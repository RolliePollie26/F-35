#ifndef _F35ACDCCONVERTER_H_
#define _F35ACDCCONVERTER_H_

#include "ED_FM_Utility.h"		// Provided utility functions that were in the initial EFM example
#include "F35Constants.h"		// Common constants used throughout this DLL

#include "Electrics/AbstractElectricDevice.h"


/*
// also inverter/regulator?
// also transformer rectifier (TR) ? (500VA)

sources:
- NASA TP 2857

*/

class F35AcDcConverter : public AbstractElectricDevice
{
public:
	F35AcDcConverter(void *_parentSystem) 
		: AbstractElectricDevice(_parentSystem)
	{}
	~F35AcDcConverter() {}

	void updateFrame(const double frameTime)
	{
	}

};

#endif // ifndef _F35ACDCCONVERTER_H_

