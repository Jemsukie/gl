package com.dchoc.game.model.unit.components.movement
{
   import com.dchoc.game.controller.map.MapControllerPlanet;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.map.MapModel;
   import com.dchoc.game.model.map.TileData;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.Path;
   import com.dchoc.game.model.unit.components.UnitComponent;
   import com.dchoc.game.model.unit.defs.UnitDef;
   import com.dchoc.game.model.world.item.WorldItemDefMng;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.view.dc.mng.ViewMngPlanet;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.utils.math.DCMath;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   
   public class UnitComponentMovement extends UnitComponent
   {
      
      private static var smMapModel:MapModel;
      
      private static var smTilesData:Vector.<TileData>;
      
      private static var smMapController:MapControllerPlanet;
      
      private static var smViewMngGame:ViewMngPlanet;
      
      private static var smTileSemiWidth:int;
      
      private static var smTileSemiHeight:int;
      
      private static var smWorldItemDefMng:WorldItemDefMng;
      
      public static const BEHAVIOUR_NONE:uint = 0;
      
      public static const BEHAVIOUR_SEEK:uint = 1;
      
      public static const BEHAVIOUR_FLEE:uint = 2;
      
      public static const BEHAVIOUR_PURSUIT:uint = 3;
      
      public static const BEHAVIOUR_EVASION:uint = 4;
      
      public static const BEHAVIOUR_OFFSET_PURSUIT:uint = 5;
      
      public static const BEHAVIOUR_OBSTACLE_AVOIDANCE:uint = 7;
      
      public static const BEHAVIOUR_WANDER:uint = 8;
      
      public static const BEHAVIOUR_PATH_FOLLOWING:uint = 9;
      
      public static const BEHAVIOUR_FLOCKING:uint = 10;
      
      public static const BEHAVIOUR_LEAD_FOLLOWING:uint = 11;
      
      public static const BEHAVIOUR_GRAVITY:uint = 12;
      
      private static const smWaypointArrivalDistance:Number = 10;
      
      private static const smWaypointEaseDistance:Number = 50;
      
      private static const smWaypointEaseDistanceSquare:Number = 100;
      
      private static const TARGET_MIN_DISTANCE:int = 5;
      
      private static const GO_TO_ASK_FOR_PATH_TIMEOUT:int = 1000;
      
      private static const GO_TO_ASK_FOR_PATH_TIMEOUT_MIN:int = 333;
       
      
      public var mBehaviourWeights:Dictionary;
      
      public var mEaseArrival:Boolean = true;
      
      public var mVelocityZ:Number = 0;
      
      public var mVelocity:Vector3D;
      
      public var mPositionZ:Number = 0;
      
      protected var mMaxForce:Number;
      
      public var mMaxSpeed:Number;
      
      protected var mMaxSpeed2:Number;
      
      protected var mWanderRadius:Number = 16;
      
      protected var mWanderTheta:Number = 0;
      
      public var mWanderDistance:Number = 60;
      
      public var mAccelerationZ:Number;
      
      public var mAcceleration:Vector3D;
      
      public var mWanderStep:Number = 2;
      
      public var mOldPosition:Vector3D;
      
      protected var mTarget:Vector3D;
      
      protected var mTargetDistance:Number;
      
      protected var mTargetVelocity:Vector3D;
      
      protected var mTargetPostposed:Vector3D;
      
      public var mPath:Path;
      
      public var mPanicDistance:Number = 100;
      
      private var mCmd:String;
      
      private var mStopped:Boolean;
      
      public var mIsEnabled:Boolean;
      
      private var mGoToAskForPathTimer:int;
      
      private var mGoToTarget:Object;
      
      private var mGoToFrom:Object;
      
      private var mGoToEventOnArrive:String;
      
      public function UnitComponentMovement(u:MyUnit)
      {
         super(u);
      }
      
      public static function init() : void
      {
         smMapModel = InstanceMng.getMapModel();
         smTilesData = smMapModel.mTilesData;
         smMapController = InstanceMng.getMapControllerPlanet();
         smViewMngGame = InstanceMng.getViewMngPlanet();
         smTileSemiWidth = (smMapController.mMapViewDef.mTileLogicWidth >> 1) + 2;
         smTileSemiHeight = (smMapController.mMapViewDef.mTileLogicHeight >> 1) + 2;
         smWorldItemDefMng = InstanceMng.getWorldItemDefMng();
      }
      
      public static function unloadStatic() : void
      {
         smMapModel = null;
         smTilesData = null;
         smMapController = null;
         smViewMngGame = null;
         smTileSemiWidth = 0;
         smTileSemiHeight = 0;
         smWorldItemDefMng = null;
      }
      
      override protected function load() : void
      {
         this.mBehaviourWeights = new Dictionary(true);
         super.load();
      }
      
      override public function unload() : void
      {
         this.mBehaviourWeights = null;
         super.unload();
      }
      
      override protected function buildDo(def:UnitDef, u:MyUnit) : void
      {
         super.buildDo(def,u);
         this.mMaxForce = def.getMaxForce();
         this.setMaxSpeed(def.getMaxSpeed());
         this.mPanicDistance = def.getPanicDistance();
      }
      
      override public function reset(u:MyUnit) : void
      {
         super.reset(u);
         this.mVelocity = new Vector3D();
         this.mOldPosition = new Vector3D();
         this.mAcceleration = new Vector3D();
         this.mTarget = null;
         this.mTargetPostposed = null;
         this.mTargetVelocity = null;
         if(this.mPath != null)
         {
            this.mPath.unbuild();
            this.mPath = null;
         }
         this.resetBehaviours();
         this.mEaseArrival = false;
         this.mStopped = false;
         this.mIsEnabled = true;
         this.mAccelerationZ = 0;
      }
      
      public function isOnFloor() : Boolean
      {
         return mUnit.mPosition.z >= 0;
      }
      
      public function getIsEnabled() : Boolean
      {
         return this.mIsEnabled;
      }
      
      public function setIsEnabled(value:Boolean) : void
      {
         this.mIsEnabled = value;
      }
      
      override protected function logicUpdateDo(dt:int, u:MyUnit) : void
      {
         if(this.mIsEnabled)
         {
            this.steerLogicUpdate(1);
            this.locomotionLogicUpdate(dt / 10);
            this.goToLogicUpdate(dt);
         }
      }
      
      public function setMaxSpeed(value:Number) : void
      {
         if(value < 0)
         {
            value = 0;
         }
         value *= mUnit.slowDownGetCoef(0);
         this.mMaxSpeed = value;
         this.mMaxSpeed2 = value * value;
      }
      
      public function getMaxSpeed() : Number
      {
         return this.mMaxSpeed;
      }
      
      public function setMaxForce(value:Number) : void
      {
         if(value < 0)
         {
            value = 0;
         }
         this.mMaxForce = value;
      }
      
      public function getMaxForce() : Number
      {
         return this.mMaxForce;
      }
      
      public function steerLogicUpdate(dt:Number) : Boolean
      {
         var returnValue:Boolean = false;
         if(this.mBehaviourWeights[1] > 0)
         {
            returnValue = true;
            this.steerSeek(dt * this.mBehaviourWeights[1]);
         }
         if(this.mBehaviourWeights[2] > 0)
         {
            returnValue = true;
            this.steerFlee(dt * this.mBehaviourWeights[2]);
         }
         if(this.mBehaviourWeights[3] > 0)
         {
            returnValue = true;
            this.steerPursuit(dt * this.mBehaviourWeights[3]);
         }
         if(this.mBehaviourWeights[9] > 0)
         {
            returnValue = true;
            this.steerFollowPath(dt * this.mBehaviourWeights[9]);
         }
         if(this.mBehaviourWeights[8] > 0)
         {
            returnValue = true;
            this.steerWander(dt * this.mBehaviourWeights[8]);
         }
         return returnValue;
      }
      
      public function resetBehaviours() : void
      {
         this.mBehaviourWeights[8] = 0;
         this.mBehaviourWeights[1] = 0;
         this.mBehaviourWeights[2] = 0;
         this.mBehaviourWeights[3] = 0;
         this.mBehaviourWeights[9] = 0;
         this.mBehaviourWeights[7] = 0;
      }
      
      public function steerSeek(multiplier:Number = 1, easeDistance:Number = 100) : void
      {
         var steeringForce:Vector3D = null;
         if(this.mTarget != null)
         {
            steeringForce = this.steer(this.mTarget,this.mEaseArrival,easeDistance);
            steeringForce.scaleBy(multiplier);
            this.mAcceleration.incrementBy(steeringForce);
         }
      }
      
      public function steerPursuit(multiplier:Number = 1, easeDistance:Number = 100) : void
      {
         var steeringForce:Vector3D = null;
         var predictedTarget:Vector3D = null;
         if(this.mTarget != null)
         {
            predictedTarget = new Vector3D(this.mTarget.x + this.mTargetVelocity.x,this.mTarget.y + this.mTargetVelocity.y,this.mTarget.z + this.mTargetVelocity.z);
            (steeringForce = this.steer(this.mTarget,this.mEaseArrival,easeDistance)).scaleBy(multiplier);
            this.mAcceleration.incrementBy(steeringForce);
         }
      }
      
      public function steerFlee(multiplier:Number = 1) : void
      {
         var steeringForce:Vector3D = null;
         var distanceSqr:Number = NaN;
         if(this.mTarget != null)
         {
            distanceSqr = DCMath.distanceSqr(mUnit.mPosition,this.mTarget);
            if(distanceSqr <= this.mPanicDistance * this.mPanicDistance)
            {
               steeringForce = this.steer(this.mTarget,true,-this.mPanicDistance);
               steeringForce.scaleBy(multiplier);
               steeringForce.negate();
               this.mAcceleration.incrementBy(steeringForce);
            }
         }
      }
      
      public function moveToExactPosition(x:Number, y:Number, dt:Number, speed:Number) : Boolean
      {
         if(this.mStopped)
         {
            return false;
         }
         var returnValue:Boolean = false;
         dt /= 10;
         var positionX:* = mUnit.mPosition.x;
         var positionY:* = mUnit.mPosition.y;
         var prevAngle:Number = DCMath.rad2Degree(Math.acos(this.mVelocity.x));
         var oldVelocityX:Number = this.mVelocity.x;
         var oldVelocityY:Number = this.mVelocity.y;
         this.mVelocity.x = positionX;
         this.mVelocity.y = positionY;
         this.mVelocity.scaleBy(-1);
         this.mVelocity.x += x;
         this.mVelocity.y += y;
         this.mVelocity.z = 0;
         this.mVelocity.normalize();
         this.mVelocity.scaleBy(dt * speed);
         positionX += this.mVelocity.x;
         positionY += this.mVelocity.y;
         this.mVelocity.normalize();
         var position:Vector3D = mUnit.mPosition;
         this.mOldPosition.x = position.x;
         this.mOldPosition.y = position.y;
         this.mOldPosition.z = position.z;
         if(this.mOldPosition.x <= x && positionX > x || this.mOldPosition.x >= x && positionX < x)
         {
            positionX = x;
         }
         if(this.mOldPosition.y <= y && positionY > y || this.mOldPosition.y >= y && positionY < y)
         {
            positionY = y;
         }
         mUnit.setPosition(positionX,positionY);
         if(returnValue = positionX == x && positionY == y)
         {
            this.mVelocity.x = oldVelocityX;
            this.mVelocity.y = oldVelocityY;
         }
         return returnValue;
      }
      
      public function steerFollowPath(multiplier:Number = 1) : void
      {
         var waypoint:Vector3D = null;
         var waypointDistSqr:Number = NaN;
         var waypointCoor:DCCoordinate;
         if((waypointCoor = this.mPath.currentWaypointAsWorldCoord()) != null)
         {
            waypoint = waypointCoor.asVector3D();
            if(waypoint && !this.mPath.finished())
            {
               waypointDistSqr = DCMath.distanceSqr(waypoint,mUnit.mPosition);
               if(waypointDistSqr < 100)
               {
                  this.mPath.advance();
                  if(this.mPath.mType == 0 && this.mPath.finished())
                  {
                     this.steerFollowPathStop();
                  }
               }
               this.mTarget = this.mPath.currentWaypointAsWorldCoord().asVector3D();
               this.steerSeek(multiplier,50);
            }
         }
         else
         {
            this.steerFollowPathStop();
         }
      }
      
      private function steerFollowPathStop() : void
      {
         this.mBehaviourWeights[9] = 0;
         this.stop();
         if(this.mCmd != null)
         {
            this.sendEvent();
         }
      }
      
      public function steerWander(multiplier:Number) : void
      {
         var steeringForce:Vector3D = null;
         var newpos:Vector3D = this.mVelocity.clone();
         newpos.normalize();
         newpos.scaleBy(this.mWanderDistance);
         newpos.incrementBy(mUnit.mPosition);
         var offset:Vector3D = new Vector3D();
         offset.x = this.mWanderRadius * Math.cos(this.mWanderTheta);
         offset.y = this.mWanderRadius * Math.sin(this.mWanderTheta);
         (steeringForce = this.steer(newpos.add(offset))).scaleBy(multiplier);
         this.mAcceleration.incrementBy(steeringForce);
      }
      
      public function locomotionLogicUpdate(dt:uint) : void
      {
         var incVel:Vector3D = null;
         var coor:DCCoordinate = null;
         var tileIndex:int = 0;
         var tileData:TileData = null;
         var tileIndexTemp:int = 0;
         var oldPositionTileX:int = 0;
         var oldPositionTileY:int = 0;
         var candidate1:TileData = null;
         var candidate2:TileData = null;
         var chosen:* = null;
         var tileDataBlocking:TileData = null;
         var vertical:* = false;
         var newPosX:int = 0;
         var newPosY:int = 0;
         var sign:int = 0;
         var tilesPerRow:int = 0;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var distance1:Number = NaN;
         var distance2:Number = NaN;
         var targetX:int = 0;
         var targetY:int = 0;
         var position:Vector3D = mUnit.mPosition;
         if(this.mAccelerationZ != 0)
         {
            this.mVelocityZ += this.mAccelerationZ * dt;
            if(this.mPositionZ < 0)
            {
               this.mPositionZ += this.mVelocityZ * dt;
            }
            else
            {
               position.z += this.mVelocityZ * dt;
            }
         }
         else if(position.z < 0)
         {
            this.mVelocityZ += 0.68;
            position.z += this.mVelocityZ * dt;
            if(position.z > 0)
            {
               if(this.mVelocityZ > 2)
               {
                  this.mVelocityZ = -(3 * this.mVelocityZ / 7);
                  position.z = -1;
               }
               else
               {
                  this.mVelocityZ = 0;
                  position.z = 0;
               }
            }
         }
         if(!this.mStopped)
         {
            this.mOldPosition.x = position.x;
            this.mOldPosition.y = position.y;
            this.mOldPosition.z = position.z;
         }
         this.mVelocity.incrementBy(this.mAcceleration);
         if(this.mVelocity.lengthSquared > this.mMaxSpeed2)
         {
            this.mVelocity.normalize();
            this.mVelocity.scaleBy(this.mMaxSpeed);
         }
         if(!this.mStopped)
         {
            (incVel = new Vector3D(this.mVelocity.x,this.mVelocity.y,0)).scaleBy(dt);
            position.incrementBy(incVel);
            if(this.mBehaviourWeights[7] > 0)
            {
               coor = MyUnit.smCoor;
               coor.x = position.x;
               coor.y = position.y;
               tileIndex = smViewMngGame.logicPosToTileIndex(coor);
               if((tileData = smMapModel.getTileDataFromIndex(tileIndex)) != null)
               {
                  if(!smMapModel.logicTilesCanBeStepped(tileIndex))
                  {
                     coor.x = this.mOldPosition.x;
                     coor.y = this.mOldPosition.y;
                     smViewMngGame.logicPosToTileXY(coor);
                     oldPositionTileX = coor.x;
                     oldPositionTileY = coor.y;
                     candidate1 = null;
                     candidate2 = null;
                     chosen = null;
                     if(!(vertical = tileData.mRow != oldPositionTileY && tileData.mCol == oldPositionTileX))
                     {
                        tileIndexTemp = smMapController.getTileXYToIndex(oldPositionTileX,tileData.mRow);
                        vertical = !smMapModel.logicTilesCanBeStepped(tileIndexTemp);
                     }
                     newPosX = 2147483647;
                     newPosY = 2147483647;
                     if(vertical)
                     {
                        coor.x = tileData.mCol;
                        coor.y = tileData.mRow;
                        smViewMngGame.tileXYToWorldPos(coor,true);
                        sign = oldPositionTileY < tileData.mRow ? -1 : 1;
                        position.y = coor.y + smTileSemiHeight * sign;
                     }
                     else
                     {
                        coor.x = tileData.getCol();
                        coor.y = tileData.getRow();
                        smViewMngGame.tileXYToWorldPos(coor,true);
                        sign = oldPositionTileX < tileData.mCol ? -1 : 1;
                        position.x = coor.x + smTileSemiWidth * sign;
                     }
                     if(this.mTargetPostposed == null)
                     {
                        if(vertical)
                        {
                           tileIndexTemp = tileIndex + 1;
                           while(smMapController.isIndexInMap(tileIndexTemp) && candidate1 == null)
                           {
                              candidate1 = smTilesData[tileIndexTemp];
                              if((tileDataBlocking = smMapController.getTileDataFromTileXY(candidate1.mCol,oldPositionTileY)) != null && !smMapModel.logicTilesCanBeStepped(tileDataBlocking.mTileIndex))
                              {
                                 candidate1 = null;
                                 break;
                              }
                              if(!smMapModel.logicTilesCanBeStepped(candidate1.mTileIndex))
                              {
                                 candidate1 = null;
                              }
                              tileIndexTemp++;
                           }
                           tileIndexTemp = tileIndex - 1;
                           while(smMapController.isIndexInMap(tileIndexTemp) && candidate2 == null)
                           {
                              candidate2 = smTilesData[tileIndexTemp];
                              if((tileDataBlocking = smMapController.getTileDataFromTileXY(candidate2.mCol,oldPositionTileY)) != null && !smMapModel.logicTilesCanBeStepped(tileDataBlocking.mTileIndex))
                              {
                                 candidate2 = null;
                                 break;
                              }
                              if(!smMapModel.logicTilesCanBeStepped(candidate2.mTileIndex))
                              {
                                 candidate2 = null;
                              }
                              tileIndexTemp--;
                           }
                        }
                        else if(tileData.mCol != oldPositionTileY)
                        {
                           tilesPerRow = int(smMapController.mTilesCols);
                           tileIndexTemp = tileIndex + tilesPerRow;
                           while(smMapController.isIndexInMap(tileIndexTemp) && candidate1 == null)
                           {
                              candidate1 = smTilesData[tileIndexTemp];
                              tileDataBlocking = smMapController.getTileDataFromTileXY(oldPositionTileX,candidate1.mRow);
                              if(!smMapModel.logicTilesCanBeStepped(tileDataBlocking.mTileIndex))
                              {
                                 candidate1 = null;
                                 break;
                              }
                              if(!smMapModel.logicTilesCanBeStepped(candidate1.mTileIndex))
                              {
                                 candidate1 = null;
                              }
                              tileIndexTemp += tilesPerRow;
                           }
                           tileIndexTemp = tileIndex - tilesPerRow;
                           while(smMapController.isIndexInMap(tileIndexTemp) && candidate2 == null)
                           {
                              candidate2 = smTilesData[tileIndexTemp];
                              tileDataBlocking = smMapController.getTileDataFromTileXY(oldPositionTileX,candidate2.mRow);
                              if(!smMapModel.logicTilesCanBeStepped(tileDataBlocking.mTileIndex))
                              {
                                 candidate2 = null;
                                 break;
                              }
                              if(!smMapModel.logicTilesCanBeStepped(candidate2.mTileIndex))
                              {
                                 candidate2 = null;
                              }
                              tileIndexTemp -= tilesPerRow;
                           }
                        }
                        if(candidate1 != null && candidate2 == null)
                        {
                           chosen = candidate1;
                        }
                        else if(candidate1 == null && candidate2 != null)
                        {
                           chosen = candidate2;
                        }
                        else if(candidate1 != null && candidate2 != null)
                        {
                           smViewMngGame.tileIndexToWorldPos(candidate1.mTileIndex,coor);
                           dx = coor.x - this.mTarget.x;
                           dy = coor.y - this.mTarget.y;
                           distance1 = dx * dx + dy * dy;
                           smViewMngGame.tileIndexToWorldPos(candidate2.mTileIndex,coor);
                           dx = coor.x - this.mTarget.x;
                           dy = coor.y - this.mTarget.y;
                           distance2 = dx * dx + dy * dy;
                           if(distance1 < distance2)
                           {
                              chosen = candidate1;
                           }
                           else
                           {
                              chosen = candidate2;
                           }
                        }
                        if(chosen != null)
                        {
                           if(vertical)
                           {
                              coor.x = chosen.mCol;
                              coor.y = oldPositionTileY;
                              smViewMngGame.tileXYToWorldPos(coor,true);
                              targetX = coor.x;
                              targetY = position.y;
                           }
                           else
                           {
                              coor.x = oldPositionTileX;
                              coor.y = chosen.mRow;
                              smViewMngGame.tileXYToWorldPos(coor,true);
                              targetX = position.x;
                              targetY = coor.y;
                           }
                           this.arrivePostposing(targetX,targetY);
                           coor.x = targetX;
                           coor.y = targetY;
                           smViewMngGame.logicPosToViewPos(coor);
                           InstanceMng.getMapViewPlanet().mDOCross.x = coor.x;
                           InstanceMng.getMapViewPlanet().mDOCross.y = coor.y;
                        }
                     }
                  }
               }
            }
            mUnit.setPosition(position.x,position.y);
            if(this.hasArrive())
            {
               if(this.mTargetPostposed != null)
               {
                  this.arriveRestoreTargetPostposed();
               }
               else if(this.mCmd != null)
               {
                  this.sendEvent();
               }
            }
         }
         this.mAcceleration.x = 0;
         this.mAcceleration.y = 0;
         this.mAcceleration.z = 0;
      }
      
      private function sendEvent() : void
      {
         mUnit.sendEvent(this.mCmd);
         this.mCmd = null;
      }
      
      public function hasArrive() : Boolean
      {
         if(this.mPath != null)
         {
            return this.mPath.finished();
         }
         return this.mTarget == null ? false : DCMath.distanceSqr(mUnit.mPosition,this.mTarget) < this.mTargetDistance * this.mTargetDistance;
      }
      
      private function steer(target:Vector3D, ease:Boolean = false, easeDistance:Number = 100) : Vector3D
      {
         var distanceToTarget:Number = NaN;
         var maxSpeed:Number = NaN;
         var steeringForce:Vector3D;
         (steeringForce = target.clone()).decrementBy(mUnit.mPosition);
         if((distanceToTarget = steeringForce.normalize()) > 0.00001)
         {
            if(distanceToTarget < easeDistance && ease)
            {
               steeringForce.scaleBy(this.mMaxSpeed * (distanceToTarget / easeDistance));
            }
            else
            {
               maxSpeed = this.mMaxSpeed;
               if(this.mVelocity.lengthSquared == this.mMaxSpeed2)
               {
                  maxSpeed = this.mMaxSpeed + 0.1;
               }
               steeringForce.scaleBy(maxSpeed);
            }
            steeringForce.decrementBy(this.mVelocity);
            if(steeringForce.lengthSquared > this.mMaxForce * this.mMaxForce)
            {
               steeringForce.normalize();
               steeringForce.scaleBy(this.mMaxForce);
            }
         }
         return steeringForce;
      }
      
      public function refreshPath() : void
      {
         this.mPath.setWaypointIndex(this.calculateClosestWaypoint());
         if(Config.DEBUG_PATHS)
         {
            this.mPath.updateView(16776960,Math.random() * 16777215);
         }
         this.mTarget = this.mPath.currentWaypointAsWorldCoord().asVector3D();
      }
      
      private function calculateClosestWaypoint() : int
      {
         var i:int = 0;
         var tmpDistanceSqr:Number = NaN;
         var pointPosition:Vector3D = null;
         var minPointPosition:Vector3D = null;
         var minIndex:* = -1;
         var minDistanceSqr:* = 1.7976931348623157e+308;
         var length:int = this.mPath.getPathLength();
         var position:Vector3D = mUnit.mPosition;
         for(i = 0; i < length; )
         {
            pointPosition = this.mPath.getWorldCoords(i).asVector3D();
            tmpDistanceSqr = DCMath.distanceSqr(pointPosition,position);
            if(tmpDistanceSqr < minDistanceSqr || DCMath.distanceSqr(pointPosition,minPointPosition) > tmpDistanceSqr)
            {
               minIndex = i;
               minDistanceSqr = tmpDistanceSqr;
               minPointPosition = this.mPath.getWorldCoords(i).asVector3D();
            }
            i++;
         }
         return minIndex;
      }
      
      public function setPath(path:Path) : void
      {
         this.mPath = path;
         this.refreshPath();
      }
      
      public function setTarget(target:Vector3D, distance:Number = 5) : void
      {
         this.mTarget = target;
         this.mTargetDistance = distance < 5 ? 5 : distance;
      }
      
      public function getTarget() : Vector3D
      {
         return this.mTarget;
      }
      
      public function setTargetUnitMobile(targetUnit:MyUnit) : void
      {
         this.mTarget = targetUnit.mPosition;
         this.mTargetVelocity = targetUnit.getMovementComponent().mVelocity;
      }
      
      public function setBehaviorWeight(key:int, value:Number) : void
      {
         this.mBehaviourWeights[key] = value;
      }
      
      override public function getHeading() : Vector3D
      {
         return this.mVelocity;
      }
      
      public function goToPosition(pos:Vector3D, distance:Number = 0, cmdOnArrive:String = null) : void
      {
         this.resume();
         this.mEaseArrival = true;
         this.setTarget(pos,distance);
         this.resetBehaviours();
         this.setBehaviorWeight(1,1);
         this.mCmd = cmdOnArrive;
      }
      
      public function followPath(path:Path, setAtFirsPosition:Boolean = false, cmdOnArrive:String = null) : void
      {
         var coor:DCCoordinate = null;
         if(path.isNotEmpty())
         {
            this.resume();
            if(setAtFirsPosition)
            {
               coor = path.getWorldCoords(0);
               mUnit.setPosition(coor.x,coor.y);
            }
            this.mEaseArrival = false;
            this.setPath(path);
            this.resetBehaviours();
            this.mBehaviourWeights[9] = 1.1;
            this.mCmd = cmdOnArrive;
            if(Config.DEBUG_PATHS)
            {
               this.mPath.updateView();
               this.mPath.addToView();
            }
         }
      }
      
      public function isFollowingAPath() : Boolean
      {
         return this.mBehaviourWeights[9] > 0;
      }
      
      public function followPathFromRaw(path:Vector.<int>, tileIndexDest:int, complete:Boolean, reverse:Boolean = false, setAtFirstPosition:Boolean = false, cmdOnArrive:String = null, itemFrom:WorldItemObject = null, itemTo:WorldItemObject = null) : void
      {
         if(this.mPath == null)
         {
            this.mPath = new Path();
         }
         else
         {
            this.mPath.unbuild();
         }
         var pos:Vector3D = setAtFirstPosition ? null : mUnit.mPosition;
         this.mPath.buildFromPoints(path,tileIndexDest,complete,reverse,0,itemFrom,itemTo,pos,!mUnit.isAllowedToStepWalls());
         this.followPath(this.mPath,setAtFirstPosition,cmdOnArrive);
      }
      
      public function reversePath() : void
      {
         if(this.mPath != null)
         {
            this.resume();
            this.mEaseArrival = false;
            this.mPath.mReverseOrder = true;
            if(this.mPath.finished())
            {
               this.mPath.start();
            }
         }
         else if(Config.DEBUG_ASSERTS)
         {
            DCDebug.trace("WARNING in UnitComponentMovement.reversePath(): no path assigned",1);
         }
      }
      
      public function wander(weight:Number) : void
      {
         this.resume();
         this.resetBehaviours();
         this.mBehaviourWeights[8] = weight;
      }
      
      public function wanderToPosition(target:Vector3D, distance:Number = 0, cmdOnArrive:String = null, weight:Number = 0.7) : void
      {
         var signX:Number = NaN;
         var signY:Number = NaN;
         var diffX:Number = NaN;
         var diffY:Number = NaN;
         var abs:Number = NaN;
         this.resume();
         this.resetBehaviours();
         this.setTarget(target,distance);
         this.mBehaviourWeights[1] = 5;
         this.mBehaviourWeights[8] = weight;
         if(target != null)
         {
            diffX = mUnit.mPosition.x - this.mTarget.x;
            diffY = mUnit.mPosition.y - this.mTarget.y;
            if((abs = Math.abs(diffX)) > 0.00001)
            {
               signX = diffX / abs;
            }
            else
            {
               signX = 0;
            }
            if((abs = Math.abs(diffY)) > 0.00001)
            {
               signY = diffY / abs;
            }
            else
            {
               signY = 0;
            }
         }
         this.mAcceleration.x = this.mMaxForce * signY;
         this.mAcceleration.y = this.mMaxForce * signX;
         this.mMaxForce = 0.05;
         this.mEaseArrival = true;
         this.mCmd = cmdOnArrive;
      }
      
      public function arrivePostposing(x:Number, y:Number) : void
      {
         if(this.mTargetPostposed == null)
         {
            this.mTargetPostposed = this.mTarget;
         }
         this.arrive(x,y);
         this.mEaseArrival = false;
         this.mBehaviourWeights[7] = 1;
      }
      
      public function arriveRestoreTargetPostposed() : void
      {
         if(this.mTargetPostposed != null)
         {
            this.arrive(this.mTargetPostposed.x,this.mTargetPostposed.y);
            this.mBehaviourWeights[7] = 1;
            this.mTargetPostposed = null;
         }
      }
      
      public function arrive(x:Number, y:Number) : void
      {
         this.resume();
         this.resetBehaviours();
         this.mBehaviourWeights[1] = 1;
         this.setTarget(new Vector3D(x,y));
         this.mEaseArrival = true;
      }
      
      public function resume() : void
      {
         this.mStopped = false;
      }
      
      public function stop() : void
      {
         this.mStopped = true;
      }
      
      public function isStopped() : Boolean
      {
         return this.mStopped;
      }
      
      public function setVelocity(x:Number, y:Number, z:Number) : void
      {
         this.mVelocity.x = x;
         this.mVelocity.y = y;
         this.mVelocityZ = z;
      }
      
      public function goToSetPositionOnItem(item:WorldItemObject) : void
      {
         mUnit.setPositionInViewSpace(item.mViewCenterWorldX,item.mViewCenterWorldY);
      }
      
      public function goToReset() : void
      {
         this.mGoToTarget = null;
         this.mGoToEventOnArrive = null;
         this.mGoToAskForPathTimer = 0;
         this.mGoToFrom = null;
      }
      
      public function goToLogicUpdate(dt:int) : void
      {
         var item:WorldItemObject = null;
         var coef:Number = NaN;
         var tileIndex:int = 0;
         var coor:DCCoordinate = null;
         if(this.mGoToTarget != null && this.mGoToAskForPathTimer >= 0 && !this.mStopped)
         {
            this.mGoToAskForPathTimer -= dt;
            if(this.mGoToAskForPathTimer < 0)
            {
               item = null;
               if(this.mGoToFrom != null)
               {
                  if(this.mGoToFrom is WorldItemObject)
                  {
                     item = WorldItemObject(this.mGoToFrom);
                  }
                  else if(this.mGoToFrom.tileIndex != null)
                  {
                     tileIndex = int(this.mGoToFrom.tileIndex);
                     coor = MyUnit.smCoor;
                     smViewMngGame.tileIndexToWorldViewPos(tileIndex,coor);
                     mUnit.setPositionInViewSpace(coor.x,coor.y);
                     this.mGoToFrom = null;
                  }
               }
               MyUnit.smUnitScene.pathFinderRequestPath(mUnit,this.mGoToTarget,mUnit.mDef,false,this.mGoToEventOnArrive,false,false,item);
               coef = mUnit.mDef.getMaxSpeed() / 0.5;
               this.mGoToAskForPathTimer = 1000 / coef;
               if(this.mGoToAskForPathTimer < 333)
               {
                  this.mGoToAskForPathTimer = 333;
               }
            }
         }
      }
      
      public function goToTarget(target:Object, from:Object, reverse:Boolean = false, eventOnArrive:String = null, askPeriodically:Boolean = true) : void
      {
         var pTileIndex:int = 0;
         var item:WorldItemObject = null;
         if(from is WorldItemObject)
         {
            item = WorldItemObject(from);
            if((pTileIndex = smWorldItemDefMng.getTileIndexToGo(item,mUnit)) > -1)
            {
               from = {"tileIndex":pTileIndex};
            }
         }
         if(target is WorldItemObject)
         {
            item = WorldItemObject(target);
            if((pTileIndex = smWorldItemDefMng.getTileIndexToGo(item,mUnit)) > -1)
            {
               target = {"tileIndex":pTileIndex};
            }
         }
         if(reverse)
         {
            this.mGoToTarget = from;
            this.mGoToFrom = target;
         }
         else
         {
            this.mGoToTarget = target;
            this.mGoToFrom = from;
         }
         this.mGoToEventOnArrive = eventOnArrive;
         this.mGoToAskForPathTimer = 0;
         this.resume();
         this.goToLogicUpdate(1);
         if(!askPeriodically)
         {
            this.mGoToAskForPathTimer = -1;
         }
      }
      
      public function goToUnit(unitTarget:MyUnit, eventOnArrive:String = null) : void
      {
         var itemTo:WorldItemObject = MyUnit.smUnitScene.mUnitsItems[unitTarget.mId];
         var target:Object = itemTo == null ? unitTarget : itemTo;
         this.goToTarget(target,eventOnArrive);
      }
      
      public function goToItem(target:WorldItemObject, itemFrom:WorldItemObject = null, reverse:Boolean = false, eventOnArrive:String = null, askPeriodically:Boolean = true) : void
      {
         this.goToTarget(target,itemFrom,reverse,eventOnArrive,askPeriodically);
      }
      
      public function goToTileIndex(pTileIndex:int, itemFrom:WorldItemObject = null, reverse:Boolean = false, eventOnArrive:String = null, askPeriodically:Boolean = true) : void
      {
         this.goToTarget({"tileIndex":pTileIndex},itemFrom,reverse,eventOnArrive,askPeriodically);
      }
      
      public function goToWorldPosition(pos:Vector3D, eventOnArrive:String = null) : void
      {
         this.goToTarget(pos,null,false,eventOnArrive);
      }
   }
}
