package org.ggj.cupidator.entities 
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import org.ggj.cupidator.*;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	import org.ggj.cupidator.Constant;
	import org.ggj.cupidator.Debug;
	import org.ggj.cupidator.Entity;
	import org.ggj.cupidator.World;	
	
	/**
	 * ...
	 * @author Jerome
	 */
	public class Enemy extends Entity 
	{
		public var moveOnScroll:Boolean = true;
		
		public var enterActivityArea:Boolean = false;
		
		public var enemyFirstUpdate:Boolean = true;
				
		public function Enemy() 
		{
			//type = Constant.ENTITYTYPE_ENEMY;
			collisionShape = CollisionManager.SHAPE_AABB;
			collisionGroup = 1;
			weight = 1;
			//radius = 0;
		}
		
		public override function update(time:uint):void
		{
			//Do not update entity if entity is dead and play dead animation
			if ( markAsDead )
			{
				var deadAnimFound:Boolean = false;
				//Check if frame label stop exists
				for each( var frameLabel:FrameLabel in movieClip.currentLabels )
				{
					if (frameLabel.name == Constant.ENEMY_ANIM_DEAD) 
					{
						deadAnimFound = true;
					}
				}
				if ( deadAnimFound )
				{
					if (frameLabel.name == Constant.ENEMY_ANIM_DEAD) 
					{
						deadAnimFound = true;
						movieClip.gotoAndStop(Constant.ENEMY_ANIM_DEAD);
						//Check if children has finished animation
						if ( null !== movieClip.getChildByName(Constant.ENEMY_ANIM_DEAD) )
						{
							if ( movieClip.mort.currentFrame == movieClip.mort.totalFrames )
							{
								markAsDeleted = true;
							}
						}
					}
				}
				else
				{
					markAsDeleted = true;
				}
				return;
			}
			//Set horizontal scrolling speed if moveOnScroll is available
			if ( moveOnScroll )
			{
				movieClip.x = movieClip.x - Constant.SCROLL_SPEEDX_ENEMY * time;
			}
			movieClip.gotoAndStop(1);
			
			
			//Use stand animation by default if exists
			if (enemyFirstUpdate)
			{
				movieClip.gotoAndStop(1);
				enemyFirstUpdate = false;
			}
			//Enable behaviour if enemy enter inside activity area
			var point:Point = new Point(movieClip.x, movieClip.y);
			point = movieClip.parent.localToGlobal(point);
			if ( point.x <= Constant.GAME_WIDTH + Constant.OFFSET_ACTIVITY_AREA )
			{
				if ( !enterActivityArea )
				{
					Debug.log("Enemy with class " + getQualifiedClassName(this) + " enter in activity area");
					enterActivityArea = true;
				}
				super.update(time);
			}
		}
		
	}

}