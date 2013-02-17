package org.ggj.cupidator.entities 
{
	import com.oaxoa.fx.Lightning;
	import flash.display.BlendMode;
	import flash.filters.GlowFilter;
	import org.ggj.cupidator.*;
	
	/**
	 * ...
	 * @author ...
	 */
	public class EnemyLightning extends Enemy 
	{
		
		public var active:Boolean = true;
		public var timer:int = 0;
		public var ll:Lightning;
		
		public function EnemyLightning() 
		{
			type = Constant.ENTITYTYPE_LIGHTNING;
			collisionShape = CollisionManager.SHAPE_AABB;
			
			collisionGroup = 1;
		}
		
		/*public function toggleState() : void
		{
			timer = Math.floor(Math.random() * (Constant.ENEMY_LIGHTNING_TIMER_MAX - Constant.ENEMY_LIGHTNING_TIMER_MIN)) + Constant.ENEMY_LIGHTNING_TIMER_MIN;
			active = !active;
			movieClip.visible = active;
			//updateTiming();
		}*/
		
		/*private function updateTiming():void 
		{
			timer -= 200;
			if (timer <= 200)
		}*/
		
		public override function update(time:uint):void
		{
			super.update(time);			
			movieClip.fingers.visible = false;
			movieClip.dot1.visible = false;
			
			if ( enterActivityArea )
			{
				if ( !markAsDeleted )
				{
					if ( null == ll ) {
						initLighting();
					}
					else {
						//Update positions
						ll.endX = movieClip.fingers.x;
						ll.endY = movieClip.fingers.y;
						ll.update();
					}
				}
				else
				{
					if ( movieClip.contains(ll) )
					{
						ll.kill();
						//movieClip.removeChild(ll);
						ll = null;
						Debug.log("Killing Lighting");
					}
				}
			}
		}
		
		public function initLighting():void
		{
			movieClip.setChildIndex(movieClip.fingers, 1);			
			var color:uint = 0xddeeff;			
			ll = new Lightning(color, 2);
			ll.blendMode= BlendMode.ADD;
			ll.childrenProbability=.5;
			ll.childrenLifeSpanMin=.1;
			ll.childrenLifeSpanMax=1.5;
			ll.maxLength=500;
			ll.maxLengthVary=500;

			ll.startX=movieClip.dot1.x;
			ll.startY=movieClip.dot1.y;

			var glow:GlowFilter=new GlowFilter();
			glow.color=color;
			glow.strength=3.5;
			glow.quality=3;
			glow.blurX=glow.blurY=10;
			ll.filters =[glow];
			movieClip.addChild(ll);			
		}
	}

}