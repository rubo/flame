////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.tests.crypto
{
	import flame.crypto.SHA224;
	
	import flash.utils.ByteArray;

	[TestCase(order=4)]
	public final class SHA224Test extends HashAlgorithmTest
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function SHA224Test()
		{
			super();
			
			_hashAlgorithm = new SHA224();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		[Test]
		public function testComputeHash1():void
		{
			computeHashAndTest(new ByteArray(), "D14A028C2A3A2BC9476102BB288234C415A2B01F828EA62AC5B3E42F");
		}
		
		[Test]
		public function testComputeHash2():void
		{
			var data:ByteArray = new ByteArray();
			
			data.writeUTFBytes("abc");
			
			computeHashAndTest(data, "23097D223405D8228642A477BDA255B32AADBCE4BDA0B3F7E36C9DA7");
		}
		
		[Test]
		public function testComputeHash3():void
		{
			var data:ByteArray = new ByteArray();
			
			data.writeUTFBytes("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq");
			
			computeHashAndTest(data, "75388B16512776CC5DBA5DA1FD890150B0C6455CB4F58B1952522525");
		}
		
		[Test]
		public function testTransformBlock():void
		{
			var data:ByteArray = new ByteArray();
			
			data.writeUTFBytes("The quick brown fox jumps over the lazy dog");
			
			transformBlockAndTest(data, "730E109BD7A8A32B1CB9D9A09AA2325D2430587DDBC0C38BAD911525");
		}
	}
}