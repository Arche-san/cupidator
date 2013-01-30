package org.ggj.cupidator.entities 
{
	import org.ggj.cupidator.*;
	
	/**
	 * ...
	 * @author ...
	 */
	public class EnemyOxygen extends Enemy 
	{
		
		public var firstUpdate:Boolean = true;
		
		public function EnemyOxygen()
		{
			super();
			
			type = Constant.ENTITYTYPE_OXYGEN;
			
			collisionShape = CollisionManager.SHAPE_AABB;
			collisionGroup = 1;
			weight = 1;
			//radius = 0;			
		}
		
		public override function update(time:uint):void
		{
			if (firstUpdate)
			{
				firstUpdate = false;
				var plaX:Number = World.player.movieClip.x;
				var plaY:Number = World.player.movieClip.y;
				var dirX:Number = plaX - movieClip.x;
				var dirY:Number = plaY - movieClip.y;	
				var dirLen:Number = Math.sqrt( dirX * dirX + dirY * dirY );
				dirX = dirX / dirLen;
				dirY = dirY / dirLen;
				setSpeedX(dirX * Constant.ENEMY_OXYGEN_SPEED);
				setSpeedY(dirY * Constant.ENEMY_OXYGEN_SPEED);				
			}
			super.update(time);
		}		
		
	}

}