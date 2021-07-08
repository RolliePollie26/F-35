#ifndef _F35GEARBOX_H_
#define _F35GEARBOX_H_

#include "ED_FM_Utility.h"		// Provided utility functions that were in the initial EFM example
#include "F35Constants.h"		// Common constants used throughout this DLL

/*
main engine is connected to gearbox which powers 
hydraulic pumps, fuel pumps and has some torque resistance on engine.

also JFS is connected to gearbox for rotating engine, especially during startup.
*/

class F35Gearbox
{
public:
	//double engineTorque;
	double engineRpm;

	//F35FuelPump *pFuelPump;
	//F35MainGenerator *pGenerator;
	//F35HydraulicSystem *pHydrPump;

public:
	F35Gearbox() 
		: engineRpm(0)
	{}
	~F35Gearbox() {}

	// update with engine/APU rpm/torque
	// and power consumption:
	// logic for EPU/JFS/main engine torque distribution
	// to various systems (hydraulics etc)
	void updateFrame(const double frameTime)
	{
		// APU (JFS) torque -> to engine for starting
		// without APU, engine -> auxiliary systems
		// airstart when engine rotating? (disconnect aux systems?)
		// reduction in rpm when windmilling -> limiting on airstart?

		/*
		if (engineTorque > threshold)
		{
			pAux->update(engineTorque, engineRpm)
		}
		**/
		/*
		// JFS will provide assistance to main engine in some cases
		// in addition to starting power
		if (engineTorque < threshold)
		{
			pJfs->update(pEngine)
		}
		*/

	}
};

#endif // ifndef _F35GEARBOX_H_

