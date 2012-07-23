////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto.asn1
{
	/**
	 * Represents the abstract base class from which all implementations of
	 * Abstract Syntax Notation One (ASN.1) primitive form types must inherit.
	 */
	public class ASN1Primitive extends ASN1Object
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the ASN1Primitive class.
		 * 
		 * @param tag ASN.1 tag number.
		 * 
		 * @throws ArgumentError <code>tag</code> parameter is not a valid ASN.1 primitive form type tag.
		 */
		public function ASN1Primitive(tag:uint)
		{
			super(tag);
			
			if ((_tag & ASN1Tag.CONSTRUCTED) == ASN1Tag.CONSTRUCTED)
				throw new ArgumentError(_resourceManager.getString("flameCrypto", "asn1InvalidPrimitiveTag"));
		}
	}
}