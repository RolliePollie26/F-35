#ifndef _F35PMG_H_
#define _F35PMG_H_

#include "ED_FM_Utility.h"		// Provided utility functions that were in the initial EFM example
#include "F35Constants.h"		// Common constants used throughout this DLL

#include "Electrics/AbstractElectricDevice.h"

/*
permanent magnetic generator

sources:
- NASA TP 2857

*/

class F35PMG : public AbstractElectricDevice
{
public:
	F35PMG(void *_parentSystem) 
		: AbstractElectricDevice(_parentSystem)
	{}
	~F35PMG() {}

	void updateFrame(const double frameTime)
	{
	}

};

#endif // ifndef _F35PMG_H_

