dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."Airframe/ElectricSystem.lua")

local dev = GetSelf()
local sensor_data = get_base_data()

local update_time_step = 0.02
make_default_activity(update_time_step)

local CANOPY = 0
local CANOPY_INSIDE = get_param_handle("CANOPY_INSIDE")
CANOPY_INSIDE:set(0)

dev:listen_command(71)

function post_initialize()
    local birth = LockOn_Options.init_conditions.birth_place
    if birth == "GROUND_HOT" or birth == "AIR_HOT" then
        CANOPY = 0
    elseif birth == "GROUND_COLD" then
        CANOPY = 0.9
    end
    print_message_to_user("CANOPY INIT")
end

function SetCommand(command,value)
    if command == 71 and CANOPY == 0 then
        CANOPY = 0.9
    elseif command == 71 and CANOPY == 0.9 then
        CANOPY = 0
    end
end

function update()
    local CanopyStatus = CANOPY_INSIDE:get()

    if (CANOPY == 0 and CanopyStatus > 0) then
        CanopyStatus = CanopyStatus - 0.01
        set_aircraft_draw_argument_value(38,CanopyStatus)
        CANOPY_INSIDE:set(CanopyStatus)
    elseif (CANOPY == 0.9 and CanopyStatus < 0.9) then
        CanopyStatus = CanopyStatus + 0.01
        set_aircraft_draw_argument_value(38,CanopyStatus)
        CANOPY_INSIDE:set(CanopyStatus)
    end

end