dofile(LockOn_Options.script_path.."command_defs.lua")

local update_time_step = 0.01
make_default_activity(update_time_step)

local sensor_data = get_base_data()

local rate_met2knot = 0.539956803456
local ias_knots = 0 -- * rate_met2knot

local fmt = '%.2f'

local air_brake_state
local air_brake_pos = 0

local Airbrake  = 73
local AirbrakeOn = 147
local AirbrakeOff = 148

local slat_pos
local SLATS_STATE = 0
local SLATS_TARGET = 0

local dev = GetSelf()

dev:listen_command(Airbrake)
dev:listen_command(AirbrakeOn)
dev:listen_command(AirbrakeOff)

function post_initialize()
    air_brake_state = 0
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
    if (command == Airbrake) then
        if (air_brake_state == 0) then
            air_brake_state = 1
        elseif (air_brake_state == 1) then
            air_brake_state = 0
        end
    elseif (command == AirbrakeOn) then
        air_brake_state = 1
    elseif (command == AirbrakeOff) then
        air_brake_state = 0
    end
end

function update()
    air_brake_pos = tonumber(string.format(fmt, air_brake_pos))

    if (air_brake_pos < air_brake_state) then
        air_brake_pos = air_brake_pos + 0.01
        set_aircraft_draw_argument_value(21, air_brake_pos)
    elseif (air_brake_pos > air_brake_state) then
        air_brake_pos = air_brake_pos - 0.01
        set_aircraft_draw_argument_value(21, air_brake_pos)
    elseif (air_brake_pos == air_brake_state) then
        set_aircraft_draw_argument_value(21, air_brake_pos)
    end

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

    --Test set anim argument

	local ROLL_STATE = sensor_data:getStickPitchPosition() / 100
	set_aircraft_draw_argument_value(11, ROLL_STATE) -- right aileron
    set_aircraft_draw_argument_value(12, -ROLL_STATE) -- left aileron
    --set_aircraft_draw_argument_value(9, ROLL_STATE) -- right slat
	--set_aircraft_draw_argument_value(10, -ROLL_STATE) -- left slat
	

	local PITCH_STATE = sensor_data:getStickRollPosition() / 100
	set_aircraft_draw_argument_value(15, PITCH_STATE + ROLL_STATE) -- right canard
	set_aircraft_draw_argument_value(16, PITCH_STATE + -ROLL_STATE) -- left canard
    set_aircraft_draw_argument_value(19, PITCH_STATE)
    set_aircraft_draw_argument_value(20, PITCH_STATE)

	local RUDDER_STATE = sensor_data:getRudderPosition() / 100
    set_aircraft_draw_argument_value(17, -RUDDER_STATE)
    set_aircraft_draw_argument_value(18, -RUDDER_STATE)
	
	if (get_aircraft_draw_argument_value(0) > 0.5) then
		set_aircraft_draw_argument_value(2, -RUDDER_STATE*0.666) -- limit visual nosewheel deflection to 30 degrees
	else
		set_aircraft_draw_argument_value(2, 0)
	end
	--print(ROLL_STATE)
	--print(PITCH_STATE)
end

need_to_be_closed = false