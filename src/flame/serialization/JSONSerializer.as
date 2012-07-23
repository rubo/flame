////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.serialization
{
	import flame.utils.StringUtil;
	
	import flash.utils.getQualifiedClassName;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	import mx.utils.DescribeTypeCache;

	[ResourceBundle("flameCore")]
	[ResourceBundle("flameSerialization")]
	
	/**
	 * Serializes and deserializes objects into and from JSON strings.
	 * This class cannot be inherited.
	 */
	public final class JSONSerializer
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private static var _resourceManager:IResourceManager = ResourceManager.getInstance();
		
		private var _maxJSONLength:int = 0x200000;
		private var _recursionLimit:int = 100;
		private var _tokenizer:JSONTokenizer;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the JSONSerializer class. 
		 */
		public function JSONSerializer()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Converts the specified JSON string to an object graph.
		 *  
		 * @param value The JSON string to be deserialized.
		 * 
		 * @return The deserialized object.
		 * 
		 * @throws ArgumentError Thrown in the following situations:<ul>
		 * <li><code>value</code> parameter is <code>null</code>.</li>
		 * <li>The <code>value</code> length exceeds the value of the <code>maxJSONLength</code> property.</li>
		 * <li>The recursion limit defined by the <code>recursionLimit</code> property was exceeded.</li>
		 * </ul>
		 * 
		 * @throws flame.serialization.JSONError <code>value</code> parameter contains an unexpected character sequence.
		 */
		public function deserialize(value:String):*
		{
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
			if (value.length > _maxJSONLength)
				throw new ArgumentError(_resourceManager.getString("flameSerialization", "jsonMaxLengthExceeded"));
			
			if (StringUtil.isNullOrWhiteSpace(value))
				return null;
			
			_tokenizer = new JSONTokenizer(value);
			
			return deserializeValue(_tokenizer.nextToken(), 1);
		}
		
		/**
		 * Converts an object to a JSON string.
		 *  
		 * @param value The object to serialize.
		 * 
		 * @return The serialized JSON string.
		 * 
		 * @throws ArgumentError Thrown in the following situations:<ul>
		 * <li>The resulting JSON string exceeds the value of the <code>maxJSONLength</code> property.</li>
		 * <li>The recursion limit defined by the <code>recursionLimit</code> property was exceeded.</li>
		 * <li><code>value</code> parameter contains a circular reference.
		 * A circular reference occurs when a child object has a reference to a parent object,
		 * and the parent object has a reference to the child object.</li>
		 * </ul>
		 */
		public function serialize(value:*):String
		{
			var json:String = serializeValue(value, 1, []);
			
			if (json.length > _maxJSONLength)
				throw new ArgumentError(_resourceManager.getString("flameSerialization", "jsonMaxLengthExceeded"));
			
			return json;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Gets or sets the maximum length of JSON strings that are accepted by the JSONSerializer class.
		 * 
		 * @throws RangeError The maximum allowed JSON length is less than one.
		 */
		public function get maxJSONLength():int
		{
			return _maxJSONLength;
		}
		
		/**
		 * @private
		 */
		public function set maxJSONLength(value:int):void
		{
			if (value < 1)
				throw new RangeError(_resourceManager.getString("flameSerialization", "argInvalidMaxJSONLength"));
			
			_maxJSONLength = value;
		}
		
		/**
		 * Gets or sets the limit for constraining the number of object levels to process.
		 * 
		 * @throws RangeError The recursion limit is less than one.
		 */
		public function get recursionLimit():int
		{
			return _recursionLimit;
		}
		
		/**
		 * @private
		 */
		public function set recursionLimit(value:int):void
		{
			if (value < 1)
				throw new RangeError(_resourceManager.getString("flameSerialization", "argInvalidRecursionLimit"));
			
			_recursionLimit = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function deserializeArray(depth:int):Array
		{
			var array:Array = [];
			var token:JSONToken = _tokenizer.nextToken();
			
			if (token.type == JSONTokenType.RIGHT_SQUARE_BRACKET)
				return array;
			
			var key:String;
			
			depth++;
			
			while (true)
			{
				array.push(deserializeValue(token, depth));
				
				token = _tokenizer.nextToken();
				
				if (token.type == JSONTokenType.RIGHT_SQUARE_BRACKET)
					return array;
				else if (token.type == JSONTokenType.COMMA)
					token = _tokenizer.nextToken();
				else
					throw new JSONError(_resourceManager.getString("flameSerialization", "jsonInvalidArrayMissingCommaOrRightBracket",
						[ _tokenizer.position ]));
			}
			
			return null;
		}
		
		private function deserializeObject(depth:int):Object
		{
			var object:Object = {};
			var token:JSONToken = _tokenizer.nextToken();
			
			if (token.type == JSONTokenType.RIGHT_CURLY_BRACKET)
				return object;
			
			var key:String;
			
			depth++;
			
			while (true)
			{
				if (token.type == JSONTokenType.STRING)
				{
					key = token.value;
					
					token = _tokenizer.nextToken();
					
					if (token.type == JSONTokenType.COLON)
					{
						object[key] = deserializeValue(_tokenizer.nextToken(), depth);
						
						token = _tokenizer.nextToken();
						
						if (token.type == JSONTokenType.RIGHT_CURLY_BRACKET)
							return object;
						else if (token.type == JSONTokenType.COMMA)
							token = _tokenizer.nextToken();
						else
							throw new JSONError(_resourceManager.getString("flameSerialization", "jsonInvalidObjectMissingCommaOrRightBracket",
								[ _tokenizer.position ]));
					}
					else
						throw new JSONError(_resourceManager.getString("flameSerialization", "jsonInvalidObjectMissingColon",
							[ _tokenizer.position ]));
				}
				else
					throw new JSONError(_resourceManager.getString("flameSerialization", "jsonInvalidObjectMissingMemberName",
						[ _tokenizer.position ]));
			}
			
			return null;
		}
		
		private function deserializeValue(token:JSONToken, depth:int):*
		{
			if (depth > _recursionLimit)
				throw new ArgumentError(_resourceManager.getString("flameSerialization", "jsonDepthLimitExceeded"));
			
			switch (token.type)
			{
				case JSONTokenType.FALSE:
				case JSONTokenType.NULL:
				case JSONTokenType.NUMBER:
				case JSONTokenType.TRUE:
					
					return token.value;
				
				case JSONTokenType.STRING:
					
					return token.value;
					
				case JSONTokenType.LEFT_CURLY_BRACKET:
					
					return deserializeObject(depth);
				
				case JSONTokenType.LEFT_SQUARE_BRACKET:
					
					return deserializeArray(depth);
				
				default:
					
					throw new JSONError(_resourceManager.getString("flameSerialization", "jsonIllegalPrimitive", [ token.value ]));
			}
		}
		
		private function serializeArray(value:Array, depth:int, objectsInUse:Array):String
		{
			var string:String = "";
			
			depth++;
			
			for each (var object:Object in objectsInUse)
				if (value === object)
					throw new ArgumentError(_resourceManager.getString("flameSerialization", "jsonCircularReference",
						[ getQualifiedClassName(value) ]));
			
			objectsInUse.push(value);
			
			for (var i:int = 0, count:int = value.length; i < count; i++)
			{
				if (string.length > 0)
					string += ",";
					
				string += serializeValue(value[i], depth, objectsInUse);
			}
			
			objectsInUse.splice(objectsInUse.indexOf(value), 1);
			
			return "[" + string + "]";	
		}
		
		private function serializeObject(value:Object, depth:int, objectsInUse:Array):String
		{
			var string:String = "";
			var typeDescription:XML = DescribeTypeCache.describeType(value).typeDescription;
			
			depth++;
			
			for each (var object:Object in objectsInUse)
				if (value === object)
					throw new ArgumentError(_resourceManager.getString("flameSerialization", "jsonCircularReference",
						[ getQualifiedClassName(value) ]));
			
			objectsInUse.push(value);
				
			if (typeDescription.@name.toString() == "Object")
			{
				for (var key:String in value)
					if (!(value[key] is Function))
					{
						if (string.length > 0)
							string += ",";
						
						string += serializeString(key) + ":" + serializeValue(value[key], depth, objectsInUse);
					}
			}
			else
				for each (var element:XML in typeDescription..*.(name() == "accessor" || name() == "variable"))
					if (element.metadata.(@name.toString() == "Transient").length() == 0)
					{
						if (string.length > 0)
							string += ",";
						
						string += serializeString(element.@name.toString()) + ":"
							+ serializeValue(value[new QName(element.@uri.toString(), element.@name.toString())], depth, objectsInUse);
					}
			
			objectsInUse.splice(objectsInUse.indexOf(value), 1);
			
			return "{" + string + "}";
		}
		
		private function serializeString(value:String):String
		{
			var char:String;
			var string:String = "";
			
			for (var i:int = 0, count:int = value.length; i < count; i++)
			{
				char = value.charAt(i);
				
				switch (char)
				{
					case "\"":
						
						string += "\\\"";
						break;
					
					case "\\":
						
						string += "\\\\";
						break;
					
					case "\b":
						
						string += "\\b";
						break;
					
					case "\f":
						
						string += "\\f";
						break;
					
					case "\n":
						
						string += "\\n";
						break;
					
					case "\r":
						
						string += "\\r";
						break;
					
					default:
						
						string += char < " " ? "\\u" + StringUtil.padLeft(char.charCodeAt(i).toString(16), 4, "0") : char;
						break;
				}
			}
			
			return "\"" + string + "\"";
		}
		
		private function serializeValue(value:*, depth:int, objectsInUse:Array):String
		{
			if (depth > _recursionLimit)
				throw new ArgumentError(_resourceManager.getString("flameSerialization", "jsonDepthLimitExceeded"));
			
			if (value is Array)
				return serializeArray(value, depth, objectsInUse);
			else if (value is Boolean)
				return value ? "true" : "false";
			else if (value is Date)
				return "\\/Date(" + value.time + ")\\/";
			else if (value is Number)
				return isFinite(value) ? value.toString() : "null";
			else if (value is String)
				return serializeString(value);
			else if (value is Object)
				return serializeObject(value, depth, objectsInUse);
			
			return "null";
		}
	}
}