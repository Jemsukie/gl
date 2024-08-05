package com.dchoc.game.model.rule
{
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class ProtectionTimeDef extends DCDef
   {
      
      public static const FIELD_PRICE_PC:String = "price";
       
      
      private var mTime:Number = 0;
      
      private var mShopOrder:Number = 0;
      
      public function ProtectionTimeDef()
      {
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         super.doFromXml(info);
         var attribute:String = "time";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setProtectionTime(EUtils.xmlReadNumber(info,attribute));
         }
         paidCurrencyRead("price",info);
         attribute = "shopOrder";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setShopOrder(EUtils.xmlReadNumber(info,attribute));
         }
         attribute = "icon";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            setAssetId(EUtils.xmlReadString(info,attribute));
         }
      }
      
      private function setProtectionTime(value:Number) : void
      {
         this.mTime = value;
      }
      
      private function setShopOrder(value:Number) : void
      {
         this.mShopOrder = value;
      }
      
      public function getProtectionTime() : Number
      {
         return this.mTime;
      }
      
      public function getProtectionTimeInMs() : Number
      {
         return DCTimerUtil.hourToMs(this.mTime);
      }
      
      public function getShopOrder() : Number
      {
         return this.mShopOrder;
      }
      
      public function getTimeAsTexts() : Array
      {
         var time:Number = this.getProtectionTime();
         return GameConstants.getTimeFromMs(DCTimerUtil.hourToMs(time),false,true);
      }
   }
}
