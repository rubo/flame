////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.tests.crypto
{
	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public final class CryptoSuite
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		public var aesTest:AESTest;
		public var hmacTest:HMACTest;
		public var md5Test:MD5Test;
		public var ripemd160Test:RIPEMD160Test;
		public var sha1Test:SHA1Test;
		public var sha224Test:SHA224Test;
		public var sha256Test:SHA256Test;
		public var sha384Test:SHA384Test;
		public var sha512Test:SHA512Test;
	}
}