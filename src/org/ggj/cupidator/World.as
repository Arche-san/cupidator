package org.ggj.cupidator 
{	
	/**
	 * ...
	 * @author Jerome
	 */
	public const World:WorldInst = new WorldInst();
}

import com.oaxoa.fx.Lightning;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.geom.Point;
import flash.utils.getQualifiedClassName;
import org.ggj.cupidator.*;
import org.ggj.cupidator.entities.*;

internal class WorldInst 
{
	//Movie clip containers
	public var main:Sprite;
	public var container:MovieClip;
	
	public var finished:Boolean;
	
	//Decor
	public var backgroundContainer:MovieClip;
	public var floorContainer:MovieClip;
	public var ceilContainer:MovieClip;
	public var decor:Decor;
	
	public var input:InputManager;
	public var entitiesToAdd:Vector.<Entity>;
	public var allEntities:Vector.<Entity>;
	public var enemyEntities:Vector.<Entity>;
	public var player:Player;
	public var collisionManager:CollisionManager;
	
	public var hud:Hud = null;
	
	public var whiteFader:Fader = null;
	public var blackFader:Fader = null;
	
	public var shocking:Boolean = false;
	public var shockDirX:Number = 0.0;
	public var shockDirY:Number = 0.0;
	public var shockDuration:uint = 0;
	public var shockCountdown:int = 0;
	public var shockPower:int = 0;
	public var shockSwitch:int = 1;
	
	public var isLevelEnding:Boolean = false;
	public var endLevelCountdown:int = -1;
	
	public var currentSequenceIndex:uint = 0;
	
	public var dead:Boolean = false;
	
	public function WorldInst()
	{
		allEntities = new Vector.<Entity>();
		entitiesToAdd = new Vector.<Entity>();
		enemyEntities = new Vector.<Entity>();
		collisionManager = new CollisionManager();
	}
	
	public function init(main:Sprite):void
	{
		this.main = main;
		container = new MovieClip();
		backgroundContainer = new MovieClip();
		floorContainer = new MovieClip();
		ceilContainer = new MovieClip();
		input = new InputManager(main);
		whiteFader = new Fader(0xFFFFFF);
		blackFader = new Fader(0x000000);
		hud = new Hud();
		
	}
	
	public function clearSequence():void
	{
		//Count entities in vectors
		Debug.log("Nb Entities in allEntities " + allEntities.length);
		Debug.log("Nb Entities in enemyEntities " + enemyEntities.length);
		Debug.log("Nb Entities in entitiesToAdd " + entitiesToAdd.length);
		//Delete all elements inside entities list
		var mcParent:DisplayObjectContainer;
		for each(var entity:Entity in allEntities)
		{
			//HACK : Never delete player entity
			if (entity is Player) {
				continue;
			}
			if ( null != entity.movieClip )
			{
				entity.destroy();
				mcParent = entity.movieClip.parent;
				if ( (null != mcParent) && mcParent.contains(entity.movieClip) ) {
					mcParent.removeChild(entity.movieClip);
				}
				entity.movieClip = null;
				entity = null;
			}
		}
		
		//Delete all children inside background/floor/ceil movie clip
		clearContainer(backgroundContainer);
		clearContainer(floorContainer);
		clearContainer(ceilContainer);
		
		allEntities = new Vector.<Entity>();
		entitiesToAdd = new Vector.<Entity>();
		enemyEntities = new Vector.<Entity>();
		
		this.main.removeChild(container);
		//this.main.removeChild(backgroundContainer);	
		this.main.removeChild(whiteFader.movieClip);
		this.main.removeChild(blackFader.movieClip);
		this.main.removeChild(hud.movieClip);
	}
	
	public function clearContainer(mcContainer:MovieClip):void
	{
		var numChildren:uint = mcContainer.numChildren;
		while ( --numChildren ) {
			mcContainer.removeChildAt(numChildren);
		}
	}
		
