package com.dchoc.game.model.target
{
   import com.dchoc.game.controller.tools.Tool;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.world.target.action.ActionAutoscroll;
   import com.dchoc.game.model.world.target.action.ActionAutoscrollToPreviousPlace;
   import com.dchoc.game.model.world.target.action.ActionBackToHome;
   import com.dchoc.game.model.world.target.action.ActionBattleReturnArmy;
   import com.dchoc.game.model.world.target.action.ActionBeginKidnapSequence;
   import com.dchoc.game.model.world.target.action.ActionBuildBattle;
   import com.dchoc.game.model.world.target.action.ActionCloseShop;
   import com.dchoc.game.model.world.target.action.ActionCloseSpeechBubble;
   import com.dchoc.game.model.world.target.action.ActionFinishTutorial;
   import com.dchoc.game.model.world.target.action.ActionHideArrow;
   import com.dchoc.game.model.world.target.action.ActionHideSpotlight;
   import com.dchoc.game.model.world.target.action.ActionLockButtonsOnAttack;
   import com.dchoc.game.model.world.target.action.ActionLockGUIBut;
   import com.dchoc.game.model.world.target.action.ActionLockPopup;
   import com.dchoc.game.model.world.target.action.ActionLockPopupInstantOps;
   import com.dchoc.game.model.world.target.action.ActionLockScroll;
   import com.dchoc.game.model.world.target.action.ActionLockSolarSystemBut;
   import com.dchoc.game.model.world.target.action.ActionMapTiles;
   import com.dchoc.game.model.world.target.action.ActionNPCAttackOver;
   import com.dchoc.game.model.world.target.action.ActionOpenPopup;
   import com.dchoc.game.model.world.target.action.ActionOpenShop;
   import com.dchoc.game.model.world.target.action.ActionOpenSpeechBubble;
   import com.dchoc.game.model.world.target.action.ActionPrepareBattle;
   import com.dchoc.game.model.world.target.action.ActionRemoveKeyFromTutorial;
   import com.dchoc.game.model.world.target.action.ActionSetDefaultBuilding;
   import com.dchoc.game.model.world.target.action.ActionSetDefaultShop;
   import com.dchoc.game.model.world.target.action.ActionSetTutorialBuilding;
   import com.dchoc.game.model.world.target.action.ActionShowCircleInButton;
   import com.dchoc.game.model.world.target.action.ActionShowCircleInButtonInstantOps;
   import com.dchoc.game.model.world.target.action.ActionShowCircleInMap;
   import com.dchoc.game.model.world.target.action.ActionShowCircleInMovieclip;
   import com.dchoc.game.model.world.target.action.ActionShowCircleInNavBar;
   import com.dchoc.game.model.world.target.action.ActionShowCircleInPlanet;
   import com.dchoc.game.model.world.target.action.ActionShowCircleInTiles;
   import com.dchoc.game.model.world.target.action.ActionShowSpotlight;
   import com.dchoc.game.model.world.target.action.ActionSoundSet;
   import com.dchoc.game.model.world.target.action.ActionStartFireworks;
   import com.dchoc.game.model.world.target.action.ActionStartInvestsIntro;
   import com.dchoc.game.model.world.target.action.ActionStopFireworks;
   import com.dchoc.game.model.world.target.action.ActionToggleBlackStrips;
   import com.dchoc.game.model.world.target.action.ActionTutorialSetupOptions;
   import com.dchoc.game.model.world.target.action.ActionUnlockGUI;
   import com.dchoc.game.model.world.target.action.ActionUnlockNavBarComponent;
   import com.dchoc.game.model.world.target.action.ActionUnlockPopup;
   import com.dchoc.game.model.world.target.action.ActionUnlockSettings;
   import com.dchoc.game.model.world.target.action.ActionWait;
   import com.dchoc.game.model.world.target.action.tutorial.ActionShowTutorialMission005;
   import com.dchoc.game.model.world.target.action.tutorial.ActionShowTutorialMission021;
   import com.dchoc.game.model.world.target.condition.ConditionAccumulate;
   import com.dchoc.game.model.world.target.condition.ConditionArrowShown;
   import com.dchoc.game.model.world.target.condition.ConditionBackHome;
   import com.dchoc.game.model.world.target.condition.ConditionBattleHasStarted;
   import com.dchoc.game.model.world.target.condition.ConditionBattleOver;
   import com.dchoc.game.model.world.target.condition.ConditionBuildingsCreated;
   import com.dchoc.game.model.world.target.condition.ConditionComposite;
   import com.dchoc.game.model.world.target.condition.ConditionCurrentRole;
   import com.dchoc.game.model.world.target.condition.ConditionCurrentView;
   import com.dchoc.game.model.world.target.condition.ConditionDroidCreated;
   import com.dchoc.game.model.world.target.condition.ConditionFireworksOver;
   import com.dchoc.game.model.world.target.condition.ConditionHasKidnapSequenceEnded;
   import com.dchoc.game.model.world.target.condition.ConditionHasWaveBeenLaunched;
   import com.dchoc.game.model.world.target.condition.ConditionHaveColonies;
   import com.dchoc.game.model.world.target.condition.ConditionHaveItem;
   import com.dchoc.game.model.world.target.condition.ConditionIntroOver;
   import com.dchoc.game.model.world.target.condition.ConditionIsCameraInPosition;
   import com.dchoc.game.model.world.target.condition.ConditionIsUnitUnlocked;
   import com.dchoc.game.model.world.target.condition.ConditionIsUnitUpgraded;
   import com.dchoc.game.model.world.target.condition.ConditionLoadStarmapAmount;
   import com.dchoc.game.model.world.target.condition.ConditionPopupClosed;
   import com.dchoc.game.model.world.target.condition.ConditionPopupShown;
   import com.dchoc.game.model.world.target.condition.ConditionShopClosed;
   import com.dchoc.game.model.world.target.condition.ConditionShopShown;
   import com.dchoc.game.model.world.target.condition.ConditionSpeechBubbleTextEnd;
   import com.dchoc.game.model.world.target.condition.ConditionSpotlightHidden;
   import com.dchoc.game.model.world.target.condition.ConditionSpotlightShown;
   import com.dchoc.game.model.world.target.condition.ConditionToolSelected;
   import com.dchoc.game.model.world.target.condition.ConditionUnlockByLevel;
   import com.dchoc.game.model.world.target.condition.ConditionUnlockByTargets;
   import com.dchoc.game.model.world.target.condition.ConditionVisitingCity;
   import com.dchoc.game.model.world.target.condition.ConditionWaitOver;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.DCTargetDefMng;
   import com.dchoc.toolkit.core.target.action.DCAction;
   import com.dchoc.toolkit.core.target.condition.DCCondition;
   import com.dchoc.toolkit.utils.def.DCDef;
   import esparragon.utils.EUtils;
   import flash.utils.Dictionary;
   
   public class TargetDefMng extends DCTargetDefMng
   {
      
      public static const DEF_TUTORIAL_ID:int = 0;
      
      public static const DEF_MISSION_ID:int = 1;
      
      public static const TYPE_SKUS:Vector.<String> = new <String>["tutorial","mission"];
      
      private static const RESOURCE_DEFS:Vector.<String> = new <String>["tutorialDefinitions.xml","missionDefinitions.xml"];
      
      public static const CONDITION_NONE_1:String = "";
      
      public static const CONDITION_NONE_2:String = "none";
      
      public static const CONDITION_UNLOCKBYLEVEL_ID:String = "level";
      
      public static const CONDITION_UNLOCKBYMISSIONS_ID:String = "targets";
      
      public static const CONDITION_COMPOSITE:String = "composite";
      
      public static const CONDITION_ACCUMULATE_ID:String = "accumulate";
      
      public static const CONDITION_ACCUMULATE_BUILD_ID:String = "build";
      
      public static const CONDITION_ACCUMULATE_COLLECT_ID:String = "collect";
      
      public static const CONDITION_ACCUMULATE_PLACE_ITEM_ID:String = "placeItem";
      
      public static const CONDITION_ACCUMULATE_CHANGE_SHOP_ID:String = "changeShop";
      
      public static const CONDITION_ACCUMULATE_INSTANT_BUILD_ID:String = "instantBuild";
      
      public static const CONDITION_ACCUMULATE_CLICKSHOPBUTTON:String = "clickShopButton";
      
      public static const CONDITION_ACCUMULATE_LOOT:String = "loot";
      
      public static const CONDITION_ACCUMULATE_UPGRADE_ID:String = "upgrade";
      
      public static const CONDITION_ACCUMULATE_UNLOCK_ID:String = "unlock";
      
      public static const CONDITION_ACCUMULATE_RECYCLE_ID:String = "recycle";
      
      public static const CONDITION_ACCUMULATE_KILL_OWN_UNIT_ID:String = "killOwnUnit";
      
      public static const CONDITION_ACCUMULATE_KILL_ENEMY_UNIT_ID:String = "killEnemyUnit";
      
      public static const CONDITION_ACCUMULATE_LOOT_COLLECTABLE_ID:String = "lootCollectable";
      
      public static const CONDITION_ACCUMULATE_RESIST_NPC_ATTACK_ID:String = "resistAttack";
      
      public static const CONDITION_ACCUMULATE_BUY_DROID_ID:String = "buyDroid";
      
      public static const CONDITION_ACCUMULATE_COMPLETE_COLLECTION:String = "completeCollection";
      
      public static const CONDITION_ACCUMULATE_COMPLETE_CRAFTING:String = "completeCrafting";
      
      public static const CONDITION_ACCUMULATE_COMPLETE_REFINING:String = "completeRefining";
      
      public static const CONDITION_ACCUMULATE_USE_CRAFTING:String = "useCrafting";
      
      public static const CONDITION_ACCUMULATE_DAMAGE_CAUSED:String = "damageCaused";
      
      public static const CONDITION_ACCUMULATE_SEND_UNITS_TO_BATTLE:String = "sendUnitsToBattle";
      
      public static const CONDITION_ACCUMULATE_HELP_FRIEND:String = "helpFriend";
      
      public static const CONDITION_ACCUMULATE_SEND_CIVIL_RIDE:String = "sendCivilRide";
      
      public static const CONDITION_ACCUMULATE_SPEED_UP_QUEUE:String = "speedUpQueue";
      
      public static const CONDITION_ACCUMULATE_SPEED_UP_UNIT:String = "speedUpUnit";
      
      public static const CONDITION_POPUP_CLOSED_ID:String = "popupClosed";
      
      public static const CONDITION_POPUP_SHOWN_ID:String = "popupShown";
      
      public static const CONDITION_SHOPCLOSED_ID:String = "shopClosed";
      
      public static const CONDITION_SHOPSHOWN_ID:String = "shopShown";
      
      public static const CONDITION_ARROW_SHOWN_ID:String = "arrowShown";
      
      public static const CONDITION_SPOTLIGHT_HIDDEN_ID:String = "spotlightHidden";
      
      public static const CONDITION_SPOTLIGHT_SHOWN_ID:String = "spotlightShown";
      
      public static const CONDITION_BATTLE_OVER_ID:String = "battleOver";
      
      public static const CONDITION_BATTLE_HAS_STARTED:String = "battleHasStarted";
      
      public static const CONDITION_DROID_HAS_ARRIVED:String = "droidHasArrived";
      
      public static const CONDITION_SHIP_HAS_ARRIVED_TO_HQ:String = "shipHasArrivedToHQ";
      
      public static const CONDITION_VISIT_ANY_CITY:String = "visitAnyCity";
      
      public static const CONDITION_VISITING_CITY:String = "visitingCity";
      
      public static const CONDITION_VISITING_CITY_SKU:String = "visitingCitySku";
      
      public static const CONDITION_SPYING_CITY_SKU:String = "spyingCitySku";
      
      public static const CONDITION_ATTACKING_CITY_SKU:String = "attackingCitySku";
      
      public static const CONDITION_BACK_HOME:String = "isbackHome";
      
      public static const CONDITION_IS_CAMERA_IN_POSITION:String = "isCameraInPosition";
      
      public static const CONDITION_HAS_WAVE_BEEN_LAUNCHED:String = "hasWaveBeenLaunched";
      
      public static const CONDITION_WAIT_OVER:String = "isWaitOver";
      
      public static const CONDITION_SHIPS_SELECTED_FOR_BATTLE:String = "shipsSelectedForBattle";
      
      public static const CONDITION_LAUNCH_ATTACK:String = "launchAttack";
      
      public static const CONDITION_GOING_TO_ATTACK_BUTTON_CLICKED:String = "goingToAttackButtonClicked";
      
      public static const CONDITION_FIREWORKS_OVER:String = "fireworksOver";
      
      public static const CONDITION_BUILDINGS_CREATED:String = "buildingsCreated";
      
      public static const CONDITION_ACCUMULATE_BUILDINGS_MOVED:String = "buildingsMoved";
      
      public static const CONDITION_DROIDS_CREATED:String = "droidsCreated";
      
      public static const CONDITION_TOOL_SELECTED:String = "toolSelected";
      
      public static const CONDITION_HAS_KIDNAP_SEQUENCE_ENDED:String = "hasKidnapSequenceEnded";
      
      public static const CONDITION_IS_UNIT_UNLOCKED:String = "unitUnlocked";
      
      public static const CONDITION_IS_UNIT_UPGRADED:String = "unitUpgraded";
      
      public static const CONDITION_IS_INTRO_OVER:String = "introOver";
      
      public static const CONDITION_CURRENT_VIEW:String = "currentView";
      
      public static const CONDITION_CURRENT_ROLE:String = "currentRole";
      
      public static const CONDITION_LOAD_STARMAP_AMOUNT:String = "loadStarmapAmount";
      
      public static const CONDITION_HAVE_COLONIES:String = "haveColonies";
      
      public static const CONDITION_HAVE_ITEM:String = "possess";
      
      public static const CONDITION_ACCUMULATE_SEND_WISHLIST_ITEM:String = "sendWishlistItem";
      
      public static const CONDITION_ADD_UNITS_TO_FRIENDS_BUNKER:String = "addUnitsToFriendsBunker";
      
      public static const CONDITION_SPEECH_BUBBLE_TEXT_END:String = "speechBubbleTextEnd";
      
      public static const CONDITION_TROOPS_RETURN_FROM_ATTACK:String = "troopsReturnFromAttack";
      
      public static const ACTION_ID_OPEN_POPUP:String = "openPopup";
      
      public static const ACTION_ID_OPEN_SPEECH_BUBBLE:String = "openSpeechBubble";
      
      public static const ACTION_ID_OPEN_SHOP:String = "openShop";
      
      public static const ACTION_ID_CLOSE_SHOP:String = "closeShop";
      
      public static const ACTION_ID_FINISH_TUTORIAL:String = "finishTutorial";
      
      public static const ACTION_ID_SHOW_ARROW_IN_TILE:String = "showArrowInTile";
      
      public static const ACTION_ID_SHOW_ARROW_IN_MAP:String = "showArrowInMap";
      
      public static const ACTION_SHOW_ARROW_IN_MOVIECLIP:String = "showArrowInMovieclip";
      
      public static const ACTION_SHOW_ARROW_IN_NAV_BAR:String = "showArrowInNavBar";
      
      public static const ACTION_ID_HIDE_ARROW:String = "hideArrow";
      
      public static const ACTION_ID_SHOW_SPOTLIGHT:String = "showSpotlight";
      
      public static const ACTION_ID_HIDE_SPOTLIGHT:String = "hideSpotlight";
      
      public static const ACTION_ID_CLOSE_SPEECHBUBBLE:String = "closeSpeechBubble";
      
      public static const ACTION_ID_BUILD_BATTLE:String = "buildBattle";
      
      public static const ACTION_ID_MAP_TILES:String = "mapTiles";
      
      public static const ACTION_ID_MAP_TILES_SQUARE:String = "mapTilesSquare";
      
      public static const ACTION_ID_SET_DEFAULT_SHOP:String = "setDefaultShop";
      
      public static const ACTION_ID_SHOW_ARROW_IN_BUTTON:String = "showArrowInButton";
      
      public static const ACTION_ID_SHOW_ARROW_IN_BUTTON_INSTANT_OPS:String = "showArrowInButtonInstantOps";
      
      public static const ACTION_ID_LOCK_GUI:String = "lockGUIBut";
      
      public static const ACTION_ID_UNLOCK_GUI:String = "unlockGUI";
      
      public static const ACTION_ID_UNLOCK_SETTINGS:String = "unlockSettings";
      
      public static const ACTION_ID_UNLOCK_NAV_BAR_COMP:String = "unlockNavBarComp";
      
      public static const ACTION_ID_SET_TUTORIAL_BUILDING:String = "setTutorialBuilding";
      
      public static const ACTION_ID_SET_DEFAULT_BUILDING:String = "setDefaultBuilding";
      
      public static const ACTION_ID_COME_BACK_HOME:String = "comeBackHome";
      
      public static const ACTION_ID_BATTLE_RETURN_ARMY:String = "battleReturnArmy";
      
      public static const ACTION_ID_AUTOSCROLL:String = "autoScroll";
      
      public static const ACTION_ID_WAIT:String = "wait";
      
      public static const ACTION_ID_LOCK_POPUP:String = "lockPopup";
      
      public static const ACTION_ID_LOCK_POPUP_INSTANT_OPS:String = "lockPopupInstantOps";
      
      public static const ACTION_ID_UNLOCK_POPUP:String = "unlockPopup";
      
      public static const ACTION_ID_AUTO_SCROLL_PREV_PLACE:String = "autoScrollPreviousPlace";
      
      public static const ACTION_ID_LOCK_BUTTONS_ON_ATTACK:String = "lockButtonsOnAttack";
      
      public static const ACTION_ID_LOCK_SCROLL:String = "scrollAllowed";
      
      public static const ACTION_ID_START_FIREWORKS:String = "startFireworks";
      
      public static const ACTION_ID_STOP_FIREWORKS:String = "stopFireworks";
      
      public static const ACTION_ID_PREPARE_NPC_ATTACK:String = "prepareNPCAttack";
      
      public static const ACTION_ID_NPC_ATTACK_OVER:String = "NPCAttackOver";
      
      public static const ACTION_ID_OPEN_BLACKSTRIPS:String = "openBlackStrips";
      
      public static const ACTION_ID_CLOSE_BLACKSTRIPS:String = "closeBlackStrips";
      
      public static const ACTION_ID_SETUP_OPTIONS_BUTTON:String = "setupOptionsButton";
      
      public static const ACTION_ID_BEGIN_KIDNAP_SEQUENCE:String = "beginKidnapSequence";
      
      public static const ACTION_ID_SOUND_SET:String = "soundSet";
      
      public static const ACTION_ID_START_INVESTS_INTO:String = "investsIntro";
      
      public static const ACTION_SHOW_TUTORIAL_MISSION_021:String = "showTutorialMission021";
      
      public static const ACTION_SHOW_TUTORIAL_MISSION_005:String = "showTutorialMission005";
      
      public static const ACTION_ID_LOCK_SOLAR_SYSTEM_BUT:String = "lockSolarSystemBut";
      
      public static const ACTION_ID_SHOW_ARROW_IN_PLANET:String = "showArrowInPlanet";
      
      public static const ACTION_ID_REMOVE_KEY_FROM_INVENTORY:String = "removeKeyFromInventory";
       
      
      private var mAchievements:Dictionary;
      
      private var mAchievementIdx:int = 0;
      
      public function TargetDefMng(directoryPath:String = null)
      {
         super(RESOURCE_DEFS,TYPE_SKUS,directoryPath);
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new TargetDef();
      }
      
      public function getTutorialDefs() : Vector.<DCDef>
      {
         return getDefs(EUtils.array2VectorString([TYPE_SKUS[0]]));
      }
      
      public function getMissionDefs() : Vector.<DCDef>
      {
         var missionDefs:Vector.<DCDef> = getDefs(EUtils.array2VectorString([TYPE_SKUS[1]]));
         missionDefs.sort(this.sortByPrio);
         return missionDefs;
      }
      
      private function sortByPrio(a:TargetDef, b:TargetDef) : Number
      {
         var aValue:Number = a.getPriority() as Number;
         var bValue:Number = b.getPriority() as Number;
         if(aValue > bValue)
         {
            return 1;
         }
         if(aValue < bValue)
         {
            return -1;
         }
         return 0;
      }
      
      override protected function filterConditionId(conditionId:String) : String
      {
         switch(conditionId)
         {
            case "loot":
            case "build":
            case "collect":
            case "placeItem":
            case "changeShop":
            case "instantBuild":
            case "buildingsMoved":
            case "clickShopButton":
            case "droidHasArrived":
            case "shipHasArrivedToHQ":
            case "troopsReturnFromAttack":
            case "shipsSelectedForBattle":
            case "launchAttack":
            case "goingToAttackButtonClicked":
            case "upgrade":
            case "unlock":
            case "recycle":
            case "killOwnUnit":
            case "visitAnyCity":
            case "visitingCitySku":
            case "spyingCitySku":
            case "attackingCitySku":
            case "killEnemyUnit":
            case "lootCollectable":
            case "resistAttack":
            case "buyDroid":
            case "completeCollection":
            case "completeCrafting":
            case "completeRefining":
            case "useCrafting":
            case "damageCaused":
            case "sendUnitsToBattle":
            case "helpFriend":
            case "sendCivilRide":
            case "speedUpQueue":
            case "speedUpUnit":
            case "addUnitsToFriendsBunker":
            case "sendWishlistItem":
               break;
            default:
               return conditionId;
         }
         return "accumulate";
      }
      
      override protected function requestCondition(conditionId:String) : void
      {
         if(mConditionCatalog[conditionId] != null)
         {
            return;
         }
         var conditionClass:Class = null;
         switch(conditionId)
         {
            case "level":
               conditionClass = ConditionUnlockByLevel;
               break;
            case "targets":
               conditionClass = ConditionUnlockByTargets;
               break;
            case "composite":
               conditionClass = ConditionComposite;
               break;
            case "accumulate":
               conditionClass = ConditionAccumulate;
               break;
            case "popupClosed":
               conditionClass = ConditionPopupClosed;
               break;
            case "popupShown":
               conditionClass = ConditionPopupShown;
               break;
            case "shopClosed":
               conditionClass = ConditionShopClosed;
               break;
            case "shopShown":
               conditionClass = ConditionShopShown;
               break;
            case "arrowShown":
               conditionClass = ConditionArrowShown;
               break;
            case "spotlightHidden":
               conditionClass = ConditionSpotlightHidden;
               break;
            case "spotlightShown":
               conditionClass = ConditionSpotlightShown;
               break;
            case "battleOver":
               conditionClass = ConditionBattleOver;
               break;
            case "battleHasStarted":
               conditionClass = ConditionBattleHasStarted;
               break;
            case "visitingCity":
               conditionClass = ConditionVisitingCity;
               break;
            case "isbackHome":
               conditionClass = ConditionBackHome;
               break;
            case "isCameraInPosition":
               conditionClass = ConditionIsCameraInPosition;
               break;
            case "hasWaveBeenLaunched":
               conditionClass = ConditionHasWaveBeenLaunched;
               break;
            case "isWaitOver":
               conditionClass = ConditionWaitOver;
               break;
            case "fireworksOver":
               conditionClass = ConditionFireworksOver;
               break;
            case "buildingsCreated":
               conditionClass = ConditionBuildingsCreated;
               break;
            case "droidsCreated":
               conditionClass = ConditionDroidCreated;
               break;
            case "toolSelected":
               conditionClass = ConditionToolSelected;
               break;
            case "hasKidnapSequenceEnded":
               conditionClass = ConditionHasKidnapSequenceEnded;
               break;
            case "currentView":
               conditionClass = ConditionCurrentView;
               break;
            case "currentRole":
               conditionClass = ConditionCurrentRole;
               break;
            case "unitUnlocked":
               conditionClass = ConditionIsUnitUnlocked;
               break;
            case "unitUpgraded":
               conditionClass = ConditionIsUnitUpgraded;
               break;
            case "loadStarmapAmount":
               conditionClass = ConditionLoadStarmapAmount;
               break;
            case "introOver":
               conditionClass = ConditionIntroOver;
               break;
            case "haveColonies":
               conditionClass = ConditionHaveColonies;
               break;
            case "possess":
               conditionClass = ConditionHaveItem;
               break;
            case "speechBubbleTextEnd":
               conditionClass = ConditionSpeechBubbleTextEnd;
               break;
            case "":
            case "none":
               conditionClass = DCCondition;
               break;
            default:
               DCDebug.trace("!!! CONDITION NOT FOUND: [" + conditionId + "] skipping add to catalog !!!");
               conditionId = null;
         }
         if(conditionId != null)
         {
            mConditionCatalog[conditionId] = new conditionClass();
         }
      }
      
      override public function getCondition(conditionId:String) : DCCondition
      {
         var returnValue:DCCondition = null;
         if(conditionId == "composite")
         {
            returnValue = new ConditionComposite();
         }
         else
         {
            returnValue = super.getCondition(conditionId);
         }
         return returnValue;
      }
      
      override protected function requestAction(actionId:String) : void
      {
         if(mActionCatalog[actionId] != null)
         {
            return;
         }
         var actionClass:Class = null;
         switch(actionId)
         {
            case "openPopup":
               actionClass = ActionOpenPopup;
               break;
            case "openSpeechBubble":
               actionClass = ActionOpenSpeechBubble;
               break;
            case "openShop":
               actionClass = ActionOpenShop;
               break;
            case "closeShop":
               actionClass = ActionCloseShop;
               break;
            case "finishTutorial":
               actionClass = ActionFinishTutorial;
               break;
            case "showArrowInTile":
               actionClass = ActionShowCircleInTiles;
               break;
            case "showArrowInMap":
               actionClass = ActionShowCircleInMap;
               break;
            case "showArrowInNavBar":
               actionClass = ActionShowCircleInNavBar;
               break;
            case "showArrowInMovieclip":
               actionClass = ActionShowCircleInMovieclip;
               break;
            case "hideArrow":
               actionClass = ActionHideArrow;
               break;
            case "showSpotlight":
               actionClass = ActionShowSpotlight;
               break;
            case "hideSpotlight":
               actionClass = ActionHideSpotlight;
               break;
            case "closeSpeechBubble":
               actionClass = ActionCloseSpeechBubble;
               break;
            case "buildBattle":
               actionClass = ActionBuildBattle;
               break;
            case "mapTiles":
            case "mapTilesSquare":
               actionClass = ActionMapTiles;
               break;
            case "setDefaultShop":
               actionClass = ActionSetDefaultShop;
               break;
            case "showArrowInButton":
               actionClass = ActionShowCircleInButton;
               break;
            case "showArrowInButtonInstantOps":
               actionClass = ActionShowCircleInButtonInstantOps;
               break;
            case "lockGUIBut":
               actionClass = ActionLockGUIBut;
               break;
            case "unlockGUI":
               actionClass = ActionUnlockGUI;
               break;
            case "unlockSettings":
               actionClass = ActionUnlockSettings;
               break;
            case "unlockNavBarComp":
               actionClass = ActionUnlockNavBarComponent;
               break;
            case "setDefaultBuilding":
               actionClass = ActionSetDefaultBuilding;
               break;
            case "setTutorialBuilding":
               actionClass = ActionSetTutorialBuilding;
               break;
            case "comeBackHome":
               actionClass = ActionBackToHome;
               break;
            case "battleReturnArmy":
               actionClass = ActionBattleReturnArmy;
               break;
            case "autoScroll":
               actionClass = ActionAutoscroll;
               break;
            case "wait":
               actionClass = ActionWait;
               break;
            case "lockPopup":
               actionClass = ActionLockPopup;
               break;
            case "lockPopupInstantOps":
               actionClass = ActionLockPopupInstantOps;
               break;
            case "unlockPopup":
               actionClass = ActionUnlockPopup;
               break;
            case "autoScrollPreviousPlace":
               actionClass = ActionAutoscrollToPreviousPlace;
               break;
            case "lockButtonsOnAttack":
               actionClass = ActionLockButtonsOnAttack;
               break;
            case "scrollAllowed":
               actionClass = ActionLockScroll;
               break;
            case "startFireworks":
               actionClass = ActionStartFireworks;
               break;
            case "stopFireworks":
               actionClass = ActionStopFireworks;
               break;
            case "prepareNPCAttack":
               actionClass = ActionPrepareBattle;
               break;
            case "NPCAttackOver":
               actionClass = ActionNPCAttackOver;
               break;
            case "openBlackStrips":
            case "closeBlackStrips":
               actionClass = ActionToggleBlackStrips;
               break;
            case "setupOptionsButton":
               actionClass = ActionTutorialSetupOptions;
               break;
            case "beginKidnapSequence":
               actionClass = ActionBeginKidnapSequence;
               break;
            case "soundSet":
               actionClass = ActionSoundSet;
               break;
            case "lockSolarSystemBut":
               actionClass = ActionLockSolarSystemBut;
               break;
            case "showArrowInPlanet":
               actionClass = ActionShowCircleInPlanet;
               break;
            case "removeKeyFromInventory":
               actionClass = ActionRemoveKeyFromTutorial;
               break;
            case "investsIntro":
               actionClass = ActionStartInvestsIntro;
               break;
            case "showTutorialMission021":
               actionClass = ActionShowTutorialMission021;
               break;
            case "showTutorialMission005":
               actionClass = ActionShowTutorialMission005;
               break;
            default:
               DCDebug.trace("!!! ACTION NOT FOUND: [" + actionId + "] skipping add to catalog !!!");
               actionId = null;
         }
         if(actionId != null)
         {
            mActionCatalog[actionId] = new actionClass();
         }
      }
      
      public function skipTutorial() : void
      {
         var target:DCTarget = null;
         var targets:Array = InstanceMng.getTargetMng().getAllTargets();
         for each(target in targets)
         {
            if(target.getDef().mSku.indexOf("tutorial_step") > -1)
            {
               InstanceMng.getTargetDefMng().changeState(target,4);
            }
         }
         InstanceMng.getApplication().speechPopupClose();
         InstanceMng.getGUIController().unlockGUI();
         Tool.tooltipsEnabled = true;
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var action:DCAction = null;
         for each(action in mActionCatalog)
         {
            action.logicUpdate(dt);
         }
      }
      
      override public function changeState(target:DCTarget, stateId:int) : void
      {
         if(target == null)
         {
            return;
         }
         var conditionType:String = null;
         var conditionComposite:ConditionComposite = null;
         var conditionsArray:Array = null;
         var condition:DCCondition = null;
         var i:int = 0;
         var max:int = 0;
         var condId:String = null;
         super.changeState(target,stateId);
         if((conditionType = target.getConditionType()) == "composite" && stateId < 3)
         {
            conditionComposite = ConditionComposite(target.getCondition());
            if(stateId == 1)
            {
               conditionComposite.init();
               target.setCondition(conditionComposite);
            }
            if((conditionsArray = conditionComposite.getConditionsArray()) == null || conditionsArray.length == 0)
            {
               max = target.getDef().getNumMinitargetsFound();
               for(i = 0; i < max; )
               {
                  condId = target.getDef().getMiniTargetTypes(i);
                  condition = this.getCondition(condId);
                  conditionComposite.addCondition(condition,i);
                  i++;
               }
               target.setCondition(conditionComposite);
            }
         }
      }
      
      public function addAchievement(sku:String) : void
      {
         if(this.mAchievements == null)
         {
            this.mAchievements = new Dictionary(true);
         }
         this.mAchievements[sku] = this.mAchievementIdx;
         this.mAchievementIdx++;
      }
      
      public function getAchievementId(sku:String) : String
      {
         var id:String = "";
         if(this.mAchievements != null && this.mAchievements[sku] != null)
         {
            id = String(this.mAchievements[sku].toString());
         }
         return id;
      }
   }
}
