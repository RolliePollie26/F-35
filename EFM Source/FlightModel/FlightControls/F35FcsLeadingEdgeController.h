#ifndef _F35FCSLEADINGEDGECONTROLLER_H_
#define _F35FCSLEADINGEDGECONTROLLER_H_

#include <cmath>

#include "UtilityFunctions.h"

#include "F35FcsCommon.h"
#include "F35Actuator.h"

class F35FcsLeadingEdgeController
{
protected:
	F35BodyState *bodyState;
	F35FlightSurface *flightSurface;

	double		leading_edge_flap_integral;
	double		leading_edge_flap_integrated;
	double		leading_edge_flap_rate;
	double		leading_edge_flap_final;

	Limiter<double>		lefLimiter;


	// flap control at transonic speeds:
	// 0..-2 at Qc/Ps 0.787...1.008, 0.8975 is one deg pos?
	LinearFunction<double> transonicFlap;

	// is in automatic operation or locked in position
	bool isAuto;

public:
	F35FcsLeadingEdgeController() :
		bodyState(nullptr),
		flightSurface(nullptr),
		leading_edge_flap_integral(0),
		leading_edge_flap_integrated(0),
		leading_edge_flap_rate(0),
		leading_edge_flap_final(0),
		lefLimiter(-2, 25),
		transonicFlap(0.1105, 0.787, 0.787, 1.008, 0, 2), // <- change to negative in output
		isAuto(true)
	{}
	~F35FcsLeadingEdgeController() {}

	void setRef(F35BodyState *bs, F35FlightSurface *fs)
	{
		bodyState = bs;
		flightSurface = fs;
	}

	void setAutoLocked(bool onoff)
	{
		isAuto = onoff;
	}

	// Controller for the leading edge flaps
	// symmetrical, as function of alpha and mach number
	void fcsCommand(const double qbarOverPs, const bool isWoW, const double frameTime)
	{
		// is in automatic mode?
		if (isAuto == false)
		{
			// locked -> no change
			return;
		}

		// TODO: fix rest of handling for this too
		// actuator movement needs support too
		if (isWoW == true)
		{
			// weight on wheels -> lock to -2 degrees (up)
			flightSurface->leadingEdgeFlap_Command = -2.0;
			return;
		}

		// TODO:
		// also add handling in transonic speeds..
		// something like this..
		/**/
		if (qbarOverPs >= transonicFlap.minRange)
		{
			flightSurface->leadingEdgeFlap_Command = -transonicFlap.result(qbarOverPs);
			return;
		}
		/**/

		leading_edge_flap_rate = (bodyState->alpha_DEG - leading_edge_flap_integrated) * 7.25;
		leading_edge_flap_integral += (leading_edge_flap_rate * frameTime);

		leading_edge_flap_integrated = leading_edge_flap_integral + bodyState->alpha_DEG * 2.0;

		double lef_gained = leading_edge_flap_integrated * 1.38;
		double press = (9.05 * qbarOverPs) + 1.45;
		leading_edge_flap_final = lef_gained - press;

		flightSurface->leadingEdgeFlap_Command = lefLimiter.limit(leading_edge_flap_final);
	}
};

#endif // ifndef _F35FCSLEADINGEDGECONTROLLER_H_
