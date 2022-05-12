dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."Airframe/ElectricSystem.lua")

--[[ package.cpath = package.cpath..";"..LockOn_Options.script_path.."../../bin/?.dll"
protect = require "F35Cockpit" ]]

local dev = GetSelf()
local sensor_data = get_base_data()

local update_time_step = 0.02
make_default_activity(update_time_step)

local math = 
            {  
                ias_conversion_to_knots = 1.9504132,
                ias_conversion_to_kmh = 3.6,
                DEGREE_TO_RAD = 0.0174532925199433,
                RADIANS_TO_DEGREES = 57.29577951308233,
                METERS_TO_INCHES = 3.2808,
}

local ccParameters = 
                    {
                        ccInit = get_param_handle("ccInit"),
                        ID_U_UID = get_param_handle("ID_U_UID"),
                        ID_U_USER = get_param_handle("ID_U_USER"),
                        ID_U_BUILD = get_param_handle("ID_U_BUILD"),
                        ID_U_VER = get_param_handle("ID_U_VER"),
                        BATT = get_param_handle("BATT"),
                        ALT = get_param_handle("ALT"),
                        RALT = get_param_handle("RALT"),
                        RPM = get_param_handle("RPM"),
                        FF = get_param_handle("FF"),
                        EGT = get_param_handle("EGT"),
                        MCAUT = get_param_handle("MCAUT"),
                        STALL = get_param_handle("STALL"),
                        PULLUP = get_param_handle("PULLUP"),
                        ROLL = get_param_handle("ROLL"),
                        PITCH = get_param_handle("PITCH"),
                        YAW = get_param_handle("YAW"),
                        SPDBRK = get_param_handle("SPDBRK"),
                        AOA = get_param_handle("AOA"),
                        AOS = get_param_handle("AOS"),
                        ACCEL = get_param_handle("ACCEL"),
                        VSPD = get_param_handle("VSPD"),
                        SPEED = get_param_handle("SPEED"),
                        HDG = get_param_handle("HDG"),
                        MHDG = get_param_handle("MHDG"),
                        MACH = get_param_handle("MACH"),
                        GS = get_param_handle("GS"),
                        WARNALT = get_param_handle("WARNALT"),
                        WARNOVERG = get_param_handle("WARNOVERG"),
                        WEAPONBAY = get_param_handle("WEAPONBAY"),
                        BAYDOORS = get_param_handle("BAYDOORS"),
                        CHOCKS = get_param_handle("CHOCKS"),
                        COVERS = get_param_handle("COVERS"),
                        HUDPWR = get_param_handle("HUD_PWR"),
                        AAMODE = get_param_handle("AA_MODE"),
                        AGMODE = get_param_handle("AG_MODE"),
}

local WeaponsBay = 0
local Chocks = 0
local Covers = 0

dev:listen_command(10020)
dev:listen_event("WheelChocksOn")
dev:listen_event("WheelChocksOff")

function post_initialize()
    local birth = LockOn_Options.init_conditions.birth_place
    if birth == "GROUND_HOT" or birth == "AIR_HOT" then
        ccParameters.WEAPONBAY:set(0)
        WeaponsBay = 0
    elseif birth == "GROUND_COLD" then
        ccParameters.WEAPONBAY:set(1)
        WeaponsBay = 1
    end

    ccParameters.ccInit:set(1)
    ccParameters.WARNALT:set(0)
    ccParameters.WARNOVERG:set(0)
    audioHost = create_sound_host("audioHost","2D",0,0,0)
    pullUP = audioHost:create_sound("Aircrafts/F-35/Cockpit/pullUP")
    altWarn = audioHost:create_sound("Aircrafts/F-35/Cockpit/altitude")
    overG = audioHost:create_sound("Aircrafts/F-35/Cockpit/overG")
    masterCaution = audioHost:create_sound("Aircrafts/F-35/Cockpit/masterCaution")
    stallWarn = audioHost:create_sound("Aircrafts/F-35/Cockpit/stallWarn")
    avionics = audioHost:create_sound("Aircrafts/F-35/Cockpit/avionics")
    print_message_to_user("COCKPIT INIT")
    print_message_to_user("COMMUNITY F-35A LIGHTNING II\nDEVELOPED BY NO-STOP PRODUCTIONS\nVERSION 1.0.0.2\nDEVELOPMENT BUILD\nDO NOT REDISTRIBUTE")
end

