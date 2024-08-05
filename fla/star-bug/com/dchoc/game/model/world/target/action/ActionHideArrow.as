package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   
   public class ActionHideArrow extends DCAction
   {
       
      
      public function ActionHideArrow()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         InstanceMng.getViewMngGame().removeAllHighlights();
         return true;
      }
   }
}
