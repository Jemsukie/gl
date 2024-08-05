package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   
   public class ActionSetDefaultBuilding extends DCAction
   {
       
      
      public function ActionSetDefaultBuilding()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         InstanceMng.getWorldItemObjectController().statesSetDefaultBuilding();
         return true;
      }
   }
}
