////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto.asn1
{
	import flash.utils.ByteArray;
	
	/**
	 * Represents the Abstract Syntax Notation One (ASN.1) ObjectIdentifier type.
	 */
	public class ASN1ObjectIdentifier extends ASN1Primitive
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private static var _oidPattern:RegExp = /^[0-2]+(\.\d+)+$/;
		
		private var _value:String;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the ASN1ObjectIdentifier class.
		 * 
		 * @param value The value to use.
		 * 
		 * @throws ArgumentError Thrown in the following situations:<ul>
		 * <li><code>value</code> parameter is <code>null</code>.</li>
		 * <li><code>value</code> parameter is not in a correct format.</li>
		 * </ul>
		 */
		public function ASN1ObjectIdentifier(value:String)
		{
			super(ASN1Tag.OBJECT_IDENTIFIER);
			
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "data" ]));
			
			if (!_oidPattern.test(value))
				throw new ArgumentError(_resourceManager.getString("flameCrypto", "asn1InvalidOID"));
			
			_value = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Gets the actual content as a string.
		 */
		public function get value():String
		{
			return _value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private 
		 */
		internal static function fromRawValue(value:ByteArray):ASN1ObjectIdentifier
		{
			var number:uint = value.readUnsignedByte();
			var number1:uint = number / 40;
			var number2:uint = number % 40;
			var oid:String;

			if (number1 > 2)
			{
				number2 += (number1 - 2) * 40;
				number1 = 2;
			}
			
			oid = number1 + "." + number2;
			
			var number3:uint = 0;
			
			while (value.bytesAvailable > 0)
			{
				number = value.readUnsignedByte();
				number3 = (number3 << 7) | (number & 0x7F);
				
				if ((number & 0x80) != 0x80)
				{
					oid += "." + number3;
					
					number3 = 0;
				}
			}
			
			return new ASN1ObjectIdentifier(oid);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		protected override function encodeValue():ByteArray
		{
			var numbers:Vector.<uint> = Vector.<uint>(_value.split("."));
			var buffer:ByteArray = new ByteArray();
			
			buffer.writeBytes(encodeSingleNumber(numbers[0] * 40 + numbers[1]));
			
			for (var i:int = 2, count:int = numbers.length; i < count; i++)
				buffer.writeBytes(encodeSingleNumber(numbers[i]));
			
			buffer.position = 0;
			
			return buffer;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private static function encodeSingleNumber(value:uint):ByteArray
		{
			var buffer:ByteArray = new ByteArray();
			var i:int;
			var size:int = 1;
			
			for (i = value; i >= 0x80; i >>>= 7)
				size++;
			
			for (i = (size - 1) * 7; i > 0; i -= 7)
				buffer.writeByte((value >>> i) | 0x80);
			
			buffer.writeByte(value & 0x7F);
			
			buffer.position = 0;
			
			return buffer;
		}
	}
}