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

-- We have to manually calculate the way pitch lines (and their text)
-- move and rotate when the plane rotates
local PITCH_LINE_PARAMS = {}
for i=-90,90,5 do
    PITCH_LINE_PARAMS[i] = {
        -- Used for all elements
        o = get_param_handle("PL_O_"..i),
        r = get_param_handle("PL_R_"..i),
        -- Center line
        x = get_param_handle("PL_X_"..i),
        y = get_param_handle("PL_Y_"..i),
        -- Left text
        lx = get_param_handle("PL_LX_"..i),
        ly = get_param_handle("PL_LY_"..i),
        -- Right text
        rx = get_param_handle("PL_RX_"..i),
        ry = get_param_handle("PL_RY_"..i)
    }
end
function update_pitch_lines()
    --TODO: Head displacement
    local head_x = get_aircraft_draw_argument_value(39) * 3.14159/2
    local head_y = get_aircraft_draw_argument_value(99) * 3.14159/2
    local hmd_pwr = HMD_PWR:get()
    local pitch = -sensor_data.getPitch()
    local roll = sensor_data.getRoll()
    local roll_sin = math.sin(roll)
    local roll_cos = math.cos(roll)
    for i,params in pairs(PITCH_LINE_PARAMS) do
        local pitch_diff = (pitch - math.rad(-i)) * 4.0
        if pitch_diff > 0.3 or pitch_diff < -1.0 then
            -- Hide pitch lader outside expected region
            params.o:set(0)
        else
            params.o:set(hmd_pwr)
            params.r:set(roll)
            params.x:set(-pitch_diff * roll_sin)
            params.y:set(pitch_diff * roll_cos)
            params.lx:set(-0.2 * roll_cos - pitch_diff * roll_sin)
            params.ly:set(pitch_diff * roll_cos - 0.2 * roll_sin)
            params.rx:set(0.2 * roll_cos - pitch_diff * roll_sin)
            params.ry:set(pitch_diff * roll_cos + 0.2 * roll_sin)
        end
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

    update_pitch_lines()
end
