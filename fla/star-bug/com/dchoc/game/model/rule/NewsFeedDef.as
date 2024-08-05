package com.dchoc.game.model.rule
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   
   public class NewsFeedDef extends DCDef
   {
      
      public static const REWARD_TYPE:int = 0;
      
      public static const REWARD_AMOUNT:int = 1;
       
      
      private var mTidTitle:String = "";
      
      private var mTidCaption:String = "";
      
      private var mTidText:String = "";
      
      private var mTidUrl:String = "";
      
      private var mReward:Array;
      
      private var mSwfUrl:String = "";
      
      private var mFeedsAmount:int = 0;
      
      public function NewsFeedDef()
      {
         super();
      }
      
      override protected function doFromXml(info:XML) : void
      {
         super.doFromXml(info);
         var attribute:String = "reward";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setReward(EUtils.xmlReadString(info,attribute).split(":"));
         }
         attribute = "tidText";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setText(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidName";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setTitle(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidTitle";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setCaption(EUtils.xmlReadString(info,attribute));
         }
         attribute = "tidUrl";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setUrlText(EUtils.xmlReadString(info,attribute));
         }
         attribute = "swfId";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setSwfUrl(EUtils.xmlReadString(info,attribute));
         }
         attribute = "feedAmount";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setFeedsAmount(EUtils.xmlReadInt(info,attribute));
         }
      }
      
      public function getText() : String
      {
         return this.mTidText;
      }
      
      public function getReward() : Array
      {
         return this.mReward;
      }
      
      public function getTitle() : String
      {
         return this.mTidTitle;
      }
      
      public function getCaption() : String
      {
         return this.mTidCaption;
      }
      
      public function getUrlText() : String
      {
         return this.mTidUrl;
      }
      
      public function getSwfUrl() : String
      {
         return this.mSwfUrl;
      }
      
      public function getFeedsAmount() : int
      {
         return this.mFeedsAmount;
      }
      
      private function setText(value:String) : void
      {
         this.mTidText = value;
      }
      
      private function setReward(value:Array) : void
      {
         this.mReward = value;
      }
      
      private function setTitle(value:String) : void
      {
         this.mTidTitle = value;
      }
      
      private function setCaption(value:String) : void
      {
         this.mTidCaption = value;
      }
      
      private function setUrlText(value:String) : void
      {
         this.mTidUrl = value;
      }
      
      private function setSwfUrl(value:String) : void
      {
         this.mSwfUrl = value;
      }
      
      private function setFeedsAmount(value:int) : void
      {
         this.mFeedsAmount = value;
      }
   }
}
