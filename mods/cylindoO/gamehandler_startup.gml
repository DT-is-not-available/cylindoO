if (parameter_count() > 0 && parameter_string(1) != "ignore") {
	var param = parameter_string(1)
	if (param == "getid") {
		show_message("Your device ID is "+deviceID);
		game_end()
	} else if (param == "openlevel") {

		var file = file_text_open_read("temp.sav");
		var s = "";

		while (file_text_eof(file) == false) {
			s += file_text_readln(file);
		}

		file_text_close(file);
		
		level_start_content(s, 0);
		global.startedGameInitial = 1;
	}
}