#ifndef _F35BLEEDAIRSYSTEM_H_
#define _F35BLEEDAIRSYSTEM_H_

#include "ED_FM_Utility.h"		// Provided utility functions that were in the initial EFM example
#include "F35Constants.h"		// Common constants used throughout this DLL

/*
 bleed air from jet engine can be used for various thing (anti-ice, oxygen generator..),
 handle that system here

 -> air conditioning (cabin pressure, cockpit temperature)

 -> anti-ice

 F100-PW-200
 -> to AB fuel pump (driven by this)
 (low) -> fan duct (avoid compressor stall)

 (high) -> EPU
 (high/low) -> ECS

 F100-PW-220
 -> to AB fuel pump (driven by this)
 (low) -> fan duct (avoid compressor stall)
 -> anti-icing

 -> CENC

 (high) -> EPU
 (high/low) -> ECS

*/

class F35BleedAirSystem
{
protected:
	// 
	//double currentEngineRpm;

	double lowpressure;
	double highpressure;

	// TODO:
	//F35FuelPump *pABFuelPump;
	//F35EnvControlSystem *pEnvSystem;
	//F35EPU *pEpu;

public:
	F35BleedAirSystem() 
		: lowpressure(0)
		, highpressure(0)
	{}
	~F35BleedAirSystem() {}

	// update with engine/APU rpm/torque
	// and power consumption
	void updateFrame(const double frameTime)
	{
		// add logic to system control:
		// valves open/close etc. in various conditions

	}

	/*
	// we might need to calculate air pressure directly in engine code
	// due to differences in engines?
	void setEngineRpm(const double value)
	{
	}
	*/

	// actually, there's "high" and "low" pressure from the engine
	// -> set them from engine
	void setLowPressureBleedAir(const double value)
	{
		// just a function of engine RPM?
		lowpressure = value;
	}
	void setHighPressureBleedAir(const double value)
	{
		// just a function of engine RPM?
		highpressure = value;
	}

};

#endif // ifndef _F35BLEEDAIRSYSTEM_H_

