////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2011 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto
{
	import flame.core.flame_internal;
	import flame.numerics.BigInteger;

	internal class PrimeECFieldElement extends ECFieldElement
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private var _q:BigInteger;
		private var _x:BigInteger;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function PrimeECFieldElement(q:BigInteger, x:BigInteger)
		{
			super();
			
			if (x.compareTo(q) >= 0)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidParameter"));
			
			_q = q;
			_x = x;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal methods
		//
		//--------------------------------------------------------------------------
		
		internal override function add(value:ECFieldElement):ECFieldElement
		{
			return new PrimeECFieldElement(_q, _x.add(value.toBigInteger()).mod(_q));
		}
		
		internal override function divide(value:ECFieldElement):ECFieldElement
		{
			return new PrimeECFieldElement(_q, _x.multiply(value.toBigInteger().flame_internal::modInverse(_q)).mod(_q));
		}
		
		internal override function equals(value:ECFieldElement):Boolean
		{
			if (value == this)
				return true;
			
			return value is PrimeECFieldElement && _q.equals(PrimeECFieldElement(value)._q) && super.equals(value);
		}
		
		internal override function multiply(value:ECFieldElement):ECFieldElement
		{
			return new PrimeECFieldElement(_q, _x.multiply(value.toBigInteger()).mod(_q));
		}
		
		internal override function negate():ECFieldElement
		{
			return new PrimeECFieldElement(_q, _x.negate().mod(_q));
		}
		
		internal override function square():ECFieldElement
		{
			return new PrimeECFieldElement(_q, _x.flame_internal::square().mod(_q));
		}
		
		internal override function subtract(value:ECFieldElement):ECFieldElement
		{
			return new PrimeECFieldElement(_q, _x.subtract(value.toBigInteger()).mod(_q));
		}
		
		internal override function toBigInteger():BigInteger
		{
			return _x;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal properties
		//
		//--------------------------------------------------------------------------
		
		internal override function get fieldSize():int
		{
			return _q.flame_internal::bitLength;
		}
	}
}