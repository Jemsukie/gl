package com.dchoc.game.model.world.target.action
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.popups.upgrade.EPopupUpgrade;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.action.DCAction;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   import flash.display.DisplayObjectContainer;
   
   public class ActionShowCircleInButtonInstantOps extends DCAction
   {
       
      
      public function ActionShowCircleInButtonInstantOps()
      {
         super();
      }
      
      override public function execute(target:DCTarget, isPreaction:Boolean) : Boolean
      {
         var container:DisplayObjectContainer = null;
         var halfw:* = 0;
         var halfh:* = 0;
         var offsetX:int = 0;
         var offsetY:int = 0;
         var offsetW:int = 0;
         var offsetH:int = 0;
         var doShow:* = true;
         if((InstanceMng.getMapView() != null && InstanceMng.getMapView().isBuilt()) == false)
         {
            return false;
         }
         var popup:DCIPopup;
         if((popup = InstanceMng.getPopupMng().getPopupBeingShown()) == null)
         {
            return false;
         }
         if(popup.getPopupType() != "PopupUpgradeBuildings")
         {
            return false;
         }
         container = EPopupUpgrade(popup).getInstantBuildButton();
         if(doShow = container != null)
         {
            halfw = container.width >> 1;
            halfh = container.height >> 1;
            offsetX = halfw;
            offsetY = halfh;
            offsetW = halfw;
            offsetH = halfh;
            InstanceMng.getViewMngPlanet().addHighlightFromContainer(container,true,offsetX,offsetY,offsetW,offsetH);
         }
         return true;
      }
   }
}
