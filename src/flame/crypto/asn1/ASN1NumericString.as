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
	 * Represents the Abstract Syntax Notation One (ASN.1) NumericString type.
	 */
	public class ASN1NumericString extends ASN1StringBase
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private static const _validCharPattern:RegExp = /^[\d ]+$/;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the ASN1NumericString class.
		 * 
		 * @param value The value to use.
		 * 
		 * @throws ArgumentError Thrown in the following situations:<ul>
		 * <li><code>value</code> parameter is <code>null</code>.</li>
		 * <li><code>value</code> parameter is not in a correct format.</li>
		 * </ul>
		 */
		public function ASN1NumericString(value:String)
		{
			super(ASN1Tag.NUMERIC_STRING);
			
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
			if (!_validCharPattern.test(value))
				throw new ArgumentError(_resourceManager.getString("flameCrypto", "asn1InvalidNumericStringValue"));
			
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
		internal static function fromRawValue(value:ByteArray):ASN1NumericString
		{
			var string:String = value.readMultiByte(value.bytesAvailable, "ascii");
			
			if (!_validCharPattern.test(string))
				throw new ASN1Error(_resourceManager.getString("flameCrypto", "asn1InvalidNumericStringValue"));
			
			return new ASN1NumericString(string);
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