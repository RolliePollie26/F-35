#ifndef _F35ELECTRICBUS_H_
#define _F35ELECTRICBUS_H_

#include "ED_FM_Utility.h"		// Provided utility functions that were in the initial EFM example
#include "F35Constants.h"		// Common constants used throughout this DLL

//#include "Electrics/AbstractElectricDevice.h"

/*

sources:
- NASA TP 2857

*/

class F35ElectricBus
{
protected:
	// type: AC no 1, AC no 2, DC "battery" bus
	// voltage: 28V DC?
	// on/off
	// battery/generator status?

	//AbstractElectricDevice devices[];

public:
	F35ElectricBus() {}
	~F35ElectricBus() {}

	
	void updateFrame(const double frameTime)
	{
	}

};

#endif // ifndef _F35ELECTRICBUS_H_

