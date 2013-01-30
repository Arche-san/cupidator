package org.ggj.cupidator.entities 
{
	import org.ggj.cupidator.*;
	
	/**
	 * ...
	 * @author Jerome
	 */
	public class HeartBoss extends Enemy 
	{
		public var firstUpdate:Boolean = false;
		public var isOpen:Boolean = false;
		public var pendingFade:Boolean = false;
		
		public function HeartBoss()
		{
			collisionShape = CollisionManager.SHAPE_AABB;
			type = Constant.ENTITYTYPE_HEARTBOSS;
		}
		
		public override function update(time:uint):void
		{
			if (! firstUpdate )
			{
				//HACK : Swap heart position with player position
				World.container.swapChildren(movieClip, World.player.movieClip);
				firstUpdate = true;
				movieClip.gotoAndStop("stand");
			}
		}
	}

}