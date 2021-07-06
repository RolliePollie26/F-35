dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."Airframe/ElectricSystem.lua")

local dev = GetSelf()

local update_time_step = 0.02
make_default_activity(update_time_step)

local sensor_data = get_base_data()

BATT = get_param_handle("BATT")

local HMD_PWR = get_param_handle("HMD_PWR")
local SENS_PWR = get_param_handle("SENS_PWR")
local FILTER_OPACTIY = get_param_handle("FILTER_OPACITY")

local VISOR = 1

dev:listen_command(device_commands.HMDPower) -- HMD Power
dev:listen_command(device_commands.HMDSensorView) -- See through shit

function post_initialize()
    local birth = LockOn_Options.init_conditions.birth_place
    if birth == "GROUND_HOT" or birth == "AIR_HOT" then
        HMD_PWR:set(1)
        VISOR = 1
    elseif birth == "GROUND_COLD" then
        HMD_PWR:set(0)
        VISOR = 0
    end
    print_message_to_user("HELMET INIT")
end

function SetCommand(command,value)
    if command == device_commands.HMDPower and BATT:get() == 0 and HMD_PWR:get() == 0 then
        HMD_PWR:set(0)
        print_message_to_user("Must Turn On Battery")
    elseif command == device_commands.HMDPower and BATT:get() == 1 and HMD_PWR:get() == 0 then
        HMD_PWR:set(1)
        VISOR = 1
        print_message_to_user("HMD Power ON")
    elseif command == device_commands.HMDPower and BATT:get() == 1 and HMD_PWR:get() == 1 then
        HMD_PWR:set(0)
        VISOR = 0
        print_message_to_user("HMD Power OFF")
    end

    if command == device_commands.HMDSensorView and HMD_PWR:get() == 0 and FILTER_OPACTIY:get() == 0 then
        FILTER_OPACITY:set(0)
        print_message_to_user("No Power to HMD")
    elseif command == device_commands.HMDSensorView and HMD_PWR:get() == 1 and FILTER_OPACITY:get() == 0 then
        FILTER_OPACITY:set(1)
        dispatch_action(nil,326,0)
        print_message_to_user("HMD Sensor View ON")
    elseif command == device_commands.HMDSensorView and HMD_PWR:get() == 1 and FILTER_OPACITY:get() == 1 then
        FILTER_OPACITY:set(0)
        dispatch_action(nil,326,1)
        print_message_to_user("HMD Sensor View OFF")
    end
end

function update()
    if HMD_PWR:get() == 0 then
        VISOR = 0
    end

    if BATT:get() == 0 then
        HMD_PWR:set(0)
        SENS_PWR:set(0)
        if FILTER_OPACITY:get() > 0 then
            FILTER_OPACITY:set(0)
            dispatch_action(nil,326,1)
        end
    end

    set_aircraft_draw_argument_value(400,VISOR)
end