package com.dchoc.game.model.unit.components.goal
{
   import com.dchoc.game.model.map.MapModel;
   import com.dchoc.game.model.map.TileData;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.ParticleMng;
   import com.dchoc.game.model.unit.Path;
   import com.dchoc.game.model.unit.UnitScene;
   import com.dchoc.game.model.unit.components.movement.UnitComponentMovement;
   import com.dchoc.game.model.unit.components.shot.UnitComponentShot;
   import com.dchoc.game.model.unit.components.view.UnitComponentView;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.utils.math.DCMath;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import flash.geom.Vector3D;
   
   public class GoalTerrainUnit extends UnitComponentGoal
   {
      
      protected static const STATE_LOOKING_FOR_A_TARGET:int = 0;
      
      protected static const STATE_GETTING_TARGET:int = 1;
      
      public static const TASKS_LOOK_FOR_A_TARGET:int = 100;
      
      protected static const MOVE_MODE_NONE:int = -1;
      
      protected static const MOVE_MODE_STOPPED:int = 0;
      
      protected static const MOVE_MODE_WANDER:int = 1;
      
      protected static const MOVE_MODE_FOLLOW_PATH:int = 2;
      
      protected static const MOVE_MODE_ARRIVE:int = 3;
      
      private static const SHOT_STATE_READY:int = 0;
      
      private static const SHOT_STATE_AIMING:int = 1;
      
      private static const SHOT_STATE_SHOOTING:int = 2;
      
      private static const DRILL_STATE_GOING_OUT_ID:int = 0;
      
      private static const DRILL_STATE_ON_SURFACE_ID:int = 1;
      
      private static const DRILL_STATE_PRE_ENTERING_ID:int = 2;
      
      private static const DRILL_STATE_ENTERING_ID:int = 3;
      
      private static const DRILL_STATE_UNDER_SURFACE_ID:int = 4;
      
      private static const DRILL_STATE_COUNT:int = 5;
      
      private static const DRILL_UP_DOWN_PROJECT_DISTANCE:int = 50;
      
      private static const DRILL_UP_DOWN_ANGLE:Array = [220,300];
      
      private static const DRILL_UP_DOWN_ANGLES_COUNT:int = DRILL_UP_DOWN_ANGLE.length;
      
      private static const DRILL_UP_DOWN_ANIM_SUFFIX_ID:Array = ["left","right"];
      
      private static const DRILL_STATE_ANIM_ID:Array = ["up_","running","none","down_","none"];
      
      private static var smDrillHeadingAngleVectors:Vector.<Vector3D>;
      
      private static var smDrillHeadingProjectedVectors:Vector.<Vector3D>;
      
      private static const DRILL_DISTANCE_TO_DRAW_PARTICLE_SQR:int = 1024;
       
      
      private var mAnimLookingForATarget:String;
      
      private var mCheckTargetTime:int;
      
      protected var mUsePathIsEnabled:Boolean;
      
      public var mRetreatFormationPos:Vector3D;
      
      protected var mMoveMode:int;
      
      protected var mMoveModePrevious:int;
      
      protected var mMoveAnimIdPrevious:String;
      
      protected var mMoveHasArrivedTask:int;
      
      protected var mMoveHasArrivedTaskDefault:int;
      
      protected var mShotIsAllowed:Boolean;
      
      protected var mShotIsEnabled:Boolean;
      
      protected var mShotState:int;
      
      protected var mDrillIsEnabled:Boolean;
      
      private var mDrillState:int;
      
      private var mDrillLastParticlePos:Vector3D;
      
      private var mDrillToTarget:Vector3D;
      
      private var mDrillAngleId:int;
      
      public function GoalTerrainUnit(unit:MyUnit, shotIsAllowed:Boolean = true, moveHasArrivedTaskDefault:int = 2, animLookingForATarget:String = "still")
      {
         super(unit);
         this.mShotIsAllowed = shotIsAllowed;
         this.mMoveHasArrivedTaskDefault = moveHasArrivedTaskDefault;
         this.mAnimLookingForATarget = animLookingForATarget;
      }
      
      override public function activate() : void
      {
         super.activate();
         this.mDrillIsEnabled = mUnit.mDef.getAnimationDefSku() == "driller";
         this.mUsePathIsEnabled = !this.mDrillIsEnabled;
         if(this.mDrillIsEnabled)
         {
            this.drillLoad();
            this.drillSetState(1);
         }
         this.moveReset();
         this.shotReset();
         changeState(0);
      }
      
      override protected function enterState(newState:int) : void
      {
         var moveComp:UnitComponentMovement = null;
         var heading:Vector3D = null;
         var coor:DCCoordinate = null;
         super.enterState(newState);
         switch(newState - -5)
         {
            case 0:
               coor = MyUnit.smCoor;
               if(this.mRetreatFormationPos == null)
               {
                  this.moveWander(null,0,this.moveGetAnimId());
                  mUnit.getMovementComponent().setMaxSpeed(mUnit.mDef.getMaxSpeed() * 0.6);
               }
               else
               {
                  mUnit.getMovementComponent().goToPosition(this.mRetreatFormationPos);
               }
               this.mShotIsEnabled = false;
               this.mCheckTargetTime = 2000;
               break;
            case 1:
               animSetId(this.moveGetAnimId());
               heading = (moveComp = mUnit.getMovementComponent()).getHeading().clone();
               heading.normalize();
               heading.scaleBy(-1600);
               heading.x += mUnit.mPosition.x;
               heading.y += mUnit.mPosition.y;
               moveComp.goToPosition(heading);
               moveComp.setMaxSpeed(mUnit.mDef.getMaxSpeed() * 0.3);
               this.mShotIsEnabled = false;
               break;
            case 5:
               mUnit.mData[3] = null;
               mUnit.mData[13] = null;
               if(this.mAnimLookingForATarget == "still")
               {
                  this.moveStop();
               }
               else
               {
                  this.moveStop();
               }
               break;
            case 6:
               this.mCheckTargetTime = 2000;
         }
      }
      
      override protected function exitState(state:int) : void
      {
         switch(state - -4)
         {
            case 0:
               mUnit.getMovementComponent().setMaxSpeed(mUnit.mDef.getMaxSpeed());
               this.mShotIsEnabled = true;
         }
         mUnit.getMovementComponent().setMaxSpeed(mUnit.mDef.getMaxSpeed());
         this.mShotIsEnabled = true;
      }
      
      override protected function logicUpdateDoDo(dt:int, u:MyUnit) : void
      {
         var adjacentTiles:* = undefined;
         var moveComp:UnitComponentMovement;
         if(!(moveComp = u.getMovementComponent()).isOnFloor())
         {
            return;
         }
         var tileData:TileData = null;
         var targetUnit:MyUnit = null;
         var checkTarget:* = false;
         var canShoot:* = false;
         var shotIsTypeBlast:Boolean = false;
         var path:Path = null;
         var item:WorldItemObject = null;
         var col:int = 0;
         var row:int = 0;
         var thisUnit:MyUnit = null;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var radii:Number = NaN;
         var toTarget:Vector3D = null;
         var velocity:Vector3D = null;
         var dot:Number = NaN;
         var coor:DCCoordinate = null;
         var tileIndex:int = 0;
         var baseItem:WorldItemObject = null;
         var mapModel:MapModel = UnitScene.smMapModel;
         var data:Array = u.mData;
         if(this.mMoveMode != -1 && this.mMoveMode != 0)
         {
            if(this.mMoveHasArrivedTask != -1)
            {
               if(moveComp.hasArrive())
               {
                  tasksPerform(this.mMoveHasArrivedTask);
                  this.mMoveHasArrivedTask = -1;
               }
            }
         }
         this.mCheckTargetTime -= dt;
         checkTarget = mCurrentState == 1 && this.mCheckTargetTime < 0;
         if(this.mDrillIsEnabled && checkTarget)
         {
            checkTarget = this.mShotIsEnabled;
         }
         if(this.mShotIsEnabled)
         {
            targetUnit = data[3];
            canShoot = true;
            if(!u.isAllowedToStepWalls())
            {
               if((path = moveComp.mPath) != null && path.mWaypointsTileDatas != null && path.mWaypointsTileDatas.length > 0)
               {
                  if((tileData = path.mWaypointsTileDatas[path.mIndex]) != null && !mapModel.logicTilesCanBeStepped(tileData.mTileIndex))
                  {
                     item = tileData.mBaseItem;
                     col = tileData.mCol;
                     row = tileData.mRow;
                     if(item == null)
                     {
                        (adjacentTiles = new Vector.<TileData>(0)).push(mapModel.mMapController.getTileDataFromTileXY(col + 1,row));
                        adjacentTiles.push(mapModel.mMapController.getTileDataFromTileXY(col - 1,row));
                        adjacentTiles.push(mapModel.mMapController.getTileDataFromTileXY(col,row + 1));
                        adjacentTiles.push(mapModel.mMapController.getTileDataFromTileXY(col,row - 1));
                        for each(tileData in adjacentTiles)
                        {
                           if(tileData != null)
                           {
                              if((item = tileData.mBaseItem) != null && (!item.mDef.isAWall() || item.isBroken()))
                              {
                                 item = null;
                              }
                           }
                           if(item != null)
                           {
                              break;
                           }
                        }
                     }
                     if(item != null)
                     {
                        if((thisUnit = item.mUnit) != null && thisUnit.shotCanBeATarget())
                        {
                           targetUnit = item.mUnit;
                           checkTarget = false;
                        }
                     }
                  }
               }
               canShoot = this.mDrillIsEnabled || path != null;
            }
            if(canShoot)
            {
               canShoot = targetUnit != null && targetUnit.mIsAlive;
            }
            shotIsTypeBlast = mUnit.mFaction == 0 && mUnit.mDef.getAmmoSku() == "b_blast_001";
            if(canShoot)
            {
               dx = mUnit.mPosition.x - targetUnit.mPosition.x;
               dy = mUnit.mPosition.y - targetUnit.mPosition.y;
               if(shotIsTypeBlast)
               {
                  radii = u.mDef.getBoundingRadius() + targetUnit.mDef.getBoundingRadius();
               }
               else
               {
                  radii = mUnit.mDef.getShotDistance() + targetUnit.mDef.getBoundingRadius();
               }
               canShoot = dx * dx + dy * dy < radii * radii;
            }
            if(canShoot)
            {
               if(shotIsTypeBlast)
               {
                  this.checkTypeBlast(targetUnit);
                  return;
               }
               if(this.mShotState == 2)
               {
                  mUnit.shotShoot(targetUnit);
               }
               else if(this.mShotState == 1)
               {
                  (toTarget = targetUnit.mPosition.clone()).decrementBy(mUnit.mPosition);
                  toTarget.normalize();
                  (velocity = mUnit.getMovementComponent().mVelocity).normalize();
                  dot = toTarget.dotProduct(velocity);
                  if(1 - dot < 0.1)
                  {
                     this.shotStart(targetUnit);
                  }
               }
               else if(this.mShotState == 0)
               {
                  if(this.mDrillIsEnabled && this.mDrillState != 1)
                  {
                     if(this.mDrillState == 4)
                     {
                        this.drillSetState(0);
                     }
                  }
                  else
                  {
                     moveComp.goToPosition(targetUnit.mPosition);
                     this.movePause();
                     this.mShotState = 1;
                     mapModel.pathFinderResetRequestPath(mUnit.mId);
                  }
               }
               checkTarget = false;
            }
            else
            {
               if(this.mShotState > 0)
               {
                  this.shotFinish();
               }
               else if(checkTarget)
               {
                  checkTarget = targetUnit == null;
                  if(!checkTarget)
                  {
                     checkTarget = targetUnit.mDef.isABuilding() ? targetUnit.shotCanBeATarget() : true;
                  }
               }
               if(!checkTarget)
               {
                  checkTarget = moveComp.isStopped() && mCurrentState != 0;
               }
            }
            if(shotIsTypeBlast)
            {
               (coor = MyUnit.smCoor).x = u.mPosition.x;
               coor.y = u.mPosition.y;
               coor.z = 0;
               tileIndex = UnitScene.smViewMng.logicPosToTileIndex(coor);
               if((tileData = UnitScene.smMapModel.getTileDataFromIndex(tileIndex)) != null)
               {
                  if((baseItem = tileData.mBaseItem) != null)
                  {
                     if((targetUnit = baseItem.mUnit) != null && targetUnit.shotCanBeATarget())
                     {
                        this.checkTypeBlast(targetUnit);
                     }
                  }
               }
            }
         }
         if(checkTarget)
         {
            if((targetUnit = data[13]) != null && targetUnit.shotCanBeATarget())
            {
               changeState(1);
            }
            else
            {
               changeState(0);
            }
         }
         separateUnitsFromEachOther(true);
         if(this.mDrillIsEnabled)
         {
            this.drillLogicUpdate(dt);
         }
      }
      
      protected function checkTypeBlast(targetUnit:MyUnit) : void
      {
         mUnit.shotSetDamage(mUnit.mDef.getShotDamage());
         GoalBulletImpact.doImpact(mUnit,targetUnit,MyUnit.shotCreateUnitInfoObject(mUnit),-1);
         GoalBulletImpact.playEffects(mUnit,null,7);
      }
      
      override public function notify(e:Object) : void
      {
         var _loc2_:* = e.cmd;
         if("unitGoalTargetHasChanged" === _loc2_)
         {
            this.mCheckTargetTime = 0;
         }
      }
      
      override protected function logicUpdateRetreatingAfterWinning(dt:int) : void
      {
         super.logicUpdateRetreatingAfterWinning(dt);
      }
      
      private function moveReset() : void
      {
         this.mMoveHasArrivedTask = -1;
      }
      
      protected function moveArriveTarget() : void
      {
         if(false && this.mMoveMode == 3)
         {
            return;
         }
         var target:MyUnit = MyUnit(mUnit.mData[13]);
         this.mMoveMode = 3;
         this.mMoveHasArrivedTask = -1;
         var moveComp:UnitComponentMovement = mUnit.getMovementComponent();
         moveComp.arrive(target.mPosition.x,target.mPosition.y);
         if(false)
         {
            moveComp.mBehaviourWeights[7] = 1;
         }
         if(this.mDrillIsEnabled)
         {
            if(this.mDrillState == 1)
            {
               this.drillSetState(2);
            }
         }
      }
      
      protected function moveWander(target:Vector3D = null, distance:Number = 0, animId:String = "none", hasArrivedTask:int = -1) : void
      {
         this.mMoveMode = 1;
         if(this.mDrillIsEnabled && this.mDrillState != 1)
         {
            animId = "none";
         }
         else
         {
            animId = animId == "none" ? this.moveGetAnimId() : animId;
         }
         animSetId(animId);
         if(target == null)
         {
            this.mMoveHasArrivedTask = -1;
         }
         else
         {
            this.mMoveHasArrivedTask = hasArrivedTask == -1 ? this.mMoveHasArrivedTaskDefault : hasArrivedTask;
         }
         mUnit.getMovementComponent().wander(0.5);
      }
      
      override public function moveFollowPath(hasArrivedTask:int = -1) : void
      {
         this.mShotState = 0;
         if(this.mMoveMode != 2)
         {
            this.mMoveMode = 2;
            animSetId(this.moveGetAnimId());
         }
         this.mMoveHasArrivedTask = hasArrivedTask == -1 ? this.mMoveHasArrivedTaskDefault : hasArrivedTask;
      }
      
      override protected function moveStop(anim:String = "still", play:Boolean = true) : void
      {
         this.mMoveModePrevious = this.mMoveMode;
         this.mMoveMode = 0;
         mUnit.getMovementComponent().stop();
         var viewComponent:UnitComponentView = mUnit.getViewComponent();
         if(viewComponent != null)
         {
            this.mMoveAnimIdPrevious = viewComponent.getCurrentAnimId();
            if(mUnit.mDef.getAnimationDef().getAnimation(anim) != null)
            {
               animSetId(anim,play);
            }
            else
            {
               mUnit.getViewComponent().stop();
            }
         }
      }
      
      protected function movePause() : void
      {
         this.moveStop();
      }
      
      protected function moveResume() : void
      {
         if(this.mMoveMode == 0)
         {
            this.mMoveMode = this.mMoveModePrevious;
            mUnit.getMovementComponent().resume();
            if(mUnit.mDef.getAnimationDef().getAnimation("still") != null)
            {
               animSetId(this.mMoveAnimIdPrevious);
            }
            else
            {
               mUnit.getViewComponent().resume();
            }
         }
      }
      
      protected function moveGetAnimId() : String
      {
         return "running";
      }
      
      override protected function animDoSetId(animId:String, play:Boolean = true, loop:Boolean = true) : void
      {
         var frameId:int = -1;
         var viewComp:UnitComponentView = mUnit.getViewComponent();
         switch(animId)
         {
            case "walking":
               mUnit.getMovementComponent().setMaxSpeed(mUnit.mDef.getMaxSpeed() / 2);
               viewComp.setFrameRate(2);
               break;
            case "running":
               mUnit.getMovementComponent().setMaxSpeed(mUnit.mDef.getMaxSpeed());
               viewComp.setFrameRate(0);
               break;
            case "still":
               viewComp.setFrameRate(2);
               frameId = 0;
               break;
            case "shooting":
               viewComp.setFrameRate(2);
               break;
            case "jump":
               viewComp.setFrameRate(0);
               break;
            case "talk_left":
            case "talk_right":
               viewComp.setFrameRate(1);
         }
         viewComp.setAnimationId(animId,frameId,play,false,false,loop);
      }
      
      public function askPathToItem(target:WorldItemObject) : void
      {
         var mov:UnitComponentMovement = mUnit.getMovementComponent();
         if(mov != null)
         {
            mov.goToItem(target,null,false,null,false);
         }
      }
      
      public function askPathToUnit(unitTarget:MyUnit, itemFrom:WorldItemObject = null) : void
      {
         var itemTo:WorldItemObject = MyUnit.smUnitScene.mUnitsItems[unitTarget.mId];
         var target:Object = itemTo == null ? unitTarget : itemTo;
         MyUnit.smUnitScene.pathFinderRequestPath(mUnit,target,mUnit.mDef,false,null,true,true,itemFrom);
      }
      
      protected function shotReset() : void
      {
         if(this.mShotIsAllowed)
         {
            this.mShotIsEnabled = true;
         }
         this.mShotState = 0;
      }
      
      protected function shotStart(target:MyUnit) : void
      {
         this.mShotState = 2;
         var shotComp:UnitComponentShot = mUnit.getShotComponent();
         if(shotComp == null || !shotComp.mWaitForAnim)
         {
            animSetId("shooting");
         }
         mUnit.setLookingForATargetEnabled(false);
      }
      
      protected function shotFinish() : void
      {
         this.mShotState = 0;
         mUnit.setLookingForATargetEnabled(true);
      }
      
      protected function shotIsShooting() : Boolean
      {
         return this.mShotState == 0;
      }
      
      private function drillLoad() : void
      {
         var angleDegrees:Number = NaN;
         var angleRad:Number = NaN;
         var headingVector:Vector3D = null;
         if(smDrillHeadingAngleVectors == null)
         {
            smDrillHeadingAngleVectors = new Vector.<Vector3D>(0);
            smDrillHeadingProjectedVectors = new Vector.<Vector3D>(0);
            for each(angleDegrees in DRILL_UP_DOWN_ANGLE)
            {
               angleRad = DCMath.degree2Rad(angleDegrees);
               headingVector = new Vector3D(Math.cos(angleRad),-Math.sin(angleRad));
               smDrillHeadingAngleVectors.push(headingVector);
               headingVector = headingVector.clone();
               headingVector.scaleBy(50);
               smDrillHeadingProjectedVectors.push(headingVector);
            }
         }
      }
      
      private function drillSetState(newState:int) : void
      {
         var tempVect:Vector3D = null;
         var targetUnit:MyUnit = null;
         var coor:DCCoordinate = null;
         var target:Vector3D = null;
         var drillAnimId:int = 0;
         switch(this.mDrillState - 3)
         {
            case 0:
               tempVect = smDrillHeadingProjectedVectors[this.mDrillAngleId];
               mUnit.setPositionInViewSpace(mUnit.mPositionDrawX + tempVect.x,mUnit.mPositionDrawY + tempVect.y);
         }
         this.mDrillState = newState;
         var moveComp:UnitComponentMovement = mUnit.getMovementComponent();
         var viewComp:UnitComponentView = mUnit.getViewComponent();
         var frameRate:int = 1;
         var animId:String = String(DRILL_STATE_ANIM_ID[this.mDrillState]);
         switch(this.mDrillState)
         {
            case 0:
               this.movePause();
               if((targetUnit = mUnit.mData[3]) != null)
               {
                  (target = targetUnit.mPosition.clone()).decrementBy(mUnit.mPosition);
                  this.mDrillAngleId = 0;
                  tempVect = smDrillHeadingAngleVectors[this.mDrillAngleId];
                  coor = MyUnit.smCoor;
                  coor.x = tempVect.x;
                  coor.y = tempVect.y;
                  coor.z = 0;
                  UnitScene.smViewMng.viewPosToLogicPos(coor);
                  moveComp.resetBehaviours();
                  moveComp.mVelocity.x = coor.x;
                  moveComp.mVelocity.y = coor.y;
               }
            case 3:
               tempVect = smDrillHeadingProjectedVectors[this.mDrillAngleId];
               frameRate = 2;
               viewComp.setLoopMode(false);
               drillAnimId = this.mDrillAngleId;
               animId = String(DRILL_STATE_ANIM_ID[this.mDrillState] + DRILL_UP_DOWN_ANIM_SUFFIX_ID[drillAnimId]);
               break;
            case 1:
               viewComp.setLoopMode(true);
            case 4:
               if(this.mDrillLastParticlePos == null)
               {
                  this.mDrillLastParticlePos = mUnit.mPosition.clone();
               }
               break;
            case 2:
               this.mDrillAngleId = this.drillCalculateAngleId(moveComp.getHeading());
               tempVect = smDrillHeadingProjectedVectors[this.mDrillAngleId];
               coor = MyUnit.smCoor;
               coor.x = mUnit.mPositionDrawX + tempVect.x;
               coor.y = mUnit.mPositionDrawY + tempVect.y;
               coor.z = 0;
               UnitScene.smViewMng.viewPosToLogicPos(coor);
               target = new Vector3D(coor.x,coor.y,0);
               moveComp.goToPosition(target);
               if(this.mDrillToTarget == null)
               {
                  this.mDrillToTarget = new Vector3D();
               }
               this.mDrillToTarget.x = target.x;
               this.mDrillToTarget.y = target.y;
               this.mDrillToTarget.decrementBy(mUnit.mPosition);
               this.mDrillToTarget.normalize();
               this.movePause();
         }
         mUnit.mCanBeATarget = this.mDrillState == 1;
         this.mShotIsEnabled = this.mDrillState == 4 || this.mDrillState == 1;
         mUnit.liveBarSetVisible(mUnit.mCanBeATarget);
         if(animId != "none")
         {
            animSetId(animId,true,false);
            viewComp.setFrameRate(frameRate);
         }
      }
      
      private function drillLogicUpdate(dt:int) : void
      {
         var velocity:Vector3D = null;
         var dot:Number = NaN;
         var nextStateId:int = 0;
         var distanceSqr:Number = NaN;
         var viewComp:UnitComponentView = mUnit.getViewComponent();
         switch(this.mDrillState)
         {
            case 0:
            case 3:
               if(!viewComp.isPlayingAnimId(viewComp.getCurrentAnimId()))
               {
                  nextStateId = (this.mDrillState + 1) % 5;
                  this.drillSetState(nextStateId);
               }
               break;
            case 2:
               (velocity = mUnit.getMovementComponent().mVelocity).normalize();
               dot = this.mDrillToTarget.dotProduct(velocity);
               if(1 - dot < 0.1)
               {
                  this.drillSetState(3);
               }
               break;
            case 4:
               distanceSqr = DCMath.distanceSqr(this.mDrillLastParticlePos,mUnit.mPosition);
               if(distanceSqr > 1024)
               {
                  ParticleMng.addParticle(12,mUnit.mPositionDrawX,mUnit.mPositionDrawY);
                  this.mDrillLastParticlePos.x = mUnit.mPosition.x;
                  this.mDrillLastParticlePos.y = mUnit.mPosition.y;
                  break;
               }
         }
      }
      
      private function drillCalculateAngleId(target:Vector3D) : int
      {
         var dotProduct:Number = NaN;
         var i:int = 0;
         var angle:Number = NaN;
         var tempVect:Vector3D = null;
         var returnValue:* = 0;
         target.normalize();
         var lowestAngleSoFar:* = 1.7976931348623157e+308;
         for(i = 0; i < DRILL_UP_DOWN_ANGLES_COUNT; )
         {
            dotProduct = (tempVect = smDrillHeadingAngleVectors[i]).dotProduct(target);
            if((angle = Math.acos(dotProduct)) < lowestAngleSoFar)
            {
               lowestAngleSoFar = angle;
               returnValue = i;
            }
            i++;
         }
         return returnValue;
      }
   }
}
