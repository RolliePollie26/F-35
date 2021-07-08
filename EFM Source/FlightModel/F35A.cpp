//--------------------------------------------------------------------------
// IMPORTANT!  COORDINATE CONVENTION:
//
// DCS WORLD Convention:
// Xbody: Out the front of the nose
// Ybody: Out the top of the aircraft
// Zbody: Out the right wing
//
// Normal Aerodynamics/Control Convention:
// Xbody: Out the front of the nose
// Ybody: Out the right wing
// Zbody: Out the bottom of the aircraft
//
// This means that if you are referincing from any aerodynamic, stabilty, or control document
// they are probably using the second set of directions.  Which means you always need to switch
// the Y and the Z and reverse the Y prior to output to DCS World
//---------------------------------------------------------------------------
// TODO List:
// -Make code more "object-oriented"...
// -Differential command into the pitch controller
// -Weight on wheels determination
// -Ground reaction modeling
// -Fix actuator dynamics
// -Improve look-up tables
// -Speed brake effects and control
//---------------------------------------------------------------------------
// KNOWN Issues:
// -On ground, the FCS controls flutter due to no filtering of alpha and Nz.
//  Need logic to determine when on ground (hackish right now) to zero those
//  signals out.
// -Aircraft naturally trims to 1.3g for some reason, need to apply -0.3 pitch
//  trim to get aircraft to trim at 1.0g for flight controller
// -> relaxed static stability (RSS) so as intended?
// -Actuators cause flutter at high speed due to filtering of sensor signals
//  Removed servo-dynamics until I can figure this out
// -> reduced unnecessary unit conversions and thus resulting rounding errors etc.
// -> fixed
// -Gear reaction happening but ground handling not modeled due to lack of available
//  API calls
// -> partially now
// -Gear automatically drops at 200ft to allow simple touch downs
//---------------------------------------------------------------------------
#include "stdafx.h"
#include "F35A.h"

// for debug use
#include <wchar.h>
#include <cstdio>

#include "ED_FM_Utility.h"		// Provided utility functions that were in the initial EFM example
#include "F35Constants.h"		// Common constants used throughout this DLL

#include "Inputs/F35Inputs.h"			// just list of inputs: can get potentially long list

// Model headers
#include "Atmosphere/F35Atmosphere.h"			//Atmosphere model functions
#include "Atmosphere/F35GroundSurface.h"
#include "Aerodynamics/F35Aero.h"				//Aerodynamic model functions

#include "Hydraulics/F35HydraulicSystem.h"
#include "FlightControls/F35FlightControlSystem.h"	//Flight Controls model functions

#include "Engine/F35EngineManagementSystem.h"
#include "Engine/F35Engine.h"					//Engine model functions
#include "Engine/F35FuelSystem.h"				//Fuel usage and tank usage functions

#include "LandingGear/F35LandingGear.h"			//Landing gear actuators, aerodynamic drag, wheelbrake function
#include "Airframe/F35Airframe.h"				//Canopy, dragging chute, refuel slot, section damages..
#include "Electrics/F35ElectricSystem.h"		//Generators, battery etc.
#include "EnvironmentalSystem/F35EnvControlSystem.h"	//Oxygen system, heating/cooling, G-suit, canopy sealing..

// physics integration
#include "EquationsOfMotion/F35EquationsOfMotion.h"


wchar_t dbgmsg[255] = {0};
//dbgmsg[0] = 0;


//-------------------------------------------------------
// Start of F-16 Simulation Variables
// Probably doesn't need it's own namespace or anything
// I just quickly did this to organize my F-16 specific
// variables, needs to be done better eventually
//-------------------------------------------------------
namespace F35
{
	double		longStickInputRaw = 0; // pitch orig (just for cockpit anim)
	double		latStickInputRaw = 0; // bank orig (just for cockpit anim)
	double		pedInputRaw = 0;	// yaw orig (just for cockpit anim)

	F35Atmosphere Atmos;
	F35GroundSurface Ground(&Atmos);
	F35Aero Aero(&Atmos, &Ground);
	F35FuelSystem Fuel;
	F35Airframe Airframe;
	F35EngineManagementSystem EMS(&Atmos, &Fuel);
	F35LandingGear LandingGear(&Atmos, &Ground);
	F35FlightControls FlightControls(&Atmos, &LandingGear, &Airframe);
	F35Motion Motion(&Atmos);
	F35HydraulicSystem Hydraulics;
	F35ElectricSystem Electrics;
	F35EnvControlSystem EnvCS(&Atmos);
}

// This is where the simulation send the accumulated forces to the DCS Simulation
// after each run frame
void ed_fm_add_local_force(double &x,double &y,double &z,double &pos_x,double &pos_y,double &pos_z)
{
	F35::Motion.getLocalForce(x, y, z, pos_x, pos_y, pos_z);
}

// Not used
void ed_fm_add_global_force(double & x,double &y,double &z,double & pos_x,double & pos_y,double & pos_z)
{

}

/* same but in component form , return value bool : function will be called until return value is true
while (ed_fm_add_local_force_component(x,y,z,pos_xpos_y,pos_z))
{
	--collect 
}
*/
bool ed_fm_add_local_force_component (double & x,double &y,double &z,double & pos_x,double & pos_y,double & pos_z)
{
	return false;
}
bool ed_fm_add_global_force_component (double & x,double &y,double &z,double & pos_x,double & pos_y,double & pos_z)
{
	return false;
}

// This is where the simulation send the accumulated moments to the DCS Simulation
// after each run frame
void ed_fm_add_local_moment(double &x,double &y,double &z)
{
	F35::Motion.getLocalMoment(x, y, z);
}

// Not used
void ed_fm_add_global_moment(double & x,double &y,double &z)
{

}

