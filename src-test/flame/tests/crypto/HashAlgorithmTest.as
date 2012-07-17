////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.tests.crypto
{
	import flame.crypto.HashAlgorithm;
	import flame.utils.ByteArrayUtil;
	
	import flash.utils.ByteArray;
	
	import flexunit.framework.Assert;
	
	import mx.utils.StringUtil;
	
	public class HashAlgorithmTest
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		protected var _hashAlgorithm:HashAlgorithm;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function HashAlgorithmTest()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		[After]
		public function tearDown():void
		{
			_hashAlgorithm.initialize();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		protected function assertHashIsValid(hash:String, expectedHash:String):void
		{
			Assert.assertTrue(StringUtil.substitute("Invalid hash. Expected '{0}', got '{1}'.", expectedHash, hash), hash == expectedHash);
		}
		
		protected function computeHashAndTest(data:ByteArray, expectedHash:String):void
		{
			assertHashIsValid(ByteArrayUtil.toHexString(_hashAlgorithm.computeHash(data)), expectedHash);
		}
		
		protected function transformBlockAndTest(data:ByteArray, expectedHash:String):void
		{
			var buffer:ByteArray = new ByteArray();
			var inputBlockSize:int = _hashAlgorithm.inputBlockSize;
			var inputOffset:int;
			var outputOffset:int;
			
			for (inputOffset = 0, outputOffset = 0; data.length - outputOffset > inputBlockSize; inputOffset += inputBlockSize, buffer.clear())
				outputOffset += _hashAlgorithm.transformBlock(data, inputOffset, inputBlockSize, buffer, outputOffset);
			
			_hashAlgorithm.transformFinalBlock(data, outputOffset, data.length - outputOffset);
			
			assertHashIsValid(ByteArrayUtil.toHexString(_hashAlgorithm.hash), expectedHash);
		}
	}
}