package com.dchoc.game.core.flow
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   import esparragon.utils.EUtils;
   
   public class RequestTarget
   {
      
      private static const STATE_NONE:int = 0;
      
      private static const STATE_WAITING_FOR_TARGET:int = 1;
      
      private static const STATE_NOTIFY_NO_TARGET_FOUND:int = 2;
      
      private static const STATE_NOTIFY_TARGET_FOUND:int = 3;
       
      
      private var mState:int = 0;
      
      private var mUserId:String;
      
      private var mPlanetId:String;
      
      protected var mErrorPopup:DCIPopup;
      
      private var mConsoleChannel:String;
      
      private var mAttackMode:int;
      
      public function RequestTarget(attackMode:int, consoleChannel:String)
      {
         super();
         this.mAttackMode = attackMode;
         this.mConsoleChannel = consoleChannel;
      }
      
      public function unload() : void
      {
         this.reset();
         this.mErrorPopup = null;
         this.mConsoleChannel = null;
      }
      
      public function getUserId() : String
      {
         return this.mUserId;
      }
      
      public function getPlanetId() : String
      {
         return this.mPlanetId;
      }
      
      private function isRequestTargetAllowed() : Boolean
      {
         return this.mState == 0;
      }
      
      public function requestTarget(data:Object = null) : void
      {
         if(this.isRequestTargetAllowed())
         {
            this.doRequestTarget(data);
            this.setState(1);
         }
         else
         {
            DCDebug.traceCh(this.mConsoleChannel,"Warning : RequestTarget.requestTarget() is not allowed to be applied. State = " + this.mState);
         }
      }
      
      protected function doRequestTarget(data:Object) : void
      {
      }
      
      private function isSetTargetInfoAvailable() : Boolean
      {
         return this.mState == 1;
      }
      
      public function setTargetInfo(obj:XML) : void
      {
         var userInfo:UserInfo = null;
         if(this.isSetTargetInfoAvailable() && obj != null)
         {
            userInfo = InstanceMng.getUserInfoMng().addOtherPlayerInfo(obj);
            this.mUserId = userInfo.getAccountId();
            this.mPlanetId = EUtils.xmlReadString(obj,"planetId");
            this.setState(3);
         }
         else
         {
            DCDebug.traceCh(this.mConsoleChannel,"Warning : RequestTarget.setTargetInfo() is not allowed to be applied. State = " + this.mState);
         }
      }
      
      private function isSetNoTargetFoundAllowed() : Boolean
      {
         return this.isSetTargetInfoAvailable();
      }
      
      public function setNoTargetFound() : void
      {
         if(this.isSetNoTargetFoundAllowed())
         {
            this.setState(2);
         }
         else
         {
            DCDebug.traceCh(this.mConsoleChannel,"Warning : RequestTarget.setNoTargetFound() is not allowed to be applied. State = " + this.mState);
         }
      }
      
      public function notifyRequestForTargetError(cmd:String) : void
      {
      }
      
      protected function reset() : void
      {
         this.setState(0);
      }
      
      public function isWaitingForTarget() : Boolean
      {
         return this.mState == 1;
      }
      
      public function isTargetFound() : Boolean
      {
         return this.mState == 3;
      }
      
      public function attackTarget(checkIfOwnerCanAttack:Boolean, checkIfTargetIsAttackable:Boolean) : void
      {
         InstanceMng.getApplication().attackRequest(this.mUserId,this.mPlanetId,this.mAttackMode,false,checkIfTargetIsAttackable);
         this.reset();
      }
      
      private function setState(value:int) : void
      {
         if(this.mState != value)
         {
            this.mState = value;
            switch(this.mState)
            {
               case 0:
                  this.mUserId = null;
                  this.mPlanetId = null;
                  break;
               case 1:
                  this.mUserId = null;
                  this.mPlanetId = null;
                  this.mErrorPopup = null;
            }
         }
      }
      
      public function notifyActualBattleStart() : void
      {
         if(this.mErrorPopup != null)
         {
            InstanceMng.getUIFacade().closePopup(this.mErrorPopup);
            this.mErrorPopup = null;
         }
      }
   }
}
