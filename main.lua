maincol = {0.5, 0, 0}
backcol = {0.9, 0.4, 0.4}

require("xml")

print (love.filesystem.getSourceBaseDirectory())

function readFile(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    f:close()
    return content
end

function writeFile(file, data)
    local f = assert(io.open(file, "w"))
	f:write(data)
    f:close()
end

function fileSize(file)
	local f = assert(io.open(file, "r"))
	local size = f:seek("end")
	f:close()
	return size
end

function HSV(h, s, v)
    if s <= 0 then return v,v,v end
    h = h*6
    local c = v*s
    local x = (1-math.abs((h%2)-1))*c
    local m,r,g,b = (v-c), 0, 0, 0
    if h < 1 then
        r, g, b = c, x, 0
    elseif h < 2 then
        r, g, b = x, c, 0
    elseif h < 3 then
        r, g, b = 0, c, x
    elseif h < 4 then
        r, g, b = 0, x, c
    elseif h < 5 then
        r, g, b = x, 0, c
    else
        r, g, b = c, 0, x
    end
    return r+m, g+m, b+m
end

function setCols(r, g, b)
	maincol = {r/2, g/2, b/2}
	backcol = {r/2+0.4, g/2+0.4, b/2+0.4}
end

math.randomseed(love.timer.getTime( ))

setCols(HSV(math.random(), 1, 1))

elements = {}
elements.window = {
	draw = function(self)
		love.graphics.push()
		if self.xarg.padding then
			love.graphics.translate(tonumber(self.xarg.padding), tonumber(self.xarg.padding))
		end
		for index, value in ipairs(self) do
			elements[value.label].draw(value)
			love.graphics.translate(0, elements[value.label]:getHeight())
		end
		love.graphics.pop()
	end,
	getHeight = function(self)
		return love.graphics:getHeight()
	end,
	getWidth = function(self)
		return love.graphics:getWidth()
	end,
}
elements.title = {
	draw = function(self)
		love.graphics.setFont(font(48))
		love.graphics.print(self[1], 0, 0)
	end,
	getHeight = function(self)
		return font(48):getHeight()*select(2, string.gsub(self[1], "\n", "string"))
	end,
	getWidth = function(self)
		return font(48):getWidth()
	end,
}
elements.label = {
	draw = function(self)
		love.graphics.setFont(font(16))
		love.graphics.print(self[1], 0, 0)
	end,
	getHeight = function(self)
		return font(16):getHeight()
	end,
	getWidth = function(self)
		return font(16):getWidth()
	end,
}

menu = {}

function forcepaint()
	love.graphics.clear(love.graphics.getBackgroundColor())
	love.draw()
	love.graphics.present()
end

menu.main = {
	{
		x = 125, y = 300, r = 74,
		text = "Play!",
		click = function (self)
			buttons = menu.compiling
			forcepaint()
			print("Compiling Mods...\nThe window may show that it is not responding during this process.")
			os.remove("./data.win")
			os.execute("compile.bat")
			--[[]
			print("Applying file size fix")
			local data = readFile('./data.win')
			data = string.sub(data, 1, 4)..love.data.pack("string", "<I4", fileSize("./data.win"))..string.sub(data, 9)
			writeFile('./data.win', data)
			--[[]]
			print("Launching... "..love.filesystem.getSourceBaseDirectory()..'/data.win')
			os.execute('start "" "C:\\Program Files (x86)\\Steam\\steamapps\\common\\circloO\\circloo2.exe" -game "'..love.filesystem.getSourceBaseDirectory()..'\\data.win"')
			buttons = menu.launched
		end
	},
	{
		x = 308, y = 300, r = 74,
		text = "Mods",
		click = function (self)
			buttons = menu.mods
		end
	},
	{
		x = 492, y = 300, r = 74,
		text = "Settings",
		disabled = true,
		click = function (self)
			buttons = menu.settings
		end
	},
	{
		x = 675, y = 300, r = 74,
		text = "Exit",
		click = function (self)
			love.event.quit()
		end
	},
	{
		x = 400, y = 50, r = 48,
		text = "cylindoO Mod Loader",
	},
	{
		x = 400, y = 85.5, r = 20,
		text = "A tool by DT.",
	},
}

menu.mods = {
	{
		x = 150, y = 300, r = 100,
		text = "Browse",
		disabled = true,
		click = function (self)
			
		end
	},
	{
		x = 400, y = 300, r = 100,
		text = "Manage",
		disabled = true,
		click = function (self)
			
		end
	},
	{
		x = 650, y = 300, r = 100,
		text = "Create",
		disabled = true,
		click = function (self)

		end
	},
	{
		x = 40, y = 40, r = 25,
		text = "<",
		click = function (self)
			buttons = menu.main
		end
	},
	{
		x = 400, y = 50, r = 48,
		text = "Mods",
	},
	{
		x = 400, y = 85.5, r = 20,
		text = "Download, manage, and create mods.",
	},
}

menu.compiling = {
	{
		x = 400, y = 200, r = 48,
		text = "Compiling...",
	},
	{
		x = 400, y = 260.5, r = 16,
		text = "This may take a while. Do not panic if the window appears as \"Not Responding.\"",
	},
}

menu.launched = {
	{
		x = 400, y = 200, r = 48,
		text = "Game Launched",
	}, 
	{
		x = 275, y = 350, r = 74,
		text = "Back",
		click = function (self)
			buttons = menu.main
		end
	},
	{
		x = 525, y = 350, r = 74,
		text = "Exit",
		click = function (self)
			love.event.quit()
		end
	},
	{
		x = 40, y = 40, r = 25,
		text = "<",
		click = function (self)
			buttons = menu.main
		end
	},
}

menu.settings = xml [[
	<window padding="10">
		<title>Hello world!</title>
		<label>This is a paragraph lmao</label>
	</window>
]]

buttons = menu.main

fonts = {}

function font(size)
	if fonts["S_"..size] == nil then
		fonts["S_"..size] = love.graphics.newFont(size)
	end
	return fonts["S_"..size]
end

function love.draw()
	love.graphics.setBackgroundColor(maincol)
	love.graphics.setLineWidth(2)
	if buttons.xml_top then
		for index, value in ipairs(buttons) do
			elements[value.label].draw(value)
		end
	else
		for index, value in ipairs(buttons) do
			local fo
			if value.click then
				fo = font(value.r/3)
				
				if distanceFrom(love.mouse.getX(), love.mouse.getY(), value.x, value.y) < value.r and not value.disabled then
					love.graphics.setColor(1,1,1)
				else
					love.graphics.setColor(backcol)
				end
				love.graphics.circle("line", value.x, value.y, value.r, 100)
				if not value.disabled then 
					love.graphics.circle("fill", value.x, value.y, value.r)
					love.graphics.setColor(maincol)
				end
			else
				fo = font(value.r)
				love.graphics.setColor(backcol)
			end
			love.graphics.setFont(fo)
			if (value.text == "<") then
				love.graphics.polygon("fill",
					value.x-value.r*0.75, value.y,
					value.x+value.r*0.5, value.y+value.r*0.65,
					value.x+value.r*0.5, value.y-value.r*0.65
				)
				love.graphics.polygon("line",
					value.x-value.r*0.75, value.y,
					value.x+value.r*0.5, value.y+value.r*0.65,
					value.x+value.r*0.5, value.y-value.r*0.65
				)
			end
			love.graphics.print(value.text, value.x-fo:getWidth(value.text)/2, value.y-fo:getHeight()/2)
		end	
	end
end

function love.update()

end

function distanceFrom(x1,y1,x2,y2) return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2) end

function love.mousepressed()
	for index, value in ipairs(buttons) do
		if distanceFrom(love.mouse.getX(), love.mouse.getY(), value.x, value.y) < value.r then
			value:click()
		end
	end
end