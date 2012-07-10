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
	 * Specifies a tag number of an Abstract Syntax Notation One (ASN.1) type. 
	 */
	public final class ASN1Tag
	{
		/**
		 * Specifies the tag number of the ASN.1 application class types. 
		 */
		public static const APPLICATION:uint		= 0x40;
		
		/**
		 * Specifies the tag number of the ASN.1 BitString type. 
		 */
		public static const BIT_STRING:uint			= 0x03;
		
		/**
		 * Specifies the tag number of the ASN.1 BMPString type. 
		 */
		public static const BMP_STRING:uint			= 0x1E;
		
		/**
		 * Specifies the tag number of the ASN.1 Boolean type. 
		 */
		public static const BOOLEAN:uint			= 0x01;
		
		/**
		 * Specifies the tag number of the ASN.1 constructed encoding form types. 
		 */
		public static const CONSTRUCTED:uint		= 0x20;
		
		/**
		 * Specifies the tag number of the ASN.1 Embedded PDV type. 
		 */
		public static const EMBEDDED_PDV:uint		= 0x0B;
		
		/**
		 * Specifies the tag number of the ASN.1 Enumerated type. 
		 */
		public static const ENUMERATED:uint			= 0x0A;
		
		/**
		 * Specifies the tag number of the ASN.1 External type. 
		 */
		public static const EXTERNAL:uint			= 0x08;
		
		/**
		 * Specifies the tag number of the ASN.1 GeneralizedTime type. 
		 */
		public static const GENERALIZED_TIME:uint	= 0x18;
		
		/**
		 * Specifies the tag number of the ASN.1 GeneralString type. 
		 */
		public static const GENERAL_STRING:uint		= 0x1B;
		
		/**
		 * Specifies the tag number of the ASN.1 GraphicString type. 
		 */
		public static const GRAPHIC_STRING:uint		= 0x19;
		
		/**
		 * Specifies the tag number of the ASN.1 IA5String type. 
		 */
		public static const IA5_STRING:uint			= 0x16;
		
		/**
		 * Specifies the tag number of the ASN.1 Integer type. 
		 */
		public static const INTEGER:uint			= 0x02;
		
		/**
		 * Specifies the tag number of the ASN.1 Null type. 
		 */
		public static const NULL:uint				= 0x05;
		
		/**
		 * Specifies the tag number of the ASN.1 NimerocString type. 
		 */
		public static const NUMERIC_STRING:uint		= 0x12;
		
		/**
		 * Specifies the tag number of the ASN.1 ObjectDescriptor type. 
		 */
		public static const OBJECT_DESCRIPTOR:uint	= 0x07;
		
		/**
		 * Specifies the tag number of the ASN.1 ObjectIdentifier type. 
		 */
		public static const OBJECT_IDENTIFIER:uint	= 0x06;
		
		/**
		 * Specifies the tag number of the ASN.1 OctetString type. 
		 */
		public static const OCTET_STRING:uint		= 0x04;
		
		/**
		 * Specifies the tag number of the ASN.1 PrintableString type. 
		 */
		public static const PRINTABLE_STRING:uint	= 0x13;
		
		/**
		 * Specifies the tag number of the ASN.1 private class types. 
		 */
		public static const PRIVATE:uint			= 0xC0;
		
		/**
		 * Specifies the tag number of the ASN.1 real type. 
		 */
		public static const REAL:uint				= 0x09;
		
		/**
		 * Specifies the tag number of the ASN.1 Sequnce and SequenceOf types. 
		 */
		public static const SEQUENCE:uint			= 0x10;
		
		/**
		 * Specifies the tag number of the ASN.1 Set and SetOf types. 
		 */
		public static const SET:uint				= 0x11;
		
		/**
		 * Specifies the tag number of the ASN.1 TeletexString (T61String) type. 
		 */
		public static const TELETEX_STRING:uint		= 0x14;
		
		/**
		 * Specifies the tag number of the ASN.1 context-specific class types. 
		 */
		public static const TAGGED:uint				= 0x80;
		
		/**
		 * Specifies the tag number of the ASN.1 universal class types. 
		 */
		public static const UNIVERSAL:uint	= 0x00;
		
		/**
		 * Specifies the tag number of the ASN.1 UniversalString type. 
		 */
		public static const UNIVERSAL_STRING:uint	= 0x1C;
		
		/**
		 * Specifies the tag number of the ASN.1 UTCTime type. 
		 */
		public static const UTC_TIME:uint			= 0x17;
		
		/**
		 * Specifies the tag number of the ASN.1 UTF8String type. 
		 */
		public static const UTF8_STRING:uint		= 0x0C;
		
		/**
		 * Specifies the tag number of the ASN.1 VideotexString type. 
		 */
		public static const VIDEOTEX_STRING:uint	= 0x15;
		
		/**
		 * Specifies the tag number of the ASN.1 VisibleString (ISO646String) type. 
		 */
		public static const VISIBLE_STRING:uint		= 0x1A;
	}
}