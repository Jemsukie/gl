package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   
   public class ActionLockPopup extends DCAction
   {
       
      
      public function ActionLockPopup()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         var componentId:String = isPreaction ? target.getDef().getPreactionTargetSid() : target.getDef().getPostactionTargetSid();
         InstanceMng.getPopupMng().getPopupBeingShown().lockPopup(componentId);
         return true;
      }
   }
}
