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
	 * Represents the Abstract Syntax Notation One (ASN.1) generic constructed form type.
	 */
	public class ASN1GenericConstruct extends ASN1Construct
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the ASN1GenericConstruct class.
		 * 
		 * @param tag ASN.1 tag number.
		 * 
		 * @param elements The child elements to add.
		 */
		public function ASN1GenericConstruct(tag:uint, elements:Vector.<ASN1Object> = null)
		{
			super(tag, elements);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private 
		 */
		internal static function fromRawValue(tag:uint, value:ByteArray):ASN1GenericConstruct
		{
			var elements:Vector.<ASN1Object> = new Vector.<ASN1Object>();
			
			while (value.bytesAvailable > 0)
				elements.push(ASN1Object.fromByteArray(value));
			
			return new ASN1GenericConstruct(tag, elements);
		}
	}
}