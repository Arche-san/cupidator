package org.ggj.cupidator.entities 
{
	import flash.geom.Point;
	import org.ggj.cupidator.*;
	/**
	 * ...
	 * @author Jerome
	 */
	public class EnemyPlatelet1 extends Enemy 
	{
		public var moveTime:int = 0;
		public var dir:Point;
		public var speed:Number;
		public var level:uint;
		public var firstUpdate:Boolean = true;
		
		public function EnemyPlatelet1()
		{
			type = Constant.ENTITYTYPE_PLATELET1;
			moveTime = 0;
			
			life = 2;
			
			dir = new Point();
			
			collisionShape = CollisionManager.SHAPE_AABB;
			collisionGroup = 1;
			weight = 1;
			//radius = 0;
			
		}
		
		public override function update(time:uint):void
		{
			if (firstUpdate)
			{
				setLevel(life);
				initTimeAndDir();
				firstUpdate = false;
			}
			
			moveTime -= time;
			if (moveTime <= 0)
			{
				initTimeAndDir();
			}
			super.update(time);
		}
		
		public function initTimeAndDir():void
		{
			moveTime = Math.floor(Math.random() * (Constant.ENEMY_PLATELET_MOVE_TIME_MAX - Constant.ENEMY_PLATELET_MOVE_TIME_MIN)) + Constant.ENEMY_PLATELET_MOVE_TIME_MIN;
			speed = Math.floor(Math.random() * (Constant.ENEMY_PLATELET_SPEED_MAX - Constant.ENEMY_PLATELET_SPEED_MIN)) + Constant.ENEMY_PLATELET_SPEED_MIN;
			var angle:Number;
			if (movieClip.y > Constant.ENEMY_PLATELET_YMAX)
			{
				angle = (Math.random() * Math.PI) + Math.PI;
			} else if (movieClip.y < Constant.ENEMY_PLATELET_YMIN)
			{
				angle = (Math.random() * Math.PI);
			} else {
				angle = (Math.random() * Math.PI * 2);
			}
			dir.x = Math.cos(angle);
			dir.y = Math.sin(angle);
			setSpeedX(dir.x * speed);
			setSpeedY(dir.y * speed);
		}
		
		public function setLevel(newLevel:uint): void
		{
			level = newLevel;
			life = level;
			movieClip.scaleX = 1 + Constant.ENEMY_PLATELET_SCALE_FACTOR_PER_LEVEL * level;
			movieClip.scaleY = 1 + Constant.ENEMY_PLATELET_SCALE_FACTOR_PER_LEVEL * level;
		}
		
		public function onHit(): void
		{
			if (life >= 1)
			{
				setLevel(life);
				var bullet:EnemyPlateletBullet = World.createEntityEnemyPlateletBullet();
				bullet.movieClip.x = movieClip.x;
				bullet.movieClip.y = movieClip.y;
				World.addEntity(bullet);
			}
		}
	}

}