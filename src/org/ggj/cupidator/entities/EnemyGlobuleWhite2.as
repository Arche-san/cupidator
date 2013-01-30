package org.ggj.cupidator.entities 
{
	import org.ggj.cupidator.*;	
	/**
	 * ...
	 * @author ...
	 */
	public class EnemyGlobuleWhite2 extends Enemy
	{
		public const ORIENT_PLAYER:uint = 0;
		public const ORIENT_ANGLE:uint = 1;
		public const ORIENT_BACK_AND_FORTH:uint = 2;
		
		public var firstUpdate:Boolean = true;
		public var orientPattern:uint;
		public var reloadPeriod:uint;
		public var currentReloadTime:int;
		public var bulletPerSwipe:uint;
		public var bulletCountdown:int;
		public var bulletPeriod:uint;
		public var nextBulletDelay:int;
		public var currentAngle:Number;
		public var currentAngleDir:int;
		public var angleOrigin:Number;
		public var angleAmplitude:Number;
		
		public var fireReload:uint;
		
		public var shootAnimTimer:int;		
		
		public function EnemyGlobuleWhite2()
		{
			type = Constant.ENTITYTYPE_GLOBULEWHITE2;
			life = 3;
			
			collisionShape = CollisionManager.SHAPE_AABB;
			collisionGroup = 1;
			weight = 10;
			//radius = 0;
			
			orientPattern = ORIENT_BACK_AND_FORTH;
			reloadPeriod = Constant.ENEMY_TOWER3_RELOAD;
			bulletPerSwipe = Constant.ENEMY_TOWER3_BULLET_PER_SWIPE;
			bulletPeriod = Constant.ENEMY_TOWER3_BULLET_PERIOD;
			angleAmplitude = Constant.ENEMY_TOWER3_ANGLE_AMPLITUDE;
			
			currentReloadTime = reloadPeriod;
			bulletCountdown = 0;
			nextBulletDelay = 0;
			currentAngle = 0;
			currentAngleDir = 1;
			
			moveOnScroll = false;
			
		}
		
		public override function update(time:uint):void
		{
			if(firstUpdate)
			{
				firstUpdate = false;
				angleOrigin = Math.PI /2 ;
			}
			
			if (movieClip.x > Constant.ENEMY_GLOBULEWHITE2_POSX)
			{
				setSpeedX( -Constant.ENEMY_GLOBULEWHITE2_SPEED);
			}
			
			//Reduce globule speed using frictions
			if ( speedX != 0 || speedY != 0 )
			{
				var speedOldX:Number = speedX;
				var speedOldY:Number = speedY;
				var speedNorm:Number = Math.sqrt( (speedX * speedX) + (speedY * speedY) );
				var frictionX:Number = -1 * ( (speedX / speedNorm) * Constant.ENEMY_GLOBULEWHITE2_FRICTION );
				var frictionY:Number = -1 * ( (speedY / speedNorm) * Constant.ENEMY_GLOBULEWHITE2_FRICTION );
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
			
			// HACK
			if (markAsDead)
			{
				super.update(time);
				markAsDeleted = true;
				//movieClip.gotoAndStop("mort");
				return;
			}
			
			if (movieClip.x < Constant.ENEMY_GLOBULEWHITE2_POSX)
			{
				if (shootAnimTimer > 0)
				{
					shootAnimTimer -= time;
					if (shootAnimTimer <= 0)
					{
						movieClip.gotoAndStop(1);
					}
				}
					
				if (currentReloadTime > 0)
				{
					currentReloadTime -= time;
					if (currentReloadTime <= 0)
					{
						bulletCountdown = bulletPerSwipe;
						nextBulletDelay = 0;
						currentAngle = angleOrigin - (angleAmplitude / 2) * currentAngleDir;
					}
				}
				else if (bulletCountdown > 0)
				{
					if (nextBulletDelay > 0)
					{
						nextBulletDelay -= time;
					} else {
						--bulletCountdown;
						if (orientPattern == ORIENT_PLAYER)
						{
							var dirX:Number = World.player.movieClip.x - movieClip.x;
							var dirY:Number = World.player.movieClip.y - movieClip.y;
							var length:Number = Math.sqrt( dirX * dirX + dirY * dirY);
							fireAtDir(dirX / length, dirY / length);
						} else {
							fireAtAngle(currentAngle);
							if (bulletPerSwipe > 1)
							{
								if (orientPattern == ORIENT_BACK_AND_FORTH)
								{
									currentAngle += angleAmplitude / (bulletPerSwipe) * currentAngleDir;
								} else {
									currentAngle += angleAmplitude / (bulletPerSwipe - 1) * currentAngleDir;
								}
							}
						}
						if ( bulletCountdown > 0)
						{
							nextBulletDelay = bulletPeriod;
						} else {
							currentReloadTime = reloadPeriod;
							if (orientPattern == ORIENT_BACK_AND_FORTH)
							{
								currentAngleDir *= -1;
							}
						}
					}
								
				}
			}
			super.update(time);			
		}
		
		public function fireAtAngle(angle:Number) : void
		{
			fireAtDir(Math.cos(angle + (Math.PI / 2)), Math.sin(angle + (Math.PI / 2)));
		}
		
		public function fireAtDir(dirX:Number, dirY:Number) : void
		{
			movieClip.gotoAndStop(2);
			shootAnimTimer = 200;
			
			var bullet:EnemyAntibody1 = World.createEntityEnemyAntibody1();
			bullet.movieClip.x = movieClip.x;
			bullet.movieClip.y = movieClip.y;
			bullet.setSpeedX(dirX * Constant.ENEMY_TOWER_SHOT_SPEED);
			bullet.setSpeedY(dirY * Constant.ENEMY_TOWER_SHOT_SPEED);
			World.addEntity(bullet);
		}
		
	}

}