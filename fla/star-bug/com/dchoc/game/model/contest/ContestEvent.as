package com.dchoc.game.model.contest
{
   import flash.events.Event;
   
   public class ContestEvent extends Event
   {
      
      public static const SUCCESS:String = "contest_success";
      
      public static const ERROR:String = "contest_error";
       
      
      private var mErrorCode:int;
      
      private var mErrorMsg:String;
      
      public function ContestEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      public function setError(code:int, msg:String = null) : void
      {
         this.mErrorCode = code;
         this.mErrorMsg = msg;
      }
      
      public function getErrorCode() : int
      {
         return this.mErrorCode;
      }
      
      public function getErrorMsg() : String
      {
         return this.mErrorMsg == null ? ContestConstants.getErrorMsg(this.mErrorCode) : this.mErrorMsg;
      }
   }
}
