#ifndef _F35BATTERY_H_
#define _F35BATTERY_H_

#include "ED_FM_Utility.h"		// Provided utility functions that were in the initial EFM example
#include "F35Constants.h"		// Common constants used throughout this DLL

#include "Electrics/AbstractElectricDevice.h"

/*

sources:
- NASA TP 2857

*/

class F35Battery //: public AbstractElectricDevice
{
public:
	// 28V DC?

	// battery "storage" values
	// discharge rate
	// charging rate

	// if battery power turned on
	bool m_isOn;

public:
	F35Battery() 
		: m_isOn(false)
	{}
	~F35Battery() {}

	void updateFrame(const double frameTime)
	{
	}
};

#endif // ifndef _F35BATTERY_H_

