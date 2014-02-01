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
	import flame.numerics.BigInteger;
	
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Provides an implementation of the Elliptic Curve Digital Signature Algorithm (ECDSA).
	 * This class cannot be inherited.
	 * <p>To use a public-key system to digitally sign a message,
	 * the sender first applies a hash function to the message to create a message digest.
	 * The sender then encrypts the message digest with the sender's private key
	 * to create the sender's personal signature. Upon receiving the message and signature,
	 * the receiver decrypts the signature using the sender's public key to recover the message digest
	 * and hashes the message using the same hash algorithm that the sender used.
	 * If the message digest that the receiver computes exactly matches the message digest received from the sender,
	 * the receiver can be sure that the message was not altered while in transit.
	 * Note that a signature can be verified by anyone, because the sender's public key is common knowledge.</p>
	 */
	public final class ECDSA extends AsymmetricAlgorithm
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
		 * Initializes a new instance of the ECDSA class
		 * with the specified key size or key pair.
		 * 
		 * @param key If the parameter type is int, it specifies the size of the key to use, in bits.
		 * If the parameter type is ECCParameters, it specifies the key pair to be passed.
		 * 
		 * @throws flame.crypto.CryptoError <code>keySize</code> parameter specifies an invalid length.
		 * 
		 * @throws TypeError <code>key</code> paramater has an invalid type.
		 */
		public function ECDSA(key:* = 256)
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
		 * Exports the key used by the ECDSA object into an ECCParameters object.
		 * 
		 * @param includePrivateParameters <code>true</code> to include private parameters;
		 * otherwise, <code>false</code>.
		 * 
		 * @return The key pair for ECDSA.
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
		 * @param parameters The key pair for ECDSA.
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
		 * Generates a signature for the specified hash value.
		 * 
		 * @param hash The hash value of the data to be signed.
		 * 
		 * @return A digital signature for the specified hash value.
		 * 
		 * @throws ArgumentError <code>hash</code> parameter is <code>null</code>.
		 * 
		 * @throws flame.crypto.CryptoError The private key does not exist.
		 */
		public function signHash(hash:ByteArray):ByteArray
		{
			if (hash == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "hash" ]));
			
			if (publicOnly)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "keyNotExist"));
			
			if (!_isKeyPairGenerated)
				generateKeyPair();
			
			var buffer:ByteArray = new ByteArray();
			
			buffer.writeBytes(hash, 0, Math.min(hash.length, int((_domainParameters.n.flame_internal::bitLength + 7) / 8)));
			
			var e:BigInteger = new BigInteger(buffer, true);
			var k:BigInteger = new BigInteger(RandomNumberGenerator.getNonZeroBytes(_domainParameters.n.flame_internal::bitLength), true)
				.mod(_domainParameters.n.subtract(BigInteger.ONE)).add(BigInteger.ONE);
			var r:BigInteger = _curve.createPoint(_domainParameters.x, _domainParameters.y).multiply(k).x.toBigInteger().mod(_domainParameters.n);
			var s:BigInteger = k.flame_internal::modInverse(_domainParameters.n).multiply(e.add(_d.multiply(r))).mod(_domainParameters.n);
			var keySizeInBytes:int = (_keySize + 7) / 8;
			
			buffer.clear();
			buffer.writeBytes(CryptoUtil.ensureLength(r.toByteArray(), keySizeInBytes));
			buffer.writeBytes(CryptoUtil.ensureLength(s.toByteArray(), keySizeInBytes));
			
			buffer.position = 0;
			
			return buffer;
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
		
		/**
		 * Verifies the specified digital signature against a specified hash value.
		 * 
		 * @param hash The hash value of the data to be verified.
		 * 
		 * @param signature The digital signature of the data to be verified against the hash value.
		 * 
		 * @return <code>true</code> if the signature is valid; otherwise, <code>false</code>.
		 */
		public function verifyHash(hash:ByteArray, signature:ByteArray):Boolean
		{
			if (hash == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "hash" ]));
			
			if (signature == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "signature" ]));
			
			if (signature.length != _keySize >> 2)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidParameter"));
			
			if (!_isKeyPairGenerated)
				generateKeyPair();
			
			var buffer:ByteArray = new ByteArray();
			var keySizeInBytes:int = (_keySize + 7) / 8;
			
			buffer.writeBytes(signature, 0, keySizeInBytes);
			
			var r:BigInteger = new BigInteger(buffer, true);
			
			buffer.clear();
			buffer.writeBytes(signature, keySizeInBytes);
			
			var inverse:BigInteger = new BigInteger(buffer, true).flame_internal::modInverse(_domainParameters.n);
			
			buffer.clear();
			buffer.writeBytes(hash, 0, Math.min(hash.length, int((_domainParameters.n.flame_internal::bitLength + 7) / 8)));
			
			var u1:BigInteger = new BigInteger(buffer, true).multiply(inverse).mod(_domainParameters.n);
			var u2:BigInteger = r.multiply(inverse).mod(_domainParameters.n);
			var g:ECPoint = _curve.createPoint(_domainParameters.x, _domainParameters.y);
			var q:ECPoint = _curve.createPoint(_x, _y);
			var gq:ECPoint = g.add(q);
			var result:ECPoint = g.curve.pointAtInfinity;
			
			for (var i:int = Math.max(u1.flame_internal::bitLength, u2.flame_internal::bitLength) - 1; i >= 0; i--)
			{
				result = result.double();
				
				if (u1.flame_internal::isBitSet(i))
					result = result.add(u2.flame_internal::isBitSet(i) ? gq : g);
				else if (u2.flame_internal::isBitSet(i))
					result = result.add(q);
			}
			
			return r.equals(result.x.toBigInteger().mod(_domainParameters.n));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public proeprties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Gets a value that indicates whether the ECDSA object contains only a public key.
		 * <p>The ECDSA class can be initialized either with a public key only
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