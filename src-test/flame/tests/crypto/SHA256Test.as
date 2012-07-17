////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.tests.crypto
{
	import flame.crypto.SHA256;
	
	import flash.utils.ByteArray;

	[TestCase(order=5)]
	public final class SHA256Test extends HashAlgorithmTest
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function SHA256Test()
		{
			super();
			
			_hashAlgorithm = new SHA256();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		[Test]
		public function testComputeHash1():void
		{
			computeHashAndTest(new ByteArray(), "E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649B934CA495991B7852B855");
		}
		
		[Test]
		public function testComputeHash2():void
		{
			var data:ByteArray = new ByteArray();
			
			data.writeUTFBytes("abc");
			
			computeHashAndTest(data, "BA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD");
		}
		
		[Test]
		public function testComputeHash3():void
		{
			var data:ByteArray = new ByteArray();
			
			data.writeUTFBytes("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq");
			
			computeHashAndTest(data, "248D6A61D20638B8E5C026930C3E6039A33CE45964FF2167F6ECEDD419DB06C1");
		}
		
		[Test]
		public function testTransformBlock():void
		{
			var data:ByteArray = new ByteArray();
			
			data.writeUTFBytes("The quick brown fox jumps over the lazy dog");
			
			transformBlockAndTest(data, "D7A8FBB307D7809469CA9ABCB0082E4F8D5651E46D3CDB762D02D0BF37C9E592");
		}
	}
}