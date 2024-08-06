package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.model.unit.FireWorksMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   
   public class ActionStartFireworks extends DCAction
   {
       
      
      public function ActionStartFireworks()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         var timeOut:String = "-1";
         if(isPreaction)
         {
            timeOut = target.getDef().getPreactionTargetSid();
         }
         else
         {
            timeOut = target.getDef().getPostactionTargetSid();
         }
         FireWorksMng.getInstance().init(Number(timeOut));
         return true;
      }
   }
}
