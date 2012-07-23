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
	 * Represents the Abstract Syntax Notation One (ASN.1) Null type.
	 */
	public class ASN1Null extends ASN1Primitive
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Gets an instance of ASN1Null class.
		 */
		public static const NULL:ASN1Null = new ASN1Null();
		
		private static var _value:ByteArray = new ByteArray();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the ASN1Null class.
		 * <p>Commonly, you do not need to instantiate this class.
		 * Use the static <code>NULL</code> property instead.</p>
		 * 
		 * @see #NULL NULL
		 */
		public function ASN1Null()
		{
			super(ASN1Tag.NULL);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private 
		 */
		internal static function fromRawValue(value:ByteArray):ASN1Null
		{
			if (value.length > 0)
				throw new ASN1Error(_resourceManager.getString("flameCrypto", "asn1InvalidValueLength"));
			
			return NULL;
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
			return _value;
		}
	}
}