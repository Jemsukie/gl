package com.dchoc.game.model.flow
{
   import com.dchoc.game.controller.gui.GUIControllerSolarSystem;
   import com.dchoc.game.controller.map.MapControllerSolarSystem;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.view.dc.mng.ViewMngrGame;
   import flash.events.KeyboardEvent;
   
   public class FlowStateSolarSystem extends FlowState
   {
       
      
      private var mGUIControllerSolarSystem:GUIControllerSolarSystem;
      
      private var mMapControllerSolarSystem:MapControllerSolarSystem;
      
      public function FlowStateSolarSystem()
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
         var guiController:GUIControllerSolarSystem = InstanceMng.getGUIControllerSolarSystem();
         if(guiController == null)
         {
            this.mGUIControllerSolarSystem = new GUIControllerSolarSystem();
            InstanceMng.registerGUIControllerSolarSystem(this.mGUIControllerSolarSystem);
            childrenAddChild(this.mGUIControllerSolarSystem);
            this.mGUIControllerSolarSystem.setViewMng(ViewMngrGame(mViewMng));
         }
         else
         {
            InstanceMng.unregisterGUIControllerSolarSystem();
            InstanceMng.registerGUIControllerSolarSystem(this.mGUIControllerSolarSystem);
            this.mGUIControllerSolarSystem = guiController;
            this.mGUIControllerSolarSystem.setViewMng(ViewMngrGame(mViewMng));
            childrenAddChild(this.mGUIControllerSolarSystem);
         }
      }
      
      override protected function createMapController() : void
      {
         this.mMapControllerSolarSystem = InstanceMng.getMapControllerSolarSystem();
         if(this.mMapControllerSolarSystem == null)
         {
            this.mMapControllerSolarSystem = new MapControllerSolarSystem();
            InstanceMng.registerMapControllerSolarSystem(this.mMapControllerSolarSystem);
         }
         childrenAddChild(this.mMapControllerSolarSystem);
      }
      
      override protected function childrenUnbuildMode(mode:int) : void
      {
         InstanceMng.getMapController().unbuild(mode);
         super.childrenUnbuildMode(mode);
      }
      
      override public function onKeyDown(e:KeyboardEvent) : void
      {
         super.onKeyDown(e);
         switch(int(e.keyCode) - 113)
         {
            case 0:
               InstanceMng.getMapViewSolarSystem().performAsteroidFX();
         }
      }
   }
}
