#ifndef _F35ENVCONTROLSYSTEM_H_
#define _F35ENVCONTROLSYSTEM_H_

#include "F35Constants.h"

#include "Atmosphere/F35Atmosphere.h"			//Atmosphere model functions

#include "EnvironmentalSystem/F35AirConditioning.h"
#include "EnvironmentalSystem/F35OxygenSystem.h"


// ENVIRONMENTAL CONTROL SYSTEM (ECS)
// cockpit pressure, temperature, sealing, defogging, G-suit pressure, fuel tank pressure, equipment cooling


// use high/low bleed air pressure from engine

// TODO: G-suit pressure..

class F35EnvControlSystem
{
protected:
	double lowpressure;
	double highpressure;

	// TODO: cockpit pressure in pascals over external (get update from oxygen system also)
	double cockpitPressure;

public:
	F35AirConditioning AirCond;
	F35OxygenSystem Oxy;

	F35Atmosphere *pAtmos;

public:
	F35EnvControlSystem(F35Atmosphere *atmos)
		: lowpressure(0)
		, highpressure(0)
		, cockpitPressure(0)
		, AirCond()
		, Oxy()
		, pAtmos(atmos)
	{}
	~F35EnvControlSystem() {}

	void setOxygenSystem(float value)
	{
		// value currently ignored, just use as event trigger
		Oxy.setDiluterNormal();
	}

	// TODO:
	// get cockpit pressure in pascals over external (get update from oxygen system also)
	// -> set to ambient pressure when canopy gone or failure in ECS
	double getCockpitPressure() const
	{
		return cockpitPressure;
	}

	void updateFrame(const double frameTime)
	{
		// logic of using high/low pressure of bleed air?
			
		Oxy.updateFrame(pAtmos->ambientPressure, pAtmos->altitude, frameTime);

		// just use oxygen system pressure directly?
		cockpitPressure = Oxy.getPressure();

	}

	// there's "high" and "low" pressure from the engine
	void setLowPressureBleedAir(const double value)
	{
		lowpressure = value;
	}
	void setHighPressureBleedAir(const double value)
	{
		highpressure = value;
	}
};

#endif // ifndef 
