package org.ggj.cupidator.entities 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import org.ggj.cupidator.*;
	
	/**
	 * ...
	 * @author Jerome
	 */
	public class Decor extends Entity 
	{
		public var decorList:Array;
		public var initDecorWidth:Number;
		public var vx:Number;
		
		public function Decor(mc:MovieClip, decorePattern:uint, wall:Boolean = false, isCeil:Boolean = false) 
		{
			movieClip = mc;
			var offsetX:Number = 0;
			var offsetY:Number = 0;
			
			var val:uint = decorePattern;
			if (wall)
			{
				val += 100;	
			}
			if (isCeil)
			{
				val += 100;
			}
			
			var nb:uint = 1;
			
			trace(val);
			switch(val)
			{
				case 1 : nb = 3; vx = -0.05; break;
				case 2 : nb = 1; vx = 0; break;
				case 3:  nb = 1; vx = 0; break;				
				case 101 : nb = 5; vx = -Constant.SCROLL_SPEEDX_ENEMY; break;
				case 102 : nb = 5; vx = -Constant.SCROLL_SPEEDX_ENEMY; break;
				case 201 : nb = 5; vx = -Constant.SCROLL_SPEEDX_ENEMY; break;
				case 202 : nb = 5; vx = -Constant.SCROLL_SPEEDX_ENEMY; break;
			}
			
			for ( var i:uint = 0 ; i < nb; ++i)
			{
				var decorMc:MovieClip;
				switch(val)
				{
					case 1 : decorMc = new BACKGROUND1(); offsetX = -50; offsetY = -42; break;
					case 2 : decorMc = new BACKGROUND2(); offsetX = 0; break;
					case 3 : decorMc = new BACKGROUND3(); offsetX = 0; offsetY = -240; break;
					case 101 : decorMc = new SOL1(); offsetX = -30; offsetY = +380; break;
					case 102 : decorMc = new SOL2(); offsetX = -200; offsetY = +320; break;
					case 201 : decorMc = new SOL1(); decorMc.scaleY *= -1; offsetX = -30; offsetY = -10; break;
					case 202 : decorMc = new SOL2(); decorMc.scaleY *= -1; offsetX = -200; offsetY = 30; break;
				}
				
				decorMc.x = (nb - (i+1)) * (decorMc.width + offsetX);
				decorMc.y = (decorMc.height / 2) + offsetY;
				mc.addChild(decorMc);
				initDecorWidth = (decorMc.width + offsetX);
				
				switch(val)
				{
					case 2 : decorMc.x += initDecorWidth / 2; break;
					case 102 : decorMc.x -= initDecorWidth / 2; break;
					case 202 : decorMc.x -= initDecorWidth / 2; break;
				}				
			}
		}
		
		public override function update(time:uint):void
		{
			movieClip.x += vx * time;
			if (movieClip.x < -initDecorWidth)
			{
				movieClip.x += initDecorWidth;
			}
		}
		
	}

}