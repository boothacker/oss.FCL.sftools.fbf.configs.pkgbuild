// Copyright (c) 1999-2009 Nokia Corporation and/or its subsidiary(-ies).
// All rights reserved.
// This component and the accompanying materials are made available
// under the terms of the License "Symbian Foundation License v1.0"
// which accompanies this distribution, and is available
// at the URL "http://www.symbianfoundation.org/legal/sfl-v10.html".
//
// Initial Contributors:
// Nokia Corporation - initial contribution.
//
// Contributors:
//
// Description:
//

#ifndef __CONSOLEALARMALERTLEDFLASHER_H__
#define __CONSOLEALARMALERTLEDFLASHER_H__

// System includes
#include <e32base.h>

// User includes

// Type definitions

// Constants

// Enumerations

// Classes referenced


///////////////////////////////////////////////////////////////////////////////////////
// ----> CConsoleAlarmAlertLEDFlasher (header)
///////////////////////////////////////////////////////////////////////////////////////
class CConsoleAlarmAlertLEDFlasher : public CTimer
	{
///////////////////////////////////////////////////////////////////////////////////////
public:										// STATIC CONSTRUCT
///////////////////////////////////////////////////////////////////////////////////////
	static CConsoleAlarmAlertLEDFlasher*	NewL();

///////////////////////////////////////////////////////////////////////////////////////
private:									// INTERNAL CONSTRUCT
///////////////////////////////////////////////////////////////////////////////////////
	CConsoleAlarmAlertLEDFlasher();

///////////////////////////////////////////////////////////////////////////////////////
public:										// ACCESS
///////////////////////////////////////////////////////////////////////////////////////

	TInt									Start();

	void									Stop();

///////////////////////////////////////////////////////////////////////////////////////
private:									// FROM CActive
///////////////////////////////////////////////////////////////////////////////////////

	void									RunL();

///////////////////////////////////////////////////////////////////////////////////////
private:									// INTERNAL
///////////////////////////////////////////////////////////////////////////////////////

	TInt									SetRedLedOn(TBool aOn);

///////////////////////////////////////////////////////////////////////////////////////
private:									// MEMBER DATA
///////////////////////////////////////////////////////////////////////////////////////

	TBool									iLedOn;
	};

#endif
