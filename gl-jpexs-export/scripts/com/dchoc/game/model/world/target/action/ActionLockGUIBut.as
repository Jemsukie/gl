package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.component.DCComponentUI;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   
   public class ActionLockGUIBut extends DCAction
   {
       
      
      public function ActionLockGUIBut()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         var componentId:String = isPreaction ? target.getDef().getPreactionTargetSid() : target.getDef().getPostactionTargetSid();
         var infoArr:Array = [];
         infoArr = componentId.split(":");
         var component:DCComponentUI = InstanceMng.getGUIController().getComponentByName(infoArr[0]) as DCComponentUI;
         InstanceMng.getGUIController().lockGUI(component);
         var exception:Object = {};
         exception.action = infoArr[1] != null ? infoArr[1] : "";
         exception.sid = infoArr[2] != null ? infoArr[2] : "";
         if(exception.action == "" && exception.sid == "")
         {
            exception = null;
         }
         InstanceMng.getGUIController().unlockSingleGUIElem(component,exception);
         return true;
      }
   }
}
