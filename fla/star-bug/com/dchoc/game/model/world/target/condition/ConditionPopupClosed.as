package com.dchoc.game.model.world.target.condition
{
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.view.gui.popups.DCPopupMng;
   
   public class ConditionPopupClosed extends Condition
   {
       
      
      public function ConditionPopupClosed()
      {
         super();
      }
      
      override public function check(target:DCTarget, index:int = 0) : Boolean
      {
         return !DCPopupMng.smIsPopupActive;
      }
   }
}
