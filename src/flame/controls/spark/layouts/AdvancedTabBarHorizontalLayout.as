////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
//	Portions Copyright 2008 Adobe Systems Incorporated. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.controls.spark.layouts
{
	import mx.core.ILayoutElement;
	import mx.core.IUIComponent;
	
	import spark.components.supportClasses.ButtonBarHorizontalLayout;
	import spark.components.supportClasses.GroupBase;
	
	/**
	 * The AdvancedTabBarHorizontalLayout is a layout specifically designed for the AdvancedTabBar skins.
	 * The layout arranges the tabs in a horizontal sequence,
	 * left to right, with optional gaps between them.
	 * The horizontal position of the tabs is determined by arranging them
	 * in a horizontal sequence, left to right, taking into account the gaps between them.
	 * <p>During the execution of the <code>updateDisplayList()</code> method,
	 * the width of each tab is calculated according to the following rules,
	 * listed in their respective order of precedence
	 * (tab's minimum width and maximum width are always respected):<ul>
	 * <li>If the <code>resizeTabToFit</code> property is <code>true</code>,
	 * then the tab is resized to fit the parent if there is no enough space.
	 * The children that are smaller than the average width are allocated their preferred size
	 * and the rest of the elements are reduced equally.</li>
	 * <li>If there is enough space and the <code>variableTabWidth</code>
	 * property is <code>true</code>, then the tab's width is set to its preferred size;
	 * otherwise, if the <code>tabWidth</code> property is specified, the tab's width
	 * is set to the value of that.</li>
	 * </ul></p>
	 * <p>All children are set to the height of the parent.</p>
	 * 
	 * @see flame.controls.spark.AdvancedTabBar
	 */
	public class AdvancedTabBarHorizontalLayout extends ButtonBarHorizontalLayout
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private var _resizeTabToFit:Boolean;
		private var _tabWidth:Number;
		private var _variableTabWidth:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the AdvancedTabBarHorizontalLayout class.
		 */
		public function AdvancedTabBarHorizontalLayout()
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
		public override function updateDisplayList(width:Number, height:Number):void
		{
			var gap:Number = this.gap;
			var layoutTarget:GroupBase = target;
			
			if (layoutTarget != null)
			{
				var count:int = layoutTarget.numElements;
				var elementCount:int = count;
				var hasUndefinedTabWidth:Boolean = _variableTabWidth || isNaN(_tabWidth);
				var layoutElement:ILayoutElement;
				var totalPreferredWidth:Number = 0;
				
				for (var i:int = 0; i < count; i++)
				{
					layoutElement = layoutTarget.getElementAt(i);
					
					if (layoutElement == null || !layoutElement.includeInLayout)
						elementCount--;
					else
						totalPreferredWidth += hasUndefinedTabWidth ? layoutElement.getPreferredBoundsWidth() : _tabWidth;
				}
				
				if (elementCount == 0)
					layoutTarget.setContentSize(0, 0);
				else
				{
					layoutTarget.setContentSize(width, height);
					
					if (width == 0)
						gap = 0;
					
					var averageWidth:Number;
					var excessSpace:Number = width - totalPreferredWidth - gap * (elementCount - 1);
					var largeChildrenCount:int = elementCount;
					var widthToDistribute:Number = width - gap * (elementCount - 1);
					var widthToDistributeNoSpace:Number = widthToDistribute;
					
					if (excessSpace < 0)
					{
						averageWidth = width / elementCount;
						
						for (i = 0; i < count; i++)
						{
							layoutElement = layoutTarget.getElementAt(i);
							
							if (layoutElement != null && layoutElement.includeInLayout)	
							{
								var preferredWidth:Number = hasUndefinedTabWidth ? layoutElement.getPreferredBoundsWidth() : _tabWidth;
								
								if (preferredWidth <= averageWidth)
								{
									widthToDistributeNoSpace -= preferredWidth;
									
									largeChildrenCount--;
								}
							}
						}
						
						widthToDistributeNoSpace = Math.max(0, widthToDistributeNoSpace);
					}
					
					var childWidth:Number = Number.NaN;
					var childWidthRounded:Number = Number.NaN;
					var roundOff:Number = 0;
					var x:Number = 0;
					
					for (i = 0; i < count; i++)
					{
						layoutElement = layoutTarget.getElementAt(i);
						
						if (layoutElement != null && layoutElement.includeInLayout)
						{
							if (excessSpace > 0)
							{
								if (_resizeTabToFit)
									childWidth = _variableTabWidth ? Number.NaN : isNaN(_tabWidth) ? widthToDistribute / elementCount : _tabWidth;
								else
									childWidth = hasUndefinedTabWidth ? widthToDistribute * layoutElement.getPreferredBoundsWidth() / totalPreferredWidth : _tabWidth;
							}
							else if (excessSpace < 0)
							{
								if (_resizeTabToFit)
								{
									if (_variableTabWidth)
										childWidth = averageWidth < layoutElement.getPreferredBoundsWidth() ? widthToDistributeNoSpace / largeChildrenCount : Number.NaN;
									else
										childWidth = widthToDistribute / elementCount;
								}
								else
									childWidth = hasUndefinedTabWidth ? Number.NaN : _tabWidth;
							}
							
							if (!isNaN(childWidth))
							{
								childWidthRounded = Math.round(childWidth + roundOff);
								roundOff += childWidth - childWidthRounded;
							}
							
							if (layoutElement is IUIComponent)
							{
								var component:IUIComponent = layoutElement as IUIComponent;
								
								if (childWidthRounded > component.maxWidth)
									childWidthRounded = component.maxWidth;
								else if (childWidthRounded < component.minWidth)
									childWidthRounded = component.minWidth;
							}
							
							layoutElement.setLayoutBoundsSize(childWidthRounded, height);
							layoutElement.setLayoutBoundsPosition(x, 0);
							
							x += gap + layoutElement.getLayoutBoundsWidth(); 
							
							childWidthRounded = Number.NaN;
						}
					}
				}
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		[Inspectable(category="General", enumeration="false,true")]
		
		/**
		 * Gets or sets the value that indicates whether the tabs are to be resized to fit their parent.
		 */
		public function get resizeTabToFit():Boolean
		{
			return _resizeTabToFit;
		}
		
		/**
		 * @private
		 */
		public function set resizeTabToFit(value:Boolean):void
		{
			if (_resizeTabToFit != value)
			{
				_resizeTabToFit = value;
				
				invalidateTargetSizeAndDisplayList();
			}
		}
		
		[Inspectable(category="General", minValue="0.0")]
		
		/**
		 * Gets or sets the width of the tabs.
		 * <p>If the <code>variableTabWidth</code> property is <code>true</code>,
		 * the default, then this property has no effect.</p>
		 * <p>The default value of this property is the preferred width
		 * of the item specified by the <code>typicalLayoutElement</code> property.</p>
		 */
		public function get tabWidth():Number
		{
			if (isNaN(_tabWidth))
				return typicalLayoutElement == null ? 0 : typicalLayoutElement.getPreferredBoundsWidth();
			
			return _tabWidth;
		}
		
		/**
		 * @private
		 */
		public function set tabWidth(value:Number):void
		{
			if (_tabWidth != value)
			{
				_tabWidth = value;
				
				invalidateTargetSizeAndDisplayList();
			}
		}
		
		[Inspectable(category="General", enumeration="false,true")]
		
		/**
		 * Gets or sets the value that indicates whether the tabs are to be allocated their preferred width.
		 * <p>Setting this property to <code>false</code> specifies fixed width tabs.
		 * The actual width of each tab is the value of the <code>tabWidth</code> property.</p>
		 */
		public function get variableTabWidth():Boolean
		{
			return _variableTabWidth;
		}
		
		/**
		 * @private
		 */
		public function set variableTabWidth(value:Boolean):void
		{
			if (_variableTabWidth != value)
			{
				_variableTabWidth = value;
				
				invalidateTargetSizeAndDisplayList();
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function invalidateTargetSizeAndDisplayList():void
		{
			if (target != null)
			{
				target.invalidateSize();
				target.invalidateDisplayList();
			}
		}
	}
}