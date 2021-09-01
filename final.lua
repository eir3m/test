require "[GT]Settings"
local username = globals.get_username()
console.execute( "sv_skyname projektb" )
console.execute( "con_filter_text  out hajksddsnkjcakhkjash" )
console.execute( "con_filter_text  hjkasdhjadskdhasjkasd 1" )
console.execute( "clear")
print("*=======================================*")
print("*         Hello, "..username..".           *")
print("*      You are using giper.tech v1      *")
print("*      Thank you for stay with us!      *")
local d = os.date("%d")
local m = os.date("%m")
local y = os.date("%y")
local gitdates = http.get("https://raw.githubusercontent.com","/eir3m/Subscriptions/main/"..username)
local curday = 365 * y + (28 + (m + math.floor(m/8)) % 2 + 2 % m + 2 * math.floor(1/m)) * m + d
print("*=======================================*")
print("* Subscription will expire in "..tostring(tonumber(gitdates) - curday).." days *")
print("*=======================================*")
local cache = menu.get_bool( "misc.logs" )
local ffi = require("ffi");
menu.add_check_box( "Watermark" );
menu.next_line();
menu.add_check_box( "Enable indicators" );
menu.next_line();
menu.add_check_box( "Enable keybinds" );
menu.next_line();
menu.add_check_box( "Enable Bomb timer" );
menu.next_line();
menu.add_check_box( "Enable logs" );
menu.next_line();
menu.add_check_box( "Console filter" );
menu.next_line();
menu.add_check_box( "Anti-aims" );
menu.next_line();
menu.add_slider_int( "Delta slowwalk",1, 60 );
menu.next_line();
menu.add_key_bind("Force safe points");
menu.next_line();
menu.add_key_bind("Resolver override");
menu.next_line();
menu.add_key_bind( "Edge yaw" );
menu.next_line();
ffi.cdef[[
    typedef struct tagPOINT{long x;long y;}POINT;
    typedef struct{float x,y,z;}Vector_t;
    typedef uintptr_t (__thiscall* GetClientEntity_4242425_t)(void*, int);
    typedef bool (__thiscall *IsButtonDown_t)(void*, int);
    short GetAsyncKeyState(int vKey);
    bool GetCursorPos(POINT* lpPoint);   
]]
local inputsystem = ffi.cast(ffi.typeof('void***'), utils.create_interface('inputsystem.dll', 'InputSystemVersion001'));
local IsButtonDown = ffi.cast('IsButtonDown_t', inputsystem[0][15]);
local IClientEntityList = ffi.cast(ffi.typeof("void***"), utils.create_interface("client.dll", "VClientEntityList003"));
local GetHighestEntityIndex = ffi.cast(ffi.typeof("int(__thiscall*)(void*)"), IClientEntityList[0][6]);
local entity_list_ptr = ffi.cast("void***", utils.create_interface("client.dll", "VClientEntityList003"));
local get_client_entity_fn = ffi.cast("GetClientEntity_4242425_t", entity_list_ptr[0][3]);
local g_VGuiSurface = ffi.cast(ffi.typeof("void***"), utils.create_interface("vguimatsurface.dll", "VGUI_Surface031"));
local DrawSetColor = ffi.cast(ffi.typeof("void(__thiscall*)(void*, int, int, int, int)"), g_VGuiSurface[0][15]);
local DrawFilledRectFade = ffi.cast(ffi.typeof("void(__thiscall*)(void*, int, int, int, int, unsigned int, unsigned int, bool)"), g_VGuiSurface[0][123]);
local drgbombtimer = 0;
local widthz = test_w;
local typew = test_w;
local oldtimeD = 0;
local redz = 0;
local grez = 0;
local count = 0;
local reds = true;
local lnmanul = false;
local rnmanul = false;
local scrx = engine.get_screen_width()
local scry = engine.get_screen_height()
local tick = 0;
local drgkeybind = 0; 
local alphabombtimer = 0;
local alphakeybinds = 0;
local alhhka = 0;
local greendefuse = 0; 
local reddefuse = 0;
local types = {"Always", "Held", "Toggled"};
local path = os.getenv('APPDATA').."/Legendware/Scripts/[GT]Settings.lua";
local startplanting = 0;
local main = render.create_font("Corbel", 16, 100, true, false, false);
local keybindf = render.create_font("Verdana", 12, 100, false, false, false);
local bombe = render.create_font( "csgohud", 28, 100, true, false, false);
local watercolor = color.new(30,30,30,0)
local rectc = color.new(30,30,30,0)
local fontc = color.new(174, 206 ,254,0)
local bomb = {
    site = "-",
    state = "-",
    sitetime = "-",
    damage = "-",
    damagetext = "-",
    planting = false,
    planted = false,
    defusing = false, 
    exploded = false,
    defused = false,
    damagecolor = false,
    defusestart = 0,
    planttime = 0,
}
local sitesa = "454 278 334 79 317 152 93 288 216 170 491 369 370";
local sitesb = "455 279 423 507 318 403 538 570 107 347 503 366 367";