/* same but in component form , return value bool : function will be called until return value is true
while (ed_fm_add_local_moment_component(x,y,z))
{
	--collect 
}
*/
bool ed_fm_add_local_moment_component (double & x,double &y,double &z)
{
	return false;
}
bool ed_fm_add_global_moment_component (double & x,double &y,double &z)
{
	return false;
}

//-----------------------------------------------------------------------
// The most important part of the entire EFM code.  This is where you code
// gets called for each run frame.  Each run frame last for a duration of
// "dt" (delta time).  This can be used to help time certain features such
// as filters and lags
//-----------------------------------------------------------------------
// NOTE! dt is actually slice-length DCS wants code to limit itself to,
// not actually time passed since last frame - it is constant 0.006000 seconds.
//
// Simulation step/slice/frame should take care of syncing over network (hopefully)
// and it should take care of pausing the simulation: we can't calculate those cases here
// and can only trust DCS to give suitable value.
//
void ed_fm_simulate(double dt)
{
	double frametime = dt; // initialize only

	// Very important! clear out the forces and moments before you start calculated
	// a new set for this run frame
	F35::Motion.clear();

	// Get the total absolute velocity acting on the aircraft with wind included
	// using english units so airspeed is in feet/second here
	F35::Atmos.updateFrame(frametime);
	F35::Ground.updateFrame(frametime);

	// update thrust, engine management
	F35::EMS.updateFrame(frametime);

	// update amount of fuel used and change in mass
	F35::Fuel.updateFrame(F35::EMS.getFuelPerFrame(), frametime);
	F35::Motion.updateFuelMass(F35::Fuel.getInternalFuel()); // <- update total fuel weight

	// update oxygen provided to pilot: tanks, bleed air from engine etc.
	F35::EnvCS.updateFrame(frametime);

	// TODO: engine power to hydraulics
	F35::Hydraulics.updateFrame(frametime);

	F35::Electrics.updateFrame(frametime);
	F35::Airframe.updateFrame(frametime);

	// TODO:! give ground speed to calculate wheel slip/grip!
	// we use total velocity for now..
	// use "dry" weight and internal fuel weight (TODO: take care of it in motion)
	F35::LandingGear.updateFrame(F35::Motion.getTotalWeightN(), frametime);

	//-----CONTROL DYNAMICS------------------------
	// landing gear "down&locked" affects some logic
	F35::FlightControls.updateFrame(frametime);

	F35::Aero.updateFrame(F35::FlightControls.bodyState, F35::FlightControls.flightSurface, frametime);
	F35::Aero.computeTotals(F35::FlightControls.flightSurface, F35::FlightControls.bodyState,
		F35::LandingGear.CxGearAero, 
		F35::LandingGear.CzGearAero);

	F35::Motion.updateAeroForces(F35::Aero.getCyTotal(), F35::Aero.getCxTotal(), F35::Aero.getCzTotal(), 
								F35::Aero.getClTotal(), F35::Aero.getCmTotal(), F35::Aero.getCnTotal());

	F35::Motion.updateEngineForces(F35::EMS.Engine.getThrustN(), F35::EMS.Engine.enginePosition, F35::EMS.getTurbineMomentum());

	// just internal fuel for now, payload and external tanks later
	F35::Motion.updateWetMassCg(F35::Fuel.FwdFus.fuel, F35::Fuel.FwdFus.position, F35::Fuel.FwdFus.size);
	F35::Motion.updateWetMassCg(F35::Fuel.AftFus.fuel, F35::Fuel.AftFus.position, F35::Fuel.AftFus.size);
	F35::Motion.updateWetMassCg(F35::Fuel.LeftWing.fuel, F35::Fuel.LeftWing.position, F35::Fuel.LeftWing.size);
	F35::Motion.updateWetMassCg(F35::Fuel.RightWing.fuel, F35::Fuel.RightWing.position, F35::Fuel.RightWing.size);
	F35::Motion.commitWetMassCg();

	F35::Motion.updateFuelMassDelta(F35::Fuel.getUsageSinceLastFrame());
	F35::Fuel.clearUsageSinceLastFrame();

	if (F35::LandingGear.isWoW() == true)
	{
		F35::Motion.updateWheelForces(F35::LandingGear.wheelLeft.CxWheelFriction,
									F35::LandingGear.wheelLeft.CzWheelFriction,
									F35::LandingGear.wheelRight.CxWheelFriction,
									F35::LandingGear.wheelRight.CzWheelFriction,
									F35::LandingGear.wheelNose.CxWheelFriction,
									F35::LandingGear.wheelNose.CzWheelFriction);

		// just braking force, needs refining
		F35::Motion.updateBrakingFriction(F35::LandingGear.wheelLeft.brakeForce, F35::LandingGear.wheelRight.brakeForce);

		// use free-rolling friction as single unit for now
		// TODO: nose-wheel steering, braking forces etc.
		F35::Motion.updateNoseWheelTurn(F35::LandingGear.getNoseTurnDirection(), F35::LandingGear.getNosegearAngle());
	}

	// testing, check
	//F35::Motion.updateInertia();
}

/*
called before simulation to set up your environment for the next step
give parameters of surface under your aircraft usefull for ground effect
*/
void ed_fm_set_surface (double		h, //surface height under the center of aircraft
						double		h_obj, //surface height with objects
						unsigned		surface_type,
						double		normal_x, //components of normal vector to surface
						double		normal_y, //components of normal vector to surface
						double		normal_z //components of normal vector to surface
						)
{
	F35::Ground.setSurface(h, h_obj, surface_type, Vec3(normal_x, normal_y, normal_z));
}

