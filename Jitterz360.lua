require "[GT]Settings";
local ffi = require("ffi");
local cache = menu.get_bool("misc.logs");
ffi.cdef[[
    int MessageBoxA(void *w, const char *txt, const char *cap, int type);
    typedef int(__fastcall* clantag_t)(const char*, const char*);
    typedef struct tagPOINT{long x;long y;}POINT;
    typedef struct{float x,y,z;}Vector_t;
    typedef uintptr_t (__thiscall* GetClientEntity_4242425_t)(void*, int);
    typedef bool (__thiscall *IsButtonDown_t)(void*, int);
    short GetAsyncKeyState(int vKey);
    bool GetCursorPos(POINT* lpPoint);

    typedef struct _Vector {
        float x,y,z;
    } Vector;

    typedef struct _color_t {
        unsigned char r, g, b;
        signed char exponent;
    } color_t; 
    typedef struct _dlight_t {
        int flags;
        Vector origin;
        float radius;
        color_t color;
        float die;
        float decay;
        float minlight;
        int key;
        int style;
        Vector direction;
        float innerAngle;
        float outerAngle;
    } dlight_t; 
]]

console.execute("con_filter_text out hajksddsnkjcakhkjash")
console.execute("con_filter_text hjkasdhjadskdhasjkasd 1")
console.execute("clear")
local effects = ffi.cast(ffi.typeof("void***"), utils.create_interface("engine.dll", "VEngineEffects001"))
local alloc_dlight = ffi.cast(ffi.typeof('dlight_t*(__thiscall*)(void*, int)'), effects[0][4])
local fn_change_clantag = utils.find_signature("engine.dll", "53 56 57 8B DA 8B F9 FF 15")
local set_clantag = ffi.cast("clantag_t", fn_change_clantag)
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
local frame_rate = 0.0;
local origin
local fps = 0;
local widthz = test_w;
local typew = test_w;
local cheattag = menu.get_bool("misc.clan_tag");
local cheatwat = menu.get_bool("misc.watermark");
local cheatkey = menu.get_bool("misc.key_binds");
local cheatap = menu.get_color( "misc.automatic_peek_clr"):a();
local viscac = menu.get_bool( "visuals.world.manual_anti_aim" )
local visc = true
local aacc = menu.get_bool("anti_aim.enable");
local ffcc = menu.get_bool("anti_aim.enable_fake_lag");
local oldtimeD = 0;
local redz = 0;
local grez = 0;
local count = 0;
local disc321 = 0;
local reds = true;
local aacahce = true;
local memeorylogs = true;
local memeoryclan = true;
local memeorykey = true;
local memeorywat = true;
local lnmanul = false;
local rnmanul = false;
local shotldelay = nil;
local registered_shot = nil;
local scrx = engine.get_screen_width();
local scry = engine.get_screen_height();
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
local autopeekpos = vector.new(0,0,0)
local o = menu.get_color( "misc.automatic_peek_clr" )
menu.set_color( "misc.automatic_peek_clr", color.new(o:r(),o:g(),o:b(),0))
local watercolor = color.new(30,30,30,0)
local watertextcolor = color.new(170,200,255,0)
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
local off = {
    " ",
}
local c2k17 = {
    "         ",
    "   7.c   ",
    "  17.cl  ",
    " k17.clu ",
    "2k17.club",
    "2k17.club",
    "2k17.club",
    " k17.clu ",
    "  17.cl  ",
    "   7.c   ",
    "         ",
}
local gamesense = {
    "",
    "ga",
    "gam",
    "game",
    "games",
    "gamese",
    "gamesen",
    "gamesens",
    "gamesense",
    "gamesense",
    "gamesense",
    "gamesense",
    "gamesense",
    "amesense",
    "mesense",
    "esense",
    "sense",
    "ense",
    "nse",
    "se",
    "e",
}
local lawe = {
    "",
    "",
    "l",
    "le",
    "leg",
    "lege",
    "legen",
    "legend",
    "legendw",
    "legendwa",
    "legendwar",
    "legendware ",
    "legendware B",
    "legendware Be",
    "legendware Bet",
    "legendware Beta",
    "legendware Beta",
    "legendware Beta",
    "legendware Beta",
    "legendware Beta",
    "legendware Bet",
    "legendware Be",
    "legendware B",
    "legendware ",
    "legendware",
    "legendwar",
    "legendwa",
    "legendw",
    "legend",
    "legen",
    "lege",
    "leg",
    "le",
    "l",
}
local ffi_helpers = {
    get_entity_address = function(ent_index)
        local addr = get_client_entity_fn(entity_list_ptr, ent_index)
        return addr
    end,
}


