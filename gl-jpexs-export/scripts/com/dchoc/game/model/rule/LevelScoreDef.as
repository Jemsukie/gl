package com.dchoc.game.model.rule
{
   import com.dchoc.game.controller.entry.Entry;
   import com.dchoc.game.controller.entry.EntryFactory;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class LevelScoreDef extends DCDef
   {
       
      
      public var mMinXp:SecureNumber;
      
      public var mMaxXp:SecureNumber;
      
      public var mRewardCoins:SecureInt;
      
      public var mRewardMinerals:SecureInt;
      
      public var mRewardChips:SecureInt;
      
      private var mMinLevelCanAttack:SecureInt;
      
      public function LevelScoreDef()
      {
         mMinXp = new SecureNumber("LevelScoreDef.mMinXp");
         mMaxXp = new SecureNumber("LevelScoreDef.mMaxXp");
         mRewardCoins = new SecureInt("LevelScoreDef.mRewardCoins");
         mRewardMinerals = new SecureInt("LevelScoreDef.mRewardMinerals");
         mRewardChips = new SecureInt("LevelScoreDef.mRewardChips");
         mMinLevelCanAttack = new SecureInt("LevelScoreDef.mMinLevelCanAttack");
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         var rewardCoins:String = null;
         var rewardMinerals:String = null;
         var rewardChips:String = null;
         var attribute:String = "maxXp";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMaxXp(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "rewardCoins";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            rewardCoins = EUtils.xmlReadString(info,attribute);
            if(rewardCoins != "")
            {
               this.setRewardCoins(int(rewardCoins));
            }
         }
         attribute = "rewardMinerals";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            if((rewardMinerals = EUtils.xmlReadString(info,attribute)) != "")
            {
               this.setRewardMinerals(int(rewardMinerals));
            }
         }
         attribute = "rewardChips";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            rewardChips = EUtils.xmlReadString(info,attribute);
            if(rewardChips != "")
            {
               this.setRewardChips(int(rewardChips));
            }
         }
         attribute = "minLevelCanAttack";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMinLevelCanAttack(EUtils.xmlReadInt(info,attribute));
         }
      }
      
      public function setMinXp(exp:Number) : void
      {
         this.mMinXp.value = exp;
      }
      
      public function setMaxXp(exp:Number) : void
      {
         this.mMaxXp.value = exp;
      }
      
      public function setRewardCoins(value:int) : void
      {
         this.mRewardCoins.value = value;
      }
      
      public function setRewardMinerals(value:int) : void
      {
         this.mRewardMinerals.value = value;
      }
      
      public function setRewardChips(value:int) : void
      {
         this.mRewardChips.value = value;
      }
      
      public function setMinLevelCanAttack(value:int) : void
      {
         this.mMinLevelCanAttack.value = value;
      }
      
      public function getMinXp() : Number
      {
         return this.mMinXp.value;
      }
      
      public function getMaxXp() : Number
      {
         return this.mMaxXp.value;
      }
      
      public function getRewardCoins() : int
      {
         return this.mRewardCoins.value;
      }
      
      public function getRewardMinerals() : int
      {
         return this.mRewardMinerals.value;
      }
      
      public function getRewardChips() : int
      {
         return this.mRewardChips.value;
      }
      
      public function getMinLevelCanAttack() : int
      {
         return this.mMinLevelCanAttack.value;
      }
      
      public function getRewardAsEntry() : Entry
      {
         var entry:Entry = null;
         if(this.getRewardChips())
         {
            entry = EntryFactory.createEntryFromEntrySet("cash:" + this.getRewardChips());
         }
         else if(this.getRewardCoins())
         {
            entry = EntryFactory.createEntryFromEntrySet("coins:" + this.getRewardCoins());
         }
         else
         {
            entry = EntryFactory.createEntryFromEntrySet("minerals:" + this.getRewardMinerals());
         }
         return entry;
      }
   }
}
