package org.ggj.cupidator.entities 
{
	import org.ggj.cupidator.Constant;
	import org.ggj.cupidator.Entity;
	import flash.display.MovieClip;
	import org.ggj.cupidator.*;
	
	/**
	 * ...
	 * @author Jerome
	 */
	public class Wall extends Entity 
	{
		
		public function Wall() 
		{
			type = Constant.ENTITYTYPE_WALL;
			
			movieClip = new MCWall();
			
			bbMovieClip = null;
			collisionShape = CollisionManager.SHAPE_AABB;
			//collisionGroup = 0;
			//weight = 0;
			//radius = 0;
			
			
		}
		
	}

}