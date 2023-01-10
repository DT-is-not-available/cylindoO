function parseargs(s)
	local arg = {}
	string.gsub(s, "([%-%w]+)=([\"'])(.-)%2", function (w, _, a)
		arg[w] = a
		return ""
	end)
	string.gsub(s, "([%-%w]+)=([%-%w%.]+)", function (w, a)
		arg[w] = a
		return ""
	end)
	return arg
end
		
function xml(s)
	local stack = {}
	local top = {
		xml_top = true
	}
	table.insert(stack, top)
	local ni,c,label,xarg, empty
	local i, j = 1, 1
	while true do
		ni,j,c,label,xarg, empty = string.find(s, "<(%/?)([%w:]+)(.-)(%/?)>", i)
		if not ni then break end
		local text = string.sub(s, i, ni-1)
		if not string.find(text, "^%s*$") then
			table.insert(top, text)
		end
		if empty == "/" then  -- empty element tag
			table.insert(top, {label=label, xarg=parseargs(xarg), empty=1, parent=top})
		elseif c == "" then  -- start tag
			top = {label=label, xarg=parseargs(xarg), parent=top}
			table.insert(stack, top)  -- new level
		else  -- end tag
			local toclose = table.remove(stack)  -- remove top
			top = stack[#stack]
			if #stack < 1 then
				error("nothing to close with "..label)
			end
			if toclose.label ~= label then
				error("trying to close "..toclose.label.." with "..label)
			end
			table.insert(top, toclose)
		end
		i = j+1
	end
	local text = string.sub(s, i)
	if not string.find(text, "^%s*$") then
		table.insert(stack[#stack], text)
	end
	if #stack > 1 then
		error("unclosed "..stack[#stack].label)
	end
	return stack[1]
end

function dump(o, i)
	if not i then
		i = 0
	end
	if type(o) == 'table' then
		local s = '{\n'
		for k,v in pairs(o) do
			if type(k) == 'string' then k = '"'..k..'"' end
			s = s .. string.rep("    ",i+1) ..k..' = ' .. dump(v, i+1) .. ',\n'
		end
		return s .. string.rep("    ",i) .. '}'
	else
		if type(o) == "string" then
			return '"'..tostring(o)..'"'
		else
			return tostring(o)
		end
	end
end