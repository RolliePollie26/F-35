#ifndef _F35HSI_H_
#define _F35HSI_H_

#include "../stdafx.h"
#include "BaseInstrument.h"

class F35HSI : public BaseInstrument
{
public:
	F35HSI() 
		: BaseInstrument() 
	{}
	~F35HSI() {}

	void updateFrame(double frametime) {}
};

#endif 
