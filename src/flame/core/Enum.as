////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.core
{
	import flash.errors.IllegalOperationError;
	import flash.utils.getQualifiedClassName;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	import mx.utils.DescribeTypeCache;
	
	/**
	 * The Enum utility class is an all-static class with methods for working with enumeration objects.
	 * You do not create instances of Enum;
	 * instead you call methods such as the <code>Enum.toString()</code> method.
	 */
	public final class Enum
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
		 * @throws flash.errors.IllegalOperationError Enum is an all-static class.
		 */
		public function Enum()
		{
			throw new IllegalOperationError(_resourceManager.getString("flameLocale", "staticClassInstance", [ getQualifiedClassName(Enum) ]));
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Public methods
	    //
	    //--------------------------------------------------------------------------
		
		/**
		 * Retrieves the name of the constant in the specified enumeration that has the specified value.
		 * 
		 * @param type An enumeration class.
		 * 
		 * @param value The value of a particular enumerated constant in terms of its underlying type.
		 * 
		 * @return A string containing the name of the enumerated constant in <code>type</code> parameter
		 * whose value is <code>value</code>; or <code>null</code> if no such constant is found.
		 * 
		 * @throws ArgumentError Thrown in the following situations:<ul>
		 * <li><code>type</code> parameter is <code>null</code>.</li>
		 * <li><code>value</code> parameter is <code>null</code>.</li>
		 * </ul>
		 */
		public static function getName(type:Class, value:*):String
		{
			if (type == null)
				throw new ArgumentError(_resourceManager.getString("flameLocale", "argNullGeneric", [ "type" ]));
			
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameLocale", "argNullGeneric", [ "value" ]));
			
			var typeDescription:XML = DescribeTypeCache.describeType(type).typeDescription;
			
			for each (var item:XML in typeDescription.child("constant"))
				if (type[item.@name.toString()] === value)
					return item.@name.toString();
			
			return null;
		}
		
		/**
		 * Converts the value of the specified enumeration to its equivalent string representation.
		 * 
		 * @param type An enumeration class.
		 * 
		 * @param value The value of a particular enumerated constant in terms of its underlying type.
		 * 
		 * @return The string representation of the enumerated constant in <code>type</code> parameter
		 * whose value is <code>value</code>; or <code>null</code> if no such constant is found.
		 * 
		 * @throws ArgumentError Thrown in the following situations:<ul>
		 * <li><code>type</code> parameter is <code>null</code>.</li>
		 * <li><code>value</code> parameter is <code>null</code>.</li>
		 * </ul>
		 */		
		public static function toString(type:Class, value:*):String
		{
			if (type == null)
				throw new ArgumentError(_resourceManager.getString("flameLocale", "argNullGeneric", [ "type" ]));
			
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameLocale", "argNullGeneric", [ "value" ]));
			
			var typeDescription:XML = DescribeTypeCache.describeType(type).typeDescription;
			var fieldDescription:XMLList = typeDescription.constant.(@name == getName(type, value));
			
			if (fieldDescription)
			{
				var metadataDescription:XMLList = fieldDescription.metadata.(@name == "Description");
				
				if (metadataDescription)
				{
					var args:XMLList = metadataDescription.child("arg");
					
					if (args.length() == 1 && args[0].@key == "")
						return args[0].@value.toString();
					else if (args.length() >= 2)
					{
						var resourceBundle:String = args.(@key == "resourceBundle").@value.toString();
						var resourceKey:String = args.(@key == "resourceKey").@value.toString();
						
						if (resourceBundle && resourceKey)
							return _resourceManager.getString(resourceBundle, resourceKey);
					}
				}
			}
			
			return null;
		}
	}
}