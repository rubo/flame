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
	 * Represents the Abstract Syntax Notation One (ASN.1) GraphicString type.
	 */
	public class ASN1GraphicString extends ASN1StringBase
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the ASN1GraphicString class.
		 * 
		 * @param value The value to use.
		 * 
		 * @throws ArgumentError <code>value</code> parameter is <code>null</code>.
		 */
		public function ASN1GraphicString(value:String)
		{
			super(ASN1Tag.GRAPHIC_STRING);
			
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
		internal static function fromRawValue(value:ByteArray):ASN1VisibleString
		{
			return new ASN1VisibleString(value.readMultiByte(value.bytesAvailable, "ascii"));
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