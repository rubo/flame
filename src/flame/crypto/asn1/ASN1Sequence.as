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
	 * Represents the Abstract Syntax Notation One (ASN.1) Sequence type.
	 */
	public class ASN1Sequence extends ASN1Construct
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the ASN1Sequence class.
		 * 
		 * @param elements The child elements to add.
		 */
		public function ASN1Sequence(elements:Vector.<ASN1Object> = null)
		{
			super(ASN1Tag.SEQUENCE | ASN1Tag.CONSTRUCTED, elements);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private 
		 */
		internal static function fromRawValue(value:ByteArray):ASN1Sequence
		{
			var elements:Vector.<ASN1Object> = new Vector.<ASN1Object>();
			
			while (value.bytesAvailable > 0)
				elements.push(ASN1Object.fromByteArray(value));
			
			return new ASN1Sequence(elements);
		}
	}
}