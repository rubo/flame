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
	 * The ArrayUtil utility class is an all-static class with methods for working with Array objects.
	 * You do not create instances of ArrayUtil;
	 * instead you call methods such as the <code>ArrayUtil.repeat()</code> method.
	 */
	public final class ArrayUtil
	{
		//--------------------------------------------------------------------------
	    //
	    //  Fields
	    //
	    //--------------------------------------------------------------------------
	    
		private static var _resourceManager:IResourceManager = ResourceManager.getInstance();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @throws flash.errors.IllegalOperationError ArrayUtil is an all-static class.
		 */
		public function ArrayUtil()
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "staticClassInstance",
				[ getQualifiedClassName(ArrayUtil) ]));
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Public methods
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Searches the entire sorted Array for an element using the specified comparer
		 * and returns the zero-based index of the element.
		 * 
		 * @param array The sorted Array to search.
		 * 
		 * @param value The object to locate. The value can be <code>null</code>.
		 * 
		 * @param comparer The function to run on each item in the array.
		 * This function must return a Boolean value, and is invoked with two arguments;
		 * the <code>value</code> parameter, and the value of an item:
		 * <p><code>function (value:~~, item:~~):Boolean</code></p>
		 * 
		 * @return The zero-based index of item in the sorted Array, if item is found;
		 * otherwise, a negative number that is the bitwise complement of the index of the next element
		 * that is larger than item or, if there is no larger element,
		 * the bitwise complement of <code>length</code> property.
		 * 
		 * @throws ArgumentError Thrown in the following situations:<ul>
		 * <li><code>array</code> parameter is <code>null</code>.</li>
		 * <li><code>comparer</code> parameter is <code>null</code>.</li>
		 * </ul>
		 */
		public static function binarySearch(array:Array, value:*, comparer:Function):int
		{
			if (array == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "array" ]));
			
			if (comparer == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "comparer" ]));
			
		    var length:int = array.length;
		    var l:int = 0;
		    var r:int = length - 1;
		    var m:int;
		        
		    while (l <= r)
		        switch (comparer(value, array[m = l + r >> 1]))
		        {
		            case 1:
		                
		                l = m + 1;
		                break;
		            
		            case -1:
		                
		                r = m - 1;
		                break;
		            
		            default:
		                
		                return m;
		        }
		    
		    return r < length ? ~l : ~length;
		}
		
		/**
		 * Returns an Array whose elements are copies of the specified value.
		 * 
		 * @param value The Object to copy multiple times in the new Array.
		 * The value can be <code>null</code>.
		 * 
		 * @param count The number of times <code>value</code> parameter should be copied.
		 * 
		 * @return An Array with count number of elements,
		 * all of which are copies of <code>value</code> parameter.
		 * 
		 * @throws RangeError <code>count</code> paremeter is less than zero.
		 */
		public static function repeat(value:*, count:int):Array
		{
			if (count < 0)
				throw new RangeError(_resourceManager.getString("flameCore", "argOutOfRangeNonNegative", [ "count" ]));
			
			var array:Array = [];
		
		    for (var i:int = 0; i < count; i++)
		        array[i] = value;
		
		    return array;
		}
	}
}