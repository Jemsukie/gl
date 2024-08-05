package com.dchoc.game.model.userdata
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.rule.CreditsDefMng;
   import com.dchoc.toolkit.core.customizer.DCCustomizerMng;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.DCUtils;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   import esparragon.utils.EUtils;
   
   public class CustomizerMng extends DCCustomizerMng
   {
      
      private static const TYPE_OFFER:String = "offer";
       
      
      private var mExpireOfferDate:Date;
      
      public function CustomizerMng()
      {
         super();
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         if(step == 0)
         {
            if(InstanceMng.getRuleMng().isBuilt() && InstanceMng.getUserDataMng().isFileLoaded(UserDataMng.KEY_CUSTOMIZER))
            {
               buildAdvanceSyncStep();
            }
         }
         else if(step == 1)
         {
            parseData(InstanceMng.getUserDataMng().getFileXML(UserDataMng.KEY_CUSTOMIZER),false);
            buildAdvanceSyncStep();
         }
      }
      
      override protected function unbuildDo() : void
      {
         super.unbuildDo();
         this.mExpireOfferDate = null;
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         if(this.mExpireOfferDate != null && this.isOfferExpired())
         {
            this.expireOffer();
         }
      }
      
      override protected function buildSku(def:XML) : String
      {
         var levelId:int = 0;
         var sku:String = EUtils.xmlReadString(def,"sku");
         var attribute:String = "levelId";
         if(EUtils.xmlIsAttribute(def,attribute))
         {
            levelId = EUtils.xmlReadInt(def,attribute) - 1;
            if(levelId > 0)
            {
               sku += "_" + levelId;
            }
         }
         return sku;
      }
      
      override protected function doChangeRules(defMng:DCDefMng) : void
      {
         defMng.notifyChangeOnRules();
      }
      
      override protected function getOffers(data:XML) : void
      {
         var expireDate:String = null;
         var offerDurationMS:Number = NaN;
         var epochDate:Number = NaN;
         if(EUtils.xmlReadString(data,"type") == "offer" && EUtils.xmlIsAttribute(data,"expire_on"))
         {
            expireDate = EUtils.xmlReadString(data,"expire_on");
            if(expireDate != "")
            {
               if(DCUtils.isStringANumber(expireDate))
               {
                  offerDurationMS = Number(expireDate);
                  this.mExpireOfferDate = new Date();
                  this.mExpireOfferDate.setTime(InstanceMng.getUserDataMng().getServerCurrentTimemillis() + offerDurationMS);
               }
               else
               {
                  this.mExpireOfferDate = new Date(Date.parse(expireDate));
                  this.mExpireOfferDate = new Date(this.mExpireOfferDate.valueOf());
               }
            }
         }
      }
      
      public function needsOfferToShowTimer() : Boolean
      {
         return this.mExpireOfferDate != null && !this.isOfferExpired() && InstanceMng.getApplication().isTutorialCompleted() && InstanceMng.getUnitScene().battleIsRunning() == false && InstanceMng.getUIFacade().blackStripsAreActive() == false;
      }
      
      public function isOfferExpired() : Boolean
      {
         var returnValue:* = false;
         if(this.mExpireOfferDate != null)
         {
            returnValue = this.mExpireOfferDate.getTime() <= InstanceMng.getUserDataMng().getServerCurrentTimemillis();
         }
         return returnValue;
      }
      
      public function getOfferTimeLeft() : String
      {
         var returnValue:String = null;
         var daysLeft:Number = NaN;
         if(this.mExpireOfferDate == null || this.mExpireOfferDate.getTime() <= InstanceMng.getUserDataMng().getServerCurrentTimemillis())
         {
            returnValue = "00:00:00";
         }
         else
         {
            daysLeft = this.mExpireOfferDate.getTime() - InstanceMng.getUserDataMng().getServerCurrentTimemillis();
            if(daysLeft < 172800000)
            {
               returnValue = DCTextMng.convertTimeToStringColon(daysLeft);
            }
            else
            {
               returnValue = DCTextMng.getCountdownTime(daysLeft);
            }
         }
         return returnValue;
      }
      
      public function expireOffer() : void
      {
         var creditsDefMng:CreditsDefMng = null;
         var defs:Vector.<DCDef> = null;
         var def:DCDef = null;
         var xml:XML = null;
         var origFile:XML = null;
         var defXml:XML = null;
         if(this.mExpireOfferDate != null)
         {
            if(mNeedsToRevertChanges)
            {
               defs = (creditsDefMng = InstanceMng.getCreditsMng()).getDefs();
               for each(def in defs)
               {
                  def.reset();
               }
               xml = EUtils.stringToXML("<rules file=\"creditsDefinitions\"/>");
               origFile = InstanceMng.getRuleMng().filesGetFileAsXML("creditsDefinitions.xml");
               for each(defXml in origFile.Definition)
               {
                  EUtils.xmlSetAttribute(defXml,"overwrite","1");
                  xml.appendChild(defXml);
               }
               changeRules(xml);
            }
            this.mExpireOfferDate = null;
         }
      }
   }
}
