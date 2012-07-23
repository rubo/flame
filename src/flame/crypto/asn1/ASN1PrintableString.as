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
	 * Represents the Abstract Syntax Notation One (ASN.1) PrintableString type.
	 */
	public class ASN1PrintableString extends ASN1StringBase
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private static const _validCharPattern:RegExp = /^[0-9a-z \'\(\)\+\,\-\/\:\=\?]+$/i;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the ASN1PrintableString class.
		 * 
		 * @param value The value to use.
		 * 
		 * @throws ArgumentError Thrown in the following situations:<ul>
		 * <li><code>value</code> parameter is <code>null</code>.</li>
		 * <li><code>value</code> parameter contains invalid characters.</li>
		 * </ul>
		 */
		public function ASN1PrintableString(value:String)
		{
			super(ASN1Tag.PRINTABLE_STRING);
			
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
			if (!_validCharPattern.test(value))
				throw new ArgumentError(_resourceManager.getString("flameCrypto", "asn1InvalidPrintableStringValue"));
			
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
		internal static function fromRawValue(value:ByteArray):ASN1PrintableString
		{
			return new ASN1PrintableString(value.readMultiByte(value.bytesAvailable, "ascii"));
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