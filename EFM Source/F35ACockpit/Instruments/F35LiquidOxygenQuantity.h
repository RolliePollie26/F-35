#ifndef _F35LIQUIDOXYGENQUANTITY_H_
#define _F35LIQUIDOXYGENQUANTITY_H_

#include "../stdafx.h"
#include "BaseInstrument.h"

class F35LiquidOxygenQuantity : public BaseInstrument
{
public:
	F35LiquidOxygenQuantity() 
		: BaseInstrument() 
	{}
	~F35LiquidOxygenQuantity() {}

	void updateFrame(double frametime) {}
};

#endif 
