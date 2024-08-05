package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   
   public class ActionPrepareBattle extends DCAction
   {
       
      
      public function ActionPrepareBattle()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         InstanceMng.getGUIController().hideHud();
         InstanceMng.getGUIControllerPlanet().hideOpenedBar();
         if(InstanceMng.getFlowStatePlanet().isTutorialRunning())
         {
            InstanceMng.getUserInfoMng().setUserToVisitByAccountId("npc_B");
         }
         return true;
      }
   }
}
