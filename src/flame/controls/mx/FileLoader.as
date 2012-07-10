////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2010 Ruben Buniatyan. All rights reserved.
//
//  This source is subject to the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package flame.controls.mx
{
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	/**
	 * Dispatched when the load operation completes successfully.
	 * 
	 * @eventType flash.events.Event.COMPLETE
	 */
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * Dispatched when the load fails.
	 * 
	 * @eventType flash.events.IOErrorEvent.IO_ERROR
	 */
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	
	/**
	 * Dispatched when a load operation starts.
	 * 
	 * @eventType flash.events.Event.OPEN
	 */
	[Event(name="open", type="flash.events.Event")]
	
	/**
	 * Dispatched periodically during the file load operation.
	 * 
	 * @eventType flash.events.ProgressEvent.PROGRESS
	 */
	[Event(name="progress", type="flash.events.ProgressEvent")]
	
	/**
	 * Displays a text input control and a Browse button
	 * that enable users to select a file to load into the memory. 
	 */
	public class FileLoader extends FileReader
	{
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Initializes a new instance of the FileLoader class.
		 */
		public function FileLoader()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
	    //
	    //  Public properties
	    //
	    //--------------------------------------------------------------------------
	    
		/**
		 * Gets the ByteArray object representing the data from the loaded file. 
		 */
	    public function get data():ByteArray
	    {
	    	return _fileReference.data;
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
	    	setMode(BROWSE);
	    	
	    	super.fileReference_completeHandler(event);
	    }
	    
		/**
		 * @inheritDoc
		 */
	    protected override function fileReference_selectHandler(event:Event):void
	    {
	    	super.fileReference_selectHandler(event);
	    	
	    	_fileReference.load();
	    	
	    	setMode(LOAD);
	    }
	}
}