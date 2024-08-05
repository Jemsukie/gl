package com.dchoc.game.model.world.target.condition
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   
   public class ConditionToolSelected extends Condition
   {
       
      
      public function ConditionToolSelected()
      {
         super();
      }
      
      override public function check(target:DCTarget, index:int = 0) : Boolean
      {
         var toolKeyNeeded:int = 0;
         var conditionExtraPars:String = target.getDef().getHideArrowConditionParameter();
         var returnValue:* = false;
         if(conditionExtraPars != null)
         {
            toolKeyNeeded = InstanceMng.getToolsMng().getToolValueByKey(conditionExtraPars);
            returnValue = InstanceMng.getToolsMng().getCurrentToolId() == toolKeyNeeded;
         }
         return returnValue;
      }
   }
}