function SetCommand(command,value)
    if command == 10020 and ccParameters.BATT:get() == 0 and WeaponsBay == 0 and ccParameters.WEAPONBAY:get() == 0 then
        ccParameters.WEAPONBAY:set(0)
        WeaponsBay = 0
        print_message_to_user("Must Turn On Battery")
    elseif command == 10020 and ccParameters.BATT:get() == 0 and WeaponsBay == 1 and ccParameters.WEAPONBAY:get() == 1 then
        ccParameters.WEAPONBAY:set(1)
        WeaponsBay = 1
        print_message_to_user("Must Turn On Battery")
    elseif command == 10020 and ccParameters.BATT:get() == 1 and WeaponsBay == 0 and ccParameters.WEAPONBAY:get() == 0 then
        ccParameters.WEAPONBAY:set(1)
        WeaponsBay = 1
        print_message_to_user("Weapons Bay OPEN")
    elseif command == 10020 and ccParameters.BATT:get() == 1 and WeaponsBay == 1 and ccParameters.WEAPONBAY:get() == 1 then
        ccParameters.WEAPONBAY:set(0)
        WeaponsBay = 0
        print_message_to_user("Weapons Bay CLOSED")
    end
end

function updateWeaponBay()
    local BayStatus = ccParameters.BAYDOORS:get()

    if (WeaponsBay == 0 and BayStatus > 0) then
        BayStatus = BayStatus - 0.01
        set_aircraft_draw_argument_value(26,BayStatus)
        ccParameters.BAYDOORS:set(BayStatus)
    elseif (WeaponsBay == 1 and BayStatus < 1) then
        BayStatus = BayStatus + 0.01
        set_aircraft_draw_argument_value(26,BayStatus)
        ccParameters.BAYDOORS:set(BayStatus)
    end
end

function update()
    updateWeaponBay()
    ccParameters.ID_U_UID:set("xXxXxXxXxX")
    ccParameters.ID_U_USER:set("ID_U_USER")
    ccParameters.ID_U_BUILD:set("1.0.0.4")
    ccParameters.ID_U_VER:set("WORK IN PROGRESS")
    ccParameters.ALT:set(sensor_data.getBarometricAltitude() * math.METERS_TO_INCHES)
    ccParameters.RALT:set(sensor_data.getRadarAltitude() * math.METERS_TO_INCHES)
    ccParameters.RPM:set(sensor_data.getEngineLeftRPM())
    ccParameters.FF:set(sensor_data.getEngineLeftFuelConsumption())
    ccParameters.EGT:set(sensor_data.getEngineLeftTemperatureBeforeTurbine())
    ccParameters.ROLL:set(sensor_data.getRoll())
    ccParameters.PITCH:set(-sensor_data.getPitch())
    ccParameters.SPDBRK:set(sensor_data.getSpeedBrakePos())
    ccParameters.AOA:set(sensor_data.getAngleOfAttack() * math.RADIANS_TO_DEGREES)
    ccParameters.AOS:set(sensor_data.getAngleOfSlide())
    ccParameters.ACCEL:set(sensor_data.getVerticalAcceleration())
    ccParameters.VSPD:set(sensor_data.getVerticalVelocity())
    ccParameters.SPEED:set(sensor_data.getIndicatedAirSpeed() * math.ias_conversion_to_knots)
    ccParameters.HDG:set(sensor_data.getHeading() * math.RADIANS_TO_DEGREES)
    ccParameters.MHDG:set(sensor_data.getMagneticHeading() * math.RADIANS_TO_DEGREES)
    ccParameters.MACH:set(sensor_data.getMachNumber())

    if get_aircraft_draw_argument_value(0) < 1 and ccParameters.RALT:get() < 50 then
        altWarn:play_continue()
        ccParameters.WARNALT:set(1)
    else
        altWarn:stop()
        ccParameters.WARNALT:set(0)
    end

    if ccParameters.ACCEL:get() > 5 then
        overG:play_continue()
        ccParameters.WARNOVERG:set(1)
    else
        overG:stop()
        ccParameters.WARNOVERG:set(0)
    end

    if get_aircraft_draw_argument_value(0) < 1 and ccParameters.SPEED:get() < 80 then
        stallWarn:play_continue()
        ccParameters.STALL:set(1)
        print_message_to_user("STALL WARNING")
    else
        stallWarn:stop()
        ccParameters.STALL:set(0)
    end

    if ccParameters.BATT:get() == 1 then
        avionics:play_continue()
        Covers = 0
    else
        avionics:stop()
        Covers = 1
    end

    set_aircraft_draw_argument_value(23,Chocks)
    set_aircraft_draw_argument_value(24,Covers)
end

function CockpitEvent(event, val)
    if event == "WheelChocksOn" then
        Chocks = 1
    elseif event == "WheelChocksOff" then
        Chocks = 0
    end
end
