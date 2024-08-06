package com.dchoc.game.model.rule
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class WarPointsPerHQDef extends DCDef
   {
       
      
      private var mPoints:Number;
      
      public function WarPointsPerHQDef()
      {
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         super.doFromXml(info);
         var attribute:String = "points";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setPoints(EUtils.xmlReadNumber(info,attribute));
         }
      }
      
      public function getPoints() : Number
      {
         return this.mPoints;
      }
      
      private function setPoints(value:Number) : void
      {
         this.mPoints = value;
      }
   }
}
