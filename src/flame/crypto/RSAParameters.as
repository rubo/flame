////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto
{
	import flame.core.flame_internal;
	import flame.crypto.asn1.ASN1BitString;
	import flame.crypto.asn1.ASN1Integer;
	import flame.crypto.asn1.ASN1Null;
	import flame.crypto.asn1.ASN1Object;
	import flame.crypto.asn1.ASN1ObjectIdentifier;
	import flame.crypto.asn1.ASN1OctetString;
	import flame.crypto.asn1.ASN1Sequence;
	import flame.numerics.BigInteger;
	import flame.utils.ByteArrayUtil;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	[RemoteClass]
	
	/**
	 * Represents the standard parameters for the RSA algorithm.
	 * <p>The RSA class exposes an <code>exportParameters()</code> method
	 * that enables you to retrieve the raw RSA key in the form of an RSAParameters structure.
	 * Understanding the contents of this structure requires familiarity with how the RSA algorithm works.
	 * The next section discusses the algorithm briefly.</p>
	 * <p><strong>RSA Algorithm</strong><br />
	 * To generate a key pair, you start by creating two large prime numbers named p and q.
	 * These numbers are multiplied and the result is called n. Because p and q are both prime numbers,
	 * the only factors of n are 1, p, q, and n. If we consider only numbers that are less than n,
	 * the count of numbers that are relatively prime to n, that is,
	 * have no factors in common with n, equals (p - 1)(q - 1).</p>
	 * <p>Now you choose a number e, which is relatively prime to the value you calculated.
	 * The public key is now represented as {e, n}. To create the private key,
	 * you must calculate d, which is a number such that (d)(e) mod (p - 1)(q - 1) = 1.
	 * In accordance with the Euclidean algorithm, the private key is now {d, n}.</p>
	 * <p>Encryption of plaintext m to ciphertext c is defined as c = (m ^ e) mod n.
	 * Decryption would then be defined as m = (c ^ d) mod n.</p>
	 * <p><strong>Summary of Fields</strong><br />
	 * Section A.1.2 of the PKCS #1: RSA Cryptography Standard defines a format for RSA private keys.
	 * The following table summarizes the fields of the RSAParameters structure.
	 * The third column provides the corresponding field in section A.1.2 of PKCS #1: RSA Cryptography Standard.</p>
	 * <p><table class="innertable">
	 * <tr><th>RSAParameters field</th><th>Contains</th><th>Corresponding PKCS #1 field</th></tr>
	 * <tr><td>d</td><td>d, the private exponent</td><td>privateExponent</td></tr>
	 * <tr><td>dP</td><td>d mod (p - 1)</td><td>exponent1</td></tr>
	 * <tr><td>dQ</td><td>d mod (q - 1)</td><td>exponent2</td></tr>
	 * <tr><td>exponent</td><td>e, the public exponent</td><td>publicExponent</td></tr>
	 * <tr><td>inverseQ</td><td>(inverseQ)(q) = 1 mod p</td><td>coefficient</td></tr>
	 * <tr><td>modulus</td><td>n</td><td>modulus</td></tr>
	 * <tr><td>p</td><td>p</td><td>prime1</td></tr>
	 * <tr><td>q</td><td>q</td><td>prime2</td></tr>
	 * </table></p>
	 * <p>The security of RSA derives from the fact that, given the public key {e, n},
	 * it is computationally infeasible to calculate d, either directly or by factoring n into p and q.
	 * Therefore, any part of the key related to d, p, or q must be kept secret.
	 * If you call the <code>exportParameters()</code> method and ask for only the public key information,
	 * this is why you will receive only <code>exponent</code> and <code>modulus</code>.
	 * The other fields are available only if you have access to the private key, and you request it.</p>
	 * <p>RSAParameters is not encrypted in any way, so you must be careful
	 * when you use it with the private key information. In fact, none of the fields
	 * that contain private key information can be serialized.
	 * If you try to serialize an RSAParameters structure with a remoting call
	 * or by using one of the serializers, you will receive only public key information.
	 * If you want to pass private key information, you will have to manually send that data.
	 * In all cases, if anyone can derive the parameters, the key that you transmit becomes useless.</p>
	 */
	public final class RSAParameters
	{
		//--------------------------------------------------------------------------
	    //
	    //  Fields
	    //
	    //--------------------------------------------------------------------------
	    
		private static const RSA_FULL_PRIVATE_MAGIC:uint = 0x33415352; // RSA3
		private static const RSA_PRIVATE_MAGIC:uint = 0x32415352; // RSA2
		private static const RSA_PUBLIC_MAGIC:uint = 0x31415352; // RSA1
		
		private static var _resourceManager:IResourceManager = ResourceManager.getInstance();
		
		[Transient]
		
		/**
		 * Represents the <code>d</code> parameter for the RSA algorithm.
		 */
	    public var d:ByteArray;
		
		[Transient]
		
		/**
		 * Represents the <code>dP</code> parameter for the RSA algorithm.
		 */
	    public var dP:ByteArray;
		
		[Transient]
		
		/**
		 * Represents the <code>dQ</code> parameter for the RSA algorithm.
		 */
	    public var dQ:ByteArray;
		
		/**
		 * Represents the <code>exponent</code> parameter for the RSA algorithm.
		 */
		public var exponent:ByteArray;
		
		[Transient]
		
		/**
		 * Represents the <code>inverseQ</code> parameter for the RSA algorithm.
		 */
	    public var inverseQ:ByteArray;
		
		/**
		 * Represents the <code>modulus</code> parameter for the RSA algorithm.
		 */
		public var modulus:ByteArray;
		
		[Transient]
		
		/**
		 * Represents the <code>p</code> parameter for the RSA algorithm.
		 */
	    public var p:ByteArray;
		
		[Transient]
		
		/**
		 * Represents the <code>q</code> parameter for the RSA algorithm.
		 */
	    public var q:ByteArray;
		
	    //--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Initializes a new instance of the RSAParameters class.
		 */
		public function RSAParameters()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Converts a byte array that contains a key material to an RSAParameters object
		 * according to the specified format.
		 * 
		 * @param data A byte array that contains an RSA key material.
		 * 
		 * @param format A string that specifies the format of the key BLOB.
		 * See KeyBLOBFormat enumeration for a description of specific formats.
		 * 
		 * @return An object that contains the RSA key pair that is specified in the byte array.
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
		public static function fromByteArray(data:ByteArray, format:String):RSAParameters
		{
			if (data == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "data" ]));
			
			var buffer:ByteArray = ByteArrayUtil.copy(data);
			var keySizeInBytes:int;
			var parameters:RSAParameters;
			
			switch (format)
			{
				case KeyBLOBFormat.RSA_FULL_PRIVATE_BLOB:
				case KeyBLOBFormat.RSA_PRIVATE_BLOB:
				case KeyBLOBFormat.RSA_PUBLIC_BLOB:
					
					buffer.endian = Endian.LITTLE_ENDIAN;
					
					var magic:uint = buffer.readUnsignedInt();
					
					if (magic != getMagicByKeyBLOBFormat(format))
						throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidParameter"));
					
					parameters = new RSAParameters();
					
					var keySize:int = buffer.readUnsignedInt();
					var exponentSize:int = buffer.readUnsignedInt();
					var modulusSize:int = buffer.readUnsignedInt();
					var pSize:int = buffer.readUnsignedInt();
					var qSize:int = buffer.readUnsignedInt();
					
					parameters.exponent = new ByteArray();
					parameters.modulus = new ByteArray();
					
					buffer.readBytes(parameters.exponent, 0, exponentSize);
					buffer.readBytes(parameters.modulus, 0, modulusSize);
					
					if (format != KeyBLOBFormat.RSA_PUBLIC_BLOB)
					{
						parameters.p = new ByteArray();
						parameters.q = new ByteArray();
						
						buffer.readBytes(parameters.p, 0, pSize);
						buffer.readBytes(parameters.q, 0, qSize);
						
						if (format == KeyBLOBFormat.RSA_FULL_PRIVATE_BLOB)
						{
							parameters.d = new ByteArray();
							parameters.dP = new ByteArray();
							parameters.dQ = new ByteArray();
							parameters.inverseQ = new ByteArray();
							
							buffer.readBytes(parameters.dP, 0, pSize);
							buffer.readBytes(parameters.dQ, 0, qSize);
							buffer.readBytes(parameters.inverseQ, 0, pSize);
							buffer.readBytes(parameters.d, 0, modulusSize);
						}
					}
					
					break;
				
				case KeyBLOBFormat.PKCS8_PRIVATE_BLOB:
				case KeyBLOBFormat.PKCS8_PUBLIC_BLOB:
					
					var includesPrivateParameters:Boolean = format == KeyBLOBFormat.PKCS8_PRIVATE_BLOB;
					
					var mainSequence:ASN1Sequence = ASN1Object.fromByteArray(buffer) as ASN1Sequence;
					
					if (mainSequence == null || mainSequence.elementCount < (includesPrivateParameters ? 3 : 2))
						throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyBLOB"));
					
					var integer:ASN1Integer;
					
					if (includesPrivateParameters)
					{
						integer = mainSequence.getElementAt(0) as ASN1Integer;
						
						if (integer == null || integer.value.flame_internal::bitLength > 32)
							throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyBLOB"));
					}
					
					var oidSequence:ASN1Sequence = mainSequence.getElementAt(includesPrivateParameters ? 1 : 0) as ASN1Sequence;
					
					if (oidSequence == null || oidSequence.elementCount != 2 || !(oidSequence.getElementAt(1) is ASN1Null))
						throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyBLOB"));
					
					var oid:ASN1ObjectIdentifier = oidSequence.getElementAt(0) as ASN1ObjectIdentifier;
					
					if (CryptoConfig.mapNameToOID("RSA") != oid.value)
						throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidAlgorithm"));
					
					parameters = new RSAParameters();
					
					var keySequence:ASN1Sequence;
					
					if (includesPrivateParameters)
					{
						var octetString:ASN1OctetString = mainSequence.getElementAt(2) as ASN1OctetString;
						
						if (octetString == null)
							throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyBLOB"));
						
						keySequence = ASN1Object.fromByteArray(octetString.value) as ASN1Sequence;
					}
					else
					{
						var bitString:ASN1BitString = mainSequence.getElementAt(1) as ASN1BitString;
						
						keySequence = ASN1Object.fromByteArray(bitString.value) as ASN1Sequence;
					}
					
					if (keySequence == null)
						throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyBLOB"));
						
					if (includesPrivateParameters)
					{
						integer = keySequence.getElementAt(0) as ASN1Integer;
						
						if (integer == null || !integer.value.equals(BigInteger.ZERO))
							throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyBLOB"));
					}
						
					integer = keySequence.getElementAt(includesPrivateParameters ? 1 : 0) as ASN1Integer;
					
					if (integer == null)
						throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyBLOB"));
					
					parameters.modulus = integer.value.toByteArray();
					
					integer = keySequence.getElementAt(includesPrivateParameters ? 2 : 1) as ASN1Integer;
					
					if (integer == null)
						throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyBLOB"));
					
					parameters.exponent = integer.value.toByteArray();
					
					if (includesPrivateParameters)
					{
						integer = keySequence.getElementAt(3) as ASN1Integer;
						
						if (integer == null)
							throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyBLOB"));
						
						parameters.d = integer.value.toByteArray();
						
						integer = keySequence.getElementAt(4) as ASN1Integer;
						
						if (integer == null)
							throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyBLOB"));
						
						parameters.p = integer.value.toByteArray();
						
						integer = keySequence.getElementAt(5) as ASN1Integer;
						
						if (integer == null)
							throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyBLOB"));
						
						parameters.q = integer.value.toByteArray();
						
						integer = keySequence.getElementAt(6) as ASN1Integer;
						
						if (integer == null)
							throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyBLOB"));
						
						parameters.dP = integer.value.toByteArray();
						
						integer = keySequence.getElementAt(7) as ASN1Integer;
						
						if (integer == null)
							throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyBLOB"));
						
						parameters.dQ = integer.value.toByteArray();
						
						integer = keySequence.getElementAt(8) as ASN1Integer;
						
						if (integer == null)
							throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyBLOB"));
						
						parameters.inverseQ = integer.value.toByteArray();
					}
						
					break;
				
				default:
					
					throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyBLOBFormat", [ format ]));
			}
			
			return parameters;
		}
		
		/**
		 * Converts the RSAParamaters object to a byte array, in the specified format.
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
			var includePrivateParameters:Boolean;
			
			switch (format)
			{
				case KeyBLOBFormat.RSA_FULL_PRIVATE_BLOB:
				case KeyBLOBFormat.RSA_PRIVATE_BLOB:
				case KeyBLOBFormat.RSA_PUBLIC_BLOB:
					
					includePrivateParameters = format != KeyBLOBFormat.RSA_PUBLIC_BLOB;
					
					if (includePrivateParameters && (p == null || q == null))
						throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyState"));
					
					var data:ByteArray = new ByteArray();
					
					data.endian = Endian.LITTLE_ENDIAN;
					
					data.writeUnsignedInt(getMagicByKeyBLOBFormat(format));
					data.writeUnsignedInt(modulus.length << 3);
					data.writeUnsignedInt(exponent.length);
					data.writeUnsignedInt(modulus.length);
					data.writeUnsignedInt(includePrivateParameters ? p.length : 0);
					data.writeUnsignedInt(includePrivateParameters ? q.length : 0);
					data.writeBytes(exponent);
					data.writeBytes(modulus);
					
					if (includePrivateParameters)
					{
						data.writeBytes(p);
						data.writeBytes(q);
						
						if (format == KeyBLOBFormat.RSA_FULL_PRIVATE_BLOB)
						{
							if (d == null || dP == null || dQ == null || inverseQ == null)
								throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyState"));
							
							data.writeBytes(dP);
							data.writeBytes(dQ);
							data.writeBytes(inverseQ);
							data.writeBytes(d);
						}
					}
					
					data.position = 0;
					
					return data;
					
				case KeyBLOBFormat.PKCS8_PRIVATE_BLOB:
				case KeyBLOBFormat.PKCS8_PUBLIC_BLOB:
					
					includePrivateParameters = format == KeyBLOBFormat.PKCS8_PRIVATE_BLOB;
					
					if (includePrivateParameters && (p == null || q == null || d == null || dP == null || dQ == null || inverseQ == null))
						throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyState"));
					
					var mainSequence:ASN1Sequence = new ASN1Sequence();
					var oidSequence:ASN1Sequence = new ASN1Sequence(new <ASN1Object>[
						new ASN1ObjectIdentifier(CryptoConfig.mapNameToOID("RSA")),
						ASN1Null.NULL
					]);
					
					var keySequence:ASN1Sequence = new ASN1Sequence();
					
					if (includePrivateParameters)
					{
						keySequence.addElement(new ASN1Integer(0));
						keySequence.addElement(new ASN1Integer(modulus));
						keySequence.addElement(new ASN1Integer(exponent));
						keySequence.addElement(new ASN1Integer(d));
						keySequence.addElement(new ASN1Integer(p));
						keySequence.addElement(new ASN1Integer(q));
						keySequence.addElement(new ASN1Integer(dP));
						keySequence.addElement(new ASN1Integer(dQ));
						keySequence.addElement(new ASN1Integer(inverseQ));
						
						mainSequence.addElement(new ASN1Integer(0));
						mainSequence.addElement(oidSequence);
						mainSequence.addElement(new ASN1OctetString(keySequence.toByteArray()));
					}
					else
					{
						keySequence.addElement(new ASN1Integer(modulus));
						keySequence.addElement(new ASN1Integer(exponent));
						
						mainSequence.addElement(oidSequence);
						mainSequence.addElement(new ASN1BitString(keySequence.toByteArray()));
					}
					
					return mainSequence.toByteArray();
					
				default:
					
					throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyBLOBFormat", [ format ]));
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private static function getMagicByKeyBLOBFormat(format:String):uint
		{
			switch (format)
			{
				case KeyBLOBFormat.RSA_FULL_PRIVATE_BLOB:
					
					return RSA_FULL_PRIVATE_MAGIC;
				
				case KeyBLOBFormat.RSA_PRIVATE_BLOB:
					
					return RSA_PRIVATE_MAGIC;
				
				case KeyBLOBFormat.RSA_PRIVATE_BLOB:
					
					return RSA_PUBLIC_MAGIC;
					
				default:
					
					throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyBLOBFormat", [ format ]));
			}
		}
	}
}