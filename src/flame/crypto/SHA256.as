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
	 * Computes the SHA-256 hash value for the input data. This class cannot be inherited.
	 * <p>The hash size for the SHA-256 algorithm is 256 bits.</p>
	 */
	public final class SHA256 extends HashAlgorithm
	{
		//--------------------------------------------------------------------------
	    //
	    //  Fields
	    //
	    //--------------------------------------------------------------------------
	    
		private static const _k:Vector.<int> = new <int>[ 1116352408, 1899447441, -1245643825, -373957723, 961987163, 1508970993, -1841331548, -1424204075, -670586216, 310598401, 607225278, 1426881987, 1925078388, -2132889090, -1680079193, -1046744716, -459576895, -272742522, 264347078, 604807628, 770255983, 1249150122, 1555081692, 1996064986, -1740746414, -1473132947, -1341970488, -1084653625, -958395405, -710438585, 113926993, 338241895, 666307205, 773529912, 1294757372, 1396182291, 1695183700, 1986661051, -2117940946, -1838011259, -1564481375, -1474664885, -1035236496, -949202525, -778901479, -694614492, -200395387, 275423344, 430227734, 506948616, 659060556, 883997877, 958139571, 1322822218, 1537002063, 1747873779, 1955562222, 2024104815, -2067236844, -1933114872, -1866530822, -1538233109, -1090935817, -965641998 ];
		
		private var _buffer:ByteArray = new ByteArray();
		private var _count:int;
		private var _sha256State:Vector.<int> = new Vector.<int>(8, true);
		private var _w:Vector.<int> = new Vector.<int>(64, true);
		
		//--------------------------------------------------------------------------
	    //
	    //  Static constructor
	    //
	    //--------------------------------------------------------------------------
		
		{
			_k.fixed = true;
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Initializes a new instance of the SHA256 class.  
		 */
		public function SHA256()
		{
			super();
			
			_hash = new ByteArray();
			_hashSize = 256;
			
			initialize();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes an instance of SHA256. 
		 */
		public override function initialize():void
		{
			_buffer.clear();
			
			_count = 0;
			
			_sha256State[0] = 1779033703;
			_sha256State[1] = -1150833019;
			_sha256State[2] = 1013904242;
			_sha256State[3] = -1521486534;
			_sha256State[4] = 1359893119;
			_sha256State[5] = -1694144372;
			_sha256State[6] = 528734635;
			_sha256State[7] = 1541459225;
			
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
			_hash.writeInt(_sha256State[0]);
			_hash.writeInt(_sha256State[1]);
			_hash.writeInt(_sha256State[2]);
			_hash.writeInt(_sha256State[3]);
			_hash.writeInt(_sha256State[4]);
			_hash.writeInt(_sha256State[5]);
			_hash.writeInt(_sha256State[6]);
			_hash.writeInt(_sha256State[7]);
			
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
            var f:int;
            var g:int;
            var h:int;
			var i:int;
			var position:int = _buffer.position;
	        var temp1:int;
	        var temp2:int;
			
			_count += count;

			data.position = offset;
			
			data.readBytes(_buffer, _buffer.length, count);
			
			_buffer.position = position;
			
			for (; count >= 64; count -= 64)
	        {
	            a = _sha256State[0];
	            b = _sha256State[1];
	            c = _sha256State[2];
	            d = _sha256State[3];
	            e = _sha256State[4];
	            f = _sha256State[5];
	            g = _sha256State[6];
	            h = _sha256State[7];
	            
				for (i = 0; i < 16; i++)
				{
		            _w[i] = _buffer.readInt();
					temp1 = h + ((e << 26 | e >>> 6) ^ (e << 21 | e >>> 11) ^ (e << 7 | e >>> 25)) + ((e & f) ^ (~e & g)) + _k[i] + _w[i];
					temp2 = ((a << 30 | a >>> 2) ^ (a << 19 | a >>> 13) ^ (a << 10 | a >>> 22)) + ((a & b) ^ (a & c) ^ (b & c));
					h = g
					g = f;
					f = e;
					e = d + temp1;
					d = c;
					c = b;
					b = a;
					a = temp1 + temp2;
				}
				
	            for (i = 16; i < 64; i++)
				{
					temp1 = _w[i - 2];
					temp2 = _w[i - 15];
		            _w[i] = ((temp1 << 15 | temp1 >>> 17) ^ (temp1 << 13 | temp1 >>> 19) ^ (temp1 >>> 10)) + _w[i - 7] +
						((temp2 << 25 | temp2 >>> 7) ^ (temp2 << 14 | temp2 >>> 18) ^ (temp2 >>> 3)) + _w[i - 16];
					temp1 = h + ((e << 26 | e >>> 6) ^ (e << 21 | e >>> 11) ^ (e << 7 | e >>> 25)) + ((e & f) ^ (~e & g)) + _k[i] + _w[i];
					temp2 = ((a << 30 | a >>> 2) ^ (a << 19 | a >>> 13) ^ (a << 10 | a >>> 22)) + ((a & b) ^ (a & c) ^ (b & c));
					h = g
					g = f;
					f = e;
					e = d + temp1;
					d = c;
					c = b;
					b = a;
					a = temp1 + temp2;
				}
				
	            _sha256State[0] += a;
	            _sha256State[1] += b;
	            _sha256State[2] += c;
	            _sha256State[3] += d;
	            _sha256State[4] += e;
	            _sha256State[5] += f;
	            _sha256State[6] += g;
	            _sha256State[7] += h;
	        }
			
			var bytesAvailable:int = _buffer.bytesAvailable;
			
			_buffer.readBytes(_buffer, 0, bytesAvailable);
			
			_buffer.length = bytesAvailable;
			_buffer.position = 0;
		}
	}
}