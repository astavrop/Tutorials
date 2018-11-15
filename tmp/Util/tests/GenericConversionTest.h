/*
	This file is part of the Util library.
	Copyright (C) 2013-2015 Benjamin Eikel <benjamin@eikel.org>
	
	This library is subject to the terms of the Mozilla Public License, v. 2.0.
	You should have received a copy of the MPL along with this library; see the 
	file LICENSE. If not, you can obtain one at http://mozilla.org/MPL/2.0/.
*/
#ifndef GENERICCONVERSIONTEST_H_
#define GENERICCONVERSIONTEST_H_

#include <cppunit/TestFixture.h>
#include <cppunit/extensions/HelperMacros.h>

class GenericConversionTest : public CppUnit::TestFixture {
	CPPUNIT_TEST_SUITE(GenericConversionTest);
	CPPUNIT_TEST(testBasicSerialization);
	CPPUNIT_TEST(testArraySerialization);
	CPPUNIT_TEST(testMapSerialization);
	CPPUNIT_TEST_SUITE_END();

	public:
		void testBasicSerialization();
		void testArraySerialization();
		void testMapSerialization();
};

#endif /* GENERICCONVERSIONTEST_H_ */
