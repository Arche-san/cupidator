package org.ggj.cupidator 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Jerome
	 */
	public class LevelParam 
	{
		public var gameMode:uint = Constant.PLAYER_MODE_RUNNER;
		public var playerSpeedX:Number = 0;
		public var playerSpeedY:Number = 0;
		public var playerSpeedMaxX:Number = Number.MAX_VALUE;
		public var playerSpeedMaxY:Number = Number.MAX_VALUE;		
		public var decorPattern:uint;
		public var wallPattern:uint;
		//Movie clip configurations
		public var mcEnemisPatternArr:Array;
		
	}

}