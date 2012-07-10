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
	 * Represents the Abstract Syntax Notation One (ASN.1) Set type.
	 */
	public class ASN1Set extends ASN1Construct
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the ASN1Set class.
		 * 
		 * @param elements The child elements to add.
		 */
		public function ASN1Set(elements:Vector.<ASN1Object> = null)
		{
			super(ASN1Tag.SET | ASN1Tag.CONSTRUCTED, elements);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private 
		 */
		internal static function fromRawValue(value:ByteArray):ASN1Set
		{
			var elements:Vector.<ASN1Object> = new Vector.<ASN1Object>();
			
			while (value.bytesAvailable > 0)
				elements.push(ASN1Object.fromByteArray(value));
			
			return new ASN1Set(elements);
		}
	}
}