void ed_fm_set_atmosphere(	double h,//altitude above sea level			(meters)
							double t,//current atmosphere temperature   (Kelvin)
							double a,//speed of sound					(meters/sec)
							double ro,// atmosphere density				(kg/m^3)
							double p,// atmosphere pressure				(N/m^2)
							double wind_vx,//components of velocity vector, including turbulence in world coordinate system (meters/sec)
							double wind_vy,//components of velocity vector, including turbulence in world coordinate system (meters/sec)
							double wind_vz //components of velocity vector, including turbulence in world coordinate system (meters/sec)
						)
{
	F35::Atmos.setAtmosphere(t, ro, a, h, p);
}

void ed_fm_set_current_mass_state ( double mass, // "dry" mass in kg (not including fuel)
									double center_of_mass_x,
									double center_of_mass_y,
									double center_of_mass_z,
									double moment_of_inertia_x,
									double moment_of_inertia_y,
									double moment_of_inertia_z
									)
{
	F35::Motion.setMassState(mass, 
							center_of_mass_x, center_of_mass_y, center_of_mass_z,
							moment_of_inertia_x, moment_of_inertia_y, moment_of_inertia_z);
}

/*
called before simulation to set up your environment for the next step
*/
void ed_fm_set_current_state (double ax,//linear acceleration component in world coordinate system
							double ay,//linear acceleration component in world coordinate system
							double az,//linear acceleration component in world coordinate system
							double vx,//linear velocity component in world coordinate system
							double vy,//linear velocity component in world coordinate system
							double vz,//linear velocity component in world coordinate system
							double px,//center of the body position in world coordinate system
							double py,//center of the body position in world coordinate system
							double pz,//center of the body position in world coordinate system
							double omegadotx,//angular accelearation components in world coordinate system
							double omegadoty,//angular accelearation components in world coordinate system
							double omegadotz,//angular accelearation components in world coordinate system
							double omegax,//angular velocity components in world coordinate system
							double omegay,//angular velocity components in world coordinate system
							double omegaz,//angular velocity components in world coordinate system
							double quaternion_x,//orientation quaternion components in world coordinate system
							double quaternion_y,//orientation quaternion components in world coordinate system
							double quaternion_z,//orientation quaternion components in world coordinate system
							double quaternion_w //orientation quaternion components in world coordinate system
							)
{
	F35::FlightControls.setCurrentState(ax, ay, az);
}

void ed_fm_set_current_state_body_axis(	double ax,//linear acceleration component in body coordinate system (meters/sec^2)
										double ay,//linear acceleration component in body coordinate system (meters/sec^2)
										double az,//linear acceleration component in body coordinate system (meters/sec^2)
										double vx,//linear velocity component in body coordinate system (meters/sec)
										double vy,//linear velocity component in body coordinate system (meters/sec)
										double vz,//linear velocity component in body coordinate system (meters/sec)
										double wind_vx,//wind linear velocity component in body coordinate system (meters/sec)
										double wind_vy,//wind linear velocity component in body coordinate system (meters/sec)
										double wind_vz,//wind linear velocity component in body coordinate system (meters/sec)
										double omegadotx,//angular accelearation components in body coordinate system (rad/sec^2)
										double omegadoty,//angular accelearation components in body coordinate system (rad/sec^2)
										double omegadotz,//angular accelearation components in body coordinate system (rad/sec^2)
										double omegax,//angular velocity components in body coordinate system (rad/sec)
										double omegay,//angular velocity components in body coordinate system (rad/sec)
										double omegaz,//angular velocity components in body coordinate system (rad/sec)
										double yaw,  //radians (rad)
										double pitch,//radians (rad/sec)
										double roll, //radians (rad/sec)
										double common_angle_of_attack, //AoA  (rad)
										double common_angle_of_slide   //AoS  (rad)
										)
{
	F35::Atmos.setAirspeed(vx, vy, vz, wind_vx, wind_vy, wind_vz);

	// set values for later
	F35::FlightControls.setBodyAxisState(common_angle_of_attack, common_angle_of_slide, omegax, omegay, omegaz, ax, ay, az);
}

