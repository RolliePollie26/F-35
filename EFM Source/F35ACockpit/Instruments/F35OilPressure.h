#ifndef _F35OILPRESSURE_H_
#define _F35OILPRESSURE_H_

#include "../stdafx.h"
#include "BaseInstrument.h"

class F35OilPressure : public BaseInstrument
{
public:
	F35OilPressure() 
		: BaseInstrument() 
	{}
	~F35OilPressure() {}

	void updateFrame(double frametime) {}
};

#endif 
