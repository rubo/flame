////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto
{
	import flame.core.flame_internal;
	import flame.numerics.BigInteger;

	internal class ECPointWNAFMultiplier extends ECPointMultiplier
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private var _double:ECPoint;
		private var _points:Vector.<ECPoint>;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function ECPointWNAFMultiplier(point:ECPoint)
		{
			super(point);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal methods
		//
		//--------------------------------------------------------------------------
		
		internal override function multiply(value:BigInteger):ECPoint
		{
			if (_double == null)
				_double = _point.double();
			
			if (_points == null)
				_points = new <ECPoint>[ _point ];
			
			var bitLength:int = value.flame_internal::bitLength;
			var requiredLength:int;
			var width:int;
			
			if (bitLength < 13)
			{
				width = 2;
				requiredLength = 1;
			}
			else if (bitLength < 41)
			{
				width = 3;
				requiredLength = 2;
			}
			else if (bitLength < 121)
			{
				width = 4;
				requiredLength = 4;
			}
			else if (bitLength < 337)
			{
				width = 5;
				requiredLength = 8;
			}
			else if (bitLength < 897)
			{
				width = 6;
				requiredLength = 16;
			}
			else if (bitLength < 2305)
			{
				width = 7;
				requiredLength = 32;
			}
			else
			{
				width = 8;
				requiredLength = 127;
			}
			
			var i:int;
			var length:int = _points.length;
			
			if (length < requiredLength)
			{
				_points.length = requiredLength;
				
				for (i = length; i < requiredLength; i++)
					_points[i] = _double.add(_points[i - 1]);
			}
			
			var power1:int = 1 << width;
			var power2:BigInteger = new BigInteger(power1);
			var wnaf:Vector.<int> = new Vector.<int>();
			
			for (i = 0; value.sign > 0; value = value.shiftRight(1), i++)
			{
				if (value.flame_internal::isBitSet(0))
				{
					var r:BigInteger = value.mod(power2);
					
					wnaf[i] = r.flame_internal::isBitSet(width - 1)
						? r.flame_internal::toInt() - power1 : r.flame_internal::toInt();
					
					value = value.subtract(new BigInteger(wnaf[i]));
				}
				else
					wnaf[i] = 0;
			}
			
			var point:ECPoint = _point.curve.pointAtInfinity;
			
			for (i = wnaf.length - 1; i >= 0; i--)
			{
				point = point.double();
				
				if (wnaf[i] != 0)
					point = wnaf[i] > 0 ? point.add(_points[(wnaf[i] - 1) / 2]) : point.subtract(_points[(-wnaf[i] - 1) / 2]);
			}
			
			return point;
		}
	}
}