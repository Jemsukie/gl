package com.dchoc.game.model.rule
{
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class RebornObstaclesDef extends DCDef
   {
       
      
      private var mMinutes:SecureInt;
      
      private var mObstaclesCount:SecureInt;
      
      public function RebornObstaclesDef()
      {
         mMinutes = new SecureInt("RebornObstaclesDef.mMinutes");
         mObstaclesCount = new SecureInt("RebornObstaclesDef.mObstaclesCount");
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         var attribute:String = "timeLastLogin";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTime(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "obstaclesReborn";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setObstaclesCount(EUtils.xmlReadInt(info,attribute));
         }
      }
      
      private function setTime(value:int) : void
      {
         this.mMinutes.value = value;
      }
      
      public function getTime() : int
      {
         return this.mMinutes.value;
      }
      
      private function setObstaclesCount(value:int) : void
      {
         this.mObstaclesCount.value = value;
      }
      
      public function getObstaclesCount() : int
      {
         return this.mObstaclesCount.value;
      }
   }
}
