#ifndef _F35FUELSYSTEM_H_
#define _F35FUELSYSTEM_H_

#include "ED_FM_Utility.h"		// Provided utility functions that were in the initial EFM example
#include "F35Constants.h"		// Common constants used throughout this DLL

/*
average_fuel_consumption 	= 0.245, -- this is highly relative, but good estimates are 36-40l/min = 28-31kg/min = 0.47-0.52kg/s -- 45l/min = 35kg/min = 0.583kg/s
~0,775 kg/l?
*/

/* // properties of fuel (ignition point, energy released, weight) */
class FuelData
{
public:
	enum eFuelType
	{
		JP8
	};
	eFuelType type;

	//double pressure;
	//double compressibility;
	//double heat_release;

	// fuel/air mixture ignition limits:
	// amount air required for fuel to burn (lean/rich)
	//
	//double minIgnition;
	//double maxIgnition;
	//double flamepoint; // heatpoint for automatic ignition?
	//double freezepoint; // point where fuel freezes

	double weight; // weight in kg/l

	// TODO: use fuel weight in calculating how fits in tank
	// since they have different compressibility..

	FuelData() 
		: type(JP8)
		, weight(0.775) // kg/l
	{}
	~FuelData() {}


};
/**/

// we need fuel usage curve for the used engine here
// also calculation for the mass of the fuel and position of it

// F100-PW-229
//Specific fuel consumption: Military thrust: 77.5 kg/(kN�h) (0.76 lb/(lbf�h)) Full afterburner: 197.8 kg/(kN�h) (1.94 lb/(lbf�h))

/*
For example: 
49,000 PPH would be 7,000 gal/hr, 117 gal/min or 3 gal/sec 'roughly'. (Using 7 lbs/gal) 
49,000 PPH would be 7,368 gal/hr, 123 gal/min or 2 gal/sec 'roughly'. (Using 6.65 lbs/gal) 
*/

// three externals: wings and centerline station
// five internals: left and right wing tanks, two forward (F-1, F-2) and one aft (A-1) fuselage tank.
// fwd & aft reservoir
// total internal: [A] 6950 +- 300 (JP-4), 7290 +- 300 (JP-5/8) [B] 5650 +- 300, 5930 +- 300

// JP8 weight 6.65lbs/gal ?

// main fuel pump or AB fuel pump
class F35FuelPump
{
	// gearbox mounted on engine -> torque from engine to power fuel feeding?
public:

	double fuel_flow;

	F35FuelPump() 
		: fuel_flow(0)
	{}
	~F35FuelPump() {}
};


// add:
// - currently used (selected) station
// - support for internal tanks and external (pylons)
class F35FuelTank
{
public:
	int station; // do we need this here or not?

	double volume; // capacity of tank (in kg)
	double fuel; // amount of fuel in tank (in kg)

	//double pressurization; // how pressure tank causes for fuel?

	Vec3 position;
	Vec3 size; // bounding box

	F35FuelTank(double max_volume, double pos_x = 0, double pos_y = 0, double pos_z = 0)
		: station(0)
		, volume(max_volume)
		, fuel(0)
		, position(pos_x, pos_y, pos_z)
		, size()
	{}
	~F35FuelTank() {}

	// add what is possible, return remaining if full
	double addFuel(const double addition)
	{
		double space = volume - fuel;
		if (space < addition)
		{
			fuel = volume; // set to max
			return (addition - space); // overflow
		}
		fuel += addition;
		return 0;
	}

	double decFuel(const double decrement)
	{
		if (fuel < decrement)
		{
			double tmp = decrement - fuel;
			fuel = 0; // set to min
			return tmp; // remaining
		}
		fuel -= decrement;
		return 0;
	}

	double getSpace() const
	{
		return (volume - fuel);
	}
};

// TODO: fuel transfer between internal tanks etc.

class F35FuelSystem
{
protected:

	bool is_unlimited_fuel;
	double previous_usage;

public:

	// setting for "bingo fuel"
	double m_fuelWarningLimit; // in kg

	// Internal fuel as calculated by the EFM fuel system modeling
	//F35FuelTank FwdFus1; // foward fuselage 1
	//F35FuelTank FwdFus2; // forward fuselage 2
	//F35FuelTank FwdRes; // forward reservoir
	//F35FuelTank AftFus1; // aft fuselage
	//F35FuelTank AftRes; // aft reservoir


