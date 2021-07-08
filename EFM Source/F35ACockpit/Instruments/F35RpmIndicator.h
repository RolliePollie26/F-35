#ifndef _F35RPMINDICATOR_H_
#define _F35RPMINDICATOR_H_

#include "../stdafx.h"
#include "BaseInstrument.h"

class F35RpmIndicator : public BaseInstrument
{
public:
	F35RpmIndicator() 
		: BaseInstrument() 
	{}
	~F35RpmIndicator() {}

	void updateFrame(double frametime) {}
};

#endif 
