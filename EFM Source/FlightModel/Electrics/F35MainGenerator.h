#ifndef _F35MAINGENERATOR_H_
#define _F35MAINGENERATOR_H_

#include "ED_FM_Utility.h"		// Provided utility functions that were in the initial EFM example
#include "F35Constants.h"		// Common constants used throughout this DLL

#include "Electrics/AbstractElectricDevice.h"


/*
main generator/primary generator

sources:
- NASA TP 2857
*/

// 40 kVA generator?

// alternator
class F35MainGenerator : public AbstractElectricDevice
{
public:
	F35MainGenerator(void *_parentSystem) 
		: AbstractElectricDevice(_parentSystem)
	{}
	~F35MainGenerator() {}

	void updateFrame(const double frameTime)
	{
	}

};

#endif // ifndef _F35MAINGENERATOR_H_

