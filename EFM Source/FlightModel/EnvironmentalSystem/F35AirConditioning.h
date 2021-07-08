#ifndef _F35AIRCONDITIONING_H_
#define _F35AIRCONDITIONING_H_

#include "ED_FM_Utility.h"		// Provided utility functions that were in the initial EFM example
#include "F35Constants.h"		// Common constants used throughout this DLL

// heating/cooling temperature control
// electric operated

class F35AirConditioning
{
protected:
	enum eAirSourceKnob // air source knob
	{
		EAS_OFF,
		EAS_NORM,
		EAS_DUMP,
		EAS_RAM
	};
	enum eTempKnob
	{
		ETMP_AUTO,
		ETMP_MAN,
		ETMP_OFF
	};
	enum eDefogKnob
	{
		EDFG_MIN,
		EDFG_MAX
	};
	eAirSourceKnob airsourceKnob = EAS_OFF;
	eTempKnob tempKnob = ETMP_AUTO;
	eDefogKnob defogKnob = EDFG_MIN;

public:
	F35AirConditioning() {}
	~F35AirConditioning() {}

	void updateFrame(const double frameTime)
	{
		// heat transfer
	}
};

#endif // ifndef _F35AIRCONDITIONING_H_
