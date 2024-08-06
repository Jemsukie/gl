package com.dchoc.game.model.rule
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class InvestRewardsDef extends DCDef
   {
       
      
      private var mRewardsString:String = "";
      
      public function InvestRewardsDef()
      {
         super();
      }
      
      private function setRewardsString(value:String) : void
      {
         this.mRewardsString = value;
      }
      
      public function getRewardsString() : String
      {
         return this.mRewardsString;
      }
      
      override public function fromXml(info:XML, key:String = "default") : Boolean
      {
         var attribute:String = "rewards";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setRewardsString(EUtils.xmlReadString(info,attribute));
         }
         return super.fromXml(info,key);
      }
   }
}
