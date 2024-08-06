package com.dchoc.game.model.shop
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class PurchaseShopDef extends DCDef
   {
       
      
      private var mTitleTID:int;
      
      private var mEventTypeCRM:String;
      
      public function PurchaseShopDef()
      {
         super();
      }
      
      override protected function doReset() : void
      {
         this.mTitleTID = 0;
      }
      
      override protected function doFromXml(info:XML) : void
      {
         var attribute:String = "titleTID";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTitleTID(EUtils.xmlReadString(info,attribute));
         }
         attribute = "eventTypeCRM";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setEventTypeCRM(EUtils.xmlReadString(info,attribute));
         }
      }
      
      private function setTitleTID(value:String) : void
      {
         this.mTitleTID = TextIDs[value];
      }
      
      public function getTitleTID() : int
      {
         return this.mTitleTID;
      }
      
      private function setEventTypeCRM(value:String) : void
      {
         this.mEventTypeCRM = value;
      }
      
      public function getEventTypeCRM() : String
      {
         return this.mEventTypeCRM;
      }
   }
}
