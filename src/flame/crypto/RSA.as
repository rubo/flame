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
	import flame.numerics.BigInteger;
	import flame.utils.Convert;
	
	import flash.utils.ByteArray;
	
	/**
	 * Performs asymmetric encryption and decryption using the RSA algorithm.
	 * This class cannot be inherited.
	 * <p>The RSA supports key lengths from 384 bits to 4096 bits in increments of 8 bits.</p>
	 */
	public final class RSA extends AsymmetricAlgorithm
	{
		//--------------------------------------------------------------------------
	    //
	    //  Fields
	    //
	    //--------------------------------------------------------------------------
		
		private var _d:BigInteger;
		private var _dP:BigInteger;
		private var _dQ:BigInteger;
		private var _exponent:BigInteger = new BigInteger(65537);
		private var _inverseQ:BigInteger;
		private var _isKeyParametersGenerated:Boolean;
		private var _modulus:BigInteger;
		private var _p:BigInteger;
		private var _q:BigInteger;
		private var _useCRT:Boolean;
		private var _useKeyBlinding:Boolean;
		
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the RSA class
		 * with the specified key size or key pair.
		 * 
		 * @param key If the parameter type is int, it specifies the size of the key to use, in bits.
		 * If the parameter type is RSAParameters, it specifies the key pair to be passed.
		 * 
		 * @throws flame.crypto.CryptoError <code>key</code> parameter specifies an invalid length.
		 * 
		 * @throws TypeError <code>key</code> paramater has an invalid type.
		 */
		public function RSA(key:* = 512)
		{
			super();
			
			_legalKeySizes = new <KeySizes>[ new KeySizes(384, 4096, 8) ];
			_legalKeySizes.fixed = true;
			
			if (key is int)
				setKeySize(key);
			else if (key is RSAParameters)
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
		 * Decrypts data with the RSA algorithm.
		 *  
		 * @param data The data to be decrypted.
		 * 
		 * @return The decrypted data, which is the original plain text before encryption.
		 * 
		 * @throws ArgumentError <code>data</code> parameter is <code>null</code>.
		 * 
		 * @throws flame.crypto.CryptoError The private key does not exist.
		 */
	    public function decrypt(data:ByteArray):ByteArray
	    {
			if (data == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "data" ]));
			
			if (!_isKeyParametersGenerated)
				generateKeyPair();
			
			var r:BigInteger;
			var t:BigInteger = new BigInteger(data, true);
			
			if (_useKeyBlinding)
			{
				r = new BigInteger(RandomNumberGenerator.getNonZeroBytes(_keySize >> 3), true);
				t = r.modPow(_exponent, _modulus).multiply(t).mod(_modulus);
			}
			
			if (_useCRT)
			{
		    	var tP:BigInteger = t.mod(_p).modPow(_dP, _p);
		    	var tQ:BigInteger = t.mod(_q).modPow(_dQ, _q);
				
				t = tQ > tP
					? tQ.add(_q.multiply(_p.subtract(tQ.subtract(tP).multiply(_inverseQ).mod(_p))))
					: tQ.add(_q.multiply(tP.subtract(tQ).multiply(_inverseQ).mod(_p)));
			}
			else if (publicOnly)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "keyNotExist"));
			else
				t = t.modPow(_d, _modulus);
	    	
			if (_useKeyBlinding)
				t = t.multiply(r.flame_internal::modInverse(_modulus)).mod(_modulus);
				
			return CryptoUtil.ensureLength(t.toByteArray(), _keySize >> 3);
	    }
	    
		/**
		 * Encrypts data with the RSA algorithm.
		 * 
		 * @param data The data to be encrypted.
		 * 
		 * @return The encrypted data.
		 * 
		 * @throws ArgumentError <code>data</code> parameter is <code>null</code>.
		 */
	    public function encrypt(data:ByteArray):ByteArray
	    {
			if (data == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "data" ]));
			
			if (!_isKeyParametersGenerated)
				generateKeyPair();
			
	    	return CryptoUtil.ensureLength(new BigInteger(data, true).flame_internal::modPowInt(_exponent, _modulus).toByteArray(), _keySize >> 3);
	    }
	    
		/**
		 * Exports the key used by the RSA object into an RSAParameters object.
		 * 
		 * @param includePrivateParameters <code>true</code> to include private parameters;
		 * otherwise, <code>false</code>.
		 * 
		 * @return The key pair for RSA.
		 * 
		 * @throws flame.crypto.CryptoError The key cannot be exported.
		 */
	    public function exportParameters(includePrivateParameters:Boolean):RSAParameters
	    {
			var length:int = _keySize >> 3;
	    	var parameters:RSAParameters = new RSAParameters();
			
			if (!_isKeyParametersGenerated)
				generateKeyPair();
			
	    	parameters.exponent = _exponent.toByteArray();
	    	parameters.modulus = CryptoUtil.ensureLength(_modulus.toByteArray(), length);
	    	
	    	if (includePrivateParameters)
	    	{
				if (publicOnly)
					throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeyState"));
				
				parameters.d = CryptoUtil.ensureLength(_d.toByteArray(), length);
				
				length >>= 1;
				
				if (_dP != null && _dQ != null && _inverseQ != null && _p != null && _q != null)
				{
					parameters.dP = CryptoUtil.ensureLength(_dP.toByteArray(), length);
			    	parameters.dQ = CryptoUtil.ensureLength(_dQ.toByteArray(), length);
			    	parameters.inverseQ = CryptoUtil.ensureLength(_inverseQ.toByteArray(), length);
			    	parameters.p = CryptoUtil.ensureLength(_p.toByteArray(), length);
			    	parameters.q = CryptoUtil.ensureLength(_q.toByteArray(), length);
				}
	    	}
	    	
	    	return parameters;
	    }
	    
		/**
		 * Initializes an RSA object from the key information from an XML string.
		 * <p>This method initializes an RSA object using key information in an XML string
		 * that was generated using the <code>toXMLString()</code> method.
		 * This method accepts either an XML string containing a public key or
		 * an XML string containing a public and private key.</p>
		 * <p>Use this method to conveniently initialize RSA key information.</p>
		 * <p><strong>Caution</strong><br />
		 * Persisting an XML string containing a private key to an insecure location is a security threat.
		 * The security of your application can be compromised if a malicious third party can access your private key.</p>
		 * 
		 * @param value The XML string containing RSA key information.
		 * 
		 * @throws ArgumentError <code>value</code> parameter is <code>null</code>.
		 * 
		 * @see flame.crypto.RSA#toXMLString() toXMLString()
		 */
	    public override function fromXMLString(value:String):void
	    {
	    	if (value == null)
	    		throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
	    	
	    	var parameters:RSAParameters = new RSAParameters();
	    	var xml:XML = new XML(value);
	    	
			if (xml.D.text().toString())
	    		parameters.d = Convert.fromBase64String(xml.D.text().toString());
			
			if (xml.DP.text().toString())
	    		parameters.dP = Convert.fromBase64String(xml.DP.text().toString());
	    	
			if (xml.DQ.text().toString())
				parameters.dQ = Convert.fromBase64String(xml.DQ.text().toString());
	    	
			if (xml.Exponent.text().toString())
				parameters.exponent = Convert.fromBase64String(xml.Exponent.text().toString());
	    	
			if (xml.InverseQ.text().toString())
				parameters.inverseQ = Convert.fromBase64String(xml.InverseQ.text().toString());
	    	
			if (xml.Modulus.text().toString())
				parameters.modulus = Convert.fromBase64String(xml.Modulus.text().toString());
	    	
			if (xml.P.text().toString())
				parameters.p = Convert.fromBase64String(xml.P.text().toString());
	    	
			if (xml.Q.text().toString())
				parameters.q = Convert.fromBase64String(xml.Q.text().toString());
	    	
	    	importParameters(parameters);
	    }
	    
		/**
		 * Imports the key from the the specified RSAParameters.
		 * 
		 * @param parameters The key pair for RSA.
		 * 
		 * @throws ArgumentError <code>parameters</code> parameter is <code>null</code>.
		 * 
		 * @throws flame.crypto.CryptoError The <code>parameters</code> parameter has missing fields.
		 */
	    public function importParameters(parameters:RSAParameters):void
	    {
	    	if (parameters == null)
	    		throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "parameters" ]));
	    	
			if (parameters.exponent == null)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeySize"));
			
			if (parameters.modulus == null)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeySize"));
			
			_exponent = new BigInteger(parameters.exponent, true);
			_modulus = new BigInteger(parameters.modulus, true);
			
			setKeySize(_modulus.flame_internal::bitLength);
			
			_d = parameters.d == null ? null : new BigInteger(parameters.d, true);
			_dP = parameters.dP == null ? null : new BigInteger(parameters.dP, true);
			_dQ = parameters.dQ == null ? null : new BigInteger(parameters.dQ, true);
			_inverseQ = parameters.inverseQ == null ? null : new BigInteger(parameters.inverseQ, true);
			_p = parameters.p == null ? null : new BigInteger(parameters.p, true);
			_q = parameters.q == null ? null : new BigInteger(parameters.q, true);
			_useCRT = _p != null && _q != null;
			
			_isKeyParametersGenerated = true;
			
			if (_useCRT)
			{
				if (!_modulus.equals(_p.multiply(_q)))
					throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeySize"));
				
				var p1:BigInteger = _p.subtract(BigInteger.ONE);
				var q1:BigInteger = _q.subtract(BigInteger.ONE);
				var p1q1:BigInteger = p1.multiply(q1);
				var d:BigInteger = _exponent.flame_internal::modInverse(p1q1);
				var dP:BigInteger = d.mod(p1);
				
				if (_dP == null)
					_dP = dP;
				else if (!_dP.equals(dP))
					throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeySize"));
				
				var dQ:BigInteger = d.mod(q1);
				
				if (_dQ == null)
					_dQ = dQ;
				else if (!_dQ.equals(dQ))
					throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeySize"));
				
				var inverseQ:BigInteger = _q.flame_internal::modInverse(_p);
				
				if (_inverseQ == null)
					_inverseQ = inverseQ;
				else if (!_inverseQ.equals(inverseQ))
					throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeySize"));
			}
	    }
	    
		/**
		 * Creates and returns an XML string containing the key of the current RSA object.
		 * <p>This method creates an XML string that contains either the public and private key
		 * of the current RSA object or contains only the public key of the current RSA object.</p>
		 * <p>Use this method whenever you need to conveniently persist RSA key information.
		 * To initialize an RSA object with the key in an XML string, use the <code>fromXMLString()</code> method.</p>
		 * <p><strong>Caution</strong><br />
		 * Persisting an XML string containing a private key to an insecure location is a security threat.
		 * The security of your application can be compromised if a malicious third party can access your private key.</p>
		 * <p>When you pass <code>true</code> to this method, the resulting XML string takes the following form:</p>
		 * <p><listing>
		 * &#60;RSAKeyValue&#62;
		 * 		&#60;Modulus&#62;...&#60;/Modulus&#62;
		 * 		&#60;Exponent&#62;...&#60;/Exponent&#62;
		 * 		&#60;P&#62;...&#60;/P&#62;
		 * 		&#60;Q&#62;...&#60;/Q&#62;
		 * 		&#60;DP&#62;...&#60;/DP&#62;
		 * 		&#60;DQ&#62;...&#60;/DQ&#62;
		 * 		&#60;InverseQ&#62;...&#60;/InverseQ&#62;
		 * 		&#60;D&#62;...&#60;/D&#62;
		 * &#60;/RSAKeyValue&#62;
		 * </listing>
		 * When you pass false to the ToXmlString method, the resulting XML string takes the following form:
		 * <listing>
		 * &#60;RSAKeyValue&#62;
		 * 		&#60;Modulus&#62;...&#60;/Modulus&#62;
		 * 		&#60;Exponent&#62;...&#60;/Exponent&#62;
		 * &#60;/RSAKeyValue&#62;
		 * </listing></p>
		 * 
		 * @param includePrivateParameters <code>true</code> to include a public and private RSA key;
		 * <code>false</code> to include only the public key.
		 * 
		 * @return An XML string containing the key of the current RSA object.
		 * 
		 * @see flame.crypto.RSA#fromXMLString() fromXMLString()
		 */
	    public override function toXMLString(includePrivateParameters:Boolean):String
	    {
			var parameters:RSAParameters = exportParameters(includePrivateParameters);
			
	    	var xml:XML =
				<RSAKeyValue>
					<Modulus>{Convert.toBase64String(parameters.modulus)}</Modulus>
	    			<Exponent>{Convert.toBase64String(parameters.exponent)}</Exponent>
				</RSAKeyValue>;
	    	
			if (includePrivateParameters)
			{
				if (parameters.p != null)
					xml.appendChild(<P>{Convert.toBase64String(parameters.p)}</P>);
				
				if (parameters.q != null)
					xml.appendChild(<Q>{Convert.toBase64String(parameters.q)}</Q>);
				
				if (parameters.dP != null)
					xml.appendChild(<DP>{Convert.toBase64String(parameters.dP)}</DP>);
				
				if (parameters.dQ != null)
					xml.appendChild(<DQ>{Convert.toBase64String(parameters.dQ)}</DQ>);
				
				if (parameters.inverseQ != null)
					xml.appendChild(<InverseQ>{Convert.toBase64String(parameters.inverseQ)}</InverseQ>);
				
				xml.appendChild(<D>{Convert.toBase64String(parameters.d)}</D>);
			}
			
	    	return xml.toXMLString();
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
	    	return _isKeyParametersGenerated && (_d == null || _modulus == null);
	    }
		
		/**
		 * Gets or sets a value that indicates whether to use key blinding.
		 * <p>Blinding techniques are used to prevent side channel attacks.
		 * Side channel attacks allow an adversary to recover information about the input to a cryptographic operation,
		 * by measuring, for example, timing information, power consumption, electromagnetic leaks, or even sound.</p>
		 */
		public function get useKeyBlinding():Boolean
		{
			return _useKeyBlinding;
		}
		
		/**
		 * @private
		 */
		public function set useKeyBlinding(value:Boolean):void
		{
			_useKeyBlinding = value;
		}
	    
	    //--------------------------------------------------------------------------
	    //
	    //  Private methods
	    //
	    //--------------------------------------------------------------------------
	    
	    private function generateKeyPair():void
	    {
	    	var p:BigInteger;
			var primeSize:int = _keySize >> 1;
			var primeSizeInBytes:int = primeSize >> 3;
			var q:BigInteger;
			
			do
			{
				p = new BigInteger(RandomNumberGenerator.getNonZeroBytes(primeSizeInBytes), true).flame_internal::findNextProbablePrime(primeSize);
			}
			while (p.flame_internal::bitLength != primeSize || !p.greatestCommonDivisor(_exponent).equals(BigInteger.ONE));
			
			while (true)
			{
		    	do
		    	{
		    		q = new BigInteger(RandomNumberGenerator.getNonZeroBytes(primeSizeInBytes), true).flame_internal::findNextProbablePrime(primeSize);
		    	}
				while (q.flame_internal::bitLength != primeSize || !q.greatestCommonDivisor(_exponent).equals(BigInteger.ONE));
			
				_modulus = p.multiply(q);
				
				if (_modulus.flame_internal::bitLength == _keySize && !p.equals(q))
					break;
				
				if (p.compareTo(q) < 0)
					p = q;
			}
			
			if (p.compareTo(q) < 0)
			{
				var t:BigInteger = p;
				p = q;
				q = t;
			}
	    	
	    	var p1:BigInteger = p.subtract(BigInteger.ONE);
	    	var q1:BigInteger = q.subtract(BigInteger.ONE);
	    	var p1q1:BigInteger = p1.multiply(q1);
	    	
    		_d = _exponent.flame_internal::modInverse(p1q1);
    		_dP = _d.mod(p1);
    		_dQ = _d.mod(q1);
    		_inverseQ = q.flame_internal::modInverse(p);
    		_p = p;
    		_q = q;
			
			_isKeyParametersGenerated = true;
			_useCRT = true;
	    }
		
		private function setKeySize(value:int):void
		{
			if (!validateKeySize(value))
				throw new CryptoError(_resourceManager.getString("flameCrypto", "invalidKeySize"));
			
			_keySize = value;
		}
	}
}