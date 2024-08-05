package com.dchoc.game.model.umbrella
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class UmbrellaSkinDef extends DCDef
   {
       
      
      private var mShipSku:String;
      
      public function UmbrellaSkinDef()
      {
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         var attribute:String = "shipSku";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setShipSku(EUtils.xmlReadString(info,attribute));
         }
      }
      
      private function setShipSku(value:String) : void
      {
         this.mShipSku = value;
      }
      
      public function getShipSku() : String
      {
         return this.mShipSku;
      }
   }
}
