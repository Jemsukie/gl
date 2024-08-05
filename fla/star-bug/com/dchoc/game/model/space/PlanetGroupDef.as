package com.dchoc.game.model.space
{
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class PlanetGroupDef extends DCDef
   {
       
      
      private var mMineralsProductionRateMultiplier:SecureNumber;
      
      private var mCoinsProductionRateMultiplier:SecureNumber;
      
      public function PlanetGroupDef()
      {
         mMineralsProductionRateMultiplier = new SecureNumber("PlanetGroupDef.mMineralsProductionRateMultiplier",0);
         mCoinsProductionRateMultiplier = new SecureNumber("PlanetGroupDef.mCoinsProductionRateMultiplier",0);
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         super.doFromXml(info);
         var attribute:String = "mineralsProductionRateMultiplier";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMineralsProductionRateMultiplier(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "coinsProductionRateMultiplier";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setCoinsProductionRateMultiplier(EUtils.xmlReadNumber(info,attribute));
         }
      }
      
      private function setMineralsProductionRateMultiplier(value:Number) : void
      {
         this.mMineralsProductionRateMultiplier.value = value;
      }
      
      public function getMineralsProductionRateMultiplier() : Number
      {
         return this.mMineralsProductionRateMultiplier.value;
      }
      
      private function setCoinsProductionRateMultiplier(value:Number) : void
      {
         this.mCoinsProductionRateMultiplier.value = value;
      }
      
      public function getCoinsProductionRateMultiplier() : Number
      {
         return this.mCoinsProductionRateMultiplier.value;
      }
   }
}
