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

-- We have to manually calculate the way heading lines (and their text)
-- move and rotate when the plane rotates
local HEADING_LINE_PARAMS = {}
for i=0,350,10 do
    HEADING_LINE_PARAMS[i] = {
        -- Line
        x = get_param_handle("HL_X_"..i),
        o = get_param_handle("HL_O_"..i),
        -- Text
        tx = get_param_handle("HL_TX_"..i),
        to = get_param_handle("HL_TO_"..i),
    }
end
function update_heading_lines()
    local hmd_pwr = HMD_PWR:get()
    local hdg = -sensor_data.getHeading()
    for i,params in pairs(HEADING_LINE_PARAMS) do
        local hdg_diff = (math.rad(i) - hdg)
        -- Normalize hdg_diff to between -PI and PI
        while hdg_diff > math.pi do
            hdg_diff = hdg_diff - 2.0 * math.pi
        end
        while hdg_diff < -math.pi do
            hdg_diff = hdg_diff + 2.0 * math.pi
        end
        if math.abs(hdg_diff) > math.rad(25) then
            -- Hide ticks and text where it is out of bounds
            params.o:set(0)
            params.to:set(0)
        else
            local hdg_offset = hdg_diff / 2.0
            params.x:set(hdg_offset)
            params.o:set(hmd_pwr)
            if math.abs(hdg_diff) < math.rad(3) then
                -- Hide tick text where it would interfere with heading indicator
                params.to:set(0)
            else
                params.tx:set(hdg_offset)
                params.to:set(hmd_pwr)
            end
        end
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
        tx = get_param_handle("PL_TX_"..i),
        ty = get_param_handle("PL_TY_"..i)
    }
end
function update_pitch_lines()
    local hmd_pwr = HMD_PWR:get()
    local pitch = -sensor_data.getPitch()
    local roll = sensor_data.getRoll()
    local roll_sin = math.sin(roll)
    local roll_cos = math.cos(roll)
    for i,params in pairs(PITCH_LINE_PARAMS) do
        local pitch_diff = pitch - math.rad(-i)
        if pitch_diff > math.rad(8) or pitch_diff < -math.rad(16) then
            -- Hide pitch lader outside expected region
            params.o:set(0)
        else
            local text_offset
            if i > 0 then
                text_offset = 0.06
            else
                text_offset = 0.05
            end
            params.o:set(hmd_pwr)
            params.r:set(roll)
            params.x:set(-pitch_diff * roll_sin)
            params.y:set(pitch_diff * roll_cos)
            params.tx:set(-text_offset * roll_cos - pitch_diff * roll_sin)
            params.ty:set(pitch_diff * roll_cos - text_offset * roll_sin)
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

    update_heading_lines()
    update_pitch_lines()
end