	public function update(time:uint):void
	{
		var entity:Entity;
		var entityLength:uint = allEntities.length;
		
		if ( entitiesToAdd.length > 0 )
		{
			//Process entityToAdd list
			for each( entity in entitiesToAdd )
			{
				allEntities.push(entity);
				//Store enemy entities into another list
				if ( Entity.isEnemy(entity.type) )
				{
					enemyEntities.push(entity);
				}
				//add entity movie clip to scene
				if( entity.type != Constant.ENTITYTYPE_DECOR )
					container.addChild(entity.movieClip);
				Debug.log("Add entity with type " + entity.type);
			}
			entitiesToAdd = new Vector.<Entity>();
		}
		
		var mcParent:DisplayObjectContainer;
		var cleanedAllEntities:Vector.<Entity> = allEntities.concat();
		var cleanedEnemyEntities:Vector.<Entity> = enemyEntities.concat();
		for each (entity in allEntities)
		{
			//Delete entity if mark as deleted
			if (entity.markAsDeleted)
			{
				if ( null != entity.movieClip )
				{
					entity.destroy();
					mcParent = entity.movieClip.parent;
					//Remove movie clip from display list
					if ( (null != mcParent) && (mcParent.contains(entity.movieClip)) ) {
						mcParent.removeChild(entity.movieClip);
						Debug.log("Remove clip " + entity.movieClip);
					}
					//Remove entity from entity list
					if ( cleanedAllEntities.indexOf(entity) > -1 ) {
						cleanedAllEntities.splice(cleanedAllEntities.indexOf(entity), 1);
						Debug.log("Remove entity with type " + entity.type);
					}
					//Remove entity from enemy list if entity is enemy
					if ( entity is Enemy && (cleanedEnemyEntities.indexOf(entity) > -1 ) ) {
						cleanedEnemyEntities.splice(cleanedEnemyEntities.indexOf(entity), 1);
						Debug.log("Remove enemy entity with type " + entity.type);
					}
					entity.movieClip = null;
					entity = null;
				}
			}
			else
			{
				entity.update(time);
			}
		}
		allEntities = cleanedAllEntities;
		enemyEntities = cleanedEnemyEntities;
		
		whiteFader.update(time);
		blackFader.update(time);
		
		hud.update(time);
		
		if (shocking)
		{
			shockCountdown -= time;
			if (shockCountdown <= 0)
			{
				shocking = false;
				container.x = 0;
				container.y = 0;
			} else {
				container.x = (shockDirX * shockPower) * shockSwitch * shockCountdown / shockDuration;
				container.y = (shockDirY * shockPower) * shockSwitch * shockCountdown / shockDuration;	
				shockSwitch *= -1;
			}
		}
		
		if (isLevelEnding)
		{
			endLevelCountdown -= time;
			if (endLevelCountdown < 0)
			{
				finished = true;
			}
		}
		
		if (player.life <= 0 && !dead)
		{
			dead = true;
			blackFader.startFade(0, 1, 2000);
		} else if(dead) {
			if (!blackFader.isFadePlaying())
			{
				clearSequence();
				initSequence(currentSequenceIndex)
			}
			player.life = Constant.PLAYER_LIFE_MAX;
			player.cardio = Constant.PLAYER_CARDIO_MAX;
		}
		
		collisionManager.applycollisions(allEntities);
	}
	
