////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto
{
	/**
	 * Specifies the type of padding to apply when the message data block is shorter
	 * than the full number of bytes needed for a cryptographic operation.
	 * <p>Most plain text messages do not consist of a number of bytes that completely fill blocks.
	 * Often, there are not enough bytes to fill the last block.
	 * When this happens, a padding string is added to the text.
	 * For example, if the block length is 64 bits and the last block contains only 40 bits,
	 * 24 bits of padding are added.</p>
	 * <p>Some encryption standards specify a particular padding scheme.
	 * The following example shows how these modes work.
	 * Given a blocklength of 8, a data length of 9, the number of padding octets equal to 7,
	 * and the data equal to FF FF FF FF FF FF FF FF FF:</p>
	 * <p>Data: FF FF FF FF FF FF FF FF FF</p>
	 * <p>X923 padding: FF FF FF FF FF FF FF FF FF 00 00 00 00 00 00 07</p>
	 * <p>PKCS7 padding: FF FF FF FF FF FF FF FF FF 07 07 07 07 07 07 07</p>
	 * <p>ISO10126 padding: FF FF FF FF FF FF FF FF FF 7D 2A 75 EF F8 EF 07</p>
	 */
	public final class PaddingMode
	{
		/**
		 * No padding is done. 
		 */
		public static const NONE:uint = 1;
		
		/**
		 * The PKCS #7 padding string consists of a sequence of bytes,
		 * each of which is equal to the total number of padding bytes added.
		 * <p>The following example shows how these modes work.
		 * Given a blocklength of 8, a data length of 9, the number of padding octets equal to 7,
		 * and the data equal to FF FF FF FF FF FF FF FF FF:</p>
		 * <p>Data: FF FF FF FF FF FF FF FF FF</p>
		 * <p>PKCS7 padding: FF FF FF FF FF FF FF FF FF 07 07 07 07 07 07 07</p>
		 */
		public static const PKCS7:uint = 2;
		
		/**
		 * The padding string consists of bytes set to zero. 
		 */
		public static const ZEROS:uint = 3;
		
		/**
		 * The ANSIX923 padding string consists of a sequence of bytes filled with zeros before the length.
		 * <p>The following example shows how this mode works.
		 * Given a blocklength of 8, a data length of 9, the number of padding octets equal to 7,
		 * and the data equal to FF FF FF FF FF FF FF FF FF:</p>
		 * <p>Data: FF FF FF FF FF FF FF FF FF</p>
		 * <p>X923 padding: FF FF FF FF FF FF FF FF FF 00 00 00 00 00 00 07</p>
		 */
		public static const ANSIX923:uint = 4;
		
		/**
		 * The ISO10126 padding string consists of random data before the length.
		 * <p>The following example shows how this mode works.
		 * Given a blocklength of 8, a data length of 9, the number of padding octets equal to 7,
		 * and the data equal to FF FF FF FF FF FF FF FF FF:</p>
		 * <p>Data: FF FF FF FF FF FF FF FF FF</p>
		 * <p>ISO10126 padding: FF FF FF FF FF FF FF FF FF 7D 2A 75 EF F8 EF 07</p> 
		 */
		public static const ISO10126:uint = 5;
	}
}