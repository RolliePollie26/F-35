dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."Airframe/ElectricSystem.lua")
dofile[[Scripts\socket.lua]]
local gettime = socket.gettime

local dev = GetSelf()
local sensor_data = get_base_data()

local update_time_step = 0.001
make_default_activity(update_time_step)

local IPPparams = {
            pct = get_param_handle("IPP_PCT"),
            spool = 5.4,
            spool_start = nil,
}

local IPP = get_param_handle("IPP")
BATT = get_param_handle("BATT")

IPP:set(0)
local IPP_STATE = IPP_OFF
local IPP_OFF = 1
local IPP_STARTING = 0
local IPP_RUNNING = 0

local IGNITION = 0
local ENG_STATE = OFF
local ENG_START = 0
local ENG_RUN = 1
local ENG_OFF = 0
local IDLE_STOP = 0
local ICC_1 = get_param_handle("ICC_1")
local ICC_2 = get_param_handle("ICC_2")
local IGNITION = get_param_handle("IGNITION")
ICC_1:set(0)
ICC_2:set(0)
IGNITION:set(0)

local startButtonFlag = 0
local startCounter = 0
local startIsDone = 0

dev:listen_command(device_commands.IPPSwitch)
dev:listen_command(device_commands.ICC1)
dev:listen_command(device_commands.ICC2)
dev:listen_command(device_commands.ENGIgn)
dev:listen_command(device_commands.ENGStart)

function createExternal(sound_host, sdef_name)
    return sound_host:create_sound("Aircrafts/F-35/Cockpit/" .. sdef_name)
end
function playSoundOnce(sound)
    if sound then
        if sound:is_playing() then 
            sound:stop() 
        end        
        sound:play_once()
    end    
end
function stopSound(sound)    
    if sound and sound:is_playing() then
        sound:stop()        
    end    
end
function createExternalLoop(sound_host, start_sound_length, sdef_name_start, sdef_name_loop, sdef_name_end)
    start_length_ = start_sound_length or 0
    
    if sdef_name_start then
        sound_start_ = createExternal(sound_host, sdef_name_start)
    else
        sound_start_ = nil
    end
    
    sound_loop_ = createExternal(sound_host, sdef_name_loop)
    
    if sdef_name_end then
        sound_end_ = createExternal(sound_host, sdef_name_end)
    else
        sound_end_ = nil
    end    
    
    return {
        startLength = start_length_,
        timePlaying = 0,
        isPlaying = false,
        sound_start = sound_start_,
        sound_loop = sound_loop_,
        sound_end = sound_end_,
    }
end   

function post_initialize()
    sndhost = create_sound_host("IPP","3D",0,-4.0,0)
    sndStartIPP = sndhost:create_sound("Aircrafts/F-35/Cockpit/IPP_START")
    sndRunIPP = sndhost:create_sound("Aircrafts/F-35/Cockpit/IPP_RUN")
    sndStopIPP = sndhost:create_sound("Aircrafts/F-35/Cockpit/IPP_STOP")
    local throttle = sensor_data.getThrottleLeftPosition()

    local birth = LockOn_Options.init_conditions.birth_place
    if birth == "GROUND_HOT" or birth == "AIR_HOT" then
        IPP:set(0)
        IPP_STATE = IPP_OFF
        ENG_STATE = RUNNING
        IGNITION:set(1)
        ENG_START = 1
        ICC_1:set(1)
        ICC_2:set(1)
    elseif birth == "GROUND_COLD" then
        IPP:set(0)
        IPP_STATE = IPP_OFF
        ENG_STATE = OFF
        IGNITION:set(0)
        ENG_START = 0
        ICC_1:set(0)
        ICC_2:set(0)
    end
    print_message_to_user("FW135PW100 INIT")
end

