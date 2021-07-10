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
        local hdg_diff = math.deg(math.rad(i) - hdg)
        -- Normalize hdg_diff to between -PI and PI
        while hdg_diff > 180 do
            hdg_diff = hdg_diff - 360
        end
        while hdg_diff < -180 do
            hdg_diff = hdg_diff + 360
        end
        if math.abs(hdg_diff) > 25 then
            -- Hide ticks and text where it is out of bounds
            params.o:set(0)
            params.to:set(0)
        else
            params.x:set(hdg_diff)
            params.o:set(hmd_pwr)
            if math.abs(hdg_diff) < 6 then
                -- Hide tick text where it would interfere with heading indicator
                params.to:set(0)
            else
                params.tx:set(hdg_diff)
                params.to:set(hmd_pwr)
            end
        end
    end
end

-- We have to manually calculate the way pitch lines (and their text)
-- move and rotate when the plane rotates
local FPM_X = get_param_handle("FPM_X")
local FPM_Y = get_param_handle("FPM_Y")
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
    local pitch = sensor_data:getPitch()
    local roll = sensor_data.getRoll()
    local roll_cos = math.cos(roll)
    local roll_sin = math.sin(roll)
    local speedx, speedy, speedz = sensor_data:getSelfVelocity()
    local speedh=math.sqrt(speedx*speedx + speedz*speedz)
    local anglev
    if speedh == 0 then
        anglev = 0
    else
        anglev = math.atan(speedy/speedh)
    end
    anglev = anglev - pitch
    local iasx, iasy, iasz = sensor_data.getSelfAirspeed()
    local angleh = math.atan2(iasz, iasx) - math.atan2(speedz, speedx)
    angleh = math.rad(sensor_data.getAngleOfSlide())-angleh

    fpm_x = math.deg(angleh * roll_cos - anglev * roll_sin)
    fpm_y = math.deg(anglev * roll_cos + angleh * roll_sin)
    FPM_X:set(fpm_x)
    FPM_Y:set(fpm_y)

    for i,params in pairs(PITCH_LINE_PARAMS) do
        local pitch_diff = math.deg(-pitch - math.rad(-i))
        if pitch_diff > 8 or pitch_diff < -12 then
            -- Hide pitch lader outside expected region
            params.o:set(0)
        else
            local text_offset
            if i > 0 then
                text_offset = 3.75
            else
                text_offset = 3.25
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

local TGT_X = get_param_handle("TGT_X")
local TGT_Y = get_param_handle("TGT_Y")
local TGT_O = get_param_handle("TGT_O")
function update_target_marker()
    -- Hard-coded to north-west "13" on Batumi runway
    local t_pos = geo_to_lo_coords(41.615831, 41.590797)
    local t_elev = 10.5

    local lx, ly, lz = sensor_data.getSelfCoordinates()

    local dx = t_pos.x - lx
    local dy = t_elev - ly
    local dz = t_pos.z - lz
    local t_dist = math.sqrt(math.pow(dx, 2) + math.pow(dy, 2) + math.pow(dz, 2))
    local t_pitch = math.asin(dy / t_dist)
    local t_hdg = math.atan2(dz / t_dist, dx / t_dist)
    t_pitch = math.deg(t_pitch)
    t_hdg = math.deg(t_hdg)

    local hdg = math.deg(2.0 * math.pi - sensor_data.getHeading())
    local pitch = math.deg(-sensor_data.getPitch())
    local roll = sensor_data.getRoll()
    local roll_cos = math.cos(roll)
    local roll_sin = math.sin(roll)

    local hdg_diff = t_hdg - hdg
    -- Normalize hdg_diff to between -PI and PI
    while hdg_diff > 180 do
        hdg_diff = hdg_diff - 360
    end
    while hdg_diff < -180 do
        hdg_diff = hdg_diff + 360
    end

    local pitch_diff = pitch + t_pitch

    TGT_X:set(hdg_diff * roll_cos - pitch_diff * roll_sin)
    TGT_Y:set(pitch_diff * roll_cos + hdg_diff * roll_sin)
    TGT_O:set(0) -- SET TO 1 TO VIEW TARGET
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
    update_target_marker()
end
