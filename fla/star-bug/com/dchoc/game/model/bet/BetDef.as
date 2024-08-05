package com.dchoc.game.model.bet
{
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class BetDef extends DCDef
   {
       
      
      private var mBet:String = "";
      
      private var mReward:String = "";
      
      private var mUsesForFree:SecureInt;
      
      public function BetDef()
      {
         mUsesForFree = new SecureInt("BetDef.mUsesForFree");
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         super.doFromXml(info);
         var attribute:String = "bet";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setBet(EUtils.xmlReadString(info,attribute));
         }
         attribute = "reward";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setReward(EUtils.xmlReadString(info,attribute));
         }
         attribute = "usesFree";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setUsesForFree(EUtils.xmlReadInt(info,attribute));
         }
      }
      
      public function getBet() : String
      {
         return this.mBet;
      }
      
      public function getReward() : String
      {
         return this.mReward;
      }
      
      public function getUsesForFree() : int
      {
         return this.mUsesForFree.value;
      }
      
      private function setBet(value:String) : void
      {
         this.mBet = value;
      }
      
      private function setReward(value:String) : void
      {
         this.mReward = value;
      }
      
      private function setUsesForFree(value:int) : void
      {
         this.mUsesForFree.value = value;
      }
   }
}
