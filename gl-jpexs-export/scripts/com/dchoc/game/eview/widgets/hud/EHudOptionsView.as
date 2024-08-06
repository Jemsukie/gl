package com.dchoc.game.eview.widgets.hud
{
   import com.dchoc.game.core.flow.messaging.INotifyReceiver;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EDropDownButton;
   import com.dchoc.game.eview.widgets.EDropDownSprite;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipInfo;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.toolkit.view.conf.DCGUIDef;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import flash.utils.Dictionary;
   
   public class EHudOptionsView extends EDropDownButton implements INotifyReceiver
   {
      
      public static const SETTINGS_FULL_SCREEN:String = "button_full_screen";
      
      public static const SETTINGS_FULL_SCREEN_OFF:String = "button_full_screen_cancel";
      
      public static const SETTINGS_FLATBED_VIEW:String = "button_flatbed_view";
      
      public static const SETTINGS_ZOOM_IN:String = "button_zoom_in";
      
      public static const SETTINGS_ZOOM_OUT:String = "button_zoom_out";
      
      public static const SETTINGS_QUALITY:String = "button_quality";
      
      public static const SETTINGS_QUALITY_OFF:String = "button_quality_cancel";
      
      public static const SETTINGS_MUSIC:String = "button_music";
      
      public static const SETTINGS_SOUND:String = "button_volume";
      
      public static const SETTINGS_MUSIC_OFF:String = "button_music_cancel";
      
      public static const SETTINGS_SOUND_OFF:String = "button_volume_cancel";
      
      public static const SETTINGS_EXPAND:String = "button_expand";
       
      
      private var mViewFactory:ViewFactory;
      
      private var mBtnMLayoutArea:ELayoutArea;
      
      private var mLayoutAreaFactory:ELayoutAreaFactory;
      
      public function EHudOptionsView()
      {
         this.mViewFactory = InstanceMng.getViewFactory();
         this.mBtnMLayoutArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(this.mViewFactory.getLayoutAreaFactory("BtnImgM").getArea("base"));
         this.mBtnMLayoutArea.isSetPositionEnabled = false;
         this.mLayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory(InstanceMng.getUIFacade().getHudBottomLayoutName());
         var buttonsSpriteContainer:ESpriteContainer = this.createContent();
         var button:EButton = this.createButton();
         var dropdown:EDropDownSprite = this.createDropDown(buttonsSpriteContainer);
         dropdown.setCloseTimeMs(0);
         super(button,dropdown);
         MessageCenter.getInstance().registerObject(this);
      }
      
      override protected function extendedDestroy() : void
      {
         MessageCenter.getInstance().unregisterObject(this);
         ETooltipMng.getInstance().destroyTooltipFromContainer(getContent("button_full_screen"));
         ETooltipMng.getInstance().destroyTooltipFromContainer(getContent("button_full_screen_cancel"));
         ETooltipMng.getInstance().destroyTooltipFromContainer(getContent("button_zoom_in"));
         ETooltipMng.getInstance().destroyTooltipFromContainer(getContent("button_zoom_out"));
         ETooltipMng.getInstance().destroyTooltipFromContainer(getContent("button_quality"));
         ETooltipMng.getInstance().destroyTooltipFromContainer(getContent("button_quality_cancel"));
         ETooltipMng.getInstance().destroyTooltipFromContainer(getContent("button_music"));
         ETooltipMng.getInstance().destroyTooltipFromContainer(getContent("button_music_cancel"));
         ETooltipMng.getInstance().destroyTooltipFromContainer(getContent("button_volume"));
         ETooltipMng.getInstance().destroyTooltipFromContainer(getContent("button_volume_cancel"));
         ETooltipMng.getInstance().destroyTooltipFromContainer(getContent("button_expand"));
         super.extendedDestroy();
      }
      
      public function getName() : String
      {
         return "ESettings";
      }
      
      public function getTaskList() : Vector.<String>
      {
         return new <String>["soundSetting","musicSetting","cameraMaxZoomIn","cameraMaxZoomOut","cameraMaxZoomOut","qualitySetting","fullscreenSetting","optionsExpand"];
      }
      
      public function onMessage(task:String, params:Dictionary) : void
      {
         switch(task)
         {
            case "musicSetting":
               getContent("button_music").visible = params["value"] === true;
               getContent("button_music_cancel").visible = params["value"] === false;
               break;
            case "soundSetting":
               getContent("button_volume").visible = params["value"] === true;
               getContent("button_volume_cancel").visible = params["value"] === false;
               break;
            case "qualitySetting":
               getContent("button_quality").visible = params["value"] == "high";
               getContent("button_quality_cancel").visible = params["value"] != "high";
               break;
            case "fullscreenSetting":
               getContent("button_full_screen").visible = params["value"] === true;
               getContent("button_full_screen_cancel").visible = params["value"] === false;
               break;
            case "cameraMaxZoomOut":
               getContent("button_zoom_in").visible = true;
               getContent("button_zoom_out").visible = true;
               break;
            case "cameraMaxZoomIn":
               getContent("button_zoom_in").visible = false;
               break;
            case "cameraMaxZoomOut":
               getContent("button_zoom_out").visible = false;
         }
      }
      
      final private function createContent() : ESpriteContainer
      {
         var s:EButton = null;
         var content:ESpriteContainer = this.mViewFactory.getESpriteContainer();
         var buttons:Array = [];
         s = this.mViewFactory.getButtonIcon("btn_hud","skin_icon_fullscreen",null,this.mBtnMLayoutArea);
         s.name = "button_full_screen";
         this.addCallbacks(s);
         s.visible = InstanceMng.getApplication().stageGetStage().getDisplayState() != "normal";
         buttons.push(s);
         content.eAddChild(s);
         this.setContent(s.name,s);
         s = this.mViewFactory.getButtonIcon("btn_hud","skin_icon_zoom_out",null,this.mBtnMLayoutArea);
         s.name = "button_zoom_out";
         this.addCallbacks(s);
         buttons.push(s);
         content.eAddChild(s);
         this.setContent(s.name,s);
         s = this.mViewFactory.getButtonIcon("btn_hud","skin_icon_quality",null,this.mBtnMLayoutArea);
         s.name = "button_quality";
         this.addCallbacks(s);
         s.visible = InstanceMng.getUserInfoMng().getProfileLogin() && InstanceMng.getUserInfoMng().getProfileLogin().getBoolQuality();
         buttons.push(s);
         content.eAddChild(s);
         this.setContent(s.name,s);
         s = this.mViewFactory.getButtonIcon("btn_hud","skin_icon_sound",null,this.mBtnMLayoutArea);
         s.name = "button_volume";
         this.addCallbacks(s);
         s.visible = InstanceMng.getUserInfoMng().getProfileLogin() && InstanceMng.getUserInfoMng().getProfileLogin().getSound();
         buttons.push(s);
         content.eAddChild(s);
         this.setContent(s.name,s);
         s = this.mViewFactory.getButtonIcon("btn_hud","skin_icon_music",null,this.mBtnMLayoutArea);
         s.name = "button_music";
         this.addCallbacks(s);
         s.visible = InstanceMng.getUserInfoMng().getProfileLogin() && InstanceMng.getUserInfoMng().getProfileLogin().getMusic();
         buttons.push(s);
         content.eAddChild(s);
         this.setContent(s.name,s);
         s = this.mViewFactory.getButtonIcon("btn_hud","skin_icon_wrench",null,this.mBtnMLayoutArea);
         s.name = "button_expand";
         this.addCallbacks(s);
         buttons.push(s);
         content.eAddChild(s);
         this.setContent(s.name,s);
         content.setLayoutArea(this.mViewFactory.createMinimumLayoutArea(buttons,0,1),true);
         this.mViewFactory.distributeSpritesInArea(content.getLayoutArea(),buttons,0,1);
         s = this.mViewFactory.getButtonIcon("btn_hud_cancel","skin_icon_sound",null,this.mBtnMLayoutArea,"HUE_red");
         s.name = "button_volume_cancel";
         this.addCallbacks(s);
         s.visible = !getContent("button_volume").visible;
         s.logicLeft = this.getContent("button_volume").logicLeft;
         s.logicTop = this.getContent("button_volume").logicTop;
         content.eAddChild(s);
         this.setContent(s.name,s);
         s = this.mViewFactory.getButtonIcon("btn_hud_cancel","skin_icon_music",null,this.mBtnMLayoutArea,"HUE_red");
         s.name = "button_music_cancel";
         this.addCallbacks(s);
         s.visible = !getContent("button_music").visible;
         s.logicLeft = this.getContent("button_music").logicLeft;
         s.logicTop = this.getContent("button_music").logicTop;
         content.eAddChild(s);
         this.setContent(s.name,s);
         s = this.mViewFactory.getButtonIcon("btn_hud_cancel","skin_icon_quality",null,this.mBtnMLayoutArea,"HUE_red");
         s.name = "button_quality_cancel";
         this.addCallbacks(s);
         s.visible = !getContent("button_quality").visible;
         s.logicLeft = this.getContent("button_quality").logicLeft;
         s.logicTop = this.getContent("button_quality").logicTop;
         content.eAddChild(s);
         this.setContent(s.name,s);
         s = this.mViewFactory.getButtonIcon("btn_hud","skin_icon_zoom_in",null,this.mBtnMLayoutArea);
         s.name = "button_zoom_in";
         this.addCallbacks(s);
         s.logicLeft = this.getContent("button_zoom_out").logicLeft;
         s.logicTop = this.getContent("button_zoom_out").logicTop;
         s.visible = false;
         content.eAddChild(s);
         this.setContent(s.name,s);
         s = this.mViewFactory.getButtonIcon("btn_hud","skin_icon_screen",null,this.mBtnMLayoutArea);
         s.name = "button_full_screen_cancel";
         this.addCallbacks(s);
         s.visible = !getContent("button_full_screen").visible;
         s.logicLeft = this.getContent("button_full_screen").logicLeft;
         s.logicTop = this.getContent("button_full_screen").logicTop;
         content.eAddChild(s);
         this.setContent(s.name,s);
         return content;
      }
      
      final private function createButton() : EButton
      {
         return InstanceMng.getViewFactory().getButtonIcon("options_label_bkg_right","skin_icon_settings",null,InstanceMng.getViewFactory().getLayoutAreaFactory("OptionsDropDownHud").getArea("button_options"));
      }
      
      final private function createDropDown(buttonsSpriteContainer:ESpriteContainer) : EDropDownSprite
      {
         var dd:EOptionsDropDown = new EOptionsDropDown();
         dd.buildAll(buttonsSpriteContainer);
         return dd;
      }
      
      private function onSettingsHudClick(evt:EEvent) : void
      {
         var params:Dictionary = new Dictionary();
         params["name"] = evt.getTarget().name;
         MessageCenter.getInstance().sendMessage("hudSettingButtonClicked",params);
      }
      
      public function addCallbacks(s:ESprite) : void
      {
         var tooltipText:String = null;
         var tooltipInfo:ETooltipInfo = null;
         s.eAddEventListener("click",this.onSettingsHudClick);
         var guiDef:DCGUIDef;
         if(guiDef = InstanceMng.getGUIDefMng().getDefBySku(s.name) as DCGUIDef)
         {
            tooltipText = guiDef.getTooltipTitleToDisplay();
            tooltipInfo = ETooltipMng.getInstance().createTooltipInfoFromText(tooltipText,s,null,true,false);
         }
      }
   }
}

