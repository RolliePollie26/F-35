#ifndef _F35EPUFUELQUANTITY_H_
#define _F35EPUFUELQUANTITY_H_

#include "../stdafx.h"
#include "BaseInstrument.h"

class F35EPUFuelQuantity : public BaseInstrument
{
public:
	F35EPUFuelQuantity() 
		: BaseInstrument() 
	{}
	~F35EPUFuelQuantity() {}

	void updateFrame(double frametime) {}
};

#endif 
