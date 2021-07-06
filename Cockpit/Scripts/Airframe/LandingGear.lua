dofile(LockOn_Options.script_path.."command_defs.lua")

local gear_system = GetSelf()

local update_time_step = 0.04
make_default_activity(update_time_step)

local sensor_data = get_base_data()

local gear_switch = 68
local gear_up = 430
local gear_down = 431

local nose_gear_status = 1
local l_main_gear_status = 1
local r_main_gear_status = 1

local nose_gear_broken = 0
local l_main_gear_broken = 0
local r_main_gear_broken = 0

local gear_level_init = 0

local gear_level = get_param_handle("LANDING_GEAR")
local basic_gear_dis = get_param_handle("BASIC_GEAR_DIS")
local ParkingBrake = get_param_handle("ParkingBrake")

gear_system:listen_command(gear_switch)
gear_system:listen_command(gear_up)
gear_system:listen_command(gear_down)
gear_system:listen_command(click_cmd.GearLevel)
gear_system:listen_command(device_commands.ParkingBrake)

function post_initialize()
    local birth = LockOn_Options.init_conditions.birth_place
    if birth=="GROUND_HOT" then
        nose_gear_status = 1
        l_main_gear_status = 1
        r_main_gear_status = 1
        ParkingBrake:set(0)
        basic_gear_dis:set("DOWN")
    elseif birth=="AIR_HOT" then
        nose_gear_status = 0
        l_main_gear_status = 0
        r_main_gear_status = 0
        ParkingBrake:set(0)
        basic_gear_dis:set("UP")
    elseif birth=="GROUND_COLD" then
        nose_gear_status = 1
        l_main_gear_status = 1
        r_main_gear_status = 1
        ParkingBrake:set(1)
        basic_gear_dis:set("DOWN")
    end

    if (gear_level_init == 0) then
        --gear_system:performClickableAction(click_cmd.GearLevel, 1, false)
    end

    set_aircraft_draw_argument_value(0, nose_gear_status)
    set_aircraft_draw_argument_value(3, r_main_gear_status)
    set_aircraft_draw_argument_value(5, l_main_gear_status)
    gear_level:set(1 - nose_gear_status)
end

function SetCommand(command,value)
    if command == device_commands.ParkingBrake and ParkingBrake:get() == 0 then
        ParkingBrake:set(1)
        dispatch_action(nil,74)
        print_message_to_user("Parking Brake ON")
    elseif command == device_commands.ParkingBrake and ParkingBrake:get() == 1 then
        ParkingBrake:set(0)
        dispatch_action(nil,75)
        print_message_to_user("Parking Brake OFF")
    end

    if (command == click_cmd.GearLevel) then
        dispatch_action(nil, 68) --重设指令到默认起落架命令
    elseif (command == gear_switch) then
        nose_gear_status = 1 - nose_gear_status
        l_main_gear_status = 1 - l_main_gear_status
        r_main_gear_status = 1 - r_main_gear_status
        if (nose_gear_status == 1) then
            print_message_to_user("Gear Down")
        else
            print_message_to_user("Gear Up")
        end
    elseif (command == gear_down) then
        nose_gear_status = 1
        l_main_gear_status = 1
        r_main_gear_status = 1
    elseif (command == gear_up) then
        nose_gear_status = 0
        l_main_gear_status = 0
        r_main_gear_status = 0        
	end
end

local gear_level_pos = gear_level:get()

function update()
    local n_gear_status=get_aircraft_draw_argument_value(0)
    local l_gear_status=get_aircraft_draw_argument_value(5)
    local r_gear_status=get_aircraft_draw_argument_value(3)

    local lever_clickable_ref = get_clickable_element_reference("PNT_LDG_GEAR")

    lever_clickable_ref:update()
    
        if (nose_gear_status == 0 and n_gear_status > 0) then
            -- lower canopy in increments of 0.01 (50x per second)
            n_gear_status = n_gear_status - 0.01
            basic_gear_dis:set("MOVE")
            set_aircraft_draw_argument_value(0, n_gear_status)
        elseif (nose_gear_status == 1 and n_gear_status < 1) then
            -- lower canopy in increments of 0.01 (50x per second)
            n_gear_status = n_gear_status + 0.01
            basic_gear_dis:set("MOVE")
            set_aircraft_draw_argument_value(0, n_gear_status)
        end

        if (nose_gear_status == 0 and n_gear_status <= 0) then
            basic_gear_dis:set("UP")
        elseif (nose_gear_status == 1 and n_gear_status >= 1)then
            basic_gear_dis:set("DOWN")
        end

        if (l_main_gear_status == 0 and l_gear_status > 0) then
            l_gear_status = l_gear_status - 0.01
            set_aircraft_draw_argument_value(5, l_gear_status)
        elseif (l_main_gear_status == 1 and l_gear_status < 1) then
            l_gear_status = l_gear_status + 0.01
            set_aircraft_draw_argument_value(5, l_gear_status)
        end

        if (r_main_gear_status == 0 and r_gear_status > 0) then
            -- lower canopy in increments of 0.01 (50x per second)
            r_gear_status = r_gear_status - 0.01
            set_aircraft_draw_argument_value(3, r_gear_status)
        elseif (r_main_gear_status == 1 and r_gear_status < 1) then
            -- lower canopy in increments of 0.01 (50x per second)
            r_gear_status = r_gear_status + 0.01
            set_aircraft_draw_argument_value(3, r_gear_status)
        end
        
        if (nose_gear_status == 0 and gear_level_pos < 1) then
            -- lower canopy in increments of 0.01 (50x per second)
            gear_level_pos = gear_level_pos + 0.09
            gear_level:set(gear_level_pos)
        elseif (nose_gear_status == 1 and gear_level_pos > 0) then
            -- lower canopy in increments of 0.01 (50x per second)
            gear_level_pos = gear_level_pos - 0.09
            gear_level:set(gear_level_pos)
        end
        
end

need_to_be_closed = false