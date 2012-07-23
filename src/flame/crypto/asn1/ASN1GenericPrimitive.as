////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto.asn1
{
	import flame.utils.ByteArrayUtil;
	
	import flash.utils.ByteArray;

	/**
	 * Represents the Abstract Syntax Notation One (ASN.1) generic primitive form type.
	 */
	public class ASN1GenericPrimitive extends ASN1Primitive
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private var _value:ByteArray;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the ASN1GenericPrimitive class.
		 * 
		 * @param tag ASN.1 tag number.
		 * 
		 * @param value The value to use.
		 * 
		 * @throws ArgumentError <code>value</code> parameter is <code>null</code>.
		 */
		public function ASN1GenericPrimitive(tag:uint, value:ByteArray)
		{
			super(tag);
			
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
			_value = ByteArrayUtil.copy(value);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------

		/**
		 * Gets the actual content as a byte array.
		 */
		public function get value():ByteArray
		{
			return ByteArrayUtil.copy(_value);
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
			return ByteArrayUtil.copy(_value);
		}
	}
}