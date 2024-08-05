package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.view.facade.UIFacade;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   
   public class ActionNPCAttackOver extends DCAction
   {
       
      
      public function ActionNPCAttackOver()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         var uiFacade:UIFacade = InstanceMng.getUIFacade();
         InstanceMng.getGUIController().showHud();
         uiFacade.friendsBarShow();
         InstanceMng.getGUIController().getToolBar().moveAppearDownToUp();
         return true;
      }
   }
}
