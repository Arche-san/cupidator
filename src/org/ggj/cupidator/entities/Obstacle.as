package org.ggj.cupidator.entities 
{
	import org.ggj.cupidator.Constant;
	import org.ggj.cupidator.Entity;
	
	/**
	 * ...
	 * @author Jerome
	 */
	public class Obstacle extends Entity 
	{
		
		public function Obstacle() 
		{
			type = Constant.ENTITYTYPE_WALL;
		}
		
	}

}