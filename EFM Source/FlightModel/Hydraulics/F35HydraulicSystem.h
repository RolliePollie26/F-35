#ifndef _F35HYDRAULICSYSTEM_H_
#define _F35HYDRAULICSYSTEM_H_

#include "F35Constants.h"

#include "Hydraulics/F35HydraulicPump.h"

// two systems: system A and B
// have both in same or different instances?

//class F35HydraulicReservoir

// amount of hydraulic fluid in system
// pressure
// pump

class F35HydraulicSystem
{
public:
	//AbstractHydraulicDevice devices[];

	// two pumps: system A and system B
	// operated from ADG by engine
	F35HydraulicPump *pumpA;
	F35HydraulicPump *pumpB;

	//F35Actuator *leading_edge;
	//F35Actuator *aileron;
	//F35Actuator *elevator;
	//F35Actuator *rudder;
	//F35Actuator *speedbrake;

	//F35Actuator *landing_gear;

	//F35LandingGear *landingGear;

	F35HydraulicSystem() 
	{
		pumpA = new F35HydraulicPump(this);
		pumpB = new F35HydraulicPump(this);
	}
	~F35HydraulicSystem() 
	{
		delete pumpB;
		delete pumpA;
	}

	bool isWarning() const
	{
		if (pumpA->isWarning()
			|| pumpB->isWarning())
		{
			return true;
		}
		return false;
	}

	// need either engine torque or RPM here for pump operating information,
	// use RPM for now, also add power usage in actuators
	void updateFrame(const double frameTime)
	{
		/*
		const double engineRPM = pEngine->getRpm();
		pumpA->updateFrame(engineRPM, frameTime);
		pumpB->updateFrame(engineRPM, frameTime);
		*/
	}

};

#endif // ifndef _F35HYDRAULICSYSTEM_H_