// list of input enums kept in separate header for easier documenting..
//
// Command = Command Index (See Export.lua), Value = Signal Value (-1 to 1 for Joystick Axis)
void ed_fm_set_command(int command, float value)
{
	//----------------------------------
	// Set F-16 Raw Inputs
	//----------------------------------

	switch (command)
	{
	case F35::JoystickRoll:
		F35::latStickInputRaw = value; // just for cockpit anim

		F35::FlightControls.setLatStickInput(value);
		break;

	case F35::JoystickPitch:
		F35::longStickInputRaw = value; // just for cockpit anim

		F35::FlightControls.setLongStickInput(value);
		break;

	case F35::JoystickYaw:
		F35::pedInputRaw = value; // just for cockpit anim

		F35::FlightControls.setPedInput(value);
		F35::LandingGear.nosewheelTurn(value); // <- does nothing if not enabled or no weight on wheels
		break;

	case F35::JoystickThrottle:
		F35::EMS.setThrottleInput(value);
		break;

	case F35::ApuStart:
		F35::EMS.JfsStart();
		break;
	case F35::ApuStop:
		F35::EMS.JfsStop();
		break;

	case F35::EnginesStart: // "quickstart" shortcut
		F35::EMS.startEngine();
		break;
	case F35::EnginesStop: // "quickstop" shortcut
		F35::EMS.stopEngine();
		break;

	case F35::PowerOnOff: // <- not working now
		// electric system (FC3 style "all in one")
		F35::Electrics.toggleElectrics(); 
		/*
		swprintf(dbgmsg, 255, L" F35::power on/off (FC3): %d value: %f \r\n", command, value);
		::OutputDebugString(dbgmsg);
		*/
		break;

	case F35::BatteryPower:
		F35::Electrics.toggleBatteryOnOff();
		break;

	case F35::AirBrake:
		F35::FlightControls.switchAirbrake();
		break;
	case F35::AirBrakeOn:
		F35::FlightControls.setAirbrakeON();
		break;
	case F35::AirBrakeOff:
		F35::FlightControls.setAirbrakeOFF();
		break;

		// analog input (axis)
	case F35::WheelBrake:
		F35::LandingGear.setWheelBrakeLeft(value);
		F35::LandingGear.setWheelBrakeRight(value);
		break;
	case F35::WheelBrakeLeft:
		F35::LandingGear.setWheelBrakeLeft(value);
		break;
	case F35::WheelBrakeRight:
		F35::LandingGear.setWheelBrakeRight(value);
		break;

		// switch/button input (keyboard)
	case F35::WheelBrakesOn:
		F35::LandingGear.setWheelBrakesON();
		// when button pressed (down)
		break;
	case F35::WheelBrakesOff:
		F35::LandingGear.setWheelBrakesOFF();
		// when button released (up)
		break;

	case F35::ManualPitchOverride:
		F35::FlightControls.setManualPitchOverride(value);
		break;

	case F35::Gear:
		F35::LandingGear.switchGearUpDown();
		break;
	case F35::LandingGearUp:
		F35::LandingGear.setGearUp();
		break;
	case F35::LandingGearDown:
		F35::LandingGear.setGearDown();
		break;

		// flaps normally controlled by landing gear lever,
		// in case alternate switch is used
	case F35::FlapsOnOff:
		F35::FlightControls.toggleAltFlaps();
		break;
	case F35::FlapsOn:
		F35::FlightControls.setAltFlaps(true);
		break;
	case F35::FlapsOff:
		F35::FlightControls.setAltFlaps(false);
		break;

	case F35::NoseWheelSteering:
		// value includes status of it?
		F35::LandingGear.toggleNosewheelSteering();
		// no animation for nosewheel yet?
		/*
		swprintf(dbgmsg, 255, L" F35::nosewheelsteering: %d value: %f \r\n", command, value);
		::OutputDebugString(dbgmsg);
		*/
		break;

	case F35::TrimPitchDown:
		F35::FlightControls.trimState.pitchDown();
		break;
	case F35::TrimPitchUp:
		F35::FlightControls.trimState.pitchUp();
		break;

	case F35::TrimRollCCW:
		F35::FlightControls.trimState.rollCCW();
		break;
	case F35::TrimRollCW:
		F35::FlightControls.trimState.rollCW();
		break;

	case F35::TrimYawLeft:
		F35::FlightControls.trimState.yawLeft();
		break;
	case F35::TrimYawRight:
		F35::FlightControls.trimState.yawRight();
		break;

	case 215: // trimstop command (key up)
		break;

	case F35::NavigationLights:
		F35::Airframe.toggleNavigationLights();
		break;

	case F35::OxygenNormal:
		F35::EnvCS.setOxygenSystem(value);
		break;

	case F35::Canopy:
		// on/off toggle (needs some actuator support as well)
		F35::Airframe.canopyToggle();
		break;

	case F35::EjectPlane:
		// pilot ejected
		F35::Airframe.onEject();
		break;


		/**/
	case 2142:
	case 2143:
		// ignore these, they are noisy
		// (mouse x & y?)
		break;
		/**/

	default:
		{
			swprintf(dbgmsg, 255, L" F35::unknown command: %d value: %f \r\n", command, value);
			::OutputDebugString(dbgmsg);
			// do nothing
		}
		break;
	}
}

/*
	Mass handling 

	will be called  after ed_fm_simulate :
	you should collect mass changes in ed_fm_simulate 

	double delta_mass = 0;
	double x = 0;
	double y = 0; 
	double z = 0;
	double piece_of_mass_MOI_x = 0;
	double piece_of_mass_MOI_y = 0; 
	double piece_of_mass_MOI_z = 0;
 
	//
	while (ed_fm_change_mass(delta_mass,x,y,z,piece_of_mass_MOI_x,piece_of_mass_MOI_y,piece_of_mass_MOI_z))
	{
	//internal DCS calculations for changing mass, center of gravity,  and moments of inertia
	}
*/
/*
if (fuel_consumption_since_last_time > 0)
{
	delta_mass		 = fuel_consumption_since_last_time;
	delta_mass_pos_x = -1.0;
	delta_mass_pos_y =  1.0;
	delta_mass_pos_z =  0;

	delta_mass_moment_of_inertia_x	= 0;
	delta_mass_moment_of_inertia_y	= 0;
	delta_mass_moment_of_inertia_z	= 0;

	fuel_consumption_since_last_time = 0; // set it 0 to avoid infinite loop, because it called in cycle 
	// better to use stack like structure for mass changing 
	return true;
}
else 
{
	return false;
}
*/
bool ed_fm_change_mass(double & delta_mass,
						double & delta_mass_pos_x,
						double & delta_mass_pos_y,
						double & delta_mass_pos_z,
						double & delta_mass_moment_of_inertia_x,
						double & delta_mass_moment_of_inertia_y,
						double & delta_mass_moment_of_inertia_z
						)
{
	// TODO: better integration of fuel mass position and actual fuel usage calculation
	if (F35::Motion.isMassChanged() == true)
	{
		F35::Motion.getMassMomentInertiaChange(delta_mass, 
											delta_mass_pos_x, 
											delta_mass_pos_y, 
											delta_mass_pos_z,
											delta_mass_moment_of_inertia_x, 
											delta_mass_moment_of_inertia_y, 
											delta_mass_moment_of_inertia_z);
		// Can't set to true...crashing right now :(
		return false;
	}

	return false;
}

/*
	set internal fuel volume , init function, called on object creation and for refueling , 
	you should distribute it inside at different fuel tanks
*/
void ed_fm_set_internal_fuel(double fuel)
{
	// internal fuel in kg
	F35::Fuel.setInternalFuel(fuel);
}

/*
	get internal fuel volume 
*/
double ed_fm_get_internal_fuel()
{
	return F35::Fuel.getInternalFuel();
}

