////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.controls.mx
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.getQualifiedClassName;
	
	import mx.containers.TitleWindow;
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;
	import mx.events.FlexEvent;
	import mx.managers.PopUpManager;
	import mx.managers.PopUpManagerChildList;
	import mx.resources.ResourceManager;

	/**
	 * The Dialog is an enhancment to the standard TitleWindow.
	 * It closes itself on a "<code>close</code>" event, or when the Esc key is down.
	 * The Dialog control must be used as a popup only.
	 * 
	 * @see mx.containers.TitleWindow
	 * @see mx.managers.PopUpManager
	 */
	public class Dialog extends TitleWindow
	{
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Initializes a new instance of the Dialog class.
		 */
		public function Dialog()
		{
			super();
			
			addEventListener(CloseEvent.CLOSE, closeHandler);
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
			addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Public methods
	    //
	    //--------------------------------------------------------------------------
		
		/**
		 * Closes a dialog opened by the <code>show()</code> method.
		 * <p>Internally, this method uses the <code>PopUpManager.removePopUp()</code> method to close dialogs.</p>
		 * 
		 * @param dialog The dialog to close.
		 * 
		 * @throws ArgumentError <code>dialog</code> parameter is <code>null</code>.
		 * 
		 * @see #show() show()
		 * @see mx.managers.PopUpManager#removePopUp() mx.managers.PopUpManager.removePopUp()
		 */
		public static function hide(dialog:Dialog):void
		{
			if (dialog == null)
				throw new ArgumentError(ResourceManager.getInstance().getString("flameCore", "argNullGeneric", [ "dialog" ]));
			
			PopUpManager.removePopUp(dialog);
		}
		
		/**
		 * Sets a dialog as a topmost dialog.
		 * <p>Topmost dialog is a dialog that overlaps all the other dialogs.
		 * Tompost dialogs are always displayed at the highest point in the z-order of the windows.</p>
		 * <p>Internally, this method uses the <code>PopUpManager.bringToFront()</code> method
		 * to set dialogs as topmost.</p>
		 * 
		 * @param dialog The dialog to set topmost..
		 * 
		 * @throws ArgumentError <code>dialog</code> parameter is <code>null</code>.
		 * 
		 * @see mx.managers.PopUpManager#bringToFront() mx.managers.PopUpManager.bringToFront()
		 */
		public static function setTopmost(dialog:Dialog):void
		{
			if (dialog == null)
				throw new ArgumentError(ResourceManager.getInstance().getString("flameCore", "argNullGeneric", [ "dialog" ]));
			
			PopUpManager.bringToFront(dialog);
		}
		
		/**
		 * Displays, centers, and set as topmost the specified dialog.
		 * <p>Internally, if <code>dialog</code> parameter is a Class,
		 * this method uses the <code>PopUpManager.createPopUp()</code>; otherwise,
		 * if <code>dialog</code> parameter is a Dialog, it uses <code>PopUpManager.addPopUp()</code> method.</p>
		 * 
		 * @param dialog The dialog to display. This parameter can accept a Dialog, or a Class.
		 * 
		 * @param parent The DisplayObject to be used for determining which SystemManager's layers to use
		 * and optionally the reference point for centering the new top level window.
		 * It may not be the actual parent of the dialog as all dialogs are parented by the SystemManager.
		 * If not specified, the top-level application is used.
		 * 
		 * @param modal <code>true</code> to display a modal dialog;
		 * otherwise, <code>false</code> to display a modeless dialog.
		 *  
		 * @param owner The owner of the dialog. This parameter is used to set the <code>owner</code> property
		 * of the dialog. If not specified, the value of the <code>parent</code> parameter is used.
		 * 
		 * @param childList The child list in which to add the dialog.
		 * The default value is <code>PopUpManagerChildList.PARENT</code>.
		 * See PopUpManagerChildList enumeration for a description of specific options.
		 * 
		 * @return The displayed dialog.
		 * 
		 * @throws ArgmumentError <code>dialog</code> parameter is <code>null</code>.
		 * 
		 * @throws TypeError <code>dialog</code> paramater has an invalid type.
		 * 
		 * @see mx.managers.PopUpManager#addPopUp() mx.managers.PopUpManager.addPopUp()
		 * @see mx.managers.PopUpManager#createPopUp() mx.managers.PopUpManager.createPopUp()
		 */
		public static function show(dialog:*, parent:DisplayObject = null, modal:Boolean = true, owner:DisplayObjectContainer = null, childList:String = PopUpManagerChildList.APPLICATION):Dialog
		{
			if (dialog == null)
				throw new ArgumentError(ResourceManager.getInstance().getString("flameCore", "argNullGeneric", [ "dialog" ]));
			
			if (parent == null)
				parent = FlexGlobals.topLevelApplication as DisplayObject;
			
			var popup:Dialog;
			
			if (dialog is Class)
			{
				popup = PopUpManager.createPopUp(parent, dialog, modal, childList) as Dialog;
				
				if (popup == null)
					throw new TypeError(ResourceManager.getInstance().getString("flameCore", "argTypeMismatch",
						[ "dialog", getQualifiedClassName(Dialog) ]));
			}
			else if (dialog is Dialog)
			{
				popup = dialog;
				
				PopUpManager.addPopUp(dialog, parent, modal, childList);
			}
			else
				throw new TypeError(ResourceManager.getInstance().getString("flameCore", "argTypeMismatch",
					[ "dialog", getQualifiedClassName(Dialog) ]));
			
			popup.owner = owner || parent as DisplayObjectContainer;
			
			PopUpManager.bringToFront(popup);
			PopUpManager.centerPopUp(popup);
			
			return popup;
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Protected methods
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * The event handler called for a <code>close</code> event.
		 * 
		 * @param event The dispatched event.
		 */
		protected function closeHandler(event:CloseEvent):void
		{
			hide(this);
		}
		
		/**
		 * @inheritDoc
		 */
		protected override function keyDownHandler(event:KeyboardEvent):void
		{
			super.keyDownHandler(event);
			
			if (showCloseButton && event.keyCode == Keyboard.ESCAPE)
				dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Private methods
	    //
	    //--------------------------------------------------------------------------
	    
		private function creationCompleteHandler(event:FlexEvent):void
		{
			setFocus();
		}
	}
}