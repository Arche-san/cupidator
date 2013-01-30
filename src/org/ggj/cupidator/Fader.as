package org.ggj.cupidator 
{
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	/**
	 * ...
	 * @author ...
	 */
	public class Fader
	{
		public var movieClip:MovieClip = null;
		public var alphaStart:int = 0;
		public var alphaEnd:int = 0;
		public var currentTime:int = 0;
		public var duration:int = 0;
		
		public function Fader(color:int = 0x000000)
		{
			movieClip = new MovieClip();
			movieClip.graphics.beginFill(color);
			movieClip.graphics.drawRect(0, 0, 800, 640);
			movieClip.graphics.endFill();
			movieClip.alpha = 0;
			movieClip.x = 0;
			movieClip.y = 0;
		}
		
		public function setFadeLevel(a:int):void
		{
			movieClip.alpha = a;
		}
		
		public function startFade(a1:int, a2:int, pDuration:int):void
		{
			duration = pDuration;
			movieClip.alpha = a1;
			alphaStart = a1;
			alphaEnd = a2;
			currentTime = 0;
		}
		
		public function update(time:uint):void
		{
			currentTime += time;
			var p:Number = currentTime / duration;
			movieClip.alpha = (alphaEnd - alphaStart) * p + alphaStart;
		}
		
		public function isFadePlaying():Boolean
		{
			return (currentTime < duration);
		}
	}

}