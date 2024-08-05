package com.dchoc.game.model.shop
{
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class ShopProgressDef extends DCDef
   {
      
      public static const TYPE_AMOUNT:String = "amount";
      
      public static const TYPE_COUNT_DOWN:String = "countDown";
      
      public static const TYPE_TEXT:String = "text";
      
      public static const SHOW_ON_TOOLTIP_WHEN_BLINKING:String = "whenBlinking";
      
      public static const SHOW_ON_TOOLTIP_WHEN_RUNNING:String = "whenRunning";
      
      public static const SHOW_ON_TOOLTIP_ALWAYS:String = "always";
       
      
      private var mType:String;
      
      private var mBlinkMin:Number = 0;
      
      private var mBlinkMax:Number = 0;
      
      private var mShowOnTooltip:String = null;
      
      public function ShopProgressDef()
      {
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         var attribute:String = "type";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setType(EUtils.xmlReadString(info,attribute));
         }
         attribute = "blinkMin";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setBlinkMin(EUtils.xmlReadString(info,attribute));
         }
         attribute = "blinkMax";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setBlinkMax(EUtils.xmlReadString(info,attribute));
         }
         attribute = "showOnTooltip";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setShowOnTooltip(EUtils.xmlReadString(info,attribute));
         }
      }
      
      private function setType(type:String) : void
      {
         this.mType = type;
      }
      
      public function getType() : String
      {
         return this.mType;
      }
      
      private function setBlinkMin(value:String) : void
      {
         var _loc2_:* = this.mType;
         if("countDown" !== _loc2_)
         {
            this.mBlinkMin = parseInt(value);
         }
         else
         {
            this.mBlinkMin = DCTimerUtil.getTimeFromText(value);
         }
      }
      
      private function setBlinkMax(value:String) : void
      {
         var _loc2_:* = this.mType;
         if("countDown" !== _loc2_)
         {
            this.mBlinkMax = parseInt(value);
         }
         else
         {
            this.mBlinkMax = DCTimerUtil.getTimeFromText(value);
         }
      }
      
      private function setShowOnTooltip(value:String) : void
      {
         this.mShowOnTooltip = value;
      }
      
      public function getShowOnTooltip() : String
      {
         return this.mShowOnTooltip;
      }
      
      public function needsToBlink(currentAmount:Number) : Boolean
      {
         return (this.mBlinkMin > 0 || this.mBlinkMax > 0) && currentAmount >= this.mBlinkMin && currentAmount <= this.mBlinkMax;
      }
   }
}
