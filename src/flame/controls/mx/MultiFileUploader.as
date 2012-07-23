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
	import flash.net.FileReferenceList;
	import flash.net.URLRequest;
	
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayCollection;
	import mx.controls.Button;
	import mx.core.EventPriority;
	import mx.core.UIComponent;

	/**
	 * Dispatched when the user dismisses the file-browsing dialog box.
	 * 
	 * @eventType flash.events.Event.CANCEL
	 */
	[Event(name="cancel", type="flash.events.Event")]
	
	/**
	 * Dispatched when upload generates an HTTP status code of 200.
	 * 
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * Dispatched when an upload fails and an HTTP status code is available to describe the failure.
	 * 
	 * @eventType flash.events.HTTPStatusEvent.HTTP_STATUS
	 */
	[Event(name="httpStatus", type="flash.events.HTTPStatusEvent")]
	
	/**
	 * Dispatched when the upload fails.
	 * 
	 * @eventType flash.events.IOErrorEvent.IO_ERROR
	 */
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	/**
	 * Dispatched periodically during the file upload operation.
	 * 
	 * @eventType flash.events.ProgressEvent.PROGRESS
	 */
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
	/**
	 * Dispatched when a call to the <code>upload()</code> method tries to upload a file to a server
	 * that is outside the caller's security sandbox.
	 * 
	 * @eventType flash.events.SecurityErrorEvent.SECURITY_ERROR
	 */
	[Event(name="securityError", type="flash.events.SecurityErrorEvent")]
	
	/**
	 * Dispatched when the user selects a file for upload from the file-browsing dialog box.
	 * 
	 * @eventType flash.events.Event.SELECT
	 */
	[Event(name="select", type="flash.events.Event")]
	
	/**
	 * Dispatched after data is received from the server after a successful upload.
	 * 
	 * @eventType flash.events.DataEvent.UPLOAD_COMPLETE_DATA
	 */
	[Event(name="uploadCompleteData", type="flash.events.DataEvent")]
	
	[ResourceBundle("flameControls")]
	
	/**
	 * Name of CSS style declaration that specifies style for the browse and remove buttons.
	 * 
	 * @default undefined
	 */
	[Style(name="buttonStyleName", type="String", inherit="no")]
	
	/**
	 * Width of the Browse and Remove buttons, in pixels.
	 * If not specified, the default button widths are calculated from the label text.
	 * 
	 * @default undefined
	 */
	[Style(name="buttonWidth", type="Number", inherit="no")]
	
	/**
	 * Number of pixels between the file list and the Browse and Remeove buttons.
	 * 
	 * @default 6
	 */
	[Style(name="horizontalGap", type="Number", format="Length", inherit="no")]
	
	/**
	 * Width of the file list, in pixels.
	 * If not specified, the default list width is calculated from the widths of
	 * the MultiFileUploader and the browse and remove buttons.
	 * 
	 * @default undefined
	 */
	[Style(name="listWidth", type="Number", inherit="no")]
	
	/**
	 * Name of CSS style declaration that specifies style for the file list.
	 */
	[Style(name="listStyleName", type="String", inherit="no")]
	
	/**
	 * Number of pixels between the Browse and Remove buttons.
	 * 
	 * @default 6
	 */
	[Style(name="verticalGap", type="Number", format="Length", inherit="no")]
	
	/**
	 * Displays a list with a Browse and Remove button that enable users to select files
	 * to upload to a remote server or remove already selected files.
	 */
	public class MultiFileUploader extends UIComponent
	{
		//--------------------------------------------------------------------------
	    //
	    //  Fields
	    //
	    //--------------------------------------------------------------------------
	    
	    private static const BROWSE:uint = 1;
	    private static const LOAD:uint = 2;
	    
	   	private var _browseButton:Button;
		private var _browseLabel:String;
	   	private var _buttonStyleNameProp:String = "buttonStyleName";
	   	private var _buttonWidthProp:String = "buttonWidth";
	   	private var _enabledChanged:Boolean = false;
		private var _fileInfoList:Array = [];
	   	private var _fileReferenceList:FileReferenceList;
	    private var _fileReferences:Array = [];
	    private var _fileTypeFilter:Array;
	    private var _hasFiles:Boolean = false;
	    private var _horizontalGapProp:String = "horizontalGap";
	    private var _list:AdvancedList;
	    private var _listStyleNameProp:String = "listStyleName";
	    private var _listWidthProp:String = "listWidth";
	    private var _removeButton:Button;
		private var _removeLabel:String;
	    private var _request:URLRequest;
	    private var _stylePropChanged:Boolean = false;
	    private var _testUpload:Boolean;
	    private var _uploadDataFieldName:String;
	    private var _verticalGapProp:String = "verticalGap";
	    
	    //--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Initializes a new instance of the MultiFileUploader class.
		 */
		public function MultiFileUploader()
		{
			super();
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
	    	if (_fileReferences.length != 0)
	    		FileReference(_fileReferences[0]).cancel();
	    }
	    
		/**
		 * @inheritDoc
		 */
	    public override function initialize():void
	    {
	    	super.initialize();
	    	
	    	initializeFileReferenceList();
	    }
	    
		/**
		 * Resets the internal state of the control to its initial state.
		 */
	    public function reset():void
	    {
	    	initializeFileReferenceList();
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
				|| styleProp == _horizontalGapProp
				|| styleProp == _listStyleNameProp
				|| styleProp == _listWidthProp
				|| styleProp == _verticalGapProp)
			{
				_stylePropChanged = true;
				
				invalidateDisplayList();
			}
		}
		
		/**
		 * Starts the upload of the files selected by a user to a remote server.
		 * <p>You must select a file before calling this method.</p>
		 * <p>Internally, this method uses the <code>FileReference.upload()</code> method to upload.</p>
		 *  
		 * @param request The URLRequest object; the url property of the URLRequest object should contain
		 * the URL of the server script configured to handle upload through HTTP POST calls.
		 *  
		 * @param uploadDataFieldName The field name that precedes the file data in the upload POST operation.
		 * The <code>uploadDataFieldName</code> parameter value must be non-null and a non-empty string.
		 * The default value is <code>"Filedata"</code>.
		 * 
		 * @param testUpload If <code>true</code>, for files larger than 10 KB,
		 * attempts a test file upload POST with a Content-Length of 0. 
		 * The test upload checks whether the actual file upload will be successful
		 * and that server authentication, if required, will succeed.
		 * A test upload is available for Windows only.
		 * 
		 * @see flash.net.FileReference#upload() flash.net.FileReference.upload()
		 */
		public function upload(request:URLRequest, uploadDataFieldName:String = "Filedata", testUpload:Boolean = false):void
		{
			if (_fileReferences.length == 0)
				setMode(BROWSE);
			else
			{
				_request = request;
				_testUpload = testUpload;
				_uploadDataFieldName = uploadDataFieldName;
				
				addFileReferenceListeners(_fileReferences[0]);
				
				setMode(LOAD);
				
				FileReference(_fileReferences[0]).upload(request, uploadDataFieldName, testUpload);
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
		 * Gets an array of objects with <code>creationDate</code>, <code>modificationDate</code>,
		 * <code>name</code>, <code>size</code>, and <code>type</code> fields of the selected files.
		 */
		public function get fileInfoList():Array
		{
			return _fileInfoList;
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
	    
	    [Bindable("hasFilesChange")]
		
		/**
		 * Gets a value that indicates whether the control contains one or more files.
		 */
	    public function get hasFiles():Boolean
	    {
	    	return _hasFiles;
	    }
		
		[Bindable]
		[Inspectable(category="General")]
		
		/**
		 * Gets or sets the label for the Remove button.
		 */
		public function get removeLabel():String
		{
			return _removeLabel == null ? resourceManager.getString("flameControls", "removeButton") : _removeLabel;
		}
		
		/**
		 * @private
		 */
		public function set removeLabel(value:String):void
		{
			_removeLabel = value;
		}
	    
		//--------------------------------------------------------------------------
	    //
	    //  Protected methods
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * @inheritDoc
		 */
	    protected override function commitProperties():void
	    {
	    	super.commitProperties();
	    	
	    	if (_enabledChanged)
	    	{
	    		_browseButton.enabled = _list.enabled = enabled;
	    		
	    		_enabledChanged = false;
	    	}
	    }
	    
		/**
		 * @inheritDoc
		 */
	    protected override function createChildren():void
	    {
	    	super.createChildren();
    		
    		if (_list == null)
    		{
    			_list = new AdvancedList();
    			_list.allowMultipleSelection = true;
    			_list.labelField = "name";
    			
    			addChild(_list);
    		}
    		
    		if (_browseButton == null)
    		{
    			_browseButton = new Button();
    			_browseButton.addEventListener(MouseEvent.CLICK, browseButton_clickHandler);
    			
				BindingUtils.bindProperty(_browseButton, "label", this, "browseLabel");
    			
    			addChild(_browseButton);
    		}
    		
    		if (_removeButton == null)
    		{
    			_removeButton = new Button();
    			_removeButton.addEventListener(MouseEvent.CLICK, removeButton_clickHandler);
    			
				BindingUtils.bindProperty(_removeButton, "label", this, "removeLabel");
    			
				addChild(_removeButton);
    		}
    		
    		BindingUtils.bindSetter(function (enabled:Boolean):void { _removeButton.enabled = enabled && _list.selectedIndex != -1; },
    			_list, "enabled");
    		
    		BindingUtils.bindSetter(function (index:int):void { _removeButton.enabled = index != -1 && _list.enabled; },
				_list, "selectedIndex");
	    }
	    
		/**
		 * @inheritDoc
		 */
	    protected override function measure():void
	    {
	    	super.measure();
	    	
	    	var buttonMaxWidth:Number = Math.max(_browseButton.getExplicitOrMeasuredWidth(), _removeButton.getExplicitOrMeasuredWidth());
	    	var horizontalGap:Number = getStyle(_horizontalGapProp) || 0;
	    	var verticalGap:Number = getStyle(_verticalGapProp) || 0;
	    	
	    	measuredWidth = measuredMinWidth = _list.measuredWidth + buttonMaxWidth + horizontalGap;
	    	measuredHeight = measuredMinHeight = Math.max(_list.measuredHeight,
	    		Math.max(_browseButton.getExplicitOrMeasuredHeight() + _removeButton.getExplicitOrMeasuredHeight() + verticalGap));
	    }
		
		/**
		 * @inheritDoc
		 */
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var horizontalGap:Number = getStyle(_horizontalGapProp) || 0;
			var verticalGap:Number = getStyle(_verticalGapProp) || 0;
			var buttonStyleWidth:Number;
			var buttonWidth:Number = Math.max(_browseButton.getExplicitOrMeasuredWidth(), _removeButton.getExplicitOrMeasuredWidth());
			var listWidth:Number = getStyle(_listWidthProp);
			
			_browseButton.setActualSize(buttonWidth, _browseButton.getExplicitOrMeasuredHeight());
			_removeButton.setActualSize(buttonWidth, _removeButton.getExplicitOrMeasuredHeight());
			
			if (!isNaN(buttonStyleWidth = getStyle(_buttonWidthProp)))
				buttonWidth = _browseButton.width = _removeButton.width = buttonStyleWidth;
			
			_list.height = unscaledHeight;
			_list.width = isNaN(listWidth) ? unscaledWidth - buttonWidth - horizontalGap : listWidth;
			
			setActualSize(unscaledWidth, unscaledHeight);
			
			_browseButton.x = _removeButton.x =_list.width + horizontalGap;
			_removeButton.y = _browseButton.y + _browseButton.height + verticalGap;
			
			if (_stylePropChanged)
			{
				_browseButton.styleName = _removeButton.styleName = getStyle(_buttonStyleNameProp);
				_list.styleName = getStyle(_listStyleNameProp);
				
				_stylePropChanged = false;
			}
		}
	    
	    //--------------------------------------------------------------------------
	    //
	    //  Private methods
	    //
	    //--------------------------------------------------------------------------
	    
	    private function addFileReferenceListeners(fileReference:FileReference):void
	    {
	    	fileReference.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, fileReference_uploadCompleteData, false, EventPriority.DEFAULT, true);
			fileReference.addEventListener(Event.COMPLETE, fileReference_completeHandler);
			fileReference.addEventListener(HTTPStatusEvent.HTTP_STATUS, fileReference_httpStatusHandler);
			fileReference.addEventListener(IOErrorEvent.IO_ERROR, fileReference_ioErrorHandler);
			fileReference.addEventListener(ProgressEvent.PROGRESS, fileReference_progressHandler);
			fileReference.addEventListener(SecurityErrorEvent.SECURITY_ERROR, fileReference_securityErrorHandler);
	    }
		
		private function browseButton_clickHandler(event:MouseEvent):void
		{
			if (_list.selectable)
				_fileReferenceList.browse(_fileTypeFilter);
		}
	    
	    private function fileReference_completeHandler(event:Event):void
	    {
	    	_fileReferences.splice(_fileReferences.indexOf(event.target), 1);
			
			updateFileInfoList();
			
			removeFileReferenceListeners(event.target as FileReference);
	    	
	    	_list.dataProvider = _fileReferences;
	    	
	    	if (_hasFiles != (_fileReferences.length != 0))
			{
				_hasFiles = !_hasFiles;
				
				dispatchEvent(new Event("hasFilesChange"));
			}
	    	
	    	upload(_request, _uploadDataFieldName, _testUpload);
	    }
	    
	    private function fileReference_ioErrorHandler(event:IOErrorEvent):void
	    {
	    	setMode(BROWSE);
	    	
	    	dispatchEvent(event);
	    }
	    
	    private function fileReference_progressHandler(event:ProgressEvent):void
	    {
	    	dispatchEvent(event);
	    }
	    
	    private function fileReference_httpStatusHandler(event:HTTPStatusEvent):void
	    {
	    	setMode(BROWSE);
	    	
	    	dispatchEvent(event);
	    }
	    
	    private function fileReference_securityErrorHandler(event:SecurityErrorEvent):void
	    {
	    	setMode(BROWSE);
	    	
	    	dispatchEvent(event);
	    }
	    
	    private function fileReference_uploadCompleteData(event:DataEvent):void
	    {
	    	dispatchEvent(event);
			
			FileReference(event.target).removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, fileReference_uploadCompleteData);
	    	
	    	if (_fileReferences.length == 0)
	    		dispatchEvent(new Event(Event.COMPLETE));
	    }
	    
		private function fileReferenceList_cancelHandler(event:Event):void
		{
			dispatchEvent(event);
		}
		
	    private function fileReferenceList_selectHandler(event:Event):void
	    {
	    	_fileReferences = _fileReferences.concat(_fileReferenceList.fileList.slice());
			
			updateFileInfoList();
	    	
	    	_list.dataProvider = _fileReferences;
	    	
	    	if (_hasFiles != (_fileReferences.length != 0))
			{
				_hasFiles = !_hasFiles;
				
				dispatchEvent(new Event("hasFilesChange"));
			}
			
			dispatchEvent(event);
	    }
	    
	    private function initializeFileReferenceList():void
	    {
			if (_fileReferenceList != null)
			{
				_fileReferenceList.removeEventListener(Event.CANCEL, fileReferenceList_cancelHandler);
				_fileReferenceList.removeEventListener(Event.SELECT, fileReferenceList_selectHandler);
			}
			
	    	_fileReferenceList = new FileReferenceList();
	    	
			_fileReferenceList.addEventListener(Event.CANCEL, fileReferenceList_cancelHandler);
	    	_fileReferenceList.addEventListener(Event.SELECT, fileReferenceList_selectHandler);
	    	
	    	_list.dataProvider = null;
	    	
	    	if (_hasFiles)
			{
				_hasFiles = false;
				
				dispatchEvent(new Event("hasFilesChange"));
			}
	    }
	    
	    private function removeButton_clickHandler(event:MouseEvent):void
	    {
	    	if (_list.selectedItems != null)
	    	{
	    		var dataProvider:ArrayCollection = _list.dataProvider as ArrayCollection;
	    		
	    		for (var i:int = 0; i < dataProvider.length; i++)
	    			for (var j:int = 0; j < _list.selectedItems.length; j++)
	    				if (_list.selectedItems[j] == dataProvider.source[i])
	    				{
	    					dataProvider.removeItemAt(i--);
	    					
	    					j--;
	    				}
	    		
	    		_fileReferences = dataProvider.source;
				
				updateFileInfoList();
	    	}
	    }
		
		private function removeFileReferenceListeners(fileReference:FileReference):void
		{
			fileReference.removeEventListener(Event.COMPLETE, fileReference_completeHandler);
			fileReference.removeEventListener(HTTPStatusEvent.HTTP_STATUS, fileReference_httpStatusHandler);
			fileReference.removeEventListener(IOErrorEvent.IO_ERROR, fileReference_ioErrorHandler);
			fileReference.removeEventListener(ProgressEvent.PROGRESS, fileReference_progressHandler);
			fileReference.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, fileReference_securityErrorHandler);
		}
		
		private function setMode(mode:uint):void
		{
			switch (mode)
			{
				case BROWSE:
					
					_browseButton.enabled = _list.selectable = true;
					break;
				
				case LOAD:
					
					_browseButton.enabled = _list.selectable = false;
					break;
			}
			
			invalidateDisplayList();
			invalidateSize();
		}
		
		private function updateFileInfoList():void
		{
			_fileInfoList.length = 0;
			
			for each (var fileReference:FileReference in _fileReferences)
				_fileInfoList.push({
					creationDate: fileReference.creationDate,
					modificationDate: fileReference.modificationDate,
					name: fileReference.name,
					size: fileReference.size,
					type: fileReference.type
				});
		}
	}
}