package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   
   public class ActionTutorialSetupOptions extends DCAction
   {
       
      
      public function ActionTutorialSetupOptions()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         InstanceMng.getUIFacade().notifySetTutorialOptions();
         return true;
      }
   }
}
