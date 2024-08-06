package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   
   public class ActionOpenSpeechBubble extends DCAction
   {
       
      
      public function ActionOpenSpeechBubble()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         var tutoAdvanceStep:Object = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NotifyTutorialSpeechBubble");
         tutoAdvanceStep.tutoPopupTitle = target.getDef().getTutorialTitle();
         tutoAdvanceStep.tutoPopupDesc = target.getDef().getTutorialBody();
         tutoAdvanceStep.advisorState = target.getDef().getAdvisorPresentation();
         tutoAdvanceStep.advisorSize = 100;
         tutoAdvanceStep.soundAttached = target.getDef().getSoundAttached();
         tutoAdvanceStep.isBubbleSpeech = true;
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),tutoAdvanceStep,true);
         return true;
      }
   }
}
