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
	internal final class BarrettReduction implements IReductionAlgorithm
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private var _q3:BigInteger = new BigInteger(0);
		private var _r2:BigInteger = new BigInteger(0);
		private var _mu:BigInteger;
		private var _value:BigInteger;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function BarrettReduction(value:BigInteger)
		{
			super();
			
			BigInteger.ONE.innerShiftLeftTo(value._length << 1, _r2);
			
			_mu = _r2.divide(value);
			_value = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------

		public function convert(value:BigInteger):BigInteger
		{
			if (value._sign < 0 || value._length > _value._length << 1)
				return value.mod(_value);
			else if (value.compareTo(_value) < 0)
				return value;
			else
			{
				var result:BigInteger = value.valueOf();
				
				reduce(result);
				
				return result;
			}
		}
		
		public function multiply(value1:BigInteger, value2:BigInteger, result:BigInteger):void
		{
			value1.mulTo(value2, result);
			
			reduce(result);
		}
		
		public function reduce(value:BigInteger):void
		{
			value.innerShiftRightTo(_value._length - 1, _r2);
			
			if (value._length > _value._length + 1)
			{
				value._length = _value._length + 1;
				
				value.normalize();
			}
			
			_mu.mulUpperTo(_r2, _value._length + 1, _q3);
			
			_value.mulLowerTo(_q3, _value._length + 1, _r2);
			
			while (value.compareTo(_r2) < 0)
				value.innerAddOffset(1, _value._length + 1);
			
			value.subTo(_r2, value);
			
			while (value.compareTo(_value) >= 0)
				value.subTo(_value, value);
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