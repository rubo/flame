////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.tests.crypto
{
	[RunWith("org.flexunit.runners.Suite")]
	[Suite(order=11)]
	public final class RSASuite
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		public var rsaPaddingTest:RSAPaddingTest;
		public var rsaSignatureTest:RSASignatureTest;
		public var rsaTest:RSATest;
	}
}