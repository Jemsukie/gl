package com.dchoc.game.model.world.item
{
   import com.dchoc.game.utils.anticheat.SecureNumber;
   
   public class RefineryStage
   {
       
      
      public var mTimeMinutes:SecureNumber;
      
      public var mCostMinerals:SecureNumber;
      
      public var mRewardSku:String;
      
      public function RefineryStage(costMinerals:Number, timeMinutes:Number, rewardSku:String)
      {
         mTimeMinutes = new SecureNumber("RefineryStage.timeMinutes");
         mCostMinerals = new SecureNumber("RefineryStage.mCostMinerals");
         super();
         this.mCostMinerals.value = costMinerals;
         this.mTimeMinutes.value = timeMinutes;
         this.mRewardSku = rewardSku;
      }
   }
}
