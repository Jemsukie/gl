package com.dchoc.game.model.upselling
{
   import com.dchoc.game.controller.entry.Entry;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.popups.offers.EPopupOneTimeOffer;
   import com.dchoc.game.model.items.ItemsDef;
   import com.dchoc.game.model.rule.CreditsDefMng;
   import com.dchoc.game.model.userdata.UserDataMng;
   import com.dchoc.game.model.world.ship.ShipDef;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   import flash.utils.Dictionary;
   
   public class UpSellingMng extends DCComponent
   {
      
      public static const OFFER_UPGRADE_HQ_SKU:String = "HQLevelUp";
      
      public static const OFFER_UNITS_SKU:String = "units";
       
      
      private var mIsOfferEnabled:Boolean = false;
      
      private var mOffers:Dictionary;
      
      private var mOffersPremium:Dictionary;
      
      private var mOfferRunning:UpSellingOffer;
      
      private var mPreviousMobilePaymentsItems:String;
      
      public function UpSellingMng()
      {
         super();
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildAsyncTotalSteps = 0;
         mBuildSyncTotalSteps = 2;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         var userDataMng:UserDataMng = null;
         var info:XML = null;
         var attribute:String = null;
         var offerXml:XML = null;
         var offer:UpSellingOffer = null;
         var premiumOffer:UpSellingPremiumOffer = null;
         if(step == 0)
         {
            if(InstanceMng.getPlatformSettingsDefMng().isBuilt())
            {
               buildAdvanceSyncStep();
            }
         }
         else if(step == 1)
         {
            if(Config.useUpSelling() && InstanceMng.getPlatformSettingsDefMng().isPaymentsEnabled())
            {
               userDataMng = InstanceMng.getUserDataMng();
               if(userDataMng.isFileLoaded(UserDataMng.KEY_UPSELLING) && InstanceMng.getCreditsMng().isBuilt() && InstanceMng.getCustomizerMng().isBuilt())
               {
                  info = userDataMng.getFileXML(UserDataMng.KEY_UPSELLING);
                  attribute = "enabled";
                  if(EUtils.xmlIsAttribute(info,attribute))
                  {
                     this.setIsOfferEnabled(EUtils.xmlReadBoolean(info,attribute));
                  }
                  if(this.mIsOfferEnabled)
                  {
                     this.mOfferRunning = null;
                     for each(offerXml in EUtils.xmlGetChildrenList(info,"offer"))
                     {
                        offer = new UpSellingOffer();
                        offer.fromXml(offerXml);
                        if(this.mOffers == null)
                        {
                           this.mOffers = new Dictionary(true);
                        }
                        this.mOffers[offer.getSku()] = offer;
                        if(offer.isRunning())
                        {
                           if(this.mOfferRunning == null)
                           {
                              this.mOfferRunning = offer;
                           }
                           else if(this.mOfferRunning.getStartedAt() < offer.getStartedAt())
                           {
                              this.mOfferRunning = offer;
                           }
                        }
                     }
                     if(this.mOfferRunning)
                     {
                        this.applyOffer(this.mOfferRunning.getSku());
                     }
                     for each(offerXml in EUtils.xmlGetChildrenList(info,"premium"))
                     {
                        (premiumOffer = new UpSellingPremiumOffer()).fromXml(offerXml);
                        if(this.mOffersPremium == null)
                        {
                           this.mOffersPremium = new Dictionary(true);
                        }
                        this.mOffersPremium[premiumOffer.getSku()] = premiumOffer;
                     }
                  }
                  buildAdvanceSyncStep();
               }
            }
            else
            {
               this.setIsOfferEnabled(false);
               buildAdvanceSyncStep();
            }
         }
      }
      
      public function updatePremiumOffers(xml:XML) : void
      {
         var premiumOffer:UpSellingPremiumOffer = null;
         for each(var offerXml in EUtils.xmlGetChildrenList(xml,"premium"))
         {
            premiumOffer = new UpSellingPremiumOffer();
            premiumOffer.fromXml(offerXml);
            if(this.mOffersPremium == null)
            {
               this.mOffersPremium = new Dictionary(true);
            }
            this.mOffersPremium[premiumOffer.getSku()] = premiumOffer;
         }
      }
      
      override protected function unbuildDo() : void
      {
         var k:* = null;
         var offer:UpSellingOffer = null;
         var offerPremium:UpSellingPremiumOffer = null;
         this.setIsOfferEnabled(false);
         if(this.mOffers != null)
         {
            for(k in this.mOffers)
            {
               offer = this.mOffers[k];
               offer.destroy();
               delete this.mOffers[k];
            }
            this.mOffers = null;
         }
         if(this.mOffersPremium != null)
         {
            for(k in this.mOffersPremium)
            {
               offerPremium = this.mOffersPremium[k];
               offerPremium.destroy();
               delete this.mOffersPremium[k];
            }
            this.mOffersPremium = null;
         }
         this.mOfferRunning = null;
         this.mPreviousMobilePaymentsItems = null;
      }
      
      private function setIsOfferEnabled(value:Boolean) : void
      {
         this.mIsOfferEnabled = value;
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         if(this.mOfferRunning != null)
         {
            this.mOfferRunning.logicUpdate(dt);
            if(!this.mOfferRunning.isRunning())
            {
               this.finishRunningOffer();
            }
         }
      }
      
      private function getOfferBySku(offerSku:String) : UpSellingOffer
      {
         var returnValue:UpSellingOffer = null;
         if(this.mOffers != null)
         {
            returnValue = this.mOffers[offerSku];
         }
         return returnValue;
      }
      
      public function canOfferBeStarted(offerSku:String) : Boolean
      {
         var offer:UpSellingOffer = null;
         var returnValue:Boolean = false;
         if(this.mIsOfferEnabled && this.mOfferRunning == null)
         {
            offer = this.getOfferBySku(offerSku);
            if(offer != null)
            {
               returnValue = offer.canBeStarted();
            }
         }
         return returnValue;
      }
      
      public function startOffer(offerSku:String) : void
      {
         var offer:UpSellingOffer = null;
         if(this.canOfferBeStarted(offerSku))
         {
            offer = this.getOfferBySku(offerSku);
            if(offer != null)
            {
               offer.start();
               InstanceMng.getUserDataMng().updateMisc_upSellingStarted(offerSku);
               this.mOfferRunning = offer;
               this.applyOffer(offerSku);
               this.guiOpenOfferPopup(offerSku);
            }
         }
      }
      
      public function notifyOfferAccepted(offerSku:String) : void
      {
         if(this.mIsOfferEnabled && this.mOfferRunning != null && this.mOfferRunning.getSku() == offerSku)
         {
            this.finishRunningOffer();
         }
      }
      
      private function applyOffer(offerSku:String) : void
      {
         var rewardStr:String = null;
         var xml:XML = null;
         var contentXml:XML = null;
         var contentOfferXml:XML = null;
         var rulesXml:XML = null;
         var creditsDefMng:CreditsDefMng = null;
         var defs:Vector.<DCDef> = null;
         var def:DCDef = null;
         var origFile:XML = null;
         var defXml:XML = null;
         var offer:UpSellingOffer = this.getOfferBySku(offerSku);
         if(offer != null)
         {
            rewardStr = offer.getReward();
            xml = EUtils.stringToXML("<customizer/>");
            contentXml = EUtils.stringToXML("<content type=\"4\"/>");
            contentOfferXml = EUtils.stringToXML("<content type=\"offer\" expire_on=\"" + offer.getTimeLeft() + "\"/>");
            contentXml.appendChild(contentOfferXml);
            rulesXml = EUtils.stringToXML("<rules file=\"creditsDefinitions\"/>");
            defs = (creditsDefMng = InstanceMng.getCreditsMng()).getDefs();
            for each(def in defs)
            {
               def.reset();
            }
            origFile = InstanceMng.getRuleMng().filesGetFileAsXML("creditsDefinitions.xml");
            for each(defXml in EUtils.xmlGetChildrenList(origFile,"Definition"))
            {
               EUtils.xmlSetAttribute(defXml,"overwrite","1");
               EUtils.xmlSetAttribute(defXml,"items",rewardStr);
               rulesXml.appendChild(defXml);
            }
            contentXml.appendChild(rulesXml);
            xml.appendChild(contentXml);
            InstanceMng.getCustomizerMng().parseData(xml,true);
            this.mPreviousMobilePaymentsItems = creditsDefMng.mobilePaymentsGetItems();
            creditsDefMng.mobilePaymentsSetItems(rewardStr);
         }
      }
      
      private function finishRunningOffer() : void
      {
         this.mOfferRunning = null;
         InstanceMng.getCustomizerMng().expireOffer();
         InstanceMng.getCreditsMng().mobilePaymentsSetItems(this.mPreviousMobilePaymentsItems);
         this.setIsOfferEnabled(false);
      }
      
      public function getOfferRunning() : UpSellingOffer
      {
         return this.mOfferRunning;
      }
      
      public function isItemSkuOfferedByCurrentOffer(itemSku:String) : Boolean
      {
         var rewardEntry:Entry = null;
         var returnValue:Boolean = false;
         if(this.mOfferRunning != null)
         {
            rewardEntry = this.mOfferRunning.getRewardEntry();
            returnValue = rewardEntry != null && rewardEntry.getItemSku() == itemSku;
         }
         return returnValue;
      }
      
      public function getPremiumShopOffer(sku:String) : UpSellingPremiumOffer
      {
         var returnValue:UpSellingPremiumOffer = null;
         if(this.mOffersPremium != null)
         {
            returnValue = this.mOffersPremium[sku];
         }
         return returnValue;
      }
      
      private function guiOpenOfferPopup(offerSku:String) : void
      {
         var itemSku:String = null;
         var itemDef:ItemsDef = null;
         var groundUnitDef:ItemsDef = null;
         var unitSku:String = null;
         var shipDef:ShipDef = null;
         var path:String = null;
         var offer:UpSellingOffer = this.getOfferBySku(offerSku);
         if(!offer)
         {
            DCDebug.traceCh("ERROR","Offer not found: " + offerSku);
            return;
         }
         var popupOneTimeOffer:EPopupOneTimeOffer = this.guiCreateOneTimeOfferPopup();
         itemSku = String(offer.getReward().split(":")[0]);
         var itemAmount:String = String(offer.getReward().split(":")[1]);
         if(popupOneTimeOffer)
         {
            popupOneTimeOffer.setRemainingTime(offer.getTimeLeft());
            switch(offerSku)
            {
               case "HQLevelUp":
                  itemDef = InstanceMng.getItemsDefMng().getDefBySku(itemSku) as ItemsDef;
                  popupOneTimeOffer.setUpgradeInfoText(DCTextMng.replaceParameters(485,[DCTextMng.getText(772)]));
                  popupOneTimeOffer.setUpgradeText(DCTextMng.replaceParameters(487,[itemDef.getNameToDisplay()]));
                  popupOneTimeOffer.setAsset("hq_upgrade");
                  popupOneTimeOffer.setForegroundAsset(null);
                  popupOneTimeOffer.setIsStackable(true);
                  InstanceMng.getUIFacade().enqueuePopup(popupOneTimeOffer);
                  break;
               case "units":
                  groundUnitDef = InstanceMng.getItemsDefMng().getDefBySku(itemSku) as ItemsDef;
                  popupOneTimeOffer.setUpgradeInfoText(DCTextMng.replaceParameters(486,[itemAmount,DCTextMng.getText(groundUnitDef.getNameToDisplay())]));
                  popupOneTimeOffer.setUpgradeText(DCTextMng.replaceParameters(488,[itemAmount]));
                  popupOneTimeOffer.setAsset("units_group");
                  unitSku = String(groundUnitDef.getActionParams()[0]);
                  if(shipDef = InstanceMng.getShipDefMng().getDefBySku(unitSku) as ShipDef)
                  {
                     path = shipDef.getIcon();
                     popupOneTimeOffer.setForegroundAsset(path);
                  }
                  else
                  {
                     popupOneTimeOffer.setForegroundAsset("pngs_shop/pngs_shop_soldiers/shop_bazooka_001");
                  }
                  InstanceMng.getUIFacade().enqueuePopup(popupOneTimeOffer);
            }
         }
      }
      
      private function guiCreateOneTimeOfferPopup() : EPopupOneTimeOffer
      {
         var skinSku:String = null;
         var popupId:String = "PopupUpsellingOfferPresentation";
         var popup:EPopupOneTimeOffer = new EPopupOneTimeOffer();
         popup.setup(popupId,InstanceMng.getViewFactory(),skinSku);
         return popup;
      }
   }
}
