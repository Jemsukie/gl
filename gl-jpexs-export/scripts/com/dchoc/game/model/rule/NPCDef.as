package com.dchoc.game.model.rule
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class NPCDef extends DCDef
   {
       
      
      private var mMoodNormalResourceId:String = null;
      
      public function NPCDef()
      {
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         var attribute:String = "normalResourceId";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMoodNormalResourceId(EUtils.xmlReadString(info,attribute));
         }
      }
      
      public function getMoodNormalResourceId() : String
      {
         return this.mMoodNormalResourceId;
      }
      
      private function setMoodNormalResourceId(value:String) : void
      {
         this.mMoodNormalResourceId = value;
      }
   }
}