/*
	set external fuel volume for each payload station , called for weapon init and on reload
*/
void ed_fm_set_external_fuel(int station,
								double fuel,
								double x,
								double y,
								double z)
{
	F35::Fuel.setExternalFuel(station, fuel, x, y, z);
}

/*
	get external fuel volume 
*/
double ed_fm_get_external_fuel ()
{
	return F35::Fuel.getExternalFuel();
}

/*
	incremental adding of fuel in case of refueling process 
*/
void ed_fm_refueling_add_fuel(double fuel)
{
	/*
	swprintf(dbgmsg, 255, L" F35::add fuel: %f \r\n", fuel);
	::OutputDebugString(dbgmsg);
	*/

	return F35::Fuel.refuelAdd(fuel);
}

// see arguments in: Draw arguments for aircrafts 1.1.pdf
// also (more accurate) use ModelViewer for details in F-16DCS.edm
//
void ed_fm_set_draw_args_v2(float * drawargs, size_t size)
{
	// nose gear
	drawargs[0] = (float)F35::LandingGear.wheelNose.getStrutAngle(); // gear angle {0=retracted;1=extended}
	drawargs[1] = (float)F35::LandingGear.wheelNose.getStrutCompression(); // strut compression {0=extended;0.5=parking;1=retracted}

	//Nose Gear Steering
	// note: not active animation on the 3D model right now
	drawargs[2] = F35::LandingGear.getNosegearTurn(); // nose gear turn angle {-1=CW max;1=CCW max}

	// right gear
	drawargs[3] = (float)F35::LandingGear.wheelRight.getStrutAngle(); // gear angle {0;1}
	drawargs[4] = (float)F35::LandingGear.wheelRight.getStrutCompression(); // strut compression {0;0.5;1}

	// left gear
	drawargs[5] = (float)F35::LandingGear.wheelLeft.getStrutAngle(); // gear angle {0;1}
	drawargs[6] = (float)F35::LandingGear.wheelLeft.getStrutCompression(); // strut compression {0;0.5;1}

	drawargs[9] = F35::FlightControls.getFlapRSDraw(); // right flap (trailing edge surface)
	drawargs[10] = F35::FlightControls.getFlapLSDraw(); // left flap (trailing edge surface)

	drawargs[11] = F35::FlightControls.getAileronRSDraw(); // right aileron (trailing edge surface)
	drawargs[12] = F35::FlightControls.getAileronLSDraw(); // left aileron (trailing edge surface)

	drawargs[13] = F35::FlightControls.getLefRSDraw(); // right slat (leading edge) <- limited
	drawargs[14] = F35::FlightControls.getLefLSDraw(); // left slat (leading edge) <- negative angle works

	drawargs[15] = F35::FlightControls.getElevatorRSDraw(); // right elevator
	drawargs[16] = F35::FlightControls.getElevatorLSDraw(); // left elevator

	drawargs[17] = F35::FlightControls.getRudderDraw(); // right rudder

	drawargs[21] = F35::FlightControls.getAirbrakeRSDraw();
	drawargs[21] = F35::FlightControls.getAirbrakeLSDraw();

	drawargs[22] = F35::Airframe.getRefuelingDoorAngle(); // refueling door (not implemented)

	drawargs[28] = (float)F35::EMS.getNozzlePos();
	drawargs[89] = (float)F35::EMS.getAfterburnerDraw(); // afterburner right engine
	//drawargs[290..291].f // nozzle rotation?
	//drawargs[290].f = (float)F35::EMS.getNozzlePos(); // nozzle rotation?
	//drawargs[291].f = (float)F35::EMS.getNozzlePos(); // nozzle rotation?


	drawargs[38] = F35::Airframe.getCanopyAngle(); // draw angle of canopy {0=closed;0.9=elevated;1=no draw}

	// drawargs[50] = F35::Airframe.getEjectingSeatDraw(); // ejecting seat in plane

	//drawargs[182].f // right-side brake flaps 0..1
	//drawargs[186].f // left-side brake flaps 0..1
	// drawargs[182] = F35::FlightControls.getAirbrakeRSDraw();
	// drawargs[186] = F35::FlightControls.getAirbrakeLSDraw();

	// navigation lights
	drawargs[49] = F35::Airframe.isNavigationLight();

	// formation lights
	drawargs[88] = F35::Airframe.isFormationLight();

	// landing lights
	drawargs[51] = F35::Airframe.isLandingLight();

	// strobe lights
	drawargs[83] = F35::Airframe.isStrobeLight();

	// note: current 3D model has three "lamps" implemented:
	// 190 left
	// 196 right
	// 203 tail (back)
	drawargs[190] = F35::Airframe.getLeftLight();
	drawargs[196] = F35::Airframe.getRightLight();
	drawargs[203] = F35::Airframe.getBackLight();

	// following are not all implemented
	//drawargs[190..199].f // nav light #1..10
	//drawargs[200..207].f // formation light #1..8
	//drawargs[208..212].f // landing lamp #1..5

	//drawargs[336].f // cap of brake parachute (not implemented)

	/*
	// !! template has this addition, what are those values really for?
	// (documentation?)
	if (size > 616)
	{
		drawargs[611].f = drawargs[0].f;
		drawargs[614].f = drawargs[3].f;
		drawargs[616].f = drawargs[5].f;
	}
	*/
}

