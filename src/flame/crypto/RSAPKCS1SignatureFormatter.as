////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto
{
	import flame.crypto.asn1.ASN1ObjectIdentifier;
	import flame.utils.ByteArrayUtil;
	
	import flash.utils.ByteArray;

	/**
	 * Creates an RSA PKCS #1 version 1.5 signature.
	 * <p>This class is used to create a digital signature using the RSA algorithm.
	 * Use RSAPKCS1SignatureDeformatter to verify digital signatures with the RSA algorithm.</p>
	 * 
	 * @see flame.crypto.RSAPKCS1SignatureDeformatter
	 */
	public class RSAPKCS1SignatureFormatter extends AsymmetricSignatureFormatter
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private var _key:RSA;
		private var _oid:String;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the RSAPKCS1SignatureFormatter class.
		 * 
		 * @param key The instance of the RSA algorithm that holds the private key.
		 */
		public function RSAPKCS1SignatureFormatter(key:AsymmetricAlgorithm)
		{
			super();
			
			if (key != null)
				setKey(key);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Creates the RSA PKCS #1 signature for the specified data.
		 * <p>You must specify a key and a hash algorithm before calling this method.</p>
		 * 
		 * @param hash The data to be signed.
		 * 
		 * @return The digital signature for <code>hash</code>.
		 * 
		 * @throws flame.crypto.CryptoError Thrown in the following situations:<ul>
		 * <li>The private key is missing.</li>
		 * <li>The hash algorithm is missing.</li>
		 * </ul>
		 * 
		 *  @throws ArgumentError <code>hash</code> parameter is <code>null</code>.
		 */
		public override function createSignature(hash:ByteArray):ByteArray
		{
			if (_key == null)
				throw new CryptoError(_resourceManager.getString("flameLocale", "cryptoMissingKey"));
			
			if (_oid == null)
				throw new CryptoError(_resourceManager.getString("flameLocale", "cryptoMissingOID"));
			
			if (hash == null)
				throw new ArgumentError(_resourceManager.getString("flameLocale", "argNullGeneric", [ "hash" ]));
			
			var modulusSize:int = _key.keySize >> 3;
			var buffer:ByteArray = new ByteArray();
			var encodedOID:ByteArray = new ASN1ObjectIdentifier(_oid).toByteArray();

			buffer.writeByte(0);
			buffer.writeByte(1);
			buffer.writeBytes(ByteArrayUtil.repeat(255, modulusSize - encodedOID.length - hash.length - 11));
			buffer.writeByte(0);
			buffer.writeByte(48);
			buffer.writeByte(encodedOID.length + hash.length + 6);
			buffer.writeByte(48);
			buffer.writeByte(encodedOID.length + 2);
			buffer.writeBytes(encodedOID);
			buffer.writeByte(5);
			buffer.writeByte(0);
			buffer.writeByte(4);
			buffer.writeByte(hash.length);
			buffer.writeBytes(hash);
			
			return _key.decrypt(buffer);
		}
		
		/**
		 * Sets the hash algorithm to use for creating the signature.
		 * <p>You must set the hash algorithm before calling the <code>createSignature()</code> method.</p>
		 * 
		 * @param name The name of the hash algorithm to use for creating the signature.
		 */
		public override function setHashAlgorithm(name:String):void
		{
			_oid = CryptoConfig.mapNameToOID(name);
		}
		
		/**
		 * Sets the private key to use for creating the signature.
		 * <p>You must set the key before calling the <code>createSignature()</code> method.</p>
		 * 
		 * @param key The instance of the RSA algorithm that holds the public key.
		 * 
		 * @throws ArgumentError <code>key</code> parameter is <code>null</code>.
		 * 
		 * @see flame.crypto.RSA
		 */
		public override function setKey(key:AsymmetricAlgorithm):void
		{
			if (key == null)
				throw new ArgumentError(_resourceManager.getString("flameLocale", "argNullGeneric", [ "key" ]));
			
			_key = RSA(key);
		}
	}
}