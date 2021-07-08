#ifndef _F35GROUNDSURFACE_H_
#define _F35GROUNDSURFACE_H_

#include <cmath>

#include "ED_FM_Utility.h"		// Provided utility functions that were in the initial EFM example
#include "F35Constants.h"		// Common constants used throughout this DLL

#include "Atmosphere/F35Atmosphere.h"			//Atmosphere model functions

// This will be used in two ways:
// - to determine altitude and ground effect lift from surface below the aircraft
// - calculate orientation relative to surface and weight on each wheel
//
// The second part is already given by DCS so that might not be needed.
// Just the plan though if needed.
//
class F35GroundSurface
{
protected:
	F35Atmosphere *pAtmos;

	double surfaceHeight;
	double surfaceHeightWithObj;
	unsigned surfaceType;

	Vec3 m_surfaceNormal;

public:
	F35GroundSurface(F35Atmosphere *atmos)
		: pAtmos(atmos)
		, surfaceHeight(0)
		, surfaceHeightWithObj(0)
		, surfaceType(0)
		, m_surfaceNormal()
	{}
	~F35GroundSurface() {}

	void setSurface(double h, double h_obj, unsigned surface_type, Vec3 &sfcNormal)
	{
		surfaceHeight = h; 
		surfaceHeightWithObj = h_obj;
		surfaceType = surface_type;
		m_surfaceNormal = sfcNormal;
	}

	void groundEffect(double frameTime)
	{
		// downwash at entire trailing edge of wing,
		// also wingtip vortices
		// -> lift increase
		// -> reduced drag
		// wingspan, altitude, angle of attack


		if (surfaceHeightWithObj > surfaceHeight)
		{
			// ground effect disrupted by object (or uneven surface?)
			// TODO: more detailed version
			return;
		}

		//calculation of ground surface with aircraft normal
		// -> max effect when aligned, reduced as banking

		// trailing edge downwash effect (are flaps down?)
		// wingtip vortices (sidewinders?)

		// we might need airspeed and air pressure to determine magnitude of lift effect
		Vec3 airSpeed = pAtmos->getAirspeed();

		// should be parallel to surface for max effect, otherwise reduced

		// also reduction of induced drag when in ground effect -> less thrust needed

		// TODO: check height, set for ground effect simulation?
		// also if weight on wheels?
		if (F35::wingSpan_m >= surfaceHeight /*&& F35::LandingGear.isWoW() == false*/)
		{
			// in ground effect with the surface?
			// flying above ground, no weight on wheels?

			//double diff = F35::wingSpan_m - surfaceHeight;

		}

	}

	void updateFrame(double frameTime)
	{
		groundEffect(frameTime);
	}
};

#endif // ifndef _F35GROUNDSURFACE_H_
