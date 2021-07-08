#ifndef _F35ELECTRICSYSTEM_H_
#define _F35ELECTRICSYSTEM_H_

#include "ED_FM_Utility.h"		// Provided utility functions that were in the initial EFM example
#include "F35Constants.h"		// Common constants used throughout this DLL

#include "Electrics/F35AcDcConverter.h"
#include "Electrics/F35Battery.h"
#include "Electrics/F35ElectricBus.h"
#include "Electrics/F35MainGenerator.h"

/*
sources:
- NASA TP 2857

*/

class F35ElectricSystem
{
protected:
	F35Battery battery;

	// bit too generic: FC3 style use only
	bool electricsOnOff;

	// type: AC no 1, AC no 2, DC "battery" bus
	F35ElectricBus AcNo1;
	F35ElectricBus AcNo2;
	F35ElectricBus DcBat;

public:
	F35ElectricSystem() 
		: battery()
		, electricsOnOff(false)
	{}
	~F35ElectricSystem() {}

	// FC3 style electric power on/off ("all in one")
	void toggleElectrics()
	{
		electricsOnOff = !electricsOnOff;
	}
	void setElectricsOnOff(bool status)
	{
		electricsOnOff = status;
	}
	void toggleBatteryOnOff()
	{
	}

	// update with engine/APU rpm/torque
	// and power consumption
	void updateFrame(const double frameTime)
	{
	}

};

#endif // ifndef _F35ELECTRICSYSTEM_H_

