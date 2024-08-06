package com.dchoc.game.model.loading
{
   import esparragon.utils.EUtils;
   
   public class LoadingDef
   {
       
      
      private var mTipsSkus:Array;
      
      private var mAssetId:String;
      
      public function LoadingDef()
      {
         super();
      }
      
      public function fromXml(xml:XML) : void
      {
         this.mTipsSkus = EUtils.xmlReadString(xml,"tipsSkus").split(",");
         this.mAssetId = EUtils.xmlReadString(xml,"assetId");
      }
      
      public function getTipsSkus() : Array
      {
         return this.mTipsSkus;
      }
      
      public function getTipsCount() : int
      {
         return this.mTipsSkus == null ? 0 : int(this.mTipsSkus.length);
      }
      
      public function getAssetId() : String
      {
         return this.mAssetId;
      }
   }
}
