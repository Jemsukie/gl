package com.dchoc.game.model.umbrella
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class UmbrellaSettingsDef extends DCDef
   {
       
      
      private var mEnergyStr:String = null;
      
      private var mNukeDamage:String = null;
      
      private var mSkinSku:String = null;
      
      private var mItemSku:String = null;
      
      private var mRangeRadius:int = 0;
      
      public function UmbrellaSettingsDef()
      {
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         var attribute:String = "energy";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setEnergy(EUtils.xmlReadString(info,attribute));
         }
         attribute = "nukeDamage";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setNukeDamage(EUtils.xmlReadString(info,attribute));
         }
         attribute = "rangeRadius";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setRangeRadius(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "skinSku";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setSkinSku(EUtils.xmlReadString(info,attribute));
         }
         attribute = "itemSku";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setItemSku(EUtils.xmlReadString(info,attribute));
         }
      }
      
      private function setEnergy(value:String) : void
      {
         this.mEnergyStr = value;
      }
      
      private function setNukeDamage(value:String) : void
      {
         this.mNukeDamage = value;
      }
      
      public function getEnergy(hqLevel:int) : Number
      {
         return getValueInIntervalAsInt(this.mEnergyStr,hqLevel);
      }
      
      public function getNukeDamage(hqLevel:int) : Number
      {
         return getValueInIntervalAsInt(this.mNukeDamage,hqLevel);
      }
      
      private function setRangeRadius(value:Number) : void
      {
         this.mRangeRadius = value;
      }
      
      public function getRangeRadius() : Number
      {
         return this.mRangeRadius;
      }
      
      private function setSkinSku(value:String) : void
      {
         this.mSkinSku = value;
      }
      
      public function getSkinSku() : String
      {
         return this.mSkinSku;
      }
      
      private function setItemSku(value:String) : void
      {
         this.mItemSku = value;
      }
      
      public function getItemSku() : String
      {
         return this.mItemSku;
      }
   }
}
