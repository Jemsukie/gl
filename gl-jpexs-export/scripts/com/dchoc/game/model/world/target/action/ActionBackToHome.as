package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   
   public class ActionBackToHome extends DCAction
   {
       
      
      public function ActionBackToHome()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         var units:Vector.<Array> = InstanceMng.getHangarControllerMng().getProfileLoginHangarController().getStoredUnitsInfo();
         InstanceMng.getHangarControllerMng().getProfileLoginHangarController().removeUnitsFromHangars(units,false);
         InstanceMng.getUIFacade().friendsBarLockVisitButtonOnFriend("npc_B",false);
         InstanceMng.getFlowStatePlanet().visitReturnToOwnWorld();
         return true;
      }
   }
}
