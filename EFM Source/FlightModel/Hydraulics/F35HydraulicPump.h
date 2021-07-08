#ifndef _F35HYDRAULICPUMP_H_
#define _F35HYDRAULICPUMP_H_

#include "F35Constants.h"

#include "AbstractHydraulicDevice.h"

// pump provides pressure to hydraulic system so that other devices can operate

// TODO: need engine power to operate and generate pressure (ADG)

// also reservoir?
// maintain positive pressure at pump
class F35HydraulicReservoir
{
public:
	F35HydraulicReservoir() {}
	~F35HydraulicReservoir() {}
};

class F35HydraulicPump : public AbstractHydraulicDevice
{
public:
	// pressure provided for devices
	// 3000 psi max?
	double pressure;

	F35HydraulicReservoir reservoir;

	F35HydraulicPump(void *_parentSystem) 
		: AbstractHydraulicDevice(_parentSystem)
		, pressure(0)
		, reservoir()
	{}
	~F35HydraulicPump() {}

	bool isWarning() const
	{
		if (pressure < 1000)
		{
			return true;
		}
		return false;
	}

	// engine RPM or torque here?
	void updateFrame(const double engineRpm, const double frameTime)
	{
		if (engineRpm > 0)
		{
			pressure = 3000;
		}
		else
		{
			pressure = 0;
		}
	}
};

#endif // ifndef _F35HYDRAULICPUMP_H_


