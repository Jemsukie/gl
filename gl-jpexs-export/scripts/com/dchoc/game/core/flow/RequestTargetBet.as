package com.dchoc.game.core.flow
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.userdata.UserDataMng;
   import esparragon.events.EEvent;
   
   public class RequestTargetBet extends RequestTarget
   {
      
      public static const ERROR_BATTLE_TIMEOUT:String = "battleTimeout";
       
      
      public function RequestTargetBet(attackMode:int, consoleChannel:String)
      {
         super(attackMode,consoleChannel);
      }
      
      override protected function doRequestTarget(data:Object) : void
      {
         InstanceMng.getUserDataMng().updateBets_requestBet(data.sku);
      }
      
      override public function notifyRequestForTargetError(cmd:String) : void
      {
         var _loc2_:* = cmd;
         if("battleTimeout" === _loc2_)
         {
            reset();
            mErrorPopup = InstanceMng.getApplication().lockUIOpenPopupBasedOnResponse({"lockType":UserDataMng.ACCOUNT_LOCKED_BET_TIMEOUT_FOR_OPPONENT_EXPIRED},false,this.onErrorAccepted);
            mErrorPopup.setEvent(InstanceMng.getGUIController().createNotifyEvent("EventPopup","NotifyBetErrorBattleTimeout"));
         }
      }
      
      private function onErrorAccepted(e:EEvent) : void
      {
         InstanceMng.getBetMng().notifyBattleTimeoutAccepted();
      }
   }
}
