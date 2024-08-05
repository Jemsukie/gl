package com.dchoc.game.controller.notifications
{
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   
   public class Notification
   {
       
      
      private var mId:String;
      
      private var mMessageTitle:String;
      
      private var mMessageBody:String;
      
      private var mAdvisorId:String;
      
      private var mWIOSku:String;
      
      private var mWIOUpgradeLevel:int;
      
      private var mPopup:DCIPopup;
      
      public function Notification(id:String, titleMessage:String, bodyMessage:String, advisorId:String)
      {
         super();
         this.mId = id;
         this.mMessageBody = bodyMessage;
         this.mMessageTitle = titleMessage;
         this.mAdvisorId = advisorId;
      }
      
      public function setWIOData(wioSku:String, levelRequired:int) : void
      {
         this.mWIOSku = wioSku;
         this.mWIOUpgradeLevel = levelRequired;
      }
      
      public function getId() : String
      {
         return this.mId;
      }
      
      public function getWIOSku() : String
      {
         return this.mWIOSku;
      }
      
      public function getWIOUpgradeLevel() : int
      {
         return this.mWIOUpgradeLevel;
      }
      
      public function getMessageTitle() : String
      {
         return this.mMessageTitle;
      }
      
      public function getMessageBody() : String
      {
         return this.mMessageBody;
      }
      
      public function getAdvisorId() : String
      {
         return this.mAdvisorId;
      }
      
      public function setPopup(value:DCIPopup) : void
      {
         this.mPopup = value;
      }
      
      public function getPopup() : DCIPopup
      {
         return this.mPopup;
      }
   }
}
