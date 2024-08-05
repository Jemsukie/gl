package com.dchoc.game.model.world.target.condition
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.view.gui.popups.DCIPopupSpeech;
   
   public class ConditionSpeechBubbleTextEnd extends Condition
   {
       
      
      public function ConditionSpeechBubbleTextEnd()
      {
         super();
      }
      
      override public function check(target:DCTarget, index:int = 0) : Boolean
      {
         if(target.State <= 1)
         {
            return false;
         }
         var popup:DCIPopupSpeech = InstanceMng.getPopupMng().getPopupBeingShown() as DCIPopupSpeech;
         if(popup == null)
         {
            return true;
         }
         return popup.isTyping() == false;
      }
   }
}
