#ifndef _F35ALTIMETER_H_
#define _F35ALTIMETER_H_

#include "../stdafx.h"
#include "BaseInstrument.h"

class F35Altimeter : public BaseInstrument
{
public:
	F35Altimeter() 
		: BaseInstrument() 
	{}
	~F35Altimeter() {}

	void updateFrame(double frametime) {}
};

#endif 
