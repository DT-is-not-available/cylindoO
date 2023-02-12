.localvar 2 arguments
.localvar 2157 windowToolbar 2044

:[0]
b [29]

> gml_Script_legui_create_settings_window (locals=1, argc=0)
:[1]
push.v self.windowRelatedTo
push.s "settings"@2613
cmp.s.v EQ
bf [3]

:[2]
call.i gml_Script_legui_destroy_window(argc=0)
popz.v
exit.i

:[3]
push.s "Level settings"@2614
conv.s.v
call.i gml_Script_legui_create_basic_window(argc=1)
popz.v
push.s "settings"@2613
pop.v.s self.windowRelatedTo
pushi.e 2
conv.i.v
pushi.e 0
conv.i.v
pushi.e 2
conv.i.v
b [5]

> gml_Script_anon_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows_338_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows (locals=0, argc=1)
:[4]
push.v arg.argument0
pop.v.v 85.startingGravity
exit.i

:[5]
push.i gml_Script_anon_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows_338_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows
conv.i.v
pushi.e -1
conv.i.v
call.i method(argc=2)
b [8]

> gml_Script_anon_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows_282_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows (locals=0, argc=0)
:[6]
push.v 85.startingGravity
ret.v

:[7]
exit.i

:[8]
push.i gml_Script_anon_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows_282_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows
conv.i.v
pushi.e -1
conv.i.v
call.i method(argc=2)
push.s "Starting gravity: {}"@2617
conv.s.v
call.i gml_Script_legui_add_variable_update_to_window(argc=6)
pop.v.v local.windowToolbar
push.s ""@172
conv.s.v
pushi.e -1
conv.i.v
b [10]

> gml_Script_anon_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows_574_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows (locals=0, argc=0)
:[9]
pushi.e 90
pop.v.i 85.gravity_dir
exit.i

:[10]
push.i gml_Script_anon_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows_574_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows
conv.i.v
pushi.e -1
conv.i.v
call.i method(argc=2)
pushi.e -1
conv.i.v
b [13]

> gml_Script_anon_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows_512_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows (locals=0, argc=0)
:[11]
push.v 85.gravity_dir
pushi.e 90
cmp.i.v EQ
conv.b.v
ret.v

:[12]
exit.i

:[13]
push.i gml_Script_anon_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows_512_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows
conv.i.v
pushi.e -1
conv.i.v
call.i method(argc=2)
pushi.e 16
conv.i.v
call.i gml_Script_legui_create_button(argc=6)
pushloc.v local.windowToolbar
call.i gml_Script_legui_toolbar_add_button(argc=2)
popz.v
push.s ""@172
conv.s.v
pushi.e -1
conv.i.v
b [15]

> gml_Script_anon_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows_792_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows (locals=0, argc=0)
:[14]
pushi.e 270
pop.v.i 85.gravity_dir
exit.i

:[15]
push.i gml_Script_anon_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows_792_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows
conv.i.v
pushi.e -1
conv.i.v
call.i method(argc=2)
pushi.e -1
conv.i.v
b [18]

> gml_Script_anon_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows_729_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows (locals=0, argc=0)
:[16]
push.v 85.gravity_dir
pushi.e 270
cmp.i.v EQ
conv.b.v
ret.v

:[17]
exit.i

:[18]
push.i gml_Script_anon_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows_729_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows
conv.i.v
pushi.e -1
conv.i.v
call.i method(argc=2)
pushi.e 118
conv.i.v
call.i gml_Script_legui_create_button(argc=6)
pushloc.v local.windowToolbar
call.i gml_Script_legui_toolbar_add_button(argc=2)
popz.v
pushi.e 255
conv.i.v
pushi.e 0
conv.i.v
pushi.e 5
conv.i.v
b [20]

> gml_Script_anon_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows_955_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows (locals=0, argc=1)
:[19]
push.v arg.argument0
pop.v.v 85.levelColors
exit.i

:[20]
push.i gml_Script_anon_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows_955_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows
conv.i.v
pushi.e -1
conv.i.v
call.i method(argc=2)
b [23]

> gml_Script_anon_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows_903_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows (locals=0, argc=0)
:[21]
push.v 85.levelColors
ret.v

:[22]
exit.i

:[23]
push.i gml_Script_anon_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows_903_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows
conv.i.v
pushi.e -1
conv.i.v
call.i method(argc=2)
push.s "COLOR{}"@2624
conv.s.v
call.i gml_Script_legui_add_variable_update_to_window(argc=6)
popz.v
pushi.e 8
conv.i.v
pushi.e 1
conv.i.v
pushi.e 3
conv.i.v
b [25]

> gml_Script_anon_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows_1151_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows (locals=0, argc=1)
:[24]
push.v arg.argument0
pop.v.v 85.totalCircles
exit.i

:[25]
push.i gml_Script_anon_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows_1151_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows
conv.i.v
pushi.e -1
conv.i.v
call.i method(argc=2)
b [28]

> gml_Script_anon_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows_1098_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows (locals=0, argc=0)
:[26]
push.v 85.totalCircles
ret.v

:[27]
exit.i

:[28]
push.i gml_Script_anon_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows_1098_legui_create_settings_window_gml_GlobalScript_legui_create_settings_windows
conv.i.v
pushi.e -1
conv.i.v
call.i method(argc=2)
push.s "Level parts: {}"@2627
conv.s.v
call.i gml_Script_legui_add_variable_update_to_window(argc=6)
popz.v
call.i gml_Script_legui_finish_basic_window(argc=0)
popz.v
exit.i

:[29]
push.i gml_Script_legui_create_settings_window
conv.i.v
pushi.e -1
conv.i.v
call.i method(argc=2)
dup.v 0
pushi.e -6
pop.v.v [stacktop]self.legui_create_settings_window
popz.v

:[end]