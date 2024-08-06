package com.dchoc.game.model.unit
{
   import com.dchoc.game.controller.hangar.Bunker;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.rule.RuleMng;
   import com.dchoc.game.core.utils.collisionboxes.CollisionBoxMng;
   import com.dchoc.game.model.powerups.PowerUpDef;
   import com.dchoc.game.model.umbrella.UmbrellaMng;
   import com.dchoc.game.model.unit.components.UnitComponent;
   import com.dchoc.game.model.unit.components.goal.UnitComponentGoal;
   import com.dchoc.game.model.unit.components.movement.UnitComponentMovement;
   import com.dchoc.game.model.unit.components.shot.UnitComponentShot;
   import com.dchoc.game.model.unit.components.view.UnitComponentView;
   import com.dchoc.game.model.unit.components.view.UnitViewCustom;
   import com.dchoc.game.model.unit.defs.UnitDef;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.utils.anticheat.SecureBoolean;
   import com.dchoc.game.view.dc.mng.ViewMngPlanet;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.media.SoundManager;
   import com.dchoc.toolkit.core.view.display.DCBitmapMovieClip;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.core.view.display.DCDisplayObjectSWF;
   import com.dchoc.toolkit.utils.DCUtils;
   import com.dchoc.toolkit.utils.math.DCMath;
   import com.dchoc.toolkit.utils.math.geom.DCBox;
   import com.dchoc.toolkit.utils.math.geom.DCBoxWithTiles;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   
   public class MyUnit
   {
      
      public static var smUnitScene:UnitScene;
      
      public static var smCoor:DCCoordinate = new DCCoordinate();
      
      private static var smUmbrellaMng:UmbrellaMng;
      
      private static var smDamageLooterFactor:int = -1;
      
      public static const SPIN_NO_ANGLE:int = -1;
      
      public static const COMPONENT_MOVEMENT:int = 0;
      
      public static const COMPONENT_GOAL:int = 1;
      
      public static const COMPONENT_SHOT:int = 2;
      
      public static const COMPONENT_VIEW:int = 3;
      
      private static const LIVE_BAR_MAX_TIME:int = 10000;
      
      public static const DATA_COLLISION_NEAREST_UNIT:int = 1;
      
      public static const DATA_COLLISION_NEAREST_DISTANCE_SQR:int = 2;
      
      public static const DATA_COLLISION_NEAREST_SHOTABLE_UNIT:int = 3;
      
      public static const DATA_COLLISION_NEAREST_SHOTABLE_DISTANCE_SQR:int = 4;
      
      public static const DATA_COLLISION_NEAREST_BUILDING:int = 5;
      
      public static const DATA_COLLISION_NEAREST_BUILDING_DISTANCE_SQR:int = 6;
      
      public static const DATA_COLLISION_NEAREST_MOVING_UNIT:int = 7;
      
      public static const DATA_COLLISION_NEAREST_MOVING_UNIT_DISTANCE_SQR:int = 8;
      
      public static const DATA_BEST_SHOOT_UNIT:int = 9;
      
      public static const DATA_SHOT_CURRENT_TIME:int = 10;
      
      public static const DATA_SHOT_TIME_TO_WAIT:int = 11;
      
      public static const DATA_SHOT_TRAIL_CURRENT_TIME:int = 12;
      
      public static const DATA_UNIT_TARGET:int = 13;
      
      public static const DATA_UNIT_ENERGY_CURRENT:int = 14;
      
      public static const DATA_UNIT_ENERGY_LAST:int = 15;
      
      public static const DATA_TTL:int = 16;
      
      public static const DATA_SPIN_RATE:int = 17;
      
      public static const DATA_SPIN_CURRENT:int = 18;
      
      public static const DATA_SPIN_TARGET:int = 19;
      
      public static const DATA_LIVE_BAR_SHAPE:int = 20;
      
      public static const DATA_LIVE_BAR_DCDO:int = 21;
      
      public static const DATA_LIVE_BAR_MAX_SECTORS:int = 22;
      
      public static const DATA_LIVE_BAR_CURRENT_SECTORS:int = 23;
      
      public static const DATA_LIVE_BAR_ADDED:int = 24;
      
      public static const DATA_LIVE_BAR_OFFSET_Y:int = 25;
      
      public static const DATA_LIVE_BAR_TIMER:int = 26;
      
      public static const DATA_SHOT_DAMAGE:int = 27;
      
      public static const DATA_PARTICLE:int = 28;
      
      public static const DATA_PARTICLE_OFF_X:int = 29;
      
      public static const DATA_PARTICLE_OFF_Y:int = 30;
      
      public static const DATA_PURSUIT_DISTANCE:int = 31;
      
      public static const DATA_ANIM_CURRENT:int = 32;
      
      public static const DATA_LOOKING_FOR_A_TARGET_ENABLED:int = 33;
      
      public static const DATA_BUNKER:int = 34;
      
      public static const DATA_WIO:int = 35;
      
      public static const DATA_PRIORITY_ASKING_PATH:int = 36;
      
      public static const DATA_CAPTAIN:int = 37;
      
      public static const DATA_SHOT_PRIORITY_TARGET:int = 38;
      
      private static const LIVE_BAR_SECTOR_WIDTH:int = 5;
      
      private static const LIVE_BAR_HEIGHT:int = 5;
      
      private static const LIVE_BAR_COLORS:Array = GameConstants.UNIT_ENERGY_BAR_COLORS_UINT;
      
      private static const LIVE_BAR_COLORS_LENGTH:int = LIVE_BAR_COLORS.length;
      
      public static const EMOTICON_NONE:int = 0;
      
      public static const EMOTICON_ATTACK:int = 1;
      
      public static const EMOTICON_BIOHAZARD:int = 2;
      
      public static const EMOTICON_COIN:int = 3;
      
      public static const EMOTICON_DEFENSE:int = 4;
      
      public static const EMOTICON_DIGGING:int = 5;
      
      public static const EMOTICON_EXCLAMATION:int = 6;
      
      public static const EMOTICON_HUNGRY:int = 7;
      
      public static const EMOTICON_IDEA:int = 8;
      
      public static const EMOTICON_LOVE:int = 9;
      
      public static const EMOTICON_MINERAL:int = 10;
      
      public static const EMOTICON_PUZZLED:int = 11;
      
      public static const EMOTICON_READY:int = 12;
      
      public static const EMOTICON_SCARED:int = 13;
      
      public static const EMOTICON_SLEEPING:int = 14;
      
      public static const EMOTICON_WORK:int = 15;
      
      public static const EMOTICON_HAPPY:int = 16;
      
      public static const EMOTICON_SAD:int = 17;
      
      public static const EMOTICON_RAIN:int = 18;
      
      public static const EMOTICON_STORM:int = 19;
      
      public static const EMOTICON_ARMY:int = 20;
      
      public static const EMOTICON_DEATH:int = 21;
      
      public static const EMOTICON_ROSE:int = 22;
      
      public static var OFF:Number = 1;
      
      private static var smCheckIfTutorial:Boolean = true;
      
      public static const SLOW_DOWN_MOV_ID:int = 0;
      
      public static const SLOW_DOWN_SHOT_ID:int = 1;
      
      public static const SLOW_DOWN_COUNT:int = 2;
      
      private static const SLOW_DOWN_MAX_TIME:int = 30000;
      
      private static const SLOW_DOWN_PARAM_ID:Array = [2,3];
       
      
      private var mComponents:Array;
      
      public var mFaction:int = -1;
      
      public var mId:int;
      
      public var mDef:UnitDef;
      
      public var mPosition:Vector3D;
      
      public var mPositionDrawX:int;
      
      public var mPositionDrawY:int;
      
      public var mWasAddToScene:Boolean;
      
      public var mSecureIsInScene:SecureBoolean;
      
      public var mSecureIsAboutToExitScene:SecureBoolean;
      
      public var mIsAlive:Boolean;
      
      public var mUnitTimer:int;
      
      public var mEmoticon:int;
      
      public var mEmoticonTime:int;
      
      private var mEvent:Object;
      
      private var mHeading:Vector3D;
      
      public var mCanBeATarget:Boolean;
      
      public var mRefreshEnvironment:Boolean;
      
      public var mSceneSenseEnvironmentLevelId:int;
      
      private var mNeedsToSenseEnvironment:SecureBoolean;
      
      public var mData:Array;
      
      private var mLiveBarBlocked:Boolean = false;
      
      private var mOldLive:int = 0;
      
      private var mInitEnergyFromBunker:int;
      
      private var mGoalCurrentId:String;
      
      private var mGoalForCurrentId:String;
      
      private var mGoalItem:WorldItemObject;
      
      public var mSlowDownTime:int;
      
      public var mSlowDownCoefs:Array;
      
      public var mSlowDownType:String;
      
      public var mFromSpecialAttackId:int = -1;
      
      public function MyUnit(id:int)
      {
         mSecureIsInScene = new SecureBoolean("MyUnit.mSecureIsInScene");
         mSecureIsAboutToExitScene = new SecureBoolean("MyUnit.mSecureIsAboutToExitScene");
         mNeedsToSenseEnvironment = new SecureBoolean("MyUnit.mNeedsToSenseEnvironment");
         super();
         this.mId = id;
         this.load();
      }
      
      public static function setUnitEventListener(l:UnitScene) : void
      {
         smUnitScene = l;
      }
      
      public static function setUmbrellaMng(value:UmbrellaMng) : void
      {
         smUmbrellaMng = value;
      }
      
      public static function unloadStatic() : void
      {
         smUnitScene = null;
         smDamageLooterFactor = -1;
         smUmbrellaMng = null;
         smCheckIfTutorial = true;
      }
      
      public static function shotCreateUnitInfoObject(uFrom:MyUnit) : Object
      {
         var viewMng:ViewMngPlanet = null;
         var worldCoords:DCCoordinate = null;
         var tileCoords:DCCoordinate = null;
         if(uFrom == null)
         {
            return null;
         }
         var unitInfo:Object;
         (unitInfo = {}).sku = uFrom.mDef.mSku;
         if(uFrom.mData[35] != null)
         {
            unitInfo.type = "item";
            unitInfo.itemSid = uFrom.mData[35].mSid;
         }
         else
         {
            if(uFrom.mDef.getIsSpecialAttack())
            {
               unitInfo.type = "specialAttack";
               unitInfo.sku = InstanceMng.getSpecialAttacksDefMng().getSkuFromBulletType(unitInfo.sku);
               unitInfo.bullet = uFrom.mDef.mSku;
               unitInfo.specialAttackId = uFrom.mFromSpecialAttackId;
            }
            else
            {
               unitInfo.type = "unit";
               viewMng = UnitScene.smViewMng;
               worldCoords = new DCCoordinate(uFrom.mPositionDrawX,uFrom.mPositionDrawY + uFrom.mDef.mBoundingBoxOffY,0);
               tileCoords = viewMng.worldViewPosToTileRelativeXY(worldCoords);
               unitInfo.positionX = tileCoords.x;
               unitInfo.positionY = tileCoords.y;
            }
            unitInfo.unitId = uFrom.mId;
         }
         unitInfo.unit = uFrom;
         unitInfo.lootPercentage = uFrom.mDef.getLootPercentage();
         return unitInfo;
      }
      
      private function load() : void
      {
         this.mComponents = [];
         this.mData = [];
         this.reset();
      }
      
      public function unload() : void
      {
         var c:UnitComponent = null;
         this.mPosition = null;
         this.reset();
         for each(c in this.mComponents)
         {
            if(c != null)
            {
               c.unload();
            }
         }
         this.mEmoticon = 0;
         this.mComponents = null;
         this.mData = null;
         this.mHeading = null;
         this.mEvent = null;
      }
      
      public function build(def:UnitDef, faction:int, fromSpecialAttackId:int = -1) : void
      {
         this.mFaction = faction;
         this.mDef = def;
         this.mData[14] = 0;
         this.mData[15] = 0;
         if(this.mDef.getMaxEnergy() > 0)
         {
            this.mData[14] = this.mDef.getMaxEnergy();
            this.mData[15] = this.mData[14];
            this.mData[24] = false;
         }
         this.mData[26] = 10000;
         if(this.mDef.getTTL() > 0)
         {
            this.mData[16] = this.mDef.getTTL();
         }
         if(this.mDef.getSpinRate() != 0)
         {
            this.mData[17] = 0;
            this.mData[18] = 0;
            this.mData[19] = -1;
         }
         if(this.mData[28] == null)
         {
            this.mData[28] = null;
         }
         if(this.mDef.getPursuitDistance() > 0)
         {
            this.mData[31] = this.mDef.getPursuitDistance();
         }
         this.mUnitTimer = 0;
         this.mEmoticon = 0;
         this.mEmoticonTime = -1;
         this.buildComponents();
         this.mNeedsToSenseEnvironment.value = true;
         this.setCaptain(null);
         this.mFromSpecialAttackId = fromSpecialAttackId;
      }
      
      public function isBuilt() : Boolean
      {
         return this.mComponents != null;
      }
      
      private function buildComponents() : void
      {
         var c:UnitComponent = null;
         for each(c in this.mComponents)
         {
            if(c != null)
            {
               c.build(this.mDef,this);
            }
         }
      }
      
      public function buildViewComponent() : void
      {
         var c:UnitComponentView = this.getViewComponent();
         if(c != null)
         {
            c.build(this.mDef,this);
         }
      }
      
      public function isViewComponentBuilt() : Boolean
      {
         var c:UnitComponentView = this.getViewComponent();
         return c == null || c.isBuilt();
      }
      
      public function unbuild() : void
      {
         var c:UnitComponent = null;
         if(this.mData != null)
         {
            if(this.mData[21] != null)
            {
               this.liveBarSetVisible(false);
               this.mData[20] = null;
               this.mData[21] = null;
            }
            for each(c in this.mComponents)
            {
               if(c != null)
               {
                  c.unbuild(this);
               }
            }
            this.mData.length = 0;
         }
      }
      
      public function reset() : void
      {
         var c:UnitComponent = null;
         this.mWasAddToScene = false;
         this.mSecureIsInScene.value = false;
         this.mIsAlive = false;
         this.mSecureIsAboutToExitScene.value = false;
         this.mCanBeATarget = true;
         this.mEmoticon = 0;
         this.mEmoticonTime = -1;
         this.mSceneSenseEnvironmentLevelId = 0;
         this.mSlowDownTime = -1;
         this.mSlowDownCoefs = null;
         this.mPosition = new Vector3D();
         if(this.mData != null)
         {
            for each(c in this.mComponents)
            {
               if(c != null)
               {
                  c.reset(this);
               }
            }
            this.mData.length = 0;
         }
      }
      
      public function flip() : void
      {
      }
      
      public function liveBarSetVisible(value:Boolean, force:Boolean = false) : void
      {
         if(value && !force)
         {
            value = this.liveBarMustBeDrawn();
         }
         var isVisible:Boolean = this.liveBarGetVisible();
         if(isVisible && !value)
         {
            if(this.mData[21] != null)
            {
               InstanceMng.getViewMngPlanet().worldItemRemoveLiveBarFromStage(this.mData[21]);
            }
         }
         else if(!isVisible && value)
         {
            this.addLifeBarToUnit();
         }
         this.mData[24] = value;
      }
      
      public function liveBarGetVisible() : Boolean
      {
         return this.mData != null && this.mData[24] != null && this.mData[24] && !this.mDef.isAWall();
      }
      
      public function liveBarMustBeDrawn() : Boolean
      {
         return this.mIsAlive && this.mData[14] < this.mDef.getMaxEnergy() && this.mData[26] > 0 && !this.mDef.isAWall();
      }
      
      public function blockLiveBar(value:Boolean) : void
      {
         this.mLiveBarBlocked = value;
      }
      
      public function logicUpdate(dt:int) : void
      {
         var spinTarget:Number = NaN;
         var targetReached:* = false;
         var diff:Number = NaN;
         var signBefore:int = 0;
         var newAngle:Number = NaN;
         var c:UnitComponent = null;
         var p:Particle = null;
         var b:Boolean = false;
         var signAfter:int = 0;
         var time:int = 0;
         var viewComp:UnitComponentView;
         if((viewComp = this.getViewComponent()) != null && !viewComp.isBuilt())
         {
            viewComp.build(this.mDef,this);
            if(viewComp.isBuilt())
            {
               viewComp.addToScene();
            }
         }
         if(viewComp != null && this.goalGetCurrentId() == "unitGoalOnHangar" && InstanceMng.getUserInfoMng().getProfileLogin().getInvisibleHangarUnits())
         {
            viewComp.removeFromScene();
         }
         var oldSlowDownTime:int = this.mSlowDownTime;
         this.mSlowDownTime -= dt;
         if(oldSlowDownTime > 0 && this.mSlowDownTime <= 0)
         {
            this.slowDownUndoEffect();
         }
         this.mUnitTimer += dt;
         if(this.mSecureIsAboutToExitScene.value || this.mData == null)
         {
            this.mSecureIsInScene.value = false;
            return;
         }
         if(this.liveBarGetVisible())
         {
            if(InstanceMng.getRole().mId == 3)
            {
               this.mData[26] = Math.max(0,this.mData[26] - dt);
            }
            if(this.mData[21] == null)
            {
               this.addLifeBarToUnit();
            }
            if(!this.mLiveBarBlocked && this.mOldLive != this.getEnergy())
            {
               this.drawLiveBar();
            }
            if(!this.liveBarMustBeDrawn())
            {
               this.liveBarSetVisible(false);
            }
         }
         if(this.mData[28] != null)
         {
            if((p = this.mData[28]).mState == 0)
            {
               this.mData[28] = null;
            }
            else
            {
               p.mPosition.x = this.mPositionDrawX + this.mData[29];
               p.mPosition.y = this.mPositionDrawY + this.mData[30];
            }
         }
         if(this.mDef.getTTL() > 0)
         {
            this.mData[16] -= dt;
            if(this.mData[16] <= 0)
            {
               this.markToBeReleasedFromScene();
            }
         }
         var target:MyUnit;
         if((target = this.mData[13]) != null && !target.mIsAlive)
         {
            this.setUnitTarget(null);
         }
         if(this.mData[17] != null && this.mData[17] != 0)
         {
            spinTarget = Number(this.mData[19]);
            targetReached = false;
            if(spinTarget != -1)
            {
               if((diff = this.mData[18] - spinTarget) == 0)
               {
                  targetReached = true;
               }
               else
               {
                  signBefore = diff > 0 ? 1 : -1;
               }
            }
            newAngle = this.mData[18] + this.mData[17] * dt;
            if(target != null && target.mIsAlive)
            {
               this.spinSetAngle(newAngle);
            }
            if(spinTarget != -1)
            {
               if(!targetReached)
               {
                  if((diff = this.mData[18] - spinTarget) == 0)
                  {
                     targetReached = true;
                  }
                  else
                  {
                     signAfter = diff > 0 ? 1 : -1;
                     targetReached = signBefore != signAfter;
                  }
               }
               b = this.mData[17] <= 0 && this.mData[18] <= spinTarget || this.mData[17] > 0 && this.mData[18] >= spinTarget;
               if(targetReached && b)
               {
                  this.spinSetAngle(this.mData[19],true);
               }
            }
         }
         for each(c in this.mComponents)
         {
            if(c != null)
            {
               c.logicUpdate(dt,this);
            }
         }
         if(this.mData[10] != null)
         {
            if((time = int(this.mData[10])) > 0)
            {
               if((time -= dt * this.slowDownGetCoef(1)) < 0)
               {
                  time = 0;
               }
               this.mData[10] = time;
            }
         }
         if(this.mDef.shotCanBeATarget() && this.shotWasHit())
         {
            this.mData[15] = this.mData[14];
            this.addLifeBarToUnit();
            this.mData[26] = 10000;
         }
         this.updateEmoticon(dt);
      }
      
      public function addLifeBarToUnit() : void
      {
         if(this.mData[21] == null)
         {
            this.createLiveBar();
         }
         this.mData[24] = true;
         if(this.mData[21] != null)
         {
            if(UnitScene.smViewMng != null)
            {
               UnitScene.smViewMng.worldItemAddLiveBarToStage(this.mData[21]);
            }
         }
      }
      
      private function setComponent(key:int, c:UnitComponent) : void
      {
         if(this.mComponents != null)
         {
            this.mComponents[key] = c;
         }
      }
      
      public function getGoalComponent() : UnitComponentGoal
      {
         return this.mComponents == null ? null : this.mComponents[1];
      }
      
      public function setGoalComponent(goal:UnitComponentGoal, doActivate:Boolean = true) : void
      {
         var currentGoal:UnitComponentGoal = null;
         if(this.mComponents != null)
         {
            currentGoal = this.mComponents[1];
            if(currentGoal != null)
            {
               currentGoal.deactivate();
            }
            this.mComponents[1] = goal;
            if(goal != null)
            {
               if(doActivate)
               {
                  goal.activate();
               }
            }
         }
      }
      
      public function getMovementComponent() : UnitComponentMovement
      {
         return this.mComponents == null ? null : this.mComponents[0];
      }
      
      public function setMovementComponent(movement:UnitComponentMovement) : void
      {
         this.setComponent(0,movement);
      }
      
      public function getShotComponent() : UnitComponentShot
      {
         return this.mComponents == null ? null : this.mComponents[2];
      }
      
      public function setShotComponent(shot:UnitComponentShot) : void
      {
         this.setComponent(2,shot);
      }
      
      public function getViewComponent() : UnitComponentView
      {
         return this.mComponents == null ? null : this.mComponents[3];
      }
      
      public function setViewComponent(view:UnitComponentView) : void
      {
         this.setComponent(3,view);
      }
      
      public function getHeading(componentKey:int = -1, translateToView:Boolean = true) : Vector3D
      {
         var c:UnitComponent = null;
         var h:Vector3D = null;
         if(this.mHeading == null)
         {
            this.mHeading = new Vector3D();
         }
         if(this.mDef.getSpinRate() > 0)
         {
            this.mHeading.x = Math.cos(this.mData[18]);
            this.mHeading.y = -Math.sin(this.mData[18]);
            this.mHeading.z = 0;
            return this.mHeading;
         }
         if(componentKey > -1 && this.mComponents != null)
         {
            c = this.mComponents[componentKey];
            if((h = c != null ? c.getHeading() : null) != null)
            {
               this.mHeading.x = h.x;
               this.mHeading.y = h.y;
               this.mHeading.z = 0;
            }
            else
            {
               this.mHeading.x = 0;
               this.mHeading.y = 0;
               this.mHeading.z = 0;
            }
         }
         if(translateToView)
         {
            smCoor.x = this.mHeading.x;
            smCoor.y = this.mHeading.y;
            smCoor.z = 0;
            UnitScene.smViewMng.logicPosToViewPos(smCoor);
            this.mHeading.x = smCoor.x;
            this.mHeading.y = smCoor.y;
            this.mHeading.z = 0;
         }
         return this.mHeading;
      }
      
      public function getHeadingAngle(componentKey:int = -1) : Number
      {
         var c:UnitComponent = null;
         var heading:Vector3D = null;
         var returnValue:Number = 0;
         if(this.mDef.getSpinRate() > 0)
         {
            returnValue = Number(this.mData[18]);
         }
         else if(componentKey > -1 && this.mComponents != null)
         {
            c = this.mComponents[componentKey];
            if((heading = c != null ? c.getHeading() : null) != null)
            {
               returnValue = Math.atan2(heading.x,heading.y);
            }
         }
         return returnValue;
      }
      
      public function getBoundingRadiusSqr() : Number
      {
         return this.mDef.getBoundingRadiusSqr();
      }
      
      public function getBoundingRadius() : Number
      {
         return this.mDef.getBoundingRadius();
      }
      
      public function getPanicDistance() : Number
      {
         var c:UnitComponentMovement = this.getMovementComponent();
         return c != null ? c.mPanicDistance : this.mDef.getBoundingRadius();
      }
      
      public function spinSetRate(value:Number) : void
      {
         this.mData[17] = value;
      }
      
      public function spinStart() : void
      {
         this.mData[17] = this.mDef.getSpinRate();
      }
      
      public function spinEnd() : void
      {
         this.mData[17] = 0;
      }
      
      public function spinGetAngle() : Number
      {
         return this.mData[18];
      }
      
      public function spinSetAngle(value:Number, cancelSpin:Boolean = false) : void
      {
         if(value < 0)
         {
            value = DCMath.RAD_359 + value;
         }
         else if(value >= 6.283185307179586)
         {
            value -= 6.283185307179586;
         }
         this.mData[18] = value;
         if(cancelSpin)
         {
            this.spinEnd();
            this.spinSetTargetAngle(-1);
         }
      }
      
      public function spinSetTargetAngle(value:Number) : void
      {
         var spinRate:Number = NaN;
         if(this.mData[18] != value)
         {
            this.mData[19] = value;
            if(value != -1)
            {
               spinRate = DCMath.isClockwise(this.mData[18],this.mData[19]) ? -this.mDef.getSpinRate() : this.mDef.getSpinRate();
               this.spinSetRate(spinRate);
            }
         }
      }
      
      public function isLookingForATargetEnabled() : Boolean
      {
         return this.mData[33] == true;
      }
      
      public function setLookingForATargetEnabled(value:Boolean) : void
      {
         this.mData[33] = value;
      }
      
      public function getEnergy() : int
      {
         return this.mData[14];
      }
      
      public function setEnergy(value:int) : void
      {
         if(value < 0)
         {
            value = 0;
         }
         this.mData[14] = value;
         this.mData[15] = value;
      }
      
      public function setEnergyPercent(value:Number) : void
      {
         this.setEnergy(this.mDef.getEnergyFromPercentage(value));
      }
      
      public function getEnergyPercent() : Number
      {
         return this.mDef.getEnergyPercent(this.mData[14]);
      }
      
      public function addToScene() : void
      {
         this.mWasAddToScene = true;
         this.mSecureIsInScene.value = true;
         this.mIsAlive = true;
         var c:UnitComponentView = this.getViewComponent();
         if(c != null && !this.mDef.isABuilding())
         {
            c.addToScene();
         }
      }
      
      public function isInScene() : Boolean
      {
         return this.mSecureIsInScene.value;
      }
      
      public function markToBeReleasedFromScene() : void
      {
         this.mIsAlive = false;
         this.mSecureIsAboutToExitScene.value = true;
         this.shotStop();
      }
      
      public function removeFromScene() : void
      {
         var c:UnitComponentView = this.getViewComponent();
         if(c != null)
         {
            c.removeFromScene();
         }
         if(this.mData != null && this.mData[24] != null && this.mData[24])
         {
            UnitScene.smViewMng.worldItemRemoveLiveBarFromStage(this.mData[21]);
            this.mData[24] = false;
         }
      }
      
      public function setPosition(x:Number, y:Number) : void
      {
         var box:DCBox = null;
         var b:DCBoxWithTiles = null;
         this.mPosition.x = x;
         this.mPosition.y = y;
         smCoor.x = this.mPosition.x;
         smCoor.y = this.mPosition.y;
         var viewMng:ViewMngPlanet;
         (viewMng = UnitScene.smViewMng).logicPosToViewPos(smCoor);
         this.mPositionDrawX = smCoor.x;
         this.mPositionDrawY = smCoor.y;
         if(this.mDef.viewExtraUsesTurretPedestal())
         {
            this.mPositionDrawY -= 16;
         }
         var viewComponent:UnitComponentView;
         if((viewComponent = this.getViewComponent()) != null)
         {
            if((box = viewComponent.getBoundingBox()) != null)
            {
               smCoor.x = this.mPositionDrawX;
               smCoor.y = this.mPositionDrawY + this.mDef.mBoundingBoxOffY;
               viewMng.worldViewPosToTileXY(smCoor,true);
               b = DCBoxWithTiles(box);
               b.setTileXY(smCoor.x - b.mTilesWidth / 2,smCoor.y - b.mTilesHeight / 2);
            }
         }
         this.setLiveBarPos();
      }
      
      private function setLiveBarPos() : void
      {
         if(this.mData[21] != null && this.mData[24])
         {
            this.mData[21].x = this.mPositionDrawX - this.mData[20].width / 2;
            this.mData[21].y = this.mPositionDrawY + this.mData[25];
         }
      }
      
      public function setPositionInViewSpace(x:Number, y:Number) : void
      {
         smCoor.x = x;
         smCoor.y = y;
         smCoor.z = 0;
         UnitScene.smViewMng.viewPosToLogicPos(smCoor);
         this.setPosition(smCoor.x,smCoor.y);
      }
      
      public function setUnitTarget(target:MyUnit) : void
      {
         this.mData[13] = target;
         if(this.mData[31] != null)
         {
            this.mData[31] = this.mDef.getPursuitDistance();
         }
      }
      
      public function getTypeId() : int
      {
         return this.mDef.getUnitTypeId();
      }
      
      public function sendEvent(cmd:String, notifyUnit:Boolean = true, notifyScene:Boolean = true) : void
      {
         var c:UnitComponentGoal = null;
         switch(cmd)
         {
            case "unitEventEnterSceneImmediately":
               this.enterSceneStart(0);
               cmd = null;
               break;
            case "unitEventEnterSceneFadeIn":
               this.exitSceneStart(2);
               cmd = null;
               break;
            case "unitEventExitSceneImmediately":
               this.exitSceneStart(0);
               cmd = null;
               break;
            case "unitEventExitSceneFadeOut":
               this.exitSceneStart(1);
               cmd = null;
         }
         if(cmd != null)
         {
            if(this.mEvent == null)
            {
               this.mEvent = {};
               this.mEvent.unit = this;
            }
            this.mEvent.cmd = cmd;
            if(notifyUnit)
            {
               if((c = this.getGoalComponent()) != null)
               {
                  c.notify(this.mEvent);
               }
            }
            if(notifyScene)
            {
               smUnitScene.sceneNotify(this.mEvent);
            }
         }
      }
      
      public function enterSceneStart(mode:int = 0) : void
      {
         switch(mode)
         {
            case 0:
               this.viewFadeReset();
               this.viewSetVisible(true);
               this.mIsAlive = true;
               this.mSecureIsAboutToExitScene.value = false;
               break;
            case 2:
               this.viewFadeIn("unitEventEnterSceneImmediately");
               break;
            case 3:
               this.mPosition.z = -50;
         }
      }
      
      public function exitSceneStart(mode:int = 0) : void
      {
         switch(mode)
         {
            case 0:
               this.viewSetVisible(false);
               this.markToBeReleasedFromScene();
               break;
            case 1:
               this.viewFadeOut("unitEventExitSceneImmediately");
         }
         this.mIsAlive = false;
      }
      
      public function becomeBroken() : void
      {
         var c:UnitComponent = this.getGoalComponent();
         if(c != null)
         {
            this.mComponents[1] = null;
         }
      }
      
      public function isTakenIntoConsiderationInBattle(checkEnergy:Boolean) : Boolean
      {
         if(this.mDef.mSku == "sa_rocket" || this.mDef.mSku == "sa_freeze")
         {
            return true;
         }
         var item:WorldItemObject = this.mData[35];
         var returnValue:* = item == null || item.mDef.isTakenIntoConsiderationInBattle();
         if(returnValue && checkEnergy)
         {
            returnValue = this.getEnergy() > 0;
         }
         return returnValue;
      }
      
      public function getWorldItemObject() : WorldItemObject
      {
         return this.mData[35];
      }
      
      public function isAllowedToStepWalls() : Boolean
      {
         return this.mDef.canStepWalls() || this.mFaction != 0 && this.mDef.isTerrainUnit();
      }
      
      public function setNeedsToSenseEnvironment(value:Boolean) : void
      {
         this.mNeedsToSenseEnvironment.value = value;
         if(value)
         {
            this.mRefreshEnvironment = true;
         }
      }
      
      public function getNeedsToSenseEnvironment() : Boolean
      {
         return this.mNeedsToSenseEnvironment.value;
      }
      
      public function setCaptain(value:MyUnit) : void
      {
         this.mData[37] = value;
      }
      
      public function setShotPriorityTarget(value:String) : void
      {
         this.mData[38] = value;
      }
      
      public function getShotPriorityTarget() : String
      {
         return this.mData[38] == null ? this.mDef.getShotPriorityTarget() : this.mData[38];
      }
      
      public function goalGetCurrentId() : String
      {
         return this.mGoalCurrentId;
      }
      
      public function goalSetCurrentId(id:String, forId:String = null, item:WorldItemObject = null) : void
      {
         this.mGoalCurrentId = id;
         this.mGoalForCurrentId = forId;
         this.mGoalItem = item;
      }
      
      public function goalGetForCurrentId() : String
      {
         return this.mGoalForCurrentId;
      }
      
      public function goalSetForCurrentId(value:String) : void
      {
         this.mGoalForCurrentId = value;
      }
      
      public function goalGetItem() : WorldItemObject
      {
         return this.mGoalItem;
      }
      
      public function goalSetItem(item:WorldItemObject) : void
      {
         this.mGoalItem = item;
      }
      
      public function movementSetTarget(target:Vector3D) : void
      {
         var c:UnitComponentMovement = this.getMovementComponent();
         if(c != null)
         {
            c.setTarget(target);
         }
      }
      
      public function movementSetTargetUnitMobile(u:MyUnit) : void
      {
         var c:UnitComponentMovement = this.getMovementComponent();
         if(c != null && u.getMovementComponent() != null)
         {
            c.setTargetUnitMobile(u);
         }
      }
      
      public function movementGoToPosition(pos:Vector3D, distance:Number = 0, cmd:String = null) : void
      {
         var c:UnitComponentMovement;
         if((c = this.getMovementComponent()) != null)
         {
            c.goToPosition(pos,distance,cmd);
         }
         else if(Config.DEBUG_ASSERTS)
         {
            DCDebug.trace("WARNING in Unit.movementGoToPosition(): movement component hasn\'t been assigned yet.",1);
         }
      }
      
      public function movementFollowPath(path:Path, setAtFirsPosition:Boolean = false, cmdOnArrive:String = null) : void
      {
         var c:UnitComponentMovement;
         if((c = this.getMovementComponent()) != null)
         {
            c.followPath(path,setAtFirsPosition,cmdOnArrive);
         }
         else if(Config.DEBUG_ASSERTS)
         {
            DCDebug.trace("WARNING in Unit.movementFollowPath(): movement component hasn\'t been assigned yet.",1);
         }
      }
      
      public function movementIsFollowingAPath() : Boolean
      {
         var c:UnitComponentMovement = this.getMovementComponent();
         var returnValue:* = c != null;
         if(returnValue)
         {
            returnValue = c.mBehaviourWeights[9] > 0;
         }
         return returnValue;
      }
      
      public function movementReversePath() : void
      {
         var c:UnitComponentMovement = this.getMovementComponent();
         if(c != null)
         {
            c.reversePath();
         }
         else if(Config.DEBUG_ASSERTS)
         {
            DCDebug.trace("WARNING in Unit.setPath(): movement component hasn\'t been assigned yet.",1);
         }
      }
      
      public function movementWanderToPosition(target:Vector3D, distance:Number = 0, cmdOnArrive:String = null) : void
      {
         var c:UnitComponentMovement;
         if((c = this.getMovementComponent()) != null)
         {
            c.wanderToPosition(target,distance,cmdOnArrive);
         }
         else if(Config.DEBUG_ASSERTS)
         {
            DCDebug.trace("WARNING in Unit.movementWanderToPosition(): movement component hasn\'t been assigned yet.",1);
         }
      }
      
      public function movementGetVelocity() : Vector3D
      {
         var c:UnitComponentMovement = this.getMovementComponent();
         if(c != null)
         {
            return c.mVelocity;
         }
         if(Config.DEBUG_ASSERTS)
         {
            DCDebug.trace("WARNING in Unit.movementGetVelocity(): movement component hasn\'t been assigned yet.",1);
         }
         return null;
      }
      
      public function movementSetVelocity(x:Number, y:Number, z:Number) : void
      {
         var c:UnitComponentMovement;
         if((c = this.getMovementComponent()) != null)
         {
            c.setVelocity(x,y,z);
         }
         else if(Config.DEBUG_ASSERTS)
         {
            DCDebug.trace("WARNING in Unit.movementSetVelocity(): movement component hasn\'t been assigned yet.",1);
         }
      }
      
      public function movementSetAcceleration(x:Number, y:Number, z:Number) : void
      {
         var c:UnitComponentMovement;
         if((c = this.getMovementComponent()) != null)
         {
            c.mAcceleration.x = x;
            c.mAcceleration.y = y;
            c.mAccelerationZ = z;
         }
         else if(Config.DEBUG_ASSERTS)
         {
            DCDebug.trace("WARNING in Unit.movementSetAcceleration(): movement component hasn\'t been assigned yet.",1);
         }
      }
      
      public function movementStop() : void
      {
         var c:UnitComponentMovement = this.getMovementComponent();
         if(c != null)
         {
            c.stop();
         }
      }
      
      public function movementResume() : void
      {
         var c:UnitComponentMovement = this.getMovementComponent();
         if(c != null)
         {
            c.resume();
         }
      }
      
      public function shotCanBeATarget(checkCurrentEnergy:Boolean = true) : Boolean
      {
         var ret:Boolean = this.mDef.shotCanBeATarget() && this.mDef.getMaxEnergy() > 0;
         if(checkCurrentEnergy && ret)
         {
            ret = this.mIsAlive && this.mData[14] > 0 && this.mCanBeATarget;
         }
         return ret;
      }
      
      public function shotShoot(target:MyUnit) : Boolean
      {
         var returnValue:Boolean = false;
         var c:UnitComponentShot = this.getShotComponent();
         if(c != null)
         {
            returnValue = c.shoot(this,target);
         }
         else if(Config.DEBUG_ASSERTS)
         {
            DCDebug.trace("WARNING in Unit.shoot(): movement component hasn\'t been assigned yet.",1);
         }
         return returnValue;
      }
      
      public function shotWasHit() : Boolean
      {
         return this.mData[15] > this.mData[14];
      }
      
      public function shotHit(damage:int, uFromInfo:Object, showSmallExplosion:Boolean = false, shotType:String = null, impactEffect:int = -1) : void
      {
         var uFrom:MyUnit = null;
         var params:Array = null;
         var profAttackedId:String = null;
         var needsToUpdateMissionsProgress:Boolean = false;
         var random:int = 0;
         var originalDamage:* = 0;
         var continueWithAttack:Boolean = false;
         var tVictim:Transaction = null;
         var tAttacker:Transaction = null;
         var ruleMng:RuleMng = null;
         var item:WorldItemObject = null;
         var isDestroyed:* = false;
         var battleMode:int = 0;
         var powerUpDef:PowerUpDef = null;
         var unitSku:String = null;
         var lootDamage:* = 0;
         var coinsLooted:int = 0;
         var mineralsLooted:int = 0;
         var str:String = null;
         var bunkerContent:Object = null;
         var bunker:Bunker = null;
         var fromBunkerSid:int = 0;
         var wio:WorldItemObject = null;
         var score:Number = NaN;
         var roleId:int = 0;
         var accIdProfileAttacked:String = null;
         var bRadius:Number = NaN;
         var type:* = 0;
         var def:UnitDef = null;
         var snd:String = null;
         if(smCheckIfTutorial)
         {
            if(InstanceMng.getFlowStatePlanet().isTutorialRunning() && InstanceMng.getUnitScene().battleGetMode() == 5)
            {
               if(this.mFaction == 1 && this.mData[14] < damage * 3)
               {
                  return;
               }
            }
            else
            {
               smCheckIfTutorial = false;
            }
         }
         if(smUnitScene.battleIsRunning(true) && this.mIsAlive && this.mData[14] > 0)
         {
            uFrom = null;
            if(uFromInfo != null)
            {
               uFrom = uFromInfo.unit;
            }
            if(uFrom != null)
            {
               if((params = uFrom.mDef.shotEffectsGetSlowDownParams()) != null)
               {
                  this.slowDownDoEffect(params);
               }
            }
            if(uFrom == null || uFrom.mDef.shotEffectsIsEnergyOn())
            {
               profAttackedId = InstanceMng.getUserInfoMng().getCurrentProfileLoaded().getUserInfoObj().getAccountId();
               needsToUpdateMissionsProgress = smUnitScene.needsToUpdateMissionsProgress();
               random = Math.random() * 100;
               if(shotType == "death003")
               {
                  shotType = random < 50 ? "death003" : "death006";
               }
               else if(shotType == "deathrandom")
               {
                  if(random < 33)
                  {
                     shotType = "death002";
                  }
                  else if(random < 66)
                  {
                     shotType = "death004";
                  }
                  else
                  {
                     shotType = "death001";
                  }
               }
               if(uFromInfo != null)
               {
                  if(uFrom != null)
                  {
                     if(uFrom.mDef.isALooter() && smUnitScene.unitsGetShootPriorityKey(this) == "resources")
                     {
                        if(smDamageLooterFactor == -1)
                        {
                           smDamageLooterFactor = InstanceMng.getSettingsDefMng().getLootDamageFactor();
                        }
                        damage *= smDamageLooterFactor;
                     }
                     if((this.mDef.getUnitTypeId() == 7 || this.mDef.getUnitTypeId() == 2) && uFrom.mDef.getAmmoSku() == "b_laser_001")
                     {
                        damage *= 2;
                     }
                     if(Config.usePowerUps())
                     {
                        if((powerUpDef = UnitScene.smPowerUpMng.unitsGetPowerUpDefByType(uFrom.mDef.mSku,"turretsExtraDamage",uFrom.mFaction)) != null)
                        {
                           damage = powerUpDef.getValueWithExtra(damage);
                           uFromInfo.powerUpSkus = UnitScene.smPowerUpMng.unitsGetPowerUpSkusActiveByUnitSku(uFrom.mDef.mSku,uFrom.mFaction);
                        }
                        if((powerUpDef = UnitScene.smPowerUpMng.unitsGetPowerUpDefByType(this.mDef.mSku,"turretsExtraHealth",this.mFaction)) != null)
                        {
                           damage *= 1 - powerUpDef.getExtra() / 100;
                        }
                     }
                  }
               }
               originalDamage = damage;
               continueWithAttack = true;
               if(this.mFaction == 1 && smUmbrellaMng != null)
               {
                  if(smUmbrellaMng.needsToSkipThisAttack(this,uFrom))
                  {
                     continueWithAttack = false;
                  }
                  else if(smUmbrellaMng.isUnitProtected(this))
                  {
                     damage = smUmbrellaMng.absorbDamage(damage);
                  }
               }
               if(!continueWithAttack)
               {
                  return;
               }
               if(this.mData[14] - damage > this.mDef.getMaxEnergy())
               {
                  damage = this.mData[14] - this.mDef.getMaxEnergy();
               }
               if(uFromInfo != null)
               {
                  if((unitSku = String(uFromInfo.sku)) != null && needsToUpdateMissionsProgress)
                  {
                     InstanceMng.getTargetMng().updateProgress("damageCaused",damage,unitSku,profAttackedId);
                  }
               }
               this.mData[15] = this.mData[14];
               this.mData[14] -= damage;
               ruleMng = InstanceMng.getRuleMng();
               item = this.mData[35];
               isDestroyed = this.mData[14] <= 0;
               battleMode = smUnitScene.battleGetMode();
               if(item != null)
               {
                  if(damage > 0 && (battleMode == 0 || battleMode == 6 || battleMode == 5))
                  {
                     lootDamage = damage;
                     if(uFromInfo != null)
                     {
                        lootDamage = Math.floor(lootDamage * uFromInfo.lootPercentage / 100);
                     }
                     tVictim = ruleMng.getTransactionBattleResourceDamage(item,lootDamage,this.mData[14]);
                     if(battleMode == 6 || battleMode == 5)
                     {
                        if(ruleMng.battleAffectsProfile(item))
                        {
                           tVictim.performAllTransactions(true);
                        }
                        else
                        {
                           tVictim.setTransCoins(0);
                           tVictim.setTransMinerals(0);
                        }
                        tAttacker = ruleMng.getTransactionAttackerFromTransactionVictim(item,tVictim,isDestroyed,null);
                     }
                     else if(tVictim != null)
                     {
                        if(needsToUpdateMissionsProgress)
                        {
                           coinsLooted = tVictim.getTransCoins();
                           mineralsLooted = tVictim.getTransMinerals();
                           if(Math.abs(coinsLooted) > 0)
                           {
                              InstanceMng.getTargetMng().updateProgress("loot",Math.abs(coinsLooted),"coins",profAttackedId);
                           }
                           if(Math.abs(mineralsLooted) > 0)
                           {
                              InstanceMng.getTargetMng().updateProgress("loot",Math.abs(mineralsLooted),"minerals",profAttackedId);
                           }
                        }
                        if(smUnitScene.replayIsEnabled())
                        {
                           if((tAttacker = ruleMng.getTransactionAttackerFromTransactionVictim(item,tVictim,isDestroyed,smUnitScene.replayGetProfile())) != null)
                           {
                              tAttacker.performAllTransactions(true);
                           }
                        }
                        else
                        {
                           tAttacker = ruleMng.applyTransactionBattleResourceDamage(item,tVictim,isDestroyed);
                        }
                     }
                  }
                  if(Config.DEBUG_MODE)
                  {
                     str = "item " + item.mSid + " receive " + damage;
                     if(tVictim != null)
                     {
                        str += " tVictim.coins = " + tVictim.getTransCoins() + " tVictim.minerals = " + tVictim.getTransMinerals();
                     }
                     if(tAttacker != null)
                     {
                        str += " tAttacker.coins = " + tAttacker.getTransCoins() + " tAttacker.minerals = " + tAttacker.getTransMinerals();
                     }
                  }
                  if(item.mDef.isABunker() && isDestroyed)
                  {
                     bunkerContent = {};
                     if((bunker = Bunker(InstanceMng.getBunkerController().getFromSid(item.mSid))) != null && !bunker.isEmpty())
                     {
                        bunkerContent = bunker.getUnitsContent();
                     }
                  }
                  smUnitScene.mServerUserDataMngRef.updateBattle_itemDamaged(int(item.mSid),damage,originalDamage - damage,isDestroyed,this.mData[15],uFromInfo,tVictim,tAttacker,bunkerContent);
               }
               else
               {
                  fromBunkerSid = -1;
                  if(this.mData[34] != null)
                  {
                     if((wio = (bunker = this.mData[34]).getWIO()) != null)
                     {
                        fromBunkerSid = int(wio.mSid);
                     }
                  }
                  if(isDestroyed)
                  {
                     score = 0;
                     if((roleId = InstanceMng.getRole().mId) == 3 && this.mFaction == 1)
                     {
                        score = this.mDef.getScoreAttack();
                        if(this.mDef.getTypeId() == 8)
                        {
                           score += (this as Bunker).getUnitsScoreAttack();
                        }
                     }
                     else if(roleId != 3 && this.mFaction == 0)
                     {
                        score = this.mDef.getScoreDefense();
                     }
                     if(score != 0)
                     {
                        (tAttacker = ruleMng.createSingleTransaction(false)).setTransScore(score);
                        if(battleMode == 6 || battleMode == 5)
                        {
                           tAttacker.performAllTransactions(true);
                        }
                     }
                  }
                  smUnitScene.mServerUserDataMngRef.updateBattle_unitDamaged(this.mId,fromBunkerSid,damage,this.mDef.mSku,isDestroyed,this.mData[15],uFromInfo,tAttacker);
               }
               if(damage > 0)
               {
                  smUnitScene.battleEventsNotifyUnitWasHit(this,damage,tAttacker);
               }
               if(isDestroyed)
               {
                  this.mData[14] = 0;
                  if(shotType == null)
                  {
                     shotType = "death001";
                  }
                  this.shotDie(shotType);
                  if(shotType == "death003" && showSmallExplosion && !this.mDef.isAWall())
                  {
                     ParticleMng.addParticle(7,this.mPositionDrawX,this.mPositionDrawY,1);
                  }
                  if(needsToUpdateMissionsProgress)
                  {
                     accIdProfileAttacked = InstanceMng.getUserInfoMng().getCurrentProfileLoaded().getAccountId();
                     InstanceMng.getTargetMng().updateProgress("killEnemyUnit",1,this.mDef.mSku,accIdProfileAttacked,this.mDef.getUpgradeId());
                  }
                  if(item != null && item.mDef.isHeadQuarters())
                  {
                     InstanceMng.getWorld().notify({"cmd":"ATTACK_NOTIFICATION_HQ_DESTROYED"});
                  }
               }
               if(showSmallExplosion)
               {
                  bRadius = this.getBoundingRadius();
                  type = 8 + Math.random() * 3;
                  if(impactEffect > -1)
                  {
                     type = impactEffect;
                  }
                  this.mData[29] = bRadius * Math.random() / 2 - bRadius * Math.random() / 2;
                  this.mData[30] = bRadius * Math.random() / 2 - bRadius * Math.random() / 2;
                  this.mData[28] = ParticleMng.addParticle(type,this.mPositionDrawX + this.mData[29],this.mPositionDrawY + this.mData[30],0);
               }
               if(item != null)
               {
                  item.absorbImpactStart();
               }
            }
            if(Config.USE_SOUNDS)
            {
               if((def = uFrom.mDef).getAutoPlaySound())
               {
                  if((snd = def.getSndShot()) == null && !showSmallExplosion)
                  {
                     snd = "explode.mp3";
                  }
                  SoundManager.getInstance().playSound(snd);
               }
            }
         }
      }
      
      public function shotGetDamage() : int
      {
         return this.mData[27];
      }
      
      public function shotSetDamage(value:int) : void
      {
         this.mData[27] = value;
      }
      
      public function shotDie(type:String) : void
      {
         var score:Number = NaN;
         var roleId:int = 0;
         this.mIsAlive = false;
         this.setNeedsToSenseEnvironment(false);
         var g:UnitComponentGoal = this.getGoalComponent();
         var shotComp:UnitComponentShot = this.getShotComponent();
         if(shotComp != null)
         {
            shotComp.stopShot();
         }
         if(g == null)
         {
            this.markToBeReleasedFromScene();
         }
         else
         {
            g.die(type);
         }
         if(this.mSlowDownTime > 0)
         {
            this.slowDownUndoEffect();
         }
         if(this.mData[35] == null)
         {
            score = 0;
            if((roleId = InstanceMng.getRole().mId) == 3 && this.mFaction == 1)
            {
               score = InstanceMng.getRuleMng().getScoreAttackFromValue(this.mDef.getScoreAttack());
            }
            else if(roleId != 3 && this.mFaction == 0)
            {
               score = InstanceMng.getRuleMng().getScoreDefenseFromValue(this.mDef.getScoreDefense());
            }
            if(score != 0)
            {
               ParticleMng.launchParticle(6,score,null,1,this.mPositionDrawX,this.mPositionDrawY,true);
            }
         }
         this.sendEvent("unitEventKilled",false);
         var isABuildingAndAttacking:Boolean = this.mDef.isABuilding() && InstanceMng.getRole().mId == 3;
         var wio:WorldItemObject;
         if((wio = this.mData[35]) != null)
         {
            wio.updateEnergy();
            if(isABuildingAndAttacking)
            {
               InstanceMng.getItemsMng().getCollectionItemsParticleByAction(this.mDef.mSku,"destroy",this.mPositionDrawX,this.mPositionDrawY,wio.mUpgradeId,InstanceMng.getUserInfoMng().getCurrentProfileLoaded().getAccountId());
            }
            if(this.mDef.needsToBeRemovedAfterDying())
            {
               smUnitScene.mServerUserDataMngRef.updateBattle_itemMineExploded(int(wio.mSid));
               InstanceMng.getWorld().itemsUnplaceItem(wio,false);
            }
         }
      }
      
      public function shotStop() : void
      {
         var s:UnitComponentShot = this.getShotComponent();
         if(s != null)
         {
            s.stopShot();
         }
      }
      
      public function viewSetVisible(value:Boolean) : void
      {
         var c:UnitComponentView = this.getViewComponent();
         if(c != null)
         {
            c.setVisible(value);
         }
      }
      
      public function viewFadeReset() : void
      {
         var c:UnitComponentView = this.getViewComponent();
         if(c != null)
         {
            c.fadeReset();
         }
      }
      
      public function viewFadeIn(event:String) : void
      {
         var c:UnitComponentView = this.getViewComponent();
         if(c != null)
         {
            c.fadeIn(event);
         }
      }
      
      public function viewFadeOut(event:String) : void
      {
         var c:UnitComponentView = this.getViewComponent();
         if(c != null)
         {
            c.fadeOut(event);
         }
      }
      
      public function viewSetAnimationId(id:String) : void
      {
         var c:UnitComponentView = this.getViewComponent();
         if(c != null)
         {
            c.setAnimationId(id);
         }
         this.mData[32] = id;
      }
      
      private function createLiveBar() : void
      {
         var renderData:DCBitmapMovieClip = null;
         var bounds:Rectangle = null;
         var collisionBoxMng:CollisionBoxMng = null;
         var cData:Object = null;
         var cDataY:int = 0;
         if(!this.mDef.isABuilding())
         {
            this.mData[22] = 4;
            renderData = this.getViewComponent().getCurrentRenderData();
            if(renderData == null)
            {
               return;
            }
            bounds = this.getViewComponent().getCurrentRenderData().getOriginalBounds();
            this.mData[25] = bounds.y - 5;
         }
         else
         {
            collisionBoxMng = InstanceMng.getCollisionBoxMng();
            cDataY = ((cData = collisionBoxMng.getCollisionBoxByName(collisionBoxMng.getCollisionBoxSkuForDef(WorldItemDef(this.mDef)),"bar")) == null ? 0 : cData.y) + WorldItemDef(this.mDef).getBaseCols() * InstanceMng.getMapViewPlanet().getTileViewHeight() / 2;
            if(cData == null)
            {
               return;
            }
            this.mData[22] = 10;
            this.mData[25] = cDataY + this.mDef.getLifeBarOffY() - 5;
         }
         if(this.mData[20] == null)
         {
            this.mData[20] = new Shape();
         }
         this.mData[21] = new DCDisplayObjectSWF(this.mData[20]);
      }
      
      public function drawLiveBar() : void
      {
         var currentEnergy:int = 0;
         var shape:Shape = this.mData[20];
         if(shape != null)
         {
            currentEnergy = DCUtils.drawEnergyBar(this.getEnergy(),this.mDef.getMaxEnergy(),this.mData[20].graphics,this.mData[22],5,5,LIVE_BAR_COLORS);
            this.setLiveBarPos();
            this.mOldLive = currentEnergy;
         }
      }
      
      public function goToItem(itemTo:WorldItemObject, itemFrom:WorldItemObject = null) : void
      {
         var c:UnitComponentGoal = this.getGoalComponent();
         if(c != null)
         {
            c.goToItem(itemTo,itemFrom);
         }
      }
      
      public function getIsAlive() : Boolean
      {
         return this.mData != null && (!this.mWasAddToScene || this.mIsAlive && this.getEnergy() > 0);
      }
      
      public function isFlipped() : Boolean
      {
         var item:WorldItemObject = this.mData[35];
         if(item != null)
         {
            return item.mIsFlipped;
         }
         return false;
      }
      
      public function showEmoticon(emoticon:int, showtime:int = -1) : void
      {
         this.mEmoticon = emoticon;
         this.mEmoticonTime = showtime;
      }
      
      private function updateEmoticon(dt:int) : void
      {
         if(this.mEmoticonTime >= 0)
         {
            this.mEmoticonTime -= dt;
            if(this.mEmoticonTime < 0)
            {
               this.mEmoticon = 0;
            }
         }
      }
      
      public function slowDownGetCoef(id:int) : Number
      {
         return this.mSlowDownCoefs == null ? 1 : Number(this.mSlowDownCoefs[id]);
      }
      
      public function slowDownDoEffect(params:Array) : void
      {
         var i:int = 0;
         var oldCoef:Number = NaN;
         var coef:* = NaN;
         var colorTransform:ColorTransform = null;
         var mov:UnitComponentMovement = null;
         var maxSpeed:Number = NaN;
         if(this.mSlowDownCoefs == null)
         {
            this.mSlowDownCoefs = new Array(2);
            for(i = 0; i < 2; )
            {
               this.mSlowDownCoefs[i] = 1;
               i++;
            }
         }
         var time:int = int(params[1]);
         if(this.mSlowDownTime <= -1)
         {
            this.mSlowDownTime = time;
            this.mSlowDownType = params[4];
            switch(this.mSlowDownType)
            {
               case "stun":
                  InstanceMng.getUnitScene().effectsSwitch(this,5,true);
                  break;
               case "freeze":
               default:
                  colorTransform = DCUtils.setInk(DCUtils.smColorTransformInit,16777215,0.35);
                  this.applyFilter(colorTransform);
            }
         }
         else
         {
            this.mSlowDownTime += time;
         }
         if(this.mSlowDownTime > 30000)
         {
            this.mSlowDownTime = 30000;
         }
         i = 0;
         while(i < 2)
         {
            coef = Number(params[SLOW_DOWN_PARAM_ID[i]]);
            oldCoef = Number(this.mSlowDownCoefs[i]);
            if(oldCoef < coef)
            {
               coef = oldCoef;
            }
            this.mSlowDownCoefs[i] = coef;
            if(i == 0)
            {
               if((mov = this.getMovementComponent()) != null)
               {
                  maxSpeed = mov.getMaxSpeed();
                  if(oldCoef != coef)
                  {
                     mov.setMaxSpeed(oldCoef == 0 ? 0 : maxSpeed / oldCoef);
                  }
               }
            }
            i++;
         }
      }
      
      public function slowDownUndoEffect() : void
      {
         var id:int = 0;
         var oldCoef:Number = NaN;
         var mov:UnitComponentMovement = null;
         this.mSlowDownTime = -1;
         switch(this.mSlowDownType)
         {
            case "stun":
               InstanceMng.getUnitScene().effectsSwitch(this,5,false);
               break;
            case "freeze":
            default:
               this.applyFilter(DCUtils.smColorTransformInit);
         }
         this.mSlowDownType = "";
         for(id = 0; id < 2; )
         {
            oldCoef = Number(this.mSlowDownCoefs[id]);
            this.mSlowDownCoefs[id] = 1;
            if(id == 0)
            {
               mov = this.getMovementComponent();
               if(mov != null)
               {
                  mov.setMaxSpeed(oldCoef == 0 ? mov.mMaxSpeed : mov.mMaxSpeed / oldCoef);
               }
            }
            id++;
         }
      }
      
      private function applyFilter(color:ColorTransform) : void
      {
         var renderData:DCBitmapMovieClip = null;
         var unitViewCustom:UnitViewCustom = this.getViewComponent() as UnitViewCustom;
         if(unitViewCustom != null)
         {
            renderData = unitViewCustom.mCustomRenderData;
            if(renderData != null)
            {
               renderData.getDisplayObject().transform.colorTransform = color;
            }
         }
      }
      
      private function getDisplayObjectsForBurnFilter() : Vector.<DisplayObject>
      {
         var renderData:DCBitmapMovieClip = null;
         var dispObj:* = null;
         var unitViewCustom:UnitViewCustom = this.getViewComponent() as UnitViewCustom;
         var dispObjects:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
         if(unitViewCustom != null)
         {
            if((renderData = unitViewCustom.mCustomRenderData) != null)
            {
               dispObjects.push(renderData.getDisplayObject());
            }
         }
         var returnValue:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
         var wio:WorldItemObject;
         if((wio = this.mData[35]) != null)
         {
            for each(var DCDispObj in wio.getDisplayObjectsForFilter())
            {
               if(DCDispObj != null && DCDispObj.getDisplayObject() != null)
               {
                  returnValue.push(DCDispObj.getDisplayObject());
               }
            }
         }
         for each(dispObj in dispObjects)
         {
            if(dispObj != null)
            {
               returnValue.push(dispObj);
            }
         }
         return returnValue;
      }
      
      public function applyBurnFilter(color:uint) : void
      {
         var dispObj:* = null;
         var glowFilter:GlowFilter = GameConstants.FILTER_GLOW_BURN;
         glowFilter.color = color;
         var colorTransform:ColorTransform = DCUtils.setInk(DCUtils.smColorTransformInit,color,0.4);
         for each(dispObj in this.getDisplayObjectsForBurnFilter())
         {
            dispObj.filters = [glowFilter];
            dispObj.transform.colorTransform = colorTransform;
         }
      }
      
      public function removeBurnFilter() : void
      {
         var dispObj:* = null;
         for each(dispObj in this.getDisplayObjectsForBurnFilter())
         {
            dispObj.filters = [];
            dispObj.transform.colorTransform = DCUtils.smColorTransformInit;
         }
      }
      
      public function setInitEnergyFromBunker(value:int) : void
      {
         this.mInitEnergyFromBunker = value;
      }
      
      public function getInitEnergyFromBunker() : int
      {
         return this.mInitEnergyFromBunker;
      }
   }
}
