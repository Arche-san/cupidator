package org.ggj.cupidator 
{
	import com.oaxoa.fx.Lightning;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.*;
	import org.ggj.cupidator.*;
	import org.ggj.cupidator.entities.*;
	
	/**
	 * ...
	 * @author ...
	 */
	public class CollisionManager 
	{
		public static const SIDE_UNDEFINED:uint = 0;
		public static const SIDE_UP:uint = 1;
		public static const SIDE_DOWN:uint = 2;
		public static const SIDE_LEFT:uint = 3;
		public static const SIDE_RIGHT:uint = 4;

		public static const SHAPE_AABB:uint = 0;
		public static const SHAPE_OBB:uint = 1;
		public static const SHAPE_CIRCLE:uint = 2;
		public static const SHAPE_POINT:uint = 3;
		
		public var frameCollisionArr:Vector.<ColInfo>;

		// returning -1, 0, 1
		public function sortColInfo(a:ColInfo, b:ColInfo) : int
		{
			var result:int;
			if (a.overlap < b.overlap) {
				result = 1;
			} else if (a.overlap > b.overlap) {
				result =  -1;    
			} else {
				result 0;
			}
			return result;
		}
		
		public function CollisionManager()
		{
			frameCollisionArr = new Vector.<ColInfo>;
		}
		
		
				public function resolveCollisions() : void
		{
			frameCollisionArr.sort(sortColInfo);
			var nbElem:uint = frameCollisionArr.length;
			var i:uint = 0;
			for ( i = 0; i < nbElem; ++i )
			{
				var colInfo:ColInfo = frameCollisionArr[i];
				var isPhysicCollision:Boolean = false;
				
				// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
				// Respect hierarchy : colInfo.a.type <= colInfo.b.type
				// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
				
				// from first to last type :
				// ENTITYTYPE_PLAYER:uint = 1;
				// ENTITYTYPE_ENEMY:uint = 2;
				// ENTITYTYPE_OBSTACLE:uint = 3;
				// ENTITYTYPE_WALL:uint = 4;
				// ENTITYTYPE_BULLET:uint = 5;
				// ENTITYTYPE_DECOR:uint = 6;
				// ...
				
				// From the most important to the less important
				if (colInfo.a.type == Constant.ENTITYTYPE_PLAYER && colInfo.b.type == Constant.ENTITYTYPE_HEARTBOSS)
				{
					isPhysicCollision = collisionHeartOnPlayer(colInfo);
				} 					
				if (colInfo.a.type == Constant.ENTITYTYPE_HEARTBOSS && colInfo.b.type == Constant.ENTITYTYPE_ARROW)
				{
					isPhysicCollision = collisionHeartOnArrow(colInfo);
				} 				
				else if (colInfo.a.type == Constant.ENTITYTYPE_PLATELET1 && colInfo.b.type == Constant.ENTITYTYPE_PLATELET1)
				{
					isPhysicCollision = collisionPlateletOnPlatelet(colInfo);
				} else if (colInfo.a.type == Constant.ENTITYTYPE_PLAYER && colInfo.b.type == Constant.ENTITYTYPE_LIGHTNING)
				{
					isPhysicCollision = collisionPlayerOnLightning(colInfo);
				}else if (colInfo.a.type == Constant.ENTITYTYPE_PLAYER && Entity.isEnemy(colInfo.b.type))
				{
					isPhysicCollision = collisionPlayerOnEnemy(colInfo);
				}  else if (Entity.isEnemy(colInfo.a.type) && colInfo.b.type == Constant.ENTITYTYPE_ARROW)
				{
					isPhysicCollision = collisionEnemyOnArrow(colInfo);
				} else if (colInfo.a.type == Constant.ENTITYTYPE_PLAYER && colInfo.b.type == Constant.ENTITYTYPE_WALL) {
					isPhysicCollision = collisionPlayerOnWall(colInfo);
				} else if (colInfo.a.type == Constant.ENTITYTYPE_PLAYER && colInfo.b.type == Constant.ENTITYTYPE_LEVELFINISHED) {
					isPhysicCollision = collisionPlayerOnLevelFinished(colInfo);
				} else  {
					isPhysicCollision = false;
				}
				if (isPhysicCollision)
				{
					block(colInfo);
				}
			}
		}
		
		
		
		//////////////////////////////////////////////////////////////////////////////////////////
		// GAMEPLAY COLLISIONS
		//////////////////////////////////////////////////////////////////////////////////////////
		
		public function collisionHeartOnPlayer(colInfo:ColInfo) :Boolean
		{
			var player:Player = Player(colInfo.a);
			var heart:HeartBoss = HeartBoss(colInfo.b);
			
			if (heart.isOpen)
			{
				if ( !heart.pendingFade )
				{
					World.whiteFader.startFade(0, 1, 3000);
					heart.pendingFade = true;
				}
				else
				{
					if (!World.whiteFader.isFadePlaying())
					{
						World.finished = true;
						player.isInvincible = true;
					}
				}
			}
			return false;
		}
		
		
		public function collisionHeartOnArrow(colInfo:ColInfo) : Boolean
		{
			var heart:HeartBoss = HeartBoss(colInfo.a);
			var arrow:Arrow = Arrow(colInfo.b);
			
			if (!heart.isOpen)
			{
				arrow.markAsDeleted = true;
				World.player.cardio -= 1;
				if (World.player.cardio <= 0)
				{
					heart.movieClip.gotoAndStop("brille");
					heart.isOpen = true;
				}
			}
			return false;
		}

		public function collisionPlayerOnLightning(colInfo:ColInfo) : Boolean
		{
			var player:Player = Player(colInfo.a);
			var lightning:EnemyLightning = EnemyLightning(colInfo.b);

			if (!lightning.active) return false;
			if (player.isInvincible > 0) return false;
			
			player.life -= 3;
			World.startShocking(500, 5);
			
			player.setHit();
			
			return false;
		}

		public function collisionPlayerOnEnemy(colInfo:ColInfo) : Boolean
		{
			var player:Player = Player(colInfo.a);
			var enemy:Enemy = Enemy(colInfo.b);
			
			if (player.isInvincible > 0) return false;
			
			Sound_Manager.playSound("contact");
			World.player.cardio -= 3;
			
			enemy.markAsDeleted = true;
			if (enemy.type == Constant.ENTITYTYPE_GLOBULEWHITE1)
			{
				player.life -= 3;
				World.startShocking(500, 5);
				
			} else {
				player.life -= 1;
				World.startShocking(500, 5);
			}
			
			player.setHit();
			
			
			return false;
		}

		public function collisionPlayerOnWall(colInfo:ColInfo) : Boolean
		{
			var player:Player = Player(colInfo.a);
			var wall:Wall = Wall(colInfo.b);
			if (colInfo.side == SIDE_DOWN)
			{
				player.onFloor = true;
			}
			return true;
		}
		
		public function collisionPlateletOnPlatelet(colInfo:ColInfo) : Boolean
		{
			var platA:EnemyPlatelet1 = EnemyPlatelet1(colInfo.a);
			var platB:EnemyPlatelet1 = EnemyPlatelet1(colInfo.b);
			var mergeX:Number = (platA.movieClip.x + platB.movieClip.x) / 2;
			var mergeY:Number = (platA.movieClip.y + platB.movieClip.y) / 2;
			platA.movieClip.x = mergeX;
			platA.movieClip.y = mergeY;
			platA.setLevel(platA.level + platB.level);
			
			platB.markAsDeleted = true;
			return false;
		}
		
		public function collisionEnemyOnArrow(colInfo:ColInfo) : Boolean
		{
			var enemy:Enemy = Enemy(colInfo.a);
			var arrow:Arrow = Arrow(colInfo.b);
			
			
			
			if (enemy.life > 0)
			{
				arrow.markAsDeleted = true;
				enemy.life -= 1;
				if (enemy.life == 0)
				{
					Sound_Manager.playSound("pop");
					enemy.markAsDead = true;
				}
			}
			if (enemy.type == Constant.ENTITYTYPE_PLATELET1)
			{
				EnemyPlatelet1(enemy).onHit();
			} else if (enemy.type == Constant.ENTITYTYPE_GLOBULERED1)
			{
				EnemyGlobuleRed1(enemy).onHit();
			}
			return false;
			
		}
		
		public function collisionPlayerOnLevelFinished(colInfo:ColInfo) : Boolean
		{
			var player:Player = Player(colInfo.a);
			if (player.isEndingLevel) return false;
			
			player.endLevel();
			World.endLevelCountdown = Constant.LEVEL_END_DURATION;
			World.blackFader.startFade(0, 1, Constant.LEVEL_END_DURATION);
			World.isLevelEnding = true;
			return false;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		public function checkForCollisions(entityVec:Vector.<Entity>) : void
		{
			var nbElem:uint = entityVec.length;
			var i:uint = 0;
			for ( i = 0; i < nbElem; ++i )
			{
				var a:Entity = entityVec[i];					
				var j:uint = i+1;
				for ( ; j < nbElem; ++j )
				{
					var b:Entity = entityVec[j];
					if (!a.markAsDeleted && !b.markAsDeleted && !(a.isInSameCollisionGroup(b)) )
					{
						var shapeA:uint = a.collisionShape;
						var shapeB:uint = b.collisionShape;
						if (shapeB < shapeA)
						{
							var shapeTmp:uint = shapeA;
							shapeA = shapeB;
							shapeB = shapeTmp;
							var tmp:Entity = a;
							a = b;
							b = tmp;
						}
						if (shapeA == SHAPE_AABB)
						{
							if (shapeB == SHAPE_AABB) { collisionAABBOnAABB(a, b); }
							if (shapeB == SHAPE_OBB) { collisionAABBOnOBB(a, b); }
							if (shapeB == SHAPE_CIRCLE) { collisionAABBOnCircle(a, b); }
							if (shapeB == SHAPE_POINT) { collisionAABBOnPoint(a, b); }
						}
						if (shapeA == SHAPE_OBB)
						{
							if (shapeB == SHAPE_OBB) { collisionOBBOnOBB(a, b); }
							if (shapeB == SHAPE_CIRCLE) { collisionOBBOnCircle(a, b); }
							if (shapeB == SHAPE_POINT) { collisionOBBOnPoint(a, b); }
						}
						if (shapeA == SHAPE_CIRCLE)
						{
							if (shapeB == SHAPE_CIRCLE) { collisionCircleOnCircle(a, b); }
							if (shapeB == SHAPE_POINT) { collisionCircleOnPoint(a, b); }
						}
						if (shapeA == SHAPE_POINT)
						{
							// Point on point collision ? Sure... Go on :)
						}
					}
				}
			}
		}

		public function block(colInfo:ColInfo) : void
		{
			// Who repulse who ? Based on weight system. The heavier move the less. weight <= 0 is infinit weight
			var repulseA:Number = 0;
			var repulseB:Number = 0;
			if (colInfo.a.weight <= 0 && colInfo.b.weight > 0)
			{
				repulseA = 0;
				repulseB = 1;
			} else if (colInfo.b.weight <= 0 && colInfo.a.weight > 0)
			{
				repulseA = 1;				
				repulseB = 0;
			} else if (colInfo.a.weight > 0 && colInfo.b.weight > 0)
			{
				repulseA = 1 - (colInfo.a.weight / (colInfo.a.weight + colInfo.b.weight));
				repulseB = 1 - repulseA;
			}
			
			repulseA *= colInfo.overlap;
			repulseB *= colInfo.overlap;
			
			if (colInfo.side != SIDE_UNDEFINED)
			{
				switch(colInfo.side)
				{
					case SIDE_DOWN : { colInfo.a.movieClip.y -= repulseA; colInfo.b.movieClip.y += repulseB; break; }
					case SIDE_UP : { colInfo.a.movieClip.y += repulseA; colInfo.b.movieClip.y -= repulseB; break; }
					case SIDE_LEFT : { colInfo.a.movieClip.x -= repulseA; colInfo.b.movieClip.x += repulseB; break; }
					case SIDE_RIGHT : { colInfo.a.movieClip.x += repulseA; colInfo.b.movieClip.x -= repulseB; break; }
				}
			} else {
				var vx:Number = colInfo.b.movieClip.x - colInfo.a.movieClip.x;
				var vy:Number = colInfo.b.movieClip.y - colInfo.a.movieClip.y;
				// Normalize
				var vlength:Number = Math.sqrt(vx * vx + vy * vy)
				vx /= vlength;
				vy /= vlength;
				colInfo.a.movieClip.y -= repulseA * vy;
				colInfo.b.movieClip.y += repulseB * vy;
				colInfo.a.movieClip.x -= repulseA * vx;
				colInfo.b.movieClip.x += repulseB * vx;
			}
		}
		
		public function addColInfo(a:Entity, b:Entity, overlap:Number, side:uint = SIDE_UNDEFINED) : void
		{
			if (a.type > b.type)
			{
				var tmp:Entity = a;
				a = b;
				b = tmp;
				switch(side)
				{
					case SIDE_DOWN : side = SIDE_UP; break;
					case SIDE_UP : side = SIDE_DOWN; break;
					case SIDE_LEFT : side = SIDE_RIGHT; break;
					case SIDE_RIGHT : side = SIDE_LEFT; break;
				}
				// Nothing to change for overlap
			}
			frameCollisionArr.push(new ColInfo(a, b, overlap, side));
		}

		public function applycollisions(entityVec:Vector.<Entity>) : void
		{
			frameCollisionArr = new Vector.<ColInfo>;
			checkForCollisions(entityVec);
			resolveCollisions();
		}
		
		//////////////////////////////////////////////////////////////////////////////////////////
		// COLLISION FUNCTION
		//////////////////////////////////////////////////////////////////////////////////////////
		public function collisionAABBOnAABB(a:Entity, b:Entity) : void
		{
			var mcA:MovieClip = a.getBBMovieClip();
			var mcB:MovieClip = b.getBBMovieClip();
			var collision:Boolean = mcA.hitTestObject(mcB);
			if (collision == false) return;
			
			var overlap:Number = 0;
			
			var r1HalfWidth:Number = mcA.width / 2.0;
			var r1HalfHeight:Number = mcA.height / 2.0;
			var r2HalfWidth:Number = mcB.width / 2.0;
			var r2HalfHeight:Number = mcB.height / 2.0;
			
			if ( null == mcA.parent ) return;
			var gPtA:Point = new Point(mcA.x, mcA.y); 
			gPtA = mcA.parent.localToGlobal(gPtA);
			var gPtB:Point = new Point(mcB.x, mcB.y); 
			gPtB = mcA.parent.localToGlobal(gPtB);
			
			// HACK
			if (a.type == Constant.ENTITYTYPE_PLAYER)
			{
				r1HalfWidth *= 0.33;
				if (Player(a).gameMode === Constant.PLAYER_MODE_SHOOT)
				{
					r1HalfHeight *= 0.5;
					//gPtA.y = - 10;
				}
			}			
			
			var r1Top:Number = gPtA.y + r1HalfHeight;
			var r1Bottom:Number = gPtA.y - r1HalfHeight;
			var r1Right:Number = gPtA.x + r1HalfWidth;
			var r1Left:Number =  gPtA.x - r1HalfWidth;
			
			var r2Top:Number = gPtB.y + r2HalfHeight;
			var r2Bottom:Number = gPtB.y - r2HalfHeight;
			var r2Right:Number = gPtB.x + r2HalfWidth;
			var r2Left:Number =  gPtB.x - r2HalfWidth;
			
			if(r1Bottom - r2Top > -0.00001) return;
			if(r2Bottom - r1Top > -0.00001) return;
			if(r1Left - r2Right > -0.00001) return;
			if(r2Left - r1Right > -0.00001) return;

			// Else Collision !!!
			var bBottomOnTop:Boolean;
			var bLeftOnRight:Boolean;
			var hDist:Number = gPtB.x - gPtA.x;
			var vDist:Number = gPtB.y - gPtA.y;
			if(hDist > 0)
			{
				bLeftOnRight = false;
				hDist = (r2HalfWidth + r1HalfWidth) - hDist;		
			} else {
				bLeftOnRight = true;
				hDist = (r2HalfWidth + r1HalfWidth) + hDist;
			}
			
			if(vDist > 0)
			{
				bBottomOnTop = true;
				vDist = (r2HalfHeight + r1HalfHeight) - vDist;
			} else {
				bBottomOnTop = false;
				vDist = (r2HalfHeight + r1HalfHeight) + vDist;
			}
			var side:uint = SIDE_UNDEFINED;
			if(hDist > vDist)
			{
				if(bBottomOnTop) side = SIDE_DOWN;
				else side = SIDE_UP;
				overlap = vDist;
			} else {
				if(bLeftOnRight) side = SIDE_RIGHT;
				else side = SIDE_LEFT;
				overlap = hDist;
			}
			frameCollisionArr.push(new ColInfo(a, b, overlap, side));
		}
		
		public function collisionAABBOnOBB(a:Entity, b:Entity) : void
		{
			// Not implemented in this project
		}
		
		public function collisionAABBOnCircle(a:Entity, b:Entity) : void
		{
			/*var mcA:MovieClip = a.getBBMovieClip();
			var mcB:MovieClip = b.getBBMovieClip();
			var radB:Number = b.radius;
			
			var r1HalfWidth:Number = mcA.width / 2.0;
			var r1HalfHeight:Number = mcA.height / 2.0;
			
			var gPtA:Point = new Point(mcA.x, mcA.y); 
			gPtA = mcA.parent.localToGlobal(gPtA);
			var gPtB:Point = new Point(mcB.x, mcB.y); 
			gPtB = mcB.parent.localToGlobal(gPtB);
			
			var r1Top:Number = gPtA.y + r1HalfHeight;
			var r1Bottom:Number = gPtA.y - r1HalfHeight;
			var r1Right:Number = gPtA.x + r1HalfWidth;
			var r1Left:Number =  gPtA.x - r1HalfWidth;
			
			
			
			if (    (gPtB.y > (r1Top - radB)) && (gPtB.y < (r1Bottom + radB)) 
				 && (gPtB.x > (r1Left - radB)) && (gPtB.x < (r1Right + radB))	)
			{
				// TODO : overlap to calculate
				frameCollisionArr.push(new ColInfo(a, b, 0, SIDE_UNDEFINED));
			}*/
			collisionOBBOnCircle(a, b);
		}
		
		public function collisionAABBOnPoint(a:Entity, b:Entity) : void
		{
			var mcA:MovieClip = a.getBBMovieClip();
			var mcB:MovieClip = b.getBBMovieClip();
			var gPtB:Point = new Point(mcB.x, mcB.y); 
			gPtB = mcB.parent.localToGlobal(gPtB);
			var collide:Boolean = mcA.hitTestPoint(gPtB.x, gPtB.y);
			if (collide)
			{
				// TODO : overlap to calculate
				frameCollisionArr.push(new ColInfo(a, b, 0, SIDE_UNDEFINED));
			}
		}
		
		/*public function collisionOBBOnOBB(a:Entity, b:Entity) : void
		{
			var mcA:MovieClip = a.getBBMovieClip();
			var mcB:MovieClip = b.getBBMovieClip();
			var collision:Boolean = mcA.hitTestObject(mcB);
			if (collision)
			{
				// TODO : overlap to calculate
				// Make it work
				frameCollisionArr.push(new ColInfo(a, b, 0, SIDE_UNDEFINED));
			}
		}*/
//////////////////////////////////////////////////////////////////////////////////////////////////
		public function getOBB(mc:MovieClip) : Array
		{
			var r:Rectangle = mc.getRect(mc);
			var mat:Matrix = mc.transform.matrix;
			var p1:Point = new Point(r.top, r.left);
			var p2:Point = new Point(r.top, r.right);
			var p3:Point = new Point(r.bottom, r.right);
			var p4:Point = new Point(r.bottom, r.left);
			
			p1 = mat.transformPoint(p1);
			p2 = mat.transformPoint(p2);
			p3 = mat.transformPoint(p3);
			p4 = mat.transformPoint(p4);
			
			return([p1, p2, p3, p4]);				
		}
		

		public function collisionOBBOnOBB(a:Entity, b:Entity) : void
		{
			var b1:Array = getOBB(a.getBBMovieClip());
			var b2:Array = getOBB(b.getBBMovieClip());
			
			var a1:Point = new Point(b1[0].x-b1[1].x, b1[1].y-b1[0].y);
			var a2:Point = new Point(b2[0].x-b2[1].x, b2[1].y-b2[0].y);
			
			var tMax1:Number = 0;
			var tMin1:Number = 0;
			var tMax2:Number = 0;
			var tMin2:Number = 0;
			
			// dot red
			var rDR1:Number  = b1[0].x*a1.x+a1.y*b1[0].y;
			var rDR2:Number  = b1[1].x*a1.x+a1.y*b1[1].y;
			var rDR3:Number  = b1[2].x*a1.x+a1.y*b1[2].y;
			var rDR4:Number  = b1[3].x*a1.x+a1.y*b1[3].y;
			tMax1 = Math.max(rDR1, rDR2, rDR3, rDR4);
			tMin1 = Math.min(rDR1, rDR2, rDR3, rDR4);
				
			var _rDR1:Number  = b2[0].x*a1.x+a1.y*b2[0].y;
			var _rDR2:Number  = b2[1].x*a1.x+a1.y*b2[1].y;
			var _rDR3:Number  = b2[2].x*a1.x+a1.y*b2[2].y;    
			var _rDR4:Number  = b2[3].x*a1.x+a1.y*b2[3].y;    
			tMax2 = Math.max(_rDR1, _rDR2, _rDR3, _rDR4);
			tMin2 = Math.min(_rDR1, _rDR2, _rDR3, _rDR4);
			
			if(tMin1 > tMax2 || tMax1 < tMin2) return;
			
			// dot red ninety
			var rDRN1:Number = b1[0].x*a1.y+a1.x*b1[0].y;
			var rDRN2:Number = b1[1].x*a1.y+a1.x*b1[1].y;
			var rDRN3:Number = b1[2].x*a1.y+a1.x*b1[2].y;    
			var rDBN4:Number = b1[3].x*a1.y+a1.x*b1[3].y;
			tMax1 = Math.max(rDRN1, rDRN2, rDRN3, rDRN4);
			tMin1 = Math.min(rDRN1, rDRN2, rDRN3, rDRN4);
			
			var _rDRN1:Number = b2[0].x*a1.y+a1.x*b2[0].y;
			var _rDRN2:Number = b2[1].x*a1.y+a1.x*b2[1].y;    
			var _rDRN3:Number = b2[2].x*a1.y+a1.x*b2[2].y;
			var _rDRN4:Number = b2[3].x*a1.y+a1.x*b2[3].y;    
			tMax2 = Math.max(_rDRN1, _rDRN2, _rDRN3, _rDRN4);
			tMin2 = Math.min(_rDRN1, _rDRN2, _rDRN3, _rDRN4);
			
			if(tMin1 > tMax2 || tMax1 < tMin2) return;    
			
			// dot blue
			var rDB1:Number  = b1[0].x*a2.x+a2.y*b1[0].y;    
			var rDB2:Number  = b1[1].x*a2.x+a2.y*b1[1].y;
			var rDB3:Number  = b1[2].x*a2.x+a2.y*b1[2].y;
			var rDB4:Number  = b1[3].x*a2.x+a2.y*b1[3].y;    
			tMax1 = Math.max(rDB1, rDB2, rDB3, rDB4);
			tMin1 = Math.min(rDB1, rDB2, rDB3, rDB4);
			
			var _rDB1:Number  = b2[0].x*a2.x+a2.y*b2[0].y;
			var _rDB2:Number  = b2[1].x*a2.x+a2.y*b2[1].y;    
			var _rDB3:Number  = b2[2].x*a2.x+a2.y*b2[2].y;
			var _rDB4:Number  = b2[3].x*a2.x+a2.y*b2[3].y;    
			tMax2 = Math.max(_rDB1, _rDB2, _rDB3, _rDB4);
			tMin2 = Math.min(_rDB1, _rDB2, _rDB3, _rDB4);
			
			if(tMin1 > tMax2 || tMax1 < tMin2) return;    

			// dot blue ninety
			var rDBN1:Number = b1[0].x*a2.y+a2.x*b1[0].y;    
			var rDBN2:Number = b1[1].x*a2.y+a2.x*b1[1].y;
			var rDBN3:Number = b1[2].x*a2.y+a2.x*b1[2].y;
			var rDRN4:Number = b1[3].x*a1.y+a1.x*b1[3].y;
			tMax1 = Math.max(rDRN1, rDRN2, rDRN3, rDRN4);
			tMin1 = Math.min(rDRN1, rDRN2, rDRN3, rDRN4);
			
			var _rDBN1:Number = b2[0].x*a2.y+a2.x*b2[0].y;
			var _rDBN2:Number = b2[1].x*a2.y+a2.x*b2[1].y;
			var _rDBN3:Number = b2[2].x*a2.y+a2.x*b2[2].y;
			var _rDBN4:Number = b2[3].x*a2.y+a2.x*b2[3].y;
			tMax2 = Math.max(_rDBN1, _rDBN2, _rDBN4, _rDBN4);
			tMin2 = Math.min(_rDBN1, _rDBN2, _rDBN4, _rDBN4);
			
			var collision:Boolean = (tMin1 > tMax2 || tMax1 < tMin2)
			if (collision)
			{
				// TODO : overlap to calculate
				// Make it work
				frameCollisionArr.push(new ColInfo(a, b, 0, SIDE_UNDEFINED));
			}
		}
	
//////////////////////////////////////////////////////////////////////////////////////////////////
		
		public function collisionOBBOnCircle(a:Entity, b:Entity) : void
		{
			var mcA:MovieClip = a.getBBMovieClip();
			var mcB:MovieClip = b.getBBMovieClip();
			var radB:Number = b.radius;
			var gPtB:Point = new Point(mcB.x, mcB.y); 
			gPtB = mcB.parent.localToGlobal(gPtB);
			
			var widthBackup:Number = mcA.width;
			var heightBackup:Number = mcA.height;
			
			mcA.width += radB;
			mcA.height += radB;
			
			var collide:Boolean = mcA.hitTestPoint(gPtB.x, gPtB.y);
			
			mcA.width = widthBackup;
			mcA.height = heightBackup;
			
			if(collide){
				frameCollisionArr.push(new ColInfo(a, b, 0, SIDE_UNDEFINED));
			}
		}
		
		public function collisionOBBOnPoint(a:Entity, b:Entity) : void
		{
			var mcA:MovieClip = a.getBBMovieClip();
			var mcB:MovieClip = b.getBBMovieClip();
			var radB:Number = b.radius;
			var gPtB:Point = new Point(mcB.x, mcB.y); 
			gPtB = mcB.parent.localToGlobal(gPtB);
			
			var collide:Boolean = mcA.hitTestPoint(gPtB.x, gPtB.y);
			
			if(collide){
				frameCollisionArr.push(new ColInfo(a, b, 0, SIDE_UNDEFINED));
			}
		}
		
		public function collisionCircleOnCircle(a:Entity, b:Entity) : void
		{
			var mcA:MovieClip = a.getBBMovieClip();
			var mcB:MovieClip = b.getBBMovieClip();
			var radA:Number = b.radius;
			var radB:Number = b.radius;
			var gPtA:Point = new Point(mcA.x, mcA.y); 
			gPtA = mcB.parent.localToGlobal(gPtA);	
			var gPtB:Point = new Point(mcB.x, mcB.y); 
			gPtB = mcB.parent.localToGlobal(gPtB);
			
			gPtA.length;
			gPtB.length
			
			var overlap:Number = radA + radB - Math.abs(gPtA.length - gPtB.length);
			var collide:Boolean = (overlap > 0);
			
			if(collide){
				frameCollisionArr.push(new ColInfo(a, b, overlap, SIDE_UNDEFINED));
			}
		}
		
		public function collisionCircleOnPoint(a:Entity, b:Entity) : void
		{
			// Not implemented in this project
		}
		
		
	}

}

import org.ggj.cupidator.Entity;
import org.ggj.cupidator.CollisionManager;

internal class ColInfo
{
	public var a:Entity;
	public var b:Entity;
	public var overlap:Number;
	public var side:uint;
	
	public function ColInfo(pA:Entity, pB:Entity, pOverlap:Number, pSide:uint = CollisionManager.SIDE_UNDEFINED) : void
	{
		a = pA;
		b = pB;
		overlap = pOverlap;
		side = pSide;
	}
}