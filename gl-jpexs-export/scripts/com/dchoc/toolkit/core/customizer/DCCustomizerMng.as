package com.dchoc.toolkit.core.customizer
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.utils.DCUtils;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   import esparragon.utils.EUtils;
   import flash.utils.Dictionary;
   
   public class DCCustomizerMng extends DCComponent
   {
      
      protected static const TYPE_POPUP:String = "1";
      
      protected static const TYPE_CUSTOM_CONTENT:String = "4";
      
      protected static const TYPE_DISPLAY_ON_INIT:String = "init";
      
      protected static const TYPE_DISPLAY_ON_IDLE:String = "idle";
      
      protected static const ELEMENT_POPUPS:int = 1;
      
      protected static const ELEMENT_CROSS_PROMOTION:int = 2;
      
      protected static const ELEMENT_COUNT:int = 3;
      
      protected static const ELEMENT_POPUPS_WELCOME:int = 0;
      
      protected static const ELEMENT_POPUPS_IDLE:int = 1;
       
      
      protected var mElements:Array;
      
      private var mNextWelcomePopup:int;
      
      private var mAmountPopups:Array;
      
      protected var mNeedsToRevertChanges:Boolean = false;
      
      private var mSkusXml:Dictionary;
      
      public function DCCustomizerMng()
      {
         super();
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildSyncTotalSteps = 2;
         mBuildAsyncTotalSteps = 0;
      }
      
      override protected function loadDoStep(step:int) : void
      {
         var i:int = 0;
         if(step == 0)
         {
            this.mElements = new Array(3);
            for(i = 0; i < 3; )
            {
               this.mElements[i] = [];
               i++;
            }
            this.mElements[1][1] = [];
            this.mElements[1][0] = [];
            this.mNextWelcomePopup = 0;
            this.mAmountPopups = [];
            this.mAmountPopups[1] = 0;
            this.mAmountPopups[0] = 0;
         }
      }
      
      override protected function unloadDo() : void
      {
         var i:int = 0;
         var j:int = 0;
         var k:int = 0;
         for(i = 0; i < 3; )
         {
            for(j = 0; j < this.mElements[i].length; )
            {
               if(i == 1)
               {
                  for(k = 0; k < this.mElements[i][j].length; )
                  {
                     this.mElements[i][j][k].destroy();
                     this.mElements[i][j][k] = null;
                     k++;
                  }
               }
               this.mElements[i][j] = null;
               j++;
            }
            this.mElements[i] = null;
            i++;
         }
         this.mElements = null;
         this.mNextWelcomePopup = 0;
         this.mAmountPopups = null;
         this.mNeedsToRevertChanges = false;
      }
      
      public function amountWelcomePopups() : int
      {
         return this.mAmountPopups[0] - this.mNextWelcomePopup;
      }
      
      public function amountIdlePopups() : int
      {
         return this.mAmountPopups[1];
      }
      
      public function getNextWelcomePopup() : DCCustomizerPopupDef
      {
         var popup:DCCustomizerPopupDef = null;
         if(this.mNextWelcomePopup < this.mAmountPopups[0])
         {
            popup = this.mElements[1][0][this.mNextWelcomePopup];
            this.mNextWelcomePopup++;
         }
         return popup;
      }
      
      public function skipWelcomePopups() : void
      {
         this.mNextWelcomePopup = this.mAmountPopups[0];
      }
      
      public function getIdlePopup(index:int) : DCCustomizerPopupDef
      {
         if(index >= 0 && index < this.amountIdlePopups())
         {
            return this.mElements[1][1][index];
         }
         return null;
      }
      
      public function hasPlayedGame(pid:int) : Boolean
      {
         return this.mElements[2].indexOf(pid) > -1;
      }
      
      public function parseData(data:XML, needsToRevert:Boolean) : void
      {
         var element:XML = null;
         var experiment:String = null;
         var customRules:XML = null;
         var displayOn:int = 0;
         var popupDef:DCCustomizerPopupDef = null;
         var subContent:XML = null;
         this.mNeedsToRevertChanges = needsToRevert;
         for each(element in EUtils.xmlGetChildrenList(data,"content"))
         {
            switch(EUtils.xmlReadString(element,"type"))
            {
               case "1":
                  displayOn = this.getDisplayOn(EUtils.xmlReadString(element,"display_on"));
                  popupDef = new DCCustomizerPopupDef(element);
                  this.mElements[1][displayOn].push(popupDef);
                  this.mAmountPopups[displayOn]++;
                  break;
               case "4":
                  if((subContent = EUtils.xmlGetChildrenList(element,"content")[0] as XML) != null)
                  {
                     this.getOffers(subContent);
                  }
                  if(EUtils.xmlIsAttribute(element,"crossPromotion"))
                  {
                     this.mElements[2].push(EUtils.xmlReadInt(element,"pid"));
                  }
            }
            for each(customRules in EUtils.xmlGetChildrenList(element,"rules"))
            {
               this.changeRules(customRules);
            }
         }
      }
      
      protected function getOffers(data:XML) : void
      {
      }
      
      private function getDisplayOn(displayOn:String) : int
      {
         switch(displayOn)
         {
            case "init":
               return 0;
            case "idle":
               return 1;
            default:
               return 1;
         }
      }
      
      protected function changeRules(data:XML) : void
      {
         var def:DCDef = null;
         var customDef:XML = null;
         var listSkus:Vector.<String> = null;
         var className:Class = null;
         var sku:String = null;
         var platforms:String = null;
         var keepDef:Boolean = false;
         var k:* = null;
         this.mSkusXml = new Dictionary(true);
         var defMng:DCDefMng = InstanceMng.getRuleMng().getDefManger(EUtils.xmlReadString(data,"file"));
         var overWrite:int = 0;
         var defs:Vector.<DCDef> = defMng.getDefs();
         if(EUtils.xmlIsAttribute(data,"overwrite"))
         {
            overWrite = EUtils.xmlReadInt(data,"overwrite");
         }
         if(defs != null && defs.length > 0 && defs[0] != null)
         {
            className = DCUtils.getClass(defs[0]);
         }
         if(overWrite > 0)
         {
            listSkus = new Vector.<String>(0);
         }
         var currentPlatform:String = InstanceMng.getPlatformSettingsDefMng().getCurrentPlatformSku();
         var platformsName:String = "platforms";
         for each(customDef in EUtils.xmlGetChildrenList(data,"Definition"))
         {
            sku = EUtils.xmlReadString(customDef,"sku");
            keepDef = true;
            if(EUtils.xmlIsAttribute(customDef,platformsName))
            {
               keepDef = (platforms = EUtils.xmlReadString(customDef,platformsName)) == "" || platforms.indexOf(currentPlatform) > -1;
            }
            if(keepDef)
            {
               this.mSkusXml[sku] = customDef;
            }
         }
         for(k in this.mSkusXml)
         {
            customDef = this.mSkusXml[k] as XML;
            if((def = defMng.getDefBySku(this.buildSku(customDef))) != null)
            {
               def.fromXml(customDef);
               if(overWrite > 0)
               {
                  listSkus.push(def.mSku);
               }
            }
            else if(overWrite > 0 && className != null)
            {
               (def = new className()).fromXml(customDef);
               defMng.addDef(def);
               listSkus.push(def.mSku);
            }
         }
         if(overWrite == 1)
         {
            for each(def in defs)
            {
               if(listSkus.indexOf(def.mSku) == -1)
               {
                  defMng.removeDef(def);
               }
            }
         }
         this.doChangeRules(defMng);
         if(defMng != null)
         {
            defMng.sort();
         }
      }
      
      protected function buildSku(def:XML) : String
      {
         return EUtils.xmlReadString(def,"sku");
      }
      
      protected function doChangeRules(defMng:DCDefMng) : void
      {
      }
      
      protected function startABTest(id:String) : void
      {
      }
   }
}
