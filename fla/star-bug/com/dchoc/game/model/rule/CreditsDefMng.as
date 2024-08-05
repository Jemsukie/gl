package com.dchoc.game.model.rule
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.rule.RuleMng;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.utils.DCUtils;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   import esparragon.utils.EUtils;
   
   public class CreditsDefMng extends DCDefMng
   {
      
      public static const MAX_CREDITS_DEF:int = 6;
       
      
      private var mMobilePaymentsItems:String;
      
      private var mMobilePaymentsOriginal:Array;
      
      private var mMobilePayments:Array;
      
      private var mMobilePaymentsNeedsToBeUpdated:Boolean = false;
      
      public function CreditsDefMng(resourceDefs:Vector.<String>, typeSkus:Vector.<String> = null, directoryPath:String = null)
      {
         super(resourceDefs,typeSkus,directoryPath);
      }
      
      override protected function unloadDo() : void
      {
         this.mobilePaymentsUnload();
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new CreditsDef();
      }
      
      override protected function sortCompareFunction(a:DCDef, b:DCDef) : Number
      {
         var aint:String = a.mSku;
         var bint:String = b.mSku;
         if(!DCUtils.isStringANumber(aint) && !DCUtils.isStringANumber(bint) || DCUtils.isStringANumber(aint) && DCUtils.isStringANumber(bint))
         {
            if(aint < bint)
            {
               return 1;
            }
            if(aint > bint)
            {
               return -1;
            }
         }
         else
         {
            if(!DCUtils.isStringANumber(aint) && DCUtils.isStringANumber(bint))
            {
               return 1;
            }
            if(DCUtils.isStringANumber(aint) && !DCUtils.isStringANumber(bint))
            {
               return -1;
            }
         }
         return 0;
      }
      
      private function itemsStrToItemsArray(itemsStr:String) : Array
      {
         var item:String = null;
         var items:Array = itemsStr.split(",");
         var returnValue:Array = [];
         for each(item in items)
         {
            returnValue.push(item.split(":"));
         }
         return returnValue;
      }
      
      private function sortByBestValue(a:DCDef, b:DCDef) : Number
      {
         var aint:int = int(CreditsDef(a).getPremiumCurrency());
         var bint:int = int(CreditsDef(b).getPremiumCurrency());
         if(aint > bint)
         {
            return -1;
         }
         if(aint < bint)
         {
            return 1;
         }
         return 0;
      }
      
      override protected function buildDefs() : void
      {
         super.buildDefs();
         var credits:Vector.<DCDef> = getDefs();
         credits = credits.sort(this.sortByBestValue);
         if(credits.length > 0)
         {
            CreditsDef(credits[0]).setIsBestValue(true);
         }
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var ruleMng:RuleMng = null;
         if(this.mMobilePaymentsNeedsToBeUpdated)
         {
            ruleMng = InstanceMng.getRuleMng();
            if(this.mMobilePaymentsOriginal != null && ruleMng.hasUserCurrency())
            {
               InstanceMng.getUserDataMng().updateMisc_applyPurchasesFromMobileAdjust(ruleMng.getCurrencyExchangeValue(),ruleMng.getUserCurrency(),this.mMobilePaymentsOriginal);
               this.mMobilePaymentsNeedsToBeUpdated = false;
            }
         }
      }
      
      private function mobilePaymentsUnload() : void
      {
         this.mMobilePaymentsOriginal = null;
         this.mMobilePayments = null;
         this.mMobilePaymentsItems = null;
         this.mMobilePaymentsNeedsToBeUpdated = false;
      }
      
      public function mobilePaymentsSetDataFromJavascript(obj:Array) : void
      {
         this.mMobilePaymentsOriginal = obj;
         if(Config.useMobilePaymentsWithServer())
         {
            this.mMobilePaymentsNeedsToBeUpdated = true;
         }
         else
         {
            this.mobilePaymentsSetup();
         }
      }
      
      public function mobilePaymentsSetDataFromServer(obj:Array) : void
      {
         this.mMobilePaymentsOriginal = obj;
         this.mobilePaymentsSetup();
      }
      
      private function mobilePaymentsSetup() : void
      {
         var obj:Object = null;
         var length:int = 0;
         var i:int = 0;
         var mobile:Object = null;
         var m:Object = null;
         var itemsStr:String = null;
         if(this.mMobilePaymentsOriginal == null)
         {
            this.mMobilePayments = null;
         }
         else
         {
            if(this.mMobilePaymentsItems == null)
            {
               this.mMobilePayments = this.mMobilePaymentsOriginal;
            }
            else
            {
               this.mMobilePayments = [];
               length = int(this.mMobilePaymentsOriginal.length);
               for(i = 0; i < length; )
               {
                  obj = this.mMobilePaymentsOriginal[i];
                  this.mMobilePayments.push(EUtils.cloneObject(obj));
                  i++;
               }
            }
            if(this.mMobilePayments != null)
            {
               mobile = this.mMobilePayments[0];
               length = int(this.mMobilePayments.length);
               if(length > 6)
               {
                  length = 6;
               }
               i = 1;
               while(i < length)
               {
                  DCDebug.traceChObject("popupCredits",mobile);
                  if(mobile.credits < this.mMobilePayments[i].credits)
                  {
                     mobile = this.mMobilePayments[i];
                  }
                  i++;
               }
               mobile.isBestValue = true;
               for(i = 0; i < length; )
               {
                  m = this.mMobilePayments[i];
                  if((itemsStr = String(this.mMobilePaymentsItems == null ? m["items"] : this.mMobilePaymentsItems)) != null && itemsStr != "")
                  {
                     m["itemsArray"] = this.itemsStrToItemsArray(itemsStr);
                  }
                  i++;
               }
            }
         }
      }
      
      public function mobilePaymentsGetGUIData() : Array
      {
         return this.mMobilePayments;
      }
      
      public function mobilePaymentsSetItems(items:String) : void
      {
         this.mMobilePaymentsItems = items;
         this.mobilePaymentsSetup();
      }
      
      public function mobilePaymentsGetItems() : String
      {
         return this.mMobilePaymentsItems;
      }
   }
}
