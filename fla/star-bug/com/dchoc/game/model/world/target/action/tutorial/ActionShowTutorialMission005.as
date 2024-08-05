package com.dchoc.game.model.world.target.action.tutorial
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.target.TargetMng;
   import com.dchoc.game.model.world.target.action.ActionAutoscroll;
   import com.dchoc.game.model.world.target.action.ActionShowCircleInMap;
   import com.dchoc.game.view.dc.gui.highlights.Highlight;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   
   public class ActionShowTutorialMission005 extends DCAction
   {
      
      private static const MINITARGET_DEPLOY_MARINES:int = 0;
       
      
      private var mTarget:DCTarget;
      
      private var mTargetMng:TargetMng;
      
      private var mHighlight:Highlight;
      
      public function ActionShowTutorialMission005()
      {
         super();
         this.mTargetMng = InstanceMng.getTargetMng();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         this.mTarget = target;
         return true;
      }
      
      override public function logicUpdate(dt:int) : void
      {
         if(this.mTarget.State != 2)
         {
            return;
         }
         var progress0:int = this.mTarget.getProgress(0);
         if(progress0 < this.mTarget.getDef().getMiniTargetAmount(0))
         {
            this.tutorialDeploy();
         }
         else
         {
            this.removeHints();
         }
      }
      
      private function tutorialDeploy() : void
      {
         var accountId:String = InstanceMng.getUserInfoMng().getCurrentProfileLoaded().getAccountId();
         if(InstanceMng.getApplication().viewGetMode() == 0 && InstanceMng.getFlowStatePlanet().getCurrentRoleId() == 3 && accountId == this.mTarget.getDef().getMiniTargetNPC(0))
         {
            if(InstanceMng.getViewMngPlanet().isBuilt() && !InstanceMng.getApplication().isLoading())
            {
               if(!this.mHighlight || !this.mHighlight.parent)
               {
                  this.addHints();
               }
            }
         }
         else
         {
            this.removeHints();
         }
      }
      
      private function addHints() : void
      {
         new ActionAutoscroll().execute(this.mTarget,true);
         this.mHighlight = new ActionShowCircleInMap().placeCircleFromCoords(getTargetCoordinates(this.mTarget.getDef(),true));
         var tutoAdvanceStep:Object = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NotifyTutorialSpeechBubble");
         tutoAdvanceStep.tutoPopupTitle = "TID_TUTORIAL_TITLE14";
         tutoAdvanceStep.tutoPopupDesc = "TID_TUTORIAL_BODY14";
         tutoAdvanceStep.advisorState = "captain_normal";
         tutoAdvanceStep.advisorSize = 100;
         tutoAdvanceStep.soundAttached = this.mTarget.getDef().getSoundAttached();
         tutoAdvanceStep.isBubbleSpeech = true;
         tutoAdvanceStep.openImmediately = false;
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),tutoAdvanceStep,true);
      }
      
      private function removeHints() : void
      {
         if(this.mHighlight)
         {
            InstanceMng.getViewMngGame().removeHighlightObject(this.mHighlight);
            this.mHighlight = null;
            InstanceMng.getApplication().speechPopupClose();
         }
      }
   }
}
