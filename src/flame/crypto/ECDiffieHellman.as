////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2011 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto
{
	import flame.core.flame_internal;
	import flame.numerics.BigInteger;
	
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;

	/**
	 * Provides an implementation of the Elliptic Curve Diffie-Hellman (ECDH) algorithm.
	 * This class cannot be inherited.
	 * <p>The ECDiffieHellman class enables two parties to exchange private key material
	 * even if they are communicating through a public channel. Both parties can calculate the same secret value,
	 * which is referred to as the secret agreement in the managed Diffie-Hellman classes.
	 * The secret agreement can then be used for a variety of purposes, including as a symmetric key.
	 * However, instead of using the secret agreement directly,
	 * it is highly recommended to apply some post-processing on the agreement before providing the value.
	 * This post processing is referred to as the key derivation function (KDF);
	 * you can select which KDF you want to use and set its parameters
	 * through a set of properties on the instances of the ECDiffieHellmanHashKeyExchangeDeformatter
	 * or ECDiffieHellmanHMACKeyExchangeDeformatter classes.</p>
	 * <p>The result of passing the secret agreement through the key derivation function
	 * is a byte array that may be used as key material for your application.
	 * The number of bytes of key material generated is dependent on the key derivation function;
	 * for example, SHA-256 will generate 256 bits of key material, whereas SHA-512 will generate 512 bits of key material.
	 * The basic flow of an ECDH key exchange is as follows:<ol>
	 * <li>Alice and Bob create a key pair to use for the Diffie-Hellman key exchange operation.</li>
	 * <li>Alice and Bob configure the KDF using parameters the agree on.</li>
	 * <li>Alice sends Bob her public key.</li>
	 * <li>Bob sends Alice his public key.</li>
	 * <li>Alice and Bob use each other's public keys to generate the secret agreement,
	 * and apply the KDF to the secret agreement to generate key material.</li>
	 * </ol></p>
	 * 
	 * @see flame.crypto.ECDiffieHellmanHashKeyExchangeDeformatter
	 * @see flame.crypto.ECDiffieHellmanHMACKeyExchangeDeformatter
	 */
	public final class ECDiffieHellman extends AsymmetricAlgorithm
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private var _curve:EllipticCurve;
		private var _d:BigInteger;
		private var _domainParameters:ECDomainParameters;
		private var _isKeyPairGenerated:Boolean;
		private var _x:BigInteger;
		private var _y:BigInteger;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the ECDiffieHellman class
		 * with the specified key size or key pair.
		 * 
		 * @param key If the parameter type is int, it specifies the size of the key to use, in bits.
		 * If the parameter type is ECCParameters, it specifies the key pair to be passed.
		 * 
		 * @throws flame.crypto.CryptoError <code>key</code> parameter specifies an invalid length.
		 * 
		 * @throws TypeError <code>key</code> paramater has an invalid type.
		 */
		public function ECDiffieHellman(key:* = 256)
		{
			super();
			
			_legalKeySizes = new <KeySizes>[ new KeySizes(256, 384, 128), new KeySizes(521, 521, 0) ];
			_legalKeySizes.fixed = true;
			
			if (key is int)
				setKeySize(key);
			else if (key is ECCParameters)
				importParameters(key);
			else
				throw new TypeError(_resourceManager.getString("flameCore", "argInvalidValue", [ "key" ]));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Returns the secret agreement generated between two parties,
		 * given a ECCParameters object that contains the second party's public key.
		 * 
		 * @param otherPartyPublicKey An object that contains the public part of
		 * the elliptic curve cryptography (ECC) key from the other party in the key exchange.
		 * 
		 * @return The secret agreement. This information is calculated
		 * from this instanse's private key and the specified public key.
		 * 
		 * @throws ArgumentError <code>otherPartyPublicKey</code> parameter is <code>null</code>.
		 * 
		 * @throws flame.crypto.CryptoError Thrown in the following situations:<ul>
		 * <li><code>otherPartyPublicKey</code> is not a valid elliptic curve cryptography (ECC) key.</li>
		 * <li>The private key does not exist.</li>
		 * </ul>
		 * 
		 * @see flame.crypto.ECCParameters
		 */
		public function deriveSecretAgreement(otherPartyPublicKey:ECCParameters):ByteArray
		{
			if (otherPartyPublicKey == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "otherPartyPublicKey" ]));
			
			if (!_isKeyPairGenerated)
				generateKeyPair();
			
			if (publicOnly)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "keyNotExist"));
			
			if (otherPartyPublicKey.keySize != _keySize)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "eccKeySizeMismatch"));
			
			var x:BigInteger = new BigInteger(otherPartyPublicKey.x, true);
			var y:BigInteger = new BigInteger(otherPartyPublicKey.y, true);
			
			return CryptoUtil.ensureLength(_curve.createPoint(x, y).multiply(_d).x.toBigInteger().toByteArray(), (_keySize + 7) / 8);
		}
		
		/**
		 * Exports the key used by the ECDiffieHellman object into an ECCParameters object.
		 * 
		 * @param includePrivateParameters <code>true</code> to include private parameters;
		 * otherwise, <code>false</code>.
		 * 
		 * @return The key pair for ECDiffieHellman.
		 * 
		 * @throws flame.crypto.CryptoError The key cannot be exported.
		 */
		public function exportParameters(includePrivateParameters:Boolean):ECCParameters
		{
			if (!_isKeyPairGenerated)
				generateKeyPair();
			
			var keySizeInBytes:int = (_keySize + 7) / 8;
			var parameters:ECCParameters = new ECCParameters();
			
			parameters.algorithmName = getQualifiedClassName(this);
			parameters.keySize = _keySize;
			
			if (includePrivateParameters)
			{
				if (publicOnly)
					throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyState"));
				
				parameters.d = CryptoUtil.ensureLength(_d.toByteArray(), keySizeInBytes);
			}
			
			parameters.x = CryptoUtil.ensureLength(_x.toByteArray(), keySizeInBytes);
			parameters.y = CryptoUtil.ensureLength(_y.toByteArray(), keySizeInBytes);
			
			return parameters;
		}
		
		/**
		 * Deserializes the key information from an XML string by using the RFC 4050 format.
		 * 
		 * @param value The XML-based key information to be deserialized.
		 * 
		 * @throws ArgumentError <code>value</code> parameter is <code>null</code>.
		 */
		public override function fromXMLString(value:String):void
		{
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
			importParameters(RFC4050KeyFormatter.fromXMLString(value));
		}
		
		/**
		 * Imports the key from the specified ECCParameters.
		 * 
		 * @param parameters The key pair for ECDiffieHellman.
		 * 
		 * @throws ArgumentError <code>parameters</code> parameter is <code>null</code>.
		 * 
		 * @throws flame.crypto.CryptoError The <code>parameters</code> parameter has missing fields.
		 */
		public function importParameters(parameters:ECCParameters):void
		{
			if (parameters == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "parameters" ]));
			
			if (parameters.algorithmName != getQualifiedClassName(this))
				throw new CryptoError(_resourceManager.getString("flameCrypto", "eccMagicMismatch", [ getQualifiedClassName(this) ]));
			
			if (parameters.x == null)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeySize"));
			
			if (parameters.y == null)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeySize"));
			
			if (!parameters.validate())
				throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidParameter"));
			
			setKeySize(parameters.keySize);
			
			if (parameters.d != null)
				_d = new BigInteger(parameters.d, true);
			
			_x = new BigInteger(parameters.x, true);
			_y = new BigInteger(parameters.y, true);
			
			_isKeyPairGenerated = true;
		}
		
		/**
		 * Serializes the key information to an XML string by using the RFC 4050 format.
		 * 
		 * @param includePrivateParameters <code>true</code> to include private parameters; otherwise, <code>false</code>.
		 * 
		 * @return A string object that contains the key information, serialized to an XML string.
		 */
		public override function toXMLString(includePrivateParameters:Boolean):String
		{
			return RFC4050KeyFormatter.toXMLString(exportParameters(includePrivateParameters));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Gets a value that indicates whether the RSA object contains only a public key.
		 * <p>The RSA class can be initialized either with a public key only
		 * or with both a public and private key. Use the <code>publicOnly</code> property to determine
		 * whether the current instance contains only a public key or both a public and private key.</p>
		 */
		public function get publicOnly():Boolean
		{
			return _isKeyPairGenerated && _d == null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function generateKeyPair():void
		{
			_d = new BigInteger(RandomNumberGenerator.getNonZeroBytes(_domainParameters.n.flame_internal::bitLength))
				.mod(_domainParameters.n.subtract(BigInteger.ONE)).add(BigInteger.ONE);
			
			var point:ECPoint = _curve.createPoint(_domainParameters.x, _domainParameters.y).multiply(_d);
			
			_x = point.x.toBigInteger();
			_y = point.y.toBigInteger();
			
			_isKeyPairGenerated = true;
		}
		
		private function setKeySize(value:int):void
		{
			if (!validateKeySize(value))
				throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeySize"));
			
			_keySize = value;
			_domainParameters = ECDomainParametersCache.getParametersByKeySize(_keySize);
			_curve = new PrimeEllipticCurve(_domainParameters.q, _domainParameters.a, _domainParameters.b);
		}
	}
}