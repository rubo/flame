////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2011 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.controls.spark
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
	import mx.core.EventPriority;
	
	import spark.components.Button;
	import spark.components.List;
	import spark.components.supportClasses.SkinnableComponent;
	
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
	 * Disabled state of the MultiFileUploader.
	 */
	[SkinState("disabled")]
	
	/**
	 * Normal state of the MultiFileUploader.
	 */
	[SkinState("normal")]
	
	/**
	 * Name of CSS style declaration that specifies style for the browse and remove buttons.
	 * 
	 * @default undefined
	 */
	[Style(name="buttonStyleName", type="String", inherit="no")]
	
	/**
	 * Width of the browse and remove buttons, in pixels.
	 * If not specified, the default button widths are calculated from the label text.
	 * 
	 * @default undefined
	 */
	[Style(name="buttonWidth", type="Number", inherit="no")]
	
	/**
	 * Number of pixels between the file list, browse, and remeove buttons.
	 * 
	 * @default 6
	 */
	[Style(name="gap", type="Number", format="Length", inherit="no")]
	
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
	 * Displays a list with a browse and remove button that enable users to select files
	 * to upload to a remote server or remove already selected files.
	 */
	public class MultiFileUploader extends SkinnableComponent
	{
		//--------------------------------------------------------------------------
		//
		//  Fields
		//
		//--------------------------------------------------------------------------
		
		[SkinPart(required="true")]
		public var browseButton:Button;
		
		[SkinPart(required="true")]
		public var fileList:List;
		
		[SkinPart(required="true")]
		public var removeButton:Button;
		
		private var _browseLabel:String;
		private var _buttonProperties:Object = {};
		private var _fileInfoList:Array = [];
		private var _fileReferenceList:FileReferenceList;
		private var _fileReferences:Array = [];
		private var _fileTypeFilter:Array;
		private var _hasFiles:Boolean;
		private var _removeLabel:String;
		private var _request:URLRequest;
		private var _testUpload:Boolean;
		private var _uploadDataFieldName:String;
		
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
		 * Resets the internal state of the control to its initial state.
		 */
		public function reset():void
		{
			initializeFileReferenceList();
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
				enableButtons(true);
			else
			{
				_request = request;
				_testUpload = testUpload;
				_uploadDataFieldName = uploadDataFieldName;
				
				addFileReferenceListeners(_fileReferences[0]);
				
				enableButtons(false);
				
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
		protected override function getCurrentSkinState():String
		{
			return enabled ? "normal" : "disabled";
		}
		
		/**
		 * @inheritDoc
		 */
		protected override function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			if (instance == browseButton)
			{
				browseButton.addEventListener(MouseEvent.CLICK, browseButton_clickHandler);
				
				BindingUtils.bindProperty(browseButton, "label", this, "browseLabel");
			}
			else if (instance == fileList)
			{
				fileList.allowMultipleSelection = true;
				fileList.labelField = "name";
				
				initializeFileReferenceList();
			}
			else if (instance == removeButton)
			{
				removeButton.addEventListener(MouseEvent.CLICK, removeButton_clickHandler);
				
				BindingUtils.bindProperty(removeButton, "label", this, "removeLabel");
			}
			
			if (fileList && removeButton)
			{
				BindingUtils.bindSetter(function (enabled:Boolean):void { removeButton.enabled = enabled && fileList.selectedIndex != -1; },
					fileList, "enabled");
				
				BindingUtils.bindSetter(function (index:int):void { removeButton.enabled = index != -1 && fileList.enabled; },
					fileList, "selectedIndex");
			}
		}
		
		/**
		 * @inheritDoc
		 */
		protected override function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			if (instance == browseButton)
				browseButton.removeEventListener(MouseEvent.CLICK, browseButton_clickHandler);
			else if (instance == removeButton)
				removeButton.removeEventListener(MouseEvent.CLICK, removeButton_clickHandler);
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
			_fileReferenceList.browse(_fileTypeFilter);
		}
		
		private function enableButtons(enable:Boolean):void
		{
			browseButton.enabled = removeButton.enabled = enable;
		}
		
		private function fileReference_completeHandler(event:Event):void
		{
			_fileReferences.splice(_fileReferences.indexOf(event.target), 1);
			
			updateFileInfoList();
			
			removeFileReferenceListeners(event.target as FileReference);
			
			fileList.dataProvider = new ArrayCollection(_fileReferences);
			
			if (_hasFiles != (_fileReferences.length != 0))
			{
				_hasFiles = !_hasFiles;
				
				dispatchEvent(new Event("hasFilesChange"));
			}
			
			upload(_request, _uploadDataFieldName, _testUpload);
		}
		
		private function fileReference_ioErrorHandler(event:IOErrorEvent):void
		{
			enableButtons(true);
			
			dispatchEvent(event);
		}
		
		private function fileReference_progressHandler(event:ProgressEvent):void
		{
			dispatchEvent(event);
		}
		
		private function fileReference_httpStatusHandler(event:HTTPStatusEvent):void
		{
			enableButtons(true);
			
			dispatchEvent(event);
		}
		
		private function fileReference_securityErrorHandler(event:SecurityErrorEvent):void
		{
			enableButtons(true);
			
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
			
			fileList.dataProvider = new ArrayCollection(_fileReferences);
			
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
			
			fileList.dataProvider = null;
			
			if (_hasFiles)
			{
				_hasFiles = false;
				
				dispatchEvent(new Event("hasFilesChange"));
			}
		}
		
		private function removeButton_clickHandler(event:MouseEvent):void
		{
			if (fileList.selectedItems != null)
			{
				var dataProvider:ArrayCollection = fileList.dataProvider as ArrayCollection;
				
				for (var i:int = 0; i < dataProvider.length; i++)
					for (var j:int = 0; j < fileList.selectedItems.length; j++)
						if (fileList.selectedItems[j] == dataProvider.source[i])
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