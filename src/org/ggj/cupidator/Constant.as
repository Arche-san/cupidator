package org.ggj.cupidator 
{
	/**
	 * ...
	 * @author Jerome
	 */
	public class Constant
	{
		public static const GAME_WIDTH:Number = 800;
		public static const GAME_HEIGHT:Number = 480;
		
		public static const SHOW_FPS:Boolean = false;
		public static const DEBUG_MODE:Boolean = false;
		
		public static const OFFSET_BETWEEN_ENEMIES:Number = 800;
		public static const OFFSET_ACTIVITY_AREA:Number = 200;
		
		/** Enum entity class names **/
		public static const ENTITYCLASS_GLOBULERED1:String = 'GLOBULEROUGE1';
		public static const ENTITYCLASS_GLOBULERED12:String = 'GLOBULEROUGE12';
		public static const ENTITYCLASS_GLOBULERED2:String = 'GLOBULEROUGE2';
		public static const ENTITYCLASS_GLOBULEWHITE1:String = 'GLOBULEBLANC1';
		public static const ENTITYCLASS_GLOBULEWHITE2:String = 'GLOBULEBLANC2';
		public static const ENTITYCLASS_PLATELET1:String = 'PLAQUETTE1';
		public static const ENTITYCLASS_ANTIBODY1:String = 'ANTICORPS1';
		public static const ENTITYCLASS_SUGAR1:String = 'SUCRE1';
		public static const ENTITYCLASS_TURRET0:String = 'TOURELLE0';
		public static const ENTITYCLASS_TURRET1:String = 'TOURELLE1';
		public static const ENTITYCLASS_TURRET2:String = 'TOURELLE2';
		public static const ENTITYCLASS_TURRET3:String = 'TOURELLE3';
		public static const ENTITYCLASS_TURRET4:String = 'TOURELLE4';
		public static const ENTITYCLASS_LEVEL_FINISHED:String = 'LEVEL_FINISHED';
		public static const ENTITYCLASS_LIGHTNING:String = 'BARRIER_ELECT';
		public static const ENTITYCLASS_NEURONE:String = 'NEURONE';
		public static const ENTITYCLASS_HEARTBOSS:String = 'COEUR';
		public static const ENTITYCLASS_CRATERE:String = 'CRATERE';
		
		/** Enum entity types **/
		public static const ENTITYTYPE_PLAYER:uint = 1;
		public static const ENTITYTYPE_ENEMY:uint = 2;
		public static const ENTITYTYPE_OBSTACLE:uint = 3;
		public static const ENTITYTYPE_WALL:uint = 4;
		public static const ENTITYTYPE_BULLET:uint = 5;
		public static const ENTITYTYPE_DECOR:uint = 6;
		//Enemy types		
		public static const ENTITYTYPE_GLOBULERED1:uint = 7;
		public static const ENTITYTYPE_GLOBULERED2:uint = 8;
		public static const ENTITYTYPE_GLOBULEWHITE1:uint = 9;
		public static const ENTITYTYPE_PLATELET1:uint = 10;
		public static const ENTITYTYPE_ANTIBODY1:uint = 11;
		public static const ENTITYTYPE_SUGAR1:uint = 12;
		public static const ENTITYTYPE_TURRET1:uint = 13;
		public static const ENTITYTYPE_OXYGEN:uint = 14;
		public static const ENTITYTYPE_PLATELET_BULLET:uint = 15;
		public static const ENTITYTYPE_GLOBULEWHITE2:uint = 16;
		public static const ENTITYTYPE_LIGHTNING:uint = 17;
		public static const ENTITYTYPE_HEARTBOSS:uint = 18;
		
		//Misc
		public static const ENTITYTYPE_ARROW:uint = 50;
		public static const ENTITYTYPE_LEVELFINISHED:uint = 51;
		
	
		/** Player Constants **/
		public static const PLAYER_MODE_SHOOT:uint = 1;
		public static const PLAYER_MODE_RUNNER:uint = 2;
		public static const PLAYER_SPEED_DIAGONAL_DECREASE:Number = 0.71;
		public static const PLAYER_FIRE_PERIODE:uint = 300;
		public static const PLAYER_CARDIO_MAX:uint = 100;
		public static const PLAYER_CARDIO_RECOVERY_PERIODE:uint = 1000;
		public static const PLAYER_LIFE_MAX:uint = 50;
		
		public static const PLAYER_HIT_INVINCIBLE_DURATION:uint = 1500;
		public static const PLAYER_HIT_REPULSE_DURATION:uint = 1000;
		public static const PLAYER_HIT_REPULSE_SPEED_X:Number = -0.08;
		
		public static const PLAYER_END_LEVEL_SPEED:Number = 0.08;
		
		//Player frames
		public static const PLAYER_ANIM_STAND:String = 'stand';
		public static const PLAYER_ANIM_RUN:String = 'course';
		public static const PLAYER_ANIM_JUMP:String = 'saut';
		public static const PLAYER_ANIM_HORMONE:String = 'hormone';
		//Specific shooter constants
		public static const PLAYER_SHOOTER_SPEED:Number = 0.3;
		//Specific runner constants
		public static const PLAYER_RUNNER_SPEED_X:Number = 0.2;
		public static const PLAYER_RUNNER_SPEED_Y:Number = 5;
		public static const PLAYER_RUNNER_SPEED_JUMP:Number = 0.1;
		public static const PLAYER_RUNNER_SPEED_YMAX:Number = 0.5;
		public static const PLAYER_RUNNER_FRICTION_FLOOR:Number = 0.00004;
		public static const PLAYER_RUNNER_FRICTION_AIR:Number = 0.00004;
		public static const PLAYER_RUNNER_JUMPTIME:uint = 300;
		public static const PLAYER_RUNNER_GRAVITY:Number = 0.0001;
		public static const PLAYER_RUNNER_FRICTION_SHOOTER:Number = 0.0001;
		
				
		public static const ENEMY_ANIM_DEAD:String = 'mort';
		
		
		public static const ENEMY_PLATELET_MOVE_TIME_MAX:uint = 800;
		public static const ENEMY_PLATELET_MOVE_TIME_MIN:uint = 400;
		public static const ENEMY_PLATELET_SPEED_MIN:Number = 0.05;
		public static const ENEMY_PLATELET_SPEED_MAX:Number = 0.1;
		public static const ENEMY_PLATELET_YMAX:uint = 380;
		public static const ENEMY_PLATELET_YMIN:uint = 100;
		public static const ENEMY_PLATELET_HP:uint = 2;
		public static const ENEMY_PLATELET_SCALE_FACTOR_PER_LEVEL:uint = 0.75;
		
		
		public static const ENEMY_GLOBULE_RED_MOVE_SPEED:Number = 0.1;
		public static const ENEMY_GLOBULE_RED_FRICTION:Number = 0.00004;
		public static const ENEMY_GLOBULE_TIME_BEAT1:uint = 500;
		public static const ENEMY_GLOBULE_TIME_BEAT2:uint = 200;
		public static const ENEMY_GLOBULE_TIME_REINIT:uint = 1000;
		
		public static const ENEMY_GLOBULEWHITE_SPEED:Number = 0.1;
		public static const ENEMY_SUGAR_SPEED:Number = 0;
		public static const ENEMY_PLATELETBULLET_SPEED:Number = 0.1;
		public static const ENEMY_OXYGEN_SPEED:Number = 0.1;
		public static const ENEMY_ANTIBODY_SPEED:Number = 0.2;
		public static const ENEMY_GLOBULEWHITE2_SPEED:Number = 0.1;
		public static const ENEMY_GLOBULEWHITE2_FRICTION:Number = 0.000004;
		public static const ENEMY_GLOBULEWHITE2_POSX:Number = 600;
		
		public static const ENEMY_TOWER_SHOT_SPEED:Number = 0.2;
		
		public static const ENEMY_TOWER0_RELOAD:Number = 3000;
		public static const ENEMY_TOWER0_BULLET_PER_SWIPE:Number = 1;
		public static const ENEMY_TOWER0_BULLET_PERIOD:Number = 0;
		public static const ENEMY_TOWER0_ANGLE_AMPLITUDE:Number = 0;
		
		public static const ENEMY_TOWER1_RELOAD:Number = 3000;
		public static const ENEMY_TOWER1_BULLET_PER_SWIPE:Number = 3;
		public static const ENEMY_TOWER1_BULLET_PERIOD:Number = 500;
		public static const ENEMY_TOWER1_ANGLE_AMPLITUDE:Number = 0;
		
		public static const ENEMY_TOWER2_RELOAD:Number = 3000;
		public static const ENEMY_TOWER2_BULLET_PER_SWIPE:Number = 3;
		public static const ENEMY_TOWER2_BULLET_PERIOD:Number = 500;
		public static const ENEMY_TOWER2_ANGLE_AMPLITUDE:Number = Math.PI / 4;

		public static const ENEMY_TOWER3_RELOAD:Number = 500;
		public static const ENEMY_TOWER3_BULLET_PER_SWIPE:Number = 7;
		public static const ENEMY_TOWER3_BULLET_PERIOD:Number = 500;
		public static const ENEMY_TOWER3_ANGLE_AMPLITUDE:Number = Math.PI / 4;		

		public static const ENEMY_TOWER4_RELOAD:Number = 500;
		public static const ENEMY_TOWER4_BULLET_PER_SWIPE:Number = 1;
		public static const ENEMY_TOWER4_BULLET_PERIOD:Number = 0;
		public static const ENEMY_TOWER4_ANGLE_AMPLITUDE:Number = 0;
		
		public static const ENEMY_LIGHTNING_TIMER_MIN:uint = 1500;
		public static const ENEMY_LIGHTNING_TIMER_MAX:uint = 3000;
		
		public static const ARROW_SPEED:Number = 1.0;
		public static const ARROW_OFFSET:Number = 32;
		public static const ARROW_TIME_QUICK:Number = 200;
		public static const ARROW_FRAME_DEFAULT:uint = 1;
		public static const ARROW_FRAME_QUICK:uint = 2;
		public static const ARROW_FRAME_POUF:uint = 3;
		
		
		/** Containers Scroll speed **/
		public static const SCROLL_SPEEDX_ENEMY:Number = 0.2;
		
		public static const LEVEL_END_DURATION:uint = 4000;
}

}