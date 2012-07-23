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
	 * Verifies an RSA PKCS #1 version 1.5 signature.
	 * <p>This class is used to verify a digital signature made with the RSA algorithm.
	 * Use RSAPKCS1SignatureFormatter to create digital signatures with the RSA algorithm.</p>
	 * 
	 * @see flame.crypto.RSAPKCS1SignatureFormatter
	 */
	public class RSAPKCS1SignatureDeformatter extends AsymmetricSignatureDeformatter
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
		 * Initializes a new instance of the RSAPKCS1SignatureDeformatter class.
		 * 
		 * @param key The instance of the RSA algorithm that holds the public key.
		 */
		public function RSAPKCS1SignatureDeformatter(key:AsymmetricAlgorithm)
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
		 * Verifies the RSA PKCS#1 signature for the specified data.
		 * 
		 * @param hash The data signed with <code>signature</code>.
		 * 
		 * @param signature The signature to be verified for <code>hash</code>.
		 * 
		 * @return <code>true</code> if <code>signature</code> matches the signature
		 * computed using the specified hash algorithm and key on <code>hash</code>; otherwise, <code>false</code>.
		 * 
		 * @throws flame.crypto.CryptoError Thrown in the following situations:<ul>
		 * <li>The private key is missing.</li>
		 * <li>The hash algorithm is missing.</li>
		 * </ul>
		 * 
		 * @throws ArgumentError Thrown in the following situations:<ul>
		 * <li><code>hash</code> parameter is <code>null</code>.</li>
		 * <li><code>signature</code> parameter is <code>null</code>.</li>
		 * </ul>
		 */
		public override function verifySignature(hash:ByteArray, signature:ByteArray):Boolean
		{
			if (_key == null)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "missingKey"));
			
			if (_oid == null)
				throw new CryptoError(_resourceManager.getString("flameCrypto", "missingOID"));
			
			if (hash == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "hash" ]));
			
			if (signature == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "signature" ]));
			
			var buffer:ByteArray = new ByteArray();
			var encodedOID:ByteArray = new ASN1ObjectIdentifier(_oid).toByteArray();
			var modulusSize:int = _key.keySize >> 3;
			
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
			
			var temp:ByteArray = _key.encrypt(signature);
			
			if (buffer.length != temp.length)
				return false;
			
			for (var i:int = 0, count:int = buffer.length; i < count; i++)
				if (buffer[i] != temp[i])
					return false;
			
			return true;
		}
		
		/**
		 * Sets the hash algorithm to use for verifying the signature.
		 * <p>You must set the hash algorithm before calling the <code>verifySignature()</code> method.</p>
		 * 
		 * @param name The name of the hash algorithm to use for verifying the signature.
		 */
		public override function setHashAlgorithm(name:String):void
		{
			_oid = CryptoConfig.mapNameToOID(name);
		}
		
		/**
		 * Sets the public key to use for verifying the signature.
		 * <p>You must set the key before calling the <code>verifySignature()</code> method.</p>
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