/*
	update draw arguments for your aircraft 
	also same prototype is used for ed_fm_set_fc3_cockpit_draw_args  : direct control over cockpit arguments , 
	it can be use full for FC3 cockpits reintegration with new flight model 
	size: count of elements in array
*/
// use ModelViewer for details in Cockpit-Viper.edm
void ed_fm_set_fc3_cockpit_draw_args_v2(float * drawargs,size_t size)
{
	/*
		-- stick arg 2 and 3 match args in cockpit edm, anim should work with proper input binding
		StickPitch.arg_number			= 2
		StickPitch.input				= {-100, 100}
		StickPitch.output				= {-1, 1}
		StickPitch.controller			= controllers.base_gauge_StickPitchPosition
		StickBank.arg_number			= 3
		StickBank.input					= {-100, 100}
		StickBank.output				= {-1, 1}
		StickBank.controller			= controllers.base_gauge_StickRollPosition
	*/
	// yay! this seems to work ok!
	// TODO: movement is really small in real-life -> limit movements (1/4 inches both axes)
	// currently you can use this to check joystick vs. in-cockpit movement
	drawargs[2] = (float)F35::longStickInputRaw;
	drawargs[3] = (float)F35::latStickInputRaw;

	//F35::EMS.getThrottleInput()

}

/*
shake level amplitude for head simulation , 
*/
double ed_fm_get_shake_amplitude()
{
	return 0;
}

/*
will be called for your internal configuration
*/
void ed_fm_configure(const char * cfg_path)
{
}

/*
will be called for your internal configuration
void ed_fm_release   called when fm not needed anymore : aircraft death etc.
*/
void ed_fm_release()
{
	// we are calling destructors automatically but could cleanup earlier here..
}

// see enum ed_fm_param_enum in wHumanCustomPhysicsAPI.h
double ed_fm_get_param(unsigned param_enum)
{
	switch (param_enum)
	{
		// APU parameters at engine index 0
	case ED_FM_ENGINE_0_RPM:
		return F35::EMS.JFS.getRpm();
	case ED_FM_ENGINE_0_RELATED_RPM:
		return F35::EMS.JFS.getRelatedRpm();
	case ED_FM_ENGINE_0_CORE_RPM:
	case ED_FM_ENGINE_0_CORE_RELATED_RPM:
	case ED_FM_ENGINE_0_THRUST:
	case ED_FM_ENGINE_0_RELATED_THRUST:
	case ED_FM_ENGINE_0_CORE_THRUST:
	case ED_FM_ENGINE_0_CORE_RELATED_THRUST:
		// not implemented now
		return 0;
	case ED_FM_ENGINE_0_TEMPERATURE:
		return F35::EMS.JFS.getTemperature();
	case ED_FM_ENGINE_0_OIL_PRESSURE:
		return F35::EMS.JFS.getOilPressure();
	case ED_FM_ENGINE_0_FUEL_FLOW:
		return F35::EMS.JFS.getFuelFlow();

	case ED_FM_ENGINE_1_RPM:
		return F35::EMS.getEngineRpm();
	case ED_FM_ENGINE_1_RELATED_RPM:
		return F35::EMS.getEngineRelatedRpm();
	case ED_FM_ENGINE_1_THRUST:
		return F35::EMS.getEngineThrust();
	case ED_FM_ENGINE_1_RELATED_THRUST:
		return F35::EMS.getEngineRelatedThrust();
	case ED_FM_ENGINE_1_CORE_RPM:
		return F35::EMS.getEngineRpm();
	case ED_FM_ENGINE_1_CORE_RELATED_RPM:
		return F35::EMS.getEngineRelatedRpm();
	case ED_FM_ENGINE_1_CORE_THRUST:
		return F35::EMS.getEngineThrust();
	case ED_FM_ENGINE_1_CORE_RELATED_THRUST:
		return F35::EMS.getEngineRelatedThrust();
	case ED_FM_ENGINE_1_TEMPERATURE:
		return F35::EMS.Engine.getEngineTemperature();
	case ED_FM_ENGINE_1_OIL_PRESSURE:
		return F35::EMS.Engine.getOilPressure();
	case ED_FM_ENGINE_1_FUEL_FLOW:
		return F35::EMS.Engine.getFuelFlow();
	case ED_FM_ENGINE_1_COMBUSTION:
		// not implemented now
		return 0;

	case ED_FM_SUSPENSION_0_GEAR_POST_STATE: // from 0 to 1 : from fully retracted to full released
		return F35::LandingGear.wheelNose.getStrutAngle(); // <- already has limit
	case ED_FM_SUSPENSION_0_RELATIVE_BRAKE_MOMENT:
	case ED_FM_SUSPENSION_0_UP_LOCK:
	case ED_FM_SUSPENSION_0_DOWN_LOCK:
	case ED_FM_SUSPENSION_0_WHEEL_YAW: // steering angle? or strut sideways movement?
	case ED_FM_SUSPENSION_0_WHEEL_SELF_ATTITUDE:
		return 0;

	case ED_FM_SUSPENSION_1_GEAR_POST_STATE: // from 0 to 1 : from fully retracted to full released
		return F35::LandingGear.wheelRight.getStrutAngle(); // <- already has limit
	case ED_FM_SUSPENSION_1_RELATIVE_BRAKE_MOMENT:
	case ED_FM_SUSPENSION_1_UP_LOCK:
	case ED_FM_SUSPENSION_1_DOWN_LOCK:
	case ED_FM_SUSPENSION_1_WHEEL_YAW:
	case ED_FM_SUSPENSION_1_WHEEL_SELF_ATTITUDE:
		return 0;

	case ED_FM_SUSPENSION_2_GEAR_POST_STATE: // from 0 to 1 : from fully retracted to full released
		return F35::LandingGear.wheelLeft.getStrutAngle(); // <- already has limit
	case ED_FM_SUSPENSION_2_RELATIVE_BRAKE_MOMENT:
	case ED_FM_SUSPENSION_2_UP_LOCK:
	case ED_FM_SUSPENSION_2_DOWN_LOCK:
	case ED_FM_SUSPENSION_2_WHEEL_YAW:
	case ED_FM_SUSPENSION_2_WHEEL_SELF_ATTITUDE:
		return 0;

	case ED_FM_OXYGEN_SUPPLY: // oxygen provided from on board oxygen system, pressure - pascal
		return F35::EnvCS.getCockpitPressure();
	case ED_FM_FLOW_VELOCITY:
		return 0;

	case ED_FM_CAN_ACCEPT_FUEL_FROM_TANKER: // return positive value if all conditions are matched to connect to tanker and get fuel
		// TODO: refueling door handling, collision box reduction
		return 0;

	// Groups for fuel indicator
	case ED_FM_FUEL_FUEL_TANK_GROUP_0_LEFT:			// Values from different group of tanks
	case ED_FM_FUEL_FUEL_TANK_GROUP_0_RIGHT:
	case ED_FM_FUEL_FUEL_TANK_GROUP_1_LEFT:
	case ED_FM_FUEL_FUEL_TANK_GROUP_1_RIGHT:
	case ED_FM_FUEL_FUEL_TANK_GROUP_2_LEFT:
	case ED_FM_FUEL_FUEL_TANK_GROUP_2_RIGHT:
	case ED_FM_FUEL_FUEL_TANK_GROUP_3_LEFT:
	case ED_FM_FUEL_FUEL_TANK_GROUP_3_RIGHT:
	case ED_FM_FUEL_FUEL_TANK_GROUP_4_LEFT:
	case ED_FM_FUEL_FUEL_TANK_GROUP_4_RIGHT:
	case ED_FM_FUEL_FUEL_TANK_GROUP_5_LEFT:
	case ED_FM_FUEL_FUEL_TANK_GROUP_5_RIGHT:
	case ED_FM_FUEL_FUEL_TANK_GROUP_6_LEFT:
	case ED_FM_FUEL_FUEL_TANK_GROUP_6_RIGHT:
		return 0;

	case ED_FM_FUEL_INTERNAL_FUEL:
		return F35::Fuel.getInternalFuel();
	case ED_FM_FUEL_TOTAL_FUEL:
		return F35::Fuel.getInternalFuel() + F35::Fuel.getExternalFuel();

	case ED_FM_FUEL_LOW_SIGNAL:
		// Low fuel signal
		return F35::Fuel.isLowFuel();

	case ED_FM_ANTI_SKID_ENABLE:
		/* return positive value if anti skid system is on , it also corresspond with suspension table "anti_skid_installed"  parameter for each gear post .i.e 
		anti skid system will be applied only for those wheels who marked with   anti_skid_installed = true
		*/
		return 0;

	case ED_FM_COCKPIT_PRESSURIZATION_OVER_EXTERNAL: 
		// additional pressure from pressurization system , pascal , actual cabin pressure will be AtmoPressure + COCKPIT_PRESSURIZATION_OVER_EXTERNAL
		return F35::EnvCS.getCockpitPressure();

	default:
		// silence compiler warning(s)
		break;
	}
	return 0;	
}

