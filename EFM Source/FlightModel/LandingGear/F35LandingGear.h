#ifndef _F35LANDINGGEAR_H_
#define _F35LANDINGGEAR_H_

#include <cmath>

#include "ED_FM_Utility.h"		// Provided utility functions that were in the initial EFM example
#include "F35Constants.h"		// Common constants used throughout this DLL

#include "SuspensionData.h"
#include "F35LandingWheel.h"

#include "Atmosphere/F35Atmosphere.h"
#include "Atmosphere/F35GroundSurface.h"

#include "FlightControls/F35Actuator.h"

// nosewheel steering (NWS) limited to 32 degrees in each direction

// gears up/down status
// weight-on-wheels
// actuator movement
// aerodynamic drag
// wheelbrake deceleration
// parking brake

// anti-skid system

// TODO: different friction coefficient on each surface?
// (tarmac, concrete, grass, mud...)

// amount of braking fluid (liquid) in system? (limited amount available)

class F35LandingGear //: public AbstractHydraulicDevice
{
protected:
	bool gearLevelUp; // gear lever up/down (note runway/air start)
	//double gearDownAngle;	// Is the gear currently down? (If not, what angle is it?)
	//bool gearDownLocked; // gear down and locked?

	// alteranate pneumatic emergency system to force LG down?
	// -> single-use thing only
	//bool altLandingGearSwitch;

public:

	bool nosewheelSteering; // is active/not
	double noseGearTurnAngle; // steering angle {-1=CW max;1=CCW max}

	Limiter<double> nwsLimiter;

	// aerodynamic drag when gears are not fully up
	//double CDGearAero;
	double CzGearAero;
	double CxGearAero;

	F35Actuator actNose;
	F35Actuator actLeft;
	F35Actuator actRight;

	F35LandingWheel wheelNose;
	F35LandingWheel wheelLeft;
	F35LandingWheel wheelRight;

	bool parkingBreakOn;
	bool antiSkidOn;

	//F35HydraulicSystem *pHydSys; // parent system providing force
	F35Atmosphere *pAtmos;
	F35GroundSurface *pGrounds;

public:
	F35LandingGear(F35Atmosphere *atmos, F35GroundSurface *grounds)
		: gearLevelUp(false)
		, nosewheelSteering(true) // <- enable by default until button mapping works
		, noseGearTurnAngle(0)
		, nwsLimiter(-32, 32)
		, CzGearAero(0)
		, CxGearAero(0)
		, actNose(0.25, 0, 1.0)
		, actLeft(0.25, 0, 1.0)
		, actRight(0.25, 0, 1.0)
		, wheelNose(0.479, 3.6) // <- inertia should be different for nose wheel? (smaller wheel)
		, wheelLeft(0.68, 3.6)
		, wheelRight(0.68, 3.6)
		, parkingBreakOn(false)
		, antiSkidOn(false)
		, pAtmos(atmos)
		, pGrounds(grounds)
	{
	}
	~F35LandingGear() {}

	bool isWoW()
	{
		if (wheelNose.isWoW()
			|| wheelLeft.isWoW()
			|| wheelRight.isWoW())
		{
			return true;
		}
		return false;
	}
	int countWoW()
	{
		int n = 0;
		if (wheelNose.isWoW())
			n++;
		if (wheelLeft.isWoW())
			n++;
		if (wheelRight.isWoW())
			n++;
		return n;
	}

	void setParkingBreak(bool OnOff)
	{
		parkingBreakOn = OnOff;
	}

	// joystick axis
	void setWheelBrakeLeft(const double value)
	{
		// 0..1 from input
		wheelLeft.brakeInput = abs(value);
	}
	// joystick axis
	void setWheelBrakeRight(const double value)
	{
		// 0..1 from input
		wheelRight.brakeInput = abs(value);
	}

	// key press DOWN
	void setWheelBrakesON()
	{
		wheelLeft.brakeInput = 1;
		wheelRight.brakeInput = 1;
	}
	// key press UP
	void setWheelBrakesOFF()
	{
		wheelLeft.brakeInput = 0;
		wheelRight.brakeInput = 0;
	}

	void toggleNosewheelSteering()
	{
		nosewheelSteering = !nosewheelSteering;
	}

	// TODO: joystick input is usually -100..100
	// and we have limit of 32 degrees each way
	// -> calculate correct nosewheel angle by input amount
	// or just "cut" out excess input?
	void nosewheelTurn(const double value)
	{
		if (isWoW() == false)
		{
			return;
		}
		if (nosewheelSteering == false)
		{
			return;
		}

		// TODO: check value
		//noseGearTurnAngle = value;

		// for now, just cut input to allowed range in degrees
		noseGearTurnAngle = nwsLimiter.limit(value);
	}

	// in case of nose wheel: 
	// calculate direction vector based on the turn angle
	// (polar to cartesian coordinates)
	Vec3 getNoseTurnDirection()
	{
		// in DCS body coordinates, (x,z) plane vector instead of (x,y) ?
		double x = cos(noseGearTurnAngle);
		double z = cos(noseGearTurnAngle);

		return Vec3(x, 0, z); // test!

		//Vec3 direction(1, 0, 0); // <- start with aligned to body direction
		// ..vector multiply by radians?
		// translation matrix?
		//return direction;
	}

	// nosegear turn -1..1 for drawargs
	float getNosegearTurn()
	{
		/*
		if (isWoW() == false)
		{
			return 0;
		}
		*/
		return (float)limit(noseGearTurnAngle, -1, 1);
	}

