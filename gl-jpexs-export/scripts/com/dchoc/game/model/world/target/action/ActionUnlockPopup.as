package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   
   public class ActionUnlockPopup extends DCAction
   {
       
      
      public function ActionUnlockPopup()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         var popup:DCIPopup = InstanceMng.getPopupMng().getPopupBeingShown();
         if(popup == null)
         {
            popup = InstanceMng.getPopupMng().getLastPopup();
            if(popup == null)
            {
               return false;
            }
         }
         popup.unlockPopup();
         return true;
      }
   }
}
