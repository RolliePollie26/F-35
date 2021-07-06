dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."Systems/electric_system_api.lua")

local update_time_step = 0.01
make_default_activity(update_time_step)

local sensor_data = get_base_data()

local rate_met2knot = 0.539956803456
local ias_knots = 0 -- * rate_met2knot

local fmt = '%.2f'

local slat_pos
local SLATS_STATE = 0
local SLATS_TARGET = 0

local dev = GetSelf()

function post_initialize()
    local birth = LockOn_Options.init_conditions.birth_place
end

function getIASKnots()
    ias_knots = sensor_data.getIndicatedAirSpeed() * 3.6 * rate_met2knot
    --print_message_to_user("ISA:")
    --print_message_to_user(ias_knots)
    --print_message_to_user("SLAT_POS:")
    slat_pos = sensor_data.getFlapsPos()
    SLATS_STATE = tonumber(string.format(fmt,slat_pos))
    --print_message_to_user(slat_pos)
end

function SetCommand(command,value)
end

function update()
    getIASKnots()
    if (ias_knots < 240 and ias_knots > 160) then
        SLATS_TARGET = 1 - (ias_knots - 160)/80
        SLATS_TARGET = tonumber(string.format(fmt, SLATS_TARGET))
    elseif (ias_knots > 40 and ias_knots <= 160) then
        SLATS_TARGET = 1
    else
        SLATS_TARGET = 0
    end

    if (SLATS_TARGET == SLATS_STATE) then
    elseif (SLATS_STATE > SLATS_TARGET) then
        SLATS_STATE = SLATS_STATE - 0.01
        set_aircraft_draw_argument_value(9,SLATS_STATE)
        set_aircraft_draw_argument_value(10,SLATS_STATE)
        set_aircraft_draw_argument_value(13,SLATS_STATE)
        set_aircraft_draw_argument_value(14,SLATS_STATE)
    elseif (SLATS_TARGET > SLATS_STATE) then
        SLATS_STATE = SLATS_STATE + 0.01
        set_aircraft_draw_argument_value(9,SLATS_STATE)
        set_aircraft_draw_argument_value(10,SLATS_STATE)
        set_aircraft_draw_argument_value(13,SLATS_STATE)
        set_aircraft_draw_argument_value(14,SLATS_STATE)
    end
end

need_to_be_closed = false