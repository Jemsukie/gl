package com.dchoc.game.model.rule
{
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class PlatformSettingsDef extends DCDef
   {
      
      public static const FREEOFFERS_OFF:int = 0;
      
      public static const FREEOFFERS_ON:int = 1;
      
      public static const FREEOFFERS_CUSTOM:int = 2;
       
      
      private var mUseNewsFeeds:Boolean = false;
      
      private var mNewsFeedsResolution:String = "";
      
      private var mClosePopupAfterPublish:Boolean = false;
      
      private var mUsePlatformCreditsPopup:Boolean = false;
      
      private var mUseInvestments:Boolean = false;
      
      private var mUseFreeOffers:int = 0;
      
      private var mCurrencyIcon:String = null;
      
      private var mCurrencyConversion:Number = 0.1;
      
      private var mInviteIndividualFriendIsEnabled:Boolean = false;
      
      private var mUsePopupInviteAfterTutorial:Boolean = false;
      
      private var mMobilePayments:Boolean = false;
      
      private var mUseInvite:Boolean = false;
      
      private var mShowRealMoney:Boolean = false;
      
      private var mUseStarTrekShop:Boolean = false;
      
      private var mLoadingScreenSku:String = "loading_trike";
      
      private var mCanRefreshPage:Boolean = true;
      
      private var mUseNaranjito:Boolean = true;
      
      private var mPaymentsEnabled:Boolean = false;
      
      private var mTidName:String;
      
      public function PlatformSettingsDef()
      {
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         var attribute:String = "useNewsFeeds";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setUseNewsFeeds(EUtils.xmlReadBoolean(info,attribute));
         }
         attribute = "newsFeedsResolution";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setNewsFeedsResolution(EUtils.xmlReadString(info,attribute));
         }
         attribute = "closePopupAfterPublish";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setClosePopupAftePublish(EUtils.xmlReadBoolean(info,attribute));
         }
         attribute = "usePlatformCreditsPopup";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setUsePlatformCreditsPopup(EUtils.xmlReadBoolean(info,attribute));
         }
         attribute = "useInvestments";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setUseInvestments(EUtils.xmlReadBoolean(info,attribute));
         }
         attribute = "useFreeOffers";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setUseFreeOffers(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "currencyIcon";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setCurrencyIcon(EUtils.xmlReadString(info,attribute));
         }
         attribute = "currencyConversion";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setCurrencyConversion(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "currencyTid";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setCurrencyName(EUtils.xmlReadString(info,attribute));
         }
         attribute = "inviteIndividualFriendIsEnabled";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setInviteIndividualFriendIsEnabled(EUtils.xmlReadBoolean(info,attribute));
         }
         attribute = "usePopupInviteAfterTutorial";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setUsePopupInviteAfterTutorial(EUtils.xmlReadBoolean(info,attribute));
         }
         attribute = "mobilePayments";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMobileOptions(EUtils.xmlReadBoolean(info,attribute));
         }
         attribute = "useInvite";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setUseInvite(EUtils.xmlReadBoolean(info,attribute));
         }
         attribute = "showRealMoney";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setShowRealMoney(EUtils.xmlReadBoolean(info,attribute));
         }
         attribute = "useStarTrekShop";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setUseStarTrekShop(EUtils.xmlReadBoolean(info,attribute));
         }
         attribute = "loadingScreenSku";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setLoadingScreenSku(EUtils.xmlReadString(info,attribute));
         }
         attribute = "canRefreshPage";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setCanRefreshPage(EUtils.xmlReadBoolean(info,attribute));
         }
         attribute = "useNaranjito";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setUseNaranjito(EUtils.xmlReadBoolean(info,attribute));
         }
         attribute = "paymentsEnabled";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setPaymentsEnabled(EUtils.xmlReadBoolean(info,attribute));
         }
         attribute = "tidName";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTidName(EUtils.xmlReadString(info,attribute));
         }
      }
      
      private function setUseNewsFeeds(value:Boolean) : void
      {
         this.mUseNewsFeeds = value;
      }
      
      private function setNewsFeedsResolution(value:String) : void
      {
         this.mNewsFeedsResolution = value;
      }
      
      private function setClosePopupAftePublish(value:Boolean) : void
      {
         this.mClosePopupAfterPublish = value;
      }
      
      private function setUsePlatformCreditsPopup(value:Boolean) : void
      {
         this.mUsePlatformCreditsPopup = value;
      }
      
      private function setUseInvestments(value:Boolean) : void
      {
         this.mUseInvestments = value;
      }
      
      private function setUseFreeOffers(value:int) : void
      {
         this.mUseFreeOffers = value;
      }
      
      private function setCurrencyIcon(value:String) : void
      {
         this.mCurrencyIcon = value;
      }
      
      private function setCurrencyConversion(value:Number) : void
      {
         this.mCurrencyConversion = value;
      }
      
      private function setCurrencyName(value:String) : void
      {
         addToDictionary("currencyName",value);
      }
      
      public function setInviteIndividualFriendIsEnabled(value:Boolean) : void
      {
         this.mInviteIndividualFriendIsEnabled = value;
      }
      
      public function setUsePopupInviteAfterTutorial(value:Boolean) : void
      {
         this.mUsePopupInviteAfterTutorial = value;
      }
      
      private function setMobileOptions(value:Boolean) : void
      {
         this.mMobilePayments = value;
      }
      
      private function setUseInvite(value:Boolean) : void
      {
         this.mUseInvite = value;
      }
      
      private function setShowRealMoney(value:Boolean) : void
      {
         this.mShowRealMoney = value;
      }
      
      private function setUseStarTrekShop(value:Boolean) : void
      {
         this.mUseStarTrekShop = value;
      }
      
      private function setLoadingScreenSku(value:String) : void
      {
         this.mLoadingScreenSku = value;
      }
      
      private function setCanRefreshPage(value:Boolean) : void
      {
         this.mCanRefreshPage = value;
      }
      
      private function setUseNaranjito(value:Boolean) : void
      {
         this.mUseNaranjito = value;
      }
      
      public function getInviteIndividualFriendIsEnabled() : Boolean
      {
         return this.mInviteIndividualFriendIsEnabled;
      }
      
      public function getUsePopupInviteAfterTutorial() : Boolean
      {
         return this.mUsePopupInviteAfterTutorial;
      }
      
      public function getUseNewsFeeds() : Boolean
      {
         return this.mUseNewsFeeds;
      }
      
      public function getNewsFeedsResolution() : String
      {
         return this.mNewsFeedsResolution;
      }
      
      public function getClosePopupAfterPublish() : Boolean
      {
         return this.mClosePopupAfterPublish;
      }
      
      public function getUsePlatformCreditsPopup() : Boolean
      {
         return this.mUsePlatformCreditsPopup;
      }
      
      public function getUseInvestments() : Boolean
      {
         return this.mUseInvestments;
      }
      
      public function getUseFreeOffers() : int
      {
         return this.mUseFreeOffers;
      }
      
      public function getCurrencyIcon() : String
      {
         return this.mCurrencyIcon;
      }
      
      public function getCurrencyConversion() : Number
      {
         return this.mCurrencyConversion;
      }
      
      public function getCurrencyName() : String
      {
         return getTranslationFromDictionary("currencyName");
      }
      
      public function getShowMobilePayments() : Boolean
      {
         return this.mMobilePayments;
      }
      
      public function getUseInvite() : Boolean
      {
         return this.mUseInvite;
      }
      
      public function getShowRealMoney() : Boolean
      {
         return this.mShowRealMoney;
      }
      
      public function getUseStarTrekShop() : Boolean
      {
         return this.mUseStarTrekShop;
      }
      
      public function getLoadingScreenSku() : String
      {
         return this.mLoadingScreenSku;
      }
      
      public function canRefreshPage() : Boolean
      {
         return this.mCanRefreshPage;
      }
      
      public function getUseNaranjito() : Boolean
      {
         return this.mUseNaranjito;
      }
      
      private function setPaymentsEnabled(value:Boolean) : void
      {
         this.mPaymentsEnabled = value;
      }
      
      public function isPaymentsEnabled() : Boolean
      {
         return this.mPaymentsEnabled;
      }
      
      private function setTidName(value:String) : void
      {
         this.mTidName = value;
      }
      
      public function getName() : String
      {
         return DCTextMng.getText(TextIDs[this.mTidName]);
      }
   }
}
