package com.dchoc.game.eview.widgets.selectioncircle
{
   import com.dchoc.game.controller.map.MapControllerPlanet;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import esparragon.display.ESpriteContainer;
   
   public class ESelectionCircleMng extends DCComponent
   {
      
      public static const WALL_SELECT_PANE:String = "wall_select";
      
      public static const WALL_SELECT_AND_UPGRADE:String = "wall_select_upgrade";
      
      public static const SMALL_BTN:String = "small";
      
      private static const OFFSET_X:int = 23;
      
      private static const OFFSET_Y:int = 90;
      
      private static const UPGRADE_BTN_SKU:String = "upgrade";
      
      private static const CONFIRM_BTN_SKU:String = "confirm";
      
      private static var isSelectionPaneActive:Boolean = false;
      
      private static var pane:ESpriteContainer;
       
      
      public function ESelectionCircleMng()
      {
         super();
         pane = new ESpriteContainer();
      }
      
      private function createConfirmCircle(pos:DCCoordinate) : ESelectionCircle
      {
         var ConfirmCircle:ESelectionCircle = new ESelectionCircle();
         ConfirmCircle.confirmButton(pos);
         return ConfirmCircle;
      }
      
      private function createUpdateCircle(pos:DCCoordinate) : ESelectionCircle
      {
         var updateCircle:ESelectionCircle = new ESelectionCircle();
         updateCircle.updateButton(pos);
         return updateCircle;
      }
      
      public function createPane(item:WorldItemObject, items:Vector.<WorldItemObject>, paneType:String) : void
      {
         switch(paneType)
         {
            case "wall_select":
               this.createWallSelectPane(item);
               break;
            case "wall_select_upgrade":
               this.createSelectAndUpgradePane(item);
         }
      }
      
      private function createSelectAndUpgradePane(item:WorldItemObject) : void
      {
         var position:DCCoordinate = null;
         var mapController:MapControllerPlanet = InstanceMng.getMapControllerPlanet();
         pane.x = item.mViewCenterWorldX - 23;
         pane.y = item.mViewCenterWorldY - 90;
         mapController.mMapView.mViewMng.addChildToLayer(pane,"LayerShips");
         isSelectionPaneActive = true;
         var confirmBtnPos:DCCoordinate = new DCCoordinate();
         confirmBtnPos.x -= 35;
         var confirmCircle:ESelectionCircle = this.createConfirmCircle(confirmBtnPos);
         var updateBtnPos:DCCoordinate = new DCCoordinate();
         updateBtnPos.x += 35;
         var updateCircle:ESelectionCircle = this.createUpdateCircle(updateBtnPos);
         pane.addChild(updateCircle);
         pane.setContent("upgrade",updateCircle);
         pane.addChild(confirmCircle);
         pane.setContent("confirm",confirmCircle);
      }
      
      private function createWallSelectPane(item:WorldItemObject) : void
      {
         var position:DCCoordinate = null;
         var mapController:MapControllerPlanet = InstanceMng.getMapControllerPlanet();
         pane.x = item.mViewCenterWorldX - 23;
         pane.y = item.mViewCenterWorldY - 90;
         mapController.mMapView.mViewMng.addChildToLayer(pane,"LayerShips");
         isSelectionPaneActive = true;
         var confirmBtnPos:DCCoordinate = new DCCoordinate();
         var confirmCircle:ESelectionCircle = this.createConfirmCircle(confirmBtnPos);
         pane.addChild(confirmCircle);
         pane.setContent("confirm",confirmCircle);
      }
      
      public function isPaneActive() : Boolean
      {
         return isSelectionPaneActive;
      }
      
      public function destroyPane() : void
      {
         pane.destroy();
         isSelectionPaneActive = false;
      }
   }
}
