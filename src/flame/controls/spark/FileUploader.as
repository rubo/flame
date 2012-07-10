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
	import flash.net.URLRequest;
	
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
	 * Dispatched when an upload operation starts.
	 * 
	 * @eventType flash.events.Event.OPEN
	 */
	[Event(name="open", type="flash.events.Event")]
	
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
	 * Dispatched after data is received from the server after a successful upload.
	 * 
	 * @eventType flash.events.DataEvent.UPLOAD_COMPLETE_DATA
	 */
	[Event(name="uploadCompleteData", type="flash.events.DataEvent")]
	
	/**
	 * Displays a text input control and a browse button
	 * that enable users to select a file to upload to a remote server. 
	 */
	public class FileUploader extends FileReader
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the FileUploader class.
		 */
		public function FileUploader()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Starts the upload of a file selected by a user to a remote server.
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
			try
			{
				_fileReference.upload(request, uploadDataFieldName, testUpload);
				
				setMode(LOAD);
			}
			catch (e:Error)
			{
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
		protected override function fileReference_completeHandler(event:Event):void
		{
			reset();
			
			super.fileReference_completeHandler(event);
		}
		
		/**
		 * @inheritDoc
		 */
		protected override function fileReference_uploadCompleteData(event:DataEvent):void
		{
			setMode(INITIAL);
			
			super.fileReference_uploadCompleteData(event);
		}
	}
}