	public function initSequence(sequenceIndex:int):void
	{

		currentSequenceIndex = sequenceIndex;
		
		finished = false;
		isLevelEnding = false;
		endLevelCountdown = -1;
		dead = false;
		
		//this.main.addChild(backgroundContainer);
		//this.main.addChild(floorContainer);
		//this.main.addChild(ceilContainer);
		this.main.addChild(container);
		this.main.addChild(whiteFader.movieClip);
		this.main.addChild(blackFader.movieClip);		
		this.main.addChild(hud.movieClip);

		blackFader.setFadeLevel(1);
		blackFader.startFade(1, 0, 1000);
		
		
		var levelParam:LevelParam;
		//Init level param using sequenceIndex
		switch( sequenceIndex )
		{
			case 1 : 
			{
				//Level 1 : shooter
				levelParam = new LevelParam();
				levelParam.gameMode = Constant.PLAYER_MODE_SHOOT;
				levelParam.playerSpeedX = 0.1;
				levelParam.playerSpeedY = 0.1;
				levelParam.mcEnemisPatternArr = [new P14(), new P15(), new P16(), new P17(), new P18(), new P16(), new P17(), new P18(), new P19()];
				levelParam.decorPattern = 2;
				levelParam.wallPattern = 2;
				break;
			}
			case 2:
				//Level 2 : Shooter
				levelParam = new LevelParam();
				levelParam.gameMode = Constant.PLAYER_MODE_SHOOT;
				levelParam.playerSpeedX = 0.1;
				levelParam.playerSpeedY = 0.1;
				levelParam.mcEnemisPatternArr = [new P1(), new P2(), new P3(), new P4(), new P5(), new P6(), new P7(), new P8(), new P9(), new P10(), new P11(), new P4(), new P5(), new P6(), new P7(), new P8(), new P9(), new P12(), new P13()];
				levelParam.decorPattern = 1;
				levelParam.wallPattern = 1;
				break;
				
			case 3:
				//Level 3 : Boss
				levelParam = new LevelParam();
				levelParam.gameMode = Constant.PLAYER_MODE_SHOOT;
				levelParam.playerSpeedX = 0.1;
				levelParam.playerSpeedY = 0.1;
				levelParam.decorPattern = 3;
				levelParam.wallPattern = 0;
				levelParam.mcEnemisPatternArr = [new PBOSS()];
				break;
		}
		
		//Init decor
		var decor:Decor = createDecor(backgroundContainer, levelParam.decorPattern, false);
		addEntity(decor);
		if ( levelParam.wallPattern > 0 )
		{
			var floor:Decor = createDecor(floorContainer, levelParam.wallPattern, true);
			addEntity(floor);
			var ceil:Decor = createDecor(ceilContainer, levelParam.wallPattern, true, true);		
			addEntity(ceil);
		}
		
		//Init player
		if (this.player == null)
		{
			var pla:Player = createEntityPlayer();
		} else {
			this.player.isEndingLevel = false;
			this.player.isInvincible = false;
			this.player.jumpTime = 0;
			this.player.onFloor = false;
			this.player.isJumping = false;
			this.player.fireCountdown = 0;
			this.player.isRepulsed = false;
			this.player.isInvincible = false;
			this.player.hitRepulseDuration = 0;
			this.player.hitInvincibleDuration = 0;
			this.player.isEndingLevel = false;
			
		}
		this.player.movieClip.x = 50;
		this.player.movieClip.y = 480 / 2;
		
		addEntity(this.player);
		player.gameMode = levelParam.gameMode;

		//Get all children from enemis movie clip
		var offsetX:Number = 0;
		for each( var mcEnemiPattern:MovieClip in levelParam.mcEnemisPatternArr )
		{
			//Update offsetX
			//HACK : no extra offset for boss level
			if ( sequenceIndex != 3 )
				offsetX += Constant.OFFSET_BETWEEN_ENEMIES;			
			var numChildren:uint = mcEnemiPattern.numChildren;
			var levelElement:DisplayObject;
			var levelClip:MovieClip;
			var levelElementName:String;
			var levelEntity:Entity;
			var levelElementPoint:Point;
			for (var i:uint = 0; i < numChildren; ++i)
			{
				levelElement = mcEnemiPattern.getChildAt(i);
				if ( levelElement is MovieClip )
				{
					levelClip = MovieClip(levelElement);
					//Change movie clip coordinates
					levelElementPoint = new Point(levelClip.x, levelClip.y);
					levelElementPoint = levelClip.parent.localToGlobal(levelElementPoint);
					levelClip.x = offsetX + levelElementPoint.x;
					levelClip.y = levelElementPoint.y;
					//retrieve class from movie clip
					levelElementName = getQualifiedClassName(levelClip);
					//Generate entity from element name
					levelEntity = createEntityFromLevelElement(levelElementName, levelClip);
					if ( levelEntity is Enemy && sequenceIndex == 3 )
						Enemy(levelEntity).moveOnScroll = false;
					if ( null !== levelEntity )
					{
						addEntity(levelEntity);
					}
				}
			}
		}
	}
	
	public function addEntity(entity:Entity):void
	{
		entitiesToAdd.push(entity);
	}
	
