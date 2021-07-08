#ifndef _F35STORESMANAGEMENT_H_
#define _F35STORESMANAGEMENT_H_

#include "../stdafx.h"
#include "BaseDisplay.h"

class F35StoresManagement : public BaseDisplay
{
public:
	F35StoresManagement() 
		: BaseDisplay()
	{}
	~F35StoresManagement() {}

	void updateFrame(double frametime) {}
};

#endif 
