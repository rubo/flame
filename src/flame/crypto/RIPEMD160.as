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
	 * Computes the RIPEMD-160 hash value for the input data. This class cannot be inherited.
	 * <p>The hash size for the RIPEMD-160 algorithm is 160 bits.</p>
	 * <p>It is intended for use as a secure replacement for the 128-bit hash functions MD4, MD5, and RIPEMD.
	 * RIPEMD was developed in the framework of the EU project RIPE (RACE Integrity Primitives Evaluation, 1988-1992).</p>
	 */
	public final class RIPEMD160 extends HashAlgorithm
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private var _buffer:ByteArray = new ByteArray();
		private var _count:int;
		private var _md160State:Vector.<int> = new Vector.<int>(5, true);
		private var _x:Vector.<int> = new Vector.<int>(16, true);
		
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Initializes a new instance of the RIPEMD160 class.
		 */
		public function RIPEMD160()
		{
			super();
			
			_buffer.endian = Endian.LITTLE_ENDIAN;
			_hash = new ByteArray();
			_hash.endian = Endian.LITTLE_ENDIAN;
			_hashSize = 160;
			
			initialize();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes an instance of RIPEMD160. 
		 */
		public override function initialize():void
		{
			_buffer.clear();
			
			_count = 0;
			
			_md160State[0] = 1732584193;
			_md160State[1] = -271733879;
			_md160State[2] = -1732584194;
			_md160State[3] = 271733878;
			_md160State[4] = -1009589776;
			
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
            _hash.writeInt(_md160State[0]);
            _hash.writeInt(_md160State[1]);
            _hash.writeInt(_md160State[2]);
            _hash.writeInt(_md160State[3]);
            _hash.writeInt(_md160State[4]);
            
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
			var aa:int;
			var b:int;
			var bb:int;
			var c:int;
			var cc:int;
			var d:int;
			var dd:int;
			var e:int;
			var ee:int;
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
				
				a = aa = _md160State[0];
				b = bb = _md160State[1];
				c = cc = _md160State[2];
				d = dd = _md160State[3];
				e = ee = _md160State[4];
				
				a += (b ^ c ^ d) + _x[0];
				a = e + (a << 11 | a >>> 21);
				c = c << 10 | c >>> 22;
				e += (a ^ b ^ c) + _x[1];
				e = d + (e << 14 | e >>> 18);
				b = b << 10 | b >>> 22;
				d += (e ^ a ^ b) + _x[2];
				d = c + (d << 15 | d >>> 17);
				a = a << 10 | a >>> 22;
				c += (d ^ e ^ a) + _x[3];
				c = b + (c << 12 | c >>> 20);
				e = e << 10 | e >>> 22;
				b += (c ^ d ^ e) + _x[4];
				b = a + (b << 5 | b >>> 27);
				d = d << 10 | d >>> 22;
				a += (b ^ c ^ d) + _x[5];
				a = e + (a << 8 | a >>> 24);
				c = c << 10 | c >>> 22;
				e += (a ^ b ^ c) + _x[6];
				e = d + (e << 7 | e >>> 25);
				b = b << 10 | b >>> 22;
				d += (e ^ a ^ b) + _x[7];
				d = c + (d << 9 | d >>> 23);
				a = a << 10 | a >>> 22;
				c += (d ^ e ^ a) + _x[8];
				c = b + (c << 11 | c >>> 21);
				e = e << 10 | e >>> 22;
				b += (c ^ d ^ e) + _x[9];
				b = a + (b << 13 | b >>> 19);
				d = d << 10 | d >>> 22;
				a += (b ^ c ^ d) + _x[10];
				a = e + (a << 14 | a >>> 18);
				c = c << 10 | c >>> 22;
				e += (a ^ b ^ c) + _x[11];
				e = d + (e << 15 | e >>> 17);
				b = b << 10 | b >>> 22;
				d += (e ^ a ^ b) + _x[12];
				d = c + (d << 6 | d >>> 26);
				a = a << 10 | a >>> 22;
				c += (d ^ e ^ a) + _x[13];
				c = b + (c << 7 | c >>> 25);
				e = e << 10 | e >>> 22;
				b += (c ^ d ^ e) + _x[14];
				b = a + (b << 9 | b >>> 23);
				d = d << 10 | d >>> 22;
				a += (b ^ c ^ d) + _x[15];
				a = e + (a << 8 | a >>> 24);
				c = c << 10 | c >>> 22;
				e += (a & b | ~a & c) + 1518500249 + _x[7];
				e = d + (e << 7 | e >>> 25);
				b = b << 10 | b >>> 22;
				d += (e & a | ~e & b) + 1518500249 + _x[4];
				d = c + (d << 6 | d >>> 26);
				a = a << 10 | a >>> 22;
				c += (d & e | ~d & a) + 1518500249 + _x[13];
				c = b + (c << 8 | c >>> 24);
				e = e << 10 | e >>> 22;
				b += (c & d | ~c & e) + 1518500249 + _x[1];
				b = a + (b << 13 | b >>> 19);
				d = d << 10 | d >>> 22;
				a += (b & c | ~b & d) + 1518500249 + _x[10];
				a = e + (a << 11 | a >>> 21);
				c = c << 10 | c >>> 22;
				e += (a & b | ~a & c) + 1518500249 + _x[6];
				e = d + (e << 9 | e >>> 23);
				b = b << 10 | b >>> 22;
				d += (e & a | ~e & b) + 1518500249 + _x[15];
				d = c + (d << 7 | d >>> 25);
				a = a << 10 | a >>> 22;
				c += (d & e | ~d & a) + 1518500249 + _x[3];
				c = b + (c << 15 | c >>> 17);
				e = e << 10 | e >>> 22;
				b += (c & d | ~c & e) + 1518500249 + _x[12];
				b = a + (b << 7 | b >>> 25);
				d = d << 10 | d >>> 22;
				a += (b & c | ~b & d) + 1518500249 + _x[0];
				a = e + (a << 12 | a >>> 20);
				c = c << 10 | c >>> 22;
				e += (a & b | ~a & c) + 1518500249 + _x[9];
				e = d + (e << 15 | e >>> 17);
				b = b << 10 | b >>> 22;
				d += (e & a | ~e & b) + 1518500249 + _x[5];
				d = c + (d << 9 | d >>> 23);
				a = a << 10 | a >>> 22;
				c += (d & e | ~d & a) + 1518500249 + _x[2];
				c = b + (c << 11 | c >>> 21);
				e = e << 10 | e >>> 22;
				b += (c & d | ~c & e) + 1518500249 + _x[14];
				b = a + (b << 7 | b >>> 25);
				d = d << 10 | d >>> 22;
				a += (b & c | ~b & d) + 1518500249 + _x[11];
				a = e + (a << 13 | a >>> 19);
				c = c << 10 | c >>> 22;
				e += (a & b | ~a & c) + 1518500249 + _x[8];
				e = d + (e << 12 | e >>> 20);
				b = b << 10 | b >>> 22;
				d += ((e | ~a) ^ b) + 1859775393 + _x[3];
				d = c + (d << 11 | d >>> 21);
				a = a << 10 | a >>> 22;
				c += ((d | ~e) ^ a) + 1859775393 + _x[10];
				c = b + (c << 13 | c >>> 19);
				e = e << 10 | e >>> 22;
				b += ((c | ~d) ^ e) + 1859775393 + _x[14];
				b = a + (b << 6 | b >>> 26);
				d = d << 10 | d >>> 22;
				a += ((b | ~c) ^ d) + 1859775393 + _x[4];
				a = e + (a << 7 | a >>> 25);
				c = c << 10 | c >>> 22;
				e += ((a | ~b) ^ c) + 1859775393 + _x[9];
				e = d + (e << 14 | e >>> 18);
				b = b << 10 | b >>> 22;
				d += ((e | ~a) ^ b) + 1859775393 + _x[15];
				d = c + (d << 9 | d >>> 23);
				a = a << 10 | a >>> 22;
				c += ((d | ~e) ^ a) + 1859775393 + _x[8];
				c = b + (c << 13 | c >>> 19);
				e = e << 10 | e >>> 22;
				b += ((c | ~d) ^ e) + 1859775393 + _x[1];
				b = a + (b << 15 | b >>> 17);
				d = d << 10 | d >>> 22;
				a += ((b | ~c) ^ d) + 1859775393 + _x[2];
				a = e + (a << 14 | a >>> 18);
				c = c << 10 | c >>> 22;
				e += ((a | ~b) ^ c) + 1859775393 + _x[7];
				e = d + (e << 8 | e >>> 24);
				b = b << 10 | b >>> 22;
				d += ((e | ~a) ^ b) + 1859775393 + _x[0];
				d = c + (d << 13 | d >>> 19);
				a = a << 10 | a >>> 22;
				c += ((d | ~e) ^ a) + 1859775393 + _x[6];
				c = b + (c << 6 | c >>> 26);
				e = e << 10 | e >>> 22;
				b += ((c | ~d) ^ e) + 1859775393 + _x[13];
				b = a + (b << 5 | b >>> 27);
				d = d << 10 | d >>> 22;
				a += ((b | ~c) ^ d) + 1859775393 + _x[11];
				a = e + (a << 12 | a >>> 20);
				c = c << 10 | c >>> 22;
				e += ((a | ~b) ^ c) + 1859775393 + _x[5];
				e = d + (e << 7 | e >>> 25);
				b = b << 10 | b >>> 22;
				d += ((e | ~a) ^ b) + 1859775393 + _x[12];
				d = c + (d << 5 | d >>> 27);
				a = a << 10 | a >>> 22;
				c += (d & a | e & ~a) - 1894007588 + _x[1];
				c = b + (c << 11 | c >>> 21);
				e = e << 10 | e >>> 22;
				b += (c & e | d & ~e) - 1894007588 + _x[9];
				b = a + (b << 12 | b >>> 20);
				d = d << 10 | d >>> 22;
				a += (b & d | c & ~d) - 1894007588 + _x[11];
				a = e + (a << 14 | a >>> 18);
				c = c << 10 | c >>> 22;
				e += (a & c | b & ~c) - 1894007588 + _x[10];
				e = d + (e << 15 | e >>> 17);
				b = b << 10 | b >>> 22;
				d += (e & b | a & ~b) - 1894007588 + _x[0];
				d = c + (d << 14 | d >>> 18);
				a = a << 10 | a >>> 22;
				c += (d & a | e & ~a) - 1894007588 + _x[8];
				c = b + (c << 15 | c >>> 17);
				e = e << 10 | e >>> 22;
				b += (c & e | d & ~e) - 1894007588 + _x[12];
				b = a + (b << 9 | b >>> 23);
				d = d << 10 | d >>> 22;
				a += (b & d | c & ~d) - 1894007588 + _x[4];
				a = e + (a << 8 | a >>> 24);
				c = c << 10 | c >>> 22;
				e += (a & c | b & ~c) - 1894007588 + _x[13];
				e = d + (e << 9 | e >>> 23);
				b = b << 10 | b >>> 22;
				d += (e & b | a & ~b) - 1894007588 + _x[3];
				d = c + (d << 14 | d >>> 18);
				a = a << 10 | a >>> 22;
				c += (d & a | e & ~a) - 1894007588 + _x[7];
				c = b + (c << 5 | c >>> 27);
				e = e << 10 | e >>> 22;
				b += (c & e | d & ~e) - 1894007588 + _x[15];
				b = a + (b << 6 | b >>> 26);
				d = d << 10 | d >>> 22;
				a += (b & d | c & ~d) - 1894007588 + _x[14];
				a = e + (a << 8 | a >>> 24);
				c = c << 10 | c >>> 22;
				e += (a & c | b & ~c) - 1894007588 + _x[5];
				e = d + (e << 6 | e >>> 26);
				b = b << 10 | b >>> 22;
				d += (e & b | a & ~b) - 1894007588 + _x[6];
				d = c + (d << 5 | d >>> 27);
				a = a << 10 | a >>> 22;
				c += (d & a | e & ~a) - 1894007588 + _x[2];
				c = b + (c << 12 | c >>> 20);
				e = e << 10 | e >>> 22;
				b += (c ^ (d | ~e)) - 1454113458 + _x[4];
				b = a + (b << 9 | b >>> 23);
				d = d << 10 | d >>> 22;
				a += (b ^ (c | ~d)) - 1454113458 + _x[0];
				a = e + (a << 15 | a >>> 17);
				c = c << 10 | c >>> 22;
				e += (a ^ (b | ~c)) - 1454113458 + _x[5];
				e = d + (e << 5 | e >>> 27);
				b = b << 10 | b >>> 22;
				d += (e ^ (a | ~b)) - 1454113458 + _x[9];
				d = c + (d << 11 | d >>> 21);
				a = a << 10 | a >>> 22;
				c += (d ^ (e | ~a)) - 1454113458 + _x[7];
				c = b + (c << 6 | c >>> 26);
				e = e << 10 | e >>> 22;
				b += (c ^ (d | ~e)) - 1454113458 + _x[12];
				b = a + (b << 8 | b >>> 24);
				d = d << 10 | d >>> 22;
				a += (b ^ (c | ~d)) - 1454113458 + _x[2];
				a = e + (a << 13 | a >>> 19);
				c = c << 10 | c >>> 22;
				e += (a ^ (b | ~c)) - 1454113458 + _x[10];
				e = d + (e << 12 | e >>> 20);
				b = b << 10 | b >>> 22;
				d += (e ^ (a | ~b)) - 1454113458 + _x[14];
				d = c + (d << 5 | d >>> 27);
				a = a << 10 | a >>> 22;
				c += (d ^ (e | ~a)) - 1454113458 + _x[1];
				c = b + (c << 12 | c >>> 20);
				e = e << 10 | e >>> 22;
				b += (c ^ (d | ~e)) - 1454113458 + _x[3];
				b = a + (b << 13 | b >>> 19);
				d = d << 10 | d >>> 22;
				a += (b ^ (c | ~d)) - 1454113458 + _x[8];
				a = e + (a << 14 | a >>> 18);
				c = c << 10 | c >>> 22;
				e += (a ^ (b | ~c)) - 1454113458 + _x[11];
				e = d + (e << 11 | e >>> 21);
				b = b << 10 | b >>> 22;
				d += (e ^ (a | ~b)) - 1454113458 + _x[6];
				d = c + (d << 8 | d >>> 24);
				a = a << 10 | a >>> 22;
				c += (d ^ (e | ~a)) - 1454113458 + _x[15];
				c = b + (c << 5 | c >>> 27);
				e = e << 10 | e >>> 22;
				b += (c ^ (d | ~e)) - 1454113458 + _x[13];
				b = a + (b << 6 | b >>> 26);
				d = d << 10 | d >>> 22;
				aa += (bb ^ (cc | ~dd)) + 1352829926 + _x[5];
				aa = ee + (aa << 8 | aa >>> 24);
				cc = cc << 10 | cc >>> 22;
				ee += (aa ^ (bb | ~cc)) + 1352829926 + _x[14];
				ee = dd + (ee << 9 | ee >>> 23);
				bb = bb << 10 | bb >>> 22;
				dd += (ee ^ (aa | ~bb)) + 1352829926 + _x[7];
				dd = cc + (dd << 9 | dd >>> 23);
				aa = aa << 10 | aa >>> 22;
				cc += (dd ^ (ee | ~aa)) + 1352829926 + _x[0];
				cc = bb + (cc << 11 | cc >>> 21);
				ee = ee << 10 | ee >>> 22;
				bb += (cc ^ (dd | ~ee)) + 1352829926 + _x[9];
				bb = aa + (bb << 13 | bb >>> 19);
				dd = dd << 10 | dd >>> 22;
				aa += (bb ^ (cc | ~dd)) + 1352829926 + _x[2];
				aa = ee + (aa << 15 | aa >>> 17);
				cc = cc << 10 | cc >>> 22;
				ee += (aa ^ (bb | ~cc)) + 1352829926 + _x[11];
				ee = dd + (ee << 15 | ee >>> 17);
				bb = bb << 10 | bb >>> 22;
				dd += (ee ^ (aa | ~bb)) + 1352829926 + _x[4];
				dd = cc + (dd << 5 | dd >>> 27);
				aa = aa << 10 | aa >>> 22;
				cc += (dd ^ (ee | ~aa)) + 1352829926 + _x[13];
				cc = bb + (cc << 7 | cc >>> 25);
				ee = ee << 10 | ee >>> 22;
				bb += (cc ^ (dd | ~ee)) + 1352829926 + _x[6];
				bb = aa + (bb << 7 | bb >>> 25);
				dd = dd << 10 | dd >>> 22;
				aa += (bb ^ (cc | ~dd)) + 1352829926 + _x[15];
				aa = ee + (aa << 8 | aa >>> 24);
				cc = cc << 10 | cc >>> 22;
				ee += (aa ^ (bb | ~cc)) + 1352829926 + _x[8];
				ee = dd + (ee << 11 | ee >>> 21);
				bb = bb << 10 | bb >>> 22;
				dd += (ee ^ (aa | ~bb)) + 1352829926 + _x[1];
				dd = cc + (dd << 14 | dd >>> 18);
				aa = aa << 10 | aa >>> 22;
				cc += (dd ^ (ee | ~aa)) + 1352829926 + _x[10];
				cc = bb + (cc << 14 | cc >>> 18);
				ee = ee << 10 | ee >>> 22;
				bb += (cc ^ (dd | ~ee)) + 1352829926 + _x[3];
				bb = aa + (bb << 12 | bb >>> 20);
				dd = dd << 10 | dd >>> 22;
				aa += (bb ^ (cc | ~dd)) + 1352829926 + _x[12];
				aa = ee + (aa << 6 | aa >>> 26);
				cc = cc << 10 | cc >>> 22;
				ee += (aa & cc | bb & ~cc) + 1548603684 + _x[6];
				ee = dd + (ee << 9 | ee >>> 23);
				bb = bb << 10 | bb >>> 22;
				dd += (ee & bb | aa & ~bb) + 1548603684 + _x[11];
				dd = cc + (dd << 13 | dd >>> 19);
				aa = aa << 10 | aa >>> 22;
				cc += (dd & aa | ee & ~aa) + 1548603684 + _x[3];
				cc = bb + (cc << 15 | cc >>> 17);
				ee = ee << 10 | ee >>> 22;
				bb += (cc & ee | dd & ~ee) + 1548603684 + _x[7];
				bb = aa + (bb << 7 | bb >>> 25);
				dd = dd << 10 | dd >>> 22;
				aa += (bb & dd | cc & ~dd) + 1548603684 + _x[0];
				aa = ee + (aa << 12 | aa >>> 20);
				cc = cc << 10 | cc >>> 22;
				ee += (aa & cc | bb & ~cc) + 1548603684 + _x[13];
				ee = dd + (ee << 8 | ee >>> 24);
				bb = bb << 10 | bb >>> 22;
				dd += (ee & bb | aa & ~bb) + 1548603684 + _x[5];
				dd = cc + (dd << 9 | dd >>> 23);
				aa = aa << 10 | aa >>> 22;
				cc += (dd & aa | ee & ~aa) + 1548603684 + _x[10];
				cc = bb + (cc << 11 | cc >>> 21);
				ee = ee << 10 | ee >>> 22;
				bb += (cc & ee | dd & ~ee) + 1548603684 + _x[14];
				bb = aa + (bb << 7 | bb >>> 25);
				dd = dd << 10 | dd >>> 22;
				aa += (bb & dd | cc & ~dd) + 1548603684 + _x[15];
				aa = ee + (aa << 7 | aa >>> 25);
				cc = cc << 10 | cc >>> 22;
				ee += (aa & cc | bb & ~cc) + 1548603684 + _x[8];
				ee = dd + (ee << 12 | ee >>> 20);
				bb = bb << 10 | bb >>> 22;
				dd += (ee & bb | aa & ~bb) + 1548603684 + _x[12];
				dd = cc + (dd << 7 | dd >>> 25);
				aa = aa << 10 | aa >>> 22;
				cc += (dd & aa | ee & ~aa) + 1548603684 + _x[4];
				cc = bb + (cc << 6 | cc >>> 26);
				ee = ee << 10 | ee >>> 22;
				bb += (cc & ee | dd & ~ee) + 1548603684 + _x[9];
				bb = aa + (bb << 15 | bb >>> 17);
				dd = dd << 10 | dd >>> 22;
				aa += (bb & dd | cc & ~dd) + 1548603684 + _x[1];
				aa = ee + (aa << 13 | aa >>> 19);
				cc = cc << 10 | cc >>> 22;
				ee += (aa & cc | bb & ~cc) + 1548603684 + _x[2];
				ee = dd + (ee << 11 | ee >>> 21);
				bb = bb << 10 | bb >>> 22;
				dd += ((ee | ~aa) ^ bb) + 1836072691 + _x[15];
				dd = cc + (dd << 9 | dd >>> 23);
				aa = aa << 10 | aa >>> 22;
				cc += ((dd | ~ee) ^ aa) + 1836072691 + _x[5];
				cc = bb + (cc << 7 | cc >>> 25);
				ee = ee << 10 | ee >>> 22;
				bb += ((cc | ~dd) ^ ee) + 1836072691 + _x[1];
				bb = aa + (bb << 15 | bb >>> 17);
				dd = dd << 10 | dd >>> 22;
				aa += ((bb | ~cc) ^ dd) + 1836072691 + _x[3];
				aa = ee + (aa << 11 | aa >>> 21);
				cc = cc << 10 | cc >>> 22;
				ee += ((aa | ~bb) ^ cc) + 1836072691 + _x[7];
				ee = dd + (ee << 8 | ee >>> 24);
				bb = bb << 10 | bb >>> 22;
				dd += ((ee | ~aa) ^ bb) + 1836072691 + _x[14];
				dd = cc + (dd << 6 | dd >>> 26);
				aa = aa << 10 | aa >>> 22;
				cc += ((dd | ~ee) ^ aa) + 1836072691 + _x[6];
				cc = bb + (cc << 6 | cc >>> 26);
				ee = ee << 10 | ee >>> 22;
				bb += ((cc | ~dd) ^ ee) + 1836072691 + _x[9];
				bb = aa + (bb << 14 | bb >>> 18);
				dd = dd << 10 | dd >>> 22;
				aa += ((bb | ~cc) ^ dd) + 1836072691 + _x[11];
				aa = ee + (aa << 12 | aa >>> 20);
				cc = cc << 10 | cc >>> 22;
				ee += ((aa | ~bb) ^ cc) + 1836072691 + _x[8];
				ee = dd + (ee << 13 | ee >>> 19);
				bb = bb << 10 | bb >>> 22;
				dd += ((ee | ~aa) ^ bb) + 1836072691 + _x[12];
				dd = cc + (dd << 5 | dd >>> 27);
				aa = aa << 10 | aa >>> 22;
				cc += ((dd | ~ee) ^ aa) + 1836072691 + _x[2];
				cc = bb + (cc << 14 | cc >>> 18);
				ee = ee << 10 | ee >>> 22;
				bb += ((cc | ~dd) ^ ee) + 1836072691 + _x[10];
				bb = aa + (bb << 13 | bb >>> 19);
				dd = dd << 10 | dd >>> 22;
				aa += ((bb | ~cc) ^ dd) + 1836072691 + _x[0];
				aa = ee + (aa << 13 | aa >>> 19);
				cc = cc << 10 | cc >>> 22;
				ee += ((aa | ~bb) ^ cc) + 1836072691 + _x[4];
				ee = dd + (ee << 7 | ee >>> 25);
				bb = bb << 10 | bb >>> 22;
				dd += ((ee | ~aa) ^ bb) + 1836072691 + _x[13];
				dd = cc + (dd << 5 | dd >>> 27);
				aa = aa << 10 | aa >>> 22;
				cc += (dd & ee | ~dd & aa) + 2053994217 + _x[8];
				cc = bb + (cc << 15 | cc >>> 17);
				ee = ee << 10 | ee >>> 22;
				bb += (cc & dd | ~cc & ee) + 2053994217 + _x[6];
				bb = aa + (bb << 5 | bb >>> 27);
				dd = dd << 10 | dd >>> 22;
				aa += (bb & cc | ~bb & dd) + 2053994217 + _x[4];
				aa = ee + (aa << 8 | aa >>> 24);
				cc = cc << 10 | cc >>> 22;
				ee += (aa & bb | ~aa & cc) + 2053994217 + _x[1];
				ee = dd + (ee << 11 | ee >>> 21);
				bb = bb << 10 | bb >>> 22;
				dd += (ee & aa | ~ee & bb) + 2053994217 + _x[3];
				dd = cc + (dd << 14 | dd >>> 18);
				aa = aa << 10 | aa >>> 22;
				cc += (dd & ee | ~dd & aa) + 2053994217 + _x[11];
				cc = bb + (cc << 14 | cc >>> 18);
				ee = ee << 10 | ee >>> 22;
				bb += (cc & dd | ~cc & ee) + 2053994217 + _x[15];
				bb = aa + (bb << 6 | bb >>> 26);
				dd = dd << 10 | dd >>> 22;
				aa += (bb & cc | ~bb & dd) + 2053994217 + _x[0];
				aa = ee + (aa << 14 | aa >>> 18);
				cc = cc << 10 | cc >>> 22;
				ee += (aa & bb | ~aa & cc) + 2053994217 + _x[5];
				ee = dd + (ee << 6 | ee >>> 26);
				bb = bb << 10 | bb >>> 22;
				dd += (ee & aa | ~ee & bb) + 2053994217 + _x[12];
				dd = cc + (dd << 9 | dd >>> 23);
				aa = aa << 10 | aa >>> 22;
				cc += (dd & ee | ~dd & aa) + 2053994217 + _x[2];
				cc = bb + (cc << 12 | cc >>> 20);
				ee = ee << 10 | ee >>> 22;
				bb += (cc & dd | ~cc & ee) + 2053994217 + _x[13];
				bb = aa + (bb << 9 | bb >>> 23);
				dd = dd << 10 | dd >>> 22;
				aa += (bb & cc | ~bb & dd) + 2053994217 + _x[9];
				aa = ee + (aa << 12 | aa >>> 20);
				cc = cc << 10 | cc >>> 22;
				ee += (aa & bb | ~aa & cc) + 2053994217 + _x[7];
				ee = dd + (ee << 5 | ee >>> 27);
				bb = bb << 10 | bb >>> 22;
				dd += (ee & aa | ~ee & bb) + 2053994217 + _x[10];
				dd = cc + (dd << 15 | dd >>> 17);
				aa = aa << 10 | aa >>> 22;
				cc += (dd & ee | ~dd & aa) + 2053994217 + _x[14];
				cc = bb + (cc << 8 | cc >>> 24);
				ee = ee << 10 | ee >>> 22;
				bb += (cc ^ dd ^ ee) + _x[12];
				bb = aa + (bb << 8 | bb >>> 24);
				dd = dd << 10 | dd >>> 22;
				aa += (bb ^ cc ^ dd) + _x[15];
				aa = ee + (aa << 5 | aa >>> 27);
				cc = cc << 10 | cc >>> 22;
				ee += (aa ^ bb ^ cc) + _x[10];
				ee = dd + (ee << 12 | ee >>> 20);
				bb = bb << 10 | bb >>> 22;
				dd += (ee ^ aa ^ bb) + _x[4];
				dd = cc + (dd << 9 | dd >>> 23);
				aa = aa << 10 | aa >>> 22;
				cc += (dd ^ ee ^ aa) + _x[1];
				cc = bb + (cc << 12 | cc >>> 20);
				ee = ee << 10 | ee >>> 22;
				bb += (cc ^ dd ^ ee) + _x[5];
				bb = aa + (bb << 5 | bb >>> 27);
				dd = dd << 10 | dd >>> 22;
				aa += (bb ^ cc ^ dd) + _x[8];
				aa = ee + (aa << 14 | aa >>> 18);
				cc = cc << 10 | cc >>> 22;
				ee += (aa ^ bb ^ cc) + _x[7];
				ee = dd + (ee << 6 | ee >>> 26);
				bb = bb << 10 | bb >>> 22;
				dd += (ee ^ aa ^ bb) + _x[6];
				dd = cc + (dd << 8 | dd >>> 24);
				aa = aa << 10 | aa >>> 22;
				cc += (dd ^ ee ^ aa) + _x[2];
				cc = bb + (cc << 13 | cc >>> 19);
				ee = ee << 10 | ee >>> 22;
				bb += (cc ^ dd ^ ee) + _x[13];
				bb = aa + (bb << 6 | bb >>> 26);
				dd = dd << 10 | dd >>> 22;
				aa += (bb ^ cc ^ dd) + _x[14];
				aa = ee + (aa << 5 | aa >>> 27);
				cc = cc << 10 | cc >>> 22;
				ee += (aa ^ bb ^ cc) + _x[0];
				ee = dd + (ee << 15 | ee >>> 17);
				bb = bb << 10 | bb >>> 22;
				dd += (ee ^ aa ^ bb) + _x[3];
				dd = cc + (dd << 13 | dd >>> 19);
				aa = aa << 10 | aa >>> 22;
				cc += (dd ^ ee ^ aa) + _x[9];
				cc = bb + (cc << 11 | cc >>> 21);
				ee = ee << 10 | ee >>> 22;
				bb += (cc ^ dd ^ ee) + _x[11];
				bb = aa + (bb << 11 | bb >>> 21);
				dd = dd << 10 | dd >>> 22;
				dd += c + _md160State[1];
				
				_md160State[1] = _md160State[2] + d + ee;
				_md160State[2] = _md160State[3] + e + aa;
				_md160State[3] = _md160State[4] + a + bb;
				_md160State[4] = _md160State[0] + b + cc;
				_md160State[0] = dd;
			}
			
			var bytesAvailable:int = _buffer.bytesAvailable;
			
			_buffer.readBytes(_buffer, 0, bytesAvailable);
			
			_buffer.length = bytesAvailable;
			_buffer.position = 0;
		}
	}
}