#ifndef _F35HYDRAULICPRESSUREINDICATOR_H_
#define _F35HYDRAULICPRESSUREINDICATOR_H_

#include "../stdafx.h"
#include "BaseInstrument.h"

class F35HydraulicPressureIndicator : public BaseInstrument
{
public:
	F35HydraulicPressureIndicator() 
		: BaseInstrument() 
	{}
	~F35HydraulicPressureIndicator() {}

	void updateFrame(double frametime) {}
};

#endif 
