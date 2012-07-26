////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto
{
	import flame.crypto.asn1.ASN1Null;
	import flame.crypto.asn1.ASN1Object;
	import flame.crypto.asn1.ASN1ObjectIdentifier;
	import flame.crypto.asn1.ASN1OctetString;
	import flame.crypto.asn1.ASN1Sequence;
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
		 * Creates the RSA PKCS #1 signature for the specified hash.
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
		 * @throws ArgumentError <code>hash</code> parameter is <code>null</code>.
		 */
		public override function createSignature(hash:ByteArray):ByteArray
		{
			if (_key == null)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "missingKey"));
			
			if (_oid == null)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "missingHashAlgorithm"));
			
			if (hash == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "hash" ]));
			
			var modulusSize:int = _key.keySize >> 3;
			var sequence:ASN1Sequence = new ASN1Sequence();
			
			sequence.addElement(new ASN1Sequence(new <ASN1Object>[ new ASN1ObjectIdentifier(_oid), ASN1Null.NULL ]));
			sequence.addElement(new ASN1OctetString(hash));
			
			var digestData:ByteArray = sequence.toByteArray();
			
			if (digestData.length + 3 > modulusSize)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "paddingSignatureHashTooLong", [ modulusSize ]));
			
			var buffer:ByteArray = new ByteArray();
			
			buffer.writeByte(0);
			buffer.writeByte(1);
			buffer.writeBytes(ByteArrayUtil.repeat(255, modulusSize - digestData.length - 3));
			buffer.writeByte(0);
			buffer.writeBytes(digestData);
			
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
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "key" ]));
			
			_key = RSA(key);
		}
	}
}