package com.dchoc.game.core.instance
{
   import com.dchoc.game.controller.ActionsLibrary;
   import com.dchoc.game.controller.alliances.AlliancesController;
   import com.dchoc.game.controller.animation.JailAnimMng;
   import com.dchoc.game.controller.animation.TutorialKidnapMng;
   import com.dchoc.game.controller.gameunit.GameUnitMngController;
   import com.dchoc.game.controller.gui.GUIController;
   import com.dchoc.game.controller.gui.GUIControllerGalaxy;
   import com.dchoc.game.controller.gui.GUIControllerPlanet;
   import com.dchoc.game.controller.gui.GUIControllerSolarSystem;
   import com.dchoc.game.controller.gui.popups.PopupMng;
   import com.dchoc.game.controller.gui.popups.WelcomePopupsMng;
   import com.dchoc.game.controller.hangar.BunkerController;
   import com.dchoc.game.controller.hangar.HangarControllerMng;
   import com.dchoc.game.controller.hud.HudController;
   import com.dchoc.game.controller.map.BackgroundController;
   import com.dchoc.game.controller.map.MapController;
   import com.dchoc.game.controller.map.MapControllerGalaxy;
   import com.dchoc.game.controller.map.MapControllerPlanet;
   import com.dchoc.game.controller.map.MapControllerSolarSystem;
   import com.dchoc.game.controller.notifications.NotificationsMng;
   import com.dchoc.game.controller.role.Role;
   import com.dchoc.game.controller.shop.BuildingsBufferController;
   import com.dchoc.game.controller.shop.BuildingsShopController;
   import com.dchoc.game.controller.shop.ShipyardController;
   import com.dchoc.game.controller.shop.ShopsDrawer;
   import com.dchoc.game.controller.tools.ToolsMng;
   import com.dchoc.game.controller.world.item.WorldItemObjectController;
   import com.dchoc.game.core.flow.Application;
   import com.dchoc.game.core.resource.ResourceMng;
   import com.dchoc.game.core.rule.RuleMng;
   import com.dchoc.game.core.utils.animations.AnimMng;
   import com.dchoc.game.core.utils.collisionboxes.CollisionBoxMng;
   import com.dchoc.game.core.utils.memory.PoolMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.behaviors.BehaviorsMng;
   import com.dchoc.game.eview.facade.ReplayBarFacade;
   import com.dchoc.game.eview.facade.TopHudFacade;
   import com.dchoc.game.eview.resources.ResourcesMng;
   import com.dchoc.game.eview.skins.SkinsMng;
   import com.dchoc.game.eview.widgets.selectioncircle.ESelectionCircleMng;
   import com.dchoc.game.model.bet.BetDefMng;
   import com.dchoc.game.model.bet.BetMng;
   import com.dchoc.game.model.cache.CacheMng;
   import com.dchoc.game.model.cache.GraphicsCacheMng;
   import com.dchoc.game.model.contest.ContestDefMng;
   import com.dchoc.game.model.contest.ContestMng;
   import com.dchoc.game.model.dailyreward.DailyRewardMng;
   import com.dchoc.game.model.flow.FlowState;
   import com.dchoc.game.model.flow.FlowStateGalaxy;
   import com.dchoc.game.model.flow.FlowStatePlanet;
   import com.dchoc.game.model.flow.FlowStateSolarSystem;
   import com.dchoc.game.model.friends.VisitorMng;
   import com.dchoc.game.model.happening.HappeningDefMng;
   import com.dchoc.game.model.happening.HappeningMng;
   import com.dchoc.game.model.happening.HappeningTypeDefMng;
   import com.dchoc.game.model.hotkey.HotkeyMng;
   import com.dchoc.game.model.invests.InvestMng;
   import com.dchoc.game.model.items.AlliancesRewardDefMng;
   import com.dchoc.game.model.items.AlliancesRewardsMng;
   import com.dchoc.game.model.items.CollectablesDefMng;
   import com.dchoc.game.model.items.CraftingDefMng;
   import com.dchoc.game.model.items.ItemsDefMng;
   import com.dchoc.game.model.items.ItemsMng;
   import com.dchoc.game.model.items.MisteryRewardDefMng;
   import com.dchoc.game.model.items.RewardsDefMng;
   import com.dchoc.game.model.items.SpecialAttacksDefMng;
   import com.dchoc.game.model.loading.LoadingMng;
   import com.dchoc.game.model.map.MapModel;
   import com.dchoc.game.model.poll.PollDefMng;
   import com.dchoc.game.model.poll.PollMng;
   import com.dchoc.game.model.powerups.PowerUpDefMng;
   import com.dchoc.game.model.powerups.PowerUpMng;
   import com.dchoc.game.model.rule.AlliancesLevelDefMng;
   import com.dchoc.game.model.rule.AlliancesSettingsDefMng;
   import com.dchoc.game.model.rule.AlliancesWarTypesDefMng;
   import com.dchoc.game.model.rule.AnimationsDefMng;
   import com.dchoc.game.model.rule.BackgroundDefMng;
   import com.dchoc.game.model.rule.BetsSettingsDefMng;
   import com.dchoc.game.model.rule.BuyResourcesBoxDefMng;
   import com.dchoc.game.model.rule.CreditsDefMng;
   import com.dchoc.game.model.rule.DamageProtectionDefMng;
   import com.dchoc.game.model.rule.FlagImagesDefMng;
   import com.dchoc.game.model.rule.FunnelStepDefMng;
   import com.dchoc.game.model.rule.HelpsDefMng;
   import com.dchoc.game.model.rule.InvestRewardsDefMng;
   import com.dchoc.game.model.rule.InvestsSettingsDefMng;
   import com.dchoc.game.model.rule.LevelScoreDefMng;
   import com.dchoc.game.model.rule.NPCDefMng;
   import com.dchoc.game.model.rule.NewPayerPromoDefMng;
   import com.dchoc.game.model.rule.PlatformSettingsDefMng;
   import com.dchoc.game.model.rule.PopupSkinDefMng;
   import com.dchoc.game.model.rule.PremiumPricesDefMng;
   import com.dchoc.game.model.rule.ProtectionTimeDefMng;
   import com.dchoc.game.model.rule.RebornObstaclesDefMng;
   import com.dchoc.game.model.rule.SettingsDefMng;
   import com.dchoc.game.model.rule.ShotPriorityDefMng;
   import com.dchoc.game.model.rule.SpyCapsulesShopDefMng;
   import com.dchoc.game.model.rule.WarPointsPerHQDefMng;
   import com.dchoc.game.model.shop.PurchaseShopDefMng;
   import com.dchoc.game.model.shop.ShopDefMng;
   import com.dchoc.game.model.shop.ShopProgressDefMng;
   import com.dchoc.game.model.space.PlanetDefMng;
   import com.dchoc.game.model.space.SolarSystemDefMng;
   import com.dchoc.game.model.target.TargetDefMng;
   import com.dchoc.game.model.target.TargetMng;
   import com.dchoc.game.model.umbrella.UmbrellaMng;
   import com.dchoc.game.model.umbrella.UmbrellaSettingsDefMng;
   import com.dchoc.game.model.umbrella.UmbrellaSkinDefMng;
   import com.dchoc.game.model.unit.UnitScene;
   import com.dchoc.game.model.unit.defs.CivilDefMng;
   import com.dchoc.game.model.unit.defs.DroidDefMng;
   import com.dchoc.game.model.unit.defs.UnitDefMng;
   import com.dchoc.game.model.unit.mngs.TrafficMng;
   import com.dchoc.game.model.upselling.UpSellingMng;
   import com.dchoc.game.model.userdata.CustomizerMng;
   import com.dchoc.game.model.userdata.UserDataMng;
   import com.dchoc.game.model.userdata.UserInfoMng;
   import com.dchoc.game.model.waves.WaveDefMng;
   import com.dchoc.game.model.waves.WaveSpawnDefMng;
   import com.dchoc.game.model.world.World;
   import com.dchoc.game.model.world.item.WorldItemDefMng;
   import com.dchoc.game.model.world.ship.ShipDefMng;
   import com.dchoc.game.model.world.target.missions.MissionsMng;
   import com.dchoc.game.utils.popup.PopupEffects;
   import com.dchoc.game.view.dc.map.MapView;
   import com.dchoc.game.view.dc.map.MapViewGalaxy;
   import com.dchoc.game.view.dc.map.MapViewPlanet;
   import com.dchoc.game.view.dc.map.MapViewSolarSystem;
   import com.dchoc.game.view.dc.mng.ViewMngPlanet;
   import com.dchoc.game.view.dc.mng.ViewMngSpace;
   import com.dchoc.game.view.dc.mng.ViewMngrGame;
   import com.dchoc.game.view.facade.UIFacade;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.instance.DCInstanceMng;
   import com.dchoc.toolkit.core.notify.DCNotifyMng;
   import com.dchoc.toolkit.core.view.mng.DCViewMng;
   import com.dchoc.toolkit.utils.collisionboxes.DCCollisionBoxMng;
   import com.dchoc.toolkit.view.conf.DCGUIDefMng;
   import com.dchoc.toolkit.view.map.DCMapViewDefMng;
   
   public class InstanceMng extends DCInstanceMng
   {
      
      private static const SKU_MAP_CONTROLLER_PLANET:String = "MapControllerPlanet";
      
      private static const SKU_MAP_CONTROLLER_GALAXY:String = "MapControllerGalaxy";
      
      private static const SKU_MAP_CONTROLLER_SOLAR_SYSTEM:String = "MapControllerSolarSystem";
      
      private static const SKU_MAP_MODEL:String = "MapModel";
      
      private static const SKU_MAP_VIEW_DEF_MNG:String = "MapViewDefMng";
      
      private static const SKU_TOOLS_MNG:String = "ToolsMng";
      
      private static const SKU_USER_DATA_MNG:String = "UserDataMng";
      
      private static const SKU_USER_INFO_MNG:String = "UserInfoMng";
      
      private static const SKU_WORLD:String = "World";
      
      private static const SKU_WORLD_ITEM_DEF_MNG:String = "WorldItemDefMng";
      
      private static const SKU_SHIP_DEF_MNG:String = "ShipDefMng";
      
      private static const SKU_UNIT_DEF_MNG:String = "UnitDefMng";
      
      private static const SKU_ITEM_DEF_MNG:String = "ItemDefMng";
      
      private static const SKU_ITEM_PROB_DEF_MNG:String = "ItemProbDefMng";
      
      private static const SKU_ITEMS_MNG:String = "ItemsMng";
      
      private static const SKU_WORLD_ITEM_OBJECT_CONTROLLER:String = "WorldItemObjectController";
      
      private static const SKU_ROLE:String = "Role";
      
      private static const SKU_GUI_CONTROLLER:String = "GUIController";
      
      private static const SKU_GUI_CONTROLLER_PLANET:String = "GUIControllerPlanet";
      
      private static const SKU_GUI_CONTROLLER_GALAXY:String = "GUIControllerGalaxy";
      
      private static const SKU_GUI_CONTROLLER_SOLAR_SYSTEM:String = "GUIControllerSolarSystem";
      
      private static const SKU_POPUP_MNG:String = "PopupMng";
      
      private static const SKU_WELCOME_POPUPS_MNG:String = "WelcomePopupsMng";
      
      private static const SKU_LEVEL_XP_DEF_MNG:String = "LevelXpDefMng";
      
      private static const SKU_LEVEL_SCORE_DEF_MNG:String = "LevelScoreDefMng";
      
      private static const SKU_BACKGROUND_DEF_MNG:String = "BackgroundDefMng";
      
      private static const SKU_HQ_LEVEL_DEF_MNG:String = "HQLevelDefMng";
      
      private static const SKU_GALAXY_DEF_MNG:String = "GalaxyDefMng";
      
      private static const SKU_SOLAR_SYSTEM_DEF_MNG:String = "SolarSystemDefMng";
      
      private static const SKU_PLANET_DEF_MNG:String = "PlanetDefMng";
      
      private static const SKU_PLANET_GROUP_DEF_MNG:String = "PlanetGroupDefMng";
      
      private static const SKU_PLANET_TYPE_DEF_MNG:String = "PlanetTypeDefMng";
      
      private static const SKU_GUI_DEF_MNG:String = "GUIDefMng";
      
      private static const SKU_GUI_FACTORY:String = "GUIFactory";
      
      private static const SKU_SETTINGS_DEF_MNG:String = "SettingsDefMng";
      
      private static const SKU_BUILDINGS_SHOP_CONTROLLER:String = "ShopController";
      
      private static const SKU_BUILDINGS_BUFFER_CONTROLLER:String = "BufferController";
      
      private static const SKU_SHIPYARD_CONTROLLER:String = "ShipyardController";
      
      private static const SKU_TOOLTIP_MNG:String = "TooltipMng";
      
      private static const SKU_HUD_CONTROLLER:String = "HudController";
      
      private static const SKU_UI_FACADE:String = "UIFacade";
      
      private static const SKU_DROID_MNG:String = "DroidMng";
      
      private static const SKU_DROID_DEF_MNG:String = "DroidDefMng";
      
      private static const SKU_CIVIL_DEF_MNG:String = "CivilDefMng";
      
      private static const SKU_ANIM_DEF_MNG:String = "AnimDefMng";
      
      private static const SKU_TARGET_DEF_MNG:String = "TargetDefMng";
      
      private static const SKU_TARGET_MNG:String = "TargetMng";
      
      private static const SKU_MISSIONS_MNG:String = "MissionsMng";
      
      private static const SKU_STORY_MISSIONS_MNG:String = "StoryMissionsMng";
      
      private static const SKU_SELECT_CIRCLE_MNG:String = "SelectionCircleMng";
      
      private static const SKU_VIEW_MNG_GAME:String = "ViewMngGame";
      
      private static const SKU_VIEW_MNG_PLANET:String = "ViewMngPlanet";
      
      private static const SKU_VIEW_MNG_SPACE:String = "ViewMngSpace";
      
      private static const SKU_FLOW_STATE_PLANET:String = "FlowStatePlanet";
      
      private static const SKU_FLOW_STATE_GALAXY:String = "FlowStateGalaxy";
      
      private static const SKU_FLOW_STATE_SOLAR_SYSTEM:String = "FlowStateSolarSystem";
      
      private static const SKU_HANGAR_CONTROLLER:String = "HangarController";
      
      private static const SKU_UNIT_SCENE:String = "UnitScene";
      
      private static const SKU_TRAFFIC_MNG:String = "TrafficMng";
      
      private static const SKU_PHOTO_CACHE:String = "GraphicsCacheMng";
      
      private static const SKU_CACHE_MNG:String = "CacheMng";
      
      private static const SKU_BUNKER_CONTROLLER:String = "BunkerController";
      
      private static const SKU_GAME_UNIT_MNG:String = "GameUnitMng";
      
      private static const SKU_VISITOR_MNG:String = "VisitorMng";
      
      private static const SKU_DAILY_REWARD_MNG:String = "DailyRewardMng";
      
      private static const SKU_HOTKEY_MNG:String = "HotkeyMng";
      
      private static const SKU_COLLECTABLES_DEF:String = "CollectablesDef";
      
      private static const SKU_ALLIANCES_REWARD_DEF_MNG:String = "AlliancesRewardDefMng";
      
      private static const SKU_ALLIANCES_REWARD_MNG:String = "AlliancesRewardMng";
      
      private static const SKU_CRAFTING_DEF:String = "CraftingDef";
      
      private static const SKU_SPECIAL_ATTACKS_DEF:String = "SpecialAttacksDef";
      
      private static const SKU_PREMIUM_PRICES_DEF_MNG:String = "PremiumPricesDefMng";
      
      private static const SKU_PROTECTION_TIME_DEF_MNG:String = "ProtectionTimeDefMng";
      
      private static const SKU_REBORN_OBSTACLES_DEF_MNG:String = "RebornObstaclesDefMng";
      
      private static const SKU_BUY_RESOURCES_BOXES_DEF_MNG:String = "BuyResourcesBoxesDefMng";
      
      private static const SKU_REWARDS_DEF_MNG:String = "RewardsDefMng";
      
      private static const SKU_MISTERY_REWARD_DEF_MNG:String = "MisteryRewardMng";
      
      private static const SKU_POPUP_EFFECTS:String = "PopupEffects";
      
      private static const SKU_TUTORIAL_KIDNAP_MNG:String = "TutorialKidnapMng";
      
      private static const SKU_JAIL_ANIM_MNG:String = "JailAnimMng";
      
      private static const SKU_ALLIANCES_CONTROLLER:String = "AlliancesController";
      
      private static const SKU_ALLIANCES_LEVEL_DEF_MNG:String = "AlliancesLevelDefMng";
      
      private static const SKU_FLAG_IMAGES_DEF_MNG:String = "FlagImagesDefMng";
      
      private static const SKU_CREDITS_DEF_MNG:String = "CreditsDefMng";
      
      private static const SKU_CUSTOMIZER_MNG:String = "CustomizerMng";
      
      private static const SKU_DAMAGE_PROTECTION_MNG:String = "DamageProtectionMng";
      
      private static const SKU_BACKGROUND_CONTROLLER:String = "BackgroundController";
      
      private static const SKU_ALLIANCES_SETTINGS_DEF_MNG:String = "AlliancesSettingsDefMng";
      
      private static const SKU_SHOT_PRIORITY_DEF_MNG:String = "ShotPriorityDefMng";
      
      private static const SKU_PLATFORM_SETTINGS_DEF_MNG:String = "PlatformSettingsDefMng";
      
      private static const SKU_FUNNEL_STEP_DEF_MNG:String = "FunnelStepDefMng";
      
      private static const SKU_INVESTS_SETTINGS_DEF_MNG:String = "InvestsSettingsDefMng";
      
      private static const SKU_INVEST_MNG:String = "InvestMng";
      
      private static const SKU_INVEST_REWARDS_DEF_MNG:String = "InvestRewardsDefMng";
      
      private static const SKU_SPY_CAPSULES_SHOP_DEF_MNG:String = "SpyCapsulesShopDefMng";
      
      private static const SKU_NEW_PAYER_PROMO_DEF_MNG:String = "NewPayerPromoDefMng";
      
      private static const SKU_REWARDS_PER_LEVEL_DEF_MNG:String = "RewardsPerLevelDefMng";
      
      private static const SKU_HAPPENING_DEF_MNG:String = "HappeningDefMng";
      
      private static const SKU_HAPPENING_TYPE_DEF_MNG:String = "HappeningTypeDefMng";
      
      private static const SKU_HAPPENING_MNG:String = "HappeningMng";
      
      private static const SKU_WAVE_SPAWN_DEF_MNG:String = "WaveSpawnDefMng";
      
      private static const SKU_WAVE_DEF_MNG:String = "WaveDefMng";
      
      private static const SKU_POWERUP_DEF_MNG:String = "PowerUpDefMng";
      
      private static const SKU_POWERUP_MNG:String = "PowerUpMng";
      
      private static const SKU_POPUP_SKIN_MNG:String = "PopupSkinMng";
      
      private static const SKU_VIEW_FACTORY:String = "ViewFactory";
      
      private static const SKU_E_RESOURCES_MNG:String = "EResourcesMng";
      
      private static const SKU_SKINS_MNG:String = "SkinsMng";
      
      private static const SKU_BET_DEF_MNG:String = "BetDefMng";
      
      private static const SKU_BET_MNG:String = "BetMng";
      
      private static const SKU_BETS_SETTINGS_DEF_MNG:String = "BetsSettingsDefMng";
      
      private static const SKU_BEHAVIORS_MNG:String = "BehaviorsMng";
      
      private static const SKU_CONTEST_MNG:String = "ContestMng";
      
      private static const SKU_CONTEST_DEF_MNG:String = "ContestDefMng";
      
      private static const SKU_UMBRELLA_MNG:String = "UmbrellaMng";
      
      private static const SKU_UMBRELLA_SETTINGS_DEF_MNG:String = "UmbrellaSettingsDefMng";
      
      private static const SKU_UMBRELLA_SKIN_DEF_MNG:String = "UmbrellaSkinDefMng";
      
      private static const SKU_UMBRELLA_SHOP_DEF_MNG:String = "UmbrellaShopDefMng";
      
      private static const SKU_PURCHASE_SHOP_DEF_MNG:String = "PurchaseShopDefMng";
      
      private static const SKU_SHOP_PROGRESS_DEF_MNG:String = "ShopProgressDefMng";
      
      private static const SKU_STAR_TREK_SHOP_DEF_MNG:String = "StarTrekShopDefMng";
      
      private static const SKU_PREMIUM_SHOP_DEF_MNG:String = "PremiumShopDefMng";
      
      private static const SKU_ACTIONS_LIBRARY:String = "ActionsLibrary";
      
      private static const SKU_UPSELLING_MNG:String = "UpSellingMng";
      
      private static const SKU_LOADING_MNG:String = "LoadingMng";
      
      private static const SKU_NOTIFICATIONS_MNG:String = "NotificationsMng";
      
      private static const SKU_SHOPS_DRAWER:String = "ShopsDrawer";
      
      private static const SKU_HELPS_MNG:String = "HelpsMng";
      
      private static const SKU_NPC_DEF_MNG:String = "NpcDefMng";
      
      private static const SKU_ALLIANCES_WAR_TYPE:String = "alliancesWarTypesDefMng";
      
      private static const SKU_WAR_POINTS_PER_HQ_DEF_MNG:String = "warPointsPerHQDefMng";
      
      private static const SKU_POLL_DEF_MNG:String = "PollDefMng";
      
      private static const SKU_POLL_MNG:String = "PollMng";
      
      private static var smInstance:InstanceMng;
       
      
      public function InstanceMng()
      {
         if(smInstance == null)
         {
            super();
            smInstance = this;
         }
         else if(Config.DEBUG_ASSERTS)
         {
            DCDebug.trace("WARNING in InstanceMgr.InstanceMgr(): Only one instance is allowed",1);
         }
      }
      
      public static function getApplication() : Application
      {
         return Application(smInstance.getApplication());
      }
      
      public static function getResourceMng() : ResourceMng
      {
         return ResourceMng(smInstance.getResourceMng());
      }
      
      public static function getViewMng() : DCViewMng
      {
         return smInstance.getViewMng();
      }
      
      public static function getViewMngGame() : ViewMngrGame
      {
         return ViewMngrGame(smInstance.getInstance("ViewMngGame"));
      }
      
      public static function registerViewMngGame(value:ViewMngrGame) : void
      {
         smInstance.registerInstance("ViewMngGame",value);
      }
      
      public static function getViewMngPlanet() : ViewMngPlanet
      {
         return ViewMngPlanet(smInstance.getInstance("ViewMngPlanet"));
      }
      
      public static function registerViewMngPlanet(i:ViewMngPlanet) : void
      {
         smInstance.registerInstance("ViewMngPlanet",i);
      }
      
      public static function getViewMngSpace() : ViewMngSpace
      {
         return ViewMngSpace(smInstance.getInstance("ViewMngSpace"));
      }
      
      public static function registerViewMngSpace(i:ViewMngSpace) : void
      {
         smInstance.registerInstance("ViewMngSpace",i);
      }
      
      public static function registerESelectionCircleMng(i:ESelectionCircleMng) : void
      {
         smInstance.registerInstance("SelectionCircleMng",i);
      }
      
      public static function getRuleMng() : RuleMng
      {
         return RuleMng(smInstance.getRuleMng());
      }
      
      public static function getNotifyMng() : DCNotifyMng
      {
         return DCNotifyMng(smInstance.getNotifyMng());
      }
      
      public static function getSelectionCircleMng() : ESelectionCircleMng
      {
         return ESelectionCircleMng(smInstance.getInstance("SelectionCircleMng"));
      }
      
      public static function getUserDataMng() : UserDataMng
      {
         if(smInstance)
         {
            return UserDataMng(smInstance.getInstance("UserDataMng"));
         }
         return null;
      }
      
      public static function registerUserDataMng(i:UserDataMng) : void
      {
         smInstance.registerInstance("UserDataMng",i);
      }
      
      public static function getMapController() : MapController
      {
         var returnValue:MapController = null;
         switch(getApplication().viewGetMode())
         {
            case 0:
               returnValue = MapController(smInstance.getInstance("MapControllerPlanet"));
               break;
            case 1:
               returnValue = MapControllerSolarSystem(smInstance.getInstance("MapControllerSolarSystem"));
               break;
            case 2:
               returnValue = MapControllerGalaxy(smInstance.getInstance("MapControllerGalaxy"));
         }
         return returnValue;
      }
      
      public static function getMapControllerPlanet() : MapControllerPlanet
      {
         return MapControllerPlanet(smInstance.getInstance("MapControllerPlanet"));
      }
      
      public static function getMapControllerGalaxy() : MapControllerGalaxy
      {
         return MapControllerGalaxy(smInstance.getInstance("MapControllerGalaxy"));
      }
      
      public static function getMapControllerSolarSystem() : MapControllerSolarSystem
      {
         return MapControllerSolarSystem(smInstance.getInstance("MapControllerSolarSystem"));
      }
      
      public static function registerUserInfoMng(i:UserInfoMng) : void
      {
         smInstance.registerInstance("UserInfoMng",i);
      }
      
      public static function getUserInfoMng() : UserInfoMng
      {
         return smInstance.getInstance("UserInfoMng") as UserInfoMng;
      }
      
      public static function registerMapControllerPlanet(i:MapControllerPlanet) : void
      {
         smInstance.registerInstance("MapControllerPlanet",i);
      }
      
      public static function registerMapControllerGalaxy(i:MapControllerGalaxy) : void
      {
         smInstance.registerInstance("MapControllerGalaxy",i);
      }
      
      public static function registerMapControllerSolarSystem(i:MapControllerSolarSystem) : void
      {
         smInstance.registerInstance("MapControllerSolarSystem",i);
      }
      
      public static function getMapModel() : MapModel
      {
         return MapModel(smInstance.getInstance("MapModel"));
      }
      
      public static function registerMapModel(i:MapModel) : void
      {
         smInstance.registerInstance("MapModel",i);
      }
      
      public static function getMapViewPlanet() : MapViewPlanet
      {
         return InstanceMng.getUIFacade().getMapViewPlanet();
      }
      
      public static function getMapViewGalaxy() : MapViewGalaxy
      {
         return InstanceMng.getUIFacade().getMapViewGalaxy();
      }
      
      public static function getMapViewSolarSystem() : MapViewSolarSystem
      {
         return InstanceMng.getUIFacade().getMapViewSolarSystem();
      }
      
      public static function getMapView() : MapView
      {
         var returnValue:MapView = null;
         switch(getApplication().viewGetMode())
         {
            case 0:
               returnValue = getMapViewPlanet();
               break;
            case 1:
               returnValue = getMapViewSolarSystem();
               break;
            case 2:
               returnValue = getMapViewGalaxy();
         }
         return returnValue;
      }
      
      public static function getMapViewDefMng() : DCMapViewDefMng
      {
         return DCMapViewDefMng(smInstance.getInstance("MapViewDefMng"));
      }
      
      public static function registerMapViewDefMng(i:DCMapViewDefMng) : void
      {
         smInstance.registerInstance("MapViewDefMng",i);
      }
      
      public static function getToolsMng() : ToolsMng
      {
         return ToolsMng(smInstance.getInstance("ToolsMng"));
      }
      
      public static function registerToolsMng(i:ToolsMng) : void
      {
         smInstance.registerInstance("ToolsMng",i);
      }
      
      public static function getWorld() : World
      {
         return World(smInstance.getInstance("World"));
      }
      
      public static function registerWorld(i:World) : void
      {
         smInstance.registerInstance("World",i);
      }
      
      public static function getWorldItemDefMng() : WorldItemDefMng
      {
         return WorldItemDefMng(smInstance.getInstance("WorldItemDefMng"));
      }
      
      public static function registerWorldItemDefMng(i:WorldItemDefMng) : void
      {
         smInstance.registerInstance("WorldItemDefMng",i);
      }
      
      public static function getShipDefMng() : ShipDefMng
      {
         return smInstance.getInstance("ShipDefMng") as ShipDefMng;
      }
      
      public static function registerShipDefMng(i:ShipDefMng) : void
      {
         smInstance.registerInstance("ShipDefMng",i);
      }
      
      public static function getUnitDefMng() : UnitDefMng
      {
         return smInstance.getInstance("UnitDefMng") as UnitDefMng;
      }
      
      public static function registerUnitDefMng(i:UnitDefMng) : void
      {
         smInstance.registerInstance("UnitDefMng",i);
      }
      
      public static function registerItemDefMng(i:ItemsDefMng) : void
      {
         smInstance.registerInstance("ItemDefMng",i);
      }
      
      public static function getItemsDefMng() : ItemsDefMng
      {
         return smInstance.getInstance("ItemDefMng") as ItemsDefMng;
      }
      
      public static function registerCollectablesDefMng(i:CollectablesDefMng) : void
      {
         smInstance.registerInstance("CollectablesDef",i);
      }
      
      public static function getCollectablesDefMng() : CollectablesDefMng
      {
         return smInstance.getInstance("CollectablesDef") as CollectablesDefMng;
      }
      
      public static function registerAlliancesRewardDefMng(i:AlliancesRewardDefMng) : void
      {
         smInstance.registerInstance("AlliancesRewardDefMng",i);
      }
      
      public static function unregisterAlliancesRewardDefMng() : void
      {
         smInstance.unregisterInstance("AlliancesRewardDefMng");
      }
      
      public static function getAlliancesRewardDefMng() : AlliancesRewardDefMng
      {
         return smInstance.getInstance("AlliancesRewardDefMng") as AlliancesRewardDefMng;
      }
      
      public static function registerAlliancesRewardsMng(i:AlliancesRewardsMng) : void
      {
         smInstance.registerInstance("AlliancesRewardMng",i);
      }
      
      public static function unregisterAlliancesRewardsMng() : void
      {
         smInstance.unregisterInstance("AlliancesRewardMng");
      }
      
      public static function getAlliancesRewardsMng() : AlliancesRewardsMng
      {
         return smInstance.getInstance("AlliancesRewardMng") as AlliancesRewardsMng;
      }
      
      public static function registerCraftingDefMng(i:CraftingDefMng) : void
      {
         smInstance.registerInstance("CraftingDef",i);
      }
      
      public static function getCraftingDefMng() : CraftingDefMng
      {
         return smInstance.getInstance("CraftingDef") as CraftingDefMng;
      }
      
      public static function registerSpecialAttacksDefMng(i:SpecialAttacksDefMng) : void
      {
         smInstance.registerInstance("SpecialAttacksDef",i);
      }
      
      public static function getSpecialAttacksDefMng() : SpecialAttacksDefMng
      {
         return smInstance.getInstance("SpecialAttacksDef") as SpecialAttacksDefMng;
      }
      
      public static function registerItemMng(i:ItemsMng) : void
      {
         smInstance.registerInstance("ItemsMng",i);
      }
      
      public static function getItemsMng() : ItemsMng
      {
         return smInstance.getInstance("ItemsMng") as ItemsMng;
      }
      
      public static function registerPremiumPricesDefMng(i:PremiumPricesDefMng) : void
      {
         smInstance.registerInstance("PremiumPricesDefMng",i);
      }
      
      public static function getPremiumPricesDefMng() : PremiumPricesDefMng
      {
         return smInstance.getInstance("PremiumPricesDefMng") as PremiumPricesDefMng;
      }
      
      public static function registerProtectionTimeDefMng(i:ProtectionTimeDefMng) : void
      {
         smInstance.registerInstance("ProtectionTimeDefMng",i);
      }
      
      public static function getProtectionTimeDefMng() : ProtectionTimeDefMng
      {
         return smInstance.getInstance("ProtectionTimeDefMng") as ProtectionTimeDefMng;
      }
      
      public static function registerRebornObstaclesDefMng(i:RebornObstaclesDefMng) : void
      {
         smInstance.registerInstance("RebornObstaclesDefMng",i);
      }
      
      public static function getRebornObstaclesDefMng() : RebornObstaclesDefMng
      {
         return smInstance.getInstance("RebornObstaclesDefMng") as RebornObstaclesDefMng;
      }
      
      public static function registerBuyResourcesBoxDefMng(i:BuyResourcesBoxDefMng) : void
      {
         smInstance.registerInstance("BuyResourcesBoxesDefMng",i);
      }
      
      public static function getBuyResourcesBoxDefMng() : BuyResourcesBoxDefMng
      {
         return smInstance.getInstance("BuyResourcesBoxesDefMng") as BuyResourcesBoxDefMng;
      }
      
      public static function registerRewardsDefMng(i:RewardsDefMng) : void
      {
         smInstance.registerInstance("RewardsDefMng",i);
      }
      
      public static function getRewardsDefMng() : RewardsDefMng
      {
         return smInstance.getInstance("RewardsDefMng") as RewardsDefMng;
      }
      
      public static function registerMisteryRewardDefMng(i:MisteryRewardDefMng) : void
      {
         smInstance.registerInstance("MisteryRewardMng",i);
      }
      
      public static function getMisteryRewardDefMng() : MisteryRewardDefMng
      {
         return smInstance.getInstance("MisteryRewardMng") as MisteryRewardDefMng;
      }
      
      public static function getWorldItemObjectController() : WorldItemObjectController
      {
         return WorldItemObjectController(smInstance.getInstance("WorldItemObjectController"));
      }
      
      public static function registerWorldItemObjectController(i:WorldItemObjectController) : void
      {
         smInstance.registerInstance("WorldItemObjectController",i);
      }
      
      public static function getRole() : Role
      {
         return Role(smInstance.getData("Role"));
      }
      
      public static function registerRole(i:Role) : void
      {
         smInstance.registerData("Role",i);
      }
      
      public static function registerGUIController(i:GUIController) : void
      {
         smInstance.registerInstance("GUIController",i);
      }
      
      public static function unregisterGUIController() : void
      {
         smInstance.unregisterInstance("GUIController");
      }
      
      public static function getGUIController() : GUIController
      {
         var returnValue:GUIController = null;
         switch(getApplication().viewGetMode())
         {
            case 0:
               returnValue = GUIController(smInstance.getInstance("GUIControllerPlanet"));
               break;
            case 1:
               returnValue = GUIController(smInstance.getInstance("GUIControllerSolarSystem"));
               break;
            case 2:
               returnValue = GUIController(smInstance.getInstance("GUIControllerGalaxy"));
               break;
            default:
               returnValue = GUIController(smInstance.getInstance("GUIController"));
         }
         return returnValue;
      }
      
      public static function registerGUIControllerPlanet(i:GUIControllerPlanet) : void
      {
         smInstance.registerInstance("GUIControllerPlanet",i);
      }
      
      public static function unregisterGUIControllerPlanet() : void
      {
         smInstance.unregisterInstance("GUIControllerPlanet");
      }
      
      public static function getGUIControllerPlanet() : GUIControllerPlanet
      {
         return GUIControllerPlanet(smInstance.getInstance("GUIControllerPlanet"));
      }
      
      public static function registerGUIControllerGalaxy(i:GUIControllerGalaxy) : void
      {
         smInstance.registerInstance("GUIControllerGalaxy",i);
      }
      
      public static function unregisterGUIControllerGalaxy() : void
      {
         smInstance.unregisterInstance("GUIControllerGalaxy");
      }
      
      public static function getGUIControllerGalaxy() : GUIControllerGalaxy
      {
         return GUIControllerGalaxy(smInstance.getInstance("GUIControllerGalaxy"));
      }
      
      public static function registerGUIControllerSolarSystem(i:GUIControllerSolarSystem) : void
      {
         smInstance.registerInstance("GUIControllerSolarSystem",i);
      }
      
      public static function unregisterGUIControllerSolarSystem() : void
      {
         smInstance.unregisterInstance("GUIControllerSolarSystem");
      }
      
      public static function getGUIControllerSolarSystem() : GUIControllerSolarSystem
      {
         return GUIControllerSolarSystem(smInstance.getInstance("GUIControllerSolarSystem"));
      }
      
      public static function registerPopupMng(i:PopupMng) : void
      {
         smInstance.registerInstance("PopupMng",i);
      }
      
      public static function unregisterPopupMng() : void
      {
         smInstance.unregisterInstance("PopupMng");
      }
      
      public static function getPopupMng() : PopupMng
      {
         return smInstance.getInstance("PopupMng") as PopupMng;
      }
      
      public static function registerWelcomePopupsMng(i:WelcomePopupsMng) : void
      {
         smInstance.registerInstance("WelcomePopupsMng",i);
      }
      
      public static function unregisterWelcomePopupsMng() : void
      {
         smInstance.unregisterInstance("WelcomePopupsMng");
      }
      
      public static function getWelcomePopupsMng() : WelcomePopupsMng
      {
         return smInstance.getInstance("WelcomePopupsMng") as WelcomePopupsMng;
      }
      
      public static function registerBackgroundDefMng(i:BackgroundDefMng) : void
      {
         smInstance.registerInstance("BackgroundDefMng",i);
      }
      
      public static function getBackgroundDefMng() : BackgroundDefMng
      {
         return smInstance.getInstance("BackgroundDefMng") as BackgroundDefMng;
      }
      
      public static function registerLevelScoreDefMng(i:LevelScoreDefMng) : void
      {
         smInstance.registerInstance("LevelScoreDefMng",i);
      }
      
      public static function getLevelScoreDefMng() : LevelScoreDefMng
      {
         return smInstance.getInstance("LevelScoreDefMng") as LevelScoreDefMng;
      }
      
      public static function registerDamageProtectionDefMng(i:DamageProtectionDefMng) : void
      {
         smInstance.registerInstance("DamageProtectionMng",i);
      }
      
      public static function getDamageProtectionDefMng() : DamageProtectionDefMng
      {
         return smInstance.getInstance("DamageProtectionMng") as DamageProtectionDefMng;
      }
      
      public static function registerCreditsDefMng(i:CreditsDefMng) : void
      {
         smInstance.registerInstance("CreditsDefMng",i);
      }
      
      public static function getCreditsMng() : CreditsDefMng
      {
         return smInstance.getInstance("CreditsDefMng") as CreditsDefMng;
      }
      
      public static function registerSettingsDefMng(i:SettingsDefMng) : void
      {
         smInstance.registerInstance("SettingsDefMng",i);
      }
      
      public static function getSettingsDefMng() : SettingsDefMng
      {
         return smInstance.getInstance("SettingsDefMng") as SettingsDefMng;
      }
      
      public static function registerAlliancesSettingsDefMng(i:AlliancesSettingsDefMng) : void
      {
         smInstance.registerInstance("AlliancesSettingsDefMng",i);
      }
      
      public static function getAlliancesSettingsDefMng() : AlliancesSettingsDefMng
      {
         return smInstance.getInstance("AlliancesSettingsDefMng") as AlliancesSettingsDefMng;
      }
      
      public static function registerInvestsSettingsDefMng(i:InvestsSettingsDefMng) : void
      {
         smInstance.registerInstance("InvestsSettingsDefMng",i);
      }
      
      public static function getInvestsSettingsDefMng() : InvestsSettingsDefMng
      {
         return smInstance.getInstance("InvestsSettingsDefMng") as InvestsSettingsDefMng;
      }
      
      public static function registerInvestRewardsDefMng(i:InvestRewardsDefMng) : void
      {
         smInstance.registerInstance("InvestRewardsDefMng",i);
      }
      
      public static function getInvestRewardsDefMng() : InvestRewardsDefMng
      {
         return smInstance.getInstance("InvestRewardsDefMng") as InvestRewardsDefMng;
      }
      
      public static function registerInvestMng(i:InvestMng) : void
      {
         smInstance.registerInstance("InvestMng",i);
      }
      
      public static function getInvestMng() : InvestMng
      {
         return smInstance.getInstance("InvestMng") as InvestMng;
      }
      
      public static function getSpyCapsulesShopDefMng() : SpyCapsulesShopDefMng
      {
         return smInstance.getInstance("SpyCapsulesShopDefMng") as SpyCapsulesShopDefMng;
      }
      
      public static function registerSpyCapsulesShopDefMng(i:SpyCapsulesShopDefMng) : void
      {
         smInstance.registerInstance("SpyCapsulesShopDefMng",i);
      }
      
      public static function getNewPayerPromoDefMng() : NewPayerPromoDefMng
      {
         return smInstance.getInstance("NewPayerPromoDefMng") as NewPayerPromoDefMng;
      }
      
      public static function registerNewPayerPromoDefMng(i:NewPayerPromoDefMng) : void
      {
         smInstance.registerInstance("NewPayerPromoDefMng",i);
      }
      
      public static function registerShotPriorityDefMng(i:ShotPriorityDefMng) : void
      {
         smInstance.registerInstance("ShotPriorityDefMng",i);
      }
      
      public static function getShotPriorityDefMng() : ShotPriorityDefMng
      {
         return smInstance.getInstance("ShotPriorityDefMng") as ShotPriorityDefMng;
      }
      
      public static function registerGUIDefMng(i:DCGUIDefMng) : void
      {
         smInstance.registerInstance("GUIDefMng",i);
      }
      
      public static function getGUIDefMng() : DCGUIDefMng
      {
         return smInstance.getInstance("GUIDefMng") as DCGUIDefMng;
      }
      
      public static function registerBuildingsShopController(i:BuildingsShopController) : void
      {
         smInstance.registerInstance("ShopController",i);
      }
      
      public static function registerBuildingsBufferController(i:BuildingsBufferController) : void
      {
         smInstance.registerInstance("BufferController",i);
      }
      
      public static function unregisterShopController() : void
      {
         smInstance.unregisterInstance("ShopController");
      }
      
      public static function getBuildingsShopController() : BuildingsShopController
      {
         return BuildingsShopController(smInstance.getInstance("ShopController"));
      }
      
      public static function getBuildingsBufferController() : BuildingsBufferController
      {
         return BuildingsBufferController(smInstance.getInstance("BufferController"));
      }
      
      public static function registerShipyardController(i:ShipyardController) : void
      {
         smInstance.registerInstance("ShipyardController",i);
      }
      
      public static function unregisterShipyardController() : void
      {
         smInstance.unregisterInstance("ShipyardController");
      }
      
      public static function getShipyardController() : ShipyardController
      {
         return ShipyardController(smInstance.getInstance("ShipyardController"));
      }
      
      public static function registerHudController(i:HudController) : void
      {
         smInstance.registerInstance("HudController",i);
      }
      
      public static function getHudController() : HudController
      {
         return smInstance.getInstance("HudController") as HudController;
      }
      
      public static function getTopHudFacade() : TopHudFacade
      {
         return getUIFacade().getTopHudFacade();
      }
      
      public static function getReplayBar() : ReplayBarFacade
      {
         return getUIFacade().getReplayBar();
      }
      
      public static function registerUIFacade(i:UIFacade) : void
      {
         smInstance.registerInstance("UIFacade",i);
      }
      
      public static function getUIFacade() : UIFacade
      {
         return smInstance.getInstance("UIFacade") as UIFacade;
      }
      
      public static function registerDroidDefMng(i:DroidDefMng) : void
      {
         smInstance.registerInstance("DroidDefMng",i);
      }
      
      public static function getDroidDefMng() : DroidDefMng
      {
         return smInstance.getInstance("DroidDefMng") as DroidDefMng;
      }
      
      public static function registerCivilDefMng(i:CivilDefMng) : void
      {
         smInstance.registerInstance("CivilDefMng",i);
      }
      
      public static function getCivilDefMng() : CivilDefMng
      {
         return smInstance.getInstance("CivilDefMng") as CivilDefMng;
      }
      
      public static function registerAnimationsDefMng(i:AnimationsDefMng) : void
      {
         smInstance.registerInstance("AnimDefMng",i);
      }
      
      public static function getAnimationsDefMng() : AnimationsDefMng
      {
         return smInstance.getInstance("AnimDefMng") as AnimationsDefMng;
      }
      
      public static function getCollisionBoxMng() : CollisionBoxMng
      {
         return CollisionBoxMng(smInstance.getCollisionBoxMng());
      }
      
      public static function registerCollisionBoxMng(i:DCCollisionBoxMng) : void
      {
         smInstance.registerCollisionBoxMng(i);
      }
      
      public static function getAnimMng() : AnimMng
      {
         return AnimMng(smInstance.getAnimMng());
      }
      
      public static function registerAnimMng(i:AnimMng) : void
      {
         smInstance.registerAnimMng(i);
      }
      
      public static function getPoolMng() : PoolMng
      {
         return PoolMng(smInstance.getPoolMng());
      }
      
      public static function registerPoolMng(i:PoolMng) : void
      {
         smInstance.registerPoolMng(i);
      }
      
      public static function registerPlatformSettingsDefMng(i:PlatformSettingsDefMng) : void
      {
         smInstance.registerInstance("PlatformSettingsDefMng",i);
      }
      
      public static function getPlatformSettingsDefMng() : PlatformSettingsDefMng
      {
         return smInstance.getInstance("PlatformSettingsDefMng") as PlatformSettingsDefMng;
      }
      
      public static function getTargetDefMng() : TargetDefMng
      {
         return smInstance.getData("TargetDefMng") as TargetDefMng;
      }
      
      public static function registerTargetDefMng(i:TargetDefMng) : void
      {
         smInstance.registerData("TargetDefMng",i);
      }
      
      public static function getTargetMng() : TargetMng
      {
         return smInstance.getData("TargetMng") as TargetMng;
      }
      
      public static function registerTargetMng(i:TargetMng) : void
      {
         smInstance.registerData("TargetMng",i);
      }
      
      public static function getMissionsMng() : MissionsMng
      {
         return smInstance.getData("MissionsMng") as MissionsMng;
      }
      
      public static function registerMissionsMng(i:MissionsMng) : void
      {
         smInstance.registerData("MissionsMng",i);
      }
      
      public static function getAlliancesController() : AlliancesController
      {
         return smInstance.getData("AlliancesController") as AlliancesController;
      }
      
      public static function registerAlliancesController(i:AlliancesController) : void
      {
         smInstance.registerData("AlliancesController",i);
      }
      
      public static function unregisterAlliancesController() : void
      {
         smInstance.unregisterInstance("AlliancesController");
      }
      
      public static function getFlowState() : FlowState
      {
         var returnValue:FlowState = null;
         switch(getApplication().viewGetMode())
         {
            case 0:
               returnValue = getFlowStatePlanet();
               break;
            case 1:
               returnValue = getFlowStateSolarSystem();
               break;
            case 2:
               returnValue = getFlowStateGalaxy();
         }
         return returnValue;
      }
      
      public static function registerFlowStatePlanet(i:FlowStatePlanet) : void
      {
         smInstance.registerData("FlowStatePlanet",i);
      }
      
      public static function getFlowStatePlanet() : FlowStatePlanet
      {
         return FlowStatePlanet(smInstance.getData("FlowStatePlanet"));
      }
      
      public static function registerFlowStateGalaxy(i:FlowStateGalaxy) : void
      {
         smInstance.registerData("FlowStateGalaxy",i);
      }
      
      public static function getFlowStateGalaxy() : FlowStateGalaxy
      {
         return FlowStateGalaxy(smInstance.getData("FlowStateGalaxy"));
      }
      
      public static function registerFlowStateSolarSystem(i:FlowStateSolarSystem) : void
      {
         smInstance.registerData("FlowStateSolarSystem",i);
      }
      
      public static function getFlowStateSolarSystem() : FlowStateSolarSystem
      {
         return FlowStateSolarSystem(smInstance.getData("FlowStateSolarSystem"));
      }
      
      public static function registerHangarControllerMng(i:HangarControllerMng) : void
      {
         smInstance.registerData("HangarController",i);
      }
      
      public static function unregisterHangarControllerMng() : void
      {
         smInstance.unregisterInstance("HangarController");
      }
      
      public static function getHangarControllerMng() : HangarControllerMng
      {
         return HangarControllerMng(smInstance.getData("HangarController"));
      }
      
      public static function registerUnitScene(i:UnitScene) : void
      {
         smInstance.registerData("UnitScene",i);
      }
      
      public static function getUnitScene() : UnitScene
      {
         return UnitScene(smInstance.getData("UnitScene"));
      }
      
      public static function registerTrafficMng(i:TrafficMng) : void
      {
         smInstance.registerData("TrafficMng",i);
      }
      
      public static function getTrafficMng() : TrafficMng
      {
         return TrafficMng(smInstance.getData("TrafficMng"));
      }
      
      public static function registerGraphicsCacheMng(i:GraphicsCacheMng) : void
      {
         smInstance.registerData("GraphicsCacheMng",i);
      }
      
      public static function unregisterGraphicsCacheMng() : void
      {
         smInstance.unregisterInstance("GraphicsCacheMng");
      }
      
      public static function getGraphicsCacheMng() : GraphicsCacheMng
      {
         return smInstance.getData("GraphicsCacheMng") as GraphicsCacheMng;
      }
      
      public static function registerCacheMng(i:CacheMng) : void
      {
         smInstance.registerData("CacheMng",i);
      }
      
      public static function unregisterCacheMng() : void
      {
         smInstance.unregisterInstance("CacheMng");
      }
      
      public static function getCacheMng() : CacheMng
      {
         return smInstance.getData("CacheMng") as CacheMng;
      }
      
      public static function registerBackgroundController(i:BackgroundController) : void
      {
         smInstance.registerData("BackgroundController",i);
      }
      
      public static function unregisterBackgroundController() : void
      {
         smInstance.unregisterInstance("BackgroundController");
      }
      
      public static function getBackgroundController() : BackgroundController
      {
         return BackgroundController(smInstance.getData("BackgroundController"));
      }
      
      public static function registerBunkerController(i:BunkerController) : void
      {
         smInstance.registerData("BunkerController",i);
      }
      
      public static function unregisterBunkerController() : void
      {
         smInstance.unregisterInstance("BunkerController");
      }
      
      public static function getBunkerController() : BunkerController
      {
         return BunkerController(smInstance.getData("BunkerController"));
      }
      
      public static function registerGameUnitMngController(i:GameUnitMngController) : void
      {
         smInstance.registerData("GameUnitMng",i);
      }
      
      public static function unregisterGameUnitMngController() : void
      {
         smInstance.unregisterInstance("GameUnitMng");
      }
      
      public static function getGameUnitMngController() : GameUnitMngController
      {
         return GameUnitMngController(smInstance.getData("GameUnitMng"));
      }
      
      public static function registerVisitorMng(i:VisitorMng) : void
      {
         smInstance.registerData("VisitorMng",i);
      }
      
      public static function unregisterVisitorMng() : void
      {
         smInstance.unregisterInstance("VisitorMng");
      }
      
      public static function getVisitorMng() : VisitorMng
      {
         return VisitorMng(smInstance.getData("VisitorMng"));
      }
      
      public static function registerDailyRewardMng(i:DailyRewardMng) : void
      {
         smInstance.registerData("DailyRewardMng",i);
      }
      
      public static function unregisterDailyRewardMng() : void
      {
         smInstance.unregisterInstance("DailyRewardMng");
      }
      
      public static function getDailyRewardMng() : DailyRewardMng
      {
         return DailyRewardMng(smInstance.getData("DailyRewardMng"));
      }
      
      public static function registerHotkeyMng(i:HotkeyMng) : void
      {
         smInstance.registerData("HotkeyMng",i);
      }
      
      public static function unregisterHotkeyMng() : void
      {
         smInstance.unregisterInstance("HotkeyMng");
      }
      
      public static function getHotkeyMng() : HotkeyMng
      {
         return HotkeyMng(smInstance.getData("HotkeyMng"));
      }
      
      public static function registerPopupEffects(i:PopupEffects) : void
      {
         smInstance.registerData("PopupEffects",i);
      }
      
      public static function unregisterPopupEffects() : void
      {
         smInstance.unregisterInstance("PopupEffects");
      }
      
      public static function getPopupEffects() : PopupEffects
      {
         return smInstance.getData("PopupEffects") as PopupEffects;
      }
      
      public static function registerSolarSystemDefMng(i:SolarSystemDefMng) : void
      {
         smInstance.registerInstance("SolarSystemDefMng",i);
      }
      
      public static function getSolarSystemDefMng() : SolarSystemDefMng
      {
         return smInstance.getInstance("SolarSystemDefMng") as SolarSystemDefMng;
      }
      
      public static function registerPlanetDefMng(i:PlanetDefMng) : void
      {
         smInstance.registerInstance("PlanetDefMng",i);
      }
      
      public static function getPlanetDefMng() : PlanetDefMng
      {
         return smInstance.getInstance("PlanetDefMng") as PlanetDefMng;
      }
      
      public static function registerAlliancesLevelDefMng(i:AlliancesLevelDefMng) : void
      {
         smInstance.registerInstance("AlliancesLevelDefMng",i);
      }
      
      public static function getAlliancesLevelDefMng() : AlliancesLevelDefMng
      {
         return smInstance.getInstance("AlliancesLevelDefMng") as AlliancesLevelDefMng;
      }
      
      public static function registerFlagImagesDefMng(i:FlagImagesDefMng) : void
      {
         smInstance.registerInstance("FlagImagesDefMng",i);
      }
      
      public static function getFlagImagesDefMng() : FlagImagesDefMng
      {
         return smInstance.getInstance("FlagImagesDefMng") as FlagImagesDefMng;
      }
      
      public static function registerTutorialKidnapMng(i:TutorialKidnapMng) : void
      {
         smInstance.registerData("TutorialKidnapMng",i);
      }
      
      public static function unregisterTutorialKidnapMng() : void
      {
         smInstance.unregisterInstance("TutorialKidnapMng");
      }
      
      public static function getTutorialKidnapMng() : TutorialKidnapMng
      {
         return TutorialKidnapMng(smInstance.getData("TutorialKidnapMng"));
      }
      
      public static function registerCustomizerMng(i:CustomizerMng) : void
      {
         smInstance.registerData("CustomizerMng",i);
      }
      
      public static function unregisterCustomizerMng() : void
      {
         smInstance.unregisterInstance("CustomizerMng");
      }
      
      public static function getCustomizerMng() : CustomizerMng
      {
         return CustomizerMng(smInstance.getData("CustomizerMng"));
      }
      
      public static function registerJailAnimMng(i:JailAnimMng) : void
      {
         smInstance.registerData("JailAnimMng",i);
      }
      
      public static function unregisterJailAnimMng() : void
      {
         smInstance.unregisterInstance("JailAnimMng");
      }
      
      public static function getJailAnimMng() : JailAnimMng
      {
         return JailAnimMng(smInstance.getData("JailAnimMng"));
      }
      
      public static function registerFunnelStepDefMng(i:FunnelStepDefMng) : void
      {
         smInstance.registerInstance("FunnelStepDefMng",i);
      }
      
      public static function getFunnelStepDefMng() : FunnelStepDefMng
      {
         return FunnelStepDefMng(smInstance.getInstance("FunnelStepDefMng"));
      }
      
      public static function registerHappeningDefMng(i:HappeningDefMng) : void
      {
         smInstance.registerData("HappeningDefMng",i);
      }
      
      public static function unregisterHappeningDefMng() : void
      {
         smInstance.unregisterInstance("HappeningDefMng");
      }
      
      public static function getHappeningDefMng() : HappeningDefMng
      {
         return HappeningDefMng(smInstance.getInstance("HappeningDefMng"));
      }
      
      public static function registerWaveSpawnDefMng(i:WaveSpawnDefMng) : void
      {
         smInstance.registerData("WaveSpawnDefMng",i);
      }
      
      public static function unregisterWaveSpawnDefMng() : void
      {
         smInstance.unregisterInstance("WaveSpawnDefMng");
      }
      
      public static function getWaveSpawnDefMng() : WaveSpawnDefMng
      {
         return WaveSpawnDefMng(smInstance.getInstance("WaveSpawnDefMng"));
      }
      
      public static function registerWaveDefMng(i:WaveDefMng) : void
      {
         smInstance.registerData("WaveDefMng",i);
      }
      
      public static function unregisterWaveDefMng() : void
      {
         smInstance.unregisterInstance("WaveDefMng");
      }
      
      public static function getWaveDefMng() : WaveDefMng
      {
         return WaveDefMng(smInstance.getInstance("WaveDefMng"));
      }
      
      public static function getPopupSkinDefMng() : PopupSkinDefMng
      {
         return PopupSkinDefMng(smInstance.getInstance("PopupSkinMng"));
      }
      
      public static function registerPopupSkinDefMng(i:PopupSkinDefMng) : void
      {
         smInstance.registerData("PopupSkinMng",i);
      }
      
      public static function unregisterPopupSkinDefMng() : void
      {
         smInstance.unregisterInstance("PopupSkinMng");
      }
      
      public static function registerBetDefMng(i:BetDefMng) : void
      {
         smInstance.registerData("BetDefMng",i);
      }
      
      public static function unregisterBetDefMng() : void
      {
         smInstance.unregisterInstance("BetDefMng");
      }
      
      public static function getBetDefMng() : BetDefMng
      {
         return BetDefMng(smInstance.getInstance("BetDefMng"));
      }
      
      public static function registerBetMng(i:BetMng) : void
      {
         smInstance.registerData("BetMng",i);
      }
      
      public static function unregisterBetMng() : void
      {
         smInstance.unregisterInstance("BetMng");
      }
      
      public static function getBetMng() : BetMng
      {
         return BetMng(smInstance.getInstance("BetMng"));
      }
      
      public static function registerBetsSettingsDefMng(i:BetsSettingsDefMng) : void
      {
         smInstance.registerInstance("BetsSettingsDefMng",i);
      }
      
      public static function getBetsSettingsDefMng() : BetsSettingsDefMng
      {
         return smInstance.getInstance("BetsSettingsDefMng") as BetsSettingsDefMng;
      }
      
      public static function registerHappeningTypeDefMng(i:HappeningTypeDefMng) : void
      {
         smInstance.registerData("HappeningTypeDefMng",i);
      }
      
      public static function unregisterHappeningTypeDefMng() : void
      {
         smInstance.unregisterInstance("HappeningTypeDefMng");
      }
      
      public static function getHappeningTypeDefMng() : HappeningTypeDefMng
      {
         return HappeningTypeDefMng(smInstance.getInstance("HappeningTypeDefMng"));
      }
      
      public static function registerHappeningMng(i:HappeningMng) : void
      {
         smInstance.registerData("HappeningMng",i);
      }
      
      public static function unregisterHappeningMng() : void
      {
         smInstance.unregisterInstance("HappeningMng");
      }
      
      public static function getHappeningMng() : HappeningMng
      {
         return HappeningMng(smInstance.getInstance("HappeningMng"));
      }
      
      public static function registerPowerUpDefMng(i:PowerUpDefMng) : void
      {
         smInstance.registerData("PowerUpDefMng",i);
      }
      
      public static function unregisterPowerUpDefMng() : void
      {
         smInstance.unregisterInstance("PowerUpDefMng");
      }
      
      public static function getPowerUpDefMng() : PowerUpDefMng
      {
         return PowerUpDefMng(smInstance.getInstance("PowerUpDefMng"));
      }
      
      public static function registerPowerUpMng(i:PowerUpMng) : void
      {
         smInstance.registerData("PowerUpMng",i);
      }
      
      public static function unregisterPowerUpMng() : void
      {
         smInstance.unregisterInstance("PowerUpMng");
      }
      
      public static function getPowerUpMng() : PowerUpMng
      {
         return PowerUpMng(smInstance.getInstance("PowerUpMng"));
      }
      
      public static function registerViewFactory(i:ViewFactory) : void
      {
         smInstance.registerData("ViewFactory",i);
      }
      
      public static function unregisterViewFactory() : void
      {
         smInstance.unregisterInstance("ViewFactory");
      }
      
      public static function getViewFactory() : ViewFactory
      {
         return ViewFactory(smInstance.getInstance("ViewFactory"));
      }
      
      public static function registerEResourcesMng(i:ResourcesMng) : void
      {
         smInstance.registerData("EResourcesMng",i);
      }
      
      public static function unregisterEResourcesMng() : void
      {
         smInstance.unregisterInstance("EResourcesMng");
      }
      
      public static function getEResourcesMng() : ResourcesMng
      {
         return ResourcesMng(smInstance.getInstance("EResourcesMng"));
      }
      
      public static function registerSkinsMng(i:SkinsMng) : void
      {
         smInstance.registerData("SkinsMng",i);
      }
      
      public static function unregisterSkinsMng() : void
      {
         smInstance.unregisterInstance("SkinsMng");
      }
      
      public static function getSkinsMng() : SkinsMng
      {
         return SkinsMng(smInstance.getInstance("SkinsMng"));
      }
      
      public static function registerBehaviorsMng(i:BehaviorsMng) : void
      {
         smInstance.registerData("BehaviorsMng",i);
      }
      
      public static function unregisterBehaviorsMng() : void
      {
         smInstance.unregisterInstance("BehaviorsMng");
      }
      
      public static function getBehaviorsMng() : BehaviorsMng
      {
         return BehaviorsMng(smInstance.getInstance("BehaviorsMng"));
      }
      
      public static function registerContestMng(i:ContestMng) : void
      {
         smInstance.registerData("ContestMng",i);
      }
      
      public static function unregisterContestMng() : void
      {
         smInstance.unregisterInstance("ContestMng");
      }
      
      public static function getContestMng() : ContestMng
      {
         return ContestMng(smInstance.getInstance("ContestMng"));
      }
      
      public static function registerContestDefMng(i:ContestDefMng) : void
      {
         smInstance.registerInstance("ContestDefMng",i);
      }
      
      public static function getContestDefMng() : ContestDefMng
      {
         return smInstance.getInstance("ContestDefMng") as ContestDefMng;
      }
      
      public static function registerUmbrellaMng(i:UmbrellaMng) : void
      {
         smInstance.registerInstance("UmbrellaMng",i);
      }
      
      public static function unregisterUmbrellaMng() : void
      {
         smInstance.unregisterInstance("UmbrellaMng");
      }
      
      public static function getUmbrellaMng() : UmbrellaMng
      {
         return smInstance.getInstance("UmbrellaMng") as UmbrellaMng;
      }
      
      public static function registerUmbrellaSettingsDefMng(i:UmbrellaSettingsDefMng) : void
      {
         smInstance.registerInstance("UmbrellaSettingsDefMng",i);
      }
      
      public static function getUmbrellaSettingsDefMng() : UmbrellaSettingsDefMng
      {
         return smInstance.getInstance("UmbrellaSettingsDefMng") as UmbrellaSettingsDefMng;
      }
      
      public static function registerUmbrellaSkinDefMng(i:UmbrellaSkinDefMng) : void
      {
         smInstance.registerInstance("UmbrellaSkinDefMng",i);
      }
      
      public static function getUmbrellaSkinDefMng() : UmbrellaSkinDefMng
      {
         return smInstance.getInstance("UmbrellaSkinDefMng") as UmbrellaSkinDefMng;
      }
      
      public static function registerPurchaseShopDefMng(i:PurchaseShopDefMng) : void
      {
         smInstance.registerInstance("PurchaseShopDefMng",i);
      }
      
      public static function unregisterPurchaseShopDefMng() : void
      {
         smInstance.unregisterInstance("PurchaseShopDefMng");
      }
      
      public static function getPurchaseShopDefMng() : PurchaseShopDefMng
      {
         return smInstance.getInstance("PurchaseShopDefMng") as PurchaseShopDefMng;
      }
      
      public static function registerShopProgressDefMng(i:ShopProgressDefMng) : void
      {
         smInstance.registerInstance("ShopProgressDefMng",i);
      }
      
      public static function unregisterShopProgressDefMng() : void
      {
         smInstance.unregisterInstance("ShopProgressDefMng");
      }
      
      public static function getShopProgressDefMng() : ShopProgressDefMng
      {
         return smInstance.getInstance("ShopProgressDefMng") as ShopProgressDefMng;
      }
      
      public static function registerPremiumShopDefMng(i:ShopDefMng) : void
      {
         smInstance.registerInstance("PremiumShopDefMng",i);
      }
      
      public static function unregisterPremiumShopDefMng() : void
      {
         smInstance.unregisterInstance("PremiumShopDefMng");
      }
      
      public static function getPremiumShopDefMng() : ShopDefMng
      {
         return smInstance.getInstance("PremiumShopDefMng") as ShopDefMng;
      }
      
      public static function registerActionsLibrary(i:ActionsLibrary) : void
      {
         smInstance.registerInstance("ActionsLibrary",i);
      }
      
      public static function unregisterActionsLibrary() : void
      {
         smInstance.unregisterInstance("ActionsLibrary");
      }
      
      public static function getActionsLibrary() : ActionsLibrary
      {
         return smInstance.getInstance("ActionsLibrary") as ActionsLibrary;
      }
      
      public static function registerUpSellingMng(i:UpSellingMng) : void
      {
         smInstance.registerInstance("UpSellingMng",i);
      }
      
      public static function unregisterUpSellingMng() : void
      {
         smInstance.unregisterInstance("UpSellingMng");
      }
      
      public static function getUpSellingMng() : UpSellingMng
      {
         return smInstance.getInstance("UpSellingMng") as UpSellingMng;
      }
      
      public static function registerLoadingMng(i:LoadingMng) : void
      {
         smInstance.registerInstance("LoadingMng",i);
      }
      
      public static function getLoadingMng() : LoadingMng
      {
         return smInstance.getInstance("LoadingMng") as LoadingMng;
      }
      
      public static function unregisterLoadingMng() : void
      {
         smInstance.unregisterInstance("LoadingMng");
      }
      
      public static function registerNotificationsMng(i:NotificationsMng) : void
      {
         smInstance.registerInstance("NotificationsMng",i);
      }
      
      public static function getNotificationsMng() : NotificationsMng
      {
         return smInstance.getInstance("NotificationsMng") as NotificationsMng;
      }
      
      public static function unregisterNotificationsMng() : void
      {
         smInstance.unregisterInstance("NotificationsMng");
      }
      
      public static function registerShopsDrawer(i:ShopsDrawer) : void
      {
         smInstance.registerInstance("ShopsDrawer",i);
      }
      
      public static function unregisterShopsDrawer() : void
      {
         smInstance.unregisterInstance("ShopsDrawer");
      }
      
      public static function getShopsDrawer() : ShopsDrawer
      {
         return smInstance.getInstance("ShopsDrawer") as ShopsDrawer;
      }
      
      public static function registerHelpsDefMng(i:HelpsDefMng) : void
      {
         smInstance.registerInstance("HelpsMng",i);
      }
      
      public static function unregisterHelpsDefMng() : void
      {
         smInstance.unregisterInstance("HelpsMng");
      }
      
      public static function getHelpsDefMng() : HelpsDefMng
      {
         return smInstance.getInstance("HelpsMng") as HelpsDefMng;
      }
      
      public static function registerNPCDefMng(i:NPCDefMng) : void
      {
         smInstance.registerInstance("NpcDefMng",i);
      }
      
      public static function unregisterNPCDefMng() : void
      {
         smInstance.unregisterInstance("NpcDefMng");
      }
      
      public static function getNPCDefMng() : NPCDefMng
      {
         return smInstance.getInstance("NpcDefMng") as NPCDefMng;
      }
      
      public static function registerAlliancesWarTypesDefMng(i:AlliancesWarTypesDefMng) : void
      {
         smInstance.registerInstance("alliancesWarTypesDefMng",i);
      }
      
      public static function unregisterAlliancesWarTypesDefMng() : void
      {
         smInstance.unregisterInstance("alliancesWarTypesDefMng");
      }
      
      public static function getAlliancesWarTypesDefMng() : AlliancesWarTypesDefMng
      {
         return smInstance.getInstance("alliancesWarTypesDefMng") as AlliancesWarTypesDefMng;
      }
      
      public static function registerWarPointsPerHQDefMng(i:WarPointsPerHQDefMng) : void
      {
         smInstance.registerInstance("warPointsPerHQDefMng",i);
      }
      
      public static function unregisterWarPointsPerHQDefMng() : void
      {
         smInstance.unregisterInstance("warPointsPerHQDefMng");
      }
      
      public static function getWarPointsPerHQDefMng() : WarPointsPerHQDefMng
      {
         return smInstance.getInstance("warPointsPerHQDefMng") as WarPointsPerHQDefMng;
      }
      
      public static function registerPollDefMng(i:PollDefMng) : void
      {
         smInstance.registerInstance("PollDefMng",i);
      }
      
      public static function getPollDefMng() : PollDefMng
      {
         return smInstance.getInstance("PollDefMng") as PollDefMng;
      }
      
      public static function registerPollMng(i:PollMng) : void
      {
         smInstance.registerData("PollMng",i);
      }
      
      public static function unregisterPollMng() : void
      {
         smInstance.unregisterInstance("PollMng");
      }
      
      public static function getPollMng() : PollMng
      {
         return PollMng(smInstance.getData("PollMng"));
      }
      
      override public function unload() : void
      {
         super.unload();
         smInstance = null;
      }
   }
}
