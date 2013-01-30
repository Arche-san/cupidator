package org.ggj.cupidator.entities 
{
	import org.ggj.cupidator.*;
	
	/**
	 * ...
	 * @author ...
	 */
	public class EnemyPlateletBullet extends Enemy 
	{
		public var firstUpdate:Boolean = true;
		public function EnemyPlateletBullet() 
		{
			super();
			
			movieClip = new MINI_PLAQUETTE;
			
			type = Constant.ENTITYTYPE_PLATELET_BULLET;
			
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
				setSpeedX(dirX * Constant.ENEMY_PLATELETBULLET_SPEED);
				setSpeedY(dirY * Constant.ENEMY_PLATELETBULLET_SPEED);				
			}
			super.update(time);
		}
		
	}

}