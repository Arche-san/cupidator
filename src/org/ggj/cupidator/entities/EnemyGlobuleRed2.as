package org.ggj.cupidator.entities 
{
	import org.ggj.cupidator.Constant;
	/**
	 * ...
	 * @author Jerome
	 */
	public class EnemyGlobuleRed2 extends Enemy 
	{
		public function EnemyGlobuleRed2()
		{
			collisionGroup = 1;
			type = Constant.ENTITYTYPE_GLOBULERED2;
			collisionShape = CollisionManager.SHAPE_AABB;
			//collisionGroup = 0;
			weight = 1;
			//radius = 0;			
		}
	}

}