void ed_fm_cold_start()
{
	swprintf(dbgmsg, 255, L" F35ADemo:: cold start %hs \r\n", __DATE__);
	::OutputDebugString(dbgmsg);

	// landing gear down
	// canopy open
	// electrics off
	// engine off

	// input does not work correctly yet
	F35::LandingGear.initGearsDown();
	F35::Airframe.initCanopyOpen();
	F35::FlightControls.initAirBrakeOff();
	F35::Electrics.setElectricsOnOff(false); // <- off
	F35::EMS.initEngineOff(); // <- stop
}

void ed_fm_hot_start()
{
	swprintf(dbgmsg, 255, L" F35ADemo:: hot start %hs \r\n", __DATE__);
	::OutputDebugString(dbgmsg);

	// landing gear down
	// canopy closed
	// electrics on
	// engine on
	F35::LandingGear.initGearsDown();
	F35::Airframe.initCanopyClosed();
	F35::FlightControls.initAirBrakeOff();
	F35::Electrics.setElectricsOnOff(true);
	F35::EMS.initEngineIdle();
}

void ed_fm_hot_start_in_air()
{
	swprintf(dbgmsg, 255, L" F35ADemo:: hot start in air %hs \r\n", __DATE__);
	::OutputDebugString(dbgmsg);

	// landing gear up
	// canopy closed
	// electrics on
	// engine on
	F35::LandingGear.initGearsUp();
	F35::Airframe.initCanopyClosed();
	F35::FlightControls.initAirBrakeOff();
	F35::Electrics.setElectricsOnOff(true);
	F35::EMS.initEngineCruise();
}

/* 
for experts only : called  after ed_fm_hot_start_in_air for balance FM at actual speed and height , it is directly force aircraft dynamic data in case of success 
*/
bool ed_fm_make_balance (double & ax,//linear acceleration component in world coordinate system);
									double & ay,//linear acceleration component in world coordinate system
									double & az,//linear acceleration component in world coordinate system
									double & vx,//linear velocity component in world coordinate system
									double & vy,//linear velocity component in world coordinate system
									double & vz,//linear velocity component in world coordinate system
									double & omegadotx,//angular accelearation components in world coordinate system
									double & omegadoty,//angular accelearation components in world coordinate system
									double & omegadotz,//angular accelearation components in world coordinate system
									double & omegax,//angular velocity components in world coordinate system
									double & omegay,//angular velocity components in world coordinate system
									double & omegaz,//angular velocity components in world coordinate system
									double & yaw,  //radians
									double & pitch,//radians
									double & roll)//radians
{
	return false;
}

/*
enable additional information like force vector visualization , etc.
*/
bool ed_fm_enable_debug_info()
{
	return false;
}

