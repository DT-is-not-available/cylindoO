maincol = {0.5, 0, 0}
backcol = {0.9, 0.4, 0.4}

local http = require "socket.http"

require "lib.xml"
local JSON = require "lib.json"
local fs = require "lib.fs"

function string:split(sep)
	local sep, fields = sep or ":", {}
	local pattern = string.format("([^%s]+)", sep)
	self:gsub(pattern, function(c) fields[#fields+1] = c end)
	return fields
end

needsCompile = fs.exists(".\\data.win") == nil
ver = require("ver")

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

os.execute("mkdir umtcli")
os.execute("mkdir mods")
os.execute("mkdir patches")
os.execute("mkdir temp")

local actions = {
	menu_main = function ()
		buttons = menu.main
	end,
	menu_mods = function ()
		buttons = menu.mods
	end,
	install_umtcli = function ()
		buttons = menu.message("Downloading...", "This may take a while.")
		forcepaint()
		-- custom hosting this because it doesnt like the official github release for some reason, will change once i figure out how
		os.execute('C:\\Windows\\System32\\curl "https://dt-is-not-available.github.io/cylindoO-files/umtcli.zip" --output temp\\umtcli.zip')
		buttons = menu.message("Extracting...", "This may take a while. Please wait, even if the window shows \"Not Responding.\"")
		forcepaint()
		os.execute('C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell -command "Expand-Archive -Force \'.\\temp\\umtcli.zip\' \'.\\umtcli\'"')
		buttons = menu.message("Cleaning up...", "almost done i promise")
		forcepaint()
		os.execute 'erase temp\\umtcli.zip'
		buttons = menu.messageButtons("Done!")
	end,
	download_maincsx = function ()
		buttons = menu.message("Downloading...", "This may take a while.")
		forcepaint()
		os.execute('C:\\Windows\\System32\\curl "https://dt-is-not-available.github.io/cylindoO-files/main.csx" --output main.csx')
		buttons = menu.messageButtons("Done!")
	end,
	update_ver_no = function ()
		local d = os.date("*t", os.time())
		local newver = "1.0."..(
			(d.year - 2000)*10000 + d.month*100 + d.day + d.hour/100 + d.min/10000 + d.sec/1000000
		)
		fs.write("ver.lua", 'return "'..newver..'"')
		ver = newver.." (preview)"
		buttons = menu.settings()
	end,
	update_beta_no = function ()
		local d = os.date("*t", os.time())
		local newver = 'unstable-'..(
			(d.year - 2000)*10000 + d.month*100 + d.day + d.hour/100 + d.min/10000 + d.sec/1000000
		)
		fs.write("ver.lua", 'return "'..newver..'"')
		ver = newver.." (preview)"
		buttons = menu.settings()
	end,
	restart = function ()
		love.event.quit( "restart" )
	end,
	debug_path = function ()
		path = "./debug/"
		print (path)
		buttons = menu.main
	end,
	del_data_win = function ()
		needsCompile = true
		os.execute 'erase data.win'
		buttons = menu.main
	end
}

elements = {}
elements.x = 0
elements.y = 0
elements.window = {
	init = function(self)
		for index, value in ipairs(self) do
			if elements[value.label].init then elements[value.label].init(value) end
		end
	end,
	draw = function(self)
		if not self.xarg.spacing then
			self.xarg.spacing = "0"
		end
		love.graphics.setColor(backcol)
		love.graphics.origin()
		elements.x = 0
		elements.y = 0
		if self.xarg.padding then
			elements.x = elements.x + tonumber(self.xarg.padding)
			elements.y = elements.y + tonumber(self.xarg.padding)
			love.graphics.translate(tonumber(self.xarg.padding), tonumber(self.xarg.padding))
		end
		for index, value in ipairs(self) do
			elements[value.label].draw(value, (love.mouse.getX() > elements.x and love.mouse.getX() < elements.x + elements[value.label].getWidth(value) and
			love.mouse.getY() > elements.y and love.mouse.getY() < elements.y + elements[value.label].getHeight(value)))
			love.graphics.translate(0, elements[value.label].getHeight(value) + tonumber(self.xarg.spacing))
			elements.y = elements.y + elements[value.label].getHeight(value) + tonumber(self.xarg.spacing)
		end
		love.graphics.origin()
	end,
	click = function(self)
		elements.x = 0
		elements.y = 0
		if self.xarg.padding then
			elements.x = elements.x + tonumber(self.xarg.padding)
			elements.y = elements.y + tonumber(self.xarg.padding)
		end
		for index, value in ipairs(self) do
			if elements[value.label].click and
			love.mouse.getX() > elements.x and love.mouse.getX() < elements.x + elements[value.label].getWidth(value) and
			love.mouse.getY() > elements.y and love.mouse.getY() < elements.y + elements[value.label].getHeight(value)
			then 
				elements[value.label].click(value)
			end
			elements.y = elements.y + elements[value.label].getHeight(value) + tonumber(self.xarg.spacing)
		end
	end,
	getHeight = function(self)
		return love.graphics:getHeight()
	end,
	getWidth = function(self)
		return love.graphics:getWidth()
	end,
}
elements.panel = {
	init = function(self)
		self.height = 0
		if not self.xarg.spacing then
			self.xarg.spacing = "0"
		end
		for index, value in ipairs(self) do
			if elements[value.label].init then elements[value.label].init(value) end
			self.height = self.height + elements[value.label].getHeight(value) + tonumber(self.xarg.spacing)
		end
		elements[self.label].getHeight(self)
		if self.xarg.height and self.height < tonumber(self.xarg.height) then
			self.scroll = 0
		end
		self.scroll = 0
	end,
	draw = function(self)
		if not self.xarg.spacing then
			self.xarg.spacing = "0"
		end
		love.graphics.setColor(backcol)
		love.graphics.push()
		local x = elements.x
		local y = elements.y
		if self.xarg.padding then
			elements.x = elements.x + tonumber(self.xarg.padding)
			elements.y = elements.y + tonumber(self.xarg.padding)
			love.graphics.translate(tonumber(self.xarg.padding), tonumber(self.xarg.padding))
		end
		love.graphics.translate(0, -self.scroll)
		for index, value in ipairs(self) do
			if self.xarg.height then
				love.graphics.setScissor(0, self.scroll, 800, elements[self.label].getHeight(self))
			end
			elements[value.label].draw(value, (love.mouse.getX() > elements.x and love.mouse.getX() < elements.x + elements[value.label].getWidth(value) and
			love.mouse.getY() > elements.y and love.mouse.getY() < elements.y + elements[value.label].getHeight(value)))
			love.graphics.translate(0, elements[value.label].getHeight(value) + tonumber(self.xarg.spacing))
			elements.y = elements.y + elements[value.label].getHeight(value) + tonumber(self.xarg.spacing)
		end
		love.graphics.pop()
		elements.x = x
		elements.y = y
		if self.xarg.outline then
			love.graphics.setColor(backcol)
			love.graphics.rectangle("line", 0, 0, elements[self.label].getWidth(self), elements[self.label].getHeight(self))
		end
		love.graphics.setScissor()
	end,
	click = function(self)
		local x = elements.x
		local y = elements.y
		if self.xarg.padding then
			elements.x = elements.x + tonumber(self.xarg.padding)
			elements.y = elements.y + tonumber(self.xarg.padding)
		end
		for index, value in ipairs(self) do
			if elements[value.label].click and
			love.mouse.getX() > elements.x and love.mouse.getX() < elements.x + elements[value.label].getWidth(value) and
			love.mouse.getY() > elements.y and love.mouse.getY() < elements.y + elements[value.label].getHeight(value)
			then 
				elements[value.label].click(value)
			end
			elements.y = elements.y + elements[value.label].getHeight(value) + tonumber(self.xarg.spacing)
		end
		elements.x = x
		elements.y = y
	end,
	scrolldown = function(self)
		local x = elements.x
		local y = elements.y
		self.scroll = self.scroll - 1
		if self.xarg.padding then
			elements.x = elements.x + tonumber(self.xarg.padding)
			elements.y = elements.y + tonumber(self.xarg.padding)
		end
		for index, value in ipairs(self) do
			if elements[value.label].scrolldown and
			love.mouse.getX() > elements.x and love.mouse.getX() < elements.x + elements[value.label].getWidth(value) and
			love.mouse.getY() > elements.y and love.mouse.getY() < elements.y + elements[value.label].getHeight(value)
			then 
				elements[value.label].scrolldown(value)
			end
			elements.y = elements.y + elements[value.label].getHeight(value) + tonumber(self.xarg.spacing)
		end
		elements.x = x
		elements.y = y
	end,
	scrollup = function(self)
		local x = elements.x
		local y = elements.y
		if self.xarg.padding then
			elements.x = elements.x + tonumber(self.xarg.padding)
			elements.y = elements.y + tonumber(self.xarg.padding)
		end
		for index, value in ipairs(self) do
			if elements[value.label].scrollup and
			love.mouse.getX() > elements.x and love.mouse.getX() < elements.x + elements[value.label].getWidth(value) and
			love.mouse.getY() > elements.y and love.mouse.getY() < elements.y + elements[value.label].getHeight(value)
			then 
				elements[value.label].scrollup(value)
			end
			elements.y = elements.y + elements[value.label].getHeight(value) + tonumber(self.xarg.spacing)
		end
		elements.x = x
		elements.y = y
	end,
	getHeight = function(self)
		if self.xarg.height then
			return tonumber(self.xarg.height)+tonumber(self.xarg.padding or 0)*2
		end
		return self.height+tonumber(self.xarg.padding or 0)*2
	end,
	getWidth = function(self)
		if not self.width then
			self.width = 0
			for index, value in ipairs(self) do
				local newVal = elements[value.label].getWidth(value)
				if newVal > self.width then
					self.width = newVal
				end
			end
		end
		return self.width+tonumber(self.xarg.padding or 0)*2
	end,
}
elements.row = {
	init = function(self)
		for index, value in ipairs(self) do
			if elements[value.label].init then elements[value.label].init(value) end
		end
	end,
	draw = function(self)
		if not self.xarg.spacing then
			self.xarg.spacing = "0"
		end
		love.graphics.setColor(backcol)
		love.graphics.push()
		local x = elements.x
		local y = elements.y
		if self.xarg.padding then
			elements.x = elements.x + tonumber(self.xarg.padding)
			elements.y = elements.y + tonumber(self.xarg.padding)
			love.graphics.translate(tonumber(self.xarg.padding), tonumber(self.xarg.padding))
		end
		for index, value in ipairs(self) do
			elements[value.label].draw(value, (love.mouse.getX() > elements.x and love.mouse.getX() < elements.x + elements[value.label].getWidth(value) and
			love.mouse.getY() > elements.y and love.mouse.getY() < elements.y + elements[value.label].getHeight(value)))
			love.graphics.translate(elements[value.label].getWidth(value) + tonumber(self.xarg.spacing), 0)
			elements.x = elements.x + elements[value.label].getWidth(value) + tonumber(self.xarg.spacing)
		end
		love.graphics.pop()
		elements.x = x
		elements.y = y
	end,
	click = function(self)
		local x = elements.x
		local y = elements.y
		if self.xarg.padding then
			elements.x = elements.x + tonumber(self.xarg.padding)
			elements.y = elements.y + tonumber(self.xarg.padding)
		end
		for index, value in ipairs(self) do
			if elements[value.label].click and
			love.mouse.getX() > elements.x and love.mouse.getX() < elements.x + elements[value.label].getWidth(value) and
			love.mouse.getY() > elements.y and love.mouse.getY() < elements.y + elements[value.label].getHeight(value)
			then 
				elements[value.label].click(value)
			end
			elements.x = elements.x + elements[value.label].getWidth(value) + tonumber(self.xarg.spacing)
		end
		elements.x = x
		elements.y = y
	end,
	getHeight = function(self)
		if not self.height then
			self.height = 0
			for index, value in ipairs(self) do
				local newVal = elements[value.label].getHeight(value)
				if newVal > self.height then
					self.height = newVal
				end
			end
		end
		return self.height + tonumber(self.xarg.padding or 0)*2
	end,
	getWidth = function(self)
		if not self.width then
			self.width = 0
			for index, value in ipairs(self) do
				self.width = self.width + elements[value.label].getWidth(value) + tonumber(self.xarg.spacing or 0) + tonumber(self.xarg.padding or 0)*2
			end
		end
		return self.width
	end,
}
elements.title = {
	draw = function(self)
		love.graphics.setColor(backcol)
		love.graphics.setFont(font(48))
		love.graphics.print(self[1], 0, 0)
	end,
	getHeight = function(self)
		return font(48):getHeight()*(select(2, string.gsub(self[1], "\n", "string"))+1)
	end,
	getWidth = function(self)
		return font(48):getWidth(self[1])
	end,
}
elements.label = {
	init = function(self)
		if not self.xarg.size then
			self.xarg.size = "16"
		end
		if self.xarg.wrap then
			self[1] = table.concat(select(2, font(tonumber(self.xarg.size)):getWrap(self[1], tonumber(self.xarg.wrap))),"\n")
		end
	end,
	draw = function(self)
		love.graphics.setColor(backcol)
		love.graphics.setFont(font(tonumber(self.xarg.size)))
		love.graphics.print(self[1], 0, 0)
	end,
	getHeight = function(self)
		return font(tonumber(self.xarg.size)):getHeight()*(select(2, string.gsub(self[1], "\n", "string"))+1)
	end,
	getWidth = function(self)
		if self.xarg.wrap then
			return tonumber(self.xarg.wrap)
		end
		return font(tonumber(self.xarg.size)):getWidth(self[1])
	end,
}
elements.button = {
	draw = function(self, hover)
		love.graphics.setColor(backcol)
		if not self.xarg.padding then
			self.xarg.padding = "0"
		end
		love.graphics.setFont(font(16))
		if not self.xarg.disabled then
			if hover then
				love.graphics.setColor(1,1,1)
			end
			love.graphics.rectangle("fill", 0, 0, elements.button.getWidth(self), elements.button.getHeight(self), 10, 10)
		end
		love.graphics.rectangle("line", 0, 0, elements.button.getWidth(self), elements.button.getHeight(self), 10, 10)
		if not self.xarg.disabled then love.graphics.setColor(maincol) end
		love.graphics.print(self[1], tonumber(self.xarg.padding)+5, tonumber(self.xarg.padding))
	end,
	getHeight = function(self)
		return font(16):getHeight()*(select(2, string.gsub(self[1], "\n", "string"))+1) + tonumber(self.xarg.padding)*2
	end,
	getWidth = function(self)
		return font(16):getWidth(self[1]) + tonumber(self.xarg.padding)*2+10
	end,
	click = function(self)
		if self.xarg.id then
			actions[self.xarg.id]()
		end
	end
}

menu = {}

function forcepaint()
	love.graphics.clear(love.graphics.getBackgroundColor())
	love.draw()
	love.graphics.present()
end

path = "C:\\Program Files (x86)\\Steam\\steamapps\\common\\circloO\\"

function compile()
	if (not fs.exists(path)) then
		buttons = menu.messageButtons("Error Launching")
		forcepaint()
		love.window.showMessageBox("No installation", "It does not appear that you have circloO instaled. Please install it on Steam before attempting to use this tool.", "error")
		return
	end
	local ret = 0
	if needsCompile then
		buttons = menu.compiling
		forcepaint()
		print("Compiling Mods...\nThe window may show that it is not responding during this process.")
		os.remove("./data.win")
		print("Verifying existance of compiler tools...")
		if not fs.exists(".\\umtcli\\UndertaleModCLI.exe") then
			buttons = menu.messageButtons("Error Launching")
			forcepaint()
			love.window.showMessageBox("UndertaleModCLI missing", "Please install UndertaleModCLI from the settings to continue.", "error")
			buttons = menu.settings()
			return
		end
		if not fs.exists(".\\main.csx") then
			buttons = menu.messageButtons("Error Launching")
			forcepaint()
			love.window.showMessageBox("main.csx missing", "Please redownload cylindoO to continue.", "error")
			buttons = menu.settings()
			return
		end
		ret = select(-1, os.execute('umtcli\\UndertaleModCLI.exe load "'..path..'data.win" -s "main.csx" -o "data.win"'))
	end
	--[[]
	print("Applying file size fix")
	local data = readFile('./data.win')
	data = string.sub(data, 1, 4)..love.data.pack("string", "<I4", fileSize("./data.win"))..string.sub(data, 9)
	writeFile('./data.win', data)
	--[[]]
	if ret == 0 then
		print("Launching... ./data.win")
		-- love.window.close()
		buttons = menu.launched
		needsCompile = false
		os.execute('start "" "'..path..'circloo2.exe" -game "data.win"')
	else
		buttons = menu.messageButtons("Error Launching")
		forcepaint()
		love.window.showMessageBox("Compile Error", "Something went wrong while compiling, please try again.", "error")
	end
end

menu.main = {
	{
		x = 125, y = 300, r = 74,
		text = "Play!",
		click = function (self) 
			compile()
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
		click = function (self)
			buttons = menu.settings()
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
	{
		x = 400, y = 475, r = 10,
		text = ver,
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
			buttons = menu.modlist(getMods()) --[[ {
				{
					name = "Installed Mod Name",
					description = "This is the description of a mod that has been installed. It is long enough to where it would have to wrap multiple lines if the time came, but that isn't implemented as of right now.",
					id = "modid",
					type = 1,
				},
				{
					name = "Online Mod Name",
					description = "This mod has not been installed yet.",
					id = "modid",
					type = 2,
				},
				{
					name = "Built-in Mod",
					description = "This mod cannot be removed because its built-in to the mod loader, either as a required dependancy, or as the mod api itself.",
					id = "modid",
					type = 3,
				},
			} ]] 
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

menu.message = function(title, text)
	return {
		{
			x = 400, y = 200, r = 48,
			text = title,
		},
		{
			x = 400, y = 260.5, r = 16,
			text = text,
		},
	}
end

menu.messageButtons = function(title)
	return {
		{
			x = 400, y = 200, r = 48,
			text = title,
		}, 
		{
			x = 275, y = 350, r = 74,
			text = "Launch",
			click = function()
				needsCompile = true
				compile()
			end
		},
		{
			x = 525, y = 350, r = 74,
			text = "Back",
			click = function (self)
				buttons = menu.main
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
end

menu.launched = {
	{
		x = 400, y = 200, r = 48,
		text = "Game Launched",
	}, 
	{
		x = 275, y = 350, r = 74,
		text = "Recompile",
		click = function()
			needsCompile = true
			compile()
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

menu.settings = function() return xml([[

<window padding="15" spacing=24>
	<row spacing="10">
		<button padding="10" id="menu_main">Back</button>
		<label size=32>Settings</label>
	</row>
	<label>There are currently no settings available to change.</label>
	<label size=24>Repair Options</label>
	<label>If you get a missing file error please press one of the buttons below.</label>
	<row spacing="10">
		<button padding="10" id="install_umtcli">Repair UndertaleModCLI</button>
		<button padding="10" id="download_maincsx">Repair main.csx</button>
	</row>
	<label size=24>Development/Experimental Options</label>
	<label>Current build: ]]..ver..'\n'..[[
These options are used in development, or are extremely experimental:</label>
	<row spacing="10">
		<button padding="10" id="update_ver_no">Build ID</button>
		<button padding="10" id="update_beta_no">Unstable ID</button>
		<button padding="10" id="restart">Restart</button>
		<button padding="10" id="debug_path">Debug Game Path</button>
		<button padding="10" id="del_data_win">Delete compiled data.win</button>
	</row>
</window>

]]) end

menu.modlist = function(list) 
	local ret = [[
<window padding="15" spacing=24>
	<row spacing="10">
		<button padding="10" id="menu_mods">Back</button>
		<label size=32>Mods</label>
	</row>
	<panel spacing=24 height=450>
]]
	for index, value in ipairs(list) do
		ret = ret..[[
			<panel outline=1 padding=10 spacing=5>
				<label size=24>]]..value.name..[[</label>
				<label wrap=750>]]..value.description..[[</label>
				]]..({
					[[
						<row spacing="20">
							<button padding="2" id="mod_uninstall" modid="]]..value.id..[[">Uninstall</button>
							<button padding="2" id="mod_info" modid="]]..value.id..[[">More Info</button>
						</row>
					]],
					[[
						<row spacing="20">
							<button padding="2" id="mod_install" modid="]]..value.id..[[">Install</button>
							<button padding="2" id="mod_info" modid="]]..value.id..[[">More Info</button>
						</row>
					]],
					[[
						<row spacing="20">
							<button padding="2" id="mod_info" modid="]]..value.id..[[">More Info</button>
						</row>
					]],
				})[value.type]..[[
			</panel>
		]]
	end
	ret = ret.."</panel></window>"
	return xml(ret)
end

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
		if not buttons.xml_init then
			for index, value in ipairs(buttons) do
				if elements[value.label].init then elements[value.label].init(value) end
			end
			buttons.xml_init = true
		end
		for index, value in ipairs(buttons) do
			love.graphics.setColor(backcol)
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
	if buttons.xml_top then
		for index, value in ipairs(buttons) do
			if elements[value.label].click then elements[value.label].click(value) end
		end
	else
		for index, value in ipairs(buttons) do
			if distanceFrom(love.mouse.getX(), love.mouse.getY(), value.x, value.y) < value.r then
				value:click()
			end
		end
	end
end

function love.wheelmoved(x, y)
	if buttons.xml_top then
		for index, value in ipairs(buttons) do
			if elements[value.label].scrolldown and y < 0 then elements[value.label].scrolldown(value) end
			if elements[value.label].scrollup and y > 0 then elements[value.label].scrollup(value) end
		end
	end
end

function getMods()
	local arr = fs.getdir("mods")
	local modlist = {}
	for index, value in ipairs(arr) do
		if fs.exists("mods/"..value.."/mod.json") then
			local conf = JSON.parse(fs.read("mods/"..value.."/mod.json"))
			modlist[#modlist+1] = {
				type = (not conf["internal@builtin"]) and 1 or 3,
				id = value,
				name = conf.Name,
				description = conf.Description
			}
		end
	end
	return modlist
end