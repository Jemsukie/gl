package com.dchoc.game.model.flow
{
   import com.dchoc.game.controller.gui.GUIControllerGalaxy;
   import com.dchoc.game.controller.map.MapControllerGalaxy;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.view.dc.map.MapViewGalaxy;
   import com.dchoc.game.view.dc.mng.ViewMngrGame;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import flash.events.KeyboardEvent;
   
   public class FlowStateGalaxy extends FlowState
   {
       
      
      private var mGUIControllerGalaxy:GUIControllerGalaxy;
      
      private var mMapControllerGalaxy:MapControllerGalaxy;
      
      public function FlowStateGalaxy()
      {
         super();
      }
      
      override protected function setup() : void
      {
         super.setup();
         mIsAutomaticBegin = false;
      }
      
      override protected function createGUIController() : void
      {
         super.createGUIController();
         var guiController:GUIControllerGalaxy = InstanceMng.getGUIControllerGalaxy();
         if(guiController == null)
         {
            this.mGUIControllerGalaxy = new GUIControllerGalaxy();
            InstanceMng.registerGUIControllerGalaxy(this.mGUIControllerGalaxy);
            childrenAddChild(this.mGUIControllerGalaxy);
            this.mGUIControllerGalaxy.setViewMng(ViewMngrGame(mViewMng));
         }
         else
         {
            InstanceMng.unregisterGUIControllerGalaxy();
            InstanceMng.registerGUIControllerGalaxy(this.mGUIControllerGalaxy);
            this.mGUIControllerGalaxy = guiController;
            this.mGUIControllerGalaxy.setViewMng(ViewMngrGame(mViewMng));
            childrenAddChild(this.mGUIControllerGalaxy);
         }
      }
      
      override protected function createMapController() : void
      {
         this.mMapControllerGalaxy = InstanceMng.getMapControllerGalaxy();
         if(this.mMapControllerGalaxy == null)
         {
            this.mMapControllerGalaxy = new MapControllerGalaxy();
            InstanceMng.registerMapControllerGalaxy(this.mMapControllerGalaxy);
         }
         childrenAddChild(this.mMapControllerGalaxy);
      }
      
      override protected function childrenCreate() : void
      {
         super.childrenCreate();
         var mapView:MapViewGalaxy = InstanceMng.getMapViewGalaxy();
         mapView.setViewMng(ViewMngrGame(mViewMng));
         childrenAddChild(mapView);
         mapView.setMapController(this.mMapControllerGalaxy);
         this.mMapControllerGalaxy.setMapView(mapView);
      }
      
      override protected function childrenUnbuildMode(mode:int) : void
      {
         InstanceMng.getMapController().unbuild(mode);
         super.childrenUnbuildMode(mode);
      }
      
      override public function onKeyDown(e:KeyboardEvent) : void
      {
         var coord:DCCoordinate = null;
         var x:int = 0;
         var y:int = 0;
         super.onKeyDown(e);
         coord = new DCCoordinate();
         coord.x = 123;
         coord.y = 256;
         switch(int(e.keyCode) - 112)
         {
            case 0:
               DCDebug.trace("Enabling TileEngine BG - Galaxy");
               InstanceMng.getMapViewGalaxy().setTileEngineEnabled(true);
               break;
            case 1:
               DCDebug.trace("Disabling TileEngine BG - Galaxy");
               InstanceMng.getMapViewGalaxy().setTileEngineEnabled(false);
               break;
            case 2:
               DCDebug.trace("Enabling Parallax BG - Galaxy");
               InstanceMng.getMapViewGalaxy().setParallaxEngineEnabled(true);
               break;
            case 3:
               coord.x = 10;
               coord.y = 23;
               InstanceMng.getMapViewGalaxy().centerCameraByStarCoords(coord);
         }
      }
   }
}
