package com.dchoc.toolkit.core.rule
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.resources.ResourcesMng;
   import com.dchoc.game.utils.MultiArchiveUnpacker;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.instance.DCInstanceMng;
   import com.dchoc.toolkit.core.payments.DCPaidCurrency;
   import com.dchoc.toolkit.utils.DCUtils;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   import esparragon.resources.EResourcesMng;
   import flash.utils.Dictionary;
   
   public class DCRuleMng extends DCComponent
   {
       
      
      private var mFilesSkus:Vector.<String>;
      
      private var mFilesIsRequested:Boolean;
      
      private var mFilesRequestCurrentStep:int;
      
      private var mFilesRequestMaxSteps:int;
      
      private var mSigSkusOrder:Vector.<String>;
      
      private var mSigTotal:Number;
      
      private var mManagerDict:Dictionary;
      
      private var mRulesPackageMng:MultiArchiveUnpacker;
      
      public function DCRuleMng(filesSkus:Vector.<String>, sigSkus:Vector.<String>)
      {
         super();
         this.filesLoad(filesSkus);
         this.sigLoad(sigSkus);
      }
      
      override protected function unloadDo() : void
      {
         this.filesUnload();
         this.sigUnload();
         this.rulesPackageUnload();
      }
      
      private function filesLoad(filesSkus:Vector.<String>) : void
      {
         this.mFilesSkus = filesSkus;
         this.mFilesRequestCurrentStep = this.mFilesRequestMaxSteps = 0;
         if(Config.useRulesPackage())
         {
            this.mFilesIsRequested = true;
         }
         else
         {
            this.mFilesIsRequested = false;
            if(this.mFilesSkus != null)
            {
               this.mFilesRequestMaxSteps = this.mFilesSkus.length;
            }
         }
      }
      
      private function filesUnload() : void
      {
         if(this.mFilesSkus != null)
         {
            this.mFilesSkus = null;
            this.mFilesIsRequested = false;
         }
      }
      
      public function filesRequest() : void
      {
         var resourcesMng:EResourcesMng = null;
         var key:String = null;
         if(!this.mFilesIsRequested && this.mFilesSkus != null)
         {
            resourcesMng = InstanceMng.getEResourcesMng();
            for each(key in this.mFilesSkus)
            {
               resourcesMng.loadAsset(key,"rules");
            }
            this.mFilesRequestCurrentStep = this.mFilesRequestMaxSteps;
            this.mFilesIsRequested = true;
         }
      }
      
      public function filesRequestBySteps() : void
      {
         if(Config.DEBUG_MODE)
         {
            DCDebug.traceCh("LOADING","     > DCRuleMng, mFilesRequestCurrentStep=" + this.mFilesRequestCurrentStep + "  of " + this.mFilesRequestMaxSteps);
         }
         if(this.mFilesRequestCurrentStep < this.mFilesRequestMaxSteps)
         {
            if(Config.DEBUG_MODE)
            {
               DCDebug.traceCh("LOADING","     > DCRuleMng, requestResource: " + this.mFilesSkus[this.mFilesRequestCurrentStep]);
            }
            InstanceMng.getEResourcesMng().loadAsset(this.mFilesSkus[this.mFilesRequestCurrentStep],"rules");
            this.mFilesRequestCurrentStep++;
         }
         else
         {
            this.mFilesIsRequested = true;
         }
      }
      
      public function filesGetFile(name:String) : String
      {
         var returnValue:String = null;
         if(Config.useRulesPackage())
         {
            returnValue = this.rulesPackageGetFile(name);
         }
         else
         {
            returnValue = InstanceMng.getEResourcesMng().getAssetString(name,"rules");
         }
         return returnValue;
      }
      
      public function filesGetFileAsXML(name:String) : XML
      {
         if(Config.useRulesPackage())
         {
            return new XML(this.filesGetFile(name));
         }
         return InstanceMng.getEResourcesMng().getAssetXML(name,"rules");
      }
      
      public function filesIsFileLoaded(name:String) : Boolean
      {
         if(Config.useRulesPackage())
         {
            name = "rules_bin";
         }
         return InstanceMng.getEResourcesMng().isAssetLoaded(name,"rules");
      }
      
      private function sigLoad(sigSkus:Vector.<String>) : void
      {
         this.mSigSkusOrder = sigSkus;
      }
      
      public function sigUnload() : void
      {
         this.mSigSkusOrder = null;
      }
      
      public function sigCalculateTotal() : void
      {
         var sku:String = null;
         var token:String = null;
         var sigTotalString:String = "";
         for each(sku in this.mSigSkusOrder)
         {
            token = this.filesGetFile(sku);
            sigTotalString += token;
         }
         this.mSigTotal = DCUtils.getChk(sigTotalString);
         DCDebug.traceCh("Sig","chk input = " + sigTotalString);
         DCDebug.traceCh("Sig","chk output = " + this.mSigTotal);
      }
      
      public function sigGetTotal() : Number
      {
         return this.mSigTotal;
      }
      
      public function getDefManger(fileName:String) : DCDefMng
      {
         if(this.mManagerDict == null)
         {
            this.createManagerDictionary();
         }
         return this.mManagerDict[fileName];
      }
      
      protected function createManagerDictionary() : void
      {
         var manager:DCDefMng = null;
         var resources:Vector.<String> = null;
         var path:String = null;
         this.mManagerDict = new Dictionary();
         for each(manager in mChildren)
         {
            resources = manager.getResourceDefs();
            for each(path in resources)
            {
               path = path.substring(path.lastIndexOf("/") + 1,path.lastIndexOf("."));
               this.mManagerDict[path] = manager;
            }
         }
      }
      
      public function paidCurrencyGetField(def:DCDef, key:String) : DCPaidCurrency
      {
         var platformCurrency:String = DCInstanceMng.getInstance().getApplication().getPlatformPaidCurrency();
         var amount:int = def.paidCurrencyGet(key,platformCurrency);
         if(amount == -1)
         {
            amount = def.paidCurrencyGet(key,"pc");
         }
         return new DCPaidCurrency(amount,platformCurrency);
      }
      
      public function purchaseCurrencyGetFieldVector(defs:Vector.<DCDef>, key:String) : DCPaidCurrency
      {
         var def:DCDef = null;
         var platformCurrency:String = DCInstanceMng.getInstance().getApplication().getPlatformPaidCurrency();
         var amount:int = 0;
         for each(def in defs)
         {
            amount += def.paidCurrencyGet(key,platformCurrency);
         }
         return new DCPaidCurrency(amount,platformCurrency);
      }
      
      private function rulesPackageUnload() : void
      {
         if(this.mRulesPackageMng != null)
         {
            this.mRulesPackageMng = null;
         }
      }
      
      private function rulesPackageGetMng() : MultiArchiveUnpacker
      {
         var resourcesMng:ResourcesMng = null;
         if(this.mRulesPackageMng == null)
         {
            resourcesMng = InstanceMng.getEResourcesMng();
            if(resourcesMng.isAssetLoaded("rules_bin","rules"))
            {
               this.mRulesPackageMng = new MultiArchiveUnpacker(resourcesMng.getAssetByteArray("rules_bin","rules"),true);
            }
         }
         return this.mRulesPackageMng;
      }
      
      public function rulesPackageGetFile(name:String) : String
      {
         var tokens:Array = null;
         var returnValue:String = null;
         var rulesPackageMng:MultiArchiveUnpacker;
         if((rulesPackageMng = this.rulesPackageGetMng()) != null)
         {
            tokens = name.split("/");
            returnValue = rulesPackageMng.getArchive(tokens[tokens.length - 1]);
         }
         return returnValue;
      }
   }
}
