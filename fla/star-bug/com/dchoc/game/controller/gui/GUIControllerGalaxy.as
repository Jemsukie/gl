package com.dchoc.game.controller.gui
{
   import com.dchoc.game.core.instance.InstanceMng;
   import flash.events.MouseEvent;
   
   public class GUIControllerGalaxy extends GUIController
   {
       
      
      public function GUIControllerGalaxy()
      {
         super();
      }
      
      override public function onMouseUp(e:MouseEvent) : void
      {
         InstanceMng.getUIFacade().getMapViewGalaxy().onMouseUp(e);
      }
      
      override protected function guiGetViewSku() : String
      {
         return "viewsGalaxy";
      }
   }
}
