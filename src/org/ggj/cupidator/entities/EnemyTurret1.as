package org.ggj.cupidator.entities 
{
	import org.ggj.cupidator.*;
	/**
	 * ...
	 * @author Jerome
	 */
	public class EnemyTurret1 extends Enemy 
	{
		public const ORIENT_PLAYER:uint = 0;
		public const ORIENT_ANGLE:uint = 1;
		public const ORIENT_BACK_AND_FORTH:uint = 2;
		
		public var config:uint;
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
		
		public var firstUpdate:Boolean = true;
		
		public function EnemyTurret1(pConfig:uint = 1)
		{
			type = Constant.ENTITYTYPE_TURRET1;
			config = pConfig;
			
			collisionGroup = 1;
			
			switch(config)
			{
				case 0 :
				{
					orientPattern = ORIENT_PLAYER;
					reloadPeriod = Constant.ENEMY_TOWER0_RELOAD;
					bulletPerSwipe = Constant.ENEMY_TOWER0_BULLET_PER_SWIPE;
					bulletPeriod = Constant.ENEMY_TOWER0_BULLET_PERIOD;
					angleAmplitude = Constant.ENEMY_TOWER0_ANGLE_AMPLITUDE;
					break;
				}
				case 1 :
				{
					orientPattern = ORIENT_ANGLE;
					reloadPeriod = Constant.ENEMY_TOWER1_RELOAD;
					bulletPerSwipe = Constant.ENEMY_TOWER1_BULLET_PER_SWIPE;
					bulletPeriod = Constant.ENEMY_TOWER1_BULLET_PERIOD;
					angleAmplitude = Constant.ENEMY_TOWER1_ANGLE_AMPLITUDE;
					break;
				}
				case 2 :
				{
					orientPattern = ORIENT_ANGLE;
					reloadPeriod = Constant.ENEMY_TOWER2_RELOAD;
					bulletPerSwipe = Constant.ENEMY_TOWER2_BULLET_PER_SWIPE;
					bulletPeriod = Constant.ENEMY_TOWER2_BULLET_PERIOD;
					angleAmplitude = Constant.ENEMY_TOWER2_ANGLE_AMPLITUDE;
					break;
				}
				
				case 3 :
				{
					orientPattern = ORIENT_BACK_AND_FORTH;
					reloadPeriod = Constant.ENEMY_TOWER3_RELOAD;
					bulletPerSwipe = Constant.ENEMY_TOWER3_BULLET_PER_SWIPE;
					bulletPeriod = Constant.ENEMY_TOWER3_BULLET_PERIOD;
					angleAmplitude = Constant.ENEMY_TOWER3_ANGLE_AMPLITUDE;
					break;
				}
				
				case 4 :
				{
					orientPattern = ORIENT_ANGLE;
					reloadPeriod = Constant.ENEMY_TOWER4_RELOAD;
					bulletPerSwipe = Constant.ENEMY_TOWER4_BULLET_PER_SWIPE;
					bulletPeriod = Constant.ENEMY_TOWER4_BULLET_PERIOD;
					angleAmplitude = Constant.ENEMY_TOWER4_ANGLE_AMPLITUDE;
					break;
				}			
			}
			
			currentReloadTime = 1;
			bulletCountdown = 0;
			nextBulletDelay = 0;
			currentAngle = 0;
			currentAngleDir = 1;
		}
		
		public override function update(time:uint):void
		{
			if(firstUpdate)
			{
				firstUpdate = false;
				angleOrigin = movieClip.rotationZ;
			}
			if (Math.abs(movieClip.x - World.player.movieClip.x) < 400)
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
								currentAngle += angleAmplitude / (bulletPerSwipe - 1) * currentAngleDir;
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