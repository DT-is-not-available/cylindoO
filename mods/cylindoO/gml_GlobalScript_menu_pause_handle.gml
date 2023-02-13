function menu_pause_handle(argument0) //gml_Script_menu_pause_handle
{
	var main = argument0
	switch main
	{
		case 0:
			global.ispaused = 0
			physics_pause_enable(false)
			instance_destroy()
			break
		case 1:
			global.ispaused = 0
			physics_pause_enable(false)
			sponsored_call_level_restart(global.leveltoload)
			analytics_fire("level_restart", string(global.leveltoload))
			instance_create(0, 0, obj_createlevel)
			break
		case 2:
			global.level_timer_setting = ((global.level_timer_setting + 1) % 3)
			file_open_save()
			ini_write_real("Settings", "Timer", global.level_timer_setting)
			ini_close()
			if (global.level_timer_setting == 2)
				menutext[2] = "Level#Timer:#Auto"
			else if (global.level_timer_setting == 1)
				menutext[2] = "Level#Timer:#Always"
			else
				menutext[2] = "Level#Timer:#Disabled"
			break
			menu_ingame_go_back()
		case 3:
			global.ispaused = 0
			physics_pause_enable(false)
			if global.quitOnExit
				game_end()
			else
				menu_ingame_go_back()
			break
	}

	return;
}