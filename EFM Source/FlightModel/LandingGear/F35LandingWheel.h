#ifndef _F35LANDINGWHEEL_H_
#define _F35LANDINGWHEEL_H_

#include <cmath>

#include "ED_FM_Utility.h"		// Provided utility functions that were in the initial EFM example
#include "F35Constants.h"		// Common constants used throughout this DLL
#include "Inputs/F35AnalogInput.h"

/*
 some sources to use for wheel and tyre dynamics:
 - Vehicle Dynamics - Fundamentals and Modeling Aspects, SHORT COURSE, Prof. Dr. Georg Rill, Brasil, August 2007

*/

// nosewheel steering (NWS) limited to 32 degrees in each direction

// gears up/down status
// weight-on-wheels
// actuator movement
// aerodynamic drag
// wheelbrake deceleration
// parking brake

// TODO: different friction coefficient on each surface?
// (tarmac, concrete, grass, mud...)


class F35LandingWheel
{
protected:
	//const double rolling_friction;		// Rolling friction amount (constant now)
	//double slip_friction;		// TODO: Slip friction amount? (depends on surface as well..)
	//double forcefriction // <- direction and combined forces to calculate if maximum friction is exceeded?

	const double wheel_radius; //					  = 0.479,
	const double wheel_static_friction_factor; //  = 0.65 , --Static friction when wheel is not moving (fully braked)
	const double wheel_side_friction_factor; //    = 0.65 ,
	const double wheel_roll_friction_factor; //    = 0.025, --Rolling friction factor when wheel moving
	const double wheel_glide_friction_factor; //   = 0.28 , --Sliding aircraft
	const double wheel_damage_force_factor; //     = 250.0, -- Tire is explosing due to hard landing
	const double wheel_damage_speed; //			   = 150.0, -- Tire burst due to excessive speed
	const double wheel_moment_of_inertia; //		= 3.6, --wheel moi as rotation body
	const double wheel_brake_moment_max; //		= 15000.0, -- maximum value of braking moment  , N*m 

public:
	double strutCompression;
	double wheelStrutDownAngle; // angle of strut (suspension, up/down)

	// current frictions applied on wheel
	double CxWheelFriction;
	double CzWheelFriction; // side-ways friction (should be Zbody axis)

	AnalogInput brakeInput; // braking command/input from user
	double brakeForce; // result force

	// from DCS, see ed_fm_suspension_feedback()
	Vec3 actingForce;
	Vec3 actingForcePoint;
	double integrityFactor;

	F35LandingWheel(const double wheelRadius, const double wheelInertia)
		: wheel_radius(wheelRadius) // all other same on each wheel? (check)
		, wheel_static_friction_factor(0.65)
		, wheel_side_friction_factor(0.65)
		, wheel_roll_friction_factor(0.025)
		, wheel_glide_friction_factor(0.28)
		, wheel_damage_force_factor(250.0)
		, wheel_damage_speed(150.0)
		, wheel_moment_of_inertia(wheelInertia) // <- should be different for nose wheel? (smaller wheel)
		, wheel_brake_moment_max(15000.0)
		, strutCompression(0)
		, wheelStrutDownAngle(0)
		, CxWheelFriction(0)
		, CzWheelFriction(0)
		, brakeInput(0, 1.0)
		, brakeForce(0)
		, actingForce()
		, actingForcePoint()
		, integrityFactor(0)
	{}
	~F35LandingWheel() {}

	bool isWoW() const
	{
		if (strutCompression > 0)
		{
			return true;
		}
		return false;
	}

	void setActingForce(double x, double y, double z)
	{
		actingForce.x = x;
		actingForce.y = y;
		actingForce.z = z;
	}
	void setActingForcePoint(double x, double y, double z)
	{
		actingForcePoint.x = x;
		actingForcePoint.y = y;
		actingForcePoint.z = z;
	}
	void setIntegrityFactor(double d)
	{
		integrityFactor = d;
	}

	double getStrutCompression() const
	{
		return strutCompression;
	}

	// we might get this directly at initialization so set here
	void setStrutCompression(const double compression)
	{
		strutCompression = compression;
	}

	double getStrutAngle() const
	{
		return wheelStrutDownAngle;
	}

	// expecting to be within limits,
	// change if something else is needed
	void setStrutAngle(const double angle)
	{
		wheelStrutDownAngle = angle;
	}

	/*
	double getUpLock() const
	{}
	double getDownLock() const
	{}
	*/

	void clearForceTotal()
	{
		CxWheelFriction = 0;
		CzWheelFriction = 0;
		brakeForce = 0;
	}

	// get rotation speed by ground speed and wheel radius
	double getRotationSpeed(const double groundSpeed) const
	{
		return 0;
	}

	// calculate new direction of force and if it exceeds friction (begins sliding)
	// TODO: need ground speed here for rolling/static friction
	// also, depending on how many wheels the weight is distributed on
	void updateForceFriction(const double groundSpeed, const double weightN)
	{
		clearForceTotal();
		if (isWoW() == false) // strut is not compressed -> no weight on wheel
		{
			return;
		}

		// TODO: calculate angular velocity (omega) by ground speed and wheel diameter,
		// then apply rolling friction (Dinamica_de_Veiculos)

		// TODO: also if wheel rotation is slower than speed relative to ground
		// -> apply sliding friction factor
		//if (braking && wheel locked (anti-skid==false) -> glide-factor?)

		if (brakeInput.getValue() > 0)
		{
			// just percentage of max according to input 0..1, right?
			brakeForce = abs(brakeInput.getValue()) * wheel_brake_moment_max; // * weightN;

			// if anti-skid is enabled -> check for locking
			// rotation speed of the wheel related to linear ground speed
			//weightN * wheel_glide_friction_factor if locking?

			// TODO: also consider wheel rotational inertia

			// apply brakeforce as reduction of inertia?
			/*  
			if (groundSpeed > 0 && brakeInput.getValue() > 0)
			{
			// check for rotation speed vs. groundspeed -> gliding or rotation? -> anti-skid
			}
			*/
		}

		// calculate wheel rotational speed:
		// if rotation stopped by braking but groundspeed > 0 -> slip friction
		// if rotation = 0 && groundspeed = 0 -> static friction
		// if rotation > 0 and groundspeed > 0 -> rolling friction

		// note: DCS has "left-hand notation" so side-slip is Z-axis?
		CzWheelFriction = wheel_side_friction_factor * weightN; // <- side-slip factor?

		if (groundSpeed > 0)
		{
			// just rolling friction?
			CxWheelFriction = (-wheel_roll_friction_factor * weightN);
		}
		else
		{
			// "static" friction needed to overcome to start moving?
			CxWheelFriction = (-wheel_static_friction_factor * weightN);
		}

	}
};

#endif // ifndef _F35LANDINGWHEEL_H_