function glow(i,org,clr,rdzt)
    local dlight = alloc_dlight(effects,i)
    dlight.color.r =clr:r()
    dlight.color.g =clr:g()
    dlight.color.b =clr:b()
    dlight.color.exponent = 6
    dlight.origin.x = org.x
    dlight.origin.y = org.y
    dlight.origin.z = org.z+10
    dlight.radius = rdzt
    dlight.die = globals.get_curtime() + 0.1
    dlight.decay = 35
end

local luamath = {
    get_abs_fps = function()
        frame_rate = 0.9 * frame_rate + (1.0 - 0.9) * globals.get_frametime()
        return math.floor((1.0 / frame_rate) + 0.5)
    end,
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
rect_water = function(x, y, w, h,clor)
    render.draw_rect_filled( x + 5, y,          w - 5 * 2, h,            clor)
    render.draw_rect_filled( x,          y + 5, w,            h - 5 * 2, clor)
    render.draw_circle_filled( x + 5, y + 5, 50, 5, clor )
    render.draw_circle_filled( x + w - 5, y + 5, 50, 5, clor )
    render.draw_circle_filled( x + 5, y + h - 5, 50, 5, clor )
    render.draw_circle_filled( x + w - 5, y + h - 5, 50, 5, clor )
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
    if menu.get_key_bind_state(bind_name) == true then
        render.draw_text(keybindf, rend_x+3, rend_y + 21 + (12 * count), color.new(0,0,0), render_name)
        render.draw_text(keybindf, rend_x+2, rend_y + 20 + (12 * count), fontkeybindcolor, render_name)
        wdx = render.get_text_width(keybindf, " [" .. types[menu.get_key_bind_mode(bind_name) + 1] .. "]")
        widthz = render.get_text_width(keybindf, render_name)+wdx+10

        render.draw_text(keybindf, rend_x -1+ typew-wdx, rend_y + 21 + (12 * count), color.new(0,0,0), "[" .. types[menu.get_key_bind_mode(bind_name) + 1] .. "]")
        render.draw_text(keybindf, rend_x -2+ typew-wdx, rend_y + 20 + (12 * count), fontkeybindcolor, "[" .. types[menu.get_key_bind_mode(bind_name) + 1] .. "]")
        count = count + 1
    end
end

function setmovement(xz,yz,cmd)
    local local_player = entitylist.get_local_player()
    local current_pos = local_player:get_origin()
    local yaw = engine.get_view_angles().y

    local vector_forward = { 
        x = current_pos.x - xz,
        y = current_pos.y - yz,
    }
     
    local velocity = {
        x = -(vector_forward.x * math.cos(yaw / 180 * math.pi) + vector_forward.y * math.sin(yaw / 180 * math.pi)),
        y = vector_forward.y * math.cos(yaw / 180 * math.pi) - vector_forward.x * math.sin(yaw / 180 * math.pi),
    }
    cmd.forwardmove = velocity.x * 15
    cmd.sidemove = velocity.y * 15
end;

client.add_callback( "on_shot", function(shot)
    local result = shot.result
    local unreg_hitbox = shot.client_hitbox
    local reg_hitbox = shot.server_hitbox
    local safe = shot.safe
    local i = shot.target_index
    local name = engine.get_player_info(i).name
    local unreg_dmg = shot.client_damage
    local reg_dmg = shot.server_damage
    local hc = shot.hitchance
    local bt = shot.backtrack_ticks
    if menu.get_bool( "Enable logs" ) == true then
        print("[GT.logs] Fired shot at "..name.." in the "..unreg_hitbox.." for "..unreg_dmg.." damage("..hc.."%%), Safe: "..tostring(safe)..", Backtrack: "..bt)
        if result == "Hit" then
            if unreg_hitbox == reg_hitbox then
                print("[GT.logs] Hit "..name.." in the "..reg_hitbox.. " for "..reg_dmg.. " damage\n")
            else
                print("[GT.logs] Hit "..name.." in the "..reg_hitbox.. " for "..reg_dmg.. " damage\n")
            end
        elseif result == "Spread" then
            if hc ~= 100 then
                print("[GT.logs] Missed "..name.." due to spread\n")
            else
                print("[GT.logs] Missed "..name.." due to occlusion\n")
            end
        elseif result == "Resolver" then
            print("[GT.logs] Missed "..name.." due to resolver\n")
        else
            print("[GT.logs] Missed "..name.." due to unknown\n")
        end
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
    bomb.planting = false
    bomb.planted = false
    bomb.defusing = false
    bomb.defused = false
    bomb.exploded = false
end)

client.add_callback( "create_move", function(cmd)
    local localplayer = entitylist.get_local_player();
    local cp = menu.get_color( "misc.automatic_peek_clr" );
    local laa = menu.get_key_bind_state( "LegitAA" );
    local forw = bit.band(cmd.buttons, 8) == 8;
    local back = bit.band(cmd.buttons, 16) == 16;
    local righ = bit.band(cmd.buttons, 512) == 512;
    local left = bit.band(cmd.buttons, 1024) == 1024;
    local apeek = menu.get_key_bind_state( "misc.automatic_peek_key" );
    local clr = menu.get_color( "misc.automatic_peek_clr" );
    local originalpos = localplayer:get_origin();

    if apeek == false and disc321 == 0 then
        curpos = localplayer:get_origin();
    end
    if menu.get_bool( "Enable glow autopeek" ) then
        menu.set_color( "misc.automatic_peek_clr", color.new(clr:r(),clr:g(),clr:b(),0));
        if localplayer then 
            if apeek then
                if disc321 ~= 35 then
                    disc321 = disc321 + 5
                end
            else
                if disc321 ~= 0 then
                    disc321 = disc321 - 5
                end
            end
            if disc321 ~= 0 then 
                glow(localplayer:get_index(),curpos,clr,disc321);
            end
        end
    else
        menu.set_color("misc.automatic_peek_clr", color.new(clr:r(),clr:g(),clr:b(),o:a()));
    end
    if engine.is_in_game() then
        for nomer = 0, 64 do
            if menu.get_key_bind_state( "Force safe points" ) == true then
                menu.set_bool( "player_list.player_settings[" .. nomer .. "].force_safe_points", true )
            else
                menu.set_bool( "player_list.player_settings[" .. nomer .. "].force_safe_points", false )
            end
            if menu.get_key_bind_state("Resolver override") then
                menu.set_bool("player_list.player_settings[" .. nomer .. "].force_body_yaw", true)
                menu.set_int("player_list.player_settings[" .. nomer .. "].body_yaw", -21)
            else
                menu.set_bool("player_list.player_settings[" .. nomer .. "].force_body_yaw", false)
            end
            if menu.get_key_bind_state("Force bodyaim") then
                menu.set_bool("player_list.player_settings[" .. nomer .. "].force_body_aim", true)
            else
                menu.set_bool("player_list.player_settings[" .. nomer .. "].force_body_aim", false)
            end
        end

        local localplayer = entitylist.get_local_player()
        local OnGround = bit.band(localplayer: get_prop_int("CBasePlayer","m_hGroundEntity"), 1);
        local weapon = entitylist.get_weapon_by_player(localplayer)
        if weapon ~= nil then
            weaponclass = entity.get_class_name(weapon)
        end
        --script
        local gpedgeyaw = menu.get_key_bind_state( "Edge yaw" )
        local gpantiaim = menu.get_bool( "Enable Anti-aims" )
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


        local defuse = localplayer:get_prop_int("CCSPlayer","m_bIsDefusing")
        local plant = localplayer:get_prop_int("CCSPlayer","m_bInBombZone")
        local host = localplayer:get_prop_int("CCSPlayer","m_bIsGrabbingHostage")     
        if gpedgeyaw and laa == false and slowwalk == false then
            menu.set_bool( "anti_aim.edge_yaw", true)
        else
            menu.set_bool( "anti_aim.edge_yaw", false)
        end
        if menu.get_bool( "Enable retreak on key autopeek"  ) then
            if apeek == false then
                menu.set_bool( "misc.fast_stop", true );
            else
                if forw == false and back == false and left == false and righ == false and (math.floor(curpos.x) ~= math.floor(originalpos.x) or math.floor(curpos.y) ~= math.floor(originalpos.y)) and air == false then
                    if weaponclass ~= "CHEGrenade" and weaponclass ~= "CMolotovGrenade" and weaponclass ~= "CSmokeGrenade" and weaponclass ~= "CIncendiaryGrenade" then
                        menu.set_bool( "misc.fast_stop", false );
                        setmovement(curpos.x,curpos.y, cmd);
                    end
                else
                    menu.set_bool( "misc.fast_stop", true );
                end
            end
        end
        if gpantiaim then
            if aacahce == true then
                aacc = menu.get_bool( "anti_aim.enable")
                ffcc = menu.get_bool( "anti_aim.enable_fake_lag")
                memorycheatclan = false
            end
            aacahce = false
            menu.set_bool("anti_aim.enable",true)
            if weapon ~= nil then
                local weaponclass = entity.get_class_name(weapon)
                if defuse ~= 0 then
                    check = true
                elseif host ~= 0 then
                    check = true
                else 
                    check = false
                end
            end
            
            if check == false then
                if laa == true then
                    if globals.get_tickcount() > tick + 1 then
                        if weaponclass ~= "CC4" and plant ~= 1 then
                            cmd.buttons = bit.band(cmd.buttons, bit.bnot(buttons.in_use))
                        end
                    end
                else
                    tick = globals.get_tickcount()
                end
            end
            if (laa == true) and (check == false) then
                menu.set_int( "anti_aim.target_yaw", 0)
                menu.set_int("anti_aim.pitch",0)
                menu.set_int("anti_aim.desync_type",1)
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
                if check == true then
                    menu.set_bool( "anti_aim.enable_fake_lag", false)
                else
                    menu.set_bool( "anti_aim.enable_fake_lag", true)
                end
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
                menu.set_int( "anti_aim.target_yaw", 1)
                menu.set_bool( "anti_aim.enable_fake_lag", false)
                menu.set_int("anti_aim.pitch",1)
                menu.set_int( "anti_aim.yaw_offset", -10)
                menu.set_int( "anti_aim.yaw_modifier", 1)
                menu.set_int( "anti_aim.yaw_modifier_range", 10)
                menu.set_int( "anti_aim.desync_type", 1)
                menu.set_int( "anti_aim.desync_range", math.random(15,20))
                menu.set_int( "anti_aim.desync_range_inverted", math.random(15,20))
                lnmanul = false
                rnmanul = false
            elseif air then
                menu.set_bool( "anti_aim.enable_fake_lag", true)
                menu.set_int( "anti_aim.target_yaw", 1)
                menu.set_int("anti_aim.pitch",1)
                menu.set_int( "anti_aim.yaw_offset", 0)
                menu.set_int( "anti_aim.yaw_modifier", 0)
                menu.set_int( "anti_aim.fake_lag_limit", 14)
                menu.set_int( "anti_aim.desync_range", 60)
                menu.set_int( "anti_aim.desync_range_inverted", 60)
                if weapon ~= nil then
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
                if check == true then
                    menu.set_bool( "anti_aim.enable_fake_lag", false)
                else
                    menu.set_bool( "anti_aim.enable_fake_lag", true)
                end
                menu.set_int("anti_aim.pitch",1)
                menu.set_int( "anti_aim.yaw_offset", 5)
                menu.set_int( "anti_aim.yaw_modifier", 0)
                menu.set_int( "anti_aim.fake_lag_limit", 16)
                menu.set_int( "anti_aim.desync_type", 1)
                menu.set_int( "anti_aim.desync_range", 60)
                menu.set_int( "anti_aim.desync_range_inverted", 60)
            else
                if check == true then
                    menu.set_bool( "anti_aim.enable_fake_lag", false)
                else
                    menu.set_bool( "anti_aim.enable_fake_lag", true)
                end
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
        else
            if aacahce == false then
                menu.set_bool("anti_aim.enable",aacc)
                menu.set_bool( "anti_aim.enable_fake_lag", ffcc)
                aacahce = true
            end
        end
    end
end)
client.add_callback( "on_paint" , function()
    if menu.get_bool( "Enable Anti-aims" ) then 
        laa = menu.get_key_bind_state("LegitAA") 
    end
    local localplayer = entitylist.get_local_player()
    local tim3 = math.floor(globals.get_curtime() * 3)
    if localplayer then 
        local canct = localplayer:get_prop_int("CBaseEntity","m_iTeamNum")
        if canct ~= 0 then
            if menu.get_bool( "Enable clan-tag" ) then
                if memeoryclan == false then
                    cheattag = menu.get_bool("misc.clan_tag")
                    memeoryclan = true
                    menu.set_bool("misc.clan_tag",false)
                end
                if menu.get_bool("misc.clan_tag") == false then
                    if old_time ~= tim3 and (globals.get_tickcount() % 2) == 1 then
                        if menu.get_int( "Clan tag type" ) == 0 then
                            set_clantag(c2k17[tim3 % #c2k17+1], c2k17[tim3 % #c2k17+1])
                        elseif menu.get_int( "Clan tag type" ) == 1 then
                            set_clantag(gamesense[tim3 % #gamesense+1], gamesense[tim3 % #gamesense+1])
                        elseif menu.get_int( "Clan tag type" ) == 2 then
                            set_clantag(lawe[tim3 % #lawe+1], lawe[tim3 % #lawe+1])
                        end
                        old_time = tim3
                    end
                end
            else
                if memeoryclan == true then
                    set_clantag("", "")
                    menu.set_bool("misc.clan_tag",cheattag)
                    memeoryclan = false
                end
            end
        end
    end
    if menu.get_bool( "Enable Console filter" ) == true and bomb.planting == false then
        console.set_int( "con_filter_enable", 1 )
    else
        console.set_int( "con_filter_enable", 0 )
    end
    if menu.get_bool( "Enable Watermark" ) == true then
        if memeorywat == false then
            cheatwat = menu.get_bool("misc.watermark")
            memeorywat = true
            menu.set_bool("misc.watermark",false)
        end
        if menu.get_bool("misc.watermark") == true then
            if alhhka ~= 0 then 
                alhhka = math.max(0,alhhka - 10)
            end
        else
            if alhhka ~= 255 then 
                alhhka = math.min(255,alhhka + 10)
            end
        end
    else
        if memeorywat == true then
            menu.set_bool("misc.watermark",cheatwat)
            memeorywat = false
        end
        if alhhka ~= 0 then 
            alhhka = math.max(0,alhhka - 10)
        end
    end
    if alhhka ~= 0 then
        watercolor = color.new(30,30,30,alhhka)
        watertextcolor = color.new(170,200,255,alhhka)
        if globals.get_tickcount() % 20 == 1 then
            fps = luamath.get_abs_fps()
        end
        username = "Ers"
        local cordname = "Legendware [Beta] | debug | "..username.." | "
        local fpss = render.get_text_width( main, fps.."fps" )
        local widtas = "Legendware [Beta] | debug | "..username.." | 300 fps"
        widt = render.get_text_width( main, widtas )
        rect_water(scrx-widt-15,10,widt+10,20,watercolor)
        render.draw_text_centered( main, scrx-widt-10, 20, watertextcolor,false,true,cordname)
        render.draw_text_centered( main, scrx-fpss-10, 20, watertextcolor,false,true,fps.." fps")
    end

    if menu.get_bool( "Enable logs" ) then
        if memeorylogs == false then
            cache = menu.get_bool("misc.logs")
            memeorylogs = true
            menu.set_bool("misc.logs",false)
        end
        menu.set_bool( "misc.logs", false )
    else
        if memeorylogs == true then
            set_clantag("", "")
            menu.set_bool("misc.logs",cache)
            memeorylogs = false
        end
    end

    rectc = color.new(30,30,30,alphabombtimer)
    fontc = color.new(174, 206 ,254,alphabombtimer)
    local currenttime = globals.get_curtime()
    local leftmanual = menu.get_key_bind_state( "anti_aim.manual_left_key" )
    local rightmanual = menu.get_key_bind_state( "anti_aim.manual_right_key" )
    local desyncpos = menu.get_key_bind_state( "anti_aim.invert_desync_key" )
    local mancol = menu.get_color( "Manuals Color" )
    local descol = menu.get_color( "Real Color" )
    if menu.get_bool( "Enable indicators" ) and engine.is_in_game() then
        if menu.get_bool( "visuals.world.manual_anti_aim" ) == false then
            if visc == true then
                viscac = menu.get_bool( "visuals.world.manual_anti_aim" )
                menu.set_bool("visuals.world.manual_anti_aim", false )
                visc = false
            end
            if desyncpos == false then
                if (laa == true) and (check == false) and (globals.get_tickcount() > tick + 1) then
                    render.draw_line( scrx/2+33, scry/2-11, scrx/2+33, scry/2+11, descol )
                    render.draw_line( scrx/2+32, scry/2-11, scrx/2+32, scry/2+11, descol )
                    render.draw_line( scrx/2+31, scry/2-11, scrx/2+31, scry/2+11, descol )
                else
                    render.draw_line( scrx/2-33, scry/2-11, scrx/2-33, scry/2+11, descol )
                    render.draw_line( scrx/2-32, scry/2-11, scrx/2-32, scry/2+11, descol )
                    render.draw_line( scrx/2-31, scry/2-11, scrx/2-31, scry/2+11, descol )
                end
            else
                if (laa == true) and (check == false ) and (globals.get_tickcount() > tick + 1) then
                    render.draw_line( scrx/2-33, scry/2-11, scrx/2-33, scry/2+11, descol )
                    render.draw_line( scrx/2-32, scry/2-11, scrx/2-32, scry/2+11, descol )
                    render.draw_line( scrx/2-31, scry/2-11, scrx/2-31, scry/2+11, descol )
                else
                    render.draw_line( scrx/2+33, scry/2-11, scrx/2+33, scry/2+11, descol )
                    render.draw_line( scrx/2+32, scry/2-11, scrx/2+32, scry/2+11, descol )
                    render.draw_line( scrx/2+31, scry/2-11, scrx/2+31, scry/2+11, descol )
                end
            end
            if leftmanual then
                render.draw_triangle( scrx/2-35, scry/2+11, scrx/2-55, scry/2, scrx/2-35, scry/2-10, mancol)
            else
                render.draw_line( scrx/2-35, scry/2+11, scrx/2-55, scry/2, mancol )
                render.draw_line( scrx/2-55, scry/2, scrx/2-35, scry/2-11, mancol )
                render.draw_line( scrx/2-35, scry/2-11, scrx/2-35, scry/2+11, mancol )
            end
            if rightmanual then 
                render.draw_triangle( scrx/2+55, scry/2, scrx/2+35, scry/2+11, scrx/2+35, scry/2-10, mancol)
            else
                render.draw_line( scrx/2+35, scry/2-11, scrx/2+55, scry/2, mancol )
                render.draw_line( scrx/2+55, scry/2, scrx/2+35, scry/2+11, mancol )
                render.draw_line( scrx/2+35, scry/2+11, scrx/2+35, scry/2-11, mancol )
            end
        end
    else
        if visc == false then
            menu.set_bool( "visuals.world.manual_anti_aim", viscac )
            visc = true
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
                        bomb.damage = "-"
                    end
                    if bomb.planted then
                        time_remaining = blow_time - globals.get_curtime()
                        def_time = defuse_time+(oldtimeD-currenttime)
                        if bomb.defusing then 
                            if bomb.defusestart >= defuse_time then
                                if redz ~= 120 and redz ~= 0 then
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
                                elseif redz ~= 120 and redz ~= 0 then 
                                    redz = redz-1
                                    gres = false
                                else
                                    gres = true
                                end
                            end
                            bombcolor = color.new(redz,grez,0);
                            bomb.defusestart = time_remaining;
                            oldtimeD = globals.get_curtime();
                            bomb.state = "State: Thicking";
                            bomb.sitetime = "Site: "..bomb.site.."    Timer: "..math.max(0,math.ceil(time_remaining));
                        end
                    else
                        if bomb.defused == false then
                            bomb.exploded = true;
                        end
                    end
                end
            else            
                bomb.planted = false;
                bomb.defusing = false;
                bomb.defused = false;
                bomb.exploded = false;
            end
            if bomb.exploded then
                if redz ~= 255 then
                    redz = redz + 1;
                end
                bombcolor = color.new(redz,0,0);
                bomb.state = "State: Exploded";
                bomb.sitetime = "Site:"..bomb.site;
                bomb.damagetext = "-";
                bomb.damage = "-";
            end
            if bomb.defused then
                bombcolor = color.new(0,255,0);
                bomb.state = "State: Defused";
                bomb.sitetime = "Site:"..bomb.site;
                bomb.damagetext = "-";
                bomb.damage = "-";
            end
        else
            bomb.planting = false;
            bomb.planted = false;
            bomb.defusing = false;
            bomb.defused = false;
            bomb.exploded = false;
        end
        
    else
        if alphabombtimer ~= 0 then 
            alphabombtimer = math.max(0,alphabombtimer - 10);
        end
    end

    if alphabombtimer ~= 0 then
        if Is_Open == true then
            bombtimer(bobmstartx, bobmstarty, bwidth, bheight);
        end
        rect_bombtimer( bobmstartx, bobmstarty, bwidth , bheight);
    end
    if menu.get_bool( "Enable keybinds" ) == true then
        keybindcolor = color.new(30,30,30,alphakeybinds);
        fontkeybindcolor = color.new(174, 206 ,254,alphakeybinds); 
        if engine.is_in_game() then
            bind("Edge yaw","Edge yaw");
            bind("Double tap", "rage.double_tap_key");
            bind("Hide shots", "rage.hide_shots_key");
            bind("Quick peek", "misc.automatic_peek_key");
            bind("Force bodyaim", "Force bodyaim");
            bind("Resolver override", "Resolver override");
    	    bind("Override damage", "rage.force_damage_key");
            bind("Safe points override", "Force safe points");
        end
        if menu.get_key_bind_state("Edge yaw") == false and menu.get_key_bind_state("rage.double_tap_key") == false and menu.get_key_bind_state("rage.hide_shots_key") == false and menu.get_key_bind_state("misc.automatic_peek_key") == false and menu.get_key_bind_state("Force bodyaim") == false and menu.get_key_bind_state("Resolver override") == false and menu.get_key_bind_state("Force safe points") == false and menu.get_key_bind_state("rage.force_damage_key") == false then
            widthz = 90
        end
        if memeorykey == false then
            cheatkey = menu.get_bool("misc.key_binds")
            memeorykey = true
            menu.set_bool("misc.key_binds",false)
        end
        if menu.get_bool("misc.key_binds") == false then
            if count ~= 0 or Is_Open then
                if alphakeybinds ~= 255 then 
                    alphakeybinds = math.min(255,alphakeybinds + 10)
                end
            else
                if alphakeybinds ~= 0 then 
                    alphakeybinds = math.max(0,alphakeybinds - 10)
                end
            end
        else
            if alphakeybinds ~= 0 then 
                alphakeybinds = math.max(0,alphakeybinds - 10)
            end
        end
        count = 0;
    else
        if memeorykey == true then
            menu.set_bool("misc.key_binds",cheatkey)
            memeorykey = false
        end
        if alphakeybinds ~= 0 then 
            alphakeybinds = math.max(0,alphakeybinds - 10)
        end
    end
    if alphakeybinds ~= 0 then
        if Is_Open then 
            keybind(rend_x, rend_y, widthz, test_h);
        end
        rect_keybind(rend_x, rend_y, widthz, test_h);
    end
end)
client.add_callback("unload", function()
    menu.set_bool("misc.clan_tag",cheattag);
    menu.set_bool("misc.watermark",cheatwat);
    menu.set_bool("misc.key_binds",cheatkey);
    menu.set_bool("anti_aim.enable",aacc);
    menu.set_bool("anti_aim.enable_fake_lag",ffcc);
    console.set_int("con_filter_enable", 0);
    set_clantag("","");
end)