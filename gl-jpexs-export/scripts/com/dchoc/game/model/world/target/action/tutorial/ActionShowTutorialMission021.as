package com.dchoc.game.model.world.target.action.tutorial
{
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.popups.navigation.EPopupPlanetAction;
   import com.dchoc.game.model.target.TargetMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   import flash.display.DisplayObjectContainer;
   import flash.utils.Dictionary;
   
   public class ActionShowTutorialMission021 extends DCAction
   {
      
      private static const MINITARGET_SPY:int = 0;
      
      private static const MINITARGET_USE_MISSILE:int = 1;
       
      
      private var mTarget:DCTarget;
      
      private var mTargetMng:TargetMng;
      
      private var mComplete:Boolean;
      
      public function ActionShowTutorialMission021()
      {
         super();
         this.mTargetMng = InstanceMng.getTargetMng();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         this.mTarget = target;
         this.mComplete = false;
         return true;
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var container:DisplayObjectContainer = null;
         var params:Dictionary = null;
         var accountId:String = null;
         if(this.mTarget.State != 2 || this.mComplete)
         {
            return;
         }
         if(InstanceMng.getApplication().viewGetMode() == 0 && InstanceMng.getFlowStatePlanet().getCurrentRoleId() == 2 && InstanceMng.getUserInfoMng().getCurrentProfileLoaded())
         {
            this.mTargetMng.highlightHide();
            accountId = InstanceMng.getUserInfoMng().getCurrentProfileLoaded().getAccountId();
            if(accountId == "npc_B")
            {
               this.mComplete = true;
            }
         }
         else if(InstanceMng.getPopupMng().getPopupBeingShown() is EPopupPlanetAction)
         {
            (params = new Dictionary())["elementName"] = "buttonVisit";
            MessageCenter.getInstance().sendMessage("putTutorialCircle",params);
         }
         else if(InstanceMng.getApplication().viewGetMode() == 1 && InstanceMng.getMapViewSolarSystem() && InstanceMng.getMapViewSolarSystem().isBuilt())
         {
            container = InstanceMng.getMapViewSolarSystem().getPlanetDisplayObject("npc_B",null,true);
            this.mTargetMng.highlightContainer(container);
         }
         else if(InstanceMng.getApplication().viewGetMode() == 0 && InstanceMng.getMapView() != null && InstanceMng.getMapView().isBuilt())
         {
            (params = new Dictionary())["elementName"] = "button_solar_system";
            MessageCenter.getInstance().sendMessage("putTutorialCircle",params);
         }
      }
   }
}
