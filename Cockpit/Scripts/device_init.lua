dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.common_script_path.."tools.lua")
dofile(LockOn_Options.script_path.."materials.lua")

MainPanel = {"ccMainPanel",LockOn_Options.script_path.."mainpanel_init.lua"}

creators  = {}
creators[devices.COCKPIT]           = {"avLuaDevice",               LockOn_Options.script_path.."ccCockpit.lua"}
creators[devices.ELECTRIC_SYSTEM]   = {"avLuaDevice",               LockOn_Options.script_path.."Airframe/ElectricSystem.lua"}
creators[devices.FW135PW100]        = {"avLuaDevice",               LockOn_Options.script_path.."Airframe/FW135PW100.lua"}
creators[devices.LANDING_GEAR]      = {"avLuaDevice",               LockOn_Options.script_path.."Airframe/LandingGear.lua"}
creators[devices.CANOPY]            = {"avLuaDevice",               LockOn_Options.script_path.."Airframe/Canopy.lua"}
creators[devices.FCS]               = {"avLuaDevice",               LockOn_Options.script_path.."Airframe/FCS.lua"}
creators[devices.HMD]               = {"avLuaDevice",               LockOn_Options.script_path.."HMD/Device/device.lua"}
creators[devices.INTERCOM]          = {"avIntercom"}
creators[devices.RADIO]             = {"avUHK_ARC_164"}
creators[devices.NVG]               = {"avNightVisionGoggles"}

-- Indicators
indicators = {}
indicators[#indicators + 1] = {"ccIndicator",LockOn_Options.script_path.."HMD/Indicator/init.lua",nil}