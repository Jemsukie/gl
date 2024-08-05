package com.dchoc.game.model.world.target.condition
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   
   public class ConditionCurrentView extends Condition
   {
       
      
      public function ConditionCurrentView()
      {
         super();
      }
      
      override public function check(target:DCTarget, index:int = 0) : Boolean
      {
         var viewId:int = parseInt(target.getDef().getConditionParameterSku());
         return InstanceMng.getApplication().viewGetMode() == viewId;
      }
   }
}
