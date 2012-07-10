////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.controls.mx
{
	import flash.events.MouseEvent;
	
	import mx.controls.LinkButton;
	
	/**
	 * Text decoration of the label as the user moves the mouse pointer over the button.
	 */
	[Style(name="textRollOverDecoration", type="String", enumeration="none,underline", inherit="no")]
	
	/**
	 * The LinkButton is an enhancment to the standard LinkButton.
	 * It adds an ability to specify a text decoration of the label as the user moves the mouse pointer over the button.
	 * 
	 * @see mx.controls.LinkButton
	 */
	public class LinkButton extends mx.controls.LinkButton
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Represents the name of style used to specify the <code>textRollOverDecoration</code>. 
		 */
		protected var _textRollOverDecorationProp:String = "textRollOverDecoration";
		
		/**
		 * Indicates whether <code>textRollOverDecoration</code> property has changed.
		 */
		protected var _textRollOverDecorationPropChanged:Boolean;
		
		private var _textDecorationBackup:Object;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the LinkButton class.
		 */
		public function LinkButton()
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
			
			var allStyles:Boolean = styleProp == "styleName";
			
			if (allStyles || styleProp == _textRollOverDecorationProp)
			{
				_textRollOverDecorationPropChanged = styleProp == _textRollOverDecorationProp;
				
				invalidateDisplayList();
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		protected override function rollOutHandler(event:MouseEvent):void
		{
			setStyle("textDecoration", _textDecorationBackup);
			
			super.rollOutHandler(event);
		}
		
		/**
		 * @inheritDoc
		 */
		protected override function rollOverHandler(event:MouseEvent):void
		{
			_textDecorationBackup = getStyle("textDecoration");
			
			setStyle("textDecoration", getStyle(_textRollOverDecorationProp));
			
			super.rollOverHandler(event);
		}
		
		/**
		 * @inheritDoc
		 */
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if (_textRollOverDecorationPropChanged)
			{
				_textDecorationBackup = getStyle("textDecoration");
				
				setStyle("textDecoration", getStyle(_textRollOverDecorationProp));
				
				_textRollOverDecorationPropChanged = false;
			}
		}
	}
}