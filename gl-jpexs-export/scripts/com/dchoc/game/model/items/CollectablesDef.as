package com.dchoc.game.model.items
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class CollectablesDef extends DCDef
   {
      
      public static const REWARD_SKU:int = 0;
      
      public static const REWARD_AMOUNT:int = 1;
       
      
      private var mReward:Array;
      
      private var mItemsList:Array;
      
      private var mName:String = "";
      
      private var mOrder:int = 0;
      
      public function CollectablesDef()
      {
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         var attribute:String = "reward";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mReward = EUtils.xmlReadString(info,attribute).split(":");
         }
         attribute = "itemSkuList";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mItemsList = EUtils.xmlReadString(info,attribute).split(",");
         }
         attribute = "name";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setCollectionName(EUtils.xmlReadString(info,attribute));
         }
         attribute = "order";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setOrder(EUtils.xmlReadInt(info,attribute));
         }
      }
      
      public function getReward() : Array
      {
         return this.mReward;
      }
      
      public function getCollectionList() : Array
      {
         return this.mItemsList;
      }
      
      public function getCollectionName() : String
      {
         return this.mName;
      }
      
      public function setCollectionName(value:String) : void
      {
         this.mName = value;
      }
      
      override public function getOrder() : int
      {
         return this.mOrder;
      }
      
      public function setOrder(value:int) : void
      {
         this.mOrder = value;
      }
   }
}
