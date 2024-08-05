package com.dchoc.game.model.world.target.action
{
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   
   public class ActionLockPopupInstantOps extends DCAction
   {
       
      
      public function ActionLockPopupInstantOps()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         return true;
      }
   }
}
