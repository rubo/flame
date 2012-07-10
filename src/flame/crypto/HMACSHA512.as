////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto
{
	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;
	
	/**
	 * Computes a Hash-based Message Authentication Code (HMAC) using the SHA-512 hash function.
	 * This class cannot be inherited.
	 * <p>HMAC-SHA-512 is a type of keyed hash algorithm that is constructed from the SHA-512 hash function
	 * and used as a Hash-based Message Authentication Code (HMAC).
	 * The HMAC process mixes a secret key with the message data and hashes the result.
	 * The hash value is mixed with the secret key again, and then hashed a second time.
	 * The output hash is 512 bits long.</p>
	 * <p>An HMAC can be used to determine whether a message sent over a nonsecure channel
	 * has been tampered with, provided that the sender and receiver share a secret key.
	 * The sender computes the hash value for the original data and sends both the original data
	 * and the hash value as a single message. The receiver recalculates the hash value
	 * on the received message and checks that the computed HMAC matches the transmitted HMAC.</p>
	 * <p>If the original and computed hash values match, the message is authenticated.
	 * If they do not match, either the data or the hash value has been changed.
	 * HMACs provide security against tampering because knowledge of the secret key is required
	 * to change the message and reproduce the correct hash value.</p>
	 * <p>HMAC-SHA-512 accepts all key sizes and produces a hash sequence that is 512 bits long.</p>
	 */
	public final class HMACSHA512 extends HMAC
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the HMACSHA512 class.
		 * 
		 * @param key The secret key for HMAC-SHA-512 encryption. The key can be any length,
		 * but if it is more than 128 bytes long it will be hashed (using SHA-512) to derive a 128-byte key.
		 * Therefore, the recommended size of the secret key is 128 bytes.
		 */
		public function HMACSHA512(key:ByteArray = null)
		{
			blockSize = 128;
			
			setHashAlgorithm("SHA512");
			
			super.key = key || RandomNumberGenerator.getBytes(blockSize);
		}
	}
}