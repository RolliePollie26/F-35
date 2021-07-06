start_custom_command   = 10000
local __count_custom = start_custom_command-1
local function __custom_counter()
	__count_custom = __count_custom + 1
	return __count_custom
end

count = 10000
device_commands =
{
	BATT28v 		= __custom_counter(), -- 10001
	BATT270v 		= __custom_counter(), -- 10002
	BattSwitch 		= __custom_counter(), -- 10003
	IPPSwitch		= __custom_counter(), -- 10004
	ICC1			= __custom_counter(), -- 10005
	ICC2			= __custom_counter(), -- 10006

	ParkingBrake	= __custom_counter(), -- 10007

	StrobeLt		= __custom_counter(), -- 10008
	NavLt			= __custom_counter(), -- 10009
	FormLt			= __custom_counter(), -- 10010
	floodLt			= __custom_counter(), -- 10011

	HMDPwr			= __custom_counter(), -- 10012
	MFDPwr			= __custom_counter(), -- 10013
	MFDBrt			= __custom_counter(), -- 10014

	ENGIgn			= __custom_counter(), -- 10015
	ENGStart		= __custom_counter(), -- 10016

	HMDSensorView	= __custom_counter(), -- 10017
	HMDPower		= __custom_counter(), -- 10018
	SensorPower		= __custom_counter(), -- 10019

	WeaponsBay		= __custom_counter(), -- 10020
	EngineCovers	= __custom_counter(), -- 10021

}

EFM_commands =
{
	increaseVTOL = 3010,
	decreaseVTOL = 3011,
	ParkBrake = 3012,
	toggleAPU = 3013,
}

start_command   = 5000
local __count_click = start_command-1
local function __click_counter()
	__count_click = __count_click + 1
	return __count_click
end


click_cmd =
{
    GearLevel = __click_counter(),
    FlapLever = __click_counter(),
}