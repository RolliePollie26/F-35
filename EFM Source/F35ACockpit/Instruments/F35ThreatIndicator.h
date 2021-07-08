#ifndef _F35THREATINDICATOR_H_
#define _F35THREATINDICATOR_H_

#include "../stdafx.h"
#include "BaseInstrument.h"

class F35ThreatIndicator : public BaseInstrument
{
public:
	F35ThreatIndicator() 
		: BaseInstrument() 
	{}
	~F35ThreatIndicator() {}

	void updateFrame(double frametime) {}
};

#endif 