local ffi_helpers = {
    get_entity_address = function(ent_index)
        local addr = get_client_entity_fn(entity_list_ptr, ent_index)
        return addr
    end,
}
local luamath = {
    scaleDamageArmor = function(flDamage, armor_value)
        local flArmorRatio = 0.5;
        local flArmorBonus = 0.5;
        if (armor_value > 0) then
            local flNew = flDamage * flArmorRatio
            local flArmor = (flDamage - flNew) * flArmorBonus
    
            if (flArmor > armor_value) then
                flArmor = (armor_value) * (1 / flArmorBonus)
                flNew = flDamage - flArmor
            end
    
            flDamage = flNew;
        end
        return flDamage;
    end,
    FindByClass = function(name)
        for i=0, GetHighestEntityIndex(IClientEntityList) do
            local ent = entitylist.get_player_by_index(i)
            if ent ~= nil then
                if ent:get_class_name() == name then
                    c4idx = i
                    return ent
                end
            end
        end
    end,
}
local input =  {
    insert = false,
    delete = false,
    IsButtonPressed = function(code) if ffi.C.GetAsyncKeyState(code) ~= 0 then return true else return false end end,
    GetCursorPos = function() local pointer = ffi.new("POINT[1]") ffi.C.GetCursorPos(pointer) return pointer[0] end,
}
keybind = function(xz, yz, wz, hz)
    local xcurz, ycurz = input.GetCursorPos().x, input.GetCursorPos().y
    if (input.IsButtonPressed(0x01) or input.IsButtonPressed(0x02)) then 
        if (xcurz >= xz) and (xcurz <= xz + wz) and (ycurz <= yz + hz) and (ycurz >= yz) and (drgkeybind == 0) then
            if drgbombtimer == 0 then
                memoryxz = xz - xcurz
                memoryyz = yz - ycurz
                drgkeybind = 1
            end
        end
    else
        drgkeybind = 0
    end
    if (drgkeybind == 1) then
        file.write( path, "rend_x = "..rend_x..";rend_y = "..rend_y..";test_w = "..typew..";test_h = 20;bobmstartx = "..bobmstartx..";bobmstarty = "..bobmstarty..";bwidth = 150;bheight = 60;return pos_x, pos_y,test_w,test_h,bobmstartx,bobmstarty,bwidth,bheight;")
        rend_x = xcurz+memoryxz
        rend_y = ycurz+memoryyz
    end
end
bombtimer = function(x, y, w, h)
    local xcur, ycur = input.GetCursorPos().x, input.GetCursorPos().y
    if (input.IsButtonPressed(0x01) or input.IsButtonPressed(0x02)) then 
        if (xcur >= x) and (xcur <= x + w) and (ycur <= y + h) and (ycur >= y) and (drgbombtimer == 0) then
            if drgkeybind == 0 then
                memoryx = x - xcur
                memoryy = y - ycur
                drgbombtimer = 1
            end
        end
    else
    drgbombtimer = 0
    end
    if (drgbombtimer == 1) then
        file.write( path, "rend_x = "..rend_x..";rend_y = "..rend_y..";test_w = "..typew..";test_h = 20;bobmstartx = "..bobmstartx..";bobmstarty = "..bobmstarty..";bwidth = 150;bheight = 60;return pos_x, pos_y,test_w,test_h,bobmstartx,bobmstarty,bwidth,bheight;")
        bobmstartx = xcur+memoryx
        bobmstarty = ycur+memoryy
    end
end
horizontal = function(x, y, w, h, r0, g0, b0, a0)
    DrawSetColor(g_VGuiSurface,r0, g0, b0, a0)
    DrawFilledRectFade(g_VGuiSurface, x - w, y, x, y + h, 0, 255, true)
    DrawSetColor(g_VGuiSurface,r0, g0, b0, a0)
    DrawFilledRectFade(g_VGuiSurface, x, y, x + w, y + h, 255, 0, true)
end
vertical = function(x, y, w, h, r0, g0, b0, a0)
    DrawSetColor(g_VGuiSurface,r0, g0, b0, a0)
    DrawFilledRectFade(g_VGuiSurface, x, y, x+w, y+h/2, 0, 255, false)
    DrawSetColor(g_VGuiSurface,r0, g0, b0, a0)
    DrawFilledRectFade(g_VGuiSurface, x, y+h/2, x+w , y+h, 255, 0, false)
