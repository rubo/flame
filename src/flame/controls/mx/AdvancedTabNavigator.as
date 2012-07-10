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
	
	import mx.containers.TabNavigator;
	import mx.core.EventPriority;
	import mx.events.IndexChangedEvent;
	import mx.styles.StyleProxy;

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
	 * The AdvancedTabNavigator is an enhancment to the standard TabNavigator.
	 * It provides tab drag-and-drop functionality, closable tabs, and adds an ability
	 * to specify a custom style for the selected tab.
	 * 
	 * @see mx.containers.TabNavigator
	 */
	public class AdvancedTabNavigator extends TabNavigator
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private var _dragEnabled:Boolean;
		private var _dropEnabled:Boolean;
		private var _tabClosePolicy:String = TabClosePolicy.NEVER;
		
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Initializes a new instance of the AdvancedTabNavigator class.
		 */
		public function AdvancedTabNavigator()
		{
			super();
			
			tabBarStyleFilters.selectedTabStyleName = "selectedTabStyleName";
			tabBarStyleFilters.tabMaxWidth = "tabMaxWidth";
			tabBarStyleFilters.tabMinWidth = "tabMinWidth";
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
			
			if (tabBar != null)
				AdvancedTabBar(tabBar).tabClosePolicy = value;
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
			
			if (tabBar != null)
				AdvancedTabBar(tabBar).dragEnabled = value;
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
			
			if (tabBar != null)
				AdvancedTabBar(tabBar).dropEnabled = value;
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Protected methods
	    //
	    //--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		protected override function createChildren():void
		{
			super.createChildren();
			
			if (tabBar != null)
				rawChildren.removeChild(tabBar);
		
			tabBar = new AdvancedTabBar();
            tabBar.name = "tabBar";
            tabBar.focusEnabled = false;
            tabBar.styleName = new StyleProxy(this, tabBarStyleFilters);
			
			AdvancedTabBar(tabBar).dragEnabled = _dragEnabled;
			AdvancedTabBar(tabBar).dropEnabled = _dropEnabled;
			AdvancedTabBar(tabBar).tabClosePolicy = _tabClosePolicy;
			
			tabBar.addEventListener(TabEvent.TAB_CLOSE, tabBar_tabCloseHandler, false, EventPriority.DEFAULT, true);
			tabBar.addEventListener(IndexChangedEvent.CHANGE, tabBar_indexChangeHandler, false, EventPriority.DEFAULT, true);
            
			rawChildren.addChild(tabBar);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function tabBar_indexChangeHandler(event:IndexChangedEvent):void
		{
			selectedIndex = event.newIndex;
			
			dispatchEvent(event);
		}
		
		private function tabBar_tabCloseHandler(event:TabEvent):void
		{
			dispatchEvent(event);
		}
	}
}