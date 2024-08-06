package com.dchoc.game.model.rule
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.utils.anticheat.SecureBoolean;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.game.utils.anticheat.SecureString;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class SettingsDef extends DCDef
   {
      
      public static const FIELD_PC_TO_COINS_PC:String = "pcToCoins";
      
      public static const FIELD_PC_TO_MINERALS_PC:String = "pcToMinerals";
      
      public static const FIELD_INITIAL_PC_PC:String = "initialPc";
      
      public static const NO_USE_POPUP_INVITE_AFTER_TUTORIAL:int = 0;
      
      public static const USE_POPUP_INVITE_AFTER_TUTORIAL:int = 1;
      
      public static const USE_POPUP_INVITE_AFTER_TUTORIAL_WITH_CLOSE_BUTTON:int = 2;
       
      
      public var mDefaultCoins:SecureInt;
      
      public var mDefaultMinerals:SecureInt;
      
      public var mDefaultDroids:SecureInt;
      
      public var mDefaultMineralCapacity:SecureInt;
      
      public var mDestroyItemProfitPercentage:SecureNumber;
      
      public var mCancelBuildingUpgradeProfitPercentage:SecureNumber;
      
      public var mMinutesToCoins:SecureInt;
      
      public var mMinutesToMinerals:SecureInt;
      
      public var mCoinsToOneUSD:SecureInt;
      
      public var mMinPriceCoins:SecureInt;
      
      private var mMinutePriceCoins:SecureNumber;
      
      public var mMinPricePremiumCurrency:SecureInt;
      
      public var mPremiumCurrencyToUSD:SecureNumber;
      
      private var mInstantOperationsCurrency:SecureString;
      
      private var mMysteryGiftActionTime:SecureNumber;
      
      private var mHideNavBarInTutorial:SecureInt;
      
      private var mSkipAttackDistancePopupIfFree:SecureInt;
      
      private var mUseStoryPopups:SecureInt;
      
      public var mMaxMineralsAllUpgraded:SecureNumber;
      
      public var mMaxCoinsALlUpgraded:SecureNumber;
      
      private var mInstantBuildThreshold:SecureNumber;
      
      private var mInstantRepairThreshold:SecureNumber;
      
      private var mInstantRepairPriceChips:SecureInt;
      
      private var mInstantRepairBasicPrice:SecureInt;
      
      private var mInstantRepairMinPrice:SecureInt;
      
      private var mRepairMaxTime:SecureInt;
      
      private var mIncomePace:SecureNumber;
      
      private var mCollectablesThreshold:SecureInt;
      
      private var mRepairingTimeFactor:SecureNumber;
      
      private var mHelpAccelerationTime:SecureNumber;
      
      private var mHelpDailyVisitCoins:SecureNumber;
      
      private var mHelpPercentageBonus:SecureNumber;
      
      private var mRevengeTime:SecureNumber;
      
      private var mIdleTime:SecureInt;
      
      private var mLootingXpCoinsFactor:SecureNumber;
      
      private var mLootingXpMineralsFactor:SecureNumber;
      
      private var mHelpMaxActionsReward:SecureInt;
      
      private var mMaxObstacles:SecureInt;
      
      private var mBattleTime:SecureNumber;
      
      private var mBattleTimeNPC:SecureNumber;
      
      private var mBattleSafeResourceMinerals:SecureNumber;
      
      private var mBattleSafeResourceCoins:SecureNumber;
      
      private var mDistanceThreshold:SecureNumber;
      
      private var mColonyFactor:SecureNumber;
      
      private var mAttackCost:SecureNumber;
      
      private var mMinPriceColony:SecureNumber;
      
      private var mBattleEndTime:SecureNumber;
      
      private var mShowFreeOffers:SecureBoolean;
      
      private var mDefaultCreditsIndex:SecureInt;
      
      private var mWIOTooltipTimeOut:SecureNumber;
      
      private var mWaitForIntroTimeOut:SecureNumber;
      
      private var mFriendsBarRandomPlayers:SecureInt;
      
      private var mNoFriendsBarRandomPlayers:SecureInt;
      
      private var mSpyCapsulesForFreeTime:SecureInt;
      
      private var mSpyCapsulesForFreeItems:SecureString;
      
      private var mExtraBattleTimeTrigger:SecureInt;
      
      private var mMercenariesUnlockMissionSku:SecureString;
      
      private var mMoveColonyCostPC:SecureInt;
      
      private var mAttackCostStoragePercentage:SecureInt;
      
      private var mPopupAfterTutorial:SecureInt;
      
      private var mShowCrossPromoPopup:SecureInt;
      
      private var mLootDamageFactor:SecureInt;
      
      private var mMinDiscountUpgrade:SecureInt;
      
      private var mMaxDiscountUpgrade:SecureInt;
      
      private var mQuickAttackPreviewCountdown:SecureInt;
      
      private var mOnlineProtectionWarning:SecureInt;
      
      private var mStartNowReminderRecurrenceTime:SecureInt;
      
      private var mUpSellingDuration:SecureNumber;
      
      private var mPremiumShopUnlockLevel:SecureInt;
      
      private var mEmbassyDiscounts:SecureString;
      
      private var mMaxCubesPerDay:SecureInt;
      
      private var mStarlingColorPrice:SecureInt;
      
      public function SettingsDef()
      {
         mDefaultCoins = new SecureInt("SettingsDef.mDefaultCoins");
         mDefaultMinerals = new SecureInt("SettingsDef.mDefaultMinerals");
         mDefaultDroids = new SecureInt("SettingsDef.mDefaultDroids");
         mDefaultMineralCapacity = new SecureInt("SettingsDef.mDefaultMineralCapacity");
         mDestroyItemProfitPercentage = new SecureNumber("SettingsDef.mDestroyItemProfitPercentage");
         mCancelBuildingUpgradeProfitPercentage = new SecureNumber("SettingsDef.mCancelBuildingUpgradeProfitPercentage");
         mMinutesToCoins = new SecureInt("SettingsDef.mMinutesToCoins");
         mMinutesToMinerals = new SecureInt("SettingsDef.mMinutesToMinerals");
         mCoinsToOneUSD = new SecureInt("SettingsDef.mCoinsToOneUSD");
         mMinPriceCoins = new SecureInt("SettingsDef.mMinPriceCoins");
         mMinutePriceCoins = new SecureNumber("SettingsDef.mMinutePriceCoins");
         mMinPricePremiumCurrency = new SecureInt("SettingsDef.mMinPricePremiumCurrency");
         mPremiumCurrencyToUSD = new SecureNumber("SettingsDef.mPremiumCurrencyToUSD");
         mInstantOperationsCurrency = new SecureString("SettingsDef.mInstantOperationsCurrency","");
         mMysteryGiftActionTime = new SecureNumber("SettingsDef.mMysteryGiftActionTime");
         mHideNavBarInTutorial = new SecureInt("SettingsDef.mHideNavBarInTutorial",1);
         mSkipAttackDistancePopupIfFree = new SecureInt("SettingsDef.mSkipAttackDistancePopupIfFree");
         mUseStoryPopups = new SecureInt("SettingsDef.mUseStoryPopups");
         mMaxMineralsAllUpgraded = new SecureNumber("SettingsDef.mMaxMineralsAllUpgraded");
         mMaxCoinsALlUpgraded = new SecureNumber("SettingsDef.mMaxCoinsALlUpgraded");
         mInstantBuildThreshold = new SecureNumber("SettingsDef.mInstantBuildThreshold");
         mInstantRepairThreshold = new SecureNumber("SettingsDef.mInstantRepairThreshold");
         mInstantRepairPriceChips = new SecureInt("SettingsDef.mInstantRepairPriceChips");
         mInstantRepairBasicPrice = new SecureInt("SettingsDef.mInstantRepairBasicPrice");
         mInstantRepairMinPrice = new SecureInt("SettingsDef.mInstantRepairMinPrice");
         mRepairMaxTime = new SecureInt("SettingsDef.mRepairMaxTime");
         mIncomePace = new SecureNumber("SettingsDef.mIncomePace");
         mCollectablesThreshold = new SecureInt("SettingsDef.mCollectablesThreshold");
         mRepairingTimeFactor = new SecureNumber("SettingsDef.mRepairingTimeFactor");
         mHelpAccelerationTime = new SecureNumber("SettingsDef.mHelpAccelerationTime");
         mHelpDailyVisitCoins = new SecureNumber("SettingsDef.mHelpDailyVisitCoins");
         mHelpPercentageBonus = new SecureNumber("SettingsDef.mHelpPercentageBonus");
         mRevengeTime = new SecureNumber("SettingsDef.mRevengeTime");
         mIdleTime = new SecureInt("SettingsDef.mIdleTime");
         mLootingXpCoinsFactor = new SecureNumber("SettingsDef.mLootingXpCoinsFactor");
         mLootingXpMineralsFactor = new SecureNumber("SettingsDef.mLootingXpMineralsFactor");
         mHelpMaxActionsReward = new SecureInt("SettingsDef.mHelpMaxActionsReward");
         mMaxObstacles = new SecureInt("SettingsDef.mMaxObstacles");
         mBattleTime = new SecureNumber("SettingsDef.mBattleTime");
         mBattleTimeNPC = new SecureNumber("SettingsDef.mBattleTimeNPC");
         mBattleSafeResourceMinerals = new SecureNumber("SettingsDef.mBattleSafeResourceMinerals");
         mBattleSafeResourceCoins = new SecureNumber("SettingsDef.mBattleSafeResourceCoins");
         mDistanceThreshold = new SecureNumber("SettingsDef.mDistanceThreshold");
         mColonyFactor = new SecureNumber("SettingsDef.mColonyFactor");
         mAttackCost = new SecureNumber("SettingsDef.mAttackCost");
         mMinPriceColony = new SecureNumber("SettingsDef.mMinPriceColony");
         mBattleEndTime = new SecureNumber("SettingsDef.mBattleEndTime");
         mShowFreeOffers = new SecureBoolean("SettingsDef.mShowFreeOffers");
         mDefaultCreditsIndex = new SecureInt("SettingsDef.mDefaultCreditsIndex");
         mWIOTooltipTimeOut = new SecureNumber("SettingsDef.mWIOTooltipTimeOut");
         mWaitForIntroTimeOut = new SecureNumber("SettingsDef.mWaitForIntroTimeOut");
         mFriendsBarRandomPlayers = new SecureInt("SettingsDef.mFriendsBarRandomPlayers");
         mNoFriendsBarRandomPlayers = new SecureInt("SettingsDef.mNoFriendsBarRandomPlayers");
         mSpyCapsulesForFreeTime = new SecureInt("SettingsDef.mSpyCapsulesForFreeTime");
         mSpyCapsulesForFreeItems = new SecureString("SettingsDef.mSpyCapsulesForFreeItems","");
         mExtraBattleTimeTrigger = new SecureInt("SettingsDef.mExtraBattleTimeTrigger");
         mMercenariesUnlockMissionSku = new SecureString("SettingsDef.mMercenariesUnlockMissionSku","");
         mMoveColonyCostPC = new SecureInt("SettingsDef.mMoveColonyCostPC");
         mAttackCostStoragePercentage = new SecureInt("SettingsDef.mAttackCostStoragePercentage");
         mPopupAfterTutorial = new SecureInt("SettingsDef.mPopupAfterTutorial");
         mShowCrossPromoPopup = new SecureInt("SettingsDef.mShowCrossPromoPopup");
         mLootDamageFactor = new SecureInt("SettingsDef.mLootDamageFactor",1);
         mMinDiscountUpgrade = new SecureInt("SettingsDef.mMinDiscountUpgrade");
         mMaxDiscountUpgrade = new SecureInt("SettingsDef.mMaxDiscountUpgrade");
         mQuickAttackPreviewCountdown = new SecureInt("SettingsDef.mQuickAttackPreviewCountdown");
         mOnlineProtectionWarning = new SecureInt("SettingsDef.mOnlineProtectionWarning");
         mStartNowReminderRecurrenceTime = new SecureInt("SettingsDef.mStartNowReminderRecurrenceTime");
         mUpSellingDuration = new SecureNumber("SettingsDef.mUpSellingDuration");
         mPremiumShopUnlockLevel = new SecureInt("SettingsDef.mPremiumShopUnlockLevel");
         mEmbassyDiscounts = new SecureString("SettingsDef.mEmbassyDiscounts");
         mMaxCubesPerDay = new SecureInt("SettingsDef.mMaxCubesPerDay");
         mStarlingColorPrice = new SecureInt("SettingsDef.mStarlingColorPrice");
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         var time:int = 0;
         paidCurrencyRead("pcToCoins",info);
         paidCurrencyRead("pcToMinerals",info);
         paidCurrencyRead("initialPc",info);
         var attribute:String = "maxMineralAmount";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMaxMineralAmount(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "resourcesIncomePace";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setIncomePace(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "defaultDroids";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setDefaultDroids(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "defaultMineralCapacity";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setDefaultMineralCapacity(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "destroyItemProfitPercentage";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setDestroyItemProfitPercentage(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "cancelBuildingUpgradeProfitPercentage";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setCancelBuildingUpgradeProfitPercentage(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "minutesToCoins";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMinutesToCoins(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "minutesToMinerals";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMinutesToMinerals(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "initialCoins";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setDefaultCoins(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "initialMinerals";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setDefaultMinerals(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "instantBuildThreshold";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setInstantBuildThreshold(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "instantRepairThreshold";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setInstantRepairThreshold(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "instantRepairPriceChips";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setInstantRepairPriceChips(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "instantRepairBasicPrice";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setInstantRepairBasicPrice(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "instantRepairMinPrice";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setInstantRepairMinPrice(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "repairFullBarTime";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setRepairMaxTime(DCTimerUtil.secondToMs(EUtils.xmlReadInt(info,attribute)));
         }
         attribute = "collectablesThreshold";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mCollectablesThreshold.value = EUtils.xmlReadInt(info,attribute);
         }
         attribute = "repairCost";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setRepairTimeFactor(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "coinsToOneUSD";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setCoinsToOneUSD(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "maxMineralsCapacityAllUpgraded";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMaxMineralsAllUpgraded(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "maxCoinsCapacityAllUpgraded";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMaxCoinsAllUpgraded(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "helpAccelerationTime";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setHelpAccelerationTime(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "helpDailyVisitCoins";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setHelpDailyVisitCoins(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "helpMaxActionsReward";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mHelpMaxActionsReward.value = EUtils.xmlReadInt(info,attribute);
         }
         attribute = "helpPercentageBonus";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setHelpPercentageBonus(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "revengeTime";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setRevengeTime(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "idleTime";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mIdleTime.value = EUtils.xmlReadInt(info,attribute);
         }
         attribute = "instantBuildMinPrice";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mMinPriceCoins.value = EUtils.xmlReadInt(info,attribute);
         }
         attribute = "instantBuildPrice";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMinutePriceCoins(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "minPricePremiumCurrency";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mMinPricePremiumCurrency.value = EUtils.xmlReadInt(info,attribute);
         }
         attribute = "fbcToOneUSD";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setPremiumCurrencyToOneUSD(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "bootyXpCoins";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setLootingXpCoinsFactor(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "bootyXpMinerals";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setLootingXpMineralsFactor(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "maxObstacles";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mMaxObstacles.value = EUtils.xmlReadInt(info,attribute);
         }
         attribute = "battleTime";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setBattleTime(DCTimerUtil.minToMs(EUtils.xmlReadNumber(info,attribute)));
         }
         attribute = "battleTimeNPC";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setBattleTimeNPC(DCTimerUtil.minToMs(EUtils.xmlReadNumber(info,attribute)));
         }
         attribute = "battleSafeResourceCoins";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setBattleSafeResourceCoins(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "battleSafeResourceMinerals";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setBattleSafeResourceMinerals(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "instantOperationsCurrency";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setInstantOperationsCurrency(EUtils.xmlReadString(info,attribute));
         }
         attribute = "distanceThreshold";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setDistanceThreshold(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "colonyFactor";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setColonyFactor(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "attackCost";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setAttackCost(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "minPriceColony";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMinPriceColony(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "battleEndTime";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setBattleEndTime(DCTimerUtil.minToMs(EUtils.xmlReadNumber(info,attribute)));
         }
         attribute = "mysteryGiftActionTime";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMysteryGiftActionTime(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "showFreeOffers";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setShowFreeOffers(EUtils.xmlReadBoolean(info,attribute));
         }
         attribute = "defaultCreditsIndex";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setDefaultCreditsIndex(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "wioTooltipTimeout";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setWIOTooltipTimeout(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "waitForIntroTimeOut";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setWaitForIntroTimeOut(DCTimerUtil.secondToMs(EUtils.xmlReadNumber(info,attribute)));
         }
         attribute = "hideNavigationBarInTutorial";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setHideNavBarInTutorial(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "skipAttackDistancePopupIfFree";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setSkipAttackDistancePopupIfFree(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "useStoryPopups";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setUseStoryPopup(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "friendsBarRandomPlayers";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setFriendsBarRandomPlayers(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "noFriendsBarRandomPlayers";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setNoFriendsBarRandomPlayers(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "spyCapsulesForFreeTime";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setSpyCapsulesForFreeTime(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "spyCapsulesForFreeItems";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setSpyCapsulesForFreeItems(EUtils.xmlReadString(info,attribute));
         }
         attribute = "extraBattleTimeTrigger";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setExtraBattleTimeTrigger(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "mercenariesUnlockMissionSku";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMercenariesUnlockMissionSku(EUtils.xmlReadString(info,attribute));
         }
         attribute = "moveColonyCostPC";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMoveColonyCostPC(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "attackCostStoragePercentage";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setAttackCostStoragePercentage(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "popupInviteAfterTutorial";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setShowPopupInviteAfterTutorial(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "showCrossPromoPopup";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setShowCrossPromoPopup(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "lootDamageFactor";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setLootDamageFactor(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "minDiscountUpgrade";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMinDiscountUpgrade(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "maxDiscountUpgrade";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMaxDiscountUpgrade(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "quickAttackPreviewCountdown";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setQuickAttackPreviewCountdown(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "onlineProtectionWarning";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setOnlineProtectionWarning(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "startNowReminderRecurrenceTime";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setStartNowReminderRecurrenceTime(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "upSellingDuration";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            time = EUtils.xmlReadInt(info,attribute);
            this.setUpSellingDuration(DCTimerUtil.minToMs(time));
         }
         attribute = "premiumShopUnlockLevel";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setPremiumShopUnlockLevel(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "embassyDiscounts";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setEmbassyDiscounts(EUtils.xmlReadString(info,attribute));
         }
         attribute = "maxCubesPerDay";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMaxCubesPerDay(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "starlingColorPrice";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setStarlingColorPrice(EUtils.xmlReadInt(info,attribute));
         }
      }
      
      public function getUpSellingDuration() : Number
      {
         return this.mUpSellingDuration.value;
      }
      
      private function setUpSellingDuration(value:Number) : void
      {
         this.mUpSellingDuration.value = value;
      }
      
      private function setMysteryGiftActionTime(value:Number) : void
      {
         this.mMysteryGiftActionTime.value = value;
      }
      
      public function getMysteryGiftActionTime() : Number
      {
         return this.mMysteryGiftActionTime.value;
      }
      
      private function setInstantOperationsCurrency(value:String) : void
      {
         this.mInstantOperationsCurrency.value = value;
      }
      
      public function getInstantOperationsCurrency() : String
      {
         return this.mInstantOperationsCurrency.value;
      }
      
      private function setMinutePriceCoins(value:Number) : void
      {
         this.mMinutePriceCoins.value = value;
      }
      
      public function getMinutePriceCoins() : Number
      {
         return this.mMinutePriceCoins.value;
      }
      
      private function setLootingXpCoinsFactor(value:Number) : void
      {
         this.mLootingXpCoinsFactor.value = value;
      }
      
      private function setLootingXpMineralsFactor(value:Number) : void
      {
         this.mLootingXpMineralsFactor.value = value;
      }
      
      public function getLootingXpFromMinerals(value:Number) : Number
      {
         return value * this.mLootingXpMineralsFactor.value;
      }
      
      public function getLootingXpFromCoins(value:Number) : Number
      {
         return value * this.mLootingXpCoinsFactor.value;
      }
      
      public function getHelpMaxActionsReward() : int
      {
         return this.mHelpMaxActionsReward.value;
      }
      
      private function setRepairTimeFactor(value:Number) : void
      {
         this.mRepairingTimeFactor.value = DCTimerUtil.secondToMs(value);
      }
      
      public function getRepairingTimeFactor() : Number
      {
         return this.mRepairingTimeFactor.value;
      }
      
      public function getCashToCoins() : Number
      {
         return InstanceMng.getRuleMng().paidCurrencyGetField(this,"pcToCoins").mAmount;
      }
      
      public function getCashToMinerals() : Number
      {
         return InstanceMng.getRuleMng().paidCurrencyGetField(this,"pcToMinerals").mAmount;
      }
      
      public function setMaxMineralAmount(maxMineralAmount:Number) : void
      {
         InstanceMng.getUserInfoMng().getCurrentProfileLoaded().setMineralsCapacityAmount(maxMineralAmount);
      }
      
      public function getIncomePace() : Number
      {
         return this.mIncomePace.value;
      }
      
      public function setIncomePace(value:Number) : void
      {
         this.mIncomePace.value = DCTimerUtil.secondToMs(value);
      }
      
      public function getDefaultDroids() : Number
      {
         return this.mDefaultDroids.value;
      }
      
      private function setDefaultDroids(value:Number) : void
      {
         this.mDefaultDroids.value = value;
      }
      
      public function getDefaultMineralCapacity() : Number
      {
         return this.mDefaultMineralCapacity.value;
      }
      
      private function setDefaultMineralCapacity(value:Number) : void
      {
         this.mDefaultMineralCapacity.value = value;
      }
      
      public function getDestroyItemProfitPercentage() : Number
      {
         return this.mDestroyItemProfitPercentage.value;
      }
      
      private function setDestroyItemProfitPercentage(value:Number) : void
      {
         this.mDestroyItemProfitPercentage.value = value;
      }
      
      public function getCancelBuildingUpgradeProfitPercentage() : Number
      {
         return this.mCancelBuildingUpgradeProfitPercentage.value;
      }
      
      private function setCancelBuildingUpgradeProfitPercentage(value:Number) : void
      {
         this.mCancelBuildingUpgradeProfitPercentage.value = value;
      }
      
      private function setMinutesToCoins(value:Number) : void
      {
         this.mMinutesToCoins.value = value;
      }
      
      public function getMinutesToCoins() : Number
      {
         return this.mMinutesToCoins.value;
      }
      
      private function setMinutesToMinerals(value:Number) : void
      {
         this.mMinutesToMinerals.value = value;
      }
      
      public function getMinutesToMinerals() : Number
      {
         return this.mMinutesToMinerals.value;
      }
      
      private function setCoinsToOneUSD(value:Number) : void
      {
         this.mCoinsToOneUSD.value = value;
      }
      
      public function getCoinsToOneUSD() : Number
      {
         return this.mCoinsToOneUSD.value;
      }
      
      private function setPremiumCurrencyToOneUSD(value:Number) : void
      {
         this.mPremiumCurrencyToUSD.value = 1 / value;
      }
      
      public function getPremiumCurrencyToOneUSD() : Number
      {
         return this.mPremiumCurrencyToUSD.value;
      }
      
      private function setMaxMineralsAllUpgraded(value:Number) : void
      {
         this.mMaxMineralsAllUpgraded.value = value;
      }
      
      public function getMaxMineralsAllUpgraded() : Number
      {
         return this.mMaxMineralsAllUpgraded.value;
      }
      
      private function setMaxCoinsAllUpgraded(value:Number) : void
      {
         this.mMaxCoinsALlUpgraded.value = value;
      }
      
      public function getMaxCoinsAllUpgraded() : Number
      {
         return this.mMaxCoinsALlUpgraded.value;
      }
      
      public function getDefaultCash() : Number
      {
         return InstanceMng.getRuleMng().paidCurrencyGetField(this,"initialPc").mAmount;
      }
      
      private function setDefaultCoins(value:Number) : void
      {
         this.mDefaultCoins.value = value;
      }
      
      public function getDefaultCoins() : Number
      {
         return this.mDefaultCoins.value;
      }
      
      private function setDefaultMinerals(value:Number) : void
      {
         this.mDefaultMinerals.value = value;
      }
      
      public function getDefaultMinerals() : Number
      {
         return this.mDefaultMinerals.value;
      }
      
      public function setInstantBuildThreshold(value:int) : void
      {
         this.mInstantBuildThreshold.value = value;
      }
      
      public function getInstantBuildThreshold() : int
      {
         return this.mInstantBuildThreshold.value;
      }
      
      public function setInstantRepairThreshold(value:int) : void
      {
         this.mInstantRepairThreshold.value = value;
      }
      
      public function getInstantRepairThreshold() : int
      {
         return this.mInstantRepairThreshold.value;
      }
      
      public function getInstantRepairPriceChips() : int
      {
         return this.mInstantRepairPriceChips.value;
      }
      
      public function setInstantRepairPriceChips(value:int) : void
      {
         this.mInstantRepairPriceChips.value = value;
      }
      
      public function getInstantRepairBasicPrice() : int
      {
         return this.mInstantRepairBasicPrice.value;
      }
      
      public function setInstantRepairBasicPrice(value:int) : void
      {
         this.mInstantRepairBasicPrice.value = value;
      }
      
      public function getInstantRepairMinPrice() : int
      {
         return this.mInstantRepairMinPrice.value;
      }
      
      public function setInstantRepairMinPrice(value:int) : void
      {
         this.mInstantRepairMinPrice.value = value;
      }
      
      private function setRepairMaxTime(value:int) : void
      {
         this.mRepairMaxTime.value = value;
      }
      
      public function getRepairMaxTime() : int
      {
         return this.mRepairMaxTime.value;
      }
      
      public function getCollectablesThreshold() : int
      {
         return this.mCollectablesThreshold.value;
      }
      
      private function setHelpAccelerationTime(value:Number) : void
      {
         this.mHelpAccelerationTime.value = value;
      }
      
      public function getHelpAccelerationTime() : Number
      {
         return this.mHelpAccelerationTime.value;
      }
      
      private function setHelpDailyVisitCoins(value:Number) : void
      {
         this.mHelpDailyVisitCoins.value = value;
      }
      
      public function getHelpDailyVisitCoins() : Number
      {
         return this.mHelpDailyVisitCoins.value;
      }
      
      private function setHelpPercentageBonus(value:Number) : void
      {
         this.mHelpPercentageBonus.value = value;
      }
      
      public function getHelpPercentageBonus() : Number
      {
         return this.mHelpPercentageBonus.value;
      }
      
      private function setRevengeTime(value:Number) : void
      {
         this.mRevengeTime.value = DCTimerUtil.hourToMs(value);
      }
      
      public function getRevengeTime() : Number
      {
         return this.mRevengeTime.value;
      }
      
      public function getIdleTime() : Number
      {
         return DCTimerUtil.minToMs(this.mIdleTime.value);
      }
      
      public function getMinPriceCoins() : int
      {
         return this.mMinPriceCoins.value;
      }
      
      public function getMinPricePremiumCurrency() : int
      {
         return this.mMinPricePremiumCurrency.value;
      }
      
      public function getMaxObstacles() : int
      {
         return this.mMaxObstacles.value;
      }
      
      public function getBattleTime() : Number
      {
         return this.mBattleTime.value;
      }
      
      public function getBattleTimeNPC() : Number
      {
         return this.mBattleTimeNPC.value;
      }
      
      private function setBattleTime(value:Number) : void
      {
         this.mBattleTime.value = value;
      }
      
      private function setBattleTimeNPC(value:Number) : void
      {
         this.mBattleTimeNPC.value = value;
      }
      
      public function getBattleSafeResourceCoins() : Number
      {
         return this.mBattleSafeResourceCoins.value;
      }
      
      private function setBattleSafeResourceCoins(value:Number) : void
      {
         this.mBattleSafeResourceCoins.value = value;
      }
      
      public function getBattleSafeResourceMinerals() : Number
      {
         return this.mBattleSafeResourceMinerals.value;
      }
      
      private function setBattleSafeResourceMinerals(value:Number) : void
      {
         this.mBattleSafeResourceMinerals.value = value;
      }
      
      private function setDistanceThreshold(value:Number) : void
      {
         this.mDistanceThreshold.value = value;
      }
      
      public function getDistanceThreshold() : Number
      {
         return this.mDistanceThreshold.value;
      }
      
      private function setColonyFactor(value:Number) : void
      {
         this.mColonyFactor.value = value;
      }
      
      public function getColonyFactor() : Number
      {
         return this.mColonyFactor.value;
      }
      
      private function setAttackCost(value:Number) : void
      {
         this.mAttackCost.value = value;
      }
      
      public function getAttackCost() : Number
      {
         return this.mAttackCost.value;
      }
      
      private function setMinPriceColony(value:Number) : void
      {
         this.mMinPriceColony.value = value;
      }
      
      public function getMinPriceColony() : Number
      {
         return this.mMinPriceColony.value;
      }
      
      public function setBattleEndTime(value:Number) : void
      {
         this.mBattleEndTime.value = value;
      }
      
      public function getBattleEndTime() : Number
      {
         return this.mBattleEndTime.value;
      }
      
      public function setShowFreeOffers(value:Boolean) : void
      {
         this.mShowFreeOffers.value = value;
      }
      
      public function getShowFreeOffers() : Boolean
      {
         return this.mShowFreeOffers.value && InstanceMng.getPlatformSettingsDefMng().getUseFreeOffers() > 0;
      }
      
      public function setDefaultCreditsIndex(value:int) : void
      {
         this.mDefaultCreditsIndex.value = value;
      }
      
      public function getDefaultCreditsIndex() : int
      {
         return this.mDefaultCreditsIndex.value;
      }
      
      private function setWIOTooltipTimeout(value:Number) : void
      {
         this.mWIOTooltipTimeOut.value = value;
      }
      
      public function getWIOTooltipTimeOut() : Number
      {
         return this.mWIOTooltipTimeOut.value;
      }
      
      private function setWaitForIntroTimeOut(value:Number) : void
      {
         this.mWaitForIntroTimeOut.value = value;
      }
      
      public function getWaitForIntroTimeOut() : Number
      {
         return this.mWaitForIntroTimeOut.value;
      }
      
      private function setHideNavBarInTutorial(value:Number) : void
      {
         this.mHideNavBarInTutorial.value = value;
      }
      
      public function getHideNavBarInTutorial() : Number
      {
         return this.mHideNavBarInTutorial.value;
      }
      
      private function setSkipAttackDistancePopupIfFree(value:Number) : void
      {
         this.mSkipAttackDistancePopupIfFree.value = value;
      }
      
      public function getSkipAttackDistancePopupIfFree() : Number
      {
         return this.mSkipAttackDistancePopupIfFree.value;
      }
      
      private function setUseStoryPopup(value:Number) : void
      {
         this.mUseStoryPopups.value = value;
      }
      
      public function getUseStoryPopup() : Number
      {
         return this.mUseStoryPopups.value;
      }
      
      private function setFriendsBarRandomPlayers(value:int) : void
      {
         this.mFriendsBarRandomPlayers.value = value;
      }
      
      public function getFriendsBarRandomPlayers() : int
      {
         return this.mFriendsBarRandomPlayers.value;
      }
      
      private function setNoFriendsBarRandomPlayers(value:int) : void
      {
         this.mNoFriendsBarRandomPlayers.value = value;
      }
      
      public function getNoFriendsBarRandomPlayers() : int
      {
         return this.mNoFriendsBarRandomPlayers.value;
      }
      
      private function setSpyCapsulesForFreeTime(value:int) : void
      {
         this.mSpyCapsulesForFreeTime.value = value;
      }
      
      public function getSpyCapsulesForFreeTime() : int
      {
         return this.mSpyCapsulesForFreeTime.value;
      }
      
      private function setSpyCapsulesForFreeItems(value:String) : void
      {
         this.mSpyCapsulesForFreeItems.value = value;
      }
      
      public function getSpyCapsulesForFreeItems() : String
      {
         return this.mSpyCapsulesForFreeItems.value;
      }
      
      private function setExtraBattleTimeTrigger(value:int) : void
      {
         this.mExtraBattleTimeTrigger.value = value;
      }
      
      public function getExtraBattleTimeTrigger() : int
      {
         return this.mExtraBattleTimeTrigger.value;
      }
      
      private function setMercenariesUnlockMissionSku(value:String) : void
      {
         this.mMercenariesUnlockMissionSku.value = value;
      }
      
      public function getMercenariesUnlockMissionSku() : String
      {
         return this.mMercenariesUnlockMissionSku.value;
      }
      
      private function setMoveColonyCostPC(value:int) : void
      {
         this.mMoveColonyCostPC.value = value;
      }
      
      public function getMoveColonyCostPC() : int
      {
         return this.mMoveColonyCostPC.value;
      }
      
      private function setAttackCostStoragePercentage(value:int) : void
      {
         this.mAttackCostStoragePercentage.value = value;
      }
      
      public function getAttackCostStoragePercentage() : int
      {
         return this.mAttackCostStoragePercentage.value;
      }
      
      private function setShowPopupInviteAfterTutorial(value:int) : void
      {
         this.mPopupAfterTutorial.value = value;
      }
      
      public function getShowPopupInviteAfterTutorial() : int
      {
         return this.mPopupAfterTutorial.value;
      }
      
      private function setShowCrossPromoPopup(value:int) : void
      {
         this.mShowCrossPromoPopup.value = value;
      }
      
      public function getShowCrossPromoPopup() : int
      {
         return this.mShowCrossPromoPopup.value;
      }
      
      private function setLootDamageFactor(value:int) : void
      {
         this.mLootDamageFactor.value = value;
      }
      
      public function getLootDamageFactor() : int
      {
         return this.mLootDamageFactor.value;
      }
      
      private function setMinDiscountUpgrade(value:int) : void
      {
         this.mMinDiscountUpgrade.value = value;
      }
      
      public function getMinDiscountUpgrade() : int
      {
         return this.mMinDiscountUpgrade.value;
      }
      
      private function setMaxDiscountUpgrade(value:int) : void
      {
         this.mMaxDiscountUpgrade.value = value;
      }
      
      public function getMaxDiscountUpgrade() : int
      {
         return this.mMaxDiscountUpgrade.value;
      }
      
      private function setQuickAttackPreviewCountdown(value:int) : void
      {
         this.mQuickAttackPreviewCountdown.value = value;
      }
      
      public function getQuickAttackPreviewCountdown() : int
      {
         return this.mQuickAttackPreviewCountdown.value;
      }
      
      private function setOnlineProtectionWarning(value:int) : void
      {
         this.mOnlineProtectionWarning.value = value;
      }
      
      public function getOnlineProtectionWarning() : Number
      {
         return DCTimerUtil.minToMs(this.mOnlineProtectionWarning.value);
      }
      
      private function setStartNowReminderRecurrenceTime(value:int) : void
      {
         this.mStartNowReminderRecurrenceTime.value = value;
      }
      
      public function getStartNowReminderRecurrenceTime() : Number
      {
         return DCTimerUtil.hourToMs(this.mStartNowReminderRecurrenceTime.value);
      }
      
      private function setPremiumShopUnlockLevel(value:int) : void
      {
         this.mPremiumShopUnlockLevel.value = value;
      }
      
      public function getPremiumShopUnlockLevel() : int
      {
         return this.mPremiumShopUnlockLevel.value;
      }
      
      private function setEmbassyDiscounts(value:String) : void
      {
         this.mEmbassyDiscounts.value = value;
      }
      
      public function getEmbassyDiscounts() : String
      {
         return this.mEmbassyDiscounts.value;
      }
      
      private function setMaxCubesPerDay(value:int) : void
      {
         this.mMaxCubesPerDay.value = value;
      }
      
      public function getMaxCubesPerDay() : int
      {
         return this.mMaxCubesPerDay.value;
      }
      
      private function setStarlingColorPrice(value:int) : void
      {
         this.mStarlingColorPrice.value = value;
      }
      
      public function getStarlingColorPrice() : int
      {
         return this.mStarlingColorPrice.value;
      }
      
      override protected function getSigDo() : String
      {
         return "" + this.getBattleTime();
      }
   }
}
