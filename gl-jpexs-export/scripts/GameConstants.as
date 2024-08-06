package
{
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import com.reygazu.anticheat.variables.SecureObject;
   import flash.filters.BlurFilter;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.utils.Dictionary;
   
   public class GameConstants
   {
      
      public static const BROWSER_FIREFOX_ID:String = "mozilla";
      
      public static const BROWSER_OPERA_ID:String = "opera";
      
      public static const BROWSER_CHROME_ID:String = "webkit";
      
      public static const BROWSER_IE_ID:String = "msie";
      
      public static const FRAMERATE_LIMIT_MIN:int = 5;
      
      public static const FRAMERATE_LIMIT_MAX:int = 120;
      
      public static const COLONY_SHIELD_REASON_TOO_MUCH_DAMAGE:int = 0;
      
      public static const COLONY_SHIELD_REASON_TOO_MANY_ATTACKS:int = 1;
      
      public static const TIME_LEFT_COLONY_SHIELD:String = "shield";
      
      public static const TIME_LEFT_POWER_UPS:String = "powerups";
      
      public static const TIME_LEFT_ONLINE_PROTECTION:String = "onlineProtection";
      
      public static const PURCHASE_SHOP_PREMIUM:String = "premium";
      
      public static const PURCHASE_SHOP_STAR_TREK:String = "starTrek";
      
      public static const POPUP_SKIN_DEFAULT:String = "default";
      
      public static const PLATFORM_FACEBOOK:String = "facebook";
      
      public static const UNIT_NO_BREED_COLOR:String = "noBreedColor";
      
      public static const UNIT_HAS_OWN_DEATH_ANIM:String = "hasOwnDeathAnim";
      
      public static const UNIT_MELEE:String = "melee";
      
      public static const UNIT_WAIT_FOR_SHOOT:String = "waitForShoot";
      
      public static const UNIT_SHOT_QUIET:String = "shotQuiet";
      
      public static const UNIT_FLOATING:String = "floating";
      
      public static const COMING_SOON:String = "ComingSoon";
      
      public static const FREE_SLOTS_OLD_SHIPYARDS:int = 3;
      
      public static const FREE_SLOTS_NEW_SHIPYARDS:int = 2;
      
      public static const EVENT_MISSION_CLICKED:String = "clickMission";
      
      public static const EVENT_MISSION_CLICK_POPUP:String = "clickPopup";
      
      public static const EVENT_MISSION_CLICK_COLLECT_RENT:String = "clickOnCompactHouse";
      
      public static const EVENT_MISSION_CLOSE_POPUP_REWARD:String = "closePopupReward";
      
      public static const EVENT_MISSION_WOW_EFFECT_OVER:String = "wowEffectOver";
      
      public static const EVENT_MISSION_GO_TO_SHOP:String = "goToShop";
      
      public static const EVENT_MISSION_CLICK_ON_MAP:String = "clickOnMap";
      
      public static const SHIPS_HIGH:int = -200;
      
      public static const FILTER_GLOW_YELLOW_HIGH:GlowFilter = new GlowFilter(16776960,1,25,25,1);
      
      public static const FILTER_GLOW_BLUE_LOW:GlowFilter = new GlowFilter(2003199,1,10,10);
      
      public static const FILTER_GLOW_BLUE_HIGH:GlowFilter = new GlowFilter(2003199,1,20,20);
      
      public static const FILTER_GLOW_BLUE_LASER:GlowFilter = new GlowFilter(2003199,1,10,10,6);
      
      public static const FILTER_GLOW_BLUE_ROUGH:GlowFilter = new GlowFilter(2003199,1,8,8,2);
      
      public static const FILTER_GLOW_UMBRELLA:GlowFilter = new GlowFilter(11123432,1,8,8,2);
      
      public static const FILTER_GLOW_BLUE_ITEMS:GlowFilter = new GlowFilter(2003199,1,20,20,1);
      
      public static const FILTER_GLOW_WHITE_LOW:GlowFilter = new GlowFilter(16777215,1,10,10);
      
      public static const FILTER_GLOW_WHITE_HIGH:GlowFilter = new GlowFilter(16777215,1,25,25,1);
      
      public static const FILTER_GLOW_GREEN_LOW:GlowFilter = new GlowFilter(65280,1,4,4,2,2);
      
      public static const FILTER_GLOW_GREEN_HIGH:GlowFilter = new GlowFilter(65280,1,8,8,2,2);
      
      public static const FILTER_GLOW_PURPLE_LOW:GlowFilter = new GlowFilter(10040319,1,10,10);
      
      public static const FILTER_GLOW_PURPLE_HIGH:GlowFilter = new GlowFilter(10040319,1,20,20);
      
      public static const FILTER_GLOW_SELECTED_SHIPYARD:GlowFilter = new GlowFilter(16488754,1,20,20);
      
      public static const FILTER_GLOW_BURN:GlowFilter = new GlowFilter(16546563,1,16,16,3);
      
      public static const FILTER_GLOW_RED_LOW:GlowFilter = new GlowFilter(16711731,1,4,4,2,2);
      
      public static const FILTER_GLOW_RED_HIGH:GlowFilter = new GlowFilter(16711731,1,8,8,2,2);
      
      public static const FILTER_GLOW_RED_LASER:GlowFilter = new GlowFilter(16711680,1,10,10,6);
      
      public static const FILTER_DROPSHADOW_YELLOW:DropShadowFilter = new DropShadowFilter(0,45,16776960,1,3,3,5,3);
      
      public static const FILTER_DROPSHADOW_WHITE:DropShadowFilter = new DropShadowFilter(0,45,16777215,1,3,3,5,3);
      
      public static const FILTER_AVAILABLE_BUILDING_GREEN:DropShadowFilter = new DropShadowFilter(0,45,12451631,1,3,3,100,3);
      
      public static const FILTER_UNAVAILABLE_BUILDING_RED:DropShadowFilter = new DropShadowFilter(0,45,15252254,1,3,3,100,3);
      
      public static const FILTER_WAITING_FOR_DROID_FOR_RECYCLING_BLUE:GlowFilter = new GlowFilter(65520,1,25,25);
      
      public static const FILTER_BLUR_SCREENSHOT:BlurFilter = new BlurFilter(3,3,1);
      
      public static const FILTER_AIR_UNITS_SHADOW:DropShadowFilter = new DropShadowFilter(70,90,0,0.3);
      
      public static const FILTER_BROWN_POPUP:GlowFilter = new GlowFilter(16301120,1,8,8,2);
      
      public static const FILTER_GLOW_CAN_BE_SPIED:DropShadowFilter = new DropShadowFilter(0,45,16777215,1,6,6,5,3);
      
      public static const FILTER_SPY_CAPSULE_NOT_SELECTED:GlowFilter = new GlowFilter(10092492,1,10,10,2,1,true);
      
      public static const FILTER_SPY_CAPSULE_SELECTED:GlowFilter = new GlowFilter(16777215,1,10,10,2,1,true);
      
      public static const FILTER_SPY_CAPSULE_ADVANCED_NOT_SELECTED:GlowFilter = new GlowFilter(16750848,1,10,10,2,1,true);
      
      public static const FILTER_SPY_CAPSULE_ADVANCED_SELECTED:GlowFilter = new GlowFilter(16776960,1,10,10,2,1,true);
      
      public static const FILTER_GLOW_LIGHT_BLUE_HIGH:GlowFilter = new GlowFilter(6545151,1,8,8,2,2);
      
      public static const COLOR_ENEMY_GREEN:String = "green";
      
      public static const COLOR_ENEMY_VIOLET:String = "violet";
      
      public static const COLOR_ENEMY_YELLOW:String = "yellow";
      
      public static const COLOR_ENEMY_WHITE:String = "white";
      
      public static const ANCHOR_POINT_WIO_TO_CALCULATE:int = -1;
      
      public static const ANCHOR_POINT_WIO_CENTER:int = 0;
      
      public static const ANCHOR_POINT_WIO_BOTTOM_RIGHT:int = 1;
      
      public static const ANCHOR_POINT_WIO_FLATBED_UPGRADE:int = 2;
      
      public static const GUI_UPGRADE_WIO_ICON_FRAME_WIDTH:int = 200;
      
      public static const GUI_UPGRADE_WIO_ICON_FRAME_HEIGHT:int = 200;
      
      public static const GUI_SHOP_WIO_ICON_FRAME_WIDTH:int = 110;
      
      public static const GUI_SHOP_WIO_ICON_FRAME_HEIGHT:int = 90;
      
      public static const FRIENDS_NPCS_A_SKU:String = "npc_A";
      
      public static const FRIENDS_NPCS_B_SKU:String = "npc_B";
      
      public static const FRIENDS_NPCS_C_SKU:String = "npc_C";
      
      public static const FRIENDS_NPCS_D_SKU:String = "npc_D";
      
      public static const FRIENDS_NPCS_E_SKU:String = "npc_E";
      
      public static const DEBUG_LABEL_BBOX:String = "debugLabelBBox";
      
      public static const DEBUG_PATH:String = "debugPath";
      
      public static const TEXTCOLOR_RED:String = "0xFF2323";
      
      public static const TEXTCOLOR_GREEN:String = "0x00FF00";
      
      public static const TEXTCOLOR_ALLIANCES_RED:String = "0xD00202";
      
      public static const TEXTCOLOR_ALLIANCES_GREEN:String = "0x306001";
      
      public static const TEXTCOLOR_WHITE:String = "0xFFFFFF";
      
      public static const TEXTCOLOR_EXTRA_DAMAGE:String = "0xB0F6FF";
      
      public static const MISSION_KIDNAPPING_ID:String = "mission_000";
      
      public static const USERDATA_ISONLINE_COOLDOWN_TIME:Number = DCTimerUtil.minToMs(5);
      
      public static const CURRENCY_PC_KEY:String = "pc";
      
      public static const CURRENCY_CASH_KEY:String = "cash";
      
      public static const CURRENCY_CHIPS_KEY:String = "chips";
      
      public static const CURRENCY_COINS_KEY:String = "coins";
      
      public static const CURRENCY_MINERALS_KEY:String = "minerals";
      
      public static const CURRENCY_SCORE_KEY:String = "score";
      
      public static const CURRENCY_MAX_AMOUNT_MINERALS_KEY:String = "maxMinerals";
      
      public static const CURRENCY_DROIDS_KEY:String = "droids";
      
      public static const CURRENCY_MAX_AMOUNT_DROIDS_KEY:String = "maxDroids";
      
      public static const CURRENCY_MAX_AMOUNT_COINS_KEY:String = "maxCoins";
      
      public static const CURRENCY_ITEM_KEY:String = "item";
      
      public static const CURRENCY_ITEMS_KEY:String = "items";
      
      public static const CURRENCY_BADGES_KEY:String = "badges";
      
      public static const CURRENCY_MAX_AMOUNT_BADGES_KEY:String = "maxBadges";
      
      public static const CURRENCY_CASH:int = 0;
      
      public static const CURRENCY_COINS:int = 1;
      
      public static const CURRENCY_MINERALS:int = 2;
      
      public static const CURRENCY_MAX_AMOUNT_MINERALS:int = 3;
      
      public static const CURRENCY_DROIDS:int = 4;
      
      public static const CURRENCY_MAX_AMOUNT_DROIDS:int = 5;
      
      public static const CURRENCY_XP:int = 6;
      
      public static const CURRENCY_MAX_AMOUNT_COINS:int = 7;
      
      public static const CURRENCY_SCORE:int = 6;
      
      public static const CURRENCY_BADGES:int = 8;
      
      public static const CURRENCY_MAX_AMOUNT_BADGES:int = 9;
      
      public static const CURRENCY_TYPE_BURN_EFFECT:int = 10;
      
      public static const TAIL_TYPE_SMOKE:String = "smoke";
      
      private static var smCurrencyDictionary:Dictionary;
      
      private static var smCurrencyNames:Array;
      
      public static const CHARACTER_NAME_NONE:String = "";
      
      public static const CHARACTER_NAME_ORANGE_NORMAL:String = "orange_normal";
      
      public static const CHARACTER_NAME_ORANGE_HAPPY:String = "orange_happy";
      
      public static const CHARACTER_NAME_ORANGE_WORRIED:String = "orange_worried";
      
      public static const CHARACTER_NAME_CAPTAIN_NORMAL:String = "captain_normal";
      
      public static const CHARACTER_NAME_CAPTAIN_HAPPY:String = "captain_happy";
      
      public static const CHARACTER_NAME_CAPTAIN_WORRIED:String = "captain_worried";
      
      public static const CHARACTER_NAME_SCIENTIST_HAPPY:String = "scientist_happy";
      
      public static const CHARACTER_NAME_SCIENTIST_WORRIED:String = "scientist_worried";
      
      public static const CHARACTER_NAME_WORKER_NORMAL:String = "builder_normal";
      
      public static const CHARACTER_NAME_WORKER_WORRIED:String = "builder_worried";
      
      public static const ADVISOR_FIREBIT_NORMAL:String = "firebit_normal";
      
      public static const ADVISOR_ELDERBY_NORMAL:String = "elderby_normal";
      
      public static const ADVISOR_COUNCIL_ANGRY:String = "alliance_council_angry";
      
      public static const ADVISOR_COUNCIL_HAPPY:String = "alliance_council_happy";
      
      public static const ADVISOR_COUNCIL_WAR:String = "alliance_council_war";
      
      public static const CHARACTER_HQ:String = "headquarter_001";
      
      public static const ADVISOR_INVEST_HAPPY:String = "ambassador";
      
      public static const ADVISOR_NETWORK_BUSY:String = "builder_worried";
      
      public static const CHARACTER_STATE_SUFFIX_NORMAL:String = "_normal";
      
      public static const CHARACTER_STATE_SUFFIX_HAPPY:String = "_happy";
      
      public static const CHARACTER_STATE_SUFFIX_WORRIED:String = "_worried";
      
      public static const CHARACTER_NPC_A_NORMAL:String = "npc_A_normal";
      
      public static const CHARACTER_NPC_B_NORMAL:String = "npc_B_normal";
      
      public static const CHARACTER_NPC_C_NORMAL:String = "npc_C_normal";
      
      public static const CHARACTER_NPC_D_NORMAL:String = "npc_D_normal";
      
      public static const CHARACTER_STATE_INSTANT_BUILD:String = "builder_normal";
      
      public static const CHARACTER_STATE_INSTANT_UPGRADE:String = "builder_normal";
      
      public static const CHARACTER_STATE_INSTANT_REPAIR:String = "builder_normal";
      
      public static const CHARACTER_STATE_START_REPAIRING:String = "builder_worried";
      
      public static const CHARACTER_STATE_DROID_NEEDED:String = "builder_normal";
      
      public static const CHARACTER_STATE_DROID_AND_RESOURCES_NEEDED:String = "builder_normal";
      
      public static const CHARACTER_STATE_PROTECTION:String = "orange_normal";
      
      public static const CHARACTER_STATE_BUY_DROID:String = "builder_normal";
      
      public static const CHARACTER_STATE_MSG_POPUP_DEFAULT:String = "orange_normal";
      
      public static const CHARACTER_STATE_MSG_POPUP_ERROR:String = "orange_worried";
      
      public static const CHARACTER_STATE_MSG_FIRST_VISIT:String = "orange_normal";
      
      public static const CHARACTER_STATE_MSG_NO_UNITS_TO_ATTACK:String = "captain_normal";
      
      public static const CHARACTER_STATE_TUTORIAL_DEFAULT:String = "orange_normal";
      
      public static const CHARACTER_STATE_MSG_YOU_WILL_LOOSE_PROTECTION:String = "orange_normal";
      
      public static const CHARACTER_STATE_MSG_ATTACK_TO_NPC:String = "captain_worried";
      
      public static const CHARACTER_STATE_MSG_ATTACK_NPC_IS_OVER:String = "captain_normal";
      
      public static const CHARACTER_STATE_MSG_OBJECTS_FOR_CRAFTING_PENDING:String = "scientist_worried";
      
      public static const CHARACTER_STATE_MSG_CITY_DAMAGED:String = "captain_worried";
      
      public static const CHARACTER_STATE_MISSION_PROGRESS:String = "";
      
      public static const CHARACTER_STATE_SPEED_UP_UNIT:String = "captain_normal";
      
      public static const CHARACTER_STATE_SPEED_UP_QUEUE:String = "captain_normal";
      
      public static const CHARACTER_STATE_RECYCLE:String = "orange_normal";
      
      public static const CHARACTER_STATE_WRAP_BUNKER_OWNER:String = "orange_normal";
      
      public static const ICON_FACEBOOK:String = "icon_fb";
      
      public static const GENERAL_TUTORIAL_COMPLETE_ATTRIBUTE:String = "tutorialCompleted";
      
      public static const TOOLTIPBOX_OFFSET_Y:int = 62;
      
      public static const TEXTFIELD_PARTICLE_OFFSET_Y:int = 60;
      
      public static const TEXTFIELD_PARTICLE_OFFSET_X:int = 5;
      
      public static const TEXTFIELD_QUEUED_PARTICLES_OFFSET_Y:int = 35;
      
      public static const TUTORIAL_ARROW_OFFSET_Y_GUI_ELEM:int = 60;
      
      public static const TUTORIAL_ARROW_OFFSET_Y_TILE_WITHOUT_BUILDING:int = 40;
      
      public static const TUTORIAL_ARROW_OFFSET_Y:int = 20;
      
      public static const TUTORIAL_ARROW_OFFSET_X:int = 40;
      
      public static const MISSIONS_ICON_OFFSET_X:int = 45;
      
      public static const MISSIONS_ICON_OFFSET_Y:int = 95;
      
      public static const MISSIONS_ICON_OFFSET_Y_NEW_MISSION_DROP:int = 90;
      
      public static const MISSIONS_ICON_OFFSET_X_PROGRESS:int = 45;
      
      public static const MISSIONS_ICON_EFFECT_OFFSET_X_PROGRESS:int = 15;
      
      public static const MISSIONS_GUI_ELEM_OFFSET_Y:int = 35;
      
      public static const MISSIONS_GUI_ELEM_OFFSET_X:int = 15;
      
      public static const TOOLTIP_UPPER_HUD:String = "TooltipUpperHud";
      
      public static const TOOLTIP_TOOLBAR_BUTTON:String = "TooltipToolbarButton";
      
      public static const TOOLTIP_BOX_MISSIONS:String = "TooltipBoxMissions";
      
      public static const EVENT_TYPE_WIO_MODEL:int = 0;
      
      public static const EVENT_TYPE_WIO_UI:int = 1;
      
      public static const EVENT_TYPE_SHOP_RESOURCE_UI:int = 2;
      
      public static const EVENT_TYPE_MISSIONS:int = 3;
      
      public static const EVENT_TYPE_MAP:int = 4;
      
      public static const EVENT_TYPE_WAR:int = 5;
      
      public static const NOTIFY_MISSION_COMPLETED:String = "NOTIFY_MISSION_COMPLETED";
      
      public static const NOTIFY_BUILD_ITEM:String = "NOTIFY_BUILD_ITEM";
      
      public static const NOTIFY_PAY_REWARD:String = "NOTIFY_PAY_REWARD";
      
      public static const NOTIFY_ATTACKED_INGAME:String = "NOTIFY_ATTACKED_INGAME";
      
      public static const SERVER_CMD_WIO_ADD_ITEM:String = "WIOAddItem";
      
      public static const SERVER_CMD_WIO_MOVE_ITEM:String = "WIOMoveItem";
      
      public static const SERVER_CMD_WIO_FLIP_ITEM:String = "WIOFlipItem";
      
      public static const SERVER_CMD_WIO_BUILDING_END:String = "WIOBuildingEnd";
      
      public static const SERVER_CMD_WIO_UPGRADING_START:String = "WIOUpgradingStart";
      
      public static const SERVER_CMD_WIO_UPGRADING_END:String = "WIOUpgradingEnd";
      
      public static const SERVER_CMD_WIO_REPAIRING_END:String = "WIORepairingEnd";
      
      public static const SERVER_CMD_WIO_DESTROY:String = "WIODestroy";
      
      public static const SERVER_ERROR_LOGOUT_TIMEOUT:String = "serverUpdated";
      
      public static const SERVER_ERROR_LOGOUT_CONNECTION_LOST:String = "connectionLost";
      
      public static const SERVER_ERROR_LOGOUT_GUEST_USER_SESSION_OVER:String = "guestUserSessionOver";
      
      public static const MAP_TOOLS_MOVE_ITEM_EVENT_SUBCMD:String = "MoveItem";
      
      public static const MAP_TOOLS_MOVE_ITEMS_EVENT_SUBCMD:String = "MoveItems";
      
      public static const MAP_TOOLS_ADD_ITEM_EVENT_SUBCMD:String = "AddItem";
      
      public static const MAP_TOOLS_FLIP_ITEM_EVENT_SUBCMD:String = "FlipItem";
      
      public static const MAP_TOOLS_RESTORE_ITEM_EVENT_SUBCMD:String = "RestoreItem";
      
      public static const MAP_TOOLS_EVENT_PLACE_ITEM:String = "mapToolsEventPlaceItem";
      
      public static const MAP_MODEL_EVENT_PATH_RESOLVED:String = "MapModelEventPathResolved";
      
      public static const WORLD_EVENT_DEMOLISH_ITEM:String = "WorldEventDemolishItem";
      
      public static const WORLD_EVENT_PLACE_ITEM:String = "WorldEventPlaceItem";
      
      public static const WORLD_EVENT_PLACE_ITEMS:String = "WorldEventPlaceItems";
      
      public static const WORLD_EVENT_MOVE_CAMERA_TO_ITEM:String = "WorldEventMoveCameraToItem";
      
      public static const WIO_DROID_LABOUR_NONE_ID:int = -1;
      
      public static const WIO_DROID_LABOUR_BUILD_ID:int = 0;
      
      public static const WIO_DROID_LABOUR_UPGRADE_ID:int = 1;
      
      public static const WIO_DROID_LABOUR_DEMOLISH_ID:int = 2;
      
      public static const WIO_ACTIONS_UI_BATTLE_CHANGE_TARGET_ID:int = 0;
      
      public static const WIO_ACTIONS_UI_PLACE_ITEM_ID:int = 1;
      
      public static const WIO_ACTIONS_UI_INSTANT_BUILD_ITEM_ID:int = 2;
      
      public static const WIO_ACTIONS_UI_INSTANT_UPGRADE_ITEM_ID:int = 3;
      
      public static const WIO_ACTIONS_UI_BUILDING_WAITING_FOR_DROID_ID:int = 4;
      
      public static const WIO_ACTIONS_UI_UPGRADING_WAITING_FOR_DROID_ID:int = 5;
      
      public static const WIO_ACTIONS_UI_LABOUR_WAITING_FOR_DROID_ID:int = 6;
      
      public static const WIO_ACTIONS_UI_DEMOLISH_ID:int = 7;
      
      public static const WIO_ACTIONS_UI_INSTANT_REPAIR_ITEM_ID:int = 8;
      
      public static const WIO_ACTIONS_UI_UPGRADE_ID:int = 9;
      
      public static const WIO_ACTIONS_UI_DISCONNECTED_ID:int = 10;
      
      public static const WIO_ACTIONS_UI_COLLECT_RENT_ID:int = 11;
      
      public static const WIO_ACTIONS_UI_INTERACT_SHIPYARD_SHOP_ID:int = 12;
      
      public static const WIO_ACTIONS_UI_DEFENSE_ID:int = 13;
      
      public static const WIO_ACTIONS_UI_HANGAR_ID:int = 14;
      
      public static const WIO_ACTIONS_UI_BUNKER_ID:int = 15;
      
      public static const WIO_ACTIONS_UI_LABORATORY_ID:int = 16;
      
      public static const WIO_ACTIONS_UI_OBSERVATORY_ID:int = 17;
      
      public static const WIO_ACTIONS_UI_VISIT_FRIEND_ID:int = 18;
      
      public static const WIO_ACTIONS_UI_BUILT_PASSIVE:int = 19;
      
      public static const WIO_ACTIONS_UI_GLOW_ID:int = 20;
      
      public static const WIO_ACTIONS_UI_HQ_ID:int = 21;
      
      public static const WIO_ACTIONS_UI_COLLECT_ALL_ID:int = 22;
      
      public static const WIO_ACTIONS_UI_REFINERY_ID:int = 23;
      
      public static const WIO_ACTIONS_UI_EMBASSY_ID:int = 24;
      
      public static const WIO_ACTIONS_UI_NONE_ID:int = 25;
      
      public static const WIO_ACTIONS_UI_SELECT_ID:int = 25;
      
      public static const WIO_ACTIONS_UI_COUNT:int = 27;
      
      public static const WIO_EVENT_INSTANT_BUILD:String = "WIOEventInstantBuild";
      
      public static const WIO_EVENT_INSTANT_DEMOLISH:String = "WIOEventInstantDemolish";
      
      public static const WIO_EVENT_BUILDING_END:String = "WIOEventBuildingEnd";
      
      public static const WIO_EVENT_BUILDING_END_END:String = "WIOEventBuildingEndEnd";
      
      public static const WIO_EVENT_DEMOLITION_START:String = "WIOEventDemolitionStart";
      
      public static const WIO_EVENT_DEMOLITION_END:String = "WIOEventDemolitionEnd";
      
      public static const WIO_EVENT_DEMOLITION_END_END:String = "WIOEventDemolitionEndEnd";
      
      public static const WIO_EVENT_RENT_WAITING_START:String = "WIOEventRentWaitingStart";
      
      public static const WIO_EVENT_RENT_WAITING_END:String = "WIORentWaitingEnd";
      
      public static const WIO_EVENT_RENT_COLLECTING_END:String = "WIORentCollectingEnd";
      
      public static const WIO_EVENT_WAITING_FOR_DROID_END:String = "WIOEventWaitingForDroidEnd";
      
      public static const WIO_EVENT_DROID_REQUESTED:String = "WIOEventDroidRequested";
      
      public static const WIO_EVENT_BUILDING_PLACED:String = "WIOEventBuildingPlaced";
      
      public static const WIO_EVENT_INSTANT_UPGRADE:String = "WIOEventInstantUpgrade";
      
      public static const WIO_EVENT_UPGRADING_END:String = "WIOEventUpgradingEnd";
      
      public static const WIO_EVENT_REPAIR_END:String = "WIOEventRepairEnd";
      
      public static const WIO_EVENT_CANCEL_UPGRADE:String = "WIOEventCancelUpgrade";
      
      public static const WIO_EVENT_CANCEL_BUILD:String = "WIOEventCancelBuild";
      
      public static const WIO_EVENT_SHIPYARD_BUILD_SHIP_START:String = "WIOEventShipyardBuildShipStart";
      
      public static const WIO_EVENT_SHIPYARD_BUILD_NO_SHIPS:String = "WIOEventShipyardBuildNoShips";
      
      public static const WIO_EVENT_SHIPYARD_LAUNCH_SHIP_START:String = "WIOEventShipyardLaunchShipStart";
      
      public static const WIO_EVENT_SHIPYARD_LAUNCH_SHIP_END:String = "WIOEventShipyardLaunchShipEnd";
      
      public static const WIO_EVENT_SHIPYARD_LAUNCH_SHIP_PAUSE:String = "WIOEventShipyardLaunchShipPause";
      
      public static const WIO_EVENT_PASSIVE_BUILDING_BUILT_END:String = "WIOEventPassiveBuildingBuiltEnd";
      
      public static const WIO_EVENT_UPGRADE_START:String = "WIOEventUpgradeStart";
      
      public static const WIO_EVENT_UPGRADE_PREMIUM:String = "WIOEventUpgradePremium";
      
      public static const WIO_EVENT_BREAK:String = "WIOEventBreak";
      
      public static const WIO_EVENT_REPAIR_START:String = "WIOEventRepairStart";
      
      public static const WIO_EVENT_VISIT_FRIEND:String = "WIOEventVisitFriend";
      
      public static const WIO_EVENT_VISIT_FRIEND_HELPED:String = "WIOEventVisitFriendHelped";
      
      public static const WIO_EVENT_VISIT_FRIEND_HELPED_END:String = "WIOEventVisitFriendHelpedEnd";
      
      public static const WIO_EVENT_FRIEND_HELPED:String = "WioEventFriendHelped";
      
      public static const WIO_EVENT_PARAM_INSTANT:String = "Instant";
      
      public static const WIO_EVENT_POWERUP_SWITCH:String = "WIOEventPowerUpSwitch";
      
      public static var smAllowedEventsForItemsHistory:Dictionary;
      
      public static const WIO_STATES_UI_TIME_TO_WAIT_MS:int = 3000;
      
      public static const WIO_CLIENT_STATES_BUILDING_PLACED_ID:int = 0;
      
      public static const WIO_CLIENT_STATES_LABOUR_WAITING_FOR_DROID_ID:int = 1;
      
      public static const WIO_CLIENT_STATES_BUILDING_ID:int = 2;
      
      public static const WIO_CLIENT_STATES_BUILDING_END_ID:int = 3;
      
      public static const WIO_CLIENT_STATES_RENT_WAITING_ID:int = 4;
      
      public static const WIO_CLIENT_STATES_RENT_READY_ID:int = 5;
      
      public static const WIO_CLIENT_STATES_RENT_COLLECTING_ID:int = 6;
      
      public static const WIO_CLIENT_STATES_DEMOLITION_START_ID:int = 7;
      
      public static const WIO_CLIENT_STATES_DEMOLITION_END_ID:int = 8;
      
      public static const WIO_CLIENT_STATES_EMPTY_ID:int = 9;
      
      public static const WIO_CLIENT_STATES_SHIPYARD_RUNNING_EMPTY_ID:int = 10;
      
      public static const WIO_CLIENT_STATES_SHIPYARD_RUNNING_WORKING_ID:int = 11;
      
      public static const WIO_CLIENT_STATES_SHIPYARD_PAUSED_ID:int = 12;
      
      public static const WIO_CLIENT_STATES_SHIPYARD_LAUNCHING_SHIP_ID:int = 13;
      
      public static const WIO_CLIENT_STATES_UPGRADEABLE_RUNNING_ID:int = 14;
      
      public static const WIO_CLIENT_STATES_DEFENSE_ID:int = 15;
      
      public static const WIO_CLIENT_STATES_UPGRADING_ID:int = 16;
      
      public static const WIO_CLIENT_STATES_BUILT_PASSIVE_ID:int = 17;
      
      public static const WIO_CLIENT_STATES_BROKEN_ID:int = 18;
      
      public static const WIO_CLIENT_STATES_HANGAR_RUNNING_ID:int = 19;
      
      public static const WIO_CLIENT_STATES_BUNKER_RUNNING_ID:int = 20;
      
      public static const WIO_CLIENT_STATES_LABS_RUNNING_ID:int = 21;
      
      public static const WIO_CLIENT_STATES_REPAIRING_ID:int = 22;
      
      public static const WIO_CLIENT_STATES_FOR_TOOL_PLACE_ID:int = 23;
      
      public static const CLIENT_STATES_PASSIVE_GLOW_ID:int = 24;
      
      public static const CLIENT_STATES_EMPTY_ITEM_ORIENTED_ID:int = 25;
      
      public static const WIO_CLIENT_STATES_HQ_RUNNING:int = 26;
      
      public static const WIO_CLIENT_STATES_VISIT_FRIEND_ID:int = 27;
      
      public static const WIO_CLIENT_STATES_VISIT_FRIEND_HELPED_ID:int = 28;
      
      public static const WIO_CLIENT_STATES_JAIL_OPENING_ID:int = 29;
      
      public static const WIO_CLIENT_STATES_OBSERVATORY_RUNNING_ID:int = 30;
      
      public static const WIO_CLIENT_STATES_SILO_RUNNING_ID:int = 31;
      
      public static const WIO_CLIENT_STATES_REFINERY_RUNNING_ID:int = 32;
      
      public static const WIO_CLIENT_STATES_EMBASSY_RUNNING_ID:int = 33;
      
      public static const WIO_CLIENT_STATES_COUNT:int = 34;
      
      public static const WIO_SERVER_STATE_NO_STATE_ID:int = -1;
      
      public static const WIO_SERVER_STATE_ON_BUILDING_ID:int = 0;
      
      public static const WIO_SERVER_STATE_ON_RUNNING_ID:int = 1;
      
      public static const WIO_SERVER_STATE_ON_UPGRADING_ID:int = 2;
      
      public static const WIO_SERVER_STATE_ID_TO_STRING:Vector.<String> = new <String>["StateOnBuilding","StateOnRunning","StateOnUpgrading"];
      
      public static const WIO_SERVER_MODE_INVALID_ID:int = -1;
      
      public static const WIO_SERVER_MODE_NONE_ID:int = 0;
      
      public static const WIO_SERVER_BUILDING_MODE_WAITING_FOR_DROID_ID:int = 0;
      
      public static const WIO_SERVER_BUILDING_MODE_BUILDING_STARTED:int = 1;
      
      public static const WIO_SERVER_MODES_TO_STRING:Array = [["WaitingForDroid","BuildingStarted"],["none"],["none"]];
      
      public static const WIO_VIEW_LAYERS_GROUND_ID:int = 0;
      
      public static const WIO_VIEW_LAYERS_BASE_ID:int = 1;
      
      public static const WIO_VIEW_LAYERS_PARTICLES_ID:int = 2;
      
      public static const WIO_VIEW_LAYERS_BASE_DECORATION_ID:int = 3;
      
      public static const WIO_VIEW_LAYERS_OUTLINE_ID:int = 4;
      
      public static const WIO_VIEW_LAYERS_ICON_ID:int = 5;
      
      public static const WIO_VIEW_LAYERS_ICON_2_ID:int = 6;
      
      public static const WIO_VIEW_LAYERS_BAR_ID:int = 7;
      
      public static const WIO_VIEW_LAYERS_COUNT:int = 8;
      
      public static const WIO_VIEW_LAYERS_AFFECTED_BY_OBSTRUCTION_ALPHA:Array = [5,1,2,3];
      
      public static const EXPENDABLES_NUKE_SKU:String = "nuke";
      
      public static const EXPENDABLES_CAPSULE_SKU:String = "capsule";
      
      public static var EXPENDABLES_ASSET_SKU:Dictionary;
      
      public static var EXPENDABLES_TILES_WIDTH:Dictionary;
      
      public static var EXPENDABLES_TILES_HEIGHT:Dictionary;
      
      public static var EXPENDABLES_HAS_TO_APPLY_EFFECT:Dictionary;
      
      public static const DECORATION_NORMAL:String = "decoration";
      
      public static const DECORATION_OBSTACLE:String = "obstacle";
      
      public static const BATTLE_MENU_CLOCK_MODE_NONE:int = -1;
      
      public static const BATTLE_MENU_CLOCK_MODE_ACTUAL_BATTLE:int = 0;
      
      public static const BATTLE_MENU_CLOCK_MODE_COUNTDOWN_BEFORE_BATTLE:int = 1;
      
      public static const BATTLE_MENU_CLOCK_MODE_WAITING_FOR_OPPONENT:int = 2;
      
      public static const BATTLE_MENU_CLOCK_MODE_WARBAR_COUNTDOWN:int = 3;
      
      public static const BATTLE_MENU_CLOCK_MODE_BUY_EXTRA_TIME:int = 4;
      
      public static const BATTLE_MENU_CLOCK_MODE_BOUGHT_EXTRA_TIME:int = 5;
      
      public static const BATTLE_TIME_MS:int = DCTimerUtil.minToMs(7);
      
      public static const MINE_TRAP_DETONATION_RADIUS:Number = 46;
      
      public static const BATTLE_ARMY_EVENT_FINISH:String = "battleArmyEventFinish";
      
      public static const BATTLE_ARMY_EVENT_LEAVE_SCENE:String = "battleArmyEventLeaveScene";
      
      public static const BATTLE_ARMY_EVENT_RETREAT:String = "battleArmyEvenRetreat";
      
      public static const BATTLE_ARMY_EVENT_RETREAT_AFTER_WINNING:String = "battleArmyEventRetreatAfterWinning";
      
      public static const BATTLE_ARMY_REMOVE_UNITS:String = "battleArmyRemoveUnits";
      
      public static const BATTLE_UNIT_EVENT_WAS_HIT:String = "battleUnitEventWasHit";
      
      public static const BATTLE_EVENT_HAS_STARTED:String = "battleEventHasStarted";
      
      public static const BATTLE_EVENT_HAS_FINISHED:String = "battleEventHasFinished";
      
      public static const BATTLE_EVENT_DEPLOY_WAVE:String = "battleEventDeployWave";
      
      public static const BATTLE_EVENT_DEPLOY_SPECIAL_ATTACK:String = "battleEventDeploySpecialAttack";
      
      public static const BATTLE_EVENT_MOVE_CAMERA:String = "battleEventMoveCamera";
      
      public static const CIVIL_BATTLE_STARTED:String = "civilBattleStarted";
      
      public static const CIVIL_BATTLE_END:String = "civilBattleEnd";
      
      public static const CIVIL_KILLED_IN_BATTLE:String = "civilKilledInBattle";
      
      public static const TERRAIN_UNIT_FREQ_CHECK_TARGET:int = 2000;
      
      public static const UNIT_FACTION_NONE:int = -1;
      
      public static const UNIT_FACTION_ATTACKER:int = 0;
      
      public static const UNIT_FACTION_DEFENDER:int = 1;
      
      public static const UNIT_FACTION_COUNT:int = 2;
      
      public static const UNIT_FACTION_TO_STRING:Array = ["Attacker","Defender"];
      
      public static const UNIT_DEF_MNG_DROID_ID:int = 0;
      
      public static const UNIT_DEF_MNG_CIVIL_ID:int = 1;
      
      public static const UNIT_DEF_MNG_SHIP_ID:int = 2;
      
      public static const UNIT_DEF_MNG_UNIT_ID:int = 3;
      
      public static const UNIT_DEF_MNG_WIO_ID:int = 4;
      
      public static const UNIT_DEF_MNG_COUNT:int = 5;
      
      public static const UNIT_NOTIFY_MNG_TRAFFIC_ID:int = 0;
      
      public static const UNIT_NOTIFY_MNG_ARMY_ATTACKER_ID:int = 1;
      
      public static const UNIT_NOTIFY_MNG_ARMY_DEFENDER_ID:int = 2;
      
      public static const UNIT_NOTIFY_MNG_ARMY_DEPENDING_ON_FACTION_ID:int = 3;
      
      public static const UNIT_TYPE_DROIDS_ID:int = 0;
      
      public static const UNIT_TYPE_CIVILS_ID:int = 1;
      
      public static const UNIT_TYPE_SHIPS_ID:int = 2;
      
      public static const UNIT_TYPE_BULLETS_ID:int = 3;
      
      public static const UNIT_TYPE_BUILDINGS_NO_WALLS_ID:int = 4;
      
      public static const UNIT_TYPE_WALLS_ID:int = 5;
      
      public static const UNIT_TYPE_SOLDIERS_ID:int = 6;
      
      public static const UNIT_TYPE_MECHAS_ID:int = 7;
      
      public static const UNIT_TYPE_COLLECTORS_ID:int = 8;
      
      public static const UNIT_TYPE_UMBRELLAS_ID:int = 9;
      
      public static const UNIT_TYPE_COUNT:int = 10;
      
      public static const UNIT_TYPE_TO_STRING:Array = ["Droid","Civil","Ship","Bullet","BuildingNoWall","Wall","Soldier","Mechas","Collectors","Umbrellas"];
      
      public static const UNIT_TYPE_IS_TERRAIN:Array = [true,true,false,true,true,true,true,true,true,false];
      
      public static const UNIT_TYPE_DEPENDS_ON_FACTION:Array = [false,false,true,true,false,false,true,true,false,false];
      
      public static const UNIT_TYPE_TO_FACTORY_TYPE:Array = [-1,-1,0,-1,-1,-1,2,3,-1,-1];
      
      public static const UNIT_TYPE_TO_DEF_MNG:Array = [0,1,2,3,4,4,2,2,2,2];
      
      public static const UNIT_TYPE_TO_NOTIFY_MNG:Array = [0,0,3,-1,2,2,3,3,-1,-1];
      
      public static const UNIT_PRIORITY_ANYTHING:String = "anything";
      
      public static const UNIT_PRIORITY_DEFENSES:String = "defenses";
      
      public static const UNIT_PRIORITY_HQ:String = "hq";
      
      public static const UNIT_PRIORITY_RESOURCES:String = "resources";
      
      public static const UNIT_PRIORITY_SHIPS:String = "ships";
      
      public static const UNIT_PRIORITY_SOLDIERS:String = "soldiers";
      
      public static const UNIT_PRIORITY_WALLS:String = "walls";
      
      public static const SCENE_UNIT_TYPE_NONE_ID:int = -1;
      
      public static const SCENE_UNIT_TYPE_DROIDS_ID:int = 0;
      
      public static const UNIT_TYPE_TO_SCENE_UNIT_TYPE:Array = [SCENE_UNIT_TYPE_DROIDS_ID,1,2,4,6,7,8,10,12,12];
      
      public static const SCENE_UNIT_TYPE_CIVILS_ID:int = 1;
      
      public static const SCENE_UNIT_TYPE_SHIPS_ATTACKER_ID:int = 2;
      
      public static const SCENE_UNIT_TYPE_SHIPS_DEFENDER_ID:int = 3;
      
      public static const SCENE_UNIT_TYPE_BULLETS_ATTACKER_ID:int = 4;
      
      public static const SCENE_UNIT_TYPE_BULLETS_DEFENDER_ID:int = 5;
      
      public static const SCENE_UNIT_TYPE_BUILDINGS_NO_WALLS_ID:int = 6;
      
      public static const SCENE_UNIT_TYPE_WALLS_ID:int = 7;
      
      public static const SCENE_UNIT_TYPE_SOLDIERS_ATTACKER_ID:int = 8;
      
      public static const SCENE_UNIT_TYPE_SOLDIERS_DEFENDER_ID:int = 9;
      
      public static const SCENE_UNIT_TYPE_MECHAS_ATTACKER_ID:int = 10;
      
      public static const SCENE_UNIT_TYPE_MECHAS_DEFENDER_ID:int = 11;
      
      public static const SCENE_UNIT_TYPE_COLLECTORS_ID:int = 12;
      
      public static const SCENE_UNIT_TYPE_DEFAULT_ID:int = 13;
      
      public static const SCENE_UNIT_TYPE_COUNT:int = 14;
      
      public static const SCENE_UNIT_TYPE_TO_UNIT_TYPE:Array = [0,1,2,2,3,3,4,5,6,6,7,7,8];
      
      public static const SCENE_UNIT_SENSE_ENVIRONMENT_PER_TICK:int = 5;
      
      public static var SCENE_UNIT_TYPE_NEEDS_TO_SENSE_ENVIRONMENT_SECURE:SecureObject = new SecureObject();
      
      public static const SCENE_UNIT_TYPE_NEEDS_TO_SENSE_ENVIRONMENT:Array = [false,false,true,true,true,true,true,false,true,false,true,false,false,false];
      
      public static const SCENE_UNIT_TYPES_ATTACKER:Array = [2,8,10];
      
      public static const UNIT_SCENE_NONE:int = -1;
      
      public static const UNIT_SCENE_IMMEDIATELY:int = 0;
      
      public static const UNIT_SCENE_FADEOUT:int = 1;
      
      public static const UNIT_SCENE_FADEIN:int = 2;
      
      public static const UNIT_SCENE_DROP:int = 3;
      
      public static const UNIT_SCENE_FROM_BUNKER:int = 4;
      
      public static const UNIT_EVENT_TARGET_HAS_CHANGED:String = "unitGoalTargetHasChanged";
      
      public static const UNIT_EVENT_HAS_ARRIVED:String = "unitEventHasArrived";
      
      public static const UNIT_EVENT_PATH_ENDED:String = "unitEventPathEnded";
      
      public static const UNIT_EVENT_ENTER_SCENE_IMMEDIATELY:String = "unitEventEnterSceneImmediately";
      
      public static const UNIT_EVENT_ENTER_SCENE_FADEIN:String = "unitEventEnterSceneFadeIn";
      
      public static const UNIT_EVENT_EXIT_SCENE_IMMEDIATELY:String = "unitEventExitSceneImmediately";
      
      public static const UNIT_EVENT_EXIT_SCENE_FADEOUT:String = "unitEventExitSceneFadeOut";
      
      public static const UNIT_EVENT_KILLED:String = "unitEventKilled";
      
      public static const UNIT_EVENT_ADDED_TO_SCENE:String = "unitEventAddedToScene";
      
      public static const UNIT_EVENT_REMOVED_FROM_SCENE:String = "unitEventRemovedFromScene";
      
      public static const UNIT_EVENT_ITEM_DESTROYED:String = "unitEventITemDestroyed";
      
      public static const UNIT_EVENT_DEFEND_BUNKER:String = "unitEventDefendBunker";
      
      public static const UNIT_EVENT_RETURN_TO_BUNKER:String = "unitEventReturnToBunker";
      
      public static const UNIT_GOAL_GEN_ATTACK:String = "unitGoalGenAttack";
      
      public static const UNIT_GOAL_SHIP_ATTACKING:String = "unitGoalShipAttacking";
      
      public static const UNIT_GOAL_ON_HANGAR:String = "unitGoalOnHangar";
      
      public static const UNIT_GOAL_GO_TO_ITEM:String = "unitGoalGoToItem";
      
      public static const UNIT_GOAL_RETURN_TO_HQ:String = "unitGoalReturnToHQ";
      
      public static const UNIT_GOAL_GET_IN_HQ:String = "unitGetInHQ";
      
      public static const UNIT_GOAL_GET_OUT_HQ:String = "unitGetOutHQ";
      
      public static const UNIT_GOAL_IN_HQ:String = "unitInHQ";
      
      public static const UNIT_GOAL_IMPACT:String = "unitGoalImpact";
      
      public static const UNIT_GOAL_BUILDING_NONE:String = "unitGoalBuildingNone";
      
      public static const UNIT_GOAL_BUILDING_DEFENDING:String = "unitGoalBuildingDefending";
      
      public static const UNIT_GOAL_BUILDING_MINE:String = "unitGoalBuildingMine";
      
      public static const UNIT_GOAL_SOLDIER_ATTACKING:String = "unitGoalSoldierAttacking";
      
      public static const UNIT_GOAL_SOLDIER_DEFENDING:String = "unitGoalSoldierDefending";
      
      public static const UNIT_GOAL_FOR_RETURN_TO_HANGAR:String = "unitGoalForReturnToHangar";
      
      public static const UNIT_GOAL_FOR_CARRY_RENT:String = "unitGoalForCarryRent";
      
      public static const UNIT_GOAL_FOR_LAND_IN_HANGAR:String = "unitGoalForLandInHangar";
      
      public static const UNIT_GOAL_FOR_HANGAR_TO_BUNKER:String = "unitGoalForHangarToBunker";
      
      public static const UNIT_GOAL_FOR_RETURN_TO_BUNKER:String = "unitGoalForReturnToBunker";
      
      public static const UNIT_GOAL_FOR_DROID_GO_TO_ITEM:String = "unitGoalForDroidGoToItem";
      
      public static const UNIT_GOAL_SPECIAL_ATTACK_ROCKET:String = "unitGoalSpecialAttackRocket";
      
      public static const UNIT_GOAL_SPECIAL_ATTACK_FREEZE:String = "unitGoalSpecialAttackFreeze";
      
      public static const UNIT_GOAL_SPECIAL_ATTACK_CATAPULT:String = "unitGoalSpecialAttackCatapult";
      
      public static const UNIT_GOAL_WANDER_AROUND_HQ:String = "unitGoalWanderAroundHq";
      
      public static const UNIT_GOAL_WORKING_ON_ITEM:String = "unitGoalWorkingOnItem";
      
      public static var UNIT_FACTION_SUFFIX:Array;
      
      public static const UNIT_FACTION_MODE_NORMAL:int = 0;
      
      public static const UNIT_FACTION_MODE_INVERSE:int = 1;
      
      private static var smUnitFactionMode:int = 0;
      
      public static const DEFAULT_ANIMATION:int = -1;
      
      public static const ANIMATION_NONE:String = "none";
      
      public static const ANIMATION_WALKING:String = "walking";
      
      public static const ANIMATION_RUNNING:String = "running";
      
      public static const ANIMATION_STOPPED:String = "still";
      
      public static const ANIMATION_ASLEEP:String = "sleep";
      
      public static const ANIMATION_JUMP:String = "jump";
      
      public static const ANIMATION_JUMP_ROLL:String = "jump_roll";
      
      public static const ANIMATION_TALK_LEFT:String = "talk_left";
      
      public static const ANIMATION_TALK_RIGHT:String = "talk_right";
      
      public static const ANIMATION_DYING_RANDOM:String = "deathrandom";
      
      public static const ANIMATION_DYING_01:String = "death001";
      
      public static const ANIMATION_DYING_02:String = "death002";
      
      public static const ANIMATION_DYING_03:String = "death003";
      
      public static const ANIMATION_DYING_04:String = "death004";
      
      public static const ANIMATION_DYING_05:String = "death005";
      
      public static const ANIMATION_DYING_06:String = "death006";
      
      public static const ANIMATION_SHOOTING:String = "shooting";
      
      public static const ANIMATION_LOAD_WEAPON:String = "load";
      
      public static const DEATH_ANIMATION_NAME:String = "death";
      
      public static const UNIT_BUILDING_TYPE_TURRET:String = "turret";
      
      public static const UNIT_BUILDING_TYPE_WALL:String = "wall";
      
      public static const UNIT_BUILDING_TYPE_MINE:String = "mine";
      
      public static const UNIT_BUILDING_TYPE_MORTAR:String = "mortar";
      
      public static const UNIT_BUILDING_TYPE_PLAYABLE:String = "play";
      
      public static const UNIT_BUILDING_TYPE_FREEZE:String = "freeze";
      
      public static const UNIT_MINE_HAS_EXPLOSION_ANIM:String = "mineExploAnim";
      
      public static const UNIT_ATTRACTS_ENEMIES:String = "attractEnemies";
      
      public static const MINE_TYPE_FLYING:String = "mineFlying";
      
      public static const MINE_TYPE_PUMPKIN:String = "minePumpkin";
      
      public static const SPY_TYPE_NORMAL:int = 0;
      
      public static const SPY_TYPE_ADVANCED:int = 1;
      
      public static const SPY_CAPSULE_ADVANCED_SCALE:int = 2;
      
      public static const UNIT_MISSILE_THROWER:String = "missile";
      
      public static const UNIT_ENERGY_BAR_MAX_SECTORS_BUILDING:int = 4;
      
      public static const UNIT_ENERGY_BAR_MAX_SECTORS_UNIT:int = 10;
      
      public static const UNIT_ENERGY_BAR_SECTOR_WIDTH:int = 5;
      
      public static const UNIT_ENERGY_BAR_HEIGHT:int = 5;
      
      public static const UNIT_ENERGY_BAR_COLORS:Array = ["color_red","color_yellow","color_green"];
      
      public static const UNIT_ENERGY_BAR_COLORS_UINT:Array = [13369344,16763904,65280];
      
      public static const SHOT_TYPE_SNIPER:String = "b_sniper_001";
      
      public static const SHOT_TYPE_SNIPER2:String = "b_sniper_002";
      
      public static const SHOT_TYPE_SNIPER3:String = "b_sniper_003";
      
      public static const SHOT_TYPE_FREEZE:String = "b_freeze_001";
      
      public static const SHOT_TYPE_BULLET:String = "b_bullet_001";
      
      public static const SHOT_TYPE_AIRBULLET:String = "b_airbullet_001";
      
      public static const SHOT_TYPE_ROCKET:String = "b_rocket_001";
      
      public static const SHOT_TYPE_ROCKET_DOUBLE:String = "b_rocket_002";
      
      public static const SHOT_TYPE_FIREBALL:String = "b_fireball_001";
      
      public static const SHOT_TYPE_TORNADO:String = "b_tornado_001";
      
      public static const SHOT_TYPE_ROCKET_DOUBLE_AUTO:String = "b_rocket_002_auto";
      
      public static const SHOT_TYPE_LASER:String = "b_laser_001";
      
      public static const SHOT_TYPE_FLAME:String = "b_flame_001";
      
      public static const SHOT_TYPE_POKE:String = "b_poke_001";
      
      public static const SHOT_TYPE_BLAST:String = "b_blast_001";
      
      public static const SHOT_TYPE_BOMB:String = "b_bomb_001";
      
      public static const SHOT_TYPE_LOOT:String = "b_loot_001";
      
      public static const SHOT_TYPE_BURST:String = "b_burst_001";
      
      public static const SHOT_TYPE_ROCK:String = "b_rock_001";
      
      public static const BULLET_GROUP_SNIPER:String = "sniper";
      
      public static const BULLET_GROUP_FREEZE:String = "freeze";
      
      public static const UNIT_SPECIAL_ATTACK_ROCKET_SKU:String = "sa_rocket";
      
      public static const UNIT_SPECIAL_ATTACK_FREEZE_SKU:String = "sa_freeze";
      
      public static const UNIT_SPECIAL_ATTACK_CATAPULT_SKU:String = "sa_catapult";
      
      public static const UNIT_SPECIAL_ATTACK_NUKE_01_SKU:String = "sa_nuke_01";
      
      public static const UNIT_SPECIAL_ATTACK_NUKE_02_SKU:String = "sa_nuke_02";
      
      public static const UNIT_BLAST_DAMAGE_DISTRIBUTION_UNIFORM:String = "uniform";
      
      public static const UNIT_BLAST_DAMAGE_DISTRIBUTION_LINEAR:String = "linear";
      
      public static const NEWS_FEED_INSTANTBUILD:String = "instantBuild";
      
      public static const NEWS_FEED_INSTANTREPAIR:String = "instantRepair";
      
      public static const NEWS_FEED_INSTANTUPGRADE:String = "instantUpgrade";
      
      public static const NEWS_FEED_ENDWAR:String = "war";
      
      public static const NEWS_FEED_ENDWARNPC:String = "warNPC";
      
      public static const NEWS_FEED_MISSIONCOMPLETE:String = "missionCompleted";
      
      public static const NEWS_FEED_LEVELUP:String = "levelUp";
      
      public static const NEWS_FEED_WISHLIST:String = "wishlist";
      
      public static const NEWS_FEED_FRIENDHELPED:String = "friendHelped";
      
      public static const NEWS_FEED_ASKFORDROIDPART:String = "askForItemDroid";
      
      public static const NEWS_FEED_ASKFORSPEEDUPQUEUE:String = "askForSpeedupQueue";
      
      public static const NEWS_FEED_ACTIVATEUNITSPEEDUP:String = "activateUnitSpeedup";
      
      public static const NEWS_FEED_UPGRADEUNITSPEEDUP:String = "upgradeUnitSpeedup";
      
      public static const NEWS_FEED_UNITSFORBUNKER:String = "unitsForBunker";
      
      public static const NEWS_FEED_PLANETCOLONIZED:String = "NewColony";
      
      public static const NEWS_FEED_PLANETMOVED:String = "MovedColony";
      
      public static const NEWS_FEED_THANKSHELPBUNKER:String = "thanksHelpBunker";
      
      public static const NEWS_FEED_ACTIVATEUNITCOMPLETED:String = "activateUnitComplete";
      
      public static const NEWS_FEED_UPGRADEUNITCOMPLETED:String = "upgradeUnitComplete";
      
      public static const NEWS_FEED_ALLIANCEWARDECLARED:String = "allianceWarDeclared";
      
      public static const NEWS_FEED_ALLIANCECREATED:String = "allianceCreated";
      
      public static const NEWS_FEED_ALLIANCEREWARD:String = "allianceReward";
      
      public static const NEWS_FEED_ALLIANCEWARWON:String = "allianceWarWon";
      
      public static const NEWS_FEED_INVESTREMIND:String = "investRemind";
      
      public static const NEWS_FEED_INVESTHURRYUP:String = "investHurryup";
      
      public static const NEWS_FEED_INVEST_REWARD:String = "investReward";
      
      public static const NEWS_FEED_INVEST_TUTO_REWARD:String = "investTutoReward";
      
      public static const NEWS_FEED_PASS_FRIENDS_LEVELUP:String = "PassFriendLevel";
      
      public static const NEWS_FEED_PASS_FRIENDS_BATTLE_RANKING:String = "PassFriendBattle";
      
      public static const NEWS_FEED_WIN_BET:String = "winBet";
      
      public static const NEWS_FEED_CONTEST_WON:String = "contestWon";
      
      public static const NEWS_FEED_CONTEST_LOSE:String = "contestLost";
      
      public static const EXPLOSION_BUILDING_TILES_BASE:int = 12;
      
      public static const BACKGROUND_GALAXY_VIEW:String = "background_galaxy";
      
      public static const BACKGROUND_SPACE_STAR_VIEW:String = "background_space_star_v2";
      
      public static const GALAXY_VIEW:String = "galaxy_view";
      
      public static const SPACE_STAR_VIEW:String = "space_star_view";
      
      public static const PLANET_VIEW:String = "planet_view";
      
      public static const GALAXY_ICON_PLANET:int = 0;
      
      public static const GALAXY_ICON_PLANET_EMPTY:int = 1;
      
      public static const GALAXY_ICON_STAR:int = 2;
      
      public static const GALAXY_ICON_STAR_TOOLTIP:int = 3;
      
      public static const SPACE_STAR_ICON_SUN:int = 4;
      
      public static const SPACE_STAR_ICON_NPC_A:int = 5;
      
      public static const SPACE_STAR_ICON_NPC_B:int = 6;
      
      public static const SPACE_STAR_ICON_NPC_C:int = 7;
      
      public static const SPACE_STAR_ICON_NPC_D:int = 8;
      
      public static const SPACE_STAR_ICON_NPC_E:int = 9;
      
      public static const MAIN_PLANET:String = "mainPlanet";
      
      public static const COLONY_PLANET:String = "colony";
      
      public static const SPACE_MAPS_MAX_AMOUNT_PLANETS_OWNED:int = 12;
      
      public static const DISTANCE_FORMULA_CONST_A:Number = 2000;
      
      public static const DISTANCE_FORMULA_CONST_B:Number = 0.072;
      
      public static const ANTI_CHEAT_CHANGE_MEMORY:String = "cheatClientMemory";
      
      public static const ANTI_CHEAT_MACRO:String = "cheatMacro";
      
      public static const ANTI_CHEAT_CONSOLE:String = "cheatConsole";
      
      public static const CANT_ATTACK_REASON_RIVAL_NO_ATTACKABLE:String = "cantAttackRivalNoAttackable";
      
      public static const CANT_ATTACK_REASON_NOT_ENOUGH_MINERALS_CAPACITY:String = "cantAttackNotEnoughMineralsCapacity";
      
      public static const CANT_ATTACK_REASON_OWNER_NO_ARMY:String = "cantAttackOwnerNoArmy";
      
      public static const CANT_ATTACK_REASON_OWNER_CRAFT_PENDING:String = "cantAttackOwnerCraftPending";
      
      public static const CANT_ATTACK_REASON_OWNER_LOOSE_DAMAGE_PROTECTION:String = "cantAttackOwnerLooseDamageProtection";
      
      private static const TILE_2_COOR:Number = 33;
      
      public static const TEMPLATE_RESPONSE_ALL_OK:int = 0;
      
      public static const TEMPLATE_RESPONSE_ERROR_TYPE_OVERLAP:int = 1;
      
      public static const TEMPLATE_RESPONSE_ERROR_TYPE_OBSTACLE:int = 2;
      
      public static const TEMPLATE_RESPONSE_ERROR_TYPE_EMPTY:int = 3;
      
      public static const TEMPLATE_RESPONSE_ERROR_TYPE_INVALID:int = 4;
      
      public static const TEMPLATE_RESPONSE_ERROR_TYPE_BAD_UUID:int = 5;
       
      
      public function GameConstants()
      {
         super();
      }
      
      public static function colonyShieldGetWarningText(reason:int) : String
      {
         var tid:int = 0;
         switch(reason)
         {
            case 0:
               tid = 353;
               break;
            case 1:
               tid = 354;
         }
         return DCTextMng.getText(tid);
      }
      
      public static function currencyGetIdFromKey(key:String) : int
      {
         if(smCurrencyDictionary == null)
         {
            smCurrencyDictionary = new Dictionary(true);
            smCurrencyDictionary["pc"] = 0;
            smCurrencyDictionary["cash"] = 0;
            smCurrencyDictionary["coins"] = 1;
            smCurrencyDictionary["minerals"] = 2;
            smCurrencyDictionary["maxMinerals"] = 3;
            smCurrencyDictionary["droids"] = 4;
            smCurrencyDictionary["maxDroids"] = 5;
            smCurrencyDictionary["maxCoins"] = 7;
            smCurrencyDictionary["badges"] = 8;
            smCurrencyDictionary["maxBadges"] = 9;
         }
         return smCurrencyDictionary[key];
      }
      
      public static function currencyGetKeyFromId(id:int) : String
      {
         if(smCurrencyNames == null)
         {
            smCurrencyNames = [];
            smCurrencyNames[0] = "cash";
            smCurrencyNames[1] = "coins";
            smCurrencyNames[2] = "minerals";
            smCurrencyNames[3] = "maxMinerals";
            smCurrencyNames[4] = "droids";
            smCurrencyNames[5] = "maxDroids";
            smCurrencyNames[7] = "maxCoins";
            smCurrencyNames[8] = "badges";
            smCurrencyNames[9] = "maxBadges";
         }
         return smCurrencyNames[id];
      }
      
      public static function currencyHasToDoWithItems(key:String) : Boolean
      {
         return key == "item" || key == "items";
      }
      
      public static function currencyHasToDoWithChips(key:String) : Boolean
      {
         return key == "chips" || key == "cash";
      }
      
      public static function getHistoricalKeyByEventName(event:String) : String
      {
         if(smAllowedEventsForItemsHistory == null)
         {
            smAllowedEventsForItemsHistory = new Dictionary();
            smAllowedEventsForItemsHistory["WIOEventInstantBuild"] = "IB";
            smAllowedEventsForItemsHistory["WIOEventInstantDemolish"] = "ID";
            smAllowedEventsForItemsHistory["WIOEventInstantUpgrade"] = "IU";
            smAllowedEventsForItemsHistory["WIOEventRepairStart"] = "RS";
            smAllowedEventsForItemsHistory["WIOEventRepairEnd"] = "RE";
            smAllowedEventsForItemsHistory["WIOEventUpgradingEnd"] = "UE";
            smAllowedEventsForItemsHistory["WIOEventUpgradeStart"] = "US";
            smAllowedEventsForItemsHistory["WIOEventUpgradePremium"] = "UP";
            smAllowedEventsForItemsHistory["WIOEventBuildingEnd"] = "BE";
            smAllowedEventsForItemsHistory["WIOEventDemolitionEnd"] = "DE";
            smAllowedEventsForItemsHistory["WIORentCollectingEnd"] = "RC";
            smAllowedEventsForItemsHistory["WIOEventCancelUpgrade"] = "CU";
            smAllowedEventsForItemsHistory["WIOEventCancelBuild"] = "CB";
         }
         return smAllowedEventsForItemsHistory[event];
      }
      
      public static function expendablesInit() : void
      {
         if(EXPENDABLES_ASSET_SKU == null)
         {
            EXPENDABLES_ASSET_SKU = new Dictionary();
            EXPENDABLES_TILES_WIDTH = new Dictionary();
            EXPENDABLES_TILES_HEIGHT = new Dictionary();
            EXPENDABLES_HAS_TO_APPLY_EFFECT = new Dictionary();
            EXPENDABLES_ASSET_SKU["nuke"] = "crater_nuke";
            EXPENDABLES_TILES_WIDTH["nuke"] = 27;
            EXPENDABLES_TILES_HEIGHT["nuke"] = 27;
            EXPENDABLES_HAS_TO_APPLY_EFFECT["nuke"] = true;
            EXPENDABLES_ASSET_SKU["capsule"] = "crater_capsule";
            EXPENDABLES_TILES_WIDTH["capsule"] = 4;
            EXPENDABLES_TILES_HEIGHT["capsule"] = 4;
            EXPENDABLES_HAS_TO_APPLY_EFFECT["capsule"] = false;
         }
      }
      
      public static function init() : void
      {
         UNIT_FACTION_SUFFIX = new Array(2);
         UNIT_FACTION_SUFFIX[0] = "";
         UNIT_FACTION_SUFFIX[1] = "";
         SCENE_UNIT_TYPE_NEEDS_TO_SENSE_ENVIRONMENT_SECURE.objectValue = [false,false,true,true,true,true,true,false,true,false,true,false,false,false];
         expendablesInit();
      }
      
      public static function unitsSetFactionMode(mode:int) : void
      {
         smUnitFactionMode = mode;
      }
      
      public static function unitUseInversedRenderMode(faction:int) : Boolean
      {
         var normalMode:* = smUnitFactionMode == 0;
         return normalMode && faction == 0 || !normalMode && faction == 1;
      }
      
      public static function unitsGetSkin(faction:int) : String
      {
         var id:* = faction;
         return UNIT_FACTION_SUFFIX[id];
      }
      
      public static function translateTileToCoor(value:Number) : Number
      {
         return value * 33;
      }
      
      public static function getTimeTextFromMs(timeMs:Number, useAbbreviations:Boolean = true, useYears:Boolean = true, useMonths:Boolean = true, useWeeks:Boolean = true, useDays:Boolean = true, useHours:Boolean = true, useMinutes:Boolean = true, useSeconds:Boolean = true, useZeros:Boolean = false, useSmartZeroUsage:Boolean = false) : String
      {
         var Y:String = null;
         var M:String = null;
         var w:String = null;
         var d:String = null;
         var h:String = null;
         var m:String = null;
         var s:String = null;
         if(useAbbreviations)
         {
            Y = String(useYears ? DCTextMng.getText(2947) : null);
            M = String(useMonths ? DCTextMng.getText(2948) : null);
            w = String(useWeeks ? DCTextMng.getText(2949) : null);
            d = String(useDays ? DCTextMng.getText(48) : null);
            h = String(useHours ? DCTextMng.getText(47) : null);
            m = String(useMinutes ? DCTextMng.getText(46) : null);
            s = String(useSeconds ? DCTextMng.getText(45) : null);
         }
         else
         {
            Y = String(useYears ? DCTextMng.getText(2944) : null);
            M = String(useMonths ? DCTextMng.getText(2945) : null);
            w = String(useWeeks ? DCTextMng.getText(2946) : null);
            d = String(useDays ? DCTextMng.getText(43) : null);
            h = String(useHours ? DCTextMng.getText(41) : null);
            m = String(useMinutes ? DCTextMng.getText(40) : null);
            s = String(useSeconds ? DCTextMng.getText(38) : null);
         }
         return DCTimerUtil.getTimeTextFromMs(timeMs,Y,M,w,d,h,m,s,useZeros,useSmartZeroUsage);
      }
      
      public static function getTimeFromMs(timeMs:Number, useStringAbbreviation:Boolean = false, compactSpareTime:Boolean = false) : Array
      {
         var amount:* = 0;
         var tid:* = 0;
         var days:int = Math.abs(DCTimerUtil.msToDays(timeMs));
         var hours:int = Math.abs(DCTimerUtil.msToHour(timeMs - days * 86400000));
         var minutes:int = Math.abs(DCTimerUtil.msToMin(timeMs - days * 86400000 - hours * 3600000));
         var seconds:int = Math.abs(Math.round((timeMs - days * 86400000 - hours * 3600000 - minutes * 60000) * 0.001));
         var tidD:int = useStringAbbreviation ? 48 : 43;
         if(days == 1 && useStringAbbreviation == false)
         {
            tidD = 44;
         }
         var tidH:int = useStringAbbreviation ? 47 : 41;
         if(hours == 1 && useStringAbbreviation == false)
         {
            tidH = 42;
         }
         var tidM:int = useStringAbbreviation ? 46 : 40;
         var tidS:int = useStringAbbreviation ? 45 : 38;
         if(compactSpareTime)
         {
            amount = days;
            tid = tidD;
            if(hours > 0)
            {
               amount = DCTimerUtil.msToHour(days * 86400000) + hours;
               tid = tidH;
            }
            if(minutes > 0)
            {
               amount = DCTimerUtil.msToMin(days * 86400000 + hours * 3600000) + minutes;
               tid = tidM;
            }
            if(seconds > 0)
            {
               amount = timeMs * 0.001;
               tid = tidS;
            }
         }
         else
         {
            amount = days;
            tid = tidD;
            if(amount == 0)
            {
               amount = DCTimerUtil.msToHour(days * 86400000) + hours;
               tid = tidH;
               if(amount == 0)
               {
                  amount = DCTimerUtil.msToMin(days * 86400000 + hours * 3600000) + minutes;
                  tid = tidM;
                  if(amount == 0)
                  {
                     amount = timeMs * 0.001;
                     tid = tidS;
                  }
               }
            }
         }
         return [amount,DCTextMng.getText(tid)];
      }
      
      public static function getTimeTextFromMsForCountDown(timeMs:Number, useAbbreviations:Boolean = true, useDays:Boolean = true, useHours:Boolean = true, useMinutes:Boolean = true, useSeconds:Boolean = true, useZeros:Boolean = false) : String
      {
         return getTimeTextFromMs(timeMs,useAbbreviations,false,false,false,useDays,useHours,useMinutes,useSeconds,useZeros,true);
      }
      
      public static function convertNumberToStringUseDecimals(number:Number, useNumDecimals:int = 2) : String
      {
         var i:int = 0;
         var returnNumber:String = "";
         var decimals:Number = Math.pow(10,useNumDecimals);
         var useDecimals:*;
         if(useDecimals = (decimals = Math.round(number * decimals - Math.floor(number) * decimals)) > 0)
         {
            number = Math.floor(number);
         }
         var numberText:String = number.toString();
         var numberFigures:uint = 0;
         for(i = numberText.length - 1; i >= 0; )
         {
            numberFigures++;
            if(numberFigures == 4)
            {
               numberFigures = 1;
               returnNumber = DCTextMng.getText(36) + returnNumber;
            }
            returnNumber = numberText.charAt(i) + returnNumber;
            i--;
         }
         if(useDecimals)
         {
            returnNumber = returnNumber + DCTextMng.getText(37) + decimals;
         }
         return returnNumber;
      }
      
      public static function formatScoreValue(number:Number) : String
      {
         return DCTextMng.convertNumberToString(number,1,5);
      }
   }
}
