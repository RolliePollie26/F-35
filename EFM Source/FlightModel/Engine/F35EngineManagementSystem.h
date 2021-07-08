#ifndef _F35ENGINEMANAGEMENTSYSTEM_H_
#define _F35ENGINEMANAGEMENTSYSTEM_H_

#include "ED_FM_Utility.h"		// Provided utility functions that were in the initial EFM example
#include "F35Constants.h"		// Common constants used throughout this DLL

#include "Atmosphere/F35Atmosphere.h"

#include "Engine/F35Engine.h"					//Engine model functions
#include "Engine/F35FuelSystem.h"				//Fuel usage and tank usage functions

#include "Engine/F35JFS.h"						//APU
#include "Engine/F35EPU.h"						//Emergency Power Unit (electric&hydraulic power)
#include "Engine/F35BleedAirSystem.h"
#include "Engine/F35Gearbox.h"


/*
 aka Engine Monitoring System (EMS)
*/
//class F35FuelOilCooler

//class F35OilSystem

//class F35FuelControl

/*
class F35Alternator
{};
*/

// PRI / SEC
enum eABResetSwitch
{
	AB_RESET,
	AB_NORM,
	ENGDATA
};


class F35EngineManagementSystem
{
public:
	F35EPU Epu;
	F35JFS JFS;

	F35Atmosphere *pAtmos;
	F35FuelSystem *pFuel;

	// main engine: turbofan with AB
	F35Engine Engine;

	// logic for EPU/JFS/main engine torque
	F35Gearbox Gearbox;

	// logic for bleed air to env system, anti-ice, back to engine etc.
	F35BleedAirSystem BleedAir;
	//BleedAir.pEpu = &Epu;

	double	throttleInput;	// Throttle input command normalized (-1 to 1)

public:
	F35EngineManagementSystem(F35Atmosphere *atmos, F35FuelSystem *fuels) 
		: pAtmos(atmos)
		, pFuel(fuels)
		, Engine(ET_F100PW200, atmos)
		, Gearbox()
		, BleedAir()
		, throttleInput(0)
	{}
	~F35EngineManagementSystem() {}

	void initEngineOff()
	{
		Engine.isIgnited = false;
		throttleInput = 0;
	}
	void initEngineIdle()
	{
		Engine.isIgnited = true;
		setThrottleInput(0.01);
	}
	void initEngineCruise()
	{
		Engine.isIgnited = true;
		setThrottleInput(0.80);
	}

	void JfsStart()
	{
		// just direct start for now..
		startEngine();
	}
	void JfsStop()
	{
	}

	void startEngine()
	{
		// just direct start for now..
		initEngineIdle();
	}
	void stopEngine()
	{
		// just direct stop..
		initEngineOff();
	}

	// MaksRUD	=	0.85, -- Military power state of the throttle
	// ForsRUD	=	0.91, -- Afterburner state of the throttle
	void setThrottleInput(double value)
	{
		if (Engine.isIgnited == false)
		{
			return;
		}

		// old code, see if we need changes..
		throttleInput = limit(((-value + 1.0) / 2.0) * 100.0, 0.0, 100.0);

		// --------------------------- OLD STUFF
		// Coded from the simulator study document
		if (throttleInput < 78.0)
		{
			Engine.m_percentPower = throttleInput * 0.6923;
		}
		else
		{
			Engine.m_percentPower = throttleInput *4.5455 - 354.55;
		}
		Engine.m_percentPower = limit(Engine.m_percentPower, 0.0, 100.0);

		// TODO: calculate fuel mixture needed for given throttle setting and flight conditions
	}

	double getEngineRpm() const
	{
		if (Engine.isIgnited == false) // ignore throttle setting if engine is not running
		{
			return 0;
		}

		// ED_FM_ENGINE_1_RPM:
		return (throttleInput / 100.0) * 3000;
	}
	double getEngineRelatedRpm() const
	{
		if (Engine.isIgnited == false)
		{
			return 0;
		}

		// ED_FM_ENGINE_1_RELATED_RPM:
		return (throttleInput / 100.0);
	}
	double getEngineThrust() const
	{
		if (Engine.isIgnited == false)
		{
			return 0;
		}

		// ED_FM_ENGINE_1_THRUST:
		return (throttleInput / 100.0) * 5000 * 9.81;
	}
	double getEngineRelatedThrust() const
	{
		if (Engine.isIgnited == false)
		{
			return 0;
		}

		// ED_FM_ENGINE_1_RELATED_THRUST:
		return (throttleInput / 100.0);
	}

	/*
	double getThrottleInput() const
	{
		return Engine.throttleInput;
	}
	*/

	double getFuelPerFrame() const
	{
		return Engine.getFuelPerFrame();
	}

	void updateFrame(const double frameTime)
	{
		// 
		//Engine CIVV control

		//pFuel->updateFrame(frameTime);
		//Engine.updateFrame(frameTime);
		Engine.updateOldStuff(frameTime); // use old stuff for now until new code is ready

		/*
		if (getEngineRpm() < minRpm)
		{
			Epu.start();
		}
		*/

		Epu.updateFrame(frameTime);
		JFS.updateFrame(frameTime);
		Gearbox.updateFrame(frameTime);
		BleedAir.updateFrame(frameTime);
	}


	float getAfterburnerDraw() const
	{
		return (float)Engine.afterburnerDraw;
	}

	// TODO: we'll need to control nozzle position:
	// for example, landing gear out -> open nozzle more 
	// to reduce possibility of power loss
	float getNozzlePos() const
	{
		return (float)Engine.afterburnerDraw;
	}

	// return gyroscopic effect of engine for motions,
	// use angular momentum directly now
	double getTurbineMomentum() const
	{
		return Engine.engineParams.angular_momentum;
	}

};

#endif // ifndef _F35ENGINEMANAGEMENTSYSTEM_H_

