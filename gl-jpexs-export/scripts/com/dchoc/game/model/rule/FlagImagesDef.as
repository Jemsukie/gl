package com.dchoc.game.model.rule
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class FlagImagesDef extends DCDef
   {
       
      
      private var mType:String = "";
      
      private var mColor:uint = 0;
      
      public function FlagImagesDef()
      {
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         var attribute:String = "type";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setType(EUtils.xmlReadString(info,attribute));
         }
         attribute = "color";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setColor(EUtils.xmlReadString(info,attribute));
         }
      }
      
      private function setType(value:String) : void
      {
         this.mType = value;
      }
      
      public function getType() : String
      {
         return this.mType;
      }
      
      private function setColor(str:String) : void
      {
         this.mColor = parseInt(str,16);
      }
      
      public function getColor() : int
      {
         return this.mColor;
      }
   }
}
