dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."Airframe/ElectricSystem.lua")

local dev = GetSelf()
local sensor_data = get_base_data()

local update_time_step = 0.02
make_default_activity(update_time_step)

local ccParameters = {
                        BATT = get_param_handle("BATT"),
                        NAVLT = get_param_handle("NAVLT"),
                        STRBLT = get_param_handle("STRBLT"),
                        FORMLT = get_param_handle("FORMLT"),
                        LDGLT = get_param_handle("LDGLT"),
}

dev:listen_command(device_commands.StrobeLt)
dev:listen_command(device_commands.NavLt)
dev:listen_command(device_commands.FormLt)
dev:listen_command(device_commands.floodLt)
dev:listen_command(device_commands.LandingLt)

function post_initialize()
    local birth = LockOn_Options.init_conditions.birth_place
    if birth == "GROUND_HOT" or birth == "AIR_HOT" then
        dev:performClickableAction(device_commands.StrobeLt,1,true)
        dev:performClickableAction(device_commands.NavLt,1,true)
        dev:performClickableAction(device_commands.FormLt,1,true)
        dev:performClickableAction(device_commands.floodLt,1,true)
        dev:performClickableAction(device_commands.LandingLt,1,true)
    elseif birth == "GROUND_COLD" then
        dev:performClickableAction(device_commands.StrobeLt,0,true)
        dev:performClickableAction(device_commands.NavLt,0,true)
        dev:performClickableAction(device_commands.FormLt,0,true)
        dev:performClickableAction(device_commands.floodLt,0,true)
        dev:performClickableAction(device_commands.LandingLt,0,true)
    end
    print_message_to_user("LIGHTS INIT")
end

function SetCommand(command,value)
    battSw = get_cockpit_draw_argument_value(14)

    if command == device_commands.StrobeLt then
        if battSw == 1 then
            if get_cockpit_draw_argument_value(6) == 1 then
                dev:performClickableAction(device_commands.StrobeLt,0,true)
                ccParameters.STRBLT:set(0)
            elseif get_cockpit_draw_argument_value(6) < 1 then
                dev:performClickableAction(device_commands.StrobeLt,1,true)
                ccParameters.STRBLT:set(1)
            end
        elseif battSw < 1 then
            dev:performClickableAction(device_commands.StrobeLt,0,true)
            ccParameters.STRBLT:set(0)
        end
    end
end

function update()
    set_aircraft_draw_argument_value(192,ccParameters.STRBLT)
    set_aircraft_draw_argument_value(193,ccParameters.STRBLT)
end