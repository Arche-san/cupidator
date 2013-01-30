package org.ggj.cupidator.entities 
{
	import flash.geom.Point;
	import org.ggj.cupidator.*;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Arrow extends Entity 
	{
		public var timeElapsed:uint = 0;
		
		public function Arrow() 
		{
			super();
			type = Constant.ENTITYTYPE_ARROW;
			
			movieClip = new FLECHE();
			//Default value for movie clip
			movieClip.gotoAndStop(Constant.ARROW_FRAME_DEFAULT);
			
			collisionShape = CollisionManager.SHAPE_AABB;
			weight = 1;
			setSpeedX(Constant.ARROW_SPEED);
			setSpeedY( -0.08);
			movieClip.rotationZ = -5;
		}	
		
		public override function update(time:uint):void
		{
			gravity = 0.00001;
			movieClip.rotationZ += 0.015 * time;
			super.update(time);
			//Destroy arrow if enter outside of activity area
			var point:Point = new Point(movieClip.x, movieClip.y);
			point = movieClip.parent.localToGlobal(point);
			if ( point.x > Constant.GAME_WIDTH + Constant.OFFSET_ACTIVITY_AREA )
			{
				Debug.log("Arrow is marked as deleted");
				markAsDeleted = true;
			}
			
			timeElapsed += time;
			if (timeElapsed > Constant.ARROW_TIME_QUICK )
			{
				movieClip.gotoAndStop(Constant.ARROW_FRAME_QUICK);
			}
		}
	}

}