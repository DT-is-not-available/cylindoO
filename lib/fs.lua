function exists(filepa)
	local file = table.concat(filepa:split("/"), "\\")
	local ok, err, code = os.rename(file, file)
	if not ok then
	if code == 13 then
		-- Permission denied, but it exists
		return true
	end
	end
	return ok, err
end

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

function getdir(directory)
    local t, popen = {}, io.popen
    local pfile = popen('dir /b /ad "'..directory..'"')
    for filename in pfile:lines() do
        t[#t+1] = filename
    end
    pfile:close()
    return t
end

return {
	exists=exists,
	read=readFile,
	write=writeFile,
	size=fileSize,
	getdir=getdir
}