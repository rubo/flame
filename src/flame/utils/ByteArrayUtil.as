////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.utils
{
	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	[ResourceBundle("flameLocale")]
	
	/**
	 * The ByteArrayUtil utility class is an all-static class with methods for working with ByteArray objects.
	 * You do not create instances of ByteArrayUtil;
	 * instead you call methods such as the <code>ByteArrayUtil.toHexString()</code> method.
	 */
	public final class ByteArrayUtil
	{
		//--------------------------------------------------------------------------
	    //
	    //  Fields
	    //
	    //--------------------------------------------------------------------------
	    
		private static var _hexPattern:RegExp = /[^0-9A-F]/gi;
		private static var _hexTrimPattern:RegExp = /(^0x)|(\s+)/gi;
		private static var _resourceManager:IResourceManager = ResourceManager.getInstance();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @throws flash.errors.IllegalOperationError ByteArrayUtil is an all-static class.
		 */
		public function ByteArrayUtil()
		{
			throw new IllegalOperationError(_resourceManager.getString("flameLocale", "staticClassInstance",
				[ getQualifiedClassName(ByteArrayUtil) ]));
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Public methods
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Adds the bytes of one ByteArray to the end of another ByteArray. 
		 * 
		 * @param byteArray The ByteArray to add to.
		 * 
		 * @param bytes The ByteArray whose bytes should be added
		 * to the end of the <code>byteArray</code> parameter.
		 * 
		 * @throws ArgumentError Thrown in the following situations:<ul>
		 * <li><code>byteArray</code> parameter is <code>null</code>.</li>
		 * <li><code>bytes</code> parameter is <code>null</code>.</li>
		 * </ul>
		 */
		public static function addBytes(byteArray:ByteArray, bytes:ByteArray):void
		{
			if (byteArray == null)
				throw new ArgumentError(_resourceManager.getString("flameLocale", "argNullGeneric", [ "byteArray" ]));
			
			if (bytes == null)
				throw new ArgumentError(_resourceManager.getString("flameLocale", "argNullGeneric", [ "bytes" ]));
			
			byteArray.position = byteArray.length;
			byteArray.writeBytes(bytes);
		}
		
		/**
		 * Returns a copy of the ByteArray.
		 * 
		 * @param byteArray A ByteArray to copy.
		 * 
		 * @returns A copy of the ByteArray.
		 * 
		 * @throws ArgumentError <code>byteArray</code> parameter is <code>null</code>.
		 */
		public static function copy(byteArray:ByteArray):ByteArray
		{
			if (byteArray == null)
				throw new ArgumentError(_resourceManager.getString("flameLocale", "argNullGeneric", [ "byteArray" ]));
			
			var buffer:ByteArray = new ByteArray();
			var position:uint = byteArray.position;
			
			byteArray.position = 0;
			
			byteArray.readBytes(buffer);
			
			byteArray.position = position;
			
			buffer.endian = byteArray.endian;
			buffer.position = 0;
			
			return buffer;
		}
		
		/**
		 * Creates a ByteArray from a hexadecimal string.
		 * 
		 * @param value The hexadecimal string to convert from.
		 * 
		 * @returns The converted ByteArray.
		 * 
		 * @throws ArgumentError <code>value</code> parameter is not a valid hexadecimal string.
		 */
		public static function fromHexString(value:String):ByteArray
		{
			value = value.replace(_hexTrimPattern, "");
			
			if (_hexPattern.test(value))
				throw new ArgumentError(_resourceManager.getString("flameLocale", "argInvalidHexString"));
			
			if (value.length % 2 != 0)
				value = "0" + value;
			
			var byteArray:ByteArray = new ByteArray();
			
			for (var i:int = 0, count:int = value.length; i < count; i += 2)
				byteArray.writeByte(parseInt(value.substr(i, 2), 16));
			
			byteArray.position = 0;
			
			return byteArray;
		}
		
		/**
		 * Returns a ByteArray which represents a subset of the bytes in the source ByteArray.
		 * 
		 * @param byteArray The ByteArray to get range from.
		 * 
		 * @param index The zero-based ByteArray index at which the range starts.
		 * 
		 * @param count The number of bytes in the range.
		 * 
		 * @return A ByteArray which represents a subset of the bytes in the source ByteArray.
		 * 
		 * @throws ArgumentError <code>byteArray</code> paremeter is <code>null</code>.
		 * 
		 * @throws RangeError Thrown in the following situations:<ul>
		 * <li><code>index</code> parameter is less than zero.</li>
		 * <li><code>count</code> is less than zero.</li>
		 * <li><code>index</code> + <code>count</code> is greater than the length of <code>byteArray</code> paremeter.</li>
		 * </ul>
		 */
		public static function getBytes(byteArray:ByteArray, index:int, count:int):ByteArray
		{
			if (byteArray == null)
				throw new ArgumentError(_resourceManager.getString("flameLocale", "argNullGeneric", [ "byteArray" ]));
			
			if (index < 0)
				throw new RangeError(_resourceManager.getString("flameLocale", "argOutOfRangeNonNegative", [ "index" ]));
			
			if (count < 0)
				throw new RangeError(_resourceManager.getString("flameLocale", "argOutOfRangeNonNegative", [ "count" ]));
			
			if (byteArray.length - index < count)
				throw new RangeError(_resourceManager.getString("flameLocale", "argInvalidOffsetLength"));
			
			var buffer:ByteArray = new ByteArray();
			
			buffer.writeBytes(byteArray, index, count);
			
			buffer.position = 0;
			
			return buffer;
		}
		
		/**
		 * Inserts a byte into the ByteArray at the specified index.
		 * 
		 * @param byteArray The ByteArray to instert to.
		 * 
		 * @param index The zero-based index at which the new bytes should be inserted.
		 * 
		 * @param byte The byte to insert into the <code>byteArray</code> parameter.
		 * 
		 * @throws ArgumentError <code>byteArray</code> parameter is <code>null</code>.
		 * 
		 * @throws RangeError <code>index</code> parameter is less than zero,
		 * or greater than the value of the <code>length</code> property of the <code>byteArray</code> parameter.
		 */
		public static function insertByte(byteArray:ByteArray, index:int, byte:int):void
		{
			if (byteArray == null)
				throw new ArgumentError(_resourceManager.getString("flameLocale", "argNullGeneric", [ "byteArray" ]));
			
			if (index < 0 || index > byteArray.length)
				throw new RangeError(_resourceManager.getString("flameLocale", "argOutOfRangeInsert", [ "index" ]));
			
			var buffer:ByteArray = new ByteArray();
			var position:uint = byteArray.position;
			
			byteArray.position = index;
			byteArray.readBytes(buffer);
			
			byteArray.length = index;
			
			byteArray.writeByte(byte);
			byteArray.writeBytes(buffer);
			
			byteArray.position = position;
		}
		
		/**
		 * Inserts a range of bytes into the ByteArray at the specified index.
		 * 
		 * @param byteArray The ByteArray to instert to.
		 * 
		 * @param index The zero-based index at which the new bytes should be inserted.
		 * 
		 * @param bytes The ByteArray whose bytes should be inserted into the <code>byteArray</code> parameter.
		 * 
		 * @throws ArgumentError Thrown in the following situations:<ul>
		 * <li><code>byteArray</code> parameter is <code>null</code>.</li>
		 * <li><code>bytes</code> parameter is <code>null</code>.</li>
		 * </ul>
		 * 
		 * @throws RangeError <code>index</code> parameter is less than zero,
		 * or greater than the value of the <code>length</code> property of the <code>byteArray</code> parameter.
		 */
		public static function insertBytes(byteArray:ByteArray, index:int, bytes:ByteArray):void
		{
			if (byteArray == null)
				throw new ArgumentError(_resourceManager.getString("flameLocale", "argNullGeneric", [ "byteArray" ]));
			
			if (index < 0 || index > byteArray.length)
				throw new RangeError(_resourceManager.getString("flameLocale", "argOutOfRangeInsert", [ "index" ]));
			
			if (bytes == null)
				throw new ArgumentError(_resourceManager.getString("flameLocale", "argNullGeneric", [ "bytes" ]));
			
			var buffer:ByteArray = new ByteArray();
			var position:uint = byteArray.position;
			
			byteArray.position = index;
			byteArray.readBytes(buffer);
			
			byteArray.length = index;
			
			byteArray.writeBytes(bytes);
			byteArray.writeBytes(buffer);
			
			byteArray.position = position;
		}
		
		/**
		 * Removes a range of bytes from the ByteArray.
		 * 
		 * @param byteArray The ByteArray to remove from.
		 * 
		 * @param index The zero-based starting index of the range of bytes to remove.
		 * 
		 * @param count The number of bytes to remove.
		 * 
		 * @throws ArgumentError <code>byteArray</code> parameter is <code>null</code>.
		 * 
		 * @throws RangeError Thrown in the following situations:<ul>
		 * <li><code>index</code> parameter is less than zero.</li>
		 * <li><code>count</code> is less than zero.</li>
		 * <li><code>index</code> + <code>count</code> is greater than the length of <code>byteArray</code> paremeter.</li>
		 * </ul>
		 */
		public static function removeBytes(byteArray:ByteArray, index:int, count:int):void
		{
			if (byteArray == null)
				throw new ArgumentError(_resourceManager.getString("flameLocale", "argNullGeneric", [ "byteArray" ]));
			
			if (index < 0)
				throw new RangeError(_resourceManager.getString("flameLocale", "argOutOfRangeNonNegative", [ "index" ]));
			
			if (count < 0)
				throw new RangeError(_resourceManager.getString("flameLocale", "argOutOfRangeNonNegative", [ "count" ]));
			
			if (byteArray.length - index < count)
				throw new RangeError(_resourceManager.getString("flameLocale", "argInvalidOffsetLength"));
			
			if (count > 0)
			{
				var position:uint = byteArray.position;
				
				byteArray.position = index + count;
				
				byteArray.readBytes(byteArray, index);
				
				byteArray.length -= count;
				
				byteArray.position = position > byteArray.length ? byteArray.length : position;
			}
		}
		
		/**
		 * Returns a ByteArray whose bytes are copies of the specified value.
		 * 
		 * @param value The byte to copy multiple times in the new ByteArray.
		 * 
		 * @param count The number of times value should be copied.
		 * 
		 * @return A ByteArray with count number of bytes, all of which are copies of <code>value</code>.
		 * 
		 * @throws RangeError <code>count</code> parameter is less than zero.
		 */
		public static function repeat(value:int, count:int):ByteArray
		{
			if (count < 0)
				throw new RangeError(_resourceManager.getString("flameLocale", "argOutOfRangeNonNegative", [ "count" ]));
			
			var byteArray:ByteArray = new ByteArray();
		
		    for (var i:int = 0; i < count; i++)
		        byteArray[i] = value;
		    
		    return byteArray;
		}
		
		/**
		 * Reverses the order of the bytes in the specified range.
		 *  
		 * @param byteArray The ByteArray to reverse.
		 * 
		 * @param index The zero-based starting index of the range to reverse.
		 * 
		 * @param count The number of bytes in the range to reverse.
		 * 
		 * @throws ArgumentError <code>byteArray</code> parameter is <code>null</code>.
		 * 
		 * @throws RangeError Thrown in the following situations:<ul>
		 * <li><code>index</code> parameter is less than zero.</li>
		 * <li><code>count</code> is less than zero.</li>
		 * <li><code>index</code> + <code>count</code> is greater than the length of <code>byteArray</code> paremeter.</li>
		 * </ul>
		 */		
		public static function reverse(byteArray:ByteArray, index:int = 0, count:int = 0):void
		{
			if (byteArray == null)
				throw new ArgumentError(_resourceManager.getString("flameLocale", "argNullGeneric", [ "byteArray" ]));
			
			if (index < 0)
				throw new RangeError(_resourceManager.getString("flameLocale", "argOutOfRangeNonNegative", [ "index" ]));
			
			if (count < 0)
				throw new RangeError(_resourceManager.getString("flameLocale", "argOutOfRangeNonNegative", [ "count" ]));
			
			if (byteArray.length - index < count)
				throw new RangeError(_resourceManager.getString("flameLocale", "argInvalidOffsetLength"));
			
			for (var i:int = index, j:int = index + (count || byteArray.length) - 1, byte:int; i < j; i++, j--)
			{
				byte = byteArray[i];
				byteArray[i] = byteArray[j];
				byteArray[j] = byte;
			}
		}
		
		/**
		 * Converts ByteArray to Array.
		 * 
		 * @param byteArray The ByteArray to convert.
		 * 
		 * @return A new Array whose elements are bytes of the <code>byteArray</code> parameter.
		 * 
		 * @throws ArgumentError <code>byteArray</code> parameter is <code>null</code>.
		 */
		public static function toArray(byteArray:ByteArray):Array
		{
			if (byteArray == null)
				throw new ArgumentError(_resourceManager.getString("flameLocale", "argNullGeneric", [ "byteArray" ]));
			
			var array:Array = [];
			
			for (var i:int = 0, count:int = byteArray.length; i < count; i++)
				array[i] = byteArray[i];
			
			return array;
		}
		
		/**
		 * Converts ByteArray to hexadecimal string.
		 * 
		 * @param byteArray The ByteArray to convert.
		 * 
		 * @return A new hexadecimal string which represents the bytes of <code>byteArray</code> parameter.
		 * 
		 * @throws ArgumentError <code>byteArray</code> parameter is <code>null</code>.
		 */
		public static function toHexString(byteArray:ByteArray):String
		{
			if (byteArray == null)
				throw new ArgumentError(_resourceManager.getString("flameLocale", "argNullGeneric", [ "byteArray" ]));
			
            var string:String = "";
			var position:int = byteArray.position;
			
			byteArray.position = 0;
			
			for (var i:int = 0, count:int = byteArray.length; i < count; i++)
	            string += StringUtil.padLeft(byteArray.readUnsignedByte().toString(16), 2, "0");
			
			byteArray.position = position;
			
	        return string.toUpperCase();
		}
		
		/**
		 * Converts ByteArray to Vector.&#60;int&#62;.
		 * 
		 * @param byteArray The ByteArray to convert.
		 * 
		 * @return A new Vector.&#60;int&#62; whose elements are bytes of the <code>byteArray</code> parameter.
		 * 
		 * @throws ArgumentError <code>byteArray</code> parameter is <code>null</code>.
		 */
		public static function toVector(byteArray:ByteArray):Vector.<int>
		{
			if (byteArray == null)
				throw new ArgumentError(_resourceManager.getString("flameLocale", "argNullGeneric", [ "byteArray" ]));
			
			var vector:Vector.<int> = new Vector.<int>();
			
			for (var i:int = 0, count:int = byteArray.length; i < count; i++)
				vector[i] = byteArray[i];
			
			return vector;
		}
	}
}