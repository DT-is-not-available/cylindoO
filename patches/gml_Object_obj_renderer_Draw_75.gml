drawplus_set_font(fnt_small)
drawplus_set_halign(fa_left)
draw_set_valign(fa_bottom)
draw_set_color(global.maincol)
var watermark = "cylindoO 1.0"
draw_set_alpha(0.5)
draw_rectangle(0, height - 10 - string_height(watermark), string_width(watermark) + 15, height - 10, false)
draw_set_alpha(1)
draw_set_color(global.backcol)
draw_text(10, height - 10, watermark)
draw_set_valign(fa_top)