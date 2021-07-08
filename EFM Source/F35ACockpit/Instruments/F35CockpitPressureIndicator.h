#ifndef _F35COCKPITPRESSUREINDICATOR_H_
#define _F35COCKPITPRESSUREINDICATOR_H_

#include "../stdafx.h"
#include "BaseInstrument.h"

class F35CockpitPressureIndicator : public BaseInstrument
{
public:
	F35CockpitPressureIndicator() 
		: BaseInstrument() 
	{}
	~F35CockpitPressureIndicator() {}

	void updateFrame(double frametime) {}
};

#endif 
