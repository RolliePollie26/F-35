#ifndef _F35COMPASS_H_
#define _F35COMPASS_H_

#include "../stdafx.h"
#include "BaseInstrument.h"

class F35Compass : public BaseInstrument
{
public:
	F35Compass() 
		: BaseInstrument() 
	{}
	~F35Compass() {}

	void updateFrame(double frametime) {}
};

#endif 
