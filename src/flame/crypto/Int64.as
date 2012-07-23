////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2011 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto
{
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	[ResourceBundle("flameNumerics")]
	internal final class Int64
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		internal static const MAX_VALUE:Int64 = new Int64(0x7FFFFFFF, 0xFFFFFFFF);
		internal static const MIN_VALUE:Int64 = new Int64(0x80000000, 0);
		internal static const MINUS_ONE:Int64 = new Int64(-1, -1);
		internal static const ONE:Int64 = new Int64(0, 1);
		internal static const ZERO:Int64 = new Int64(0, 0);
		
		internal var highBits:int;
		internal var lowBits:int;
		
		private static var _resourceManager:IResourceManager = ResourceManager.getInstance();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Int64(highBits:int, lowBits:int)
		{
			super();
			
			this.highBits = highBits;
			this.lowBits = lowBits;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		public function valueOf():Int64
		{
			return new Int64(highBits, lowBits);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal methods
		//
		//--------------------------------------------------------------------------
		
		internal function abs():Int64
		{
			return sign < 0 ? negate() : this;
		}
		
		internal function add(value:Int64):Int64
		{
			var lbLow:int = (lowBits & 0xFFFF) + (value.lowBits & 0xFFFF);
			var hbLow:int = (lowBits >>> 16) + (value.lowBits >>> 16) + (lbLow >>> 16);
			var lbHigh:int = (highBits & 0xFFFF) + (value.highBits & 0xFFFF) + (hbLow >>> 16);
			var hbHigh:int = (highBits >>> 16) + (value.highBits >>> 16) + (lbHigh >>> 16);
			
			return new Int64((hbHigh & 0xFFFF) << 16 | lbHigh & 0xFFFF, (hbLow & 0xFFFF) << 16 | lbLow & 0xFFFF);
		}
		
		internal function and(value:Int64):Int64
		{
			return new Int64(highBits & value.highBits, lowBits & value.lowBits);
		}
		
		internal function compareTo(value:Int64):int
		{
			if (highBits < value.highBits)
				return -1;
			
			if (highBits > value.highBits)
				return 1;
			
			if (lowBits < value.lowBits)
				return -1;
			
			if (lowBits > value.lowBits)
				return 1;
			
			return 0;
		}
		
		internal function divide(value:Int64):Int64
		{
			if (value.isZero)
				throw new ArgumentError(_resourceManager.getString("flameNumerics", "argDivideByZero"));
			
			var result:Int64 = new Int64(0, 0);
			
			divRemTo(value, result, null);
			
			return result;
		}
		
		internal function divRem(divisor:Int64):Vector.<Int64>
		{
			if (divisor.isZero)
				throw new ArgumentError(_resourceManager.getString("flameNumerics", "argDivideByZero"));
			
			var quotient:Int64 = new Int64(0, 0);
			var remainder:Int64 = new Int64(0, 0);
			
			divRemTo(divisor, quotient, remainder);
			
			return new <Int64>[ quotient, remainder ];
		}
		
		internal function equals(value:Int64):Boolean
		{
			return highBits == value.highBits && lowBits == value.lowBits;
		}
		
		internal function mod(value:Int64):Int64
		{
			if (value.isZero)
				throw new ArgumentError(_resourceManager.getString("flameNumerics", "argDivideByZero"));
			
			var result:Int64 = new Int64(0, 0);
			
			abs().divRemTo(value, null, result);
			
			if (sign < 0 && result.compareTo(ZERO) > 0)
				result = result.negate();
			
			return result;
		}
		
		internal function multiply(value:Int64):Int64
		{
			if (equals(MIN_VALUE))
				return value.isEven ? ZERO : MIN_VALUE;
			
			if (value.equals(MIN_VALUE))
				return isEven ? ZERO : MIN_VALUE;
			
			if (sign < 0)
			{
				if (value.sign < 0)
					return negate().multiply(value.negate());
				else
					return negate().multiply(value).negate();
			}
			else if (value.sign < 0)
				return multiply(value.negate()).negate();
			
			var hbHigh:int = highBits >>> 16;
			var hbLow:int = highBits & 0xFFFF;
			var lbHigh:int = lowBits >>> 16;
			var lbLow:int = lowBits & 0xFFFF;
			var vhbHigh:int = value.highBits >>> 16;
			var vhbLow:int = value.highBits & 0xFFFF;
			var vlbHigh:int = value.lowBits >>> 16;
			var vlbLow:int = value.lowBits & 0xFFFF;
			var rlbLow:int = lbLow * vlbLow;
			var rlbHigh:int = (rlbLow >>> 16) + lbHigh * vlbLow;
			var rhbLow:int = rlbHigh >>> 16;
			var rhbHigh:int;
			
			rlbHigh &= 0xFFFF;
			rlbHigh += lbLow * vlbHigh;
			rhbLow += (rlbHigh >>> 16) + hbLow * vlbLow;
			rhbHigh = rhbLow >>> 16;
			rhbLow &= 0xFFFF;
			rhbLow += lbHigh * vlbHigh;
			rhbHigh += rhbLow >>> 16;
			rhbLow &= 0xFFFF;
			rhbLow += lbLow * vhbLow;
			rhbHigh += (rhbLow >>> 16) + hbHigh * vlbLow + hbLow * vlbHigh + lbHigh * vhbLow + lbLow * vhbHigh;
			
			return new Int64((rhbHigh & 0xFFFF) << 16 | rhbLow & 0xFFFF, (rlbHigh & 0xFFFF) << 16 | rlbLow & 0xFFFF);
		}
		
		internal function negate():Int64
		{
			return not().add(ONE);
		}
		
		internal function not():Int64
		{
			return new Int64(~highBits, ~lowBits);
		}
		
		internal function or(value:Int64):Int64
		{
			return new Int64(highBits | value.highBits, lowBits | value.lowBits);
		}
		
		internal function shiftLeft(value:int):Int64
		{
			return value < 32
				? new Int64(highBits << value | lowBits >>> (32 - value), lowBits << value)
				: new Int64(lowBits << (value - 32), 0);
		}
		
		internal function shiftRight(value:int):Int64
		{
			return value < 32
				? new Int64(highBits >> value, lowBits >>> value | highBits << (32 - value))
				: new Int64(highBits >= 0 ? 0 : -1, highBits >> (value - 32));
		}
		
		internal function shiftRightUnsigned(value:int):Int64
		{
			return value < 32
				? new Int64(highBits >>> value, lowBits >>> value | highBits << (32 - value))
				: new Int64(0, highBits >>> (value - 32));
		}
		
		internal function subtract(value:Int64):Int64
		{
			return add(value.negate());
		}
		
		internal function xor(value:Int64):Int64
		{
			return new Int64(highBits ^ value.highBits, lowBits ^ value.lowBits);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal properties
		//
		//--------------------------------------------------------------------------
		
		internal function get isEven():Boolean
		{
			return (lowBits & 1) != 1;
		}
		
		internal function get isZero():Boolean
		{
			return highBits == 0 && lowBits == 0;
		}
		
		internal function get sign():int
		{
			if (isZero)
				return 0;
			
			if (highBits < 0)
				return -1;
			
			return 1;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function copyTo(destination:Int64):void
		{
			destination.highBits = highBits;
			destination.lowBits = lowBits;
		}
		
		private function divRemTo(divisor:Int64, quotient:Int64, remainder:Int64):void
		{
			if (quotient == null)
				quotient = new Int64(0, 0);
			
			if (remainder == null)
				remainder = new Int64(0, 0);
			
			ZERO.copyTo(remainder);
			
			if (equals(MIN_VALUE))
			{
				if (divisor.equals(ONE) || divisor.equals(MINUS_ONE))
					MIN_VALUE.copyTo(quotient);
				else if (divisor.equals(MIN_VALUE))
					ONE.copyTo(quotient);
				else
				{
					shiftRight(1).divRemTo(divisor, quotient, remainder);
					
					var approx:Int64 = quotient.shiftLeft(1);
					
					if (approx.isZero)
						divisor.sign < 0 ? ONE.copyTo(quotient) : MINUS_ONE.copyTo(quotient);
					else
					{
						subtract(divisor.multiply(approx)).divRemTo(divisor, quotient, remainder);
						
						approx.add(quotient).copyTo(quotient);
					}
				}
			}
			else if (divisor.equals(MIN_VALUE))
				ZERO.copyTo(quotient);
			else if (sign < 0)
			{
				if (divisor.sign < 0)
					negate().divRemTo(divisor.negate(), quotient, remainder);
				else
				{
					negate().divRemTo(divisor, quotient, remainder);
					
					quotient.negate().copyTo(quotient);
				}
			}
			else if (divisor.sign < 0)
			{
				divRemTo(divisor.negate(), quotient, remainder);
				
				quotient.negate().copyTo(quotient);
			}
			else
			{
				copyTo(remainder);
				ZERO.copyTo(quotient);
				
				for (var comparison:int = remainder.compareTo(divisor); comparison >= 0; comparison = remainder.compareTo(divisor))
				{
					var an:Number = Math.max(1, Math.floor(remainder.toNumber() / divisor.toNumber()));
					var aq:Int64 = fromNumber(an);
					var ar:Int64 = aq.multiply(divisor);
					var log:Number = Math.ceil(Math.log(an) / Math.LN2);
					var delta:Number = log <= 48 ? 1 : Math.pow(2, log - 48);
					
					while (ar.sign < 0 || ar.compareTo(remainder) > 0)
					{
						an -= delta;
						aq = fromNumber(an);
						ar = aq.multiply(divisor);
					}
					
					if (aq.isZero)
						aq = ONE;
					
					quotient.add(aq).copyTo(quotient);
					remainder.subtract(ar).copyTo(remainder);
				}
			}
		}
		
		private static function fromNumber(value:Number):Int64
		{
			if (isNaN(value) || !isFinite(value))
				return ZERO;
			
			if (value <= -0x8000000000000000)
				return MIN_VALUE;
			
			if (value + 1 >= 0x8000000000000000)
				return MAX_VALUE;
			
			if (value < 0)
				return fromNumber(-value).negate();
			
			return new Int64(value / 0x100000000, value % 0x100000000);
		}
		
		private function toNumber():Number
		{
			return highBits * 0x100000000 + (lowBits >= 0 ? lowBits : lowBits + 0x100000000);
		}
	}
}