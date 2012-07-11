////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2011 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto
{
	import flame.numerics.BigInteger;

	internal final class ECDomainParameters
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		internal var a:BigInteger;
		internal var b:BigInteger;
		internal var n:BigInteger;
		internal var q:BigInteger;
		internal var x:BigInteger;
		internal var y:BigInteger;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ECDomainParameters()
		{
			super();
		}
	}
}