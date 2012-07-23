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
	 * Represents the Abstract Syntax Notation One (ASN.1) UniversalString type.
	 */
	public class ASN1UniversalString extends ASN1StringBase
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the ASN1UniversalString class.
		 * 
		 * @param value The value to use.
		 * 
		 * @throws ArgumentError <code>value</code> parameter is <code>null</code>.
		 */
		public function ASN1UniversalString(value:String)
		{
			super(ASN1Tag.UNIVERSAL_STRING);
			
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
		internal static function fromRawValue(value:ByteArray):ASN1BMPString
		{
			return new ASN1BMPString(value.readMultiByte(value.bytesAvailable, "utf-16"));
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
			
			buffer.writeMultiByte(_value, "utf-16");
			
			buffer.position = 0;
			
			return buffer;
		}
	}
}