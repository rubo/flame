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
	 * The VectorUtil utility class is an all-static class with methods for working with Vector objects.
	 * You do not create instances of VectorUtil;
	 * instead you call methods such as the <code>VectorUtil.binarySearch()</code> method.  
	 */
	public final class VectorUtil
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
		 * @throws flash.errors.IllegalOperationError VectorUtil is an all-static class.
		 */
		public function VectorUtil()
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "staticClassInstance",
				[ getQualifiedClassName(VectorUtil) ]));
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Public methods
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Searches the entire sorted Vector for an element using the specified comparer
		 * and returns the zero-based index of the element.
		 * 
		 * @param vector The sorted Vector to search.
		 * 
		 * @param value The object to locate. The value can be <code>null</code>.
		 * 
		 * @param comparer The function to run on each item in the Vector.
		 * This function must return a Boolean value, and is invoked with two arguments;
		 * the <code>value</code> parameter, and the value of an item:
		 * <p><code>function (value:~~, item:~~):Boolean</code></p>
		 * 
		 * @return The zero-based index of item in the sorted Vector, if item is found;
		 * otherwise, a negative number that is the bitwise complement of the index of the next element
		 * that is larger than item or, if there is no larger element,
		 * the bitwise complement of <code>length</code> property.
		 * 
		 * @throws ArgumentError Thrown in the following situations:<ul>
		 * <li><code>vector</code> parameter is <code>null</code>.</li>
		 * <li><code>comparer</code> parameter is <code>null</code>.</li>
		 * </ul>
		 * 
		 * @throws TypeError <code>vector</code> parameter must be of type 'Vector'.
		 */
		public static function binarySearch(vector:*, value:*, comparer:Function):int
		{
			if (vector == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "vector" ]));
			
			if (!isVector(vector))
				throw new TypeError(_resourceManager.getString("flameCore", "argTypeMismatch", [ "vector", getQualifiedClassName(Vector.<*>) ]));
			
			if (comparer == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "comparer" ]));
			
		    var length:int = vector.length;
		    var l:int = 0;
		    var r:int = length - 1;
		    var m:int;
		        
		    while (l <= r)
		        switch (comparer(value, vector[m = l + r >> 1]))
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
		 * Indicates whether the object is an instance of Vector.
		 * 
		 * @param object The object to test.
		 * 
		 * @return <code>true</code> if the <code>object</code> parameter is an instance of Vector; otherwise, <code>false</code>.
		 */
		public static function isVector(object:*):Boolean
		{
			return object is Vector.<*> || object is Vector.<Number> || object is Vector.<int> || object is Vector.<uint>;
		}
		
		/**
		 * Converts Vector to Array.
		 * 
		 * @param vector The Vector to convert.
		 * 
		 * @return A new Array whose elements are items of the <code>vector</code> parameter.
		 * 
		 * @throws ArgumentError <code>vector</code> parameter is <code>null</code>.
		 * 
		 * @throws TypeError <code>vector</code> parameter must be of type 'Vector'.
		 */
		public static function toArray(vector:*):Array
		{
			if (vector == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "vector" ]));
			
			if (!isVector(vector))
				throw new TypeError(_resourceManager.getString("flameCore", "argTypeMismatch", [ "vector", getQualifiedClassName(Vector.<*>) ]));
			
			var array:Array = [];
		
		    for (var i:int = 0, count:int = vector.length; i < count; i++)
		        array[i] = vector[i];
		
		    return array;
		}
	}
}