////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto.asn1
{
	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	[ResourceBundle("flameCore")]
	[ResourceBundle("flameCrypto")]
	
	/**
	 * Represents the abstract base class from which all implementations of
	 * Abstract Syntax Notation One (ASN.1) types must inherit.
	 * <p>Abstract Syntax Notation One (ASN.1), which is defined in CCITT Recommendation X.208,
	 * is a way to specify abstract objects that will be serially transmitted.
	 * The set of ASN.1 rules for representing such objects as strings of ones and zeros is called
	 * the Distinguished Encoding Rules (DER), and is defined in CCITT Recommendation X.509, Section 8.7.
	 * These encoding methods are currently used by the cryptographic algorithms provided.</p>
	 */
	public class ASN1Object
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * A reference to the IResourceManager object which manages all of the localized resources.
		 * 
		 * @see mx.resources.IResourceManager
		 */
		protected static var _resourceManager:IResourceManager = ResourceManager.getInstance();
		
		/**
		 * Represents the tag number of the ASN.1 type.
		 */
		protected var _tag:uint;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the ASN1Object class.
		 * 
		 * @param tag ASN.1 tag number.
		 */
		public function ASN1Object(tag:uint)
		{
			super();
			
			_tag = tag;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Converts an ASN.1 DER-encoded byte array to a corresponding ASN1Object object.
		 * 
		 * @param data A byte array that contains an ASN.1-encoded data.
		 * 
		 * @return An object derived from ASN1Object that contains the decoded data.
		 * 
		 * @throws ArgumentError <code>data</code> parameter is <code>null</code>.
		 */
		public static function fromByteArray(data:ByteArray):ASN1Object
		{
			if (data == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "data" ]));
			
			var tag:uint = data.readUnsignedByte();
			var length:int = decodeLength(data);
			var value:ByteArray = new ByteArray();
			
			data.readBytes(value, 0, length);
			
			switch (tag)
			{
				case ASN1Tag.BIT_STRING:
					
					return ASN1BitString.fromRawValue(value);
					
				case ASN1Tag.BMP_STRING:
					
					return ASN1BMPString.fromRawValue(value);
				
				case ASN1Tag.BOOLEAN:
					
					return ASN1Boolean.fromRawValue(value);
				
				case ASN1Tag.GENERALIZED_TIME:
					
					return ASN1GeneralizedTime.fromRawValue(value);
				
				case ASN1Tag.GENERAL_STRING:
					
					return ASN1GeneralString.fromRawValue(value);
					
				case ASN1Tag.GRAPHIC_STRING:
					
					return ASN1GraphicString.fromRawValue(value);
				
				case ASN1Tag.IA5_STRING:
					
					return ASN1IA5String.fromRawValue(value);
					
				case ASN1Tag.INTEGER:
					
					return ASN1Integer.fromRawValue(value);
				
				case ASN1Tag.NULL:
					
					return ASN1Null.NULL;
				
				case ASN1Tag.NUMERIC_STRING:
					
					return ASN1NumericString.fromRawValue(value);
				
				case ASN1Tag.OBJECT_IDENTIFIER:
					
					return ASN1ObjectIdentifier.fromRawValue(value);
				
				case ASN1Tag.OCTET_STRING:
					
					return ASN1OctetString.fromRawValue(value);
					
				case ASN1Tag.PRINTABLE_STRING:
					
					return ASN1PrintableString.fromRawValue(value);
					
				case ASN1Tag.SEQUENCE | ASN1Tag.CONSTRUCTED:
					
					return ASN1Sequence.fromRawValue(value);
				
				case ASN1Tag.SET | ASN1Tag.CONSTRUCTED:
					
					return ASN1Set.fromRawValue(value);
				
				case ASN1Tag.TELETEX_STRING:
					
					return ASN1TeletexString.fromRawValue(value);
				
				case ASN1Tag.UNIVERSAL_STRING:
					
					return ASN1UniversalString.fromRawValue(value);
					
				case ASN1Tag.UTC_TIME:
					
					return ASN1UTCTime.fromRawValue(value);
					
				case ASN1Tag.UTF8_STRING:
					
					return ASN1UTF8String.fromRawValue(value);
					
				case ASN1Tag.VIDEOTEX_STRING:
					
					return ASN1VideotexString.fromRawValue(value);	
				
				case ASN1Tag.VISIBLE_STRING:
					
					return ASN1VisibleString.fromRawValue(value);
				
				default:
					
					return (tag & ASN1Tag.CONSTRUCTED) == ASN1Tag.CONSTRUCTED ? ASN1GenericConstruct.fromRawValue(tag, value) : new ASN1GenericPrimitive(tag, value);
			}
		}
		
		/**
		 * Converts this instance to a byte array according to the Distinguished Encoding Rules (DER).
		 * 
		 * @return An encoded byte array.
		 */
		public function toByteArray():ByteArray
		{
			var buffer:ByteArray = new ByteArray();
			var value:ByteArray = encodeValue();
			
			buffer.writeByte(tag);
			buffer.writeBytes(encodeLength(value.length));
			buffer.writeBytes(value);
			
			buffer.position = 0;
			
			return buffer;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Gets the tag number of the ASN.1 type that this instance represents.
		 */
		public function get tag():uint
		{
			return _tag;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Encodes the length of the value according to the Distinguished Encoding Rules (DER).
		 * 
		 * @param length The length of the value to encode.
		 * 
		 * @return A byte array that contains the encoded length.
		 */
		protected static function encodeLength(length:int):ByteArray
		{
			var buffer:ByteArray = new ByteArray();
			
			if (length > 0x7F)
			{
				var i:int;
				var size:int = 1;
				
				for (i = length >>> 8; i != 0; i >>>= 8)
					size++;
				
				buffer.writeByte(size | 0x80);
				
				for (i = (size - 1) << 3; i >= 0; i -= 8)
					buffer.writeByte(length >>> i);
			}
			else
				buffer.writeByte(length);
			
			buffer.position = 0;
			
			return buffer;
		}
		
		/**
		 * When overridden in a derived class,
		 * encodes the value according to the Distinguished Encoding Rules (DER).
		 * 
		 * @return A byte array that contains the encoded value.
		 */
		protected function encodeValue():ByteArray
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "argNotImplemented"));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private static function decodeLength(data:ByteArray):int
		{
			var length:int = data.readUnsignedByte();
			
			if (length > 0x7F)
			{
				if (length == 0x80)
					throw new ASN1Error(_resourceManager.getString("flameCrypto", "asn1IndefiniteLength"));
				
				var decodedLength:int = 0;
				
				length &= 0x7F;
				
				while (length-- > 0)
					decodedLength = (decodedLength << 8) | data.readUnsignedByte();
				
				return decodedLength;
			}

			return length;
		}
	}
}