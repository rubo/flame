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
	internal final class MontgomeryReduction implements IReductionAlgorithm
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private var _value:BigInteger;
		private var _valueDoubleLength:int;
		private var _valueInverse:int;
		private var _valueInverseHigh:int;
		private var _valueInverseLow:int;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function MontgomeryReduction(value:BigInteger)
		{
			super();
			
			_value = value;
			_valueDoubleLength = _value._length << 1;
			_valueInverse = _value.invertDigit();
			_valueInverseHigh = _valueInverse >> 15;
			_valueInverseLow = _valueInverse & 0x7FFF;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------

		public function convert(value:BigInteger):BigInteger
		{
			var result:BigInteger = new BigInteger(0);
			
			value.abs().innerShiftLeftTo(_value._length, result);
			
			result.divRemTo(_value, null, result);
			
			if (value._sign < 0 && result.compareTo(BigInteger.ZERO) > 0)
				_value.subTo(result, result);
			
			return result;
		}
		
		public function multiply(value1:BigInteger, value2:BigInteger, result:BigInteger):void
		{
			value1.mulTo(value2, result);
			
			reduce(result);
		}
		
		public function reduce(value:BigInteger):void
		{
			var bits:Vector.<int> = value._bits;
			
			while (value._length <= _valueDoubleLength)
				bits[value._length++] = 0;
			
			var j:int;
			var t:int;
			
			for (var i:int = 0, count:int = _value._length; i < count; i++)
			{
				j = bits[i] & 0x7FFF;
				t = j * _valueInverseLow + (((j * _valueInverseHigh + (bits[i] >> 15) * _valueInverseLow) & 0x7FFF) << 15) & 0x3FFFFFFF;
				j = i + _value._length;
				
				bits[j] += _value.addMul(0, t, bits, i, 0, _value._length);
				
				while (bits[j] >= 0x40000000)
				{
					bits[j] -= 0x40000000;
					
					bits[++j]++;
				}
			}
			
			value.normalize();
			
			value.innerShiftRightTo(_value._length, value);
			
			if (value.compareTo(_value) >= 0)
				value.subTo(_value, value);
		}
		
		public function revert(value:BigInteger):BigInteger
		{
			var result:BigInteger = value.valueOf();
			
			reduce(result);
			
			return result;
		}
		
		public function square(value:BigInteger, result:BigInteger):void
		{
			value.squareTo(result);
			
			reduce(result);
		}
	}
}