////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto
{
	import flame.utils.ByteArrayUtil;
	
	import flash.utils.ByteArray;

	internal final class CryptoUtil
	{
		//--------------------------------------------------------------------------
		//
		//  Internal methods
		//
		//--------------------------------------------------------------------------
		
		internal static function ensureLength(byteArray:ByteArray, length:int):ByteArray
		{
			if (byteArray.length > length)
			{
				var i:int = 0;
				var count:int = byteArray.length - length;
				
				while (i < count && byteArray[i] == 0)
					i++;
				
				if (i > 0)
					ByteArrayUtil.removeBytes(byteArray, 0, i);
			}
			else if (byteArray.length < length)
				ByteArrayUtil.insertBytes(byteArray, 0, ByteArrayUtil.repeat(0, length - byteArray.length));
			
			byteArray.position = 0;
			
			return byteArray;
		}
		
		internal static function generatePKCS1Mask(seed:ByteArray, length:int, hashAlgorithm:HashAlgorithm):ByteArray
		{
			var hash:ByteArray = new ByteArray();
			var buffer:ByteArray = new ByteArray();
			
			for (var i:int = 0, j:int = 0, stepSize:int = hashAlgorithm.hashSize >> 3; i < length; i += stepSize, j++)
			{
				hash.clear();
				hash.writeBytes(seed);
				hash.writeInt(j);
				
				buffer.writeBytes(hashAlgorithm.computeHash(hash), 0, length - i > stepSize ? stepSize : length - i);
			}
			
			return buffer;
		}
	}
}