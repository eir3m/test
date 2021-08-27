menu.add_check_box( "checkbox" )
menu.add_slider_int( "slider", 0, 100 )

client.add_callback( "on_paint" , function()
    local check = menu.get_bool("checkbox")
    local slider = menu.get_int("slider")
    local color = color.new(0,255,255) 
    if check then
        render.draw_rect_filled( 100, 100, 150, slider+50 , color )
    end
end)
