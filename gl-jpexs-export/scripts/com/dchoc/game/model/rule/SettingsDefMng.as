package com.dchoc.game.model.rule
{
   import com.dchoc.game.controller.entry.Entry;
   import com.dchoc.game.controller.entry.EntryFactory;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   
   public class SettingsDefMng extends DCDefMng
   {
      
      private static const RESOURCES_FILES:Vector.<String> = new <String>["settings.xml"];
       
      
      public var mSettingsDef:SettingsDef;
      
      private var mSpyCapsulesForFreeEntry:Entry;
      
      public function SettingsDefMng()
      {
         super(RESOURCES_FILES);
      }
      
      override protected function unloadDo() : void
      {
         this.mSettingsDef = null;
      }
      
      override protected function buildDefs() : void
      {
         super.buildDefs();
         this.mSettingsDef = SettingsDef(getDefBySku("1"));
      }
      
      public function areDefsCreated() : Boolean
      {
         return this.mSettingsDef != null;
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new SettingsDef();
      }
      
      public function getIncomePace() : Number
      {
         return this.mSettingsDef.getIncomePace();
      }
      
      public function getInstantOpTimeThreshold() : Number
      {
         return this.mSettingsDef.getInstantBuildThreshold();
      }
      
      public function getInstantBuildThreshold() : Number
      {
         return this.mSettingsDef.getInstantBuildThreshold();
      }
      
      public function getRepairMaxTime() : int
      {
         return this.mSettingsDef.getRepairMaxTime();
      }
      
      public function getHelpAccelerationTime() : Number
      {
         return this.mSettingsDef.getHelpAccelerationTime();
      }
      
      public function getHideNavBarInTutorial() : Number
      {
         return this.mSettingsDef.getHideNavBarInTutorial();
      }
      
      public function getSkipAttackDistancePopupIfFree() : Number
      {
         return this.mSettingsDef.getSkipAttackDistancePopupIfFree();
      }
      
      public function getUseStoryPopups() : Number
      {
         return this.mSettingsDef.getUseStoryPopup();
      }
      
      public function hasToShowStoryPopup() : Boolean
      {
         return this.getUseStoryPopups() != 0;
      }
      
      public function getHelpDailyVisitCoins() : Number
      {
         return this.mSettingsDef.getHelpDailyVisitCoins();
      }
      
      public function getHelpPercentageBonus() : Number
      {
         return this.mSettingsDef.getHelpPercentageBonus();
      }
      
      public function getRevengeTime() : Number
      {
         return this.mSettingsDef.getRevengeTime();
      }
      
      public function getMinPriceCoins() : int
      {
         return this.mSettingsDef.getMinPriceCoins();
      }
      
      public function getMinutePriceCoins() : Number
      {
         return this.mSettingsDef.getMinutePriceCoins();
      }
      
      public function getMinPricePremiumCurrency() : int
      {
         return this.mSettingsDef.getMinPricePremiumCurrency();
      }
      
      public function getBattleTime() : Number
      {
         return this.mSettingsDef.getBattleTime();
      }
      
      public function getBattleTimeNPC() : Number
      {
         return this.mSettingsDef.getBattleTimeNPC();
      }
      
      public function getBattleSafeResourceMinerals() : Number
      {
         return this.mSettingsDef.getBattleSafeResourceMinerals();
      }
      
      public function getBattleSafeResourceCoins() : Number
      {
         return this.mSettingsDef.getBattleSafeResourceCoins();
      }
      
      public function getInstantOperationCurrency() : String
      {
         return this.mSettingsDef.getInstantOperationsCurrency();
      }
      
      public function getDistanceThreshold() : Number
      {
         return this.mSettingsDef.getDistanceThreshold();
      }
      
      public function getColonyFactor() : Number
      {
         return this.mSettingsDef.getColonyFactor();
      }
      
      public function getAttackCost() : Number
      {
         return this.mSettingsDef.getAttackCost();
      }
      
      public function getMinPriceColony() : Number
      {
         return this.mSettingsDef.getMinPriceColony();
      }
      
      public function getBattleEndTime() : Number
      {
         return this.mSettingsDef.getBattleEndTime();
      }
      
      public function getScoreBuiltFactor() : Number
      {
         return 1;
      }
      
      public function getScoreAttackFactor() : Number
      {
         return 1;
      }
      
      public function getScoreDefenseFactor() : Number
      {
         return 1;
      }
      
      public function getWaitForIntroTimeOut() : Number
      {
         var returnValue:Number = 0;
         if(this.mSettingsDef != null)
         {
            returnValue = this.mSettingsDef.getWaitForIntroTimeOut();
         }
         return returnValue;
      }
      
      public function getFriendsBarRandomPlayers() : int
      {
         return this.mSettingsDef.getFriendsBarRandomPlayers();
      }
      
      public function getNoFriendsBarRandomPlayers() : int
      {
         return this.mSettingsDef.getNoFriendsBarRandomPlayers();
      }
      
      public function getSpyCapsulesForFreeTime() : int
      {
         return this.mSettingsDef.getSpyCapsulesForFreeTime();
      }
      
      public function getSpyCapsulesForFreeItems() : String
      {
         return this.mSettingsDef.getSpyCapsulesForFreeItems();
      }
      
      public function getSpyCapsulesForFreeItemsEntry() : Entry
      {
         if(this.mSpyCapsulesForFreeEntry == null)
         {
            this.mSpyCapsulesForFreeEntry = EntryFactory.createSingleEntryFromString(this.mSettingsDef.getSpyCapsulesForFreeItems());
            this.mSpyCapsulesForFreeEntry.setParam("checkLimit",false);
         }
         return this.mSpyCapsulesForFreeEntry;
      }
      
      public function getExtraBattleTimeTrigger() : int
      {
         return this.mSettingsDef.getExtraBattleTimeTrigger();
      }
      
      public function getMercenariesUnlockMissionSku() : String
      {
         return this.mSettingsDef.getMercenariesUnlockMissionSku();
      }
      
      public function getMoveColonyCostPC() : int
      {
         return this.mSettingsDef.getMoveColonyCostPC();
      }
      
      public function getAttackCostStoragePercentage() : int
      {
         return this.mSettingsDef.getAttackCostStoragePercentage();
      }
      
      public function getShowPopupInviteAfterTutorial() : int
      {
         return this.mSettingsDef.getShowPopupInviteAfterTutorial();
      }
      
      public function getLootDamageFactor() : int
      {
         return this.mSettingsDef.getLootDamageFactor();
      }
      
      public function getMinDiscountUpgrade() : int
      {
         return this.mSettingsDef.getMinDiscountUpgrade();
      }
      
      public function getMaxDiscountUpgrade() : int
      {
         return this.mSettingsDef.getMaxDiscountUpgrade();
      }
      
      public function getQuickAttackPreviewCountdown() : int
      {
         return this.mSettingsDef.getQuickAttackPreviewCountdown();
      }
      
      public function getOnlineProtectionWarning() : Number
      {
         return this.mSettingsDef.getOnlineProtectionWarning();
      }
      
      public function getStartNowReminderRecurrenceTime() : Number
      {
         return this.mSettingsDef.getStartNowReminderRecurrenceTime();
      }
      
      public function getUpSellingDuration() : Number
      {
         return this.mSettingsDef.getUpSellingDuration();
      }
   }
}
