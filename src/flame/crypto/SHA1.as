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
	
	/**
	 * Computes the SHA-1 hash value for the input data. This class cannot be inherited.
	 * <p>The hash size for the SHA-1 algorithm is 160 bits.</p>
	 */
	public final class SHA1 extends HashAlgorithm
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private var _buffer:ByteArray = new ByteArray();
		private var _count:int;
		private var _sha1State:Vector.<int> = new Vector.<int>(5, true);
		private var _w:Vector.<int> = new Vector.<int>(80, true);
		
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Initializes a new instance of the SHA1 class. 
		 */
		public function SHA1()
		{
			super();
			
			_hash = new ByteArray();
			_hashSize = 160;
			
			initialize();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes an instance of SHA1. 
		 */
		public override function initialize():void
		{
			_buffer.clear();
			
			_count = 0;
			
			_sha1State[0] = 1732584193;
			_sha1State[1] = -271733879;
			_sha1State[2] = -1732584194;
			_sha1State[3] = 271733878;
			_sha1State[4] = -1009589776;
			
			for (var i:int = 0, count:int = _w.length; i < count; i++)
				_w[i] = 0;
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
			
			data[bufferLength] |= 0x80;
			data.length = paddedLength;
			data.position = paddedLength - 4;
			
			data.writeInt(_count << 3);
			
			_buffer.clear();
			
			hashData(data, 0, data.length);
			
			_hash.clear();
			_hash.writeInt(_sha1State[0]);
			_hash.writeInt(_sha1State[1]);
			_hash.writeInt(_sha1State[2]);
			_hash.writeInt(_sha1State[3]);
			_hash.writeInt(_sha1State[4]);
			
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
			var a:int;
			var b:int;
			var c:int;
			var d:int;
			var e:int;
			var i:int;
			var position:int = _buffer.position;
			var temp:int;
			
			_count += count;
			
			data.position = offset;
			
			data.readBytes(_buffer, _buffer.length, count);
			
			_buffer.position = position;
			
			for (; count >= 64; count -= 64)
			{
				a = _sha1State[0];
				b = _sha1State[1];
				c = _sha1State[2];
				d = _sha1State[3];
				e = _sha1State[4];
				
				for (i = 0; i < 16; i++)
				{
					_w[i] = _buffer.readInt();
					temp = (a << 5 | a >>> 27) + (b & c | ~b & d) + e + 1518500249 + _w[i];
					e = d;
					d = c;
					c = b << 30 | b >>> 2;
					b = a;
					a = temp;
				}
				
				for (i = 16; i < 20; i++)
				{
					_w[i] = _w[i - 3] ^ _w[i - 8] ^ _w[i - 14] ^ _w[i - 16];
					_w[i] = _w[i] << 1 | _w[i] >>> 31;
					temp = (a << 5 | a >>> 27) + (b & c | ~b & d) + e + 1518500249 + _w[i];
					e = d;
					d = c;
					c = b << 30 | b >>> 2;
					b = a;
					a = temp;
				}
				
				for (i = 20; i < 40; i++)
				{
					_w[i] = _w[i - 3] ^ _w[i - 8] ^ _w[i - 14] ^ _w[i - 16];
					_w[i] = _w[i] << 1 | _w[i] >>> 31;
					temp = (a << 5 | a >>> 27) + (b ^ c ^ d) + e + 1859775393 + _w[i];
					e = d;
					d = c;
					c = b << 30 | b >>> 2;
					b = a;
					a = temp;
				}
				
				for (i = 40; i < 60; i++)
				{
					_w[i] = _w[i - 3] ^ _w[i - 8] ^ _w[i - 14] ^ _w[i - 16];
					_w[i] = _w[i] << 1 | _w[i] >>> 31;
					temp = (a << 5 | a >>> 27) + (b & c | b & d | c & d) + e - 1894007588 + _w[i];
					e = d;
					d = c;
					c = b << 30 | b >>> 2;
					b = a;
					a = temp;
				}
				
				for (i = 60; i < 80; i++)
				{
					_w[i] = _w[i - 3] ^ _w[i - 8] ^ _w[i - 14] ^ _w[i - 16];
					_w[i] = _w[i] << 1 | _w[i] >>> 31;
					temp = (a << 5 | a >>> 27) + (b ^ c ^ d) + e - 899497514 + _w[i];
					e = d;
					d = c;
					c = b << 30 | b >>> 2;
					b = a;
					a = temp;
				}
				
				_sha1State[0] += a;
				_sha1State[1] += b;
				_sha1State[2] += c;
				_sha1State[3] += d;
				_sha1State[4] += e;
			}
			
			var bytesAvailable:int = _buffer.bytesAvailable;
			
			_buffer.readBytes(_buffer, 0, bytesAvailable);
			
			_buffer.length = bytesAvailable;
			_buffer.position = 0;
		}
	}
}