////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.controls.mx
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileReference;
	
	import mx.binding.utils.BindingUtils;
	import mx.controls.Button;
	import mx.controls.ProgressBar;
	import mx.controls.TextInput;
	import mx.core.UIComponent;

	/**
	 * Dispatched when the user dismisses the file-browsing dialog box.
	 * 
	 * @eventType flash.events.Event.CANCEL
	 */
	[Event(name="cancel", type="flash.events.Event")]
	
	/**
	 * Dispatched when the user selects a file from the file-browsing dialog box.
	 * 
	 * @eventType flash.events.Event.SELECT
	 */
	[Event(name="select", type="flash.events.Event")]
	
	[ResourceBundle("flameControls")]
	
	/**
	 * Name of CSS style declaration that specifies style for the Browse button.
	 * 
	 * @default undefined
	 */
	[Style(name="buttonStyleName", type="String", inherit="no")]
	
	/**
	 * Width of the Browse button, in pixels.
	 * If not specified, the default button width is calculated from the label text.
	 * 
	 * @default undefined
	 */
	[Style(name="buttonWidth", type="Number", inherit="no")]
	
	/**
	 * Number of pixels between the text input and the Browse button.
	 * 
	 * @default 6
	 */
	[Style(name="horizontalGap", type="Number", format="Length", inherit="no")]
	
	/**
	 * Name of CSS style declaration that specifies style for the upload progress bar.
	 * 
	 * @default undefined
	 */
	[Style(name="progressStyleName", type="String", inherit="no")]
	
	/**
	 * Name of CSS style declaration that specifies style for the text input.
	 * 
	 * @default undefined
	 */
	[Style(name="textStyleName", type="String", inherit="no")]
	
	/**
	 * Width of the text input, in pixels.
	 * If not specified, the default text input width is calculated from the widths of
	 * the parent control and the browse button.
	 * 
	 * @default undefined
	 */
	[Style(name="textWidth", type="Number", inherit="no")]
	
	/**
	 * Represents the base class for controls that work with single files from the local disk.
	 */
	internal class FileReader extends UIComponent
	{
		//--------------------------------------------------------------------------
	    //
	    //  Fields
	    //
	    //--------------------------------------------------------------------------
	    
	    protected static const INITIAL:uint = 0;
	    protected static const BROWSE:uint = 1;
	    protected static const LOAD:uint = 2;
	    
	    protected var _button:Button;
	    protected var _fileReference:FileReference;
	    protected var _progressBar:ProgressBar;
	    protected var _stylePropChanged:Boolean = false;
	    protected var _textInput:TextInput;
	    
		private var _browseLabel:String;
	    private var _buttonStyleNameProp:String = "buttonStyleName";
	    private var _buttonWidthProp:String = "buttonWidth";
		private var _cancelLabel:String;
	    private var _fileTypeFilter:Array;
	    private var _hasFile:Boolean = false;
	    private var _horizontalGapProp:String = "horizontalGap";
	    private var _progressStyleNameProp:String = "progressStyleName";
	    private var _showCancelButton:Boolean = false;
	    private var _textStyleNameProp:String = "textStyleName";
	    private var _textWidthProp:String = "textWidth";
	    private var _enabledChanged:Boolean = false;
	    
	    //--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Initializes a new instance of the FileReader class.
		 */
		public function FileReader()
		{
			super();
			
			initializeFileReference();
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Public methods
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Cancels any ongoing upload operation.
		 */
	    public function cancel():void
	    {
	    	_fileReference.cancel();
	    }
	    
		/**
		 * Resets the internal state of the control to its initial state.
		 */
	    public function reset():void
	    {
	    	initializeFileReference();
	    	
	    	setMode(INITIAL);
	    }
	    
		/**
		 * @inheritDoc
		 */
	    public override function styleChanged(styleProp:String):void
		{
			super.styleChanged(styleProp);
			
			var allStyles:Boolean = styleProp == null || styleProp == "styleName";
			
			if (allStyles
				|| styleProp == _buttonStyleNameProp
				|| styleProp == _buttonWidthProp
				|| styleProp == _progressStyleNameProp
				|| styleProp == _textStyleNameProp
				|| styleProp == _textWidthProp)
			{
				_stylePropChanged = true;
				
				invalidateDisplayList();
			}
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Public properties
	    //
	    //--------------------------------------------------------------------------
	    
		[Bindable]
		[Inspectable(category="General")]
		
		/**
		 * Gets or sets the label for the Browse button.
		 */
		public function get browseLabel():String
		{
			return _browseLabel == null ? resourceManager.getString("flameControls", "browseButton") : _browseLabel;
		}
		
		/**
		 * @private
		 */
		public function set browseLabel(value:String):void
		{
			_browseLabel = value;
		}
		
		[Bindable]
		[Inspectable(category="General")]
		
		/**
		 * Gets or sets the label for the Cancel button.
		 */
		public function get cancelLabel():String
		{
			return _cancelLabel == null ? resourceManager.getString("flameControls", "cancelButton") : _cancelLabel;
		}
		
		/**
		 * @private
		 */
		public function set cancelLabel(value:String):void
		{
			_cancelLabel = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public override function set enabled(value:Boolean):void
		{
			if (value == enabled)
				return;
			
			_enabledChanged = true;
			
			super.enabled = value;
			
			invalidateProperties();
		}
		
		/**
		 * Gets the creation date of the selected file on the local disk.
		 */
	    public function get fileCreationDate():Date
	    {
	    	return _fileReference.creationDate;
	    }
	    
		/**
		 * Gets the date that the selected file on the local disk was last modified.
		 */
		public function get fileModificationDate():Date
		{
			return _fileReference.modificationDate;
		}
		
		/**
		 * Gets the name of the selected file on the local disk.
		 */
	    public function get fileName():String
	    {
	    	return _fileReference.name;
	    }
	    
		/**
		 * Gets the size of the selected file on the local disk in bytes.
		 */
	    public function get fileSize():uint
	    {
	    	return _fileReference.size;
	    }
		
		/**
		 * Gets the type of the selected file.
		 */
		public function get fileType():String
		{
			return _fileReference.type;
		}
	    
		/**
		 * Gets or sets an array of FileFilter instances used to filter the files that are displayed in the dialog box.
		 * If not specified, all files are displayed.
		 * 
		 * @see flash.net.FileFilter
		 */
	    public function get fileTypeFilter():Array
	    {
	    	return _fileTypeFilter;
	    }
	    
		/**
		 * @private 
		 */
	    public function set fileTypeFilter(value:Array):void
	    {
	    	_fileTypeFilter = value;
	    }
	    
	    [Bindable("hasFileChange")]
		
		/**
		 * Gets a value that indicates whether the control contains a file.
		 */
	    public function get hasFile():Boolean
	    {
	    	return _hasFile;
	    }
	    
	    [Bindable]
	    [Inspectable(category="General", enumeration="false,true", defaultValue="true")]
		
		/**
		 * Gets or sets a value that indicates whether to show the cancel button.
		 */
	    public function get showCancelButton():Boolean
	    {
	    	return _showCancelButton;
	    }
	    
		/**
		 * @private 
		 */
	    public function set showCancelButton(value:Boolean):void
	    {
	    	 _showCancelButton = value;
	    }
		
		//--------------------------------------------------------------------------
	    //
	    //  Protected methods
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * The button event handler called for a <code>click</code> event.
		 * 
		 * @param event The dispatched event.
		 */
	    protected function button_clickHandler(event:MouseEvent):void
	    {
	    	if (_progressBar.visible)
	    	{
	    		setMode(INITIAL);
	    		
	    		_fileReference.cancel();
	    		
	    		initializeFileReference();
	    	}
	    	else
	    		_fileReference.browse(_fileTypeFilter);
	    }
	    
		/**
		 * @inheritDoc
		 */
	    protected override function commitProperties():void
	    {
	    	super.commitProperties();
	    	
	    	if (_enabledChanged)
	    	{
	    		_button.enabled = _progressBar.enabled = _textInput.enabled = enabled;
	    		
	    		_enabledChanged = false;
	    	}
	    }
	    
		/**
		 * @inheritDoc
		 */
	    protected override function createChildren():void
	    {
	    	super.createChildren();
    		
    		if (!_textInput)
    		{
    			_textInput = new TextInput();
    			_textInput.editable = false;
    			
    			addChild(_textInput);
    		}
    		
    		if (!_progressBar)
    		{
    			_progressBar = new ProgressBar();
    			_progressBar.label = "";
    			_progressBar.labelPlacement = "center";
    			_progressBar.source = _fileReference;
    			_progressBar.visible = false;
    			
    			addChild(_progressBar);
    		}
    		
    		if (!_button)
    		{
    			_button = new Button();
    			_button.addEventListener(MouseEvent.CLICK, button_clickHandler);
    			
				BindingUtils.bindProperty(_button, "label", this, "browseLabel");
			
    			addChild(_button);
    		}
	    }
	    
		/**
		 * Initializes the FileReference object.
		 */
	    protected function initializeFileReference():void
	    {
			if (_fileReference != null)
			{
				_fileReference.removeEventListener(Event.CANCEL, fileReference_cancelHandler);
				_fileReference.removeEventListener(Event.COMPLETE, fileReference_completeHandler);
				_fileReference.removeEventListener(Event.OPEN, fileReference_openHandler);
				_fileReference.removeEventListener(Event.SELECT, fileReference_selectHandler);
				_fileReference.removeEventListener(HTTPStatusEvent.HTTP_STATUS, fileReference_httpStatusHandler);
				_fileReference.removeEventListener(IOErrorEvent.IO_ERROR, fileReference_ioErrorHandler);
				_fileReference.removeEventListener(ProgressEvent.PROGRESS, fileReference_progressHandler);
				_fileReference.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, fileReference_securityErrorHandler);
			}
			
	    	_fileReference = new FileReference();
	    	
	    	_fileReference.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, fileReference_uploadCompleteData);
			_fileReference.addEventListener(Event.CANCEL, fileReference_cancelHandler);
			_fileReference.addEventListener(Event.COMPLETE, fileReference_completeHandler);
			_fileReference.addEventListener(Event.OPEN, fileReference_openHandler);
			_fileReference.addEventListener(Event.SELECT, fileReference_selectHandler);
			_fileReference.addEventListener(HTTPStatusEvent.HTTP_STATUS, fileReference_httpStatusHandler);
			_fileReference.addEventListener(IOErrorEvent.IO_ERROR, fileReference_ioErrorHandler);
			_fileReference.addEventListener(ProgressEvent.PROGRESS, fileReference_progressHandler);
			_fileReference.addEventListener(SecurityErrorEvent.SECURITY_ERROR, fileReference_securityErrorHandler);
			
			if (_hasFile)
			{
				_hasFile = false
	    		
				dispatchEvent(new Event("hasFileChange"));
			}
			
			if (_progressBar)
				_progressBar.source = _fileReference;
	    }
	    
		/**
		 * The event handler called of the FileReference object for a <code>cancel</code> event.
		 * 
		 * @param event The dispatched event.
		 */
	    protected function fileReference_cancelHandler(event:Event):void
	    {
	    	setMode(BROWSE);
	    	
	    	dispatchEvent(event);
	    }
	    
		/**
		 * The event handler called of the FileReference object for a <code>complete</code> event.
		 * 
		 * @param event The dispatched event.
		 */
	    protected function fileReference_completeHandler(event:Event):void
	    {
	    	dispatchEvent(event);
	    }
	    
		/**
		 * The event handler called of the FileReference object for a <code>ioError</code> event.
		 * 
		 * @param event The dispatched event.
		 */
	    private function fileReference_ioErrorHandler(event:IOErrorEvent):void
	    {
	    	setMode(BROWSE);
	    	
	    	dispatchEvent(event);
	    }
	    
		/**
		 * The event handler called of the FileReference object for a <code>open</code> event.
		 * 
		 * @param event The dispatched event.
		 */
	    protected function fileReference_openHandler(event:Event):void
	    {
	    	dispatchEvent(event);
	    }
	    
		/**
		 * The event handler called of the FileReference object for a <code>progress</code> event.
		 * 
		 * @param event The dispatched event.
		 */
	    protected function fileReference_progressHandler(event:ProgressEvent):void
	    {
	    	_progressBar.label = resourceManager.getString("flameControls", "fileProgressLabel",
	    		[ Math.round(event.bytesLoaded * 100 / event.bytesTotal) ]);
	    }
	    
		/**
		 * The event handler called of the FileReference object for a <code>select</code> event.
		 * 
		 * @param event The dispatched event.
		 */
	    protected function fileReference_selectHandler(event:Event):void
	    {
	    	_textInput.text = _fileReference.name;
			
			if (!_hasFile)
			{
				_hasFile = true;
				
				dispatchEvent(new Event("hasFileChange"));
			}
			
	    	dispatchEvent(event);
	    }
	    
		/**
		 * The event handler called of the FileReference object for a <code>httpStatus</code> event.
		 * 
		 * @param event The dispatched event.
		 */
	    protected function fileReference_httpStatusHandler(event:HTTPStatusEvent):void
	    {
	    	setMode(BROWSE);
	    	
	    	dispatchEvent(event);
	    }
	    
		/**
		 * The event handler called of the FileReference object for a <code>securityError</code> event.
		 * 
		 * @param event The dispatched event.
		 */
	    protected function fileReference_securityErrorHandler(event:SecurityErrorEvent):void
	    {
	    	setMode(BROWSE);
	    	
	    	dispatchEvent(event);
	    }
	    
		/**
		 * The event handler called of the FileReference object for a <code>uploadCompleteData</code> event.
		 * 
		 * @param event The dispatched event.
		 */
	    protected function fileReference_uploadCompleteData(event:DataEvent):void
	    {
			FileReference(event.target).removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, fileReference_uploadCompleteData);
			
	    	dispatchEvent(event);
	    }
	    
		/**
		 * @inheritDoc
		 */
	    protected override function measure():void
	    {
	    	super.measure();
	    	
	    	measuredWidth = measuredMinWidth = _textInput.measuredWidth + _button.getExplicitOrMeasuredWidth() +
				getStyle(_horizontalGapProp);
	    	
	    	measuredHeight = measuredMinHeight = Math.max(_textInput.measuredHeight, _button.getExplicitOrMeasuredHeight());
	    }
		
		/**
		 * Sets the internal mode of the control to the specified mode.
		 */
		protected function setMode(mode:uint):void
		{
			switch (mode)
			{
				case BROWSE:
					
					_button.visible = true;
					_progressBar.visible = !(_textInput.visible = true);
					
					BindingUtils.bindProperty(_button, "label", this, "browseLabel");
					break;
				
				case INITIAL:
					
					_button.visible = true;
					_textInput.text = "";
					_progressBar.visible = !(_textInput.visible = true);
					
					BindingUtils.bindProperty(_button, "label", this, "browseLabel");
					break;
				
				case LOAD:
					
					if (_showCancelButton)
						BindingUtils.bindProperty(_button, "label", this, "cancelLabel");
					else
						_button.visible = false;
					
					_progressBar.visible = !(_textInput.visible = false);
					break;	
			}
			
			invalidateDisplayList();
			invalidateSize();
		}
		
		/**
		 * @inheritDoc
		 */
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var horizontalGap:Number = getStyle(_horizontalGapProp);
			var buttonStyleWidth:Number;
			var buttonWidth:Number = _button.getExplicitOrMeasuredWidth();
			var textWidth:Number = getStyle(_textWidthProp);
			
			_button.setActualSize(buttonWidth, unscaledHeight);
			
			if (!isNaN(buttonStyleWidth = getStyle(_buttonWidthProp)))
				buttonWidth = _button.width = buttonStyleWidth;
			
			_textInput.height = unscaledHeight;
			_textInput.width = isNaN(textWidth) ? unscaledWidth - buttonWidth - horizontalGap : textWidth;
			
			_progressBar.setActualSize(_textInput.width, unscaledHeight);
			
			setActualSize(unscaledWidth, unscaledHeight);
			
			_button.x = _textInput.width + horizontalGap;
			
			if (_stylePropChanged)
			{
				_button.styleName = getStyle(_buttonStyleNameProp);
				_progressBar.styleName = getStyle(_progressStyleNameProp);
				_textInput.styleName = getStyle(_textStyleNameProp);
				
				_stylePropChanged = false;
			}
		}
	}
}