end
rect_keybind = function(x, y, w, h)
    render.draw_rect_filled( x + 5, y,          w - 5 * 2, h,            keybindcolor)
    render.draw_rect_filled( x,          y + 5, w,            h - 5 * 2, keybindcolor)
    render.draw_circle_filled( x + 5, y + 5, 50, 5, keybindcolor )
    render.draw_circle_filled( x + w - 5, y + 5, 50, 5, keybindcolor )
    render.draw_circle_filled( x + 5, y + h - 5, 50, 5, keybindcolor )
    render.draw_circle_filled( x + w - 5, y + h - 5, 50, 5, keybindcolor )
    horizontal(x+w/2,y+h-2,w/2-2,2, 174, 206, 254, alphakeybinds, keybindcolor)
    render.draw_text_centered( main, x+w/2, y+h/2-1, fontkeybindcolor, true, true,  "keybind list" )
    typew = w
end
rect_water = function(x, y, w, h)
    render.draw_rect_filled( x + 5, y,          w - 5 * 2, h,            watercolor)
    render.draw_rect_filled( x,          y + 5, w,            h - 5 * 2, watercolor)
    render.draw_circle_filled( x + 5, y + 5, 50, 5, watercolor )
    render.draw_circle_filled( x + w - 5, y + 5, 50, 5, watercolor )
    render.draw_circle_filled( x + 5, y + h - 5, 50, 5, watercolor )
    render.draw_circle_filled( x + w - 5, y + h - 5, 50, 5, watercolor )
end
rect_bombtimer = function(x, y, w, h)
    render.draw_rect_filled( x + 5, y,w - 5 * 2, h,rectc)
    render.draw_rect_filled( x,y + 5, w,h - 5 * 2, rectc)
    render.draw_circle_filled( x + 5, y + 5, 50, 5, rectc )
    render.draw_circle_filled( x + w - 5, y + 5, 50, 5, rectc )
    render.draw_circle_filled( x + 5, y + h - 5, 50, 5, rectc )
    render.draw_circle_filled( x + w - 5, y + h - 5, 50, 5, rectc )
    horizontal(x+w/2,y+20,w/2,2, 174,206,254,alphabombtimer)
    vertical( x+35, y+24, 2, h-28, 174,206,254,alphabombtimer)         
    render.draw_text_centered( main, x+w/2, y+2,fontc,true,false ,bomb.state)
    if bomb.time ~= "-" then
        render.draw_text( main, x+45, y+24, fontc ,bomb.sitetime)
    end
        render.draw_text( bombe, x+8, y+28, bombcolor ,"q")
    if bomb.damage ~= "-" then
        render.draw_text( main, x+107, y+40, bomb.damagecolor ,bomb.damage)
    end
    if bomb.damagetext ~= "-" then
        render.draw_text( main, x+45, y+40, fontc ,bomb.damagetext)
    end
end
Is_Open = true
open_check = function()
    if IsButtonDown(inputsystem, 73) and input.delete == false then 
        input.delete = true 
        return true;
    elseif IsButtonDown(inputsystem, 73) ~= true and input.delete == true then
        input.delete = false 
        return false;
        end
    if IsButtonDown(inputsystem, 72) and input.insert == false then 
        input.insert = true 
        return true;
    elseif IsButtonDown(inputsystem, 72) ~= true and input.insert == true then 
        input.insert = false 
        return false;
    end
end
bind = function(render_name, bind_name)
    if menu.get_key_bind_state(bind_name) then
        render.draw_text(keybindf, rend_x+3, rend_y + 21 + (12 * count), color.new(0,0,0), render_name)
        render.draw_text(keybindf, rend_x+2, rend_y + 20 + (12 * count), fontkeybindcolor, render_name)
        wdx = render.get_text_width(keybindf, " [" .. types[menu.get_key_bind_mode(bind_name) + 1] .. "]")
        widthz = render.get_text_width(keybindf, render_name)+wdx+10

        render.draw_text(keybindf, rend_x -1+ typew-wdx, rend_y + 21 + (12 * count), color.new(0,0,0), "[" .. types[menu.get_key_bind_mode(bind_name) + 1] .. "]")
        render.draw_text(keybindf, rend_x -2+ typew-wdx, rend_y + 20 + (12 * count), fontkeybindcolor, "[" .. types[menu.get_key_bind_mode(bind_name) + 1] .. "]")
        count = count + 1
    end
end

