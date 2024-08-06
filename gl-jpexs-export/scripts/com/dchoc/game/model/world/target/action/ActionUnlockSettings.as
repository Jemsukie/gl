package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   import flash.utils.Dictionary;
   
   public class ActionUnlockSettings extends DCAction
   {
       
      
      public function ActionUnlockSettings()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         var params:Dictionary = new Dictionary();
         params["containerName"] = "toolbar";
         params["elementName"] = "preferences";
         MessageCenter.getInstance().sendMessage("uiUnlockElement",params);
         InstanceMng.getUIFacade().notifyUnlockSettingsFromAction();
         return true;
      }
   }
}
