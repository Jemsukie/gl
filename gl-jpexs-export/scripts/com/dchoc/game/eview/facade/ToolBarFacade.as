package com.dchoc.game.eview.facade
{
   import com.dchoc.game.controller.alliances.AlliancesController;
   import com.dchoc.game.controller.alliances.AlliancesControllerStar;
   import com.dchoc.game.controller.tools.ToolSpy;
   import com.dchoc.game.controller.tools.ToolsMng;
   import com.dchoc.game.core.flow.messaging.INotifyReceiver;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EDropDownButton;
   import com.dchoc.game.eview.widgets.hud.EHudOptionsView;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipInfo;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.game.model.space.Planet;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.view.dc.gui.components.GUIComponent;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.view.conf.DCGUIDef;
   import com.gskinner.motion.GTween;
   import esparragon.display.EAbstractSprite;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import flash.utils.Dictionary;
   
   public class ToolBarFacade extends GUIComponent implements INotifyReceiver
   {
      
      public static const BUTTON_ATTACK_DROPDOWN:String = "button_attack_dropdown";
      
      public static const ATTACK_DROPDOWN:String = "button_target_spotter";
      
      public static const SPY:String = "button_spy";
      
      public static const INVENTORY:String = "button_inventory";
      
      public static const STRATEGIC_VIEW:String = "button_strategic_view";
      
      public static const INVENTORY_NOTIFICATION:String = "notification_area_inventory";
      
      public static const UPGRADE:String = "button_upgrade";
      
      public static const UPGRADE_CANCEL:String = "button_upgrade_cancel";
      
      public static const TOOLS:String = "button_multi_tool";
      
      public static const SETTINGS:String = "preferences";
      
      public static const TOOLS_USED:String = "tools";
      
      public static const TOOLS_CANCEL:String = "tools_cancel";
      
      public static const ALLIANCES:String = "button_alliances";
      
      public static const ALLIANCES_NOTIFICATION:String = "notification_area";
      
      public static const BETTING:String = "cbox_betting";
      
      public static const QUICK_ATTACK:String = "quick_attack";
      
      public static const DIRECT_ATTACK:String = "direct_attack";
      
      public static const BUILD:String = "button_shop";
      
      public static const PREMIUM_SHOP:String = "button_premium_shop";
      
      public static const PREMIUM_SHOP_NOTIFICATION:String = "notification_area_shop";
      
      public static const TOOL_RECYCLE:String = "button_recycle";
      
      public static const TOOL_MOVE:String = "button_move";
      
      public static const TOOL_MOVE_FOR_BUFFER:String = "button_move_buffer";
      
      public static const TOOL_ROTATE:String = "button_flip";
      
      public static const TOOL_SELECT:String = "button_cursor";
      
      public static const TOOL_GROUP_SELECT:String = "button_group";
      
      public static const TOOL_BUILDING_BUFFER:String = "button_bb";
      
      public static const BUTTON_MULTITOOL_PLANET:String = "button_colonies";
      
      public static const HUD_PRIMARY_BUTTONS_GROUP:Array = ["button_target_spotter","button_spy","button_inventory","button_upgrade","button_multi_tool","preferences","button_alliances","button_shop","button_premium_shop"];
      
      private static const TOOL_BAR_PIVOT_LOGIC_Y_BOTTOM:Number = 1.1;
       
      
      private var mCanvasBottom:ESpriteContainer;
      
      private var mContentHolders:Dictionary;
      
      private var mLayoutAreaFactory:ELayoutAreaFactory;
      
      private var mViewFactory:ViewFactory;
      
      private var mInventoryNotifications:int;
      
      private var mShopNotifications:int;
      
      private var mAlliancesNotifications:int;
      
      private var mQuickAttackIconTextField:ESpriteContainer;
      
      private var mAttackIconTextField:ESpriteContainer;
      
      private var mBtnMLayoutArea:ELayoutArea;
      
      private var mDropDownsRepositioned:Boolean;
      
      private var mCheckIfTheUserIsAttackable:Boolean;
      
      private var mAttackButtonDisableMessage:String;
      
      private var mAttackButtons:Array;
      
      public function ToolBarFacade()
      {
         super("hud_menu");
         this.mContentHolders = new Dictionary();
      }
      
      public function getName() : String
      {
         return "EToolBar";
      }
      
      public function getTaskList() : Vector.<String>
      {
         return new <String>["putTutorialCircle","uiUnlockElement","shopProgressBlink","updateAlliancesNotifications","updateInventoryNotifications","updateHud","hotkeyActivated"];
      }
      
      public function onMessage(task:String, params:Dictionary) : void
      {
         var toolsAllowed:Boolean = false;
         var name:String = null;
         var component:EAbstractSprite = null;
         var skus:Vector.<String> = null;
         switch(task)
         {
            case "updateHud":
               this.updateQuickAttackButton();
               break;
            case "putTutorialCircle":
               name = String(params["elementName"]);
               if(component = this.getHudElement(name))
               {
                  InstanceMng.getViewMngPlanet().addHighlightFromContainer(component);
               }
               break;
            case "uiUnlockElement":
               name = String(params["elementName"]);
               if(component = this.getHudElement(name))
               {
                  component.mouseEnabled = true;
               }
               break;
            case "shopProgressBlink":
               if((skus = InstanceMng.getApplication().shopControllersGetControllerBySku("premium").getBlinkingShopProgressSkus()).lastIndexOf("onlineProtection") >= 0)
               {
                  skus.splice(skus.lastIndexOf("onlineProtection"),1);
               }
               this.setShopNotifications(skus.length);
               break;
            case "updateInventoryNotifications":
               this.updateInventoryButton();
               break;
            case "updateAlliancesNotifications":
               this.updateAlliancesButton();
               break;
            case "hotkeyActivated":
               toolsAllowed = InstanceMng.getFlowState().getCurrentRoleId() == 0 && !InstanceMng.getUnitScene().battleIsRunning() && InstanceMng.getToolsMng().getCurrentTool() && !InstanceMng.getToolsMng().getCurrentTool().isItemAttached() && !InstanceMng.getBuildingsBufferController().isBufferOpen() && !InstanceMng.getPopupMng().isAnyPopupBeingShownOrWaiting();
               if(toolsAllowed)
               {
                  switch(params["sku"])
                  {
                     case "none":
                        this.toolChange("button_cursor");
                        break;
                     case "move":
                        this.toolChange("button_move");
                        break;
                     case "upgrade":
                        this.toolChange("button_upgrade");
                        break;
                     case "flip":
                        this.toolChange("button_flip");
                        break;
                     case "demolish":
                        this.toolChange("button_recycle");
                  }
                  break;
               }
         }
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildAsyncTotalSteps = 0;
         mBuildSyncTotalSteps = 8;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         switch(step)
         {
            case 0:
               this.mViewFactory = InstanceMng.getViewFactory();
               this.mCanvasBottom = this.mViewFactory.getESpriteContainer();
               this.mCanvasBottom.name = "thisisatest";
               buildAdvanceSyncStep();
               break;
            case 1:
               this.createLayoutsView();
               buildAdvanceSyncStep();
               break;
            case 2:
               if(InstanceMng.getRuleMng().isBuilt() && InstanceMng.getUserInfoMng().getProfileLogin().isBuilt() && InstanceMng.getUserInfoMng().getCurrentProfileLoaded().isBuilt())
               {
                  buildAdvanceSyncStep();
                  this.buildView(step);
               }
               break;
            case 3:
            case 4:
            case 5:
            case 6:
            case 7:
               buildAdvanceSyncStep();
               this.buildView(step);
         }
      }
      
      private function createLayoutsView() : void
      {
         this.mBtnMLayoutArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(this.mViewFactory.getLayoutAreaFactory("BtnImgM").getArea("base"));
         this.mBtnMLayoutArea.isSetPositionEnabled = false;
         this.mLayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory(InstanceMng.getUIFacade().getHudBottomLayoutName());
      }
      
      private function buildView(step:int) : void
      {
         var role:int = InstanceMng.getFlowState().getCurrentRoleId();
         switch(role)
         {
            case 0:
            case 5:
               if(InstanceMng.getApplication().viewGetMode() == 2)
               {
                  this.buildViewGalaxy(step);
               }
               else if(InstanceMng.getApplication().viewGetMode() == 1)
               {
                  this.buildViewStar(step);
               }
               else
               {
                  this.buildViewOwner(step);
               }
               break;
            case 1:
               this.buildViewVisitor(step);
               break;
            case 2:
               this.buildViewSpy(step);
         }
      }
      
      private function buildViewOwner(step:int) : void
      {
         switch(step - 2)
         {
            case 0:
               this.createInventoryButton();
               this.createUpgradeButton();
               break;
            case 1:
               this.createAttackDropDownButton();
               this.createAlliancesButton();
               break;
            case 2:
               this.createSettingsButton();
               break;
            case 3:
               this.createToolsButton();
               break;
            case 4:
               this.createBuildButton();
               this.createShopButton();
               this.createStrategicViewButton();
         }
      }
      
      private function buildViewStar(step:int) : void
      {
         switch(step - 2)
         {
            case 0:
               this.createAttackDropDownButton();
               break;
            case 1:
               this.createAlliancesButton();
               break;
            case 2:
               this.createSettingsButton();
         }
      }
      
      private function buildViewGalaxy(step:int) : void
      {
         switch(step - 2)
         {
            case 0:
               this.createAttackDropDownButton();
               break;
            case 1:
               this.createAlliancesButton();
               break;
            case 2:
               this.createSettingsButton();
         }
      }
      
      private function buildViewVisitor(step:int) : void
      {
         switch(step - 2)
         {
            case 0:
               this.createAttackDropDownButton();
               break;
            case 1:
               this.createSpyButton();
               break;
            case 2:
               this.createSettingsButton();
         }
      }
      
      private function buildViewSpy(step:int) : void
      {
         switch(step - 2)
         {
            case 0:
               this.createAttackDropDownButton();
               break;
            case 1:
               this.createAlliancesButton();
               break;
            case 2:
               this.createSettingsButton();
         }
      }
      
      private function createInventoryButton() : ESprite
      {
         var s:EButton = null;
         s = this.mViewFactory.getButtonIcon("btn_hud","skin_icon_inventory",null,this.mLayoutAreaFactory.getArea("button_inventory"));
         s.setLayoutArea(this.mLayoutAreaFactory.getArea("button_inventory"),true);
         s.eAddEventListener("click",this.onInventoryClick);
         s.name = "button_inventory";
         this.addHudElement("button_inventory",s,this.mCanvasBottom,true);
         var not:ESpriteContainer = this.mViewFactory.getNotificationArea(null,this.mLayoutAreaFactory.getArea("notification_area_inventory"));
         not.name = "notification_area_inventory";
         not.visible = true;
         this.addHudElement("notification_area_inventory",not,this.mCanvasBottom,false);
         return this.getHudElement("button_inventory");
      }
      
      private function createStrategicViewButton() : ESprite
      {
         var s:EButton = null;
         s = this.mViewFactory.getButtonIcon("btn_hud","skin_icon_flatbed",null,this.mLayoutAreaFactory.getArea("button_strategic_view"));
         s.setLayoutArea(this.mLayoutAreaFactory.getArea("button_strategic_view"),true);
         s.eAddEventListener("click",this.onStrategicViewClick);
         s.name = "button_strategic_view";
         this.addHudElement("button_strategic_view",s,this.mCanvasBottom,true);
         return this.getHudElement("button_strategic_view");
      }
      
      private function createUpgradeButton() : ESprite
      {
         var s:EButton = null;
         var area:ELayoutArea = this.mLayoutAreaFactory.getArea("button_upgrade");
         s = this.mViewFactory.getButtonIcon("btn_hud","skin_icon_upgrade",null,area);
         s.setLayoutArea(area,true);
         s.eAddEventListener("click",this.onToolHudClick);
         s.name = "button_upgrade";
         this.addHudElement("button_upgrade",s,this.mCanvasBottom,true);
         s = this.mViewFactory.getButtonIcon("btn_hud_cancel","skin_icon_upgrade",null,area,"HUE_red");
         s.setLayoutArea(area,true);
         s.eAddEventListener("click",this.onToolHudClick);
         s.name = "button_upgrade_cancel";
         this.addHudElement("button_upgrade_cancel",s,this.mCanvasBottom,true);
         s.visible = false;
         return s;
      }
      
      private function createAlliancesButton() : ESprite
      {
         var s:ESpriteContainer = null;
         s = this.mViewFactory.getButton("btn_hud",null,"HudL",DCTextMng.getText(634));
         s.setLayoutArea(this.mLayoutAreaFactory.getArea("button_alliances"),true);
         s.eAddEventListener("click",this.onAlliancesClick);
         s.name = "button_alliances";
         this.addHudElement("button_alliances",s,this.mCanvasBottom,true);
         s = this.mViewFactory.getNotificationArea(null,this.mLayoutAreaFactory.getArea("notification_area"));
         s.name = "notification_area";
         s.visible = false;
         this.addHudElement("notification_area",s,this.mCanvasBottom,false);
         return this.getHudElement("button_alliances");
      }
      
      private function createSpyButton() : ESprite
      {
         var s:ESpriteContainer = null;
         s = this.mViewFactory.getButton("btn_hud",null,"HudL",DCTextMng.getText(3506));
         s.setLayoutArea(this.mLayoutAreaFactory.getArea("button_alliances"),true);
         s.eAddEventListener("click",this.onSpyClick);
         s.name = "button_spy";
         this.addHudElement("button_spy",s,this.mCanvasBottom,true);
         return this.getHudElement("button_spy");
      }
      
      private function createBuildButton() : ESprite
      {
         var s:EButton = null;
         s = this.mViewFactory.getButton("btn_hud",null,"HudM",DCTextMng.getText(16));
         s.setLayoutArea(this.mLayoutAreaFactory.getArea("button_shop"),true);
         s.eAddEventListener("click",this.onBuildClick);
         s.name = "button_shop";
         this.addHudElement("button_shop",s,this.mCanvasBottom,true);
         return s;
      }
      
      private function createShopButton() : ESprite
      {
         var s:ESprite = null;
         s = this.mViewFactory.getButton("btn_hud",null,"HudM",DCTextMng.getText(508));
         s.setLayoutArea(this.mLayoutAreaFactory.getArea("button_premium_shop"),true);
         s.eAddEventListener("click",this.onPremiumShopClick);
         s.name = "button_premium_shop";
         EButton(s).getBackground().setColor(16753920,0.5);
         this.addHudElement("button_premium_shop",s,this.mCanvasBottom,true);
         s = this.mViewFactory.getNotificationArea(null,this.mLayoutAreaFactory.getArea("notification_area_shop"));
         s.name = "notification_area_shop";
         s.visible = false;
         this.addHudElement("notification_area_shop",s,this.mCanvasBottom,false);
         return s;
      }
      
      private function createSettingsButton() : ESprite
      {
         var optionsDropDown:EHudOptionsView = new EHudOptionsView();
         optionsDropDown.setLayoutArea(this.mLayoutAreaFactory.getArea("preferences"),true);
         optionsDropDown.name = "preferences";
         this.addHudElement("preferences",optionsDropDown,this.mCanvasBottom,false);
         return this.getHudElement("preferences");
      }
      
      private function createToolsButton() : ESprite
      {
         var a:ESprite = null;
         var s:ESprite = null;
         var btn:EButton = null;
         if(this.mViewFactory == null)
         {
            this.mViewFactory = InstanceMng.getViewFactory();
         }
         var content:ESpriteContainer = this.mViewFactory.getESpriteContainer();
         var buttons:Array = [];
         s = this.mViewFactory.getButtonIcon("btn_hud","skin_icon_recycle",null,this.mBtnMLayoutArea);
         s.name = "button_recycle";
         s.eAddEventListener("click",this.onToolHudClick);
         buttons.push(s);
         content.eAddChild(s);
         content.setContent("button_recycle",s);
         this.addMouseOverButtonBehaviors(s);
         s = this.mViewFactory.getButtonIcon("btn_hud","skin_icon_buildingbuffer",null,this.mBtnMLayoutArea);
         s.name = "button_bb";
         s.eAddEventListener("click",this.onToolHudClick);
         buttons.push(s);
         content.eAddChild(s);
         content.setContent("button_bb",s);
         this.addMouseOverButtonBehaviors(s);
         s = this.mViewFactory.getButtonIcon("btn_hud","skin_icon_move_wall",null,this.mBtnMLayoutArea);
         s.name = "button_group";
         s.eAddEventListener("click",this.onToolHudClick);
         buttons.push(s);
         content.eAddChild(s);
         content.setContent("button_group",s);
         this.addMouseOverButtonBehaviors(s);
         s = this.mViewFactory.getButtonIcon("btn_hud","skin_icon_move",null,this.mBtnMLayoutArea);
         s.name = "button_move";
         s.eAddEventListener("click",this.onToolHudClick);
         buttons.push(s);
         content.eAddChild(s);
         content.setContent("button_move",s);
         this.addMouseOverButtonBehaviors(s);
         s = this.mViewFactory.getButtonIcon("btn_hud","skin_icon_rotation",null,this.mBtnMLayoutArea);
         s.name = "button_flip";
         s.eAddEventListener("click",this.onToolHudClick);
         buttons.push(s);
         content.eAddChild(s);
         content.setContent("button_flip",s);
         this.addMouseOverButtonBehaviors(s);
         content.setLayoutArea(this.mViewFactory.createMinimumLayoutArea(buttons,1),true);
         this.mViewFactory.distributeSpritesInArea(content.getLayoutArea(),buttons,1,1,1);
         var buttonLayoutArea:ELayoutArea = this.mLayoutAreaFactory.getArea("button_multi_tool");
         (btn = this.mViewFactory.getButtonIcon("btn_hud","skin_icon_select",null,buttonLayoutArea)).setLayoutArea(buttonLayoutArea,true);
         btn.name = "button_multi_tool";
         var dropdownButton:EDropDownButton;
         (dropdownButton = this.mViewFactory.getDropDownButtonFromContent(null,content,btn)).name = "button_multi_tool";
         this.addMouseOverButtonBehaviors(dropdownButton.getButton());
         this.addHudElement("button_multi_tool",dropdownButton,this.mCanvasBottom,false);
         s = this.mViewFactory.getButtonIcon("btn_hud","skin_icon_cancel",null,buttonLayoutArea,"HUE_red");
         s.setLayoutArea(buttonLayoutArea,true);
         s.eAddEventListener("click",this.onToolHudClick);
         s.name = "tools_cancel";
         this.addHudElement("tools_cancel",s,this.mCanvasBottom,true);
         s.visible = false;
         a = this.mViewFactory.getEImage("skin_icon_arrow",null,false,this.mLayoutAreaFactory.getArea("btn_plus_tools"));
         a.logicLeft -= buttonLayoutArea.x;
         a.logicTop -= buttonLayoutArea.y;
         btn.eAddChild(a);
         btn.setContent("arrow",a);
         return this.getHudElement("button_multi_tool");
      }
      
      public function toolChange(toolType:String, forceHideToolbar:Boolean = true) : void
      {
         var e:Object = null;
         var changeMultiToolToCancel:Boolean = true;
         var changeUpgradeToolToCancel:Boolean = false;
         var toolsMng:ToolsMng = InstanceMng.getToolsMng();
         var toolBar:ToolBarFacade = InstanceMng.getGUIController().getToolBar();
         if(toolType != "button_upgrade")
         {
            InstanceMng.getToolsMng().getCurrentTool().destroySelection();
         }
         switch(toolType)
         {
            case "button_cursor":
               toolsMng.setTool(0);
               changeMultiToolToCancel = false;
               break;
            case "button_upgrade_cancel":
               toolsMng.setTool(0);
               changeMultiToolToCancel = false;
               break;
            case "button_flip":
               toolsMng.setTool(6);
               changeMultiToolToCancel = true;
               break;
            case "button_group":
               toolsMng.setTool(15);
               changeMultiToolToCancel = true;
               break;
            case "button_bb":
               MessageCenter.getInstance().sendMessage("hudBuildingBufferClicked");
               break;
            case "button_move":
               toolsMng.setTool(5);
               changeMultiToolToCancel = true;
               break;
            case "button_move_buffer":
               toolsMng.setTool(16);
               changeMultiToolToCancel = true;
               break;
            case "button_recycle":
               toolsMng.setTool(1);
               changeMultiToolToCancel = true;
               break;
            case "button_upgrade":
               if(InstanceMng.getToolsMng().getCurrentTool().isSelectionMade())
               {
                  (e = {}).item = InstanceMng.getToolsMng().getCurrentTool().getLowestLevelWalls()[0];
                  e.items = InstanceMng.getToolsMng().getCurrentTool().getLowestLevelWalls();
                  e.cmd = "WIOEventUpgradeStart";
                  e.sendResponseTo = InstanceMng.getWorldItemObjectController();
                  e.phase = "";
                  e.type = 1;
                  InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),e,true);
               }
               else
               {
                  toolsMng.setTool(8);
                  changeUpgradeToolToCancel = true;
               }
               break;
            case "tools_cancel":
               if(toolsMng.getCurrentToolId() == 6 && toolsMng.getCurrentTool().isItemAttached())
               {
                  toolsMng.getCurrentTool().getAttachedItem().flip(true);
               }
               toolsMng.setTool(0);
               changeMultiToolToCancel = false;
               break;
            case "button_colonies":
               toolsMng.setTool(0);
               toolBar.changeDisplayColoniesExtended();
               changeMultiToolToCancel = false;
         }
         if(InstanceMng.getApplication().viewGetMode() == 0)
         {
            if(forceHideToolbar)
            {
               toolBar.hideToolbarExtended();
            }
            else
            {
               toolBar.changeDisplayToolbarExtended();
            }
            toolBar.setCancelButtons(changeUpgradeToolToCancel);
            toolBar.setCancelTools(changeMultiToolToCancel);
         }
      }
      
      private function createAttackDropDownButton() : ESprite
      {
         var s:ESprite = null;
         var btn:EButton = null;
         var profileUser:Profile = null;
         var targetUser:Profile = null;
         var userPlanet:String = null;
         var planet:Planet = null;
         var targetPlanet:String = null;
         var content:ESpriteContainer = this.mViewFactory.getESpriteContainer();
         var buttonHudLayoutAreaFactory:ELayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory(this.mViewFactory.getButtonLayout("HudIconArea",true));
         this.mAttackButtons = [];
         if(InstanceMng.getBetMng().canShowBetIconInHud())
         {
            (s = this.mViewFactory.getButton("btn_hud",null,"Hud",DCTextMng.getText(332),"icon_betting")).name = "cbox_betting";
            s.eAddEventListener("click",this.onBettingClick);
            this.mAttackButtons.push(s);
            this.addHudElement("cbox_betting",s,content,true);
         }
         s = this.mViewFactory.getButton("btn_hud",null,"HudIconArea",DCTextMng.getText(323),"icon_battle");
         var transaction:int = InstanceMng.getRuleMng().getQuickAttackMineralCost();
         this.mQuickAttackIconTextField = this.mViewFactory.getContentIconWithTextHorizontal("IconTextSLarge","icon_minerals",DCTextMng.convertNumberToString(Math.abs(transaction),-1,-1),null,"text_minerals");
         this.mQuickAttackIconTextField.setLayoutArea(buttonHudLayoutAreaFactory.getArea("container_icon_text_xs"),true);
         s.eAddChild(this.mQuickAttackIconTextField);
         ESpriteContainer(s).setContent("cost",this.mQuickAttackIconTextField);
         s.name = "quick_attack";
         s.eAddEventListener("click",this.onQuickAttackClick);
         this.mAttackButtons.push(s);
         this.addHudElement("quick_attack",s,content,true);
         if(InstanceMng.getFlowState().getCurrentRoleId() == 2 || InstanceMng.getFlowState().getCurrentRoleId() == 1)
         {
            profileUser = InstanceMng.getUserInfoMng().getProfileLogin();
            if((targetUser = InstanceMng.getUserInfoMng().getCurrentProfileLoaded()).getUserInfoObj().mIsNPC.value)
            {
               transaction = InstanceMng.getRuleMng().getAmountDependingOnCapacity(targetUser.getUserInfoObj().getAttackCostPercentage(),false);
            }
            else
            {
               userPlanet = profileUser.getUserInfoObj().getPlanetById(profileUser.getCurrentPlanetId()).getSku();
               planet = targetUser.getUserInfoObj().getPlanetById(targetUser.getCurrentPlanetId());
               targetPlanet = Config.OFFLINE_GAMEPLAY_MODE ? InstanceMng.getApplication().goToGetRequestPlanetSku() : planet.getSku();
               transaction = InstanceMng.getRuleMng().getAttackDistanceMineralCost(userPlanet,targetPlanet);
            }
            s = this.mViewFactory.getButton("btn_hud",null,"HudIconArea",DCTextMng.getText(483),"icon_friend_attack");
            this.mAttackIconTextField = this.mViewFactory.getContentIconWithTextHorizontal("IconTextSLarge","icon_minerals",DCTextMng.convertNumberToString(Math.abs(transaction),-1,-1),null,"text_minerals");
            this.mAttackIconTextField.setLayoutArea(buttonHudLayoutAreaFactory.getArea("container_icon_text_xs"),true);
            s.eAddChild(this.mAttackIconTextField);
            ESpriteContainer(s).setContent("cost",this.mAttackIconTextField);
            s.name = "direct_attack";
            s.eAddEventListener("click",this.onAttackClick);
            this.mAttackButtons.push(s);
            this.addHudElement("direct_attack",s,content,true);
         }
         content.setLayoutArea(this.mViewFactory.createMinimumLayoutArea(this.mAttackButtons,1),true);
         this.mViewFactory.distributeSpritesInArea(content.getLayoutArea(),this.mAttackButtons,1,1,1);
         var buttonLayoutArea:ELayoutArea = this.mLayoutAreaFactory.getArea("button_target_spotter");
         (btn = this.mViewFactory.getButton("btn_hud_attack",null,"HudL",DCTextMng.getText(398))).setLayoutArea(buttonLayoutArea,true);
         btn.name = "button_attack_dropdown";
         var dropdownButton:EDropDownButton;
         (dropdownButton = this.mViewFactory.getDropDownButtonFromContent(null,content,btn)).name = "button_target_spotter";
         this.addMouseOverButtonBehaviors(dropdownButton.getButton());
         this.addHudElement("button_target_spotter",dropdownButton,this.mCanvasBottom,false);
         s = this.mViewFactory.getEImage("skin_icon_arrow",null,false,this.mLayoutAreaFactory.getArea("btn_plus_attack"),"HUE_attack");
         s.logicLeft -= buttonLayoutArea.x;
         s.logicTop -= buttonLayoutArea.y;
         btn.eAddChild(s);
         btn.setContent("arrow",s);
         var toolSpy:ToolSpy;
         (toolSpy = InstanceMng.getToolsMng().getTool(10) as ToolSpy).buttonHovering = false;
         toolSpy.dropDownHovering = false;
         return dropdownButton;
      }
      
      private function addHudElement(id:String, s:ESprite, where:ESpriteContainer, addMouseOverBehaviours:Boolean) : void
      {
         s.name = id;
         if(addMouseOverBehaviours)
         {
            this.addMouseOverButtonBehaviors(s);
         }
         s.eAddEventListener("rollOver",uiEnable);
         s.eAddEventListener("rollOut",uiDisable);
         where.eAddChild(s);
         this.mContentHolders[id] = s;
      }
      
      private function addMouseOverButtonBehaviors(s:ESprite) : void
      {
         s.eAddEventBehavior("rollOver",InstanceMng.getBehaviorsMng().getMouseBehavior("MouseOverButton"));
         s.eAddEventBehavior("rollOut",InstanceMng.getBehaviorsMng().getMouseBehavior("MouseOutButton"));
         s.eAddEventListener("rollOver",this.onMouseOverBtn);
         s.eAddEventListener("rollOut",this.onMouseOutBtn);
      }
      
      override protected function beginDo() : void
      {
         this.resetInventoryNotifications();
         this.updateQuickAttackButton();
         MessageCenter.getInstance().registerObject(this);
         InstanceMng.getViewMngGame().addESpriteToLayer(this.mCanvasBottom,InstanceMng.getViewMngGame().getHudLayerSku(),8);
         this.mCanvasBottom.logicY = this.mCanvasBottom.logicY;
         setVisible(true);
         if(!InstanceMng.getFlowStatePlanet().isFirstTargetDone())
         {
            this.moveDisappearUpToDown(0.1);
         }
         this.mAttackButtonDisableMessage = null;
         this.mCheckIfTheUserIsAttackable = InstanceMng.getRole().mId == 2 || InstanceMng.getRole().mId == 1;
         this.mDropDownsRepositioned = false;
      }
      
      override protected function unbuildDo() : void
      {
         var id:* = null;
         for(id in this.mContentHolders)
         {
            this.mContentHolders[id].destroy();
            delete this.mContentHolders[id];
         }
         this.mCanvasBottom.destroy();
         this.mQuickAttackIconTextField = null;
         if(this.mBtnMLayoutArea != null)
         {
            this.mBtnMLayoutArea.destroy();
            this.mBtnMLayoutArea = null;
         }
      }
      
      override protected function endDo() : void
      {
         MessageCenter.getInstance().unregisterObject(this);
         InstanceMng.getViewMngGame().removeESpriteFromLayer(this.mCanvasBottom,InstanceMng.getViewMngGame().getHudLayerSku());
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var s:ESprite = null;
         var sc:ESpriteContainer = null;
         var lastLeft:Number = NaN;
         var diff:Number = NaN;
         var elements:Array = null;
         var element:String = null;
         super.logicUpdateDo(dt);
         for each(s in this.mContentHolders)
         {
            s.logicUpdate(dt);
         }
         if(this.mCheckIfTheUserIsAttackable)
         {
            this.mCheckIfTheUserIsAttackable = false;
            InstanceMng.getApplication().canUserBeAttacked(InstanceMng.getUserInfoMng().getUserToVisit());
         }
         if(!this.mDropDownsRepositioned)
         {
            elements = ["button_target_spotter"];
            for each(element in elements)
            {
               if(this.getHudElement(element) && this.getHudElement(element) as EDropDownButton)
               {
                  sc = (this.getHudElement(element) as EDropDownButton).getDropDown();
                  lastLeft = sc.logicLeft;
                  InstanceMng.getViewFactory().arrangeToFitInMinimumScreen(sc);
                  diff = sc.logicLeft - lastLeft;
                  sc.getContent("arrow").logicX = sc.getContent("arrow").logicX - diff;
               }
            }
            this.mDropDownsRepositioned = true;
         }
      }
      
      public function getHudElement(id:String) : ESprite
      {
         return this.mContentHolders[id];
      }
      
      override public function addMouseEvents() : void
      {
         var s:String = null;
         var esprite:ESprite = null;
         for each(s in HUD_PRIMARY_BUTTONS_GROUP)
         {
            esprite = this.getHudElement(s);
            if(esprite)
            {
               esprite.mouseEnabled = true;
            }
         }
      }
      
      override public function removeMouseEvents() : void
      {
         var s:String = null;
         var esprite:ESprite = null;
         for each(s in HUD_PRIMARY_BUTTONS_GROUP)
         {
            esprite = this.getHudElement(s);
            if(esprite)
            {
               esprite.mouseEnabled = false;
            }
         }
      }
      
      override public function unlock(exception:Object = null) : void
      {
         var s:ESprite = null;
         super.unlock();
         this.addMouseEvents();
         if(exception)
         {
            s = this.getHudElement(exception.toString());
            if(s)
            {
               s.mouseEnabled = false;
            }
         }
      }
      
      override public function lock() : void
      {
         super.lock();
         this.removeMouseEvents();
      }
      
      public function disableAttackButton(reason:String) : void
      {
         var esp:ESprite = this.getHudElement("direct_attack");
         if(esp)
         {
            esp.applySkinProp(null,"disabled");
            this.mAttackButtonDisableMessage = reason;
         }
      }
      
      public function changeDisplayToolbarExtended() : void
      {
      }
      
      public function changeDisplayColoniesExtended() : void
      {
      }
      
      public function hideToolbarExtended() : Boolean
      {
         var btn:EDropDownButton = this.getHudElement("button_multi_tool") as EDropDownButton;
         if(btn)
         {
            btn.close();
         }
         btn = this.getHudElement("button_target_spotter") as EDropDownButton;
         if(btn)
         {
            btn.close();
         }
         btn = this.getHudElement("preferences") as EDropDownButton;
         if(btn)
         {
            btn.close();
         }
         return true;
      }
      
      public function setCancelButtons(upgradeToolCancelValue:Boolean = false) : void
      {
         this.getHudElement("button_upgrade_cancel").visible = upgradeToolCancelValue;
         this.getHudElement("button_upgrade").visible = !upgradeToolCancelValue;
      }
      
      public function setCancelTools(upgradeToolCancelValue:Boolean = false) : void
      {
         this.getHudElement("tools_cancel").visible = upgradeToolCancelValue;
         this.getHudElement("button_multi_tool").visible = !upgradeToolCancelValue;
      }
      
      public function setStarInventoryVisible() : void
      {
         this.updateInventoryButton();
      }
      
      override public function moveDisappearUpToDown(numSeconds:Number = 0.5) : void
      {
         var values:Object = null;
         var tween:GTween = null;
         if(isVisible())
         {
            values = {"pivotLogicY":-1.1};
            tween = new GTween(this.mCanvasBottom,numSeconds,values);
            tween.autoPlay = true;
            tween.onComplete = function(t:GTween):void
            {
               setVisible(false);
            };
         }
      }
      
      override public function moveAppearDownToUp(numSeconds:Number = 0.5) : void
      {
         var values:Object = null;
         var tween:GTween = null;
         if(!isVisible())
         {
            values = {"pivotLogicY":0};
            tween = new GTween(this.mCanvasBottom,numSeconds,values);
            tween.autoPlay = true;
            tween.onComplete = function(t:GTween):void
            {
               setVisible(true);
            };
         }
      }
      
      private function setInventoryNotifications(value:uint) : void
      {
         this.mInventoryNotifications = value;
         if(this.getHudElement("notification_area_inventory"))
         {
            ESpriteContainer(this.getHudElement("notification_area_inventory")).getContentAsETextField("text").setText(this.mInventoryNotifications.toString());
            this.getHudElement("notification_area_inventory").visible = this.mInventoryNotifications > 0;
         }
      }
      
      private function resetInventoryNotifications() : void
      {
         this.mInventoryNotifications = 0;
         if(this.getHudElement("notification_area_inventory"))
         {
            ESpriteContainer(this.getHudElement("notification_area_inventory")).getContentAsETextField("text").setText(this.mInventoryNotifications.toString());
            this.getHudElement("notification_area_inventory").visible = false;
         }
      }
      
      private function setShopNotifications(value:uint) : void
      {
         this.mShopNotifications = value;
         if(this.getHudElement("notification_area_shop"))
         {
            ESpriteContainer(this.getHudElement("notification_area_shop")).getContentAsETextField("text").setText(this.mShopNotifications.toString());
            this.getHudElement("notification_area_shop").visible = this.mShopNotifications > 0;
         }
      }
      
      private function setAlliancesNotifications(value:uint) : void
      {
         this.mAlliancesNotifications = value;
         if(this.getHudElement("notification_area"))
         {
            ESpriteContainer(this.getHudElement("notification_area")).getContentAsETextField("text").setText(this.mAlliancesNotifications.toString());
            this.getHudElement("notification_area").visible = this.mAlliancesNotifications > 0;
         }
      }
      
      public function updateAlliancesButton() : void
      {
         var alliancesControllerStar:AlliancesControllerStar = null;
         var totalNotifications:int = 0;
         var o:Object = null;
         var controller:AlliancesController = InstanceMng.getAlliancesController();
         if(controller == null)
         {
            this.getHudElement("button_alliances").visible = false;
         }
         else
         {
            alliancesControllerStar = controller as AlliancesControllerStar;
            if(alliancesControllerStar != null)
            {
               if(alliancesControllerStar.needsToShowWarIsOverPopup())
               {
                  alliancesControllerStar.showPopupOnWarOver();
               }
               if(alliancesControllerStar.needsToShowDeclareWarPopup())
               {
                  o = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NOTIFY_ALLIANCES_DECLARE_WAR");
                  if(AlliancesControllerStar(InstanceMng.getAlliancesController()).getMyAlliance() != null)
                  {
                     o.alliance = alliancesControllerStar.getMyAlliance();
                     InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o);
                     alliancesControllerStar.saveCurrentWarInProfile();
                     InstanceMng.getUIFacade().alliancesNotifyWarHasBegun();
                  }
               }
            }
            totalNotifications = 0;
            if(controller.getMyAlliance())
            {
               totalNotifications += controller.getMyAlliance().getNewsUnreadCount();
            }
            totalNotifications += InstanceMng.getAlliancesRewardsMng().getRewardsAvailable();
            totalNotifications += int(InstanceMng.getAlliancesController().needsToShowKickedFromAlliancePopup());
            this.setAlliancesNotifications(totalNotifications);
         }
      }
      
      public function updateInventoryButton() : void
      {
         this.setInventoryNotifications(InstanceMng.getItemsMng().getUnseenItemsAmount(null));
      }
      
      private function updateQuickAttackButton() : void
      {
         var transaction:int = 0;
         var tf:ETextField = null;
         var profile:Profile = null;
         var targetUser:Profile = null;
         var targetPlanet:String = null;
         var userPlanet:String = null;
         var planet:Planet = null;
         if(this.mQuickAttackIconTextField)
         {
            transaction = InstanceMng.getRuleMng().getQuickAttackMineralCost();
            profile = InstanceMng.getUserInfoMng().getProfileLogin();
            tf = this.mQuickAttackIconTextField.getContentAsETextField("text");
            tf.setText(DCTextMng.convertNumberToString(transaction,-1,-1));
            if(transaction < profile.getMinerals())
            {
               tf.unapplySkinProp(null,"text_light_negative");
               tf.applySkinProp(null,"text_minerals");
            }
            else
            {
               tf.unapplySkinProp(null,"text_minerals");
               tf.applySkinProp(null,"text_light_negative");
            }
         }
         if(this.mAttackIconTextField && (InstanceMng.getRole().mId == 1 || InstanceMng.getRole().mId == 2))
         {
            profile = InstanceMng.getUserInfoMng().getProfileLogin();
            if((targetUser = InstanceMng.getUserInfoMng().getCurrentProfileLoaded()).getUserInfoObj().mIsNPC.value)
            {
               transaction = InstanceMng.getRuleMng().getAmountDependingOnCapacity(targetUser.getUserInfoObj().getAttackCostPercentage(),false);
            }
            else
            {
               userPlanet = profile.getUserInfoObj().getPlanetById(profile.getCurrentPlanetId()).getSku();
               planet = targetUser.getUserInfoObj().getPlanetById(targetUser.getCurrentPlanetId());
               targetPlanet = Config.OFFLINE_GAMEPLAY_MODE ? InstanceMng.getApplication().goToGetRequestPlanetSku() : planet.getSku();
               transaction = InstanceMng.getRuleMng().getAttackDistanceMineralCost(userPlanet,targetPlanet);
            }
            tf = this.mAttackIconTextField.getContentAsETextField("text");
            tf.setText(DCTextMng.convertNumberToString(transaction,-1,-1));
            if(transaction < profile.getMinerals())
            {
               tf.unapplySkinProp(null,"text_light_negative");
               tf.applySkinProp(null,"text_minerals");
            }
            else
            {
               tf.unapplySkinProp(null,"text_minerals");
               tf.applySkinProp(null,"text_light_negative");
            }
         }
      }
      
      public function setAttackButtonsEnabled(value:Boolean) : void
      {
         if(this.mAttackButtons)
         {
            for each(var btn in this.mAttackButtons)
            {
               btn.setIsEnabled(value);
            }
         }
      }
      
      public function setShowBetIcon() : void
      {
         if(!this.getHudElement("cbox_betting"))
         {
            if(this.getHudElement("quick_attack"))
            {
               this.getHudElement("quick_attack").destroy();
            }
            if(this.getHudElement("direct_attack"))
            {
               this.getHudElement("direct_attack").destroy();
            }
            if(this.getHudElement("button_target_spotter"))
            {
               this.getHudElement("button_target_spotter").destroy();
            }
            this.createAttackDropDownButton();
         }
      }
      
      private function onMouseOverBtn(evt:EEvent) : void
      {
         var toolSpy:ToolSpy = null;
         var tooltipInfo:ETooltipInfo = null;
         var buttonName:String = null;
         var guiDef:DCGUIDef = null;
         if(evt.getTarget())
         {
            buttonName = String(evt.getTarget().name);
            if(this.mAttackButtonDisableMessage && buttonName == "direct_attack")
            {
               tooltipInfo = ETooltipMng.getInstance().createTooltipInfoFromText(this.mAttackButtonDisableMessage,evt.getTarget());
            }
            else if(guiDef = InstanceMng.getGUIDefMng().getDefBySku(buttonName) as DCGUIDef)
            {
               tooltipInfo = ETooltipMng.getInstance().createTooltipInfoFromText(DCTextMng.getText(TextIDs[guiDef.getTidTitleTooltip()]),evt.getTarget());
            }
            if(buttonName == "button_attack_dropdown")
            {
               (toolSpy = InstanceMng.getToolsMng().getTool(10) as ToolSpy).dropCapsuleEnable(false);
               toolSpy.spySetEnable(false);
               toolSpy.buttonHovering = true;
            }
         }
      }
      
      private function onMouseOutBtn(evt:EEvent) : void
      {
         var toolSpy:ToolSpy = null;
         if(evt.getTarget())
         {
            ETooltipMng.getInstance().removeCurrentTooltip();
         }
         if(evt.getTarget().name == "button_attack_dropdown")
         {
            toolSpy = InstanceMng.getToolsMng().getTool(10) as ToolSpy;
            toolSpy.buttonHovering = false;
         }
      }
      
      private function onInventoryClick(evt:EEvent) : void
      {
         this.checkAndRestoreSelectTool();
         InstanceMng.getItemsMng().guiOpenInventoryPopup();
      }
      
      private function onStrategicViewClick(evt:EEvent) : void
      {
         InstanceMng.getUserInfoMng().getProfileLogin().toggleFlatbed();
      }
      
      private function onBuildClick(evt:EEvent) : void
      {
         this.checkAndRestoreSelectTool();
         MessageCenter.getInstance().sendMessage("hudBuildButtonClicked");
      }
      
      private function onToolHudClick(evt:EEvent) : void
      {
         this.toolChange(evt.getTarget().name);
      }
      
      private function onAlliancesClick(evt:EEvent) : void
      {
         this.checkAndRestoreSelectTool();
         MessageCenter.getInstance().sendMessage("hudAlliancesClicked",null);
      }
      
      private function onSpyClick(evt:EEvent) : void
      {
         MessageCenter.getInstance().sendMessage("hudSpyClicked",null);
      }
      
      private function onAttackClick(evt:EEvent) : void
      {
         this.checkAndRestoreSelectTool();
         if(!this.mAttackButtonDisableMessage)
         {
            MessageCenter.getInstance().sendMessage("hudAttackClicked",null);
         }
      }
      
      private function onQuickAttackClick(evt:EEvent) : void
      {
         this.checkAndRestoreSelectTool();
         MessageCenter.getInstance().sendMessage("hudQuickAttackClicked",null);
      }
      
      private function onBettingClick(evt:EEvent) : void
      {
         this.checkAndRestoreSelectTool();
         MessageCenter.getInstance().sendMessage("hudBettingClicked",null);
      }
      
      private function onPremiumShopClick(evt:EEvent) : void
      {
         var profile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         var levelRequirement:int = InstanceMng.getSettingsDefMng().mSettingsDef.getPremiumShopUnlockLevel();
         if(profile.getLevel() >= levelRequirement)
         {
            this.checkAndRestoreSelectTool();
            MessageCenter.getInstance().sendMessage("openPremiumShop");
         }
         else
         {
            InstanceMng.getNotificationsMng().guiOpenMessagePopup("NOTIFY_SHOW_PREMIUM_SHOP_WARNING",DCTextMng.getText(77),DCTextMng.replaceParameters(4061,[levelRequirement]),"npc_A_normal");
         }
      }
      
      private function checkAndRestoreSelectTool() : void
      {
         if(InstanceMng.getToolsMng().getCurrentTool().isSelectionMade())
         {
            InstanceMng.getToolsMng().getCurrentTool().destroySelection();
            this.toolChange("button_cursor");
         }
      }
   }
}
