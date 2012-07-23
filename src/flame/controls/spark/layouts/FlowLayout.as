////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2012 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.controls.spark.layouts
{
	import flash.geom.Rectangle;
	
	import mx.core.ILayoutElement;
	import mx.resources.ResourceManager;
	
	import spark.components.supportClasses.GroupBase;
	import spark.core.NavigationUnit;
	import spark.layouts.VerticalAlign;
	import spark.layouts.supportClasses.DropLocation;
	import spark.layouts.supportClasses.LayoutBase;
	
	/**
	 * The FlowLayout class arranges the layout elements in a flow sequence,
	 * much like lines of text in a paragraph, left to right, and top to bottom,
	 * with optional gaps between the elements and optional padding around the sequence of elements.  
	 */
	public class FlowLayout extends LayoutBase
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		private var _horizontalGap:Number = 6;
		private var _paddingBottom:Number = 0;
		private var _paddingLeft:Number = 0;
		private var _paddingRight:Number = 0;
		private var _paddingTop:Number = 0;
		private var _rowInfo:Vector.<RowInfo> = new Vector.<RowInfo>();
		private var _verticalAlign:String = VerticalAlign.TOP;
		private var _verticalGap:Number = 6;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the FlowLayout class. 
		 */
		public function FlowLayout()
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
		public override function elementAdded(index:int):void
		{
			invalidateTargetSizeAndDisplayList();
		}
		
		/**
		 * @inheritDoc
		 */
		public override function elementRemoved(index:int):void
		{
			invalidateTargetSizeAndDisplayList();
		}
		
		/**
		 * @inheritDoc
		 */
		public override function getNavigationDestinationIndex(currentIndex:int, navigationUnit:uint, arrowKeysWrapFocus:Boolean):int
		{
			if (target == null || target.numElements < 1)
				return -1;
			
			var maxIndex:int = target.numElements - 1;
			var rowIndex:int;
			
			if (currentIndex == -1)
			{
				if (navigationUnit == NavigationUnit.LEFT || navigationUnit == NavigationUnit.UP)
					return arrowKeysWrapFocus ? maxIndex : -1;
				
				if (navigationUnit == NavigationUnit.RIGHT || navigationUnit == NavigationUnit.DOWN)
					return 0;    
			}
			
			switch (navigationUnit)
			{
				case NavigationUnit.END:
					
					return maxIndex;
				
				case NavigationUnit.HOME:
					
					return 0;
				
				case NavigationUnit.LEFT:
				case NavigationUnit.UP:
					
					return arrowKeysWrapFocus && currentIndex == 0 ? maxIndex : currentIndex - 1;
				
				case NavigationUnit.PAGE_DOWN:
				case NavigationUnit.PAGE_UP:
					
					break;
				
				case NavigationUnit.RIGHT:
				case NavigationUnit.DOWN:
					
					return arrowKeysWrapFocus && currentIndex == maxIndex ? 0 : currentIndex + 1;
				
				default:
					
					return super.getNavigationDestinationIndex(currentIndex, navigationUnit, arrowKeysWrapFocus);
			}
			
			return -1;
		}
		
		/**
		 * @inheritDoc
		 */
		public override function updateDisplayList(width:Number, height:Number):void
		{
			checkVirtualLayout();
			
			var layoutTarget:GroupBase = target;
			
			if (layoutTarget == null)
				return;
			
			var elementIndex:int = 0;
			var contentHeight:Number = 0;
			var contentWidth:Number = 0;
			var isVerticalAlignBottom:Boolean = _verticalAlign == VerticalAlign.BOTTOM;
			var isVerticalAlignMiddle:Boolean = _verticalAlign == VerticalAlign.MIDDLE;
			var rowIndex:int = 0;
			var rowHeight:Number = 0;
			var x:Number = _paddingLeft;
			var y:Number = _paddingTop;
			
			_rowInfo.length = 0;
			
			for (var i:int = 0, count:int = layoutTarget.numElements; i < count; i++)
			{
				var element:ILayoutElement = layoutTarget.getElementAt(i);
				
				if (element == null || !element.includeInLayout)
					continue;
				
				element.setLayoutBoundsSize(Number.NaN, Number.NaN);
				
				var elementHeight:Number = element.getLayoutBoundsHeight();
				var elementWidth:Number = element.getLayoutBoundsWidth();
				
				if (x + elementWidth + _paddingRight > width && i != 0)
				{
					x = _paddingLeft;
					y += rowHeight + _verticalGap;
					
					rowHeight = 0;
					rowIndex++;
				}
				
				if (_rowInfo.length == rowIndex)
				{
					_rowInfo.push(new RowInfo());
					
					_rowInfo[rowIndex].startIndex = elementIndex;
					_rowInfo[rowIndex].cellCount = 0;
				}
				
				rowHeight = Math.max(rowHeight, elementHeight);
				
				element.setLayoutBoundsPosition(x, y
					+ (isVerticalAlignBottom ? rowHeight - elementHeight : isVerticalAlignMiddle ? (rowHeight - elementHeight) / 2 : 0));
				
				contentHeight = Math.max(contentHeight, y + rowHeight);
				contentWidth = Math.max(contentWidth, x + elementWidth);
				
				x += elementWidth + _horizontalGap;
				
				_rowInfo[rowIndex].cellCount++;
				_rowInfo[rowIndex].rowHeight = rowHeight;
				
				elementIndex++;
			}
			
			contentHeight += _paddingBottom;
			contentWidth += _paddingRight;
			
			layoutTarget.explicitHeight = layoutTarget.measuredHeight = clipAndEnableScrolling ? height : contentHeight;
			
			layoutTarget.setContentSize(contentWidth, contentHeight);
			
			if (layoutTarget.getExplicitOrMeasuredWidth() != width)
				invalidateTargetSizeAndDisplayList();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public properties
		//
		//--------------------------------------------------------------------------
		
		[Bindable("propertyChange")]
		[Inspectable(category="General")]
		
		/**
		 * Gets or sets horizontal space between rows, in pixels.
		 * 
		 * @see #verticalGap verticalGap
		 */
		public function get horizontalGap():Number
		{
			return _horizontalGap;
		}
		
		/**
		 * @private
		 */
		public function set horizontalGap(value:Number):void
		{
			if (_horizontalGap == value)
				return;
			
			_horizontalGap = value;
			
			invalidateTargetSizeAndDisplayList();
		}
		
		[Inspectable(category="General")]
		
		/**
		 * Gets or sets the number of pixels between the container's bottom edge
		 * and the bottom edge of the last layout element.
		 */
		public function get paddingBottom():Number
		{
			return _paddingBottom;
		}
		
		/**
		 * @private
		 */
		public function set paddingBottom(value:Number):void
		{
			if (_paddingBottom == value)
				return;
			
			_paddingBottom = value;
			
			invalidateTargetSizeAndDisplayList();
		}
		
		[Inspectable(category="General")]
		
		/**
		 * Gets or sets the number of pixels between the container's left edge
		 * and the left edge of the layout element.
		 */
		public function get paddingLeft():Number
		{
			return _paddingLeft;
		}
		
		/**
		 * @private
		 */
		public function set paddingLeft(value:Number):void
		{
			if (_paddingLeft == value)
				return;
			
			_paddingLeft = value;
			
			invalidateTargetSizeAndDisplayList();
		}
		
		[Inspectable(category="General")]
		
		/**
		 * Gets or sets the number of pixels between the container's right edge
		 * and the right edge of the layout element.
		 */
		public function get paddingRight():Number
		{
			return _paddingRight;
		}
		
		/**
		 * @private
		 */
		public function set paddingRight(value:Number):void
		{
			if (_paddingRight == value)
				return;
			
			_paddingRight = value;
			
			invalidateTargetSizeAndDisplayList();
		}
		
		[Inspectable(category="General")]
		
		/**
		 * Gets or sets the number of pixels between the container's top edge
		 * and the top edge of the first layout element.
		 */
		public function get paddingTop():Number
		{
			return _paddingTop;
		}
		
		/**
		 * @private
		 */
		public function set paddingTop(value:Number):void
		{
			if (_paddingTop == value)
				return;
			
			_paddingTop = value;
			
			invalidateTargetSizeAndDisplayList();
		}
		
		[Inspectable(category="General", enumeration="bottom,middle,top", defaultValue="top")]
		
		/**
		 * Gets or sets the alignment of the elements within the cells in the vertical direction.
		 * <p>The default value is <code>VerticalAlign.TOP</code>.</p>
		 * <p>Supported values are:<ul>
		 * <li><code>VerticalAlign.BOTTOM</code></li>
		 * <li><code>VerticalAlign.MIDDLE</code></li>
		 * <li><code>VerticalAlign.TOP</code></li>
		 * </ul></p>
		 * 
		 * @see spark.layouts.VerticalAlign
		 */
		public function get verticalAlign():String
		{
			return _verticalAlign;
		}
		
		/**
		 * @private
		 */
		public function set verticalAlign(value:String):void
		{
			_verticalAlign = value;
		}
		
		[Bindable("propertyChange")]
		[Inspectable(category="General")]

		/**
		 * Gets or sets vertical space between rows, in pixels.
		 * 
		 * @see #horizontalGap horizontalGap
		 */
		public function get verticalGap():Number
		{
			return _verticalGap;
		}

		/**
		 * @private
		 */
		public function set verticalGap(value:Number):void
		{
			if (_verticalGap == value)
				return;
			
			_verticalGap = value;
			
			invalidateTargetSizeAndDisplayList();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------

		/**
		 * @inheritDoc
		 */
		protected override function calculateDropIndex(x:Number, y:Number):int
		{
			var layoutTarget:GroupBase = target;
			var cellCount:int;
			var contentWidth:Number = layoutTarget.getLayoutBoundsWidth();
			var element:ILayoutElement;
			var elementLeftBound:Number;
			var elementRightBound:Number;
			var halfHGap:Number = _horizontalGap / 2;
			var halfVGap:Number = _rowInfo.length > 1 ? _verticalGap / 2 : 0;
			var i:int;
			var j:int;
			var rowCount:int;
			var rowInfo:RowInfo;
			var rowY:Number = 0;
			
			for (i = 0, rowCount = _rowInfo.length; i < rowCount; i++)
			{
				rowInfo = _rowInfo[i];
				
				if (y >= rowY && y <= rowY + rowInfo.rowHeight + halfVGap + (i == 0 ? _paddingTop : i == rowCount - 1 ? _paddingBottom : 0))
				{
					for (j = rowInfo.startIndex, cellCount = rowInfo.cellCount + rowInfo.startIndex; j < cellCount; j++)
					{
						element = layoutTarget.getElementAt(j);
						elementLeftBound = element.getLayoutBoundsX();
						elementRightBound = elementLeftBound + element.getLayoutBoundsWidth();
						
						if (x >= elementLeftBound - (j == rowInfo.startIndex ? _paddingLeft : halfHGap)
							&& x <= elementRightBound + (j == cellCount - 1 ? contentWidth - elementRightBound : halfHGap))
							return x < (elementLeftBound + elementRightBound) / 2 ? j : j + 1;
					}
				}
				
				rowY += rowInfo.rowHeight + halfVGap + (i == 0 ? _paddingTop : 0);
			}
			
			return _rowInfo.length == 0 ? 0 : _rowInfo[_rowInfo.length - 1].cellCount;
		}
		
		/**
		 * @inheritDoc
		 */
		protected override function calculateDropIndicatorBounds(dropLocation:DropLocation):Rectangle
		{
			var layoutTarget:GroupBase = target;
			var height:Number;
			var rowInfo:RowInfo;
			var width:Number = dropIndicator.width;
			var x:Number = _paddingLeft;
			var y:Number = _paddingTop;
			
			for (var i:int = 0, count:int = _rowInfo.length; i < count; i++)
			{
				rowInfo = _rowInfo[i];
				
				if (i > 0)
					y += _verticalGap;
				
				if (dropLocation.dropIndex < rowInfo.startIndex + rowInfo.cellCount)
				{
					x = dropLocation.dropIndex == rowInfo.startIndex
						? _paddingLeft / 2
						: layoutTarget.getElementAt(dropLocation.dropIndex).getLayoutBoundsX() - _horizontalGap / 2;
					
					height = rowInfo.rowHeight;
					break;
				}
				
				y += rowInfo.rowHeight;
			}
			
			if (dropLocation.dropIndex >= target.numElements)
			{
				var element:ILayoutElement = layoutTarget.getElementAt(layoutTarget.numElements - 1);
				
				height = rowInfo == null ? layoutTarget.getLayoutBoundsHeight() : rowInfo.rowHeight;
				x = element.getLayoutBoundsX() + element.getLayoutBoundsWidth()
					+ (x + _horizontalGap / 2 > layoutTarget.getLayoutBoundsWidth() ? _paddingRight : _horizontalGap) / 2;
				y = element.getLayoutBoundsY();
			}
			
			return new Rectangle(x, y, 3, height);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		private function checkVirtualLayout():void
		{
			if (useVirtualLayout)
				throw new Error(ResourceManager.getInstance().getString("flameControls", "flowLayoutNotVirtualized"));
		}
		
		private function getElementRowIndexAt(index:int):int
		{
			if (index < 0 || index > target.numElements - 1)
				return -1;
			
			for (var i:int = 0, count:int = _rowInfo.length; i < count; i++)
				if (index < _rowInfo[i].startIndex + _rowInfo[i].cellCount)
					return i;
			
			return -1;
		}
		
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

class RowInfo
{
	public var cellCount:int;
	public var rowHeight:Number;
	public var startIndex:int;
}