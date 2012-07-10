////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2011 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.controls.spark
{
	import flame.controls.TabClosePolicy;
	import flame.controls.events.TabEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import mx.collections.IList;
	import mx.containers.ViewStack;
	import mx.core.DragSource;
	import mx.core.EventPriority;
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.DragEvent;
	import mx.managers.DragManager;
	
	import spark.components.IItemRenderer;
	import spark.components.TabBar;
	import spark.events.IndexChangeEvent;
	import spark.events.RendererExistenceEvent;
	
	/**
	 * Dispatched when the tab index is changed as a result of drag-and-drop operation.
	 * 
	 * @eventType spark.events.IndexChangeEvent.CHANGE
	 */
	[Event(name="indexChange", type="spark.events.IndexChangeEvent")]
	
	/**
	 * Dispatched when the tab is closed.
	 * 
	 * @eventType flame.controls.events.TabEvent.TAB_CLOSE
	 */
	[Event(name="tabClose", type="flame.controls.events.TabEvent")]
	
	[ResourceBundle("flameLocale")]
	
	/**
	 * The AdvancedTabBar is an enhancment to the standard TabBar.
	 * It provides tab drag-and-drop functionality, closable tabs, and adds an ability
	 * to specify a custom style for the selected tab.
	 * 
	 * @see spark.components.TabBar
	 */
	public class AdvancedTabBar extends TabBar
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private var _dragEnabled:Boolean;
		private var _dropEnabled:Boolean;
		private var _localX:Number;
		private var _tabClosePolicy:String = TabClosePolicy.NEVER;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the AdvancedTabBar class.
		 */
		public function AdvancedTabBar()
		{
			super();
			
			addEventListener(TabEvent.TAB_CLOSE, tabCloseHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Returns close policy for the tab at the specified index.
		 * 
		 * @param index The index position of the tab.
		 * 
		 * @return The close policy for the tab at the specified index.
		 * 
		 * @throws RangeError <code>index</code> parameter is less than zero
		 * or greater than or equal to the length of the <code>numChildren</code> property.
		 * 
		 * @see flame.controls.TabClosePolicy
		 */
		public function getTabClosePolicyAt(index:int):String
		{
			if (index < 0 || index >= dataGroup.numElements)
				throw new RangeError(resourceManager.getString("flameLocale", "argOutOfRangeIndex", [ "index" ]));
			
			return AdvancedTabBarButton(dataGroup.getElementAt(index)).closePolicy;
		}
		
		/**
		 * Sets close policy for the tab at the specified index.
		 * 
		 * @param value The value to set.
		 * 
		 * @param index The index position of the tab.
		 * 
		 * @throws RangeError <code>index</code> parameter is less than zero
		 * or greater than or equal to the length of the <code>numChildren</code> property.
		 * 
		 * @see flame.controls.TabClosePolicy
		 */
		public function setTabClosePolicyAt(value:String, index:int):void
		{
			if (index < 0 || index >= dataGroup.numElements)
				throw new RangeError(resourceManager.getString("flameLocale", "argOutOfRangeIndex", [ "index" ]));
			
			AdvancedTabBarButton(dataGroup.getElementAt(index)).closePolicy = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		[Inspectable(category="General", enumeration="always,never,rollOver,selected", defaultValue="never")]
		
		/**
		 * Gets or sets the value that indicates whether the Close button is
		 * always present, always absent, or visible on mouse roll over or on tab select.
		 * 
		 * @see flame.controls.TabClosePolicy
		 */
		public function get tabClosePolicy():String
		{
			return _tabClosePolicy;
		}
		
		/**
		 * @private
		 */
		public function set tabClosePolicy(value:String):void
		{
			_tabClosePolicy = value;
		}
		
		[Inspectable(category="General", enumeration="false,true", defaultValue="false")]
		
		/**
		 * Gets or sets the value that indicates whether tabs can be moved as part of a drag-and-drop operation.
		 */
		public function get dragEnabled():Boolean
		{
			return _dragEnabled;
		}
		
		/**
		 * @private
		 */
		public function set dragEnabled(value:Boolean):void
		{
			_dragEnabled = value;
			
			if (dataGroup != null)
				for (var i:int = 0, count:int = dataGroup.numElements; i < count; i++)
					if (value)
						addTabDragListeners(getChildAt(i));
					else
						removeTabDragListeners(getChildAt(i));
		}
		
		[Inspectable(category="General", enumeration="false,true", defaultValue="false")]
		
		/**
		 * Gets or sets the value that indicates whether dragged tabs can be dropped onto the tab bar.
		 */
		public function get dropEnabled():Boolean
		{
			return _dropEnabled;
		}
		
		/**
		 * @private
		 */
		public function set dropEnabled(value:Boolean):void
		{
			_dropEnabled = value;
			
			if (dataGroup != null)
				for (var i:int = 0, count:int = dataGroup.numElements; i < count; i++)
					if (value)
						addTabDropListeners(getChildAt(i));
					else
						removeTabDropListeners(getChildAt(i));
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		protected override function dataGroup_rendererAddHandler(event:RendererExistenceEvent):void
		{
			super.dataGroup_rendererAddHandler(event);
			
			AdvancedTabBarButton(event.renderer).closePolicy = _tabClosePolicy;
			
			if (_dragEnabled)
				addTabDragListeners(event.renderer);
			
			if (_dropEnabled)
				addTabDropListeners(event.renderer);
		}
		
		/**
		 * @inheritDoc
		 */
		protected override function dataGroup_rendererRemoveHandler(event:RendererExistenceEvent):void
		{
			super.dataGroup_rendererRemoveHandler(event);
			
			removeTabDragListeners(event.renderer);
			removeTabDropListeners(event.renderer);
		}
		
		/**
		 * @inheritDoc
		 */
		protected override function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance == dataGroup)
				dataGroup.addEventListener(TabEvent.TAB_CLOSE, dataGroup_tabCloseHandler);
		}
		
		/**
		 * @inheritDoc
		 */
		protected override function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			if (instance == dataGroup)
				dataGroup.removeEventListener(TabEvent.TAB_CLOSE, dataGroup_tabCloseHandler);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function addTabDragListeners(tab:IEventDispatcher):void
		{
			tab.addEventListener(MouseEvent.MOUSE_DOWN, tab_mouseDownHandler, false, int.MAX_VALUE, true);
			tab.addEventListener(MouseEvent.MOUSE_UP, tab_mouseUpHandler, false, EventPriority.DEFAULT, true);
		}
		
		private function addTabDropListeners(tab:IEventDispatcher):void
		{
			tab.addEventListener(DragEvent.DRAG_DROP, tab_dragDropHandler, false, EventPriority.DEFAULT, true);
			tab.addEventListener(DragEvent.DRAG_ENTER, tab_dragEnterHandler, false, EventPriority.DEFAULT, true);
			tab.addEventListener(DragEvent.DRAG_EXIT, tab_dragExitHandler, false, EventPriority.DEFAULT, true);
			tab.addEventListener(DragEvent.DRAG_OVER, tab_dragOverHandler, false, EventPriority.DEFAULT, true);
		}
		
		private function removeTabDragListeners(tab:IEventDispatcher):void
		{
			tab.removeEventListener(MouseEvent.MOUSE_DOWN, tab_mouseDownHandler);
			tab.removeEventListener(MouseEvent.MOUSE_UP, tab_mouseUpHandler);
		}
		
		private function removeTabDropListeners(tab:IEventDispatcher):void
		{
			tab.removeEventListener(DragEvent.DRAG_DROP, tab_dragDropHandler);
			tab.removeEventListener(DragEvent.DRAG_ENTER, tab_dragEnterHandler);
			tab.removeEventListener(DragEvent.DRAG_EXIT, tab_dragExitHandler);
			tab.removeEventListener(DragEvent.DRAG_OVER, tab_dragOverHandler);
		}
		
		private function dataGroup_tabCloseHandler(event:TabEvent):void
		{
			event.stopImmediatePropagation();
			
			dispatchEvent(new TabEvent(TabEvent.TAB_CLOSE, false, true, event.index));
		}
		
		private function tab_dragDropHandler(event:DragEvent):void
		{
			_localX = Number.NaN;
			
			if (event.dragSource.hasFormat("tabDrag") && event.draggedItem != event.dragInitiator)
			{
				var dragTab:AdvancedTabBarButton = event.dragInitiator as AdvancedTabBarButton;
				var dropTab:AdvancedTabBarButton = event.target as AdvancedTabBarButton;
				var dragIndex:int = dataGroup.getElementIndex(dragTab);
				var dropIndex:int = dataGroup.getElementIndex(dropTab);
				
				dropTab.hideDropIndicator();
				
				if (dataProvider is ViewStack)
				{
					var child:DisplayObject = ViewStack(dataProvider).getChildAt(dragIndex);
					
					ViewStack(dataProvider).addChildAt(child, dropIndex);
				}
				else if (dataProvider is IList)
				{
					var dragItem:Object;
					var i:int;
					
					if (dragIndex < dropIndex)
					{
						dragItem = dataProvider.getItemAt(dragIndex);
						
						for (i = dragIndex + 1; i <= dropIndex; i++)
							dataProvider.setItemAt(dataProvider.getItemAt(i), i - 1);
						
						dataProvider.setItemAt(dragItem, dropIndex);
					}
					else if (dragIndex > dropIndex)
					{
						dragItem = dataProvider.getItemAt(dragIndex);
						
						for (i = dragIndex - 1; i >= dropIndex; i--)
							dataProvider.setItemAt(dataProvider.getItemAt(i), i + 1);
						
						dataProvider.setItemAt(dragItem, dropIndex);
					}
				}
				
				selectedIndex = dropIndex;
				
				dispatchEvent(new IndexChangeEvent(IndexChangeEvent.CHANGE, false, false, dragIndex, dropIndex));
			}
		}
		
		private function tab_dragEnterHandler(event:DragEvent):void
		{
			if (event.dragSource.hasFormat("tabDrag") && event.draggedItem != event.dragInitiator &&
				IUIComponent(event.target).parent == event.dragInitiator.parent &&
				(dataProvider is IList && event.dragSource.hasFormat("listData") ||
				dataProvider is ViewStack && event.dragSource.hasFormat("viewData")))
				DragManager.acceptDragDrop(event.target as IUIComponent);
		}
		
		private function tab_dragExitHandler(event:DragEvent):void
		{
			_localX = Number.NaN;
			
			AdvancedTabBarButton(event.target).hideDropIndicator();
		}
		
		private function tab_dragOverHandler(event:DragEvent):void
		{
			if (event.dragSource.hasFormat("tabDrag") && event.target != event.dragInitiator)
			{
				var tab:AdvancedTabBarButton = event.target as AdvancedTabBarButton;
				
				DragManager.showFeedback(DragManager.MOVE);
				
				if (!isNaN(_localX))
					tab.showDropIndicator(_localX > event.localX);
				
				_localX = event.localX;
			}
		}
		
		private function tab_mouseDownHandler(event:MouseEvent):void
		{
			var renderer:IItemRenderer = event.currentTarget as IItemRenderer;
			
			dataGroup.getElementAt(renderer.itemIndex).addEventListener(MouseEvent.MOUSE_MOVE, tab_mouseMoveHandler);
		}
		
		private function tab_mouseMoveHandler(event:MouseEvent):void
		{
			var renderer:IItemRenderer = event.currentTarget as IItemRenderer;
			
			var tab:AdvancedTabBarButton = dataGroup.getElementAt(renderer.itemIndex) as AdvancedTabBarButton;
			
			if (tab != null)
			{
				var dragSource:DragSource = new DragSource();
				
				dragSource.addData(event.target, "tabDrag");
				
				if (dataProvider is ViewStack)
					dragSource.addData(event.target, "viewData");
				else if (dataProvider is IList)
					dragSource.addData(event.target, "listData");
				
				var bitmapData:BitmapData = new BitmapData(tab.width, tab.height, true);
				
				bitmapData.draw(tab);
				
				var bitmap:Bitmap = new Bitmap(bitmapData);
				var dragImage:UIComponent = new UIComponent();
				
				dragImage.addChild(bitmap);
				
				tab.removeEventListener(MouseEvent.MOUSE_MOVE, tab_mouseMoveHandler);
				
				DragManager.doDrag(tab, dragSource, event, dragImage);
			}
		}
		
		private function tab_mouseUpHandler(event:MouseEvent):void
		{
			dataGroup.getElementAt(IItemRenderer(event.currentTarget).itemIndex).removeEventListener(MouseEvent.MOUSE_MOVE, tab_mouseMoveHandler);
		}
		
		private function tabCloseHandler(event:TabEvent):void
		{
			if (!event.isDefaultPrevented())
			{
				if (dataProvider is ViewStack)
					ViewStack(dataProvider).removeChildAt(event.index);
				else if (dataProvider is IList)
					dataProvider.removeItemAt(event.index);
			}
		}
	}
}