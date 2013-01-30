package org.ggj.cupidator.entities 
{
	import flash.utils.setTimeout;
	import org.ggj.cupidator.*;
	/**
	 * ...
	 * @author Jerome
	 */
	public class EnemyGlobuleRed1 extends Enemy
	{
		public var changeDir:Boolean = false;
		public var explode:Boolean = false;
		public var angleDirection:Number = -1;
				
		public function EnemyGlobuleRed1()
		{
			type = Constant.ENTITYTYPE_GLOBULERED1;
			life = 2;
			//TODO : use beat sound instead of custom timer
			setTimeout(onTimerBeat1, Constant.ENEMY_GLOBULE_TIME_BEAT1);
			collisionShape = CollisionManager.SHAPE_AABB;
			collisionGroup = 1;
			weight = 1;
			//radius = 0;
		}
		
		public function onTimerBeat1():void
		{
			changeDir = true;
			setTimeout(onTimerBeat2, Constant.ENEMY_GLOBULE_TIME_BEAT2);
		}
		
		public function onTimerBeat2():void
		{
			changeDir = true;
			setTimeout(onReinitTimerBeat, Constant.ENEMY_GLOBULE_TIME_REINIT);
		}
		
		public function onReinitTimerBeat():void
		{
			setTimeout(onTimerBeat1, Constant.ENEMY_GLOBULE_TIME_BEAT1);
		}
		
		override public function update(time:uint):void
		{
			if ( changeDir )
			{
				changeDirection();
				changeDir = false;
			}
			
			//Reduce globule speed using frictions
			if ( speedX != 0 || speedY != 0 )
			{
				var speedOldX:Number = speedX;
				var speedOldY:Number = speedY;
				var speedNorm:Number = Math.sqrt( (speedX * speedX) + (speedY * speedY) );
				var frictionX:Number = -1 * ( (speedX / speedNorm) * Constant.ENEMY_GLOBULE_RED_FRICTION );
				var frictionY:Number = -1 * ( (speedY / speedNorm) * Constant.ENEMY_GLOBULE_RED_FRICTION );
				speedX = speedX + frictionX * (time * time);
				speedY = speedY + frictionY * (time * time);
				//Check if old speed vector and new speed vector cancel each other using scalar product
				var speedScal:Number = (speedOldX * speedX) + (speedOldY * speedY);
				if ( speedScal < 0 )
				{
					//Reinitialize speeds
					speedX = speedY = 0;
				}
			}
			super.update(time);
		}
		
		private function changeDirection():void
		{
			var speed:Number = Constant.ENEMY_GLOBULE_RED_MOVE_SPEED;
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
			var dirX:Number = Math.cos(angle);
			var dirY:Number = Math.sin(angle);
			setSpeedX(dirX * speed);
			setSpeedY(dirY * speed);
		}
		
		public function onHit(): void
		{
			if (explode)
			{
				var bullet:EnemyAntibody1 = World.createEntityEnemyAntibody1();
				var dirX:Number = World.player.movieClip.x - movieClip.x;
				var dirY:Number = World.player.movieClip.y - movieClip.y;
				var length:Number = Math.sqrt( dirX * dirX + dirY * dirY);
				bullet.movieClip.x = movieClip.x;
				bullet.movieClip.y = movieClip.y;
				bullet.setSpeedX(dirX * Constant.ENEMY_ANTIBODY_SPEED);
				bullet.setSpeedY(dirY * Constant.ENEMY_ANTIBODY_SPEED);
				World.addEntity(bullet);
			}
		}		
	}

}