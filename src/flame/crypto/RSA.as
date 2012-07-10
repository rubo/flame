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
	import flame.utils.ByteArrayUtil;
	import flame.utils.Convert;
	
	import flash.utils.ByteArray;
	
	/**
	 * Performs asymmetric encryption and decryption using the RSA algorithm.
	 * This class cannot be inherited.
	 * <p>The RSA supports key lengths from 384 bits to 1024 bits in increments of 8 bits.</p>
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
		private var _modulus:BigInteger;
		private var _p:BigInteger;
		private var _q:BigInteger;
		
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the RSA class
		 * with the specified key size or key parameters.
		 * 
		 * @param keySize The size of the key to use in bits.
		 * 
		 * @param parameters The key parameters to be passed.
		 * 
		 * @throws flame.crypto.CryptoError <code>keySize</code> specifies an invalid length.
		 */
		public function RSA(keySize:int = 512, parameters:RSAParameters = null)
		{
			super();
			
			_legalKeySizes = new <KeySizes>[ new KeySizes(384, 1024, 8) ];
			_legalKeySizes.fixed = true;
			
			if (parameters == null)
			{
				setKeySize(keySize);
				
				generateKeyParameters();
			}
			else
				importParameters(parameters);
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
		 * @throws flame.crypto.CryptoError Thrown in the following situations:<ul>
		 * <li>The length of the <code>data</code> parameter is greater than <code>keySize</code>.</li>
		 * <li>The private key does not exist.</li>
		 * </ul>
		 */
	    public function decrypt(data:ByteArray):ByteArray
	    {
			if (data == null)
				throw new ArgumentError(_resourceManager.getString("flameLocale", "argNullGeneric", [ "data" ]));
			
			if (publicOnly)
				throw new CryptoError(_resourceManager.getString("flameLocale", "cryptoKeyNotExist"));
	    	
			ByteArrayUtil.insertByte(data, 0, 0);
			
    		var t:BigInteger = new BigInteger(data);
	    	var tP:BigInteger = t.mod(_p).modPow(_dP, _p);
	    	var tQ:BigInteger = t.mod(_q).modPow(_dQ, _q);
	    	
	    	for (; tP.compareTo(tQ) < 0; tP = tP.add(_p));
	    	
			return CryptoUtil.ensureLength(tP.subtract(tQ).multiply(_inverseQ).mod(_p).multiply(_q).add(tQ).toByteArray(), _keySize >> 3);
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
				throw new ArgumentError(_resourceManager.getString("flameLocale", "argNullGeneric", [ "data" ]));
			
			ByteArrayUtil.insertByte(data, 0, 0);
			
	    	return CryptoUtil.ensureLength(new BigInteger(data).flame_internal::modPowInt(_exponent, _modulus).toByteArray(), _keySize >> 3);
	    }
	    
		/**
		 * Exports the key used by the RSA object into an RSAParameters object.
		 * 
		 * @param includePrivateParameters <code>true</code> to include private parameters;
		 * otherwise, <code>false</code>.
		 * 
		 * @return The key parameters for RSA.
		 * 
		 * @throws flame.crypto.CryptoError The key cannot be exported.
		 */
	    public function exportParameters(includePrivateParameters:Boolean):RSAParameters
	    {
			var length:int = _keySize >> 3;
	    	var parameters:RSAParameters = new RSAParameters();
			
	    	parameters.exponent = _exponent.toByteArray();
	    	parameters.modulus = CryptoUtil.ensureLength(_modulus.toByteArray(), length);
	    	
	    	if (includePrivateParameters)
	    	{
				if (publicOnly)
					throw new CryptoError(_resourceManager.getString("flameLocale", "cryptoInvalidKeyState"));
				
				parameters.d = CryptoUtil.ensureLength(_d.toByteArray(), length);
				
				length >>= 1;
				
				parameters.dP = CryptoUtil.ensureLength(_dP.toByteArray(), length);
		    	parameters.dQ = CryptoUtil.ensureLength(_dQ.toByteArray(), length);
		    	parameters.inverseQ = CryptoUtil.ensureLength(_inverseQ.toByteArray(), length);
		    	parameters.p = CryptoUtil.ensureLength(_p.toByteArray(), length);
		    	parameters.q = CryptoUtil.ensureLength(_q.toByteArray(), length);
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
	    		throw new ArgumentError(_resourceManager.getString("flameLocale", "argNullGeneric", [ "value" ]));
	    	
	    	var paremeters:RSAParameters = new RSAParameters();
	    	var xml:XML = new XML(value);
	    	
			if (xml.D.text().toString())
	    		paremeters.d = Convert.fromBase64String(xml.D.text().toString());
			
			if (xml.DP.text().toString())
	    		paremeters.dP = Convert.fromBase64String(xml.DP.text().toString());
	    	
			if (xml.DQ.text().toString())
				paremeters.dQ = Convert.fromBase64String(xml.DQ.text().toString());
	    	
			if (xml.Exponent.text().toString())
				paremeters.exponent = Convert.fromBase64String(xml.Exponent.text().toString());
	    	
			if (xml.InverseQ.text().toString())
				paremeters.inverseQ = Convert.fromBase64String(xml.InverseQ.text().toString());
	    	
			if (xml.Modulus.text().toString())
				paremeters.modulus = Convert.fromBase64String(xml.Modulus.text().toString());
	    	
			if (xml.P.text().toString())
				paremeters.p = Convert.fromBase64String(xml.P.text().toString());
	    	
			if (xml.Q.text().toString())
				paremeters.q = Convert.fromBase64String(xml.Q.text().toString());
	    	
	    	importParameters(paremeters);
	    }
	    
		/**
		 * Imports the key from the the specified RSAParameters.
		 * 
		 * @param parameters The key parameters for RSA.
		 * 
		 * @throws ArgumentError <code>parameters</code> parameter is <code>null</code>.
		 * 
		 * @throws flame.crypto.CryptoError The <code>parameters</code> parameter has missing fields.
		 */
	    public function importParameters(parameters:RSAParameters):void
	    {
	    	if (parameters == null)
	    		throw new ArgumentError(_resourceManager.getString("flameLocale", "argNullGeneric", [ "parameters" ]));
	    	
			if (parameters.exponent == null)
				throw new CryptoError(_resourceManager.getString("flameLocale", "cryptoInvalidKeySize"));
			
			if (parameters.modulus == null)
				throw new CryptoError(_resourceManager.getString("flameLocale", "cryptoInvalidKeySize"));
			
			var buffer:ByteArray = new ByteArray();
			
			buffer.writeByte(0);
			buffer.writeBytes(parameters.exponent);
			
			_exponent = new BigInteger(buffer);
			
			buffer.clear();
			
			buffer.writeByte(0);
			buffer.writeBytes(parameters.modulus);
			
			_modulus = new BigInteger(buffer);
			
			setKeySize(_modulus.flame_internal::bitLength);
			
			if (parameters.d == null)
				_d = null;
			else
			{
				buffer.clear();
			
				buffer.writeByte(0);
				buffer.writeBytes(parameters.d);
				
				_d = new BigInteger(buffer);
			}
			
			if (parameters.dP == null)
				_dP == null;
			else
			{
				buffer.clear();
				
				buffer.writeByte(0);
				buffer.writeBytes(parameters.dP);
				
				_dP = new BigInteger(buffer);
			}
			
			if (parameters.dQ == null)
				_dQ == null;
			else
			{
				buffer.clear();
				
				buffer.writeByte(0);
				buffer.writeBytes(parameters.dQ);
				
				_dQ = new BigInteger(buffer);
			}
			
			if (parameters.inverseQ == null)
				_inverseQ = null;
			else
			{
				buffer.clear();
				
				buffer.writeByte(0);
				buffer.writeBytes(parameters.inverseQ);
				
				_inverseQ = new BigInteger(buffer);
			}
			
			if (parameters.p == null || parameters.q == null)
				_p = _q = null;
			else
			{
				buffer.clear();
				
				buffer.writeByte(0);
				buffer.writeBytes(parameters.p);
				
				_p = new BigInteger(buffer);
			}
			
			if (_p != null)
			{
				buffer.clear();
				
				buffer.writeByte(0);
				buffer.writeBytes(parameters.q);
				
				_q = new BigInteger(buffer);
			}
			
			if (_p != null && _q != null)
			{
				if (!_modulus.equals(_p.multiply(_q)))
					throw new CryptoError(_resourceManager.getString("flameLocale", "cryptoInvalidKeySize"));
				
				var pp:BigInteger = _p.subtract(BigInteger.ONE);
				var qq:BigInteger = _q.subtract(BigInteger.ONE);
				var pq:BigInteger = pp.multiply(qq);
				
				var d:BigInteger = _exponent.flame_internal::modInverse(pq);
				
				if (_d == null)
					_d = d;
				else if (!_d.equals(d))
					throw new CryptoError(_resourceManager.getString("flameLocale", "cryptoInvalidKeySize"));
				
				var dP:BigInteger = d.mod(pp);
				
				if (_dP == null)
					_dP = dP;
				else if (!_d.equals(d))
					throw new CryptoError(_resourceManager.getString("flameLocale", "cryptoInvalidKeySize"));
				
				var dQ:BigInteger = d.mod(qq);
				
				if (_dQ == null)
					_dQ = dQ;
				else if (!_dQ.equals(dQ))
					throw new CryptoError(_resourceManager.getString("flameLocale", "cryptoInvalidKeySize"));
				
				var inverseQ:BigInteger = _q.flame_internal::modInverse(_p);
				
				if (_inverseQ == null)
					_inverseQ = inverseQ;
				else if (!_inverseQ.equals(inverseQ))
					throw new CryptoError(_resourceManager.getString("flameLocale", "cryptoInvalidKeySize"));
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
				xml.appendChild(<P>{Convert.toBase64String(parameters.p)}</P>);
				xml.appendChild(<Q>{Convert.toBase64String(parameters.q)}</Q>);
				xml.appendChild(<DP>{Convert.toBase64String(parameters.dP)}</DP>);
				xml.appendChild(<DQ>{Convert.toBase64String(parameters.dQ)}</DQ>);
				xml.appendChild(<InverseQ>{Convert.toBase64String(parameters.inverseQ)}</InverseQ>);
				xml.appendChild(<D>{Convert.toBase64String(parameters.d)}</D>);
			}
			
	    	return xml.toXMLString();
	    }
	    
	    //--------------------------------------------------------------------------
	    //
	    //  Public proeprties
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
	    	return _p == null || _q == null;
	    }
	    
	    //--------------------------------------------------------------------------
	    //
	    //  Private methods
	    //
	    //--------------------------------------------------------------------------
	    
	    private function generateKeyParameters():void
	    {
	    	var p:BigInteger;
			var primeSize:int = _keySize >> 1;
			var primeSizeinBytes:int = primeSize >> 3;
			var q:BigInteger;
			var rgb:ByteArray;
			
			do
			{
		    	do
		    	{
					rgb = RandomNumberGenerator.getNonZeroBytes(primeSizeinBytes);
					
					ByteArrayUtil.insertByte(rgb, 0, 0);
					
		    		p = new BigInteger(rgb).flame_internal::findNextProbablePrime(primeSize);
		    	}
				while (p.flame_internal::bitLength != primeSize || p.greatestCommonDivisor(_exponent).compareTo(BigInteger.ONE) != 0);
		    	
		    	do
		    	{
					rgb = RandomNumberGenerator.getNonZeroBytes(primeSizeinBytes);
					
					ByteArrayUtil.insertByte(rgb, 0, 0);
					
		    		q = new BigInteger(rgb).flame_internal::findNextProbablePrime(primeSize);
		    	}
				while (q.flame_internal::bitLength != primeSize || q.greatestCommonDivisor(_exponent).compareTo(BigInteger.ONE) != 0);
			
				_modulus = p.multiply(q);
			}
			while (_modulus.flame_internal::bitLength != _keySize);
			
			if (p.compareTo(q) < 0)
			{
				var t:BigInteger = p;
				p = q;
				q = t;
			}
	    	
	    	var pp:BigInteger = p.subtract(BigInteger.ONE);
	    	var qq:BigInteger = q.subtract(BigInteger.ONE);
	    	var pq:BigInteger = pp.multiply(qq);
	    	
    		_d = _exponent.flame_internal::modInverse(pq);
    		_dP = _d.mod(pp);
    		_dQ = _d.mod(qq);
    		_inverseQ = q.flame_internal::modInverse(p);
    		_p = p;
    		_q = q;
	    }
		
		private function setKeySize(value:int):void
		{
			if (!validateKeySize(value))
				throw new CryptoError(_resourceManager.getString("flameLocale", "cryptoInvalidKeySize"));
			
			_keySize = value;
		}
	}
}