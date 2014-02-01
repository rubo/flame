////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto
{
	import flame.core.flame_internal;
	import flame.crypto.asn1.ASN1BitString;
	import flame.crypto.asn1.ASN1GenericConstruct;
	import flame.crypto.asn1.ASN1Integer;
	import flame.crypto.asn1.ASN1Object;
	import flame.crypto.asn1.ASN1ObjectIdentifier;
	import flame.crypto.asn1.ASN1OctetString;
	import flame.crypto.asn1.ASN1Sequence;
	import flame.crypto.asn1.ASN1Tag;
	import flame.numerics.BigInteger;
	import flame.utils.ByteArrayUtil;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.getQualifiedClassName;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;

	[RemoteClass]
	
	/**
	 * Represents the standard parameters for the elliptic curve cryptography (ECC) algorithms.
	 * This class cannot be inherited.
	 */
	public final class ECCParameters
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private static const ECDH_PUBLIC_P256_MAGIC:uint = 0x314B4345;
		private static const ECDH_PRIVATE_P256_MAGIC:uint = 0x324B4345;
		private static const ECDH_PUBLIC_P384_MAGIC:uint = 0x334B4345;
		private static const ECDH_PRIVATE_P384_MAGIC:uint = 0x344B4345;
		private static const ECDH_PUBLIC_P521_MAGIC:uint = 0x354B4345;
		private static const ECDH_PRIVATE_P521_MAGIC:uint = 0x364B4345;
		private static const ECDSA_PUBLIC_P256_MAGIC:uint = 0x31534345;
		private static const ECDSA_PRIVATE_P256_MAGIC:uint = 0x32534345;
		private static const ECDSA_PUBLIC_P384_MAGIC:uint = 0x33534345;
		private static const ECDSA_PRIVATE_P384_MAGIC:uint = 0x34534345;
		private static const ECDSA_PUBLIC_P521_MAGIC:uint = 0x35534345;
		private static const ECDSA_PRIVATE_P521_MAGIC:uint = 0x36534345;
		private static const P256_NAME:String = "ansix9p256r1";
		private static const P384_NAME:String = "ansix9p384r1";
		private static const P521_NAME:String = "ansix9p521r1";
		
		private static var _resourceManager:IResourceManager = ResourceManager.getInstance();
		
		[Transient]
		
		/**
		 * Represents the <code>d</code> parameter for the ECC algorithms.
		 */
		public var d:ByteArray;
		
		/**
		 * Represents the <code>x</code> parameter for the ECC algorithms.
		 */
		public var x:ByteArray;
		
		/**
		 * Represents the <code>y</code> parameter for the ECC algorithms.
		 */
		public var y:ByteArray;
		
		/**
		 * @private
		 */
		internal var algorithmName:String;
		
		/**
		 * @private
		 */
		internal var keySize:int;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the ECCParameters class.
		 */
		public function ECCParameters()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Converts a byte array that contains a key material to an ECCParameters object
		 * according to the specified format.
		 * 
		 * @param data A byte array that contains an ECC key material.
		 * 
		 * @param format A string that specifies the format of the key BLOB.
		 * See KeyBLOBFormat enumeration for a description of specific formats.
		 * 
		 * @return An object that contains the ECC key pair that is specified in the byte array.
		 * 
		 * @throws ArgumentError Thrown in the following situations:<ul>
		 * <li><code>data</code> parameter is <code>null</code>.</li>
		 * <li><code>format</code> parameter is <code>null</code>.</li>
		 * </ul>
		 * 
		 * @throws flame.crypto.CryptoError The key BLOB is not a valid format or is corrupted.
		 * 
		 * @see flame.crypto.KeyBLOBFormat
		 */
		public static function fromByteArray(data:ByteArray, format:String):ECCParameters
		{
			if (data == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "data" ]));
			
			if (format == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "format" ]));
			
			var buffer:ByteArray = ByteArrayUtil.copy(data);
			var includesPrivateParameter:Boolean;
			var keySizeInBytes:int;
			var parameters:ECCParameters;
			
			switch (format)
			{
				case KeyBLOBFormat.ECC_PRIVATE_BLOB:
				case KeyBLOBFormat.ECC_PUBLIC_BLOB:
					
					buffer.endian = Endian.LITTLE_ENDIAN;
					includesPrivateParameter = format == KeyBLOBFormat.ECC_PRIVATE_BLOB;
					
					var magic:uint = buffer.readUnsignedInt();
					
					switch (magic)
					{
						case ECDH_PRIVATE_P256_MAGIC:
						case ECDH_PRIVATE_P384_MAGIC:
						case ECDH_PRIVATE_P521_MAGIC:
						case ECDSA_PRIVATE_P256_MAGIC:
						case ECDSA_PRIVATE_P384_MAGIC:
						case ECDSA_PRIVATE_P521_MAGIC:
							
							if (!includesPrivateParameter)
								throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidParameter"));
							
							break;
							
						case ECDH_PUBLIC_P256_MAGIC:
						case ECDH_PUBLIC_P384_MAGIC:
						case ECDH_PUBLIC_P521_MAGIC:
						case ECDSA_PUBLIC_P256_MAGIC:
						case ECDSA_PUBLIC_P384_MAGIC:
						case ECDSA_PUBLIC_P521_MAGIC:
							
							if (includesPrivateParameter)
								throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidParameter"));
							
							break;
							
						default:
							
							throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidParameter"));
					}
					
					parameters = new ECCParameters();
					parameters.algorithmName = getAlgorithmNameByMagic(magic);
					parameters.keySize = getKeySizeByMagic(magic);
					
					keySizeInBytes = (parameters.keySize + 7) / 8;
					
					if (buffer.readUnsignedInt() != keySizeInBytes)
						throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidParameter"));
					
					var xBytes:ByteArray = new ByteArray();
					var yBytes:ByteArray = new ByteArray();
					
					buffer.readBytes(xBytes, 0, keySizeInBytes);
					buffer.readBytes(yBytes, 0, keySizeInBytes);
					
					parameters.x = xBytes;
					parameters.y = yBytes;
					
					if (includesPrivateParameter)
					{
						if (buffer.bytesAvailable < keySizeInBytes)
							throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidParameter"));
						
						var dBytes:ByteArray = new ByteArray();
						
						buffer.readBytes(dBytes, 0, keySizeInBytes);
						
						parameters.d = dBytes;
					}
					
					break;
				
				case KeyBLOBFormat.PKCS8_PRIVATE_BLOB:
				case KeyBLOBFormat.PKCS8_PUBLIC_BLOB:
					
					includesPrivateParameter = format == KeyBLOBFormat.PKCS8_PRIVATE_BLOB;
					
					var mainSequence:ASN1Sequence = ASN1Object.fromByteArray(buffer) as ASN1Sequence;
					
					if (mainSequence == null || mainSequence.elementCount < (includesPrivateParameter ? 3 : 2))
						throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyBLOB"));
					
					var version:ASN1Integer;
					
					if (includesPrivateParameter)
					{
						version = mainSequence.getElementAt(0) as ASN1Integer;
						
						if (version == null || version.value.flame_internal::bitLength > 32)
							throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyBLOB"));
					}
					
					var oidSequence:ASN1Sequence = mainSequence.getElementAt(includesPrivateParameter ? 1 : 0) as ASN1Sequence;
					
					if (oidSequence == null || oidSequence.elementCount != 2)
						throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyBLOB"));
					
					var keyOID:ASN1ObjectIdentifier = oidSequence.getElementAt(0) as ASN1ObjectIdentifier;
					
					if (CryptoConfig.mapNameToOID("ECC") != keyOID.value)
						throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidAlgorithm"));
					
					var bitString:ASN1BitString;
					var ecOID:ASN1ObjectIdentifier = oidSequence.getElementAt(1) as ASN1ObjectIdentifier;
					
					parameters = new ECCParameters();
					parameters.keySize = getKeySizeByCurveOID(ecOID.value);
					keySizeInBytes = (parameters.keySize + 7) / 8; 
					
					if (includesPrivateParameter)
					{
						var octetString:ASN1OctetString = mainSequence.getElementAt(2) as ASN1OctetString;
						
						if (octetString == null)
							throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyBLOB"));
						
						var keySequence:ASN1Sequence = ASN1Object.fromByteArray(octetString.value) as ASN1Sequence;
						
						if (keySequence == null)
							throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyBLOB"));
						
						version = keySequence.getElementAt(0) as ASN1Integer;
						
						if (version == null || !version.value.equals(BigInteger.ONE))
							throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyBLOB"));
						
						octetString = keySequence.getElementAt(1) as ASN1OctetString;
						
						if (octetString == null || octetString.value.length != keySizeInBytes)
							throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyBLOB"));
						
						parameters.d = octetString.value;
						
						var asn1Construct:ASN1GenericConstruct = keySequence.getElementAt(2) as ASN1GenericConstruct;
						
						if (asn1Construct == null || asn1Construct.tag != (ASN1Tag.TAGGED | ASN1Tag.CONSTRUCTED | 1) || asn1Construct.elementCount != 1)
							throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyBLOB"));
						
						bitString = asn1Construct.getElementAt(0) as ASN1BitString;
					}
					else
						bitString = mainSequence.getElementAt(1) as ASN1BitString;
					
					if (bitString == null || bitString.value.length != 2 * keySizeInBytes + 1 || bitString.value[0] != 4)
						throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyBLOB"));
					
					parameters.x = ByteArrayUtil.getBytes(bitString.value, 1, keySizeInBytes);
					parameters.y = ByteArrayUtil.getBytes(bitString.value, keySizeInBytes + 1, keySizeInBytes);
					break;
				
				default:
					
					throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyBLOBFormat", [ format ]));
			}
			
			return parameters;
		}
		
		/**
		 * Converts the ECCParamaters object to a byte array, in the specified format.
		 * 
		 * @param format A string that specifies the format of the key BLOB.
		 * 
		 * @return A byte array that contains the key material in the specified format.
		 * 
		 * @throws ArgumentError <code>format</code> parameter is <code>null</code>.
		 * 
		 * @throws flame.crypto.CryptoError Thrown in the following situations:<ul>
		 * <li>The key cannot be converted.</li>
		 * <li>The specified key BLOB format is invalid.</li>
		 * </ul> 
		 */
		public function toByteArray(format:String):ByteArray
		{
			if (format == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "format" ]));
			
			var includePrivateParameter:Boolean;
			
			switch (format)
			{
				case KeyBLOBFormat.ECC_PRIVATE_BLOB:
				case KeyBLOBFormat.ECC_PUBLIC_BLOB:
					
					includePrivateParameter = format == KeyBLOBFormat.ECC_PRIVATE_BLOB;
					
					if (includePrivateParameter && d == null)
						throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyState"));
					
					var data:ByteArray = new ByteArray();
					
					data.endian = Endian.LITTLE_ENDIAN;
					
					data.writeUnsignedInt(getMagic(includePrivateParameter));
					data.writeUnsignedInt((keySize + 7) / 8);
					data.writeBytes(x);
					data.writeBytes(y);
					
					if (includePrivateParameter)
						data.writeBytes(d);
					
					data.position = 0;
					
					return data;
					
				case KeyBLOBFormat.PKCS8_PRIVATE_BLOB:
				case KeyBLOBFormat.PKCS8_PUBLIC_BLOB:
					
					includePrivateParameter = format == KeyBLOBFormat.PKCS8_PRIVATE_BLOB;
					
					if (includePrivateParameter && d == null)
						throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyState"));
					
					var mainSequence:ASN1Sequence = new ASN1Sequence();
					var oidSequence:ASN1Sequence = new ASN1Sequence(new <ASN1Object>[
						new ASN1ObjectIdentifier(CryptoConfig.mapNameToOID("ECC")),
						new ASN1ObjectIdentifier(getCurveOIDByKeySize(keySize))
					]);
					
					var buffer:ByteArray = new ByteArray();
					buffer.writeByte(4);
					buffer.writeBytes(x);
					buffer.writeBytes(y);
					
					var bitString:ASN1BitString = new ASN1BitString(buffer);
					
					if (includePrivateParameter)
					{
						var keySequence:ASN1Sequence = new ASN1Sequence();
						
						keySequence.addElement(new ASN1Integer(1));
						keySequence.addElement(new ASN1OctetString(d));
						keySequence.addElement(new ASN1GenericConstruct(ASN1Tag.TAGGED | ASN1Tag.CONSTRUCTED | 1, new <ASN1Object>[ bitString ]));
						
						mainSequence.addElement(new ASN1Integer(0));
						mainSequence.addElement(oidSequence);
						mainSequence.addElement(new ASN1OctetString(keySequence.toByteArray()));
					}
					else
					{
						mainSequence.addElement(oidSequence);
						mainSequence.addElement(bitString);
					}
					
					return mainSequence.toByteArray();
					
				default:
					
					throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyBLOBFormat", [ format ]));
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		internal static function getCurveOIDByKeySize(keySize:int):String
		{
			switch (keySize)
			{
				case 256:
					
					return CryptoConfig.mapNameToOID(P256_NAME);
					
				case 384:
					
					return CryptoConfig.mapNameToOID(P384_NAME);
					
				case 521:
					
					return CryptoConfig.mapNameToOID(P521_NAME);
					
				default:
					
					throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidParameter"));
			}
		}
		
		/**
		 * @private
		 */
		internal static function getKeySizeByCurveOID(oid:String):int
		{
			switch (oid)
			{
				case CryptoConfig.mapNameToOID(P256_NAME):
					
					return 256;
					
				case CryptoConfig.mapNameToOID(P384_NAME):
					
					return 384;
					
				case CryptoConfig.mapNameToOID(P521_NAME):
					
					return 521;
					
				default:
					
					throw new CryptoError(_resourceManager.getString("flameCrypto", "unknownEC"));
			}
		}
		
		/**
		 * @private
		 */
		internal function validate():Boolean
		{
			var domainParameters:ECDomainParameters = ECDomainParametersCache.getParametersByKeySize(keySize);
			var x:BigInteger = new BigInteger(this.x, true);
			var y:BigInteger = new BigInteger(this.y, true);
			
			return y.flame_internal::square().mod(domainParameters.q)
				.equals(x.pow(3).add(x.multiply(domainParameters.a)).add(domainParameters.b).mod(domainParameters.q));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private static function getAlgorithmNameByMagic(magic:uint):String
		{
			switch (magic)
			{
				case ECDH_PRIVATE_P256_MAGIC:
				case ECDH_PRIVATE_P384_MAGIC:
				case ECDH_PRIVATE_P521_MAGIC:
				case ECDH_PUBLIC_P256_MAGIC:
				case ECDH_PUBLIC_P384_MAGIC:
				case ECDH_PUBLIC_P521_MAGIC:
					
					return getQualifiedClassName(ECDiffieHellman);
					
				case ECDSA_PRIVATE_P256_MAGIC:
				case ECDSA_PRIVATE_P384_MAGIC:
				case ECDSA_PRIVATE_P521_MAGIC:
				case ECDSA_PUBLIC_P256_MAGIC:
				case ECDSA_PUBLIC_P384_MAGIC:
				case ECDSA_PUBLIC_P521_MAGIC:
					
					return getQualifiedClassName(ECDSA);
					
				default:
					
					throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidParameter"));
			}
		}
		
		private static function getKeySizeByMagic(magic:uint):int
		{
			switch (magic)
			{
				case ECDH_PRIVATE_P256_MAGIC:
				case ECDH_PUBLIC_P256_MAGIC:
				case ECDSA_PRIVATE_P256_MAGIC:
				case ECDSA_PUBLIC_P256_MAGIC:
					
					return 256;
					
				case ECDH_PRIVATE_P384_MAGIC:
				case ECDH_PUBLIC_P384_MAGIC:
				case ECDSA_PRIVATE_P384_MAGIC:
				case ECDSA_PUBLIC_P384_MAGIC:
					
					return 384;
					
				case ECDH_PRIVATE_P521_MAGIC:
				case ECDH_PUBLIC_P521_MAGIC:
				case ECDSA_PRIVATE_P521_MAGIC:
				case ECDSA_PUBLIC_P521_MAGIC:
					
					return 521;
					
				default:
					
					throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidParameter"));
			}
		}
		
		private function getMagic(includePrivateParameters:Boolean):uint
		{
			if (algorithmName == getQualifiedClassName(ECDiffieHellman))
				switch (keySize)
				{
					case 256:
						
						return includePrivateParameters ? ECDH_PRIVATE_P256_MAGIC : ECDH_PUBLIC_P256_MAGIC;
						
					case 384:
						
						return includePrivateParameters ? ECDH_PRIVATE_P384_MAGIC : ECDH_PUBLIC_P384_MAGIC;
						
					case 521:
						
						return includePrivateParameters ? ECDH_PRIVATE_P521_MAGIC : ECDH_PUBLIC_P521_MAGIC;
						
					default:
						
						throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidParameter"));
				}
				
			if (algorithmName == getQualifiedClassName(ECDSA))
				switch (keySize)
				{
					case 256:
						
						return includePrivateParameters ? ECDSA_PRIVATE_P256_MAGIC : ECDSA_PUBLIC_P256_MAGIC;
						
					case 384:
						
						return includePrivateParameters ? ECDSA_PRIVATE_P384_MAGIC : ECDSA_PUBLIC_P384_MAGIC;
						
					case 521:
						
						return includePrivateParameters ? ECDSA_PRIVATE_P521_MAGIC : ECDSA_PUBLIC_P521_MAGIC;
						
					default:
						
						throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidParameter"));
				}
					
			throw new CryptoError(_resourceManager.getString("flameCrypto", "unknownECAlgorithm"));
		}
	}
}