	F35FuelTank FwdFus; // forward combined
	F35FuelTank AftFus; // aft combined

	F35FuelTank LeftWing; // wing internal
	F35FuelTank RightWing; // wing internal

	// externals: one per wing plus centerline (if equipped)
	F35FuelTank ext_Center;
	F35FuelTank ext_LWing;
	F35FuelTank ext_RWing;

	// TODO: settings:
	// - crossfeed
	// - booster pumps

	// liquid mass parameters
	FuelData fuelData;

public:
	// TODO: check units !! (pounds)
	// 0.45359237 (1/2.2046)

	// TODO: add positions of tanks
	F35FuelSystem() 
		: is_unlimited_fuel(false)
		, previous_usage(0)
		, m_fuelWarningLimit(500.0) // in kg
		, FwdFus(3100 * F35::lb_to_kg, 1.0, 0.0, 0.0) // just use non-zero positions for now
		, AftFus(2800 * F35::lb_to_kg, -1.0, 0.0, 0.0)
		, LeftWing(525 * F35::lb_to_kg, 0.0, 0.0, 1.5)
		, RightWing(525 * F35::lb_to_kg, 0.0, 0.0, -1.5)
		, ext_Center(1800 * F35::lb_to_kg)
		, ext_LWing(2300 * F35::lb_to_kg)
		, ext_RWing(2300 * F35::lb_to_kg)
		, fuelData()
	{}
	~F35FuelSystem() {}

	/* 
	// for weight-balance calculation,
	// we need amount of fuel in each tank and position
	double getFuelMass()
	{
		// JP8 weight 6.65lbs/gal ?
		// -> ~0,775 kg/l?
		//return getInternalFuel() * weightconstant;
		//fuel.weight * getInternalFuel();

		// since we are calculating fuel in weight instead of volume
		// -> return total mass
		return getInternalFuel();
	}
	*/

	// is low fuel indication
	bool isLowFuel() const
	{
		// check remining fuel
		if (getInternalFuel() <= m_fuelWarningLimit)
		{
			return true;
		}
		return false;
	}

	// called on initialization and on refueling
	void setInternalFuel(const double fuel) // <- in kg
	{
		// distribute fuel to each tank for weight balance
		double addition = fuel;

		// TODO: transfer of fuel

		addition = AftFus.addFuel(addition);
		addition = FwdFus.addFuel(addition);

		addition = LeftWing.addFuel(addition);
		addition = RightWing.addFuel(addition);
	}

	// total internal fuel in kg
	double getInternalFuel() const
	{
		return (FwdFus.fuel + AftFus.fuel + LeftWing.fuel + RightWing.fuel);
	}

	// not ready yet
	void setExternalFuel(int station, double fuel, double x, double y, double z)
	{
	}
	// not ready yet
	double getExternalFuel() const
	{
		return 0;
	}

	void refuelAdd(const double fuel) // <- in kg
	{
		// TODO: transfer of fuel

		// aerial refuel support: add given amount of fuel
		setInternalFuel(fuel);
	}

	void dumpFuel(const double frameTime)
	{
		// TODO: transfer of fuel

		// amount of fuel dumped from tanks within frame,
		// decrement from tanks
	}

	void setUnlimitedFuel(bool status)
	{
		is_unlimited_fuel = status;
	}

	double getUsageSinceLastFrame() const
	{
		return previous_usage;
	}
	void clearUsageSinceLastFrame()
	{
		previous_usage = 0;
	}

	void updateFrame(const double fuelPerFrame, const double frameTime)
	{
		// TODO: decrement from tanks by order of usage
		// TODO: usage by throttle setting / altitude?

		if (is_unlimited_fuel == true)
		{
			return;
		}
		if (getInternalFuel() == 0 && is_unlimited_fuel == false)
		{
			return;
		}

		previous_usage += fuelPerFrame; // add to usage since last time updated

		double fueltmp = fuelPerFrame;

		// TODO: transfer of fuel between tanks

		fueltmp = RightWing.decFuel(fueltmp);
		fueltmp = LeftWing.decFuel(fueltmp);

		fueltmp = FwdFus.decFuel(fueltmp);
		fueltmp = AftFus.decFuel(fueltmp);
	}

	// internal fuel transfer
	void transferFuel()
	{
		// transfer from external tanks to wings and fuselage tanks when consuming

		// transfer from wings to fuselage tanks when consuming
	}
};

#endif // ifndef _F35FUELSYSTEM_H_
