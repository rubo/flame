////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.numerics
{
	internal interface IReductionAlgorithm
	{
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		function convert(value:BigInteger):BigInteger;
		function multiply(value1:BigInteger, value2:BigInteger, result:BigInteger):void;
		function reduce(value:BigInteger):void;
		function revert(value:BigInteger):BigInteger;
		function square(value:BigInteger, result:BigInteger):void;
	}
}