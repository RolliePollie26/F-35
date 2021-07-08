/*
	weight balance calculations, determine center of gravity

sources:
- 68548, Model of F-16 Fighter Aircraft - Equation of Motions

*/

#ifndef _F35WEIGHTBALANCE_H_
#define _F35WEIGHTBALANCE_H_

#include <cmath>

#include "ED_FM_Utility.h"		// Provided utility functions that were in the initial EFM example
#include "F35Constants.h"		// Common constants used throughout this DLL

// mostly amount of fuel at different stations matter here
// (unless we start adding payload support into flight model)
class F35WeightBalance
{
public:

	// calculate new center of gravity
	// for using in motion calculations
	Vec3 balanced_center_of_gravity;
	//double total_mass_kg; // new "wet" mass with balance

	// reference location (0.35)
	Vec3 original_cog;

	// dry mass used with original cog
	double dry_mass_kg;

public:
	F35WeightBalance() 
		: balanced_center_of_gravity()
		, original_cog()
		, dry_mass_kg(0)
	{}
	~F35WeightBalance() {}

	// used to initialize
	void setMassState(double mass_kg, Vec3 &center_of_gravity)
	{
		dry_mass_kg = mass_kg;
		original_cog = center_of_gravity;
		balanced_center_of_gravity = center_of_gravity;
	}

	void balance(double mass, Vec3 &position, Vec3 &size)
	{
		// update cog with given mass, position and bounding size

		// force of the mass
		double force_N = mass * F35::standard_gravity;

		// vector "torque" for force
		Vec3 force_vec;
		force_vec.x = position.x * force_N;
		force_vec.y = position.y * force_N;
		force_vec.z = position.z * force_N;

		// new center of gravity relative to original reference
		//balanced_center_of_gravity = cross(center_of_gravity, force_vec);

		// combine in case of multiple masses
		balanced_center_of_gravity = cross(balanced_center_of_gravity, force_vec);
	}

};

#endif // ifndef _F35WEIGHTBALANCE_H_
