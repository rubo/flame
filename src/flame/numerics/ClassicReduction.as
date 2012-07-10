////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//	Portions Copyright 2009 Tom Wu. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.numerics
{
	internal final class ClassicReduction implements IReductionAlgorithm
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private var _value:BigInteger;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ClassicReduction(value:BigInteger)
		{
			super();
			
			_value = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function convert(value:BigInteger):BigInteger
		{
			if (value._sign < 0 || value.compareTo(_value) >= 0)
				return value.mod(_value);

			return value;
		}
		
		public function multiply(value1:BigInteger, value2:BigInteger, result:BigInteger):void
		{
			value1.mulTo(value2, result);
			
			reduce(result);
		}
		
		public function reduce(value:BigInteger):void
		{
			value.divRemTo(_value, null, value);
		}
		
		public function revert(value:BigInteger):BigInteger
		{
			return value;
		}
		
		public function square(value:BigInteger, result:BigInteger):void
		{
			value.squareTo(result);
			
			reduce(result);
		}
	}
}