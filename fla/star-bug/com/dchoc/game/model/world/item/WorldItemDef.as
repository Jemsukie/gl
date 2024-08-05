package com.dchoc.game.model.world.item
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.space.PlanetDef;
   import com.dchoc.game.model.unit.FireWorksMng;
   import com.dchoc.game.model.unit.defs.UnitDef;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.utils.anticheat.SecureBoolean;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.game.utils.anticheat.SecureString;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import esparragon.utils.EUtils;
   import flash.utils.Dictionary;
   
   public class WorldItemDef extends UnitDef
   {
      
      private static var smTemp:Array;
      
      public static const EXTRA_ASSET_KEY_COLONY:String = "colony";
      
      public static const SKU_HQ:String = "wonders_headquarters";
      
      public static const SKU_LABORATORY:String = "labs_001_001";
      
      public static const SKU_OBSERVATORY:String = "labs_observatory";
      
      public static const UNLOCK_TYPE_LEVEL:String = "level";
      
      public static const UNLOCK_TYPE_MISSION:String = "mission";
      
      private static const FIELD_CONSTRUCTION_PC:String = "construction";
      
      private static const FIELD_UNLOCK_PC:String = "unlock";
      
      private static const ACTION_FIREWORKS:String = "fireworks";
      
      private static const BROKEN_TYPE_HOUSES:int = 0;
      
      private static const BROKEN_TYPE_DEFENSES:int = 1;
      
      public static const BROKEN_LEVELS_COUNT:int = 1;
      
      public static const BROKEN_HOUSES_VISUAL_LEVELS:Vector.<int> = new <int>[33,99];
      
      private static var smBrokenVisualLevels:Vector.<int> = new <int>[0,0];
       
      
      private var mSecureBaseCols:SecureInt;
      
      private var mSecureBaseRows:SecureInt;
      
      private var mConstructionTime:SecureNumber;
      
      private var mConstructionXp:SecureNumber;
      
      private var mIncomeSpeed:SecureNumber;
      
      private var mIncomeXpFactor:SecureNumber;
      
      private var mIncomeCapacity:SecureNumber;
      
      private var mIncomeCapacityProgressBar:SecureNumber;
      
      private var mIncomePerMinute:SecureNumber;
      
      private var mIncomePerMinuteProgressBar:SecureNumber;
      
      private var mIncomeCurrencyId:SecureInt;
      
      private var mIncomeTime:SecureNumber;
      
      private var mMineralsStorage:SecureNumber;
      
      private var mMineralsStorageProgressBar:SecureNumber;
      
      private var mCoinsStorage:SecureNumber;
      
      private var mCoinsStorageProgressBar:SecureNumber;
      
      private var mExtraLootWhenDeadPercent:SecureNumber;
      
      private var mIcon:SecureString;
      
      private var mUnlockCash:SecureInt;
      
      private var mUnlockCondition:SecureString;
      
      private var mUnlockConditionParam:SecureString;
      
      private var mConstructionCoins:SecureInt;
      
      private var mConstructionMineral:SecureInt;
      
      private var mInstantBuildFactor:SecureNumber;
      
      private var mShipsFiles:SecureString;
      
      private var mShipCapacity:SecureInt;
      
      private var mShipCapacityProgressBar:SecureInt;
      
      private var mInfluenceAreaRadius:SecureInt;
      
      private var mInfluenceAreaRadiusProgressBar:SecureInt;
      
      private var mInfluenceAreaRows:SecureInt;
      
      private var mInfluenceAreaCols:SecureInt;
      
      private var mInfluenceAreaRowsProgressBar:SecureInt;
      
      private var mInfluenceAreaColsProgressBar:SecureInt;
      
      private var mMaxNumPerHQUpgradeId:Array;
      
      private var mCanReborn:SecureBoolean;
      
      private var mSlotsCapacities:Vector.<int>;
      
      private var mSlotsCapacitiesTotal:SecureInt;
      
      private var mSlotsUnlockPrice:Array;
      
      private var mRepairMaxTime:SecureNumber;
      
      private var mCanBeRide:SecureBoolean;
      
      private var mIsPlayable:SecureBoolean;
      
      private var mPlayAction:SecureString;
      
      private var mZOrder:SecureInt;
      
      private var mAnimOnBase:SecureString;
      
      private var mBackgroundsAllowed:Vector.<String>;
      
      private var mExtraFlaFolder:Dictionary = null;
      
      private var mExtraAssetId:Dictionary = null;
      
      private var mFlatAssetId:SecureString;
      
      private var mCostQuickAttack:SecureNumber;
      
      private var mRefineryStages:SecureString;
      
      public function WorldItemDef()
      {
         mSecureBaseCols = new SecureInt("WorldItemDef.mSecureBaseCols");
         mSecureBaseRows = new SecureInt("WorldItemDef.mSecureBaseRows");
         mConstructionTime = new SecureNumber("WorldItemDef.mConstructionTime");
         mConstructionXp = new SecureNumber("WorldItemDef.mConstructionXp");
         mIncomeSpeed = new SecureNumber("WorldItemDef.mIncomeSpeed");
         mIncomeXpFactor = new SecureNumber("WorldItemDef.mIncomeXpFactor");
         mIncomeCapacity = new SecureNumber("WorldItemDef.mIncomeCapacity");
         mIncomeCapacityProgressBar = new SecureNumber("WorldItemDef.mIncomeCapacityProgressBar");
         mIncomePerMinute = new SecureNumber("WorldItemDef.mIncomePerMinute");
         mIncomePerMinuteProgressBar = new SecureNumber("WorldItemDef.mIncomePerMinuteProgressBar");
         mIncomeCurrencyId = new SecureInt("WorldItemDef.mIncomeCurrencyId");
         mIncomeTime = new SecureNumber("WorldItemDef.mIncomeTime");
         mMineralsStorage = new SecureNumber("WorldItemDef.mMineralsStorage");
         mMineralsStorageProgressBar = new SecureNumber("WorldItemDef.mMineralsStorageProgressBar");
         mCoinsStorage = new SecureNumber("WorldItemDef.mCoinsStorage");
         mCoinsStorageProgressBar = new SecureNumber("WorldItemDef.mCoinsStorageProgressBar");
         mExtraLootWhenDeadPercent = new SecureNumber("WorldItemDef.mExtraLootWhenDeadPercent");
         mIcon = new SecureString("WorldItemDef.mIcon","");
         mUnlockCash = new SecureInt("WorldItemDef.mUnlockCash");
         mUnlockCondition = new SecureString("WorldItemDef.mUnlockCondition","");
         mUnlockConditionParam = new SecureString("WorldItemDef.mUnlockConditionParam","");
         mConstructionCoins = new SecureInt("WorldItemDef.mConstructionCoins");
         mConstructionMineral = new SecureInt("WorldItemDef.mConstructionMineral");
         mInstantBuildFactor = new SecureNumber("WorldItemDef.mInstantBuildFactor");
         mShipsFiles = new SecureString("WorldItemDef.mShipsFiles","");
         mShipCapacity = new SecureInt("WorldItemDef.mShipCapacity");
         mShipCapacityProgressBar = new SecureInt("WorldItemDef.mShipCapacityProgressBar");
         mInfluenceAreaRadius = new SecureInt("WorldItemDef.mInfluenceAreaRadius");
         mInfluenceAreaRadiusProgressBar = new SecureInt("WorldItemDef.mInfluenceAreaRadiusProgressBar");
         mInfluenceAreaRows = new SecureInt("WorldItemDef.mInfluenceAreaRows");
         mInfluenceAreaCols = new SecureInt("WorldItemDef.mInfluenceAreaCols");
         mInfluenceAreaRowsProgressBar = new SecureInt("WorldItemDef.mInfluenceAreaRowsProgressBar");
         mInfluenceAreaColsProgressBar = new SecureInt("WorldItemDef.mInfluenceAreaColsProgressBar");
         mCanReborn = new SecureBoolean("WorldItemDef.mCanReborn");
         mSlotsCapacitiesTotal = new SecureInt("WorldItemDef.mSlotsCapacitiesTotal");
         mRepairMaxTime = new SecureNumber("WorldItemDef.mRepairMaxTime");
         mCanBeRide = new SecureBoolean("WorldItemDef.mCanBeRide");
         mIsPlayable = new SecureBoolean("WorldItemDef.mIsPlayable");
         mPlayAction = new SecureString("WorldItemDef.mPlayAction","");
         mZOrder = new SecureInt("WorldItemDef.mZOrder");
         mAnimOnBase = new SecureString("WorldItemDef.mAnimOnBase");
         mFlatAssetId = new SecureString("WorldItemDef.mFlatAssetId");
         mCostQuickAttack = new SecureNumber("WorldItemDef.mCostQuickAttack");
         mRefineryStages = new SecureString("WorldItemDef.mRefineryStages");
         super();
         setAnimAngleOffset(-1.5707963267948966);
      }
      
      public function getFlaFolderByKey(key:String) : String
      {
         var returnValue:String = null;
         if(this.mExtraFlaFolder != null)
         {
            returnValue = String(this.mExtraFlaFolder[key]);
         }
         return returnValue;
      }
      
      public function getAssetIdByKey(key:String) : String
      {
         var returnValue:String = null;
         if(this.mExtraAssetId != null)
         {
            returnValue = String(this.mExtraAssetId[key]);
         }
         return returnValue;
      }
      
      public function getFlatAssetId() : String
      {
         return this.mFlatAssetId.value;
      }
      
      public function setFlatAssetId(value:String) : void
      {
         this.mFlatAssetId.value = value;
      }
      
      private function setExtraFlaFolder(value:String) : void
      {
         var token:String = null;
         var words:Array = null;
         var word:String = null;
         this.mExtraAssetId = null;
         var tokens:Array = value.split(",");
         for each(token in tokens)
         {
            words = token.split(":");
            for each(word in words)
            {
               if(this.mExtraFlaFolder == null)
               {
                  this.mExtraFlaFolder = new Dictionary();
               }
               this.mExtraFlaFolder[words[0]] = words[1];
            }
         }
      }
      
      private function setExtraAssetId(value:String) : void
      {
         var token:String = null;
         var words:Array = null;
         var word:String = null;
         this.mExtraAssetId = null;
         var tokens:Array = value.split(",");
         for each(token in tokens)
         {
            words = token.split(":");
            for each(word in words)
            {
               if(this.mExtraAssetId == null)
               {
                  this.mExtraAssetId = new Dictionary();
               }
               this.mExtraAssetId[words[0]] = words[1];
            }
         }
      }
      
      public function set mBaseCols(value:int) : void
      {
         this.mSecureBaseCols.value = value;
      }
      
      public function get mBaseCols() : int
      {
         return this.mSecureBaseCols.value;
      }
      
      public function set mBaseRows(value:int) : void
      {
         this.mSecureBaseRows.value = value;
      }
      
      public function get mBaseRows() : int
      {
         return this.mSecureBaseRows.value;
      }
      
      override public function build() : void
      {
         var tiles:Number = NaN;
         super.build();
         switch(mTypeId)
         {
            case 0:
               this.mIncomeCurrencyId.value = 1;
               break;
            case 1:
               this.mIncomeCurrencyId.value = 2;
               break;
            case 2:
               this.mIncomeCurrencyId.value = 3;
         }
         var bRadius:Number = getBoundingRadius();
         if(isNaN(bRadius) || bRadius == 0)
         {
            tiles = this.mBaseCols < this.mBaseRows ? this.mBaseCols : this.mBaseRows;
            tiles /= 3;
            setBoundingRadius(tiles * 22);
         }
         setShotDistanceProgressBar(this.mInfluenceAreaRadiusProgressBar.value);
         InstanceMng.getWorldItemDefMng().basesRegister(this.mBaseCols,this.mBaseRows);
      }
      
      public function getWorkingTypeId() : int
      {
         return this.isHeadQuarters() ? 2 : mTypeId;
      }
      
      public function getFormat() : int
      {
         var pos:int = 0;
         var returnValue:int = -1;
         if(mAssetFile != null)
         {
            pos = mAssetFile.indexOf(".swf");
            if(pos == -1)
            {
               returnValue = 2;
            }
            else
            {
               returnValue = 3;
            }
         }
         return returnValue;
      }
      
      override public function getAssetFile() : String
      {
         return "assets/flash/world_items/" + mAssetFile;
      }
      
      public function getBaseCols() : int
      {
         return this.mBaseCols;
      }
      
      private function setBaseCols(value:int) : void
      {
         this.mBaseCols = value;
      }
      
      public function getBaseRows() : int
      {
         return this.mBaseRows;
      }
      
      private function setBaseRows(value:int) : void
      {
         this.mBaseRows = value;
      }
      
      public function getBaseSize() : int
      {
         return this.mBaseCols * this.mBaseRows;
      }
      
      public function getZOrder() : int
      {
         return this.mZOrder.value;
      }
      
      public function setZOrder(value:int) : void
      {
         this.mZOrder.value = value;
      }
      
      public function getConstructionTime() : Number
      {
         return this.mConstructionTime.value;
      }
      
      private function setConstructionTime(value:Number) : void
      {
         this.mConstructionTime.value = DCTimerUtil.minToMs(value);
      }
      
      public function getConstructionXp() : Number
      {
         return this.mConstructionXp.value;
      }
      
      public function setConstructionXp(value:Number) : void
      {
         this.mConstructionXp.value = value;
      }
      
      public function getIncomeTime() : Number
      {
         return this.mIncomeTime.value;
      }
      
      private function setIncomeTime(value:Number) : void
      {
         this.mIncomeTime.value = DCTimerUtil.hourToMs(value);
      }
      
      public function getIncomeSpeed() : Number
      {
         var profile:Profile = InstanceMng.getUserInfoMng().getCurrentProfileLoaded();
         var planetSku:String = profile.getCurrentPlanetOrderSku();
         var planetDef:PlanetDef = PlanetDef(InstanceMng.getPlanetDefMng().getDefBySku(planetSku));
         var factor:Number = 1;
         return this.mIncomeSpeed.value * factor;
      }
      
      private function setIncomeSpeed(value:Number) : void
      {
         this.mIncomeSpeed.value = value;
      }
      
      private function setIncomeXpFactor(value:Number) : void
      {
         this.mIncomeXpFactor.value = value;
      }
      
      public function getIncomeCapacity() : Number
      {
         return this.mIncomeCapacity.value;
      }
      
      private function setIncomeCapacity(value:Number) : void
      {
         this.mIncomeCapacity.value = value;
      }
      
      public function getIncomeCapacityProgressBar() : Number
      {
         return this.mIncomeCapacityProgressBar.value;
      }
      
      private function setIncomeCapacityProgressBar(value:Number) : void
      {
         this.mIncomeCapacityProgressBar.value = value;
      }
      
      private function setIncomePerMinute(value:Number) : void
      {
         this.mIncomePerMinute.value = value;
      }
      
      public function getIncomePerMinute() : int
      {
         return this.mIncomePerMinute.value;
      }
      
      private function setIncomePerMinuteProgressBar(value:Number) : void
      {
         this.mIncomePerMinuteProgressBar.value = value;
      }
      
      public function getIncomePerMinuteProgressBar() : int
      {
         return this.mIncomePerMinuteProgressBar.value;
      }
      
      public function getIncomeCurrencyId() : int
      {
         return this.mIncomeCurrencyId.value;
      }
      
      private function setIncomeCurrency(key:String) : void
      {
         this.mIncomeCurrencyId.value = GameConstants.currencyGetIdFromKey(key);
      }
      
      public function getIncomeNumPacesFromTime(time:Number) : int
      {
         return time / InstanceMng.getSettingsDefMng().getIncomePace();
      }
      
      public function getIncomeAmountFromTime(time:Number) : Number
      {
         if(time < 0)
         {
            time = 0;
         }
         return time == this.mIncomeTime.value ? this.mIncomeCapacity.value : Math.floor(this.getIncomeNumPacesFromTime(time) * this.getIncomeSpeed());
      }
      
      public function getIncomeAmountFromTimeLineal(time:Number) : Number
      {
         return Math.floor(time * this.mIncomeCapacity.value / this.mIncomeTime.value);
      }
      
      public function getIncomeXp(incomeAmount:Number) : Number
      {
         return incomeAmount * this.mIncomeXpFactor.value;
      }
      
      public function getMineralsStorage() : Number
      {
         return this.mMineralsStorage.value;
      }
      
      private function setMineralsStorage(value:Number) : void
      {
         this.mMineralsStorage.value = value;
      }
      
      public function getCoinsStorage() : Number
      {
         return this.mCoinsStorage.value;
      }
      
      private function setCoinsStorage(value:Number) : void
      {
         this.mCoinsStorage.value = value;
      }
      
      public function getMineralsStorageProgressBar() : Number
      {
         return this.mMineralsStorageProgressBar.value;
      }
      
      private function setMineralsStorageProgressBar(value:Number) : void
      {
         this.mMineralsStorageProgressBar.value = value;
      }
      
      public function getCoinsStorageProgressBar() : Number
      {
         return this.mCoinsStorageProgressBar.value;
      }
      
      private function setCoinsStorageProgressBar(value:Number) : void
      {
         this.mCoinsStorageProgressBar.value = value;
      }
      
      public function getExtraLootWhenDeadPercent() : Number
      {
         return this.mExtraLootWhenDeadPercent.value;
      }
      
      private function setExtraLootWhenDeadPercent(value:Number) : void
      {
         this.mExtraLootWhenDeadPercent.value = value;
      }
      
      public function getMaxNumPerHQUpgradeId(hqUpgradeId:int) : int
      {
         var returnValue:int = 0;
         if(this.mMaxNumPerHQUpgradeId != null && hqUpgradeId < this.mMaxNumPerHQUpgradeId.length)
         {
            returnValue = int(this.mMaxNumPerHQUpgradeId[hqUpgradeId]);
         }
         else
         {
            if(Config.DEBUG_ASSERTS)
            {
               DCDebug.trace("ERROR in WorldItemDef.getMaxNumPerHQLevel(): maxNumPerHQUpgradeId is not defined for sku = " + mSku + " and HQ upgradeId = " + hqUpgradeId,1);
            }
            if(this.mMaxNumPerHQUpgradeId != null)
            {
               returnValue = int(this.mMaxNumPerHQUpgradeId[this.mMaxNumPerHQUpgradeId.length - 1]);
            }
            else
            {
               returnValue = 0;
            }
         }
         return returnValue;
      }
      
      public function getHQUpgradeIdForHavingNumItems(numItems:int) : int
      {
         var length:int = 0;
         var i:int = 0;
         if(this.mMaxNumPerHQUpgradeId != null)
         {
            length = int(this.mMaxNumPerHQUpgradeId.length);
            while(i < length && this.mMaxNumPerHQUpgradeId[i] < numItems)
            {
               i++;
            }
            if(i == length)
            {
               i = -1;
            }
         }
         return i;
      }
      
      private function setMaxNumPerHQUpgradeId(value:String) : void
      {
         var t:String = null;
         var num:int = 0;
         var tokens:Array = value.split(",");
         this.mMaxNumPerHQUpgradeId = [];
         var hqUpgradeIdIsUnlocked:* = 0;
         for each(t in tokens)
         {
            num = int(t);
            if(this.isHeadQuarters())
            {
               num++;
            }
            if(getUpgradeId() > 0)
            {
               num--;
               hqUpgradeIdIsUnlocked = num;
            }
            else if(num == 0)
            {
               hqUpgradeIdIsUnlocked++;
            }
            this.mMaxNumPerHQUpgradeId.push(num);
         }
         setUnlockHQUpgradeIdRequired(hqUpgradeIdIsUnlocked);
      }
      
      public function getUnlockCash() : int
      {
         return InstanceMng.getRuleMng().paidCurrencyGetField(this,"unlock").mAmount;
      }
      
      public function getUnlockCondition() : String
      {
         return this.mUnlockCondition.value;
      }
      
      private function setUnlockCondition(value:String) : void
      {
         this.mUnlockCondition.value = value;
      }
      
      public function getUnlockConditionParam() : String
      {
         return this.mUnlockConditionParam.value;
      }
      
      private function setUnlockConditionParam(value:String) : void
      {
         this.mUnlockConditionParam.value = value;
      }
      
      public function getConstructionCash() : int
      {
         return InstanceMng.getRuleMng().paidCurrencyGetField(this,"construction").mAmount;
      }
      
      public function getInstantBuildFactor() : Number
      {
         return this.mInstantBuildFactor.value;
      }
      
      private function setInstantBuildFactor(value:Number) : void
      {
         this.mInstantBuildFactor.value = value;
      }
      
      public function getConstructionCoins() : int
      {
         return this.mConstructionCoins.value;
      }
      
      private function setConstructionCoins(value:int) : void
      {
         this.mConstructionCoins.value = value;
      }
      
      public function getConstructionMineral() : int
      {
         return this.mConstructionMineral.value;
      }
      
      private function setConstructionMineral(value:int) : void
      {
         this.mConstructionMineral.value = value;
      }
      
      public function getIcon() : String
      {
         var flaFolder:String = null;
         var assetId:String = null;
         if(this.mIcon.value == "")
         {
            if(this.isHeadQuarters() && !InstanceMng.getUserInfoMng().getCurrentProfileLoaded().isCurrentPlanetCapital())
            {
               flaFolder = this.getFlaFolderByKey("colony");
               assetId = this.getAssetIdByKey("colony");
            }
            else
            {
               flaFolder = getFlaFolder();
               assetId = getAssetId();
            }
            return flaFolder + assetId + "_ready";
         }
         return this.mIcon.value;
      }
      
      public function getAssetIdShop() : String
      {
         return this.getAssetId() + "_shop";
      }
      
      private function setIcon(value:String) : void
      {
         this.mIcon.value = value.toLocaleLowerCase();
      }
      
      public function getShipsFiles() : String
      {
         return this.mShipsFiles.value;
      }
      
      private function setShipsFiles(value:String) : void
      {
         this.mShipsFiles.value = value;
      }
      
      public function getShipCapacity() : int
      {
         return this.mShipCapacity.value;
      }
      
      private function setShipCapacity(value:int) : void
      {
         this.mShipCapacity.value = value;
      }
      
      public function getShipCapacityProgressBar() : int
      {
         return this.mShipCapacityProgressBar.value;
      }
      
      private function setShipCapacityProgressBar(value:int) : void
      {
         this.mShipCapacityProgressBar.value = value;
      }
      
      public function setRepairingTime(value:Number) : void
      {
         this.mRepairMaxTime.value = value;
      }
      
      public function getRepairingTime() : Number
      {
         return this.mRepairMaxTime.value;
      }
      
      public function getStepablePerimeter() : int
      {
         return mTypeId == 4 || mTypeId == 12 || isAWall() || this.mBaseCols == 1 && this.mBaseRows == 1 ? 0 : 1;
      }
      
      public function hasInfluenceArea() : Boolean
      {
         return (this.isABunker() || mTypeId == 6) && getShotDistance() > 0;
      }
      
      public function hasCupola() : Boolean
      {
         return this.isABunker() || mTypeId == 6 && !isAMine();
      }
      
      public function getCanReborn() : Boolean
      {
         return this.mCanReborn.value;
      }
      
      private function setCanReborn(value:Boolean) : void
      {
         this.mCanReborn.value = value;
      }
      
      public function getSlotsCapacitiesProgressBar() : int
      {
         return this.mSlotsCapacitiesTotal.value;
      }
      
      public function getSlotCapacity(slotId:int) : int
      {
         if(this.mSlotsCapacities.length <= slotId)
         {
            slotId = this.mSlotsCapacities.length - 1;
         }
         return this.mSlotsCapacities[slotId];
      }
      
      private function setSlotsCapacities(value:String) : void
      {
         var str:String = null;
         var capacity:int = 0;
         if(this.mSlotsCapacities == null)
         {
            this.mSlotsCapacities = new Vector.<int>(0);
         }
         else
         {
            this.mSlotsCapacities.length = 0;
            this.mSlotsCapacitiesTotal.value = 0;
         }
         this.mSlotsCapacities.push(1);
         smTemp = value.split(",");
         for each(str in smTemp)
         {
            capacity = parseInt(str);
            this.mSlotsCapacities.push(capacity);
            this.mSlotsCapacitiesTotal.value += capacity;
         }
      }
      
      public function getSlotsCapacitiesTotal() : int
      {
         return this.mSlotsCapacitiesTotal.value;
      }
      
      private function setSlotsUnlockPrice(value:Array) : void
      {
         this.mSlotsUnlockPrice = value;
      }
      
      public function getSlotsUnlockPrice() : Array
      {
         return this.mSlotsUnlockPrice;
      }
      
      private function setCanBeRide(value:Boolean) : void
      {
         this.mCanBeRide.value = value;
      }
      
      public function getCanBeRide() : Boolean
      {
         return this.mCanBeRide.value;
      }
      
      private function setIsPlayable(value:Boolean) : void
      {
         this.mIsPlayable.value = value;
      }
      
      public function isPlayable() : Boolean
      {
         return this.mIsPlayable.value;
      }
      
      private function setPlayAction(value:String) : void
      {
         this.mPlayAction.value = value;
      }
      
      public function getPlayAction() : String
      {
         return this.mPlayAction.value;
      }
      
      public function playAction() : Boolean
      {
         if(!this.isPlayable())
         {
            return false;
         }
         if(this.getPlayAction() == "fireworks")
         {
            FireWorksMng.getInstance().showFireworks(10000);
            return true;
         }
         return false;
      }
      
      private function setAnimOnBase(value:String) : void
      {
         this.mAnimOnBase.value = value;
      }
      
      public function getAnimOnBase() : String
      {
         return this.mAnimOnBase.value;
      }
      
      private function setCostQuickAttack(value:Number) : void
      {
         this.mCostQuickAttack.value = value;
      }
      
      public function getCostQuickAttack() : Number
      {
         return this.mCostQuickAttack.value;
      }
      
      private function setRefineryStages(value:String) : void
      {
         this.mRefineryStages.value = value;
      }
      
      public function getRefineryStages() : String
      {
         return this.mRefineryStages.value;
      }
      
      override protected function doFromXml(info:XML) : void
      {
         var unlockCondition:String = null;
         var unlockConditionArray:Array = null;
         var isComplex:* = false;
         super.doFromXml(info);
         var attribute:String = "extraFlaFolder";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setExtraFlaFolder(EUtils.xmlReadString(info,attribute));
         }
         attribute = "extraAssetId";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setExtraAssetId(EUtils.xmlReadString(info,attribute));
         }
         attribute = "flatAssetId";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setFlatAssetId(EUtils.xmlReadString(info,attribute));
         }
         attribute = "baseCols";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setBaseCols(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "baseRows";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setBaseRows(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "constructionTime";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setConstructionTime(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "exp";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setConstructionXp(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "unlockCondition";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            unlockCondition = EUtils.xmlReadString(info,attribute);
            unlockConditionArray = unlockCondition.split(":");
            isComplex = unlockConditionArray.length > 1;
            unlockCondition = String(unlockConditionArray[0]);
            this.setUnlockCondition(unlockCondition);
            if(isComplex)
            {
               this.setUnlockConditionParam(unlockConditionArray[1]);
            }
         }
         attribute = "constructionCoins";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setConstructionCoins(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "constructionMineral";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setConstructionMineral(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "instantBuildFactor";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setInstantBuildFactor(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "icon";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setIcon(EUtils.xmlReadString(info,attribute));
         }
         else if(this.mIcon.value == "")
         {
            this.setIcon("");
         }
         attribute = "incomeCapacity";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setIncomeCapacity(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "incomeCapacityProgressBar";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setIncomeCapacityProgressBar(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "incomeTime";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setIncomeTime(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "incomeSpeed";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setIncomeSpeed(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "xpPerPace";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setIncomeXpFactor(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "incomeCurrency";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setIncomeCurrency(EUtils.xmlReadString(info,attribute));
         }
         attribute = "incomePerMinute";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setIncomePerMinute(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "incomePerMinuteProgressBar";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setIncomePerMinuteProgressBar(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "mineralsStorage";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMineralsStorage(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "mineralsStorageProgressBar";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMineralsStorageProgressBar(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "coinsStorage";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setCoinsStorage(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "coinsStorageProgressBar";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setCoinsStorageProgressBar(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "extraLootWhenDeadPercent";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setExtraLootWhenDeadPercent(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "energy";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            setMaxEnergy(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "energyProgressBar";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            setMaxEnergyProgressBar(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "shipsFiles";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setShipsFiles(EUtils.xmlReadString(info,attribute));
         }
         attribute = "storageAmount";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setShipCapacity(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "storageAmountProgressBar";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setShipCapacityProgressBar(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "repairTime";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setRepairingTime(DCTimerUtil.minToMs(EUtils.xmlReadNumber(info,attribute)));
         }
         attribute = "maxNumPerHQLevel";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMaxNumPerHQUpgradeId(EUtils.xmlReadString(info,attribute));
         }
         attribute = "canBorn";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setCanReborn(EUtils.xmlReadString(info,attribute) == "yes");
         }
         attribute = "slotCapacity";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setSlotsCapacities(EUtils.xmlReadString(info,attribute));
         }
         if(EUtils.xmlIsAttribute(info,"slot3CashPrice") && EUtils.xmlIsAttribute(info,"slot4CashPrice") && EUtils.xmlIsAttribute(info,"slot2CashPrice"))
         {
            this.setSlotsUnlockPrice([EUtils.xmlReadInt(info,"slot2CashPrice"),EUtils.xmlReadInt(info,"slot3CashPrice"),EUtils.xmlReadInt(info,"slot4CashPrice")]);
         }
         attribute = "canBeRide";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setCanBeRide(EUtils.xmlReadBoolean(info,attribute));
         }
         attribute = "isPlayable";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setIsPlayable(EUtils.xmlReadBoolean(info,attribute));
         }
         attribute = "playAction";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setPlayAction(EUtils.xmlReadString(info,attribute));
         }
         attribute = "zOrder";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setZOrder(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "animOnBase";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setAnimOnBase(EUtils.xmlReadString(info,attribute));
         }
         attribute = "backgroundSkuAllowed";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.addBackgroundSkuAllowed(EUtils.xmlReadString(info,attribute));
         }
         attribute = "costQuickAttack";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setCostQuickAttack(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "refineryStages";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setRefineryStages(EUtils.xmlReadString(info,attribute));
         }
         paidCurrencyRead("unlock",info);
         paidCurrencyRead("construction",info);
         var typeId:int = Config.useOptSenseWalls() && isAWall() ? 5 : 4;
         setUnitTypeId(typeId);
      }
      
      private function addBackgroundSkuAllowed(bgSku:String) : void
      {
         var skusArr:Array = null;
         var i:int = 0;
         var sku:String = null;
         var alreadyAdded:Boolean = false;
         var isValid:Boolean = false;
         if(bgSku != "")
         {
            if(this.mBackgroundsAllowed == null)
            {
               this.mBackgroundsAllowed = new Vector.<String>(0);
            }
            skusArr = bgSku.split(",");
            alreadyAdded = false;
            for(i = 0; i < skusArr.length; )
            {
               alreadyAdded = false;
               for each(sku in this.mBackgroundsAllowed)
               {
                  if(sku == skusArr[i])
                  {
                     alreadyAdded = true;
                  }
               }
               isValid = skusArr[i] != "" && skusArr[i] != null;
               if(!alreadyAdded && isValid)
               {
                  this.mBackgroundsAllowed.push(skusArr[i]);
               }
               i++;
            }
         }
      }
      
      public function getBackgroundSkusAllowed() : Vector.<String>
      {
         return this.mBackgroundsAllowed;
      }
      
      public function isTakenIntoConsiderationInBattle() : Boolean
      {
         return !isAWall() && !isAMine() && !isAnEnemyAttractor();
      }
      
      public function isHeadQuarters() : Boolean
      {
         return mSku == "wonders_headquarters";
      }
      
      public function isARentResource() : Boolean
      {
         return this.mIncomeTime.value > 0;
      }
      
      public function needsHQConnection() : Boolean
      {
         return !this.isHeadQuarters() && mTypeId != 4 && mTypeId != 12;
      }
      
      private function needsBaseGround() : Boolean
      {
         return true;
      }
      
      public function needsGround() : Boolean
      {
         return mTypeId != 4 && mTypeId != 12 && this.needsBaseGround();
      }
      
      public function canBeDemolished() : Boolean
      {
         return !this.isHeadQuarters() && !this.isAnObservatory() && !this.isASilo();
      }
      
      public function usesPath() : Boolean
      {
         return this.needsHQConnection() || this.isHeadQuarters();
      }
      
      public function hasBuildingProcess() : Boolean
      {
         var returnValue:Boolean = mTypeId != 4 && mTypeId != 12 && this.mConstructionTime.value > 0;
         if(this.isAWall() || this.isAMine())
         {
            return false;
         }
         return returnValue;
      }
      
      public function hasDemolitionProgressBar() : Boolean
      {
         return true;
      }
      
      public function needsAnUnit() : Boolean
      {
         return mTypeId != 4 && mTypeId != 12;
      }
      
      override public function shotCanBeATarget() : Boolean
      {
         return this.needsAnUnit() && super.shotCanBeATarget();
      }
      
      public function canSpawnCivils() : Boolean
      {
         return mTypeId == 0 || mTypeId == 1 || mTypeId == 2 || mTypeId == 9;
      }
      
      public function canGenerateResources() : Boolean
      {
         return mTypeId == 0 || mTypeId == 1;
      }
      
      public function isAResources() : Boolean
      {
         return mTypeId == 0 || mTypeId == 1;
      }
      
      public function isAHangar() : Boolean
      {
         return mTypeId == 7;
      }
      
      public function isABunker() : Boolean
      {
         return mTypeId == 8;
      }
      
      public function isAShipyard() : Boolean
      {
         return mTypeId == 3;
      }
      
      public function isAnEmbassy() : Boolean
      {
         return belongsToGroup("embassy");
      }
      
      public function isAnObservatory() : Boolean
      {
         return belongsToGroup("observatory");
      }
      
      public function isARefinery() : Boolean
      {
         return belongsToGroup("refinery");
      }
      
      public function isAWarpBunker() : Boolean
      {
         return belongsToGroup("warp");
      }
      
      public function isADecoration() : Boolean
      {
         return mTypeId == 4;
      }
      
      public function isADefense() : Boolean
      {
         return mTypeId == 6;
      }
      
      public function isAnObstacle() : Boolean
      {
         return mTypeId == 12;
      }
      
      public function isSpiable() : Boolean
      {
         return true;
      }
      
      public function isCapitalOnly() : Boolean
      {
         return this.isAnObservatory() || this.isARefinery() || this.isAnEmbassy();
      }
      
      public function canBeSteppedByOwnUnits() : Boolean
      {
         return isAWall();
      }
      
      public function canBeStepped() : Boolean
      {
         return mTypeId == 4 || mTypeId == 12;
      }
      
      public function requiresDroidToBePlaced() : Boolean
      {
         return !(this.mTypeId == 4 || this.mTypeId == 12);
      }
      
      public function requiresDroidToBeDemolished() : Boolean
      {
         return getTypeId() != 12 && !this.isAWall() && !this.isAMine();
      }
      
      public function isASilo() : Boolean
      {
         return this.isASiloOfCoins() || this.isASiloOfMinerals();
      }
      
      public function isASiloOfMinerals() : Boolean
      {
         return mTypeId == 2 && this.mMineralsStorage.value > 0;
      }
      
      public function isASiloOfCoins() : Boolean
      {
         return mTypeId == 2 && this.mCoinsStorage.value > 0;
      }
      
      public function isALabType() : Boolean
      {
         return mTypeId == 9;
      }
      
      public function isALaboratory() : Boolean
      {
         return belongsToGroup("laboratory");
      }
      
      public function showsNormalWhenUpgradingInBattle() : Boolean
      {
         return this.isADefense() || this.isABunker();
      }
      
      public function brokenGetVisualLevels() : Vector.<int>
      {
         var p:int = 0;
         var inc:int = 0;
         var i:int = 0;
         if(this.brokenGetType() == 1)
         {
            p = this.brokenGetEnergyPercentLogicLevel();
            inc = p / (1 - 1);
            smBrokenVisualLevels[0] = 100 - p;
            for(i = 1; i < 1 - 1; )
            {
               smBrokenVisualLevels[i] = smBrokenVisualLevels[i - 1] + inc;
               i++;
            }
            smBrokenVisualLevels[1 - 1] = 99;
            return smBrokenVisualLevels;
         }
         return BROKEN_HOUSES_VISUAL_LEVELS;
      }
      
      private function brokenGetType() : int
      {
         return mTypeId == 6 || mTypeId == 8 ? 1 : 0;
      }
      
      public function brokenGetEnergyPercentLogicLevel() : int
      {
         return this.brokenGetType() == 1 ? 0 : 99;
      }
      
      public function getMaxDef() : WorldItemDef
      {
         return InstanceMng.getWorldItemDefMng().getMaxUpgradeDefBySku(mSku);
      }
      
      public function getNextDef() : WorldItemDef
      {
         var nextDef:WorldItemDef = InstanceMng.getWorldItemDefMng().getDefBySkuAndUpgradeId(mSku,getUpgradeId() + 1);
         return nextDef == null ? this : nextDef;
      }
      
      override protected function getSigDo() : String
      {
         return super.getSigDo() + this.getBaseCols() + this.getBaseRows();
      }
   }
}
