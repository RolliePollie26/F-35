#ifndef _F35MFD_H_
#define _F35MFD_H_

#include "../stdafx.h"
#include "BaseDisplay.h"

class F35MFD : public BaseDisplay
{
public:
	F35MFD() 
		: BaseDisplay()
	{}
	~F35MFD() {}

	void updateFrame(double frametime) {}
};

#endif 
