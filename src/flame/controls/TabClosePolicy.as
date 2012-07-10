package flame.controls
{
	/**
	 * Specifies the close policy for the AdvancedTabBar.
	 */
	public final class TabClosePolicy
	{
		/**
		 * Always show the Close button.
		 */
		public static const ALWAYS:String = "always";
		
		/**
		 * Never show the Close button.
		 */
		public static const NEVER:String = "never";
		
		/**
		 * Show the Close button when mouse rolls over a tab.
		 */
		public static const ROLL_OVER:String = "rollOver";
		
		/**
		 * Show the Close button for the selected tab only.
		 */
		public static const SELECTED:String = "selected";
	}
}