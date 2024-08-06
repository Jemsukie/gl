package com.dchoc.game.model.rule
{
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class PremiumPricesDef extends DCDef
   {
       
      
      private var mMinutesToOneUSD:SecureNumber;
      
      private var mBound:SecureNumber;
      
      private var mMultiplier:SecureNumber;
      
      private var mDivisor:SecureNumber;
      
      private var mExponent:SecureNumber;
      
      private var mMinutesForFree:SecureNumber;
      
      public function PremiumPricesDef()
      {
         mMinutesToOneUSD = new SecureNumber("PremiumPricesDef.mMinutesToOneUSD");
         mBound = new SecureNumber("PremiumPricesDef.mBound");
         mMultiplier = new SecureNumber("PremiumPricesDef.mMultiplier");
         mDivisor = new SecureNumber("PremiumPricesDef.mDivisor");
         mExponent = new SecureNumber("PremiumPricesDef.mExponent");
         mMinutesForFree = new SecureNumber("PremiumPricesDef.mMinutesForFree");
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         super.doFromXml(info);
         var attribute:String = "bound";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setBound(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "multiplier";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMultiplier(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "divisor";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setDivisor(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "exponent";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setExponent(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "minutesToOneUSD";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMinutesToOneUSD(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "minutesForFree";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMinutesForFree(EUtils.xmlReadNumber(info,attribute));
         }
      }
      
      public function setMinutesToOneUSD(value:Number) : void
      {
         this.mMinutesToOneUSD.value = value;
      }
      
      public function setBound(value:Number) : void
      {
         this.mBound.value = value;
      }
      
      public function setMultiplier(value:Number) : void
      {
         this.mMultiplier.value = value;
      }
      
      public function setDivisor(value:Number) : void
      {
         this.mDivisor.value = value;
      }
      
      public function setExponent(value:Number) : void
      {
         this.mExponent.value = value;
      }
      
      public function setMinutesForFree(value:Number) : void
      {
         this.mMinutesForFree.value = value;
      }
      
      public function getMinutesToOneUSD() : int
      {
         return this.mMinutesToOneUSD.value;
      }
      
      public function getBound() : Number
      {
         return this.mBound.value;
      }
      
      public function getMultiplier() : Number
      {
         return this.mMultiplier.value;
      }
      
      public function getDivisor() : Number
      {
         return this.mDivisor.value;
      }
      
      public function getExponent() : Number
      {
         return this.mExponent.value;
      }
      
      public function getMinutesForFree() : Number
      {
         return this.mMinutesForFree.value;
      }
   }
}
