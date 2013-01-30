package org.ggj.cupidator.entities 
{
	import org.ggj.cupidator.*;
	/**
	 * ...
	 * @author Jerome
	 */
	public class EnemyGlobuleWhite1 extends Enemy 
	{
		public function EnemyGlobuleWhite1()
		{
			type = Constant.ENTITYTYPE_GLOBULEWHITE1;
			life = 3;
			
			collisionShape = CollisionManager.SHAPE_AABB;
			collisionGroup = 1;
			weight = 10;
			//radius = 0;
		}
		
		public override function update(time:uint):void
		{
			var plaX:Number = World.player.movieClip.x;
			var plaY:Number = World.player.movieClip.y;			
			var dirX:Number = plaX - movieClip.x;
			var dirY:Number = plaY - movieClip.y;
			if (dirX != 0 || dirY != 0)
			{
				var dirLen:Number = Math.sqrt( dirX * dirX + dirY * dirY );
				dirX = dirX / dirLen;
				dirY = dirY / dirLen;
				setSpeedX(dirX * Constant.ENEMY_GLOBULEWHITE_SPEED);
				setSpeedY(dirY * Constant.ENEMY_GLOBULEWHITE_SPEED);
			}
			super.update(time);
		}
	}
}