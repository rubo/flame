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
	import flash.utils.getQualifiedClassName;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	[ResourceBundle("flameCore")]
	
	/**
	 * The StringUtil utility class is an all-static class with methods for working with String objects.
	 * You do not create instances of StringUtil;
	 * instead you call methods such as the <code>StringUtil.isNullOrEmpty()</code> method.  
	 */
	public final class StringUtil
	{
		//--------------------------------------------------------------------------
	    //
	    //  Fields
	    //
	    //--------------------------------------------------------------------------
		
		private static var _resourceManager:IResourceManager = ResourceManager.getInstance();
		private static var _whiteSpacePattern:RegExp = /^\s+$/;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @throws flash.errors.IllegalOperationError StringUtil is an all-static class.
		 */
		public function StringUtil()
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "staticClassInstance",
				[ getQualifiedClassName(StringUtil) ]));
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Public methods
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Inserts a specified String at a specified index position in another String. 
		 * 
		 * @param string The string to insert to.
		 * 
		 * @param index The index position of the insertion.
		 * 
		 * @param value The string to insert.
		 * 
		 * @return A new string that is equivalent to the <code>string</code> parameter,
		 * but with value inserted at position <code>index</code>.
		 * 
		 * @throws ArgumentError <code>string</code> parameter is <code>null</code>.
		 * 
		 * @throws RangeError <code>index</code> parameter is less than zero
		 * or greater than the length of the <code>string</code> parameter.
		 */
	    public static function insert(string:String, index:int, value:String):String
	    {
	    	if (string == null)
	    		throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "string" ]));
	    	
	    	if (index < 0)
	    		throw new RangeError(_resourceManager.getString("flameCore", "argOutOfRangeStartIndex", [ "index" ]));
	    	
	    	if (index > string.length)
	    		throw new RangeError(_resourceManager.getString("flameCore", "argOutOfRangeIndex", [ "index" ]));
	    	
	    	return value ? string.substr(0, index) + value + string.substr(index) : string;
	    }
	    
		/**
		 * Indicates whether the specified string is <code>null</code> or an empty string ("").
		 * <p><code>isNullOrEmpty</code> is a convenience method that enables you
		 * to simultaneously test whether a String is <code>null</code> or its value is empty.</p>
		 * 
		 * @param value The string to test.
		 * 
		 * @return <code>true</code> if the <code>value</code> parameter is <code>null</code> or an empty string ("");
		 * otherwise, <code>false</code>.
		 */
		public static function isNullOrEmpty(value:String):Boolean
		{
			return value == null || value.length == 0;
		}
		
		/**
		 * Indicates whether a specified string is null, empty, or consists only of white-space characters.
		 * 
		 * @param value The string to test.
		 * 
		 * @return <code>true</code> if the <code>value</code> parameter is <code>null</code> or an empty string ("") 
		 * or if <code>value</code> parameter consists exclusively of white-space characters;
		 * otherwise, <code>false</code>.
		 */
		public static function isNullOrWhiteSpace(value:String):Boolean
		{
			return isNullOrEmpty(value) || _whiteSpacePattern.test(value);
		}
		
		/**
		 * Returns a new string that right-aligns the characters in a String
		 * by padding them with spaces on the left, for a specified total length.
		 * 
		 * @param string The string to pad.
		 * 
		 * @param totalWidth The number of characters in the resulting string,
		 * equal to the number of original characters plus any additional padding characters.
		 * 
		 * @param paddingChar A Unicode padding character (if not supplied, a space character is used).
		 * 
		 * @return A new string that is equivalent to the <code>string</code> instance, but right-aligned
		 * and padded on the left with as many <code>padingChar</code> characters
		 * as needed to create a length of <code>totalWidth</code>. 
		 * Or, if <code>totalWidth</code> is less than the length of the <code>string</code> instance,
		 * a new string that is identical to the <code>string</code> instance.
		 * 
		 * @throws ArgumentError <code>string</code> parameter is <code>null</code>.
		 * 
		 * @throws RangeError <code>totalWidth</code> paramerer is less than zero.
		 */
		public static function padLeft(string:String, totalWidth:int, paddingChar:String = null):String
		{
			return pad(string, totalWidth, paddingChar, false);
		}
		
		/**
		 * Returns a new string that left-aligns the characters in a String
		 * by padding them with spaces on the right, for a specified total length.
		 * 
		 * @param string The string to pad.
		 * 
		 * @param totalWidth The number of characters in the resulting string,
		 * equal to the number of original characters plus any additional padding characters.
		 * 
		 * @param paddingChar A Unicode padding character (if not supplied, a space character is used).
		 * 
		 * @return A new string that is equivalent to the <code>string</code> instance, but left-aligned
		 * and padded on the right with as many <code>paddingChar</code> characters
		 * as needed to create a length of <code>totalWidth</code>. 
		 * Or, if <code>totalWidth</code> is less than the length of the <code>string</code> instance,
		 * a new string that is identical to the <code>string</code> instance.
		 * 
		 * @throws ArgumentError <code>string</code> parameter is <code>null</code>.
		 * 
		 * @throws RangeError <code>totalWidth</code> parameter is less than zero.
		 */
		public static function padRight(value:String, totalWidth:int, paddingChar:String = null):String
		{
			return pad(value, totalWidth, paddingChar, true);
		}
		
		/**
		 * Deletes a specified number of characters from String beginning at a specified position.
		 * 
		 * @param value The string to remove from.
		 * 
		 * @param startIndex The zero-based position to begin deleting characters.
		 * 
		 * @param count The number of characters to delete.
		 * 
		 * @return A new string that is equivalent to the <code>value</code> parameter except for the removed characters.
		 * 
		 * @throws ArgumentError <code>value</code> parameter is <code>null</code>.
		 * 
		 * @throws RangeError Thrown in the following situations:<ul>
		 * <li><code>startIndex</code> parameter is less than zero.</li>
		 * <li><code>count</code> parameter is less than zero.</li>
		 * <li><code>startIndex</code> + <code>count</code> is greater than the length of <code>value</code> parameter.</li>
		 * </ul>
		 */
		public static function remove(value:String, startIndex:int, count:int):String
	    {
	    	if (value == null)
	    		throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
	    	
	    	if (startIndex < 0)
	    		throw new RangeError(_resourceManager.getString("flameCore", "argOutOfRangeStartIndex", [ "startIndex" ]));
	    	
	    	if (count < 0)
	    		throw new RangeError(_resourceManager.getString("flameCore", "argOutOfRangeNonNegative", [ "count" ]));
	    	
	    	if (startIndex + count > value.length)
	    		throw new RangeError(_resourceManager.getString("flameCore", "argOutOfRangeIndex", [ "index" ]));
	    	
	    	return value.substr(0, startIndex) + value.substr(startIndex + count);
	    }
		
		//--------------------------------------------------------------------------
	    //
	    //  Private methods
	    //
	    //--------------------------------------------------------------------------
	    
		private static function pad(value:String, totalWidth:int, paddingChar:String, isRightPadded:Boolean):String
		{
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
			if (totalWidth < 0)
				throw new RangeError(_resourceManager.getString("flameCore", "argOutOfRangeNonNegative", [ "totalWidth" ]));
			
			var paddingWidth:int = totalWidth - value.length;
			
			if (paddingWidth <= 0)
				return value;
			
			var pad:String = ArrayUtil.repeat(paddingChar || " ", paddingWidth).join("");
        
    		return isRightPadded ? value + pad : pad + value;
		}		
	}
}