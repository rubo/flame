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
	 * Computes a Hash-based Message Authentication Code (HMAC) using the MD5 hash function.
	 * This class cannot be inherited.
	 * <p>HMAC-MD5 is a type of keyed hash algorithm that is constructed from the MD5 hash function
	 * and used as a Hash-based Message Authentication Code (HMAC).
	 * The HMAC process mixes a secret key with the message data, hashes the result with the hash function,
	 * mixes that hash value with the secret key again, then applies the hash function a second time.
	 * The output hash will be 128 bits in length.</p>
	 * <p>An HMAC can be used to determine whether a message sent over an insecure channel
	 * has been tampered with, provided that the sender and receiver share a secret key.
	 * The sender computes the hash value for the original data and sends both the original data
	 * and hash value as a single message. The receiver recalculates the hash value
	 * on the received message and checks that the computed HMAC matches the transmitted HMAC.</p>
	 * <p>Any change to the data or the hash value will result in a mismatch,
	 * because knowledge of the secret key is required to change the message
	 * and reproduce the correct hash value. Therefore, if the original and computed hash values match,
	 * the message is authenticated.</p>
	 * <p>MD5 (Message Digest Algorithm 5) is a cryptographic hash algorithm developed at RSA Laboratories.
	 * HMAC-MD5 accepts keys of any size, and produces a hash sequence 128 bits in length.</p>
	 */
	public final class HMACMD5 extends HMAC
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the HMACMD5 class.
		 * 
		 * @param key The secret key for HMAC-MD5 encryption. The key can be any length,
		 * but if it is more than 64 bytes long it will be hashed (using MD5) to derive a 64-byte key.
		 * Therefore, the recommended size of the secret key is 64 bytes.
		 */	
		public function HMACMD5(key:ByteArray = null)
		{
			blockSize = 64;
			
			setHashAlgorithm("MD5");
			
			super.key = key || RandomNumberGenerator.getBytes(blockSize);
		}
	}
}