function SetCommand(command,value)
   --[[  if command == device_commands.IPPSwitch then
        IPPparams.spool_start = gettime()
    end ]]
    if command == device_commands.IPPSwitch and BATT:get() == 0 and IPP:get() == 0 and IPP_STATE == IPP_OFF then
        IPP:set(0)
        IPP_STATE = IPP_OFF
        print_message_to_user("NO BATTERY POWER, IPP CANNOT START")
    elseif command == device_commands.IPPSwitch and BATT:get() == 1 and IPP:get() == 0 and IPP_STATE == IPP_OFF then
        IPP:set(1)
        IPP_STATE = IPP_RUNNING
        IPP_STARTING = 1
        startButtonFlag = 1
        sndStartIPP:play_once()
        sndRunIPP:play_continue()
        print_message_to_user("IPP STARTING")
    elseif command == device_commands.IPPSwitch and BATT:get() == 1 and IPP:get() == 1 and IPP_STATE == IPP_RUNNING then
        IPP:set(0)
        IPP_STATE = IPP_OFF
        IPP_STARTING = 0
        sndRunIPP:stop()
        sndStopIPP:play_once()
        if (startButtonFlag == 1) then
            startButtonFlag = 0
            startCounter = 0
            startIsDone = 0
        end
        print_message_to_user("IPP SHUTTING DOWN")
    end

    if command == device_commands.ICC1 and ICC_1:get() == 0 then
        ICC_1:set(1)
        --print_message_to_user("ICC 1 ON")
    elseif command == device_commands.ICC1 and ICC_1:get() == 1 then
        ICC_1:set(0)
        --print_message_to_user("ICC 1 OFF")
    end

    if command == device_commands.ICC2 and ICC_2:get() == 0 then
        ICC_2:set(1)
        --print_message_to_user("ICC 2 ON")
    elseif command == device_commands.ICC2 and ICC_2:get() == 1 then
        ICC_2:set(0)
        --print_message_to_user("ICC 2 OFF")
    end

    if command == device_commands.ENGIgn and IGNITION:get() == 0 then
        IGNITION:set(1)
        --print_message_to_user("IGNITION ON")
    elseif command == device_commands.ENGIgn and IGNITION:get() == 1 then
        IGNITION:set(0)
        --print_message_to_user("IGNITION OFF")
    end

    if command == device_commands.ENGStart and IGNITION:get() == 1 and ICC_1:get() == 1 and ICC_2:get() == 1 and IPP:get() == 1 then
        ENG_STATE = STARTING
        ENG_START = 1
        ENG_RUN = 0
        ENG_OFF = 0
        dispatch_action(nil,309)
        --print_message_to_user("ENGINE STARTING")
    elseif command == device_commands.ENGStart and IGNITION:get() == 1 and ICC_1:get() == 1 and ICC_2:get() == 1 and IPP:get() == 0 then
        ENG_STATE = OFF
        ENG_START = 0
        ENG_RUN = 0
        ENG_OFF = 1
        print_message_to_user("CANNOT START ENGINE. IPP NOT RUNNING!")
    elseif command == device_commands.ENGStart and IGNITION:get() == 1 and ICC_1:get() == 1 and ICC_2:get() == 0 and IPP:get() == 1 then
        ENG_STATE = OFF
        ENG_START = 0
        ENG_RUN = 0
        ENG_OFF = 1
        print_message_to_user("CANNOT START ENGINE. ICC 2 IS NOT ON!")
    elseif command == device_commands.ENGStart and IGNITION:get() == 1 and ICC_1:get() == 0 and ICC_2:get() == 1 and IPP:get() == 1 then
        ENG_STATE = OFF
        ENG_START = 0
        ENG_RUN = 0
        ENG_OFF = 1
        print_message_to_user("CANNOT START ENGINE. ICC 1 IS NOT ON!")
    elseif command == device_commands.ENGStart and IGNITION:get() == 0 and ICC_1:get() == 1 and ICC_2:get() == 1 and IPP:get() == 1 then
        ENG_STATE = OFF
        ENG_START = 0
        ENG_RUN = 0
        ENG_OFF = 1
        print_message_to_user("CANNOT START ENGINE. IGNITION IS NOT ON!")
    elseif command == device_commands.ENGStart and IGNITION:get() == 0 and ICC_1:get() == 0 and ICC_2:get() == 1 and IPP:get() == 1 then
        ENG_STATE = OFF
        ENG_START = 0
        ENG_RUN = 0
        ENG_OFF = 1
        print_message_to_user("CANNOT START ENGINE. IGNITION AND ICC 1 ARE NOT ON!")
    elseif command == device_commands.ENGStart and IGNITION:get() == 0 and ICC_1:get() == 0 and ICC_2:get() == 0 and IPP:get() == 1 then
        ENG_STATE = OFF
        ENG_START = 0
        ENG_RUN = 0
        ENG_OFF = 1
        print_message_to_user("CANNOT START ENGINE. IGNITION, ICC 1 and ICC 2 ARE NOT ON!")
    elseif command == device_commands.ENGStart and IGNITION:get() == 0 and ICC_1:get() == 0 and ICC_2:get() == 0 and IPP:get() == 0 then
        ENG_STATE = OFF
        ENG_START = 0
        ENG_RUN = 0
        ENG_OFF = 1
        print_message_to_user("CANNOT START ENGINE. IGNITION, ICC 1, ICC 2 AND IPP ARE NOT ON!")
    end
end

function update()
--[[     if IPPparams.spool_start == nil then
        return
    end
    IPPparams.pct:set(max((gettime() - IPPparams.spool_start)/IPPparams.spool), 1)

    if (IPPparams.pct:get() < 1) then
        sndStartIPP.play_continue()
    end

    print_message_to_user(IPPparams.pct:get())
 ]]
    local ipp_clickable_ref = get_clickable_element_reference("PNT_IPP")

    ipp_clickable_ref:update()
end

--[[ spool_pct_value = CreateElement "ceTexPoly"
spool_pct_value.material = "mfd_font"
spool_pct_value.value = "%.2f"
spool_pct_value.controller = {{"text_using_parameter", 0}}
spool_pct_value.element_controllers = {"IPP_PCT"}

main_mfd = CreateElement "ceTexPoly"
main_mfd.material = "black"
main_mfd.controller = {{"parameter_in_range", 0, 0.95, 1.05}}
main_mfd.element_controllers = {"IPP_PCT"} ]]