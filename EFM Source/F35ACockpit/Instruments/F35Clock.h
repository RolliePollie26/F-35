#ifndef _F35CLOCK_H_
#define _F35CLOCK_H_

#include "../stdafx.h"
#include "BaseInstrument.h"

class F35Clock : public BaseInstrument
{
public:
	F35Clock() 
		: BaseInstrument() 
	{}
	~F35Clock() {}

	void updateFrame(double frametime) {}
};

#endif 
