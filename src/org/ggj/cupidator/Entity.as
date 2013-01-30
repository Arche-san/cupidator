package org.ggj.cupidator 
{
	import flash.display.MovieClip;
	import flash.display.FrameLabel;
	import org.ggj.cupidator.*;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author Jerome
	 */
	public class Entity
	{
		public var type:uint = 0;
		public var movieClip:MovieClip = null;
		public var life:int = 0;
		public var speedX:Number = 0;
		public var speedMaxX:Number = Number.MAX_VALUE;
		public var speedY:Number = 0;
		public var speedMaxY:Number = Number.MAX_VALUE;
		public var accelerationX:Number = 0;
		public var gravity:Number = 0;
		public var markAsDeleted:Boolean = false;
		public var markAsDead:Boolean = false;
		public var outOfActivityBox:Boolean = false;
		
		
		//Physic
		public var bbMovieClip:MovieClip = null;
		public var collisionShape:uint = 0;
		public var collisionGroup:uint = 0;
		public var weight:uint = 0;
		public var radius:Number = 0;
		
		public function setSpeedX(speed:Number, speedMax:Number = Number.MAX_VALUE):void
		{
			this.speedX = speed;
			this.speedMaxX = speedMax;
		}
		
		public function setSpeedMax(pSpeedMaxX:Number, pSpeedMaxY:Number):void
		{
			this.speedMaxY = pSpeedMaxX;
			this.speedMaxY = pSpeedMaxY;
		}
		
		public function setSpeedY(speed:Number):void
		{
			this.speedY = speed;
			
		}		
		
		public function isInSameCollisionGroup(entity:Entity) : Boolean
		{
			if (collisionGroup == 0 && entity.collisionGroup == 0) { return false;  }
			return (collisionGroup == entity.collisionGroup);
		}
		
		public function getBBMovieClip() : MovieClip
		{
			if(bbMovieClip == null) { return movieClip; }
			return bbMovieClip;
		}
		
		public static function isEnemy(entityType:uint):Boolean
		{
			return (Constant.ENTITYTYPE_ENEMY == entityType
				|| Constant.ENTITYTYPE_ENEMY == entityType
				|| Constant.ENTITYTYPE_GLOBULERED1 == entityType
				|| Constant.ENTITYTYPE_GLOBULERED2 == entityType
				|| Constant.ENTITYTYPE_GLOBULEWHITE1 == entityType
				|| Constant.ENTITYTYPE_PLATELET1 == entityType
				|| Constant.ENTITYTYPE_ANTIBODY1 == entityType
				|| Constant.ENTITYTYPE_SUGAR1 == entityType
				|| Constant.ENTITYTYPE_TURRET1 == entityType
				|| Constant.ENTITYTYPE_OXYGEN == entityType
				|| Constant.ENTITYTYPE_PLATELET_BULLET == entityType
				|| Constant.ENTITYTYPE_GLOBULEWHITE2 == entityType
				|| Constant.ENTITYTYPE_LIGHTNING == entityType
			);
		}
				
		public function update(time:uint):void
		{
			//Update X position 
			
			// friction
			var speedSignPos:Boolean = speedX > 0;
			speedX = speedX + accelerationX * (time * time);
			// If sign has changed, speed = 0;
			if (speedSignPos != speedX > 0)
			{
				speedX = 0;
			}
			//Force speedX to speedMaxX
			if ( Math.abs(speedX) > Math.abs(speedMaxX) )
			{
				speedX = speedX > 0 ? speedMaxX 
							 : -1 * speedMaxX;
			}
			movieClip.x = movieClip.x + (speedX * time);
			
			//Update Y position
			speedY = speedY +  gravity * (time * time);
			//Force speedY to speedMaxY
			if ( Math.abs(speedY) > Math.abs(speedMaxY) )
			{
				speedY = speedY > 0 ? speedMaxY 
							: -1 * speedMaxY;
			}

			movieClip.y = movieClip.y + (speedY * time);

			var point:Point = new Point(movieClip.x, movieClip.y);
			point = movieClip.parent.localToGlobal(point);
			
			if ( point.x <= ( -1 *  Constant.OFFSET_ACTIVITY_AREA ) )
			{
				Debug.log("Enemy with class " + getQualifiedClassName(this) + " get out from activity area");
				markAsDeleted = true;
			}
			if ( point.y >= Constant.GAME_HEIGHT + Constant.OFFSET_ACTIVITY_AREA )
			{
				Debug.log("Enemy with class " + getQualifiedClassName(this) + " get out from activity area");
				markAsDeleted = true;				
			}
			if ( point.y <= - Constant.OFFSET_ACTIVITY_AREA )
			{
				Debug.log("Enemy with class " + getQualifiedClassName(this) + " get out from activity area");
				markAsDeleted = true;				
			}
			
			outOfActivityBox =  (point.x > Constant.GAME_WIDTH + Constant.OFFSET_ACTIVITY_AREA);
		}
	}

}