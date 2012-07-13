////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2011 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.crypto
{
	import flash.utils.ByteArray;
	
	/**
	 * Computes the SHA-512 hash value for the input data. This class cannot be inherited.
	 * <p>The hash size for the SHA-512 algorithm is 512 bits.</p>
	 */
	public final class SHA512 extends HashAlgorithm
	{
		//--------------------------------------------------------------------------
	    //
	    //  Fields
	    //
	    //--------------------------------------------------------------------------
	    
		private static const _k:Vector.<Int64> = new <Int64>[ new Int64(1116352408, -685199838), new Int64(1899447441, 602891725), new Int64(-1245643825, -330482897), new Int64(-373957723, -2121671748), new Int64(961987163, -213338824), new Int64(1508970993, -1241133031), new Int64(-1841331548, -1357295717), new Int64(-1424204075, -630357736), new Int64(-670586216, -1560083902),	new Int64(310598401, 1164996542), new Int64(607225278, 1323610764), new Int64(1426881987, -704662302), new Int64(1925078388, -226784913), new Int64(-2132889090, 991336113), new Int64(-1680079193, 633803317), new Int64(-1046744716, -815192428), new Int64(-459576895, -1628353838), new Int64(-272742522, 944711139), new Int64(264347078, -1953704523), new Int64(604807628, 2007800933), new Int64(770255983, 1495990901), new Int64(1249150122, 1856431235), new Int64(1555081692, -1119749164), new Int64(1996064986, -2096016459), new Int64(-1740746414, -295247957),	new Int64(-1473132947, 766784016), new Int64(-1341970488, -1728372417), new Int64(-1084653625, -1091629340), new Int64(-958395405, 1034457026), new Int64(-710438585, -1828018395), new Int64(113926993, -536640913), new Int64(338241895, 168717936), new Int64(666307205, 1188179964), new Int64(773529912, 1546045734), new Int64(1294757372, 1522805485), new Int64(1396182291, -1651133473), new Int64(1695183700, -1951439906), new Int64(1986661051, 1014477480), new Int64(-2117940946,	1206759142), new Int64(-1838011259, 344077627), new Int64(-1564481375, 1290863460), new Int64(-1474664885, -1136513023), new Int64(-1035236496, -789014639), new Int64(-949202525, 106217008), new Int64(-778901479, -688958952), new Int64(-694614492, 1432725776), new Int64(-200395387, 1467031594), new Int64(275423344, 851169720), new Int64(430227734, -1194143544), new Int64(506948616, 1363258195), new Int64(659060556, -544281703), new Int64(883997877, -509917016), new Int64(958139571, -976659869), new Int64(1322822218, -482243893), new Int64(1537002063, 2003034995), new Int64(1747873779, -692930397), new Int64(1955562222, 1575990012), new Int64(2024104815, 1125592928), new Int64(-2067236844, -1578062990), new Int64(-1933114872, 442776044), new Int64(-1866530822, 593698344), new Int64(-1538233109, -561857047), new Int64(-1090935817, -1295615723), new Int64(-965641998, -479046869), new Int64(-903397682, -366583396), new Int64(-779700025, 566280711), new Int64(-354779690, -840897762), new Int64(-176337025, -294727304), new Int64(116418474, 1914138554), new Int64(174292421, -1563912026), new Int64(289380356, -1090974290), new Int64(460393269, 320620315), new Int64(685471733, 587496836), new Int64(852142971, 1086792851), new Int64(1017036298, 365543100), new Int64(1126000580, -1676669620), new Int64(1288033470, -885112138), new Int64(1501505948,	-60457430), new Int64(1607167915, 987167468), new Int64(1816402316, 1246189591) ];
		
		private var _buffer:ByteArray = new ByteArray();
		private var _count:int;
		private var _sha512State:Vector.<Int64> = new Vector.<Int64>(8, true);
		private var _w:Vector.<Int64> = new Vector.<Int64>(80, true);
		
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
		 * Initializes a new instance of the SHA512 class.  
		 */
		public function SHA512()
		{
			super();
			
			_hash = new ByteArray();
			_hashSize = 512;
			
			initialize();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes an instance of SHA512. 
		 */
		public override function initialize():void
		{
			_buffer.clear();
			
			_count = 0;
			
			_sha512State[0] = new Int64(1779033703, -205731576); 
			_sha512State[1] = new Int64(-1150833019, -2067093701);
			_sha512State[2] = new Int64(1013904242, -23791573);
			_sha512State[3] = new Int64(-1521486534, 1595750129);
			_sha512State[4] = new Int64(1359893119, -1377402159);
			_sha512State[5] = new Int64(-1694144372, 725511199);
			_sha512State[6] = new Int64(528734635, -79577749);
			_sha512State[7] = new Int64(1541459225, 327033209);
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
			var paddedLength:int = ((((bufferLength << 3) + 128) >> 10) + 1) << 7;
			
			_buffer.readBytes(data);
			
			data[bufferLength] |= 0x80;
			data.length = paddedLength;
			data.position = paddedLength - 4;
			
			data.writeInt(_count << 3);
			
			_buffer.clear();
			
			hashData(data, 0, data.length);
			
			_hash.clear();
			_hash.writeInt(_sha512State[0].highBits);
			_hash.writeInt(_sha512State[0].lowBits);
			_hash.writeInt(_sha512State[1].highBits);
			_hash.writeInt(_sha512State[1].lowBits);
			_hash.writeInt(_sha512State[2].highBits);
			_hash.writeInt(_sha512State[2].lowBits);
			_hash.writeInt(_sha512State[3].highBits);
			_hash.writeInt(_sha512State[3].lowBits);
			_hash.writeInt(_sha512State[4].highBits);
			_hash.writeInt(_sha512State[4].lowBits);
			_hash.writeInt(_sha512State[5].highBits);
			_hash.writeInt(_sha512State[5].lowBits);
			_hash.writeInt(_sha512State[6].highBits);
			_hash.writeInt(_sha512State[6].lowBits);
			_hash.writeInt(_sha512State[7].highBits);
			_hash.writeInt(_sha512State[7].lowBits);
			
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
	        var a:Int64;
            var b:Int64;
            var c:Int64;
            var d:Int64;
            var e:Int64;
            var f:Int64;
            var g:Int64;
            var h:Int64;
			var i:int;
			var position:int = _buffer.position;
	        var temp1:Int64;
	        var temp2:Int64;
			
			_count += count;

			data.position = offset;
			
			data.readBytes(_buffer, _buffer.length, count);
			
			_buffer.position = position;
			
			for (; count >= 128; count -= 128)
	        {
				a = _sha512State[0].valueOf();
				b = _sha512State[1].valueOf();
				c = _sha512State[2].valueOf();
				d = _sha512State[3].valueOf();
				e = _sha512State[4].valueOf();
				f = _sha512State[5].valueOf();
				g = _sha512State[6].valueOf();
				h = _sha512State[7].valueOf();
	            
				for (i = 0; i < 16; i++)
				{
					_w[i] = new Int64(_buffer.readInt(), _buffer.readInt());
					temp1 = h.add(new Int64((e.highBits >>> 14 | e.lowBits << 18) ^ (e.highBits >>> 18 | e.lowBits << 14) ^ (e.lowBits >>> 9 | e.highBits << 23), (e.lowBits >>> 14 | e.highBits << 18) ^ (e.lowBits >>> 18 | e.highBits << 14) ^ (e.highBits >>> 9 | e.lowBits << 23)))
						.add(new Int64(e.highBits & f.highBits ^ ~e.highBits & g.highBits, e.lowBits & f.lowBits ^ ~e.lowBits & g.lowBits)).add(_k[i]).add(_w[i]);
					temp2 = new Int64((a.highBits >>> 28 | a.lowBits << 4) ^ (a.lowBits >>> 2 | a.highBits << 30) ^ (a.lowBits >>> 7 | a.highBits << 25), (a.lowBits >>> 28 | a.highBits << 4) ^ (a.highBits >>> 2 | a.lowBits << 30) ^ (a.highBits >>> 7 | a.lowBits << 25))
						.add(new Int64(a.highBits & b.highBits ^ a.highBits & c.highBits ^ b.highBits & c.highBits, a.lowBits & b.lowBits ^ a.lowBits & c.lowBits ^ b.lowBits & c.lowBits));
					h = g
					g = f;
					f = e;
					e = d.add(temp1);
					d = c;
					c = b;
					b = a;
					a = temp1.add(temp2);
				}
				
				for (i = 16; i < 80; i++)
				{
					temp1 = _w[i - 2];
					temp2 = _w[i - 15];
					_w[i] = new Int64((temp1.highBits >>> 19 | temp1.lowBits << 13) ^ (temp1.lowBits >>> 29 | temp1.highBits << 3) ^ (temp1.highBits >>> 6), (temp1.lowBits >>> 19 | temp1.highBits << 13) ^ (temp1.highBits >>> 29 | temp1.lowBits << 3) ^ (temp1.lowBits >>> 6 | temp1.highBits << 26)).add(_w[i - 7])
						.add(new Int64((temp2.highBits >>> 1 | temp2.lowBits << 31) ^ (temp2.highBits >>> 8 | temp2.lowBits << 24) ^ (temp2.highBits >>> 7), (temp2.lowBits >>> 1 | temp2.highBits << 31) ^ (temp2.lowBits >>> 8 | temp2.highBits << 24) ^ (temp2.lowBits >>> 7 | temp2.highBits << 25))).add(_w[i - 16]);
					temp1 = h.add(new Int64((e.highBits >>> 14 | e.lowBits << 18) ^ (e.highBits >>> 18 | e.lowBits << 14) ^ (e.lowBits >>> 9 | e.highBits << 23), (e.lowBits >>> 14 | e.highBits << 18) ^ (e.lowBits >>> 18 | e.highBits << 14) ^ (e.highBits >>> 9 | e.lowBits << 23)))
						.add(new Int64(e.highBits & f.highBits ^ ~e.highBits & g.highBits, e.lowBits & f.lowBits ^ ~e.lowBits & g.lowBits)).add(_k[i]).add(_w[i]);
					temp2 = new Int64((a.highBits >>> 28 | a.lowBits << 4) ^ (a.lowBits >>> 2 | a.highBits << 30) ^ (a.lowBits >>> 7 | a.highBits << 25), (a.lowBits >>> 28 | a.highBits << 4) ^ (a.highBits >>> 2 | a.lowBits << 30) ^ (a.highBits >>> 7 | a.lowBits << 25))
						.add(new Int64(a.highBits & b.highBits ^ a.highBits & c.highBits ^ b.highBits & c.highBits, a.lowBits & b.lowBits ^ a.lowBits & c.lowBits ^ b.lowBits & c.lowBits));
					h = g
					g = f;
					f = e;
					e = d.add(temp1);
					d = c;
					c = b;
					b = a;
					a = temp1.add(temp2);
				}
				
	            _sha512State[0] = _sha512State[0].add(a);
	            _sha512State[1] = _sha512State[1].add(b);
	            _sha512State[2] = _sha512State[2].add(c);
	            _sha512State[3] = _sha512State[3].add(d);
	            _sha512State[4] = _sha512State[4].add(e);
	            _sha512State[5] = _sha512State[5].add(f);
	            _sha512State[6] = _sha512State[6].add(g);
	            _sha512State[7] = _sha512State[7].add(h);
	        }
			
			var bytesAvailable:int = _buffer.bytesAvailable;
			
			_buffer.readBytes(_buffer, 0, bytesAvailable);
			
			_buffer.length = bytesAvailable;
			_buffer.position = 0;
		}
	}
}