function menu_pause_init() //gml_Script_menu_pause_init
{
	menu_general_init()
	mobile_use_back_button = 0
	use_advanced_buttons = 0
	menu_show_sponsor_info = 1
	mainpos = get_correct_mainpos()
	menu_rows = 1
	mainnumber = 4
	menu_has_arrows = 0
	menutitle = "Game Paused"
	if (global.leveltoload > 0)
	{
		if (1 && instance_exists(obj_gameflowhandler) && obj_gameflowhandler.isCircloO1RightNow && global.leveltoload > 14)
			menutitle = (("Hard Mode " + string((global.leveltoload - 14))) + " - Game Paused")
		else
			menutitle = (("Level " + string(global.leveltoload)) + " - Game Paused")
	}
	menusubtitle = (((string(((obj_createbigcircle.radius / 200) - 1)) + "/") + string((obj_createbigcircle.circlemax / obj_createbigcircle.circlestep))) + " circles collected")
	escapehandler = 0
	menutext[0] = "Continue"
	menufont[0] = 10
	focusonmobile[0] = 1
	menutext[1] = "Retry Level"
	menufont[1] = 10
	focusonmobile[1] = 0
    if (global.level_timer_setting == 2)
        menutext[2] = "Level#Timer:#Auto"
    else if (global.level_timer_setting == 1)
        menutext[2] = "Level#Timer:#Always"
    else
        menutext[2] = "Level#Timer:#Disabled"
    menufont[2] = 10
	focusonmobile[2] = 0
	if obj_gameflowhandler.fromLevelEditor
		menutext[3] = "To Editor"
	else if global.quitOnExit
		menutext[3] = "Exit"
	else
		menutext[3] = "Main Menu"
	menufont[3] = 10
	focusonmobile[3] = 0
	gotoanimtype[0] = 1
	gotoanimtype[1] = 0
	gotoanimtype[2] = 1
	gotoanimtype[3] = 0
	menuhandler = gml_Script_menu_pause_handle
	return;
}