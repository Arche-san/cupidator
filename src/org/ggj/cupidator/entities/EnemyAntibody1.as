package org.ggj.cupidator.entities 
{
	import org.ggj.cupidator.*;
	/**
	 * ...
	 * @author Jerome
	 */
	public class EnemyAntibody1 extends Enemy 
	{
		public function EnemyAntibody1()
		{
			type = Constant.ENTITYTYPE_ANTIBODY1;
			movieClip = new ANTICORPS;
			collisionShape = CollisionManager.SHAPE_AABB;
			collisionGroup = 1;
			weight = 1;
			//radius = 0;
			moveOnScroll = false;
		}	
	}

}