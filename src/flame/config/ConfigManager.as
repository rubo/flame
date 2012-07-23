////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.config
{
	import flame.crypto.HashAlgorithm;
	import flame.crypto.SHA1;
	import flame.utils.ByteArrayUtil;
	import flame.utils.Convert;
	
	import flash.errors.IllegalOperationError;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	import mx.utils.ObjectProxy;
	
	/**
	 * Dispatched when an error is thrown asynchronously.
	 * 
	 * @eventType flash.events.AsyncErrorEvent.ASYN_ERROR
	 */
	[Event(name="asyncError", type="flash.events.AsyncErrorEvent")]
	
	/**
	 * Dispatched after all the received configuration settings are decoded.
	 * The configuration settings can be accessed once this event has been dispatched.
	 * 
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * Dispatched if a call to the <code>ConfigManager.load()</code> method
	 * attempts to access data over HTTP. For content running in Flash Player,
	 * this event is only dispatched if the current Flash Player environment
	 * is able to detect and return the status code for the request.
	 * (Some browser environments may not be able to provide this information.)
	 * Note that the <code>httpStatus</code> event (if any)
	 * is sent before (and in addition to) any <code>complete</code> or <code>error</code> event.
	 * 
	 * @eventType flash.events.HTTPStatusEvent.HTTP_STATUS
	 * 
	 * @see #load() load()
	 */
	[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]
	
	/**
	 * Dispatched if a call to the <code>ConfigManager.load()</code> method
	 * results in a fatal error that terminates the download.
	 * 
	 * @eventType flash.events.IOErrorEvent.IO_ERROR
	 * 
	 * @see #load() load()
	 */
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	/**
	 * Dispatched when data is received as the download operation progresses.
	 * 
	 * @eventType flash.events.ProgressEvent.PROGRESS
	 * 
	 * @see #load() load()
	 */
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
	/**
	 * Dispatched if a call to the <code>ConfigManager.load()</code> method
	 * attempts to load data from a server outside the security sandbox.
	 * 
	 * @eventType flash.events.SecurityErrorEvent.SECURITY_ERROR
	 * 
	 * @see #load() load()
	 */
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	
	/**
	 * Dispatched when the ConfigManager instance is reporting its status or error condition.
	 * The <code>status</code> event contains an <code>info</code> property,
	 * which is an information object that contains specific information about the event,
	 * such as whether the settings was successfully saved to the underlying data store.
	 * 
	 * @eventType flash.events.StatusEvent.STATUS
	 */
	[Event(name="status", type="flash.events.StatusEvent")]
	
	[ResourceBundle("flameConfig")]
	[ResourceBundle("flameCore")]
	
	/**
	 * Provides access to the configuration settings loaded from an XML document
	 * or a local data store. This class cannot be inherited.
	 * <p>ConfigManager parses and converts the loaded XML document to its equivalent
	 * ActionScript representation using the Configuration Definition Language (CDL).
	 * CDL is an XML-based language that uses predefined elements and attributes in the following namespaces
	 * to manage data conversion, cacheability, and storage of the configuration settings.</p>
	 * <p><table class="innertable">
	 * <tr><th>Prefix</th><th>Namespace</th><th>Description</th></tr>
	 * <tr><td>c</td><td>library://flame/cdl/config</td>
	 * <td>An element or attribute qualified with this namespace is processed as a CDL instruction.</td></tr>
	 * <tr><td>b</td><td>library://flame/cdl/boolean</td>
	 * <td>The value of an attribute qualified with this namespace is converted to Boolean.</td></tr>
	 * <tr><td>d</td><td>library://flame/cdl/date</td>
	 * <td>The value of an attribute qualified with this namespace is converted to Date.</td></tr>
	 * <tr><td>n</td><td>library://flame/cdl/numeric</td>
	 * <td>The value of an attribute qualified with this namespace is converted to Number.</td></tr>
	 * <tr><td>s</td><td>library://flame/cdl/string</td>
	 * <td>The value of an attribute qualified with this namespace is converted to String.</td></tr>
	 * </table></p>
	 * <p>An element of the loaded XML document is converted to ObjectProxy
	 * with its attributes as the properties of the ObjectProxy object. Any attribute must be one of the types
	 * defined by the <code>b</code>, <code>d</code>, <code>n</code>, or <code>s</code> namespaces.
	 * If none of them is specified, the <code>s</code> namespace is used.</p>
	 * <p>To convert an XML element into an Array, it must contain one or more <code>c:item</code> elements
	 * which are converted to Array elements. If the <code>c:item</code> element has no child elements
	 * and has a single attribute only,  it is converted to the object of the type defined by that attribute;
	 * otherwise, it is parsed as a standard element.</p>
	 * <p>If the <code>c:item</code> element has <code>c:key</code> attribute,
	 * a dictionary is created instead of an array. The dictionary has type of ObjectProxy.
	 * The <code>c:key</code> attribute is used to access the converted <code>c:item</code> object in the dictionary.
	 * If the <code>c:item</code> element has no child elements and has only one attribute but the c:key,
	 * it is converted to the object of the type defined by that attribute; otherwise,
	 * it is parsed as a standard element.</p>
	 * <p><code>c:item</code> elements can be nested. For example, ConfigManager converts the following CDL:</p>
	 * <p><listing>
	 * &#60;configuration c:name="sample"
	 * 	xmlns:b="library://flame/cdl/boolean"
	 * 	xmlns:c="library://flame/cdl/config"
	 * 	xmlns:d="library://flame/cdl/date"
	 * 	xmlns:n="library://flame/cdl/numeric"
	 * 	xmlns:s="library://flame/cdl/string"&#62;
	 * 	&#60;servers c:cacheable="false"&#62;
	 * 		&#60;c:item s:host="127.0.0.1" n:port="8080" /&#62;
	 * 		&#60;c:item s:host="127.0.0.1" n:port="8181" /&#62;
	 * 	&#60;/servers&#62;
	 * 	&#60;roles&#62;
	 * 		&#60;c:item c:key="admin" b:enabled="true"&#62;
	 * 			&#60;permissions&#62;
	 * 				&#60;c:item s:value="read" /&#62;
	 * 				&#60;c:item s:value="write" /&#62;
	 * 			&#60;/permissions&#62;
	 * 		&#60;/c:item&#62;
	 * 		&#60;c:item c:key="limited" b:enabled="false"&#62;
	 * 			&#60;permissions&#62;
	 * 				&#60;c:item s:value="read" /&#62;
	 * 			&#60;/permissions&#62;
	 * 		&#60;/c:item&#62;
	 * 	&#60;/roles&#62;
	 * &#60;/configuration&#62;
	 * </listing>
	 * to the following ActionScript object:
	 * <listing>
	 * {
	 * 	servers: [
	 * 		new ObjectProxy({ host: "127.0.0.1", port: 8080 }),
	 * 		new ObjectProxy({ host: "127.0.0.1", port: 8181 })
	 * 	],
	 * 	roles: new ObjectProxy({
	 * 		admin: new ObjectProxy({
	 * 			enabled: true,
	 * 			permissions: [ "read", "write" ]
	 * 		}),
	 * 		limited: new ObjectProxy({
	 * 			enabled: false,
	 * 			permissions: [ "read" ]
	 * 		})
	 * 	})
	 * }
	 * </listing>
	 * </p>
	 * <p>To manage the cacheability of the configuration settings, CDL defines the <code>c:cacheable</code> attribute.
	 * This attribute has a Boolean type - that is, the valid values are "true" or "false".
	 * By default, all elements are cacheable. When a cached object is accessed,
	 * ConfigManager loads it from the underlying data store rather than loaded XML document.
	 * If an element in the XML document is changed after being cached, the newer version is cached and used.</p>
	 * <p><em>Note:</em> The <code>c:cacheable</code> attribute cannot be applied to <code>c:item</code> elements.
	 * Therefore, all child elements of a <code>c:item</code> element, including the nested <code>c:item</code> elements,
	 * are controlled by the <code>c:cacheable</code> attribute of the parent element
	 * of the topmost <code>c:item</code> element.</p>
	 * <p>Internally, ConfigManager uses a SharedObject as its underlying data store.
	 * CDL defines the following attributes to manage the storage process.
	 * These attributes are applied to the root element only.</p>
	 * <p><table class="innertable">
	 * <tr><th>Attribute</th><th>Description</th></tr>
	 * <tr><td>c:name</td><td>Defines the configuration name that is used to save settings
	 * to the underlying data store. This attribute is required and cannot be empty.</td></tr>
	 * <tr><td>c:path</td><td>Defines the full or partial path to the SWF file
	 * that loads the configuration settings and determines where the configuration data will be stored locally.
	 * The default value is "<code>/</code>".</td></tr>
	 * <tr><td>c:revision</td><td>Defines a revision of current configuration to manage cacheability.
	 * If the revision of the loaded XML is greater than the revision of the cache,
	 * the entire cache is cleared. Valid values include any positive integer. This attribute is optional.</td></tr>
	 * <tr><td>c:secure</td><td>Determines whether access to configuration settings
	 * is restricted to the SWF files which are delivered over an HTTPS connection.
	 * The default value is "<code>false</code>".</td></tr>
	 * </table></p>
	 */
	public final class ConfigManager extends EventDispatcher
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private static const BOOLEAN_NAMESPACE_URI:String = "library://flame/cdl/boolean";
		private static const CDL_NAMESPACE_URI:String = "library://flame/cdl/config";
		private static const DATE_NAMESPACE_URI:String = "library://flame/cdl/date";
		private static const NUMERIC_NAMESPACE_URI:String = "library://flame/cdl/numeric";
		private static const STRING_NAMESPACE_URI:String = "library://flame/cdl/string";
		
		private static var _instance:ConfigManager;
		
		private var _booleanPattern:RegExp = /^\s*(false|true)\s*$/i;
		private var _cacheableQName:QName = new QName(CDL_NAMESPACE_URI, "cacheable");
		private var _hashAlgorithm:HashAlgorithm = new SHA1();
		private var _itemQName:QName = new QName(CDL_NAMESPACE_URI, "item");
		private var _keyQName:QName = new QName(CDL_NAMESPACE_URI, "key");
		private var _numberPattern:RegExp = /^\s*\-?\d+(\.\d+)?\s*$/;
		private var _resourceManager:IResourceManager = ResourceManager.getInstance();
		private var _sharedObject:SharedObject;
		private var _sharedObjectIsSecure:Boolean;
		private var _sharedObjectName:String;
		private var _sharedObjectPath:String;
		private var _urlLoader:URLLoader = new URLLoader();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes the single instance of the ConfigManager class.
		 * To get the instance of the ConfigManager class, use the <code>getInstance()</code> method instead.
		 * 
		 * @throws flash.errors.IllegalOperationError ConfigManager has already been instantiated.
		 * 
		 * @see #getInstance() getInstance()
		 */
		public function ConfigManager()
		{
			super();
			
			if (_instance != null)
				throw new IllegalOperationError(_resourceManager.getString("flameCore", "singletonInstance", [ getQualifiedClassName(this) ]));
			
			_instance = this;
			
			_urlLoader.addEventListener(Event.COMPLETE, urlLoader_completeHandler);
			_urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, urlLoader_httpStatusHandler);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, urlLoader_ioErrorHandler);
			_urlLoader.addEventListener(ProgressEvent.PROGRESS, urlLoader_progressHandler);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, urlLoader_securityErrorHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Purges all of the settings data and deletes them from the underlying data store.
		 * 
		 * @throws ConfigError Configuration settings are not loaded.
		 */
		public function clear():void
		{
			if (_sharedObject == null)
				throw new ConfigError(_resourceManager.getString("flameConfig", "settingsNotLoaded"));
			
			_sharedObject.clear();
		}
		
		/**
		 * Saves changes that are made to the settings to the underlying data store.
		 * If this method is not used, the settings will be saved when the session ends.
		 * <p><em>Caution:</em> If you call <code>refresh()</code> method before calling
		 * <code>commitChanges()</code> method, any uncommitted changes to the settings will be lost.</p>
		 * 
		 * @throws ConfigError Configuration settings are not loaded.
		 * 
		 * @see #refresh() refresh()
		 */
		public function commitChanges():void
		{
			if (_sharedObject == null)
				throw new ConfigError(_resourceManager.getString("flameConfig", "settingsNotLoaded"));
			
			_sharedObject.flush();
		}
		
		/**
		 * Gets the single instance of the ConfigManager class.
		 * 
		 * @return The single instance of the ConfigManager class.
		 */
		public static function getInstance():ConfigManager
		{
			if (_instance == null)
				_instance = new ConfigManager();
			
			return _instance;
		}
		
		/**
		 * Loads the configuration settings from the specified URL.
		 *  
		 * @param url The URL to load from.
		 * 
		 * @throws ArgumentError <code>url</code> parameter is <code>null</code>.
		 */
		public function load(url:String):void
		{
			if (url == null)
				throw new ArgumentError(_resourceManager.getString("flameCore", "argNullGeneric", [ "url" ]));
			
			_urlLoader.load(new URLRequest(url));
		}
		
		/**
		 * Reloads the configuration settings from the underlying data store.
		 * <p><em>Caution:</em> Any uncommitted changes to the settings will be lost.
		 * Use the <code>commitChanges()</code> method to persist changes to the underlying data store.</p>
		 * 
		 * @throws ConfigError Configuration name is <code>null</code> or an empty string.
		 * 
		 * @see #commitChanges() commitChanges()
		 */
		public function refresh():void
		{
			if (!_sharedObjectName)
				throw new ConfigError(_resourceManager.getString("flameConfig", "invalidName"));
			
			if (_sharedObject != null)
				removeSharedObjectListeners();
			
			_sharedObject = SharedObject.getLocal(_sharedObjectName, _sharedObjectPath, _sharedObjectIsSecure);
			
			addSharedObjectListeners();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Gets the settings data for the currently loaded configuration.
		 */
		public function get settings():Object
		{
			if (_sharedObject != null)
				return _sharedObject.data;
			
			return null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function addSharedObjectListeners():void
		{
			_sharedObject.addEventListener(AsyncErrorEvent.ASYNC_ERROR, sharedObject_asyncErrorHandler);
			_sharedObject.addEventListener(NetStatusEvent.NET_STATUS, sharedObject_netStatusHandler);
		}
		
		private function parseAttribute(attribute:XML):*
		{
			switch (attribute.namespace().uri)
			{
				case BOOLEAN_NAMESPACE_URI:
					
					return parseBoolean(attribute);
				
				case CDL_NAMESPACE_URI:
					
					return null;
				
				case DATE_NAMESPACE_URI:
					
					return Convert.toDate(attribute.toString());
				
				case NUMERIC_NAMESPACE_URI:
				
					return parseNumber(attribute);
				
				default:
				
					return attribute.toString();
			}
		}
		
		private function parseBoolean(attribute:XML):Boolean
		{
			var value:String = attribute.toString();
			
			if (_booleanPattern.test(value))
				return Convert.toBoolean(value);
			
			throw new ConfigError(_resourceManager.getString("flameConfig", "invalidBooleanValue",
				[ attribute.localName(), value ]));
		}
		
		private function parseCollection(items:XMLList, cacheable:Boolean = false):*
		{
			var idCount:int = items.attribute(_keyQName).length();
			var index:int = 0;
			var keyed:Boolean = idCount != 0;
			
			if (keyed && idCount != items.length())
				throw new ConfigError(_resourceManager.getString("flameConfig", "invalidKeyedCollection"));
			
			var collection:* = keyed ? new ObjectProxy() : [];
			
			for each (var item:XML in items)
			{
				var key:* = keyed ? item.attribute(_keyQName).toString() : index;
				
				if (item.attributes().length() == (keyed ? 2 : 1) && item.children().length() == 0)
				{
					for each (var attribute:XML in item.attributes())
						if (attribute.namespace().uri != CDL_NAMESPACE_URI)
						{
							collection[key] = parseAttribute(attribute);
							
							break;
						}
				}
				else
					collection[key] = parseObject(item, null);
				
				index++;
			}

			if (cacheable)
			{
				var buffer:ByteArray = new ByteArray();
				buffer.writeObject(collection);
				
				collection.$collectionHash = ByteArrayUtil.toHexString(_hashAlgorithm.computeHash(buffer));
			}
			
			return collection;
		}
		
		private function parseNumber(attribute:XML):Number
		{
			var value:String = attribute.toString();
			
			if (_numberPattern.test(value))
				return Number(value);
			
			throw new ConfigError(_resourceManager.getString("flameConfig", "invalidNumberValue",
				[ attribute.localName(), value ]));
		}
		
		private function parseObject(xml:*, object:Object):Object
		{
			var cacheable:Boolean = xml.attribute(_cacheableQName).toString() != "false" && xml.name().toString() != _itemQName.toString();
			var items:XMLList = xml.child(_itemQName);
			var localName:String;
			
			if (items.length() != 0)
			{
				var collection:* = parseCollection(items, cacheable);
				
				if (cacheable && object != null && object.$collectionHash != collection.$collectionHash || !cacheable || object == null)
				{
					object = collection;
					
					cacheable = false;
				}
			}
			else if (object == null || !cacheable)
			{
				object = new ObjectProxy();
				
				cacheable = false;
			}
			
			for each (var attribute:XML in xml.attributes())
			{
				localName = attribute.localName();
				
				if (attribute.namespace().uri != CDL_NAMESPACE_URI && (cacheable && !object.hasOwnProperty(localName) || !cacheable))
					object[localName] = parseAttribute(attribute);
			}
			
			for each (var child:XML in xml.children())
			{
				cacheable = child.attribute(_cacheableQName).toString() == "true";
				localName = child.localName();
				
				switch (child.namespace().uri)
				{
					case BOOLEAN_NAMESPACE_URI:
					case DATE_NAMESPACE_URI:
					case NUMERIC_NAMESPACE_URI:
					case STRING_NAMESPACE_URI:
						
						if (!cacheable || !object.hasOwnProperty(localName))
							object[localName] = parseAttribute(child);
						
						break;
					
					case CDL_NAMESPACE_URI:
					
						break;
					
					default:
						
						object[localName] = parseObject(child, object[localName]);
						break;
				}
			}
			
			return object;
		}
		
		private function removeSharedObjectListeners():void
		{
			_sharedObject.removeEventListener(AsyncErrorEvent.ASYNC_ERROR, sharedObject_asyncErrorHandler);
			_sharedObject.removeEventListener(NetStatusEvent.NET_STATUS, sharedObject_netStatusHandler);
		}
		
		private function sharedObject_asyncErrorHandler(event:AsyncErrorEvent):void
		{
			dispatchEvent(event);
		}
		
		private function sharedObject_netStatusHandler(event:NetStatusEvent):void
		{
			dispatchEvent(new StatusEvent(StatusEvent.STATUS, false, false, event.info.code, event.info.level));
		}
		
		private function urlLoader_completeHandler(event:Event):void
		{
			try
			{
				if (_urlLoader.dataFormat == URLLoaderDataFormat.TEXT)
				{
					XML.ignoreWhitespace = true;
					
					var root:XML = new XML(_urlLoader.data);
					
					_sharedObjectName = root.attribute(new QName(CDL_NAMESPACE_URI, "name")).toString();
					
					if (!_sharedObjectName)
						throw new ConfigError(_resourceManager.getString("flameConfig", "invalidName"));
					
					var pathAttribute:XMLList = root.attribute(new QName(CDL_NAMESPACE_URI, "path"));
					
					_sharedObjectPath = pathAttribute.length() > 0 ? pathAttribute[0].toString() : "/";
					
					var secureAttribute:XMLList = root.attribute(new QName(CDL_NAMESPACE_URI, "secure"));
					
					if (secureAttribute.length() > 0)
						_sharedObjectIsSecure = parseBoolean(secureAttribute[0]);
					
					if (_sharedObject != null)
						removeSharedObjectListeners();
					
					_sharedObject = SharedObject.getLocal(_sharedObjectName, _sharedObjectPath, _sharedObjectIsSecure);
					
					addSharedObjectListeners();
					
					var revision:Number;
					var revisionAttribute:XMLList = root.attribute(new QName(CDL_NAMESPACE_URI, "revision"));
					
					if (revisionAttribute.length() > 0)
						revision = parseNumber(revisionAttribute[0]);
					
					if (isNaN(revision) || revision < 1)
						throw new ConfigError(_resourceManager.getString("flameConfig", "invalidRevision"));
					
					if (isNaN(_sharedObject.data.$revision) || _sharedObject.data.$revision < revision)
					{
						_sharedObject.clear();
						
						_sharedObject.data.$revision = revision;
					}
					
					parseObject(root, _sharedObject.data);
					
					_sharedObject.flush();
				}
				else
					throw new ConfigError(_resourceManager.getString("flameConfig", "invalidDataFormat"));
				
				dispatchEvent(event);
			}
			catch (e:Error)
			{
				dispatchEvent(new AsyncErrorEvent(AsyncErrorEvent.ASYNC_ERROR, false, false, e.message, e));
			}
		}
		
		private function urlLoader_httpStatusHandler(event:HTTPStatusEvent):void
		{
			dispatchEvent(event);
		}
		
		private function urlLoader_ioErrorHandler(event:IOErrorEvent):void
		{
			dispatchEvent(event);
		}
		
		private function urlLoader_progressHandler(event:ProgressEvent):void
		{
			dispatchEvent(event);
		}
		
		private function urlLoader_securityErrorHandler(event:SecurityErrorEvent):void
		{
			dispatchEvent(event);
		}
	}
}