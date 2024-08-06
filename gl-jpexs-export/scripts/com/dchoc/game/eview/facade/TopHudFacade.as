package com.dchoc.game.eview.facade
{
   import com.dchoc.game.controller.tools.ToolSpy;
   import com.dchoc.game.core.flow.messaging.INotifyReceiver;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.hud.EHudFeedbackText;
   import com.dchoc.game.eview.widgets.EDropDownButton;
   import com.dchoc.game.eview.widgets.EDropDownSprite;
   import com.dchoc.game.eview.widgets.hud.EHudBuyTimeDropDown;
   import com.dchoc.game.eview.widgets.hud.EHudCollectionPanel;
   import com.dchoc.game.eview.widgets.hud.EHudLootingInformation;
   import com.dchoc.game.eview.widgets.hud.EHudMissionDropDownSprite;
   import com.dchoc.game.eview.widgets.hud.EHudMissionIcon;
   import com.dchoc.game.eview.widgets.hud.EHudNavigationBar;
   import com.dchoc.game.eview.widgets.smallStructures.IconBar;
   import com.dchoc.game.eview.widgets.smallStructures.IconBarHud;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipInfo;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.game.model.happening.Happening;
   import com.dchoc.game.model.happening.HappeningMng;
   import com.dchoc.game.model.rule.LevelScoreDef;
   import com.dchoc.game.model.space.Planet;
   import com.dchoc.game.model.unit.Particle;
   import com.dchoc.game.model.unit.defs.DroidDef;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.UserDataMng;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.view.dc.gui.components.GUIComponent;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.media.SoundManager;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import com.dchoc.toolkit.view.conf.DCGUIDef;
   import com.gskinner.motion.GTween;
   import esparragon.display.EGraphics;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import flash.utils.Dictionary;
   
   public class TopHudFacade extends GUIComponent implements INotifyReceiver
   {
      
      public static const HUD_GROUP_TOP_ID:String = "HudTop";
      
      public static const HUD_GROUP_TOP_ICONS_ID:String = "HudTopIcons";
      
      public static const HUD_GROUP_BOTTOM_ID:String = "HudBottom";
      
      public static const HUD_GROUP_LEFT_ID:String = "HudLeft";
      
      public static const HUD_GROUP_RIGHT_ID:String = "HudRight";
      
      public static const HUD_GROUP_OPTIONS_ID:String = "HudOptions";
      
      public static const COINS:String = "coins";
      
      public static const MINERALS:String = "minerals";
      
      public static const DROIDS:String = "droids";
      
      public static const SHIELD:String = "shield";
      
      public static const SCORE:String = "experience";
      
      public static const CHIPS:String = "gold";
      
      public static const BOOKMARK_INPUT:String = "bookmark_input";
      
      public static const BOOKMARK_INFO:String = "bookmark_info";
      
      public static const HAPPENING_WAVE_PROGRESS:String = "HAPPENING_WAVE_PROGRESS";
      
      public static const COLLECTION_PANEL_WORKER:String = "CollectionWorker";
      
      public static const COLLECTION_PANEL_CRAFTING:String = "CollectionCrafting";
      
      public static const COLLECTION_PANEL_COLLECTION:String = "CollectionCollection";
      
      public static const CHIPS_FREE:String = "btn_chips";
      
      public static const CHIPS_FREE_DROPDOWN:String = "area_free_chips";
      
      public static const CHIPS_FREE_ARROW:String = "arrow";
      
      public static const CHIPS_FREE_BUTTONS:String = "area_btns";
      
      public static const CHIPS_FREE_TEXT:String = "text_free";
      
      public static const CHIPS_OFFER_ALERT:String = "container_icon_text_xs";
      
      public static const SERVER_MAINTENANCE_ALERT:String = "area_server_notification";
      
      public static const DAILY_REWARD:String = "btn_daily_reward";
      
      public static const GENERAL_INFO_BUTTON:String = "btn_general_info";
      
      public static const GENERAL_INFO_NOTIFICATION:String = "general_info_notification";
      
      public static const DEBUG_BUTTON:String = "debug-";
      
      public static const CONTEST_TOOL:String = "btn_contest";
      
      public static const CONTEST_TOOL_TEXT:String = "text_contest";
      
      public static const MISSIONS:String = "btn_missions";
      
      public static const MISSIONS_DROPDOWN:String = "area_missions";
      
      public static const MISSIONS_NOTIFICATION:String = "notification_area";
      
      public static const HELP_COUNTER:String = "help_counter";
      
      public static const COLONIES_VISIT_INFO:String = "colonies_visit_info";
      
      public static const COLONIES_VISIT_BKG:String = "area_colonies";
      
      public static const LOOTING_PANEL:String = "container_enemy";
      
      public static const AREA_HUD_TOP:String = "container_bars";
      
      public static const AREA_PROFILE:String = "profile_basic";
      
      public static const AREA_SPY_TOOL:String = "area_spy_tool";
      
      public static const AREA_SPY_TOOL_ICON:String = "container_item";
      
      public static const AREA_SPY_TOOL_ICON_2:String = "container_item_2";
      
      public static const AREA_SPY_TOOL_TITLE:String = "text_title";
      
      public static const AREA_SPY_TOOL_BUY:String = "btn_plus";
      
      public static const AREA_BATTLE_TIMER:String = "area_timer";
      
      public static const AREA_BATTLE_TIMER_BUY_MORE:String = "area_buy_time";
      
      public static const HAPPENING_HUD_MASK:String = "happening_hud_mask";
      
      public static const HUD_GROUP_LEFT:Array = ["btn_contest","text_contest","btn_missions"];
      
      public static const HUD_GROUP_RIGHT:Array = ["btn_chips","text_free","area_free_chips","btn_daily_reward","btn_general_info"];
      
      public static const HUD_GROUP_TOP:Array = ["coins","minerals","droids","shield","experience","gold","bookmark_input","bookmark_info","HAPPENING_WAVE_PROGRESS","area_server_notification"];
      
      private static const GROUP_NORMAL_HUD_ICONS_LIST:Array = ["experience","droids","shield","minerals","coins","gold"];
      
      private static const GROUP_VISITING_HUD_ICONS_LIST:Array = ["experience","minerals","coins","gold"];
      
      private static const GROUP_SPYING_HUD_ICONS_LIST:Array = ["experience","minerals","coins","gold"];
      
      private static const GROUP_ATTACKING_HUD_ICONS_LIST:Array = ["experience","minerals","coins","gold"];
      
      private static const GROUP_STAR_HUD_ICONS_LIST:Array = ["experience","bookmark_info","minerals","coins","gold"];
      
      private static const GROUP_GALAXY_MAP_HUD_ICONS_LIST:Array = ["bookmark_input","shield","minerals","coins","gold"];
      
      private static const GROUP_BATTLE_ELEMENTS_LIST:Array = ["area_timer","container_enemy","HAPPENING_WAVE_PROGRESS"];
      
      private static const GROUP_NORMAL_HUD_HIDE_ON_HOTKEY_LIST:Array = ["container_bars","experience","droids","shield","minerals","coins","gold","btn_daily_reward","btn_general_info","bookmark_input","bookmark_info"];
      
      private static const GROUP_NORMAL_HUD_HIDE_ON_HOTKEY_CONTEST_TOOL_LIST:Array = ["btn_contest","text_contest"];
      
      private static const REPLAY_SPEEDS:Array = [1,2,4];
      
      public static const CONTEST_TOOL_USAGE_CONTEST:String = "contest";
      
      public static const CONTEST_TOOL_USAGE_HAPPENING:String = "happening";
      
      private static const BATTLE_TIME_SCALE_HALF:Number = 0.04;
      
      private static const BATTLE_TIME_SCALE_CYCLE_TIME:Number = 2000;
      
      private static const BLACK_STRIP_HEIGHT_RATIO:Number = 0.085;
       
      
      private var mCanvasTop:ESpriteContainer;
      
      private var mCanvasLeft:ESpriteContainer;
      
      private var mCanvasRight:ESpriteContainer;
      
      private var mFeedbackText:EHudFeedbackText;
      
      private var mContentHolders:Dictionary;
      
      private var mHiddenGroups:Vector.<String>;
      
      private var mTransitionGroups:Vector.<String>;
      
      private var mUpperBlackStrips:EGraphics;
      
      private var mLowerBlackStrips:EGraphics;
      
      private var mMissionsDropDown:EHudMissionDropDownSprite;
      
      private var mMissionsDropDownIcons:Vector.<EHudMissionIcon>;
      
      private var mChipsOfferTimerField:ETextField;
      
      private var mServerMaintenanceTimerField:ETextField;
      
      private var mBattleTimerField:ETextField;
      
      private var mSpeedTextField:ETextField;
      
      private var mBattleEndButton:EButton;
      
      private var mFreeChipsDropDown:EDropDownButton;
      
      private var mFreeChipsButtonOfferWall:EButton;
      
      private var mFreeChipsButtonVideoAds:EButton;
      
      private var mDailyRewardButton:EButton;
      
      private var mSocialMediaButton:EButton;
      
      private var mCanvasTopIconsGroup:ESpriteContainer;
      
      private var mCurrentLootCoins:int;
      
      private var mCurrentLootMinerals:int;
      
      private var mCurrentReplayIndex:int;
      
      private var mPurchaseShopsIsBlinking:Dictionary;
      
      protected var mLayoutAreaFactoryLeft:ELayoutAreaFactory;
      
      protected var mLayoutAreaFactoryTop:ELayoutAreaFactory;
      
      protected var mLayoutAreaFactoryTopSpying:ELayoutAreaFactory;
      
      protected var mLayoutAreaFactoryTopReplay:ELayoutAreaFactory;
      
      protected var mLayoutAreaFactoryRight:ELayoutAreaFactory;
      
      private var mViewFactory:ViewFactory;
      
      private var mDropDownsRepositioned:Boolean;
      
      private var mContestToolUsage:String;
      
      private var mBattleState:int = -1;
      
      private var mBattleTimeLeftMs:int;
      
      private var mBattleExtraTimeDefs:Vector.<Array>;
      
      public function TopHudFacade()
      {
         super("hud_bar");
         this.mHiddenGroups = new Vector.<String>(0);
         this.mTransitionGroups = new Vector.<String>(0);
         this.mContentHolders = new Dictionary();
         this.mMissionsDropDownIcons = new Vector.<EHudMissionIcon>(0);
      }
      
      public function getName() : String
      {
         return "EHud";
      }
      
      public function getTaskList() : Vector.<String>
      {
         return new <String>["showScreenFeedback","videoCompleted","videoCancelled","updateHud","missionsDropDownOpen","replaySpeedChanged","shopProgressBlink","toolChanged"];
      }
      
      public function onMessage(task:String, params:Dictionary) : void
      {
         var iconContainer:ESpriteContainer = null;
         var iconContainer2:ESpriteContainer = null;
         var container:ESpriteContainer = null;
         var sku:String = null;
         var s:ESprite = null;
         var soundMng:SoundManager = null;
         var profile:Profile = null;
         var iconBarHud:IconBarHud = null;
         switch(task)
         {
            case "showScreenFeedback":
               this.mFeedbackText.addData(params["text"],params["ttl"],params["delay"]);
               break;
            case "updateHud":
               this.updateProfile();
               break;
            case "missionsDropDownOpen":
               this.resetMissionsCounter();
               break;
            case "videoCompleted":
            case "videoCancelled":
               if(Config.USE_SOUNDS)
               {
                  soundMng = SoundManager.getInstance();
                  if((profile = InstanceMng.getUserInfoMng().getProfileLogin()).getMusic())
                  {
                     soundMng.setMusicOn(true,true);
                  }
                  if(profile.getSound())
                  {
                     soundMng.setSfxOn(true,true);
                  }
               }
               break;
            case "replaySpeedChanged":
               this.setReplaySpeed(params["newAmount"]);
               break;
            case "shopProgressBlink":
               if((sku = String(params["sku"])) == "shield" && this.getHudElement("shield"))
               {
                  s = (iconBarHud = this.getHudElement("shield") as IconBarHud).haxGetText();
               }
               if(s)
               {
                  if(params["value"] && !this.mPurchaseShopsIsBlinking[sku])
                  {
                     this.mPurchaseShopsIsBlinking[sku] = InstanceMng.getBehaviorsMng().getBehaviorPropertyBlink("text_color_light_negative");
                     s.eAddEventBehavior("immediately",this.mPurchaseShopsIsBlinking[sku]);
                  }
                  else if(!params["value"] && this.mPurchaseShopsIsBlinking[sku])
                  {
                     s.eRemoveEventBehavior("immediately",this.mPurchaseShopsIsBlinking[sku]);
                     delete this.mPurchaseShopsIsBlinking[sku];
                  }
               }
               break;
            case "toolChanged":
               container = this.getHudElement("area_spy_tool") as ESpriteContainer;
               if(container)
               {
                  if(iconContainer = container.getContentAsESpriteContainer("container_item"))
                  {
                     iconContainer.unapplySkinProp(null,"glow_green_high");
                  }
                  if(iconContainer2 = container.getContentAsESpriteContainer("container_item_2"))
                  {
                     iconContainer2.unapplySkinProp(null,"glow_green_high");
                  }
                  if(params["toolId"] == 10)
                  {
                     if(params["spyType"] == 1)
                     {
                        iconContainer2.applySkinProp(null,"glow_green_high");
                     }
                     else
                     {
                        iconContainer.applySkinProp(null,"glow_green_high");
                     }
                  }
               }
         }
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildAsyncTotalSteps = 0;
         mBuildSyncTotalSteps = 6;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         if(step == 0)
         {
            buildAdvanceSyncStep();
            this.mViewFactory = InstanceMng.getViewFactory();
            this.mCanvasTop = this.mViewFactory.getESpriteContainer();
            this.mCanvasTop.name = "HudTop";
            this.mCanvasLeft = this.mViewFactory.getESpriteContainer();
            this.mCanvasLeft.name = "HudLeft";
            this.mCanvasRight = this.mViewFactory.getESpriteContainer();
            this.mCanvasRight.name = "HudRight";
            this.mHiddenGroups.length = 0;
            this.mTransitionGroups.length = 0;
            this.mFeedbackText = new EHudFeedbackText();
            this.addHudElement("TEXT_FEEDBACK",this.mFeedbackText,this.mCanvasTop,false);
            this.mFeedbackText.mouseChildren = false;
            this.mFeedbackText.mouseEnabled = false;
            this.mPurchaseShopsIsBlinking = new Dictionary(true);
            this.createLayoutsView();
         }
         else if(step == 1)
         {
            if(InstanceMng.getUserInfoMng().getCurrentProfileLoaded().isBuilt() && InstanceMng.getUserInfoMng().getProfileLogin().isBuilt() && InstanceMng.getMapView().isBuilt())
            {
               buildAdvanceSyncStep();
               this.mCanvasTopIconsGroup = this.mViewFactory.getESpriteContainer();
               this.mCanvasTopIconsGroup.setLayoutArea(this.mLayoutAreaFactoryTop.getArea("container_bars"),true);
               this.mCanvasTopIconsGroup.mouseEnabled = false;
               this.addHudElement("HudTopIcons",this.mCanvasTopIconsGroup,this.mCanvasTop,false);
               this.mContentHolders["HudTop"] = this.mCanvasTop;
               this.mContentHolders["HudLeft"] = this.mCanvasLeft;
               this.mContentHolders["HudRight"] = this.mCanvasRight;
               this.buildView(step);
            }
         }
         else
         {
            buildAdvanceSyncStep();
            this.buildView(step);
         }
      }
      
      private function createLayoutsView() : void
      {
         var role:int = InstanceMng.getFlowState().getCurrentRoleId();
         this.mLayoutAreaFactoryTopSpying = InstanceMng.getViewFactory().getLayoutAreaFactory("LayoutHudTopSpying");
         this.mLayoutAreaFactoryTopReplay = InstanceMng.getViewFactory().getLayoutAreaFactory("LayoutHudTopReplay");
         switch(role - 1)
         {
            case 0:
               this.mLayoutAreaFactoryLeft = InstanceMng.getViewFactory().getLayoutAreaFactory("LayoutHudLeftVisiting");
               this.mLayoutAreaFactoryTop = InstanceMng.getViewFactory().getLayoutAreaFactory("LayoutHudTopVisiting");
               this.mLayoutAreaFactoryRight = InstanceMng.getViewFactory().getLayoutAreaFactory("LayoutHudRight");
               break;
            case 1:
            case 2:
            case 6:
               this.mLayoutAreaFactoryLeft = InstanceMng.getViewFactory().getLayoutAreaFactory("LayoutHudLeftSpying");
               this.mLayoutAreaFactoryTop = InstanceMng.getViewFactory().getLayoutAreaFactory("LayoutHudTopSpying");
               this.mLayoutAreaFactoryRight = InstanceMng.getViewFactory().getLayoutAreaFactory("LayoutHudRight");
               break;
            default:
               this.mLayoutAreaFactoryLeft = InstanceMng.getViewFactory().getLayoutAreaFactory("LayoutHudLeft");
               this.mLayoutAreaFactoryTop = InstanceMng.getViewFactory().getLayoutAreaFactory("LayoutHudTop");
               this.mLayoutAreaFactoryRight = InstanceMng.getViewFactory().getLayoutAreaFactory("LayoutHudRight");
         }
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
               break;
            case 3:
               this.buildViewAttack(step);
               break;
            case 7:
               this.buildViewReplay(step);
         }
         if(Config.DEBUG_MODE)
         {
            this.createDebugButtons();
         }
      }
      
      private function buildViewOwner(step:int) : void
      {
         switch(step - 2)
         {
            case 0:
               this.createTopContainerNormal();
               this.createScoreBar();
               this.createShieldBar();
               this.createDroidsBar();
               this.createCoinsBar();
               this.createMineralsBar();
               this.createChipsBar();
               this.createChipsOfferCountdown();
               this.createServerMaintenanceCountdown();
               break;
            case 1:
               this.createContestToolButton();
               this.createMissionsButton();
               break;
            case 2:
               this.createOfferButton();
               this.createLootingPanel();
               this.createTimeLeftPanel();
               this.createHappeningWaveProgressBar();
               this.createDailyRewardButton();
               this.createGeneralInfoButton();
               break;
            case 3:
               this.createCollectionPanels();
         }
      }
      
      private function buildViewStar(step:int) : void
      {
         switch(step - 1)
         {
            case 0:
               this.createTopContainerNormal();
               this.createScoreBar();
               this.createCoinsBar();
               this.createMineralsBar();
               this.createChipsBar();
               this.createChipsOfferCountdown();
               this.createServerMaintenanceCountdown();
               this.createNavigationInfoBar();
               break;
            case 1:
         }
      }
      
      private function buildViewGalaxy(step:int) : void
      {
         switch(step - 1)
         {
            case 0:
               this.createTopContainerNormal();
               this.createShieldBar();
               this.createCoinsBar();
               this.createMineralsBar();
               this.createChipsBar();
               break;
            case 1:
               this.createChipsOfferCountdown();
               this.createServerMaintenanceCountdown();
               break;
            case 2:
               this.createNavigationInputBar();
         }
      }
      
      private function buildViewVisitor(step:int) : void
      {
         switch(step - 1)
         {
            case 0:
               this.createTopContainerVisit();
               this.createScoreBar();
               this.createCoinsBar();
               this.createMineralsBar();
               this.createChipsBar();
               break;
            case 1:
               this.createProfilePanel();
               this.createServerMaintenanceCountdown();
               break;
            case 2:
               this.createVisitorLeftPanel();
               break;
            case 4:
               this.createCollectionPanels();
         }
      }
      
      private function buildViewSpy(step:int) : void
      {
         switch(step - 1)
         {
            case 0:
               this.createTopContainerVisit();
               this.createScoreBar();
               this.createCoinsBar();
               this.createMineralsBar();
               this.createChipsBar();
               break;
            case 1:
               this.createLootingPanel();
               this.createServerMaintenanceCountdown();
               break;
            case 2:
               this.createSpyCapsulesPanel();
               break;
            case 4:
               this.createCollectionPanels();
         }
      }
      
      private function buildViewAttack(step:int) : void
      {
         switch(step - 1)
         {
            case 0:
               this.createTopContainerVisit();
               this.createScoreBar();
               this.createCoinsBar();
               this.createMineralsBar();
               this.createChipsBar();
               break;
            case 1:
               this.createLootingPanel();
               this.createServerMaintenanceCountdown();
               break;
            case 2:
               this.createTimeLeftPanel();
               this.createSpyCapsulesPanel();
               break;
            case 4:
               this.createCollectionPanels();
         }
      }
      
      private function buildViewReplay(step:int) : void
      {
         switch(step - 1)
         {
            case 0:
               this.createLootingPanel();
               break;
            case 1:
               this.createTimeLeftPanel();
               this.createServerMaintenanceCountdown();
         }
      }
      
      private function createTopContainerNormal() : void
      {
         var layout:ELayoutArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(this.mLayoutAreaFactoryTop.getArea("container_bars"),1);
         var s:ESprite = this.mViewFactory.getEImage("skin_ui_hud_area_top",null,false,layout,null);
         this.addHudElement("container_bars",s,this.mCanvasTopIconsGroup,false);
         var mask:ESpriteContainer = this.mViewFactory.getESpriteContainer();
         s = this.mViewFactory.getResourceAsESprite("base_top_xmas",null,false);
         mask.eAddChild(s);
         mask.logicX = layout.x - 20;
         mask.logicY = layout.y + 55;
         var happMng:HappeningMng = InstanceMng.getHappeningMng();
         if(!InstanceMng.getApplication().isTutorialCompleted() || happMng.getHappeningInHudSku() == null || happMng.getHappeningInHudSku().indexOf("winter") == -1 || happMng.getHappeningInHud() != null && !happMng.getHappeningInHud().isRunning())
         {
            mask.visible = false;
         }
         this.addHudElement("happening_hud_mask",mask,this.mCanvasTopIconsGroup,false);
      }
      
      private function createTopContainerVisit() : void
      {
         var layout:ELayoutArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(this.mLayoutAreaFactoryTop.getArea("container_bars"),1);
         var s:ESprite = this.mViewFactory.getEImage("skin_ui_area_top_visit",null,false,layout,null);
         this.addHudElement("container_bars",s,this.mCanvasTopIconsGroup,false);
      }
      
      private function createTopContainerSpy() : void
      {
         var layout:ELayoutArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(this.mLayoutAreaFactoryTop.getArea("container_bars"),1);
         var s:ESprite = this.mViewFactory.getEImage("skin_ui_area_top_visit",null,false,layout,null);
         this.addHudElement("container_bars",s,this.mCanvasTopIconsGroup,false);
      }
      
      private function createScoreBar() : ESprite
      {
         var s:ESprite = this.mViewFactory.getIconBar(null,"IconBarHudMNoBtn","color_score","icon_score_level");
         s.eAddEventListener("rollOver",this.onMouseOverScore);
         s.eAddEventListener("rollOut",this.onMouseOutScore);
         s.mouseChildren = false;
         s.name = "experience";
         this.addHudElement("experience",s,this.mCanvasTopIconsGroup,true);
         return s;
      }
      
      private function createCoinsBar() : ESprite
      {
         var s:IconBar = this.mViewFactory.getIconBarHud(null,"IconBarHudL","color_coins","icon_coin",this.onCoinsClicked);
         s.eAddEventListener("rollOver",this.onMouseOverCoins);
         s.eAddEventListener("rollOut",this.onMouseOutCoins);
         s.mouseChildren = false;
         this.addHudElement("coins",s,this.mCanvasTopIconsGroup,true);
         return s;
      }
      
      private function createMineralsBar() : ESprite
      {
         var s:IconBar = this.mViewFactory.getIconBarHud(null,"IconBarHudL","color_minerals","icon_mineral",this.onMineralsClicked);
         s.eAddEventListener("rollOver",this.onMouseOverMinerals);
         s.eAddEventListener("rollOut",this.onMouseOutMinerals);
         s.mouseChildren = false;
         this.addHudElement("minerals",s,this.mCanvasTopIconsGroup,true);
         return s;
      }
      
      private function createChipsBar() : ESprite
      {
         var s:ESprite = this.mViewFactory.getIconBarHud(null,"IconBarHudM","color_white","icon_chip",this.onChipsClicked);
         s.eAddEventListener("rollOver",this.onMouseOverHudElement);
         s.eAddEventListener("rollOut",this.onMouseOutHudElement);
         s.mouseChildren = false;
         s.name = "gold";
         this.addHudElement("gold",s,this.mCanvasTopIconsGroup,true);
         return s;
      }
      
      private function createDroidsBar() : ESprite
      {
         var s:ESprite = this.mViewFactory.getIconBarHud(null,"IconBarHudS","color_white","icon_droids",this.onDroidsClicked);
         s.eAddEventListener("rollOver",this.onMouseOverDroids);
         s.eAddEventListener("rollOut",this.onMouseOutDroids);
         s.mouseChildren = false;
         s.name = "droids";
         this.addHudElement("droids",s,this.mCanvasTopIconsGroup,true);
         return s;
      }
      
      private function createShieldBar() : ESprite
      {
         var s:ESprite = this.mViewFactory.getIconBarHud(null,"IconBarHudM","color_white","shield1",this.onShieldClicked);
         s.eAddEventListener("rollOver",this.onMouseOverHudElement);
         s.eAddEventListener("rollOut",this.onMouseOutHudElement);
         s.mouseChildren = false;
         s.name = "shield";
         this.addHudElement("shield",s,this.mCanvasTopIconsGroup,true);
         return s;
      }
      
      private function createNavigationInputBar() : ESprite
      {
         var s:ESprite = this.mViewFactory.getNavigationInputBarHud();
         s.name = "bookmark_input";
         this.addHudElement("bookmark_input",s,this.mCanvasTopIconsGroup,false);
         return s;
      }
      
      private function createNavigationInfoBar() : ESprite
      {
         var barInfo:ESpriteContainer = this.mViewFactory.getNavigationInfoBarHud();
         barInfo.getContentAsEButton("btn_add").eAddEventListener("click",this.onBookmarkAddClicked);
         barInfo.getContentAsEButton("btn_remove").eAddEventListener("click",this.onBookmarkRemovedClicked);
         barInfo.name = "bookmark_info";
         this.addHudElement("bookmark_info",barInfo,this.mCanvasTopIconsGroup,false);
         return barInfo;
      }
      
      private function createProfilePanel() : ESprite
      {
         var s:ESprite = null;
         var sc:ESpriteContainer = null;
         sc = this.mViewFactory.getProfileInfoBasic(InstanceMng.getUserInfoMng().getCurrentProfileLoaded().getUserInfoObj());
         sc.setLayoutArea(this.mLayoutAreaFactoryTop.getArea("profile_basic"),true);
         this.addHudElement("profile_basic",sc,this.mCanvasTop,false);
         var layoutBG:ELayoutArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(this.mLayoutAreaFactoryTop.getArea("container_enemy"));
         layoutBG.x -= sc.getLayoutArea().x;
         layoutBG.y -= sc.getLayoutArea().y;
         s = this.mViewFactory.getEImage("tooltip_bkg",null,false,layoutBG);
         sc.eAddChildAt(s,0);
         sc.setContent("container_enemy",s);
         return s;
      }
      
      private function createLootingPanel() : ESprite
      {
         var hudLootInfo:EHudLootingInformation = new EHudLootingInformation();
         var role:int = InstanceMng.getFlowState().getCurrentRoleId();
         var mode:int = role == 2 ? 1 : 0;
         hudLootInfo.build(InstanceMng.getViewFactory(),null,InstanceMng.getUserInfoMng().getCurrentProfileLoaded().getUserInfoObj(),mode);
         hudLootInfo.setLayoutArea(this.mLayoutAreaFactoryTopSpying.getArea("container_enemy"),true);
         this.addHudElement("container_enemy",hudLootInfo,this.mCanvasTop,false);
         return hudLootInfo;
      }
      
      private function createTimeLeftPanel() : ESprite
      {
         var bkgLayoutArea:ELayoutArea = null;
         var areaBuyMore:EHudBuyTimeDropDown = null;
         var layoutAreaFactory:ELayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory("LayoutHudBattleTimer");
         var s:ESpriteContainer = this.mViewFactory.getESpriteContainer();
         var isReplay:* = InstanceMng.getFlowState().getCurrentRoleId() == 7;
         var isOwner:* = InstanceMng.getFlowState().getCurrentRoleId() == 0;
         if(isOwner || InstanceMng.getFlowStatePlanet().isTutorialRunning())
         {
            bkgLayoutArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(this.mLayoutAreaFactoryTopReplay.getArea("container_battle_npc"),1);
         }
         else
         {
            bkgLayoutArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layoutAreaFactory.getArea("container_battle"));
         }
         var bkg:EImage = this.mViewFactory.getEImage("hud_box",null,false,bkgLayoutArea);
         s.eAddChild(bkg);
         s.setContent("container_battle",bkg);
         var textAreaName:String = isReplay ? "container_timer" : "container_text_icon_xs";
         var text:ESpriteContainer;
         (text = this.mViewFactory.getContentIconWithTextHorizontal("IconTextXS","icon_clock",DCTextMng.convertTimeToStringColon(0),null,"text_title_3")).setLayoutArea(layoutAreaFactory.getArea(textAreaName),true);
         if(!isReplay)
         {
            text.logicLeft -= text.height;
         }
         s.eAddChild(text);
         s.setContent("container_timer",text);
         var speedBtn:EButton;
         (speedBtn = this.mViewFactory.getButtonImage("skin_ui_btn_speed",null,layoutAreaFactory.getArea("btn_speed"))).setLayoutArea(layoutAreaFactory.getArea("btn_speed"),true);
         speedBtn.eAddEventListener("click",this.onReplaySpeedClicked);
         s.eAddChild(speedBtn);
         s.setContent("btn_speed",speedBtn);
         this.mSpeedTextField = this.mViewFactory.getETextField(null,layoutAreaFactory.getTextArea("text_speed"));
         this.mSpeedTextField.logicLeft -= speedBtn.logicLeft;
         this.mSpeedTextField.logicTop -= speedBtn.logicTop;
         this.mSpeedTextField.applySkinProp(null,"text_title_3");
         speedBtn.eAddChild(this.mSpeedTextField);
         speedBtn.setContent("text",this.mSpeedTextField);
         if(!isReplay)
         {
            speedBtn.logicLeft += text.height * 0.25;
         }
         if(!isOwner && !InstanceMng.getFlowStatePlanet().isTutorialRunning())
         {
            this.mBattleEndButton = this.mViewFactory.getButton("btn_cancel",null,"S",DCTextMng.getText(583));
            this.mBattleEndButton.setLayoutArea(layoutAreaFactory.getArea("btn"),true);
            this.mBattleEndButton.eAddEventListener("click",this.onRetireButtonClicked);
            s.eAddChild(this.mBattleEndButton);
            s.setContent("btn",this.mBattleEndButton);
         }
         this.mBattleTimerField = text.getContentAsETextField("text");
         this.mBattleTimerField.setPivotLogicXY(0.5,0.5);
         this.mBattleTimerField.logicLeft += this.mBattleTimerField.pivotX;
         this.mBattleTimerField.logicTop += this.mBattleTimerField.pivotY;
         if(InstanceMng.getApplication().goToGetAttackMode() == 2)
         {
            text.logicLeft = bkgLayoutArea.getOriginalWidth() / 2 - text.getLogicWidth() / 2;
         }
         if(isReplay)
         {
            s.setLayoutArea(this.mLayoutAreaFactoryTopReplay.getArea("container_battle_timer"),true);
         }
         else if(isOwner || InstanceMng.getFlowStatePlanet().isTutorialRunning())
         {
            s.setLayoutArea(this.mLayoutAreaFactoryTopReplay.getArea("container_battle_npc"),true);
         }
         else
         {
            s.setLayoutArea(this.mLayoutAreaFactoryTopSpying.getArea("area_timer"),true);
         }
         this.addHudElement("area_timer",s,this.mCanvasTop,false);
         this.mCanvasTop.setChildIndex(s,2);
         if(Config.useBuyBattleTime())
         {
            areaBuyMore = new EHudBuyTimeDropDown();
            areaBuyMore.build(this.mViewFactory,this.mLayoutAreaFactoryTopSpying);
            areaBuyMore.close(false);
            this.addHudElement("area_buy_time",areaBuyMore,this.mCanvasTop,false);
         }
         return this.getHudElement("area_timer");
      }
      
      private function createHappeningWaveProgressBar() : ESprite
      {
         var bar:IconBar = new IconBar();
         bar.setup("IconBarL",0,0,"color_ko_bar","icon_enemy");
         this.addHudElement("HAPPENING_WAVE_PROGRESS",bar,this.mCanvasTop,false);
         bar.x = -190;
         bar.y = 100;
         return this.getHudElement("HAPPENING_WAVE_PROGRESS");
      }
      
      private function createChipsOfferCountdown() : ESprite
      {
         var s:ESprite = null;
         var chipsClockLayout:ELayoutArea = this.mLayoutAreaFactoryTop.getArea("container_icon_text_xs");
         var chipsClockContainer:ESpriteContainer = this.mViewFactory.getESpriteContainer();
         chipsClockContainer.eAddChild(s = this.mViewFactory.getEImage("box_negative",null,false,chipsClockLayout));
         chipsClockContainer.setContent("bkg",s);
         s = this.mViewFactory.getContentIconWithTextHorizontal("IconTextXS","icon_clock",DCTextMng.convertTimeToStringColon(0),null);
         chipsClockContainer.eAddChild(s);
         chipsClockContainer.setContent("clock",s);
         this.mChipsOfferTimerField = ESpriteContainer(s).getContent("text") as ETextField;
         this.mChipsOfferTimerField.width = this.mChipsOfferTimerField.textWithMarginWidth;
         this.mChipsOfferTimerField.applySkinProp(null,"text_title_3");
         this.mViewFactory.distributeSpritesInArea(chipsClockLayout,[s],1,1,-1,1,true);
         s.name = "container_icon_text_xs";
         chipsClockContainer.visible = false;
         this.addHudElement("container_icon_text_xs",chipsClockContainer,this.mCanvasTop,false);
         return chipsClockContainer;
      }
      
      private function createServerMaintenanceCountdown() : ESprite
      {
         var s:ESprite = null;
         var infoBtn:ESprite = null;
         var clockLayout:ELayoutArea = null;
         var clockContainer:ESpriteContainer = this.mViewFactory.getESpriteContainer();
         s = this.mViewFactory.getContentIconWithTextHorizontal("IconTextXS","icon_clock","X Minutes",null);
         s.name = "area_server_notification";
         clockContainer.eAddChild(s);
         clockContainer.setContent("clock",s);
         this.mServerMaintenanceTimerField = ESpriteContainer(s).getContent("text") as ETextField;
         this.mServerMaintenanceTimerField.applySkinProp(null,"text_title_3");
         this.mServerMaintenanceTimerField.width = this.mServerMaintenanceTimerField.textWithMarginWidth;
         infoBtn = this.mViewFactory.getButtonImage("btn_info",null);
         infoBtn.name = "infoButton";
         infoBtn.eAddEventListener("click",this.onServerMaintenanceCountdownClicked);
         clockContainer.eAddChild(infoBtn);
         clockContainer.setContent("infoButton",infoBtn);
         clockLayout = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(this.mViewFactory.getLayoutAreaFactory("IBtnM").getArea("base"));
         clockLayout.x = -530;
         clockLayout.y = 5;
         this.mViewFactory.distributeSpritesInArea(clockLayout,[s,infoBtn],1,1,-1,1,true);
         clockContainer.eAddChildAt(s = this.mViewFactory.getEImage("box_negative",null,false,clockLayout),0);
         clockContainer.setContent("bkg",s);
         clockContainer.visible = false;
         this.addHudElement("area_server_notification",clockContainer,this.mCanvasTop,false);
         return this.getHudElement("area_server_notification");
      }
      
      private function createContestToolButton() : ESprite
      {
         var btn:EButton = null;
         var s:ESprite = null;
         var iconAsset:String = "skin_icon_contest_tool";
         var happ:Happening = InstanceMng.getHappeningMng().getHappeningInHud();
         if(happ != null)
         {
            if(happ.getHappeningDef().getHudIcon())
            {
               iconAsset = happ.getHappeningDef().getHudIcon();
            }
         }
         btn = this.mViewFactory.getButtonIcon("btn_hud",iconAsset,null,this.mLayoutAreaFactoryLeft.getArea("btn_contest"));
         btn.name = "btn_contest";
         btn.visible = false;
         btn.eAddEventListener("click",this.onContestToolClicked);
         this.addHudElement("btn_contest",btn,this.mCanvasLeft,false);
         s = this.mViewFactory.getETextField(null,this.mLayoutAreaFactoryLeft.getTextArea("text_contest"),"text_title_0");
         s.name = "text_contest";
         s.mouseChildren = false;
         s.mouseEnabled = false;
         s.visible = false;
         this.addHudElement("text_contest",s,this.mCanvasLeft,false);
         return this.getHudElement("btn_contest");
      }
      
      private function createMissionsButton() : ESprite
      {
         var s:ESprite = null;
         this.mMissionsDropDown = new EHudMissionDropDownSprite();
         this.mMissionsDropDown.build();
         this.mMissionsDropDown.setCloseTimeMs(0);
         this.mMissionsDropDown.setLayoutArea(this.mLayoutAreaFactoryLeft.getArea("area_missions"),true);
         var btn:EButton = this.mViewFactory.getButtonIcon("btn_hud","skin_icon_missions",null,this.mLayoutAreaFactoryLeft.getArea("btn_missions"));
         btn.name = "btn_missions";
         s = this.mViewFactory.getNotificationArea(null,this.mLayoutAreaFactoryLeft.getArea("notification_area"));
         s.name = "notification_area";
         s.visible = false;
         var ddBtn:EDropDownButton = this.mViewFactory.getDropDownButton(btn,this.mMissionsDropDown);
         this.addHudElement("area_missions",this.mMissionsDropDown,this.mCanvasLeft,false);
         this.addHudElement("btn_missions",ddBtn,this.mCanvasLeft,false);
         this.addHudElement("notification_area",s,this.mCanvasLeft,false);
         return this.getHudElement("btn_missions");
      }
      
      private function createSpyCapsulesPanel() : ESprite
      {
         var layout:ELayoutArea = this.mLayoutAreaFactoryLeft.getArea("container_item");
         var result:ESpriteContainer = this.mViewFactory.getESpriteContainer();
         var bkg:EImage = this.mViewFactory.getEImage("generic_box",null,false,this.mLayoutAreaFactoryLeft.getArea("area_spy_tool"));
         result.eAddChild(bkg);
         result.setContent("area_spy_tool",bkg);
         var structure:ESpriteContainer;
         (structure = this.mViewFactory.getContainerItem("gift_spy_capsule","5")).setLayoutArea(layout,true);
         structure.eAddEventListener("click",this.onSpyCapsulesIconClicked);
         this.mViewFactory.setButtonBehaviors(structure);
         result.eAddChild(structure);
         result.setContent("container_item",structure);
         structure = this.mViewFactory.getContainerItem("gift_spy_capsule_advanced","5");
         layout = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layout);
         layout.x += 70;
         structure.setLayoutArea(layout,true);
         structure.eAddEventListener("click",this.onSpyCapsulesAdvancedIconClicked);
         this.mViewFactory.setButtonBehaviors(structure);
         result.eAddChild(structure);
         result.setContent("container_item_2",structure);
         var title:ETextField = this.mViewFactory.getETextField(null,this.mLayoutAreaFactoryLeft.getTextArea("text_title"),"text_title_0");
         title.setText(DCTextMng.getText(2495));
         result.eAddChild(title);
         result.setContent("text_title",title);
         var btn:EButton;
         (btn = this.mViewFactory.getButtonImage("btn_plus",null,this.mLayoutAreaFactoryLeft.getArea("btn_plus"))).eAddEventListener("click",this.onSpyCapsulesShopClicked);
         result.eAddChild(btn);
         result.setContent("btn_plus",btn);
         result.y -= 150;
         this.addHudElement("area_spy_tool",result,this.mCanvasLeft,false);
         return result;
      }
      
      private function createVisitorLeftPanel() : ESprite
      {
         var planets:ESpriteContainer = null;
         var counter:ESpriteContainer = null;
         var layoutArea:ELayoutArea = null;
         var image:EImage = null;
         var layoutAreaFactory:ELayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory("LayoutHudLeftVisiting");
         var userInfo:UserInfo = InstanceMng.getUserInfoMng().getCurrentProfileLoaded().getUserInfoObj();
         var content:ESpriteContainer = this.mViewFactory.getESpriteContainer();
         if(userInfo.getPlanetsAmount() > 1)
         {
            (planets = this.mViewFactory.getColoniesForVisitorHud(this.onColonyClick,userInfo,userInfo.getCurrentPlanet())).name = "colonies_visit_info";
         }
         if(InstanceMng.getUserInfoMng().getCurrentProfileLoaded().getUserInfoObj().isNeighbor())
         {
            (counter = this.mViewFactory.getContentIconWithTextHorizontal("IconTextS","skin_icon_friends","...",null,"text_title_3")).setLayoutArea(layoutAreaFactory.getArea("container_icon_text_s"),true);
            counter.name = "help_counter";
            if(planets)
            {
               planets.logicTop = counter.logicTop + counter.getLogicHeight();
            }
         }
         if(counter || planets)
         {
            layoutArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layoutAreaFactory.getArea("area_colonies"));
            if(planets)
            {
               layoutArea.width = Math.max(planets.getLogicWidth() + 2 * 8,layoutArea.width);
               layoutArea.height += planets.getLogicHeight();
            }
            image = this.mViewFactory.getEImage("hud_box",null,false,layoutArea);
            image.name = "area_colonies";
            this.addHudElement(image.name,image,content,false);
            if(counter)
            {
               this.addHudElement(counter.name,counter,content,false);
            }
            if(planets)
            {
               this.addHudElement(planets.name,planets,content,false);
            }
            this.addHudElement(content.name,content,this.mCanvasLeft,false);
         }
         return content;
      }
      
      private function createOfferButton() : ESprite
      {
         var s:ESprite = null;
         var btn:EButton = null;
         if(!InstanceMng.getApplication().isTutorialCompleted())
         {
            return null;
         }
         btn = this.mViewFactory.getButtonIcon("btn_hud","skin_icon_chip",null,this.mLayoutAreaFactoryRight.getArea("btn_chips"));
         btn.name = "btn_chips";
         btn.visible = true;
         s = this.mViewFactory.getEImage("skin_icon_arrow",null,false,this.mLayoutAreaFactoryRight.getArea("btn_arrow"));
         s.logicLeft -= this.mLayoutAreaFactoryRight.getArea("btn_chips").x;
         s.logicTop -= this.mLayoutAreaFactoryRight.getArea("btn_chips").y;
         btn.eAddChild(s);
         btn.setContent("arrow",s);
         this.mFreeChipsButtonOfferWall = this.mViewFactory.getButton("btn_hud",null,"XS",DCTextMng.getText(691),"icon_chip");
         this.mFreeChipsButtonOfferWall.eAddEventListener("click",this.onOfferWallClicked);
         this.mFreeChipsButtonVideoAds = this.mViewFactory.getButton("btn_hud",null,"XS",DCTextMng.getText(690),"icon_chip");
         this.mFreeChipsButtonVideoAds.eAddEventListener("click",this.onVideoAdsClicked);
         var boxes:Array = [this.mFreeChipsButtonOfferWall,this.mFreeChipsButtonVideoAds];
         var content:ESpriteContainer;
         (content = this.mViewFactory.getESpriteContainer()).setLayoutArea(this.mViewFactory.createMinimumLayoutArea(boxes,1),true);
         this.mViewFactory.distributeSpritesInArea(content.getLayoutArea(),boxes,0,0,1);
         content.eAddChild(this.mFreeChipsButtonOfferWall);
         content.eAddChild(this.mFreeChipsButtonVideoAds);
         content.setContent("offer_wall",this.mFreeChipsButtonOfferWall);
         content.setContent("video_ads",this.mFreeChipsButtonVideoAds);
         s = this.mViewFactory.getDropDownSprite(null,content,"LayoutHudEmptyDropDownArrowUp","down");
         s.logicX = btn.logicLeft + btn.getLogicWidth() / 2;
         s.logicY = btn.logicTop + btn.getLogicHeight();
         s.name = "area_free_chips";
         this.addHudElement(s.name,s,this.mCanvasRight,false);
         this.mFreeChipsDropDown = this.mViewFactory.getDropDownButton(btn,s as EDropDownSprite);
         this.addHudElement("btn_chips",this.mFreeChipsDropDown,this.mCanvasRight,false);
         this.mContentHolders["offer_wall"] = this.mFreeChipsButtonOfferWall;
         this.mContentHolders["video_ads"] = this.mFreeChipsButtonVideoAds;
         s = this.mViewFactory.getETextField(null,this.mLayoutAreaFactoryRight.getTextArea("text_free"),"text_title_0");
         (s as ETextField).setText(DCTextMng.getText(102));
         s.name = "text_free";
         s.mouseChildren = false;
         s.mouseEnabled = false;
         this.addHudElement("text_free",s,this.mCanvasRight,false);
         this.setVideoAdButtonVisible(false);
         this.setOfferWallButtonVisible(false);
         return this.getHudElement("btn_chips");
      }
      
      private function createDailyRewardButton() : ESprite
      {
         if(!InstanceMng.getApplication().isTutorialCompleted())
         {
            return null;
         }
         var buttonIcon:String = "icon_clock";
         if(InstanceMng.getDailyRewardMng().isClaimable())
         {
            buttonIcon = "gift_present";
         }
         this.mDailyRewardButton = this.mViewFactory.getButtonIcon("btn_hud",buttonIcon,null,this.mLayoutAreaFactoryRight.getArea("btn_chips"));
         this.mDailyRewardButton.eAddEventListener("click",this.onDailyRewardButtonClicked);
         this.addHudElement("btn_daily_reward",this.mDailyRewardButton,this.mCanvasRight,false);
         return this.getHudElement("btn_daily_reward");
      }
      
      private function createGeneralInfoButton() : ESprite
      {
         if(!InstanceMng.getApplication().isTutorialCompleted())
         {
            return null;
         }
         var layoutArea:ELayoutArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(this.mLayoutAreaFactoryRight.getArea("btn_chips"));
         layoutArea.y += 50;
         this.mSocialMediaButton = this.mViewFactory.getButtonIcon("btn_hud","icon_wishlist",null,layoutArea);
         this.mSocialMediaButton.eAddEventListener("click",this.onGeneralInfoButtonClicked);
         var notifLayoutArea:ELayoutArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(this.mLayoutAreaFactoryLeft.getArea("notification_area"));
         notifLayoutArea.x = layoutArea.x - 5;
         notifLayoutArea.y = layoutArea.y - 5;
         var s:ESprite = this.mViewFactory.getNotificationArea(null,notifLayoutArea);
         s.visible = false;
         this.addHudElement("btn_general_info",this.mSocialMediaButton,this.mCanvasRight,false);
         this.addHudElement("general_info_notification",s,this.mCanvasRight,false);
         InstanceMng.getUserDataMng().requestTask(UserDataMng.KEY_POLL);
         return this.getHudElement("btn_general_info");
      }
      
      private function createDebugButtons() : void
      {
         var i:int = 0;
         var btn:EButton = null;
         var originalLayoutArea:ELayoutArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(this.mLayoutAreaFactoryRight.getArea("btn_chips"));
         var layoutArea:ELayoutArea = null;
         for(i = 0; i < 6; )
         {
            layoutArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(originalLayoutArea);
            layoutArea.y += 50 * (i + 2);
            btn = this.mViewFactory.getButtonIcon("btn_hud","icon_mission_spy",null,layoutArea);
            btn.eAddEventListener("click",this.onDebugButtonClicked);
            this.addHudElement("debug-" + i,btn,this.mCanvasRight,true);
            i++;
         }
      }
      
      private function createCollectionPanels() : ESprite
      {
         var returnValue:EHudCollectionPanel = null;
         returnValue = new EHudCollectionPanel(this.mViewFactory,3);
         returnValue.layoutApplyTransformations(this.mLayoutAreaFactoryRight.getArea("area_0"));
         this.addHudElement("CollectionWorker",returnValue,this.mCanvasRight,false);
         returnValue = new EHudCollectionPanel(this.mViewFactory,4);
         returnValue.layoutApplyTransformations(this.mLayoutAreaFactoryRight.getArea("area_1"));
         this.addHudElement("CollectionCrafting",returnValue,this.mCanvasRight,false);
         returnValue = new EHudCollectionPanel(this.mViewFactory,5);
         returnValue.layoutApplyTransformations(this.mLayoutAreaFactoryRight.getArea("area_2"));
         this.addHudElement("CollectionCollection",returnValue,this.mCanvasRight,false);
         return returnValue;
      }
      
      override protected function unbuildDo() : void
      {
         var i:EHudMissionIcon = null;
         var id:* = null;
         this.mPurchaseShopsIsBlinking = null;
         if(this.mMissionsDropDown)
         {
            this.mMissionsDropDown.resetContent();
         }
         for each(i in this.mMissionsDropDownIcons)
         {
            i.destroy();
         }
         this.mMissionsDropDownIcons.length = 0;
         for(id in this.mContentHolders)
         {
            this.mContentHolders[id].destroy();
            delete this.mContentHolders[id];
         }
         this.mCanvasLeft.destroy();
         this.mCanvasTop.destroy();
         this.mCanvasTopIconsGroup.destroy();
         this.mCanvasRight.destroy();
         this.destroyESprite(this.mUpperBlackStrips);
         this.mUpperBlackStrips = null;
         this.destroyESprite(this.mLowerBlackStrips);
         this.mLowerBlackStrips = null;
         this.mMissionsDropDown = null;
         this.mChipsOfferTimerField = null;
         this.mBattleTimerField = null;
         this.mSpeedTextField = null;
         this.mBattleEndButton = null;
         this.mFreeChipsDropDown = null;
         this.mFreeChipsButtonOfferWall = null;
         this.mFreeChipsButtonVideoAds = null;
         this.mCanvasLeft = null;
         this.mCanvasLeft = null;
         this.mCanvasTopIconsGroup = null;
         this.mCanvasLeft = null;
      }
      
      override protected function beginDo() : void
      {
         MessageCenter.getInstance().registerObject(this);
         this.mDropDownsRepositioned = false;
         this.mCurrentLootCoins = 0;
         this.mCurrentLootMinerals = 0;
         if(this.getHudElement("bookmark_input"))
         {
            MessageCenter.getInstance().registerObject(this.getHudElement("bookmark_input") as INotifyReceiver);
         }
         InstanceMng.getViewMngGame().addESpriteToLayer(this.mCanvasLeft,InstanceMng.getViewMngGame().getHudLayerSku(),1);
         InstanceMng.getViewMngGame().addESpriteToLayer(this.mCanvasRight,InstanceMng.getViewMngGame().getHudLayerSku(),3);
         InstanceMng.getViewMngGame().addESpriteToLayer(this.mCanvasTop,InstanceMng.getViewMngGame().getHudLayerSku(),2);
         InstanceMng.getViewMngGame().addESpriteToLayer(this.mFeedbackText,InstanceMng.getViewMngGame().getHudLayerSku(),5);
         if(this.mMissionsDropDown)
         {
            this.mMissionsDropDown.close(false);
         }
         if(this.getHudElement("container_enemy"))
         {
            EHudLootingInformation(this.getHudElement("container_enemy")).setLootingInfo(InstanceMng.getWorld());
         }
         this.refreshBookmarkButtonsVisibility();
         this.updateProfile();
         this.updateSpyCapsules();
         this.setReplaySpeed(1);
         if(!InstanceMng.getApplication().isTutorialCompleted() && InstanceMng.getFlowStatePlanet().getCurrentRoleId() == 5 && !InstanceMng.getFlowStatePlanet().isPlayerIsBackFromVisiting())
         {
            this.hideHudGroup("HudTopIcons",false);
            this.hideHudGroup("HudLeft",false);
            this.hideHudGroup("HudRight",false);
         }
      }
      
      override protected function endDo() : void
      {
         MessageCenter.getInstance().unregisterObject(this);
         if(this.getHudElement("bookmark_input"))
         {
            MessageCenter.getInstance().unregisterObject(this.getHudElement("bookmark_input") as INotifyReceiver);
         }
         InstanceMng.getViewMngGame().removeESpriteFromLayer(this.mCanvasTop,InstanceMng.getViewMngGame().getHudLayerSku());
         InstanceMng.getViewMngGame().removeESpriteFromLayer(this.mCanvasLeft,InstanceMng.getViewMngGame().getHudLayerSku());
         InstanceMng.getViewMngGame().removeESpriteFromLayer(this.mCanvasRight,InstanceMng.getViewMngGame().getHudLayerSku());
         if(this.mMissionsDropDown)
         {
            this.mMissionsDropDown.close(false);
         }
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var i:int = 0;
         var s:ESprite = null;
         var icon:EHudMissionIcon = null;
         var profile:Profile = null;
         var timeLeft:Number = NaN;
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
         if(this.mFeedbackText != null)
         {
            this.mFeedbackText.logicUpdate(dt);
         }
         var missionsCleaned:Boolean = false;
         for(i = this.mMissionsDropDownIcons.length - 1; i >= 0; )
         {
            (icon = this.mMissionsDropDownIcons[i]).logicUpdate(dt);
            if(!icon.getMissionSku())
            {
               this.mMissionsDropDown.removeContent(icon);
               this.mMissionsDropDownIcons.splice(i,1);
               missionsCleaned = true;
            }
            i--;
         }
         if(missionsCleaned)
         {
            this.missionsReposition();
         }
         if(!InstanceMng.getMissionsMng().areMissionsHidden())
         {
            if(this.mMissionsDropDownIcons.length)
            {
               this.missionsShowAll();
            }
            else
            {
               this.missionsHideAll();
            }
         }
         if(this.mChipsOfferTimerField != null && this.getHudElement("container_icon_text_xs"))
         {
            if(this.getHudElement("container_icon_text_xs").visible)
            {
               this.mChipsOfferTimerField.setText(InstanceMng.getCustomizerMng().getOfferTimeLeft());
            }
         }
         if(this.mServerMaintenanceTimerField != null && this.getHudElement("area_server_notification"))
         {
            if(this.getHudElement("area_server_notification").visible)
            {
               this.mServerMaintenanceTimerField.setText(DCTextMng.convertTimeToStringShortened(InstanceMng.getUserInfoMng().getProfileLogin().getMaintenanceEnabledTimestamp() - InstanceMng.getUserDataMng().getServerCurrentTimemillis()));
            }
         }
         var iconBar:IconBar;
         if((iconBar = this.getHudElement("shield") as IconBar) && iconBar.visible)
         {
            profile = InstanceMng.getUserInfoMng().getProfileLogin();
            if((timeLeft = profile.getProtectionTimeLeft()) > 0)
            {
               iconBar.updateText(this.getProtectionTimeForHud());
            }
            else
            {
               iconBar.updateText(this.getProtectionTimeForHud(),"text_negative");
            }
         }
         if(InstanceMng.getFlowState().getCurrentRole().mId == 3)
         {
            this.battleLogicUpdate(dt);
         }
         this.updateSpyCapsules();
         if(!this.mDropDownsRepositioned)
         {
            elements = ["btn_chips"];
            for each(element in elements)
            {
               if(this.getHudElement(element) && this.getHudElement(element) as EDropDownButton)
               {
                  lastLeft = (sc = (this.getHudElement(element) as EDropDownButton).getDropDown()).logicLeft;
                  InstanceMng.getViewFactory().arrangeToFitInMinimumScreen(sc,true);
                  diff = sc.logicLeft - lastLeft;
                  sc.getContent("arrow").logicX = sc.getContent("arrow").logicX - diff;
               }
            }
            this.mDropDownsRepositioned = true;
         }
      }
      
      public function removeHudElement(cbox:String) : void
      {
         if(this.getHudElement(cbox) != null)
         {
            this.getHudElement(cbox).visible = false;
         }
      }
      
      public function setWarHUD(npcAttack:Boolean = false) : void
      {
         if(npcAttack && InstanceMng.getFlowStatePlanet().isTutorialRunning())
         {
            return;
         }
         this.showHudElements(GROUP_BATTLE_ELEMENTS_LIST);
         this.getHudElement("HAPPENING_WAVE_PROGRESS").visible = InstanceMng.getUnitScene().battleHasHappeningProgressBar();
      }
      
      public function loadPlayerPhotos() : void
      {
         var areaProfile:EHudLootingInformation = this.getHudElement("container_enemy") as EHudLootingInformation;
         if(areaProfile)
         {
            if(InstanceMng.getFlowState().getCurrentRoleId() == 3)
            {
               areaProfile.setUserInfo(InstanceMng.getUserInfoMng().getAttacked());
            }
            else
            {
               areaProfile.setUserInfo(InstanceMng.getUserInfoMng().getAttacker());
            }
         }
      }
      
      public function setReplayIndex(value:int) : void
      {
         this.mCurrentReplayIndex = value;
      }
      
      public function setStarHUD() : void
      {
         this.switchTopIconsTopGroup(GROUP_STAR_HUD_ICONS_LIST);
         this.hideHudElements(GROUP_BATTLE_ELEMENTS_LIST);
      }
      
      public function setNormalHUD() : void
      {
         this.switchTopIconsTopGroup(GROUP_NORMAL_HUD_ICONS_LIST);
         this.hideHudElements(GROUP_BATTLE_ELEMENTS_LIST);
      }
      
      public function setGalaxyMapHUD() : void
      {
         this.switchTopIconsTopGroup(GROUP_GALAXY_MAP_HUD_ICONS_LIST);
         this.hideHudElements(GROUP_BATTLE_ELEMENTS_LIST);
      }
      
      public function setSpyingHUD() : void
      {
         this.switchTopIconsTopGroup(GROUP_SPYING_HUD_ICONS_LIST);
         this.showHudElements(GROUP_BATTLE_ELEMENTS_LIST);
      }
      
      public function setVisitingHUD(isNeighbor:Boolean) : void
      {
         this.switchTopIconsTopGroup(GROUP_VISITING_HUD_ICONS_LIST);
         this.hideHudElements(GROUP_BATTLE_ELEMENTS_LIST);
      }
      
      public function setAttackingHUD() : void
      {
         this.switchTopIconsTopGroup(GROUP_ATTACKING_HUD_ICONS_LIST);
         this.showHudElements(GROUP_BATTLE_ELEMENTS_LIST);
      }
      
      public function setReplayHUD() : void
      {
         this.showHudElements(GROUP_BATTLE_ELEMENTS_LIST);
      }
      
      override public function moveDisappearUpToDown(numSeconds:Number = 0.5) : void
      {
         this.hideHudElements(GROUP_NORMAL_HUD_HIDE_ON_HOTKEY_LIST);
         this.hideHudElements(GROUP_NORMAL_HUD_HIDE_ON_HOTKEY_CONTEST_TOOL_LIST);
      }
      
      override public function moveAppearDownToUp(numSeconds:Number = 0.5) : void
      {
         this.showHudElements(GROUP_NORMAL_HUD_HIDE_ON_HOTKEY_LIST);
         if(InstanceMng.getHappeningMng().getHappeningInHud() != null || InstanceMng.getContestMng().getRunningTimeLeft() > 0)
         {
            this.showHudElements(GROUP_NORMAL_HUD_HIDE_ON_HOTKEY_CONTEST_TOOL_LIST);
         }
      }
      
      private function switchTopIconsTopGroup(array:Array) : void
      {
         var i:int = 0;
         var id:String = null;
         for(i = 0; i < HUD_GROUP_TOP.length; )
         {
            if(this.getHudElement(HUD_GROUP_TOP[i]))
            {
               this.getHudElement(HUD_GROUP_TOP[i]).visible = false;
            }
            i++;
         }
         var boxes:Array = [];
         for each(id in array)
         {
            if(this.getHudElement(id))
            {
               boxes.push(this.getHudElement(id));
               this.getHudElement(id).visible = true;
            }
         }
         InstanceMng.getViewFactory().distributeSpritesInArea(this.mCanvasTopIconsGroup.getLayoutArea(),boxes,1,1,-1,1,false);
      }
      
      public function refreshGoToCoordsTextfields(coords:DCCoordinate) : void
      {
         var navigationBar:EHudNavigationBar = this.getHudElement("bookmark_input") as EHudNavigationBar;
         if(navigationBar && coords)
         {
            navigationBar.setXCoord(coords.x);
            navigationBar.setYCoord(coords.y);
         }
      }
      
      public function setHudCash(cash:Number) : void
      {
         var cashText:String = null;
         var textPropSku:String = null;
         var iconBar:IconBar = this.getHudElement("gold") as IconBar;
         if(iconBar)
         {
            cashText = DCTextMng.convertNumberToString(cash - Particle.smGiftCashOffset,-1,-1);
            textPropSku = String(cash - Particle.smGiftCashOffset > 0 ? null : "text_negative");
            iconBar.updateText(cashText,textPropSku);
         }
      }
      
      public function setWarBootyBarsValues(changeLootText:Boolean = false) : void
      {
         var content:ESprite;
         if(!(content = this.getHudElement("container_enemy")))
         {
            return;
         }
         var tutoRunning:Boolean = InstanceMng.getFlowStatePlanet().isTutorialRunning();
         var npcAttack:Boolean = InstanceMng.getUnitScene().battleIsANPCAttack();
         content.visible = !tutoRunning || tutoRunning && !npcAttack;
      }
      
      private function updateProfile() : void
      {
         var buttonIcon:String = null;
         var textPropSku:String = null;
         var value:Number = NaN;
         var defending:* = InstanceMng.getFlowStatePlanet().getCurrentRoleId() == 0;
         var profile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         var currentLevelDef:LevelScoreDef = InstanceMng.getLevelScoreDefMng().getDefBySku(profile.getLevel().toString()) as LevelScoreDef;
         var iconBar:IconBar = this.getHudElement("experience") as IconBar;
         if(iconBar)
         {
            iconBar.setBarMaxValue(currentLevelDef.getMaxXp() - currentLevelDef.getMinXp());
            iconBar.setBarCurrentValue(profile.getScore() - currentLevelDef.getMinXp());
            iconBar.updateText(DCTextMng.convertNumberToString(profile.getLevel(),-1,-1),"text_score");
         }
         iconBar = this.getHudElement("coins") as IconBar;
         if(iconBar)
         {
            value = Math.min(profile.getCoinsCapacity(),profile.getCoins() + this.mCurrentLootCoins);
            if(defending)
            {
               value -= this.mCurrentLootCoins;
            }
            iconBar.setBarCurrentValue(value);
            iconBar.setBarMaxValue(profile.getCoinsCapacity());
            textPropSku = !!value ? "text_coins" : "text_negative";
            iconBar.updateText(DCTextMng.convertNumberToString(value,-1,-1),textPropSku);
         }
         iconBar = this.getHudElement("minerals") as IconBar;
         if(iconBar)
         {
            value = Math.min(profile.getMineralsCapacity(),profile.getMinerals() + this.mCurrentLootMinerals);
            if(defending)
            {
               value -= this.mCurrentLootMinerals;
            }
            iconBar.setBarCurrentValue(value);
            iconBar.setBarMaxValue(profile.getMineralsCapacity());
            textPropSku = !!value ? "text_minerals" : "text_negative";
            iconBar.updateText(DCTextMng.convertNumberToString(value,-1,-1),textPropSku);
         }
         this.setHudCash(profile.getCash());
         iconBar = this.getHudElement("droids") as IconBar;
         if(iconBar)
         {
            iconBar.setBarMaxValue(profile.getMaxDroidsAmount());
            iconBar.setBarCurrentValue(0);
            iconBar.updateText(profile.getDroids() + "/" + profile.getMaxDroidsAmount());
         }
         var btn:EButton;
         if(btn = this.getHudElement("btn_daily_reward") as EButton)
         {
            buttonIcon = "icon_clock";
            if(InstanceMng.getDailyRewardMng().isClaimable())
            {
               buttonIcon = "gift_present";
            }
            btn.setIcon(this.mViewFactory.getEImage(buttonIcon,null,false));
         }
      }
      
      private function updateSpyCapsules() : void
      {
         var tf:ETextField = null;
         var previousAmount:int = 0;
         var capsulesAmount:int = 0;
         var container:ESpriteContainer = this.getHudElement("area_spy_tool") as ESpriteContainer;
         if(container)
         {
            tf = container.getContentAsESpriteContainer("container_item").getContentAsETextField("text");
            previousAmount = parseInt(tf.getText().slice(1));
            capsulesAmount = InstanceMng.getItemsMng().getSpyCapsules(0);
            tf.setText("x" + capsulesAmount);
            if(capsulesAmount && !previousAmount)
            {
               tf.unapplySkinProp(null,"text_negative");
            }
            else if(!capsulesAmount && previousAmount)
            {
               tf.applySkinProp(null,"text_negative");
            }
            tf = container.getContentAsESpriteContainer("container_item_2").getContentAsETextField("text");
            previousAmount = parseInt(tf.getText().slice(1));
            capsulesAmount = InstanceMng.getItemsMng().getSpyCapsules(1);
            tf.setText("x" + capsulesAmount);
            if(capsulesAmount && !previousAmount)
            {
               tf.unapplySkinProp(null,"text_negative");
            }
            else if(!capsulesAmount && previousAmount)
            {
               tf.applySkinProp(null,"text_negative");
            }
         }
      }
      
      private function getProtectionTimeForHud() : String
      {
         var numberOfUnits:int = 0;
         var useDays:* = false;
         var useHours:* = false;
         var useMinutes:* = false;
         var useSeconds:* = false;
         var result:String = null;
         var timeLeft:Number;
         var profile:Profile;
         if((timeLeft = (profile = InstanceMng.getUserInfoMng().getProfileLogin()).getProtectionTimeLeft()) > 0)
         {
            numberOfUnits = 0;
            useDays = timeLeft >= 86400000;
            useHours = timeLeft >= 3600000;
            useMinutes = !useDays;
            for each(var unit in [useDays,useHours,useMinutes])
            {
               if(unit)
               {
                  numberOfUnits++;
               }
            }
            useSeconds = numberOfUnits < 2;
            result = DCTextMng.getStringFromTime(timeLeft,useDays,useHours,useMinutes,useSeconds);
         }
         else
         {
            result = DCTextMng.getText(683);
         }
         return result;
      }
      
      override public function onResize(stageWidth:int, stageHeight:int) : void
      {
         if(this.mUpperBlackStrips)
         {
            this.mUpperBlackStrips.width = stageWidth;
         }
         if(this.mLowerBlackStrips)
         {
            this.mLowerBlackStrips.width = stageWidth;
            this.mLowerBlackStrips.logicY = stageHeight;
         }
      }
      
      public function getHudElement(id:String) : ESprite
      {
         return this.mContentHolders[id];
      }
      
      private function addHudElement(id:String, s:ESprite, where:ESpriteContainer, addMouseOverBehaviours:Boolean) : void
      {
         s.name = id;
         if(addMouseOverBehaviours)
         {
            s.eAddEventBehavior("rollOver",InstanceMng.getBehaviorsMng().getMouseBehavior("MouseOverButton"));
            s.eAddEventBehavior("rollOut",InstanceMng.getBehaviorsMng().getMouseBehavior("MouseOutButton"));
         }
         s.eAddEventListener("rollOver",uiEnable);
         s.eAddEventListener("rollOut",uiDisable);
         if(where == null)
         {
            where = this.mCanvasTop;
         }
         where.eAddChild(s);
         this.mContentHolders[id] = s;
      }
      
      private function hideHudGroup(groupID:String, animated:Boolean = true) : void
      {
         var values:Object = null;
         var tween:GTween = null;
         var target:ESprite = this.getHudElement(groupID);
         if(!target || this.mHiddenGroups.lastIndexOf(groupID) > -1 || this.mTransitionGroups.lastIndexOf(groupID) > -1)
         {
            return;
         }
         switch(groupID)
         {
            case "HudTopIcons":
               values = {"pivotLogicY":target.pivotLogicY + 1};
               break;
            case "HudLeft":
               values = {"logicLeft":target.logicLeft - 150};
               break;
            case "HudRight":
               values = {"logicLeft":target.logicLeft + 150};
               break;
            case "HudOptions":
               values = {"x":target.x + 200};
         }
         if(values)
         {
            tween = new GTween(target,1.5,values);
            tween.onComplete = this.onAddThisToHidden;
            tween.autoPlay = true;
            tween.onChange = function(tween:GTween):void
            {
            };
            if(!animated)
            {
               tween.end();
            }
         }
         this.mTransitionGroups.push(groupID);
      }
      
      private function showHudGroup(groupID:String, animated:Boolean = true) : void
      {
         var values:Object = null;
         var tween:GTween = null;
         var idx:int = this.mHiddenGroups.lastIndexOf(groupID);
         var target:ESprite;
         if(!(target = this.getHudElement(groupID)) || idx == -1)
         {
            return;
         }
         switch(groupID)
         {
            case "HudTopIcons":
               values = {"pivotLogicY":target.pivotLogicY - 1};
               break;
            case "HudLeft":
               values = {"logicLeft":target.logicLeft + 150};
               break;
            case "HudRight":
               values = {"logicLeft":target.logicLeft - 150};
               break;
            case "HudOptions":
               values = {"x":target.logicTop - 200};
         }
         if(values)
         {
            tween = new GTween(target,1.5,values);
            tween.onComplete = this.onRemoveThisFromHidden;
            tween.autoPlay = true;
            if(!animated)
            {
               tween.end();
            }
         }
         this.mTransitionGroups.push(groupID);
         this.mHiddenGroups.splice(idx,1);
      }
      
      public function showHudElement(elementID:String) : void
      {
         if(this.getHudElement(elementID))
         {
            this.getHudElement(elementID).visible = true;
         }
      }
      
      public function hideHudElement(elementID:String) : void
      {
         if(this.getHudElement(elementID))
         {
            this.getHudElement(elementID).visible = false;
         }
      }
      
      private function hideHudElements(elements:Array) : void
      {
         var s:String = null;
         for each(s in elements)
         {
            this.hideHudElement(s);
         }
      }
      
      private function showHudElements(elements:Array) : void
      {
         var s:String = null;
         for each(s in elements)
         {
            this.showHudElement(s);
         }
      }
      
      public function setContestToolButtonUsage(usage:String) : void
      {
         this.mContestToolUsage = usage;
      }
      
      public function updateContestToolButtonIcon() : void
      {
         var btn:EButton = null;
         var btnIcon:String = null;
         var happ:Happening = null;
         if(this.getHudElement("btn_contest"))
         {
            btn = this.getHudElement("btn_contest") as EButton;
            happ = InstanceMng.getHappeningMng().getHappeningInHud();
            if(happ != null)
            {
               btnIcon = happ.getHappeningDef().getHudIcon();
            }
            else if(InstanceMng.getContestMng().needsToShowIcon())
            {
               btnIcon = InstanceMng.getContestMng().getHudIcon();
            }
            if(btnIcon)
            {
               btn.setIcon(this.mViewFactory.getEImage(btnIcon,null,false));
            }
            else
            {
               btn.setIcon(this.mViewFactory.getEImage("skin_icon_contest_tool",null,false));
            }
         }
      }
      
      public function cheatsTimeIsEnabled() : Boolean
      {
         return false;
      }
      
      override public function addMouseEvents() : void
      {
         var name:String = null;
         var s:ESprite = null;
         for each(name in HUD_GROUP_LEFT.concat(HUD_GROUP_TOP))
         {
            s = this.mContentHolders[name];
            if(s)
            {
               s.mouseChildren = true;
               s.mouseEnabled = true;
            }
         }
      }
      
      override public function removeMouseEvents() : void
      {
         var name:String = null;
         var s:ESprite = null;
         for each(name in HUD_GROUP_LEFT.concat(HUD_GROUP_TOP))
         {
            s = this.mContentHolders[name];
            if(s)
            {
               s.mouseChildren = false;
               s.mouseEnabled = false;
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
               s.mouseChildren = false;
               s.mouseEnabled = false;
            }
         }
      }
      
      override public function lock() : void
      {
         super.lock();
         this.removeMouseEvents();
      }
      
      public function setContestToolTip(str:String) : void
      {
         if(this.getHudElement("text_contest"))
         {
            (this.getHudElement("text_contest") as ETextField).setText(str);
         }
      }
      
      public function refreshVisibilityOfferButton() : void
      {
         var showFreeOffers:Boolean = InstanceMng.getSettingsDefMng().mSettingsDef.getShowFreeOffers();
         var useOffers:Boolean = Config.useOfferInHUD();
         var newPayerPromo:Boolean = InstanceMng.getUserInfoMng().getProfileLogin().getShowOfferNewPayerPromo();
         var tutoEnd:Boolean = InstanceMng.getApplication().isTutorialCompleted();
         var battleRunning:Boolean = InstanceMng.getUnitScene().battleIsRunning();
         this.setOfferWallButtonVisible(tutoEnd && battleRunning == false && (showFreeOffers || useOffers && newPayerPromo));
      }
      
      public function setVideoAdButtonVisible(enabled:Boolean) : void
      {
         if(this.mFreeChipsButtonVideoAds && enabled != this.mFreeChipsButtonVideoAds.visible)
         {
            this.mFreeChipsButtonVideoAds.visible = enabled;
            if(enabled)
            {
               this.mFreeChipsDropDown.visible = true;
               this.getHudElement("text_free").visible = true;
            }
            else if(!(this.mFreeChipsButtonOfferWall.visible || this.mFreeChipsButtonVideoAds.visible))
            {
               this.mFreeChipsDropDown.visible = false;
               this.getHudElement("text_free").visible = false;
            }
         }
      }
      
      public function setOfferWallButtonVisible(enabled:Boolean) : void
      {
         if(this.getHudElement("text_free") && this.mFreeChipsButtonOfferWall && enabled != this.mFreeChipsButtonOfferWall.visible)
         {
            this.mFreeChipsButtonOfferWall.visible = enabled;
            if(enabled)
            {
               this.mFreeChipsDropDown.visible = true;
               this.getHudElement("text_free").visible = true;
            }
            else if(!(this.mFreeChipsButtonOfferWall.visible || this.mFreeChipsButtonVideoAds.visible))
            {
               this.mFreeChipsDropDown.visible = false;
               this.getHudElement("text_free").visible = false;
            }
         }
      }
      
      public function setChipsOfferTimerVisible(enabled:Boolean) : void
      {
         if(this.getHudElement("container_icon_text_xs"))
         {
            if(enabled != this.getHudElement("container_icon_text_xs").visible)
            {
               this.getHudElement("container_icon_text_xs").visible = enabled;
            }
         }
      }
      
      public function setServerMaintenanceTimerVisible(enabled:Boolean) : void
      {
         if(this.getHudElement("area_server_notification"))
         {
            if(enabled != this.getHudElement("area_server_notification").visible)
            {
               this.getHudElement("area_server_notification").visible = enabled;
            }
         }
      }
      
      public function disableBattleEndButton() : void
      {
         if(this.mBattleEndButton)
         {
            this.mBattleEndButton.setIsEnabled(false);
         }
      }
      
      public function enableBattleEndButton() : void
      {
         if(this.mBattleEndButton)
         {
            this.mBattleEndButton.setIsEnabled(true);
         }
      }
      
      public function battleLockMenuClockButtons() : void
      {
         this.disableBattleEndButton();
      }
      
      public function battleSetMenuClockMode(mode:int) : void
      {
         this.battleChangeState(mode);
      }
      
      private function battleGetState() : int
      {
         return this.mBattleState;
      }
      
      private function battleChangeState(mode:int) : void
      {
         var toolSpy:ToolSpy = null;
         switch(mode)
         {
            case 0:
               this.hideHudElement("area_spy_tool");
               if(InstanceMng.getToolsMng().getPreviousToolId() == 10)
               {
                  InstanceMng.getToolsMng().setPreviousTool(0);
               }
               if(InstanceMng.getToolsMng().getCurrentToolId() == 10)
               {
                  InstanceMng.getToolsMng().setTool(0);
               }
               toolSpy = InstanceMng.getToolsMng().getTool(10) as ToolSpy;
               toolSpy.removeAllCapsulesFromStage();
               if(this.mBattleState != 5 && this.getHudElement("container_enemy") as EHudLootingInformation)
               {
                  (this.getHudElement("container_enemy") as EHudLootingInformation).setMode(0);
                  (this.getHudElement("container_enemy") as EHudLootingInformation).setLootingInfo(InstanceMng.getWorld());
               }
               if(this.mBattleEndButton)
               {
                  this.mBattleEndButton.setText(DCTextMng.getText(576));
                  this.mBattleEndButton.setIsEnabled(true);
               }
               MessageCenter.getInstance().sendMessage("hideNextTargetPanel");
               break;
            case 1:
               if(this.mBattleEndButton)
               {
                  this.mBattleEndButton.setText(DCTextMng.getText(584));
               }
               (this.getHudElement("container_enemy") as EHudLootingInformation).setMode(1);
               (this.getHudElement("container_enemy") as EHudLootingInformation).setLootingInfo(InstanceMng.getWorld());
               break;
            case 2:
               if(this.mBattleTimerField)
               {
                  this.mBattleTimerField.setText(DCTextMng.getText(329));
               }
               if(this.mBattleEndButton)
               {
                  this.mBattleEndButton.setIsEnabled(false);
               }
               MessageCenter.getInstance().sendMessage("hideNextTargetPanel");
               break;
            case 3:
               (this.getHudElement("container_enemy") as EHudLootingInformation).setMode(0);
               (this.getHudElement("container_enemy") as EHudLootingInformation).setLootingInfo(InstanceMng.getWorld());
               if(this.mBattleEndButton)
               {
                  this.mBattleEndButton.setText(DCTextMng.getText(576));
                  this.mBattleEndButton.setIsEnabled(false);
               }
               MessageCenter.getInstance().sendMessage("hideNextTargetPanel");
               break;
            case 4:
               if(this.mBattleTimerField)
               {
                  this.mBattleTimerField.unapplySkinProp(null,"text_title_3");
                  this.mBattleTimerField.applySkinProp(null,"text_light_negative");
               }
               break;
            case 5:
               if(this.mBattleTimerField)
               {
                  this.mBattleTimerField.unapplySkinProp(null,"text_light_negative");
                  this.mBattleTimerField.applySkinProp(null,"text_title_3");
                  this.mBattleTimerField.scaleLogicX = this.mBattleTimerField.scaleLogicY = 1;
               }
               if(this.getHudElement("area_buy_time"))
               {
                  (this.getHudElement("area_buy_time") as EHudBuyTimeDropDown).close(true);
               }
         }
         this.mBattleState = mode;
      }
      
      public function battleSetTimeLeft(timeLeftMS:int) : void
      {
         this.mBattleTimeLeftMs = timeLeftMS;
         if(this.mBattleTimerField)
         {
            this.mBattleTimerField.setText(DCTextMng.convertTimeToStringColon(timeLeftMS));
         }
      }
      
      public function battleEnd() : void
      {
         if(this.mBattleExtraTimeDefs)
         {
            this.mBattleExtraTimeDefs = null;
         }
      }
      
      public function battleExtraTimeBought(extraBattleTimeBought:Number) : void
      {
         this.mBattleTimeLeftMs += extraBattleTimeBought;
         this.battleChangeState(5);
      }
      
      public function battleSetLootCoins(value:int) : void
      {
         var iconBar:IconBar = null;
         var textPropSku:String = null;
         var profile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         var lootingPanel:EHudLootingInformation;
         (lootingPanel = this.getHudElement("container_enemy") as EHudLootingInformation).setCoins(value);
         this.mCurrentLootCoins = value;
      }
      
      public function battleSetLootMinerals(value:int) : void
      {
         var iconBar:IconBar = null;
         var textPropSku:String = null;
         var profile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         var lootingPanel:EHudLootingInformation;
         (lootingPanel = this.getHudElement("container_enemy") as EHudLootingInformation).setMinerals(value);
         this.mCurrentLootMinerals = value;
      }
      
      public function battleSetLootScore(value:int) : void
      {
         var lootingPanel:EHudLootingInformation = this.getHudElement("container_enemy") as EHudLootingInformation;
         lootingPanel.setScore(value);
      }
      
      private function battleLogicUpdate(dt:int) : void
      {
         var area:EHudBuyTimeDropDown = null;
         var scale:Number = NaN;
         var battleState:int = this.battleGetState();
         if(!this.mBattleExtraTimeDefs)
         {
            this.mBattleExtraTimeDefs = InstanceMng.getItemsMng().getArrayVectorForSpecialAttacks("showInTopBar");
         }
         else if(battleState == 0)
         {
            if(Config.useBuyBattleTime() && this.mBattleTimeLeftMs < (InstanceMng.getSettingsDefMng().getExtraBattleTimeTrigger() - 1) * 1000 && this.mBattleTimeLeftMs > 0 && InstanceMng.getUnitScene().battleCanBuyExtraBattleTime() && this.mBattleExtraTimeDefs.length)
            {
               this.battleChangeState(4);
               if(this.getHudElement("area_buy_time"))
               {
                  area = this.getHudElement("area_buy_time") as EHudBuyTimeDropDown;
                  area.open(true);
                  area.setDefinition(this.mBattleExtraTimeDefs[0][0]);
               }
               this.mBattleExtraTimeDefs.splice(0,1);
            }
         }
         else if(battleState == 4 && this.mBattleTimerField)
         {
            scale = 1 + 0.04 - 0.04 * Math.cos(this.mBattleTimeLeftMs % 2000 * (2 * 3.141592653589793) / 2000);
            this.mBattleTimerField.scaleLogicX = this.mBattleTimerField.scaleLogicY = scale;
         }
         else if(battleState == 5)
         {
            this.battleChangeState(0);
         }
      }
      
      private function setReplaySpeed(speed:int) : void
      {
         if(this.mSpeedTextField)
         {
            this.mSpeedTextField.setText("x" + speed.toString());
         }
      }
      
      public function missionsChangeState(missionSku:String, stateId:int, notify:Boolean = true) : void
      {
         var icon:EHudMissionIcon = null;
         var notification:ESpriteContainer = null;
         var notificationText:ETextField = null;
         var notificationNumber:int = 0;
         if(!this.getHudElement("notification_area"))
         {
            return;
         }
         if(this.missionsGetPosition(missionSku) < 0)
         {
            if(this.mMissionsDropDownIcons.length < 5)
            {
               (icon = new EHudMissionIcon()).setMissionSku(missionSku);
               this.mMissionsDropDownIcons[this.mMissionsDropDownIcons.length] = icon;
               this.mMissionsDropDown.addContent(icon);
               if(notify)
               {
                  notificationText = (notification = this.getHudElement("notification_area") as ESpriteContainer).getContent("text") as ETextField;
                  notificationNumber = Math.min(5,parseInt(notificationText.getText()) + 1);
                  notificationText.setText(notificationNumber.toString());
                  notification.visible = true;
               }
               this.missionsReposition();
            }
            else
            {
               DCDebug.traceCh("ERROR","Trying to show mission " + missionSku + " when there\'s not enough place in the HUD");
            }
         }
      }
      
      public function missionsHideAll() : void
      {
         if(this.getHudElement("btn_missions"))
         {
            this.getHudElement("btn_missions").visible = false;
            this.getHudElement("area_missions").visible = false;
            this.getHudElement("notification_area").visible = false;
         }
      }
      
      public function missionsShowAll() : void
      {
         if(this.getHudElement("btn_missions"))
         {
            this.getHudElement("btn_missions").visible = true;
            this.getHudElement("area_missions").visible = true;
            this.getHudElement("notification_area").visible = ESpriteContainer(this.getHudElement("notification_area")).getContentAsETextField("text").getText() != "0";
         }
      }
      
      public function missionsGetMissionAt(pos:int) : String
      {
         var mission:EHudMissionIcon = null;
         var returnValue:String = "";
         if(this.mMissionsDropDownIcons.length > pos)
         {
            mission = this.mMissionsDropDownIcons[pos];
            if(mission != null)
            {
               returnValue = mission.getMissionSku();
            }
         }
         return returnValue;
      }
      
      private function missionsGetPosition(missionSku:String) : int
      {
         var i:int = 0;
         while(i < 5 && i < this.mMissionsDropDownIcons.length)
         {
            if(this.mMissionsDropDownIcons[i].getMissionSku() == missionSku)
            {
               return i;
            }
            i++;
         }
         return -1;
      }
      
      private function missionsReposition() : void
      {
         var i:int = 0;
         var icon:EHudMissionIcon = null;
         for(i = 0; i < this.mMissionsDropDownIcons.length; )
         {
            icon = this.mMissionsDropDownIcons[i];
            i++;
         }
      }
      
      private function resetMissionsCounter() : void
      {
         var notificationText:ETextField = null;
         var notification:ESpriteContainer = ESpriteContainer(this.getHudElement("notification_area"));
         if(notification)
         {
            notification.visible = false;
            notificationText = notification.getContentAsETextField("text");
            notificationText.setText("0");
         }
      }
      
      public function showProgressIcon(missionSku:String) : void
      {
         var container:EHudMissionIcon = null;
         var idx:int = this.missionsGetPosition(missionSku);
         if(idx > -1)
         {
            container = this.mMissionsDropDownIcons[idx];
            container.addProgressEffect();
         }
      }
      
      public function generalInfoNotification(value:Boolean) : void
      {
         if(this.getHudElement("btn_general_info") == null || this.getHudElement("general_info_notification") == null)
         {
            return;
         }
         var notifEspc:ESpriteContainer = this.getHudElement("general_info_notification") as ESpriteContainer;
         var notifField:ETextField = notifEspc.getContent("text") as ETextField;
         var notifNumber:int = parseInt(notifField.getText());
         if(value)
         {
            notifNumber = Math.min(1,notifNumber + 1);
         }
         notifField.setText(notifNumber.toString());
         notifEspc.visible = value && notifNumber > 0;
      }
      
      public function visitingSetHelpActionsAmount(amount:int) : void
      {
         var helpCounter:ESpriteContainer = this.getHudElement("help_counter") as ESpriteContainer;
         if(helpCounter)
         {
            helpCounter.getContentAsETextField("text").setText("x" + amount);
            if(amount)
            {
               helpCounter.getContent("text").unapplySkinProp(null,"text_negative");
               helpCounter.getContent("text").applySkinProp(null,"text_title_3");
            }
            else
            {
               helpCounter.getContent("text").unapplySkinProp(null,"text_title_3");
               helpCounter.getContent("text").applySkinProp(null,"text_negative");
            }
         }
      }
      
      public function collectiblesShow() : void
      {
         (this.getHudElement("CollectionCollection") as EHudCollectionPanel).open();
      }
      
      public function collectiblesResetTimer() : void
      {
         (this.getHudElement("CollectionCollection") as EHudCollectionPanel).resetTimer();
      }
      
      public function collectiblesHide(time:Number = 0.5) : void
      {
         (this.getHudElement("CollectionCollection") as EHudCollectionPanel).close();
      }
      
      public function isCollectiblesShown() : Boolean
      {
         return (this.getHudElement("CollectionCollection") as EHudCollectionPanel).isOpen();
      }
      
      public function collectiblesSetCollection(sku:String, removeOne:Boolean = false) : void
      {
         var showNewCollection:Boolean = false;
         var isCompleteCollection:Boolean = false;
         var collection:Array = null;
         var collectionDef:DCDef = null;
         var i:int = 0;
         var newCollectionId:String;
         if(newCollectionId = InstanceMng.getItemsMng().getCollectionIdByCollectableSku(sku))
         {
            showNewCollection = false;
            isCompleteCollection = true;
            collection = InstanceMng.getItemsMng().getCollection(newCollectionId);
            if(collectionDef = InstanceMng.getCollectablesDefMng().getDefBySku(collection[0]))
            {
               collection[0] = collectionDef.getNameToDisplay();
            }
            i = 1;
            while(isCompleteCollection && i < collection.length)
            {
               if(collection[i].quantity == 0)
               {
                  isCompleteCollection = false;
               }
               else if(sku == collection[i].mDef.mSku && collection[i].quantity == 1)
               {
                  showNewCollection = true;
               }
               i++;
            }
            (this.getHudElement("CollectionCollection") as EHudCollectionPanel).fillData(collection,showNewCollection && isCompleteCollection);
         }
      }
      
      public function craftingShow() : void
      {
         (this.getHudElement("CollectionCrafting") as EHudCollectionPanel).open();
      }
      
      public function craftingResetTimer() : void
      {
         (this.getHudElement("CollectionCrafting") as EHudCollectionPanel).resetTimer();
      }
      
      public function craftingHide(time:Number = 0.5) : void
      {
         (this.getHudElement("CollectionCrafting") as EHudCollectionPanel).close();
      }
      
      public function isCraftingShown() : Boolean
      {
         return (this.getHudElement("CollectionCrafting") as EHudCollectionPanel).isOpen();
      }
      
      public function craftingSetCollection(sku:String, removeOne:Boolean = false) : void
      {
         var showNewCollection:Boolean = false;
         var isCompleteCollection:Boolean = true;
         var craftingGroup:Array = InstanceMng.getItemsMng().getCraftingGroupByCraftItemSku(sku);
         var craftingGroupDef:DCDef = InstanceMng.getCraftingDefMng().getDefBySku(craftingGroup[0]);
         if(craftingGroupDef)
         {
            craftingGroup[0] = craftingGroupDef.getNameToDisplay();
         }
         var i:int = 1;
         while(isCompleteCollection && i < craftingGroup.length)
         {
            if(craftingGroup[i].quantity == 0)
            {
               isCompleteCollection = false;
            }
            if(sku == craftingGroup[i].mDef.mSku && craftingGroup[i].quantity == 1)
            {
               showNewCollection = true;
            }
            i++;
         }
         (this.getHudElement("CollectionCrafting") as EHudCollectionPanel).fillData(craftingGroup,showNewCollection && isCompleteCollection);
      }
      
      public function workerCollectiblesShow() : void
      {
         (this.getHudElement("CollectionWorker") as EHudCollectionPanel).open(true);
      }
      
      public function workersResetTimer() : void
      {
         (this.getHudElement("CollectionWorker") as EHudCollectionPanel).resetTimer();
      }
      
      public function workersCollectiblesHide(time:Number = 0.5) : void
      {
         (this.getHudElement("CollectionWorker") as EHudCollectionPanel).close();
      }
      
      public function isWorkerCollectiblesShown() : Boolean
      {
         return (this.getHudElement("CollectionWorker") as EHudCollectionPanel).isOpen();
      }
      
      public function workerCollectiblesSetCollection(sku:String, removeOne:Boolean = false) : void
      {
         var i:int = 0;
         var list:Array = null;
         var workerDef:DroidDef = InstanceMng.getDroidDefMng().getDefs()[0] as DroidDef;
         var collection:Array = [DCTextMng.getText(2681)];
         var paymentItemsList:Array = InstanceMng.getRuleMng().getDroidPaymentItemsList(workerDef);
         for(i = 0; i < paymentItemsList.length; )
         {
            list = paymentItemsList[i].split(":");
            collection.push(InstanceMng.getItemsMng().getItemObjectBySku(list[0]));
            i++;
         }
         (this.getHudElement("CollectionWorker") as EHudCollectionPanel).fillData(collection,false);
      }
      
      public function blackStripsShow(hideHud:Boolean) : void
      {
         var tween:GTween = null;
         var stageWidth:int = InstanceMng.getViewMng().getStageWidth();
         var stageHeight:int = InstanceMng.getViewMng().getStageHeight();
         if(this.mUpperBlackStrips == null)
         {
            this.mUpperBlackStrips = InstanceMng.getViewFactory().getGraphics();
            this.mUpperBlackStrips.drawRect(stageWidth,stageHeight * 0.085);
         }
         if(this.mLowerBlackStrips == null)
         {
            this.mLowerBlackStrips = InstanceMng.getViewFactory().getGraphics();
            this.mLowerBlackStrips.drawRect(stageWidth,stageHeight * 0.085);
         }
         this.mUpperBlackStrips.setPivotLogicXY(0,1);
         this.mLowerBlackStrips.setPivotLogicXY(0,0);
         this.mUpperBlackStrips.logicY = 0;
         this.mLowerBlackStrips.logicY = stageHeight;
         InstanceMng.getViewMng().addESpriteToLayer(this.mUpperBlackStrips,InstanceMng.getViewMngGame().getHudLayerSku());
         InstanceMng.getViewMng().addESpriteToLayer(this.mLowerBlackStrips,InstanceMng.getViewMngGame().getHudLayerSku());
         this.mUpperBlackStrips.parent.setChildIndex(this.mUpperBlackStrips,0);
         this.mLowerBlackStrips.parent.setChildIndex(this.mLowerBlackStrips,0);
         var upValues:Object = {"pivotLogicY":0};
         var loValues:Object = {"pivotLogicY":1};
         (tween = new GTween(this.mUpperBlackStrips,1,upValues)).autoPlay = true;
         (tween = new GTween(this.mLowerBlackStrips,1,loValues)).autoPlay = true;
         if(hideHud)
         {
            this.hideHudGroup("HudTopIcons");
            this.hideHudGroup("HudLeft");
            this.hideHudGroup("HudRight");
         }
      }
      
      public function blackStripsHide() : void
      {
         var upValues:Object = null;
         var loValues:Object = null;
         var tween:GTween = null;
         if(this.mUpperBlackStrips && this.mLowerBlackStrips)
         {
            upValues = {"pivotLogicY":1};
            loValues = {"pivotLogicY":0};
            tween = new GTween(this.mUpperBlackStrips,1,upValues);
            tween.autoPlay = true;
            tween.onComplete = this.onCompleteTweenDestroyUpperStrips;
            tween = new GTween(this.mLowerBlackStrips,1,loValues);
            tween.autoPlay = true;
            tween.onComplete = this.onCompleteTweenDestroyLowerStrips;
         }
         this.showHudGroup("HudTopIcons");
         this.showHudGroup("HudLeft");
         this.showHudGroup("HudRight");
      }
      
      public function blackStripsAreActive() : Boolean
      {
         return this.mUpperBlackStrips || this.mLowerBlackStrips;
      }
      
      private function onBookmarkAddClicked(evt:EEvent) : void
      {
         var currentSolarSystemId:Number = InstanceMng.getMapViewSolarSystem().getStarId();
         var currentSolarSystemCoords:DCCoordinate = InstanceMng.getMapViewSolarSystem().getStarCoords();
         var currentSolarSystemName:String = InstanceMng.getMapViewSolarSystem().getStarName();
         var currentSolarSystemType:int = InstanceMng.getMapViewSolarSystem().getStarType();
         var bookmarkOK:Boolean = InstanceMng.getMapView().addBookmark(currentSolarSystemId,currentSolarSystemCoords,currentSolarSystemName,String(currentSolarSystemType));
         this.refreshBookmarkButtonsVisibility();
      }
      
      private function onBookmarkRemovedClicked(evt:EEvent) : void
      {
         var currentSolarSystemCoords:DCCoordinate = InstanceMng.getMapViewSolarSystem().getStarCoords();
         var bookmarkOK:Boolean = InstanceMng.getMapView().deleteBookmark(currentSolarSystemCoords);
         this.refreshBookmarkButtonsVisibility();
      }
      
      public function refreshBookmarkButtonsVisibility() : void
      {
         var barText:String = null;
         var isBookmarked:Boolean = false;
         var bar:ESpriteContainer = this.getHudElement("bookmark_info") as ESpriteContainer;
         var currentSolarSystemCoords:DCCoordinate = InstanceMng.getMapViewSolarSystem().getStarCoords();
         var currentSolarSystemId:Number = InstanceMng.getMapViewSolarSystem().getStarId();
         if(bar && currentSolarSystemCoords)
         {
            isBookmarked = InstanceMng.getMapView().checkIfStarAlreadyBookmarked(currentSolarSystemId);
            bar.getContent("btn_add").visible = !isBookmarked;
            bar.getContent("btn_remove").visible = isBookmarked;
            barText = "[" + currentSolarSystemCoords.x + "," + currentSolarSystemCoords.y + "]";
            if(InstanceMng.getUserInfoMng().getProfileLogin().getStreamerMode())
            {
               barText = InstanceMng.getMapViewSolarSystem().getStarName();
            }
            bar.getContentAsETextField("text").setText(barText);
         }
      }
      
      private function onDroidsClicked(evt:EEvent) : void
      {
         MessageCenter.getInstance().sendMessage("openDroidsShop");
      }
      
      private function onShieldClicked(evt:EEvent) : void
      {
         MessageCenter.getInstance().sendMessage("openPremiumShop");
      }
      
      private function onMineralsClicked(evt:EEvent) : void
      {
         MessageCenter.getInstance().sendMessage("openMineralsShop");
      }
      
      private function onCoinsClicked(evt:EEvent) : void
      {
         MessageCenter.getInstance().sendMessage("openCoinsShop");
      }
      
      private function onDailyRewardButtonClicked(evt:EEvent) : void
      {
         MessageCenter.getInstance().sendMessage("openDailyReward");
      }
      
      private function onGeneralInfoButtonClicked(evt:EEvent) : void
      {
         MessageCenter.getInstance().sendMessage("openSocialMedia");
      }
      
      private function onDebugButtonClicked(evt:EEvent) : void
      {
      }
      
      private function onSpyCapsulesIconClicked(evt:EEvent) : void
      {
         InstanceMng.getToolsMng().toggleSpy(0);
         this.deselectWarBar();
      }
      
      private function onSpyCapsulesAdvancedIconClicked(evt:EEvent) : void
      {
         InstanceMng.getToolsMng().toggleSpy(1);
         this.deselectWarBar();
      }
      
      private function deselectWarBar() : void
      {
         var params:Dictionary = null;
         var warBar:WarBarFacade = InstanceMng.getGUIControllerPlanet().getWarBar();
         if(warBar)
         {
            params = new Dictionary();
            params["selected"] = false;
            warBar.onMessage("warBarUnitClicked",params);
         }
      }
      
      private function onSpyCapsulesShopClicked(evt:EEvent) : void
      {
         MessageCenter.getInstance().sendMessage("hudBuyCapsulesClicked");
      }
      
      private function onServerMaintenanceCountdownClicked(evt:EEvent) : void
      {
         MessageCenter.getInstance().sendMessage("hudServerMaintenanceCountdownClicked");
      }
      
      private function onReplaySpeedClicked(evt:EEvent) : void
      {
         this.mCurrentReplayIndex += 1;
         this.mCurrentReplayIndex %= REPLAY_SPEEDS.length;
         var params:Dictionary = new Dictionary();
         params["newAmount"] = REPLAY_SPEEDS[this.mCurrentReplayIndex];
         MessageCenter.getInstance().sendMessage("replaySpeedChanged",params);
      }
      
      private function onColonyClick(evt:EEvent) : void
      {
         var userInfo:UserInfo = InstanceMng.getUserInfoMng().getCurrentProfileLoaded().getUserInfoObj();
         var planetId:String = String(evt.getTarget().name);
         var planet:Planet = userInfo.getPlanetById(planetId);
         InstanceMng.getApplication().goToSetCurrentDestinationInfo(planetId,userInfo);
         InstanceMng.getApplication().requestPlanet(userInfo.getAccountId(),planetId,1,planet.getSku());
      }
      
      private function onRetireButtonClicked(evt:EEvent) : void
      {
         MessageCenter.getInstance().sendMessage("hudRetireButtonClicked");
      }
      
      private function onOfferWallClicked(evt:EEvent) : void
      {
         MessageCenter.getInstance().sendMessage("offerWallClicked");
         this.setOfferWallButtonVisible(false);
         this.mFreeChipsDropDown.close(false);
      }
      
      private function onVideoAdsClicked(evt:EEvent) : void
      {
         MessageCenter.getInstance().sendMessage("videoAdsClicked");
         this.setVideoAdButtonVisible(false);
         this.mFreeChipsDropDown.close(false);
      }
      
      private function onChipsClicked(evt:EEvent) : void
      {
         MessageCenter.getInstance().sendMessage("openChipsShop");
      }
      
      private function onContestToolClicked(evt:EEvent) : void
      {
         if(this.mContestToolUsage == "contest")
         {
            MessageCenter.getInstance().sendMessage("openContestToolPopup");
         }
         else if(this.mContestToolUsage == "happening")
         {
            MessageCenter.getInstance().sendMessage("openHappeningPopup");
         }
      }
      
      private function onMouseOverScore(evt:EEvent) : void
      {
         var profile:Profile;
         var xp:Number = (profile = InstanceMng.getUserInfoMng().getProfileLogin()).getScore();
         var currentLevel:String = profile.getLevel().toString();
         var levelScoreDef:LevelScoreDef;
         var maxXpForThisLevel:Number = (levelScoreDef = InstanceMng.getLevelScoreDefMng().getDefBySku(currentLevel) as LevelScoreDef).getMaxXp();
         var desc:String = InstanceMng.getGUIDefMng().getDefBySku("experience").getTooltipDescToDisplay();
         var xpStr:String = GameConstants.formatScoreValue(xp);
         var maxXpStr:String = GameConstants.formatScoreValue(maxXpForThisLevel);
         var tooltipText:String = DCTextMng.replaceParameters(501,[currentLevel,xpStr,GameConstants.formatScoreValue(maxXpForThisLevel - xp)]);
         if(desc != "")
         {
            tooltipText += "\n" + desc;
         }
         var tooltipInfo:ETooltipInfo = ETooltipMng.getInstance().createTooltipInfoFromText(tooltipText,evt.getTarget());
      }
      
      private function onMouseOutScore(evt:EEvent) : void
      {
         ETooltipMng.getInstance().removeCurrentTooltip();
      }
      
      private function onMouseOverDroids(evt:EEvent) : void
      {
         var tooltipText:String = null;
         var allItems:* = undefined;
         var droids:Number = InstanceMng.getUserInfoMng().getProfileLogin().getDroids();
         var droidsText:String = DCTextMng.convertNumberToString(droids,-1,-1);
         var maxDroids:Number = InstanceMng.getUserInfoMng().getProfileLogin().getMaxDroidsAmount();
         var maxDroidsText:String = DCTextMng.convertNumberToString(maxDroids,-1,-1);
         var droidProgressTimesRaw:Array = [];
         var droidProgressTimes:Array = [];
         var droidProgressText:String = "";
         if(droids < maxDroids)
         {
            allItems = InstanceMng.getWorld().itemsGetAllItems();
            for each(var item in allItems)
            {
               if(item.isUpgrading() || item.mServerStateId == 0)
               {
                  droidProgressTimesRaw.push(item.getTimeLeft());
               }
            }
            droidProgressTimesRaw.sort(16);
            for each(var time in droidProgressTimesRaw)
            {
               droidProgressTimes.push(DCTextMng.convertTimeToStringColon(time));
            }
            droidProgressText = "\n" + droidProgressTimes.join("\n");
         }
         if(droidProgressTimes.length == 0)
         {
            tooltipText = DCTextMng.replaceParameters(3975,[maxDroidsText,droidsText]);
         }
         else
         {
            tooltipText = DCTextMng.replaceParameters(502,[maxDroidsText,droidsText,droidProgressText]);
         }
         var tooltipInfo:ETooltipInfo = ETooltipMng.getInstance().createTooltipInfoFromText(tooltipText,evt.getTarget());
      }
      
      private function onMouseOutDroids(evt:EEvent) : void
      {
         ETooltipMng.getInstance().removeCurrentTooltip();
      }
      
      private function onMouseOverCoins(evt:EEvent) : void
      {
         var incomePerHour:Number = InstanceMng.getWorldItemObjectController().getProductionAmountPerHour(0);
         var incomePerHourStr:String = DCTextMng.convertNumberToString(incomePerHour,-1,-1);
         var coins:Number = InstanceMng.getUserInfoMng().getProfileLogin().getCoins();
         var coinsText:String = DCTextMng.convertNumberToString(coins,-1,-1);
         var maxCoins:Number = InstanceMng.getUserInfoMng().getProfileLogin().getCoinsCapacity();
         var maxCoinsText:String = DCTextMng.convertNumberToString(maxCoins,-1,-1);
         var tooltipText:String = DCTextMng.replaceParameters(504,new Array(maxCoinsText,incomePerHourStr));
         var tooltipInfo:ETooltipInfo = ETooltipMng.getInstance().createTooltipInfoFromText(tooltipText,evt.getTarget());
      }
      
      private function onMouseOutCoins(evt:EEvent) : void
      {
         ETooltipMng.getInstance().removeCurrentTooltip();
      }
      
      private function onMouseOverMinerals(evt:EEvent) : void
      {
         var incomePerHour:Number = InstanceMng.getWorldItemObjectController().getProductionAmountPerHour(1);
         var incomePerHourStr:String = DCTextMng.convertNumberToString(incomePerHour,-1,-1);
         var minerals:Number = InstanceMng.getUserInfoMng().getProfileLogin().getMinerals();
         var mineralsText:String = DCTextMng.convertNumberToString(minerals,-1,-1);
         var maxMinerals:Number = InstanceMng.getUserInfoMng().getProfileLogin().getMineralsCapacity();
         var maxMineralsText:String = DCTextMng.convertNumberToString(maxMinerals,-1,-1);
         var tooltipText:String = DCTextMng.replaceParameters(503,[maxMineralsText,incomePerHourStr]);
         var tooltipInfo:ETooltipInfo = ETooltipMng.getInstance().createTooltipInfoFromText(tooltipText,evt.getTarget());
      }
      
      private function onMouseOutMinerals(evt:EEvent) : void
      {
         ETooltipMng.getInstance().removeCurrentTooltip();
      }
      
      private function onMouseOverHudElement(evt:EEvent) : void
      {
         var tooltipText:String = null;
         var tooltipInfo:ETooltipInfo = null;
         var guiDef:DCGUIDef;
         if(guiDef = InstanceMng.getGUIDefMng().getDefBySku(evt.getTarget().name) as DCGUIDef)
         {
            tooltipText = guiDef.getTooltipTitleToDisplay();
            tooltipInfo = ETooltipMng.getInstance().createTooltipInfoFromText(tooltipText,evt.getTarget());
         }
      }
      
      private function onMouseOutHudElement(evt:EEvent) : void
      {
         ETooltipMng.getInstance().removeCurrentTooltip();
      }
      
      private function onAddThisToHidden(tween:GTween) : void
      {
         this.mHiddenGroups.push(tween.target.name);
         this.mTransitionGroups.splice(this.mTransitionGroups.lastIndexOf(tween.target.name),1);
      }
      
      private function onRemoveThisFromHidden(tween:GTween) : void
      {
         this.mTransitionGroups.splice(this.mTransitionGroups.lastIndexOf(tween.target.name),1);
      }
      
      private function onCompleteTweenDestroyUpperStrips(tween:GTween) : void
      {
         this.destroyESprite(this.mUpperBlackStrips);
         this.mUpperBlackStrips = null;
      }
      
      private function onCompleteTweenDestroyLowerStrips(tween:GTween) : void
      {
         this.destroyESprite(this.mLowerBlackStrips);
         this.mLowerBlackStrips = null;
      }
      
      private function destroyESprite(sp:ESprite) : void
      {
         if(sp)
         {
            if(sp.parent)
            {
               sp.parent.removeChild(sp);
            }
            sp.destroy();
         }
      }
      
      public function setBattleSpeedBtnVisible(value:Boolean) : void
      {
         (this.getHudElement("area_timer") as ESpriteContainer).getContent("btn_speed").visible = value;
      }
      
      public function updateHappeningWaveProgressBar(value:int, maxValue:int) : void
      {
         var bar:IconBar = null;
         if(this.getHudElement("HAPPENING_WAVE_PROGRESS"))
         {
            bar = this.getHudElement("HAPPENING_WAVE_PROGRESS") as IconBar;
            bar.visible = true;
            bar.setBarCurrentValue(value);
            bar.setBarMaxValue(maxValue);
            bar.updateText(DCTextMng.replaceParameters(3274,[String(value),String(maxValue)]));
         }
      }
   }
}
