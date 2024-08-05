package com.dchoc.game.model.rule
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class BetsSettingsDef extends DCDef
   {
       
      
      private var mMinimumPlayerLevel:int = 0;
      
      private var mMinimumHQLevel:int = 0;
      
      private var mBetWaitingTimeout:int = 0;
      
      private var mBetSummaryFakeSentencesChangeTime:int = 0;
      
      private var mUseBets:Boolean = false;
      
      private var mSummaryAnimationResultTime:int = 0;
      
      public function BetsSettingsDef()
      {
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         var attribute:String = "minimumPlayerLevel";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMinimumPlayerLevel(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "minHQLevel";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMinimumHQLevel(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "betWaitingTimeout";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setBetWaitingTimeout(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "betSummaryFakeSentencesChangeTime";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setBetSummaryFakeSentencesChangeTime(EUtils.xmlReadInt(info,attribute));
         }
         attribute = "useBets";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setUseBets(EUtils.xmlReadBoolean(info,attribute));
         }
         attribute = "summaryAnimationResultTime";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setSummaryAnimationResultTime(EUtils.xmlReadInt(info,attribute));
         }
      }
      
      private function setMinimumPlayerLevel(value:int) : void
      {
         this.mMinimumPlayerLevel = value;
      }
      
      public function getMinimumPlayerLevel() : int
      {
         return this.mMinimumPlayerLevel;
      }
      
      private function setMinimumHQLevel(value:int) : void
      {
         this.mMinimumHQLevel = value;
      }
      
      public function getMinimumHQLevel() : int
      {
         return this.mMinimumHQLevel;
      }
      
      private function setBetWaitingTimeout(value:int) : void
      {
         this.mBetWaitingTimeout = value;
      }
      
      public function getBetWaitingTimeout() : int
      {
         return this.mBetWaitingTimeout;
      }
      
      private function setBetSummaryFakeSentencesChangeTime(value:int) : void
      {
         this.mBetSummaryFakeSentencesChangeTime = value;
      }
      
      public function getBetSummaryFakeSentencesChangeTime() : int
      {
         return this.mBetSummaryFakeSentencesChangeTime;
      }
      
      private function setUseBets(value:Boolean) : void
      {
         this.mUseBets = value;
      }
      
      public function getUseBets() : Boolean
      {
         return this.mUseBets;
      }
      
      private function setSummaryAnimationResultTime(value:int) : void
      {
         this.mSummaryAnimationResultTime = value;
      }
      
      public function getSummaryAnimationResultTime() : int
      {
         return this.mSummaryAnimationResultTime;
      }
   }
}