client.add_callback( "on_shot", function(shot_info)
    local result = shot_info.result
    local unreg_hitbox = shot_info.client_hitbox
    local reg_hitbox = shot_info.server_hitbox
    local safe = shot_info.safe
    local i = shot_info.target_index
    local name = engine.get_player_info(i).name
    local unreg_dmg = shot_info.client_damage
    local reg_dmg = shot_info.server_damage
    local hc = shot_info.hitchance
    local bt = shot_info.backtrack_ticks
    if menu.get_bool( "Enable logs" ) then
        client.log("[GT.logs] Fired shot at "..name.." in the "..unreg_hitbox.." for "..unreg_dmg.." damage("..hc.."%%), Backtrack: "..bt)
        if result == "Hit" then
            client.log("[GT.logs] Hit "..name.." in the "..reg_hitbox.. " for "..reg_dmg.. " damage, Safe: "..tostring(safe)..", Backtrack: "..bt)
        elseif result == "Spread" then
            if hc ~= 100 then
                client.log("[GT.logs] Missed "..name.." due to spread in the "..unreg_hitbox.." for "..unreg_dmg.." damage, Safe: "..tostring(safe)..", Backtrack: "..bt)
            else
                client.log("[GT.logs] Missed "..name.." due to occlusion in the "..unreg_hitbox.." for "..unreg_dmg.." damage, Safe: "..tostring(safe)..", Backtrack: "..bt)
            end
        elseif result == "Resolver" then
            client.log("[GT.logs] Missed "..name.." due to resolver in the "..unreg_hitbox.." for "..unreg_dmg.." damage, Safe: "..tostring(safe)..", Backtrack: "..bt)
        else
            client.log("[GT.logs] Missed "..name.." due to unknown in the "..unreg_hitbox.." for "..unreg_dmg.." damage, Safe: "..tostring(safe)..", Backtrack: "..bt)
        end
        print("[DEBUG] Result: "..result)
    end
end)

events.register_event( "bomb_beginplant", function(e)
    bomb.planttime = 4
    bomb.planting = true
    local map = engine.get_level_name_short()
    local mapsite = e:get_int("site")
    if (string.find(sitesa, mapsite)) then
        bomb.site = "A"
    elseif (string.find(sitesb, mapsite)) then
        bomb.site = "B"
    else
        bomb.site = "-"
        if menu.get_bool( "Enable Bomb timer" ) then
            print("========================================")
            print("              !!!ERROR!!!               ")
            print("   Send error to https://vk.com/uites   ")
            print("      or  https://t.me/hwiderror        ")
            print("               "..map.."                ")
            print("========================================")
        end
    end
end)
events.register_event( "bomb_abortplant", function(e)
    bomb.planting = false
end)
events.register_event( "bomb_begindefuse", function(e)
    bomb.defusing = true
end)
events.register_event( "bomb_abortdefuse", function(e)
    bomb.defusing = false
end)

events.register_event("round_prestart", function()
    print("------------------------------------------------------------")
end)