	public function createEntityFromLevelElement(name:String, levelElement:MovieClip):Entity
	{
		Debug.log("Create entity from element name " + name);
		var entity:Entity = null;
		switch(name)
		{
			case Constant.ENTITYCLASS_GLOBULERED1 :
			case Constant.ENTITYCLASS_GLOBULERED12 : entity = new EnemyGlobuleRed1(); break;
			case Constant.ENTITYCLASS_GLOBULERED2 : {
				var globul:EnemyGlobuleRed1 = new EnemyGlobuleRed1(); 
				globul.explode = true;
				entity = globul;
				break;
			}
			case Constant.ENTITYCLASS_GLOBULEWHITE1 : entity = new EnemyGlobuleWhite1(); break;
			case Constant.ENTITYCLASS_GLOBULEWHITE2 : entity = new EnemyGlobuleWhite2(); break;
			case Constant.ENTITYCLASS_PLATELET1 : entity = new EnemyPlatelet1(); break;
			case Constant.ENTITYCLASS_SUGAR1 : entity = new EnemySugar1(); break;
			case Constant.ENTITYCLASS_ANTIBODY1 : entity = new EnemyAntibody1(); break;
			case Constant.ENTITYCLASS_CRATERE :
			case Constant.ENTITYCLASS_TURRET0 : entity = new EnemyTurret1(0); break;
			case Constant.ENTITYCLASS_TURRET1 : entity = new EnemyTurret1(1); break;
			case Constant.ENTITYCLASS_TURRET2 : entity = new EnemyTurret1(2); break;
			case Constant.ENTITYCLASS_TURRET3 : entity = new EnemyTurret1(3); break;
			case Constant.ENTITYCLASS_TURRET4 : entity = new EnemyTurret1(4); break;
			case Constant.ENTITYCLASS_LEVEL_FINISHED : entity = new LevelFinished(); break;
			case Constant.ENTITYCLASS_LIGHTNING : entity = new EnemyLightning(); break;
			case Constant.ENTITYCLASS_NEURONE : entity = new EnemySugar1(); break;
			case Constant.ENTITYCLASS_HEARTBOSS : entity = new HeartBoss(); break;
		}
		if( null != entity )
			entity.movieClip = levelElement;
		return entity;
	}
	
	public function createEntityPlayer():Player
	{
		//TODO : Find player in graph swc
		var mcPlayer:MovieClip = new CUPIDATOR();
		//var b:Boolean = Main(main).slip;
		//mcSlip.visible = b;
		player = new Player(mcPlayer);
		return player;
	}
	
	public function createEntityEnemy():Enemy
	{
		return new Enemy();
	}
	
	public function createEntityObstacle():Obstacle
	{
		return new Obstacle();
	}
	
	public function createEntityWall():Wall
	{
		return new Wall();
	}
	
	public function createEntityBullet():Bullet
	{
		return new Bullet();
	}
	
	public function createDecor(mc:MovieClip, decorPattern:uint, isWall:Boolean, isCeil:Boolean = false):Decor
	{
		return new Decor(mc, decorPattern, isWall, isCeil);
	}
	
	public function createEntityEnemyPlatelet1():EnemyPlatelet1
	{
		return new EnemyPlatelet1();
	}
	
	public function createEntityEnemyPlateletBullet():EnemyPlateletBullet
	{
		return new EnemyPlateletBullet();
	}
	
	public function createEntityEnemyGlobuleWhite1():EnemyGlobuleWhite1
	{
		return new EnemyGlobuleWhite1();
	}
	
	public function createEntityEnemyGlobuleWhite2():EnemyGlobuleWhite2
	{
		return new EnemyGlobuleWhite2();
	}	
	
	public function createEntityEnemyAntibody1():EnemyAntibody1
	{
		//TODO : Find player in graph swc
		return new EnemyAntibody1();
	}
	
	public function createEntityEnemyTurret(config:uint):EnemyTurret1
	{
		return new EnemyTurret1(config);
	}
	
	public function createEntityArrow():Arrow
	{
		return new Arrow();
	}	
	
	
	
	//// SHOCK ////////////////////////////////////////////////
	
	public function startShocking(duration:int, power:Number) : void
	{
		shocking = true;
		var angle:Number = Math.random() * 2 * Math.PI;
		shockDirX = Math.cos(angle);
		shockDirY = Math.sin(angle);
		shockPower = power;
		shockDuration = duration;
		shockCountdown = duration;
		shockSwitch = 1;
	}

	
}
