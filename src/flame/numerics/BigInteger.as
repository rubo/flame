////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//  Portions Copyright 2003-2005 Tom Wu. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.numerics
{
	import flame.core.flame_internal;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	import mx.utils.StringUtil;
	
	use namespace flame_internal;
	
	[ResourceBundle("flameCore")]
	[ResourceBundle("flameNumerics")]
	
	/**
	 * Represents an arbitrarily large signed integer. This class cannot be inherited.
	 * <p>The BigInteger type is an immutable type that represents an arbitrarily large integer
	 * whose value in theory has no upper or lower bounds.
	 * The members of the BigInteger type closely parallel those of other integral types
	 * (the int, uint, and Number types). This type differs from the other integral types in the ActionScript,
	 * which have a range indicated by their <code>MIN_VALUE</code> and <code>MAX_VALUE</code> properties.</p>
	 * <p>The BigInteger class provides a rich set of methods for performing mathematical operations.
	 * This includes <code>add()</code>, <code>divide()</code>, <code>multiply()</code>, <code>negate()</code>,
	 * <code>subtract()</code> methods, and several others.</p>
	 * <p>Many members of the BigInteger class correspond directly to members of the other integral types.
	 * In addition, BigInteger adds members such as the following:<ul>
	 * <li><code>sign</code> property, which returns a value that indicates the sign of a BigInteger value.</li>
	 * <li><code>abs()</code> method, which returns the absolute value of a BigInteger value.</li>
	 * <li><code>divRem()</code> method, which returns both the quotient and remainder of a division operation.</li>
	 * <li><code>greatestCommonDivisor()</code> method, which returns the greatest common divisor
	 * of two BigInteger values.</li>
	 * </ul></p>
	 * <p>Many of these additional members correspond to the members of the Math class,
	 * which provides the functionality to work with the primitive numeric types.</p>
	 * <p><em>Note:</em> The other numeric types in the ActionScript are also immutable.
	 * However, because the BigInteger type has no upper or lower bounds,
	 * its values can grow extremely large and have a measurable impact on performance.</p>
	 * <p>If you convert BigInteger values to byte arrays, or if you convert byte arrays to BigInteger values,
	 * you must consider the order of bytes. The BigInteger class expects the individual bytes in a byte array
	 * to appear in big-endian order (that is, the higher-order bytes of the value precede the lower-order bytes).
	 * You can round-trip a BigInteger value by calling the <code>toByteArray()</code> method
	 * and then passing the resulting byte array to the <code>BigInteger()</code> constructor.</p>
	 * <p>To instantiate a BigInteger value from a byte array that represents a value of some other integral type,
	 * you can pass the integral value to the ByteArray, and then pass the resulting byte array
	 * to the <code>BigInteger()</code> constructor.</p>
	 * <p>The BigInteger class assumes that negative values are stored by using two's complement representation.
	 * Because the BigInteger class represents a numeric value with no fixed length,
	 * the <code>BigInteger()</code> constructor always interprets the most significant bit
	 * of the first byte in the array as a sign bit. To prevent the <code>BigInteger()</code> constructor
	 * from confusing the two's complement representation of a negative value
	 * with the sign-and-magnitude representation of a positive value,
	 * positive values in which the most significant bit of the first byte in the byte array
	 * would ordinarily be set should include an additional byte whose value is 0.
	 * For example, FF F0 BD C0 is the big-endian hexadecimal representation of either -1,000,000 or 4,293,967,296.
	 * Because the most significant bit of the first byte in this array is on, the value of the byte array
	 * would be interpreted by the <code>BigInteger()</code> constructor as -1,000,000.
	 * To instantiate a BigInteger whose value is positive, a byte array whose elements are 00 FF F0 BD C0
	 * must be passed to the constructor. To avoid manually adding a zero-value byte,
	 * you may use the <code>unsigned</code> parameter of the <code>BigInteger()</code> constructor.</p>
	 * <p>Byte arrays created by the <code>toByteArray()</code> method from positive values
	 * include an extra zero-value byte. Therefore, the BigInteger class can successfully round-trip values
	 * by assigning them to, and then restoring them from, byte arrays.</p>
	 * <p>However, you may need to add this additional zero-value byte to byte arrays
	 * that are created dynamically by the developer or that are returned by methods
	 * that convert unsigned integers to byte arrays (such as <code>ByteArray.writeUnsignedInt()</code>).</p>
	 */
	public final class BigInteger
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Gets a value that represents the number negative one (-1). 
		 */
		public static const MINUS_ONE:BigInteger = new BigInteger(-1);
		
		/**
		 * Gets a value that represents the number one (1). 
		 */
		public static const ONE:BigInteger = new BigInteger(1);
		
		/**
		 * Gets a value that represents the number zero (0). 
		 */
		public static const ZERO:BigInteger = new BigInteger(0);
		
		private static const _hexPattern:RegExp = /^\-?0x/i;
		private static const _legalParsePattern:RegExp = /^\-?(0x)?[0-9a-z]+$/i;
		private static const _lowPrimes:Vector.<int> = new <int>[ 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499, 503, 509 ];
		private static var _resourceManager:IResourceManager = ResourceManager.getInstance();
		
		/**
		 * @private
		 */
		internal var _bits:Vector.<int> = new Vector.<int>();
		
		/**
		 * @private
		 */
		internal var _length:int;
		
		/**
		 * @private
		 */
		internal var _sign:int;
		
		//--------------------------------------------------------------------------
		//
		//  Static constructor
		//
		//--------------------------------------------------------------------------
		
		{
			_lowPrimes.fixed = true;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the BigInteger class.
		 * <p>If the <code>value</code> parameter is ByteArray,
		 * the individual bytes in the <code>value</code> parameter should be in big-endian order,
		 * from highest-order byte to lowest-order byte.
		 * For example, the numeric value 1,000,000,000,000 is represented as shown in the following table:</p>
		 * <p><table class="innertable">
		 * <tr><td>Hexadecimal string</td><td>E8D4A51000</td></tr>
		 * <tr><td>Byte array (highest index first)</td><td>00 E8 D4 A5 10 00</td></tr>
		 * </table></p>
		 * <p>The constructor expects positive values in the byte array to use sign-and-magnitude representation,
		 * and negative values to use two's complement representation. In other words,
		 * if the highest-order bit of the highest-order byte in <code>value</code> is set,
		 * the resulting BigInteger value is negative. Depending on the source of the byte array,
		 * this may cause a positive value to be misinterpreted as a negative value.
		 * Byte arrays are typically generated in the following ways:<ul>
		 * <li>By calling the <code>BigInteger.toByteArray()</code> method.
		 * Because this method returns a byte array with the highest-order bit of the highest-order byte
		 * in the array set to zero for positive values, there is no chance of misinterpreting a positive value as negative.
		 * Unmodified byte arrays created by the <code>toByteArray()</code> method always successfully round-trip
		 * when they are passed to the <code>BigInteger()</code> constructor.</li>
		 * <li>By calling the <code>ByteArray.writeInt()</code> method and passing it a signed integer as a parameter.
		 * Because signed integers handle both sign-and-magnitude representation and two's complement representation,
		 * there is no chance of misinterpreting a positive value as negative.</li>
		 * <li>By calling the <code>ByteArray.writeUnsignedInt()</code> method
		 * and passing it an unsigned integer as a parameter.
		 * Because unsigned integers are represented by their magnitude only,
		 * positive values can be misinterpreted as negative values.
		 * To prevent this misinterpretation, you can add a zero-byte value to the beginning of the array
		 * either manually or by setting the <code>unsigned</code> parameter to <code>true</code>.</li>
		 * <li>By creating a byte array either dynamically or statically
		 * without necessarily calling any of the previous methods, or by modifying an existing byte array.
		 * To prevent positive values from being misinterpreted as negative values,
		 * you can add a zero-byte value to the beginning of the array either manually
		 * or by setting the <code>unsigned</code> parameter to <code>true</code>.</li>
		 * </ul></p>
		 * <p>If <code>value</code> parameter is an empty ByteArray,
		 * the new BigInteger object is initialized to a value of <code>BigInteger.ZERO</code>.</p>
		 * 
		 * @param value The value to use to create the BigInteger.
		 * This parameter can accept a String, a ByteArray, or an int.
		 * 
		 * @param unsigned Indicates whether to use the most significant bit of the first byte
		 * as a sign bit. If <code>true</code>, the BigInteger is unsigned; otherwise, signed.
		 * This paramater is used only when the <code>value</code> parameter type is ByteArray.
		 * 
		 * @throws ArgumentError Thrown in the following situations:<ul>
		 * <li><code>value</code> parameter is <code>null</code>.</li>
		 * <li><code>value</code> parameter is not in the correct format.</li>
		 * </ul>
		 * 
		 * @throws TypeError <code>value</code> paramater has an invalid type.
		 * 
		 * @see #toByteArray() toByteArray()
		 * @see flash.utils.ByteArray
		 */
		public function BigInteger(value:*, unsigned:Boolean = false)
		{
			super();
			
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
			if (value is ByteArray)
			{
				if (value.length == 0)
					setBitsFromInt(0);
				else
					setBitsFromByteArray(value, unsigned);
			}
			else if (value is int)
				setBitsFromInt(value);
			else if (value is String)
			{
				value = StringUtil.trim(value);
				
				if (!_legalParsePattern.test(value))
					throw new ArgumentError(_resourceManager.getString("flameNumerics", "argInvalidBigIntegerFormat"));
				
				setBitsFromString(value, getDefaultRadix(value));
			}
			else
				throw new TypeError(_resourceManager.getString("flameCore", "argInvalidValue", [ "value" ]));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Gets the absolute value of this instance.
		 * <p>The absolute value of a number is that number without its sign,
		 * as shown in the following table.</p>
		 * <p><table class="innertable">
		 * <tr><th>value</th><th>Return value</th></tr>
		 * <tr><td>value &#62;= 0</td><td>value</td></tr>
		 * <tr><td>value &#60; 0</td><td>value ~~ -1</td></tr>
		 * </table></p>
		 * 
		 * @return The absolute value of this instance.
		 */
		public function abs():BigInteger
		{
			return _sign < 0 ? negate() : this;
		}
		
		/**
		 * Adds the specified BigInteger to this instance and returns the result.
		 * 
		 * @param value The value to add.
		 * 
		 * @return The sum of the addition.
		 * 
		 * @throws ArgumentError <code>value</code> parameter is <code>null</code>.
		 */
		public function add(value:BigInteger):BigInteger
		{
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
			var result:BigInteger = new BigInteger(0);
			
			addTo(value, result);
			
			return result;
		}
		
		/**
		 * Performs a bitwise And operation on this instance and the specified BigInteger.
		 * <p>The bitwise And operation sets a result bit only if the corresponding bits
		 * in the values of this instance and <code>value</code> parameter are also set,
		 * as shown in the following table.</p>
		 * <p><table class="innertable">
		 * <tr><th>Bits in <code>this</code></th><th>Bits in <code>value</code></th><th>Bits in result</th></tr>
		 * <tr><td>0</td><td>0</td><td>0</td></tr>
		 * <tr><td>1</td><td>0</td><td>0</td></tr>
		 * <tr><td>1</td><td>1</td><td>1</td></tr>
		 * <tr><td>0</td><td>1</td><td>0</td></tr>
		 * </table></p>
		 *  
		 * @param value The value to perform a bitwise And operation on.
		 * 
		 * @return The result of the bitwise And operation.
		 * 
		 * @throws ArgumentError <code>value</code> parameter is <code>null</code>.
		 */
		public function and(value:BigInteger):BigInteger
		{
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
			var count:int;
			var length:int = Math.min(value._length, _length);
			var result:BigInteger = new BigInteger(0);
			var sign:int;
			
			for (var i:int = 0; i < length; i++)
				result._bits[i] = _bits[i] & value._bits[i];
			
			if (value._length < _length)
			{
				sign = value._sign & 0x3FFFFFFF;
				
				count = _length;
				
				for (i = length; i < count; i++)
					result._bits[i] = _bits[i] & sign;
				
				result._length = _length;
			}
			else
			{
				sign = _sign & 0x3FFFFFFF;
				
				count = value._length;
				
				for (i = length; i < count; i++)
					result._bits[i] = sign & value._bits[i];
				
				result._length = value._length;
			}
			
			result._sign = _sign & value._sign;
			
			result.normalize();
			
			return result;
		}
		
		/**
		 * Performs a bitwise And operation on this instance
		 * and the bitwise one's complement of the specified BigInteger.
		 *  
		 * @param value The value to be one's complemented and to perform a bitwise And operation on.
		 * 
		 * @return The result of the bitwise one's complement and the bitwise And operation.
		 * 
		 * @throws ArgumentError <code>value</code> parameter is <code>null</code>.
		 */
		public function andNot(value:BigInteger):BigInteger
		{
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
			var count:int;
			var length:int = Math.min(value._length, _length);
			var result:BigInteger = new BigInteger(0);
			var sign:int;
			
			for (var i:int = 0; i < length; i++)
				result._bits[i] = _bits[i] & ~value._bits[i];
			
			if (value._length < _length)
			{
				sign = value._sign & 0x3FFFFFFF;
				
				count = _length;
				
				for (i = length; i < count; i++)
					result._bits[i] = _bits[i] & ~sign;
				
				result._length = _length;
			}
			else
			{
				sign = _sign & 0x3FFFFFFF;
				
				count = value._length;
				
				for (i = length; i < count; i++)
					result._bits[i] = sign & ~value._bits[i];
				
				result._length = value._length;
			}
			
			result._sign = _sign & ~value._sign;
			
			result.normalize();
			
			return result;
		}
		
		/**
		 * Compares this instance to the specified BigInteger and returns an integer
		 * that indicates whether the value of this instance is less than, equal to, or greater than
		 * the value of the specified BigInteger.
		 * 
		 * @param value The value to compare.
		 * 
		 * @return A signed integer value that indicates the relationship of this instance to <code>value</code> parameter,
		 * as shown in the following table.
		 * <p><table class="innertable">
		 * <tr><th>Return value</th><th>Description</th></tr>
		 * <tr><td>A negative integer</td><td>This instance is less than <code>value</code> parameter.</td></tr>
		 * <tr><td>Zero</td><td>This instance is equal to <code>value</code> parameter.</td></tr>
		 * <tr><td>A positive integer</td><td>This instance is greater than <code>value</code> parameter.</td></tr>
		 * </table></p>
		 * 
		 * @throws ArgumentError <code>value</code> parameter is <code>null</code>.
		 */
		public function compareTo(value:BigInteger):int
		{
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
			if (_sign < value._sign)
				return -1;
			
			if (_sign > value._sign)
				return 1;
			
			if (_length < value._length)
				return -1;
			
			if (_length > value._length)
				return 1;
			
			var bits1:Vector.<int> = _bits;
			var bits2:Vector.<int> = value._bits;
			
			for (var i:int = _length - 1; i >= 0; i--)
				if (bits1[i] != bits2[i])
					return bits1[i] < bits2[i] ? -1 : 1;
			
			return 0;
		}
		
		/**
		 * Divides this instance by the specified BigInteger and returns the result.
		 * 
		 * @param value The value to divide by.
		 * 
		 * @return The quotient of the division.
		 * 
		 * @throws ArgumentError Thrown in the following situations:<ul>
		 * <li><code>value</code> parameter is <code>null</code>.</li>
		 * <li><code>value</code> parameter is 0 (zero).</li>
		 * </ul>
		 */
		public function divide(value:BigInteger):BigInteger
		{
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
			if (value.isZero)
				throw new ArgumentError(_resourceManager.getString("flameNumerics", "argDivideByZero"));
			
			var result:BigInteger = new BigInteger(0);
			
			divRemTo(value, result, null);
			
			return result;
		}
		
		/**
		 * Divides this instance by the specified BigInteger, returns the result and the remainder from the division.
		 * <p>This method preserves both the quotient and the remainder that results from integer division.
		 * If you are not interested in the remainder, use the <code>divide()</code> method;
		 * if you are only interested in the remainder, use the <code>remainder()</code> method.</p>
		 * <p>The sign of the returned remainder value is the same as the sign of this instance.</p>
		 * 
		 * @param divisor The value to divide by.
		 * 
		 * @return A Vector of two BigIntegers containing the quotient of the division as the first element
		 * and the remainder from the division as the last element.
		 * 
		 * @throws ArgumentError Thrown in the following situations:<ul>
		 * <li><code>divisor</code> parameter is <code>null</code>.</li>
		 * <li><code>divisor</code> parameter is 0 (zero).</li>
		 * </ul>
		 * 
		 * @see #divide() divide()
		 * @see #remainder() remainder()
		 */
		public function divRem(divisor:BigInteger):Vector.<BigInteger>
		{
			if (divisor == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "divisor" ]));
			
			if (divisor.isZero)
				throw new ArgumentError(_resourceManager.getString("flameNumerics", "argDivideByZero"));
			
			var quotient:BigInteger = new BigInteger(0);
			var remainder:BigInteger = new BigInteger(0);
			
			divRemTo(divisor, quotient, remainder);
			
			return new <BigInteger>[ quotient, remainder ];
		}
		
		/**
		 * Returns a value that indicates whether this instance and the specified BigInteger have the same value.
		 * <p>To determine the relationship between the two BigInteger objects
		 * instead of just testing for equality, use the <code>compareTo()</code> method.</p>
		 * 
		 * @param value The value to compare.
		 * 
		 * @return <code>true</code> if this instance and <code>value</code> parameter have the same value;
		 * otherwise, <code>false</code>.
		 * 
		 * @throws ArgumentError <code>value</code> parameter is <code>null</code>.
		 * 
		 * @see #compareTo() compareTo()
		 */
		public function equals(value:BigInteger):Boolean
		{
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
			return compareTo(value) == 0;
		}
		
		/**
		 * Finds the greatest common divisor of this instance and the specified BigInteger.
		 * <p>The greatest common divisor is the largest number into which
		 * the two BigInteger values can be divided without returning a remainder.</p>
		 * <p>If the values of this instance and <code>value</code> parameter are non-zero numbers,
		 * the method always returns at least a value of 1 because all numbers can be divided by 1.
		 * If either value is zero, the method returns the absolute value of the non-zero value.
		 * If both values are zero, the method returns zero.</p>
		 * <p><em>Note:</em> Computing the greatest common divisor of very large values of this instance
		 * and <code>value</code> parameter can be a very time-consuming operation.</p>
		 * <p>The value returned by this method is always positive
		 * regardless of the sign of this instance and <code>value</code> parameter.</p>
		 *  
		 * @param value The value the greatest common divisor to be found with.
		 * 
		 * @return The greatest common divisor of this instance and <code>value</code> parameter.
		 * 
		 * @throws ArgumentError <code>value</code> parameter is <code>null</code>.
		 */
		public function greatestCommonDivisor(value:BigInteger):BigInteger
		{
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
			var x:BigInteger = _sign < 0 ? negate() : valueOf();
			var y:BigInteger = value._sign < 0 ? value.negate() : value.valueOf();
			
			if (x.compareTo(y) < 0)
			{
				var t:BigInteger = x;
				x = y;
				y = t;
			}
			
			var i:int = x.lowestSetBit;
			var j:int = y.lowestSetBit;
			
			if (j < 0)
				return x;
			
			if (i < j)
				j = i;
			
			if (j > 0)
			{
				x.shiftRightTo(j, x);
				y.shiftRightTo(j, y);
			}
			
			while (x.sign > 0)
			{
				if ((i = x.lowestSetBit) > 0)
					x.shiftRightTo(i, x);
				
				if ((i = y.lowestSetBit) > 0)
					y.shiftRightTo(i, y);
				
				if (x.compareTo(y) >= 0)
				{
					x.subTo(y, x);
					x.shiftRightTo(1, x);
				}
				else
				{
					y.subTo(x, y);
					y.shiftRightTo(1, y);
				}
			}
			
			if (j > 0)
				y.shiftLeftTo(j, y);
			
			return y;
		}
		
		/**
		 * Returns the logarithm of a specified number in a specified base.
		 * <p>The <code>value</code> and <code>base</code> parameters are specified as base 10 numbers.
		 * The precise return value of the method depends on the sign of <code>value</code>
		 * and on the sign and value of <code>base</code>, as the following table shows.</p>
		 * <p><table class="innertable">
		 * <tr><th><code>value</code> parameter</th><th><code>base</code> parameter</th><th>Return value</th></tr>
		 * <tr><td><code>value</code> &#62; 0</td><td>(0 &#60; <code>base</code> &#60; 1) or (<code>base</code> &#62; 1)</td><td>log<sub><code>base</code></sub>(<code>value</code>)</td></tr>
		 * <tr><td><code>value</code> &#60; 0</td><td>(any value)</td><td>Number.NaN</td></tr>
		 * <tr><td>(any value)</td><td><code>base</code> &#60; 0</td><td>Number.NaN</td></tr>
		 * <tr><td><code>value</code> != 1</td><td><code>base</code> = 0</td><td>Number.NaN</td></tr>
		 * <tr><td><code>value</code> != 1</td><td><code>base</code> = Number.POSITIVE_INFINITY</td><td>Number.NaN</td></tr>
		 * <tr><td>(any value)</td><td><code>base</code> = Number.NaN</td><td>Number.NaN</td></tr>
		 * <tr><td>(any value)</td><td><code>base</code> = 1</td><td>Number.NaN</td></tr>
		 * <tr><td><code>value</code> = 0</td><td>(0 &#60; <code>base</code> &#60; 1) or (<code>base</code> &#62; 1)</td><td>Number.POSITIVE_INFINITY</td></tr>
		 * <tr><td><code>value</code> = 1</td><td><code>base</code> = 0</td><td>0</td></tr>
		 * <tr><td><code>value</code> = 1</td><td><code>base</code> = Number.POSITIVE_INFINITY</td><td>0</td></tr>
		 * </table></p>
		 * <p>This method corresponds to the <code>Math.log()</code> method for the primitive numeric types.</p>
		 * 
		 * @param value A number whose logarithm is to be found.
		 * 
		 * @param base The base of the logarithm.
		 * 
		 * @return The base <code>base</code> logarithm of <code>value</code>, as shown in the table above.
		 * 
		 * @throws ArgumentError <code>value</code> parameter is <code>null</code>.
		 * 
		 * @see Math.E
		 * @see Math.log()
		 */
		public static function log(value:BigInteger, base:Number = Math.E):Number
		{
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
			if (value._sign < 0 || base == 1)
				return Number.NaN;
			
			if (base == Number.POSITIVE_INFINITY)
			{
				if (!value.isOne)
					return Number.NaN;
				
				return 0;
			}
			
			if (base == 0 && !value.isOne)
				return Number.NaN;
			
			var x:Number = 0;
			var t:Number = .5;
			var length:int = value._length - 1;
			var bl:int = getBitLength(value._bits[length]);
			var mask:int =  1 << bl - 1;
			
			for (var i:int = length; i >= 0; i--)
			{
				while (mask != 0)
				{
					if ((value._bits[i] & mask) != 0)
						x += t;
					
					t *= .5;
					mask >>>= 1;
				}
				
				mask = 0x20000000;
			}
			
			return (Math.log(x) + Math.LN2 * (length * 30 + bl)) / Math.log(base);
		}
		
		/**
		 * Returns the larger of two BigInteger values.
		 *  
		 * @param value1 The first value to compare.
		 * 
		 * @param value2 The second value to compare.
		 * 
		 * @return The <code>value1</code> or <code>value2</code> parameter, whichever is larger.
		 * 
		 * @throws ArgumentError Thrown in the following situations:<ul>
		 * <li><code>value1</code> parameter is <code>null</code>.</li>
		 * <li><code>value2</code> parameter is <code>null</code>.</li>
		 * </ul>
		 */
		public static function max(value1:BigInteger, value2:BigInteger):BigInteger
		{
			if (value1 == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value1" ]));
			
			if (value2 == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value2" ]));
			
			return value1.compareTo(value2) > 0 ? value1 : value2;
		}
		
		/**
		 * Returns the smaller of two BigInteger values.
		 *  
		 * @param value1 The first value to compare.
		 * 
		 * @param value2 The second value to compare.
		 * 
		 * @return The <code>value1</code> or <code>value2</code> parameter, whichever is smaller.
		 * 
		 * @throws ArgumentError Thrown in the following situations:<ul>
		 * <li><code>value1</code> parameter is <code>null</code>.</li>
		 * <li><code>value2</code> parameter is <code>null</code>.</li>
		 * </ul>
		 */
		public static function min(value1:BigInteger, value2:BigInteger):BigInteger
		{
			if (value1 == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value1" ]));
			
			if (value2 == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value2" ]));
			
			return value1.compareTo(value2) < 0 ? value1 : value2;
		}
		
		/**
		 * Returns the remainder that results from division of this instance by the specified BigInteger.
		 * <p>The sign of the value returned by this method depends on the sign of this the value of instance:
		 * If the value of this instance is positive, this method returns a positive result;
		 * if it is negative, this method returns a negative result.</p>
		 *  
		 * @param value The value to divide by.
		 * 
		 * @return The reminder of the division.
		 * 
		 * @throws ArgumentError Thrown in the following situations:<ul>
		 * <li><code>value</code> parameter is <code>null</code>.</li>
		 * <li><code>value</code> parameter is 0 (zero).</li>
		 * </ul>
		 */
		public function mod(value:BigInteger):BigInteger
		{
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
			if (value.isZero)
				throw new ArgumentError(_resourceManager.getString("flameNumerics", "argDivideByZero"));
			
			var result:BigInteger = new BigInteger(0);
			
			abs().divRemTo(value, null, result);
			
			if (_sign < 0 && result.compareTo(ZERO) > 0)
				value.subTo(result, result);
			
			return result;
		}
		
		/**
		 * Performs modulus division on this instance raised to the power of the specified BigInteger.
		 *  
		 * @param exponent The exponent to raise this instance by.
		 * 
		 * @param modulus The value to divide <code>this<sup>exponent</sup></code> by.
		 * 
		 * @return The remainder after dividing <code>this<sup>exponent</sup></code> by modulus.
		 * 
		 * @throws ArgumentError Thrown in the following situations:<ul>
		 * <li><code>exponent</code> parameter is <code>null</code>.</li>
		 * <li><code>modulus</code> parameter is <code>null</code>.</li>
		 * <li><code>modulus</code> parameter is 0 (zero).</li>
		 * </ul>
		 * 
		 * @throws RangeError <code>exponent</code> parameter is less than zero.
		 */
		public function modPow(exponent:BigInteger, modulus:BigInteger):BigInteger
		{
			if (exponent == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "exponent" ]));
			
			if (exponent.compareTo(ZERO) < 0)
				throw new RangeError(_resourceManager.getString("flameCore", "argOutOfRangeNonNegative", [ "exponent" ]));
			
			if (modulus == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "modulus" ]));
			
			if (modulus.isZero)
				throw new ArgumentError(_resourceManager.getString("flameNumerics", "argDivideByZero"));
			
			if (exponent.isZero || equals(ONE))
				return modulus.equals(ONE) ? ZERO : ONE;
			
			if (equals(ZERO))
				return ZERO;
			
			var i:int = exponent.bitLength;
			var k:int;
			var remainder:BigInteger = new BigInteger(1);
			var reductionAlgorithm:IReductionAlgorithm;
			
			if (i <= 0)
				return remainder;
			else if (i < 18)
				k = 1;
			else if (i < 48)
				k = 3;
			else if (i < 144)
				k = 4;
			else if (i < 768)
				k = 5;
			else
				k = 6;
			
			if (i < 8)
				reductionAlgorithm = new ClassicReduction(modulus);
			else if (modulus.isEven)
				reductionAlgorithm = new BarrettReduction(modulus);
			else
				reductionAlgorithm = new MontgomeryReduction(modulus);
			
			var collection:Dictionary = new Dictionary(true);
			var n:int = 3;
			var k1:int = k - 1;
			var m:int = (1 << k) - 1;
			
			collection[1] = reductionAlgorithm.convert(this);
			
			if (k > 1)
			{
				var t:BigInteger = new BigInteger(0);
				
				reductionAlgorithm.square(collection[1], t);
				
				while (n <= m)
				{
					collection[n] = new BigInteger(0);
					
					reductionAlgorithm.multiply(t, collection[n - 2], collection[n]);
					
					n += 2;
				}
			}
			
			var j:int = exponent._length - 1;
			var w:int;
			var isOne:Boolean = true;
			var t1:BigInteger = new BigInteger(0);
			var t2:BigInteger;
			
			i = getBitLength(exponent._bits[j]) - 1;
			
			while (j >= 0)
			{
				if (i >= k1)
					w = (exponent._bits[j] >> i - k1) & m;
				else
				{
					w = (exponent._bits[j] & ((1 << i + 1) - 1)) << k1 - i;
					
					if (j > 0)
						w |= exponent._bits[j - 1] >> 30 + i - k1;
				}
				
				n = k;
				
				while ((w & 1) == 0)
				{
					w >>= 1;
					
					n--;
				}
				
				if ((i -= n) < 0)
				{
					i += 30;
					
					j--;
				}
				
				if (isOne)
				{
					collection[w].copyTo(remainder);
					
					isOne = false;
				}
				else
				{
					while (n > 1)
					{
						reductionAlgorithm.square(remainder, t1);
						reductionAlgorithm.square(t1, remainder);
						
						n -= 2;
					}
					
					if (n > 0)
						reductionAlgorithm.square(remainder, t1);
					else
					{
						t2 = remainder;
						remainder = t1;
						t1 = t2;
					}
					
					reductionAlgorithm.multiply(t1, collection[w], remainder);
				}
				
				while (j >= 0 && (exponent._bits[j] & 1 << i) == 0)
				{
					reductionAlgorithm.square(remainder, t1);
					
					t2 = remainder;
					remainder = t1;
					t1 = t2;
					
					if (--i < 0)
					{
						i = 29;
						
						j--;
					}
				}
			}
			
			return reductionAlgorithm.revert(remainder);
		}
		
		/**
		 * Multiplies this instance and the specified BigInteger.
		 * 
		 * @param value The value to multiply.
		 * 
		 * @return The product of the multiplication.
		 * 
		 * @throws ArgumentError <code>value</code> parameter is <code>null</code>.
		 */
		public function multiply(value:BigInteger):BigInteger
		{
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
			var result:BigInteger = new BigInteger(0);
			
			mulTo(value, result);
			
			return result;
		}
		
		/**
		 * Negates the value of this instance.
		 * <p>Negation obtains the additive inverse of a number.
		 * The additive inverse of a number is a number that produces a value of zero
		 * when it is added to the original number.</p>
		 * 
		 * @return The value of this instance multiplied by negative one (-1).
		 */
		public function negate():BigInteger
		{
			var result:BigInteger = new BigInteger(0);
			
			ZERO.subTo(this, result);
			
			return result;
		}
		
		/**
		 * Returns the bitwise one's complement of this instance.
		 * <p>The bitwise one's complement operation reverses each bit in the value of this instance.
		 * That is, bits in value that are 0 are set to 1 in the result,
		 * and bits that are 1 are set to 0 in the result.</p>
		 *  
		 * @return The bitwise one's complement of this instance.
		 */
		public function not():BigInteger
		{
			var result:BigInteger = new BigInteger(0);
			
			for (var i:int = 0, count:int = _length; i < count; i++)
				result._bits[i] = 0x3FFFFFFF & ~_bits[i];
			
			result._length = _length;
			result._sign = ~_sign;
			
			return result;
		}
		
		/**
		 * Performs a bitwise Or operation on this instance and the specified BigInteger.
		 * <p>The bitwise Or operation sets a result bit only if either or both of the corresponding bits
		 * in the values of this instance and <code>value</code> parameter are set,
		 * as shown in the following table.</p>
		 * <p><table class="innertable">
		 * <tr><th>Bits in <code>this</code></th><th>Bits in <code>value</code></th><th>Bits in result</th></tr>
		 * <tr><td>0</td><td>0</td><td>0</td></tr>
		 * <tr><td>1</td><td>0</td><td>1</td></tr>
		 * <tr><td>1</td><td>1</td><td>1</td></tr>
		 * <tr><td>0</td><td>1</td><td>1</td></tr>
		 * </table></p>
		 * 
		 * @param value The value to perform a bitwise Or operation on.
		 * 
		 * @return The result of the bitwise Or operation.
		 * 
		 * @throws ArgumentError <code>value</code> parameter is <code>null</code>.
		 */
		public function or(value:BigInteger):BigInteger
		{
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
			var count:int;
			var length:int = Math.min(value._length, _length);
			var result:BigInteger = new BigInteger(0);
			var sign:int;
			
			for (var i:int = 0; i < length; i++)
				result._bits[i] = _bits[i] | value._bits[i];
			
			if (value._length < _length)
			{
				sign = value._sign & 0x3FFFFFFF;
				
				count = _length;
				
				for (i = length; i < count; i++)
					result._bits[i] = _bits[i] | sign;
				
				result._length = _length;
			}
			else
			{
				sign = _sign & 0x3FFFFFFF;
				
				count = value._length;
				
				for (i = length; i < count; i++)
					result._bits[i] = sign | value._bits[i];
				
				result._length = value._length;
			}
			
			result._sign = _sign | value._sign;
			
			result.normalize();
			
			return result;
		}
		
		/**
		 * Converts the string representation of a number to its BigInteger equivalent.
		 * 
		 * @param value A string that contains the number to convert.
		 * 
		 * @param radix An integer representing the radix (base) of the number to parse.
		 * Legal values are from 2 to 36. This paramater is optional.
		 * 
		 * @return A value that is equivalent to the number specified in the <code>value</code> parameter.
		 * 
		 *  @throws ArgumentError Thrown in the following situations:<ul>
		 * <li><code>value</code> parameter is <code>null</code>.</li>
		 * <li><code>value</code> parameter is not in the correct format.</li>
		 * </ul>
		 * 
		 * @throws RangeError <code>radix</code> parameter is less than 2 or greater than 36.
		 */
		public static function parse(value:String, radix:int = 0):BigInteger
		{
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
			value = StringUtil.trim(value);
			
			if (!_legalParsePattern.test(value))
				throw new ArgumentError(_resourceManager.getString("flameNumerics", "argInvalidBigIntegerFormat"));
			
			if (radix == 0)
				radix = getDefaultRadix(value);
			
			if (radix < 2 || radix > 36)
				throw new RangeError(_resourceManager.getString("flameNumerics", "argInvalidRadix"));
			
			var result:BigInteger = new BigInteger(0);
			
			result.setBitsFromString(value, radix);
			
			return result;
		}
		
		/**
		 * Raises this instance to the power of the specified value and returns the result.
		 * <p>This method returns 1 if the value of the <code>exponent</code> parameter is 0,
		 * or if the values of both this instance and <code>exponent</code> parameter are 0.
		 * If <code>exponent</code> parameter is 1, this method returns this instance.
		 * If this instance is negative, the method returns a negative result.</p>
		 * 
		 * @param exponent The exponent to raise by.
		 * 
		 * @return The value of this instance raised to the power <code>exponent</code>.
		 * 
		 * @throws RangeError <code>exponent</code> parameter is less than zero.
		 */
		public function pow(exponent:int):BigInteger
		{
			return exp(exponent, new NullReduction());
		}
		
		/**
		 * Divides this instance by the specified BigInteger and returns the remainder.
		 * <p>The sign of the remainder is the sign of this instance.</p>
		 * 
		 * @param value The value to divide by.
		 * 
		 * @return The reminder of the division.
		 * 
		 * @throws ArgumentError Thrown in the following situations:<ul>
		 * <li><code>value</code> parameter is <code>null</code>.</li>
		 * <li><code>value</code> parameter is 0 (zero).</li>
		 * </ul>
		 */
		public function remainder(value:BigInteger):BigInteger
		{
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
			if (value.isZero)
				throw new ArgumentError(_resourceManager.getString("flameNumerics", "argDivideByZero"));
			
			var remainder:BigInteger = new BigInteger(0);
			
			divRemTo(value, null, remainder);
			
			return remainder;
		}
		
		/**
		 * Shifts the value of this instance the specified number of bits to the left.
		 * 
		 * @param value The number of bits to shift to the left.
		 * 
		 * @return The value of this instance that has been shifted to the left by the specified number of bits.
		 */
		public function shiftLeft(value:int):BigInteger
		{
			if (isZero)
				return ZERO;
			
			if (value == 0)
				return this;
			
			var result:BigInteger = new BigInteger(0);
			
			if (value < 0)
				shiftRightTo(-value, result);
			else
				shiftLeftTo(value, result);
			
			return result;
		}
		
		/**
		 * Shifts the value of this instance the specified number of bits to the right.
		 * 
		 * @param value The number of bits to shift to the right.
		 * 
		 * @return The value of this instance that has been shifted to the right by the specified number of bits.
		 */
		public function shiftRight(value:int):BigInteger
		{
			if (value == 0)
				return this;
			
			var result:BigInteger = new BigInteger(0);
			
			if (value < 0)
				shiftLeftTo(-value, result);
			else
				shiftRightTo(value, result);
			
			return result;
		}
		
		/**
		 * Subtracts the specified BigInteger from this instance and returns the result.
		 * 
		 * @param value The value to subtract (the subtrahend).
		 * 
		 * @return The result of the subtraction.
		 * 
		 * @throws ArgumentError <code>value</code> parameter is <code>null</code>.
		 */
		public function subtract(value:BigInteger):BigInteger
		{
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
			var diff:BigInteger = new BigInteger(0);
			
			subTo(value, diff);
			
			return diff;
		}
		
		/**
		 * Converts the value of this instance to a byte array.
		 * <p>The individual bytes in the array returned by this method appear in big-endian order.
		 * That is, the higher-order bytes of the value precede the lower-order bytes.
		 * The first byte of the array reflects the first eight bits of the BigInteger value,
		 * the second byte reflects the next eight bits, and so on.
		 * For example, the value 1024, or 0x0400, is stored as the following array of two bytes:</p>
		 * <p><table class="innertable">
		 * <tr><th>Element</th><th>Byte value</th></tr>
		 * <tr><td>0</td><td>0x40</td></tr>
		 * <tr><td>1</td><td>0x00</td></tr>
		 * </table></p>
		 * <p>Negative values are written to the array using two's complement representation.</p>
		 * <p>Because two's complement representation always interprets the highest-order bit
		 * of the first byte in the array as the sign bit, the method returns a byte array
		 * with an extra element whose value is zero to disambiguate positive values
		 * that could otherwise be interpreted as having their sign bits set. For example,
		 * the value 120 or 0x78 is represented as a single-byte array: 0x78.
		 * However, 128, or 0x80, is represented as a two-byte array: 0x00, 0x80.</p>
		 * <p>You can round-trip a BigInteger value by storing it to a byte array
		 * and then restoring it using the BigInteger constructor.</p>
		 * <p><em>Caution:</em> If your code modifies the value of individual bytes in the array
		 * returned by this method before it restores the value, you must make sure
		 * that you do not unintentionally change the sign bit. For example,
		 * if your modifications increase a positive value so that the highest-order bit
		 * in the first element of the byte array becomes set, you can add a new byte
		 * whose value is zero to the beginning of the array.</p>
		 *  
		 * @return The value of the this instance converted to an array of bytes.
		 */
		public function toByteArray():ByteArray
		{
			var i:int = _length;
			var buffer:ByteArray = new ByteArray();
			buffer[0] = _sign;
			
			var byte:int;
			var n:int = 30 - (i * 30) % 8;
			var j:int = 0;
			
			if (i-- > 0)
			{
				if (n < 30 && (byte = _bits[i] >> n) != (_sign & 0x3FFFFFFF) >> n)
					buffer[j++] = byte | _sign << 30 - n;
				
				while (i >= 0)
				{
					if (n < 8)
					{
						byte = (_bits[i] & ((1 << n) - 1)) << 8 - n;
						byte |= _bits[--i] >> (n += 22);
					}
					else
					{
						byte = _bits[i] >> (n -= 8) & 0xFF;
						
						if (n <= 0)
						{
							n += 30;
							i--;
						}
					}
					
					if ((byte & 0x80) != 0)
						byte |= -0x100;
					
					if (j == 0 && (_sign & 0x80) != (byte & 0x80))
						j++;
					
					if (j > 0 || byte != _sign)
						buffer[j++] = byte;
				}
			}
			
			return buffer;
		}
		
		/**
		 * Converts the value of the this instance to its equivalent string representation
		 * by using the specified radix.
		 *  
		 * @param radix An integer representing the radix (base) of the number to parse.
		 * Legal values are from 2 to 36.
		 * 
		 * @return The string representation of this instance in the radix specified by the <code>radix</code> parameter. 
		 */
		public function toString(radix:int = 10):String
		{
			if (_sign < 0)
				return "-" + negate().toString(radix);
			
			var e:int;
			var string:String = "";
			
			switch (radix)
			{
				case 2:
					
					e = 1;
					break;
				
				case 4:
					
					e = 2;
					break;
				
				case 8:
					
					e = 3;
					break;
				
				case 16:
					
					e = 4;
					break;
				
				case 32:
					
					e = 5;
					break;
				
				default:
					
					if (sign == 0 || radix < 2 || radix > 36)
						return "0";
					
					var bitCount:int = getBitCount(radix);
					var p:int = Math.pow(radix, bitCount);
					var x:BigInteger = new BigInteger(p);
					var y:BigInteger = new BigInteger(0);
					var z:BigInteger = new BigInteger(0);
					
					divRemTo(x, y, z);
					
					while (y.sign > 0)
					{
						string = (p + z.toInt()).toString(radix).substr(1) + string;
						
						y.divRemTo(x, y, z);
					}
					
					return z.toInt().toString(radix) + string;
			}
			
			var f:Boolean = false;
			var m:int = (1 << e) - 1;
			var n:int;
			var i:int = _length;
			var s:int = 30 - (i * 30) % e;
			
			if (i-- > 0)
			{
				if (s < 30 && (n = _bits[i] >> s) > 0)
				{
					f = true;
					string = n.toString(36);
				}
				
				while (i >= 0)
				{
					if (s < e)
					{
						n = (_bits[i] & ((1 << s) - 1)) << e - s;
						n |= _bits[--i] >> (s += 30 - e);
					}
					else
					{
						n = (_bits[i] >> (s -= e)) & m;
						
						if (s <= 0)
						{
							s += 30;
							i--;
						}
					}
					
					if (n > 0)
						f = true;
					
					if (f)
						string += n.toString(36);
				}
			}
			
			return f ? string : "0";
		}
		
		/**
		 * Returns a BigInteger whose value is equal to that of this instance.
		 * 
		 * @return A BigInteger with the value of this instance.
		 */
		public function valueOf():BigInteger
		{
			var result:BigInteger = new BigInteger(0);
			
			copyTo(result);
			
			return result;
		}
		
		/**
		 * Performs a bitwise exclusive Or (XOr) operation on this instance and the specified BigInteger.
		 * <p>The result of a bitwise exclusive Or operation is <code>true</code>
		 * if the values of the two bits are different; otherwise, it is <code>false</code>.
		 * The following table illustrates the exclusive Or operation.</p>
		 * <p><table class="innertable">
		 * <tr><th>Bits in <code>this</code></th><th>Bits in <code>value</code></th><th>Bits in result</th></tr>
		 * <tr><td>0</td><td>0</td><td>0</td></tr>
		 * <tr><td>1</td><td>0</td><td>1</td></tr>
		 * <tr><td>1</td><td>1</td><td>0</td></tr>
		 * <tr><td>0</td><td>1</td><td>1</td></tr>
		 * </table></p>
		 *  
		 * @param value The value to perform a bitwise exclusive Or operation on.
		 * 
		 * @return The result of the bitwise exclusive Or operation.
		 * 
		 * @throws ArgumentError <code>value</code> parameter is <code>null</code>.
		 */
		public function xor(value:BigInteger):BigInteger
		{
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
			var count:int;
			var length:int = Math.min(value._length, _length);
			var result:BigInteger = new BigInteger(0);
			var sign:int;
			
			for (var i:int = 0; i < length; i++)
				result._bits[i] = _bits[i] ^ value._bits[i];
			
			if (value._length < _length)
			{
				sign = value._sign & 0x3FFFFFFF;
				
				count = _length;
				
				for (i = length; i < count; i++)
					result._bits[i] = _bits[i] ^ sign;
				
				result._length = _length;
			}
			else
			{
				sign = _sign & 0x3FFFFFFF;
				
				count = value._length;
				
				for (i = length; i < count; i++)
					result._bits[i] = sign ^ value._bits[i];
				
				result._length = value._length;
			}
			
			result._sign = _sign ^ value._sign;
			
			result.normalize();
			
			return result;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Gets a value that indicates whether the value of this instance is an even number.
		 * <p>This property is a convenience feature that indicates
		 * whether the value of this instance is evenly divisible by two.</p>
		 * <p>If the value of this instance is <code>BigInteger.ZERO</code>, the property returns <code>true</code>.</p>
		 */
		public function get isEven():Boolean
		{
			return (_length > 0 ? (_bits[0] & 1) : _sign) == 0;
		}
		
		/**
		 * Gets a value that indicates whether the value of the this instance is <code>BigInteger.ONE</code>.
		 * <p>This property offers significantly better performance than other comparisons with one,
		 * such as <code>BigInteger.equals(BigInteger.ONE)</code>.</p>
		 */
		public function get isOne():Boolean
		{
			return _sign == 0 && _length == 1 && _bits[0] == 1;
		}
		
		/**
		 * Gets a value that indicates whether the value of this instance is a power of two.
		 * <p>This property determines whether a BigInteger value has a single non-zero bit set.
		 * This means that it returns <code>true</code> if the value of this instance is 1 (that is, 2<sup>0</sup>)
		 * or any greater power of two. It returns <code>false</code> if the value of this instance is 0.</p>
		 */
		public function get isPowerOfTwo():Boolean
		{
			if (sign == 1)
			{
				var i:int = _length - 1;
				
				if ((_bits[i] & _bits[i] - 1) == 0)
				{
					while (--i >= 0)
						if (_bits[i] != 0)
							return false;
					
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * Gets a value that indicates whether the value of the this instance is <code>BigInteger.ZERO</code>.
		 * <p>This property offers significantly better performance than <code>BigInteger.equals(BigInteger.ZERO)</code>.</p>
		 */
		public function get isZero():Boolean
		{
			return sign == 0;
		}
		
		/**
		 * Gets a number that indicates the sign (negative, positive, or zero) of this instance,
		 * as shown in the following table.
		 * <p><table class="innertable">
		 * <tr><th>Number</th><th>Description</th></tr>
		 * <tr><td>-1</td><td>The value of this instance is negative.</td></tr>
		 * <tr><td>0</td><td>The value of this instance is 0 (zero).</td></tr>
		 * <tr><td>1</td><td>The value of this instance is positive.</td></tr>
		 * </table></p>
		 */
		public function get sign():int
		{
			if (_sign < 0)
				return -1;
			
			if (_length <= 0 || _length == 1 && _bits[0] <= 0)
				return 0;
			
			return 1;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		internal function addMul(i:int, x:int, magnitude:Vector.<int>, j:int, carry:int, length:int):int
		{
			var h:int;
			var l:int;
			var m:int;
			var xh:int = x >> 15;
			var xl:int = x & 0x7FFF;
			
			while (--length >= 0)
			{
				l = _bits[i] & 0x7FFF;
				h = _bits[i++] >> 15;
				m = xh * l + xl * h;
				
				l = xl * l + ((m & 0x7FFF) << 15) + magnitude[j] + (carry & 0x3FFFFFFF);
				carry = (l >>> 30) + (m >>> 15) + (carry >>> 30) + xh * h;
				magnitude[j++] = l & 0x3FFFFFFF;
			}
			
			return carry;
		}
		
		/**
		 * @private
		 */
		internal function divRemTo(d:BigInteger, q:BigInteger, r:BigInteger):void
		{
			var pd:BigInteger = d.abs();
			
			if (pd._length <= 0)
				return;
			
			var p:BigInteger = abs();
			
			if (p._length < pd._length)
			{
				if (q != null)
					q.setBitsFromInt(0);
				
				if (r != null)
					copyTo(r);
				
				return;
			}
			
			var a:BigInteger = new BigInteger(0);
			var s:int = _sign;
			var ds:int = d._sign;
			var ss:int = 30 - getBitLength(pd._bits[pd._length - 1]);
			
			if (r == null)
				r = new BigInteger(0);
			
			if (ss > 0)
			{
				pd.shiftLeftTo(ss, a);
				p.shiftLeftTo(ss, r);
			}
			else
			{
				pd.copyTo(a);
				p.copyTo(r);
			}
			
			var al:int = a._length;
			var af:int = a._bits[al - 1];
			
			if (af == 0)
				return;
			
			var at:Number = af * 0x400000 + (al > 1 ? a._bits[al - 2] >> 8 : 0);
			var n1:Number = 0x10000000000000 / at;
			var n2:Number = 0x400000 / at;
			var i:int = r._length;
			var j:int = i - al;
			var b:BigInteger = q || new BigInteger(0);
			
			a.innerShiftLeftTo(j, b);
			
			if (r.compareTo(b) >= 0)
			{
				r._bits[r._length++] = 1;
				
				r.subTo(b, r);
			}
			
			ONE.innerShiftLeftTo(al, b);
			
			b.subTo(a, a);
			
			var bits:Vector.<int> = a._bits;
			
			while (a._length < al)
				bits[a._length++] = 0;
			
			bits = r._bits;
			
			var t:int;
			
			while (--j >= 0)
			{
				t = bits[--i] == af ? 0x3FFFFFFF : bits[i] * n1 + (bits[i - 1] + 0x100) * n2;
				
				if ((bits[i] += a.addMul(0, t, bits, j, 0, al)) < t)
				{
					a.innerShiftLeftTo(j, b);
					
					r.subTo(b, r);
					
					while (bits[i] < --t)
						r.subTo(b, r);
				}
			}
			
			if (q != null)
			{
				r.innerShiftRightTo(al, q);
				
				if (s != ds)
					ZERO.subTo(q, q);
			}
			
			r._length = al;
			
			r.normalize();
			
			if (ss > 0)
				r.shiftRightTo(ss, r);
			
			if (s < 0)
				ZERO.subTo(r, r);
		}
		
		/**
		 * @private
		 */
		flame_internal function findNextProbablePrime(maxBitLength:int, certainty:int = 10):BigInteger
		{
			var prime:BigInteger = valueOf();
			
			if (prime.isEven)
				prime.innerAddOffset(1, 0);
			
			while (!prime.isProbablePrime(certainty))
			{
				prime.innerAddOffset(2, 0);
				
				if (prime.bitLength > maxBitLength)
					prime.subTo(ONE.shiftLeft(maxBitLength - 1), prime);
			}
			
			return prime;
		}
		
		/**
		 * @private
		 */
		internal function innerAddOffset(value:int, word:int):void
		{
			if (value == 0)
				return;
			
			while (_length <= word)
				_bits[_length++] = 0;
			
			_bits[word] += value;
			
			while (_bits[word] >= 0x40000000)
			{
				_bits[word] -= 0x40000000;
				
				if (++word >= _length)
					_bits[_length++] = 0;
				
				_bits[word]++;
			}
		}
		
		/**
		 * @private
		 */
		internal function innerShiftLeftTo(value:int, result:BigInteger):void
		{
			for (var i:int = 0; i < value; i++)
				result._bits[i] = 0;
			
			for (i = 0; i < _length; i++)
				result._bits[i + value] = _bits[i];
			
			result._length = _length + value;
			result._sign = _sign;
		}
		
		/**
		 * @private
		 */
		internal function innerShiftRightTo(value:int, result:BigInteger):void
		{
			for (var i:int = value; i < _length; i++)
				result._bits[i - value] = _bits[i];
			
			result._length = Math.max(_length - value, 0);
			result._sign = _sign;
		}
		
		/**
		 * @private
		 */
		internal function invertDigit():int
		{
			if (_length < 1)
				return 0;
			
			var x:int = _bits[0];
			
			if ((x & 1) == 0)
				return 0;
			
			var y:int = x & 3;
			
			y = y * (2 - (x & 0xF) * y) & 0xF;
			y = y * (2 - (x & 0xFF) * y) & 0xFF;
			y = (y * (2 - (x & 0xFFFF) * y) & 0xFFFF) & 0xFFFF;
			y = y * (2 - x * y % 0x40000000) % 0x40000000;
			
			return y > 0 ? 0x40000000 - y : -y;
		}
		
		/**
		 * @private
		 */
		flame_internal function isBitSet(index:int):Boolean
		{
			var i:int = index / 30;
			
			return i >= _length ? _sign != 0 : (_bits[i] & 1 << index % 30) != 0;
		}
		
		/**
		 * @private
		 */
		flame_internal function isProbablePrime(certainty:int):Boolean
		{
			var i:int;
			var count:int;
			var p:BigInteger = abs();
			
			if (p._length == 1 && p._bits[0] <= _lowPrimes[_lowPrimes.length - 1])
			{
				for (i = 0, count = _lowPrimes.length; i < count; i++)
					if (p._bits[0] == _lowPrimes[i])
						return true;
				
				return false;
			}
			
			if (p.isEven)
				return false;
			
			i = 1;
			
			var j:int;
			var prime:int;
			
			count = _lowPrimes.length;
			
			while (i < count)
			{
				prime = _lowPrimes[i];
				j = i + 1;
				
				while (j < count && prime < 131844)
					prime *= _lowPrimes[j++];
				
				prime = p.modInt(prime);
				
				while (i < j)
					if (prime % _lowPrimes[i++] == 0)
						return false;
			}
			
			return p.testMillerRabin(certainty);
		}
		
		/**
		 * @private
		 */
		flame_internal function modInverse(modulus:BigInteger):BigInteger
		{
			var isModulusEven:Boolean = modulus.isEven;
			
			if (isEven && isModulusEven || modulus.sign == 0)
				return ZERO;
			
			var a:BigInteger = new BigInteger(1);
			var b:BigInteger = new BigInteger(0);
			var c:BigInteger = new BigInteger(0);
			var d:BigInteger = new BigInteger(1);
			var x:BigInteger = modulus.valueOf();
			var y:BigInteger = valueOf();
			
			while (x.sign != 0)
			{
				while (x.isEven)
				{
					x.shiftRightTo(1, x);
					
					if (isModulusEven)
					{
						if (!a.isEven || !b.isEven)
						{
							a.addTo(this, a);
							b.subTo(modulus, b);
						}
						
						a.shiftRightTo(1, a);
					}
					else if (!b.isEven)
						b.subTo(modulus, b);
					
					b.shiftRightTo(1, b);
				}
				
				while (y.isEven)
				{
					y.shiftRightTo(1, y);
					
					if (isModulusEven)
					{
						if (!c.isEven || !d.isEven)
						{
							c.addTo(this, c);
							
							d.subTo(modulus, d);
						}
						
						c.shiftRightTo(1, c);
					}
					else if (!d.isEven)
						d.subTo(modulus, d);
					
					d.shiftRightTo(1, d);
				}
				
				if (x.compareTo(y) >= 0)
				{
					x.subTo(y, x);
					
					if (isModulusEven)
						a.subTo(c, a);
					
					b.subTo(d, b);
				}
				else
				{
					y.subTo(x, y);
					
					if (isModulusEven)
						c.subTo(a, c);
					
					d.subTo(b, d);
				}
			}
			
			if (y.compareTo(ONE) != 0)
				return ZERO;
			
			if (d.compareTo(modulus) >= 0)
				return d.subtract(modulus);
			
			if (d.sign < 0)
				d.addTo(modulus, d);
			else
				return d;
			
			if (d.sign < 0)
				return d.add(modulus);
			else
				return d;
		}
		
		/**
		 * @private
		 */
		flame_internal function modPowInt(exponent:int, modulus:BigInteger):BigInteger
		{
			return exp(exponent, exponent < 256 || modulus.isEven ? new ClassicReduction(modulus) : new MontgomeryReduction(modulus));
		}
		
		/**
		 * @private
		 */
		internal function mulLowerTo(value:BigInteger, n:int, result:BigInteger):void
		{
			var i:int = Math.min(_length + value._length, n);
			
			result._length = i;
			result._sign = 0;
			
			for (var j:int = 0; j < i; j++)
				result._bits[j] = 0;
			
			for (j = result._length - _length; i < j; i++)
				result._bits[i + _length] = addMul(0, value._bits[i], result._bits, i, 0, _length);
			
			for (j = Math.min(value._length, n); i < j; i++)
				addMul(0, value._bits[i], result._bits, i, 0, n - i);
			
			result.normalize();
		}
		
		/**
		 * @private
		 */
		internal function mulTo(value:BigInteger, result:BigInteger):void
		{
			var p:BigInteger = abs();
			var pv:BigInteger = value.abs();
			
			for (var i:int = 0, count:int = p._length; i < count; i++)
				result._bits[i] = 0;
			
			for (i = 0, count = value._length; i < count; i++)
				result._bits[i + p._length] = p.addMul(0, pv._bits[i], result._bits, i, 0, p._length);
			
			result._length = p._length + pv._length;
			result._sign = 0;
			
			result.normalize();
			
			if (_sign != value._sign)
				ZERO.subTo(result, result);
		}
		
		/**
		 * @private
		 */
		internal function mulUpperTo(value:BigInteger, n:int, result:BigInteger):void
		{
			result._length = _length + value._length - --n;
			result._sign = 0;
			
			for (var i:int = 0, count:int = result._length; i < count; i++)
				result._bits[i] = 0;
			
			for (i = Math.max(n - _length, 0), count = value._length; i < count; i++)
				result._bits[_length + i - n] = addMul(n - i, value._bits[i], result._bits, 0, 0, _length + i - n);
			
			result.normalize();
			
			result.innerShiftRightTo(1, result);
		}
		
		/**
		 * @private
		 */
		internal function normalize():void
		{
			var value:int = _sign & 0x3FFFFFFF;
			
			if (_length > _bits.length)
				_length = _bits.length;
			
			while (_length > 0 && _bits[_length - 1] == value)
				_length--;
		}
		
		/**
		 * @private
		 */
		flame_internal function square():BigInteger
		{
			var result:BigInteger = new BigInteger(0);
			
			squareTo(result);
			
			return result;
		}
		
		/**
		 * @private
		 */
		internal function squareTo(result:BigInteger):void
		{
			var p:BigInteger = abs();
			
			result._length = p._length << 1;
			
			for (var i:int = 0, count:int = result._length; i < count; i++)
				result._bits[i] = 0;
			
			var t:int;
			
			for (i = 0, count = p._length - 1; i < count; i++)
			{
				t = p.addMul(i, p._bits[i], result._bits, i << 1, 0, 1);
				
				if ((result._bits[i + p._length] += p.addMul(i + 1, p._bits[i] << 1, result._bits, (i << 1) + 1, t, p._length - i - 1)) >= 0x40000000)
				{
					result._bits[i + p._length] -= 0x40000000;
					result._bits[i + p._length + 1] = 1;
				}
			}
			
			if (result._length > 0)
				result._bits[result._length - 1] += p.addMul(i, p._bits[i], result._bits, i << 1, 0, 1);
			
			result._sign = 0;
			
			result.normalize();
		}
		
		/**
		 * @private
		 */
		internal function subTo(value:BigInteger, result:BigInteger):void
		{
			var carry:int = 0;
			var i:int = 0;
			var length:int = Math.min(value._length, _length);
			
			while (i < length)
			{
				carry += _bits[i] - value._bits[i];
				result._bits[i++] = carry & 0x3FFFFFFF;
				carry >>= 30;
			}
			
			if (value._length < _length)
			{
				carry -= value._sign;
				
				while (i < _length)
				{
					carry += _bits[i];
					result._bits[i++] = carry & 0x3FFFFFFF;
					carry >>= 30;
				}
				
				carry += _sign;
			}
			else
			{
				carry += _sign;
				
				while (i < value._length)
				{
					carry -= value._bits[i];
					result._bits[i++] = carry & 0x3FFFFFFF;
					carry >>= 30;
				}
				
				carry -= value._sign;
			}
			
			result._sign = carry < 0 ? -1 : 0;
			
			if (carry < -1)
				result._bits[i++] = 0x40000000 + carry;
			else if (carry > 0)
				result._bits[i++] = carry;
			
			result._length = i;
			
			result.normalize();
		}
		
		/**
		 * @private
		 */
		flame_internal function toInt():int
		{
			if (_sign < 0)
			{
				if (_length == 1)
					return _bits[0] - 0x40000000;
				else if (_length == 0)
					return -1;
			}
			else if (_length == 1)
				return _bits[0];
			else if (_length == 0)
				return 0;
			
			return (_bits[1] & 3) << 30 | _bits[0];
		}
		
		//--------------------------------------------------------------------------
		//
		//  Internal properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		flame_internal function get bitLength():int
		{
			if (_length <= 0)
				return 0;
			
			return 30 * (_length - 1) + getBitLength(_bits[_length - 1] ^ _sign & 0x3FFFFFFF);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function addTo(value:BigInteger, result:BigInteger):void
		{
			var carry:int = 0;
			var i:int = 0;
			var length:int = Math.min(value._length, _length);
			
			while (i < length)
			{
				carry += _bits[i] + value._bits[i];
				result._bits[i++] = carry & 0x3FFFFFFF;
				carry >>= 30;
			}
			
			if (value._length < _length)
			{
				carry += value._sign;
				
				while (i < _length)
				{
					carry += _bits[i];
					result._bits[i++] = carry & 0x3FFFFFFF;
					carry >>= 30;
				}
				
				carry += _sign;
			}
			else
			{
				carry += _sign;
				
				while (i < value._length)
				{
					carry += value._bits[i];
					result._bits[i++] = carry & 0x3FFFFFFF;
					carry >>= 30;
				}
				
				carry += value._sign;
			}
			
			result._sign = carry < 0 ? -1 : 0;
			
			if (carry > 0)
				result._bits[i++] = carry;
			else if (carry < -1)
				result._bits[i++] = 0x40000000 + carry;
			
			result._length = i;
			
			result.normalize();
		}
		
		private function copyTo(destination:BigInteger):void
		{
			destination._length = _length;
			destination._bits = _bits.slice();
			destination._sign = _sign;
		}
		
		private function exp(exponent:int, reductionAlgorithm:IReductionAlgorithm):BigInteger
		{
			if (exponent < 0)
				throw new RangeError(_resourceManager.getString("flameCore", "argOutOfRangeNonNegative", [ "exponent" ]));
			
			if (isZero)
				return exponent == 0 ? ONE : this;
			
			var t1:BigInteger = new BigInteger(0);
			var t2:BigInteger = reductionAlgorithm.convert(this);
			var t3:BigInteger;
			var result:BigInteger = t2.valueOf();
			
			for (var i:int = getBitLength(exponent) - 2; i >= 0; i--)
			{
				reductionAlgorithm.square(result, t1);
				
				if ((exponent & (1 << i)) > 0)
					reductionAlgorithm.multiply(t1, t2, result);
				else
				{
					t3 = result;
					result = t1;
					t1 = t3;
				}
			}
			
			return reductionAlgorithm.revert(result);
		}
		
		private static function getBitLength(value:int):int
		{
			var size:int = 1;
			
			if (value >>> 16 != 0)
			{
				size += 16;
				value >>>= 16;
			}
			
			if (value >> 8 != 0)
			{
				size += 8;
				value >>= 8;
			}
			
			if (value >> 4 != 0)
			{
				size += 4
				value >>= 4;
			}
			
			if (value >> 2 != 0)
			{
				size += 2;
				value >>= 2;
			}
			
			if (value >> 1 != 0)
				size += 1;
			
			return size;
		}
		
		private static function getBitCount(value:int):int
		{
			return 20.79441541679836 / Math.log(value); // Math.LN2 * 30
		}
		
		private static function getDefaultRadix(value:String):int
		{
			return _hexPattern.test(value) ? 16 : 10;
		}
		
		private function innerMul(value:int):void
		{
			_bits[_length] = addMul(0, value - 1, _bits, 0, 0, _length);
			_length++;
			
			normalize();
		}
		
		private function modInt(value:int):int
		{
			if (value <= 0)
				return 0;
			
			var t:int = 0x40000000 % value;
			var result:int = _sign < 0 ? value - 1 : 0;
			
			if (_length > 0)
			{
				if (t == 0)
					result = _bits[0] % value;
				else
					for (var i:int = _length - 1; i >= 0; i--)
						result = (t * result + _bits[i]) % value;
			}
			
			return result;
		}
		
		private function setBitsFromByteArray(value:ByteArray, unsigned:Boolean):void
		{
			var s:int = 0;
			var x:int = 0;
			
			_length = 0;
			
			for (var i:int = value.length - 1; i >= 0; i--)
			{
				x = value[i];
				
				if (s == 0)
					_bits[_length++] = x;
				else if (s > 22)
				{
					_bits[_length - 1] |= (x & (1 << 30 - s) - 1) << s;
					_bits[_length++] = x >> 30 - s;
				}
				else
					_bits[_length - 1] |= x << s;
				
				s += 8;
				
				if (s >= 30)
					s -= 30;
			}
			
			if (!unsigned && (value[0] & 0x80) != 0)
			{
				_sign = -1;
				
				if (s > 0)
					_bits[_length - 1] |= (1 << 30 - s) - 1 << s;
			}
			
			normalize();
		}
		
		private function setBitsFromInt(value:int):void
		{
			_bits.length = 0;
			_length = 1;
			_sign = value < 0 ? -1 : 0;
			
			if (value > 0)
				_bits[0] = value;
			else if (value < -1)
				_bits[0] = value + 0x40000000;
			else
				_length = 0;
		}
		
		private function setBitsFromString(value:String, radix:int):void
		{
			var e:int;
			var i:int;
			var subtract:Boolean = value.indexOf("-") == 0;
			var x:int;
			
			switch (radix)
			{
				case 2:
					
					e = 1;
					break;
				
				case 4:
					
					e = 2;
					break;
				
				case 8:
					
					e = 3;
					break;
				
				case 16:
					
					e = 4;
					
					value = value.replace("0x", "");
					break;
				
				case 32:
					
					e = 5;
					break;
				
				default:
					
					setBitsFromInt(0);
					
					var bitCount:int = getBitCount(radix);
					var count:int;
					var p:int = Math.pow(radix, bitCount);
					var j:int = 0;
					var y:int = 0;
					
					for (i = 0, count = value.length; i < count; i++)
					{
						x = parseInt(value.charAt(i), 36);
						y = y * radix + x;
						
						if (++j >= bitCount)
						{
							innerMul(p);
							innerAddOffset(y, 0);
							
							j = 0;
							y = 0;
						}
					}
					
					if (j > 0)
					{
						innerMul(Math.pow(radix, j));
						innerAddOffset(y, 0);
					}
					
					if (subtract)
						ZERO.subTo(this, this);
					
					return;
			}
			
			var s:int = 0;
			
			_length = 0;
			
			for (i = value.length - 1; i >= 0; i--)
			{
				x = parseInt(value.charAt(i), 36);
				
				if (s == 0)
					_bits[_length++] = x;
				else if (s + e > 30)
				{
					_bits[_length - 1] |= (x & (1 << (30 - s)) - 1) << s;
					_bits[_length++] = x >> 30 - s;
				}
				else
					_bits[_length - 1] |= x << s;
				
				s += e;
				
				if (s >= 30)
					s -= 30;
			}
			
			normalize();
			
			if (subtract)
				ZERO.subTo(this, this);
		}
		
		private function shiftLeftTo(value:int, result:BigInteger):void
		{
			var r:int = value % 30;
			var d:int = 30 - r;
			var m:int = (1 << d) - 1;
			var q:int = value / 30;
			var c:int = _sign << r & 0x3FFFFFFF;
			
			result._bits.length = _length + q;
			
			for (var i:int = _length - 1; i >= 0; i--)
			{
				result._bits[i + q + 1] = _bits[i] >> d | c;
				c = (_bits[i] & m) << r;
			}
			
			for (i = 0; i < q; i++)
				result._bits[i] = 0;
			
			result._bits[q] = c;
			result._length = _length + q + 1;
			result._sign = _sign;
			
			result.normalize();
		}
		
		private function shiftRightTo(value:int, result:BigInteger):void
		{
			result._sign = _sign;
			
			var q:int = value / 30;
			
			if (q >= _length)
			{
				result._length = 0;
				
				return;
			}
			
			var r:int = value % 30;
			var d:int = 30 - r;
			var m:int = (1 << r) - 1;
			
			result._bits[0] = _bits[q] >> r;
			
			for (var i:int = q + 1; i < _length; i++)
			{
				result._bits[i - q - 1] |= (_bits[i] & m) << d;
				result._bits[i - q] = _bits[i] >> r;
			}
			
			if (r > 0)
				result._bits[_length - q - 1] |= (_sign & m) << d;
			
			result._length = _length - q;
			
			result.normalize();
		}
		
		private function testMillerRabin(certainty:int):Boolean
		{
			var subOne:BigInteger = subtract(ONE);
			var lowBit:int = subOne.lowestSetBit;
			
			if (lowBit <= 0)
				return false;
			
			certainty = certainty + 1 >> 1;
			
			var lowPrimesLength:int = _lowPrimes.length;
			
			if (certainty > lowPrimesLength)
				certainty = lowPrimesLength;
			
			var x:BigInteger = subOne.shiftRight(lowBit);
			var y:BigInteger = new BigInteger(0);
			var z:BigInteger;
			
			for (var i:int = 0, j:int; i < certainty; i++)
			{
				y.setBitsFromInt(_lowPrimes[int(Math.random() * lowPrimesLength)]);
				
				z = y.modPow(x, this);
				
				if (z.compareTo(ONE) != 0 && z.compareTo(subOne) != 0)
				{
					for (j = 1; j < lowBit && z.compareTo(subOne) != 0; j++)
					{
						z = z.modPowInt(2, this);
						
						if (z.compareTo(ONE) == 0)
							return false;
					}
					
					if (z.compareTo(subOne) != 0)
						return false;
				}
			}
			
			return true;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private properties
		//
		//--------------------------------------------------------------------------
		
		private function get lowestSetBit():int
		{
			var index:int = 0;
			var value:int;
			
			for (var i:int = 0; i < _length; i++)
				if (_bits[i] != 0)
				{
					value = _bits[i];
					
					if ((value & 0xFFFF) == 0)
					{
						value >>= 16;
						index += 16;
					}
					
					if ((value & 0xFF) == 0)
					{
						value >>= 8;
						index += 8;
					}
					
					if ((value & 0xF) == 0)
					{
						value >>= 4;
						index += 4;
					}
					
					if ((value & 3) == 0)
					{
						value >>= 2;
						index += 2;
					}
					
					if ((value & 1) == 0)
						index++;
					
					return i * 30 + index;
				}
			
			if (_sign < 0)
				return _length * 30;
			
			return -1;
		}
	}
}