////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.tests.crypto
{
	import flame.crypto.SHA384;
	
	import flash.utils.ByteArray;

	[TestCase(order=6)]
	public final class SHA384Test extends HashAlgorithmTest
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function SHA384Test()
		{
			super();
			
			_hashAlgorithm = new SHA384();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		[Test(order=1)]
		public function testComputeHash1():void
		{
			computeHashAndTest(new ByteArray(), "38B060A751AC96384CD9327EB1B1E36A21FDB71114BE07434C0CC7BF63F6E1DA274EDEBFE76F65FBD51AD2F14898B95B");
		}
		
		[Test(order=2)]
		public function testComputeHash2():void
		{
			var data:ByteArray = new ByteArray();
			
			data.writeUTFBytes("abc");
			
			computeHashAndTest(data, "CB00753F45A35E8BB5A03D699AC65007272C32AB0EDED1631A8B605A43FF5BED8086072BA1E7CC2358BAECA134C825A7");
		}
		
		[Test(order=3)]
		public function testComputeHash3():void
		{
			var data:ByteArray = new ByteArray();
			
			data.writeUTFBytes("abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq");
			
			computeHashAndTest(data, "3391FDDDFC8DC7393707A65B1B4709397CF8B1D162AF05ABFE8F450DE5F36BC6B0455A8520BC4E6F5FE95B1FE3C8452B");
		}
		
		[Test(order=4)]
		public function testTransformBlock():void
		{
			var data:ByteArray = new ByteArray();
			
			data.writeUTFBytes("The quick brown fox jumps over the lazy dog");
			
			transformBlockAndTest(data, "CA737F1014A48F4C0B6DD43CB177B0AFD9E5169367544C494011E3317DBF9A509CB1E5DC1E85A941BBEE3D7F2AFBC9B1");
		}
	}
}