////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.tests.crypto
{
	import flame.crypto.SHA1;
	
	import flash.utils.ByteArray;

	[TestCase(order=3)]
	public final class SHA1Test extends HashAlgorithmTest
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function SHA1Test()
		{
			super();
			
			_hashAlgorithm = new SHA1();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		[Test]
		public function testComputeHash1():void
		{
			computeHashAndTest(new ByteArray(), "DA39A3EE5E6B4B0D3255BFEF95601890AFD80709");
		}
		
		[Test]
		public function testComputeHash2():void
		{
			var data:ByteArray = new ByteArray();
			
			data.writeUTFBytes("abc");
			
			computeHashAndTest(data, "A9993E364706816ABA3E25717850C26C9CD0D89D");
		}
		
		[Test]
		public function testComputeHash3():void
		{
			var data:ByteArray = new ByteArray();
			
			data.writeUTFBytes("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq");
			
			computeHashAndTest(data, "84983E441C3BD26EBAAE4AA1F95129E5E54670F1");
		}
		
		[Test]
		public function testTransformBlock():void
		{
			var data:ByteArray = new ByteArray();
			
			data.writeUTFBytes("The quick brown fox jumps over the lazy dog");
			
			transformBlockAndTest(data, "2FD4E1C67A2D28FCED849EE1BB76E7391B93EB12");
		}
	}
}