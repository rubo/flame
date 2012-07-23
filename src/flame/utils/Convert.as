////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.utils
{
	import flame.serialization.JSONSerializer;
	
	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	import mx.formatters.DateFormatter;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	import mx.utils.Base64Decoder;
	import mx.utils.Base64Encoder;
	import mx.utils.StringUtil;
	
	[ResourceBundle("flameCore")]
	
	/**
	 * The Convert utility class is an all-static class
	 * with methods for convertion a base data type to another base data type.
	 * You do not create instances of Convert;
	 * instead you call methods such as the <code>Convert.toString()</code> method.  
	 */
	public final class Convert
	{
		//--------------------------------------------------------------------------
	    //
	    //  Fields
	    //
	    //--------------------------------------------------------------------------
	    
	    private static var _base64Encoder:Base64Encoder = new Base64Encoder();
	    private static var _base64Decoder:Base64Decoder = new Base64Decoder();
		private static var _jsonSerializer:JSONSerializer = new JSONSerializer();
	    private static var _resourceManager:IResourceManager = ResourceManager.getInstance();
	    
	    //--------------------------------------------------------------------------
	    //
	    //  Static constructor
	    //
	    //--------------------------------------------------------------------------
	    
	    {
	    	_base64Encoder.insertNewLines = false;
	    }
	    
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @throws flash.errors.IllegalOperationError Convert is an all-static class.
		 */
		public function Convert()
		{
			throw new IllegalOperationError(_resourceManager.getString("flameCore", "staticClassInstance",
				[ getQualifiedClassName(Convert) ]));
		}
		
	    //--------------------------------------------------------------------------
	    //
	    //  Public methods
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Converts the specified string, which encodes binary data as base-64 digits, to a ByteArray.
		 * <p>Internally, <code>fromBase64String()</code> method uses Base64Decoder to decode data.</p>
		 * 
		 * @param value The string to convert.
		 * 
		 * @return A ByteArray that is equivalent to <code>value</code> parameter.
		 * 
		 * @throws ArgumentError <code>value</code> parameter is <code>null</code>.
		 * 
		 * @see mx.utils.Base64Decoder
		 */
	    public static function fromBase64String(value:String):ByteArray
	    {
	    	if (value == null)
	    		throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
	    	
	    	_base64Decoder.reset();
	    	
	    	_base64Decoder.decode(value);
	    	
	    	return _base64Decoder.toByteArray();
	    }
		
		/**
		 * Converts the specified JSON string to an object graph.
		 * <p>Internally, <code>fromJSONString()</code> method uses JSONSerializer to deserialize data.</p>
		 * 
		 * @param value The JSON string to be deserialized.
		 * 
		 * @return The deserialized object.
		 * 
		 * @throws ArgumentError <code>value</code> parameter is <code>null</code>.
		 * 
		 * @see flame.serialization.JSONSerializer
		 */
		public static function fromJSONString(value:String):Object
		{
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
			return _jsonSerializer.deserialize(value);
		}
	    
		/**
		 * URL-decodes a string and returns the decoded string.
		 * <p>Internally, <code>fromURLEncoded()</code> method uses
		 * <code>decodeURIComponent()</code> method to decode strings.</p>
		 * 
		 * @param value The string to decode.
		 * 
		 * @return The decoded text.
		 * 
		 * @see global#decodeURIComponent() decodeURIComponent()
		 */		
	    public static function fromURLEncoded(value:String):String
	    {
	    	return decodeURIComponent(value);
	    }
	    
		/**
		 * Converts a ByteArray to its equivalent string representation that is encoded with base-64 digits.
		 * <p>Internally, <code>toBase64String()</code> method uses Base64Encoder to encode data.</p>
		 * 
		 * @param data The ByteArray to convert.
		 * 
		 * @return The string representation, in base-64, of the contents of <code>data</code> parameter.
		 * 
		 * @throws ArgumentError <code>data</code> parameter is <code>null</code>.
		 * 
		 * @see mx.utils.Base64Encoder
		 */
	    public static function toBase64String(data:ByteArray):String
	    {
	    	if (data == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "data" ]));
	    	
	    	_base64Encoder.reset();
	    	
	    	_base64Encoder.encodeBytes(data);
	    	
	    	return _base64Encoder.toString();
	    }
	    
		/**
		 * Converts the value of a specified object to an equivalent Boolean value.
		 * 
		 * @param value The object to convert.
		 * 
		 * @return <code>true</code> or <code>false</code>.
		 * If value is <code>null</code>, the method returns <code>false</code>.
		 */
	    public static function toBoolean(value:Object):Boolean
	    {
			if (value is int || value is Number || value is uint || value is Boolean)
	    		return Boolean(value);
	    	
			if (value is String)
	    		return mx.utils.StringUtil.trim(String(value).toLowerCase()) == "true";
	    	
	    	return value != null;
	    }
	    
		/**
		 * Converts the specified string representation of a date and time to an equivalent date and time value.
		 * <p>Internally, <code>toDate()</code> method uses <code>DateFormatter.parseDateString()</code> method
		 * to convert date strings.</p>
		 * 
		 * @param value The string representation of a date and time.
		 * 
		 * @return The date and time equivalent of the value of <code>value</code> parameter.
		 * 
		 * @throws ArgumentError <code>value</code> parameter is <code>null</code>.
		 * 
		 * @see mx.formatters.DateFormatter
		 */
	    public static function toDate(value:String):Date
	    {
			if (value == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "value" ]));
			
	    	return DateFormatter.parseDateString(value);
	    }
	    
		/**
		 * Converts the value of the specified object to a signed integer.
		 * <p>Internally, <code>toInt()</code> method uses <code>parseInt()</code> method to convert objects.</p>
		 * 
		 * @param value The object to convert.
		 * 
		 * @return A signed integer equivalent to <code>value</code> parameter,
		 * or zero if <code>value</code> parameter is <code>null</code>.
		 * 
		 * @see global#parseInt() parseInt()
		 */
	    public static function toInt(value:Object):Number
	    {
	    	return value == null ? 0 : parseInt(value.toString());
	    }
		
		/**
		 * Converts an object to a JSON string.
		 * <p>Internally, <code>toJSONString()</code> method uses JSONSerializer to serialize objects.</p>
		 * 
		 * @param value The object to serialize.
		 * 
		 * @return The serialized JSON string.
		 * 
		 * @see flame.serialization.JSONSerializer
		 */
		public static function toJSONString(value:*):String
		{
			return _jsonSerializer.serialize(value);
		}
	    
		/**
		 * Converts the value of the specified object to a floating-point number.
		 * <p>Internally, <code>toNumber()</code> method uses <code>parseFloat()</code> method to convert objects.</p>
		 * 
		 * @param value The object to convert.
		 * 
		 * @return A floating-point number that is equivalent to <code>value</code> parameter,
		 * or <code>Number.NaN</code> if <code>value</code> parameter is <code>null</code>.
		 * 
		 * @see global#parseFloat() parseFloat()
		 */
	    public static function toNumber(value:Object):Number
	    {
	    	return value == null ? Number.NaN : parseFloat(value.toString());
	    }
	    
		/**
		 * Converts the value of the specified object to its equivalent string representation.
		 * 
		 * @param value The object to convert.
		 * 
		 * @return The string representation of <code>value</code> parameter,
		 * or an empty string ("") if <code>value</code> parameter is <code>null</code>.
		 */
	    public static function toString(value:Object):String
	    {
			return value == null ? "" : value.toString();
	    }
	    
		/**
		 * URL-encodes a string and returns the encoded string.
		 * <p>Internally, <code>toURLEncoded()</code> method uses
		 * <code>encodeURIComponent()</code> method to encode strings.</p>
		 * 
		 * @param value The string to encode.
		 * 
		 * @return The URL-encoded text.
		 * 
		 * @see global#encodeURIComponent() encodeURIComponent()
		 */
	    public static function toURLEncoded(value:String):String
	    {
	    	return encodeURIComponent(value);
	    }
	}
}