#ifndef _F35EPU_H_
#define _F35EPU_H_

#include "ED_FM_Utility.h"		// Provided utility functions that were in the initial EFM example
#include "F35Constants.h"		// Common constants used throughout this DLL

/*
EPU = emergency power unit

-> get bleed air from engine and/or use hydrazine
-> emergency hydraulic pressure to system A
-> emergency electrical power

5kVA ?

sources:
- NASA TP 2857

*/

class F35EPU
{
protected:
	bool m_isRunning;

	// if EPU/GEN test switch is used
	bool testSwitch;

	// high-pressure bleed air from engine
	double highBleedAir;

	// hydraulic pressure to/from ?
	double hydrPress;

	// AC/DC buses?

	// warning light status
	bool hydrazineLight; 

	//F35ElectricSystem *pElecSys;
	//F35HydraulicSystem *pHydSys;

public:
	F35EPU() 
		: m_isRunning(false)
		, testSwitch(false)
		, highBleedAir(0)
		, hydrPress(0)
		, hydrazineLight(false)
	{}
	~F35EPU() {}

	void setHighPressureBleedAir(const double value)
	{
		highBleedAir = value;
	}

	// EMS may order to start if engine RPM too low
	void start()
	{
	}
	void stop()
	{
	}

	void updateFrame(const double frameTime)
	{
		//if (testSwitch)

		//if (highBleedAir < limit)
		//-> augment with hydrazine
	}

};

#endif // ifndef _F35EPU_H_

