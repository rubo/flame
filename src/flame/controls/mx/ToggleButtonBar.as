////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.controls.mx
{
	import mx.controls.Button;
	import mx.core.mx_internal;

	/**
	 * Name of CSS style declaration that specifies max width for each button.
	 * 
	 * @default undefined
	 */
	[Style(name="buttonMaxWidth", type="Number", format="Length", inherit="no")]
	
	/**
	 * Name of CSS style declaration that specifies min width for each button.
	 * 
	 * @default undefined
	 */
	[Style(name="buttonMinWidth", type="Number", format="Length", inherit="no")]
	
	/**
	 * Name of CSS style declaration that specifies style for the selected button.
	 * 
	 * @default undefined
	 */
	[Style(name="selectedButtonStyleName", type="String", inherit="no")]
	
	/**
	 * The ToggleButtonBar is an enhancment to the standard ToggleButtonBar.
	 * It adds an ability to specify a custom style for the selected button.
	 * 
	 * @see mx.controls.ToggleButtonBar
	 */
	public class ToggleButtonBar extends mx.controls.ToggleButtonBar
	{
		//--------------------------------------------------------------------------
	    //
	    //  Fields
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Represents the name of style used to specify the <code>buttonMaxWidth</code>. 
		 */
		protected var _buttonMaxWidthProp:String = "buttonMaxWidth";
		
		/**
		 * Represents the name of style used to specify the <code>buttonMinWidth</code>. 
		 */
		protected var _buttonMinWidthProp:String = "buttonMinWidth";
		
		/**
		 * Represents the name of style used to specify the <code>selectedButtonStyleName</code>. 
		 */
		protected var _selectedButtonStyleNameProp:String = "selectedButtonStyleName";
		
		/**
		 * Indicates whether <code>selectedButtonStyleName</code> property has changed.
		 */
		protected var _selectedButtonStyleNamePropChanged:Boolean;
		
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Initializes a new instance of the ToggleButtonBar class.
		 */
		public function ToggleButtonBar()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Public methods
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * @inheritDoc
		 */
		public override function styleChanged(styleProp:String):void
		{
			super.styleChanged(styleProp);
			
			var allStyles:Boolean = styleProp == null || styleProp == "styleName";
			
			if (allStyles || styleProp == _selectedButtonStyleNameProp)
			{
				_selectedButtonStyleNamePropChanged = true;
				
				invalidateDisplayList();
			}
			
			if (allStyles || styleProp == _buttonMaxWidthProp || styleProp == _buttonMinWidthProp
				|| (styleManager.isInheritingStyle(styleProp) &&  styleManager.isSizeInvalidatingStyle(styleProp)))
				resetButtonWidths();
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Protected methods
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * @inheritDoc
		 */
		protected override function hiliteSelectedNavItem(index:int):void
		{
			var child:Button;
			
			// Un-hilites the current selection
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
	            // Hilites the new selection
	            child = Button(getChildAt(selectedIndex));
	
	            var selectedButtonStyleName:String = getStyle(_selectedButtonStyleNameProp);
				
				if (selectedButtonStyleName)
	            	child.styleName = selectedButtonStyleName;
	                
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
					child.maxWidth = getStyle(_buttonMaxWidthProp);
					child.minWidth = getStyle(_buttonMinWidthProp);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if (_selectedButtonStyleNamePropChanged)
			{
				hiliteSelectedNavItem(selectedIndex);
				
				_selectedButtonStyleNamePropChanged = false;
			}
			
			resetButtonWidths();
		}
	}
}