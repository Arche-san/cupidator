package org.ggj.cupidator.entities 
{
	import org.ggj.cupidator.*;
	/**
	 * ...
	 * @author Jerome
	 */
	public class EnemySugar1 extends Enemy 
	{
		public var state:uint = 3;
		public function EnemySugar1()
		{
			type = Constant.ENTITYTYPE_SUGAR1;
			
			life = 3;
			state = 4;

			setSpeedX(Constant.ENEMY_SUGAR_SPEED);
			setSpeedY(0);
			
			collisionShape = CollisionManager.SHAPE_AABB;
			collisionGroup = 1;
			weight = 1;
			//radius = 0;			
		}
		
		public override function update(time:uint):void
		{
			if (life < state)
			{
				setState(life);
			}
			super.update(time);
		}
		
		public function setState(life:uint) : void
		{
			state = life;
			switch(state)
			{
					case 0 : movieClip.gotoAndStop("cellule4"); break;
					case 1 : movieClip.gotoAndStop("cellule3"); break;
					case 2 : movieClip.gotoAndStop("cellule2"); break;
					case 3 : movieClip.gotoAndStop("cellule1"); break;
			}
		}
	}

}