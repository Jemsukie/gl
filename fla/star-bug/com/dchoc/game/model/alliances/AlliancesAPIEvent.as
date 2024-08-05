package com.dchoc.game.model.alliances
{
   import flash.events.Event;
   
   public class AlliancesAPIEvent extends Event
   {
      
      public static const SUCCESS:String = "alliance_api_success";
      
      public static const ERROR:String = "alliance_api_error";
       
      
      public var alliance:Alliance;
      
      public var alliance_array:Array;
      
      public var user:AlliancesUser;
      
      public var count:uint;
      
      public var retry:Boolean;
      
      private var mErrorCode:int;
      
      private var mErrorMsg:String;
      
      private var mErrorTitle:String;
      
      private var mErrorData:Object;
      
      private var mRequestParams:Object;
      
      public function AlliancesAPIEvent(type:String, requestParams:Object, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.retry = false;
         this.setError(0);
         this.mRequestParams = requestParams;
      }
      
      public function setError(code:int, msg:String = null, data:Object = null) : void
      {
         this.mErrorCode = code;
         this.mErrorMsg = msg;
         this.mErrorData = data;
      }
      
      public function getErrorCode() : int
      {
         return this.mErrorCode;
      }
      
      public function getErrorMsg() : String
      {
         return this.mErrorMsg == null ? AlliancesConstants.getErrorMsg(this.mErrorCode,this.mErrorData) : this.mErrorMsg;
      }
      
      public function getErrorTitle() : String
      {
         return this.mErrorTitle == null ? AlliancesConstants.getErrorTitle(this.mErrorCode) : this.mErrorTitle;
      }
      
      public function getRequestParams() : Object
      {
         return this.mRequestParams;
      }
   }
}
