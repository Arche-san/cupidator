package org.ggj.cupidator.entities 
{
	
	import org.ggj.cupidator.*;
	/**
	 * ...
	 * @author ...
	 */
	public class EnemyLightning extends Enemy 
	{
		
		public var active:Boolean = true;
		public var timer:int = 0;
		
		public function EnemyLightning() 
		{
			type = Constant.ENTITYTYPE_LIGHTNING;
			collisionShape = CollisionManager.SHAPE_AABB;
			
			collisionGroup = 1;
		}
		
		/*public function toggleState() : void
		{
			timer = Math.floor(Math.random() * (Constant.ENEMY_LIGHTNING_TIMER_MAX - Constant.ENEMY_LIGHTNING_TIMER_MIN)) + Constant.ENEMY_LIGHTNING_TIMER_MIN;
			active = !active;
			movieClip.visible = active;
			//updateTiming();
		}*/
		
		/*private function updateTiming():void 
		{
			timer -= 200;
			if (timer <= 200)
		}*/
		
		/*public override function update(time:uint):void
		{
			
			super.update(time);
			timer -= time;
			if (timer <= 0)
			{
				toggleState();
			}
		}*/
		
		
		
	}

}