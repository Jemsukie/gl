package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.component.DCComponentUI;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   
   public class ActionUnlockGUI extends DCAction
   {
      
      private static const ACTION_ID:int = 0;
      
      private static const COMPONENT_ID:int = 1;
      
      private static const ACTION_GIVE_FOCUS:String = "focus";
      
      private static const ACTION_SINGLE_ELEM:String = "singleComponent";
       
      
      public function ActionUnlockGUI()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         var componentId:String;
         var arr:Array = (componentId = isPreaction ? target.getDef().getPreactionTargetSid() : target.getDef().getPostactionTargetSid()).split(":");
         var component:DCComponentUI = InstanceMng.getGUIController().getComponentByName(arr[1]) as DCComponentUI;
         var action:String;
         if((action = String(arr[0])) == "focus")
         {
            InstanceMng.getGUIController().unlockGUI(component);
         }
         else if(action == "singleComponent")
         {
            InstanceMng.getGUIController().unlockSingleGUIElem(component);
         }
         return true;
      }
   }
}
