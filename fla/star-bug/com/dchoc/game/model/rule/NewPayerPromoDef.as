package com.dchoc.game.model.rule
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class NewPayerPromoDef extends DCDef
   {
       
      
      private var mAction:String = "";
      
      private var mTarget:String = "";
      
      private var mCoins:int = 0;
      
      private var mRewards:Vector.<String>;
      
      private var mImageRewards:Vector.<String>;
      
      private var mTIDRewards:Vector.<String>;
      
      public function NewPayerPromoDef()
      {
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         super.doFromXml(info);
         var attribute:String = "action";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setAction(EUtils.xmlReadString(info,attribute));
         }
         attribute = "target";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTarget(EUtils.xmlReadString(info,attribute));
         }
         this.readRewards(info);
         this.readTIDRewards(info);
      }
      
      private function readRewards(info:XML) : void
      {
         this.mRewards = new Vector.<String>(0);
         var attribute:String = "rewards";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.initializeVector(EUtils.xmlReadString(info,attribute),this.mRewards);
         }
      }
      
      private function readImageRewards(info:XML) : void
      {
         this.mImageRewards = new Vector.<String>(0);
         var attribute:String = "imageRewards";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.initializeVector(EUtils.xmlReadString(info,attribute),this.mImageRewards);
         }
      }
      
      private function readTIDRewards(info:XML) : void
      {
         this.mTIDRewards = new Vector.<String>(0);
         var attribute:String = "tidRewards";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.initializeVector(EUtils.xmlReadString(info,attribute),this.mTIDRewards);
         }
      }
      
      private function initializeVector(flags:String, vector:Vector.<String>) : void
      {
         var str:String = null;
         var arr:Array = flags.split(",");
         for each(str in arr)
         {
            if(str != "")
            {
               vector.push(str);
            }
         }
      }
      
      public function getAction() : String
      {
         return this.mAction;
      }
      
      public function getTarget() : String
      {
         return this.mTarget;
      }
      
      public function getRewardsVector() : Vector.<String>
      {
         return this.mRewards;
      }
      
      public function getReward(idx:int) : String
      {
         if(this.mRewards != null && idx < this.mRewards.length)
         {
            return this.mRewards[idx];
         }
         return "NULL";
      }
      
      public function getImageRewardsVector() : Vector.<String>
      {
         return this.mImageRewards;
      }
      
      public function getImageReward(idx:int) : String
      {
         if(this.mImageRewards != null && idx < this.mImageRewards.length)
         {
            return this.mImageRewards[idx];
         }
         return "NULL";
      }
      
      public function getTIDReward(idx:int) : String
      {
         if(this.mTIDRewards != null && idx < this.mTIDRewards.length)
         {
            return this.mTIDRewards[idx];
         }
         return "NULL";
      }
      
      private function setAction(value:String) : void
      {
         this.mAction = value;
      }
      
      private function setTarget(value:String) : void
      {
         this.mTarget = value;
      }
   }
}
