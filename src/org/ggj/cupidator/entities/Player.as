package org.ggj.cupidator.entities 
{
	import flash.display.MovieClip;
	import org.ggj.cupidator.*;
	
	/**
	 * ...
	 * @author Jerome
	 */
	public class Player extends Entity 
	{
		public var firstFrame:Boolean = true;
		public var gameMode:uint = Constant.PLAYER_MODE_SHOOT;
		public var jumpTime:uint = 0;
		public var onFloor:Boolean = false;
		public var isJumping:Boolean = false;
		public var fireCountdown:int = 0;
		public var isRepulsed:Boolean = false;
		public var isInvincible:Boolean = false;
		public var hitRepulseDuration:int = 0;
		public var hitInvincibleDuration:int = 0;
		public var isEndingLevel:Boolean = false;
		
		public var cardio:uint = Constant.PLAYER_CARDIO_MAX;
		public var cardioRecoveryCountown:int = 0;
		
		public function Player(mcPlayer:MovieClip)
		{	
			movieClip = mcPlayer;
			
			movieClip.x = 100;
			movieClip.y = 240;
			
			movieClip.scaleX = 0.25;
			movieClip.scaleY = 0.25;
			//movieClip.width = 204.25;
			//movieClip.height = 163.60;
			movieClip.gotoAndStop(Constant.PLAYER_ANIM_STAND);
			type = Constant.ENTITYTYPE_PLAYER;
			bbMovieClip = null;
			collisionShape = CollisionManager.SHAPE_AABB;
			//collisionGroup = 0;
			weight = 1;
			//radius = 0;
			
			setSpeedMax(Number.MAX_VALUE, Constant.PLAYER_RUNNER_SPEED_YMAX);
			
			life = Constant.PLAYER_LIFE_MAX;
		}
		
		override public function update(time:uint):void
		{
			if (!Main(World.main).slip)
			{
				var mcCupidator:MovieClip = MovieClip(movieClip.cupidator);
				if ( null != mcCupidator )
				{
					var mcSlip:MovieClip = MovieClip(mcCupidator.to_slip);
					if (mcSlip != null)
					{
						mcSlip.visible = false;
					}
				}
			}
			if (isEndingLevel)
			{
				setSpeedX(Constant.PLAYER_END_LEVEL_SPEED);
				setSpeedY(0);
				super.update(time);
				return;
			}
			
			if (hitInvincibleDuration > 0)
			{
				hitInvincibleDuration -= time;
				
				var blink:Boolean = (hitInvincibleDuration % 150) > 75;
				if (blink) { movieClip.alpha = 0.5; }
				else { movieClip.alpha = 1.0; }
				
				if (hitInvincibleDuration <= 0)
				{
					movieClip.alpha = 1.0;
					isInvincible = false;
				}
			}
			
			if (hitRepulseDuration > 0)
			{
				hitRepulseDuration -= time;
				
				setSpeedX(Constant.PLAYER_HIT_REPULSE_SPEED_X);
				setSpeedY(0);
				
				if (hitRepulseDuration <= 0)
				{
					isRepulsed = false;
				}
			}
			
			//Call specific update by game mode
			if ( Constant.PLAYER_MODE_SHOOT == gameMode )
				updateShooter(time);
			else if ( Constant.PLAYER_MODE_RUNNER == gameMode )
				updateRunner(time);
			
			if(fireCountdown <= 0)
			{
				if (!isRepulsed && (World.input.mouse || World.input.actionBtn) )
				{
					fireCountdown = Constant.PLAYER_FIRE_PERIODE;
					fire();
				}
			} else {
				fireCountdown -= time;
			}
				
			super.update(time);
			
			//Player cannot be outside the scene
			if ( movieClip.x + movieClip.width/2 > Constant.GAME_WIDTH )
				movieClip.x = Constant.GAME_WIDTH - movieClip.width/2;
			if ( movieClip.x - movieClip.width/2 < 0 )
				movieClip.x = movieClip.width / 2;
			if ( movieClip.y + movieClip.height/2 > Constant.GAME_HEIGHT )
				movieClip.y = Constant.GAME_HEIGHT - movieClip.height/2;
			if ( movieClip.y - movieClip.height/2 < 0 )
				movieClip.y = movieClip.height / 2;

		}
		
		public function updateShooter(time:uint):void
		{
			gravity = 0;
			//Update speed X
			var modx:Number = 0;
			var mody:Number = 0;
			if ( !isRepulsed && World.input.keyLeft ) {
				
				modx = -1 * Constant.PLAYER_SHOOTER_SPEED;
			}
			else if ( !isRepulsed && World.input.keyRight ) {
				modx = Constant.PLAYER_SHOOTER_SPEED;
			}
			/*else if(!isRepulsed)  {
				speedX = 0;
			}*/			
			//Update speed Y
			if ( !isRepulsed && World.input.keyUp ) {
				mody = -1 * Constant.PLAYER_SHOOTER_SPEED;
			}
			else if ( !isRepulsed && World.input.keyDown ) {
				mody = Constant.PLAYER_SHOOTER_SPEED;
			}
			/*else if(!isRepulsed){
				speedY = 0;
			}*/
			//Readjust speed if both are set
			if ( modx != 0 || mody != 0 ) {
				if (modx != 0 && mody != 0 )
				{
					setSpeedX( speedX * Constant.PLAYER_SPEED_DIAGONAL_DECREASE);
					setSpeedY( speedY * Constant.PLAYER_SPEED_DIAGONAL_DECREASE);
				}
				setSpeedX(modx);
				setSpeedY(mody);
			} else {
				//Reduce globule speed using frictions
				if ( (speedX != 0 || speedY != 0) && !isRepulsed )
				{
					var speedOldX:Number = speedX;
					var speedOldY:Number = speedY;
					var speedNorm:Number = Math.sqrt( (speedX * speedX) + (speedY * speedY) );
					var frictionX:Number = -1 * ( (speedX / speedNorm) * Constant.PLAYER_RUNNER_FRICTION_SHOOTER );
					var frictionY:Number = -1 * ( (speedY / speedNorm) * Constant.PLAYER_RUNNER_FRICTION_SHOOTER );
					speedX = speedX + frictionX * (time * time);
					speedY = speedY + frictionY * (time * time);
					//Check if old speed vector and new speed vector cancel each other using scalar product
					var speedScal:Number = (speedOldX * speedX) + (speedOldY * speedY);
					if ( speedScal < 0 )
					{
						//Reinitialize speeds
						speedX = speedY = 0;
					}
				}
			}
			movieClip.gotoAndStop(Constant.PLAYER_ANIM_HORMONE);
		}
		
		public function updateRunner(time:uint):void
		{
			//Set default speed
			//setSpeedY(0, Constant.PLAYER_RUNNER_SPEED_YMAX);
			//Set Gravity
			gravity = Constant.PLAYER_RUNNER_GRAVITY;
			
			//floor/air friction
			if (speedX != 0  && !isRepulsed)
			{
				var dir:Number;
				var power:Number;
				if (speedX < 0) { dir = 1; }
				else { dir = -1;  }
				if (onFloor) { power = Constant.PLAYER_RUNNER_FRICTION_FLOOR; }
				else { power = Constant.PLAYER_RUNNER_FRICTION_AIR; }
				accelerationX = dir * power;
			}
			
			
			//Update speed X
			if ( !isRepulsed && World.input.keyLeft ) {
				setSpeedX( -1 * Constant.PLAYER_RUNNER_SPEED_X );
				accelerationX = 0;
			}
			else if ( !isRepulsed && World.input.keyRight ) {
				setSpeedX(Constant.PLAYER_RUNNER_SPEED_X);
				accelerationX = 0;
			}
			
			
			//Update speed Y
			if ( !isRepulsed && World.input.keyUp && !isJumping && onFloor) {
				//TODO : Check if player is on the ground
				isJumping = true;
				onFloor = false;
				jumpTime = 0;
			}
			
			if ( !isRepulsed && isJumping )
			{
				if (!World.input.keyUp)
				{
					isJumping = false;
				} else {
					setSpeedY(-1 * Constant.PLAYER_RUNNER_SPEED_Y);
					jumpTime += time;
					if ( jumpTime > Constant.PLAYER_RUNNER_JUMPTIME )
					{
						isJumping = false;
					}
				}
			}
			
			if(onFloor && (speedX != 0))
			{
				movieClip.gotoAndStop(Constant.PLAYER_ANIM_RUN);
			} else if (!onFloor) {
				movieClip.gotoAndStop(Constant.PLAYER_ANIM_JUMP);
			} else {
				movieClip.gotoAndStop(Constant.PLAYER_ANIM_STAND);	
			}
			
			onFloor = false;
		}
		
		public function fire() : void
		{
			Sound_Manager.playSound("gun");
			var arrow:Arrow = World.createEntityArrow();
			arrow.movieClip.x = movieClip.x;
			arrow.movieClip.y = movieClip.y - Constant.ARROW_OFFSET;
			World.addEntity(arrow);
		}
		
		public function setHit() : void
		{
			isRepulsed = true;
			isInvincible = true;
			hitInvincibleDuration = Constant.PLAYER_HIT_INVINCIBLE_DURATION;
			hitRepulseDuration = Constant.PLAYER_HIT_REPULSE_DURATION;
			isJumping = false;
		}
		
		public function endLevel() : void
		{
			isEndingLevel = true;
		}
	}
}