package com.dchoc.game.model.rule
{
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   
   public class PlatformSettingsDefMng extends DCDefMng
   {
       
      
      public var mPlatformSettingsDef:PlatformSettingsDef;
      
      public function PlatformSettingsDefMng(resourceDefs:Vector.<String>, typeSkus:Vector.<String> = null, directoryPath:String = null)
      {
         super(resourceDefs,typeSkus,directoryPath);
      }
      
      override protected function unloadDo() : void
      {
         this.mPlatformSettingsDef = null;
      }
      
      override protected function buildDefs() : void
      {
         super.buildDefs();
         var platform:String = "facebook";
         var flashvars:Object = Star.getFlashVars();
         if(flashvars != null && flashvars.hasOwnProperty("platform"))
         {
            platform = String(flashvars.platform);
         }
         DCDebug.traceCh("platform","current platform is: " + platform);
         this.mPlatformSettingsDef = PlatformSettingsDef(getDefBySku(platform));
         Config.USE_NEWS_FEEDS = this.mPlatformSettingsDef.getUseNewsFeeds();
      }
      
      public function areDefsCreated() : Boolean
      {
         return this.mPlatformSettingsDef != null;
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new PlatformSettingsDef();
      }
      
      public function getUseNewsFeeds() : Boolean
      {
         return this.mPlatformSettingsDef.getUseNewsFeeds();
      }
      
      public function getClosePopupAfterPublish() : Boolean
      {
         return this.mPlatformSettingsDef.getClosePopupAfterPublish();
      }
      
      public function getUsePlatformCreditsPopup() : Boolean
      {
         return this.mPlatformSettingsDef.getUsePlatformCreditsPopup();
      }
      
      public function getUseInvestments() : Boolean
      {
         return this.mPlatformSettingsDef.getUseInvestments();
      }
      
      public function getUseFreeOffers() : int
      {
         return this.mPlatformSettingsDef.getUseFreeOffers();
      }
      
      public function getCurrencyIcon() : String
      {
         return this.mPlatformSettingsDef.getCurrencyIcon();
      }
      
      public function getCurrencyConversion() : Number
      {
         return this.mPlatformSettingsDef.getCurrencyConversion();
      }
      
      public function getCurrencyName() : String
      {
         return this.mPlatformSettingsDef.getCurrencyName();
      }
      
      public function getInviteIndividualFriendIsEnabled() : Boolean
      {
         return this.mPlatformSettingsDef.getInviteIndividualFriendIsEnabled();
      }
      
      public function getUsePopupInviteAfterTutorial() : Boolean
      {
         return this.mPlatformSettingsDef.getUsePopupInviteAfterTutorial();
      }
      
      public function hasOwnCurrency() : Boolean
      {
         return this.getCurrencyIcon() != null;
      }
      
      public function getUseMobilePayments() : Boolean
      {
         return this.mPlatformSettingsDef.getShowMobilePayments();
      }
      
      public function getUseInvite() : Boolean
      {
         return this.mPlatformSettingsDef.getUseInvite();
      }
      
      public function getShowRealMoney() : Boolean
      {
         return this.mPlatformSettingsDef.getShowRealMoney();
      }
      
      public function getUseStarTrekShop() : Boolean
      {
         return this.mPlatformSettingsDef.getUseStarTrekShop();
      }
      
      public function getLoadingScreenSku() : String
      {
         return this.mPlatformSettingsDef.getLoadingScreenSku();
      }
      
      public function canRefreshPage() : Boolean
      {
         return this.mPlatformSettingsDef.canRefreshPage();
      }
      
      public function getUseNaranjito() : Boolean
      {
         return this.mPlatformSettingsDef.getUseNaranjito();
      }
      
      public function getNewsFeedsResolution() : String
      {
         return this.mPlatformSettingsDef.getNewsFeedsResolution();
      }
      
      public function getCurrentPlatformSku() : String
      {
         return this.mPlatformSettingsDef == null ? "" : this.mPlatformSettingsDef.mSku;
      }
      
      public function isPaymentsEnabled() : Boolean
      {
         return this.mPlatformSettingsDef == null ? true : this.mPlatformSettingsDef.isPaymentsEnabled();
      }
      
      public function getName() : String
      {
         return this.mPlatformSettingsDef == null ? "" : this.mPlatformSettingsDef.getName();
      }
   }
}
