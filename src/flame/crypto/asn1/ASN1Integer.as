////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto.asn1
{
	import flame.numerics.BigInteger;
	
	import flash.utils.ByteArray;
	
	/**
	 * Represents the Abstract Syntax Notation One (ASN.1) Integer type.
	 */
	public class ASN1Integer extends ASN1Primitive
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private var _value:BigInteger;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the ASN1Integer class.
		 * 
		 * @param value The value to use.
		 * This parameter can accept a BigInteger, a ByteArray, or an int.
		 * 
		 * @throws ArgumentError <code>value</code> parameter is <code>null</code>.
		 * 
		 * @throws TypeError <code>value</code> paramater has an invalid type.
		 */
		public function ASN1Integer(value:*)
		{
			super(ASN1Tag.INTEGER);
			
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
			if (value is BigInteger)
				_value = BigInteger(value).valueOf();
			else if (value is int || value is ByteArray)
				_value = new BigInteger(value);
			else
				throw new TypeError(_resourceManager.getString("flameCore", "argInvalidValue", [ "value" ]));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Gets the actual content as a BigInteger.
		 */
		public function get value():BigInteger
		{
			return _value.valueOf();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private 
		 */
		internal static function fromRawValue(value:ByteArray):ASN1Integer
		{
			return new ASN1Integer(value);
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
			return _value.toByteArray();
		}
	}
}