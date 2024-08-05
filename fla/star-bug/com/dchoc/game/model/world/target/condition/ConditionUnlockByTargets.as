package com.dchoc.game.model.world.target.condition
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   
   public class ConditionUnlockByTargets extends Condition
   {
       
      
      public function ConditionUnlockByTargets()
      {
         super();
      }
      
      override public function check(target:DCTarget, index:int = 0) : Boolean
      {
         var id:String = null;
         var state:int = 0;
         var ids:Array = target.getDef().getConditionAmount().split(",");
         for each(id in ids)
         {
            id = String(id.replace(/^\s+|\s+$/g,""));
            state = InstanceMng.getTargetMng().getTargetStateById(id);
            if(id != "" && state <= 2)
            {
               return false;
            }
         }
         return true;
      }
   }
}
