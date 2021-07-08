#ifndef _F35NOZZLEPOSITION_H_
#define _F35NOZZLEPOSITION_H_

#include "../stdafx.h"
#include "BaseInstrument.h"

class F35NozzlePosition : public BaseInstrument
{
public:
	F35NozzlePosition() 
		: BaseInstrument() 
	{}
	~F35NozzlePosition() {}

	void updateFrame(double frametime) {}
};

#endif 
