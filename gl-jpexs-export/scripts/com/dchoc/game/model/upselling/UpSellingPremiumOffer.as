package com.dchoc.game.model.upselling
{
   import com.dchoc.game.core.instance.InstanceMng;
   import esparragon.utils.EUtils;
   
   public class UpSellingPremiumOffer
   {
       
      
      private var mSku:String;
      
      private var mTimeLeft:Number = 0;
      
      private var mItems:String;
      
      private var mStartedAt:Number = 0;
      
      public function UpSellingPremiumOffer()
      {
         super();
      }
      
      public function destroy() : void
      {
         this.mSku = null;
         this.mItems = null;
      }
      
      public function fromXml(xml:XML) : void
      {
         this.setSku(EUtils.xmlReadString(xml,"sku"));
         var attribute:String = "timeLeft";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.setTimeLeft(EUtils.xmlReadNumber(xml,attribute));
         }
         attribute = "startedAt";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.setStartedAt(EUtils.xmlReadNumber(xml,attribute));
         }
         this.logicUpdate(0);
      }
      
      public function getSku() : String
      {
         return this.mSku;
      }
      
      private function setSku(value:String) : void
      {
         this.mSku = value;
      }
      
      public function getTimeLeft() : Number
      {
         return this.mTimeLeft;
      }
      
      private function setTimeLeft(value:Number) : void
      {
         this.mTimeLeft = value;
      }
      
      private function setStartedAt(value:Number) : void
      {
         this.mStartedAt = value;
      }
      
      public function getStartedAt() : Number
      {
         return this.mStartedAt;
      }
      
      public function isRunning() : Boolean
      {
         return true;
      }
      
      public function logicUpdate(dt:int) : void
      {
      }
      
      public function start() : void
      {
         this.setTimeLeft(InstanceMng.getSettingsDefMng().getUpSellingDuration());
      }
   }
}
