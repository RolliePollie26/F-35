dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")

local dev = GetSelf()
local sensor_data = get_base_data()

local update_time_step = 0.02
make_default_activity(update_time_step)

local BATT_28V = get_param_handle("BATT_28V")
local BATT_270V = get_param_handle("BATT_270V")
local BATT = get_param_handle("BATT")

BATT_28V:set(0)
BATT_270V:set(0)
BATT:set(0)

dev:listen_command(device_commands.BATT28v)
dev:listen_command(device_commands.BATT270v)
dev:listen_command(device_commands.BattSwitch)

function post_initialize()
    local birth = LockOn_Options.init_conditions.birth_place
    if birth == "GROUND_HOT" or birth == "AIR_HOT" then
        BATT_28V:set(1)
        BATT_270V:set(1)
        dev:performClickableAction(device_commands.BattSwitch,1,true)
        --BATT:set(1)
    elseif birth == "GROUND_COLD" then
        BATT_28V:set(0)
        BATT_270V:set(0)
        dev:performClickableAction(device_commands.BattSwitch,0,true)
        --BATT:set(0)
    end
    print_message_to_user("ELECTRIC SYSTEM INIT")
end

function SetCommand(command,value)
    if command == device_commands.BATT28v and BATT_28V:get() == 0 then
        BATT_28V:set(1)
        print_message_to_user("BATT_28V:set(1)")
    elseif command == device_commands.BATT28v and BATT_28V:get() == 1 then
        BATT_28V:set(0)
        print_message_to_user("BATT_28V:set(0)")
    end

    if command == device_commands.BATT270v and BATT_270V:get() == 0 then
        BATT_270V:set(1)
        print_message_to_user("BATT_270V:set(1)")
    elseif command == device_commands.BATT270v and BATT_270V:get() == 1 then
        BATT_270V:set(0)
        print_message_to_user("BATT_270V:set(0)")
    end

    if command == device_commands.BattSwitch then
        if get_cockpit_draw_argument_value(14) == 1 then
            dev:performClickableAction(device_commands.BattSwitch,0,true)
            dispatch_action(nil,315,0)
            BATT:set(0)
        elseif get_cockpit_draw_argument_value(14) < 1 then
            dev:performClickableAction(device_commands.BattSwitch,1,true)
            dispatch_action(nil,315,1)
            BATT:set(1)
        end
    end

    --[[ if command == device_commands.BattSwitch and BATT:get() == 0 then
        BATT:set(1)
        print_message_to_user("BATT:set(1)")
    elseif command == device_commands.BattSwitch and BATT:get() == 1 then
        BATT:set(0)
        print_message_to_user("BATT:set(0)")
    end ]]
end

function update()
    local batt28v_clickable_ref = get_clickable_element_reference("PNT_BATT_28V")
    local batt270v_clickable_ref = get_clickable_element_reference("PNT_BATT_270V")
    local battery_clickable_ref = get_clickable_element_reference("PNT_BATT")

    batt28v_clickable_ref:update()
    batt270v_clickable_ref:update()
    battery_clickable_ref:update()
end
