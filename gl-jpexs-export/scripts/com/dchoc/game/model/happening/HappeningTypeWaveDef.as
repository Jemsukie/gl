package com.dchoc.game.model.happening
{
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import esparragon.utils.EUtils;
   
   public class HappeningTypeWaveDef extends HappeningTypeDef
   {
       
      
      private var mTargetsPerLvl:String;
      
      private var mWavesSpawnGroup:String;
      
      private var mBoxResourcesName:String;
      
      private var mBoxEnemyName:String;
      
      private var mShopAdvisorPath:String;
      
      private var mEnemyAdvisorPath:String;
      
      private var mDelayWaveTime:Number;
      
      private var mTidAttackTitle:String;
      
      private var mTidAttackBody:String;
      
      private var mTidAttackBtnStart:String;
      
      private var mTidAttackBtnDelay:String;
      
      private var mTidAttackBtnSkip:String;
      
      private var mTidWaveCompletedTitle:String;
      
      private var mTidWaveCompletedBody1:String;
      
      private var mTidWaveCompletedBody2:String;
      
      private var mTidCounterCaption:String;
      
      public function HappeningTypeWaveDef()
      {
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         super.doFromXml(info);
         var attribute:String = "target";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTarget(EUtils.xmlReadString(info,attribute));
         }
         attribute = "wavesSpawnGroup";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setWavesSpawnGroup(EUtils.xmlReadString(info,attribute));
         }
         attribute = "boxEnemyName";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setBoxEnemyName(EUtils.xmlReadString(info,attribute));
         }
         attribute = "shopAdvisorPath";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setShopAdvisorPath(EUtils.xmlReadString(info,attribute));
         }
         attribute = "enemyAdvisorPath";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setEnemyAdvisorPath(EUtils.xmlReadString(info,attribute));
         }
         attribute = "delayWaveTime";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setDelayWaveTime(DCTimerUtil.minToMs(EUtils.xmlReadNumber(info,attribute)));
         }
         attribute = "tidAttackTitle";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTidAttackTitle(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidAttackBody";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTidAttackBody(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidAttackBtnStart";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTidAttackBtnStart(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidAttackBtnDelay";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTidAttackBtnDelay(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidAttackBtnSkip";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTidAttackBtnSkip(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidWaveCompletedTitle";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTidWaveCompletedTitle(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidWaveCompletedBody1";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTidWaveCompletedBody1(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidWaveCompletedBody2";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTidWaveCompletedBody2(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidCounterCaption";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTidCounterCaption(EUtils.xmlReadString(info,attribute));
         }
      }
      
      private function setTarget(value:String) : void
      {
         this.mTargetsPerLvl = value;
      }
      
      public function getTarget(HQLevel:int) : int
      {
         return getValueInIntervalAsInt(this.mTargetsPerLvl,HQLevel);
      }
      
      private function setWavesSpawnGroup(value:String) : void
      {
         this.mWavesSpawnGroup = value;
      }
      
      public function getWavesSpawnGroup() : String
      {
         return this.mWavesSpawnGroup;
      }
      
      public function getBoxResourcesName() : String
      {
         return this.mBoxResourcesName;
      }
      
      private function setBoxEnemyName(value:String) : void
      {
         this.mBoxEnemyName = value;
      }
      
      public function getBoxEnemyName() : String
      {
         return this.mBoxEnemyName;
      }
      
      private function setShopAdvisorPath(value:String) : void
      {
         this.mShopAdvisorPath = value;
      }
      
      public function getShopAdvisorPath() : String
      {
         return "assets/flash/" + this.mShopAdvisorPath;
      }
      
      private function setEnemyAdvisorPath(value:String) : void
      {
         this.mEnemyAdvisorPath = value;
      }
      
      public function getEnemyAdvisorPath() : String
      {
         return "assets/flash/" + this.mEnemyAdvisorPath;
      }
      
      private function setDelayWaveTime(value:Number) : void
      {
         this.mDelayWaveTime = value;
      }
      
      public function getDelayWaveTime() : Number
      {
         return this.mDelayWaveTime;
      }
      
      private function setTidAttackTitle(value:String) : void
      {
         this.mTidAttackTitle = value;
      }
      
      public function getTidAttackTitle() : String
      {
         return this.mTidAttackTitle;
      }
      
      private function setTidAttackBody(value:String) : void
      {
         this.mTidAttackBody = value;
      }
      
      public function getTidAttackBody() : String
      {
         return this.mTidAttackBody;
      }
      
      private function setTidAttackBtnStart(value:String) : void
      {
         this.mTidAttackBtnStart = value;
      }
      
      public function getTidAttackBtnStart() : String
      {
         return this.mTidAttackBtnStart;
      }
      
      private function setTidAttackBtnDelay(value:String) : void
      {
         this.mTidAttackBtnDelay = value;
      }
      
      public function getTidAttackBtnDelay() : String
      {
         return this.mTidAttackBtnDelay;
      }
      
      private function setTidAttackBtnSkip(value:String) : void
      {
         this.mTidAttackBtnSkip = value;
      }
      
      public function getTidAttackBtnSkip() : String
      {
         return this.mTidAttackBtnSkip;
      }
      
      private function setTidWaveCompletedTitle(value:String) : void
      {
         this.mTidWaveCompletedTitle = value;
      }
      
      public function getTidWaveCompletedTitle() : String
      {
         return this.mTidWaveCompletedTitle;
      }
      
      private function setTidWaveCompletedBody1(value:String) : void
      {
         this.mTidWaveCompletedBody1 = value;
      }
      
      public function getTidWaveCompletedBody1() : String
      {
         return this.mTidWaveCompletedBody1;
      }
      
      private function setTidWaveCompletedBody2(value:String) : void
      {
         this.mTidWaveCompletedBody2 = value;
      }
      
      public function getTidWaveCompletedBody2() : String
      {
         return this.mTidWaveCompletedBody2;
      }
      
      private function setTidCounterCaption(value:String) : void
      {
         this.mTidCounterCaption = value;
      }
      
      public function getTidCounterCaption() : String
      {
         return this.mTidCounterCaption;
      }
   }
}
