package com.dchoc.game.model.umbrella
{
   import com.dchoc.game.controller.map.MapControllerPlanet;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.widgets.smallStructures.IconBarUmbrella;
   import com.dchoc.game.model.map.TileData;
   import com.dchoc.game.model.unit.Cupola;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.UnitScene;
   import com.dchoc.game.model.unit.components.movement.UnitComponentMovement;
   import com.dchoc.game.model.unit.components.view.UnitComponentView;
   import com.dchoc.game.model.unit.defs.UnitDef;
   import com.dchoc.game.model.unit.effects.BeamRay;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.utils.anticheat.SecureBoolean;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.media.SoundManager;
   import com.dchoc.toolkit.core.view.display.DCBitmapMovieClip;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.utils.math.DCMath;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import esparragon.utils.EUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   
   public class UmbrellaMng extends DCComponent
   {
      
      private static const SHIP_TIME_WAITING_FOR_SHIP:int = 1000;
      
      private static const SHIP_STATE_NONE:int = -1;
      
      private static const SHIP_STATE_ARRIVING:int = 0;
      
      private static const SHIP_STATE_MOVING:int = 1;
      
      private static const SHIP_STATE_LEAVING:int = 2;
      
      private static const SHIP_SHADOW_HEIGHT:int = 100;
      
      private static const SHIP_LEAVING_TARGET_ANGLE:Number = DCMath.degree2Rad(108);
      
      private static const CUPOLAS_AMOUNT:int = 5;
      
      private static const DEPLOY_BEAM_IS_ENABLED:Boolean = true;
      
      private static const DEPLOY_BEAM_TIME_ALL_UMBRELLAS:int = 10000;
      
      private static const DEPLOY_BEAM_TIME_ONE_UMBRELLA:int = 2000;
      
      private static const DEPLOY_OPEN_UMBRELLA_MIN_TIME:int = 800;
      
      private static const DEPLOY_STATE_NONE:int = -1;
      
      private static const DEPLOY_STATE_MOVING_CAMERA:int = 0;
      
      private static const DEPLOY_STATE_PLAY_SHIP_ANIMATION:int = 1;
      
      private static const DEPLOY_STATE_SHOOT_BEAM:int = 2;
      
      private static const DEPLOY_STATE_UMBRELLA_ON:int = 3;
      
      private static const DEPLOY_STATE_RETURNING_TO_HQ:int = 4;
      
      private static const DEPLOY_STATE_END:int = 5;
      
      private static const EVENT_MOVE_CAMERA_TARGET_REACHED:String = "moveCameraTargetReached";
      
      private static const EVENT_SHIP_TARGET_REACHED:String = "shipTargetReached";
      
      private static const DEBUG_ENABLED:Boolean = false;
       
      
      private var mSettingsDef:UmbrellaSettingsDef;
      
      private var mHqWIO:WorldItemObject;
      
      private var mHQLastUpgradeId:SecureInt;
      
      private var mCenterWorldPos:Vector3D;
      
      private var mCenterTileRelativeX:SecureInt;
      
      private var mCenterTileRelativeY:SecureInt;
      
      private var mAreaTileX:SecureInt;
      
      private var mAreaTileY:SecureInt;
      
      private var mAreaTilesSize:SecureInt;
      
      private var mCoor:DCCoordinate;
      
      private var mVector:Vector3D;
      
      private var mBulletsToIgnore:Vector.<MyUnit>;
      
      private var mUmbrellasAmountToDeploy:SecureInt;
      
      private var mUmbrellasAmountDeployed:SecureInt;
      
      private var mUmbrellaIsMoving:SecureBoolean;
      
      private var mSkinDef:UmbrellaSkinDef;
      
      private var mShipState:SecureInt;
      
      private var mShipUnit:MyUnit;
      
      private var mShipTargetWorldPos:Vector3D;
      
      private var mShipDO:DCDisplayObject;
      
      private var mShipShadowDO:DCDisplayObject;
      
      private var mShipTime:SecureInt;
      
      private var mShipTargetAngle:SecureNumber;
      
      private var mShipShadowOffX:SecureInt;
      
      private var mShipShadowOffY:SecureInt;
      
      private var mEffectIsApplied:SecureBoolean;
      
      private var mElectricityIsApplied:SecureBoolean;
      
      private var mCupolas:Vector.<Cupola>;
      
      private var mCupolasOpen:SecureInt;
      
      private var mDeployState:SecureInt;
      
      private var mDeployBeam:BeamRay;
      
      private var mDeployTime:SecureInt;
      
      private var mDeployTimeTotal:SecureInt;
      
      private var mDeployIsAllowedToBeShown:SecureBoolean;
      
      private var mDeployIsBeingShown:SecureBoolean;
      
      private var mEnergyMax:SecureNumber;
      
      private var mEnergyCurrent:SecureNumber;
      
      private var mEnergyTarget:SecureNumber;
      
      private var mBarESprite:IconBarUmbrella;
      
      private var mBarESpriteIsAddedToScene:SecureBoolean;
      
      private var mBarIsHidden:SecureBoolean;
      
      private var mDebugRenderData:Sprite;
      
      private var mDebugRenderData2:Sprite;
      
      public function UmbrellaMng()
      {
         mHQLastUpgradeId = new SecureInt("UmbrellaMng.mHQLastUpgradeId");
         mCenterTileRelativeX = new SecureInt("UmbrellaMng.mCenterTileRelativeX");
         mCenterTileRelativeY = new SecureInt("UmbrellaMng.mCenterTileRelativeY");
         mAreaTileX = new SecureInt("UmbrellaMng.mAreaTileX");
         mAreaTileY = new SecureInt("UmbrellaMng.mAreaTileY");
         mAreaTilesSize = new SecureInt("UmbrellaMng.mAreaTilesSize");
         mUmbrellasAmountToDeploy = new SecureInt("UmbrellaMng.mUmbrellasAmountToDeploy");
         mUmbrellasAmountDeployed = new SecureInt("UmbrellaMng.mUmbrellasAmountDeployed");
         mUmbrellaIsMoving = new SecureBoolean("UmbrellaMng.mUmbrellaIsMoving");
         mShipState = new SecureInt("UmbrellaMng.mShipState",-1);
         mShipTime = new SecureInt("UmbrellaMng.mShipTime");
         mShipTargetAngle = new SecureNumber("UmbrellaMng.mShipTargetAngle");
         mShipShadowOffX = new SecureInt("UmbrellaMng.mShipShadowOffX");
         mShipShadowOffY = new SecureInt("UmbrellaMng.mShipShadowOffY");
         mEffectIsApplied = new SecureBoolean("UmbrellaMng.mEffectIsApplied");
         mElectricityIsApplied = new SecureBoolean("UmbrellaMng.mElectricityIsApplied");
         mCupolasOpen = new SecureInt("UmbrellaMng.mCupolasOpen");
         mDeployState = new SecureInt("UmbrellaMng.mDeployState");
         mDeployTime = new SecureInt("UmbrellaMng.mDeployTime");
         mDeployTimeTotal = new SecureInt("UmbrellaMng.mDeployTimeTotal");
         mDeployIsAllowedToBeShown = new SecureBoolean("UmbrellaMng.mDeployIsAllowedToBeShown");
         mDeployIsBeingShown = new SecureBoolean("UmbrellaMng.mDeployIsBeingShown");
         mEnergyMax = new SecureNumber("UmbrellaMng.mEnergyMax",-1);
         mEnergyCurrent = new SecureNumber("UmbrellaMng.mEnergyCurrent",-1);
         mEnergyTarget = new SecureNumber("UmbrellaMng.mEnergyTarget",-1);
         mBarESpriteIsAddedToScene = new SecureBoolean("UmbrellaMng.mBarESpriteIsAddedToScene");
         mBarIsHidden = new SecureBoolean("UmbrellaMng.mBarIsHidden");
         this.mUmbrellasAmountToDeploy = new SecureInt("UmbrellaMng.mUmbrellasAmountToDeploy");
         super();
      }
      
      override protected function loadDoStep(step:int) : void
      {
         if(step == 0)
         {
            this.mVector = new Vector3D();
            this.mUmbrellasAmountToDeploy = new SecureInt("UmbrellaMng.mUmbrellasAmountToDeploy");
         }
      }
      
      override protected function unloadDo() : void
      {
         this.mSettingsDef = null;
         this.mSkinDef = null;
         this.mCoor = null;
         this.mVector = null;
         this.mCenterWorldPos = null;
         this.shipUnload();
         this.cupolaUnload();
         this.barUnload();
         this.mBulletsToIgnore = null;
         this.mUmbrellasAmountToDeploy = null;
      }
      
      override protected function unbuildDo() : void
      {
         this.energyReset();
         this.deployReset();
         this.shipReset();
         this.effectReset();
         this.cupolaReset();
         this.mHqWIO = null;
         if(this.mBulletsToIgnore != null)
         {
            this.mBulletsToIgnore.length = 0;
         }
         this.mUmbrellasAmountDeployed.value = 0;
         this.mUmbrellaIsMoving.value = false;
         this.barUnbuild();
      }
      
      override protected function endDo() : void
      {
         this.barUnbuild();
         this.barUnload();
      }
      
      override public function isRunning() : Boolean
      {
         return Config.useUmbrella() && this.mEnergyCurrent.value > -1;
      }
      
      private function getHqWIO() : WorldItemObject
      {
         if(this.mHqWIO == null)
         {
            this.mHqWIO = InstanceMng.getWorld().itemsGetHeadquarters();
         }
         return this.mHqWIO;
      }
      
      public function useUmbrella(deploy:Boolean = false) : Boolean
      {
         var hq:WorldItemObject = this.getHqWIO();
         if(hq != null && getUmbrellasAmount() + this.mUmbrellasAmountToDeploy.value < 50)
         {
            this.mUmbrellasAmountToDeploy.value++;
            if(deploy)
            {
               this.deployStart();
            }
            return true;
         }
         return false;
      }
      
      private function calculateUmbrellaPosition() : void
      {
         var mapController:MapControllerPlanet = null;
         var radius:int = 0;
         if(this.mCoor == null)
         {
            this.mCoor = new DCCoordinate();
         }
         if(this.mCenterWorldPos == null)
         {
            this.mCenterWorldPos = new Vector3D();
         }
         var hq:WorldItemObject = this.getHqWIO();
         if(this.mHqWIO != null)
         {
            this.mHqWIO.getWorldPos(this.mCoor);
            this.mCenterWorldPos.x = this.mCoor.x;
            this.mCenterWorldPos.y = this.mCoor.y;
            this.mCenterWorldPos.z = 0;
            this.mCenterTileRelativeX.value = hq.mTileRelativeX;
            this.mCenterTileRelativeY.value = hq.mTileRelativeY;
            mapController = InstanceMng.getMapControllerPlanet();
            this.mAreaTileX.value = mapController.getTileRelativeXToTile(hq.mTileRelativeX) + hq.mDef.getBaseCols() / 2;
            this.mAreaTileY.value = mapController.getTileRelativeYToTile(hq.mTileRelativeY) + hq.mDef.getBaseRows() / 2;
            radius = this.mSettingsDef.getRangeRadius();
            this.mAreaTilesSize.value = radius / 22;
            if(radius % 22 > 0)
            {
               this.mAreaTilesSize.value++;
            }
            this.mAreaTileX.value -= this.mAreaTilesSize.value;
            this.mAreaTileY.value -= this.mAreaTilesSize.value;
         }
      }
      
      public function moveUmbrellaBegin() : void
      {
         if(this.isThereUmbrella())
         {
            this.mUmbrellaIsMoving.value = true;
         }
         this.effectUnapply(true);
      }
      
      public function moveUmbrellaEnd() : void
      {
         this.calculateUmbrellaPosition();
         this.cupolaUpdatePosition();
         if(this.isThereUmbrella())
         {
            this.mUmbrellaIsMoving.value = false;
            this.moveUmbrella();
            this.barSetHidden(false);
            this.effectApply(true);
         }
      }
      
      private function moveUmbrella() : void
      {
         var hq:WorldItemObject = this.getHqWIO();
         if(hq != null)
         {
            this.barRemoveFromScene();
            this.barSetHidden(true);
            this.effectUnapply(false);
            this.calculateUmbrellaPosition();
            this.effectApply(false);
            this.cupolaUpdatePosition();
         }
      }
      
      public function isUnitProtected(unit:MyUnit, checkType:Boolean = true) : Boolean
      {
         var returnValue:Boolean = false;
         if(unit != null)
         {
            returnValue = this.isDefProtected(unit.mPosition.x,unit.mPosition.y,unit.mDef,checkType);
         }
         return returnValue;
      }
      
      public function isItemProtected(item:WorldItemObject, checkType:Boolean = true) : Boolean
      {
         var returnValue:Boolean = false;
         if(item != null)
         {
            item.getWorldPos(this.mCoor);
            returnValue = this.isDefProtected(this.mCoor.x,this.mCoor.y,item.mDef,checkType);
         }
         return returnValue;
      }
      
      private function isDefProtected(worldX:int, worldY:int, def:UnitDef, checkType:Boolean) : Boolean
      {
         var returnValue:Boolean = false;
         if(!checkType || def.isABuilding() && !def.isAMine())
         {
            returnValue = this.isAreaProtected(worldX,worldY,def.getBoundingRadius());
         }
         return returnValue;
      }
      
      public function isAreaProtected(worldX:int, worldY:int, boundingRadius:Number) : Boolean
      {
         var dx:Number = NaN;
         var dy:Number = NaN;
         var radii:Number = NaN;
         var returnValue:* = false;
         if(this.isThereUmbrella())
         {
            dx = this.mCenterWorldPos.x - worldX;
            dy = this.mCenterWorldPos.y - worldY;
            radii = boundingRadius + this.mSettingsDef.getRangeRadius();
            returnValue = dx * dx + dy * dy < radii * radii;
         }
         return returnValue;
      }
      
      private function isUnitInUmbrellaArea(unit:MyUnit) : Boolean
      {
         var returnValue:Boolean = false;
         if(unit != null)
         {
            returnValue = this.isInUmbrellaArea(unit.mPosition.x,unit.mPosition.y,unit.mDef.getBoundingRadius());
         }
         return returnValue;
      }
      
      private function isInUmbrellaArea(worldX:int, worldY:int, boundingRadius:Number) : Boolean
      {
         var dx:Number = this.mCenterWorldPos.x - worldX;
         var dy:Number = this.mCenterWorldPos.y - worldY;
         var radii:Number = boundingRadius + this.mSettingsDef.getRangeRadius();
         return dx * dx + dy * dy < radii * radii;
      }
      
      public function absorbDamage(damage:Number) : Number
      {
         var returnValue:Number = 0;
         var energy:Number = this.mEnergyCurrent.value;
         if(energy >= damage)
         {
            energy -= damage;
         }
         else
         {
            returnValue = damage - energy;
            energy = 0;
         }
         this.energySetCurrent(energy);
         InstanceMng.getUserDataMng().updateBattle_umbrellaDamaged(damage);
         return returnValue;
      }
      
      public function needsToSkipThisAttack(unitVictim:MyUnit, unitBullet:MyUnit) : Boolean
      {
         return this.isUnitInUmbrellaArea(unitVictim) && this.mBulletsToIgnore != null && this.mBulletsToIgnore.indexOf(unitBullet) > -1;
      }
      
      public function absorbNukeDamage(u:MyUnit) : void
      {
         var nukeDamage:Number = NaN;
         var damageRemaining:Number = NaN;
         var index:int = 0;
         var hq:WorldItemObject;
         if((hq = this.getHqWIO()) != null)
         {
            nukeDamage = this.mSettingsDef.getNukeDamage(hq.mDef.getUpgradeId() + 1);
            damageRemaining = this.absorbDamage(nukeDamage);
            if(damageRemaining == 0)
            {
               if(this.mBulletsToIgnore == null)
               {
                  this.mBulletsToIgnore = new Vector.<MyUnit>(0);
               }
               index = this.mBulletsToIgnore.indexOf(u);
               if(index == -1)
               {
                  this.mBulletsToIgnore.push(u);
               }
            }
         }
      }
      
      public function isThereUmbrella() : Boolean
      {
         return this.mEnergyTarget.value > 0;
      }
      
      public function getOneUmbrellaMaxEnergy() : Number
      {
         var returnValue:Number = 0;
         var hq:WorldItemObject = this.getHqWIO();
         if(hq != null)
         {
            returnValue = this.mSettingsDef.getEnergy(hq.mDef.getUpgradeId() + 1);
         }
         return returnValue;
      }
      
      public function getOneUmbrellaCurrentEnergy() : Number
      {
         var oneUmbrellaMaxEnergy:Number = this.getOneUmbrellaMaxEnergy();
         return this.mEnergyTarget.value % (oneUmbrellaMaxEnergy + 1);
      }
      
      public function getUmbrellasAmount() : int
      {
         var oneUmbrellaMaxEnergy:Number = NaN;
         var returnValue:int = 0;
         if(this.isThereUmbrella())
         {
            oneUmbrellaMaxEnergy = this.getOneUmbrellaMaxEnergy();
            returnValue = this.mEnergyTarget.value / oneUmbrellaMaxEnergy;
            if(this.mEnergyTarget.value % oneUmbrellaMaxEnergy > 0)
            {
               returnValue++;
            }
         }
         return returnValue;
      }
      
      private function getUmbrellasAmountByHQUpgradeId(hqUpgradeId:int) : Number
      {
         var oneUmbrellaEnergy:Number = this.mSettingsDef.getEnergy(hqUpgradeId + 1);
         return this.mEnergyTarget.value / oneUmbrellaEnergy;
      }
      
      private function shipReset() : void
      {
         this.shipSetState(-1);
      }
      
      private function shipUnload() : void
      {
         this.shipReset();
         this.mShipTargetWorldPos = null;
      }
      
      private function shipLoadAssets() : void
      {
         if(this.mShipUnit == null)
         {
            this.mShipUnit = this.shipGetUnit();
         }
         this.mShipUnit.buildViewComponent();
         var swf:String = this.mShipUnit.mDef.getAssetId();
         InstanceMng.getResourceMng().requestResource(swf);
      }
      
      private function shipGetUnit() : MyUnit
      {
         var unitScene:UnitScene = null;
         if(this.mShipUnit == null && this.mSkinDef != null)
         {
            unitScene = InstanceMng.getUnitScene();
            this.mShipUnit = unitScene.unitsCreateUnit(this.mSkinDef.getShipSku(),9,1,true);
         }
         return this.mShipUnit;
      }
      
      private function shipGoToTargetViewPos(x:int, y:int) : void
      {
         var moveComp:UnitComponentMovement = null;
         if(this.mShipUnit != null)
         {
            moveComp = this.mShipUnit.getMovementComponent();
            if(moveComp != null)
            {
               this.mCoor.x = x;
               this.mCoor.y = y;
               this.mCoor.z = 0;
               this.mCoor = InstanceMng.getViewMngPlanet().viewPosToLogicPos(this.mCoor);
               if(this.mShipTargetWorldPos == null)
               {
                  this.mShipTargetWorldPos = new Vector3D();
               }
               this.mShipTargetWorldPos.x = this.mCoor.x;
               this.mShipTargetWorldPos.y = this.mCoor.y;
               this.mShipTargetWorldPos.z = 0;
               this.mShipUnit.movementGoToPosition(this.mShipTargetWorldPos,10,"shipTargetReached");
            }
         }
      }
      
      public function shipSetUnitVelocity(angle:Number) : void
      {
         var moveComp:UnitComponentMovement = null;
         var velocity:Vector3D = null;
         if(this.mShipUnit != null)
         {
            moveComp = this.mShipUnit.getMovementComponent();
            if(moveComp != null)
            {
               velocity = moveComp.mVelocity;
               angle = DCMath.degree2Rad(angle);
               velocity.x = Math.cos(angle);
               velocity.y = -Math.sin(angle);
            }
         }
      }
      
      private function shipSetState(newState:int) : void
      {
         var moveComp:UnitComponentMovement = null;
         var hq:WorldItemObject = null;
         var maxSpeed:Number = NaN;
         var seconds:int = 0;
         var movComponent:UnitComponentMovement = null;
         var velocity:Vector3D = null;
         switch(this.mShipState.value)
         {
            case 0:
               if(this.mShipDO != null)
               {
                  InstanceMng.getViewMngPlanet().shipRemoveFromStage(this.mShipDO);
               }
               break;
            case 1:
            case 2:
               if(this.mShipUnit != null)
               {
                  if((moveComp = this.mShipUnit.getMovementComponent()) != null)
                  {
                     moveComp.resetBehaviours();
                  }
                  this.mShipUnit.movementStop();
                  break;
               }
         }
         this.mShipState.value = newState;
         switch(this.mShipState.value - -1)
         {
            case 0:
               if(this.mShipUnit != null)
               {
                  if(this.mShipUnit.isInScene())
                  {
                     this.mShipUnit.exitSceneStart();
                  }
                  this.mShipUnit = null;
               }
               if(this.mShipDO != null)
               {
                  InstanceMng.getViewMngPlanet().shipRemoveFromStage(this.mShipDO);
                  this.mShipDO = null;
               }
               if(this.mShipShadowDO != null)
               {
                  this.shipRemoveShadow();
                  this.mShipShadowDO = null;
               }
               break;
            case 1:
               this.mShipTime.value = 1000;
               break;
            case 2:
               if(this.mShipUnit != null)
               {
                  this.mShipShadowOffX.value = 4;
                  this.mShipShadowOffY.value = 100 - 16;
                  this.mCoor.x = this.mShipDO.x - 4;
                  this.mCoor.y = this.mShipDO.y + 16;
                  this.mCoor.z = 0;
                  InstanceMng.getViewMngPlanet().viewPosToLogicPos(this.mCoor);
                  this.mShipUnit.setPosition(this.mCoor.x,this.mCoor.y);
                  if(this.mShipShadowDO != null)
                  {
                     this.mShipShadowDO.gotoAndStop(this.mShipShadowDO.totalFrames);
                  }
                  this.mShipDO = null;
               }
               this.mCoor = this.shipGetShootPosition();
               this.shipGoToTargetViewPos(this.mCoor.x,this.mCoor.y);
               if(!this.mShipUnit.isInScene())
               {
                  this.mShipUnit.logicUpdate(0);
                  InstanceMng.getUnitScene().unitAddToScene(this.mShipUnit,0);
               }
               if((hq = this.getHqWIO()) != null)
               {
                  maxSpeed = this.mShipUnit.mDef.getMaxSpeed();
                  seconds = Math.ceil(5 / maxSpeed);
                  InstanceMng.getMapControllerPlanet().moveCameraTo(hq.mViewCenterWorldX,hq.mViewCenterWorldY,seconds,true);
               }
               break;
            case 3:
               movComponent = this.mShipUnit.getMovementComponent();
               (velocity = movComponent.getHeading()).normalize();
               this.mShipTargetAngle.value = Math.acos(velocity.x);
               movComponent.resume();
         }
      }
      
      private function shipGetShootPosition() : DCCoordinate
      {
         var hq:WorldItemObject = this.getHqWIO();
         if(hq != null)
         {
            this.mCoor.x = hq.mViewCenterWorldX - 200;
            this.mCoor.y = hq.mViewCenterWorldY - 100;
         }
         else
         {
            this.mCoor.x = 0;
            this.mCoor.y = 0;
         }
         return this.mCoor;
      }
      
      private function shipGetSpawnPosition() : DCCoordinate
      {
         this.mCoor = this.shipGetShootPosition();
         var arrivalAngle:Number = DCMath.degree2Rad(305);
         var DISTANCE:Number = 300;
         this.mCoor.x -= DISTANCE * Math.cos(arrivalAngle);
         this.mCoor.y -= DISTANCE * -Math.sin(arrivalAngle);
         return this.mCoor;
      }
      
      private function shipRemoveShadow() : void
      {
         if(this.mShipShadowDO != null)
         {
            InstanceMng.getViewMngPlanet().shipRemoveFromStage(this.mShipShadowDO);
         }
      }
      
      private function shipAddShadow(className:String) : void
      {
         var swf:String = null;
         if(this.mShipShadowDO != null)
         {
            this.shipRemoveShadow();
         }
         if(this.mShipDO != null && this.mShipUnit != null)
         {
            swf = this.mShipUnit.mDef.getAssetId();
            this.mShipShadowDO = InstanceMng.getResourceMng().getDCDisplayObject(swf,className,true,0);
            this.mShipShadowDO.x = this.mShipDO.x + this.mShipShadowOffX.value;
            this.mShipShadowDO.y = this.mShipDO.y + this.mShipShadowOffY.value;
            InstanceMng.getViewMngPlanet().shipAddToStage(this.mShipShadowDO);
         }
      }
      
      private function shipMoveShadow() : void
      {
         if(this.mShipUnit != null && this.mShipShadowDO != null)
         {
            this.mShipShadowDO.x = this.mShipUnit.mPositionDrawX + this.mShipShadowOffX.value;
            this.mShipShadowDO.y = this.mShipUnit.mPositionDrawY + this.mShipShadowOffY.value;
         }
      }
      
      private function shipLogicUpdate(dt:int) : void
      {
         var swf:String = null;
         var movComponent:UnitComponentMovement = null;
         var velocity:Vector3D = null;
         this.mShipTime.value -= dt;
         switch(this.mShipState.value)
         {
            case 0:
               if(this.mShipTime.value <= 0)
               {
                  if(this.mShipDO == null)
                  {
                     swf = this.mShipUnit.mDef.getAssetId();
                     this.mShipUnit.build(this.mShipUnit.mDef,this.mShipUnit.mFaction);
                     if(InstanceMng.getResourceMng().isResourceLoaded(swf) && this.mShipUnit.getViewComponent().isBuilt())
                     {
                        this.mShipDO = InstanceMng.getResourceMng().getDCDisplayObject(swf,"enterprise_arrives",true,0);
                        this.mCoor = this.shipGetSpawnPosition();
                        this.mShipDO.x = this.mCoor.x;
                        this.mShipDO.y = this.mCoor.y;
                        InstanceMng.getViewMngPlanet().shipAddToStage(this.mShipDO);
                        if(Config.USE_SOUNDS)
                        {
                           SoundManager.getInstance().playSound("enterprise.mp3");
                        }
                        this.mShipShadowOffX.value = 0;
                        this.mShipShadowOffY.value = 100;
                        this.shipAddShadow("shadow_arrives");
                     }
                  }
                  else
                  {
                     if(this.mShipShadowDO != null)
                     {
                        if(this.mShipShadowDO.isAnimationOver())
                        {
                           this.mShipShadowDO.gotoAndStop(this.mShipShadowDO.totalFrames);
                        }
                     }
                     if(this.mShipDO.isAnimationOver())
                     {
                        this.shipSetState(1);
                     }
                  }
               }
               break;
            case 1:
               this.shipMoveShadow();
               break;
            case 2:
               movComponent = this.mShipUnit.getMovementComponent();
               if(this.mShipTargetAngle.value != SHIP_LEAVING_TARGET_ANGLE)
               {
                  this.mShipTargetAngle.value += 0.001 * dt;
                  if(this.mShipTargetAngle.value > SHIP_LEAVING_TARGET_ANGLE)
                  {
                     this.mShipTargetAngle.value = SHIP_LEAVING_TARGET_ANGLE;
                  }
                  (velocity = movComponent.getHeading()).x = Math.cos(this.mShipTargetAngle.value);
                  velocity.y = -Math.sin(this.mShipTargetAngle.value);
                  velocity.scaleBy(movComponent.getMaxSpeed());
                  this.mShipTime.value = 1000;
                  this.shipCameraFollowShip();
                  this.shipMoveShadow();
                  break;
               }
               if(this.mShipTime.value <= 0)
               {
                  if(this.mShipUnit.isInScene() && this.mShipDO == null)
                  {
                     this.mShipDO = InstanceMng.getResourceMng().getDCDisplayObject(this.mShipUnit.mDef.getAssetId(),"enterprise_leaves",true,0);
                     this.mShipDO.x = this.mShipUnit.mPositionDrawX + 13;
                     this.mShipDO.y = this.mShipUnit.mPositionDrawY - 9;
                     InstanceMng.getViewMngPlanet().shipAddToStage(this.mShipDO);
                     if(this.mShipShadowDO != null)
                     {
                        this.shipAddShadow("shadow_leaves");
                     }
                     if(Config.USE_SOUNDS)
                     {
                        SoundManager.getInstance().playSound("enterprise.mp3");
                     }
                     this.mShipUnit.exitSceneStart();
                  }
                  else if(this.mShipDO != null)
                  {
                     if(this.mShipShadowDO != null && this.mShipShadowDO.isAnimationOver())
                     {
                        this.shipRemoveShadow();
                     }
                     if(this.mShipDO.isAnimationOver())
                     {
                        this.shipSetState(-1);
                        this.deploySetState(4);
                     }
                  }
                  break;
               }
               this.shipMoveShadow();
               break;
         }
      }
      
      private function shipCameraFollowShip() : void
      {
         var heading:Vector3D = null;
         var off:int = 0;
         if(this.mShipUnit != null && !this.mShipUnit.getMovementComponent().isStopped())
         {
            heading = this.mShipUnit.getHeading(0);
            this.mVector.x = heading.x;
            this.mVector.y = heading.y;
            this.mVector.z = 0;
            this.mVector.normalize();
            off = 250;
            InstanceMng.getMapControllerPlanet().moveCameraTo(this.mShipUnit.mPositionDrawX + off * this.mVector.x,this.mShipUnit.mPositionDrawY + off * this.mVector.y,1);
         }
      }
      
      private function effectReset() : void
      {
         this.mEffectIsApplied.value = false;
      }
      
      private function effectApplyOnTile(tileData:TileData, args:Object) : void
      {
         var item:WorldItemObject = null;
         var right:Number = NaN;
         var down:Number = NaN;
         var func:Function = null;
         if(tileData != null && args != null)
         {
            item = tileData.mBaseItem;
            if(item != null)
            {
               item.getBoundingBoxCornerDownRightWorldPos(this.mCoor);
               right = this.mCoor.x;
               down = this.mCoor.y;
               item.getBoundingBoxCornerUpLeftWorldPos(this.mCoor);
               if(DCMath.intersectCircleRectangle(this.mCenterWorldPos.x,this.mCenterWorldPos.y,this.mSettingsDef.getRangeRadius(),this.mCoor.y,this.mCoor.x,down,right))
               {
                  func = args[0];
                  func(item,args);
               }
            }
         }
      }
      
      private function effectApplyOnItemWithArgs(item:WorldItemObject, args:Object) : void
      {
         var enabled:Boolean = Boolean(args[1]);
         this.effectApplyOnItem(item,enabled);
      }
      
      private function effectApplyOnItem(item:WorldItemObject, enabled:Boolean) : void
      {
         if(!item.mDef.isADecoration() && !item.mDef.isAnObstacle() && !item.mDef.isAMine())
         {
            item.umbrellaSetIsEnabled(enabled);
         }
      }
      
      private function effectApply(applyEffects:Boolean) : void
      {
         var hq:WorldItemObject = null;
         if(!this.mEffectIsApplied.value)
         {
            InstanceMng.getMapModel().tilesDataApplyFunc(this.mAreaTileX.value,this.mAreaTileY.value,this.mAreaTilesSize.value * 2,this.mAreaTilesSize.value * 2,false,this.effectApplyOnTile,this.effectApplyOnItemWithArgs,true);
            if(applyEffects)
            {
               hq = this.getHqWIO();
               this.mElectricityIsApplied.value = !InstanceMng.getUserInfoMng().getProfileLogin().getFlatbed();
               if(hq != null && this.mElectricityIsApplied.value)
               {
                  InstanceMng.getUnitScene().effectsSwitch(hq.mUnit,2,true);
               }
            }
            this.mEffectIsApplied.value = true;
         }
      }
      
      private function effectUnapply(applyEffects:Boolean) : void
      {
         var hq:WorldItemObject = null;
         if(this.mEffectIsApplied.value)
         {
            InstanceMng.getMapModel().tilesDataApplyFunc(this.mAreaTileX.value,this.mAreaTileY.value,this.mAreaTilesSize.value * 2,this.mAreaTilesSize.value * 2,false,this.effectApplyOnTile,this.effectApplyOnItemWithArgs,false);
            if(applyEffects)
            {
               hq = this.getHqWIO();
               if(hq != null)
               {
                  InstanceMng.getUnitScene().effectsSwitch(hq.mUnit,2,false);
               }
            }
            this.mEffectIsApplied.value = false;
         }
      }
      
      private function electricityLogicUpdate() : void
      {
         var isFlatbed:* = false;
         var hq:WorldItemObject = null;
         if(this.mEffectIsApplied.value)
         {
            isFlatbed = InstanceMng.getUserInfoMng().getProfileLogin().getFlatbed();
            if(!this.mElectricityIsApplied.value && !isFlatbed || this.mElectricityIsApplied.value && isFlatbed)
            {
               hq = this.getHqWIO();
               this.mElectricityIsApplied.value = !isFlatbed;
               if(hq != null)
               {
                  InstanceMng.getUnitScene().effectsSwitch(hq.mUnit,2,false);
                  if(this.mElectricityIsApplied.value)
                  {
                     InstanceMng.getUnitScene().effectsSwitch(hq.mUnit,2,true);
                  }
               }
            }
         }
      }
      
      public function effectConsiderItem(item:WorldItemObject) : void
      {
         var itemHasEffect:Boolean = item.umbrellaGetIsEnabled();
         var itemIsProtected:Boolean = this.isItemProtected(item);
         if(this.mUmbrellaIsMoving.value && item.mDef.isHeadQuarters())
         {
            itemIsProtected = false;
         }
         if(!itemHasEffect && itemIsProtected)
         {
            this.effectApplyOnItem(item,true);
         }
         else if(itemHasEffect && !itemIsProtected)
         {
            this.effectApplyOnItem(item,false);
         }
      }
      
      private function cupolaUnload() : void
      {
         var cupola:Cupola = null;
         if(this.mCupolas != null)
         {
            while(this.mCupolas.length > 0)
            {
               cupola = this.mCupolas.shift();
               if(cupola != null)
               {
                  cupola.destroy();
               }
            }
            this.mCupolas = null;
         }
      }
      
      private function cupolaReset() : void
      {
         var cupola:Cupola = null;
         if(this.mCupolas != null)
         {
            for each(cupola in this.mCupolas)
            {
               if(cupola != null)
               {
                  cupola.reset();
               }
            }
         }
         this.mCupolasOpen.value = 0;
      }
      
      private function cupolasGetOpenAmount() : int
      {
         var cupola:Cupola = null;
         var returnValue:int = 0;
         for each(cupola in this.mCupolas)
         {
            if(cupola != null && cupola.isOpen())
            {
               returnValue++;
            }
         }
         return returnValue;
      }
      
      private function cupolaGetCupola(open:Boolean) : Cupola
      {
         var i:int = 0;
         var hq:WorldItemObject = null;
         if(this.mCupolas == null)
         {
            this.mCupolas = new Vector.<Cupola>(5);
         }
         var index:* = -1;
         var cupola:Cupola = null;
         var length:int = int(this.mCupolas.length);
         i = 0;
         while(i < length && index == -1)
         {
            cupola = this.mCupolas[i];
            if(open)
            {
               if(cupola == null || cupola.isAvailable())
               {
                  index = i;
               }
            }
            else if(cupola != null && !cupola.isAvailable())
            {
               index = i;
            }
            i++;
         }
         if(index > -1)
         {
            if(this.mCupolas[index] == null)
            {
               this.mCupolas[index] = new Cupola();
            }
            cupola = this.mCupolas[index];
            (hq = this.getHqWIO()).getWorldPos(this.mCoor);
            InstanceMng.getViewMngPlanet().logicPosToViewPos(this.mCoor);
            cupola.setup("cupola_umbrella",this.mSettingsDef.getRangeRadius(),540,this.mCoor.x,this.mCoor.y,this);
         }
         else
         {
            cupola = null;
         }
         return cupola;
      }
      
      public function cupolaUpdatePosition() : void
      {
         var hq:WorldItemObject = null;
         var cupola:Cupola = null;
         if(this.mCupolas != null)
         {
            hq = this.getHqWIO();
            if(hq != null)
            {
               for each(cupola in this.mCupolas)
               {
                  if(cupola != null)
                  {
                     cupola.setViewPosition(hq.mViewCenterWorldX,hq.mViewCenterWorldY);
                  }
               }
            }
         }
      }
      
      public function cupolaPlayOpening(time:int) : void
      {
         var cupola:Cupola = this.cupolaGetCupola(true);
         if(cupola != null)
         {
            cupola.playOpening(time);
            this.mCupolasOpen.value++;
            if(Config.USE_SOUNDS)
            {
               SoundManager.getInstance().playSound("umbrella_deployed.mp3");
            }
         }
      }
      
      public function cupolaPlayOpen() : void
      {
         var cupola:Cupola = null;
         this.mDeployIsBeingShown.value = true;
         if(this.mCupolasOpen.value == 0)
         {
            cupola = this.cupolaGetCupola(true);
            if(cupola != null)
            {
               cupola.playOpen();
               this.mCupolasOpen.value = this.getUmbrellasAmount();
            }
         }
      }
      
      public function cupolaPlayClose() : void
      {
         this.mCupolasOpen.value = 0;
         var cupola:Cupola = this.cupolaGetCupola(false);
         cupola.reset();
      }
      
      public function cupolaPlayClosing(time:int, numUmbrellasToClose:int) : void
      {
         var i:int = 0;
         var cupola:Cupola = null;
         if(time == 0)
         {
            this.cupolaPlayClose();
         }
         else
         {
            i = 0;
            while(i < numUmbrellasToClose)
            {
               this.mCupolasOpen.value--;
               cupola = this.cupolaGetCupola(this.mCupolasOpen.value > 0);
               if(cupola != null)
               {
                  cupola.playClosing(time);
               }
               i++;
            }
            InstanceMng.getViewMngGame().cameraShakeStart();
         }
      }
      
      private function cupolaLogicUpdate(dt:int) : void
      {
         var cupola:Cupola = null;
         if(this.mCupolas != null)
         {
            for each(cupola in this.mCupolas)
            {
               if(cupola != null)
               {
                  cupola.logicUpdate(dt);
               }
            }
         }
      }
      
      private function deployReset() : void
      {
         this.deploySetState(-1);
         this.mDeployIsBeingShown.value = false;
         this.mDeployIsAllowedToBeShown.value = false;
      }
      
      public function deployStart() : void
      {
         this.calculateUmbrellaPosition();
         this.mUmbrellasAmountDeployed.value = 0;
         this.mDeployTimeTotal.value = 0;
         this.cupolaPlayOpening(2000);
         this.energyCommit();
         this.cupolaPlayOpen();
         var hq:WorldItemObject = null;
         var energyToAdd:Number = NaN;
         var multiplier:Number = NaN;
         if(this.mDeployTime.value <= 0)
         {
            this.mUmbrellasAmountToDeploy.value--;
            this.mUmbrellasAmountDeployed.value++;
            if(this.mUmbrellasAmountToDeploy.value >= 0)
            {
               hq = this.getHqWIO();
               if(hq != null)
               {
                  energyToAdd = this.mSettingsDef.getEnergy(hq.mDef.getUpgradeId() + 1);
                  this.energySetValues(this.mEnergyTarget.value + energyToAdd,this.mEnergyTarget.value + energyToAdd);
               }
               if(this.mUmbrellasAmountToDeploy.value == 0)
               {
                  this.deploySetState(3);
               }
               else
               {
                  while(this.mUmbrellasAmountToDeploy.value > 0)
                  {
                     this.energySetValues(this.mEnergyTarget.value + energyToAdd,this.mEnergyTarget.value + energyToAdd);
                     this.mUmbrellasAmountToDeploy.value--;
                  }
               }
            }
         }
      }
      
      public function deploySetIsAllowedToBeShown(value:Boolean) : void
      {
         this.mDeployIsAllowedToBeShown.value = value;
      }
      
      private function deployIsBeingShown() : Boolean
      {
         return this.mDeployState.value == 3;
      }
      
      private function deploySetState(newState:int) : void
      {
         var viewComp:UnitComponentView = null;
         var renderData:DisplayObject = null;
         var doc:DCBitmapMovieClip = null;
         var hq:WorldItemObject = null;
         var startPoint:Point = null;
         var endPoint:Point = null;
         switch(this.mDeployState.value - 2)
         {
            case 0:
               if(this.mDeployBeam != null)
               {
                  InstanceMng.getViewMngPlanet().umbrellaBeamRemoveFromStage(this.mDeployBeam);
                  this.mDeployBeam = null;
               }
               if(Config.USE_SOUNDS)
               {
                  SoundManager.getInstance().playSound("shield_activated.mp3");
               }
               renderData = (doc = (viewComp = this.mShipUnit.getViewComponent()).getCurrentRenderData()).getDisplayObjectContent();
               renderData.filters = [GameConstants.FILTER_GLOW_UMBRELLA];
               renderData.filters = null;
               viewComp.setAnimationId("running",-1,true,true,true,true);
               this.shipSetState(2);
               break;
            case 1:
               if(newState == -1)
               {
                  this.effectUnapply(true);
               }
         }
         this.mDeployState.value = newState;
         switch(this.mDeployState.value)
         {
            case 0:
               InstanceMng.getGUIController().cinematicsStart();
               this.mCoor = this.shipGetSpawnPosition();
               InstanceMng.getMapControllerPlanet().moveCameraTo(this.mCoor.x,this.mCoor.y,2,true,this,"moveCameraTargetReached");
               break;
            case 1:
               this.shipLoadAssets();
               this.shipSetState(0);
               break;
            case 2:
               hq = this.getHqWIO();
               (viewComp = this.mShipUnit.getViewComponent()).setAnimationId("shooting",-1,true,true,true,true);
               renderData = (doc = viewComp.getCurrentRenderData()).getDisplayObjectContent();
               renderData.filters = [GameConstants.FILTER_GLOW_UMBRELLA];
               if(true)
               {
                  this.mDeployBeam = new BeamRay([GameConstants.FILTER_GLOW_UMBRELLA],"lighten");
                  startPoint = new Point(this.mShipUnit.mPositionDrawX + doc.getCollBoxX(),this.mShipUnit.mPositionDrawY + doc.getCollBoxY());
                  endPoint = new Point(hq.mViewCenterWorldX,hq.mViewCenterWorldY);
                  this.mDeployBeam.addRay(1,5,startPoint,endPoint,11123432,16777215);
                  this.mDeployBeam.addRay(20,1,startPoint,endPoint,11123432,16777215);
                  this.mDeployBeam.addRay(20,1,startPoint,endPoint,11123432,16777215);
                  InstanceMng.getViewMngPlanet().umbrellaBeamAddToStage(this.mDeployBeam);
               }
               this.mDeployTime.value = 2000;
               this.cupolaPlayOpening(2000);
               break;
            case 3:
               this.energyCommit();
               if(this.mDeployIsAllowedToBeShown.value)
               {
                  this.cupolaPlayOpen();
               }
               break;
            case 4:
               InstanceMng.getMapControllerPlanet().centerCameraInHQ(1,this,"moveCameraTargetReached");
               break;
            case 5:
               InstanceMng.getGUIController().cinematicsFinish();
               this.deploySetState(3);
         }
      }
      
      private function deployLogicUpdate(dt:int) : void
      {
         var hq:WorldItemObject = null;
         var energyToAdd:Number = NaN;
         var multiplier:Number = NaN;
         this.mDeployTime.value -= dt;
         switch(this.mDeployState.value - 2)
         {
            case 0:
               if(this.mDeployBeam != null)
               {
                  this.mDeployBeam.logicUpdate(dt);
               }
               this.mDeployTimeTotal.value += dt;
               if(this.mDeployTime.value <= 0)
               {
                  this.mUmbrellasAmountToDeploy.value--;
                  this.mUmbrellasAmountDeployed.value++;
                  if(this.mUmbrellasAmountToDeploy.value >= 0)
                  {
                     if((hq = this.getHqWIO()) != null)
                     {
                        energyToAdd = this.mSettingsDef.getEnergy(hq.mDef.getUpgradeId() + 1);
                        this.energySetValues(this.mEnergyTarget.value + energyToAdd,this.mEnergyTarget.value + energyToAdd);
                     }
                     if(this.mDeployTimeTotal.value >= 10000 || this.mUmbrellasAmountToDeploy.value == 0)
                     {
                        this.deploySetState(3);
                        while(this.mUmbrellasAmountToDeploy.value > 0)
                        {
                           this.energySetValues(this.mEnergyTarget.value + energyToAdd,this.mEnergyTarget.value + energyToAdd);
                           this.mUmbrellasAmountToDeploy.value--;
                        }
                     }
                     else
                     {
                        multiplier = this.mUmbrellasAmountDeployed.value + this.mUmbrellasAmountDeployed.value / 2;
                        this.mDeployTime.value = 2000 - multiplier * 200;
                        if(this.mDeployTime.value < 800)
                        {
                           this.mDeployTime.value = 800;
                        }
                        this.cupolaPlayOpening(2000);
                     }
                  }
               }
               break;
            case 1:
               if(this.mEnergyCurrent.value <= 0)
               {
                  this.deploySetState(-1);
                  break;
               }
               if(this.mDeployIsAllowedToBeShown.value && !this.mDeployIsBeingShown.value)
               {
                  this.cupolaPlayOpen();
               }
               break;
         }
      }
      
      private function energyReset() : void
      {
         this.mEnergyMax.value = -1;
         this.mEnergyCurrent.value = -1;
         this.mEnergyTarget.value = -1;
      }
      
      public function energyGetTarget() : Number
      {
         return this.mEnergyTarget.value;
      }
      
      public function energyGetMax() : Number
      {
         return this.mEnergyMax.value;
      }
      
      private function energySetCurrent(value:Number) : void
      {
         var oldUmbrellasAmount:int = this.getUmbrellasAmount();
         this.mEnergyTarget.value = value;
         this.mEnergyCurrent.value = value;
         var currentUmbrellasAmount:int = this.getUmbrellasAmount();
         if(currentUmbrellasAmount < oldUmbrellasAmount)
         {
            this.cupolaPlayClosing(1500,oldUmbrellasAmount - currentUmbrellasAmount);
         }
      }
      
      private function energyGetOneUmbrellaEnergyByHQUpgradeId(hqUpgradeId:int) : Number
      {
         return this.mSettingsDef.getEnergy(hqUpgradeId + 1);
      }
      
      private function energyCalculateMaxEnergy(current:Number) : Number
      {
         var energyByUmbrella:Number = NaN;
         var umbrellasAmount:int = 0;
         var returnValue:* = current;
         var hq:WorldItemObject;
         if((hq = this.getHqWIO()) != null)
         {
            this.mHQLastUpgradeId.value = hq.mDef.getUpgradeId();
            energyByUmbrella = this.mSettingsDef.getEnergy(this.mHQLastUpgradeId.value + 1);
            umbrellasAmount = current / energyByUmbrella;
            if(current % energyByUmbrella > 0)
            {
               umbrellasAmount++;
            }
            returnValue = umbrellasAmount * energyByUmbrella;
         }
         return returnValue;
      }
      
      private function energySetValuesFromUmbrellasAmount(umbrellasAmount:Number) : void
      {
         var energyCurrent:Number = NaN;
         var energyMax:Number = NaN;
         var hq:WorldItemObject = this.getHqWIO();
         if(hq != null)
         {
            energyCurrent = umbrellasAmount * this.energyGetOneUmbrellaEnergyByHQUpgradeId(hq.mDef.getUpgradeId());
            energyMax = this.energyCalculateMaxEnergy(energyCurrent);
            this.energySetValues(energyCurrent,energyMax);
         }
      }
      
      private function energySetValues(current:Number, max:Number) : void
      {
         this.mEnergyTarget.value = current;
         this.mEnergyMax.value = max;
      }
      
      private function energyCommit() : void
      {
         this.mEnergyCurrent.value = this.mEnergyTarget.value;
      }
      
      private function energyLogicUpdate(dt:int) : void
      {
         var allowedRoles:Array = null;
         var profile:Profile = null;
         var persistenceData:XML = null;
         var attribute:String = null;
         var umbrellaEnergy:Number = NaN;
         var umbrellaMaxEnergy:* = NaN;
         var currentRoleId:int = 0;
         var hq:WorldItemObject = null;
         var umbrellasAmount:Number = NaN;
         var energy:Number;
         if((energy = this.mEnergyCurrent.value) == -1)
         {
            if((profile = InstanceMng.getUserInfoMng().getCurrentProfileLoaded()) != null && profile.isBuilt() && InstanceMng.getWorld().isBuilt())
            {
               this.calculateUmbrellaPosition();
               persistenceData = profile.persistenceGetRaw();
               attribute = "umbrellaEnergy";
               umbrellaEnergy = EUtils.xmlIsAttribute(persistenceData,attribute) ? EUtils.xmlReadNumber(persistenceData,attribute) : 0;
               if((umbrellaMaxEnergy = this.energyCalculateMaxEnergy(umbrellaEnergy)) < umbrellaEnergy)
               {
                  umbrellaMaxEnergy = umbrellaEnergy;
               }
               this.energySetValues(umbrellaEnergy,umbrellaMaxEnergy);
               currentRoleId = InstanceMng.getFlowStatePlanet().getCurrentRoleId();
               allowedRoles = [1,3,0,7,2];
               this.deploySetIsAllowedToBeShown(allowedRoles.indexOf(currentRoleId) >= 0);
               if(umbrellaEnergy > 0)
               {
                  this.deploySetState(3);
               }
               else
               {
                  this.energyCommit();
               }
            }
         }
         else if((hq = this.getHqWIO()) != null)
         {
            if(hq.mDef.getUpgradeId() != this.mHQLastUpgradeId.value)
            {
               umbrellasAmount = this.getUmbrellasAmountByHQUpgradeId(this.mHQLastUpgradeId.value);
               this.energySetValuesFromUmbrellasAmount(umbrellasAmount);
               this.mHQLastUpgradeId.value = hq.mDef.getUpgradeId();
            }
         }
      }
      
      private function barUnload() : void
      {
         if(this.mBarESprite != null)
         {
            this.mBarESprite.destroy();
            this.mBarESprite = null;
         }
      }
      
      private function barUnbuild() : void
      {
         this.barRemoveFromScene();
      }
      
      private function barRemoveFromScene() : void
      {
         if(this.mBarESprite != null && this.mBarESpriteIsAddedToScene.value)
         {
            this.mBarESpriteIsAddedToScene.value = false;
            InstanceMng.getViewMngPlanet().worldItemRemoveLiveBarFromStage(this.mBarESprite);
         }
      }
      
      private function barSetHidden(hidden:Boolean) : void
      {
         this.mBarIsHidden.value = hidden;
      }
      
      private function barLogicUpdate(dt:int) : void
      {
         var removeBar:Boolean = false;
         if(this.isThereUmbrella())
         {
            if(!this.mBarESpriteIsAddedToScene.value && !this.mBarIsHidden.value)
            {
               if(this.mBarESprite == null)
               {
                  this.mBarESprite = InstanceMng.getViewFactory().getIconBarUmbrella();
               }
               if(this.mHqWIO != null)
               {
                  this.mHqWIO.getWorldPos(this.mCoor);
               }
               else
               {
                  this.mCoor.x = this.mCenterWorldPos.x;
                  this.mCoor.y = this.mCenterWorldPos.y;
               }
               InstanceMng.getViewMngPlanet().logicPosToViewPos(this.mCoor);
               this.mBarESprite.x = this.mCoor.x - this.mBarESprite.getLogicWidth() / 2;
               this.mBarESprite.y = this.mCoor.y - this.mBarESprite.getLogicHeight() / 2 - 60;
               InstanceMng.getViewMngPlanet().worldItemAddLiveBarToStage(this.mBarESprite);
               this.mBarESpriteIsAddedToScene.value = true;
            }
            if(this.mBarESprite != null && this.mBarESpriteIsAddedToScene.value)
            {
               if(this.mEnergyTarget.value == 0)
               {
                  this.barRemoveFromScene();
               }
               else
               {
                  this.mBarESprite.logicUpdate(dt);
               }
            }
         }
         else
         {
            removeBar = true;
         }
         if(removeBar && this.mBarESpriteIsAddedToScene.value)
         {
            this.barRemoveFromScene();
         }
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         if(InstanceMng.getWorld().isBegun())
         {
            if(this.mSettingsDef == null)
            {
               if(InstanceMng.getUmbrellaSettingsDefMng().isBuilt())
               {
                  this.mSettingsDef = InstanceMng.getUmbrellaSettingsDefMng().getUmbrellaSettingsDef();
               }
            }
            else if(this.mSkinDef == null)
            {
               if(InstanceMng.getUmbrellaSkinDefMng().isBuilt())
               {
                  this.mSkinDef = InstanceMng.getUmbrellaSkinDefMng().getDefBySku(this.mSettingsDef.getSkinSku()) as UmbrellaSkinDef;
               }
            }
            if(this.mUmbrellaIsMoving.value)
            {
               this.moveUmbrella();
            }
            this.energyLogicUpdate(dt);
            this.barLogicUpdate(dt);
            this.shipLogicUpdate(dt);
            this.deployLogicUpdate(dt);
            this.electricityLogicUpdate();
            this.cupolaLogicUpdate(dt);
         }
      }
      
      override public function notify(e:Object) : Boolean
      {
         var moveComp:UnitComponentMovement = null;
         var cupola:Cupola = null;
         switch(e.cmd)
         {
            case "moveCameraTargetReached":
               if(this.mDeployState.value == 4)
               {
                  this.deploySetState(5);
               }
               else
               {
                  this.deploySetState(1);
               }
               break;
            case "shipTargetReached":
               if(this.mShipUnit != null)
               {
                  moveComp = this.mShipUnit.getMovementComponent();
                  if(moveComp != null)
                  {
                     moveComp.stop();
                     moveComp.resetBehaviours();
                  }
               }
               if(this.mShipState.value == 1)
               {
                  this.deploySetState(2);
               }
               else if(this.mShipState.value == 2)
               {
                  this.shipSetState(-1);
               }
               break;
            case "cupolaChangeState":
               var _loc4_:* = e.state;
               if(3 === _loc4_)
               {
                  if(this.mCupolasOpen.value > 1 && this.cupolasGetOpenAmount() > 1)
                  {
                     cupola = e.cupola;
                     if(cupola != null)
                     {
                        cupola.reset();
                     }
                  }
                  this.effectApply(true);
               }
         }
         return true;
      }
      
      public function notifyCloseInventoryPopup() : void
      {
         if(this.mUmbrellasAmountToDeploy.value > 0)
         {
            this.deployStart();
         }
      }
   }
}
