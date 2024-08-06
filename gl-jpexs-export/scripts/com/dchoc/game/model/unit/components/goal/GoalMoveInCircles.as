package com.dchoc.game.model.unit.components.goal
{
   import com.dchoc.game.controller.hangar.Bunker;
   import com.dchoc.game.controller.hangar.BunkerController;
   import com.dchoc.game.controller.hangar.Hangar;
   import com.dchoc.game.controller.map.MapControllerPlanet;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.map.TileData;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.UnitScene;
   import com.dchoc.game.model.unit.components.movement.UnitComponentMovement;
   import com.dchoc.game.model.unit.components.view.UnitComponentView;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.view.dc.map.MapViewPlanet;
   import com.dchoc.game.view.dc.mng.ViewMngPlanet;
   import com.dchoc.toolkit.utils.math.DCMath;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import flash.geom.Vector3D;
   
   public class GoalMoveInCircles extends GoalTerrainUnit
   {
      
      private static const DEBUG_PATH:Boolean = Config.DEBUG_MODE && false;
      
      private static var EPSILON:Number = 0.001;
      
      private static var smVector:Vector3D;
      
      private static var smVector1:Vector3D;
      
      private static var smCoor:DCCoordinate;
      
      private static var smCoor1:DCCoordinate;
      
      private static var smMapController:MapControllerPlanet;
      
      private static var smBunkerController:BunkerController;
      
      private static var smViewMng:ViewMngPlanet;
      
      private static var smTilesData:Vector.<TileData>;
      
      private static var smIndicesVector:Vector.<int>;
      
      private static var smData:Array;
      
      private static var smHangar:Hangar;
      
      private static var smMovComp:UnitComponentMovement;
      
      private static var smIsDefending:Boolean;
      
      private static var smUnitPos:Vector3D;
      
      private static var smUnitHeading:Vector3D;
      
      private static var smUnitOldPosX:Number;
      
      private static var smUnitOldPosY:Number;
      
      private static var smToOldPosX:Number;
      
      private static var smToOldPosY:Number;
      
      private static var smPosFutureX:Number;
      
      private static var smPosFutureY:Number;
      
      private static const MOVE_TILE_WIDTH:int = 22;
      
      private static const MOVE_DISTANCE_TO_DECELERATE:int = 88;
      
      private static const MOVE_MIN_SPEED_COEF:Number = 0.6666666666666666;
      
      private static const MOVE_STATE_WILL_NOT_COLLIDE:int = 0;
      
      private static const MOVE_STATE_CHECK_COLLISIONS:int = 1;
      
      private static const MOVE_STATE_WILL_COLLIDE:int = 2;
      
      private static const MOVE_STATE_COLLIDING:int = 3;
      
      private static const MOVE_STATE_EVADING_COLLISION:int = 4;
      
      private static const MOVE_COLLISION_TILE_UP:int = 0;
      
      private static const MOVE_COLLISION_TILE_DOWN:int = 1;
      
      private static const MOVE_COLLISION_TILE_LEFT:int = 2;
      
      private static const MOVE_COLLISION_TILE_RIGHT:int = 3;
      
      public static const TURN_RADIUS_OFF:Number = 11;
      
      private static const STATE_NONE:int = -1;
      
      private static const STATE_GOING_TO_HANGAR:int = 0;
      
      private static const STATE_MOVING_AROUND_HANGAR:int = 1;
      
      private static const STATE_GOING_TO_BUNKER:int = 2;
      
      private static const STATE_ENTERING_IN_BUNKER:int = 3;
      
      private static const STATE_EXITING_FROM_BUNKER:int = 4;
      
      private static const STATE_DEFENDING_BUNKER:int = 5;
      
      private static const STATE_RETURNING_TO_BUNKER:int = 6;
      
      private static const STATE_ATTACKING_CITY:int = 7;
      
      private static const COLLISION_OBSTACLE_TYPE_NONE:int = -1;
      
      private static const COLLISION_OBSTACLE_TYPE_UNIT:int = 0;
      
      private static const COLLISION_OBSTACLE_TYPE_WIO:int = 1;
      
      private static const COLLISION_OBSTACLE_TYPE_WALL_CORNER:int = 2;
       
      
      private var mCheckHangarHasStartedBeingMoved:Boolean = false;
      
      private var mCheckHangarIsBeingMovedTimer:int;
      
      public var mMoveSpeed:Number = 0;
      
      public var mMoveAccelSign:Number = 1;
      
      private var mMoveState:int;
      
      private var mMoveCollisionsCheckLastPosX:Number;
      
      private var mMoveCollisionsCheckLastPosY:Number;
      
      private var mMoveCollisionsPosX:int;
      
      private var mMoveCollisionsPosY:int;
      
      private var mMoveCollisionsCalculateHeading:Boolean;
      
      private var mMoveCollisionsTileIndex:int;
      
      private var mMoveCollisionsEvasionStep:int;
      
      private var mMoveCollisionsEvasionVector:Vector3D;
      
      private var mMoveCollisionsEvasionTileIndex:int;
      
      private var mMoveCollisionsEvasionWhere:Boolean;
      
      private var mTurnInitialAngle:Number = -1;
      
      private var mTurnTargetUnit:MyUnit;
      
      private var mTurnTargetWIO:WorldItemObject;
      
      private var mTurnCenterX:Number;
      
      private var mTurnCenterY:Number;
      
      private var mTurnRadius:Number = -1;
      
      private var mTurnDisplacement:Number;
      
      private var mTurnDirection:int = 1;
      
      private var mTurnUnitAlreadyInHangar:Boolean = false;
      
      private var mTargetPreferredUnit:MyUnit;
      
      private var mTargetNextUnit:MyUnit;
      
      private var mTargetLastUnit:MyUnit;
      
      private var mTargetLastWIO:WorldItemObject;
      
      private var mState:int = -1;
      
      private var mCollisionsCheckIsEnabled:Boolean = true;
      
      private var mTurnCenterXBack:Number;
      
      private var mTurnCenterYBack:Number;
      
      private var mCollisionsAvoidObstacle:int = 0;
      
      private var mShootCheckIsEnabled:Boolean = false;
      
      private var mGoToWIOTo:WorldItemObject = null;
      
      private var mGoToAngleToEnter:Number;
      
      public function GoalMoveInCircles(unit:MyUnit, itemFrom:WorldItemObject = null, itemTo:WorldItemObject = null)
      {
         super(unit);
         if(smViewMng == null)
         {
            smViewMng = InstanceMng.getViewMngPlanet();
            smMapController = InstanceMng.getMapControllerPlanet();
            smBunkerController = InstanceMng.getBunkerController();
            smTilesData = InstanceMng.getMapModel().mTilesData;
            smIndicesVector = new Vector.<int>(0);
            smCoor = MyUnit.smCoor;
            smCoor1 = new DCCoordinate();
            smVector = new Vector3D();
            smVector1 = new Vector3D();
         }
         this.goToItem(itemTo,itemFrom,false);
      }
      
      public static function unloadStatic() : void
      {
         smVector = null;
         smVector1 = null;
         smCoor = null;
         smCoor1 = null;
         smMapController = null;
         smBunkerController = null;
         smViewMng = null;
         smTilesData = null;
         smIndicesVector = null;
         smData = null;
         smHangar = null;
         smMovComp = null;
         smIsDefending = false;
         smUnitPos = null;
         smUnitHeading = null;
         smUnitOldPosX = 0;
         smUnitOldPosY = 0;
         smToOldPosX = 0;
         smToOldPosY = 0;
         smPosFutureX = 0;
         smPosFutureY = 0;
      }
      
      override public function activate() : void
      {
         super.activate();
         this.movePause();
         super.moveResume();
      }
      
      private function calculateData() : void
      {
         smUnitPos = mUnit.mPosition;
         smMovComp = mUnit.getMovementComponent();
         smUnitHeading = smMovComp.getHeading();
      }
      
      override protected function logicUpdateDoDo(dt:int, u:MyUnit) : void
      {
         var wio:WorldItemObject = null;
         var wioUnit:MyUnit = null;
         var state:int = 0;
         var viewComp:UnitComponentView = null;
         this.calculateData();
         smUnitOldPosX = smMovComp.mOldPosition.x;
         smUnitOldPosY = smMovComp.mOldPosition.y;
         smVector.x = smUnitOldPosX - smUnitPos.x;
         smVector.y = smUnitOldPosY - smUnitPos.y;
         smVector.z = 0;
         smVector.normalize();
         smToOldPosX = smVector.x;
         smToOldPosY = smVector.y;
         smData = u.mData;
         smHangar = smData[34];
         smIsDefending = this.stateIsDefending();
         if(this.mState == -1)
         {
            state = this.stateCalculateState();
            this.stateChangeState(state);
         }
         var targetUnit:MyUnit = smData[3];
         if(smHangar != null)
         {
            if((wio = smHangar.getWIO()) != null)
            {
               wioUnit = wio.mUnit;
            }
         }
         if(targetUnit == null && this.mState == 5)
         {
            if(smHangar != null)
            {
               if(wioUnit == null || !wioUnit.getIsAlive())
               {
                  this.stateChangeState(6);
               }
            }
         }
         if(this.mGoToWIOTo == null)
         {
            if(targetUnit == this.mTurnTargetUnit && this.mTurnInitialAngle > -1)
            {
               this.targetSetPreferredUnit(null);
            }
            else
            {
               this.targetSetPreferredUnit(targetUnit);
            }
         }
         if(smMovComp.isOnFloor() && mUnit.getIsAlive())
         {
            if(smMovComp.getIsEnabled())
            {
               smMovComp.setIsEnabled(false);
            }
            this.moveLogicUpdate(dt);
            separateUnitsFromEachOther(true);
            if(this.mShootCheckIsEnabled)
            {
               this.shootCheck();
            }
            if((viewComp = mUnit.getViewComponent()).getCurrentAnimId() == "shooting" && !viewComp.isPlayingAnimId("shooting"))
            {
               viewComp.setAnimationId("running",-1,true,true,true,false);
            }
            if(DEBUG_PATH)
            {
               this.debugDrawTurn();
            }
            if(smHangar != null)
            {
               if(this.mState == 2 || this.mState == 0 || this.mState == 1)
               {
                  smHangar.unitsOnItsWayCheckIsNeededToGet(mUnit);
                  if(this.mTargetPreferredUnit == null || !this.mTargetPreferredUnit.getIsAlive())
                  {
                     mUnit.exitSceneStart(1);
                  }
                  else if(wio != null)
                  {
                     if(wio.isBeingMoved())
                     {
                        this.mCheckHangarIsBeingMovedTimer -= dt;
                        if(this.mCheckHangarIsBeingMovedTimer < 0)
                        {
                           this.followHangar();
                        }
                     }
                     if(this.mCheckHangarHasStartedBeingMoved)
                     {
                        if(!wio.isBeingMoved())
                        {
                           this.followHangar();
                           this.mCheckHangarHasStartedBeingMoved = false;
                        }
                     }
                     else if(wio.isBeingMoved())
                     {
                        this.followHangar();
                        this.mCheckHangarHasStartedBeingMoved = true;
                     }
                  }
               }
            }
         }
      }
      
      private function followHangar() : void
      {
         var wio:WorldItemObject = null;
         var wioUnit:MyUnit = null;
         if(smHangar != null)
         {
            wio = smHangar.getWIO();
            if(wio != null)
            {
               wioUnit = wio.mUnit;
            }
         }
         if(wioUnit != null)
         {
            if(this.mState == 1)
            {
               this.stateChangeState(0);
            }
            this.moveChangeState(1);
            this.targetSetUnitAsCurrentTarget(wioUnit);
            this.mCheckHangarIsBeingMovedTimer = 1000;
         }
      }
      
      override protected function moveResume() : void
      {
         this.moveChangeState(1);
         super.moveResume();
      }
      
      private function moveChangeState(state:int) : void
      {
         var distance:Number = NaN;
         this.mMoveState = state;
         switch(state - 1)
         {
            case 0:
               if(this.stateNeedsToCheckCollisions(this.mState))
               {
                  if(this.mTurnRadius == -1)
                  {
                     this.targetSetNextTarget(true);
                     mUnit.setLookingForATargetEnabled(true);
                  }
                  this.mMoveCollisionsCalculateHeading = true;
                  this.mMoveCollisionsCheckLastPosX = smUnitPos.x;
                  this.mMoveCollisionsCheckLastPosY = smUnitPos.y;
                  break;
               }
               this.moveChangeState(0);
               break;
            case 1:
               smVector.x = smUnitPos.x - this.mMoveCollisionsCheckLastPosX;
               smVector.y = smUnitPos.y - this.mMoveCollisionsCheckLastPosY;
               distance = Math.min(smVector.length,2 * 22);
               smVector.normalize();
               this.mMoveCollisionsCheckLastPosX += distance * smVector.x;
               this.mMoveCollisionsCheckLastPosY += distance * smVector.y;
         }
      }
      
      private function moveStateCollisionsFreeLogicUpdate(dt:Number) : void
      {
         var goesToInsideBunker:Boolean = false;
         if(this.mTurnRadius == -1)
         {
            this.targetSetNextTarget(true);
         }
         if(this.mTurnInitialAngle > -1)
         {
            this.turnLogicUpdate(dt);
            if(DEBUG_PATH)
            {
               this.debugDrawHeading(22);
            }
         }
         else
         {
            goesToInsideBunker = this.mState == 3 || this.mState == 4;
            if(this.moveApproachDestination(dt,!goesToInsideBunker))
            {
               if(goesToInsideBunker)
               {
                  if(this.mState == 3)
                  {
                     smBunkerController.unitGettingBunker(mUnit,smHangar);
                     mUnit.sendEvent("unitEventHasArrived",false);
                  }
                  else
                  {
                     this.targetSetWIOAsCurrentTarget(smHangar.getWIO());
                     this.stateChangeState(5);
                  }
               }
               else
               {
                  this.turnStartAroundTarget();
               }
            }
         }
      }
      
      private function moveApproachDestination(dt:int, checksStartTurn:Boolean) : Object
      {
         var startedTurn:Boolean = false;
         var off:Number = NaN;
         var distance:Number = NaN;
         var returnValue:Boolean = false;
         if(this.mTurnRadius > -1)
         {
            startedTurn = false;
            if(checksStartTurn)
            {
               off = this.mTurnCenterX - mUnit.mPosition.x;
               smVector.x = -off;
               distance = off * off;
               off = this.mTurnCenterY - mUnit.mPosition.y;
               smVector.y = -off;
               smVector.z = 0;
               smVector.normalize();
               if((int(distance += off * off)) <= int(this.mTurnRadius * this.mTurnRadius))
               {
                  startedTurn = true;
                  this.turnStartAroundTarget();
               }
            }
            if(!startedTurn)
            {
               this.moveGetExactPosition(smCoor);
               returnValue = smMovComp.moveToExactPosition(smCoor.x,smCoor.y,dt,this.mMoveSpeed);
            }
         }
         return returnValue;
      }
      
      private function moveCheckEvadeCollision(tileIndex:int) : Boolean
      {
         var holeIndex:int = 0;
         var holeIndex1:int = 0;
         var holeIndex2:int = 0;
         var off:int = 0;
         var neighborIndex:int = 0;
         var m:Number = NaN;
         var xSegLeft:* = NaN;
         var xSegRight:* = NaN;
         var ySegUp:* = NaN;
         var ySegDown:* = NaN;
         var minDistance:* = NaN;
         var diffX:Number = NaN;
         var diffY:Number = NaN;
         var distance:Number = NaN;
         var yp:int = 0;
         var xp:int = 0;
         smCoor = smMapController.getIndexToTileXY(tileIndex,smCoor);
         var tileX:int = smCoor.x;
         var tileY:int = smCoor.y;
         smCoor = smViewMng.tileIndexToWorldPos(tileIndex,smCoor,true);
         var xLeft:Number = smCoor.x - 11;
         var xRight:Number = smCoor.x + 11;
         var yUp:Number = smCoor.y - 11;
         var yDown:Number = smCoor.y + 11;
         var intersectsWithSide:int = -1;
         var posX:Number = mUnit.mPosition.x;
         var posY:Number = mUnit.mPosition.y;
         if(Math.abs(smUnitHeading.x) < EPSILON)
         {
            if(smPosFutureX >= xLeft && smPosFutureX <= xRight)
            {
               if(posY > smPosFutureY)
               {
                  intersectsWithSide = 2;
               }
               else
               {
                  intersectsWithSide = 3;
               }
            }
         }
         else if(Math.abs(smUnitHeading.y) < EPSILON)
         {
            if(smPosFutureY >= yUp && smPosFutureY <= yDown)
            {
               if(posX < xLeft)
               {
                  intersectsWithSide = 2;
               }
               else
               {
                  intersectsWithSide = 3;
               }
            }
         }
         else
         {
            m = smUnitHeading.x / smUnitHeading.y;
            xSegLeft = xLeft;
            xSegRight = xRight;
            ySegUp = yUp;
            ySegDown = yDown;
            minDistance = 1.7976931348623157e+308;
            if(smPosFutureY > posY)
            {
               yp = yUp;
               if((xp = m * (yp - smPosFutureY) + smPosFutureX) >= xSegLeft && xp <= xSegRight)
               {
                  if((neighborIndex = smMapController.getTileXYToIndex(tileX,tileY - 1)) == -1 || smMapController.mMapModel.logicTilesCanBeStepped(neighborIndex))
                  {
                     diffX = xp - posX;
                     diffY = yp - posY;
                     distance = diffX * diffX + diffY + diffY;
                     if(distance < minDistance)
                     {
                        minDistance = distance;
                        intersectsWithSide = 0;
                     }
                  }
                  else
                  {
                     intersectsWithSide = smPosFutureX > posX ? 2 : 3;
                  }
               }
            }
            else if(smPosFutureY < posY)
            {
               yp = yDown;
               if((xp = m * (yp - smPosFutureY) + smPosFutureX) >= xSegLeft && xp <= xSegRight)
               {
                  if((neighborIndex = smMapController.getTileXYToIndex(tileX,tileY + 1)) == -1 || smMapController.mMapModel.logicTilesCanBeStepped(neighborIndex))
                  {
                     diffX = xp - posX;
                     diffY = yp - posY;
                     distance = diffX * diffX + diffY + diffY;
                     if(distance < minDistance)
                     {
                        minDistance = distance;
                        intersectsWithSide = 1;
                     }
                  }
                  else
                  {
                     intersectsWithSide = smPosFutureX > posX ? 2 : 3;
                  }
               }
            }
            if(intersectsWithSide == -1)
            {
               m = smUnitHeading.y / smUnitHeading.x;
               if(smPosFutureX > posX)
               {
                  xp = xLeft;
                  if((yp = m * (xp - smPosFutureX) + smPosFutureY) >= ySegUp && yp <= ySegDown)
                  {
                     if((neighborIndex = smMapController.getTileXYToIndex(tileX - 1,tileY)) == -1 || smMapController.mMapModel.logicTilesCanBeStepped(neighborIndex))
                     {
                        diffX = xp - posX;
                        diffY = yp - posY;
                        distance = diffX * diffX + diffY + diffY;
                        if(distance < minDistance)
                        {
                           minDistance = distance;
                           intersectsWithSide = 2;
                        }
                     }
                     else
                     {
                        intersectsWithSide = smPosFutureY > posY ? 0 : 1;
                     }
                  }
               }
               else if(smPosFutureX < posX)
               {
                  xp = xRight;
                  if((yp = m * (xp - smPosFutureX) + smPosFutureY) >= ySegUp && yp <= ySegDown)
                  {
                     if((neighborIndex = smMapController.getTileXYToIndex(tileX + 1,tileY)) == -1 || smMapController.mMapModel.logicTilesCanBeStepped(neighborIndex))
                     {
                        diffX = xp - posX;
                        diffY = yp - posY;
                        distance = diffX * diffX + diffY + diffY;
                        if(distance < minDistance)
                        {
                           minDistance = distance;
                           intersectsWithSide = 3;
                        }
                     }
                     else
                     {
                        intersectsWithSide = smPosFutureY > posY ? 0 : 1;
                     }
                  }
               }
            }
         }
         this.mMoveCollisionsEvasionTileIndex = -1;
         switch(intersectsWithSide)
         {
            case 0:
               if((neighborIndex = smMapController.getTileXYToIndex(tileX,tileY - 1)) == -1 || smMapController.mMapModel.logicTilesCanBeStepped(neighborIndex))
               {
                  if(neighborIndex == -1)
                  {
                     holeIndex1 = this.collisionsGetHoleIndexHorizontal(tileX,tileY,1,0,false);
                     holeIndex2 = this.collisionsGetHoleIndexHorizontal(tileX,tileY,-1,0,false);
                     holeIndex = this.collisionsSelectHoleIndex(holeIndex1,holeIndex2);
                  }
                  else
                  {
                     holeIndex1 = smMapController.getTileXYToIndex(tileX - 1,tileY - 1);
                     if(!this.collisionsIsHoleValid(holeIndex1))
                     {
                        holeIndex1 = -1;
                     }
                     holeIndex2 = smMapController.getTileXYToIndex(tileX + 1,tileY - 1);
                     if(!this.collisionsIsHoleValid(holeIndex2))
                     {
                        holeIndex2 = -1;
                     }
                     off = (holeIndex = this.collisionsSelectHoleIndex(holeIndex1,holeIndex2)) == holeIndex1 ? -1 : 1;
                     if((holeIndex = this.collisionsGetHoleIndexHorizontal(tileX,tileY,off,-1)) == -1 && (holeIndex1 != -1 && holeIndex2 != -1))
                     {
                        holeIndex = this.collisionsGetHoleIndexHorizontal(tileX,tileY,-off,-1);
                     }
                  }
                  if(holeIndex > -1)
                  {
                     this.mMoveCollisionsEvasionTileIndex = holeIndex;
                     this.mMoveCollisionsEvasionWhere = true;
                  }
               }
               break;
            case 1:
               if((neighborIndex = smMapController.getTileXYToIndex(tileX,tileY + 1)) == -1 || smMapController.mMapModel.logicTilesCanBeStepped(neighborIndex))
               {
                  if(neighborIndex == -1)
                  {
                     holeIndex1 = this.collisionsGetHoleIndexHorizontal(tileX,tileY,1,0,false);
                     holeIndex2 = this.collisionsGetHoleIndexHorizontal(tileX,tileY,-1,0,false);
                     holeIndex = this.collisionsSelectHoleIndex(holeIndex1,holeIndex2);
                  }
                  else
                  {
                     holeIndex1 = smMapController.getTileXYToIndex(tileX - 1,tileY + 1);
                     if(!this.collisionsIsHoleValid(holeIndex1))
                     {
                        holeIndex1 = -1;
                     }
                     holeIndex2 = smMapController.getTileXYToIndex(tileX + 1,tileY + 1);
                     if(!this.collisionsIsHoleValid(holeIndex2))
                     {
                        holeIndex2 = -1;
                     }
                     off = (holeIndex = this.collisionsSelectHoleIndex(holeIndex1,holeIndex2)) == holeIndex1 ? -1 : 1;
                     if((holeIndex = this.collisionsGetHoleIndexHorizontal(tileX,tileY,off,1)) == -1 && (holeIndex1 != -1 && holeIndex2 != -1))
                     {
                        holeIndex = this.collisionsGetHoleIndexHorizontal(tileX,tileY,-off,1);
                     }
                  }
                  if(holeIndex > -1)
                  {
                     this.mMoveCollisionsEvasionTileIndex = holeIndex;
                     this.mMoveCollisionsEvasionWhere = true;
                  }
               }
               break;
            case 2:
               if((neighborIndex = smMapController.getTileXYToIndex(tileX - 1,tileY)) == -1 || smMapController.mMapModel.logicTilesCanBeStepped(neighborIndex))
               {
                  if(neighborIndex == -1)
                  {
                     holeIndex1 = this.collisionsGetHoleIndexVertical(tileX,tileY,0,1,false);
                     holeIndex2 = this.collisionsGetHoleIndexVertical(tileX,tileY,0,-1,false);
                     holeIndex = this.collisionsSelectHoleIndex(holeIndex1,holeIndex2);
                  }
                  else
                  {
                     holeIndex1 = smMapController.getTileXYToIndex(tileX - 1,tileY - 1);
                     if(!this.collisionsIsHoleValid(holeIndex1))
                     {
                        holeIndex1 = -1;
                     }
                     holeIndex2 = smMapController.getTileXYToIndex(tileX - 1,tileY + 1);
                     if(!this.collisionsIsHoleValid(holeIndex2))
                     {
                        holeIndex2 = -1;
                     }
                     off = (holeIndex = this.collisionsSelectHoleIndex(holeIndex1,holeIndex2)) == holeIndex1 ? -1 : 1;
                     if((holeIndex = this.collisionsGetHoleIndexVertical(tileX,tileY,-1,off)) == -1 && (holeIndex1 != -1 && holeIndex2 != -1))
                     {
                        holeIndex = this.collisionsGetHoleIndexVertical(tileX,tileY,-1,-off);
                     }
                  }
                  if(holeIndex > -1)
                  {
                     this.mMoveCollisionsEvasionTileIndex = holeIndex;
                     this.mMoveCollisionsEvasionWhere = false;
                  }
               }
               break;
            case 3:
               if((neighborIndex = smMapController.getTileXYToIndex(tileX + 1,tileY)) == -1 || smMapController.mMapModel.logicTilesCanBeStepped(neighborIndex))
               {
                  if(neighborIndex == -1)
                  {
                     holeIndex1 = this.collisionsGetHoleIndexVertical(tileX,tileY,0,1,false);
                     holeIndex2 = this.collisionsGetHoleIndexVertical(tileX,tileY,0,-1,false);
                     holeIndex = this.collisionsSelectHoleIndex(holeIndex1,holeIndex2);
                  }
                  else
                  {
                     holeIndex1 = smMapController.getTileXYToIndex(tileX + 1,tileY - 1);
                     if(!this.collisionsIsHoleValid(holeIndex1))
                     {
                        holeIndex1 = -1;
                     }
                     holeIndex2 = smMapController.getTileXYToIndex(tileX + 1,tileY + 1);
                     if(!this.collisionsIsHoleValid(holeIndex2))
                     {
                        holeIndex2 = -1;
                     }
                     off = (holeIndex = this.collisionsSelectHoleIndex(holeIndex1,holeIndex2)) == holeIndex1 ? -1 : 1;
                     if((holeIndex = this.collisionsGetHoleIndexVertical(tileX,tileY,1,off)) == -1 && (holeIndex1 != -1 && holeIndex2 != -1))
                     {
                        holeIndex = this.collisionsGetHoleIndexVertical(tileX,tileY,1,-off);
                     }
                  }
                  if(holeIndex > -1)
                  {
                     this.mMoveCollisionsEvasionTileIndex = holeIndex;
                     this.mMoveCollisionsEvasionWhere = false;
                  }
               }
         }
         return this.mMoveCollisionsEvasionTileIndex > -1;
      }
      
      private function moveSetupEvasion(tileIndex:int) : Boolean
      {
         var posX:int = 0;
         var posY:int = 0;
         var heading:Vector3D = null;
         var returnValue:Boolean;
         if(returnValue = true)
         {
            posX = this.mMoveCollisionsCheckLastPosX;
            posY = this.mMoveCollisionsCheckLastPosY;
            smCoor = smViewMng.tileIndexToWorldPos(this.mMoveCollisionsEvasionTileIndex,smCoor,true);
            if(this.mMoveCollisionsEvasionVector == null)
            {
               this.mMoveCollisionsEvasionVector = new Vector3D();
            }
            if(this.mMoveCollisionsEvasionWhere)
            {
               this.mMoveCollisionsEvasionVector.x = 0;
               this.mMoveCollisionsEvasionVector.y = posY > smCoor.y ? -1 : 1;
               smCoor.y -= this.mMoveCollisionsEvasionVector.y * (22 + 1);
            }
            else
            {
               this.mMoveCollisionsEvasionVector.x = posX > smCoor.x ? -1 : 1;
               this.mMoveCollisionsEvasionVector.y = 0;
               smCoor.x -= this.mMoveCollisionsEvasionVector.x * (22 + 1);
            }
            smVector.x = smCoor.x - posX;
            smVector.y = smCoor.y - posY;
            smVector.z = 0;
            smVector.normalize();
            smVector1.x = smToOldPosX;
            smVector1.y = smToOldPosY;
            smVector1.z = 0;
            if(smVector.dotProduct(smVector1) >= 0.9)
            {
               returnValue = false;
            }
            else
            {
               this.mMoveCollisionsEvasionStep = 0;
               this.mMoveCollisionsPosX = smCoor.x;
               this.mMoveCollisionsPosY = smCoor.y;
               (heading = smMovComp.mVelocity).x = this.mMoveCollisionsPosX - smUnitPos.x;
               heading.y = this.mMoveCollisionsPosY - smUnitPos.y;
               heading.z = 0;
               heading.normalize();
            }
         }
         return returnValue;
      }
      
      private function moveSetCollisionPos(x:int, y:int) : void
      {
         this.mMoveCollisionsPosX = x;
         this.mMoveCollisionsPosY = y;
      }
      
      private function moveLogicUpdate(dt:Number) : void
      {
         var maxSpeed:Number = NaN;
         var mov:UnitComponentMovement = null;
         var minSpeed:Number = NaN;
         var destPosX:int = 0;
         var destPosY:int = 0;
         var newState:int = 0;
         var i:int = 0;
         var tileIndex:int = 0;
         var distance:Number = NaN;
         var lastDistance:* = NaN;
         var diff:int = 0;
         var obstacleType:int = 0;
         var unit:MyUnit = null;
         var tileData:TileData = null;
         var item:WorldItemObject = null;
         if(!smMovComp.isStopped())
         {
            this.mMoveSpeed += dt * 0.1 * this.mMoveAccelSign;
            maxSpeed = mUnit.mDef.getMaxSpeed();
            if((mov = mUnit.getMovementComponent()) != null)
            {
               maxSpeed = mov.getMaxSpeed();
            }
            minSpeed = maxSpeed * 0.6666666666666666;
            if(this.mMoveSpeed < minSpeed)
            {
               this.mMoveSpeed = minSpeed;
            }
            else if(this.mMoveSpeed > maxSpeed)
            {
               this.mMoveSpeed = maxSpeed;
            }
         }
         var o:Object = null;
         switch(this.mMoveState)
         {
            case 0:
               this.moveStateCollisionsFreeLogicUpdate(dt);
               break;
            case 1:
               if(this.mMoveCollisionsCalculateHeading)
               {
                  this.moveGetExactPosition(smCoor);
                  smUnitHeading.x = smCoor.x - smUnitPos.x;
                  smUnitHeading.y = smCoor.y - smUnitPos.y;
                  smUnitHeading.z = 0;
                  smUnitHeading.normalize();
                  this.moveGetExactPosition(smCoor);
                  smUnitHeading.x = smCoor.x - smUnitPos.x;
                  smUnitHeading.y = smCoor.y - smUnitPos.y;
                  smUnitHeading.z = 0;
                  smUnitHeading.normalize();
                  this.mMoveCollisionsCalculateHeading = false;
               }
               else
               {
                  this.moveGetExactPosition(smCoor);
               }
               destPosX = smCoor.x;
               destPosY = smCoor.y;
               newState = -1;
               lastDistance = 1.7976931348623157e+308;
               while(i < 10 && newState == -1)
               {
                  tileIndex = this.collisionGetMapTileIndexFromPos(this.mMoveCollisionsCheckLastPosX,this.mMoveCollisionsCheckLastPosY,11);
                  diff = destPosX - this.mMoveCollisionsCheckLastPosX;
                  distance = diff * diff;
                  diff = destPosY - this.mMoveCollisionsCheckLastPosY;
                  distance += diff * diff;
                  if(distance > lastDistance)
                  {
                     newState = 0;
                  }
                  else
                  {
                     lastDistance = distance;
                     if((o = this.collisionsGetObstacleInDistance(tileIndex,true)) != null)
                     {
                        newState = 2;
                     }
                     else
                     {
                        this.mMoveCollisionsCheckLastPosX = smPosFutureX;
                        this.mMoveCollisionsCheckLastPosY = smPosFutureY;
                     }
                  }
                  i++;
               }
               if(newState != -1)
               {
                  if(newState == 2)
                  {
                     if(o != null)
                     {
                        switch(obstacleType = this.collisionsGetObstacleType(o))
                        {
                           case 0:
                              unit = MyUnit(o);
                              if(this.turnCanAroundThisUnit(unit))
                              {
                                 this.targetSetUnitAsCurrentTarget(unit);
                                 newState = 1;
                              }
                              else if(this.moveTryToEvadeCollision(tileIndex,unit))
                              {
                                 newState = 4;
                              }
                              break;
                           case 1:
                              this.targetSetWIOAsCurrentTarget(WorldItemObject(o));
                              newState = 1;
                              break;
                           case 2:
                              if(UnitScene.smMapModel.wallCheckIfMakesACorner(tileIndex,smIndicesVector))
                              {
                                 if((tileData = UnitScene.smMapModel.getTileDataFromIndex(smIndicesVector[0])) != null)
                                 {
                                    item = tileData.mBaseItem;
                                    if(item != null)
                                    {
                                       unit = item.mUnit;
                                       if(this.moveTryToEvadeCollision(tileIndex,unit))
                                       {
                                          newState = 4;
                                       }
                                    }
                                 }
                                 break;
                              }
                        }
                     }
                     else
                     {
                        newState = 0;
                     }
                  }
                  this.moveChangeState(newState);
               }
               else
               {
                  this.moveApproachDestination(dt,true);
               }
               break;
            case 2:
               if((o = this.collisionsGetObstacleInDistance(this.mMoveCollisionsTileIndex)) == null)
               {
                  if(smMovComp.isStopped())
                  {
                     this.moveResume();
                  }
                  this.moveChangeState(1);
               }
               else if(smMovComp.moveToExactPosition(this.mMoveCollisionsCheckLastPosX,this.mMoveCollisionsCheckLastPosY,dt,this.mMoveSpeed) && !smMovComp.isStopped())
               {
                  this.movePause();
               }
               break;
            case 4:
               if(smMovComp.moveToExactPosition(this.mMoveCollisionsPosX,this.mMoveCollisionsPosY,dt,this.mMoveSpeed))
               {
                  if(this.mMoveCollisionsEvasionStep == 0)
                  {
                     this.mMoveCollisionsPosX += 22 * this.mMoveCollisionsEvasionVector.x;
                     this.mMoveCollisionsPosY += 22 * this.mMoveCollisionsEvasionVector.y;
                     this.mMoveCollisionsEvasionStep++;
                     break;
                  }
                  this.moveChangeState(1);
                  break;
               }
         }
      }
      
      private function moveTryToEvadeCollision(tileIndex:int, u:MyUnit) : Boolean
      {
         var returnValue:Boolean = false;
         if(this.moveCheckEvadeCollision(tileIndex))
         {
            if(this.moveSetupEvasion(tileIndex))
            {
               returnValue = true;
            }
            else
            {
               this.moveSetCollisionPos(this.mMoveCollisionsCheckLastPosX,this.mMoveCollisionsCheckLastPosY);
               this.mMoveCollisionsTileIndex = tileIndex;
               smData[3] = u;
            }
         }
         else
         {
            this.moveSetCollisionPos(this.mMoveCollisionsCheckLastPosX,this.mMoveCollisionsCheckLastPosY);
            this.mMoveCollisionsTileIndex = tileIndex;
            smData[3] = u;
         }
         return returnValue;
      }
      
      override protected function movePause() : void
      {
         super.movePause();
         mMoveAnimIdPrevious = "running";
         this.mMoveSpeed = mUnit.mDef.getMaxSpeed() * 0.6666666666666666;
      }
      
      private function moveGetExactPosition(coor:DCCoordinate) : void
      {
         var target:MyUnit = null;
         var usesTheCenter:Boolean;
         if(!(usesTheCenter = this.mState == 3 || this.mState == 4 || this.mCollisionsAvoidObstacle != 0) && smIsDefending)
         {
            if((target = smData[13]) != null && target.mPosition.x == this.mTurnCenterX && target.mPosition.y == this.mTurnCenterY)
            {
               usesTheCenter = true;
            }
         }
         var destX:Number = this.mTurnCenterX;
         var destY:Number = this.mTurnCenterY;
         if(!usesTheCenter)
         {
            destX -= smUnitHeading.y * this.mTurnRadius * this.mTurnDirection;
            destY += smUnitHeading.x * this.mTurnRadius * this.mTurnDirection;
         }
         coor.x = destX;
         coor.y = destY;
      }
      
      private function turnSetCenterPos(x:Number, y:Number) : void
      {
         this.mTurnCenterX = x;
         this.mTurnCenterY = y;
      }
      
      private function turnSetTargetUnit(u:MyUnit) : void
      {
         this.mTurnTargetUnit = u;
         if(u == null || !u.getIsAlive())
         {
            this.mTurnTargetWIO = null;
         }
         else
         {
            this.mTurnTargetWIO = u.mData[35];
         }
      }
      
      private function turnSetTargetWIO(wio:WorldItemObject) : void
      {
         this.mTurnTargetWIO = wio;
         if(wio == null)
         {
            this.mTurnTargetUnit = null;
         }
         else
         {
            this.mTurnTargetUnit = wio.mUnit;
         }
      }
      
      private function turnCanAroundThisUnit(unit:MyUnit) : Boolean
      {
         var baseItem:WorldItemObject = null;
         var returnValue:Boolean = unit != null && unit.mIsAlive;
         if(returnValue)
         {
            if(unit.mDef.isABuilding())
            {
               baseItem = unit.mData[35];
               returnValue = baseItem != null && baseItem.mDef.getBaseCols() * baseItem.mDef.getBaseRows() >= 9;
            }
            else
            {
               returnValue = true;
            }
         }
         return returnValue;
      }
      
      private function turnLogicUpdate(dt:int) : void
      {
         var prevAngle:Number = NaN;
         var off:Number = NaN;
         var angle:Number = NaN;
         var radAngle:Number = NaN;
         var cos:Number = NaN;
         var sin:Number = NaN;
         var off1:Number = NaN;
         var off2:Number = NaN;
         if(!smMovComp.isStopped())
         {
            dt /= 10;
            if((prevAngle = (prevAngle = this.mTurnInitialAngle + DCMath.rad2Degree(this.mTurnDisplacement / this.mTurnRadius)) % 360) < 0)
            {
               prevAngle += 360;
            }
            prevAngle = DCMath.degree2Rad(prevAngle);
            this.mTurnDisplacement += dt * this.mMoveSpeed * this.mTurnDirection;
            off = this.mTurnDisplacement / this.mTurnRadius;
            if((angle = (angle = this.mTurnInitialAngle + DCMath.rad2Degree(off)) % 360) < 0)
            {
               angle += 360;
            }
            radAngle = DCMath.degree2Rad(angle);
            cos = Math.cos(radAngle);
            sin = Math.sin(radAngle);
            mUnit.setPosition(this.mTurnCenterX + cos * this.mTurnRadius,this.mTurnCenterY - sin * this.mTurnRadius);
            if(this.mTurnDirection == -1)
            {
               smMovComp.setVelocity(sin,cos,0);
            }
            else
            {
               smMovComp.setVelocity(-sin,-cos,0);
            }
            if(this.mTurnTargetWIO == this.mGoToWIOTo && (this.mState == 2 || this.mState == 6))
            {
               off1 = prevAngle - this.mGoToAngleToEnter;
               if((off2 = radAngle - this.mGoToAngleToEnter) == 0 || off1 < 0 && off2 > 0 || off1 > 0 && off2 < 0)
               {
                  this.stateChangeState(3);
               }
            }
            else
            {
               if(this.mTargetNextUnit == this.mTurnTargetUnit)
               {
                  this.mTargetNextUnit = null;
               }
               else if(this.mTargetNextUnit != null)
               {
                  if(this.mTargetNextUnit.mIsAlive)
                  {
                     smVector.x = this.mTargetNextUnit.mPosition.x - mUnit.mPosition.x;
                     smVector.y = this.mTargetNextUnit.mPosition.y - mUnit.mPosition.y;
                     smVector.z = 0;
                     smVector.normalize();
                     angle = Vector3D.angleBetween(smVector,smUnitHeading);
                     if((angle = DCMath.rad2Degree(angle)) > 0 && angle < 30)
                     {
                        this.turnExitAroundTarget();
                     }
                  }
                  else
                  {
                     this.mTargetNextUnit = null;
                  }
               }
               if(this.mTargetNextUnit == null)
               {
                  this.targetSetNextTarget(false);
               }
            }
         }
      }
      
      private function turnStartAroundTarget() : void
      {
         this.mTargetLastUnit = null;
         smVector.x = mUnit.mPosition.x - this.mTurnCenterX;
         smVector.y = mUnit.mPosition.y - this.mTurnCenterY;
         smVector.z = 0;
         smVector.normalize();
         var angle:Number = Math.acos(smVector.x);
         this.mTurnInitialAngle = DCMath.rad2Degree(angle);
         if(smVector.y > 0)
         {
            this.mTurnInitialAngle = 360 - this.mTurnInitialAngle;
         }
         if(this.mTurnInitialAngle < 0)
         {
            this.mTurnInitialAngle += 360;
         }
         if(this.mTurnUnitAlreadyInHangar)
         {
            this.mTurnUnitAlreadyInHangar = false;
            this.mTurnDisplacement = DCMath.randomNumber(0,36) * 22;
         }
         else
         {
            this.mTurnDisplacement = 0;
         }
         this.mMoveAccelSign = -1;
         if(this.mGoToWIOTo != null && this.mGoToWIOTo == this.mTurnTargetWIO)
         {
            if(this.mState == 0)
            {
               this.stateChangeState(1);
            }
         }
      }
      
      private function turnExitAroundTarget() : void
      {
         this.mTargetLastUnit = this.mTurnTargetUnit;
         this.mTargetLastWIO = this.mTurnTargetWIO;
         this.targetSetUnitAsCurrentTarget(this.mTargetNextUnit);
         this.mTargetNextUnit = null;
         this.mTurnInitialAngle = -1;
         this.mMoveAccelSign = 1;
         this.moveChangeState(1);
      }
      
      private function targetGetNextTargetUnit() : MyUnit
      {
         var buildings:Vector.<MyUnit> = null;
         var length:int = 0;
         var index:int = 0;
         var i:int = 0;
         var returnValue:MyUnit = this.mTargetPreferredUnit;
         if(smIsDefending)
         {
            if(smData[13] != null)
            {
               returnValue = smData[13];
            }
         }
         else if(returnValue == null)
         {
            buildings = MyUnit.smUnitScene.mSceneUnits[6];
            length = int(buildings.length);
            if(length > 0)
            {
               index = Math.round(Math.random() * (length - 1));
               i = 0;
               while(i < length && returnValue == null)
               {
                  returnValue = buildings[(index + i) % length];
                  if(!this.turnCanAroundThisUnit(returnValue))
                  {
                     returnValue = null;
                  }
                  i++;
               }
            }
         }
         return returnValue;
      }
      
      private function targetSetUnitAsCurrentTarget(u:MyUnit) : void
      {
         if(u != this.mTurnTargetUnit || this.mTurnRadius == -1 || u != null && (u.mPosition.x != this.mTurnCenterX || u.mPosition.y != this.mTurnCenterY))
         {
            if(u != null)
            {
               this.turnSetCenterPos(u.mPosition.x,u.mPosition.y);
               this.mTurnRadius = u.mDef.getBoundingRadius() + 11;
            }
            else
            {
               this.mTurnRadius = -1;
            }
            this.turnSetTargetUnit(u);
            this.mTurnInitialAngle = -1;
            this.turnCalculateDirection();
         }
      }
      
      private function targetSetWIOAsCurrentTarget(wio:WorldItemObject) : void
      {
         if(wio != null)
         {
            if(wio.mUnit != null)
            {
               this.targetSetUnitAsCurrentTarget(wio.mUnit);
            }
            else
            {
               smCoor.x = wio.mViewCenterWorldX;
               smCoor.y = wio.mViewCenterWorldY;
               smCoor = smViewMng.viewPosToLogicPos(smCoor);
               if(this.mTurnCenterX != smCoor.x || this.mTurnCenterY != smCoor.y)
               {
                  this.turnSetCenterPos(smCoor.x,smCoor.y);
                  smCoor.x = wio.mDef.getBaseCols();
                  smCoor.y = wio.mDef.getBaseRows();
                  smCoor.z = 0;
                  smCoor = smMapController.getTileXYToPos(smCoor);
                  this.mTurnRadius = Math.max(smCoor.x,smCoor.y);
                  this.turnSetTargetWIO(wio);
                  this.mTurnInitialAngle = -1;
                  this.turnCalculateDirection();
               }
            }
         }
      }
      
      private function targetSetPreferredUnit(value:MyUnit) : void
      {
         this.mTargetPreferredUnit = value;
      }
      
      private function turnCalculateDirection() : void
      {
         var offX:Number = NaN;
         var offY:Number = NaN;
         var angle1:Number = NaN;
         var angle2:Number = NaN;
         if(this.mTurnRadius > -1)
         {
            if(this.mState == 0 || this.mTurnUnitAlreadyInHangar)
            {
               this.mTurnDirection = -1;
            }
            else
            {
               offX = mUnit.mPosition.x - this.mTurnCenterX;
               offY = mUnit.mPosition.y - this.mTurnCenterY;
               if(offX * offX + offY * offY < this.mTurnRadius * this.mTurnRadius)
               {
                  this.mTurnDirection = 1;
               }
               else
               {
                  smVector.x = this.mTurnCenterX - mUnit.mPosition.x;
                  smVector.y = this.mTurnCenterY - mUnit.mPosition.y;
                  smVector.z = 0;
                  smVector.normalize();
                  offX = smVector.y * this.mTurnRadius;
                  offY = smVector.x * this.mTurnRadius;
                  smVector.x = this.mTurnCenterX - offX;
                  smVector.y = this.mTurnCenterY + offY;
                  smVector.z = 0;
                  angle1 = Vector3D.angleBetween(smMovComp.mVelocity,smVector);
                  smVector.x = this.mTurnCenterX + offX;
                  smVector.y = this.mTurnCenterY - offY;
                  angle2 = Vector3D.angleBetween(smMovComp.mVelocity,smVector);
                  if(Math.abs(angle1) > Math.abs(angle2))
                  {
                     this.mTurnDirection = 1;
                  }
                  else
                  {
                     this.mTurnDirection = -1;
                  }
               }
            }
         }
      }
      
      private function targetSetNextTarget(immediately:Boolean) : void
      {
         var targetUnit:MyUnit = this.targetGetNextTargetUnit();
         if(!(targetUnit == null && smIsDefending))
         {
            if(immediately)
            {
               this.targetSetUnitAsCurrentTarget(targetUnit);
               if(targetUnit != null)
               {
                  this.moveResume();
               }
            }
            else
            {
               this.mTargetNextUnit = targetUnit;
               if(this.mTurnTargetUnit == this.mTargetNextUnit && this.mTargetNextUnit != null)
               {
                  if(!this.mTargetNextUnit.mIsAlive || this.mTargetNextUnit.mPosition.x == this.mTurnCenterX && this.mTargetNextUnit.mPosition.y == this.mTurnCenterY)
                  {
                     this.mTargetNextUnit = null;
                  }
               }
            }
         }
      }
      
      private function stateCalculateState() : int
      {
         var bunker:Bunker = null;
         var goalId:String = mUnit.goalGetCurrentId();
         var state:int = -1;
         switch(goalId)
         {
            case "unitGoalOnHangar":
               state = 1;
               break;
            case "unitGoalGoToItem":
               if(this.mGoToWIOTo != null)
               {
                  state = this.mGoToWIOTo.mDef.isABunker() ? 2 : 0;
               }
               break;
            case "unitGoalSoldierAttacking":
               state = 7;
               break;
            case "unitGoalSoldierDefending":
               bunker = mUnit.mData[34];
               if(bunker != null)
               {
                  this.goToItem(bunker.getWIO(),null,false);
               }
               state = 4;
         }
         return state;
      }
      
      private function stateNeedsToCheckCollisions(state:int) : Boolean
      {
         return state != 1;
      }
      
      private function stateNeedsParticlesEnabled(state:int) : Boolean
      {
         return state != 1;
      }
      
      private function stateChangeState(newState:int) : void
      {
         var prevParticlesEnabled:Boolean = false;
         var statePrev:int = 0;
         var particlesEnabled:Boolean = false;
         var tileIndexToGo:int = 0;
         var unit:MyUnit = null;
         var radius:Number = NaN;
         var viewComp:UnitComponentView = null;
         if(this.mState != newState)
         {
            prevParticlesEnabled = this.stateNeedsParticlesEnabled(this.mState);
            statePrev = this.mState;
            this.mState = newState;
            switch(this.mState)
            {
               case 6:
                  this.returnToBunker();
               case 0:
               case 1:
               case 2:
                  if(this.mState == 1)
                  {
                     mUnit.goalSetCurrentId("unitGoalOnHangar");
                     if(statePrev == -1)
                     {
                        this.mTurnUnitAlreadyInHangar = true;
                     }
                  }
                  if(!this.stateNeedsToCheckCollisions(this.mState))
                  {
                     this.moveChangeState(0);
                  }
                  if(this.mGoToWIOTo != null)
                  {
                     this.targetSetPreferredUnit(this.mGoToWIOTo.mUnit);
                  }
                  break;
               case 3:
               case 4:
                  if(this.mGoToWIOTo != null)
                  {
                     this.moveResume();
                     tileIndexToGo = InstanceMng.getWorldItemDefMng().getTileIndexToGo(this.mGoToWIOTo);
                     if(tileIndexToGo > -1)
                     {
                        smViewMng.tileIndexToWorldPos(tileIndexToGo,smCoor,true);
                        if(this.mState == 3)
                        {
                           this.turnSetCenterPos(smCoor.x,smCoor.y);
                        }
                        else
                        {
                           this.targetSetWIOAsCurrentTarget(this.mGoToWIOTo);
                           unit = this.mGoToWIOTo.mUnit;
                           if(unit != null)
                           {
                              radius = unit.getBoundingRadius();
                              this.turnSetCenterPos(this.mTurnCenterX + Math.cos(this.mGoToAngleToEnter) * (this.mTurnRadius + 5),this.mTurnCenterY - Math.sin(this.mGoToAngleToEnter) * (this.mTurnRadius + 5));
                           }
                        }
                        this.mTurnInitialAngle = -1;
                     }
                     break;
                  }
            }
            this.stateSetShootCheckIsEnabled();
            particlesEnabled = this.stateNeedsParticlesEnabled(this.mState);
            if(prevParticlesEnabled != particlesEnabled)
            {
               if((viewComp = mUnit.getViewComponent()) != null)
               {
                  viewComp.setAreParticlesEnabled(particlesEnabled);
               }
            }
         }
      }
      
      private function stateSetShootCheckIsEnabled() : void
      {
         switch(this.mState - -1)
         {
            case 0:
            case 1:
            case 2:
            case 3:
            case 4:
            case 5:
               this.shootSetCheckIsEnabled(false);
               break;
            case 6:
            case 7:
            case 8:
               this.shootSetCheckIsEnabled(true);
         }
      }
      
      private function stateIsDefending() : Boolean
      {
         return mUnit.goalGetCurrentId() == "unitGoalSoldierDefending";
      }
      
      override public function notify(e:Object) : void
      {
         switch(e.cmd)
         {
            case "unitGoalTargetHasChanged":
               this.targetSetUnitAsCurrentTarget(mUnit.mData[13] as MyUnit);
               break;
            case "unitEventDefendBunker":
               if(this.mState == 6)
               {
                  this.stateChangeState(5);
               }
               else if(this.mState == 3)
               {
                  this.stateChangeState(4);
               }
               break;
            case "unitEventReturnToBunker":
               if(this.mState != 2)
               {
                  mUnit.mData[34] = e.bunker;
                  this.stateChangeState(6);
               }
         }
      }
      
      private function collisionsGetObstacleType(o:Object) : int
      {
         var returnValue:int = -1;
         if(o is MyUnit)
         {
            returnValue = 0;
         }
         else if(o is WorldItemObject)
         {
            returnValue = 1;
         }
         else if(o is int)
         {
            returnValue = 2;
         }
         return returnValue;
      }
      
      private function collisionsGetObstacleInDistance(tileIndex:int, checkIfCanStepIt:Boolean = false) : Object
      {
         var tileData:TileData = null;
         var baseItem:WorldItemObject = null;
         var baseUnit:MyUnit = null;
         var returnValue:Object = null;
         if(tileIndex > -1 && !smMapController.mMapModel.logicTilesCanBeStepped(tileIndex))
         {
            if((baseItem = (tileData = smTilesData[tileIndex]).mBaseItem) != null && !baseItem.mDef.isAnObstacle())
            {
               if(baseItem.mDef.isADecoration())
               {
                  if(baseItem != this.mTurnTargetWIO && baseItem != this.mTargetLastWIO)
                  {
                     returnValue = baseItem;
                  }
               }
               else
               {
                  baseUnit = baseItem.mUnit;
                  if(baseUnit != null && baseUnit.getIsAlive() && baseUnit != this.mTurnTargetUnit && baseUnit != this.mTargetLastUnit)
                  {
                     if(baseUnit.mDef.isAWall() && mUnit.isAllowedToStepWalls())
                     {
                        returnValue = null;
                     }
                     else
                     {
                        returnValue = baseUnit;
                     }
                  }
               }
            }
            else
            {
               returnValue = tileIndex;
            }
         }
         return returnValue;
      }
      
      private function collisionGetMapTileIndexFromPos(posX:Number, posY:Number, distance:Number) : int
      {
         if(DEBUG_PATH)
         {
            this.debugDrawHeading(distance);
         }
         smPosFutureX = smUnitHeading.x * distance + posX;
         smPosFutureY = smUnitHeading.y * distance + posY;
         smCoor.x = smPosFutureX;
         smCoor.y = smPosFutureY;
         smCoor.z = 0;
         return smViewMng.logicPosToTileIndex(smCoor);
      }
      
      private function collisionGetMapTileIndex(distance:Number) : int
      {
         return this.collisionGetMapTileIndexFromPos(smUnitPos.x,smUnitPos.y,distance);
      }
      
      private function collisionsGetHoleTileIndex(tileX:int, tileY:int, offX:int, offY:int) : int
      {
         var returnValue:int = -2;
         while(returnValue == -2)
         {
            tileX += offX;
            tileY += offY;
            if((returnValue = smMapController.getTileXYToIndex(tileX,tileY)) > -1)
            {
               if(!InstanceMng.getMapModel().logicTilesCanBeStepped(returnValue))
               {
                  returnValue = -2;
               }
            }
         }
         return returnValue;
      }
      
      private function collisionsIsHoleValid(tileIndex:int) : Boolean
      {
         var returnValue:Boolean = true;
         if(tileIndex > -1)
         {
            smCoor = smViewMng.tileIndexToWorldPos(tileIndex,smCoor,true);
            smVector.x = smCoor.x - smUnitPos.x;
            smVector.y = smCoor.y - smUnitPos.y;
            smVector.z = 0;
            smVector.normalize();
            if(smVector.x == smToOldPosX && smVector.y == smToOldPosY)
            {
               returnValue = false;
            }
            else
            {
               returnValue = smMapController.mMapModel.logicTilesCanBeStepped(tileIndex);
            }
         }
         return returnValue;
      }
      
      private function collisionsGetHoleIndexVertical(tileX:int, tileY:int, offX:int, offY:int, checkNeighbors:Boolean = true) : int
      {
         var neighborIndex:int = 0;
         var i:* = 0;
         var returnValue:int;
         if((returnValue = this.collisionsGetHoleTileIndex(tileX,tileY,0,offY)) > -1 && checkNeighbors)
         {
            smCoor1 = smMapController.getIndexToTileXY(returnValue,smCoor1);
            if((neighborIndex = smMapController.getTileXYToIndex(smCoor1.x - offX,smCoor1.y)) > -1 && smMapController.mMapModel.logicTilesCanBeStepped(neighborIndex))
            {
               i = tileY;
               while(i != smCoor1.y && returnValue > -1)
               {
                  if((neighborIndex = smMapController.getTileXYToIndex(tileX + offX,i)) == -1 || !smMapController.mMapModel.logicTilesCanBeStepped(neighborIndex))
                  {
                     returnValue = -1;
                  }
                  i += offY;
               }
            }
            else
            {
               returnValue = -1;
            }
         }
         return returnValue;
      }
      
      private function collisionsGetHoleIndexHorizontal(tileX:int, tileY:int, offX:int, offY:int, checkNeighbors:Boolean = true) : int
      {
         var neighborIndex:int = 0;
         var i:* = 0;
         var returnValue:int;
         if((returnValue = this.collisionsGetHoleTileIndex(tileX,tileY,offX,0)) > -1 && checkNeighbors)
         {
            smCoor1 = smMapController.getIndexToTileXY(returnValue,smCoor1);
            if((neighborIndex = smMapController.getTileXYToIndex(smCoor1.x,smCoor1.y - offY)) > -1 && smMapController.mMapModel.logicTilesCanBeStepped(neighborIndex))
            {
               i = tileX;
               while(i != smCoor1.x && returnValue > -1)
               {
                  if((neighborIndex = smMapController.getTileXYToIndex(i,tileY + offY)) == -1 || !smMapController.mMapModel.logicTilesCanBeStepped(neighborIndex))
                  {
                     returnValue = -1;
                  }
                  i += offX;
               }
            }
            else
            {
               returnValue = -1;
            }
         }
         return returnValue;
      }
      
      private function collisionsSelectHoleIndex(holeIndex1:int, holeIndex2:int) : int
      {
         var angle1:Number = NaN;
         var angle2:Number = NaN;
         var distanceToHole1:Number = NaN;
         var distanceToHole2:Number = NaN;
         var temp:Number = NaN;
         if(holeIndex1 > -1)
         {
            smCoor1 = smViewMng.tileIndexToWorldPos(holeIndex1,smCoor1,true);
            temp = smCoor1.x - smUnitOldPosX;
            distanceToHole1 = temp * temp;
            temp = smCoor1.y - smUnitOldPosY;
            distanceToHole1 += temp * temp;
            smVector.x = smCoor1.x - smUnitPos.x;
            smVector.y = smCoor1.y - smUnitPos.y;
            smVector.z = 0;
            smVector.normalize();
            temp = Vector3D.angleBetween(smUnitHeading,smVector);
            if(smVector.x == smToOldPosX && smVector.y == smToOldPosY)
            {
               holeIndex1 = -1;
            }
            else
            {
               angle1 = DCMath.rad2Degree(temp);
            }
         }
         if(holeIndex2 > -1)
         {
            smCoor1 = smViewMng.tileIndexToWorldPos(holeIndex2,smCoor1,true);
            temp = smCoor1.x - smUnitOldPosX;
            distanceToHole2 = temp * temp;
            temp = smCoor1.y - smUnitOldPosY;
            distanceToHole2 += temp * temp;
            smVector.x = smCoor1.x - smUnitPos.x;
            smVector.y = smCoor1.y - smUnitPos.y;
            smVector.z = 0;
            smVector.normalize();
            temp = Vector3D.angleBetween(smUnitHeading,smVector);
            if(smVector.x == smToOldPosX && smVector.y == smToOldPosY)
            {
               holeIndex2 = -1;
            }
            else
            {
               angle2 = DCMath.rad2Degree(temp);
            }
         }
         var holeIndex:* = -1;
         if(holeIndex1 == -1)
         {
            if(holeIndex2 > -1)
            {
               holeIndex = holeIndex2;
            }
         }
         else if(holeIndex2 == -1)
         {
            if(holeIndex1 > -1)
            {
               holeIndex = holeIndex1;
            }
         }
         else if(angle1 == angle2)
         {
            holeIndex = distanceToHole1 < distanceToHole2 ? holeIndex2 : holeIndex1;
         }
         else
         {
            holeIndex = Math.abs(angle1) < Math.abs(angle2) ? holeIndex1 : holeIndex2;
         }
         return holeIndex;
      }
      
      private function shootSetCheckIsEnabled(value:Boolean) : void
      {
         this.mShootCheckIsEnabled = value;
      }
      
      private function shootCheck() : void
      {
         var dx:Number = NaN;
         var dy:Number = NaN;
         var radii:Number = NaN;
         var toTarget:Vector3D = null;
         var velocity:Vector3D = null;
         var dot:Number = NaN;
         var off:Number = NaN;
         var targetUnit:MyUnit = smData[3];
         if(!smIsDefending && this.mTurnInitialAngle > -1 && this.mTurnTargetUnit != null && this.mTurnTargetUnit.getIsAlive())
         {
            targetUnit = this.mTurnTargetUnit;
         }
         smData[13] = targetUnit;
         var canShoot:*;
         if(canShoot = targetUnit != null && targetUnit.mIsAlive && targetUnit.mFaction != mUnit.mFaction)
         {
            dx = mUnit.mPosition.x - targetUnit.mPosition.x;
            dy = mUnit.mPosition.y - targetUnit.mPosition.y;
            radii = mUnit.mDef.getShotDistance() + targetUnit.mDef.getBoundingRadius();
            if(canShoot = int(dx * dx + dy * dy) < int(radii * radii))
            {
               if(this.mTurnInitialAngle > -1 && targetUnit.mDef.isABuilding())
               {
                  canShoot = true;
               }
               else
               {
                  toTarget = targetUnit.mPosition;
                  smVector.x = toTarget.x;
                  smVector.y = toTarget.y;
                  smVector.z = toTarget.z;
                  toTarget = smVector;
                  toTarget.decrementBy(mUnit.mPosition);
                  toTarget.normalize();
                  (velocity = smMovComp.mVelocity).normalize();
                  dot = toTarget.dotProduct(velocity);
                  off = targetUnit.mDef.isABuilding() ? 0.5 : 0.05;
                  canShoot = 1 - dot < off;
               }
               if(canShoot)
               {
                  mUnit.shotShoot(targetUnit);
               }
            }
         }
         var isDefendingAndNoTarget:Boolean = smIsDefending && targetUnit == null && mUnit.goalGetForCurrentId() != "unitGoalForReturnToBunker";
         if(smMovComp.isStopped())
         {
            if(!canShoot)
            {
               this.mCollisionsCheckIsEnabled = true;
               this.moveResume();
            }
         }
         else if(canShoot && !targetUnit.mDef.isABuilding())
         {
            this.mCollisionsCheckIsEnabled = false;
            this.movePause();
         }
      }
      
      override public function goToItem(itemTo:WorldItemObject, itemFrom:WorldItemObject = null, changeState:Boolean = true) : void
      {
         var bunker:Hangar = null;
         var tileIndexToGo:int = 0;
         var angle:Number = NaN;
         this.calculateData();
         if(itemFrom != null)
         {
            MyUnit.smUnitScene.shipsGetPositionFromItem(itemFrom,mUnit.mPosition);
         }
         this.targetSetPreferredUnit(null);
         this.mGoToWIOTo = itemTo;
         this.mGoToAngleToEnter = -1;
         if(itemTo != null)
         {
            this.targetSetPreferredUnit(itemTo.mUnit);
            if(this.mTargetPreferredUnit == null || this.mTurnInitialAngle > -1 && this.mTargetPreferredUnit != null && this.mTurnTargetUnit == this.mTargetPreferredUnit)
            {
               this.targetSetWIOAsCurrentTarget(itemTo);
            }
            bunker = MyUnit.smUnitScene.getHangarFromItem(itemTo);
            mUnit.mData[34] = bunker;
            if(bunker != null && bunker is Bunker)
            {
               itemTo = bunker.getWIO();
               if(itemTo != null)
               {
                  if((tileIndexToGo = InstanceMng.getWorldItemDefMng().getTileIndexToGo(itemTo)) > -1)
                  {
                     smViewMng.tileIndexToWorldPos(tileIndexToGo,smCoor,true);
                     smVector.x = smCoor.x;
                     smVector.y = smCoor.y;
                     smVector.z = 0;
                     smCoor.x = itemTo.mTileRelativeX;
                     smCoor.y = itemTo.mTileRelativeY;
                     smCoor = smViewMng.tileRelativeXYToWorldPos(smCoor,true);
                     smVector.x -= smCoor.x;
                     smVector.y -= smCoor.y;
                     smVector.normalize();
                     angle = Math.acos(smVector.x);
                     this.mGoToAngleToEnter = angle;
                  }
               }
            }
         }
         if(changeState)
         {
            this.stateChangeState(this.stateCalculateState());
         }
      }
      
      private function returnToBunker(goInside:Boolean = true) : void
      {
         var bunker:Hangar = mUnit.mData[34];
         if(bunker != null)
         {
            this.moveResume();
            mUnit.goalSetForCurrentId("unitGoalForReturnToBunker");
            smHangar = bunker;
            this.goToItem(bunker.getWIO(),null,false);
         }
      }
      
      private function debugDrawHeading(scale:Number) : void
      {
         smVector.x = smUnitHeading.x;
         smVector.y = smUnitHeading.y;
         smVector.z = smUnitHeading.z;
         smVector.scaleBy(scale);
         var xSrc:int = mUnit.mPosition.x;
         var ySrc:int = mUnit.mPosition.y;
         var mapView:MapViewPlanet = InstanceMng.getMapViewPlanet();
         mapView.drawLine(xSrc,ySrc,xSrc + smVector.x * 5,ySrc + smVector.y * 5,10027008,true,true);
      }
      
      private function debugDrawTurn() : void
      {
         smCoor.x = this.mTurnCenterX;
         smCoor.y = this.mTurnCenterY;
         smCoor = smViewMng.logicPosToViewPos(smCoor);
      }
   }
}
