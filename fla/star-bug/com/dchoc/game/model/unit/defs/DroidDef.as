package com.dchoc.game.model.unit.defs
{
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import esparragon.utils.EUtils;
   
   public class DroidDef extends UnitDef
   {
       
      
      private var mConstructionCoins:SecureNumber;
      
      private var mConstructionXp:SecureNumber;
      
      private var mIcon:String = "";
      
      private var mItemListMain:Array;
      
      private var mItemListColony:Array;
      
      private var mInvestItemsList:Array;
      
      public function DroidDef()
      {
         mConstructionCoins = new SecureNumber("DroidDef.mConstructionCoins");
         mConstructionXp = new SecureNumber("DroidDef.mConstructionXp");
         super();
         setAnimAngleOffset(-1.5707963267948966);
      }
      
      public function getConstructionCoins() : Number
      {
         return this.mConstructionCoins.value;
      }
      
      public function getConstructionXp() : Number
      {
         return this.mConstructionXp.value;
      }
      
      public function getIcon() : String
      {
         return this.mIcon;
      }
      
      public function getItemListMain() : Array
      {
         return this.mItemListMain;
      }
      
      public function getItemListColony() : Array
      {
         return this.mItemListColony;
      }
      
      public function getInvestItemList() : Array
      {
         return this.mInvestItemsList;
      }
      
      private function setConstructionCoins(value:Number) : void
      {
         this.mConstructionCoins.value = value;
      }
      
      private function setConstructionXp(value:Number) : void
      {
         this.mConstructionXp.value = value;
      }
      
      private function setIcon(value:String) : void
      {
         this.mIcon = value;
      }
      
      private function setItemListMain(value:Array) : void
      {
         this.mItemListMain = value;
      }
      
      private function setItemListColony(value:Array) : void
      {
         this.mItemListColony = value;
      }
      
      private function setInvestItemList(value:Array) : void
      {
         this.mInvestItemsList = value;
      }
      
      override protected function doFromXml(info:XML) : void
      {
         super.doFromXml(info);
         setUnitTypeId(0);
         var attribute:String = "constructionCoins";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setConstructionCoins(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "exp";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setConstructionXp(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "icon";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setIcon(EUtils.xmlReadString(info,attribute));
         }
         attribute = "itemSkuListMain";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setItemListMain(EUtils.xmlReadString(info,attribute).split(","));
         }
         attribute = "itemSkuListColony";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setItemListColony(EUtils.xmlReadString(info,attribute).split(","));
         }
         attribute = "investItemSkuList";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setInvestItemList(EUtils.xmlReadString(info,attribute).split(","));
         }
      }
   }
}
