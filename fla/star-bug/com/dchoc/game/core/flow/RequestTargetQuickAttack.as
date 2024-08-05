package com.dchoc.game.core.flow
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.userdata.UserDataMng;
   
   public class RequestTargetQuickAttack extends RequestTarget
   {
      
      public static const ERROR_TARGET_NOT_FOUND:String = "targetNotFound";
       
      
      public function RequestTargetQuickAttack(attackMode:int, consoleChannel:String)
      {
         super(attackMode,consoleChannel);
      }
      
      override protected function doRequestTarget(data:Object) : void
      {
         InstanceMng.getUnitScene().quickAttackNotifyAskForTarget();
         InstanceMng.getUserDataMng().quickAttackFindTarget();
      }
      
      override public function notifyRequestForTargetError(cmd:String) : void
      {
         var _loc2_:* = cmd;
         if("targetNotFound" === _loc2_)
         {
            this.showNoTargetFoundPopup();
         }
      }
      
      private function showNoTargetFoundPopup() : void
      {
         reset();
         mErrorPopup = InstanceMng.getApplication().lockUIOpenPopupBasedOnResponse({"lockType":UserDataMng.ACCOUNT_LOCKED_QUICK_ATTACK_TARGET_NOT_FOUND},false);
         InstanceMng.getUnitScene().quickAttackNotifyNoTargetFound();
      }
   }
}
