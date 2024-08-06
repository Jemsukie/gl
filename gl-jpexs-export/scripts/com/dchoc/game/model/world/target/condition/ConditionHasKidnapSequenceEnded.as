package com.dchoc.game.model.world.target.condition
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   
   public class ConditionHasKidnapSequenceEnded extends Condition
   {
       
      
      public function ConditionHasKidnapSequenceEnded()
      {
         super();
      }
      
      override public function check(target:DCTarget, index:int = 0) : Boolean
      {
         return InstanceMng.getTutorialKidnapMng() != null && InstanceMng.getTutorialKidnapMng().hasEnded();
      }
   }
}
