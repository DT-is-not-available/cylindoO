local function exists(filepa)
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

local function readFile(file)
	local f = assert(io.open(file, "rb"))
	local content = f:read("*all")
	f:close()
	return content
end

local function writeFile(file, data)
	local f = assert(io.open(file, "w"))
	f:write(data)
	f:close()
end

local function fileSize(file)
	local f = assert(io.open(file, "r"))
	local size = f:seek("end")
	f:close()
	return size
end

local function getdir(directory)
	local t, popen = {}, io.popen
	local pfile = popen('dir /b /ad "'..directory..'"')
	for filename in pfile:lines() do
		t[#t+1] = filename
	end
	pfile:close()
	return t
end

local function pack(tbl)
	local data = ""
	for key, value in pairs(tbl) do
		data = data..love.data.pack('string', ">zI[2]", key, value)
	end
	return data
end

local function unpack(data)
	local tbl = {}
	local index = 1
	local key, value
	while index < #data do
		key, value, index = love.data.unpack(">zI[2]", data, index)
	end
	return tbl
end

return {
	exists=exists,
	read=readFile,
	write=writeFile,
	size=fileSize,
	getdir=getdir,
	pack=pack,
	unpack=unpack,
}