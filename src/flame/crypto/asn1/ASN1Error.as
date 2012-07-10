package flame.crypto.asn1
{
	import flash.utils.getQualifiedClassName;

	/**
	 * The error that is thrown when an error occurs during Abstract Syntax Notation One (ASN.1) encoding or decoding operation.
	 */
	public class ASN1Error extends Error
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Initializes a new instance of the ASN1Error class.
		 * 
		 * @param message The error message that explains the reason for the error.
		 * 
		 * @param id A reference number to associate with the specific error message.
		 */
		public function ASN1Error(message:String = "", id:int = 0)
		{
			super(message, id);
			
			name = getQualifiedClassName(this);
		}
	}
}