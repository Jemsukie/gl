package com.dchoc.game.controller.map
{
   import com.dchoc.game.view.dc.map.MapView;
   import com.dchoc.toolkit.core.component.DCComponentUI;
   
   public class MapController extends DCComponentUI
   {
       
      
      public var mMapView:MapView;
      
      public function MapController()
      {
         super();
      }
      
      public function hasScrollBegun() : Boolean
      {
         return false;
      }
      
      public function setMapView(value:MapView) : void
      {
         this.mMapView = value;
      }
   }
}