	// actual nosegear turn angle
	double getNosegearAngle()
	{
		/*
		if (isWoW() == false)
		{
			return 0;
		}
		*/
		return noseGearTurnAngle;
	}

	void initGearsDown()
	{
		gearLevelUp = false;
		actNose.m_current = 1.0;
		actLeft.m_current = 1.0;
		actRight.m_current = 1.0;
		wheelNose.setStrutAngle(actNose.m_current);
		wheelLeft.setStrutAngle(actLeft.m_current);
		wheelRight.setStrutAngle(actRight.m_current);
	}
	void initGearsUp()
	{
		gearLevelUp = true;
		actNose.m_current = 0;
		actLeft.m_current = 0;
		actRight.m_current = 0;
		wheelNose.setStrutAngle(actNose.m_current);
		wheelLeft.setStrutAngle(actLeft.m_current);
		wheelRight.setStrutAngle(actRight.m_current);
	}

	bool getGearLevelStatus()
	{
		return gearLevelUp;
	}

	// user "lever" action
	void switchGearUpDown()
	{
		gearLevelUp = !gearLevelUp;
	}
	void setGearDown()
	{
		gearLevelUp = false;
	}
	void setGearUp()
	{
		gearLevelUp = true;
	}

	// is gear "down and locked" -> affects airbrake logic
	bool isGearDownLocked() const
	{
		if (actNose.m_current < actNose.m_limiter.upper_limit
			|| actLeft.m_current < actLeft.m_limiter.upper_limit
			|| actRight.m_current < actRight.m_limiter.upper_limit)
		{
			// not completely down
			return false;
		}
		// at max -> down & locked
		return true;
	}

	// is gear "up and locked" -> trailing edge flaps
	bool isGearUpLocked() const
	{
		if (actNose.m_current > actNose.m_limiter.lower_limit
			|| actLeft.m_current > actLeft.m_limiter.lower_limit
			|| actRight.m_current > actRight.m_limiter.lower_limit)
		{
			// not completely up
			return false;
		}
		// at max -> up & locked
		return true;
	}

	// need current weight of the whole aircraft
	// and speed relative to ground (static, sliding or rolling friction of each wheel)
	void updateFrame(const double weightN, double frameTime)
	{
		//const double airSpeed = ;
		const double groundSpeed = pAtmos->totalVelocity;
		//pGrounds->


		wheelNose.clearForceTotal();
		wheelLeft.clearForceTotal();
		wheelRight.clearForceTotal();

		// TODO: if gears are not fully up,
		// calculate force required to pull them up
		// something like this?
		//forceReq = airSpeed * pressure;
		// then set required force to gear
		//actNose.m_forceThresholdDec = forceReq;
		//actLeft.m_forceThresholdDec = forceReq;
		//actRight.m_forceThresholdDec = forceReq;
		// also set force provided by hydraulic system (TODO)


		// if there is weight on wheels -> do nothing
		if (isWoW() == false)
		{
			if (gearLevelUp == true)
			{
				// lever up -> command to pull wheels up (decrement act.)
				actNose.m_commanded = 0;
				actLeft.m_commanded = 0;
				actRight.m_commanded = 0;
			}
			else
			{
				actNose.m_commanded = 1.0;
				actLeft.m_commanded = 1.0;
				actRight.m_commanded = 1.0;
			}
			actNose.updateFrame(frameTime);
			actLeft.updateFrame(frameTime);
			actRight.updateFrame(frameTime);

			wheelNose.setStrutAngle(actNose.m_current);
			wheelLeft.setStrutAngle(actLeft.m_current);
			wheelRight.setStrutAngle(actRight.m_current);
		}

		gearAeroDrag();

		// let's see.. 
		// total static friction should be amount of friction required (by engine thrust)
		// to be exceeded before we start rolling
		if (isWoW() == true) // <- at least one wheel has weight on it
		{
			double weightperwheel = weightN / countWoW();

			wheelNose.updateForceFriction(groundSpeed, weightperwheel);
			wheelLeft.updateForceFriction(groundSpeed, weightperwheel);
			wheelRight.updateForceFriction(groundSpeed, weightperwheel);
		}
	}


protected:

	// TODO: calculate tire load on each wheel:
	// amount of weight of the aircraft (and payload) on the tire, 
	// minus aerodynamic lift of the aircraft (when moving)
	void tireLoad()
	{
	}

	void gearAeroDrag(/*double airspeed?*/)
	{
		// precalculate some things
		const double gearZsin = sin(F35::degtorad);
		const double gearYcos = cos(F35::degtorad);
		const double gearCd = 0.0270;

		double CDNose = actNose.m_current * gearCd;
		double CDLeft = actLeft.m_current * gearCd;
		double CDRight = actRight.m_current * gearCd;

		// TODO Gear aero (from JBSim F35.xml config)
		//CDGearAero = 0.0270 * gearDownAngle; // <- angle 1.0 for fully down, 0 when up

		double CdTotal = CDNose + CDLeft + CDRight;

		CzGearAero = -(CdTotal * gearZsin);
		CxGearAero = -(CdTotal * gearYcos);
	}

	void brakeFluidUsage(double frameTime)
	{
		// TODO: there's fluid for approx. 75s (toe brakes)
		// parking brake usage does not deplete fluid
	}
};

#endif // ifndef _F35LANDINGGEAR_H_
