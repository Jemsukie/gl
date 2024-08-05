package com.dchoc.game.view.dc.gui.components
{
   import com.dchoc.game.controller.gui.GUIController;
   import com.dchoc.game.controller.map.MapController;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.view.dc.mng.ViewMngrGame;
   import com.dchoc.toolkit.view.gui.popups.DCPopup;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   
   public class GUIComponent extends DCPopup
   {
      
      public static const UPDATE_SECONDS:Number = 0.5;
       
      
      protected var mAssetName:String;
      
      private var mRelativeToTop:Boolean;
      
      private var mRx:Number;
      
      private var mRy:Number;
      
      protected var mInitialStageWidth:Number;
      
      protected var mInitialStageHeight:Number;
      
      protected var mViewMngLayerPos:int;
      
      public function GUIComponent(assetName:String, box:DisplayObjectContainer = null, viewMngLayerPos:int = -1)
      {
         super(box);
         if(box == null)
         {
            mBox = new Sprite();
         }
         this.mInitialStageWidth = InstanceMng.getApplication().stageGetWidth();
         this.mInitialStageHeight = InstanceMng.getApplication().stageGetHeight();
         this.mAssetName = assetName;
         this.mViewMngLayerPos = viewMngLayerPos;
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildAsyncTotalSteps = 0;
         mBuildSyncTotalSteps = 1;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         if(step == 0 && InstanceMng.getResourceMng().isGUIResourcesLoaded())
         {
            buildAdvanceSyncStep();
         }
      }
      
      override protected function beginDo() : void
      {
         this.paint();
         super.beginDo();
      }
      
      override protected function endDo() : void
      {
         this.unpaint();
      }
      
      public function setAnchorPixelsForResize(rx:Number, ry:Number, relativeToTop:Boolean = false) : void
      {
         this.mRx = rx;
         this.mRy = ry;
         this.mRelativeToTop = relativeToTop;
      }
      
      public function moveDisappearUpToDown(numSeconds:Number = 0.5) : void
      {
         uiDisable();
      }
      
      public function moveAppearDownToUp(numSeconds:Number = 0.5) : void
      {
         uiDisable();
      }
      
      public function moveDisappearDownToUp(numSeconds:Number = 0.5) : void
      {
         uiDisable();
      }
      
      public function moveAppearUpToDown(numSeconds:Number = 0.5, gainFocusOnEnd:int = -1) : void
      {
         uiDisable();
      }
      
      public function setVisible(b:Boolean) : void
      {
         setIsBeingShown(b);
      }
      
      public function isVisible() : Boolean
      {
         return isPopupBeingShown();
      }
      
      private function paint() : void
      {
         var viewMngrGameRef:ViewMngrGame = null;
         viewMngrGameRef = InstanceMng.getViewMngGame();
         if(this.isVisible() && !viewMngrGameRef.contains(mBox))
         {
            show(false);
            viewMngrGameRef.addHud(mBox);
         }
      }
      
      private function unpaint() : void
      {
         var viewMngrGameRef:ViewMngrGame = null;
         viewMngrGameRef = InstanceMng.getViewMngGame();
         if(viewMngrGameRef.contains(mBox))
         {
            close();
            viewMngrGameRef.removeHud(mBox);
         }
      }
      
      public function performHitTestPoint(x:Number, y:Number) : Boolean
      {
         return getForm().hitTestPoint(x,y,true);
      }
      
      override protected function uiDisableErr() : void
      {
         this.uiDisableDo();
      }
      
      protected function uiEnableDoDo() : void
      {
      }
      
      protected function uiDisableDoDo() : void
      {
      }
      
      override protected function uiDisableDo(forceRemoveListeners:Boolean = false) : void
      {
         this.uiDisableDoDo();
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),{"cmd":"NOTIFY_LOSEFOCUS"},true);
         super.uiDisableDo(forceRemoveListeners);
      }
      
      override protected function uiEnableDo(forceAddListeners:Boolean = false) : void
      {
         var o:Object = null;
         var guiController:GUIController = InstanceMng.getGUIController();
         guiController.setMouseOverChildSku(mParentRef);
         var mapController:MapController;
         if((mapController = InstanceMng.getMapController()) != null && !mapController.hasScrollBegun())
         {
            this.uiEnableDoDo();
            o = InstanceMng.getGUIController().createNotifyEvent(null,"NOTIFY_CHANGEFOCUS");
            o.parentIdx = mParentRef;
            InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o,true);
            super.uiEnableDo();
         }
         else
         {
            mUiEnabled = false;
         }
      }
      
      override public function onResize(stageWidth:int, stageHeight:int) : void
      {
         mBox.x = (stageWidth - this.mInitialStageWidth) * 0.5 + this.mRx;
         if(!this.mRelativeToTop)
         {
            mBox.y = stageHeight - this.mInitialStageHeight + this.mRy;
         }
         else
         {
            mBox.y = this.mRy;
         }
      }
      
      override public function resize() : void
      {
         var width:Number = InstanceMng.getApplication().stageGetWidth();
         var height:Number = InstanceMng.getApplication().stageGetHeight();
         this.onResize(width,height);
      }
      
      override public function notify(e:Object) : Boolean
      {
         if(e.cmd == "NOTIFY_EFFECT_END")
         {
            InstanceMng.getGUIController().performFocusTest();
         }
         return true;
      }
   }
}
