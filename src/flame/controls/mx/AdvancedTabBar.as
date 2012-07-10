////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2011 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.controls.mx
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
	import mx.controls.Button;
	import mx.controls.TabBar;
	import mx.core.ClassFactory;
	import mx.core.DragSource;
	import mx.core.EventPriority;
	import mx.core.IFlexDisplayObject;
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.events.DragEvent;
	import mx.events.IndexChangedEvent;
	import mx.managers.DragManager;

	/**
	 * Dispatched when the tab index is changed as a result of drag-and-drop operation.
	 * 
	 * @eventType mx.events.IndexChangedEvent.CHANGE
	 */
	[Event(name="change", type="mx.events.IndexChangedEvent")]
	
	/**
	 * Dispatched when the tab is closed.
	 * 
	 * @eventType flame.controls.events.TabEvent.TAB_CLOSE
	 */
	[Event(name="tabClose", type="flame.controls.events.TabEvent")]
	
	[ResourceBundle("flameLocale")]
	
	/**
	 * Name of CSS style declaration that specifies style for the selected tab.
	 * 
	 * @default undefined
	 */
	[Style(name="selectedTabStyleName", type="String", inherit="no")]
	
	/**
	 * Name of CSS style declaration that specifies max width for each tab.
	 * 
	 * @default undefined
	 */
	[Style(name="tabMaxWidth", type="Number", format="Length", inherit="no")]
	
	/**
	 * Name of CSS style declaration that specifies min width for each tab.
	 * 
	 * @default undefined
	 */
	[Style(name="tabMinWidth", type="Number", format="Length", inherit="no")]
	
	/**
	 * The AdvancedTabBar is an enhancment to the standard TabBar.
	 * It provides tab drag-and-drop functionality, closable tabs, and adds an ability
	 * to specify a custom style for the selected tab.
	 * 
	 * @see mx.controls.TabBar
	 */
	public class AdvancedTabBar extends TabBar
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Represents the name of style used to specify the <code>selectedTabStyleName</code>. 
		 */
		protected var _selectedTabStyleNameProp:String = "selectedTabStyleName";
		
		/**
		 * Indicates whether <code>selectedTabStyleName</code> property has changed.
		 */
		protected var _selectedTabStyleNamePropChanged:Boolean;
		
		/**
		 * Represents the name of style used to specify the <code>tabMaxWidth</code>. 
		 */
		protected var _tabMaxWidthProp:String = "tabMaxWidth";
		
		/**
		 * Represents the name of style used to specify the <code>tabMinWidth</code>. 
		 */
		protected var _tabMinWidthProp:String = "tabMinWidth";
		
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
			
			mx_internal::navItemFactory = new ClassFactory(AdvancedTab);
			
			addEventListener(TabEvent.TAB_CLOSE, tabCloseHandler, false, EventPriority.DEFAULT_HANDLER);
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
			if (index < 0 || index >= numChildren)
				throw new RangeError(resourceManager.getString("flameLocale", "argOutOfRangeIndex", [ "index" ]));
			
			return AdvancedTab(getChildAt(index)).closePolicy;
		}
		
		/**
		 * Resets the tab bar to its default state.
		 */
		public function resetTabs():void
		{
			resetNavItems();
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
			if (index < 0 || index >= numChildren)
				throw new RangeError(resourceManager.getString("flameLocale", "argOutOfRangeIndex", [ "index" ]));
			
			AdvancedTab(getChildAt(index)).closePolicy = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public override function styleChanged(styleProp:String):void
		{
			super.styleChanged(styleProp);
			
			var allStyles:Boolean = styleProp == null || styleProp == "styleName";
			
			if (allStyles || styleProp == _selectedTabStyleNameProp)
			{
				_selectedTabStyleNamePropChanged = true;
				
				invalidateDisplayList();
			}
			
			if (allStyles || styleProp == _tabMaxWidthProp || styleProp == _tabMinWidthProp
				|| (styleManager.isInheritingStyle(styleProp) &&  styleManager.isSizeInvalidatingStyle(styleProp)))
				resetButtonWidths();
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
			
			invalidateDisplayList();
			
			for (var i:int = 0; i < numChildren; i++)
				AdvancedTab(getChildAt(i)).closePolicy = value;
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
			
			for (var i:int = 0, count:int = numChildren; i < count; i++)
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
			
			for (var i:int = 0, count:int = numChildren; i < count; i++)
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
		 * @inhertiDoc 
		 */
		protected override function createNavItem(label:String, icon:Class = null):IFlexDisplayObject
		{
			var tab:AdvancedTab = super.createNavItem(label, icon) as AdvancedTab;
			tab.closePolicy = tabClosePolicy;
			
			tab.addEventListener(TabEvent.TAB_CLOSE, tab_tabCloseHandler, false, EventPriority.DEFAULT, true);
			
			if (dragEnabled)
				addTabDragListeners(tab);
			
			if (dropEnabled)
				addTabDropListeners(tab);
			
			return tab;
		}
		
		/**
		 * @inheritDoc
		 */
		protected override function hiliteSelectedNavItem(index:int):void
		{
			var child:Button;
			
			// Un-hilite the current selection
			if (selectedIndex != -1 && selectedIndex < numChildren)
			{
				child = getChildAt(selectedIndex) as Button;
				
				child.styleName = getStyle(super.mx_internal::buttonStyleNameProp);
				
				child.invalidateDisplayList();
				child.invalidateSize();
			}
			
			super.hiliteSelectedNavItem(index);
			
			if (index > -1)
			{
				// Hilite the new selection
				child = Button(getChildAt(selectedIndex));
				
				var selectedTabStyleName:String = getStyle(_selectedTabStyleNameProp);
				
				if (selectedTabStyleName)
					child.styleName = selectedTabStyleName;
				
				child.invalidateDisplayList();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		protected override function resetButtonWidths():void
		{
			for (var i:int = 0; i < numChildren; i++)
			{
				var child:Button = getChildAt(i) as Button;
				
				if (child)
				{
					child.explicitWidth = Number.NaN;
					child.maxWidth = getStyle(_tabMaxWidthProp);
					child.minWidth = getStyle(_tabMinWidthProp);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if (_selectedTabStyleNamePropChanged)
			{
				hiliteSelectedNavItem(selectedIndex);
				
				_selectedTabStyleNamePropChanged = false;
			}
			
			resetButtonWidths();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function addTabDragListeners(tab:IEventDispatcher):void
		{
			tab.addEventListener(MouseEvent.MOUSE_DOWN, tab_mouseDownHandler, false, EventPriority.DEFAULT, true);
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
		
		private function tab_dragDropHandler(event:DragEvent):void
		{
			_localX = Number.NaN;
			
			if (event.dragSource.hasFormat("tabDrag") && event.draggedItem != event.dragInitiator)
			{
				var dragTab:AdvancedTab = event.dragInitiator as AdvancedTab;
				var dropTab:AdvancedTab = event.target as AdvancedTab;
				var dragIndex:int = getChildIndex(dragTab);
				var dropIndex:int = getChildIndex(dropTab);
				
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
						dragItem = IList(dataProvider).getItemAt(dragIndex);
						
						for (i = dragIndex + 1; i <= dropIndex; i++)
							IList(dataProvider).setItemAt(IList(dataProvider).getItemAt(i), i - 1);
						
						IList(dataProvider).setItemAt(dragItem, dropIndex);
					}
					else if (dragIndex > dropIndex)
					{
						dragItem = IList(dataProvider).getItemAt(dragIndex);
						
						for (i = dragIndex - 1; i >= dropIndex; i--)
							IList(dataProvider).setItemAt(IList(dataProvider).getItemAt(i), i + 1);
						
						IList(dataProvider).setItemAt(dragItem, dropIndex);
					}
				}
				
				selectedIndex = dropIndex;
				
				dispatchEvent(new IndexChangedEvent(IndexChangedEvent.CHANGE, false, false, dragTab, dragIndex, dropIndex, event));
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
			
			AdvancedTab(event.target).hideDropIndicator();
		}
		
		private function tab_dragOverHandler(event:DragEvent):void
		{
			if (event.dragSource.hasFormat("tabDrag") && event.target != event.dragInitiator)
			{
				var tab:AdvancedTab = event.target as AdvancedTab;

				DragManager.showFeedback(DragManager.MOVE);
				
				if (!isNaN(_localX))
					tab.showDropIndicator(_localX > event.localX);
				
				_localX = event.localX;
			}
		}
		
		private function tab_mouseDownHandler(event:MouseEvent):void
		{
			IEventDispatcher(event.target).addEventListener(MouseEvent.MOUSE_MOVE, tab_mouseMoveHandler);
		}
		
		private function tab_mouseMoveHandler(event:MouseEvent):void
		{
			var tab:AdvancedTab = (event.target as AdvancedTab) || (event.target.parent as AdvancedTab);
			
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
			IEventDispatcher(event.target).removeEventListener(MouseEvent.MOUSE_MOVE, tab_mouseMoveHandler);
		}
		
		private function tab_tabCloseHandler(event:TabEvent):void
		{
			dispatchEvent(new TabEvent(TabEvent.TAB_CLOSE, false, true, getChildIndex(event.target as DisplayObject)));
		}
		
		private function tabCloseHandler(event:TabEvent):void
		{
			if (!event.isDefaultPrevented())
			{
				if (dataProvider is ViewStack)
					ViewStack(dataProvider).removeChildAt(event.index);
				else if (dataProvider is IList)
					IList(dataProvider).removeItemAt(event.index);
			}
		}
	}
}