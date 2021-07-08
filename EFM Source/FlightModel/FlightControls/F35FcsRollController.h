#ifndef _F35FCSROLLCONTROLLER_H_
#define _F35FCSROLLCONTROLLER_H_

#include <cmath>

#include "UtilityFunctions.h"

#include "F35FcsCommon.h"
#include "F35Actuator.h"


class F35FcsRollController
{
protected:
	F35BodyState *bodyState;
	F35FlightSurface *flightSurface;
	F35TrimState *trimState;

	Limiter<double>		rollCommandLimiter;

	// amount of hta for roll
	//LinearFunction<double> tailRoll;

protected:

	// this code is given longitudinal (pitch) force, but can't find out why..
	// bug from some old stuff?
	double getRollFeelGain(const double stickForce) const
	{
		double stickForceGained = stickForce * 0.0667;
		double rollFeelGain = 0.0;
		if (abs(stickForce) > 25.0)
		{
			rollFeelGain = 0.7;
		}
		else if (stickForce >= 0.0)
		{
			rollFeelGain = -0.012 * stickForceGained + 1.0;
		}
		else if (stickForce < 0.0)
		{
			rollFeelGain = 0.012 * stickForceGained + 1.0;
		}
		return rollFeelGain;
	}

	double getRollRateCommand(const double latStickForceFinal) const
	{
		double rollRateCommand = 0.0;
		if (abs(latStickForceFinal) < 3.0)
		{
			rollRateCommand = 0.0;
		}
		else if ((latStickForceFinal >= 3.0) && (latStickForceFinal <= 25.0))
		{
			rollRateCommand = 0.9091 * latStickForceFinal - 2.7273;
		}
		else if ((latStickForceFinal > 25.0) && (latStickForceFinal <= 46.0))
		{
			rollRateCommand = 2.8571 * latStickForceFinal - 51.429;
		}
		else if ((latStickForceFinal > 46.0))
		{
			rollRateCommand = 7.5862 * latStickForceFinal - 268.97;
		}
		else if ((latStickForceFinal <= -3.0) && (latStickForceFinal >= -25.0))
		{
			rollRateCommand = 0.9091 * latStickForceFinal + 2.7273;
		}
		else if ((latStickForceFinal < -25.0) && (latStickForceFinal >= -46.0))
		{
			rollRateCommand = 2.8571 * latStickForceFinal + 51.429;
		}
		else if ((latStickForceFinal < -46.0))
		{
			rollRateCommand = 7.5862 * latStickForceFinal + 268.97;
		}
		return rollRateCommand;
	}

	double getPressureGain(double dynamicPressure_NM2) const
	{
		double pressureGain = 0.0;
		if (dynamicPressure_NM2 < 19153.0)
		{
			pressureGain = 0.2;
		}
		else if ((dynamicPressure_NM2 >= 19153.0) && (dynamicPressure_NM2 <= 23941.0))
		{
			pressureGain = -0.00002089 * dynamicPressure_NM2 + 0.6;
		}
		else
		{
			pressureGain = 0.1;
		}
		return pressureGain;
	}

public:
	F35FcsRollController() :
		bodyState(nullptr),
		flightSurface(nullptr),
		trimState(nullptr),
		rollCommandLimiter(-21.5, 21.5) // roll limit should be -40..40 here? (roll command, not actuator)
		//tailRoll(1, 0.694, 1.132, 0.25, 0.50)
	{}
	~F35FcsRollController() {}

	void setRef(F35BodyState *bs, F35FlightSurface *fs, F35TrimState *ts)
	{
		bodyState = bs;
		flightSurface = fs;
		trimState = ts;
	}

	// Controller for roll
	void fcsCommand(double latStickInput, double longStickForce, double dynamicPressure_NM2, bool isGearUp, bool isAltFlaps)
	{
		const double roll_rate = bodyState->getRollRateDegs();

		// TODO: in case of alpha > (limit), lateral input is ignored (yaw limiter)


		// TODO: calculate elevon differential operation (aileron functionality)
		// and symmetrical operation (elevator functionality)

		double ay = bodyState->getAccYPerG();
		double latStickForceCmd = latStickInput * 75.0;
		double latStickForceBiased = latStickForceCmd - (ay * 8.9);  // CJS: remove side acceleration bias?

		double rollFeelGain = getRollFeelGain(longStickForce); // <- bug? (should be lateral?)
		double rollRateCommand = getRollRateCommand(latStickForceBiased * rollFeelGain);

		// stick force, roll cmd gradient -> 1.0 || 0.542 (LG lever, flaps)..
		//if (isGearUp == false || isAltFlaps == true)

		double rollRateCommandCombined = roll_rate - rollRateCommand - trimState->trimRoll;

		double pressureGain = getPressureGain(dynamicPressure_NM2);

		// actuator actually limited to 20 deg?
		flightSurface->roll_Command = rollCommandLimiter.limit(rollRateCommandCombined * pressureGain);

		// also, using elevators for roll control:
		// hta proportional to fl deflection: 0.294 of fl deflection in some condition
	}
};

#endif // ifndef _F35FCSROLLCONTROLLER_H_
