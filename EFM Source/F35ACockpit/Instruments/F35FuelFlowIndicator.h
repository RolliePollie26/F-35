#ifndef _F35FUELFLOWINDICATOR_H_
#define _F35FUELFLOWINDICATOR_H_

#include "../stdafx.h"
#include "BaseInstrument.h"

class F35FuelFlowIndicator : public BaseInstrument
{
public:
	F35FuelFlowIndicator() 
		: BaseInstrument() 
	{}
	~F35FuelFlowIndicator() {}

	void updateFrame(double frametime) {}
};

#endif 
