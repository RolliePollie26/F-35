#ifndef _F35FCSTRAILINGFLAPCONTROLLER_H_
#define _F35FCSTRAILINGFLAPCONTROLLER_H_

#include <cmath>

#include "UtilityFunctions.h"

#include "F35FcsCommon.h"
#include "F35Actuator.h"

class F35FcsTrailingFlapController
{
protected:
	F35BodyState *bodyState;
	F35FlightSurface *flightSurface;

	// flap control at transonic speeds:
	// 0..-2 at Qc/Ps 0.787...1.008, 0.8975 is one deg pos?
	LinearFunction<double> transonicFlap;

	// flap control at low speed:
	// get proper values and calculation
	//LinearFunction<double> lowspeedFlap;

	// lowers flaps a few degrees when enabled?
	// check this
	bool isAirRefuelMode;

public:
	F35FcsTrailingFlapController() :
		bodyState(nullptr),
		flightSurface(nullptr),
		transonicFlap(0.1105, 0.787, 0.787, 1.008, 0, 2), // <- use positive values for flaps
		//lowspeedFlap(),
		isAirRefuelMode(false)
	{}
	~F35FcsTrailingFlapController() {}

	void setRef(F35BodyState *bs, F35FlightSurface *fs)
	{
		bodyState = bs;
		flightSurface = fs;
	}

	// Passive flap schedule for the F-16...nominal for now from flight manual comments
	// below specific dynamic pressure (q) -> function as flaps,
	// otherwise only as ailerons.
	// Normally flaps are down when gear lever is down.
	// With alternate flaps switch, flaps are extended regardless of gear lever.
	//
	// " they will also come down with gear up at a defined low airspeed depending on ADC input"
	// -> need better info..
	// Trailing edge flap deflection (deg)
	// Note that flaps should be controlled by landing gear level:
	// when gears go down flaps go down as well.
	//
	// In normal flight, flaps are used like normal ailerons.
	//
	void fcsCommand(bool isGearUp, bool isAltFlaps, const double qbarOverPs)
	{
		// use positive values
		const double tef_min = 0.0;
		const double tef_max = 20.0;

		// TODO: electrical bias on adjustment?

		/*
		// lower tef by some degrees?
		// triggered by refueling trap door?
		if (isAirRefuelMode == true)
		{
		return 5.0; // <- just some value for placeholder, figure out right one
		}
		*/

		// flaps in transonic speeds? 
		// -2 deg when qbarOverPs >= 1.008
		// 0..-2 deg when qbarOverPs >= 0.787 && qbarOverPs <= 1.008

		// no "alt flaps" and lg is up -> no flap deflection
		if (isAltFlaps == false && isGearUp == true)
		{
			//flightSurface->flap_Command = tef_min;

			// linear multiplier of the input
			flightSurface->flap_Command = transonicFlap.result(qbarOverPs);
			return;
		}

		// also: hydraulic pressure limit on startup/shutdown?

		// else if gear lever is down -> max flaps
		// else if alt flap switch -> max flaps

		// speed high enough -> no flap deflection
		if (qbarOverPs > 0.22) // ~190m/s, 0.22(qbar/ps)
		{
			// no deflection
			flightSurface->flap_Command = tef_min;
			return;
		}

		// low speed -> full deflection
		if (qbarOverPs < 0.09) // ~123m/s, 0.09(qbar/ps)
		{
			// max deflection
			flightSurface->flap_Command = tef_max;
			return;
		}

		// TODO: replace with: lowspeedFlap

		// otherwise deflection is some value in between..
		//if ((airspeed_KTS >= 240.0) && (airspeed_KTS <= 370.0))
		double trailing_edge_flap_deflection = (1.0 - ((qbarOverPs - 0.09) / (0.22 - 0.09))) * 20.0;
		flightSurface->flap_Command = limit(trailing_edge_flap_deflection, tef_min, tef_max);

		// TODO: roll combination in mixer
	}
};

#endif // ifndef _F35FCSTRAILINGFLAPCONTROLLER_H_
