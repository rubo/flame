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

	internal class PrimeEllipticCurve extends EllipticCurve
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private var _q:BigInteger;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function PrimeEllipticCurve(q:BigInteger, a:BigInteger, b:BigInteger)
		{
			super();
			
			_q = q;
			_a = bigIntegerToFieldElement(a);
			_b = bigIntegerToFieldElement(b);
			_pointAtInfinity = new PrimeECPoint(this, null, null);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal methods
		//
		//--------------------------------------------------------------------------
		
		internal override function bigIntegerToFieldElement(value:BigInteger):ECFieldElement
		{
			return new PrimeECFieldElement(_q, value);
		}
		
		internal override function createPoint(x:BigInteger, y:BigInteger):ECPoint
		{
			return new PrimeECPoint(this, bigIntegerToFieldElement(x), bigIntegerToFieldElement(y));
		}

		internal override function equals(value:EllipticCurve):Boolean
		{
			return value is PrimeEllipticCurve && _q.equals(PrimeEllipticCurve(value)._q) && super.equals(value);
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
		
		internal function get q():BigInteger
		{
			return _q;
		}
	}
}