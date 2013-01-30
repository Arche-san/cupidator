package org.ggj.cupidator 
{
	/**
	 * ...
	 * @author Jerome
	 */
	public class Debug 
	{
		public static function log(message:String):void
		{
			if ( Constant.DEBUG_MODE )
			{
				trace(message);
			}
		}
		
	}

}