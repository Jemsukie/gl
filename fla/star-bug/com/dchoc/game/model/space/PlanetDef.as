package com.dchoc.game.model.space
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class PlanetDef extends DCDef
   {
       
      
      private var mBuyRequirement:String = "";
      
      private var mPlanetGroupSku:String = "";
      
      private var mPlanetGroupDef:PlanetGroupDef = null;
      
      public function PlanetDef()
      {
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         super.doFromXml(info);
         var attribute:String = "buyRequirement";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setBuyRequirement(EUtils.xmlReadString(info,attribute));
         }
         attribute = "group";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setPlanetGroupSku(EUtils.xmlReadString(info,attribute));
         }
      }
      
      private function setBuyRequirement(value:String) : void
      {
         this.mBuyRequirement = value;
      }
      
      private function setPlanetGroupSku(value:String) : void
      {
         this.mPlanetGroupSku = value;
      }
      
      public function getBuyRequirement() : String
      {
         return this.mBuyRequirement;
      }
      
      public function getPlanetGroupSku() : String
      {
         return this.mPlanetGroupSku;
      }
   }
}
