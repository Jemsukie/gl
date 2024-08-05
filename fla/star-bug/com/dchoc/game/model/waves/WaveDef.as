package com.dchoc.game.model.waves
{
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.utils.anticheat.SecureString;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class WaveDef extends DCDef
   {
       
      
      private var mUnits:SecureString;
      
      private var mDeployX:SecureInt;
      
      private var mDeployY:SecureInt;
      
      private var mDeployWay:SecureString;
      
      public function WaveDef()
      {
         mUnits = new SecureString("WaveDef.mUnits","");
         mDeployX = new SecureInt("WaveDef.mDeployX");
         mDeployY = new SecureInt("WaveDef.mDeployY");
         mDeployWay = new SecureString("WaveDef.mDeployWay","");
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         super.doFromXml(info);
         var attribute:String = "units";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setUnits(EUtils.xmlReadString(info,attribute));
         }
         attribute = "x";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setDeployX(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "y";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setDeployY(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "deployWay";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setDeployWay(EUtils.xmlReadString(info,attribute));
         }
      }
      
      public function getUnits() : String
      {
         return this.mUnits.value;
      }
      
      private function setUnits(value:String) : void
      {
         this.mUnits.value = value;
      }
      
      private function setDeployX(value:int) : void
      {
         this.mDeployX.value = value;
      }
      
      public function getDeployX() : int
      {
         return this.mDeployX.value;
      }
      
      public function getDeployY() : int
      {
         return this.mDeployY.value;
      }
      
      private function setDeployY(value:int) : void
      {
         this.mDeployY.value = value;
      }
      
      public function getDeployWay() : String
      {
         return this.mDeployWay.value;
      }
      
      private function setDeployWay(value:String) : void
      {
         this.mDeployWay.value = value;
      }
   }
}
