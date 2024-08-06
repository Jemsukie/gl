package com.dchoc.game.model.loading
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.utils.EUtils;
   import flash.utils.Dictionary;
   
   public class LoadingMng extends DCComponent
   {
       
      
      private var mLoadingDefs:Dictionary;
      
      private var mLoadingTips:Dictionary;
      
      public function LoadingMng()
      {
         super();
      }
      
      public function setupData(loadingDefs:XML, loadingTips:XML) : void
      {
         this.loadingDefsSetup(loadingDefs);
         this.loadingTipsSetup(loadingTips);
      }
      
      override protected function unloadDo() : void
      {
         this.mLoadingDefs = null;
         this.mLoadingTips = null;
      }
      
      private function loadingDefsSetup(xml:XML) : void
      {
         var loading:XML = null;
         var loadingDef:LoadingDef = null;
         var loadingSku:String = null;
         if(this.mLoadingDefs == null)
         {
            this.mLoadingDefs = new Dictionary();
         }
         for each(loading in EUtils.xmlGetChildrenList(xml,"Definition"))
         {
            loadingSku = EUtils.xmlReadString(loading,"sku");
            loadingDef = new LoadingDef();
            loadingDef.fromXml(loading);
            this.mLoadingDefs[loadingSku] = loadingDef;
         }
      }
      
      private function loadingTipsSetup(xml:XML) : void
      {
         var tip:XML = null;
         var tipSku:String = null;
         var tid:String = null;
         if(this.mLoadingTips == null)
         {
            this.mLoadingTips = new Dictionary();
         }
         for each(tip in EUtils.xmlGetChildrenList(xml,"Definition"))
         {
            tipSku = EUtils.xmlReadString(tip,"sku");
            tid = EUtils.xmlReadString(tip,"tidText");
            this.mLoadingTips[tipSku] = DCTextMng.getText(TextIDs[tid]);
         }
      }
      
      public function getLoadingAssetId(sku:String) : String
      {
         var returnValue:String = null;
         var def:LoadingDef = null;
         if(this.mLoadingDefs != null)
         {
            sku = this.getLoadingBarSku(sku);
            def = this.mLoadingDefs[sku];
            returnValue = def.getAssetId();
            if(returnValue == "default")
            {
               returnValue = InstanceMng.getPlatformSettingsDefMng().getLoadingScreenSku();
            }
         }
         return returnValue;
      }
      
      private function getLoadingBarSku(sku:String) : String
      {
         var returnValue:* = "loadingLogin";
         if(sku == "loadingFirst")
         {
            if(InstanceMng.getApplication().getWaitForIntro())
            {
               sku = "loadingTutorial";
            }
            else
            {
               sku = "loadingLogin";
            }
         }
         if(this.mLoadingDefs[sku] != null)
         {
            returnValue = sku;
         }
         return returnValue;
      }
      
      public function getTipsAmountForCurrentLoadingBar(loadingBar:String) : int
      {
         var def:LoadingDef = null;
         var returnValue:int = 0;
         if(this.mLoadingDefs != null)
         {
            loadingBar = this.getLoadingBarSku(loadingBar);
            def = this.mLoadingDefs[loadingBar];
            if(def != null)
            {
               returnValue = def.getTipsCount();
            }
         }
         return returnValue;
      }
      
      public function getTipForCurrentLoadingBar(loadingBar:String, index:int = 0) : String
      {
         var tipsArr:Array = null;
         var def:LoadingDef = null;
         var returnValue:String = "";
         if(this.mLoadingDefs != null)
         {
            loadingBar = this.getLoadingBarSku(loadingBar);
            if((def = this.mLoadingDefs[loadingBar]) != null)
            {
               tipsArr = def.getTipsSkus();
            }
            if(tipsArr != null)
            {
               if(this.mLoadingTips != null)
               {
                  returnValue = String(this.mLoadingTips[tipsArr[index]]);
               }
            }
         }
         return returnValue;
      }
   }
}
