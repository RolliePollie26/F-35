#ifndef _F35OXYGENFLOWINDICATOR_H_
#define _F35OXYGENFLOWINDICATOR_H_

#include "../stdafx.h"
#include "BaseInstrument.h"

class F35OxygenFlowIndicator : public BaseInstrument
{
public:
	F35OxygenFlowIndicator() 
		: BaseInstrument() 
	{}
	~F35OxygenFlowIndicator() {}

	void updateFrame(double frametime) {}
};

#endif 
