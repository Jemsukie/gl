package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.component.DCComponentUI;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   
   public class ActionHideSpotlight extends DCAction
   {
       
      
      public function ActionHideSpotlight()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         var componentToGiveFocusStr:String = isPreaction ? target.getDef().getPreactionTargetSid() : target.getDef().getPostactionTargetSid();
         var component:DCComponentUI = InstanceMng.getGUIController().getComponentByName(componentToGiveFocusStr) as DCComponentUI;
         InstanceMng.getGUIController().unlockGUI(component);
         InstanceMng.getMapView().removeSpotlight();
         return true;
      }
   }
}
