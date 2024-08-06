package com.dchoc.game.model.rule
{
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class AlliancesLevelDef extends DCDef
   {
       
      
      public var mMinScore:SecureNumber;
      
      public var mMaxScore:SecureNumber;
      
      private var mMinLevelCanAttack:SecureInt;
      
      private var mMaxBadges:SecureNumber;
      
      public function AlliancesLevelDef()
      {
         mMinScore = new SecureNumber("AlliancesLevelDef.mMinScore");
         mMaxScore = new SecureNumber("AlliancesLevelDef.mMaxScore");
         mMinLevelCanAttack = new SecureInt("AlliancesLevelDef.mMinLevelCanAttack");
         mMaxBadges = new SecureNumber("AlliancesLevelDef.mMaxBadges");
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         var attribute:String = "maxWarPoints";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMaxScore(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "minLevelCanAttack";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMinLevelCanAttack(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "maxBadges";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMaxBadges(EUtils.xmlReadInt(info,attribute));
         }
      }
      
      public function setMinScore(score:Number) : void
      {
         this.mMinScore.value = score;
      }
      
      public function setMaxScore(score:Number) : void
      {
         this.mMaxScore.value = score;
      }
      
      public function setMinLevelCanAttack(value:int) : void
      {
         this.mMinLevelCanAttack.value = value;
      }
      
      public function getMinScore() : Number
      {
         return this.mMinScore.value;
      }
      
      public function getMaxScore() : Number
      {
         return this.mMaxScore.value;
      }
      
      public function getMinLevelCanAttack() : int
      {
         return this.mMinLevelCanAttack.value;
      }
      
      public function setMaxBadges(badges:Number) : void
      {
         this.mMaxBadges.value = badges;
      }
      
      public function getMaxBadges() : Number
      {
         return this.mMaxBadges.value;
      }
   }
}
