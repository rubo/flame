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
	 * Abstract Syntax Notation One (ASN.1) string types must inherit.
	 */
	public class ASN1StringBase extends ASN1Primitive
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Represents the actual content.
		 */
		protected var _value:String;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the ASN1StringBase class.
		 * 
		 * @param tag ASN.1 tag number.
		 */
		public function ASN1StringBase(tag:uint)
		{
			super(tag);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Gets the actual content as a string.
		 */
		public function get value():String
		{
			return _value;
		}
	}
}