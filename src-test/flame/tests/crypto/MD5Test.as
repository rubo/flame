////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.tests.crypto
{
	import flame.crypto.MD5;
	
	import flash.utils.ByteArray;

	[TestCase(order=1)]
	public final class MD5Test extends HashAlgorithmTest
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function MD5Test()
		{
			super();
			
			_hashAlgorithm = new MD5();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		[Test]
		public function testComputeHash1():void
		{
			computeHashAndTest(new ByteArray(), "D41D8CD98F00B204E9800998ECF8427E");
		}
		
		[Test]
		public function testComputeHash2():void
		{
			var data:ByteArray = new ByteArray();
			
			data.writeUTFBytes("abc");
			
			computeHashAndTest(data, "900150983CD24FB0D6963F7D28E17F72");
		}
		
		[Test]
		public function testComputeHash3():void
		{
			var data:ByteArray = new ByteArray();
			
			data.writeUTFBytes("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789");
			
			computeHashAndTest(data, "D174AB98D277D9F5A5611C2C9F419D9F");
		}
		
		[Test]
		public function testTransformBlock():void
		{
			var data:ByteArray = new ByteArray();
			
			data.writeUTFBytes("12345678901234567890123456789012345678901234567890123456789012345678901234567890");
			
			transformBlockAndTest(data, "57EDF4A22BE3C955AC49DA2E2107B67A");
		}
	}
}