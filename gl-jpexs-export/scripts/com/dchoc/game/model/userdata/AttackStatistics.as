package com.dchoc.game.model.userdata
{
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.game.utils.anticheat.SecureString;
   
   public class AttackStatistics
   {
       
      
      private var mCoinsTaken:SecureNumber;
      
      private var mMineralsTaken:SecureNumber;
      
      public var mAttackEntry:SecureString;
      
      public var mRevengeTimeLeft:SecureNumber;
      
      public function AttackStatistics()
      {
         mCoinsTaken = new SecureNumber("AttackStatistics.mCoinsTaken");
         mMineralsTaken = new SecureNumber("AttackStatistics.mMineralsTaken");
         mAttackEntry = new SecureString("AttackStatistics.mAttackEntry");
         mRevengeTimeLeft = new SecureNumber("AttackStatistics.mRevengeTimeLeft");
         super();
      }
      
      public function setCoinsTaken(value:Number) : void
      {
         this.mCoinsTaken.value = value;
      }
      
      public function setMineralsTaken(value:Number) : void
      {
         this.mMineralsTaken.value = value;
      }
      
      public function getCoinsTaken() : Number
      {
         return this.mCoinsTaken.value;
      }
      
      public function getMineralsTaken() : Number
      {
         return this.mMineralsTaken.value;
      }
      
      public function performRevenge() : void
      {
         this.mRevengeTimeLeft.value = 0;
      }
   }
}
