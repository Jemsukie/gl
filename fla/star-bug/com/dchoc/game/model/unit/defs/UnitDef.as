package com.dchoc.game.model.unit.defs
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.rule.AnimationsDef;
   import com.dchoc.game.utils.anticheat.SecureBoolean;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.game.utils.anticheat.SecureString;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.DCUtils;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   import flash.utils.Dictionary;
   
   public class UnitDef extends DCDef
   {
      
      public static const GROUP_KEY_NO_REPAIR:String = "noRepair";
      
      public static const GROUP_KEY_REMOVE_AFTER_DYING:String = "removeAfterDying";
      
      private static const GROUP_KEY_BOMB_CHECK_GROUND:String = "bombCheckGround";
      
      private static const GROUP_KEY_BOMB_FOLLOW_TARGET:String = "bombFollowTarget";
      
      private static const GROUP_KEY_UMBRELLA:String = "umbrella";
      
      private static const VIEW_EXTRA_TURRET_PEDESTAL:int = 1;
      
      public static const SHOT_EFFECTS_SLOW_DOWN_TIME_ID:int = 1;
      
      public static const SHOT_EFFECTS_SLOW_DOWN_SPEED_ID:int = 2;
      
      public static const SHOT_EFFECTS_SLOW_DOWN_RATE_ID:int = 3;
      
      public static const SHOT_EFFECTS_SLOW_DOWN_VIEW_TYPE_ID:int = 4;
      
      public static const SHOT_EFFECTS_BURN_BASE_DAMAGE_ID:int = 1;
      
      public static const SHOT_EFFECTS_BURN_MAX_DURATION_ID:int = 2;
      
      public static const SHOT_EFFECTS_BURN_MIN_TEMPERATURE_ID:int = 3;
      
      public static const SHOT_EFFECTS_BURN_MAX_TEMPERATURE_ID:int = 4;
      
      public static const SHOT_EFFECTS_STUN_DURATION_ID:int = 1;
      
      private static const SHOT_EFFECTS_SLOW_DOWN:String = "freeze";
      
      private static const SHOT_EFFECTS_BURN:String = "burn";
      
      private static const SHOT_EFFECTS_STUN:String = "stun";
      
      private static const SHOT_EFFECTS_ENERGY:String = "energy";
       
      
      private var mLifeBarOffY:SecureInt;
      
      private var mSecureRenderAngleCount:SecureInt;
      
      private var mShotDistanceSqr:SecureNumber;
      
      private var mSecureShotDistance:SecureInt;
      
      private var mSecureShotBurstLength:SecureInt;
      
      private var mSecureShotWaitingTime:SecureNumber;
      
      private var mSecurePursuitDistance:SecureInt;
      
      private var mSecureShotType:SecureInt;
      
      private var mSecureShotAngleDiv:SecureNumber;
      
      private var mSecureShotDamage:SecureInt;
      
      private var mSecureBlastRadius:SecureNumber;
      
      private var mBlastRadiusSqr:SecureNumber;
      
      private var mSecureMass:SecureInt;
      
      private var mSecureMaxSpeed:SecureNumber;
      
      private var mSecureMaxForce:SecureNumber;
      
      private var mSecureMaxEnergy:SecureNumber;
      
      private var mSecureSpinRate:SecureNumber;
      
      protected var mSecureAnimAngleOffset:SecureNumber;
      
      private var mSecureLootPercentage:SecureInt;
      
      private var mShotDistanceProgressBar:SecureInt;
      
      private var mPanicDistance:SecureInt;
      
      private var mMaxEnergyProgressBar:SecureInt;
      
      private var mBoundingRadius:SecureNumber;
      
      private var mBoundingRadiusSqr:SecureNumber;
      
      private var mScoreBuilt:SecureNumber;
      
      private var mScoreAttack:SecureNumber;
      
      private var mScoreDefense:SecureNumber;
      
      private var mSecureShotPriorityTarget:SecureString;
      
      private var mSecureShotPriorityKey:SecureString;
      
      protected var mSecureAnimDefSku:SecureString;
      
      private var mSecureAmmoSku:SecureString;
      
      private var mSecureStartLocked:SecureBoolean;
      
      protected var mSecureUpgradeId:SecureInt;
      
      private var mSecureUnitTypeId:SecureInt;
      
      protected var mSecureAttackGround:SecureBoolean;
      
      protected var mSecureAttackAir:SecureBoolean;
      
      private var mHappeningSku:SecureString;
      
      private var mBlastDamageDistribution:String = "linear";
      
      private var mAnimCCW:SecureBoolean;
      
      private var mAnimDef:AnimationsDef;
      
      private var mDeathType:SecureString;
      
      private var mAutoPlaySound:SecureBoolean;
      
      private var mUpgradeItemsNeeded:Array;
      
      private var mShopOrder:SecureInt;
      
      public var mSortCriteria:int = 0;
      
      private var mUnlockHQUpgradeIdRequired:SecureInt;
      
      private var mUnlockItemSkuRequired:SecureString;
      
      private var mFlaFolder:SecureString;
      
      protected var mSkuTracking:SecureString;
      
      private var mSwfSku:SecureString;
      
      private var mIsSpecialAttack:SecureBoolean;
      
      private var mActivatedBy:SecureString;
      
      private var mShotEffects:Dictionary;
      
      private var mTidSpecial:SecureString;
      
      private var mCanAttackOwnUnits:SecureBoolean;
      
      private var mTailColor:SecureString;
      
      private var mInsistOnTargetOn:SecureBoolean;
      
      private var mMoveInCirclesOn:SecureBoolean;
      
      private var mIsHealer:SecureBoolean;
      
      private var mIsHappeningOnly:SecureBoolean;
      
      private var mDrawShotParticle:SecureBoolean;
      
      private var mLineThickness:SecureNumber;
      
      private var mShotDamageProgressBar:SecureNumber;
      
      private var mSndShot:SecureString;
      
      public var mBoundingBoxOffY:int = 0;
      
      private var mViewExtraId:SecureInt;
      
      private var mTtl:SecureInt;
      
      public function UnitDef()
      {
         mLifeBarOffY = new SecureInt("UnitDef.mLifeBarOffY");
         mSecureRenderAngleCount = new SecureInt("UnitDef.mSecureRenderAngleCount");
         mShotDistanceSqr = new SecureNumber("UnitDef.mShotDistanceSqr");
         mSecureShotDistance = new SecureInt("UnitDef.mSecureShotDistance");
         mSecureShotBurstLength = new SecureInt("UnitDef.mSecureShotBurstLength",1);
         mSecureShotWaitingTime = new SecureNumber("UnitDef.mSecureShotWaitingTime");
         mSecurePursuitDistance = new SecureInt("UnitDef.mSecurePursuitDistance");
         mSecureShotType = new SecureInt("UnitDef.mSecureShotType");
         mSecureShotAngleDiv = new SecureNumber("UnitDef.mSecureShotAngleDiv");
         mSecureShotDamage = new SecureInt("UnitDef.mSecureShotDamage");
         mSecureBlastRadius = new SecureNumber("UnitDef.mSecureBlastRadius");
         mBlastRadiusSqr = new SecureNumber("UnitDef.mBlastRadiusSqr");
         mSecureMass = new SecureInt("UnitDef.mSecureMass");
         mSecureMaxSpeed = new SecureNumber("UnitDef.mSecureMaxSpeed");
         mSecureMaxForce = new SecureNumber("UnitDef.mSecureMaxForce");
         mSecureMaxEnergy = new SecureNumber("UnitDef.mSecureMaxEnergy");
         mSecureSpinRate = new SecureNumber("UnitDef.mSecureSpinRate");
         mSecureAnimAngleOffset = new SecureNumber("UnitDef.mSecureAnimAngleOffset");
         mSecureLootPercentage = new SecureInt("UnitDef.mSecureLootPercentage");
         mShotDistanceProgressBar = new SecureInt("UnitDef.mShotDistanceProgressBar");
         mPanicDistance = new SecureInt("UnitDef.mPanicDistance");
         mMaxEnergyProgressBar = new SecureInt("UnitDef.mMaxEnergyProgressBar");
         mBoundingRadius = new SecureNumber("UnitDef.mBoundingRadius");
         mBoundingRadiusSqr = new SecureNumber("UnitDef.mBoundingRadiusSqr");
         mScoreBuilt = new SecureNumber("UnitDef.mScoreBuilt");
         mScoreAttack = new SecureNumber("UnitDef.mScoreAttack");
         mScoreDefense = new SecureNumber("UnitDef.mScoreDefense");
         mSecureShotPriorityTarget = new SecureString("UnitDef.mSecureShotPriorityTarget","");
         mSecureShotPriorityKey = new SecureString("UnitDef.mSecureShotPriorityKey","");
         mSecureAnimDefSku = new SecureString("UnitDef.mSecureAnimDefSku","");
         mSecureAmmoSku = new SecureString("UnitDef.mSecureAmmoSku","");
         mSecureStartLocked = new SecureBoolean("UnitDef.mSecureStartLocked");
         mSecureUpgradeId = new SecureInt("UnitDef.mSecureUpgradeId");
         mSecureUnitTypeId = new SecureInt("UnitDef.mSecureUnitTypeId",-1);
         mSecureAttackGround = new SecureBoolean("UnitDef.mSecureAttackGround",true);
         mSecureAttackAir = new SecureBoolean("UnitDef.mSecureAttackAir");
         mHappeningSku = new SecureString("UnitDef.mHappeningSku");
         mAnimCCW = new SecureBoolean("UnitDef.mAnimCCW",false);
         mDeathType = new SecureString("UnitDef.mDeathType","");
         mAutoPlaySound = new SecureBoolean("UnitDef.mAutoPlaySound",true);
         mShopOrder = new SecureInt("UnitDef.mShopOrder");
         mUnlockHQUpgradeIdRequired = new SecureInt("UnitDef.mUnlockHQUpgradeIdRequired");
         mUnlockItemSkuRequired = new SecureString("UnitDef.mUnlockItemSkuRequired","");
         mFlaFolder = new SecureString("UnitDef.mFlaFolder","");
         mSkuTracking = new SecureString("UnitDef.mSkuTracking","");
         mSwfSku = new SecureString("UnitDef.mSwfSku","");
         mIsSpecialAttack = new SecureBoolean("UnitDef.mIsSpecialAttack");
         mActivatedBy = new SecureString("UnitDef.mActivatedBy");
         mTidSpecial = new SecureString("UnitDef.mTidSpecial");
         mCanAttackOwnUnits = new SecureBoolean("UnitDef.mCanAttackOwnUnits");
         mTailColor = new SecureString("UnitDef.mTailColor","");
         mInsistOnTargetOn = new SecureBoolean("UnitDef.mInsistOnTargetOn");
         mMoveInCirclesOn = new SecureBoolean("UnitDef.mMoveInCirclesOn");
         mIsHealer = new SecureBoolean("UnitDef.mIsHealer");
         mIsHappeningOnly = new SecureBoolean("UnitDef.mIsHappeningOnly");
         mDrawShotParticle = new SecureBoolean("UnitDef.mDrawShotParticle");
         mLineThickness = new SecureNumber("UnitDef.mLineThickness");
         mShotDamageProgressBar = new SecureNumber("UnitDef.mShotDamageProgressBar");
         mSndShot = new SecureString("UnitDef.mSndShot");
         mViewExtraId = new SecureInt("UnitDef.mViewExtraId");
         mTtl = new SecureInt("UnitDef.mTtl");
         this.mUpgradeItemsNeeded = [];
         super();
         this.mSecureAnimAngleOffset.value = -1.5707963267948966;
      }
      
      public static function getIdFromSkuAndUpgradeId(sku:String, upgradeId:int) : String
      {
         return upgradeId == 0 ? sku : sku + "_" + upgradeId;
      }
      
      override public function build() : void
      {
         if(this.getUnitTypeId() == -1)
         {
            this.setUnitTypeId(mTypeId + 3);
         }
         if(this.mSecureUnitTypeId.value == -1)
         {
            this.mSecureUnitTypeId.value = mTypeId + 3;
         }
         if(this.mAnimDef == null)
         {
            this.mAnimDef = InstanceMng.getAnimationsDefMng().getDefBySku(this.getAnimationDefSku()) as AnimationsDef;
         }
         this.mInsistOnTargetOn.value = this.isAirUnit() || belongsToGroup("insistOnTarget");
         this.mMoveInCirclesOn.value = belongsToGroup("moveInCircles");
         this.mIsHealer.value = belongsToGroup("healer");
         this.mIsHappeningOnly.value = belongsToGroup("happeningOnly");
         if(this.mTtl.value == 0 && this.mSecureUnitTypeId.value == 3 && mSku != "sa_rocket" && mSku != "sa_freeze")
         {
            this.mTtl.value = 3000;
         }
      }
      
      public function getLifeBarOffY() : int
      {
         return this.mLifeBarOffY.value;
      }
      
      private function setLifeBarOffY(value:int) : void
      {
         this.mLifeBarOffY.value = value;
      }
      
      public function getPanicDistance() : int
      {
         return this.mPanicDistance.value;
      }
      
      private function setPanicDistance(value:int) : void
      {
         this.mPanicDistance.value = value;
      }
      
      public function getPursuitDistance() : int
      {
         return this.mSecurePursuitDistance.value;
      }
      
      private function setPursuitDistance(value:int) : void
      {
         this.mSecurePursuitDistance.value = value;
      }
      
      public function getShotType() : int
      {
         return this.mSecureShotType.value;
      }
      
      private function setShotType(value:int) : void
      {
         this.mSecureShotType.value = value;
      }
      
      public function getShotAngleDiv() : Number
      {
         return this.mSecureShotAngleDiv.value;
      }
      
      private function setShotAngleDiv(value:Number) : void
      {
         this.mSecureShotAngleDiv.value = value;
      }
      
      public function getShotDistance() : int
      {
         return this.mSecureShotDistance.value;
      }
      
      protected function setShotDistance(value:int) : void
      {
         this.setShotDistanceSqr(value * value);
         this.mSecureShotDistance.value = value;
      }
      
      public function getShotDistanceSqr() : int
      {
         return this.mShotDistanceSqr.value;
      }
      
      private function setShotDistanceSqr(value:int) : void
      {
         this.mShotDistanceSqr.value = value;
      }
      
      public function getShotBurstLength() : int
      {
         return this.mSecureShotBurstLength.value;
      }
      
      protected function setShotBurstLength(value:int) : void
      {
         this.mSecureShotBurstLength.value = value;
      }
      
      public function getShotDistanceProgressBar() : int
      {
         return this.mShotDistanceProgressBar.value;
      }
      
      protected function setShotDistanceProgressBar(value:int) : void
      {
         this.mShotDistanceProgressBar.value = value;
      }
      
      public function getShotWaitingTime() : Number
      {
         return this.mSecureShotWaitingTime.value;
      }
      
      public function getShotSpeed() : Number
      {
         var value:int = 1 / (this.mSecureShotWaitingTime.value / 1000) * 100;
         return value / 100;
      }
      
      protected function setShotWaitingTime(value:Number) : void
      {
         this.mSecureShotWaitingTime.value = value;
      }
      
      public function getShotDamage() : int
      {
         return this.mSecureShotDamage.value;
      }
      
      public function getShotDPS() : Number
      {
         var value:int = this.getShotDamage() * this.getShotSpeed() * 100;
         return value / 100;
      }
      
      protected function setShotDamage(value:int) : void
      {
         this.mSecureShotDamage.value = value;
      }
      
      public function getShotDamageProgressBar() : Number
      {
         return this.mShotDamageProgressBar.value;
      }
      
      protected function setShotDamageProgressBar(value:Number) : void
      {
         this.mShotDamageProgressBar.value = value;
      }
      
      public function getShotPriorityTarget() : String
      {
         return this.mSecureShotPriorityTarget.value;
      }
      
      private function setShotPriorityTarget(value:String) : void
      {
         this.mSecureShotPriorityTarget.value = value;
      }
      
      public function getShotPriorityKey() : String
      {
         return this.mSecureShotPriorityKey.value;
      }
      
      private function setShotPriorityKey(value:String) : void
      {
         this.mSecureShotPriorityKey.value = value;
      }
      
      public function getBlastRadius() : Number
      {
         return this.mSecureBlastRadius.value;
      }
      
      private function setBlastRadius(value:Number) : void
      {
         var translatedValue:Number = GameConstants.translateTileToCoor(value);
         this.mSecureBlastRadius.value = translatedValue;
         this.setBlastRadiusSqr(translatedValue * translatedValue);
      }
      
      public function getBlastRadiusSqr() : Number
      {
         return this.mBlastRadiusSqr.value;
      }
      
      private function setBlastRadiusSqr(value:Number) : void
      {
         this.mBlastRadiusSqr.value = value;
      }
      
      public function getBlastDamageDistribution() : String
      {
         return this.mBlastDamageDistribution;
      }
      
      private function setBlastDamageDistribution(value:String) : void
      {
         this.mBlastDamageDistribution = value;
      }
      
      public function getMass() : int
      {
         return this.mSecureMass.value;
      }
      
      private function setMass(value:int) : void
      {
         this.mSecureMass.value = value;
      }
      
      public function getMaxSpeed() : Number
      {
         return this.mSecureMaxSpeed.value;
      }
      
      protected function setMaxSpeed(value:Number) : void
      {
         this.mSecureMaxSpeed.value = value;
      }
      
      public function getMaxForce() : Number
      {
         return this.mSecureMaxForce.value;
      }
      
      private function setMaxForce(value:Number) : void
      {
         this.mSecureMaxForce.value = value;
      }
      
      public function getMaxEnergy() : int
      {
         return this.mSecureMaxEnergy.value;
      }
      
      public function setMaxEnergy(value:int) : void
      {
         this.mSecureMaxEnergy.value = value;
      }
      
      public function getMaxEnergyProgressBar() : int
      {
         return this.mMaxEnergyProgressBar.value;
      }
      
      protected function setMaxEnergyProgressBar(value:int) : void
      {
         this.mMaxEnergyProgressBar.value = value;
      }
      
      public function getEnergyFromPercentage(percent:Number) : int
      {
         return percent * this.mSecureMaxEnergy.value / 100;
      }
      
      public function getEnergyPercent(currentEnergy:int) : Number
      {
         var percent:Number = NaN;
         if(this.mSecureMaxEnergy.value > 0)
         {
            percent = currentEnergy * 100 / this.mSecureMaxEnergy.value;
            if(percent < 1 && currentEnergy != 0)
            {
               return 1;
            }
            return percent;
         }
         return 0;
      }
      
      public function getAnimCCW() : Boolean
      {
         return this.mAnimCCW.value;
      }
      
      private function setAnimCCW(value:Boolean) : void
      {
         this.mAnimCCW.value = value;
      }
      
      public function shotCanBeATarget() : Boolean
      {
         return !this.isAMine();
      }
      
      public function canStepWalls() : Boolean
      {
         return belongsToGroup("canStepWalls");
      }
      
      public function isASquad() : Boolean
      {
         return mTypeId == 4;
      }
      
      public function isAnimated(sku:String) : Boolean
      {
         if(this.mAnimDef != null)
         {
            return this.mAnimDef.getAnimation(sku).isAnimated;
         }
         return false;
      }
      
      public function needsToBeRemovedAfterDying() : Boolean
      {
         return belongsToGroup("removeAfterDying");
      }
      
      public function isAllowedToBeRepaired() : Boolean
      {
         return !belongsToGroup("noRepair");
      }
      
      public function bombNeedsToCheckGround() : Boolean
      {
         return belongsToGroup("bombCheckGround");
      }
      
      public function bombNeedsToFollowTarget() : Boolean
      {
         return belongsToGroup("bombFollowTarget");
      }
      
      public function isABullet() : Boolean
      {
         return this.mSecureUnitTypeId.value == 3;
      }
      
      public function isABuilding() : Boolean
      {
         return this.mSecureUnitTypeId.value == 4 || this.mSecureUnitTypeId.value == 5;
      }
      
      public function isABuildingDefense() : Boolean
      {
         return this.isABuilding() && getTypeId() == 6;
      }
      
      public function isABuildingAttack() : Boolean
      {
         var type:int = getTypeId();
         var ok:* = [7,3].indexOf(type) > -1;
         return this.isABuilding() && ok;
      }
      
      public function isAnEnemyAttractor() : Boolean
      {
         return belongsToGroup("attractEnemies");
      }
      
      public function isAWall() : Boolean
      {
         return belongsToGroup("wall");
      }
      
      public function isAMine() : Boolean
      {
         return belongsToGroup("mine");
      }
      
      public function isATurret() : Boolean
      {
         return belongsToGroup("turret");
      }
      
      public function isALooter() : Boolean
      {
         return this.getShotPriorityTarget() == "resources";
      }
      
      public function isAnUmbrellaShip() : Boolean
      {
         return belongsToGroup("umbrella");
      }
      
      public function needsFlipWithScale() : Boolean
      {
         return !this.isATurret() || mSku == "df_001_007";
      }
      
      public function needsToBeSorted() : Boolean
      {
         return this.isTerrainUnit();
      }
      
      public function getUnitTypeId() : int
      {
         return this.mSecureUnitTypeId.value;
      }
      
      public function setUnitTypeId(value:int) : void
      {
         this.mSecureUnitTypeId.value = value;
      }
      
      public function getBoundingRadius() : Number
      {
         return this.mBoundingRadius.value;
      }
      
      public function setBoundingRadius(value:Number) : void
      {
         this.mBoundingRadius.value = value;
         this.setBoundingRadiusSqr(value * value);
      }
      
      public function getBoundingRadiusSqr() : Number
      {
         return this.mBoundingRadiusSqr.value;
      }
      
      public function setBoundingRadiusSqr(value:Number) : void
      {
         this.mBoundingRadiusSqr.value = value;
      }
      
      public function getTTL() : int
      {
         return this.mTtl.value;
      }
      
      public function getSpinRate() : Number
      {
         return this.mSecureSpinRate.value;
      }
      
      public function getAnimAngleOffset() : Number
      {
         return this.mSecureAnimAngleOffset.value;
      }
      
      public function setAnimAngleOffset(value:Number) : void
      {
         this.mSecureAnimAngleOffset.value = value;
      }
      
      public function setSpinRate(value:Number) : void
      {
         this.mSecureSpinRate.value = value * 0.017453292519943295 / 1000;
      }
      
      public function getRenderAngleCount() : int
      {
         return this.mSecureRenderAngleCount.value;
      }
      
      protected function setRenderAngleCount(value:int) : void
      {
         this.mSecureRenderAngleCount.value = value;
      }
      
      public function getAnimationDef() : AnimationsDef
      {
         return this.mAnimDef;
      }
      
      public function getAnimation(sku:String = null) : Object
      {
         return this.mAnimDef == null ? null : this.mAnimDef.getAnimation(sku);
      }
      
      public function getAnimationDefSku() : String
      {
         return this.mSecureAnimDefSku.value;
      }
      
      public function getDefaultAnimationId() : String
      {
         return this.mAnimDef.mDefaultAnim;
      }
      
      public function isTerrainUnit() : Boolean
      {
         return GameConstants.UNIT_TYPE_IS_TERRAIN[this.mSecureUnitTypeId.value];
      }
      
      public function isAirUnit() : Boolean
      {
         return this.mSecureUnitTypeId.value == 2;
      }
      
      public function isMoveInCirclesOn() : Boolean
      {
         return this.mMoveInCirclesOn.value;
      }
      
      public function isHealer() : Boolean
      {
         return this.mIsHealer.value;
      }
      
      public function isHappeningOnly() : Boolean
      {
         return this.mIsHappeningOnly.value;
      }
      
      public function isInsistOnTargetOn() : Boolean
      {
         return this.mInsistOnTargetOn.value;
      }
      
      public function setDeathType(value:String) : void
      {
         this.mDeathType.value = value;
      }
      
      public function getDeathType() : String
      {
         return this.mDeathType.value;
      }
      
      public function getAmmoSku() : String
      {
         return this.mSecureAmmoSku.value;
      }
      
      override public function getSku() : String
      {
         return getIdFromSkuAndUpgradeId(mSku,this.mSecureUpgradeId.value);
      }
      
      public function getUpgradeId() : int
      {
         return this.mSecureUpgradeId.value;
      }
      
      private function setUpgradeId(value:int) : void
      {
         this.mSecureUpgradeId.value = value;
      }
      
      public function getUpgradeItemsNeeded() : Array
      {
         return this.mUpgradeItemsNeeded;
      }
      
      private function addUpgradeItemsNeeded(value:String) : void
      {
         if(this.mUpgradeItemsNeeded == null)
         {
            this.mUpgradeItemsNeeded = [];
         }
         this.mUpgradeItemsNeeded.push(value);
      }
      
      public function getNumUpgradeItemsNeeded() : int
      {
         return this.mUpgradeItemsNeeded == null ? 0 : int(this.mUpgradeItemsNeeded.length);
      }
      
      public function getUpgradeItemsNeededSku(pos:int = 0) : String
      {
         var itemStr:String = null;
         try
         {
            itemStr = String(this.mUpgradeItemsNeeded[pos]);
            return itemStr.split(":")[0];
         }
         catch(e:Error)
         {
         }
         return null;
      }
      
      public function getUpgradeItemsNeededAmount(pos:int = 0) : int
      {
         var itemStr:String = null;
         try
         {
            itemStr = String(this.mUpgradeItemsNeeded[pos]);
            return parseInt(itemStr.split(":")[1]);
         }
         catch(e:Error)
         {
         }
         return 2147483647;
      }
      
      public function getShopOrder() : int
      {
         return this.mShopOrder.value;
      }
      
      private function setShopOrder(value:int) : void
      {
         this.mShopOrder.value = value;
      }
      
      public function mustBeShownInShop() : Boolean
      {
         return this.mShopOrder.value > -1;
      }
      
      private function setFlaFolder(value:String) : void
      {
         this.mFlaFolder.value = value;
      }
      
      public function getFlaFolder() : String
      {
         return this.mFlaFolder.value;
      }
      
      public function getStartLocked() : Boolean
      {
         return this.mSecureStartLocked.value;
      }
      
      private function setStartLocked(value:String) : void
      {
         this.mSecureStartLocked.value = DCUtils.stringToBoolean(value);
      }
      
      public function getAutoPlaySound() : Boolean
      {
         return this.mAutoPlaySound.value;
      }
      
      private function setAutoPlaySound(value:String) : void
      {
         this.mAutoPlaySound.value = DCUtils.stringToBoolean(value);
      }
      
      protected function setUnlockHQUpgradeIdRequired(value:int) : void
      {
         this.mUnlockHQUpgradeIdRequired.value = value;
      }
      
      public function getUnlockHQUpgradeIdRequired() : int
      {
         return this.mUnlockHQUpgradeIdRequired.value;
      }
      
      protected function setUnlockItemSkuRequired(sku:String) : void
      {
         this.mUnlockItemSkuRequired.value = sku;
      }
      
      public function getUnlockItemSkuRequired() : String
      {
         return this.mUnlockItemSkuRequired.value;
      }
      
      public function needsItemForUnlocking() : Boolean
      {
         return this.getUnlockItemSkuRequired() != "";
      }
      
      public function getAttackGroundUnits() : Boolean
      {
         return this.mSecureAttackGround.value;
      }
      
      public function getAttackAirUnits() : Boolean
      {
         return this.mSecureAttackAir.value;
      }
      
      public function getSkuTracking() : String
      {
         return this.mSkuTracking.value;
      }
      
      public function setSkuTracking(value:String) : void
      {
         this.mSkuTracking.value = value;
      }
      
      private function setSwfUrl(value:String) : void
      {
         this.mSwfSku.value = value;
      }
      
      public function getSwfUrl() : String
      {
         return this.mSwfSku.value;
      }
      
      private function setScoreBuilt(value:Number) : void
      {
         this.mScoreBuilt.value = value;
      }
      
      public function getScoreBuilt() : Number
      {
         return this.mScoreBuilt.value;
      }
      
      private function setScoreAttack(value:Number) : void
      {
         this.mScoreAttack.value = value;
      }
      
      public function getScoreAttack() : Number
      {
         return this.mScoreAttack.value;
      }
      
      private function setScoreDefense(value:Number) : void
      {
         this.mScoreDefense.value = value;
      }
      
      public function getScoreDefense() : Number
      {
         return this.mScoreDefense.value;
      }
      
      private function setIsSpecialAttack(value:Boolean) : void
      {
         this.mIsSpecialAttack.value = value;
      }
      
      public function getIsSpecialAttack() : Boolean
      {
         return this.mIsSpecialAttack.value;
      }
      
      public function canBeActivatedBy(value:String) : Boolean
      {
         return this.mActivatedBy.value == null || this.mActivatedBy.value.indexOf(value) > -1;
      }
      
      private function setActivatedBy(value:String) : void
      {
         if(value != "")
         {
            this.mActivatedBy.value = value;
         }
      }
      
      public function getLootPercentage() : int
      {
         return this.mSecureLootPercentage.value;
      }
      
      private function setLootPercentage(value:int) : void
      {
         this.mSecureLootPercentage.value = value;
      }
      
      public function canAttackOwnUnits() : Boolean
      {
         return this.mCanAttackOwnUnits.value;
      }
      
      private function setCanAttackOwnUnits(value:Boolean) : void
      {
         this.mCanAttackOwnUnits.value = value;
      }
      
      private function shotEffectsLoad(shotDamage:String) : void
      {
         var effect:String = null;
         var attributes:Array = null;
         var attributesLength:int = 0;
         var i:int = 0;
         var shotAttributes:Array = null;
         var effects:Array = shotDamage.split(",");
         var doSetShotDamage:Boolean = true;
         this.setShotDamage(0);
         for each(effect in effects)
         {
            attributesLength = int((attributes = effect.split(":")).length);
            if(attributesLength > 1)
            {
               doSetShotDamage = false;
               if(this.mShotEffects == null)
               {
                  this.mShotEffects = new Dictionary();
               }
               shotAttributes = [];
               for(i = 1; i < attributesLength; )
               {
                  shotAttributes[i] = Number(attributes[i]);
                  i++;
               }
               switch(attributes[0])
               {
                  case "freeze":
                     shotAttributes[2] = (100 - shotAttributes[2]) / 100;
                     shotAttributes[3] = (100 - shotAttributes[3]) / 100;
                     break;
                  case "burn":
                     this.setShotDamage(shotAttributes[1]);
                     break;
                  case "stun":
               }
               this.mShotEffects[attributes[0]] = shotAttributes;
            }
         }
         if(doSetShotDamage)
         {
            this.setShotDamage(Number(shotDamage));
         }
      }
      
      private function shotEffectsGetSlowDownParam(id:int) : Number
      {
         var returnValue:Number = 0;
         var params:Array = this.shotEffectsGetSlowDownParams();
         if(params != null && id < params.length)
         {
            returnValue = Number(params[id]);
         }
         return returnValue;
      }
      
      public function shotEffectsGetSlowDownTime() : Number
      {
         return this.shotEffectsGetSlowDownParam(1);
      }
      
      public function shotEffectsGetSlowDownSpeedPercent() : Number
      {
         return 100 - 100 * this.shotEffectsGetSlowDownParam(2);
      }
      
      public function shotEffectsGetSlowDownRatePercent() : Number
      {
         return 100 - 100 * this.shotEffectsGetSlowDownParam(3);
      }
      
      public function shotEffectsGetSlowDownParams() : Array
      {
         return this.mShotEffects == null ? null : this.mShotEffects["freeze"];
      }
      
      public function shotEffectsSlowDownIsOn() : Boolean
      {
         return this.mShotEffects != null && this.mShotEffects["freeze"] != null;
      }
      
      private function shotEffectsGetBurnParam(id:int) : Number
      {
         var returnValue:Number = 0;
         var params:Array = this.shotEffectsGetBurnParams();
         if(params != null && id < params.length)
         {
            returnValue = Number(params[id]);
         }
         return returnValue;
      }
      
      public function shotEffectsGetBurnMaxDuration() : int
      {
         return this.shotEffectsGetBurnParam(2);
      }
      
      public function shotEffectsGetBurnMinTemperature() : int
      {
         return this.shotEffectsGetBurnParam(3);
      }
      
      public function shotEffectsGetBurnMaxTemperature() : int
      {
         return this.shotEffectsGetBurnParam(4);
      }
      
      public function shotEffectsGetBurnParams() : Array
      {
         return this.mShotEffects == null ? null : this.mShotEffects["burn"];
      }
      
      public function shotEffectsBurnIsOn() : Boolean
      {
         return this.mShotEffects != null && this.mShotEffects["burn"] != null;
      }
      
      private function shotEffectsGetStunParam(id:int) : Number
      {
         var returnValue:Number = 0;
         var params:Array = this.shotEffectsGetStunParams();
         if(params != null && id < params.length)
         {
            returnValue = Number(params[id]);
         }
         return returnValue;
      }
      
      public function shotEffectsGetStunDuration() : int
      {
         return this.shotEffectsGetStunParam(1);
      }
      
      public function shotEffectsGetStunParams() : Array
      {
         return this.mShotEffects == null ? null : this.mShotEffects["stun"];
      }
      
      public function shotEffectsStunIsOn() : Boolean
      {
         return this.mShotEffects != null && this.mShotEffects["stun"] != null;
      }
      
      public function shotEffectsIsEnergyOn() : Boolean
      {
         return this.mShotEffects == null || this.mShotEffects["freeze"] != null || this.mShotEffects["burn"] != null || this.mShotEffects["stun"] != null;
      }
      
      public function shotEffectsNeedsToShowInfo() : Boolean
      {
         return this.mShotEffects != null;
      }
      
      private function setTidSpecial(value:String) : void
      {
         this.mTidSpecial.value = value;
      }
      
      public function getTextSpecial() : String
      {
         if(this.mTidSpecial.value != null && TextIDs[this.mTidSpecial.value] != null)
         {
            return DCTextMng.getText(TextIDs[this.mTidSpecial.value]);
         }
         return "";
      }
      
      private function setTailColor(value:String) : void
      {
         this.mTailColor.value = value;
      }
      
      public function getTailColor() : String
      {
         return this.mTailColor.value;
      }
      
      private function setDrawShotParticle(value:Boolean) : void
      {
         this.mDrawShotParticle.value = value;
      }
      
      public function getDrawShotParticle() : Boolean
      {
         return this.mDrawShotParticle.value;
      }
      
      private function setLineThickness(value:Number) : void
      {
         this.mLineThickness.value = value;
      }
      
      public function getLineThickness() : Number
      {
         return this.mLineThickness.value;
      }
      
      public function getSndShot() : String
      {
         return this.mSndShot.value;
      }
      
      public function setSndShot(value:String) : void
      {
         if(value != null && value != "")
         {
            this.mSndShot.value = value + ".mp3";
         }
      }
      
      private function setBoundingBoxOffY(value:int) : void
      {
         this.mBoundingBoxOffY = value;
      }
      
      override protected function doFromXml(info:XML) : void
      {
         var itemsArr:Array = null;
         var itemStr:String = null;
         var attackTo:String = null;
         super.doFromXml(info);
         var attribute:String = "boundingBoxOffY";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setBoundingBoxOffY(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "panicDistance";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setPanicDistance(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "shotDistance";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setShotDistance(EUtils.xmlReadInt(info,attribute));
         }
         else
         {
            this.setShotDistance(0);
         }
         attribute = "shotDistanceProgressBar";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setShotDamageProgressBar(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "pursuitDistance";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setPursuitDistance(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "shotType";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setShotType(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "shotAngleDiv";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setShotAngleDiv(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "shotDamage";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.shotEffectsLoad(EUtils.xmlReadString(info,attribute));
         }
         attribute = "shotDamageProgressBar";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setShotDamageProgressBar(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "blastRadius";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setBlastRadius(EUtils.xmlReadNumber(info,attribute));
         }
         else
         {
            this.setBlastRadius(0);
         }
         attribute = "mass";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMass(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "maxSpeed";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMaxSpeed(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "maxForce";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMaxForce(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "energy";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMaxEnergy(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "energyProgressBar";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMaxEnergyProgressBar(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "animCCW";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setAnimCCW(EUtils.xmlReadString(info,attribute) == "true");
         }
         attribute = "boundingRadius";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setBoundingRadius(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "shotSpinRate";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setSpinRate(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "shotPriorityTarget";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setShotPriorityTarget(EUtils.xmlReadString(info,attribute));
         }
         attribute = "shotPriorityKey";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setShotPriorityKey(EUtils.xmlReadString(info,attribute));
         }
         attribute = "startLocked";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setStartLocked(EUtils.xmlReadString(info,attribute));
         }
         attribute = "shotWaitingTime";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setShotWaitingTime(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "animDefSku";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mSecureAnimDefSku.value = EUtils.xmlReadString(info,attribute);
         }
         attribute = "shotBurstLength";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mSecureShotBurstLength.value = EUtils.xmlReadInt(info,attribute);
         }
         attribute = "autoPlaySound";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setAutoPlaySound(EUtils.xmlReadString(info,attribute));
         }
         attribute = "deathType";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setDeathType(EUtils.xmlReadString(info,attribute));
         }
         else if(this.getDeathType() == "")
         {
            this.setDeathType("death001");
         }
         attribute = "ammoSku";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mSecureAmmoSku.value = EUtils.xmlReadString(info,attribute);
         }
         attribute = "levelId";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setUpgradeId(EUtils.xmlReadInt(info,attribute) - 1);
         }
         attribute = "constructionItemSku";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            itemsArr = EUtils.xmlReadString(info,attribute).split(",");
            for each(itemStr in itemsArr)
            {
               this.addUpgradeItemsNeeded(itemStr);
            }
         }
         attribute = "shopOrder";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setShopOrder(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "flaFolder";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setFlaFolder(EUtils.xmlReadString(info,attribute));
         }
         attribute = "HQlevel";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setUnlockHQUpgradeIdRequired(EUtils.xmlReadInt(info,attribute) - 1);
         }
         attribute = "itemSkuNeeded";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setUnlockItemSkuRequired(EUtils.xmlReadString(info,attribute));
         }
         attribute = "attackTo";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            attackTo = EUtils.xmlReadString(info,attribute);
            this.mSecureAttackGround.value = attackTo.indexOf("ground") > -1;
            this.mSecureAttackAir.value = attackTo.indexOf("air") > -1;
         }
         attribute = "skuTracking";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setSkuTracking(EUtils.xmlReadString(info,attribute));
         }
         attribute = "swfUrl";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setSwfUrl(EUtils.xmlReadString(info,attribute));
         }
         attribute = "scoreBuilt";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setScoreBuilt(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "scoreAttack";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setScoreAttack(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "scoreDefense";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setScoreDefense(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "isSpecialAttack";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setIsSpecialAttack(EUtils.xmlReadBoolean(info,attribute));
         }
         attribute = "activatedBy";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setActivatedBy(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidSpecial";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTidSpecial(EUtils.xmlReadString(info,attribute));
         }
         attribute = "lootPercentage";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setLootPercentage(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "canAttackOwnUnits";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setCanAttackOwnUnits(EUtils.xmlReadBoolean(info,attribute));
         }
         attribute = "blastDamageDistribution";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setBlastDamageDistribution(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tailColor";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTailColor(EUtils.xmlReadString(info,attribute));
         }
         attribute = "drawShotParticle";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setDrawShotParticle(EUtils.xmlReadBoolean(info,attribute));
         }
         attribute = "lineThickness";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setLineThickness(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "happeningSku";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setHappeningSku(EUtils.xmlReadString(info,attribute));
         }
         attribute = "sndShot";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setSndShot(EUtils.xmlReadString(info,attribute));
         }
         attribute = "viewExtraId";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setViewExtraId(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "lifeBarOffY";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setLifeBarOffY(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "ttl";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTtl(EUtils.xmlReadInt(info,attribute));
         }
      }
      
      private function setTtl(value:int) : void
      {
         this.mTtl.value = value;
      }
      
      private function setViewExtraId(value:int) : void
      {
         this.mViewExtraId.value = value;
      }
      
      private function setHappeningSku(value:String) : void
      {
         this.mHappeningSku.value = value;
      }
      
      public function getHappeningSku() : String
      {
         return this.mHappeningSku.value != null ? this.mHappeningSku.value : null;
      }
      
      public function viewExtraUsesTurretPedestal() : Boolean
      {
         return this.mViewExtraId.value == 1;
      }
      
      override protected function getSigDo() : String
      {
         return "" + getGroups() + this.getPanicDistance() + this.getBlastDamageDistribution() + Math.floor(this.getBoundingRadius()) + Math.floor(this.getBoundingRadiusSqr()) + this.getIsSpecialAttack() + this.mShotEffects + this.isInsistOnTargetOn() + this.isMoveInCirclesOn() + this.getHappeningSku() + this.getShotDistance() + this.getShotDistanceSqr() + this.getBlastRadiusSqr() + this.getBlastDamageDistribution() + this.getTTL() + this.getRenderAngleCount() + this.getShotBurstLength() + Math.floor(this.getShotWaitingTime()) + this.getPursuitDistance() + this.getShotType() + Math.floor(this.getShotAngleDiv()) + this.getShotDamage() + this.getShotPriorityTarget() + this.getShotPriorityKey() + Math.floor(this.getBlastRadius()) + this.getMass() + Math.floor(this.getMaxSpeed()) + Math.floor(this.getMaxSpeed()) + Math.floor(this.getMaxForce()) + Math.floor(this.getMaxEnergy()) + Math.floor(this.getSpinRate()) + Math.floor(this.getAnimAngleOffset()) + this.getAnimationDefSku() + this.getAmmoSku() + this.getStartLocked() + this.getUpgradeId() + this.getUnitTypeId() + this.getAttackGroundUnits() + this.getAttackAirUnits() + this.getLootPercentage() + this.getScoreDefense() + this.getScoreAttack();
      }
   }
}
