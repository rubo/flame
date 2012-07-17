////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.tests.crypto
{
	import flame.crypto.RIPEMD160;
	
	import flash.utils.ByteArray;

	[TestCase(order=2)]
	public final class RIPEMD160Test extends HashAlgorithmTest
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function RIPEMD160Test()
		{
			super();
			
			_hashAlgorithm = new RIPEMD160();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		[Test]
		public function testComputeHash1():void
		{
			computeHashAndTest(new ByteArray(), "9C1185A5C5E9FC54612808977EE8F548B2258D31");
		}
		
		[Test]
		public function testComputeHash2():void
		{
			var data:ByteArray = new ByteArray();
			
			data.writeUTFBytes("abc");
			
			computeHashAndTest(data, "8EB208F7E05D987A9B044A8E98C6B087F15A0BFC");
		}
		
		[Test]
		public function testComputeHash3():void
		{
			var data:ByteArray = new ByteArray();
			
			data.writeUTFBytes("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789");
			
			computeHashAndTest(data, "B0E20B6E3116640286ED3A87A5713079B21F5189");
		}
		
		[Test]
		public function testTransformBlock():void
		{
			var data:ByteArray = new ByteArray();
			
			data.writeUTFBytes("12345678901234567890123456789012345678901234567890123456789012345678901234567890");
			
			transformBlockAndTest(data, "9B752E45573D4B39F4DBD3323CAB82BF63326BFB");
		}
	}
}