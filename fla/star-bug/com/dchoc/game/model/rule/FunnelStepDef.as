package com.dchoc.game.model.rule
{
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   import flash.utils.Dictionary;
   
   public class FunnelStepDef extends DCDef
   {
      
      public static const TYPE_CLICK:String = "click";
      
      public static const TYPE_WAIT:String = "wait";
       
      
      private var mType:String = "";
      
      private var mLabelsEvent:Dictionary;
      
      private var mCrmEventFail:String = "";
      
      private var mMissionSku:String = "";
      
      public function FunnelStepDef()
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
         attribute = "labels";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setLabels(EUtils.xmlReadString(info,attribute));
         }
         attribute = "crmEventFail";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setCRMEventFail(EUtils.xmlReadString(info,attribute));
         }
         attribute = "missionSku";
         if(EUtils.xmlIsAttribute(info,attribute))
         {
            this.setMissionSku(EUtils.xmlReadString(info,attribute));
         }
      }
      
      private function setType(value:String) : void
      {
         this.mType = value;
      }
      
      private function setLabels(value:String) : void
      {
         var str:String = null;
         var params:Array = null;
         this.mLabelsEvent = new Dictionary();
         var labels:Array = value.split(",");
         for each(str in labels)
         {
            params = str.split(":");
            this.mLabelsEvent[params[0]] = params[1];
         }
      }
      
      public function needsToDisableSequenceWhenFailed() : Boolean
      {
         return this.mType == "click" && this.mCrmEventFail != "";
      }
      
      public function isFail(label:String) : Boolean
      {
         return this.mLabelsEvent == null || this.mLabelsEvent[label] == null;
      }
      
      public function getCRMEventLabel(label:String) : String
      {
         var returnValue:String = this.getCRMEventFail();
         if(this.mLabelsEvent != null)
         {
            if(this.mLabelsEvent[label] != null)
            {
               returnValue = String(this.mLabelsEvent[label]);
            }
         }
         return returnValue;
      }
      
      public function setCRMEventFail(value:String) : void
      {
         this.mCrmEventFail = value;
      }
      
      private function getCRMEventFail() : String
      {
         return this.mCrmEventFail;
      }
      
      public function getMissionSku() : String
      {
         return this.mMissionSku;
      }
      
      public function setMissionSku(value:String) : void
      {
         this.mMissionSku = value;
      }
      
      public function isAMissionStep() : Boolean
      {
         return this.mMissionSku != "";
      }
   }
}
