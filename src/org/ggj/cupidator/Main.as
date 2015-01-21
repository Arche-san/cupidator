package org.ggj.cupidator
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import net.hires.debug.Stats;
	import flash.utils.getTimer;
	import org.ggj.cupidator.*;
	import org.ggj.cupidator.entities.EnemyGlobuleWhite2;
	import org.ggj.cupidator.entities.EnemyTurret1;
	import org.ggj.cupidator.entities.Wall;
	import flash.events.*;

	/**
	 * ...
	 * @author Jerome
	 */
    [SWF(width="800", height="480", backgroundColor="#FFFFFF", frameRate="30")]
	public class Main extends Sprite
	{
		public var lastTime:uint = 0;
		public var currentSequence:uint = 0;
		public var useWorld:Boolean = false;
		public var currentSeqMC:MovieClip = null;
		public var slip:Boolean = true;

		public function Main():void
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//Show stats in debug mode
			if (Constant.SHOW_FPS)
			{
				addChild(new Stats());
			}



			//Set world main movie clip
			World.init(this);
			//Init last time
			lastTime = getTimer();
			//Init enter frame loop
			addEventListener(Event.ENTER_FRAME, onEnterFrame);

			initNextSequence();

			/*var entity:EnemyGlobuleWhite2 = World.createEntityEnemyGlobuleWhite2();
			entity.movieClip = new GLOBULEBLANC1;
			entity.movieClip.x += 1000;
			entity.movieClip.y += 200;
			World.addEntity(entity);*/

			/*var testGlobule:MovieClip = new MCWall();
			testGlobule.x = 200;
			testGlobule.y = 200;
			testGlobule.width = 50;
			World.addEntity(World.createEntityFromLevelElement(Constant.ENTITYCLASS_GLOBULERED1, testGlobule));
			World.addEntity(World.createEntityPlayer());
			var wall:Wall = World.createEntityWall();
			wall.movieClip.x = 300;
			wall.movieClip.y = 300;
			World.addEntity(wall);
			var tower:EnemyTurret1 = World.createEntityEnemyTurret(0);
			tower.movieClip.x = 300;
			tower.movieClip.y = 300;
			World.addEntity(tower);*/
		}

		public function onEnterFrame(e:Event):void
		{
			if(useWorld) {
				var time:uint = getTimer();
				var timeDiff:uint = time - lastTime;
				//Force timeDiff if too large
				if ( timeDiff > 100 )
					timeDiff = 100;
				World.update(timeDiff);
				if (World.finished)
				{
					World.clearSequence();
					initNextSequence();
				}
				lastTime = time;
			}

		}

		public function initNextSequence() : void
		{
			currentSequence++;

			switch(currentSequence)
			{
				case 1 : // SPLASH
				{
					Sound_Manager.playMusic("splashTheme",1);

					useWorld = false;
					currentSeqMC = new MENU_SPLASH();
					currentSeqMC.bt_play.addEventListener(MouseEvent.CLICK, nextSeq);
					currentSeqMC.BT_SLIP.addEventListener(MouseEvent.CLICK, toggleSlip);
					currentSeqMC.x += currentSeqMC.width/2 - 172 ;
					currentSeqMC.y += currentSeqMC.height/2;
					addChild(currentSeqMC);
					break;
				}
				case 2 :
				{
					Sound_Manager.stopAll();
					Sound_Manager.playMusic("runTheme", 1);
					Sound_Manager.playMusic("heartbeat1", 1);

					currentSeqMC.bt_play.removeEventListener(MouseEvent.CLICK, nextSeq);
					currentSeqMC.BT_SLIP.removeEventListener(MouseEvent.CLICK, toggleSlip);
					removeChild(currentSeqMC);

					useWorld = true;
					World.initSequence(1);
					break;
				}
				case 3 :
				{
					Sound_Manager.stopAll();
					Sound_Manager.playMusic("splashTheme",1);

					useWorld = false;
					currentSeqMC = new MENU_MAP();
					currentSeqMC.x += currentSeqMC.width/2 - 57 ;
					currentSeqMC.y += currentSeqMC.height / 2;
					currentSeqMC.anim.gotoAndPlay(1);
					currentSeqMC.addEventListener(MouseEvent.CLICK, nextSeq);

					addChild(currentSeqMC);
					break;
				}
				case 4 :
				{
					Sound_Manager.stopAll();
					Sound_Manager.playMusic("runTheme", 1);
					Sound_Manager.playMusic("heartbeat1", 1);

					currentSeqMC.removeEventListener(MouseEvent.CLICK, nextSeq);
					removeChild(currentSeqMC);
					useWorld = true;
					World.initSequence(2);
					break;
				}
				case 5 :
				{
					Sound_Manager.stopAll();
					Sound_Manager.playMusic("runTheme", 1);
					Sound_Manager.playMusic("heartbeat1", 1);

					useWorld = true;
					World.initSequence(3);
					break;
				}
				case 6 :
				{
					Sound_Manager.stopAll();
					Sound_Manager.playMusic("heartbeat2", 1);
					Sound_Manager.playSound("outro");

					useWorld = false;
					currentSeqMC = new MENU_ENDING();
					currentSeqMC.x += currentSeqMC.width/2 - 94 ;
					currentSeqMC.y += currentSeqMC.height/2 - 850;
					currentSeqMC.gotoAndPlay(1);
					addChild(currentSeqMC);
					break;
				}
			}

			/*switch(currentSequence)
			{
				case 1 : // SPLASH
				{
					Sound_Manager.playMusic("splashTheme",1);

					useWorld = false;
					currentSeqMC = new MENU_SPLASH();
					currentSeqMC.bt_play.addEventListener(MouseEvent.CLICK, nextSeq);
					currentSeqMC.BT_SLIP.addEventListener(MouseEvent.CLICK, toggleSlip);
					currentSeqMC.x += currentSeqMC.width/2 - 172 ;
					currentSeqMC.y += currentSeqMC.height/2;
					addChild(currentSeqMC);
					break;
				}
				case 2 :
				{
					Sound_Manager.stopAll();
					Sound_Manager.playMusic("splashTheme",1);

					currentSeqMC.bt_play.removeEventListener(MouseEvent.CLICK, nextSeq);
					currentSeqMC.BT_SLIP.removeEventListener(MouseEvent.CLICK, toggleSlip);
					removeChild(currentSeqMC);

					useWorld = false;
					currentSeqMC = new MENU_MAP();
					currentSeqMC.x += currentSeqMC.width/2 - 57 ;
					currentSeqMC.y += currentSeqMC.height / 2;
					currentSeqMC.anim.gotoAndPlay(1);
					currentSeqMC.addEventListener(MouseEvent.CLICK, nextSeq);

					addChild(currentSeqMC);
					break;
				}
				case 3 :
				{
					Sound_Manager.stopAll();
					Sound_Manager.playMusic("runTheme", 1);
					Sound_Manager.playMusic("heartbeat1", 1);

					currentSeqMC.removeEventListener(MouseEvent.CLICK, nextSeq);
					removeChild(currentSeqMC);
					useWorld = true;
					World.initSequence(2);
					break;
				}
				case 4 :
				{
					Sound_Manager.stopAll();
					Sound_Manager.playMusic("runTheme", 1);
					Sound_Manager.playMusic("heartbeat1", 1);

					useWorld = true;
					World.initSequence(3);
					break;
				}
				case 5 :
				{
					Sound_Manager.stopAll();
					Sound_Manager.playMusic("heartbeat2", 1);
					Sound_Manager.playSound("outro");

					useWorld = false;
					currentSeqMC = new MENU_ENDING();
					currentSeqMC.x += currentSeqMC.width/2 - 94 ;
					currentSeqMC.y += currentSeqMC.height/2 - 850;
					currentSeqMC.gotoAndPlay(1);
					addChild(currentSeqMC);
					break;
				}
			}*/

		}

		public function nextSeq(event:MouseEvent) : void
		{
			initNextSequence();
		}

		public function toggleSlip(event:MouseEvent) : void
		{
			slip = false;
		}


	}

}