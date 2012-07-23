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
	 * Represents the Abstract Syntax Notation One (ASN.1) IA5String type.
	 */
	public class ASN1IA5String extends ASN1StringBase
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the ASN1IA5String class.
		 * 
		 * @param value The value to use.
		 * 
		 * @throws ArgumentError <code>value</code> parameter is <code>null</code>.
		 */
		public function ASN1IA5String(value:String)
		{
			super(ASN1Tag.IA5_STRING);
			
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
			_value = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private 
		 */
		internal static function fromRawValue(value:ByteArray):ASN1IA5String
		{
			for (var i:int = 0, count:int = value.bytesAvailable; i < count; i++)
				if (value[i] > 0x7F)
					throw new ASN1Error(_resourceManager.getString("flameCrypto", "asn1InvalidIA5StringValue", [ "value" ]));
			
			return new ASN1IA5String(value.readMultiByte(value.bytesAvailable, "ascii"));
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
			
			buffer.writeMultiByte(_value, "ascii");
			
			buffer.position = 0;
			
			return buffer;
		}
	}
}