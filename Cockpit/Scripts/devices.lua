local count = 0
local function counter()
	count = count + 1
	return count
end
-------DEVICE ID----------
devices = {}
devices["COCKPIT"]					= counter()
devices["ELECTRIC_SYSTEM"] 			= counter()
--devices["FW135PW100"] 				= counter()
--devices["LANDING_GEAR"]				= counter()
--devices["CANOPY"]					= counter()
--devices["FCS"]						= counter()
devices["HMD"]						= counter()
devices["INTERCOM"]					= counter()
devices["RADIO"]					= counter()
devices["NVG"]						= counter()
--devices["BRAKES"]					= counter()
--devices["HUD"]					= counter()
--devices["MFD"]					= counter()
--devices["ADI"]					= counter()
--devices["EFM"]					= counter()
--devices["WEAPONS"]				= counter()
--devices["RWR"]					= counter()