package com.dchoc.game.model.world.target.condition
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   
   public class ConditionCurrentRole extends Condition
   {
       
      
      public function ConditionCurrentRole()
      {
         super();
      }
      
      override public function check(target:DCTarget, index:int = 0) : Boolean
      {
         var roleId:int = parseInt(target.getDef().getConditionParameterSku());
         return InstanceMng.getFlowState().getCurrentRoleId() == roleId;
      }
   }
}
