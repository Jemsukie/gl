package com.dchoc.game.model.waves
{
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.game.utils.anticheat.SecureString;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class WaveSpawnDef extends DCDef
   {
       
      
      private var mHQLevel:SecureString;
      
      private var mMinHQLevel:SecureInt;
      
      private var mMaxHQLevel:SecureInt;
      
      private var mCountdown:SecureNumber;
      
      private var mDuration:SecureNumber;
      
      private var mWave:SecureString;
      
      private var mReward:Array;
      
      private var mRewardEntry:SecureString;
      
      public function WaveSpawnDef()
      {
         mHQLevel = new SecureString("WaveSpawnDef.mHQLevel","");
         mMinHQLevel = new SecureInt("WaveSpawnDef.mMinHQLevel");
         mMaxHQLevel = new SecureInt("WaveSpawnDef.mMaxHQLevel",2147483647);
         mCountdown = new SecureNumber("WaveSpawnDef.mCountdown");
         mDuration = new SecureNumber("WaveSpawnDef.mDuration");
         mWave = new SecureString("WaveSpawnDef.mWave","");
         mRewardEntry = new SecureString("WaveSpawnDef.mRewardEntry","");
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         super.doFromXml(info);
         var attribute:String = "Hqlevel";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setHQLevel(EUtils.xmlReadString(info,attribute));
         }
         attribute = "countdown";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setCountdown(DCTimerUtil.minToMs(EUtils.xmlReadNumber(info,attribute)));
         }
         attribute = "duration";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setDuration(DCTimerUtil.secondToMs(EUtils.xmlReadNumber(info,attribute)));
         }
         attribute = "wave";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setWave(EUtils.xmlReadString(info,attribute));
         }
         attribute = "reward";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setReward(EUtils.xmlReadString(info,attribute));
         }
      }
      
      private function setHQLevel(value:String) : void
      {
         this.mHQLevel.value = value;
         var min:String = String(value.split("-")[0]);
         var max:String = String(value.split("-")[1]);
         if(min != "" && min != "X" && min != "x")
         {
            this.mMinHQLevel.value = int(min);
         }
         if(max != "" && max != "X" && max != "x")
         {
            this.mMaxHQLevel.value = int(max);
         }
      }
      
      private function setCountdown(value:Number) : void
      {
         this.mCountdown.value = value;
      }
      
      private function setDuration(value:Number) : void
      {
         this.mDuration.value = value;
      }
      
      private function setWave(value:String) : void
      {
         this.mWave.value = value;
      }
      
      private function setReward(value:String) : void
      {
         var i:int = 0;
         var aux:Array = null;
         this.mRewardEntry.value = value;
         var items:Array;
         var length:int = int((items = value.split(",")).length);
         this.mReward = [];
         for(i = 0; i < length; )
         {
            aux = items[i].split(":");
            aux[1] = parseInt(aux[1]);
            this.mReward.push(aux);
            i++;
         }
      }
      
      public function getCountdown() : Number
      {
         return this.mCountdown.value;
      }
      
      public function getDuration() : Number
      {
         return this.mDuration.value;
      }
      
      public function getWave() : String
      {
         return this.mWave.value;
      }
      
      public function getReward() : Array
      {
         return this.mReward;
      }
      
      public function getRewardEntry() : String
      {
         return this.mRewardEntry.value;
      }
      
      public function isBetweenHQLevel(level:int) : Boolean
      {
         return this.mMinHQLevel.value <= level && level <= this.mMaxHQLevel.value;
      }
   }
}
