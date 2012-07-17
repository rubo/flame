////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.tests.crypto
{
	import flame.crypto.HMAC;
	import flame.utils.ByteArrayUtil;
	
	import flash.utils.ByteArray;

	[TestCase(order=8)]
	public final class HMACTest extends HashAlgorithmTest
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function HMACTest()
		{
			super();
			
			_hashAlgorithm = HMAC.create("HMACMD5");
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		[Test]
		public function testComputeHash1():void
		{
			var data:ByteArray = new ByteArray();
			
			data.writeUTFBytes("Hi There");
			
			HMAC(_hashAlgorithm).key = ByteArrayUtil.fromHexString("0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B0B");
			
			computeHashAndTest(data, "9294727A3638BB1C13F48EF8158BFC9D");
		}
		
		[Test]
		public function testComputeHash2():void
		{
			var data:ByteArray = new ByteArray();
			var key:ByteArray = new ByteArray();
			
			data.writeUTFBytes("what do ya want for nothing?");
			
			key.writeUTFBytes("Jefe");
			
			HMAC(_hashAlgorithm).key = key;
			
			computeHashAndTest(data, "750C783E6AB0B503EAA86E310A5DB738");
		}
		
		[Test]
		public function testComputeHash3():void
		{
			HMAC(_hashAlgorithm).key = ByteArrayUtil.fromHexString("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
			
			computeHashAndTest(ByteArrayUtil.fromHexString("DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD"),
				"56BE34521D144C88DBB8C733F0E8B3F6");
		}
		
		[Test]
		public function testTransformBlock():void
		{
			HMAC(_hashAlgorithm).key = ByteArrayUtil.fromHexString("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
			
			transformBlockAndTest(ByteArrayUtil.fromHexString("DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD"),
				"56BE34521D144C88DBB8C733F0E8B3F6");
		}
	}
}