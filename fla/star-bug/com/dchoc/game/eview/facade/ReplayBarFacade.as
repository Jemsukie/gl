package com.dchoc.game.eview.facade
{
   import com.dchoc.game.core.flow.messaging.INotifyReceiver;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.TubeCameraEffect;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.hud.EHudOptionsView;
   import com.dchoc.game.view.dc.gui.components.GUIBar;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import flash.utils.Dictionary;
   
   public class ReplayBarFacade extends GUIBar implements INotifyReceiver
   {
      
      private static const AREA_SCREEN:String = "area_screen";
      
      private static const IMG_BATTERY:String = "icon_battery";
      
      private static const IMG_REC:String = "icon_replay";
      
      private static const TEXT_REPLAY:String = "text_replay";
      
      private static const TEXT_SPEED:String = "text_speed";
      
      private static const TEXT_TIMER:String = "text_timer";
      
      private static const TEXT_SPECS:String = "text_specs";
      
      private static const SETTINGS:String = "preferences";
       
      
      private var mCanvas:ESpriteContainer;
      
      private var mViewFactory:ViewFactory;
      
      private var mLayoutAreaFactory:ELayoutAreaFactory;
      
      private var mScreenLayoutArea:ELayoutArea;
      
      private var mContentHolders:Dictionary;
      
      private var mTimerText:ETextField;
      
      private var mSpeedText:ETextField;
      
      private var mEffect:TubeCameraEffect;
      
      public function ReplayBarFacade()
      {
         super("replay_bar");
         this.mContentHolders = new Dictionary();
         this.mEffect = new TubeCameraEffect();
      }
      
      public function getName() : String
      {
         return "EReplayBar";
      }
      
      public function getTaskList() : Vector.<String>
      {
         return new <String>["replaySpeedChanged"];
      }
      
      public function onMessage(task:String, params:Dictionary) : void
      {
         var _loc3_:* = task;
         if("replaySpeedChanged" === _loc3_)
         {
            this.mSpeedText.setText("x" + params["newAmount"].toString());
         }
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildSyncTotalSteps = 4;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         var s:ESprite = null;
         var txt:ETextField = null;
         var i:int = 0;
         var optionsDropDown:EHudOptionsView = null;
         switch(step)
         {
            case 0:
               this.mViewFactory = InstanceMng.getViewFactory();
               this.mCanvas = this.mViewFactory.getESpriteContainer();
               this.mLayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory("LayoutHudTopReplay");
               buildAdvanceSyncStep();
               break;
            case 1:
               this.mScreenLayoutArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(this.mLayoutAreaFactory.getArea("area_screen"));
               s = this.mViewFactory.getEImage("screen_replay",null,false,this.mScreenLayoutArea,null);
               this.addHudElement("area_screen",s,this.mCanvas);
               s = this.mViewFactory.getEImage("skin_icon_battery",null,false,this.mLayoutAreaFactory.getArea("icon_battery"));
               this.addHudElement("icon_battery",s,this.mCanvas);
               s = this.mViewFactory.getEImage("skin_icon_rec",null,false,this.mLayoutAreaFactory.getArea("icon_replay"));
               this.addHudElement("icon_replay",s,this.mCanvas);
               buildAdvanceSyncStep();
               break;
            case 2:
               txt = this.mViewFactory.getETextField(null,this.mLayoutAreaFactory.getTextArea("text_replay"),null);
               txt.setText(DCTextMng.getText(636));
               this.addHudElement("text_replay",txt,this.mCanvas);
               txt = this.mViewFactory.getETextField(null,this.mLayoutAreaFactory.getTextArea("text_specs"),null);
               txt.setText(DCTextMng.getText("DSZ- LSZ X100"));
               this.addHudElement("text_specs",txt,this.mCanvas);
               this.mTimerText = this.mViewFactory.getETextField(null,this.mLayoutAreaFactory.getTextArea("text_timer"),null);
               this.mTimerText.setText("00:00:00");
               this.addHudElement("text_timer",this.mTimerText,this.mCanvas);
               this.mSpeedText = this.mViewFactory.getETextField(null,this.mLayoutAreaFactory.getTextArea("text_speed"),null);
               this.mSpeedText.setText("x1");
               this.addHudElement("text_speed",this.mSpeedText,this.mCanvas);
               buildAdvanceSyncStep();
               break;
            case 3:
               (optionsDropDown = new EHudOptionsView()).setLayoutArea(this.mLayoutAreaFactory.getArea("preferences"),true);
               optionsDropDown.name = "preferences";
               optionsDropDown.eAddEventListener("rollOver",uiEnable);
               optionsDropDown.eAddEventListener("rollOut",uiDisable);
               this.addHudElement("preferences",optionsDropDown,this.mCanvas);
               buildAdvanceSyncStep();
         }
      }
      
      private function addHudElement(id:String, s:ESprite, where:ESpriteContainer) : void
      {
         s.name = id;
         where.eAddChild(s);
         this.mContentHolders[id] = s;
      }
      
      override protected function beginDo() : void
      {
         InstanceMng.getViewMngGame().addESpriteToLayer(this.mCanvas,InstanceMng.getViewMngGame().getHudLayerSku(),2);
         this.mCanvas.visible = InstanceMng.getFlowState().getCurrentRoleId() == 7;
         if(this.mCanvas.visible)
         {
            InstanceMng.getUIFacade().addTubeEffectToScreen(this.mEffect);
            MessageCenter.getInstance().registerObject(this);
         }
      }
      
      override protected function unbuildDo() : void
      {
         var id:* = null;
         for(id in this.mContentHolders)
         {
            this.mContentHolders[id].destroy();
            delete this.mContentHolders[id];
         }
         this.mCanvas.destroy();
      }
      
      override protected function endDo() : void
      {
         MessageCenter.getInstance().unregisterObject(this);
         InstanceMng.getViewMngGame().removeESpriteFromLayer(this.mCanvas,InstanceMng.getViewMngGame().getHudLayerSku());
         if(this.mEffect.parent)
         {
            this.mEffect.parent.removeChild(this.mEffect);
         }
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var s:ESprite = null;
         super.logicUpdateDo(dt);
         for each(s in this.mContentHolders)
         {
            s.logicUpdate(dt);
         }
         if(!this.mEffect.parent)
         {
            return;
         }
         this.mEffect.x = -InstanceMng.getViewMngPlanet().getLayer("LayerCursorWorld").cameraX;
         this.mEffect.y = -InstanceMng.getViewMngPlanet().getLayer("LayerCursorWorld").cameraY;
         this.mEffect.update(dt);
      }
      
      private function getHudElement(id:String) : ESprite
      {
         return this.mContentHolders[id];
      }
      
      public function battleSetTimeLeft(timeLeftMS:int) : void
      {
         if(this.mTimerText)
         {
            this.mTimerText.setText(DCTextMng.convertTimeToStringColon(timeLeftMS));
         }
      }
      
      private function setupVisualElements(stageWidth:int, stageHeight:int) : void
      {
         var s:ESprite = null;
         var layoutArea:ELayoutArea = null;
         var originalLayoutArea:ELayoutArea = null;
         var element:String = null;
         s = this.getHudElement("area_screen");
         layoutArea = s.getLayoutArea();
         originalLayoutArea = this.mLayoutAreaFactory.getArea("area_screen");
         layoutArea.width = stageWidth + originalLayoutArea.width - 760;
         layoutArea.height = stageHeight + originalLayoutArea.height - 594;
         layoutArea.x = originalLayoutArea.x - (stageWidth - 760) / 2;
         s.setLayoutArea(layoutArea,true);
         this.mViewFactory.setTextureToImage("no_texture",null,s as EImage);
         this.mViewFactory.setTextureToImage("screen_replay",null,s as EImage);
         var elements:Array = ["icon_battery","text_timer"];
         for each(element in elements)
         {
            s = this.getHudElement(element);
            originalLayoutArea = this.mLayoutAreaFactory.getArea(element);
            s.logicLeft = originalLayoutArea.x - (stageWidth - 760) / 2;
         }
         elements = ["icon_replay","text_replay","text_specs","text_speed"];
         for each(element in elements)
         {
            s = this.getHudElement(element);
            originalLayoutArea = this.mLayoutAreaFactory.getArea(element);
            s.logicLeft = originalLayoutArea.x + (stageWidth - 760) / 2;
         }
         elements = ["text_timer","text_specs"];
         for each(element in elements)
         {
            s = this.getHudElement(element);
            originalLayoutArea = this.mLayoutAreaFactory.getArea(element);
            s.logicTop = originalLayoutArea.y + (stageHeight - 594);
         }
      }
      
      override public function onResize(stageWidth:int, stageHeight:int) : void
      {
         this.setupVisualElements(stageWidth,stageHeight);
         var s:ESprite = this.getHudElement("preferences");
         s.logicTop = stageHeight - s.getLogicHeight();
      }
   }
}
