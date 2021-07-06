shape_name   	   = "Cockpit_F-35"
is_EDM			   = true
new_model_format   = true
ambient_light    = {255,255,255}
ambient_color_day_texture    = {72, 100, 160}
ambient_color_night_texture  = {40, 60 ,150}
ambient_color_from_devices   = {50, 50, 40}
ambient_color_from_panels	 = {35, 25, 25}

dusk_border					 = 0.4
draw_pilot					 = false

external_model_canopy_arg	 = 38

use_external_views = false

day_texture_set_value   = 0.0
night_texture_set_value = 0.1

local controllers = LoRegisterPanelControls()

StickBank							= CreateGauge()
StickBank.arg_number				= 1
StickBank.input						= {-100, 100}
StickBank.output					= {-1, 1}
StickBank.controller				= controllers.base_gauge_StickRollPosition

StickPitch							= CreateGauge()
StickPitch.arg_number				= 2
StickPitch.input					= {-100, 100}
StickPitch.output					= {-1, 1}
StickPitch.controller				= controllers.base_gauge_StickPitchPosition

Throttle							= CreateGauge()
Throttle.arg_number					= 3
Throttle.input						= {0, 100}
Throttle.output						= {0, 100}
Throttle.controller					= controllers.base_gauge_ThrottleLeftPosition

PedalYaw							= CreateGauge()
PedalYaw.arg_number					= 4
PedalYaw.input						= {-100, 100}
PedalYaw.output						= {-1, 1}
PedalYaw.controller					= controllers.base_gauge_RudderPosition

Canopy							    = CreateGauge("parameter")
Canopy.parameter_name               = "CANOPY_INSIDE"
Canopy.arg_number				    = 38
Canopy.input						= {0, 100}
Canopy.output					    = {0, 100}

BATT_28V                            = CreateGauge("parameter")
BATT_28V.parameter_name             = "BATT_28V"
BATT_28V.arg_number                 = 12
BATT_28V.input                      = {0, 1}
BATT_28V.output                     = {0, 1}

BATT_270V                           = CreateGauge("parameter")
BATT_270V.parameter_name            = "BATT_270V"
BATT_270V.arg_number                = 13
BATT_270V.input                     = {0, 1}
BATT_270V.output                    = {0, 1}

BATT                                = CreateGauge("parameter")
BATT.parameter_name                 = "BATT"
BATT.arg_number                     = 14
BATT.input                          = {0, 1}
BATT.output                         = {0, 1}

IPP                                 = CreateGauge("parameter")
IPP.parameter_name                  = "IPP"
IPP.arg_number                      = 15
IPP.input                           = {0, 1}
IPP.output                          = {0, 1}

LANDING_GEAR                        = CreateGauge("parameter")
LANDING_GEAR.parameter_name         = "LANDING_GEAR"
LANDING_GEAR.arg_number             = 5
LANDING_GEAR.input                  = {0, 1}
LANDING_GEAR.output                 = {0, 1}

ICC_1                               = CreateGauge("parameter")
ICC_1.parameter_name                = "ICC_1"
ICC_1.arg_number                    = 11
ICC_1.input                         = {0, 1}
ICC_1.output                        = {0, 1}

ICC_2                               = CreateGauge("parameter")
ICC_2.parameter_name                = "ICC_2"
ICC_2.arg_number                    = 10
ICC_2.input                         = {0, 1}
ICC_2.output                        = {0, 1}

IGNITION                            = CreateGauge("parameter")
IGNITION.parameter_name             = "IGNITION"
IGNITION.arg_number                 = 17
IGNITION.input                      = {0, 1}
IGNITION.output                     = {0, 1}

ParkingBrake                        = CreateGauge("parameter")
ParkingBrake.parameter_name         = "ParkingBrake"
ParkingBrake.arg_number             = 19
ParkingBrake.input                  = {0, 1}
ParkingBrake.output                 = {0, 1}

need_to_be_closed = false

--[[ available functions 

 --base_gauge_RadarAltitude
 --base_gauge_BarometricAltitude
 --base_gauge_AngleOfAttack
 --base_gauge_AngleOfSlide
 --base_gauge_VerticalVelocity
 --base_gauge_TrueAirSpeed
 --base_gauge_IndicatedAirSpeed
 --base_gauge_MachNumber
 --base_gauge_VerticalAcceleration --Ny
 --base_gauge_HorizontalAcceleration --Nx
 --base_gauge_LateralAcceleration --Nz
 --base_gauge_RateOfRoll
 --base_gauge_RateOfYaw
 --base_gauge_RateOfPitch
 --base_gauge_Roll
 --base_gauge_MagneticHeading
 --base_gauge_Pitch
 --base_gauge_Heading
 --base_gauge_EngineLeftFuelConsumption
 --base_gauge_EngineRightFuelConsumption
 --base_gauge_EngineLeftTemperatureBeforeTurbine
 --base_gauge_EngineRightTemperatureBeforeTurbine
 --base_gauge_EngineLeftRPM
 --base_gauge_EngineRightRPM
 --base_gauge_WOW_RightMainLandingGear
 --base_gauge_WOW_LeftMainLandingGear
 --base_gauge_WOW_NoseLandingGear
 --base_gauge_RightMainLandingGearDown
 --base_gauge_LeftMainLandingGearDown
 --base_gauge_NoseLandingGearDown
 --base_gauge_RightMainLandingGearUp
 --base_gauge_LeftMainLandingGearUp
 --base_gauge_NoseLandingGearUp
 --base_gauge_LandingGearHandlePos
 --base_gauge_StickRollPosition
 --base_gauge_StickPitchPosition
 --base_gauge_RudderPosition
 --base_gauge_ThrottleLeftPosition
 --base_gauge_ThrottleRightPosition
 --base_gauge_HelicopterCollective
 --base_gauge_HelicopterCorrection
 --base_gauge_CanopyPos
 --base_gauge_CanopyState
 --base_gauge_FlapsRetracted
 --base_gauge_SpeedBrakePos
 --base_gauge_FlapsPos
 --base_gauge_TotalFuelWeight

--]]