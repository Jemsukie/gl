package com.dchoc.game.model.powerups
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   
   public class PowerUpDefMng extends DCDefMng
   {
      
      public static const POWER_UP_TYPE_EXTRA_DAMAGE:String = "turretsExtraDamage";
      
      public static const POWER_UP_TYPE_EXTRA_RANGE:String = "turretsExtraRange";
      
      public static const POWER_UP_TYPE_EXTRA_ENERGY:String = "turretsExtraHealth";
      
      public static const POWER_UP_TYPES:Vector.<String> = new <String>["turretsExtraDamage","turretsExtraRange","turretsExtraHealth"];
       
      
      public function PowerUpDefMng(resourceDefs:Vector.<String>, typeSkus:Vector.<String> = null, directoryPath:String = null, sigFiles:Vector.<String> = null)
      {
         super(resourceDefs,typeSkus,directoryPath,sigFiles);
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new PowerUpDef();
      }
      
      override protected function sortIsNeeded() : Boolean
      {
         return false;
      }
   }
}