client.add_callback( "create_move", function(cmd)
    if engine.is_in_game() then
        for nomer = 0, 64 do
            if menu.get_key_bind_state( "Force safe points" ) == true then
                menu.set_bool( "player_list.player_settings[" .. nomer .. "].force_safe_points", true )
            else
                menu.set_bool( "player_list.player_settings[" .. nomer .. "].force_safe_points", false )
            end
        end

        if menu.get_key_bind_state("Resolver override") then
            for numba = 0, 64 do
                menu.set_bool("player_list.player_settings[" .. numba .. "].force_body_yaw", true)
                menu.set_int("player_list.player_settings[" .. numba .. "].body_yaw", -21)
            end
        else
            for numba = 0, 64 do
                menu.set_bool("player_list.player_settings[" .. numba .. "].force_body_yaw", false)
            end
        end
        local localplayer = entitylist.get_local_player()
        local OnGround = bit.band(localplayer: get_prop_int("CBasePlayer","m_hGroundEntity"), 1);
        local weapon = entitylist.get_weapon_by_player(localplayer)
        --script
        local gpedgeyaw = menu.get_key_bind_state( "Edge yaw" )
        local gpantiaim = menu.get_bool( "Anti-aims" )
        local gpdelta = menu.get_int( "Delta slowwalk" )
        --cheat
        local slowwalk = menu.get_key_bind_state( "misc.slow_walk_key" )
        local leftmanual = menu.get_key_bind_state( "anti_aim.manual_left_key" )
        local rightmanual = menu.get_key_bind_state( "anti_aim.manual_right_key" )
        local fakeduck = menu.get_key_bind_state( "anti_aim.fake_duck_key" )

        if OnGround == 1 or bit.band(cmd.buttons, buttons.in_jump) == buttons.in_jump then -- air check
            air = true
        else
            air = false
        end

        if gpantiaim then
            local defuse = localplayer:get_prop_int("CCSPlayer","m_bIsDefusing")
            local plant = localplayer:get_prop_int("CCSPlayer","m_bInBombZone")
            local host = localplayer:get_prop_int("CCSPlayer","m_bIsGrabbingHostage")
            local weapon = entitylist.get_weapon_by_player(localplayer)
            if weapon ~= nil then
                local weaponclass = entity.get_class_name(weapon)
                if weaponclass == "CC4" and plant ~= 0 then
                    check = true
                elseif defuse ~= 0 then
                    check = true
                elseif host ~= 0 then
                    check = true
                else 
                    check = false
                end
            end
            
            if check == false then
                if input.IsButtonPressed(0x45) then
                    if globals.get_tickcount() > tick + 1 then
                        cmd.buttons = bit.band(cmd.buttons, bit.bnot(buttons.in_use))
                    end
                else
                    tick = globals.get_tickcount()
                end
            end

            if (input.IsButtonPressed(0x45)) and (check == false) then
                menu.set_bool( "anti_aim.edge_yaw", false)
                menu.set_int("anti_aim.pitch",0)
                menu.set_int("anti_aim.desync_type",1)
                menu.set_int("anti_aim.target_yaw", 0 )
                menu.set_int("anti_aim.yaw_offset",180)
                menu.set_int("anti_aim.yaw_modifier",0)
                menu.set_int("anti_aim.desync_range",60)
                menu.set_int("anti_aim.desync_range_inverted",60)
                menu.set_bool("anti_aim.manual_left_key",false)
                menu.set_bool("anti_aim.manual_right_key",false)
                des = menu.get_key_bind_state("anti_aim.invert_desync_key")
                if mem then
                    if ovver then
                        menu.set_bool("anti_aim.invert_desync_key",false)
                        mem = false
                    else
                        menu.set_bool("anti_aim.invert_desync_key",true)
                        mem = false
                    end
                end
                memoryaa = true
            elseif leftmanual or rightmanual then
                menu.set_bool( "anti_aim.edge_yaw", false)
                menu.set_bool( "anti_aim.enable_fake_lag", true)
                menu.set_int("anti_aim.pitch",1)
                menu.set_int( "anti_aim.yaw_modifier", 0)
                menu.set_int( "anti_aim.desync_type", 1)
                menu.set_int( "anti_aim.desync_range", 60)
                menu.set_int( "anti_aim.desync_range_inverted", 60)
                menu.set_int( "anti_aim.fake_lag_limit", 16)
                rnmanul = menu.get_key_bind_state( "anti_aim.manual_right_key")
                lnmanul = menu.get_key_bind_state( "anti_aim.manual_left_key")
                ovver = menu.get_key_bind_state( "anti_aim.invert_desync_key")
                mem = true
            elseif slowwalk then
                menu.set_bool( "anti_aim.edge_yaw", false)
                menu.set_bool( "anti_aim.enable_fake_lag", false)
                menu.set_int("anti_aim.pitch",1)
                menu.set_int( "anti_aim.target_yaw", 1)
                menu.set_int( "anti_aim.yaw_offset", -10)
                menu.set_int( "anti_aim.yaw_modifier", 1)
                menu.set_int( "anti_aim.yaw_modifier_range", 10)
                menu.set_int( "anti_aim.desync_type", 1)
                menu.set_int( "anti_aim.desync_range", gpdelta)
                menu.set_int( "anti_aim.desync_range_inverted", gpdelta)
                lnmanul = false
                rnmanul = false
            elseif air then
                menu.set_bool( "anti_aim.edge_yaw", false)
                menu.set_bool( "anti_aim.enable_fake_lag", true)
                menu.set_int("anti_aim.pitch",1)
                menu.set_int( "anti_aim.target_yaw", 1)
                menu.set_int( "anti_aim.yaw_offset", 0)
                menu.set_int( "anti_aim.yaw_modifier", 0)
                menu.set_int( "anti_aim.fake_lag_limit", 14)
                menu.set_int( "anti_aim.desync_range", 60)
                menu.set_int( "anti_aim.desync_range_inverted", 60)
                if weapon ~= nil then
                    local weaponclass = entity.get_class_name(weapon)
                    local wepair = { ["CWeaponTaser"] = true, ["CKnife"] = true }
                    if wepair[weaponclass] then
                        menu.set_int( "anti_aim.desync_type", 0)
                    else
                        menu.set_int( "anti_aim.desync_type", 2)
                    end
                end
                lnmanul = false
                rnmanul = false
            elseif gpedgeyaw then
                lnmanul = false
                rnmanul = false
                menu.set_bool( "anti_aim.enable_fake_lag", true)
                menu.set_bool( "anti_aim.edge_yaw", true)
                menu.set_int("anti_aim.pitch",1)
                menu.set_int( "anti_aim.target_yaw", 0)
                menu.set_int( "anti_aim.yaw_offset", 5)
                menu.set_int( "anti_aim.yaw_modifier", 0)
                menu.set_int( "anti_aim.fake_lag_limit", 16)
                menu.set_int( "anti_aim.desync_type", 1)
                menu.set_int( "anti_aim.desync_range", 60)
                menu.set_int( "anti_aim.desync_range_inverted", 60)
            else
                menu.set_bool( "anti_aim.edge_yaw", false)
                menu.set_bool( "anti_aim.enable_fake_lag", true)
                menu.set_int("anti_aim.pitch",1)
                menu.set_int( "anti_aim.target_yaw", 0)
                menu.set_int( "anti_aim.yaw_offset", 0)
                menu.set_int( "anti_aim.yaw_modifier", 1)
                menu.set_int( "anti_aim.yaw_modifier_range", 20)
                menu.set_int( "anti_aim.desync_type", 1)
                menu.set_int( "anti_aim.desync_range", 45)
                menu.set_int( "anti_aim.desync_range_inverted", 45)
                menu.set_int( "anti_aim.fake_lag_limit", 16)
                if memoryaa then
                    menu.set_bool("anti_aim.manual_right_key",rnmanul)
                    menu.set_bool("anti_aim.manual_left_key",lnmanul)
                    if des then
                        menu.set_bool("anti_aim.invert_desync_key",false)
                    else
                        menu.set_bool("anti_aim.invert_desync_key",true)
                    end
                end
                ovver = menu.get_key_bind_state( "anti_aim.invert_desync_key")
                rnmanul = false
                lnmanul = false
                memoryaa = false
                mem = true
            end
        end
    end
end)
client.add_callback( "on_paint" , function()

    if menu.get_bool( "Console filter" ) == true and console.get_int( "con_filter_enable" ) == 0 then   
        console.execute( "con_filter_enable 1 ")
    elseif menu.get_bool( "Console filter" ) == false and console.get_int( "con_filter_enable" ) == 1 then
        console.execute( "con_filter_enable 0 ")
    end

    if menu.get_bool( "Watermark" ) then
        if alhhka ~= 255 then 
            alhhka = math.min(255,alhhka + 10)
        end
        
    else            
        if alhhka ~= 0 then 
            alhhka = math.max(0,alhhka - 10)
        end
    end

    if alhhka ~= 0 then
        watercolor = color.new(30,30,30,alhhka)
        watertextcolor = color.new(170,200,255,alhhka)
        local cordname = " giper.tech |"
        local version = cordname.." open alpha | "
        local lelee = version..username
        widt = render.get_text_width( main, lelee )
        rect_water(scrx-widt-10,10,widt+5,20)
        render.draw_text_centered( main, scrx-widt-10, 10, watertextcolor, false, false,lelee)
    end

    if menu.get_bool( "Enable logs" ) then
        menu.set_bool( "misc.logs", false )
    else
        menu.set_bool( "misc.logs", cache )
    end

    rectc = color.new(30,30,30,alphabombtimer)
    fontc = color.new(174, 206 ,254,alphabombtimer)
    local currenttime = globals.get_curtime()
    local leftmanual = menu.get_key_bind_state( "anti_aim.manual_left_key" )
    local rightmanual = menu.get_key_bind_state( "anti_aim.manual_right_key" )
    local desyncpos = menu.get_key_bind_state( "anti_aim.invert_desync_key" )
    
    if menu.get_bool( "Enable indicators" ) and engine.is_in_game() then
        if desyncpos then
            if (input.IsButtonPressed(0x45)) and (check == false) then
                render.draw_line( scrx/2+33, scry/2-11, scrx/2+33, scry/2+11, color.new(255,255,255) )
                render.draw_line( scrx/2+32, scry/2-11, scrx/2+32, scry/2+11, color.new(255,255,255) )
                render.draw_line( scrx/2+31, scry/2-11, scrx/2+31, scry/2+11, color.new(255,255,255) )
            else
                render.draw_line( scrx/2-33, scry/2-11, scrx/2-33, scry/2+11, color.new(255,255,255) )
                render.draw_line( scrx/2-32, scry/2-11, scrx/2-32, scry/2+11, color.new(255,255,255) )
                render.draw_line( scrx/2-31, scry/2-11, scrx/2-31, scry/2+11, color.new(255,255,255) )
            end
        else
            if (input.IsButtonPressed(0x45)) and (check == false) then
                render.draw_line( scrx/2-33, scry/2-11, scrx/2-33, scry/2+11, color.new(255,255,255) )
                render.draw_line( scrx/2-32, scry/2-11, scrx/2-32, scry/2+11, color.new(255,255,255) )
                render.draw_line( scrx/2-31, scry/2-11, scrx/2-31, scry/2+11, color.new(255,255,255) )
            else
                render.draw_line( scrx/2+33, scry/2-11, scrx/2+33, scry/2+11, color.new(255,255,255) )
                render.draw_line( scrx/2+32, scry/2-11, scrx/2+32, scry/2+11, color.new(255,255,255) )
                render.draw_line( scrx/2+31, scry/2-11, scrx/2+31, scry/2+11, color.new(255,255,255) )
            end
        end
        if leftmanual then
            render.draw_triangle( scrx/2-35, scry/2+11, scrx/2-55, scry/2, scrx/2-35, scry/2-10, color.new(120, 120 ,255))
        else
            render.draw_line( scrx/2-35, scry/2+11, scrx/2-55, scry/2, color.new(150,150,255) )
            render.draw_line( scrx/2-55, scry/2, scrx/2-35, scry/2-11, color.new(150,150,255) )
            render.draw_line( scrx/2-35, scry/2-11, scrx/2-35, scry/2+11, color.new(150,150,255) )
        end
        if rightmanual then 
            render.draw_triangle( scrx/2+55, scry/2, scrx/2+35, scry/2+11, scrx/2+35, scry/2-10, color.new(120, 120 ,255))
        else
            render.draw_line( scrx/2+35, scry/2-11, scrx/2+55, scry/2, color.new(150,150,255) )
            render.draw_line( scrx/2+55, scry/2, scrx/2+35, scry/2+11, color.new(150,150,255) )
            render.draw_line( scrx/2+35, scry/2+11, scrx/2+35, scry/2-11, color.new(150,150,255) )
        end
    end

    if open_check() then if Is_Open then Is_Open = false else Is_Open = true end end
    if menu.get_bool( "Enable Bomb timer" ) == true then
        if Is_Open or bomb.planting or bomb.planted or bomb.exploded or bomb.defused then
            if alphabombtimer ~= 255 then 
                alphabombtimer = math.min(255,alphabombtimer + 10)
            end
        else
            if alphabombtimer ~= 0 then 
                alphabombtimer = math.max(0,alphabombtimer - 10)
            end
        end
        if (Is_Open == true) and (bomb.planting == false) and (bomb.planted == false) and (bomb.exploded == false) then
            bombcolor = color.new(0,255,0)
            bomb.state = "State: None"
            bomb.sitetime = "Site:    Time: "
            bomb.damagetext = "Hp remain:"
            bomb.damage = "-"
        end
        if bomb.planting == true then
            timeplant = currenttime-startplanting
            redz = math.min(255,math.floor(timeplant*82))
            grez = 255-redz
            bombcolor = color.new(redz,grez,0)
            bomb.state = "State: Planting"
            bomb.sitetime = "Site: "..bomb.site
            bomb.damagetext = "Timer: "..4-math.ceil(timeplant)
            bomb.damage = "-"
        else
            startplanting = globals.get_curtime()
        end
        if engine.is_in_game() then
            c4 = luamath.FindByClass("CPlantedC4")
            player = entitylist.get_local_player()
            if c4 ~= nil then
                bomb.defused = c4:get_prop_bool("CPlantedC4","m_bBombDefused")
                blow_time = c4:get_prop_float("CPlantedC4","m_flC4Blow")
                defuse_time = c4:get_prop_float("CPlantedC4","m_flDefuseLength")
                if player ~= nil then
                    armor = player:get_prop_int( "CCSPlayer", "m_ArmorValue" );
                    health = player:get_prop_int( "CCSPlayer", "m_iHealth" );
                    time_remaining = math.max(0,math.floor(blow_time -(globals.get_curtime()))+1)
                    bomb.planting = false    
                    bomb.planted = c4:get_prop_bool( "CPlantedC4" , "m_bBombTicking")
                    bomb.damagetext = "HP remain:"
                    current_pos = player:get_origin();
                    pl_orig = ffi.cast("Vector_t*",ffi_helpers.get_entity_address(c4idx)+312);
                    c4pos = vector.new(pl_orig.x,pl_orig.y,pl_orig.z);
                    flDamage = 500;
                    flBombRadius = flDamage * 3.5;
                    flDistanceToLocalPlayer = current_pos:dist_to(c4pos);
                    fSigma = flBombRadius / 3;
                    fGaussianFalloff = math.exp(-flDistanceToLocalPlayer * flDistanceToLocalPlayer / (2 * fSigma * fSigma));
                    flAdjustedDamage = flDamage * fGaussianFalloff;
                    fltotaldamage = math.floor(luamath.scaleDamageArmor(flAdjustedDamage,armor));
                    greendefuse = math.ceil((health-fltotaldamage) * 2.55/(health/100))
                    reddefuse = 255-greendefuse
                    if health > 0 then
                        if health <= fltotaldamage then
                            bomb.damage = "Lethal"
                            bomb.damagecolor = color.new(255,0,0)
                        else
                            bomb.damage = tostring(health-fltotaldamage)
                            bomb.damagecolor = color.new(reddefuse,greendefuse,0)
                        end
                    else
                        bomb.damagetext = "You are dead"
                        bomb.dmgtext = "-"
                    end
                    if bomb.planted then
                        time_remaining = blow_time - globals.get_curtime()
                        def_time = defuse_time+(oldtimeD-currenttime)
                        if bomb.defusing then 
                            if bomb.defusestart >= defuse_time then
                                if redz ~= 0 then
                                    redz = redz-1
                                end
                                if grez ~= 255 then
                                    grez = grez+1
                                end
                            else 
                                if redz ~= 255 then
                                    redz = redz+1
                                end
                                if grez ~= 0 then
                                    grez = grez-1
                                end
                            end
                            bombcolor = color.new(redz,grez,0)
                            bomb.state = "State: Defusing"
                            bomb.sitetime = "Site: "..bomb.site.."    Timer: "..math.max(0,math.ceil(def_time))
                        else
                            if grez ~= 0 then   
                                grez = grez-1
                            else
                                if redz ~= 255 and gres == true then
                                    redz = redz + 1
                                elseif redz ~= 0 then 
                                    redz = redz-1
                                    gres = false
                                else
                                    gres = true
                                end
                            end
                            bombcolor = color.new(redz,grez,0)
                            bomb.defusestart = time_remaining
                            oldtimeD = globals.get_curtime()
                            bomb.state = "State: Thicking"
                            bomb.sitetime = "Site: "..bomb.site.."    Timer: "..math.max(0,math.ceil(time_remaining))
                        end
                    else
                        if bomb.defused == false then
                            bomb.exploded = true
                        end
                    end
                end
            else
                bomb.planted = false
                bomb.defusing = false
                bomb.defused = false
                bomb.exploded = false
            end
            if bomb.exploded then
                if redz ~= 255 then
                    redz = redz + 1
                end
                bombcolor = color.new(redz,0,0)
                bomb.state = "State: Exploded"
                bomb.sitetime = "Site:"..bomb.site
                bomb.damagetext = "-"
                bomb.damage = "-"
            end
            if bomb.defused then
                bombcolor = color.new(0,255,0)
                bomb.state = "State: Defused"
                bomb.sitetime = "Site:"..bomb.site
                bomb.damagetext = "-"
                bomb.damage = "-"
            end
        else
            bomb.planting = false
            bomb.planted = false
            bomb.defusing = false
            bomb.defused = false
            bomb.exploded = false
        end
        
    else
        if alphabombtimer ~= 0 then 
            alphabombtimer = math.max(0,alphabombtimer - 10)
        end
    end

    if alphabombtimer ~= 0 then
        if Is_Open == true then
            bombtimer(bobmstartx, bobmstarty, bwidth, bheight)
        end
        rect_bombtimer( bobmstartx, bobmstarty, bwidth , bheight)
    end

    if menu.get_bool( "Enable keybinds" ) == true then
        keybindcolor = color.new(30,30,30,alphakeybinds)
        fontkeybindcolor = color.new(174, 206 ,254,alphakeybinds)
        if count ~= 0 or Is_Open then      
            if alphakeybinds ~= 255 then 
                alphakeybinds = math.min(255,alphakeybinds + 10)
            end
        else
            if alphakeybinds ~= 0 then 
                alphakeybinds = math.max(0,alphakeybinds - 10)
            end
        end
        if open_check() then if Is_Open then Is_Open = false else Is_Open = true end end
        count = 0;
        if engine.is_in_game() then
            bind("Edge yaw","Edge yaw");
            bind("Double tap", "rage.double_tap_key");
            bind("Hide shots", "rage.hide_shots_key");
            bind("Quick peek", "misc.automatic_peek_key");
    	    bind("Override damage", "rage.force_damage_key");
            bind("Resolver override", "Resolver override");
            bind("Safe points override", "Force safe points");
        end
    else
        if alphakeybinds ~= 0 then 
            alphakeybinds = math.max(0,alphakeybinds - 10)
        end
    end
    if alphakeybinds ~= 0 then
        if Is_Open then 
            keybind(rend_x, rend_y, widthz, test_h) 
        end
        rect_keybind(rend_x, rend_y, widthz, test_h)
    end
end)
client.add_callback( "unload", function()
    menu.set_bool( "misc.logs", cache )
end)