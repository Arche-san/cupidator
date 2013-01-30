package org.ggj.cupidator 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author ...
	 */
	public class Hud 
	{
		public var movieClip:MovieClip = null;
		
		public function Hud() 
		{
			movieClip = new HUD;
			movieClip.x = 400;
			movieClip.y = 70;
			setLife(0);
			setCardio(0);
		}
		
		public function setLife(lifePercent:uint):void
		{
			movieClip.jauge_cupidator.bar.gotoAndStop(lifePercent);
		}

		public function setCardio(cardioPercent:uint):void
		{
			movieClip.jauge_corps_humain.bar.gotoAndStop(cardioPercent);
		}
		
		public function update(time:uint):void
		{
			if (World.player == null)
			{
				setLife(100);
				setCardio(100);
				return;
			}
			setLife(100 - World.player.life * 100 / Constant.PLAYER_LIFE_MAX);
			setCardio(100 - World.player.cardio * 100 / Constant.PLAYER_CARDIO_MAX);
		}
	}

}