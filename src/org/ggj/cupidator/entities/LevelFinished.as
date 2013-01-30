package org.ggj.cupidator.entities 
{
	import org.ggj.cupidator.*;
	
	/**
	 * ...
	 * @author ...
	 */
	public class LevelFinished extends Entity
	{
		public var firstUpdate:Boolean = true;
		
		public function LevelFinished() 
		{
			type = Constant.ENTITYTYPE_LEVELFINISHED;
			collisionShape = CollisionManager.SHAPE_AABB;
			setSpeedX(-Constant.SCROLL_SPEEDX_ENEMY);
		}
		
		override public function update(time:uint):void
		{
			if (firstUpdate)
			{
				movieClip.alpha = 0.05;
				firstUpdate = false;
			}
			super.update(time);
		}
		
	}

}