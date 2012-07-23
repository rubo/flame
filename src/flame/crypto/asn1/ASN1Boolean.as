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
	 * Represents the Abstract Syntax Notation One (ASN.1) Boolean type.
	 */
	public class ASN1Boolean extends ASN1Primitive
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private var _value:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the ASN1Boolean class.
		 * 
		 * @param value The value to use.
		 */
		public function ASN1Boolean(value:Boolean)
		{
			super(ASN1Tag.BOOLEAN);
			
			_value = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Gets the actual content as a Boolean.
		 */
		public function get value():Boolean
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
		internal static function fromRawValue(value:ByteArray):ASN1Boolean
		{
			if (value.bytesAvailable > 1)
				throw new ASN1Error(_resourceManager.getString("flameCrypto", "asn1InvalidValueLength", [ "value" ]));
			
			var byte:int = value.readByte();
			
			if (byte != 0 && byte != 0xFF)
				throw new ASN1Error(_resourceManager.getString("flameCrypto", "asn1InvalidBooleanValue"));
			
			return new ASN1Boolean(byte == 0xFF);
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
			var buffer:ByteArray = new ByteArray();
			
			buffer.writeByte(_value ? 0xFF : 0);
			
			buffer.position = 0;
			
			return buffer;
		}
	}
}