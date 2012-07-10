////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.collections
{
	import flame.utils.VectorUtil;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.utils.getQualifiedClassName;
	
	import mx.collections.IList;
	import mx.core.EventPriority;
	import mx.core.IPropertyChangeNotifier;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.PropertyChangeEvent;
	import mx.events.PropertyChangeEventKind;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	import mx.utils.UIDUtil;
	
	[DefaultProperty("source")]
	
	/**
	 * Dispatched when the IList has been updated in some way.
	 *
	 * @eventType mx.events.CollectionEvent.COLLECTION_CHANGE
	 */
	[Event(name="collectionChange", type="mx.events.CollectionEvent")]
	
	[ResourceBundle("flameLocale")]
	
	/**
	 * The VectorList class is a simple implementation of IList
	 * that uses a backing Vector as the source of the data.
	 * Items in the backing Vector can be accessed and manipulated
	 * using the methods and properties of the IList interface.
	 * Operations on a VectorList instance modify the data source;
	 * for example, if you use the <code>removeItemAt()</code> method
	 * on an VectorList, you remove the item from the underlying Vector.
	 * 
	 * @mxml
	 * 
	 * <pre>
	 * &#60;flame:VectorList
	 * <string>Properties</strong>
	 * source="null"
	 * /&#62;
	 * </pre>
	 * 
	 * @see mx.collections.IList
	 */
	public class VectorList extends EventDispatcher implements IExternalizable, IList, IPropertyChangeNotifier
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		protected var _resourceManager:IResourceManager = ResourceManager.getInstance();
		
		private var _source:*;
		private var _supressEvents:Boolean = true;
		private var _uid:String = UIDUtil.createUID();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the VectorList class.
		 * 
		 * @param source The data source to use.
		 * 
		 * @throws TypeError <code>source</code> parameter must be of type 'Vector'.
		 */
		public function VectorList(source:* = null)
		{
			super();
			
			if (source != null)
			{
				if (!(source is Vector.<*> || source is Vector.<Number> || source is Vector.<int> || source is Vector.<uint>))
					throw new TypeError(_resourceManager.getString("flameLocale", "argTypeMismatch",
						[ "source", getQualifiedClassName(Vector.<*>) ]));

				this.source = source;
			}
			
			_supressEvents = false;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------

		/**
		 * Adds a list of items to the current list,
		 * placing them at the end of the list in the order they are passed.
		 * 
		 * @param list The list of items to add to the current list.
		 * 
		 * @throws ArgumentError <code>list</code> parameter is <code>null</code>.
		 */
		public function addAll(list:IList):void
		{
			if (list == null)
				throw new ArgumentError(_resourceManager.getString("flameLocale", "argNullGeneric", [ "list" ]));
			
			addAllAt(list, length);
		}
		
		/**
		 * Adds a list of items to the current list, placing them at the position index passed in.
		 * The items are placed in the order they are recieved.
		 * 
		 * @param list The list of items to add to the current list.
		 * 
		 * @param index The zer-based index of the current list to place the new items.
		 * 
		 * @throws ArgumentError <code>list</code> parameter is <code>null</code>.
		 * 
		 * @throws RangeError <code>index</code> parameter is less than zero,
		 * or greater than the value of the <code>length</code> property.
		 */
		public function addAllAt(list:IList, index:int):void
		{
			if (list == null)
				throw new ArgumentError(_resourceManager.getString("flameLocale", "argNullGeneric", [ "list" ]));
			
			if (index < 0 || index > length)
				throw new RangeError(_resourceManager.getString("flameLocale", "argOutOfRangeInsert", [ "index" ]));
			
			for (var i:int = 0, count:int = list.length, offset:int = length; i < count; i++)
				addItemAt(list.getItemAt(i), offset + i);
		}
		
		/**
		 * Adds the specified item to the end of the list.
		 * 
		 * @param item The object to add.
		 */
		public function addItem(item:Object):void
		{
			addItemAt(item, length);
		}
		
		/**
		 * Adds the item at the specified index.
		 * Any item that was after this index is moved out by one.
		 * 
		 * @param item The object to add.
		 * 
		 * @param index The zero-based index to add the item at.
		 * 
		 * @throws RangeError <code>index</code> parameter is less than zero,
		 * or greater than the value of the <code>length</code> property.
		 */
		public function addItemAt(item:Object, index:int):void
		{
			if (index < 0 || index > length)
				throw new RangeError(_resourceManager.getString("flameLocale", "argOutOfRangeInsert", [ "index" ]));
			
			_source.splice(index, 0, item);
			
			watchUpdates(item);
			
			internalDispatchEvent(CollectionEventKind.ADD, item, index);
		}
		
		/**
		 * Returns the item at the specified index.
		 * 
		 * @param index The zero-based index in the list to retrieve the item from.
		 * 
		 * @param prefetch This parameter is not supported.
		 * 
		 * @return The item at the specified index.
		 * 
		 * @throws RangeError <code>index</code> parameter is less than zero,
		 * or equal to or greater than the value of the <code>length</code> property.
		 */
		public function getItemAt(index:int, prefetch:int = 0):Object
		{
			if (index < 0 || index >= length)
				throw new RangeError(_resourceManager.getString("flameLocale", "argOutOfRangeIndex", [ "index" ]));
			
			return _source[index];
		}
		
		/**
		 * Returns the index of the item if it is in the list.
		 * <p>Note that in this implementation the search is linear and is therefore O(n).</p>
		 * 
		 * @param item The item to find.
		 * 
		 * @return The index of the item if found; otherwise, -1.
		 */
		public function getItemIndex(item:Object):int
		{
			return _source == null ? -1 : _source.indexOf(item);
		}
		
		/**
		 * Notifies the view that an item has been updated.
		 * <p>This is useful if the contents of the view do not implement
		 * IEventDispatcher. If a property is specified,
		 * the view may be able to optimize its notification mechanism;
		 * otherwise, it may choose to simply refresh the whole view.</p>
		 * 
		 * @param item The item within the view that was updated.
		 * 
		 * @param property A String, a QName, or an int specifying the property that was updated.
		 * 
		 * @param oldValue The old value of the property.
		 * (If property was <code>null</code>, this can be the old value of the item.)
		 * 
		 * @param newValue The new value of the property.
		 * (If property was <code>null</code>, there's no need to specify this
		 * as the item is assumed to be the new value.)
		 * 
		 * @see mx.core.IPropertyChangeNotifier
		 * @see mx.events.CollectionEvent
		 * @see mx.events.PropertyChangeEvent
		 */
		public function itemUpdated(item:Object, property:Object = null, oldValue:Object = null, newValue:Object = null):void
		{
			item_propertyChangeHandler(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, false, false,
				PropertyChangeEventKind.UPDATE, property, oldValue, newValue, item));
		}
		
		/**
		 * Removes all items from the list.
		 */
		public function removeAll():void
		{
			if (length > 0)
			{
				for each (var item:Object in _source)
					unwatchUpdates(item);
				
				_source.splice(0, length);
				
				internalDispatchEvent(CollectionEventKind.RESET);
			}
		}
		
		/**
		 * Removes the specified item from the list.
		 * 
		 * @param item The object to remove.
		 * 
		 * @return <code>true</code> if the item was removed; otherwise, <code>false</code>.
		 */
		public function removeItem(item:Object):Boolean
		{
			var index:int = getItemIndex(item);
			
			if (index != -1)
			{
				removeItemAt(index);
				
				return true;
			}
			
			return false;
		}
		
		/**
		 * Removes the item at the specified index and returns it.
		 * Any items that were after this index are now one index earlier.
		 * 
		 * @param index The zero-based index to remove from.
		 * 
		 * @return The removed item.
		 * 
		 * @throws RangeError <code>index</code> parameter is less than zero,
		 * or equal to or greater than the value of the <code>length</code> property.
		 */
		public function removeItemAt(index:int):Object
		{
			if (index < 0 || index >= length)
				throw new RangeError(_resourceManager.getString("flameLocale", "argOutOfRangeIndex", [ "index" ]));
			
			var item:Object = _source.splice(index, 1)[0];
			
			unwatchUpdates(item);
			
			internalDispatchEvent(CollectionEventKind.REMOVE, item, index);
			
			return item;
		}
		
		/**
		 * Places the item at the specified index. If an item was already at the index,
		 * the new item will replace it and it will be returned.
		 * 
		 * @param item The object to set.
		 * 
		 * @param index The zer-based index to set the item at.
		 * 
		 * @return The replaced item.
		 * 
		 * @throws RangeError <code>index</code> parameter is less than zero,
		 * or equal to or greater than the value of the <code>length</code> property.
		 */		
		public function setItemAt(item:Object, index:int):Object
		{
			if (index < 0 || index >= length)
				throw new RangeError(_resourceManager.getString("flameLocale", "argOutOfRangeIndex", [ "index" ]));
			
			var oldItem:Object = _source[index];
			
			_source[index] = item;
			
			unwatchUpdates(oldItem);
			watchUpdates(item);
			
			if (!_supressEvents)
			{
				var hasCollectionChangeListener:Boolean = hasEventListener(CollectionEvent.COLLECTION_CHANGE);
				var hasPropertyChangeListener:Boolean = hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE);
				var propertyChangeEvent:PropertyChangeEvent;
				
				if (hasCollectionChangeListener || hasPropertyChangeListener)
					propertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE, false, false,
						PropertyChangeEventKind.UPDATE, index, oldItem, item);
				
				if (hasCollectionChangeListener)
				{
					var collectionEvent:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false,
						CollectionEventKind.UPDATE, index);
					
					collectionEvent.items.push(propertyChangeEvent);
					
					dispatchEvent(collectionEvent);
				}
				
				if (hasPropertyChangeListener)
					dispatchEvent(propertyChangeEvent);
			}
			
			return oldItem;
		}
		
		/**
		 * @private
		 */
		public function readExternal(input:IDataInput):void
		{
			source = input.readObject();
		}
		
		/**
		 * Returns an array that is populated in the same order as the IList implementation.
		 * 
		 * @return The populated array.
		 * 
		 * @see mx.collections.IList
		 */
		public function toArray():Array
		{
			return _source == null ? null : VectorUtil.toArray(_source);
		}
		
		/**
		 * Returns a string that represents this instance.
		 * 
		 * @return A string that represents this instance.
		 */
		public override function toString():String
		{
			return _source == null ? getQualifiedClassName(this) : _source.toString();
		}
		
		/**
		 * @private
		 */
		public function writeExternal(output:IDataOutput):void
		{
			output.writeObject(_source);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Gets the number of items in the list.
		 */
		public function get length():int
		{
			return _source == null ? 0 : _source.length;
		}
		
		/**
		 * Gets or sets the source Vector for this instance.
		 * <p>Any changes done through the IList interface will be reflected in the
		 * source Vector. Changes made directly to the underlying Vector
		 * (e.g., calling the <code>source.pop()</code> method) will not cause CollectionEvent to be dispatched.</p>
		 * 
		 * @throws TypeError <code>value</code> parameter must be of type 'Vector'.
		 *
		 *  @see mx.collections.IList
		 */
		public function get source():*
		{
			return _source;
		}
		
		/**
		 * @private
		 */
		public function set source(value:*):void
		{
			if (value != null && !(value is Vector.<*> || value is Vector.<Number> || value is Vector.<int> || value is Vector.<uint>))
				throw new TypeError(_resourceManager.getString("flameLocale", "argTypeMismatch",
					[ "value", getQualifiedClassName(Vector.<*>) ]));
		
			var item:Object;
		
			if (_source != null)
				for each (item in _source)
					unwatchUpdates(item);
			
			_source = value;
			
			if (_source != null)
				for each (item in _source)
					watchUpdates(item);
			
			if (!_supressEvents)
				dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE, false, false, CollectionEventKind.RESET));
		}
		
		/**
		 * Gets or sets to the unique id for this instance.
		 */
		public function get uid():String
		{
			return _uid;
		}
		
		/**
		 * @private
		 */
		public function set uid(value:String):void
		{
			_uid = value
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * The event handler called whenever any of the contained items in the list dispatch
		 * a <code>propertyChange</code> event.
		 * 
		 * @param event The dispatched event.
		 */
		protected function item_propertyChangeHandler(event:PropertyChangeEvent):void
		{
			internalDispatchEvent(CollectionEventKind.UPDATE, event);
			
			if (!_supressEvents && hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
			{
				var propertyChangeEvent:PropertyChangeEvent = event.clone() as PropertyChangeEvent;
				propertyChangeEvent.property = getItemIndex(event.target) + "." + event.property;
				
				dispatchEvent(propertyChangeEvent);
			}
		}
		
		/**
		 * Starts watching the specified item for updates if it is an IEventDispatcher.
		 * 
		 * @param item The object to watch.
		 */
		protected function watchUpdates(item:Object):void
		{
			if (item is IEventDispatcher)
				IEventDispatcher(item).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, item_propertyChangeHandler,
					false, EventPriority.DEFAULT, true);
		}
		
		/**
		 * Stops watching the specified item for updates if it is an IEventDispatcher.
		 * 
		 * @param item The object to unwatch.
		 */
		protected function unwatchUpdates(item:Object):void
		{
			if (item is IEventDispatcher)
				IEventDispatcher(item).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, item_propertyChangeHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function internalDispatchEvent(kind:String, item:Object = null, location:int = -1):void
		{
			if (!_supressEvents)
			{
				if (hasEventListener(CollectionEvent.COLLECTION_CHANGE))
				{
					var collectionEvent:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
					collectionEvent.kind = kind;
					collectionEvent.items.push(item);
					collectionEvent.location = location;
					
					dispatchEvent(collectionEvent);
				}
				
				if (hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE)
					&& (kind == CollectionEventKind.ADD || kind == CollectionEventKind.REMOVE))
				{
					var propertyChangeEvent:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
					propertyChangeEvent.property = location;
					
					if (kind == CollectionEventKind.ADD)
						propertyChangeEvent.newValue = item;
					else
						propertyChangeEvent.oldValue = item;
					
					dispatchEvent(propertyChangeEvent);
				}
			}
		}
	}
}