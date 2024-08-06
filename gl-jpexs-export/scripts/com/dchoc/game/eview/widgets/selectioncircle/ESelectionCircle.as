package com.dchoc.game.eview.widgets.selectioncircle
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import esparragon.display.EImage;
   import esparragon.display.ESpriteContainer;
   import esparragon.events.EEvent;
   import esparragon.widgets.EButton;
   
   public class ESelectionCircle extends ESpriteContainer
   {
      
      public static const CONFIRM:String = "confirm";
      
      public static const UPGRADE:String = "upgrade_icon";
       
      
      private var btn1:EButton;
      
      private var btn2:EButton;
      
      private var image:EImage;
      
      private var mViewFactory:ViewFactory;
      
      private var skinSku:String;
      
      public function ESelectionCircle()
      {
         super();
         this.skinSku = InstanceMng.getSkinsMng().getCurrentSkinSku();
         this.mViewFactory = InstanceMng.getViewFactory();
      }
      
      public function confirmButton(pos:DCCoordinate) : void
      {
         this.btn1 = this.mViewFactory.getButtonIcon("btn_hud","confirm",this.skinSku);
         this.btn1.x = pos.x;
         this.btn1.y = pos.y;
         this.btn1.eAddEventListener("mouseDown",this.confirmAction);
         this.addChild(this.btn1);
      }
      
      public function updateButton(pos:DCCoordinate) : void
      {
         this.btn2 = this.mViewFactory.getButtonIcon("btn_hud","upgrade_icon",this.skinSku);
         this.btn2.x = pos.x;
         this.btn2.y = pos.y;
         this.btn2.eAddEventListener("mouseDown",this.updateAction);
         this.addChild(this.btn2);
      }
      
      public function confirmAction(evt:EEvent) : void
      {
         InstanceMng.getToolsMng().getCurrentTool().mIsSelectionDone = true;
         InstanceMng.getSelectionCircleMng().destroyPane();
      }
      
      public function updateAction(evt:EEvent) : void
      {
         var e:Object = {};
         e.item = InstanceMng.getToolsMng().getCurrentTool().getLowestLevelWalls()[0];
         e.items = InstanceMng.getToolsMng().getCurrentTool().getLowestLevelWalls();
         e.cmd = "WIOEventUpgradeStart";
         e.sendResponseTo = InstanceMng.getWorldItemObjectController();
         e.phase = "";
         e.type = 1;
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),e,true);
         InstanceMng.getToolsMng().getCurrentTool().destroySelection();
         InstanceMng.getGUIControllerPlanet().getToolBar().toolChange("button_cursor");
         InstanceMng.getSelectionCircleMng().destroyPane();
      }
      
      public function destroyCircle() : void
      {
         this.btn1.destroy();
         this.btn2.destroy();
      }
   }
}
