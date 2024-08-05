package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.items.ItemObject;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import flash.utils.setTimeout;
   
   public class ActionStartInvestsIntro extends DCAction
   {
       
      
      public function ActionStartInvestsIntro()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         var key:ItemObject = null;
         if(Config.useInvests())
         {
            InstanceMng.getMissionsMng().hideTemporarilyMissionsInHud();
            InstanceMng.getMapViewPlanet().setInvestBuildingAnimationRunning(true);
            key = InstanceMng.getItemsMng().getItemObjectBySku("1000");
            InstanceMng.getItemsMng().removeItemFromInventory(key,false);
            InstanceMng.getGUIController().lockGUI();
            InstanceMng.getMissionsMng().enableMissionDrop(false);
            setTimeout(this.onTimeOutOver,2000);
         }
         return true;
      }
      
      private function onTimeOutOver() : void
      {
         InstanceMng.getGUIController().lockGUI();
         var pos:DCCoordinate = InstanceMng.getMapViewPlanet().investsBuildingGetPosition();
         if(pos != null)
         {
            InstanceMng.getMapControllerPlanet().moveCameraTo(pos.x,pos.y,3);
         }
         InstanceMng.getMapViewPlanet().investsBuildingPlayConstructionAnim();
      }
   }
}
