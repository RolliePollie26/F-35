#ifndef _F35ADI_H_
#define _F35ADI_H_

#include "../stdafx.h"
#include "BaseInstrument.h"

class F35ADI : public BaseInstrument
{
public:
	F35ADI() 
		: BaseInstrument() 
	{}
	~F35ADI() {}

	void updateFrame(double frametime) {}
};

#endif 
