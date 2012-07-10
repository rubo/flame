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
	 * Computes a Hash-based Message Authentication Code (HMAC) using the RIPEMD-160 hash function.
	 * This class cannot be inherited.
	 * <p>HMAC-RIPEMD-160 is a type of keyed hash algorithm that is constructed from the
	 * RIPEMD-160 hash function and used as a Hash-based Message Authentication Code (HMAC).
	 * The HMAC process mixes a secret key with the message data, hashes the result with the hash function,
	 * mixes that hash value with the secret key again, and then applies the hash function a second time.
	 * The output hash is 160 bits in length.</p>
	 * <p>An HMAC can be used to determine whether a message sent over an insecure channel
	 * has been tampered with, provided that the sender and receiver share a secret key.
	 * The sender computes the hash value for the original data and sends both the original data
	 * and hash value as a single message. The receiver recalculates the hash value
	 * on the received message and checks that the computed HMAC matches the transmitted HMAC.</p>
	 * <p>Any change to the data or the hash value will result in a mismatch,
	 * because knowledge of the secret key is required to change the message
	 * and reproduce the correct hash value. Therefore, if the original and computed hash values match,
	 * the message is authenticated.</p>
	 * <p>HMAC-RIPEMD-160 accepts keys of any size, and produces a hash sequence that is 160 bits long.</p>
	 * <p>The RIPEMD hash algorithm and its successors were developed by the European RIPE project.
	 * The original RIPEMD algorithm was designed to replace MD4 and MD5 and was later strengthened
	 * and renamed RIPEMD-160. The RIPEMD-160 hash algorithm produces a 160-bit hash value.
	 * The algorithm's designers have placed it in the public domain.</p>
	 */
	public final class HMACRIPEMD160 extends HMAC
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the HMACRIPEMD160 class.
		 * 
		 * @param key The secret key for HMAC-RIPEMD-160 encryption. The key can be any length,
		 * but if it is more than 64 bytes long it will be hashed (using RIPEMD-160) to derive a 64-byte key.
		 * Therefore, the recommended size of the secret key is 64 bytes.
		 */
		public function HMACRIPEMD160(key:ByteArray = null)
		{
			blockSize = 64;
			
			setHashAlgorithm("RIPEMD160");
			
			super.key = key || RandomNumberGenerator.getBytes(blockSize);
		}
	}
}