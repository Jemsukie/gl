package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.model.unit.FireWorksMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   
   public class ActionStopFireworks extends DCAction
   {
       
      
      public function ActionStopFireworks()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         FireWorksMng.getInstance().stop();
         return true;
      }
   }
}
