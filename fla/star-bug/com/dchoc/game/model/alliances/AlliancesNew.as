package com.dchoc.game.model.alliances
{
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import flash.globalization.DateTimeFormatter;
   
   public class AlliancesNew
   {
       
      
      private var mType:int;
      
      private var mSubtype:int;
      
      private var mName:String;
      
      private var mURL:String;
      
      private var mLogo:String;
      
      private var mLevel:int;
      
      private var mTimeStamp:Number;
      
      private var mMessage:String;
      
      public function AlliancesNew()
      {
         super();
      }
      
      public function fromJSON(data:Object) : void
      {
         this.mType = int(data.type);
         this.mSubtype = int(data.subType);
         switch(this.mType)
         {
            case 0:
               this.setupNewsAlliance(data);
               break;
            case 1:
               this.setupNewsMembers(data);
               break;
            case 2:
               this.setupNewsWar(data);
               break;
            default:
               DCDebug.trace("ALERT, type not found: " + this.mType.toString(),1);
         }
         this.mLogo = data.logo;
         this.mTimeStamp = Number(data.timestamp);
      }
      
      private function setupNewsAlliance(data:Object) : void
      {
         var textTid:int = 0;
         switch(this.mSubtype)
         {
            case 0:
               this.mLevel = int(data.level);
               textTid = 2872;
               this.mMessage = DCTextMng.replaceParameters(textTid,[this.mLevel]);
               break;
            case 12:
               this.mName = data.name;
               textTid = 2882;
               this.mMessage = DCTextMng.replaceParameters(textTid,[this.mName]);
               break;
            default:
               DCDebug.trace("ALERT, subtype not found: " + this.mSubtype.toString(),1);
         }
      }
      
      private function setupNewsMembers(data:Object) : void
      {
         var textTid:int = 0;
         this.setName(data.name);
         this.mURL = data.pictureUrl;
         switch(this.mSubtype - 1)
         {
            case 0:
               textTid = 2873;
               this.mMessage = DCTextMng.replaceParameters(textTid,[this.mName]);
               break;
            case 1:
               textTid = 2874;
               this.mMessage = DCTextMng.replaceParameters(textTid,[this.mName]);
               break;
            case 2:
               textTid = 2875;
               this.mMessage = DCTextMng.replaceParameters(textTid,[this.mName]);
               break;
            case 3:
               textTid = 2876;
               this.mMessage = DCTextMng.replaceParameters(textTid,[this.mName,DCTextMng.getText(2814)]);
               break;
            case 4:
               textTid = 2876;
               this.mMessage = DCTextMng.replaceParameters(textTid,[this.mName,DCTextMng.getText(2816)]);
               break;
            case 5:
               textTid = 2877;
               this.mMessage = DCTextMng.replaceParameters(textTid,[this.mName,DCTextMng.getText(2816)]);
               break;
            case 6:
               textTid = 2877;
               this.mMessage = DCTextMng.replaceParameters(textTid,[this.mName,DCTextMng.getText(2818)]);
               break;
            case 12:
               this.mName = data.name;
               textTid = 2883;
               this.mMessage = DCTextMng.replaceParameters(textTid,[this.mName]);
               break;
            default:
               DCDebug.trace("ALERT, subType not found: " + this.mSubtype.toString(),1);
         }
      }
      
      private function setupNewsWar(data:Object) : void
      {
         var str:String = null;
         var textTid:int = 0;
         this.mName = data.name;
         switch(this.mSubtype - 8)
         {
            case 0:
               textTid = 2878;
               break;
            case 1:
               textTid = 2879;
               break;
            case 2:
               textTid = 2880;
               break;
            case 3:
               textTid = 2881;
               break;
            case 6:
               textTid = 4345;
               break;
            default:
               DCDebug.trace("ALERT, subtype not found: " + this.mSubtype.toString(),1);
         }
         if(textTid != 0)
         {
            str = this.mName == null ? "<>" : this.mName;
            this.mMessage = DCTextMng.replaceParameters(textTid,[str]);
         }
      }
      
      private function setName(value:String) : void
      {
         var surnameIndex:int = 0;
         var name:String = null;
         if(value != null)
         {
            surnameIndex = value.indexOf(" ");
            name = value.substring(0,surnameIndex);
         }
         this.mName = name != "" ? name : value;
      }
      
      public function getName() : String
      {
         return this.mName;
      }
      
      public function getURL() : String
      {
         return this.mURL;
      }
      
      public function getLevel() : int
      {
         return this.mLevel;
      }
      
      public function getTimeStampMillis() : Number
      {
         return this.mTimeStamp;
      }
      
      public function getTimeText() : String
      {
         var format:DateTimeFormatter = new DateTimeFormatter(DCTextMng.lang,"medium","none");
         return format.format(DCTimerUtil.dateFromMs(this.mTimeStamp));
      }
      
      public function getType() : int
      {
         return this.mType;
      }
      
      public function getSubType() : int
      {
         return this.mSubtype;
      }
      
      public function getLogo() : String
      {
         return this.mLogo;
      }
      
      public function getMessage() : String
      {
         return this.mMessage;
      }
   }
}