/*debuf watch output for topl left corner DCS window info  (Ctrl + Pause to show)
ed_fm_debug_watch(int level, char *buffer,char *buf,size_t maxlen)
level - Watch verbosity level.
ED_WATCH_BRIEF   = 0,
ED_WATCH_NORMAL  = 1,
ED_WATCH_FULL	 = 2,

return value  - amount of written bytes

using

size_t ed_fm_debug_watch(int level, char *buffer,size_t maxlen)
{
	float  value_1 = .. some value;
	float  value_2 = .. some value;
	//optional , you can change depth of displayed information with level 
	switch (level)
	{
		case 0:     //ED_WATCH_BRIEF,
			..do something
			break;
		case 1:     //ED_WATCH_NORMAL,
			..do something
		break;
		case 2:     //ED_WATCH_FULL,
			..do something
		break;
	}
	... do something 
	if (do not want to display)
	{	
		return 0;
	}
	else // ok i want to display some vars 
	{    
		return sprintf_s(buffer,maxlen,"var value1 %f ,var value2 %f",value_1,value_2);
	}
}
*/
size_t ed_fm_debug_watch(int level, char *buffer,size_t maxlen)
{
	/*
	if (level < ED_WATCH_FULL)
	{
		return 0;
	}
	*/
	/*
	if (level == 1 || level == 2)
	{
		return sprintf_s(buffer, maxlen, "fuel: %f", F35::Fuel.getInternalFuel());
	}
	*/

	/* not functional at moment
	if (level > 0)
	{
		return _snprintf(buffer, maxlen, "F35:: dynP: %f Vt: %f",
			F35::Atmos.dynamicPressure, F35::Atmos.totalVelocity);
	}
	*/
	return 0;
}

/* 
path to your plugin installed
*/
void ed_fm_set_plugin_data_install_path(const char * path)
{
}

// damages and failures
// callback when preplaneed failure triggered from mission 
void ed_fm_on_planned_failure(const char * data)
{
}

// callback when damage occurs for airframe element 
void ed_fm_on_damage(int Element, double element_integrity_factor)
{
	/*
	//TODO: check what is needed to get these
	swprintf(dbgmsg, 255, L" F35::Damage: element: %d factor: %f \r\n", Element, element_integrity_factor);
	::OutputDebugString(dbgmsg);
	*/

	// keep integrity information in airframe
	F35::Airframe.onAirframeDamage(Element, element_integrity_factor);
}

// called in case of repair routine 
void ed_fm_repair()
{
	F35::Airframe.onRepair();
}

// in case of some internal damages or system failures this function return true , to switch on repair process
bool ed_fm_need_to_be_repaired()
{
	return F35::Airframe.isRepairNeeded();
}

// inform about  invulnerability settings
void ed_fm_set_immortal(bool value)
{
	F35::Airframe.setImmortal(value);
}

// inform about  unlimited fuel
void ed_fm_unlimited_fuel(bool value)
{
	F35::Fuel.setUnlimitedFuel(value);
}

// inform about simplified flight model request 
void ed_fm_set_easy_flight(bool value)
{
}

// custom properties sheet 
void ed_fm_set_property_numeric(const char * property_name,float value)
{
	/*
	// TODO: do we set these somewhere in lua?
	swprintf(dbgmsg, 255, L" F35::property numeric: %s value: %f \r\n", property_name, value);
	::OutputDebugString(dbgmsg);
	*/
}

// custom properties sheet 
void ed_fm_set_property_string(const char * property_name,const char * value)
{
	/*
	// TODO: do we set these somewhere in lua?
	swprintf(dbgmsg, 255, L" F35::property string: %s value: %s \r\n", property_name, value);
	::OutputDebugString(dbgmsg);
	*/
}

/*
	called on each sim step 

	ed_fm_simulation_event event;
	while (ed_fm_pop_simulation_event(event))
	{
		do some with event data;
	}
*/
bool ed_fm_pop_simulation_event(ed_fm_simulation_event & out)
{
	// something like this when triggered? (reset return value after output)
	//out.event_type = ED_FM_EVENT_FAILURE;
	//memcpy(out.event_message, "autopilot", strlen("autopilot"));

	return false;
}

/*
	feedback to your fm about suspension state
*/
void ed_fm_suspension_feedback(int idx,const ed_fm_suspension_info * info)
{
	// TODO: update landing gears
	//info->acting_force;
	//info->acting_force_point;
	//info->integrity_factor;
	//info->struct_compression;

	/*
	swprintf(dbgmsg, 255, L" F35::Suspension: idx: %d comp: %f \r\n", idx, info->struct_compression);
	::OutputDebugString(dbgmsg);
	*/

	switch (idx)
	{
	case 0:
		F35::LandingGear.wheelNose.setActingForce(info->acting_force[0], info->acting_force[1], info->acting_force[2]);
		F35::LandingGear.wheelNose.setActingForcePoint(info->acting_force_point[0], info->acting_force_point[1], info->acting_force_point[2]);
		F35::LandingGear.wheelNose.setIntegrityFactor(info->integrity_factor);
		// 0.231
		F35::LandingGear.wheelNose.setStrutCompression(info->struct_compression);
		break;
	case 1:
		F35::LandingGear.wheelRight.setActingForce(info->acting_force[0], info->acting_force[1], info->acting_force[2]);
		F35::LandingGear.wheelRight.setActingForcePoint(info->acting_force_point[0], info->acting_force_point[1], info->acting_force_point[2]);
		F35::LandingGear.wheelRight.setIntegrityFactor(info->integrity_factor);
		// 0.750
		F35::LandingGear.wheelRight.setStrutCompression(info->struct_compression);
		break;
	case 2:
		F35::LandingGear.wheelLeft.setActingForce(info->acting_force[0], info->acting_force[1], info->acting_force[2]);
		F35::LandingGear.wheelLeft.setActingForcePoint(info->acting_force_point[0], info->acting_force_point[1], info->acting_force_point[2]);
		F35::LandingGear.wheelLeft.setIntegrityFactor(info->integrity_factor);
		// 0.750
		F35::LandingGear.wheelLeft.setStrutCompression(info->struct_compression);
		break;

	default:
		break;
	}
}

double test()
{
	return 10.0;
}

