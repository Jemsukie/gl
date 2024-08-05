package com.dchoc.game.model.space
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class SolarSystemDef extends DCDef
   {
       
      
      private var mName:String = "";
      
      private var mPlanetsAmount:int = 0;
      
      private var mMainResourceSku:String = "";
      
      private var mPlayerBenefit:String = "";
      
      public function SolarSystemDef()
      {
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         super.doFromXml(info);
         var attribute:String = "name";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mName = EUtils.xmlReadString(info,attribute);
         }
         attribute = "planetsAmount";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mPlanetsAmount = EUtils.xmlReadInt(info,attribute);
         }
         attribute = "mainResource";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mMainResourceSku = EUtils.xmlReadString(info,attribute);
         }
         attribute = "playerBenefit";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.mPlayerBenefit = EUtils.xmlReadString(info,attribute);
         }
      }
      
      public function getName() : String
      {
         return this.mName;
      }
      
      public function getPlanetsAmount() : int
      {
         return this.mPlanetsAmount;
      }
      
      public function getMainResource() : String
      {
         return this.mMainResourceSku;
      }
      
      public function getPlayerBenefit() : String
      {
         return this.mPlayerBenefit;
      }
   }
}
