////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * Computes the MD5 hash value for the input data. This class cannot be inherited.
	 * <p>Hash functions map binary strings of an arbitrary length to small binary strings of a fixed length.
	 * A cryptographic hash function has the property that it is computationally infeasible
	 * to find two distinct inputs that hash to the same value;
	 * that is, hashes of two sets of data should match if the corresponding data also matches.
	 * Small changes to the data result in large, unpredictable changes in the hash.</p>
	 * <p>The hash size for the MD5 class is 128 bits.</p>
	 * <p>The <code>computeHash()</code> method of the MD5 class
	 * returns the hash as an array of 16 bytes. Note that some MD5 implementations produce a 32-character,
	 * hexadecimal-formatted hash. To interoperate with such implementations,
	 * format the return value of the <code>computeHash()</code> method as a hexadecimal value.</p>
	 */
	public final class MD5 extends HashAlgorithm
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private var _buffer:ByteArray = new ByteArray();
		private var _count:int;
		private var _md5State:Vector.<int> = new Vector.<int>(4, true);
		private var _x:Vector.<int> = new Vector.<int>(16, true);
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the MD5 class.
		 */
		public function MD5()
		{
			super();
			
			_buffer.endian = Endian.LITTLE_ENDIAN;
			_hash = new ByteArray();
			_hash.endian = Endian.LITTLE_ENDIAN;
			_hashSize = 128;
			
			initialize();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes an instance of MD5. 
		 */
		public override function initialize():void
		{
			_buffer.clear();
			
			_count = 0;
			
			_md5State[0] = 1732584193;
			_md5State[1] = -271733879;
			_md5State[2] = -1732584194;
			_md5State[3] = 271733878;
			
			for (var i:int = 0, count:int = _x.length; i < count; i++)
				_x[i] = 0;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		protected override function hashCore(inputBuffer:ByteArray, inputOffset:int, inputCount:int):void
		{
			hashData(inputBuffer, inputOffset, inputCount);
		}
		
		/**
		 * @inheritDoc
		 */
		protected override function hashFinal():ByteArray
		{
			var bufferLength:int = _buffer.length;
			var data:ByteArray = new ByteArray();
			var paddedLength:int = ((((bufferLength << 3) + 64) >> 9) + 1) << 6;
			
			_buffer.readBytes(data);
			
			data.endian = _buffer.endian;
			data[bufferLength] |= 0x80;
			data.length = paddedLength;
			data.position = paddedLength - 8;
			
			data.writeInt(_count << 3);
			
			_buffer.clear();
			
			hashData(data, 0, data.length);
			
			_hash.clear();
			_hash.writeInt(_md5State[0]);
			_hash.writeInt(_md5State[1]);
			_hash.writeInt(_md5State[2]);
			_hash.writeInt(_md5State[3]);
			
			_hash.position = 0;
			
			return _hash;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function hashData(data:ByteArray, offset:int, count:int):void
		{
			var a:int = _md5State[0];
			var aa:int;
			var b:int = _md5State[1];
			var bb:int;
			var c:int = _md5State[2];
			var cc:int;
			var d:int = _md5State[3];
			var dd:int;
			var position:int = _buffer.position;
			
			_count += count;
			
			data.position = offset;
			
			data.readBytes(_buffer, _buffer.length, count);
			
			_buffer.position = position;
			
			for (; count >= 64; count -= 64)
			{
				_x[0] = _buffer.readInt();
				_x[1] = _buffer.readInt();
				_x[2] = _buffer.readInt();
				_x[3] = _buffer.readInt();
				_x[4] = _buffer.readInt();
				_x[5] = _buffer.readInt();
				_x[6] = _buffer.readInt();
				_x[7] = _buffer.readInt();
				_x[8] = _buffer.readInt();
				_x[9] = _buffer.readInt();
				_x[10] = _buffer.readInt();
				_x[11] = _buffer.readInt();
				_x[12] = _buffer.readInt();
				_x[13] = _buffer.readInt();
				_x[14] = _buffer.readInt();
				_x[15] = _buffer.readInt();
				
				aa = a;
				bb = b;
				cc = c;
				dd = d;
				
				a += (b & c | ~b & d) + 3614090360 + _x[0];
				a = b + (a << 7 | a >>> 25);
				d += (a & b | ~a & c) + 3905402710 + _x[1];
				d = a + (d << 12 | d >>> 20);
				c += (d & a | ~d & b) + 606105819 + _x[2];
				c = d + (c << 17 | c >>> 15);
				b += (c & d | ~c & a) + 3250441966 + _x[3];
				b = c + (b << 22 | b >>> 10);
				a += (b & c | ~b & d) + 4118548399 + _x[4];
				a = b + (a << 7 | a >>> 25);
				d += (a & b | ~a & c) + 1200080426 + _x[5];
				d = a + (d << 12 | d >>> 20);
				c += (d & a | ~d & b) + 2821735955 + _x[6];
				c = d + (c << 17 | c >>> 15);
				b += (c & d | ~c & a) + 4249261313 + _x[7];
				b = c + (b << 22 | b >>> 10);
				a += (b & c | ~b & d) + 1770035416 + _x[8];
				a = b + (a << 7 | a >>> 25);
				d += (a & b | ~a & c) + 2336552879 + _x[9];
				d = a + (d << 12 | d >>> 20);
				c += (d & a | ~d & b) + 4294925233 + _x[10];
				c = d + (c << 17 | c >>> 15);
				b += (c & d | ~c & a) + 2304563134 + _x[11];
				b = c + (b << 22 | b >>> 10);
				a += (b & c | ~b & d) + 1804603682 + _x[12];
				a = b + (a << 7 | a >>> 25);
				d += (a & b | ~a & c) + 4254626195 + _x[13];
				d = a + (d << 12 | d >>> 20);
				c += (d & a | ~d & b) + 2792965006 + _x[14];
				c = d + (c << 17 | c >>> 15);
				b += (c & d | ~c & a) + 1236535329 + _x[15];
				b = c + (b << 22 | b >>> 10);
				a += (b & d | c & ~d) + 4129170786 + _x[1];
				a = b + (a << 5 | a >>> 27);
				d += (a & c | b & ~c) + 3225465664 + _x[6];
				d = a + (d << 9 | d >>> 23);
				c += (d & b | a & ~b) + 643717713 + _x[11];
				c = d + (c << 14 | c >>> 18);
				b += (c & a | d & ~a) + 3921069994 + _x[0];
				b = c + (b << 20 | b >>> 12);
				a += (b & d | c & ~d) + 3593408605 + _x[5];
				a = b + (a << 5 | a >>> 27);
				d += (a & c | b & ~c) + 38016083 + _x[10];
				d = a + (d << 9 | d >>> 23);
				c += (d & b | a & ~b) + 3634488961 + _x[15];
				c = d + (c << 14 | c >>> 18);
				b += (c & a | d & ~a) + 3889429448 + _x[4];
				b = c + (b << 20 | b >>> 12);
				a += (b & d | c & ~d) + 568446438 + _x[9];
				a = b + (a << 5 | a >>> 27);
				d += (a & c | b & ~c) + 3275163606 + _x[14];
				d = a + (d << 9 | d >>> 23);
				c += (d & b | a & ~b) + 4107603335 + _x[3];
				c = d + (c << 14 | c >>> 18);
				b += (c & a | d & ~a) + 1163531501 + _x[8];
				b = c + (b << 20 | b >>> 12);
				a += (b & d | c & ~d) + 2850285829 + _x[13];
				a = b + (a << 5 | a >>> 27);
				d += (a & c | b & ~c) + 4243563512 + _x[2];
				d = a + (d << 9 | d >>> 23);
				c += (d & b | a & ~b) + 1735328473 + _x[7];
				c = d + (c << 14 | c >>> 18);
				b += (c & a | d & ~a) + 2368359562 + _x[12];
				b = c + (b << 20 | b >>> 12);
				a += (b ^ c ^ d) + 4294588738 + _x[5];
				a = b + (a << 4 | a >>> 28);
				d += (a ^ b ^ c) + 2272392833 + _x[8];
				d = a + (d << 11 | d >>> 21);
				c += (d ^ a ^ b) + 1839030562 + _x[11];
				c = d + (c << 16 | c >>> 16);
				b += (c ^ d ^ a) + 4259657740 + _x[14];
				b = c + (b << 23 | b >>> 9);
				a += (b ^ c ^ d) + 2763975236 + _x[1];
				a = b + (a << 4 | a >>> 28);
				d += (a ^ b ^ c) + 1272893353 + _x[4];
				d = a + (d << 11 | d >>> 21);
				c += (d ^ a ^ b) + 4139469664 + _x[7];
				c = d + (c << 16 | c >>> 16);
				b += (c ^ d ^ a) + 3200236656 + _x[10];
				b = c + (b << 23 | b >>> 9);
				a += (b ^ c ^ d) + 681279174 + _x[13];
				a = b + (a << 4 | a >>> 28);
				d += (a ^ b ^ c) + 3936430074 + _x[0];
				d = a + (d << 11 | d >>> 21);
				c += (d ^ a ^ b) + 3572445317 + _x[3];
				c = d + (c << 16 | c >>> 16);
				b += (c ^ d ^ a) + 76029189 + _x[6];
				b = c + (b << 23 | b >>> 9);
				a += (b ^ c ^ d) + 3654602809 + _x[9];
				a = b + (a << 4 | a >>> 28);
				d += (a ^ b ^ c) + 3873151461 + _x[12];
				d = a + (d << 11 | d >>> 21);
				c += (d ^ a ^ b) + 530742520 + _x[15];
				c = d + (c << 16 | c >>> 16);
				b += (c ^ d ^ a) + 3299628645 + _x[2];
				b = c + (b << 23 | b >>> 9);
				a += (c ^ (b | ~d)) + 4096336452 + _x[0];
				a = b + (a << 6 | a >>> 26);
				d += (b ^ (a | ~c)) + 1126891415 + _x[7];
				d = a + (d << 10 | d >>> 22);
				c += (a ^ (d | ~b)) + 2878612391 + _x[14];
				c = d + (c << 15 | c >>> 17);
				b += (d ^ (c | ~a)) + 4237533241 + _x[5];
				b = c + (b << 21 | b >>> 11);
				a += (c ^ (b | ~d)) + 1700485571 + _x[12];
				a = b + (a << 6 | a >>> 26);
				d += (b ^ (a | ~c)) + 2399980690 + _x[3];
				d = a + (d << 10 | d >>> 22);
				c += (a ^ (d | ~b)) + 4293915773 + _x[10];
				c = d + (c << 15 | c >>> 17);
				b += (d ^ (c | ~a)) + 2240044497 + _x[1];
				b = c + (b << 21 | b >>> 11);
				a += (c ^ (b | ~d)) + 1873313359 + _x[8];
				a = b + (a << 6 | a >>> 26);
				d += (b ^ (a | ~c)) + 4264355552 + _x[15];
				d = a + (d << 10 | d >>> 22);
				c += (a ^ (d | ~b)) + 2734768916 + _x[6];
				c = d + (c << 15 | c >>> 17);
				b += (d ^ (c | ~a)) + 1309151649 + _x[13];
				b = c + (b << 21 | b >>> 11);
				a += (c ^ (b | ~d)) + 4149444226 + _x[4];
				a = b + (a << 6 | a >>> 26);
				d += (b ^ (a | ~c)) + 3174756917 + _x[11];
				d = a + (d << 10 | d >>> 22);
				c += (a ^ (d | ~b)) + 718787259 + _x[2];
				c = d + (c << 15 | c >>> 17);
				b += (d ^ (c | ~a)) + 3951481745 + _x[9];
				b = c + (b << 21 | b >>> 11);
				
				a += aa;
				b += bb;
				c += cc;
				d += dd;
			}
			
			_md5State[0] = a;
			_md5State[1] = b;
			_md5State[2] = c;
			_md5State[3] = d;
			
			var bytesAvailable:int = _buffer.bytesAvailable;
			
			_buffer.readBytes(_buffer, 0, bytesAvailable);
			
			_buffer.length = bytesAvailable;
			_buffer.position = 0;
		}
	}
}