import com.dchoc.game.core.instance.InstanceMng;
import com.dchoc.game.eview.ViewFactory;
import com.dchoc.game.eview.widgets.hud.EArrowDropDownSprite;
import com.gskinner.motion.GTween;
import esparragon.display.ESpriteContainer;
import esparragon.layout.ELayoutArea;
import esparragon.layout.ELayoutAreaFactory;

class EOptionsDropDown extends EArrowDropDownSprite
{
   
   private static const AREA_OPTIONS_CONTENT:String = "area_preferences";
   
   private static const AREA_BKG:String = "area_preferences_BKG";
   
   private static const AREA_TAB:String = "corner_left";
   
   private static const AREA_ARROW:String = "btn_plus_preferences";
    
   
   private var mOrigXForScale:int = 0;
   
   public function EOptionsDropDown()
   {
      super(2);
   }
   
   public function buildAll(buttonsSpriteContainer:ESpriteContainer) : void
   {
      var skinSku:String = null;
      var iconsBkgLayout:ELayoutArea = null;
      var iconsBkgInitialWidth:int = 0;
      skinSku = InstanceMng.getSkinsMng().getCurrentSkinSku();
      var viewFactory:ViewFactory;
      var layout:ELayoutAreaFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("OptionsDropDownHud");
      iconsBkgInitialWidth = (iconsBkgLayout = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layout.getArea("area_preferences"))).width;
      iconsBkgLayout.width += buttonsSpriteContainer.getLogicWidth() * iconsBkgLayout.height / buttonsSpriteContainer.getLogicHeight();
      mIconsArea = viewFactory.getEImage("options_label_bkg",skinSku,false,iconsBkgLayout,null);
      mIconsContentArea = viewFactory.getESpriteContainer();
      mIconsContentArea.setLayoutArea(iconsBkgLayout,true);
      mTabLayoutArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layout.getArea("corner_left"));
      mTabArea = viewFactory.getEImage("options_label_bkg_left",skinSku,false,mTabLayoutArea,null);
      mTabArea.name = "tabArea";
      var area:ELayoutArea = layout.getArea("btn_plus_preferences");
      mArrowLayoutArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(area);
      mArrowLayoutArea.x = mTabLayoutArea.x + mTabLayoutArea.width / 2;
      mArrowLayoutArea.y = mTabLayoutArea.y + mTabLayoutArea.height / 2;
      mArrow = viewFactory.getEImage("skin_icon_arrow",skinSku,false,mArrowLayoutArea,null);
      mArrow.setPivotLogicXY(0.5,0.5);
      mArrow.eAddEventListener("click",onArrowClick);
      mArrowCloseRotation = mArrowLayoutArea.rotation;
      mArrowOpenRotation = mArrowCloseRotation + 180;
      mArrow.eAddEventBehavior("rollOver",InstanceMng.getBehaviorsMng().getMouseBehavior("MouseOverButton"));
      mArrow.eAddEventBehavior("rollOut",InstanceMng.getBehaviorsMng().getMouseBehavior("MouseOutButton"));
      this.eAddChild(mIconsArea);
      this.eAddChild(mIconsContentArea);
      this.eAddChild(mTabArea);
      this.eAddChild(mArrow);
      setContent("area_preferences_BKG",mIconsArea);
      setContent("area_preferences",mIconsContentArea);
      setContent("corner_left",mTabArea);
      setContent("btn_plus_preferences",mArrow);
      setContentArea(mIconsContentArea.getLayoutArea());
      addContent(buttonsSpriteContainer);
      updateContent();
      this.mOrigXForScale = mIconsArea.logicLeft + iconsBkgInitialWidth;
      var xDiff:Number = iconsBkgInitialWidth - mIconsArea.getLogicWidth();
      mIconsArea.logicLeft += xDiff;
      mIconsContentArea.logicLeft += xDiff;
      setTabAreaX(mTabArea.logicLeft + xDiff);
      setArrowX(mArrow.logicLeft + xDiff);
   }
   
   override protected function onUpdateTween(tween:GTween) : void
   {
      mIconsContentArea.scaleLogicX = mIconsArea.scaleLogicX;
      mIconsArea.logicLeft = this.mOrigXForScale - mIconsArea.getLogicWidth();
      mIconsContentArea.logicLeft = mIconsArea.logicLeft + (mIconsArea.getLogicWidth() - mIconsContentArea.getLogicWidth()) / 2;
      var lastX:Number = Number(mTabArea.logicLeft);
      setTabAreaX(mIconsArea.logicLeft - mTabArea.getLogicWidth());
      setArrowX(mArrow.logicLeft + mTabArea.logicLeft - lastX);
   }
}
