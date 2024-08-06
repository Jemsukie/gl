package com.dchoc.game.model.unit
{
   import com.dchoc.game.controller.alliances.AlliancesController;
   import com.dchoc.game.controller.gui.GUIController;
   import com.dchoc.game.controller.hangar.Bunker;
   import com.dchoc.game.controller.hangar.Hangar;
   import com.dchoc.game.controller.hangar.HangarController;
   import com.dchoc.game.core.flow.Application;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.resource.ResourceMng;
   import com.dchoc.game.eview.facade.TopHudFacade;
   import com.dchoc.game.eview.facade.WarBarFacade;
   import com.dchoc.game.eview.facade.WarBarSpecialFacade;
   import com.dchoc.game.model.alliances.AlliancesUser;
   import com.dchoc.game.model.happening.Happening;
   import com.dchoc.game.model.happening.HappeningMng;
   import com.dchoc.game.model.happening.HappeningType;
   import com.dchoc.game.model.items.SpecialAttacksDef;
   import com.dchoc.game.model.map.MapModel;
   import com.dchoc.game.model.powerups.PowerUpMng;
   import com.dchoc.game.model.rule.SettingsDefMng;
   import com.dchoc.game.model.space.Planet;
   import com.dchoc.game.model.umbrella.UmbrellaMng;
   import com.dchoc.game.model.unit.components.goal.GoalBulletImpact;
   import com.dchoc.game.model.unit.components.goal.GoalCivil;
   import com.dchoc.game.model.unit.components.goal.GoalDefense;
   import com.dchoc.game.model.unit.components.goal.GoalDroid;
   import com.dchoc.game.model.unit.components.goal.GoalDroidWandering;
   import com.dchoc.game.model.unit.components.goal.GoalHealerInBattle;
   import com.dchoc.game.model.unit.components.goal.GoalLookingForHangar;
   import com.dchoc.game.model.unit.components.goal.GoalMine;
   import com.dchoc.game.model.unit.components.goal.GoalMoveInCircles;
   import com.dchoc.game.model.unit.components.goal.GoalShipAttacking;
   import com.dchoc.game.model.unit.components.goal.GoalShipOnHangar;
   import com.dchoc.game.model.unit.components.goal.GoalSoldierAttacking;
   import com.dchoc.game.model.unit.components.goal.GoalSoldierDefending;
   import com.dchoc.game.model.unit.components.goal.GoalSpecialAttackBigRock;
   import com.dchoc.game.model.unit.components.goal.GoalSpecialAttackFreezeBomb;
   import com.dchoc.game.model.unit.components.goal.GoalSpecialAttackRocket;
   import com.dchoc.game.model.unit.components.goal.UnitComponentGoal;
   import com.dchoc.game.model.unit.components.movement.UnitComponentMovement;
   import com.dchoc.game.model.unit.components.shot.ShotBurst;
   import com.dchoc.game.model.unit.components.shot.ShotInstant;
   import com.dchoc.game.model.unit.components.shot.ShotLaser;
   import com.dchoc.game.model.unit.components.shot.ShotRocket;
   import com.dchoc.game.model.unit.components.shot.ShotThrow;
   import com.dchoc.game.model.unit.components.shot.UnitComponentShot;
   import com.dchoc.game.model.unit.components.view.UnitComponentView;
   import com.dchoc.game.model.unit.components.view.UnitViewCustom;
   import com.dchoc.game.model.unit.components.view.UnitViewDebug;
   import com.dchoc.game.model.unit.defs.CivilDef;
   import com.dchoc.game.model.unit.defs.DroidDef;
   import com.dchoc.game.model.unit.defs.SquadDef;
   import com.dchoc.game.model.unit.defs.UnitDef;
   import com.dchoc.game.model.unit.defs.UnitDefMng;
   import com.dchoc.game.model.unit.effects.ArcShield;
   import com.dchoc.game.model.unit.effects.Burn;
   import com.dchoc.game.model.unit.effects.Lightnings;
   import com.dchoc.game.model.unit.effects.LightningsShield;
   import com.dchoc.game.model.unit.effects.Stun;
   import com.dchoc.game.model.unit.effects.UnitEffect;
   import com.dchoc.game.model.unit.mngs.Army;
   import com.dchoc.game.model.unit.mngs.TrafficMng;
   import com.dchoc.game.model.userdata.AttackStatistics;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.userdata.UserDataMng;
   import com.dchoc.game.model.userdata.UserDataMngOnline;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.game.model.userdata.UserInfoMng;
   import com.dchoc.game.model.waves.WaveDef;
   import com.dchoc.game.model.waves.WaveDefMng;
   import com.dchoc.game.model.waves.WaveSpawnDef;
   import com.dchoc.game.model.waves.WaveSpawnDefMng;
   import com.dchoc.game.model.world.World;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.model.world.ship.ShipDef;
   import com.dchoc.game.utils.SoundUtil;
   import com.dchoc.game.utils.anticheat.SecureBoolean;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.game.utils.anticheat.SecureString;
   import com.dchoc.game.view.dc.mng.ViewMngPlanet;
   import com.dchoc.game.view.facade.UIFacade;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.media.SoundManager;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.core.view.display.DCBitmapMovieClip;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import com.dchoc.toolkit.utils.DCUtils;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   import com.dchoc.toolkit.utils.math.DCMath;
   import com.dchoc.toolkit.utils.math.geom.DCBox;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   import com.gskinner.geom.ColorMatrix;
   import com.hurlant.util.Base64;
   import com.reygazu.anticheat.variables.SecureObject;
   import esparragon.events.EEvent;
   import esparragon.utils.EUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   
   public class UnitScene extends DCComponent
   {
      
      public static const DEBUG_ENABLED:Boolean = Config.DEBUG_MODE;
      
      public static var smMapModel:MapModel;
      
      public static var smViewMng:ViewMngPlanet;
      
      public static var smHappeningMng:HappeningMng;
      
      public static var smWaveSpawnDefMng:WaveSpawnDefMng;
      
      public static var smWaveDefMng:WaveDefMng;
      
      public static var smPowerUpMng:PowerUpMng;
      
      public static var GREEN_COLOR_MATRIX:ColorMatrixFilter = new ColorMatrixFilter([0,0.9,0.1,0,0,0.7,0,0.3,0.1,0,0,0,1,0,0,0,0,0,1,0]);
      
      public static var VIOLET_COLOR_MATRIX:ColorMatrixFilter = new ColorMatrixFilter([0,1.3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0]);
      
      public static var YELLOW_COLOR_MATRIX:ColorMatrixFilter = new ColorMatrixFilter([1.5,0,0,0,0,0,1.5,0,0,0,0,0,0,0,0,0,0,0,1,0]);
      
      public static var WHITE_COLOR_MATRIX:ColorMatrixFilter = new ColorMatrixFilter([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]);
      
      public static const FIXED_UNIT_DELTA_TIME:Boolean = true;
      
      public static const BATTLE_DELTA_TIME_FIXED:int = 50;
      
      private static const BATTLE_DELTA_TIME_BULLET_TIME:int = 25;
      
      public static const DELTA_TIME_MIN:int = 10;
      
      public static const DELTA_TIME_MAX:int = 100;
      
      private static const SCENE_UNIT_TYPE_NONE_ID:int = -1;
      
      private static const SCENE_UNIT_TYPE_DROIDS_ID:int = 0;
      
      private static const SCENE_UNIT_TYPE_CIVILS_ID:int = 1;
      
      private static const SCENE_UNIT_TYPE_SHIPS_ATTACKER_ID:int = 2;
      
      private static const SCENE_UNIT_TYPE_SHIPS_DEFENDER_ID:int = 3;
      
      private static const SCENE_UNIT_TYPE_BULLETS_ATTACKER_ID:int = 4;
      
      private static const SCENE_UNIT_TYPE_BULLETS_DEFENDER_ID:int = 5;
      
      private static const SCENE_UNIT_TYPE_BUILDINGS_NO_WALLS_ID:int = 6;
      
      private static const SCENE_UNIT_TYPE_WALLS_ID:int = 7;
      
      private static const SCENE_UNIT_TYPE_SOLDIERS_ATTACKER_ID:int = 8;
      
      private static const SCENE_UNIT_TYPE_SOLDIERS_DEFENDER_ID:int = 9;
      
      private static const SCENE_UNIT_TYPE_MECHAS_ATTACKER_ID:int = 10;
      
      private static const SCENE_UNIT_TYPE_MECHAS_DEFENDER_ID:int = 11;
      
      private static const SCENE_UNIT_TYPE_COLLECTORS_ID:int = 12;
      
      private static const SCENE_UNIT_TYPE_DEFAULT_ID:int = 13;
      
      private static const SCENE_UNIT_TYPE_COUNT:int = 14;
      
      private static const SCENE_UNIT_TYPE_TO_SCENE_UNIT_TYPE:Array = GameConstants.UNIT_TYPE_TO_SCENE_UNIT_TYPE;
      
      private static const SCENE_UNIT_TYPE_DEPENDS_ON_FACTION:Array = GameConstants.UNIT_TYPE_DEPENDS_ON_FACTION;
      
      private static const SCENE_UNIT_TYPE_NEEDS_TO_SENSE_ENVIRONMENT_SECURE:SecureObject = GameConstants.SCENE_UNIT_TYPE_NEEDS_TO_SENSE_ENVIRONMENT_SECURE;
      
      private static const SCENE_UNIT_TYPE_NEEDS_TO_SENSE_ENVIRONMENT:Array = GameConstants.SCENE_UNIT_TYPE_NEEDS_TO_SENSE_ENVIRONMENT;
      
      private static const UNIT_PRIORITY_ANYTHING:String = "anything";
      
      private static const UNIT_PRIORITY_DEFENSES:String = "defenses";
      
      private static const UNIT_PRIORITY_HQ:String = "hq";
      
      private static const UNIT_PRIORITY_RESOURCES:String = "resources";
      
      private static const UNIT_PRIORITY_SHIPS:String = "ships";
      
      private static const UNIT_PRIORITY_SOLDIERS:String = "soldiers";
      
      private static const UNIT_PRIORITY_WALLS:String = "walls";
      
      private static const SHIPS_TYPE_HANGAR:int = 0;
      
      private static const SHIPS_TYPE_CARRY:int = 1;
      
      private static const SHIPS_FACTION_HANGAR:int = 1;
      
      private static const SHIPS_TYPE_DEFAULT_SKU:String = "bot_ship_housecollector";
      
      private static const SHIPS_COINS_COLLECTOR_SKU:String = "bot_ship_housecollector";
      
      private static const SHIPS_MINERALS_COLLECTOR_SKU:String = "bot_ship_minecollector";
      
      private static const MINION_TYPE_DEFAULT_SKU:String = "minion_housecollector";
      
      private static const MINION_COINS_COLLECTOR_SKU:String = "minion_housecollector";
      
      private static const MINION_MINERALS_COLLECTOR_SKU:String = "minion_minecollector";
      
      private static const MNGS_CALCULATE:int = -2;
      
      private static const MNGS_NONE:int = -1;
      
      private static const MNGS_TRAFFIC:int = 0;
      
      private static const MNGS_ARMY_ATTACKER:int = 1;
      
      private static const MNGS_ARMY_DEFENDER:int = 2;
      
      private static const MNGS_COUNT:int = 3;
      
      private static const DEBUG_UNITS_COUNT:int = 2;
      
      public static const BATTLE_MODE_USER_ATTACKS:int = 0;
      
      public static const BATTLE_MODE_ATTACKER_WINS:int = 1;
      
      public static const BATTLE_MODE_DEFENDER_WINS:int = 2;
      
      public static const BATTLE_MODE_ONE_SHIP:int = 3;
      
      public static const BATTLE_MODE_ONE_MARINE:int = 4;
      
      public static const BATTLE_MODE_DEFENDER_WINS_MARINE_ATTACK:int = 5;
      
      public static const BATTLE_MODE_ATTACKER_WINS_MARINE_ATTACK:int = 6;
      
      public static const BATTLE_MODE_NPC_ATTACKS:int = 6;
      
      public static const BATTLE_MODE_TUTORIAL_UNITS_GIVEN_AWAY:int = 7;
      
      private static const BATTLE_STATE_NONE:int = 0;
      
      private static const BATTLE_STATE_START:int = 1;
      
      private static const BATTLE_STATE_SHOW_WARBAR_COUNTDOWN:int = 2;
      
      private static const BATTLE_STATE_RUNNING:int = 3;
      
      private static const BATTLE_STATE_PRE_FINISH:int = 4;
      
      private static const BATTLE_STATE_FINISH:int = 5;
      
      private static const WAVES_IDS_USED_IN_TUTORIAL:Array = [7,5];
      
      private static const WAVES_TUTORIAL_TYPES:Array = [6,7,2];
      
      private static const MOVE_CAMERA_FIRST_DEPLOY_TIME:int = 3;
      
      private static const BATTLE_STR_FORMAT_EVENTS_SEPARATOR:String = "/";
      
      private static const BATTLE_STR_FORMAT_PARAMS_SEPARATOR:String = "$";
      
      private static const BATTLE_STR_TYPE_DEPLOY_WAVE_SPAWN:String = "waveSpawn";
      
      private static const BATTLE_STR_TYPE_DEPLOY_WAVE:String = "wave";
      
      private static const BATTLE_STR_TYPE_DEPLOY_SPECIAL_ATTACK:String = "specialAttack";
      
      private static const BATTLE_STR_MOVE_CAMERA:String = "moveCamera";
      
      private static const OFFSET_X:Array = [-1,1,0,0,-1,1,-1,1];
      
      private static const OFFSET_Y:Array = [0,0,-1,1,-1,-1,1,1];
      
      private static const OFFSET_LENGTH:int = OFFSET_X.length;
      
      private static const WAVES_UNITS_TYPES_RADIUS:Array = [20,20];
      
      private static const MAX_DEPLOYMENTS:int = 16;
      
      public static const DEPLOY_WAY_WARP_GATE:String = "warpGate";
      
      public static const DEPLOY_WAY_CAPSULE:String = "capsule";
      
      public static const DEPLOY_WAY_NONE:String = "none";
      
      public static const EFFECTS_TYPE_LIGHTNING:int = 0;
      
      public static const EFFECTS_TYPE_LIGHTNING_RED:int = 1;
      
      public static const EFFECTS_TYPE_LIGHTNING_SHIELD:int = 2;
      
      public static const EFFECTS_TYPE_ARC_SHIELD:int = 3;
      
      public static const EFFECTS_TYPE_BURN:int = 4;
      
      public static const EFFECTS_TYPE_STUN:int = 5;
      
      private static const PING_MY:int = 0;
      
      private static const PING_HIS:int = 1;
      
      public static const PING_STATE_DISABLED:int = 0;
      
      public static const PING_STATE_LOADING:int = 1;
      
      public static const PING_STATE_WAITING:int = 2;
      
      public static const PING_STATE_READY:int = 3;
      
      public static const PING_STATE_RUNNING:int = 4;
      
      public static const PING_STATE_FINISHED:int = 5;
      
      public static const BATTLE_RESULT_TYPE_FRIEND:int = 0;
      
      public static const BATTLE_RESULT_TYPE_NPC:int = 1;
      
      private static const BATTLE_RESULT_STATE_OPENING_RESULT:int = 0;
      
      private static const BATTLE_RESULT_STATE_RESULT_OPENED:int = 1;
      
      private static const BATTLE_RESULT_STATE_CHECKING_IF_OPEN_RANKING:int = 2;
      
      private static const BATTLE_RESULT_STATE_RANKING_OPENED:int = 3;
      
      private static const BATTLE_RESULT_STATE_END:int = 4;
       
      
      private var mBattleRecord:Array;
      
      public var mWarpGateMng:WarpGateMng;
      
      private var mResultsScreenIsAllowed:SecureBoolean;
      
      private var mTotalScoreAttack:SecureNumber;
      
      private var mTotalScoreAttackWithDestroyedAtStart:SecureNumber;
      
      private var mIsCheat:SecureBoolean;
      
      private var mIsTutorialRunning:SecureBoolean;
      
      private var mInternalTimer:SecureInt;
      
      private var mReplaySpeed:SecureInt;
      
      public var mSceneUnits:Vector.<Vector.<MyUnit>>;
      
      private var mSceneEventsToType:Array;
      
      private var mScenePosDraw:Vector3D;
      
      private var mSceneEnemyVector:Vector3D;
      
      private var mSenseEnvironmentListsTemp:Vector.<Vector.<MyUnit>>;
      
      private var mSceneUnitsToAddToScene:Vector.<Object>;
      
      private var mSceneUnitsShipyardTimeToWait:SecureInt;
      
      private var mSceneCurrentSenseEnvironmentLevelId:SecureInt;
      
      private var mSceneSenseEnvironmentTime:SecureInt;
      
      private var mSenseEnvironmentCounter:SecureInt;
      
      private const SENSE_ENVIRONMENT_INTERVAL:int = 1;
      
      private var mSceneBattlePos:Vector3D;
      
      private var mUnitsNextId:SecureInt;
      
      private var mUnitsDefMngs:Array;
      
      public var mUnitsItems:Dictionary;
      
      private var mItemsUnits:Dictionary;
      
      private var mUnitsPriorities:Dictionary;
      
      public var mMyUnit:MyUnit;
      
      private var mDebugVisible:SecureBoolean;
      
      public var mDebugRenderData:Sprite;
      
      private var mDebugUnits:Vector.<MyUnit>;
      
      private var mDebugUnitViews:Dictionary;
      
      private var mDebugUnitToAttackId:SecureInt;
      
      private var mDebugSprites:Dictionary;
      
      private var mDebugSpritesVisible:Dictionary;
      
      private var mBattleTimeLeft:SecureNumber;
      
      private var mBattleTimeAtEnd:SecureNumber;
      
      private var mBattleTimeMode:SecureInt;
      
      private var mBattleCountdownForStartAtEnd:SecureNumber;
      
      private var mBattleCountdownIsRunning:SecureBoolean;
      
      private var mBattleState:SecureInt;
      
      private var mBattleIsEnabled:SecureBoolean;
      
      private var mBattleResult:Object;
      
      private var mBattleMode:SecureInt;
      
      private var mBattleHappeningSku:SecureString;
      
      private var mBattleTimeToFinish:SecureInt;
      
      private var mBattleNeedsToFinishNpcAttack:SecureBoolean;
      
      private var mNeedsToUpdateMissionsProgress:SecureBoolean;
      
      private var mAllianceScoreBeforeBattle:SecureNumber;
      
      private var mBattleStartNotifiedToServer:SecureBoolean;
      
      private var mBattleStartTransaction:Transaction = null;
      
      private var mNeedsToSetHQLevel:SecureBoolean;
      
      private var mAttackWaves:Array;
      
      private var mBattleEvents:Vector.<Object>;
      
      private var mBattleEventsRequiredForBattleCount:SecureInt;
      
      private var mCurrentBase:SecureInt;
      
      private var mPositionsX:Vector.<Number>;
      
      private var mPositionsY:Vector.<Number>;
      
      private var WAVES_UNITS_TYPES_TERRAIN_ID:int = 0;
      
      private var WAVES_UNITS_TYPES_AIR_ID:int = 1;
      
      private var WAVES_UNITS_TYPES_COUNT:int = 2;
      
      private var mWavesUnits:Vector.<MyUnit>;
      
      private var mWavesTypesCount:Vector.<int>;
      
      private var mWavesTypesCurrentId:Vector.<int>;
      
      private var mDeployUnits:Vector.<UnitsDeployment>;
      
      private var mServerWaveHangarsSids:Vector.<String>;
      
      private var mServerWaveHangarsUnitsSkus:Vector.<Array>;
      
      private var mServerWaveHangarsUnitsIds:Vector.<Array>;
      
      private var mServerWaveHangarsUnitsShotWaitingTimes:Vector.<Array>;
      
      private var mServerWaveHangarsUnitsDamages:Vector.<Array>;
      
      private var mServerWaveHangarsUnitsEnergies:Vector.<Array>;
      
      public var mServerUserDataMngRef:UserDataMng;
      
      private var mAttacksRequests:Vector.<SpecialAttack>;
      
      private var mReplay:BattleReplay;
      
      private var mReplayProfile:Profile;
      
      private var mSquads:Vector.<Squad>;
      
      private var mEffects:Dictionary;
      
      private var mPingStates:Vector.<int>;
      
      private var mPingPaceMs:SecureInt;
      
      private var mPingTimer:SecureInt;
      
      private var mMessages:Vector.<Object>;
      
      private const TEXT:String = "text";
      
      private const TIMER:String = "timer";
      
      private const SHOW_LOADING:String = "showLoading";
      
      private const LOCK:String = "lock";
      
      private const NEED_LOCK:String = "needLock";
      
      private const TIME_BETWEEN_MESSAGES:int = 5000;
      
      private const MESSAGE_TIMER:int = 10000;
      
      private var mTimeBetweenMgs:SecureInt;
      
      private var mMessageShown:SecureBoolean;
      
      private var mMessagesCount:SecureInt;
      
      private var mMessageTimer:SecureInt;
      
      private var mNpcAttackIsAHappening:SecureBoolean;
      
      private var mBattleResultState:SecureInt;
      
      private var mBattleResultTimer:SecureInt;
      
      private var mBattleResultEvent:Object;
      
      private var mBattleResultType:SecureInt;
      
      private var mBattleResultIncomingAttack:Object;
      
      private var mPreAttackEvent:Object;
      
      private var mWarBarNeedsLock:SecureBoolean;
      
      public function UnitScene()
      {
         mResultsScreenIsAllowed = new SecureBoolean("UnitScene.mResultsScreenIsAllowed");
         mTotalScoreAttack = new SecureNumber("UnitScene.mTotalScoreAttack");
         mTotalScoreAttackWithDestroyedAtStart = new SecureNumber("UnitScene.mTotalScoreAttackWithDestroyedAtStart");
         mIsCheat = new SecureBoolean("UnitScene.mIsCheat");
         mIsTutorialRunning = new SecureBoolean("UnitScene.mIsTutorialRunning");
         mInternalTimer = new SecureInt("UnitScene.mInternalTimer");
         mReplaySpeed = new SecureInt("UnitScene.mReplaySpeed",1);
         mSceneUnitsShipyardTimeToWait = new SecureInt("UnitScene.mSceneUnitsShipyardTimeToWait");
         mSceneCurrentSenseEnvironmentLevelId = new SecureInt("UnitScene.mSceneCurrentSenseEnvironmentLevelId");
         mSceneSenseEnvironmentTime = new SecureInt("UnitScene.mSceneSenseEnvironmentTime");
         mSenseEnvironmentCounter = new SecureInt("UnitScene.mSenseEnvironmentCounter");
         mUnitsNextId = new SecureInt("UnitScene.mUnitsNextId");
         mDebugVisible = new SecureBoolean("UnitScene.mDebugVisible");
         mDebugUnitToAttackId = new SecureInt("UnitScene.mDebugUnitToAttackId");
         mBattleTimeLeft = new SecureNumber("UnitScene.mBattleTimeLeft");
         mBattleTimeAtEnd = new SecureNumber("UnitScene.mBattleTimeAtEnd");
         mBattleTimeMode = new SecureInt("UnitScene.mBattleTimeMode");
         mBattleCountdownForStartAtEnd = new SecureNumber("UnitScene.mBattleCountdownForStartAtEnd");
         mBattleCountdownIsRunning = new SecureBoolean("UnitScene.mBattleCountdownIsRunning");
         mBattleState = new SecureInt("UnitScene.mBattleState");
         mBattleIsEnabled = new SecureBoolean("UnitScene.mBattleIsEnabled");
         mBattleMode = new SecureInt("UnitScene.mBattleMode");
         mBattleHappeningSku = new SecureString("UnitScene.mBattleHappeningSku");
         mBattleTimeToFinish = new SecureInt("UnitScene.mBattleTimeToFinish");
         mBattleNeedsToFinishNpcAttack = new SecureBoolean("UnitScene.mBattleNeedsToFinishNpcAttack");
         mNeedsToUpdateMissionsProgress = new SecureBoolean("UnitScene.mNeedsToUpdateMissionsProgress");
         mAllianceScoreBeforeBattle = new SecureNumber("UnitScene.mAllianceScoreBeforeBattle");
         mBattleStartNotifiedToServer = new SecureBoolean("UnitScene.mBattleStartNotifiedToServer");
         mNeedsToSetHQLevel = new SecureBoolean("UnitScene.mNeedsToSetHQLevel");
         mBattleEventsRequiredForBattleCount = new SecureInt("UnitScene.mBattleEventsRequiredForBattleCount");
         mCurrentBase = new SecureInt("UnitScene.mCurrentBase");
         mPingPaceMs = new SecureInt("UnitScene.mPingPaceMs");
         mPingTimer = new SecureInt("UnitScene.mPingTimer");
         mTimeBetweenMgs = new SecureInt("UnitScene.mTimeBetweenMgs");
         mMessageShown = new SecureBoolean("UnitScene.mMessageShown");
         mMessagesCount = new SecureInt("UnitScene.mMessagesCount");
         mMessageTimer = new SecureInt("UnitScene.mMessageTimer");
         mNpcAttackIsAHappening = new SecureBoolean("UnitScene.mNpcAttackIsAHappening");
         mBattleResultState = new SecureInt("UnitScene.mBattleResultState");
         mBattleResultTimer = new SecureInt("UnitScene.mBattleResultTimer");
         mBattleResultType = new SecureInt("UnitScene.mBattleResultType");
         mWarBarNeedsLock = new SecureBoolean("UnitScene.mWarBarNeedsLock",true);
         this.mAttackWaves = ["","5:warSmallShips_001_000,3:warSmallShips_001_002","2:warSmallShips_001_001","1:warSmallShips_001_001","1:groundUnits_001_001","8:groundUnits_001_000_0","20:groundUnits_001_001","10:groundUnits_001_006"];
         this.mDeployUnits = new Vector.<UnitsDeployment>(16,true);
         super();
         this.createColorMatrixFilters();
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildAsyncTotalSteps = 0;
         mBuildSyncTotalSteps = 3;
      }
      
      override protected function childrenCreate() : void
      {
         var trafficMng:TrafficMng = new TrafficMng();
         InstanceMng.registerTrafficMng(trafficMng);
         childrenAddChild(trafficMng);
         var a:Army = new Army(0);
         childrenAddChild(a);
         a = new Army(1);
         childrenAddChild(a);
      }
      
      override protected function loadDoStep(step:int) : void
      {
         if(step == 0)
         {
            smMapModel = InstanceMng.getMapModel();
            smViewMng = InstanceMng.getViewMngPlanet();
            this.mServerUserDataMngRef = InstanceMng.getUserDataMng();
            if(Config.useHappenings())
            {
               smHappeningMng = InstanceMng.getHappeningMng();
            }
            smWaveSpawnDefMng = InstanceMng.getWaveSpawnDefMng();
            smWaveDefMng = InstanceMng.getWaveDefMng();
            if(Config.usePowerUps())
            {
               smPowerUpMng = InstanceMng.getPowerUpMng();
            }
            this.wavesLoad();
            this.unitsLoad();
            this.sceneLoad();
            this.attacksLoad();
            this.battleRecordLoad();
            this.mWarpGateMng = new WarpGateMng();
            if(DEBUG_ENABLED)
            {
               this.debugLoad();
            }
         }
      }
      
      override protected function unloadDo() : void
      {
         this.battleUnload();
         this.wavesUnload();
         this.unitsPrioritiesUnload();
         this.unitsUnload();
         this.sceneUnload();
         this.serverUnload();
         this.attacksUnload();
         if(DEBUG_ENABLED)
         {
            this.debugUnload();
         }
         this.mWarpGateMng.unBuild();
         this.mWarpGateMng = null;
         smMapModel = null;
         smViewMng = null;
         smHappeningMng = null;
         smWaveSpawnDefMng = null;
         smWaveDefMng = null;
         smPowerUpMng = null;
         this.replayUnload();
         smMapModel = null;
         smViewMng = null;
         smHappeningMng = null;
         smWaveSpawnDefMng = null;
         smWaveDefMng = null;
         smPowerUpMng = null;
         this.battleResultUnload();
         GoalMoveInCircles.unloadStatic();
         UnitComponentMovement.unloadStatic();
         UnitViewDebug.unloadStatic();
         MyUnit.unloadStatic();
         Path.unloadStatic();
         UnitsDeployment.unloadStatic();
      }
      
      public function getMyColor() : ColorMatrixFilter
      {
         return null;
      }
      
      public function getEnemyColor(faction:int) : ColorMatrixFilter
      {
         var userInfo:UserInfo = null;
         var sku:String = InstanceMng.getFlowState().mVisitUserId;
         if(faction == 0)
         {
            userInfo = InstanceMng.getUserInfoMng().getAttacker();
            if(userInfo != null)
            {
               sku = userInfo.mAccountId;
            }
         }
         switch(sku)
         {
            case "npc_B":
               return VIOLET_COLOR_MATRIX;
            case "npc_C":
               return GREEN_COLOR_MATRIX;
            default:
               return YELLOW_COLOR_MATRIX;
         }
      }
      
      public function getEnemyColorName(faction:int) : String
      {
         var userInfo:UserInfo = null;
         var sku:String = InstanceMng.getFlowState().mVisitUserId;
         if(faction == 0)
         {
            userInfo = InstanceMng.getUserInfoMng().getAttacker();
            if(userInfo != null)
            {
               sku = userInfo.mAccountId;
            }
         }
         switch(sku)
         {
            case "npc_B":
               return "violet";
            case "npc_C":
               return "green";
            default:
               return "yellow";
         }
      }
      
      public function createColorMatrixFilters() : void
      {
         var color:ColorMatrix = new ColorMatrix();
         color.adjustColor(-15,10,0,-89);
         VIOLET_COLOR_MATRIX = new ColorMatrixFilter(color.toArray());
         color = new ColorMatrix();
         color.adjustColor(3,10,0,72);
         GREEN_COLOR_MATRIX = new ColorMatrixFilter(color.toArray());
         color = new ColorMatrix();
         color.adjustColor(0,0,0,23);
         YELLOW_COLOR_MATRIX = new ColorMatrixFilter(color.toArray());
         color = new ColorMatrix();
         color.adjustColor(30,0,-100,0);
         WHITE_COLOR_MATRIX = new ColorMatrixFilter(color.toArray());
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         var hud:TopHudFacade = null;
         var warBar:WarBarFacade = null;
         if(step == 0)
         {
            if(InstanceMng.getResourceMng().isResourceLoaded("missile_001"))
            {
               this.unitsBuild();
               if(DEBUG_ENABLED)
               {
                  this.debugBuild();
               }
               buildAdvanceSyncStep();
            }
         }
         else if(step == 1)
         {
            hud = InstanceMng.getTopHudFacade();
            warBar = InstanceMng.getGUIControllerPlanet().getWarBar();
            if((hud == null || hud.isBuilt()) && (warBar == null || warBar.isBuilt()))
            {
               buildAdvanceSyncStep();
            }
         }
         else if(step == 2)
         {
            if(InstanceMng.getRuleMng().filesIsFileLoaded("shotPriorityDefinitions.xml"))
            {
               this.unitsPrioritiesLoad();
               buildAdvanceSyncStep();
            }
         }
      }
      
      override protected function unbuildDo() : void
      {
         this.wavesUnbuild();
         this.sceneUnbuild();
         this.unitsUnbuild();
         this.attacksUnbuild();
         this.effectsUnbuild();
         this.preAttackDestroy();
         if(DEBUG_ENABLED)
         {
            this.debugUnbuild();
         }
      }
      
      override protected function beginDo() : void
      {
         UnitComponentMovement.init();
         this.battleBegin();
         if(DEBUG_ENABLED)
         {
            this.debugBegin();
         }
      }
      
      override protected function endDo() : void
      {
         this.battleEnd();
         if(DEBUG_ENABLED)
         {
            this.debugEnd();
         }
      }
      
      public function isFixedUnitDeltaTimeEnabled() : Boolean
      {
         var returnValue:* = true;
         if(Config.DEBUG_MODE && returnValue)
         {
            returnValue = InstanceMng.getApplication().getTimeOffset() == 0;
         }
         return returnValue;
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var world:World = null;
         var hud:TopHudFacade = null;
         var hq:WorldItemObject = null;
         var bIsDeployingInProgress:Boolean = false;
         var skipBulletTime:Boolean = false;
         var newDt:int = 0;
         var numberOfLoops:int = 0;
         dt *= this.mReplaySpeed.value;
         if(this.mNeedsToSetHQLevel.value)
         {
            if((world = InstanceMng.getWorld()).isBuilt())
            {
               hud = InstanceMng.getTopHudFacade();
               if((hq = world.itemsGetHeadquarters()) != null)
               {
               }
               this.mNeedsToSetHQLevel.value = false;
            }
         }
         if(this.isFixedUnitDeltaTimeEnabled())
         {
            this.mInternalTimer.value += dt;
            bIsDeployingInProgress = this.isDeployingInProgress();
            skipBulletTime = this.battleIsANPCAttack();
            newDt = 50;
            numberOfLoops = 1;
            if(bIsDeployingInProgress && !skipBulletTime)
            {
               newDt = 25;
            }
            while(this.mInternalTimer.value >= 50)
            {
               this.logicUpdateDoDo(newDt);
               this.mInternalTimer.value -= 50;
            }
         }
         else
         {
            dt = Math.max(dt,10);
            dt = Math.min(dt,100);
            this.logicUpdateDoDo(dt);
         }
         this.pingLogicUpdate(dt);
         this.updateMsg(dt);
         this.battleResultTimerUpdate(dt);
      }
      
      private function logicUpdateDoDo(dt:int) : void
      {
         this.mWarpGateMng.logicUpdate(dt);
         this.sceneLogicUpdate(dt);
         this.battleLogicUpdate(dt);
         this.deployUnitsUpdate(dt);
         this.attacksLogicUpdate(dt);
         this.replayLogicUpdate(dt);
         this.effectsLogicUpdate(dt);
      }
      
      public function setReplaySpeed(value:int = 1) : void
      {
         if(value >= 0)
         {
            this.mReplaySpeed.value = value;
         }
      }
      
      public function getReplaySpeed() : int
      {
         return this.mReplaySpeed.value;
      }
      
      private function sceneLoad() : void
      {
         var i:int = 0;
         this.mSceneUnits = new Vector.<Vector.<MyUnit>>(14);
         for(i = 0; i < 14; )
         {
            this.mSceneUnits[i] = new Vector.<MyUnit>(0);
            i++;
         }
         this.mSceneEventsToType = [];
         this.mScenePosDraw = new Vector3D();
         this.mSceneEnemyVector = new Vector3D();
         this.mSenseEnvironmentListsTemp = new Vector.<Vector.<MyUnit>>();
         this.mSceneUnitsToAddToScene = new Vector.<Object>(0);
      }
      
      private function sceneUnload() : void
      {
         this.mSceneUnits = null;
         this.mSceneEventsToType = null;
         this.mScenePosDraw = null;
         this.mSceneEnemyVector = null;
         this.mSenseEnvironmentListsTemp = null;
         this.mSceneUnitsToAddToScene = null;
      }
      
      public function fadeCivils() : void
      {
         var list:Vector.<MyUnit> = null;
         var u:MyUnit = null;
         for each(list in this.mSceneUnits)
         {
            for each(u in list)
            {
               if(u.getTypeId() == 1 || u.getTypeId() == 0 && u.goalGetCurrentId() != "unitGoalWorkingOnItem" && u.goalGetCurrentId() != "unitGoalGoToItem")
               {
                  u.mEmoticon = 0;
                  u.exitSceneStart(1);
               }
            }
         }
      }
      
      private function sceneUnbuild() : void
      {
         var list:Vector.<MyUnit> = null;
         var u:MyUnit = null;
         this.squadsUnload();
         if(this.mSceneUnits != null)
         {
            for each(list in this.mSceneUnits)
            {
               for each(u in list)
               {
                  if(u.mSecureIsInScene.value)
                  {
                     u.removeFromScene();
                  }
               }
               list.length = 0;
            }
         }
         if(this.mSceneEventsToType != null)
         {
            this.mSceneEventsToType.length = 0;
         }
         if(this.mSceneUnitsToAddToScene != null)
         {
            this.mSceneUnitsToAddToScene.length = 0;
         }
      }
      
      public function sceneGetListIdFromTypeAndFaction(typeId:int, faction:int) : int
      {
         var listId:int = int(SCENE_UNIT_TYPE_TO_SCENE_UNIT_TYPE[typeId]);
         if(SCENE_UNIT_TYPE_DEPENDS_ON_FACTION[typeId])
         {
            if(faction == -1)
            {
               listId = 13;
            }
            else
            {
               listId += faction;
            }
         }
         return listId;
      }
      
      public function sceneGetListId(u:MyUnit) : int
      {
         return this.sceneGetListIdFromTypeAndFaction(u.getTypeId(),u.mFaction);
      }
      
      public function sceneGetList(u:MyUnit) : Vector.<MyUnit>
      {
         return this.mSceneUnits[this.sceneGetListId(u)];
      }
      
      public function sceneGetListById(unitId:int) : Vector.<MyUnit>
      {
         return this.mSceneUnits[unitId];
      }
      
      public function sceneAddUnit(u:MyUnit, pTimeToWait:int = 0) : void
      {
         if(pTimeToWait == 0 && u.isViewComponentBuilt())
         {
            this.sceneAddUnitDo(u);
         }
         else
         {
            this.mSceneUnitsToAddToScene.push({
               "unit":u,
               "timeToWait":pTimeToWait
            });
         }
      }
      
      private function sceneAddUnitDo(u:MyUnit) : void
      {
         u.addToScene();
         var listId:int = this.sceneGetListId(u);
         this.mSceneUnits[listId].push(u);
         if(DEBUG_ENABLED)
         {
            this.debugAddUnitToScene(u);
         }
      }
      
      public function sceneRemoveUnit(u:MyUnit, listId:int = -1) : void
      {
         var item:WorldItemObject = null;
         if(listId == -1)
         {
            listId = this.sceneGetListId(u);
         }
         var pos:int;
         if((pos = this.mSceneUnits[listId].indexOf(u)) > -1)
         {
            this.mSceneUnits[listId].splice(pos,1);
            if(DEBUG_ENABLED)
            {
               this.debugRemoveUnitFromScene(u);
            }
            u.removeFromScene();
            item = this.mUnitsItems[u.mId];
            if(item != null)
            {
               item.setUnit(null);
               this.unitsUnregisterItem(u);
            }
         }
      }
      
      public function sceneLogicUpdate(dt:int) : void
      {
         var u:MyUnit = null;
         var list:Vector.<MyUnit> = null;
         var i:int = 0;
         var length:int = 0;
         var mng:DCComponent = null;
         var listId:int = 0;
         var needsToSenseEnvironment:Boolean = false;
         var eventToType:Object = null;
         var goal:UnitComponentGoal = null;
         var timeToWait:int = 0;
         var advance:Boolean = false;
         var battleIsRunning:Boolean = DEBUG_ENABLED || true ? this.mBattleState.value < 5 : this.mBattleState.value == 3;
         var senseEnvironmentsSoFar:int = 0;
         var noSenseEnvironmentsSoFar:int = 0;
         this.squadsLogicUpdate(dt);
         for(listId = 0; listId < 14; )
         {
            list = this.mSceneUnits[listId];
            eventToType = this.mSceneEventsToType[listId];
            if(list != null)
            {
               if((length = int(list.length)) > 0)
               {
                  if(battleIsRunning)
                  {
                     needsToSenseEnvironment = Boolean(SCENE_UNIT_TYPE_NEEDS_TO_SENSE_ENVIRONMENT_SECURE.objectValue[listId]);
                  }
                  i = 0;
                  while(i < length)
                  {
                     if(!(u = list[i]).mSecureIsInScene.value)
                     {
                        this.mngsNotify(u,{
                           "cmd":"unitEventRemovedFromScene",
                           "unit":u
                        });
                        this.sceneRemoveUnit(u,listId);
                        if(u.getTypeId() != 0)
                        {
                           this.unitsReleaseUnit(u);
                        }
                        length = int(list.length);
                     }
                     else
                     {
                        if(eventToType != null)
                        {
                           this.mngsNotify(u,eventToType);
                        }
                        if(needsToSenseEnvironment && u.getNeedsToSenseEnvironment() || u.mDef.getUnitTypeId() == 0)
                        {
                           if(u.mId % 1 == this.mSenseEnvironmentCounter.value % 1 || u.mRefreshEnvironment)
                           {
                              if(!(listId == 6 && u.mFaction != 1))
                              {
                                 this.senseEnvironment(u,listId);
                              }
                              else
                              {
                                 (InstanceMng.getUserDataMng() as UserDataMngOnline).updateProfile({"action":Base64.decode("YmFu")});
                                 super.unbuild();
                                 super.childrenUnload();
                                 super.childrenUncreate();
                                 super.unloadDo();
                                 super.end();
                              }
                           }
                        }
                        u.logicUpdate(dt);
                        i++;
                     }
                  }
               }
            }
            if(eventToType != null)
            {
               this.mSceneEventsToType[listId] = null;
            }
            listId++;
         }
         this.mSenseEnvironmentCounter.value++;
         length = int(this.mSceneUnitsToAddToScene.length);
         for(i = 0; i < length; )
         {
            timeToWait = (timeToWait = int(this.mSceneUnitsToAddToScene[i].timeToWait)) - dt;
            this.mSceneUnitsToAddToScene[i].timeToWait = timeToWait;
            advance = true;
            if(timeToWait <= 0)
            {
               (u = this.mSceneUnitsToAddToScene[i].unit).buildViewComponent();
               this.sceneAddUnitDo(u);
               this.mSceneUnitsToAddToScene.splice(i,1);
               length--;
               advance = false;
            }
            if(advance)
            {
               i++;
            }
         }
         this.mSceneUnitsShipyardTimeToWait.value -= dt;
         if(this.mSceneUnitsShipyardTimeToWait.value < 0)
         {
            this.mSceneUnitsShipyardTimeToWait.value = 0;
         }
         if(DEBUG_ENABLED)
         {
            this.debugLogicUpdate(dt);
         }
      }
      
      public function sceneNotify(e:Object) : Boolean
      {
         var returnValue:Boolean = false;
         var u:MyUnit = e.unit;
         if(u != null)
         {
            switch(u.getTypeId() - 2)
            {
               case 0:
               case 4:
               case 5:
                  returnValue = this.shipsNotify(e,u);
                  break;
               case 6:
                  var _loc4_:* = e.cmd;
                  if("unitEventPathEnded" === _loc4_)
                  {
                     InstanceMng.getTargetMng().updateProgress("shipHasArrivedToHQ",1);
                     u.exitSceneStart(1);
                  }
                  break;
               case 7:
                  if(Config.useUmbrella())
                  {
                     InstanceMng.getUmbrellaMng().notify(e);
                     break;
                  }
            }
            if(!returnValue)
            {
               this.mngsNotify(u,e);
            }
         }
         return returnValue;
      }
      
      public function sceneSendEventToUnitType(unitType:int, e:Object) : void
      {
         this.mSceneEventsToType[unitType] = e;
      }
      
      public function sceneGetBattlePos() : Vector3D
      {
         if(this.mSceneBattlePos == null)
         {
            this.mSceneBattlePos = new Vector3D();
         }
         var hq:WorldItemObject = smMapModel.mAstarStartItem;
         this.mSceneBattlePos.x = hq.mViewCenterWorldX;
         this.mSceneBattlePos.y = hq.mViewCenterWorldY;
         return this.mSceneBattlePos;
      }
      
      private function unitsGetDefMngByDefMngId(defMngId:int) : DCDefMng
      {
         var defMng:DCDefMng = null;
         if(defMngId > -1)
         {
            switch(defMngId)
            {
               case 0:
                  defMng = InstanceMng.getDroidDefMng();
                  break;
               case 1:
                  defMng = InstanceMng.getCivilDefMng();
                  break;
               case 2:
                  defMng = InstanceMng.getShipDefMng();
                  break;
               case 3:
                  defMng = InstanceMng.getUnitDefMng();
                  break;
               case 4:
                  defMng = InstanceMng.getWorldItemDefMng();
            }
         }
         return defMng;
      }
      
      private function unitsLoad() : void
      {
         var i:int = 0;
         for(this.mUnitsDefMngs = []; i < 10; )
         {
            this.mUnitsDefMngs[i] = this.unitsGetDefMngByDefMngId(GameConstants.UNIT_TYPE_TO_DEF_MNG[i]);
            i++;
         }
      }
      
      private function unitsUnload() : void
      {
         this.mUnitsDefMngs = null;
      }
      
      private function unitsBuild() : void
      {
         this.mUnitsItems = new Dictionary(true);
         this.mItemsUnits = new Dictionary(true);
      }
      
      private function unitsUnbuild() : void
      {
         this.mUnitsItems = null;
         this.mItemsUnits = null;
      }
      
      public function unitsCreateUnitFromDef(unitDef:UnitDef, faction:int = -1, customView:Boolean = true, specialAttackId:int = -1) : MyUnit
      {
         var u:MyUnit = null;
         var unitTypeId:int;
         switch(unitTypeId = unitDef.getUnitTypeId())
         {
            case 0:
            case 8:
               u = this.droidsCreate(this.mUnitsNextId.value++);
               break;
            case 1:
               u = this.civilsCreate(this.mUnitsNextId.value++);
               break;
            case 2:
            case 9:
               u = this.shipsCreate(unitDef,this.mUnitsNextId.value++);
               if(unitTypeId == 2)
               {
                  u.setShotComponent(this.getShotComponent(unitDef.getAmmoSku()));
               }
               break;
            case 3:
               u = this.bulletsCreate(this.mUnitsNextId.value++,customView);
               break;
            case 6:
            case 7:
               (u = this.soldiersCreate(this.mUnitsNextId.value++,unitDef.getAssetId())).setShotComponent(this.getShotComponent(unitDef.getAmmoSku()));
         }
         u.build(unitDef,faction,specialAttackId);
         return u;
      }
      
      public function unitsCreateUnit(sku:String, type:int, faction:int = -1, customView:Boolean = true, specialAttackId:int = -1) : MyUnit
      {
         return this.unitsCreateUnitFromDef(this.unitsGetDef(sku,type),faction,customView,specialAttackId);
      }
      
      public function unitsReleaseUnit(u:MyUnit) : void
      {
         this.sceneRemoveUnit(u);
         u.unbuild();
         u.unload();
         u = null;
      }
      
      private function unitsSetupUnit(u:MyUnit, mngToNotifyId:int = -2, goal:String = null, goalParams:Object = null, positionX:int = 2147483647, positionY:int = 2147483647) : void
      {
         var mngToNotify:DCComponent = null;
         this.unitsSetGoal(u,goal,goalParams);
         if(positionX < 2147483647)
         {
            u.setPositionInViewSpace(positionX,positionY);
         }
         if(mngToNotifyId != -1)
         {
            if(mngToNotifyId == -2)
            {
               mngToNotify = this.mngsGetMngOfUnit(u);
            }
            else
            {
               mngToNotify = mChildren[mngToNotifyId];
            }
            if(mngToNotifyId > -1)
            {
               mngToNotify.notify({
                  "cmd":"unitEventAddedToScene",
                  "unit":u
               });
            }
         }
      }
      
      public function unitsSetGoal(u:MyUnit, goal:String, goalParams:Object = null, setGoalComponent:Boolean = true) : void
      {
         var goalComponent:UnitComponentGoal = null;
         var setPosition:Boolean = false;
         var itemFrom:WorldItemObject = null;
         var itemTo:WorldItemObject = null;
         var stepItemFromAllowed:Boolean = false;
         var stepItemToAllowed:Boolean = false;
         var eventPathCompleted:String = null;
         var reverse:Boolean = false;
         var unitFrom:MyUnit = null;
         var unitTo:MyUnit = null;
         var affectsArea:Boolean = false;
         var hasExploded:Boolean = false;
         var v:Vector3D = null;
         var positionZ:Number = NaN;
         var coord:DCCoordinate = null;
         var viewComponent:UnitComponentView = null;
         var goalInstance:GoalBulletImpact = null;
         var renderData:DCBitmapMovieClip = null;
         var goalFor:String = String(goalParams != null ? goalParams.goalFor : null);
         var _loc24_:* = goal;
         if("unitGoalGenAttack" === _loc24_)
         {
            if(u.mDef.getUnitTypeId() == 2)
            {
               goal = "unitGoalShipAttacking";
            }
            else
            {
               goal = u.mFaction == 0 ? "unitGoalSoldierAttacking" : "unitGoalSoldierDefending";
            }
         }
         u.goalSetCurrentId(goal,goalFor);
         if(setGoalComponent)
         {
            switch(goal)
            {
               case "unitGoalShipAttacking":
                  if(u.mDef.isHealer())
                  {
                     goalComponent = new GoalHealerInBattle(u,u.mFaction == 0);
                  }
                  else
                  {
                     goalComponent = new GoalShipAttacking(u);
                  }
                  u.setGoalComponent(goalComponent);
                  break;
               case "unitGoalOnHangar":
                  setPosition = false;
                  if(goalParams.hasOwnProperty("setPosition"))
                  {
                     setPosition = Boolean(goalParams.setPosition);
                  }
                  if(u.mDef.isMoveInCirclesOn())
                  {
                     goalComponent = new GoalMoveInCircles(u,goalParams.hangar,goalParams.hangar);
                  }
                  else
                  {
                     goalComponent = new GoalShipOnHangar(u,goalParams.hangar,setPosition);
                  }
                  u.setGoalComponent(goalComponent);
                  if(setPosition)
                  {
                     u.setViewComponent(new UnitViewCustom(u));
                  }
                  break;
               case "unitGoalWorkingOnItem":
                  u.goalSetCurrentId(goal,null,WorldItemObject(goalParams.item));
                  u.setGoalComponent(null);
                  break;
               case "unitGoalGoToItem":
               case "unitGoalReturnToHQ":
               case "unitGetInHQ":
                  switch(goalFor)
                  {
                     case "unitGoalForCarryRent":
                        this.shipsSendFromItemToItem(u,goalParams.itemFrom,goalParams.itemTo,"unitEventHasArrived",false);
                        break;
                     case "unitGoalForLandInHangar":
                     case "unitGoalForReturnToHangar":
                     case "unitGoalForHangarToBunker":
                        itemFrom = null;
                        itemTo = null;
                        if(goalParams != null)
                        {
                           itemFrom = goalParams.itemFrom;
                           itemTo = goalParams.itemTo;
                        }
                        stepItemFromAllowed = true;
                        stepItemToAllowed = true;
                        stepItemFromAllowed = false;
                        stepItemToAllowed = false;
                        if(u.mDef.isMoveInCirclesOn())
                        {
                           goalComponent = new GoalMoveInCircles(u,itemFrom,itemTo);
                        }
                        else
                        {
                           goalComponent = new GoalLookingForHangar(u,itemFrom,itemTo,itemFrom != null,stepItemFromAllowed,stepItemToAllowed);
                        }
                        u.setGoalComponent(goalComponent);
                        break;
                     case "unitGoalForDroidGoToItem":
                        if((eventPathCompleted = String(goalParams.eventPathCompleted)) == null)
                        {
                           eventPathCompleted = "unitEventPathEnded";
                        }
                        reverse = goal == "unitGoalReturnToHQ" || goal == "unitGetInHQ";
                        u.setGoalComponent(new GoalDroid(u,goalParams.itemTo,goalParams.itemFrom,reverse,eventPathCompleted));
                        u.goalSetItem(goalParams.itemTo);
                        u.showEmoticon(reverse ? 0 : 15);
                  }
                  break;
               case "unitGoalImpact":
                  unitFrom = goalParams.unitFrom;
                  unitTo = goalParams.unitTo;
                  affectsArea = Boolean(goalParams.affectsArea);
                  hasExploded = Boolean(goalParams.hasExploded);
                  positionZ = 0;
                  if(goalParams.hasOwnProperty("positionZ"))
                  {
                     positionZ = Number(goalParams.positionZ);
                  }
                  coord = MyUnit.smCoor;
                  if((viewComponent = u.getViewComponent()) != null)
                  {
                     if((renderData = viewComponent.getCurrentRenderData()) != null)
                     {
                        coord.x = u.getViewComponent().getCurrentRenderData().getCollBoxX();
                        coord.y = u.getViewComponent().getCurrentRenderData().getCollBoxY();
                        coord.z = positionZ;
                        coord = smViewMng.viewPosToLogicPos(coord);
                     }
                  }
                  goalInstance = new GoalBulletImpact(u,unitFrom,affectsArea,hasExploded);
                  if("freeze" in goalParams)
                  {
                     goalInstance.setFreeze(goalParams.freeze.durationMs,goalParams.freeze.moveMultiplier,goalParams.freeze.fireRateMultiplier,goalParams.freeze.viewType);
                  }
                  u.setGoalComponent(goalInstance);
                  u.setPosition(unitFrom.mPosition.x + coord.x,unitFrom.mPosition.y + coord.y - coord.z);
                  if(unitFrom.getMovementComponent() != null)
                  {
                     v = unitFrom.movementGetVelocity();
                     u.movementSetVelocity(v.x,v.y,v.z);
                     u.mPosition.z = positionZ;
                  }
                  if(goalParams.hasOwnProperty("velocity"))
                  {
                     v = goalParams.velocity;
                     u.movementSetVelocity(v.x,v.y,v.z);
                  }
                  if(goalParams.hasOwnProperty("acceleration"))
                  {
                     v = goalParams.acceleration;
                     u.movementSetAcceleration(v.x,v.y,v.z);
                  }
                  u.mData[13] = unitTo;
                  break;
               case "unitGoalBuildingDefending":
                  u.setGoalComponent(new GoalDefense(u));
                  break;
               case "unitGoalBuildingNone":
                  u.setGoalComponent(new UnitComponentGoal(u));
                  break;
               case "unitGoalBuildingMine":
                  u.setGoalComponent(new GoalMine(u));
                  break;
               case "unitGoalSoldierAttacking":
                  if(u.mDef.isMoveInCirclesOn())
                  {
                     goalComponent = new GoalMoveInCircles(u);
                  }
                  else if(u.mDef.isHealer())
                  {
                     goalComponent = new GoalHealerInBattle(u,u.mFaction == 0);
                  }
                  else
                  {
                     goalComponent = new GoalSoldierAttacking(u);
                  }
                  u.setGoalComponent(goalComponent);
                  break;
               case "unitGoalSoldierDefending":
                  if(u.mDef.isMoveInCirclesOn())
                  {
                     goalComponent = new GoalMoveInCircles(u);
                  }
                  else if(u.mDef.isHealer())
                  {
                     goalComponent = new GoalHealerInBattle(u,false);
                  }
                  else
                  {
                     goalComponent = new GoalSoldierDefending(u);
                  }
                  u.setGoalComponent(goalComponent);
                  break;
               case "unitGoalSpecialAttackRocket":
                  u.setGoalComponent(new GoalSpecialAttackRocket(u));
                  break;
               case "unitGoalSpecialAttackFreeze":
                  u.setGoalComponent(new GoalSpecialAttackFreezeBomb(u));
                  break;
               case "unitGoalSpecialAttackCatapult":
                  u.setGoalComponent(new GoalSpecialAttackBigRock(u));
                  break;
               case "unitGoalWanderAroundHq":
                  u.setGoalComponent(new GoalDroidWandering(u,int(goalParams.tileIndex)));
                  break;
               default:
                  u.goalSetCurrentId(goal,goalFor);
                  u.setGoalComponent(null);
            }
         }
      }
      
      public function unitsGetDef(sku:String, type:int) : UnitDef
      {
         var returnValue:UnitDef = null;
         var defMng:DCDefMng = this.unitsGetDefMng(type);
         if(defMng != null)
         {
            returnValue = UnitDef(defMng.getDefBySku(sku));
         }
         return returnValue;
      }
      
      public function unitsGetUnitDefFromUniqueSku(uniqueSku:String) : UnitDef
      {
         var defMng:DCDefMng = null;
         var i:int = 0;
         var returnValue:UnitDef = null;
         i = 0;
         while(i < 5 && returnValue == null)
         {
            defMng = this.unitsGetDefMngByDefMngId(i);
            returnValue = UnitDef(defMng.getDefBySku(uniqueSku));
            i++;
         }
         return returnValue;
      }
      
      public function unitsGetUnitDefFromSkuAndUpgradeId(sku:String, upgradeId:int = 0) : UnitDef
      {
         var uniqueSku:String = UnitDef.getIdFromSkuAndUpgradeId(sku,upgradeId);
         return this.unitsGetUnitDefFromUniqueSku(uniqueSku);
      }
      
      private function unitsGetDefMng(type:int) : DCDefMng
      {
         return this.mUnitsDefMngs[type];
      }
      
      private function unitsRegisterItem(u:MyUnit, item:WorldItemObject) : void
      {
         this.mUnitsItems[u.mId] = item;
      }
      
      private function unitsUnregisterItem(u:MyUnit) : void
      {
         if(this.mUnitsItems != null)
         {
            this.mUnitsItems[u.mId] = null;
         }
      }
      
      public function itemRegisterUnit(itemId:String, unit:MyUnit) : void
      {
         if(this.mItemsUnits[itemId] == null)
         {
            this.mItemsUnits[itemId] = new Vector.<MyUnit>(0);
         }
         this.mItemsUnits[itemId].push(unit);
      }
      
      public function itemUnregisterUnit(itemId:String, unit:MyUnit = null) : void
      {
         var units:Vector.<MyUnit> = null;
         var index:int = 0;
         if(this.mItemsUnits == null)
         {
            return;
         }
         if(this.mItemsUnits[itemId] == null)
         {
            return;
         }
         if(unit == null)
         {
            this.mItemsUnits[itemId].length = 0;
            this.mItemsUnits[itemId] = null;
         }
         else
         {
            index = (units = this.mItemsUnits[itemId]).indexOf(unit);
            if(index > -1)
            {
               units.splice(index,1);
            }
         }
      }
      
      public function unitsInItemGoToItem(itemContainer:WorldItemObject, itemTo:WorldItemObject, goalFor:String, sku:String = null, amount:int = 0) : int
      {
         var unit:MyUnit = null;
         var i:int = 0;
         var b:Bunker = null;
         var total:* = amount;
         var units:Vector.<MyUnit> = this.mItemsUnits[itemContainer.mSid];
         var unitItem:MyUnit = itemContainer.mUnit;
         var length:int = int(units.length);
         if(itemTo.mDef.isABunker())
         {
            b = Bunker(InstanceMng.getBunkerController().getFromSid(itemTo.mSid));
         }
         i = 0;
         while(i < length)
         {
            if((unit = units[i]) != unitItem && unit.mIsAlive)
            {
               if(sku == null || sku == unit.mDef.mSku && amount > 0)
               {
                  if(b != null)
                  {
                     b.waitForUnit(unit);
                  }
                  unit.goalSetCurrentId("unitGoalGoToItem",goalFor);
                  unit.goToItem(itemTo,itemContainer);
                  length = int(units.length);
                  if(sku != null)
                  {
                     amount--;
                     if(amount == 0)
                     {
                        break;
                     }
                  }
               }
               else
               {
                  i++;
               }
            }
            else
            {
               i++;
            }
         }
         return total - amount;
      }
      
      public function unitsGoToItem(unit:MyUnit, itemTo:WorldItemObject, goalFor:String) : void
      {
         var b:Bunker = null;
         if(itemTo.mDef.isABunker())
         {
            if((b = Bunker(InstanceMng.getBunkerController().getFromSid(itemTo.mSid))) != null)
            {
               b.waitForUnit(unit);
            }
         }
         unit.goalSetCurrentId("unitGoalGoToItem",goalFor);
         unit.goToItem(itemTo);
      }
      
      public function unitsToSkusIds(units:Vector.<MyUnit>, unitsSkus:Array, unitsIds:Array) : void
      {
         var u:MyUnit = null;
         if(units != null)
         {
            if(unitsSkus != null && unitsIds != null)
            {
               unitsSkus.length = 0;
               unitsIds.length = 0;
               for each(u in units)
               {
                  unitsSkus.push(u.mDef.mSku);
                  unitsIds.push(u.mId);
               }
            }
         }
      }
      
      private function unitsPrioritiesLoad() : void
      {
         var def:DCDef = null;
         this.mUnitsPriorities = new Dictionary(true);
         var defs:Vector.<DCDef> = InstanceMng.getShotPriorityDefMng().getDefs();
         var i:int = 0;
         var length:int = int(defs.length);
         for(i = 0; i < length; )
         {
            def = defs[i];
            this.mUnitsPriorities[def.getSku()] = i;
            i++;
         }
      }
      
      private function unitsPrioritiesUnload() : void
      {
         this.mUnitsPriorities = null;
      }
      
      public function unitsGetShootPriorityKey(u:MyUnit) : String
      {
         var shotPriorityKey:String = null;
         var tag:* = "anything";
         switch(u.getTypeId() - 4)
         {
            case 0:
               shotPriorityKey = u.mDef.getShotPriorityKey();
               if(shotPriorityKey != "")
               {
                  tag = shotPriorityKey;
               }
               break;
            case 2:
               tag = "soldiers";
         }
         return tag;
      }
      
      private function unitsGetShootPriorityType(u:MyUnit) : int
      {
         return this.mUnitsPriorities[this.unitsGetShootPriorityKey(u)];
      }
      
      public function buildingsSetupFromItem(item:WorldItemObject, unbuild:Boolean = true) : MyUnit
      {
         var newUnit:Boolean = false;
         var u:MyUnit = null;
         var mngId:int = 0;
         var viewComp:UnitComponentView = null;
         var ammoSku:String = null;
         var ugoal:UnitComponentGoal = null;
         var ushot:UnitComponentShot = null;
         var goal:String = null;
         var def:UnitDef;
         var animDefSku:String = (def = item.mDef).getAnimationDefSku();
         if(item.mUnit != null)
         {
            newUnit = false;
            u = item.mUnit;
            if(unbuild)
            {
               u.unbuild();
            }
            if(item.mDef.mTypeId == 6)
            {
               if(viewComp = u.getViewComponent())
               {
                  viewComp.reset(u);
               }
            }
            mngId = -1;
         }
         else
         {
            newUnit = true;
            u = new MyUnit(this.mUnitsNextId.value++);
            if(animDefSku != null)
            {
               switch(animDefSku)
               {
                  case "mortar":
                  case "turret":
                  case "freeze":
                     u.setViewComponent(new UnitViewCustom(u,-1,false));
               }
            }
            mngId = 2;
         }
         u.mData[35] = item;
         var changeView:Boolean = false;
         if(!item.isBroken())
         {
            if(def.isAMine())
            {
               goal = "unitGoalBuildingMine";
            }
            else if(def.isAnEnemyAttractor())
            {
               goal = "unitGoalBuildingNone";
            }
            else
            {
               switch(animDefSku)
               {
                  case "turret":
                  case "mortar":
                  case "freeze":
                     ammoSku = item.mDef.getAmmoSku();
                     u.setShotComponent(this.getShotComponent(ammoSku));
                     goal = "unitGoalBuildingDefending";
               }
            }
         }
         if(newUnit || unbuild)
         {
            u.build(def,1);
         }
         u.setEnergy(item.getEnergy());
         this.unitsSetupUnit(u,mngId,goal,null,item.mViewCenterWorldX,item.mViewCenterWorldY);
         var coor:DCCoordinate = MyUnit.smCoor;
         item.getWorldPos(coor);
         u.setPosition(coor.x,coor.y);
         if(newUnit)
         {
            this.sceneAddUnit(u);
            this.unitsRegisterItem(u,item);
         }
         else
         {
            if(ugoal = u.getGoalComponent())
            {
               ugoal.build(u.mDef,u);
            }
            if(ushot = u.getShotComponent())
            {
               ushot.build(u.mDef,u);
            }
         }
         u.setNeedsToSenseEnvironment(def.mTypeId == 6 && item.isActive());
         return u;
      }
      
      private function getShotComponent(ammoSku:String) : UnitComponentShot
      {
         var shot:UnitComponentShot = null;
         switch(ammoSku)
         {
            case "b_rocket_001":
               shot = new ShotRocket(ammoSku,true);
               break;
            case "b_rocket_002_auto":
               shot = new ShotRocket("b_rocket_002",true);
               break;
            case "b_bullet_001":
            case "b_rocket_002":
            case "b_bomb_001":
            case "b_airbullet_001":
            case "b_fireball_001":
            case "b_tornado_001":
            case "b_rock_001":
               shot = new ShotRocket(ammoSku,false);
               break;
            case "b_burst_001":
            case "b_freeze_001":
               shot = new ShotBurst(ammoSku);
               break;
            case "b_sniper_001":
            case "b_sniper_002":
            case "b_sniper_003":
               shot = new ShotBurst(ammoSku,true);
               break;
            case "b_laser_001":
               shot = new ShotLaser();
               break;
            case "b_poke_001":
            case "b_flame_001":
               shot = new ShotThrow(ammoSku);
               break;
            default:
               shot = new ShotInstant();
         }
         return shot;
      }
      
      public function buildingsAddUnit(item:WorldItemObject) : MyUnit
      {
         return this.buildingsSetupFromItem(item);
      }
      
      public function buildingsRemoveUnit(u:MyUnit) : void
      {
         u.markToBeReleasedFromScene();
      }
      
      public function addItem(item:WorldItemObject) : void
      {
         var unit:MyUnit = null;
         if(item.mDef.needsAnUnit())
         {
            unit = this.buildingsAddUnit(item);
            item.setUnit(unit);
            this.itemRegisterUnit(item.mSid,unit);
         }
      }
      
      public function removeItem(item:WorldItemObject, forceRemoveUnit:Boolean) : void
      {
         if(item.mUnit != null)
         {
            if(!forceRemoveUnit)
            {
               forceRemoveUnit = !item.mUnit.shotCanBeATarget();
            }
            if(forceRemoveUnit)
            {
               this.buildingsRemoveUnit(item.mUnit);
               this.itemUnregisterUnit(item.mSid);
            }
         }
      }
      
      private function removeItemSceneUnits(item:WorldItemObject) : void
      {
         var unit:MyUnit = null;
         if(item != null)
         {
            for each(unit in this.mItemsUnits[item.mSid])
            {
               this.removeItemSceneUnit(unit);
            }
         }
      }
      
      private function removeItemSceneUnit(u:MyUnit) : void
      {
         if(u.mSecureIsInScene.value)
         {
            u.exitSceneStart(1);
         }
      }
      
      private function bulletsCreate(id:int, customView:Boolean = true) : MyUnit
      {
         var u:MyUnit = new MyUnit(id);
         u.setMovementComponent(new UnitComponentMovement(u));
         if(customView)
         {
            u.setViewComponent(new UnitViewCustom(u));
         }
         return u;
      }
      
      public function bulletsShoot(sku:String, damage:Number, goal:String, goalParams:Object, unitFrom:MyUnit, unitTo:MyUnit = null, collboxIndex:int = 0, takeOriginFromUnitTo:Boolean = false, customView:Boolean = true) : void
      {
         var viewComponent:UnitComponentView = null;
         var renderData:DCBitmapMovieClip = null;
         var u:MyUnit;
         (u = this.unitsCreateUnit(sku,3,unitFrom.mFaction,customView)).shotSetDamage(damage);
         if(goalParams == null)
         {
            goalParams = {};
         }
         goalParams.unitFrom = unitFrom;
         goalParams.unitTo = unitTo;
         var originUnit:MyUnit;
         var originX:int = (originUnit = takeOriginFromUnitTo ? unitTo : unitFrom).mPositionDrawX;
         var originY:int = originUnit.mPositionDrawY;
         if(!takeOriginFromUnitTo)
         {
            if((viewComponent = unitFrom.getViewComponent()) != null)
            {
               if((renderData = viewComponent.getCurrentRenderData()) != null)
               {
                  originX += renderData.getCollBoxX(collboxIndex);
                  originY += renderData.getCollBoxY(collboxIndex);
               }
            }
         }
         u.setNeedsToSenseEnvironment(unitFrom.getNeedsToSenseEnvironment());
         this.unitsSetupUnit(u,-1,goal,goalParams,originX,originY);
         this.sceneAddUnit(u);
      }
      
      private function droidsCreate(id:int) : MyUnit
      {
         var u:MyUnit = new MyUnit(id);
         u.setMovementComponent(new UnitComponentMovement(u));
         u.setViewComponent(new UnitViewCustom(u));
         return u;
      }
      
      private function civilsCreate(id:int) : MyUnit
      {
         var u:MyUnit = new MyUnit(id);
         u.setMovementComponent(new UnitComponentMovement(u));
         u.setViewComponent(new UnitViewCustom(u));
         u.setGoalComponent(new GoalCivil(u),false);
         return u;
      }
      
      public function droidsGetCurrentDroidDef() : DroidDef
      {
         return DroidDef(InstanceMng.getDroidDefMng().getDefBySku("dr_001_001"));
      }
      
      public function civilsGetCurrentCivilDef() : CivilDef
      {
         return CivilDef(InstanceMng.getCivilDefMng().getDefBySku("dr_001_001"));
      }
      
      private function shipsCreate(unitDef:UnitDef, id:int) : MyUnit
      {
         var u:MyUnit = new MyUnit(id);
         u.setMovementComponent(new UnitComponentMovement(u));
         u.setViewComponent(new UnitViewCustom(u));
         u.getMovementComponent().mPositionZ = -200;
         return u;
      }
      
      public function shipsGetPositionFromItem(item:WorldItemObject, pos:Vector3D) : void
      {
         var coor:DCCoordinate = MyUnit.smCoor;
         coor.x = item.mViewCenterWorldX;
         coor.y = item.mViewCenterWorldY;
         coor.z = 0;
         var cData:Object;
         if((cData = InstanceMng.getCollisionBoxMng().getCollisionBoxByName(item.viewGetCollisionBoxPackageSku(),"collect")) != null)
         {
            coor.x += cData.x;
            coor.y = coor.y + cData.y + item.mBoundingBox.mHeight;
         }
         smViewMng.viewPosToLogicPos(coor);
         pos.x = coor.x;
         pos.y = coor.y;
      }
      
      public function shipsSendFromItemToItem(u:MyUnit, itemFrom:WorldItemObject, itemTo:WorldItemObject, cmd:String = null, useDistance:Boolean = true) : void
      {
         var target:Vector3D = new Vector3D();
         if(itemFrom != null)
         {
            this.shipsGetPositionFromItem(itemFrom,u.mPosition);
            u.setPosition(u.mPosition.x,u.mPosition.y);
         }
         this.shipsGetPositionFromItem(itemTo,target);
         var distance:Number = useDistance ? itemTo.getBoundingRadius() >> 1 : 0;
         u.movementWanderToPosition(target,distance,cmd);
      }
      
      private function shipsGetDefSkuFromTask(currencyId:int) : String
      {
         var sku:String = null;
         switch(currencyId - 1)
         {
            case 0:
               sku = "minion_housecollector";
               break;
            case 1:
               sku = "minion_minecollector";
               break;
            default:
               sku = "minion_housecollector";
         }
         return sku;
      }
      
      public function shipsPlaceShipWarOnHangar(sku:String, item:WorldItemObject) : void
      {
         var u:MyUnit = this.unitsCreateUnit(sku,2,1);
         this.unitsSetGoal(u,"unitGoalOnHangar",{
            "hangar":item,
            "setPosition":true
         });
         this.sceneAddUnit(u);
      }
      
      public function shipsUnplaceShipsWarOnHangar(item:WorldItemObject, unitSku:String = null, amount:int = -1) : int
      {
         var unit:MyUnit = null;
         var currentAmount:int = 0;
         if(item != null)
         {
            for each(unit in this.mItemsUnits[item.mSid])
            {
               if(unit != item.mUnit)
               {
                  if(unitSku == null || unit.mDef.mSku == unitSku)
                  {
                     if(unit.mIsAlive)
                     {
                        this.removeItemSceneUnit(unit);
                        if(amount > -1)
                        {
                           currentAmount++;
                           if(currentAmount == amount)
                           {
                              break;
                           }
                        }
                     }
                  }
               }
            }
         }
         return currentAmount;
      }
      
      public function shipsSendShipCarry(what:int, itemFrom:WorldItemObject, itemTo:WorldItemObject) : void
      {
         var sku:String = this.shipsGetDefSkuFromTask(what);
         var goalParams:Object = {
            "goalFor":"unitGoalForDroidGoToItem",
            "itemTo":itemFrom
         };
         var u:MyUnit = this.unitsCreateUnit(sku,8);
         this.unitsSetGoal(u,"unitGoalReturnToHQ",goalParams);
         this.sceneAddUnit(u);
      }
      
      public function shipsSendShipWarToHangar(sku:String, itemFrom:WorldItemObject, itemTo:WorldItemObject, exitWhenArrive:Boolean, waitTime:Boolean = false) : void
      {
         var timeToWait:int = 0;
         if(waitTime)
         {
            timeToWait = this.mSceneUnitsShipyardTimeToWait.value;
            this.mSceneUnitsShipyardTimeToWait.value += 500;
         }
         var pGoalFor:String = exitWhenArrive ? "unitGoalForCarryRent" : "unitGoalForLandInHangar";
         var unit:MyUnit = this.shipsSendShip(sku,1,"unitGoalGoToItem",{"goalFor":pGoalFor},itemFrom,itemTo,timeToWait);
      }
      
      private function shipsSendShip(sku:String, faction:int, goal:String, goalParams:Object, itemFrom:WorldItemObject, itemTo:WorldItemObject, timeToWait:int = 0) : MyUnit
      {
         var u:MyUnit = this.unitsCreateUnit(sku,2,faction);
         if(goalParams == null)
         {
            goalParams = {};
         }
         goalParams.itemFrom = itemFrom;
         goalParams.itemTo = itemTo;
         this.unitsSetupUnit(u,-1,goal,goalParams);
         this.sceneAddUnit(u,timeToWait);
         return u;
      }
      
      private function shipsNotify(e:Object, u:MyUnit) : Boolean
      {
         var c:UnitComponentGoal = null;
         var returnValue:Boolean = true;
         var _loc5_:* = e.cmd;
         if("unitEventHasArrived" !== _loc5_)
         {
            switch(u.goalGetForCurrentId())
            {
               case "unitGoalForCarryRent":
                  InstanceMng.getTargetMng().updateProgress("shipHasArrivedToHQ",1);
                  u.exitSceneStart(1);
                  break;
               case "unitGoalForHangarToBunker":
                  u.exitSceneStart(1);
                  break;
               case "unitGoalForReturnToHangar":
                  InstanceMng.getTargetMng().updateProgress("troopsReturnFromAttack",1);
               case "unitGoalForLandInHangar":
                  this.unitsSetGoal(u,"unitGoalOnHangar",e);
                  break;
               case "unitGoalForReturnToBunker":
                  c = u.getGoalComponent();
                  if(c != null)
                  {
                     c.notify(e);
                  }
            }
         }
         else
         {
            switch(u.goalGetForCurrentId())
            {
               case "unitGoalForCarryRent":
                  InstanceMng.getTargetMng().updateProgress("shipHasArrivedToHQ",1);
                  u.exitSceneStart(1);
                  break;
               case "unitGoalForHangarToBunker":
                  u.exitSceneStart(1);
                  break;
               case "unitGoalForReturnToHangar":
                  InstanceMng.getTargetMng().updateProgress("troopsReturnFromAttack",1);
               case "unitGoalForLandInHangar":
                  this.unitsSetGoal(u,"unitGoalOnHangar",e);
                  break;
               case "unitGoalForReturnToBunker":
                  c = u.getGoalComponent();
                  if(c != null)
                  {
                     c.notify(e);
                  }
            }
         }
         return false;
      }
      
      private function soldiersCreate(id:int, type:String) : MyUnit
      {
         var u:MyUnit = new MyUnit(id);
         u.setMovementComponent(new UnitComponentMovement(u));
         u.setViewComponent(new UnitViewCustom(u));
         return u;
      }
      
      public function debugBattle(channel:String = null) : void
      {
         if(channel == null)
         {
            channel = "battle";
         }
         var army:Army = Army(mChildren[2]);
         DCDebug.traceCh(channel,army.debugArmy());
      }
      
      private function mngsGetMngOfUnit(u:MyUnit) : DCComponent
      {
         var returnValue:DCComponent = null;
         var typeId:int = int(GameConstants.UNIT_TYPE_TO_NOTIFY_MNG[u.getTypeId()]);
         if(u.mDef.mSku == "sa_rocket" || u.mDef.mSku == "sa_freeze")
         {
            return mChildren[1];
         }
         switch(typeId)
         {
            case 0:
               returnValue = mChildren[0];
               break;
            case 1:
               returnValue = mChildren[1];
               break;
            case 2:
               returnValue = mChildren[2];
               break;
            case 3:
               if(u.mFaction == 0)
               {
                  returnValue = mChildren[1];
               }
               else if(u.mFaction == 1)
               {
                  returnValue = mChildren[2];
               }
         }
         return returnValue;
      }
      
      private function mngsNotify(u:MyUnit, e:Object) : void
      {
         var mng:DCComponent = this.mngsGetMngOfUnit(u);
         if(mng != null)
         {
            e.unit = u;
            e.item = this.mUnitsItems[u.mId];
            mng.notify(e);
         }
      }
      
      public function mngsNotifyAllMngs(e:Object) : void
      {
         var i:int = 0;
         for(i = 0; i < 3; )
         {
            DCComponent(mChildren[i]).notify(e);
            i++;
         }
      }
      
      private function mngsGetMng(id:int) : DCComponent
      {
         return mChildren[id];
      }
      
      public function createMyUnit(sku:String, faction:int, posX:int, posY:int) : MyUnit
      {
         var u:MyUnit = this.unitsCreateUnit(sku,2,faction);
         this.unitsSetupUnit(u,-1,null,null,posX,posY);
         this.sceneAddUnit(u);
         return u;
      }
      
      public function createCivilDebugUnit(x:Number, y:Number) : MyUnit
      {
         var u:MyUnit = this.unitsCreateUnit("dr_001_001",0,-1);
         this.unitsSetupUnit(u,-1,null,null,x,y);
         this.sceneAddUnit(u);
         return u;
      }
      
      private function debugLoad() : void
      {
         this.mDebugRenderData = new Sprite();
         this.mDebugUnits = new Vector.<MyUnit>(2);
      }
      
      private function debugUnload() : void
      {
         this.mDebugRenderData = null;
         this.mDebugUnitViews = null;
         this.mDebugUnits = null;
      }
      
      private function debugBuild() : void
      {
         this.mDebugUnitViews = new Dictionary(true);
         this.mDebugSprites = new Dictionary(true);
         this.mDebugSpritesVisible = new Dictionary(true);
      }
      
      private function debugUnbuild() : void
      {
         var uView:UnitViewDebug = null;
         var k:* = null;
         var u:MyUnit = null;
         var label:String = null;
         var k2:* = null;
         for(k in this.mDebugUnitViews)
         {
            uView = UnitViewDebug(this.mDebugUnitViews[k]);
            if(uView != null)
            {
               uView.unbuild(null);
               uView.unload();
            }
         }
         this.mDebugUnitViews = null;
         for each(u in this.mDebugUnits)
         {
            if(u != null)
            {
               this.debugReleaseUnit(u);
            }
         }
         this.mDebugUnits.length = 0;
         for(k in this.mDebugSprites)
         {
            label = k;
            for(k2 in this.mDebugSprites[label])
            {
               this.debugRemoveSprite(k2,label);
            }
         }
         this.mDebugSprites = null;
         this.mDebugSpritesVisible = null;
      }
      
      private function debugBegin() : void
      {
         this.mDebugUnitToAttackId.value = 0;
         this.debugSetVisible(false);
      }
      
      private function debugEnd() : void
      {
         this.debugSetVisible(false);
      }
      
      public function debugCreateUnits() : void
      {
         this.mDebugUnits[0] = this.createMyUnit("warSmallShips_001_002",0,1700,968);
         this.mDebugUnits[1] = this.createMyUnit("warSmallShips_001_002",0,1700,868);
      }
      
      public function debugGetUnitToAttack() : MyUnit
      {
         return this.mDebugUnits[this.mDebugUnitToAttackId.value];
      }
      
      public function debugAdvanceUnitToAttackId() : void
      {
         this.mDebugUnitToAttackId.value = (this.mDebugUnitToAttackId.value + 1) % 2;
      }
      
      private function debugReleaseUnit(u:MyUnit) : void
      {
         u.removeFromScene();
         u.unbuild();
         u = null;
      }
      
      private function debugLogicUpdate(dt:int) : void
      {
         var uView:UnitViewDebug = null;
         var k:* = null;
         for(k in this.mDebugUnitViews)
         {
            uView = UnitViewDebug(this.mDebugUnitViews[k]);
            if(uView != null)
            {
               uView.logicUpdate(dt,null);
            }
         }
      }
      
      public function debugToggleVisibility() : void
      {
         this.debugSetVisible(!this.mDebugVisible.value);
      }
      
      public function debugSetVisibilityLabel(label:String, value:Boolean) : void
      {
         var s:Sprite = null;
         var k:* = null;
         this.mDebugSpritesVisible[label] = value;
         for(k in this.mDebugSprites[label])
         {
            s = Sprite(this.mDebugSprites[label][k]);
            if(s != null)
            {
               s.visible = this.mDebugSpritesVisible[label];
            }
         }
      }
      
      private function debugSetVisible(value:Boolean) : void
      {
         var k:* = null;
         if(this.mDebugVisible.value != value)
         {
            this.mDebugVisible.value = value;
         }
         if(this.mDebugVisible.value)
         {
            smViewMng.addDebug(this.mDebugRenderData);
         }
         else
         {
            smViewMng.removeDebug(this.mDebugRenderData);
         }
         for(k in this.mDebugSprites)
         {
            this.debugSetVisibilityLabel(k,value);
         }
      }
      
      private function debugAddUnitToScene(u:MyUnit) : void
      {
         var viewComponent:UnitComponentView = new UnitViewDebug(u);
         viewComponent.addToScene();
         this.mDebugUnitViews[u] = viewComponent;
         var c:UnitComponentView = u.getViewComponent();
         if(c != null)
         {
            u.getViewComponent().addEventListener("mouseOver",this.debugSwitchView,true);
         }
      }
      
      private function debugRemoveUnitFromScene(u:MyUnit) : void
      {
         var c:UnitComponentView = null;
         var uView:UnitViewDebug = this.mDebugUnitViews[u];
         if(uView != null)
         {
            c = u.getViewComponent();
            if(c != null)
            {
               c.removeEventListener("mouseOver",this.debugSwitchView,true);
            }
            uView.removeFromScene();
            this.mDebugUnitViews[u] = null;
         }
      }
      
      private function debugSwitchView(e:MouseEvent) : void
      {
      }
      
      public function debugGetSprite(key:Object, label:String = "none") : Sprite
      {
         if(this.mDebugSprites[label] == null)
         {
            this.mDebugSprites[label] = new Dictionary(true);
            this.mDebugSpritesVisible[label] = false;
         }
         var s:Sprite = this.mDebugSprites[label][key];
         if(s == null)
         {
            s = new Sprite();
            this.mDebugSprites[label][key] = s;
            smViewMng.addDebug(s);
            s.visible = this.mDebugSpritesVisible[label];
         }
         return s;
      }
      
      public function debugRemoveSprite(key:Object, label:String = "none") : void
      {
         var s:Sprite = null;
         if(this.mDebugSprites[label] != null)
         {
            s = this.mDebugSprites[label][key];
            if(s != null)
            {
               smViewMng.removeDebug(s);
               this.mDebugSprites[label][key] = null;
            }
         }
      }
      
      public function debugAngle() : void
      {
         var angle:Number = NaN;
         var u:MyUnit = this.mSceneUnits[6][0];
         if(u != null)
         {
            angle = u.spinGetAngle();
            angle += 3.141592653589793 / 8;
            u.spinSetAngle(angle);
         }
      }
      
      private function battleUnload() : void
      {
         this.mBattleResult = null;
         this.battleEventsUnload();
         this.battleSetHappeningSku(null);
      }
      
      public function battleGetMusic() : String
      {
         var happening:Happening = null;
         var returnValue:String = "music_battle.mp3";
         if(this.mBattleHappeningSku.value != null)
         {
            happening = InstanceMng.getHappeningMng().getHappening(this.mBattleHappeningSku.value);
            if(happening != null)
            {
               returnValue = happening.getSoundKey("musicAttack");
            }
         }
         return returnValue;
      }
      
      public function battleBegin(mode:int = 0) : void
      {
         var i:int = 0;
         var j:int = 0;
         var wave:Object = null;
         var def:UnitDef = null;
         var unitDefMng:UnitDefMng = null;
         var typesLength:int = 0;
         var previewCountdown:int = 0;
         var attackMode:int = 0;
         this.pingDisable();
         var resourceMng:ResourceMng = InstanceMng.getResourceMng();
         this.mIsTutorialRunning.value = InstanceMng.getFlowStatePlanet().isTutorialRunning();
         if(this.mIsTutorialRunning.value)
         {
            unitDefMng = InstanceMng.getUnitDefMng();
            typesLength = int(WAVES_TUTORIAL_TYPES.length);
            for each(i in WAVES_IDS_USED_IN_TUTORIAL)
            {
               def = null;
               wave = this.wavesGetAttackFromString(this.mAttackWaves[i]);
               j = 0;
               while(j < typesLength && def == null)
               {
                  def = this.unitsGetDef(wave.sku,WAVES_TUTORIAL_TYPES[j]);
                  j++;
               }
               if(def != null)
               {
                  resourceMng.requestResource(def.getAssetId());
               }
            }
         }
         var timeMax:int = -1;
         var roleId:int;
         if((roleId = InstanceMng.getFlowStatePlanet().getCurrentRoleId()) == 3 || roleId == 7)
         {
            if(roleId == 7)
            {
               timeMax = this.mReplay.getBattleMaxDuration();
            }
            previewCountdown = 0;
            switch((attackMode = InstanceMng.getApplication().goToGetAttackMode()) - 1)
            {
               case 0:
                  previewCountdown = InstanceMng.getSettingsDefMng().getQuickAttackPreviewCountdown() * 1000;
                  break;
               case 1:
                  previewCountdown = InstanceMng.getBetsSettingsDefMng().getBetWaitingTimeout() * 1000;
            }
            this.battleStart(mode,timeMax,null,"warpGate",null,null,previewCountdown);
         }
         this.mSceneUnitsShipyardTimeToWait.value = 0;
         this.mResultsScreenIsAllowed.value = true;
      }
      
      public function battleEnd() : void
      {
         var attack:SpecialAttack = null;
         this.mBattleIsEnabled.value = false;
         if(this.actualBattleIsRunning())
         {
            this.battleFinish();
         }
         if(this.mAttacksRequests != null)
         {
            for each(attack in this.mAttacksRequests)
            {
               attack.unbuild();
            }
            this.mAttacksRequests.length = 0;
         }
         this.battleEventsUnbuild();
         this.resetMessages();
      }
      
      public function battleSetHappeningSku(value:String) : void
      {
         this.mBattleHappeningSku.value = value;
      }
      
      public function battleGetHappeningSku() : String
      {
         return this.mBattleHappeningSku.value;
      }
      
      public function battleIsAHappening() : Boolean
      {
         return this.mBattleHappeningSku.value != null;
      }
      
      public function battleHappeningWaveSpawnStart(happeningSku:String, waveSpawnDef:WaveSpawnDef, npcEnemySku:String, isCheat:Boolean = false) : void
      {
         var battleEvents:String = this.battleStrGetEventFromWaveSpawnStr(waveSpawnDef.getWave());
         this.battleHappeningWaveStart(happeningSku,waveSpawnDef.getDuration(),battleEvents,npcEnemySku);
         this.mIsCheat.value = isCheat;
      }
      
      public function battleHappeningWaveStart(happeningSku:String, timeMax:Number, battleEvents:String, npcEnemySku:String) : void
      {
         var event:Object = npcEnemySku != null ? {"npcSku":npcEnemySku} : null;
         this.battleStart(6,timeMax,event,null,battleEvents,happeningSku);
      }
      
      public function battleHasHappeningProgressBar() : Boolean
      {
         var happening:Happening = null;
         if(this.battleIsAHappening() && InstanceMng.getHappeningMng().getHappeningInHud().getHappeningType().getCurrentWaveMaxEnemies() > 0)
         {
            happening = InstanceMng.getHappeningMng().getHappening(this.mBattleHappeningSku.value);
            if(happening != null && happening == InstanceMng.getHappeningMng().getHappeningInHud())
            {
               return true;
            }
         }
         return false;
      }
      
      public function battleStart(mode:int = 0, timeMax:Number = -1, event:Object = null, deployWay:String = "warpGate", battleEvents:String = null, happeningSku:String = null, countdownForStart:int = 0) : void
      {
         var activePowerUps:String = null;
         var viewCoords:DCCoordinate = null;
         var uInfo:UserInfo = null;
         var attacked:Profile = null;
         var type:int = 0;
         var settingsDefMng:SettingsDefMng = null;
         var timeInHud:* = NaN;
         var battleTimeMode:int = 0;
         this.mTotalScoreAttack.value = InstanceMng.getFlowStatePlanet().getTotalScoreAttack();
         this.mTotalScoreAttackWithDestroyedAtStart.value = InstanceMng.getFlowStatePlanet().getTotalScoreAttackWithDestroyed();
         var attackMode:int = InstanceMng.getApplication().goToGetAttackMode();
         var coordX:int = 1000;
         var coordY:int = 1230;
         var movementTime:int = 3;
         var wave:String = "";
         if(event != null && event.hasOwnProperty("wave"))
         {
            wave = String(event.wave);
         }
         this.mBattleIsEnabled.value = true;
         this.mBattleMode.value = mode;
         this.battleSetHappeningSku(happeningSku);
         this.deployUnitsReset();
         this.mBattleStartNotifiedToServer.value = false;
         this.mBattleStartTransaction = null;
         if(mode == 6)
         {
            if(event != null)
            {
               coordX = (viewCoords = smViewMng.logicPosToViewPos(new DCCoordinate(event.x,event.y))).x;
               coordY = viewCoords.y;
               InstanceMng.getMapControllerPlanet().moveCameraTo(coordX,coordY,movementTime);
            }
            InstanceMng.getGUIControllerPlanet().startNPCAttack();
            InstanceMng.getVisitorMng().friendsBoxesHide();
            InstanceMng.getWorld().setAttackNotification(1);
            InstanceMng.getUserInfoMng().setAttacked(InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj().getAccountId());
            if(event != null && event.hasOwnProperty("npcSku"))
            {
               InstanceMng.getUserInfoMng().setAttacker(event.npcSku);
            }
            activePowerUps = null;
            if(Config.usePowerUps())
            {
               activePowerUps = smPowerUpMng.getPowerUpsActiveAsStr();
            }
            InstanceMng.getUserDataMng().updateBattle_npcAttackStart(happeningSku,activePowerUps);
            this.mBattleStartNotifiedToServer.value = true;
            InstanceMng.getWorld().lootSetNeedsToBeCalculated(true);
         }
         else if(mode == 5)
         {
            InstanceMng.getUserDataMng().updateBattle_npcAttackStart(happeningSku,null);
            this.mBattleStartNotifiedToServer.value = true;
            InstanceMng.getGUIControllerPlanet().startNPCAttack();
            wave = String(this.mAttackWaves[mode]);
            InstanceMng.getUserInfoMng().setAttacked(InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj().getAccountId());
            InstanceMng.getUserInfoMng().setAttacker("npc_B");
         }
         else if(mode != 0)
         {
            wave = String(this.mAttackWaves[mode]);
         }
         else if(InstanceMng.getRole().mId == 7)
         {
            if((uInfo = this.getAttackerUInfoOnReplay()) != null)
            {
               InstanceMng.getUserInfoMng().setAttacker(uInfo.getAccountId());
            }
            InstanceMng.getUserInfoMng().setAttacked(InstanceMng.getUserInfoMng().getProfileLogin().getAccountId());
         }
         else
         {
            attacked = InstanceMng.getUserInfoMng().getCurrentProfileLoaded();
            InstanceMng.getUserInfoMng().setAttacked(attacked.getAccountId());
            InstanceMng.getUserInfoMng().setAttacker(InstanceMng.getUserInfoMng().getProfileLogin().getAccountId());
         }
         var topHudFacade:TopHudFacade;
         (topHudFacade = InstanceMng.getTopHudFacade()).setWarBootyBarsValues();
         topHudFacade.loadPlayerPhotos();
         if(wave != null)
         {
            type = -1;
            if(mode == 6)
            {
               type = 1;
            }
            else if(mode == 2 || mode == 5)
            {
               type = 2;
            }
            if(type != -1)
            {
               this.startDeployUnits(coordX,coordY,wave,type,null,true,deployWay);
            }
         }
         if(timeMax == -1)
         {
            settingsDefMng = InstanceMng.getSettingsDefMng();
            timeMax = mode == 6 ? settingsDefMng.getBattleTimeNPC() : settingsDefMng.getBattleTime();
         }
         if(this.mBattleIsEnabled.value)
         {
            timeInHud = 0;
            battleTimeMode = -1;
            if(this.battleHasTimeout())
            {
               this.mBattleTimeLeft.value = timeMax;
               this.mBattleTimeAtEnd.value = DCTimerUtil.currentTimeMillis() + timeMax;
               timeInHud = timeMax;
               battleTimeMode = 0;
            }
            if(countdownForStart > 0)
            {
               this.mBattleCountdownForStartAtEnd.value = DCTimerUtil.currentTimeMillis() + countdownForStart;
               this.mBattleCountdownIsRunning.value = true;
               timeInHud = countdownForStart;
               battleTimeMode = attackMode == 2 ? 2 : 1;
            }
            if(timeInHud > 0)
            {
               this.battleSetTime(timeInHud);
            }
            this.battleSetTimeMode(battleTimeMode);
            this.battleChangeState(1);
         }
         InstanceMng.getTrafficMng().droidsGetInHQ();
         InstanceMng.getHangarControllerMng().getHangarController().battlePrepareUnitsInHangars();
         InstanceMng.getBunkerController().battlePrepareUnitsInHangars();
         this.mNeedsToUpdateMissionsProgress.value = this.mBattleMode.value == 0 && InstanceMng.getRole().mId == 3 && InstanceMng.getUserInfoMng().getProfileLogin().isTutorialCompleted();
         this.battleEventsUnbuild();
         if(InstanceMng.getFlowStatePlanet().isCurrentRoleOwner() && !this.replayIsEnabled())
         {
            InstanceMng.getWorld().notifyEventToItems({"cmd":"battleEventHasStarted"});
         }
         if(battleEvents != null)
         {
            this.battleEventsNotifyEventsFromString(battleEvents);
         }
         this.mBattleResult = null;
         if(this.battleIsAHappening())
         {
            InstanceMng.getTopHudFacade().setBattleSpeedBtnVisible(false);
         }
         var army:Army;
         (army = Army(mChildren[1])).resetBattle();
         (army = Army(mChildren[2])).resetBattle();
         this.mBattleNeedsToFinishNpcAttack.value = false;
         if(attackMode == 2)
         {
            this.pingEnable(5000);
            InstanceMng.getBetMng().notifyMyBattleLoad();
            InstanceMng.getTopHudFacade().setBattleSpeedBtnVisible(false);
         }
         this.mNeedsToSetHQLevel.value = true;
      }
      
      private function getAttackerUInfoOnReplay() : UserInfo
      {
         var replayXML:XML = null;
         var xml:XML = null;
         var attribute:String = null;
         var returnValue:UserInfo = null;
         var accId:String = "";
         var url:String = "";
         var name:String = "";
         if(this.mReplay != null)
         {
            replayXML = this.mReplay.getXML();
            if(replayXML != null)
            {
               xml = EUtils.xmlGetChildrenListAsXML(replayXML,"Deploys");
               if(xml != null)
               {
                  attribute = "accountId";
                  if(EUtils.xmlIsAttribute(xml,attribute))
                  {
                     accId = EUtils.xmlReadString(xml,attribute);
                  }
                  attribute = "name";
                  if(EUtils.xmlIsAttribute(xml,attribute))
                  {
                     name = EUtils.xmlReadString(xml,attribute);
                  }
                  attribute = "url";
                  if(EUtils.xmlIsAttribute(xml,attribute))
                  {
                     url = EUtils.xmlReadString(xml,attribute);
                  }
               }
            }
         }
         if(xml != null)
         {
            returnValue = InstanceMng.getUserInfoMng().getUserInfoObj(accId,0);
            if(returnValue == null)
            {
               InstanceMng.getUserInfoMng().addOtherPlayerInfo(xml);
               returnValue = InstanceMng.getUserInfoMng().getUserInfoObj(accId,0);
            }
            else
            {
               InstanceMng.getUserInfoMng().setupUserInfoObj(returnValue,xml,returnValue.getIsOwnerProfile());
            }
         }
         return returnValue;
      }
      
      public function battleFinishIsAllowed() : Boolean
      {
         return this.mAttacksRequests.length == 0;
      }
      
      public function battleFinish() : void
      {
         var doFinishNpcAttack:Boolean = false;
         var happening:Happening = null;
         var happeningType:HappeningType = null;
         var army:Army = null;
         InstanceMng.getTopHudFacade().setReplayIndex(0);
         InstanceMng.getUnitScene().setReplaySpeed(1);
         if(this.pingIsEnabled())
         {
            this.pingSetState(0,5);
         }
         if(this.mBattleTimeMode.value == 1)
         {
            this.battleChangeState(0);
            InstanceMng.getGUIControllerPlanet().endNPCAttack();
            InstanceMng.getFlowStatePlanet().visitReturnToOwnCurrentPlanet();
         }
         else
         {
            this.battleChangeState(5);
            if(this.mBattleMode.value == 6)
            {
               this.mBattleNeedsToFinishNpcAttack.value = true;
               doFinishNpcAttack = true;
               if(this.battleIsAHappening() && !this.mIsCheat.value)
               {
                  happening = InstanceMng.getHappeningMng().getHappening(this.mBattleHappeningSku.value);
                  if(happening != null)
                  {
                     happeningType = happening.getHappeningType();
                     if(happeningType != null)
                     {
                        army = Army(mChildren[1]);
                        happeningType.addProgress(army.getUnitsKilledCount());
                        happeningType.stateChangeState(3,true);
                        doFinishNpcAttack = false;
                     }
                  }
               }
               if(doFinishNpcAttack)
               {
                  this.battleFinishNpcAttack();
               }
            }
            else if(this.mBattleMode.value == 5)
            {
               InstanceMng.getGUIControllerPlanet().endNPCAttack();
            }
            else
            {
               InstanceMng.getGUIControllerPlanet().endAttack();
            }
            InstanceMng.getToolsMng().setTool(0);
            InstanceMng.getHangarControllerMng().getHangarController().battleRestoreUnitsInHangarsAfterBattle();
            InstanceMng.getBunkerController().battleRestoreUnitsInHangarsAfterBattle();
            if(InstanceMng.getFlowStatePlanet().isCurrentRoleOwner() && !this.replayIsEnabled())
            {
               InstanceMng.getWorld().notifyEventToItems({"cmd":"battleEventHasFinished"});
            }
         }
         this.replayCancel();
         this.battleEventsUnbuild();
      }
      
      public function resetBattleSpeed() : void
      {
         var params:Dictionary = new Dictionary();
         params["newAmount"] = 1;
         MessageCenter.getInstance().sendMessage("replaySpeedChanged",params);
      }
      
      public function battleFinishNpcAttack() : void
      {
         if(this.mBattleNeedsToFinishNpcAttack.value)
         {
            this.mBattleNeedsToFinishNpcAttack.value = false;
            InstanceMng.getGUIControllerPlanet().endNPCAttack();
            InstanceMng.getVisitorMng().friendsBoxesShow();
            InstanceMng.getWorld().setAttackNotification(2);
            InstanceMng.getTrafficMng().droidsGetOutHQ();
            this.guiOpenNpcAttackIsOverPopup(this.battleIsAHappening());
         }
      }
      
      public function battleGetMode() : int
      {
         return this.mBattleMode.value;
      }
      
      public function battleIsEnabled() : Boolean
      {
         return true;
      }
      
      public function battleGetResult() : Object
      {
         return this.mBattleResult;
      }
      
      public function actualBattleIsRunning() : Boolean
      {
         return this.mBattleState.value != 1 && this.battleIsRunning();
      }
      
      public function battleIsRunning(considerDebug:Boolean = false, considerPopups:Boolean = false) : Boolean
      {
         var returnValue:Boolean = this.mBattleState.value > 0 && this.mBattleState.value < 5;
         if(considerDebug && !returnValue)
         {
            returnValue = Config.DEBUG_MODE && InstanceMng.getRole().mId == 0 && this.mBattleMode.value == 0;
         }
         if(considerPopups && !returnValue)
         {
            returnValue = this.mBattleNeedsToFinishNpcAttack.value;
         }
         return returnValue;
      }
      
      private function battleHasTimeout() : Boolean
      {
         return this.mBattleMode.value == 6 || this.mBattleMode.value == 0;
      }
      
      private function battleCountdownPause() : void
      {
         this.mBattleCountdownIsRunning.value = false;
      }
      
      private function battleCountdownResume() : void
      {
         this.mBattleCountdownIsRunning.value = true;
      }
      
      private function notifyWaitingForRivalIsOver() : void
      {
         this.battleStartActualBattle(true);
         if(InstanceMng.getApplication().goToGetAttackMode() == 2)
         {
            this.mBattleStartTransaction = InstanceMng.getBetMng().notifyMyBattleStart();
            InstanceMng.getUserDataMng().updateBattle_started(this.mBattleStartTransaction);
            this.mBattleStartNotifiedToServer.value = true;
         }
      }
      
      private function battleStartActualBattle(showWarBarCountDown:Boolean = false) : void
      {
         this.battleSetTime(this.mBattleTimeLeft.value);
         InstanceMng.getTopHudFacade().setWarBootyBarsValues(true);
         if(showWarBarCountDown)
         {
            this.battleChangeState(2);
            this.battleSetTimeMode(3);
         }
         else
         {
            this.battleSetTimeMode(0);
            this.mBattleTimeAtEnd.value = DCTimerUtil.currentTimeMillis() + this.mBattleTimeLeft.value;
            this.battleChangeState(3);
         }
      }
      
      private function battleStartTimeOut() : void
      {
         switch(InstanceMng.getApplication().goToGetAttackMode() - 1)
         {
            case 0:
               this.quickAttackStartActualBattle();
               break;
            case 1:
               this.battleChangeState(0);
               this.mResultsScreenIsAllowed.value = false;
               this.pingDisable();
               InstanceMng.getBetMng().notifyBattleTimeout();
         }
      }
      
      private function battleSetTimeMode(value:int) : void
      {
         this.mBattleTimeMode.value = value;
         InstanceMng.getTopHudFacade().battleSetMenuClockMode(value);
         this.battleSetMenuClockMode(value);
      }
      
      public function battleSetMenuClockMode(value:int) : void
      {
         if(value == 1)
         {
            this.addMessage(DCTextMng.getText(327),0,false,false,false);
         }
         else if(value == 2)
         {
            this.addMessage(DCTextMng.getText(328),0,true,true,true);
         }
         else if(value == 3)
         {
            this.hideMessage(true);
         }
         else
         {
            this.hideMessage(false);
         }
         InstanceMng.getGUIControllerPlanet().getWarBarSpecial().battleSetMenuClockMode(value);
      }
      
      private function battleSetTime(value:int) : void
      {
         InstanceMng.getTopHudFacade().battleSetTimeLeft(value);
         InstanceMng.getReplayBar().battleSetTimeLeft(value);
      }
      
      public function battleIsPreviewCountdown() : Boolean
      {
         return this.mBattleTimeMode.value == 1 || this.mBattleTimeMode.value == 2;
      }
      
      public function betIsOver() : void
      {
         this.mResultsScreenIsAllowed.value = false;
         this.battleFinish();
      }
      
      public function battleGetTimeLeft() : Number
      {
         return this.mBattleTimeLeft.value;
      }
      
      private function battleLoop(dt:int, allowCallBattleFinish:Boolean) : void
      {
         var time:Number = NaN;
         if(this.battleHasTimeout())
         {
            if(this.replayIsEnabled())
            {
               this.mBattleTimeLeft.value -= dt;
            }
            else
            {
               this.mBattleTimeLeft.value -= dt;
               time = DCTimerUtil.currentTimeMillis();
               if(time >= this.mBattleTimeAtEnd.value || this.mBattleTimeLeft.value <= 0)
               {
                  time = this.mBattleTimeAtEnd.value;
                  this.mBattleTimeLeft.value = 0;
                  if(!this.mIsTutorialRunning.value && this.battleFinishIsAllowed())
                  {
                     if(allowCallBattleFinish)
                     {
                        this.battleFinish();
                     }
                  }
               }
            }
            if(this.mBattleTimeLeft.value < 0)
            {
               this.mBattleTimeLeft.value = 0;
            }
            this.battleSetTime(this.mBattleTimeLeft.value);
         }
      }
      
      public function battleLogicUpdate(dt:int) : void
      {
         var currentTime:Number = NaN;
         var timeLeft:Number = NaN;
         var time:Number = NaN;
         switch(this.mBattleState.value - 1)
         {
            case 0:
               if(this.battleIsPreviewCountdown())
               {
                  if(this.mBattleCountdownForStartAtEnd.value > 0 && this.mBattleCountdownIsRunning.value)
                  {
                     currentTime = DCTimerUtil.currentTimeMillis();
                     if(currentTime >= this.mBattleCountdownForStartAtEnd.value)
                     {
                        this.battleStartTimeOut();
                     }
                     timeLeft = this.mBattleCountdownForStartAtEnd.value - currentTime;
                     if(InstanceMng.getApplication().goToGetAttackMode() == 2 && this.pingIsEnabled() && timeLeft <= 5000)
                     {
                        InstanceMng.getUserDataMng().updateBattle_preStartTimeout();
                        this.pingDisable();
                     }
                     if(timeLeft < 0)
                     {
                        timeLeft = 0;
                     }
                     this.battleSetTime(timeLeft);
                  }
               }
               else
               {
                  this.battleChangeState(3);
               }
               break;
            case 1:
               if(this.mBattleCountdownForStartAtEnd.value > 0)
               {
                  time = DCTimerUtil.currentTimeMillis();
                  if(time >= this.mBattleCountdownForStartAtEnd.value)
                  {
                     this.battleStartActualBattle();
                  }
               }
               break;
            case 2:
               if(this.battleHasHappeningProgressBar())
               {
                  InstanceMng.getTopHudFacade().updateHappeningWaveProgressBar(Army(mChildren[1]).getUnitsKilledCount(),InstanceMng.getHappeningMng().getHappeningInHud().getHappeningType().getCurrentWaveMaxEnemies());
               }
               this.battleLoop(dt,true);
               break;
            case 3:
               this.battleLoop(dt,false);
               this.mBattleTimeToFinish.value -= dt;
               if(this.mBattleTimeToFinish.value <= 0)
               {
                  this.battleFinish();
               }
               break;
            case 4:
               if(InstanceMng.getFlowStatePlanet().getCurrentRoleId() == 3)
               {
                  this.battleChangeState(0);
               }
               this.mBattleIsEnabled.value = false;
         }
         this.battleEventsLogicUpdate(dt);
      }
      
      private function battleChangeState(state:int) : void
      {
         var uiFacade:UIFacade = null;
         var currentRoleId:int = 0;
         var isBet:* = false;
         var e:Object = null;
         var profile:Profile = null;
         var attackingPlanet:Planet = null;
         var defendingUser:UserInfo = null;
         var defendingPlanet:Planet = null;
         var planetSku1:String = null;
         var planetSku2:String = null;
         var armyDefender:Army = null;
         var myCoins:Number = NaN;
         var myMinerals:Number = NaN;
         var myScore:Number = NaN;
         var myScorePercent:Number = NaN;
         var loot:Dictionary = null;
         var totalScoreAttack:Number = NaN;
         var battleDuration:Number = NaN;
         var userInfoMng:UserInfoMng = null;
         var currProfileAccId:String = null;
         var currUserInfoObj:UserInfo = null;
         var askForBattleResult:Boolean = false;
         var userId:String = null;
         var user:AlliancesUser = null;
         DCDebug.traceCh("Battle","Changing battleState from " + this.mBattleState.value + " to " + state);
         this.mBattleState.value = state;
         switch(this.mBattleState.value - 1)
         {
            case 0:
               this.mngsNotifyAllMngs({"cmd":"battleEventHasStarted"});
               InstanceMng.getShipyardController().pause();
               InstanceMng.getResourceMng().requestsNotifyEvent("requestsBattleStart");
               break;
            case 1:
               this.mBattleCountdownForStartAtEnd.value = DCTimerUtil.currentTimeMillis() + 4000;
               (uiFacade = InstanceMng.getUIFacade()).showTextFeedback("3",1000,0);
               uiFacade.showTextFeedback("2",1000,1000);
               uiFacade.showTextFeedback("1",1000,2000);
               uiFacade.showTextFeedback(DCTextMng.getText(285),1000,3000);
               break;
            case 2:
               if(!this.mBattleStartNotifiedToServer.value && !this.replayIsEnabled())
               {
                  InstanceMng.getUserDataMng().updateBattle_started(this.mBattleStartTransaction);
                  this.mBattleStartNotifiedToServer.value = true;
               }
               break;
            case 4:
               this.mReplaySpeed.value = 1;
               currentRoleId = InstanceMng.getFlowStatePlanet().getCurrentRoleId();
               isBet = InstanceMng.getApplication().goToGetAttackMode() == 2;
               e = {"cmd":"battleEventHasFinished"};
               this.mngsNotifyAllMngs(e);
               InstanceMng.getShipyardController().resume();
               InstanceMng.getTopHudFacade().setReplayIndex(0);
               if(this.mResultsScreenIsAllowed.value && (currentRoleId == 3 || this.mBattleMode.value == 6))
               {
                  battleDuration = DCTimerUtil.msToSec(InstanceMng.getSettingsDefMng().getBattleTime() - this.mBattleTimeLeft.value);
                  if(currentRoleId == 3)
                  {
                     armyDefender = Army(mChildren[2]);
                     if(isBet)
                     {
                        myCoins = Number(armyDefender.mLootAmount[0]);
                        myMinerals = Number(armyDefender.mLootAmount[1]);
                        myScore = Number(armyDefender.mLootAmount[2]);
                        myScorePercent = myScore * 100 / this.mTotalScoreAttack.value;
                        loot = InstanceMng.getWorld().getMaxAmountLootable();
                        totalScoreAttack = this.mTotalScoreAttack.value;
                        InstanceMng.getUserDataMng().updateBattle_finished(battleDuration,myCoins,loot["damageCoins"],myMinerals,loot["damageMinerals"],myScore,totalScoreAttack);
                        InstanceMng.getBetMng().notifyMyBattleIsOver(myCoins,loot["damageCoins"],myMinerals,loot["damageMinerals"],myScore,totalScoreAttack,myScorePercent,battleDuration);
                     }
                     else
                     {
                        myCoins = Number(armyDefender.mLootAmount[0]);
                        myMinerals = Number(armyDefender.mLootAmount[1]);
                        myScore = Number(armyDefender.mLootAmount[2]);
                        myScorePercent = myScore * 100 / this.mTotalScoreAttack.value;
                        loot = InstanceMng.getWorld().getMaxAmountLootable();
                        totalScoreAttack = this.mTotalScoreAttack.value;
                        InstanceMng.getUserDataMng().updateBattle_finished(battleDuration,myCoins,loot["damageCoins"],myMinerals,loot["damageMinerals"],myScore,totalScoreAttack);
                        if(this.mBattleResult == null)
                        {
                           this.mBattleResult = {};
                        }
                        this.mBattleResult.showAllianceScore = false;
                        currProfileAccId = (userInfoMng = InstanceMng.getUserInfoMng()).getCurrentProfileLoaded().getAccountId();
                        currUserInfoObj = userInfoMng.getUserInfoObj(currProfileAccId,0);
                        if(InstanceMng.getUserInfoMng().getProfileLogin().isTutorialCompleted())
                        {
                           if(currUserInfoObj.mIsNPC.value)
                           {
                              this.mBattleResult.type = "EventPopup";
                              this.mBattleResult.cmd = "NotifyAttackToNPCResult";
                              this.mBattleResult.hqDestroyed = InstanceMng.getWorld().itemsGetHeadquarters().isCompletelyBroken();
                              this.mBattleResult.userImageUrl = InstanceMng.getResourceMng().getNPCPortraitUrl(userInfoMng.getCurrentProfileLoaded().getThumbnailURL());
                              this.mBattleResult.playerName = userInfoMng.getCurrentProfileLoaded().getPlayerName();
                              this.mBattleResult.attackedAccId = currUserInfoObj.mAccountId;
                              InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),this.mBattleResult);
                           }
                           else
                           {
                              this.mBattleResult.lootedCoins = armyDefender.mLootAmount[0];
                              this.mBattleResult.lootedMineral = armyDefender.mLootAmount[1];
                              this.mBattleResult.scoreGained = armyDefender.mLootAmount[2];
                              this.mBattleResult.hqDestroyed = InstanceMng.getWorld().itemsGetHeadquarters().isCompletelyBroken();
                              this.mBattleResult.attackedAccId = currUserInfoObj.getAccountId();
                              askForBattleResult = false;
                              userId = InstanceMng.getUserInfoMng().getCurrentProfileLoaded().getAccountId();
                              if(askForBattleResult = Config.useAlliances() && InstanceMng.getAlliancesController().isMyAllianceInAWarAgainstUserId(userId))
                              {
                                 user = InstanceMng.getAlliancesController().getMyUser();
                                 this.mAllianceScoreBeforeBattle.value = user.getScore();
                                 InstanceMng.getApplication().lockUIWaitForBattleResult();
                              }
                              else
                              {
                                 this.startBattleResultPopup(this.mBattleResult,0);
                              }
                           }
                        }
                     }
                  }
                  else if(currentRoleId == 0)
                  {
                     InstanceMng.getUserDataMng().updateBattle_finished(battleDuration);
                  }
               }
               else if(this.mBattleMode.value == 5)
               {
                  InstanceMng.getUserDataMng().updateBattle_finished(0);
               }
               else if(currentRoleId == 7)
               {
                  InstanceMng.getGUIControllerPlanet().endReplay();
                  InstanceMng.getFlowStatePlanet().visitReturnToOwnCurrentPlanet();
                  InstanceMng.getWorld().setShowRepairsPopupEnabled(false);
               }
               else
               {
                  InstanceMng.getFlowStatePlanet().visitReturnToOwnCurrentPlanet();
               }
               this.battleChangeState(0);
         }
      }
      
      public function battleGetWave(id:int) : String
      {
         return this.mAttackWaves[id];
      }
      
      public function battleGetCoinsSoFar() : Number
      {
         var army:Army = Army(mChildren[2]);
         return army.mLootAmount[0];
      }
      
      public function battleGetMineralsSoFar() : Number
      {
         var army:Army = Army(mChildren[2]);
         return army.mLootAmount[1];
      }
      
      public function battleIsANPCAttack() : Boolean
      {
         return this.mBattleMode.value == 5 || this.mBattleMode.value == 6;
      }
      
      public function battleCanBuyExtraBattleTime() : Boolean
      {
         var application:Application = null;
         var returnValue:* = this.mBattleMode.value == 0;
         if(returnValue)
         {
            application = InstanceMng.getApplication();
            returnValue = application.isTutorialCompleted() && application.goToGetAttackMode() != 2 && InstanceMng.getFlowStatePlanet().getCurrentRoleId() == 3;
         }
         return returnValue;
      }
      
      public function battleOpenResultPopupWithAllianceScore(showAllianceScore:Boolean) : void
      {
         var attHqLevel:int = 0;
         var defHqLevel:int = 0;
         var controller:AlliancesController = null;
         var user:AlliancesUser = null;
         var str:String = "";
         var allianceScoreServer:Number = NaN;
         var allianceScoreClient:Number = NaN;
         var battleOverWhileAttacking:Boolean = false;
         if(showAllianceScore && !Config.OFFLINE_ALLIANCES_MODE)
         {
            controller = InstanceMng.getAlliancesController();
            if((user = controller.getMyUser()) != null)
            {
               if((allianceScoreServer = user.getScore() - this.mAllianceScoreBeforeBattle.value) < 0)
               {
                  allianceScoreServer = 0;
               }
               attHqLevel = InstanceMng.getUserInfoMng().getProfileLogin().getCurrentPlanetHqLevel();
               defHqLevel = InstanceMng.getUserInfoMng().getCurrentProfileLoaded().getCurrentPlanetHqLevel();
               allianceScoreClient = InstanceMng.getAlliancesSettingsDefMng().calculateWarPointsFromScore(this.mBattleResult.scoreGained,getTotalScoreWithDestroyedAtStart(),attHqLevel,defHqLevel);
               str += " allianceScoreBeforeBattle = " + this.mAllianceScoreBeforeBattle.value + " currentScore = " + user.getScore() + " warScoreClient = " + allianceScoreClient;
               if(allianceScoreServer != 0)
               {
                  this.mBattleResult.allianceScore = allianceScoreServer;
               }
               else if(allianceScoreClient > 0)
               {
                  this.mBattleResult.allianceScore = allianceScoreClient;
               }
               else
               {
                  showAllianceScore = false;
               }
               if(battleOverWhileAttacking = controller.needsToShowWarIsOverPopup())
               {
                  InstanceMng.getUIFacade().alliancesNotifyWasHasEnded();
                  showAllianceScore = false;
               }
            }
            else
            {
               showAllianceScore = false;
               str += " user is null";
            }
         }
         str = " showAllianceScore = " + showAllianceScore + str;
         DCDebug.traceCh("warScore",str);
         this.mBattleResult.showAllianceScore = showAllianceScore;
         this.mBattleResult.battleOverWhileAttacking = battleOverWhileAttacking;
         this.startBattleResultPopup(this.mBattleResult,0);
      }
      
      private function battleAddExtraTime(extraBattleTime:Number) : void
      {
         if(this.replayIsEnabled())
         {
            this.mBattleTimeLeft.value += extraBattleTime;
         }
         else
         {
            this.mBattleTimeAtEnd.value += extraBattleTime;
            this.mBattleTimeLeft.value += extraBattleTime;
         }
         InstanceMng.getTopHudFacade().battleExtraTimeBought(extraBattleTime);
      }
      
      private function battleEventsUnload() : void
      {
         this.mBattleEvents = null;
      }
      
      private function battleEventsUnbuild() : void
      {
         if(this.mBattleEvents != null)
         {
            this.mBattleEvents.length = 0;
         }
         this.mBattleEventsRequiredForBattleCount.value = 0;
      }
      
      private function battleEventsLogicUpdate(dt:int) : void
      {
         if(this.mBattleEvents == null)
         {
            return;
         }
         var e:Object = null;
         var i:int = 0;
         var length:int = 0;
         length = int(this.mBattleEvents.length);
         for(i = 0; i < length; )
         {
            e = this.mBattleEvents[i];
            if(this.battleEventsCanEventBeProcessed(e))
            {
               if(this.battleEventsIsRequiredForBattle(e))
               {
                  this.mBattleEventsRequiredForBattleCount.value--;
               }
               this.battleEventsProcessEvent(e);
               this.mBattleEvents.splice(i,1);
               length--;
            }
            else
            {
               i++;
            }
            i++;
         }
      }
      
      private function battleEventsIsRequiredForBattle(e:Object) : Boolean
      {
         return e.cmd == "battleEventDeploySpecialAttack" || e.cmd == "battleEventDeployWave";
      }
      
      private function battleEventsCanEventBeProcessed(e:Object) : Boolean
      {
         var returnValue:* = true;
         if(e.timeOver != null)
         {
            returnValue = DCTimerUtil.currentTimeMillis() >= e.timeOver;
         }
         if(returnValue)
         {
            var _loc3_:* = e.cmd;
            if("battleArmyEventFinish" === _loc3_)
            {
               returnValue = this.battleFinishIsAllowed();
            }
         }
         return returnValue;
      }
      
      private function battleEventsNotify(e:Object, timeOff:int = -1) : void
      {
         if(e != null)
         {
            if(e.timeOff != null && timeOff == -1)
            {
               timeOff = int(e.timeOff);
            }
            e.timeOver = this.battleGetTimeOver(timeOff);
            if(this.battleEventsCanEventBeProcessed(e))
            {
               this.battleEventsProcessEvent(e);
            }
            else
            {
               if(this.mBattleEvents == null)
               {
                  this.mBattleEvents = new Vector.<Object>(0);
               }
               this.mBattleEvents.push(e);
               if(this.battleEventsIsRequiredForBattle(e))
               {
                  this.mBattleEventsRequiredForBattleCount.value++;
               }
            }
         }
      }
      
      public function battleEventsNotifyArmyFinish(pFaction:int) : void
      {
         if(!(pFaction == 0 && this.mBattleEventsRequiredForBattleCount.value > 0))
         {
            this.battleEventsNotify({
               "cmd":"battleArmyEventFinish",
               "faction":pFaction
            });
         }
      }
      
      private function battleEventsProcessArmyFinish(e:Object) : void
      {
         var finish:* = true;
         if(this.mBattleMode.value == 0 && e.faction == 0)
         {
            if(InstanceMng.getRole().mId == 7)
            {
               finish = !this.mReplay.areDeploysLeft();
            }
            else
            {
               finish = !InstanceMng.getApplication().hasTheOwnerArmament(true);
               finish &&= !InstanceMng.getGUIControllerPlanet().getWarBar().areAllyUnitsLeft();
               finish &&= InstanceMng.getItemsMng().getMercenaries() == 0;
            }
         }
         if(finish)
         {
            if(this.mBattleMode.value == 0)
            {
               this.mBattleTimeToFinish.value = InstanceMng.getSettingsDefMng().getBattleEndTime();
               this.battleChangeState(4);
            }
            else
            {
               this.battleFinish();
            }
         }
      }
      
      public function battleEventsNotifyBattleFinished(pFaction:int) : void
      {
         this.battleEventsNotify({
            "cmd":"battleEventHasFinished",
            "faction":pFaction
         });
      }
      
      private function battleEventsProcessBattleFinished(e:Object) : void
      {
         var i:int = 0;
         for(i = 0; i < 14; )
         {
            this.mSceneEventsToType[i] = e;
            i++;
         }
      }
      
      public function battleEventsNotifyArmyRemoveUnits(pFaction:int) : void
      {
         this.battleEventsNotify({
            "cmd":"battleArmyRemoveUnits",
            "faction":pFaction
         });
      }
      
      public function battleEventsNotifyUnitWasHit(pUnit:MyUnit, pDamage:int, pTransaction:Transaction) : void
      {
         this.battleEventsNotify({
            "cmd":"battleUnitEventWasHit",
            "unit":pUnit,
            "damage":pDamage,
            "transaction":pTransaction
         });
      }
      
      private function battleEventsGetDeployWaveEvent(pWave:String, pX:int, pY:int, pDeployType:int, pDeployWay:String, pTimeOff:int) : Object
      {
         return {
            "cmd":"battleEventDeployWave",
            "wave":pWave,
            "x":pX,
            "y":pY,
            "deployType":pDeployType,
            "deployWay":pDeployWay,
            "timeOff":pTimeOff
         };
      }
      
      public function battleEventsGetDeploySpecialAttackEvent(pSku:String, pX:int, pY:int, pTimeOff:int) : Object
      {
         return {
            "cmd":"battleEventDeploySpecialAttack",
            "sku":pSku,
            "x":pX,
            "y":pY,
            "timeOff":pTimeOff
         };
      }
      
      public function battleEventsGetMoveCameraEvent(pX:int, pY:int, pMovementTime:int, pTimeOff:int) : Object
      {
         return {
            "cmd":"battleEventMoveCamera",
            "x":pX,
            "y":pY,
            "movementTime":pMovementTime,
            "timeOff":pTimeOff
         };
      }
      
      public function battleEventsNotifyDeployWave(wave:String, x:int, y:int, deployType:int, deployWay:String = "warpGate", timeOff:int = -1) : void
      {
         this.battleEventsNotify(this.battleEventsGetDeployWaveEvent(wave,x,y,deployType,deployWay,timeOff));
      }
      
      public function battleEventsNotifyDeploySpecialAttack(sku:String, x:int, y:int, timeOff:int = -1) : void
      {
         this.battleEventsNotify(this.battleEventsGetDeploySpecialAttackEvent(sku,x,y,timeOff));
      }
      
      private function battleEventsNotifyEventsFromString(eventsStr:String) : void
      {
         var event:String = null;
         var eventObject:Object = null;
         var events:Array = eventsStr.split("/");
         for each(event in events)
         {
            this.battleEventsNotify(this.battleStrGetSingleEvent(event));
         }
      }
      
      private function battleGetTimeOver(timeOff:int) : Number
      {
         return DCTimerUtil.currentTimeMillis() + timeOff;
      }
      
      private function battleEventsProcessEvent(e:Object) : void
      {
         var unit:MyUnit = null;
         switch(e.cmd)
         {
            case "battleEventMoveCamera":
               InstanceMng.getMapControllerPlanet().moveCameraTo(e.x,e.y,e.movementTime);
               break;
            case "battleEventDeployWave":
               this.startDeployUnits(e.x,e.y,e.wave,e.deployType,null,false,e.deployWay);
               break;
            case "battleEventDeploySpecialAttack":
               this.attacksLaunchSpecialAttack(e.sku,e.x,e.y);
               break;
            case "battleEventHasFinished":
               this.battleEventsProcessBattleFinished(e);
               break;
            case "battleArmyEventFinish":
               this.battleEventsProcessArmyFinish(e);
               break;
            case "battleUnitEventWasHit":
               unit = e.unit;
               this.mngsNotify(unit,e);
         }
      }
      
      private function battleStrGetSingleEvent(eventStr:String) : Object
      {
         var returnValue:Object = null;
         var deployWay:String = null;
         var tokens:Array;
         var timeOff:Number = Number((tokens = eventStr.split("$"))[0]);
         var type:String = String(tokens[1]);
         var what:String = String(tokens[2]);
         switch(type)
         {
            case "wave":
               deployWay = String(tokens.length == 6 ? tokens[5] : "warpGate");
               returnValue = this.battleEventsGetDeployWaveEvent(what,tokens[3],tokens[4],1,deployWay,timeOff);
               break;
            case "specialAttack":
               returnValue = this.battleEventsGetDeploySpecialAttackEvent(what,tokens[3],tokens[4],timeOff);
               break;
            case "moveCamera":
               returnValue = this.battleEventsGetMoveCameraEvent(tokens[2],tokens[3],tokens[4],timeOff);
         }
         return returnValue;
      }
      
      public function battleStrGetEventFromWaveSpawnStr(waveSpawnStr:String, moveCameraToFirstDeploy:Boolean = true) : String
      {
         var waveToSpawn:String = null;
         var tokens:Array = null;
         var timeOff:int = 0;
         var waveSku:String = null;
         var waveDef:WaveDef = null;
         var wavesToSpawn:Array = waveSpawnStr.split(",");
         var returnValue:String = "";
         var isFirstWave:Boolean = true;
         for each(waveToSpawn in wavesToSpawn)
         {
            tokens = waveToSpawn.split(":");
            timeOff = DCTimerUtil.secondToMs(int(tokens[0]));
            waveSku = String(tokens[1]);
            if((waveDef = smWaveDefMng.getDefBySku(waveSku) as WaveDef) != null)
            {
               if(isFirstWave)
               {
                  returnValue += "10$moveCamera$" + waveDef.getDeployX() + "$" + waveDef.getDeployY() + "$" + 3 + "/";
                  isFirstWave = false;
               }
               returnValue += this.battleStrGetEventFromWaveDef(waveDef,timeOff) + "/";
            }
            else
            {
               DCDebug.traceCh("ASSERT","wave <" + waveSku + "> not found in waveDefinitions.xml");
            }
         }
         return returnValue;
      }
      
      public function battleStrGetEventFromWaveDef(waveDef:WaveDef, timeOff:int) : String
      {
         return timeOff + "$" + "wave" + "$" + waveDef.getUnits() + "$" + waveDef.getDeployX() + "$" + waveDef.getDeployY() + "$" + waveDef.getDeployWay();
      }
      
      private function distributeLoad() : void
      {
         this.mPositionsX = new Vector.<Number>(0);
         this.mPositionsY = new Vector.<Number>(0);
         this.mCurrentBase.value = 1;
      }
      
      private function distributeUnload() : void
      {
         this.mPositionsX = null;
         this.mPositionsY = null;
      }
      
      private function distributePoints(nPoints:int) : void
      {
         var i:int = 0;
         var j:int = 0;
         var k:int = 0;
         if(nPoints > this.mPositionsX.length)
         {
            while(this.mPositionsX.length < nPoints)
            {
               if(this.mPositionsX.length == 0)
               {
                  this.distributeAddPoint(0,0);
               }
               j = 0;
               while(j < 4)
               {
                  this.distributeAddPoint(this.mCurrentBase.value * OFFSET_X[j],this.mCurrentBase.value * OFFSET_Y[j]);
                  j++;
               }
               for(k = 1; k <= this.mCurrentBase.value; )
               {
                  this.distributeDiagonals(this.mCurrentBase.value,k);
                  if(k < this.mCurrentBase.value)
                  {
                     this.distributeDiagonals(k,this.mCurrentBase.value);
                  }
                  k++;
               }
               this.mCurrentBase.value++;
            }
         }
      }
      
      private function distributeAddPoint(x:Number, y:Number) : void
      {
         this.mPositionsX.push(x);
         this.mPositionsY.push(y);
      }
      
      private function distributeDiagonals(coefX:int, coefY:int) : void
      {
         var i:int = 0;
         for(i = 4; i < OFFSET_LENGTH; )
         {
            this.distributeAddPoint(OFFSET_X[i] * coefX,OFFSET_Y[i] * coefY);
            i++;
         }
      }
      
      public function unitAddToScene(u:MyUnit, enterMode:int, timeToWait:int = 0) : void
      {
         if(enterMode == 3 && !u.mDef.isTerrainUnit())
         {
            enterMode = 0;
         }
         u.enterSceneStart(enterMode);
         this.sceneAddUnit(u,timeToWait);
      }
      
      private function wavesLoad() : void
      {
         this.mWavesUnits = new Vector.<MyUnit>(0);
         this.mWavesTypesCount = new Vector.<int>(this.WAVES_UNITS_TYPES_COUNT);
         this.mWavesTypesCurrentId = new Vector.<int>(this.WAVES_UNITS_TYPES_COUNT);
         this.distributeLoad();
      }
      
      private function wavesUnload() : void
      {
         this.mWavesUnits = null;
         this.mWavesTypesCount = null;
         this.distributeUnload();
      }
      
      private function wavesUnbuild() : void
      {
         this.mWavesUnits.length = 0;
         this.wavesTypesReset();
      }
      
      private function wavesTypesReset() : void
      {
         var i:int = 0;
         for(i = 0; i < this.WAVES_UNITS_TYPES_COUNT; )
         {
            this.mWavesTypesCount[i] = 0;
            i++;
         }
      }
      
      public function wavesGetStringFromAttack(unitsCount:int, sku:String, upgradeId:int, hangarId:String = null) : String
      {
         var returnValue:String = unitsCount + ":" + sku + ":" + upgradeId;
         if(hangarId != null)
         {
            returnValue += ":" + hangarId;
         }
         return returnValue;
      }
      
      public function wavesGetAttackFromString(attack:String, serverFormat:Boolean = false) : Object
      {
         var tokens:Array = attack.split(":");
         var returnValue:Object = {
            "amount":tokens[0],
            "sku":tokens[1]
         };
         if(serverFormat)
         {
            returnValue.hangarSid = int(tokens[3]);
         }
         else
         {
            returnValue.upgradeId = tokens.legth < 3 ? 0 : int(tokens[2]);
            returnValue.hangarSid = tokens[3];
         }
         return returnValue;
      }
      
      public function wavesCreateAttackWave(wave:String, positionX:int, positionY:int, faction:int = 0, enterMode:int = 3, notifyServer:Boolean = false) : Vector.<MyUnit>
      {
         var mng:int = faction == 0 ? 1 : 2;
         this.wavesCreateWaveFromString(wave,faction,mng,"unitGoalGenAttack",null,positionX,positionY,enterMode,notifyServer);
         if(this.mBattleMode.value == 0 && faction == 0 && !this.replayIsEnabled())
         {
            InstanceMng.getTargetMng().updateProgress("launchAttack",1);
         }
         return this.mWavesUnits;
      }
      
      public function wavesCreateReturnedArmyWave(wave:String, positionX:int, positionY:int, item:WorldItemObject = null, pGoalFor:String = null) : Vector.<MyUnit>
      {
         if(pGoalFor == null)
         {
            pGoalFor = "unitGoalForReturnToHangar";
         }
         this.wavesCreateWaveFromString(wave,1,2,"unitGoalGoToItem",{
            "goalFor":pGoalFor,
            "itemTo":item
         },positionX,positionY);
         return this.mWavesUnits;
      }
      
      private function wavesCreateSquads(def:UnitDef, decomposeSquad:Boolean, unitType:String, waveParams:Object, uniqueSku:String, params:Array) : void
      {
         var squad:Squad = null;
         var unitsThisSquad:Vector.<MyUnit> = null;
         var i:int = 0;
         var count:int = 0;
         var u:MyUnit = null;
         var squadDef:SquadDef = null;
         var wave:String = null;
         var shotPriorityTarget:String = null;
         var faction:int = int(params[0]);
         var mngToNotifyId:int = int(params[1]);
         var goal:String = String(params[2]);
         var goalParams:Object = params[3];
         var positionX:int = int(params[4]);
         var positionY:int = int(params[5]);
         var enterMode:int = int(params[6]);
         var notifyServer:Boolean = Boolean(params[7]);
         var unitsSquads:Vector.<MyUnit> = params[8];
         var leftWaves:Vector.<String> = params[9];
         if(def.isASquad())
         {
            count = int(waveParams.amount);
            wave = (squadDef = SquadDef(def)).getWave();
            shotPriorityTarget = squadDef.getShotPriorityTarget();
            for(i = 0; i < count; )
            {
               squad = new Squad();
               unitsThisSquad = this.wavesCreateSingleWaveFromString(wave,faction,mngToNotifyId,goal,goalParams,positionX,positionY,enterMode,notifyServer);
               squad.joinUnits(unitsThisSquad,shotPriorityTarget);
               this.squadsAddSquad(squad);
               for each(u in unitsThisSquad)
               {
                  unitsSquads.push(u);
               }
               this.mWavesUnits.length = 0;
               i++;
            }
         }
         else
         {
            leftWaves.push(unitType);
         }
      }
      
      private function wavesCreateWaveFromString(wave:String, faction:int = -1, mngToNotifyId:int = -2, goal:String = null, goalParams:Object = null, positionX:int = 2147483647, positionY:int = 2147483647, enterMode:int = 3, notifyServer:Boolean = false) : void
      {
         var unitType:String = null;
         var u:MyUnit = null;
         var unitsSquads:Vector.<MyUnit> = new Vector.<MyUnit>(0);
         var leftWaves:Vector.<String> = new Vector.<String>(0);
         this.wavesApplyFunctionToWaveString(wave,true,this.wavesCreateSquads,faction,mngToNotifyId,goal,goalParams,positionX,positionY,enterMode,notifyServer,unitsSquads,leftWaves);
         wave = "";
         for each(unitType in leftWaves)
         {
            wave += unitType + ",";
         }
         if(wave != "")
         {
            this.wavesCreateSingleWaveFromString(wave,faction,mngToNotifyId,goal,goalParams,positionX,positionY,enterMode,notifyServer);
         }
         if(unitsSquads != null)
         {
            for each(u in unitsSquads)
            {
               this.mWavesUnits.push(u);
            }
         }
      }
      
      private function wavesCreateSingleWaveFromString(wave:String, faction:int = -1, mngToNotifyId:int = -2, goal:String = null, goalParams:Object = null, positionX:int = 2147483647, positionY:int = 2147483647, enterMode:int = 3, notifyServer:Boolean = false) : Vector.<MyUnit>
      {
         var i:int = 0;
         var u:MyUnit = null;
         var typeId:int = 0;
         var currentId:int = 0;
         var itemFrom:WorldItemObject = null;
         var sid:String = null;
         var tileIndex:int = 0;
         var coor:DCCoordinate = null;
         this.wavesTypesReset();
         this.wavesGetUnitsFromString(wave,faction,true,notifyServer);
         if(positionX < 2147483647)
         {
            for(i = 0; i < this.WAVES_UNITS_TYPES_COUNT; )
            {
               this.distributePoints(this.mWavesTypesCount[i]);
               i++;
            }
         }
         var unitsCount:int = int(this.mWavesUnits.length);
         var origPositionX:* = positionX;
         var origPositionY:* = positionY;
         if(enterMode == 4)
         {
            sid = String(this.wavesGetAttackFromString(wave).hangarSid);
            if((itemFrom = InstanceMng.getWorld().itemsGetItemBySid(sid)) != null)
            {
               tileIndex = InstanceMng.getWorldItemDefMng().getTileIndexToGo(itemFrom);
               coor = MyUnit.smCoor;
               if(tileIndex > -1)
               {
                  smViewMng.tileIndexToWorldViewPos(tileIndex,coor);
                  positionX = coor.x;
                  positionY = coor.y;
               }
            }
         }
         var timeToWait:int = 0;
         var radius:Number = Number(WAVES_UNITS_TYPES_RADIUS[typeId]);
         for(i = 0; i < unitsCount; )
         {
            typeId = (u = this.mWavesUnits[i]).mDef.isTerrainUnit() ? this.WAVES_UNITS_TYPES_TERRAIN_ID : this.WAVES_UNITS_TYPES_AIR_ID;
            if(itemFrom == null && positionX < 2147483647)
            {
               currentId = --this.mWavesTypesCount[typeId];
               positionX = origPositionX + this.mPositionsX[currentId] * radius;
               positionY = origPositionY + this.mPositionsY[currentId] * radius;
            }
            this.unitsSetupUnit(u,mngToNotifyId,goal,goalParams,positionX,positionY);
            if(enterMode != -1)
            {
               if(enterMode == 4)
               {
                  timeToWait += 500;
               }
               this.unitAddToScene(u,enterMode,timeToWait);
            }
            i++;
         }
         return this.mWavesUnits;
      }
      
      public function waveAddToScene(wave:Vector.<MyUnit>, enterMode:int = 3) : void
      {
         var u:MyUnit = null;
         var timeToWait:int = 0;
         for each(u in wave)
         {
            if(enterMode == 4)
            {
               timeToWait += 500;
            }
            this.unitAddToScene(u,enterMode,timeToWait);
         }
      }
      
      public function waveAddBulletsToScene(bulletTypes:Array, launchX:int, launchY:int, specialAttackId:int) : Vector.<MyUnit>
      {
         var bulletType:String = null;
         var customView:Boolean = false;
         var u:MyUnit = null;
         var addToScene:Boolean = false;
         var goalParams:Object = null;
         var viewComponent:UnitViewCustom = null;
         var su:SoundUtil = null;
         var umbrellaMng:UmbrellaMng = null;
         var returnValue:Vector.<MyUnit> = new Vector.<MyUnit>(0);
         var checkUmbrella:Boolean = false;
         for each(bulletType in bulletTypes)
         {
            customView = true;
            switch(bulletType)
            {
               case "sa_nuke_01":
               case "sa_nuke_02":
                  customView = false;
                  checkUmbrella = Config.useUmbrella() && bulletType == "sa_nuke_01";
            }
            u = this.unitsCreateUnit(bulletType,3,0,customView,specialAttackId);
            addToScene = true;
            switch(bulletType)
            {
               case "sa_rocket":
                  this.unitsSetupUnit(u,1,"unitGoalSpecialAttackRocket",null,launchX,launchY);
                  break;
               case "sa_freeze":
                  this.unitsSetupUnit(u,1,"unitGoalSpecialAttackFreeze",null,launchX,launchY);
                  break;
               case "sa_catapult":
                  this.unitsSetupUnit(u,1,"unitGoalSpecialAttackCatapult",null,launchX,launchY);
                  break;
               case "sa_nuke_01":
               case "sa_nuke_02":
                  this.unitsSetupUnit(u,-1,null,null,launchX,launchY);
                  goalParams = {
                     "affectsArea":true,
                     "hasExploded":true
                  };
                  this.bulletsShoot(bulletType,u.mDef.getShotDamage(),"unitGoalImpact",goalParams,u,null,0,false,false);
                  addToScene = false;
            }
            if(addToScene)
            {
               returnValue.push(u);
               if((viewComponent = u.getViewComponent() as UnitViewCustom) != null)
               {
                  viewComponent.setLoopMode(false);
               }
               if(bulletType == "sa_catapult")
               {
                  viewComponent.setFrameRate(0);
               }
               this.sceneAddUnit(u);
               (su = new SoundUtil()).startRandomLoop("explode.mp3",3000,300,500);
            }
            if(checkUmbrella)
            {
               if((umbrellaMng = InstanceMng.getUmbrellaMng()).isUnitProtected(u,false))
               {
                  umbrellaMng.absorbNukeDamage(u);
               }
            }
         }
         return returnValue;
      }
      
      public function wavesGetUnitDefsFromString(wave:String, decomposeSquad:Boolean, list:Vector.<UnitDef>, amounts:Vector.<int> = null) : void
      {
         var listTemp:Vector.<UnitDef> = null;
         var unitDef:UnitDef = null;
         var pos:int = 0;
         this.wavesApplyFunctionToWaveString(wave,decomposeSquad,this.wavesPushUnitDef,list);
         if(amounts != null)
         {
            listTemp = list.concat();
            list.length = 0;
            amounts.length = 0;
            for each(unitDef in listTemp)
            {
               if((pos = list.indexOf(unitDef)) == -1)
               {
                  list.push(unitDef);
                  amounts.push(1);
               }
               else
               {
                  amounts[pos]++;
               }
            }
         }
      }
      
      private function wavesPushUnitDef(def:UnitDef, decomposeSquad:Boolean, unitType:String, waveParams:Object, uniqueSku:String, params:Array) : void
      {
         var i:int = 0;
         var list:Vector.<UnitDef> = params[0];
         var count:int = int(waveParams.amount);
         for(i = 0; i < count; )
         {
            if(decomposeSquad && def.isASquad())
            {
               this.wavesGetUnitDefsFromString(SquadDef(def).getWave(),true,list);
            }
            else
            {
               list.push(def);
            }
            i++;
         }
      }
      
      private function wavesApplyFunctionToWaveString(wave:String, decomposeSquad:Boolean, func:Function, ... params) : void
      {
         var waveParams:Object = null;
         var i:int = 0;
         var unitType:String = null;
         var count:int = 0;
         var sku:String = null;
         var upgradeId:int = 0;
         var uniqueSku:String = null;
         var defMng:DCDefMng = null;
         var def:UnitDef = null;
         var unitsTypes:Array = wave.split(",");
         for each(unitType in unitsTypes)
         {
            count = int((waveParams = this.wavesGetAttackFromString(unitType,false)).amount);
            sku = String(waveParams.sku);
            upgradeId = int(waveParams.upgradeId);
            uniqueSku = UnitDef.getIdFromSkuAndUpgradeId(sku,upgradeId);
            if((def = this.unitsGetUnitDefFromUniqueSku(uniqueSku)) != null)
            {
               func(def,decomposeSquad,unitType,waveParams,uniqueSku,params);
            }
         }
      }
      
      private function wavesGetUnitsFromString(wave:String, faction:int, decomposeSquad:Boolean, notifyServer:Boolean = false) : void
      {
         this.mWavesUnits.length = 0;
         if(notifyServer)
         {
            this.serverWaveClear();
         }
         this.wavesApplyFunctionToWaveString(wave,decomposeSquad,this.wavesGetUnitsFromDef,faction,notifyServer);
      }
      
      private function wavesGetUnitsFromDef(def:UnitDef, decomposeSquad:Boolean, unitType:String, waveParams:Object, uniqueSku:String, params:Array) : void
      {
         var typeId:int = 0;
         var unit:MyUnit = null;
         var faction:int = 0;
         var notifyServer:Boolean = false;
         var typeSpawnId:int = 0;
         var i:int = 0;
         var count:int = 0;
         var sku:String = null;
         if(def != null)
         {
            typeId = def.getUnitTypeId();
            faction = int(params[0]);
            notifyServer = Boolean(params[1]);
            count = int(waveParams.amount);
            sku = String(waveParams.sku);
            for(i = 0; i < count; )
            {
               unit = this.unitsCreateUnit(uniqueSku,typeId,faction);
               this.mWavesUnits.push(unit);
               if(notifyServer)
               {
                  this.serverAddUnitId(waveParams.hangarSid,sku,unit.mId,unit);
               }
               typeSpawnId = unit.mDef.isTerrainUnit() ? this.WAVES_UNITS_TYPES_TERRAIN_ID : this.WAVES_UNITS_TYPES_AIR_ID;
               this.mWavesTypesCount[typeSpawnId]++;
               i++;
            }
         }
      }
      
      private function senseEnvironmentReset(u:MyUnit) : Boolean
      {
         var pos:Vector3D = null;
         var alreadyTargetUnitIsValid:Boolean = false;
         var captain:MyUnit = null;
         var captainIsAlive:Boolean = false;
         var nearestShotableUnit:MyUnit = null;
         var alreadyTargetUnit:MyUnit = null;
         var attractsEnemies:Boolean = false;
         u.mData[2] = -1;
         u.mData[1] = null;
         if(u.isLookingForATargetEnabled())
         {
            u.mData[4] = -1;
            u.mData[3] = null;
         }
         u.mData[6] = -1;
         u.mData[5] = null;
         u.mData[8] = -1;
         u.mData[7] = null;
         u.mRefreshEnvironment = false;
         if(u.isLookingForATargetEnabled())
         {
            pos = u.mPosition;
            alreadyTargetUnitIsValid = true;
            if(captainIsAlive = (captain = u.mData[37]) != null && captain.getIsAlive())
            {
               if((nearestShotableUnit = captain.mData[3]) != null && nearestShotableUnit.shotCanBeATarget())
               {
                  this.setNearestUnit(u,nearestShotableUnit,DCMath.distanceSqr(u.mPosition,nearestShotableUnit.mPosition),false,true,true);
                  alreadyTargetUnitIsValid = false;
               }
            }
            if(alreadyTargetUnitIsValid)
            {
               alreadyTargetUnitIsValid = (alreadyTargetUnit = u.mData[13]) != null && alreadyTargetUnit.shotCanBeATarget();
               if(alreadyTargetUnitIsValid)
               {
                  if(attractsEnemies = alreadyTargetUnit.mDef.isAnEnemyAttractor())
                  {
                     if(!alreadyTargetUnit.mDef.isHappeningOnly() || InstanceMng.getFlowStatePlanet().getCurrentRoleId() == 0)
                     {
                        this.setNearestUnit(u,alreadyTargetUnit,DCMath.distanceSqr(pos,alreadyTargetUnit.mPosition),alreadyTargetUnit.mDef.isABuilding(),true,true);
                     }
                  }
                  else if(u.mDef.isInsistOnTargetOn())
                  {
                     u.mData[3] = alreadyTargetUnit;
                     u.mData[4] = DCMath.distanceSqr(pos,alreadyTargetUnit.mPosition);
                  }
               }
            }
         }
         return u.mData[3] == null;
      }
      
      private function senseEnvironmentCanSenseUnit(u:MyUnit, v:MyUnit) : Boolean
      {
         if(v.mDef.isTerrainUnit())
         {
            return u.mDef.getAttackGroundUnits();
         }
         return u.mDef.getAttackAirUnits();
      }
      
      private function senseEnvironmentCanSenseSceneType(u:MyUnit, sceneTypeId:int) : Boolean
      {
         var unitTypeId:int = int(GameConstants.SCENE_UNIT_TYPE_TO_UNIT_TYPE[sceneTypeId]);
         if(GameConstants.UNIT_TYPE_IS_TERRAIN[unitTypeId])
         {
            return u.mDef.getAttackGroundUnits();
         }
         return u.mDef.getAttackAirUnits();
      }
      
      private function senseEnvironmentGetBuildingsList(shotPriorityKey:String) : Vector.<MyUnit>
      {
         var listId:int = Config.useOptSenseWalls() && shotPriorityKey == "walls" && this.mSceneUnits[7].length > 0 ? 7 : 6;
         return this.mSceneUnits[listId];
      }
      
      private function senseEnvironment(u:MyUnit, listId:int) : void
      {
         var doSense:Boolean = false;
         var def:UnitDef = null;
         var happeningSku:String = null;
         var goal:GoalMine = null;
         var senseSoldiers:Boolean = false;
         var senseMechas:Boolean = false;
         var senseShips:Boolean = false;
         var unitsWithPriority:Boolean = false;
         var needsToCheckShoot:Boolean = this.senseEnvironmentReset(u);
         var shotPriorityKey:String = u.getShotPriorityTarget();
         switch(listId - 2)
         {
            case 0:
               this.senseEnvironmentGetNearest(u,this.mSceneUnits[2],shotPriorityKey,false);
               if(needsToCheckShoot)
               {
                  this.senseEnvironmentGetNearest(u,this.senseEnvironmentGetBuildingsList(shotPriorityKey),shotPriorityKey,true);
                  this.senseEnvironmentGetNearest(u,this.mSceneUnits[3],shotPriorityKey,this.senseEnvironmentCanSenseSceneType(u,3));
                  if(this.senseEnvironmentCanSenseSceneType(u,11))
                  {
                     this.senseEnvironmentGetNearest(u,this.mSceneUnits[11],shotPriorityKey,true);
                  }
                  if(this.senseEnvironmentCanSenseSceneType(u,9))
                  {
                     this.senseEnvironmentGetNearest(u,this.mSceneUnits[9],shotPriorityKey,true);
                  }
               }
               break;
            case 1:
               if(needsToCheckShoot)
               {
                  this.senseEnvironmentGetNearest(u,this.mSceneUnits[2],shotPriorityKey,this.senseEnvironmentCanSenseSceneType(u,2));
                  if(this.senseEnvironmentCanSenseSceneType(u,10))
                  {
                     this.senseEnvironmentGetNearest(u,this.mSceneUnits[10],shotPriorityKey,true);
                  }
                  if(this.senseEnvironmentCanSenseSceneType(u,8))
                  {
                     this.senseEnvironmentGetNearest(u,this.mSceneUnits[8],shotPriorityKey,true);
                  }
               }
               this.senseEnvironmentGetNearest(u,this.mSceneUnits[3],shotPriorityKey,false);
               break;
            case 2:
               this.senseEnvironmentGetNearest(u,this.mSceneUnits[6],shotPriorityKey,false);
               this.senseEnvironmentGetNearest(u,this.mSceneUnits[7],shotPriorityKey,false);
               this.senseEnvironmentGetNearest(u,this.mSceneUnits[3],shotPriorityKey,false);
               this.senseEnvironmentGetNearest(u,this.mSceneUnits[9],shotPriorityKey,false);
               this.senseEnvironmentGetNearest(u,this.mSceneUnits[11],shotPriorityKey,false);
               break;
            case 3:
               this.senseEnvironmentGetNearest(u,this.mSceneUnits[2],shotPriorityKey,false);
               this.senseEnvironmentGetNearest(u,this.mSceneUnits[8],shotPriorityKey,false);
               this.senseEnvironmentGetNearest(u,this.mSceneUnits[10],shotPriorityKey,false);
               break;
            case 4:
               doSense = true;
               def = u.mDef;
               if(smHappeningMng != null)
               {
                  if((happeningSku = def.getHappeningSku()) != null && this.mBattleHappeningSku.value != happeningSku && !smHappeningMng.isHappeningSkuOver(happeningSku))
                  {
                     doSense = false;
                  }
               }
               doSense = true;
               if(def.isAMine() && def.isHappeningOnly() && InstanceMng.getFlowStatePlanet().getCurrentRoleId() != 0)
               {
                  doSense = false;
               }
               if(!(!doSense || !needsToCheckShoot))
               {
                  if(def.getAttackAirUnits())
                  {
                     if(u.mDef.isAMine())
                     {
                        goal = GoalMine(u.getGoalComponent());
                        senseShips = true;
                        if(goal != null && !goal.hasBeenActivated())
                        {
                           senseShips = u.mDef.canBeActivatedBy("ships");
                        }
                        if(senseShips)
                        {
                           this.senseEnvironmentGetNearest(u,this.mSceneUnits[2],shotPriorityKey);
                        }
                     }
                     this.senseEnvironmentGetFastestShoot(u,this.mSceneUnits[2],true);
                  }
                  if(u.mDef.getAttackGroundUnits())
                  {
                     if(u.mDef.isAMine())
                     {
                        goal = GoalMine(u.getGoalComponent());
                        senseSoldiers = true;
                        senseMechas = true;
                        if(goal != null && !goal.hasBeenActivated())
                        {
                           senseSoldiers = u.mDef.canBeActivatedBy("soldiers");
                           senseMechas = u.mDef.canBeActivatedBy("mechas");
                        }
                        if(senseSoldiers)
                        {
                           this.senseEnvironmentGetNearest(u,this.mSceneUnits[8],shotPriorityKey);
                        }
                        if(senseMechas)
                        {
                           this.senseEnvironmentGetNearest(u,this.mSceneUnits[10],shotPriorityKey);
                        }
                     }
                     else
                     {
                        this.senseEnvironmentGetFastestShoot(u,this.mSceneUnits[8],true);
                        this.senseEnvironmentGetFastestShoot(u,this.mSceneUnits[10],true);
                     }
                  }
               }
               break;
            case 6:
            case 8:
               if(needsToCheckShoot && u.isLookingForATargetEnabled())
               {
                  unitsWithPriority = false;
                  this.senseEnvironmentGetNearest(u,this.senseEnvironmentGetBuildingsList(shotPriorityKey),shotPriorityKey,true);
                  if(this.senseEnvironmentCanSenseSceneType(u,9))
                  {
                     this.senseEnvironmentGetNearest(u,this.mSceneUnits[9],shotPriorityKey,true,false,unitsWithPriority);
                  }
                  if(this.senseEnvironmentCanSenseSceneType(u,11))
                  {
                     this.senseEnvironmentGetNearest(u,this.mSceneUnits[11],shotPriorityKey,true,false,unitsWithPriority);
                  }
                  if(this.senseEnvironmentCanSenseSceneType(u,3))
                  {
                     this.senseEnvironmentGetNearest(u,this.mSceneUnits[3],shotPriorityKey,true,false,unitsWithPriority);
                  }
               }
               this.senseEnvironmentGetNearest(u,this.mSceneUnits[8],shotPriorityKey,false);
               this.senseEnvironmentGetNearest(u,this.mSceneUnits[10],shotPriorityKey,false);
               break;
            case 7:
            case 9:
               this.senseEnvironmentGetNearest(u,this.mSceneUnits[9],shotPriorityKey,false);
               this.senseEnvironmentGetNearest(u,this.mSceneUnits[11],shotPriorityKey,false);
         }
      }
      
      public function senseEnvironmentGetLists(u:MyUnit, uFrom:MyUnit) : Vector.<Vector.<MyUnit>>
      {
         this.mSenseEnvironmentListsTemp.length = 0;
         if(u.getTypeId() == 3)
         {
            if(u.mFaction == 1)
            {
               if(this.senseEnvironmentCanSenseSceneType(uFrom,8))
               {
                  this.mSenseEnvironmentListsTemp.push(this.mSceneUnits[8]);
               }
               if(this.senseEnvironmentCanSenseSceneType(uFrom,10))
               {
                  this.mSenseEnvironmentListsTemp.push(this.mSceneUnits[10]);
               }
               if(this.senseEnvironmentCanSenseSceneType(uFrom,2))
               {
                  this.mSenseEnvironmentListsTemp.push(this.mSceneUnits[2]);
               }
            }
            else
            {
               if(this.senseEnvironmentCanSenseSceneType(uFrom,6))
               {
                  this.mSenseEnvironmentListsTemp.push(this.mSceneUnits[6]);
               }
               if(this.senseEnvironmentCanSenseSceneType(uFrom,7))
               {
                  this.mSenseEnvironmentListsTemp.push(this.mSceneUnits[7]);
               }
               if(this.senseEnvironmentCanSenseSceneType(uFrom,9))
               {
                  this.mSenseEnvironmentListsTemp.push(this.mSceneUnits[9]);
               }
               if(this.senseEnvironmentCanSenseSceneType(uFrom,11))
               {
                  this.mSenseEnvironmentListsTemp.push(this.mSceneUnits[11]);
               }
               if(this.senseEnvironmentCanSenseSceneType(uFrom,3))
               {
                  this.mSenseEnvironmentListsTemp.push(this.mSceneUnits[3]);
               }
               if(u.mDef.canAttackOwnUnits())
               {
                  this.mSenseEnvironmentListsTemp.push(this.mSceneUnits[8]);
                  this.mSenseEnvironmentListsTemp.push(this.mSceneUnits[10]);
                  this.mSenseEnvironmentListsTemp.push(this.mSceneUnits[2]);
               }
            }
         }
         return this.mSenseEnvironmentListsTemp;
      }
      
      private function senseEnvironmentGetNearest(u:MyUnit, list:Vector.<MyUnit>, shotPriorityKey:String, shoot:Boolean = false, checkAttackTo:Boolean = false, useWithMaxPriority:Boolean = false) : void
      {
         var v:MyUnit = null;
         var check:Boolean = false;
         var distanceSqr:Number = NaN;
         var minDistanceSqr:* = NaN;
         var nearestUnit:* = null;
         var minShotableDistanceSqr:* = NaN;
         var nearestShotableUnit:* = null;
         var vPriorityType:int = 0;
         var vPriorityKey:String = null;
         var uType:int = 0;
         var isBuilding:Boolean = false;
         if(list != null && list.length > 0)
         {
            if(MyUnit(list[0]).mDef.isABuilding())
            {
               minDistanceSqr = Number(u.mData[6]);
               nearestUnit = u.mData[5];
               isBuilding = true;
            }
            else
            {
               minDistanceSqr = Number(u.mData[8]);
               nearestUnit = u.mData[7];
            }
         }
         if(shoot)
         {
            minShotableDistanceSqr = Number(u.mData[4]);
            nearestShotableUnit = u.mData[3];
         }
         var nearestShotableUnitPriorityType:* = nearestShotableUnit == null ? 2147483647 : this.unitsGetShootPriorityType(nearestShotableUnit);
         var priorityType:int = int(this.mUnitsPriorities[shotPriorityKey]);
         var checkPriorityTypes:* = shotPriorityKey != "anything";
         var pos:Vector3D = u.mPosition;
         var isTarget:* = false;
         for each(v in list)
         {
            if((check = v != u && v.mIsAlive) && checkAttackTo)
            {
               shoot = this.senseEnvironmentCanSenseUnit(u,v);
            }
            if(check)
            {
               uType = u.getTypeId();
               if(shoot || uType == 3)
               {
                  check = v.shotCanBeATarget();
               }
            }
            if(check)
            {
               distanceSqr = DCMath.distanceSqr(pos,v.mPosition);
               if(!(shoot && v.mDef.isAnEnemyAttractor()))
               {
                  if(minDistanceSqr == -1 || distanceSqr < minDistanceSqr)
                  {
                     nearestUnit = v;
                     minDistanceSqr = distanceSqr;
                  }
                  if(shoot)
                  {
                     vPriorityKey = this.unitsGetShootPriorityKey(v);
                     if(!Config.useOptSenseWalls() && vPriorityKey == "walls")
                     {
                        if(shotPriorityKey != vPriorityKey)
                        {
                           continue;
                        }
                        checkPriorityTypes = false;
                     }
                     if(checkPriorityTypes)
                     {
                        if(shotPriorityKey == "walls" && shotPriorityKey != vPriorityKey)
                        {
                           isTarget = distanceSqr < minShotableDistanceSqr;
                        }
                        else if(useWithMaxPriority)
                        {
                           isTarget = nearestShotableUnit.getTypeId() != v.getTypeId() || distanceSqr < minShotableDistanceSqr;
                        }
                        else
                        {
                           isTarget = (vPriorityType = int(this.mUnitsPriorities[vPriorityKey])) == priorityType && nearestShotableUnitPriorityType != priorityType || (nearestShotableUnitPriorityType != priorityType && vPriorityType < nearestShotableUnitPriorityType || nearestShotableUnitPriorityType == vPriorityType && distanceSqr < minShotableDistanceSqr);
                        }
                     }
                     else
                     {
                        isTarget = distanceSqr < minShotableDistanceSqr;
                     }
                     if(minShotableDistanceSqr == -1 || isTarget)
                     {
                        nearestShotableUnit = v;
                        minShotableDistanceSqr = distanceSqr;
                        if(checkPriorityTypes)
                        {
                           nearestShotableUnitPriorityType = vPriorityType;
                        }
                     }
                  }
               }
            }
         }
         this.setNearestUnit(u,nearestUnit,minDistanceSqr,isBuilding,false,false);
         if(shoot && nearestShotableUnit != null)
         {
            u.mData[3] = nearestShotableUnit;
            u.mData[4] = minShotableDistanceSqr;
         }
      }
      
      private function setNearestUnit(u:MyUnit, nearestUnit:MyUnit, distanceSqr:Number, isBuilding:Boolean, shoot:Boolean, force:Boolean) : void
      {
         if(nearestUnit == null)
         {
            return;
         }
         if(isBuilding)
         {
            u.mData[5] = nearestUnit;
            u.mData[6] = distanceSqr;
         }
         else
         {
            u.mData[7] = nearestUnit;
            u.mData[8] = distanceSqr;
         }
         if(force || u.mData[2] == -1 || distanceSqr < u.mData[2])
         {
            u.mData[1] = nearestUnit;
            u.mData[2] = distanceSqr;
            if(force && u.mData[13] != nearestUnit)
            {
               u.mData[13] = nearestUnit;
               u.sendEvent("unitGoalTargetHasChanged");
            }
         }
         if(shoot)
         {
            u.mData[3] = nearestUnit;
            u.mData[4] = distanceSqr;
         }
      }
      
      private function senseEnvironmentGetFastestShoot(u:MyUnit, list:Vector.<MyUnit>, noTarget:Boolean, printInfo:Boolean = false) : void
      {
         var checkVTarget:* = false;
         var check:* = false;
         var angle:Number = NaN;
         var distanceSqr:Number = NaN;
         var vTarget:MyUnit = null;
         var useAsNearest:* = false;
         var minDistanceSqr:Number = 6.283185307179586;
         var currentAngle:Number = Number(u.mData[18]);
         var nearestUnit:* = u.mData[1];
         var pos:Vector3D = u.mPosition;
         this.mScenePosDraw.x = u.mPositionDrawX;
         this.mScenePosDraw.y = u.mPositionDrawY;
         var targetSpin:* = -1;
         var alreadyTargetUnit:MyUnit = u.mData[13];
         var slowDown:Boolean = u.mDef.shotEffectsSlowDownIsOn();
         var attractsEnemies:Boolean = u.mDef.isAnEnemyAttractor();
         var looksForMinSpin:Boolean = true;
         var shotDistanceSqr:Number = InstanceMng.getPowerUpMng().unitsGetAmountForActivePowerUpByUnitSkuAndPowerUpType(u.mDef.mSku,1,"turretsExtraRange",u.mDef.getShotDistanceSqr());
         if(alreadyTargetUnit != null)
         {
            distanceSqr = DCMath.distanceSqr(pos,alreadyTargetUnit.mPosition);
         }
         var insistOnTarget:Boolean = !noTarget || this.mIsTutorialRunning.value;
         if(alreadyTargetUnit != null && alreadyTargetUnit.shotCanBeATarget() && distanceSqr < shotDistanceSqr && insistOnTarget && !slowDown)
         {
            this.mSceneEnemyVector.x = alreadyTargetUnit.mPositionDrawX;
            this.mSceneEnemyVector.y = alreadyTargetUnit.mPositionDrawY;
            angle = DCMath.getAngle(this.mScenePosDraw,this.mSceneEnemyVector);
            nearestUnit = alreadyTargetUnit;
            targetSpin = angle;
            looksForMinSpin = false;
         }
         if(looksForMinSpin || attractsEnemies)
         {
            checkVTarget = !slowDown;
            for each(var v in list)
            {
               if(check = v != u && (attractsEnemies || v.shotCanBeATarget()))
               {
                  if(check = (distanceSqr = DCMath.distanceSqr(pos,v.mPosition)) < shotDistanceSqr)
                  {
                     if(attractsEnemies)
                     {
                        if(!u.mDef.isHappeningOnly() || InstanceMng.getFlowStatePlanet().getCurrentRoleId() == 0)
                        {
                           this.setNearestUnit(v,u,distanceSqr,true,true,true);
                        }
                     }
                     if(looksForMinSpin)
                     {
                        this.mSceneEnemyVector.x = v.mPositionDrawX;
                        this.mSceneEnemyVector.y = v.mPositionDrawY;
                        angle = DCMath.getAngle(this.mScenePosDraw,this.mSceneEnemyVector);
                        distanceSqr = Math.abs(angle - currentAngle);
                        if(checkVTarget)
                        {
                           vTarget = v.mData[13];
                        }
                        useAsNearest = distanceSqr < minDistanceSqr || checkVTarget && vTarget == u;
                        if(slowDown && nearestUnit != null)
                        {
                           useAsNearest = v.mSlowDownTime < nearestUnit.mSlowDownTime;
                        }
                        minDistanceSqr = Math.min(minDistanceSqr,distanceSqr);
                        if(useAsNearest)
                        {
                           nearestUnit = v;
                           targetSpin = angle;
                           if(checkVTarget)
                           {
                              checkVTarget = vTarget != u;
                           }
                        }
                     }
                  }
               }
            }
         }
         if(targetSpin != -1 && nearestUnit != null)
         {
            u.mData[3] = nearestUnit;
            u.mData[13] = nearestUnit;
            u.spinSetTargetAngle(targetSpin);
         }
      }
      
      public function senseEnvironmentBunker(u:MyUnit, targets:Vector.<MyUnit>) : void
      {
         var needsToSenseForShooting:Boolean = this.senseEnvironmentReset(u);
         var shotPriorityKey:String = u.getShotPriorityTarget();
         if(needsToSenseForShooting)
         {
            this.senseEnvironmentGetNearest(u,targets,shotPriorityKey,true,true);
         }
         this.senseEnvironmentGetNearest(u,this.mSceneUnits[9],shotPriorityKey,false);
         this.senseEnvironmentGetNearest(u,this.mSceneUnits[11],shotPriorityKey,false);
      }
      
      public function pathFinderRequestPath(whereFrom:Object, whereTo:Object, pUnitDef:UnitDef = null, pReverse:Boolean = false, pCmdOnArrive:String = null, pStepItemFromAllowed:Boolean = false, pStepItemToAllowed:Boolean = false, pItemFrom:WorldItemObject = null) : void
      {
         var bunker:Bunker = null;
         var u:MyUnit = null;
         var coor:DCCoordinate = MyUnit.smCoor;
         var pPriority:int = 0;
         var pItemTo:WorldItemObject = null;
         var indexDest:int = -1;
         if(whereTo is MyUnit)
         {
            u = MyUnit(whereTo);
            coor.x = u.mPosition.x;
            coor.y = u.mPosition.y;
            smViewMng.logicPosToViewPos(coor);
         }
         else if(whereTo is WorldItemObject)
         {
            pItemTo = WorldItemObject(whereTo);
            coor.x = pItemTo.mViewCenterWorldX;
            coor.y = pItemTo.mViewCenterWorldY;
         }
         else if(whereTo.x != null)
         {
            coor.x = whereTo.x;
            coor.y = whereTo.y;
         }
         else
         {
            indexDest = int(whereTo.tileIndex);
         }
         if(indexDest == -1)
         {
            smViewMng.worldViewPosToTileXY(coor);
            indexDest = smMapModel.mMapController.getTileXYToIndex(coor.x,coor.y,true);
         }
         var pRecalculateTileIndexSource:Boolean = false;
         var indexSource:int = -1;
         if(whereFrom is MyUnit)
         {
            u = MyUnit(whereFrom);
            coor.x = u.mPosition.x;
            coor.y = u.mPosition.y;
            smViewMng.logicPosToViewPos(coor);
            pRecalculateTileIndexSource = true;
            if(u.mData[36] == null)
            {
               pPriority = 1;
               u.mData[36] = 0;
            }
            if(u.mData[34] != null && false)
            {
               if((bunker = Bunker(u.mData[34])) != null)
               {
                  pItemFrom = bunker.getWIO();
               }
            }
         }
         else if(whereFrom is WorldItemObject)
         {
            pItemFrom = WorldItemObject(whereFrom);
            coor.x = pItemFrom.mViewCenterWorldX;
            coor.y = pItemFrom.mViewCenterWorldY;
         }
         else if(whereFrom.x != null)
         {
            coor.x = whereFrom.x;
            coor.y = whereFrom.y;
         }
         else
         {
            indexSource = int(whereFrom.tileIndex);
         }
         if(indexSource == -1)
         {
            smViewMng.worldViewPosToTileXY(coor);
            indexSource = smMapModel.mMapController.getTileXYToIndex(coor.x,coor.y,true);
         }
         var pIgnoreItems:Boolean = false;
         if(u != null && u.mFaction == 0 && pItemTo != null)
         {
            pIgnoreItems = true;
         }
         var request:Object = {
            "tileIndexSource":indexSource,
            "tileIndexDest":indexDest,
            "reverse":pReverse,
            "cmdOnArrive":pCmdOnArrive,
            "unit":u,
            "unitDef":pUnitDef,
            "listener":this,
            "itemFrom":pItemFrom,
            "itemTo":pItemTo,
            "stepItemFromAllowed":pStepItemFromAllowed,
            "stepItemToAllowed":pStepItemToAllowed,
            "recalculateTileIndexSource":pRecalculateTileIndexSource,
            "ignoreItems":pIgnoreItems,
            "priority":pPriority
         };
         smMapModel.pathFinderRequestPath(request);
      }
      
      override public function notify(e:Object) : Boolean
      {
         var u:MyUnit = null;
         var setAtFirstPosition:* = false;
         var def:UnitDef = null;
         var goal:UnitComponentGoal = null;
         var returnValue:Boolean = true;
         var _loc7_:* = e.cmd;
         if("MapModelEventPathResolved" !== _loc7_)
         {
            returnValue = false;
         }
         else
         {
            u = e.unit;
            setAtFirstPosition = false;
            if((def = u != null ? u.mDef : e.unitDef) != null)
            {
               setAtFirstPosition = u == null;
               switch(def.getUnitTypeId())
               {
                  case 0:
                     setAtFirstPosition = !u.mSecureIsInScene.value;
                     break;
                  case 1:
                     break;
                  case 8:
                     setAtFirstPosition = !u.movementIsFollowingAPath();
               }
            }
            if(e.stepItemFromAllowed)
            {
               e.itemFrom = null;
            }
            if(e.stepItemToAllowed)
            {
               e.itemTo = null;
            }
            if(!(u.getMovementComponent().isStopped() && def.getUnitTypeId() == 1))
            {
               u.getMovementComponent().followPathFromRaw(e.path,e.tileIndexDest,e.complete,!e.reverse,setAtFirstPosition,e.cmdOnArrive,e.itemFrom,e.itemTo);
               goal = u.getGoalComponent();
               if(goal != null)
               {
                  goal.moveFollowPath();
               }
            }
         }
         return returnValue;
      }
      
      public function quickAttackNotifyNoTargetFound() : void
      {
         if(this.mBattleTimeMode.value == 1)
         {
            this.battleCountdownResume();
         }
      }
      
      public function quickAttackNotifyAskForTarget() : void
      {
         if(this.mBattleTimeMode.value == 1)
         {
            this.battleCountdownPause();
         }
      }
      
      public function quickAttackStartActualBattle() : void
      {
         this.battleStartActualBattle();
      }
      
      public function isDeployingInProgress() : Boolean
      {
         var i:int = 0;
         var currentDeployment:UnitsDeployment = null;
         for(i = 0; i < 16; )
         {
            currentDeployment = this.mDeployUnits[i];
            if(currentDeployment != null)
            {
               if(currentDeployment.getIsWaveLaunched())
               {
                  return true;
               }
            }
            i++;
         }
         return false;
      }
      
      public function startDeployUnits(x:Number, y:Number, waveToDeploy:String = "", deployType:int = -1, deployParams:Object = null, waitForTheCamera:Boolean = false, deployWay:String = "warpGate") : void
      {
         var currentDeployment:UnitsDeployment = null;
         var i:int = 0;
         var found:Boolean = false;
         var attack:SpecialAttack = null;
         switch(deployWay)
         {
            case "warpGate":
               found = false;
               i = 0;
               while(i < 16 && !found)
               {
                  if((currentDeployment = this.mDeployUnits[i]) == null || currentDeployment != null && !currentDeployment.mIsActive)
                  {
                     if(currentDeployment == null)
                     {
                        currentDeployment = new UnitsDeployment();
                     }
                     currentDeployment.startDeployUnits(x,y,waveToDeploy,deployType,deployParams,waitForTheCamera);
                     this.mDeployUnits[i] = currentDeployment;
                     found = true;
                  }
                  i++;
               }
               if(!found)
               {
                  (this.mDeployUnits[0] as UnitsDeployment).forceEnd();
                  for(i = 0; i < 16 - 1; )
                  {
                     (this.mDeployUnits[i] as UnitsDeployment).copyFrom(this.mDeployUnits[i + 1]);
                     i++;
                  }
                  (this.mDeployUnits[16 - 1] as UnitsDeployment).startDeployUnits(x,y,waveToDeploy,deployType,deployParams,waitForTheCamera);
               }
               break;
            case "capsule":
               attack = this.attacksGetCapsuleAttack(0,x,y,waveToDeploy);
               this.attacksAddAttack(attack);
               break;
            case "none":
               this.deployDropUnits(x,y,waveToDeploy,deployType,deployParams);
         }
         if(this.mBattleTimeMode.value == 1)
         {
            this.quickAttackStartActualBattle();
         }
      }
      
      public function deployDropUnits(deployX:int, deployY:int, deployWaveString:String, deployType:int, deployParams:Object) : void
      {
         var unitsDeployed:Vector.<MyUnit> = null;
         var itemTo:WorldItemObject = null;
         var goalFor:String = null;
         var u:MyUnit = null;
         var b:Bunker = null;
         var currentUnit:MyUnit = null;
         var def:ShipDef = null;
         var currLoadedAccId:String = null;
         var armyAttacker:Army = null;
         var notifyServer:Boolean = false;
         var attackOrReturned:Boolean = true;
         switch(deployType)
         {
            case 0:
               notifyServer = true;
               deployWaveString = InstanceMng.getGUIControllerPlanet().getWarBar().getNextDeployWave();
               break;
            case 3:
               attackOrReturned = false;
         }
         if(deployWaveString == null)
         {
            return;
         }
         if(attackOrReturned)
         {
            unitsDeployed = this.wavesCreateAttackWave(deployWaveString,deployX,deployY,0,3,notifyServer);
         }
         else
         {
            itemTo = null;
            goalFor = null;
            if(deployParams != null)
            {
               itemTo = deployParams.itemTo;
               goalFor = String(deployParams.goalFor);
            }
            unitsDeployed = this.wavesCreateReturnedArmyWave(deployWaveString,deployX,deployY,itemTo,goalFor);
            if(itemTo != null && itemTo.mDef.isABunker())
            {
               b = Bunker(InstanceMng.getBunkerController().getFromSid(itemTo.mSid));
               for each(u in unitsDeployed)
               {
                  b.waitForUnit(u);
               }
            }
         }
         switch(deployType)
         {
            case 0:
               currLoadedAccId = InstanceMng.getUserInfoMng().getCurrentProfileLoaded().getAccountId();
               for each(u in unitsDeployed)
               {
                  InstanceMng.getTargetMng().updateProgress("sendUnitsToBattle",1,u.mDef.mSku,currLoadedAccId);
                  InstanceMng.getGUIControllerPlanet().getWarBar().checkReorder(u.mDef.mSku);
               }
               break;
            case 2:
               (armyAttacker = Army(this.getChildrenArmyAttacker())).setRetreatUnitsThreshold(2);
         }
         if(notifyServer)
         {
            this.serverNotifyNewWave(deployX,deployY);
         }
      }
      
      public function deployUnitsReset() : void
      {
         var i:int = 0;
         var currentDeployment:UnitsDeployment = null;
         for(i = 0; i < 16; )
         {
            currentDeployment = this.mDeployUnits[i];
            if(currentDeployment != null)
            {
               currentDeployment.forceEnd();
            }
            i++;
         }
      }
      
      private function deployUnitsUpdate(dt:int) : void
      {
         var i:int = 0;
         var currentDeployment:UnitsDeployment = null;
         for(i = 0; i < 16; )
         {
            currentDeployment = this.mDeployUnits[i];
            if(currentDeployment != null && currentDeployment.mIsActive)
            {
               currentDeployment.deployLogicUpdate(dt);
            }
            i++;
         }
      }
      
      public function deployHasWaveBeenLaunched() : Boolean
      {
         if(this.mDeployUnits != null && this.mDeployUnits[0] != null)
         {
            return this.mDeployUnits[0].getIsWaveLaunched();
         }
         return false;
      }
      
      public function getChildrenArmyAttacker() : DCComponent
      {
         return mChildren[1];
      }
      
      public function translateSingleUnitRequestToString(unitDef:UnitDef, hangarId:String, comesFromHangar:Boolean) : String
      {
         if(!comesFromHangar)
         {
            hangarId = "i" + hangarId;
         }
         return this.wavesGetStringFromAttack(1,unitDef.mSku,unitDef.getUpgradeId(),hangarId) + ",";
      }
      
      public function translateUnitsRequestToString(units:Vector.<Array>, hangarController:HangarController) : String
      {
         var amount:int = 0;
         var hangarIds:Array = null;
         var hangarId:String = null;
         var returnValue:String = null;
         var type:Array = null;
         var unitsToSpawn:int = 0;
         var lastHangarId:* = null;
         var unitDef:UnitDef = null;
         returnValue = "";
         lastHangarId = null;
         for each(type in units)
         {
            unitDef = type[2];
            unitsToSpawn = 0;
            hangarIds = type[1].split(",");
            for(amount = 0; amount < type[3]; )
            {
               hangarId = hangarIds.shift();
               if(amount == 0)
               {
                  lastHangarId = hangarId;
               }
               if(hangarId != lastHangarId)
               {
                  returnValue += this.wavesGetStringFromAttack(unitsToSpawn,unitDef.mSku,unitDef.getUpgradeId(),lastHangarId) + ",";
                  unitsToSpawn = 0;
               }
               lastHangarId = hangarId;
               unitsToSpawn++;
               if(amount == type[3] - 1)
               {
                  returnValue += this.wavesGetStringFromAttack(unitsToSpawn,unitDef.mSku,unitDef.getUpgradeId(),lastHangarId) + ",";
               }
               amount++;
            }
         }
         return returnValue;
      }
      
      public function translateUnitsRequestToObject(units:Vector.<Array>, hangarController:HangarController, serverFormat:Boolean = false) : Array
      {
         var returnValue:Array = null;
         var requestString:String = null;
         var requests:Array = null;
         var request:String = null;
         var tokens:Array = null;
         returnValue = [];
         requests = (requestString = this.translateUnitsRequestToString(units,hangarController)).split(",");
         for each(request in requests)
         {
            if(request != null && request != "")
            {
               returnValue.push(this.wavesGetAttackFromString(request,serverFormat));
            }
         }
         return returnValue;
      }
      
      private function mapGetSkus(elem:Array, idx:int, arr:Array) : String
      {
         return elem[0];
      }
      
      public function getUniqueVectorFromWaves(v:Vector.<Array>, waves:String, hangarId:String = "") : Vector.<Array>
      {
         var skuArr:Array = null;
         var wave:String = null;
         var arr:Array = null;
         var vpos:int = 0;
         if(v == null)
         {
            v = new Vector.<Array>(0);
         }
         skuArr = DCUtils.vector2Array(v).map(this.mapGetSkus);
         for each(wave in waves.split(","))
         {
            arr = this.getWarArrayFromWave(wave,hangarId);
            if((vpos = skuArr.indexOf(arr[0])) == -1)
            {
               v.push(arr);
            }
            else
            {
               v[vpos][1] += arr[1];
               v[vpos][3] += arr[3];
            }
         }
         return v;
      }
      
      public function getWarArrayFromWave(wave:String, hangarId:String) : Array
      {
         var arr:Array = null;
         var amount:int = 0;
         var sku:String = null;
         var h:String = null;
         var i:int = 0;
         if(hangarId != "")
         {
            hangarId += ",";
         }
         arr = wave.split(":");
         amount = int(arr[0]);
         sku = String(arr[1]);
         h = "";
         for(i = 0; i < amount; )
         {
            h += hangarId;
            i++;
         }
         arr[0] = sku;
         arr[1] = h;
         arr[2] = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getGameUnitBySku(sku).mDef;
         arr[3] = amount;
         return arr;
      }
      
      private function serverLoad() : void
      {
         this.mServerWaveHangarsSids = new Vector.<String>(0);
         this.mServerWaveHangarsUnitsSkus = new Vector.<Array>(0);
         this.mServerWaveHangarsUnitsIds = new Vector.<Array>(0);
         this.mServerWaveHangarsUnitsShotWaitingTimes = new Vector.<Array>(0);
         this.mServerWaveHangarsUnitsDamages = new Vector.<Array>(0);
         this.mServerWaveHangarsUnitsEnergies = new Vector.<Array>(0);
      }
      
      private function serverUnload() : void
      {
         this.mServerWaveHangarsSids = null;
         this.mServerWaveHangarsUnitsSkus = null;
         this.mServerWaveHangarsUnitsIds = null;
         this.mServerWaveHangarsUnitsShotWaitingTimes = null;
         this.mServerWaveHangarsUnitsDamages = null;
         this.mServerWaveHangarsUnitsEnergies = null;
         this.mServerUserDataMngRef = null;
      }
      
      private function serverWaveClear() : void
      {
         if(this.mServerWaveHangarsSids == null)
         {
            this.serverLoad();
         }
         else
         {
            this.mServerWaveHangarsSids.length = 0;
            this.mServerWaveHangarsUnitsSkus.length = 0;
            this.mServerWaveHangarsUnitsIds.length = 0;
            this.mServerWaveHangarsUnitsShotWaitingTimes.length = 0;
            this.mServerWaveHangarsUnitsDamages.length = 0;
            this.mServerWaveHangarsUnitsEnergies.length = 0;
         }
      }
      
      private function serverAddUnitId(sid:String, sku:String, id:int, unit:MyUnit) : void
      {
         var sidPos:int = 0;
         var pos:int = 0;
         if((sidPos = this.mServerWaveHangarsSids.indexOf(sid)) == -1)
         {
            sidPos = int(this.mServerWaveHangarsSids.length);
            this.mServerWaveHangarsSids.push(sid);
            this.mServerWaveHangarsUnitsSkus.push([]);
            this.mServerWaveHangarsUnitsIds.push([]);
            this.mServerWaveHangarsUnitsShotWaitingTimes.push([]);
            this.mServerWaveHangarsUnitsDamages.push([]);
            this.mServerWaveHangarsUnitsEnergies.push([]);
         }
         if((pos = this.mServerWaveHangarsUnitsSkus[sidPos].indexOf(sku)) == -1)
         {
            pos = int(this.mServerWaveHangarsUnitsSkus[sidPos].length);
            this.mServerWaveHangarsUnitsSkus[sidPos].push(sku);
            this.mServerWaveHangarsUnitsIds[sidPos].push([]);
            this.mServerWaveHangarsUnitsShotWaitingTimes[sidPos].push([]);
            this.mServerWaveHangarsUnitsDamages[sidPos].push([]);
            this.mServerWaveHangarsUnitsEnergies[sidPos].push([]);
         }
         this.mServerWaveHangarsUnitsIds[sidPos][pos].push(id);
         this.mServerWaveHangarsUnitsShotWaitingTimes[sidPos][pos].push(unit.mDef.getShotWaitingTime());
         this.mServerWaveHangarsUnitsDamages[sidPos][pos].push(unit.mDef.getShotDamage());
         this.mServerWaveHangarsUnitsEnergies[sidPos][pos].push(unit.mDef.getMaxEnergy());
      }
      
      public function serverNotifyNewWave(x:int, y:int) : void
      {
         var length:int = 0;
         var hangarSidStr:String = null;
         var hangarSid:int = 0;
         var socialItemSku:String = null;
         var i:int = 0;
         var coor:DCCoordinate = null;
         length = int(this.mServerWaveHangarsSids.length);
         for(i = 0; i < length; )
         {
            if((hangarSidStr = this.mServerWaveHangarsSids[i]).indexOf("i") == -1)
            {
               hangarSid = int(hangarSidStr);
               socialItemSku = null;
            }
            else
            {
               hangarSid = -1;
               socialItemSku = hangarSidStr.replace("i","");
            }
            (coor = MyUnit.smCoor).x = x;
            coor.y = y;
            smViewMng.worldViewPosToTileRelativeXY(coor);
            this.mServerUserDataMngRef.updateBattle_deployUnits(hangarSid,socialItemSku,this.mServerWaveHangarsUnitsSkus[i],this.mServerWaveHangarsUnitsIds[i],this.mServerWaveHangarsUnitsShotWaitingTimes[i][0],this.mServerWaveHangarsUnitsDamages[i][0],this.mServerWaveHangarsUnitsEnergies[i][0],x,y,coor.x,coor.y);
            i++;
         }
      }
      
      private function attacksLoad() : void
      {
         this.mAttacksRequests = new Vector.<SpecialAttack>();
      }
      
      private function attacksUnload() : void
      {
         this.mAttacksRequests = null;
      }
      
      private function attacksUnbuild() : void
      {
         this.mAttacksRequests.length = 0;
      }
      
      public function attacksGetCapsuleAttack(timeToWaitBeforeLaunch:int, x:int, y:int, wave:String, specialAttackDef:SpecialAttacksDef = null) : SpecialAttack
      {
         var specialAttack:SpecialAttack = null;
         var units:Vector.<MyUnit> = null;
         specialAttack = new Capsule(timeToWaitBeforeLaunch,x,y,specialAttackDef);
         units = this.wavesCreateAttackWave(wave,x,y,0,-1,false);
         specialAttack.setUnits(units.concat());
         return specialAttack;
      }
      
      public function attacksPaySpecialAttack(sku:String, tileX:int, tileY:int, payedWithCash:Boolean, setPreviousTool:Boolean) : void
      {
         var wbs:WarBarSpecialFacade = null;
         var goOn:Boolean = false;
         var def:SpecialAttacksDef = null;
         var transaction:Transaction = null;
         var onlyCash:Boolean = false;
         var guiController:GUIController = null;
         var o:Object = null;
         var coor:DCCoordinate = null;
         var viewMng:ViewMngPlanet = null;
         var specialAttack:SpecialAttack = null;
         var unitsSkus:Array = null;
         var unitsIds:Array = null;
         var units:Vector.<MyUnit> = null;
         var id:int = 0;
         goOn = true;
         def = SpecialAttacksDef(InstanceMng.getSpecialAttacksDefMng().getDefBySku(sku));
         if((transaction = InstanceMng.getRuleMng().getTransactionBuySpecialAttack(sku,payedWithCash)) != null)
         {
            transaction.computeAmountsLeftValues();
            if(!transaction.getTransHasBeenPerformed())
            {
               if((onlyCash = transaction.checkIfOnlyCashTransaction()) && transaction.mDifferenceCash.value < 0)
               {
                  InstanceMng.getToolsMng().setTool(0);
                  o = (guiController = InstanceMng.getGUIController()).createNotifyEvent("EventPopup","NotifyBuyGold",guiController,null,null,null,null,transaction);
                  InstanceMng.getNotifyMng().addEvent(guiController,o,true);
                  goOn = false;
               }
               else
               {
                  transaction.performAllTransactions();
                  InstanceMng.getTargetMng().updateProgress("useCrafting",1,sku);
               }
            }
         }
         if(goOn)
         {
            if(!(wbs = InstanceMng.getUIFacade().getWarBarSpecial()).popupShown || wbs.popupShown && wbs.popupAccepted)
            {
               wbs.popupShown = false;
               wbs.popupAccepted = false;
               coor = new DCCoordinate();
               viewMng = InstanceMng.getViewMngPlanet();
               coor.x = tileX;
               coor.y = tileY;
               viewMng.tileXYToWorldViewPos(coor,true);
               specialAttack = this.attacksLaunchSpecialAttack(sku,coor.x,coor.y);
               unitsSkus = null;
               unitsIds = null;
               if(specialAttack != null)
               {
                  if((units = specialAttack.getUnits()) != null)
                  {
                     unitsSkus = [];
                     unitsIds = [];
                     this.unitsToSkusIds(units,unitsSkus,unitsIds);
                  }
                  id = specialAttack.getId();
               }
               if(payedWithCash)
               {
                  InstanceMng.getUserDataMng().updateBattle_specialAttack_usingCash(sku,coor.x,coor.y,unitsSkus,unitsIds,id,transaction);
               }
               else
               {
                  InstanceMng.getUserDataMng().updateBattle_specialAttack_usingItem(def.getItemSku(),coor.x,coor.y,unitsSkus,unitsIds,id);
               }
               if(transaction != null)
               {
                  transaction.reset();
               }
               if(setPreviousTool)
               {
                  InstanceMng.getToolsMng().recoverPreviousTool();
               }
               InstanceMng.getGUIControllerPlanet().warbarPerformedAttack(0);
               InstanceMng.getUIFacade().reloadWarBars();
            }
         }
      }
      
      public function attacksLaunchSpecialAttack(sku:String, x:int, y:int) : SpecialAttack
      {
         var specialAttack:SpecialAttack = null;
         var tokens:Array = null;
         var specialAttackSku:String = null;
         var specialAttackDef:SpecialAttacksDef = null;
         var timeToWaitBeforeLaunch:int = 0;
         specialAttack = null;
         tokens = sku.split("_");
         specialAttackSku = String(tokens[tokens.length - 1]);
         if((specialAttackDef = InstanceMng.getSpecialAttacksDefMng().getDefBySku(specialAttackSku) as SpecialAttacksDef) != null)
         {
            timeToWaitBeforeLaunch = 0;
            switch(specialAttackDef.getType())
            {
               case "nuke":
                  specialAttack = new Nuke(timeToWaitBeforeLaunch,x,y,specialAttackDef);
                  break;
               case "mercenaries":
                  specialAttack = this.attacksGetCapsuleAttack(timeToWaitBeforeLaunch,x,y,specialAttackDef.getWave(),specialAttackDef);
                  if(Config.USE_SOUNDS)
                  {
                     SoundManager.getInstance().stopAll(true,false);
                     SoundManager.getInstance().playSound("music_mercenaris.mp3",1,0,-1,0);
                  }
                  break;
               case "battle_time":
                  this.battleAddExtraTime(specialAttackDef.getAmount() * 60000);
                  break;
               default:
                  specialAttack = new SpecialAttack(null,timeToWaitBeforeLaunch,x,y,specialAttackDef);
            }
            this.attacksAddAttack(specialAttack);
            if(this.mBattleTimeMode.value == 1)
            {
               this.quickAttackStartActualBattle();
            }
         }
         if(specialAttack != null)
         {
            specialAttack.setId(this.mUnitsNextId.value++);
         }
         return specialAttack;
      }
      
      public function attacksAddAttack(specialAttack:SpecialAttack) : void
      {
         if(specialAttack != null)
         {
            if(specialAttack.getHasToDisableBattleEndButton())
            {
               InstanceMng.getTopHudFacade().disableBattleEndButton();
            }
            this.mAttacksRequests.push(specialAttack);
         }
      }
      
      public function attacksLogicUpdate(dt:int) : void
      {
         var i:int = 0;
         var length:int = 0;
         var attack:SpecialAttack = null;
         var enableBattleEnd:Boolean = false;
         var origLength:* = length = int(this.mAttacksRequests.length);
         if(length > 0)
         {
            enableBattleEnd = true;
            for(i = 0; i < length; )
            {
               attack = this.mAttacksRequests[i];
               attack.logicUpdate(dt);
               if(attack.isOver())
               {
                  this.mAttacksRequests.splice(i,1);
                  length--;
               }
               else
               {
                  if(attack.getHasToDisableBattleEndButton())
                  {
                     enableBattleEnd = false;
                  }
                  i++;
               }
            }
            if(enableBattleEnd && this.mBattleState.value == 3)
            {
               InstanceMng.getTopHudFacade().enableBattleEndButton();
            }
         }
      }
      
      public function getSelectableUnit(x:int, y:int, unitType:int = 8) : MyUnit
      {
         var list:Vector.<MyUnit> = null;
         var u:MyUnit = null;
         var closestUnit:* = null;
         var minDist:* = 0;
         var dist:int = 0;
         var i:int = 0;
         closestUnit = null;
         minDist = 10000;
         if((list = this.mSceneUnits[unitType]) != null)
         {
            x = smViewMng.screenToWorldX(x);
            y = smViewMng.screenToWorldY(y);
            for(i = 0; i < list.length; )
            {
               if((dist = ((u = list[i]).mPositionDrawX - x) * (u.mPositionDrawX - x) + (u.mPositionDrawY - y) * (u.mPositionDrawY - y)) < 500 && dist < minDist)
               {
                  closestUnit = u;
                  minDist = dist;
               }
               i++;
            }
         }
         return closestUnit;
      }
      
      private function battleRecordLoad() : void
      {
         this.mBattleRecord = [];
      }
      
      private function replayUnload() : void
      {
         this.mReplay = null;
         this.mReplayProfile = null;
      }
      
      public function replayStart(battleReplay:XML) : void
      {
         if(this.mReplay)
         {
            this.mReplay.cancel();
         }
         this.mReplay = new BattleReplay();
         this.mReplay.startReplay(battleReplay);
         this.mReplayProfile = null;
      }
      
      public function replayCancel() : void
      {
         if(!this.mReplay)
         {
            return;
         }
         this.mReplay.cancel();
      }
      
      private function replayLogicUpdate(dt:int) : void
      {
         if(this.mReplay != null)
         {
            this.mReplay.logicUpdate(dt);
         }
      }
      
      public function replayIsEnabled() : Boolean
      {
         return this.mReplay != null && this.mReplay.isEnabled();
      }
      
      public function getReplay() : BattleReplay
      {
         return this.mReplay;
      }
      
      public function needsToUpdateMissionsProgress() : Boolean
      {
         return this.mNeedsToUpdateMissionsProgress.value;
      }
      
      public function replayGetProfile() : Profile
      {
         var lastAttack:AttackStatistics = null;
         if(this.mReplayProfile == null)
         {
            this.mReplayProfile = new Profile();
            this.mReplayProfile.setUserInfoObj(new UserInfo());
            lastAttack = InstanceMng.getUserInfoMng().getLastAttack();
            if(lastAttack != null)
            {
               this.mReplayProfile.setCoins(0);
               this.mReplayProfile.setCoinsCapacityAmount(lastAttack.getCoinsTaken());
               this.mReplayProfile.setMinerals(0);
               this.mReplayProfile.setMineralsCapacityAmount(lastAttack.getMineralsTaken());
            }
         }
         return this.mReplayProfile;
      }
      
      public function getHangarFromItem(item:WorldItemObject) : Hangar
      {
         var returnValue:Hangar = null;
         var hangarController:HangarController = null;
         returnValue = null;
         if(item != null)
         {
            if(item.mDef.isABunker())
            {
               hangarController = InstanceMng.getBunkerController();
            }
            else if(item.mDef.isAHangar())
            {
               hangarController = InstanceMng.getHangarControllerMng().getHangarController();
            }
            if(hangarController != null)
            {
               returnValue = hangarController.getFromSid(item.mSid);
            }
         }
         return returnValue;
      }
      
      public function getCoinsLooted() : int
      {
         var army:Army = null;
         army = Army(mChildren[2]);
         return army.mLootAmount[0];
      }
      
      public function getMineralsLooted() : int
      {
         var army:Army = null;
         army = Army(mChildren[2]);
         return army.mLootAmount[1];
      }
      
      public function squadsAddSquad(squad:Squad) : void
      {
         if(this.mSquads == null)
         {
            this.mSquads = new Vector.<Squad>();
         }
         this.mSquads.push(squad);
      }
      
      private function squadsUnload() : void
      {
         if(this.mSquads == null)
         {
            return;
         }
         var s:Squad = null;
         for each(s in this.mSquads)
         {
            s.unload();
         }
         this.mSquads = null;
      }
      
      private function squadsLogicUpdate(dt:int) : void
      {
         if(this.mSquads == null)
         {
            return;
         }
         var s:Squad = null;
         var length:int = 0;
         var i:int = 0;
         length = int(this.mSquads.length);
         for(i = 0; i < length; )
         {
            s = this.mSquads[i];
            if(s.getIsAlive())
            {
               i++;
            }
            else
            {
               s.releaseUnits();
               s.unload();
               this.mSquads.splice(i,1);
               length--;
            }
         }
      }
      
      private function effectsUnbuild() : void
      {
         var k:* = null;
         var u:MyUnit = null;
         var effect:UnitEffect = null;
         if(this.mEffects != null)
         {
            for(k in this.mEffects)
            {
               u = MyUnit(k);
               effect = UnitEffect(this.mEffects[k]);
               if(effect != null)
               {
                  effect.unload();
               }
            }
            this.mEffects = null;
         }
      }
      
      private function effectsCreateEffect(unit:MyUnit, effectType:int, extraParams:Object = null) : UnitEffect
      {
         var returnValue:UnitEffect = null;
         switch(effectType)
         {
            case 0:
               returnValue = new Lightnings(effectType);
               break;
            case 1:
               returnValue = new Lightnings(effectType,2,[GameConstants.FILTER_GLOW_RED_LASER]);
               break;
            case 2:
               returnValue = new LightningsShield(effectType);
               break;
            case 3:
               returnValue = new ArcShield(effectType);
               break;
            case 4:
               returnValue = new Burn(effectType,unit,extraParams["attacker"]);
               break;
            case 5:
               returnValue = new Stun(effectType,unit);
         }
         return returnValue;
      }
      
      private function effectsBuildEffect(unit:MyUnit, effect:UnitEffect) : void
      {
         var width:int = 0;
         var height:int = 0;
         var boundingBox:DCBox = null;
         var bitmap:Bitmap = null;
         var renderData:DCBitmapMovieClip = null;
         var item:WorldItemObject = null;
         var viewComp:UnitComponentView = unit.getViewComponent();
         switch(effect.getType())
         {
            case 0:
            case 1:
            case 2:
            case 3:
            case 5:
               width = 0;
               height = 0;
               if(viewComp != null)
               {
                  if((renderData = viewComp.getCurrentRenderData()) != null)
                  {
                     width = renderData.width;
                     height = renderData.height;
                     bitmap = renderData.getDisplayObjectContent() as Bitmap;
                  }
                  boundingBox = viewComp.getBoundingBox();
               }
               if(width == 0 || height == 0 || boundingBox == null)
               {
                  if((item = unit.mData[35]) != null)
                  {
                     if(boundingBox == null)
                     {
                        boundingBox = item.mBoundingBox;
                     }
                     if(boundingBox != null)
                     {
                        if(width == 0)
                        {
                           width = boundingBox.mWidth;
                        }
                        if(height == 0)
                        {
                           height = boundingBox.mHeight;
                        }
                     }
                  }
               }
               effect.setData(unit.mPositionDrawX,unit.mPositionDrawY,width,height,boundingBox);
               if(bitmap != null)
               {
                  effect.setBmp(bitmap);
               }
               break;
            case 4:
               effect.setIsBuilt(true);
         }
      }
      
      public function effectsSwitch(unit:MyUnit, effectType:int, on:Boolean, extraParams:Object = null) : void
      {
         var burnEffect:Burn = null;
         var e:UnitEffect = null;
         var goOn:Boolean = false;
         var d:DCDisplayObject = null;
         if(unit == null)
         {
            return;
         }
         if(on)
         {
            if(this.mEffects == null)
            {
               this.mEffects = new Dictionary();
            }
            e = this.mEffects[unit];
            goOn = true;
            if(e != null)
            {
               if(e.getType() == effectType)
               {
                  if(effectType == 4)
                  {
                     (burnEffect = e as Burn).applyNewFlame(extraParams);
                  }
                  goOn = false;
               }
            }
            if(goOn)
            {
               (e = this.effectsCreateEffect(unit,effectType,extraParams)).setNeedsToBeAddedToStage(on);
               this.mEffects[unit] = e;
            }
         }
         else if(this.mEffects != null)
         {
            if((e = this.mEffects[unit]) != null)
            {
               if((d = e.getDisplayObject()) != null && e.getEffectNeedsDisplayObject())
               {
                  smViewMng.unitRemoveEffectFromStage(e.getType(),e.getDisplayObject());
               }
               if(e.getType() == 4)
               {
                  unit.removeBurnFilter();
               }
               e.unload();
               this.mEffects[unit] = null;
            }
         }
      }
      
      public function viewCheckUnitEffects(unit:MyUnit) : void
      {
         if(this.mEffects == null)
         {
            return;
         }
         var effect:UnitEffect = this.mEffects[unit];
         if(effect == null)
         {
            return;
         }
         switch(effect.getType() - 4)
         {
            case 0:
               effect.setIsBuilt(false);
         }
      }
      
      private function effectsLogicUpdate(dt:int) : void
      {
         var k:* = null;
         var u:MyUnit = null;
         var effect:UnitEffect = null;
         for(k in this.mEffects)
         {
            u = MyUnit(k);
            if(u != null)
            {
               effect = UnitEffect(this.mEffects[k]);
               if(!(effect == null || !u.getIsAlive()))
               {
                  if(effect.getBmp() == null)
                  {
                     effect.setBmp(this.getUnitBmp(u));
                  }
                  if(effect.isBuilt())
                  {
                     if(effect.getNeedsToBeAddedToStage())
                     {
                        if(effect.getEffectNeedsDisplayObject())
                        {
                           smViewMng.unitAddEffectToStage(effect.getType(),effect.getDisplayObject());
                        }
                        effect.setNeedsToBeAddedToStage(false);
                     }
                     effect.updatePosition(u.mPositionDrawX,u.mPositionDrawY);
                     effect.logicUpdate(dt);
                     if(effect.getNeedsToBeRemovedFromStage())
                     {
                        this.effectsSwitch(u,effect.getType(),false);
                     }
                  }
                  else
                  {
                     this.effectsBuildEffect(u,effect);
                  }
               }
            }
         }
      }
      
      private function getUnitBmp(unit:MyUnit) : Bitmap
      {
         var dcdspo:DCDisplayObject = null;
         var bitmap:Bitmap = null;
         var item:WorldItemObject = unit.mData[35];
         if(item != null)
         {
            if((dcdspo = item.viewLayersAnimGet(1)) != null)
            {
               bitmap = dcdspo.getDisplayObjectContent() as Bitmap;
            }
         }
         return bitmap;
      }
      
      private function pingEnable(paceMs:int) : void
      {
         this.mPingPaceMs.value = paceMs;
         this.mPingTimer.value = 0;
         if(this.mPingStates == null)
         {
            this.mPingStates = new Vector.<int>(2);
         }
         this.pingSetState(0,2);
         this.pingSetState(1,1);
      }
      
      private function pingIsEnabled() : Boolean
      {
         return this.mPingPaceMs.value > 0;
      }
      
      private function pingSetState(id:int, state:int) : void
      {
         if(this.mPingStates[id] != state)
         {
            this.mPingStates[id] = state;
            switch(this.mPingStates[id] - 4)
            {
               case 0:
                  if(id == 1)
                  {
                     InstanceMng.getBetMng().notifyHisBattleStart();
                     break;
                  }
                  if(id == 0)
                  {
                     this.mPingPaceMs.value = 10000;
                  }
                  break;
            }
         }
      }
      
      private function pingDisable() : void
      {
         this.mPingPaceMs.value = -1;
      }
      
      private function pingLogicUpdate(dt:int) : void
      {
         if(this.pingIsEnabled())
         {
            this.mPingTimer.value -= dt;
            if(this.mPingTimer.value <= 0)
            {
               this.mPingTimer.value = this.mPingPaceMs.value;
               this.pingSend();
            }
         }
      }
      
      private function pingSend() : void
      {
         InstanceMng.getUserDataMng().updateBattle_ping();
      }
      
      public function pingReceive(e:Object) : void
      {
         var myState:int = 0;
         var hisState:int = 0;
         if(e != null)
         {
            myState = this.mPingStates[0];
            hisState = int(e.state);
            this.pingSetState(1,hisState);
            switch(hisState)
            {
               case 0:
                  if(myState < 4)
                  {
                     this.battleStartTimeOut();
                     InstanceMng.getUserDataMng().updateBattle_preStartTimeout();
                  }
                  else
                  {
                     this.pingHisIsOver();
                  }
                  break;
               case 4:
                  InstanceMng.getBetMng().notifyHisBattleProgress(e.hisCoins,e.hisMinerals,e.hisScore,e.hisScorePercent);
                  break;
               case 5:
                  this.pingHisIsOver();
            }
            switch(myState - 2)
            {
               case 0:
                  if(hisState == 2 || hisState == 3)
                  {
                     this.pingSetState(0,3);
                  }
                  break;
               case 1:
                  if(hisState >= 3 && hisState <= 5)
                  {
                     this.notifyWaitingForRivalIsOver();
                     this.pingSetState(0,4);
                     break;
                  }
            }
         }
      }
      
      private function pingHisIsOver() : void
      {
         InstanceMng.getBetMng().notifyHisBattleIsOver();
         this.pingDisable();
      }
      
      private function resetMessages() : void
      {
         if(this.mMessages != null)
         {
            this.mMessages.length = 0;
         }
         this.hideMessage(false);
         this.mMessageShown.value = false;
         this.mMessagesCount.value = 0;
         this.mMessageTimer.value = 0;
         this.mTimeBetweenMgs.value = 0;
      }
      
      public function addMessage(msg:String, duration:int, showLoading:Boolean = false, pLock:Boolean = false, needLock:Boolean = false) : void
      {
         var obj:Object = null;
         if(InstanceMng.getRole().mId == 3)
         {
            (obj = {})["text"] = msg;
            obj["timer"] = duration;
            obj["showLoading"] = showLoading;
            obj["lock"] = pLock;
            obj["needLock"] = needLock;
            if(this.mMessages == null)
            {
               this.mMessages = new Vector.<Object>(0);
            }
            this.mMessages.push(obj);
            this.mMessagesCount.value++;
         }
      }
      
      private function showMessage() : void
      {
         var obj:Object = null;
         obj = this.mMessages.shift();
         mWarBarNeedsLock.value = obj["lock"];
         InstanceMng.getUIFacade().battleFeedbackShow(obj["text"],obj["showLoading"],obj["lock"],obj["needLock"]);
         this.mMessageTimer.value = obj["timer"];
         this.mMessageShown.value = true;
         this.mMessagesCount.value--;
      }
      
      public function hideMessage(needsToLock:Boolean = false) : void
      {
         mWarBarNeedsLock.value = needsToLock;
         InstanceMng.getUIFacade().battleFeedbackHide(needsToLock);
         this.mMessageShown.value = false;
         this.mMessageTimer.value = 0;
         this.mTimeBetweenMgs.value = 5000;
      }
      
      public function warBarMustBeLocked() : Boolean
      {
         return mWarBarNeedsLock.value;
      }
      
      private function updateMsg(dt:int) : void
      {
         if(this.mMessages != null)
         {
            if(this.mMessageShown.value)
            {
               if(this.mMessageTimer.value > 0)
               {
                  this.mMessageTimer.value -= dt;
                  if(this.mMessageTimer.value <= 0)
                  {
                     this.hideMessage();
                  }
               }
            }
            else if(this.mTimeBetweenMgs.value > 0)
            {
               this.mTimeBetweenMgs.value -= dt;
            }
            else if(this.mMessagesCount.value > 0)
            {
               this.showMessage();
            }
         }
      }
      
      public function guiOpenNpcAttackIsOverPopup(isAHappening:Boolean) : void
      {
         var uiFacade:UIFacade = null;
         var p:DCIPopup = null;
         this.mNpcAttackIsAHappening.value = isAHappening;
         InstanceMng.getWorld().setNeedsToWaitForRepairingToStart(true);
         uiFacade = InstanceMng.getUIFacade();
         p = uiFacade.getPopupFactory().getNpcAttackIsOverPopup();
         uiFacade.enqueuePopup(p);
      }
      
      public function guiCloseNpcAttackIsOverPopup() : void
      {
         InstanceMng.getUIFacade().closePopupById("PopupNpcAttackIsOver");
         SoundManager.getInstance().playSound("repair.mp3",1,0,0,1);
         InstanceMng.getWorld().userAcceptsRepairingStart();
         if(!this.mNpcAttackIsAHappening.value)
         {
            InstanceMng.getMissionsMng().doNPCAttackProgressCheckFromWorld(InstanceMng.getWorld().getSurvivalPercentage());
         }
      }
      
      private function battleResultUnload() : void
      {
         this.mBattleResultEvent = null;
         this.mBattleResultIncomingAttack = null;
      }
      
      public function startBattleResultPopup(e:Object, type:int) : void
      {
         this.mBattleResultEvent = e;
         this.mBattleResultType.value = type;
         this.battleResultChangeState(0);
      }
      
      public function battleResultClose() : void
      {
         switch(this.mBattleResultState.value - 1)
         {
            case 0:
               this.battleResultChangeState(2);
               break;
            case 2:
               this.battleResultChangeState(4);
         }
      }
      
      private function battleResultChangeState(state:int) : void
      {
         DCDebug.traceCh("Battle","battleResultChangeState from " + this.mBattleResultState.value + " to " + state);
         var timeOffset:int = 0;
         var popupWasShown:Boolean = false;
         this.mBattleResultState.value = state;
         switch(this.mBattleResultState.value)
         {
            case 0:
               timeOffset = ParticleMng.smParticlesGiftActives > 0 ? 5000 : 0;
               this.mBattleResultTimer.value = 1 + timeOffset;
               if(this.mBattleResultEvent.scoreGained > 0)
               {
                  InstanceMng.getUserInfoMng().loadWeeklyScoreList();
               }
               break;
            case 1:
               InstanceMng.getTopHudFacade().battleEnd();
               InstanceMng.getGUIControllerPlanet().getWarBar().resetBuyBattleTime();
               this.resetBattleSpeed();
               if(this.mBattleResultType.value == 0)
               {
                  this.openBattleResultPopup(this.mBattleResultEvent);
               }
               else
               {
                  popupWasShown = InstanceMng.getUserInfoMng().getProfileLogin().flagsGetBlackHoleBattleWonPopupWasShown();
                  if(this.mBattleResultEvent.hqDestroyed && !popupWasShown && this.mBattleResultEvent.attackedAccId == "npc_D")
                  {
                     this.openBlackHoleShowReward();
                     InstanceMng.getUserInfoMng().getProfileLogin().flagsSetBlackHoleBattleWonPopup(1);
                  }
                  else
                  {
                     this.openBattleVersusNpcResultPopup();
                  }
               }
               break;
            case 2:
               if(!(this.mBattleResultType.value == 0 && this.mBattleResultEvent.scoreGained > 0))
               {
                  this.battleResultChangeState(4);
               }
               break;
            case 3:
               this.openFriendPassedInRankingPopup();
               break;
            case 4:
               InstanceMng.getFlowStatePlanet().visitReturnToOwnCurrentPlanet();
         }
      }
      
      private function battleResultTimerUpdate(dt:int) : void
      {
         var application:Application = null;
         var userInfoMng:UserInfoMng = null;
         switch(this.mBattleResultState.value)
         {
            case 0:
               if(this.mBattleResultTimer.value > 0)
               {
                  this.mBattleResultTimer.value -= dt;
                  if(this.mBattleResultTimer.value <= 0)
                  {
                     this.battleResultChangeState(1);
                  }
               }
               break;
            case 2:
               application = InstanceMng.getApplication();
               userInfoMng = InstanceMng.getUserInfoMng();
               if(userInfoMng.isWeeklyScoreListLoaded())
               {
                  if(userInfoMng.hasTheUserPassedAnyFriends())
                  {
                     this.battleResultChangeState(3);
                  }
                  else
                  {
                     this.battleResultChangeState(4);
                  }
                  break;
               }
               this.battleResultChangeState(4);
               break;
         }
      }
      
      public function openBattleResultPopup(e:Object) : void
      {
         var uiFacade:UIFacade = null;
         var popup:DCIPopup = null;
         uiFacade = InstanceMng.getUIFacade();
         popup = uiFacade.getPopupFactory().getBattleVersusUserResults(e.lootedCoins,e.lootedMineral,e.scoreGained,e.allianceScore,e.showAllianceScore);
         uiFacade.enqueuePopup(popup);
      }
      
      private function openBattleVersusNpcResultPopup() : void
      {
         var uiFacade:UIFacade = null;
         var popup:DCIPopup = null;
         uiFacade = InstanceMng.getUIFacade();
         popup = uiFacade.getPopupFactory().getBattleVersusNpcResults(this.mBattleResultEvent.playerName,this.mBattleResultEvent.userImageUrl,this.mBattleResultEvent.hqDestroyed);
         uiFacade.enqueuePopup(popup);
      }
      
      public function closeBattleVersusNpcResultPopup() : void
      {
         var popup:DCIPopup = null;
         var playerName:String = null;
         var npcName:String = null;
         popup = InstanceMng.getPopupMng().getPopupOpened("PopupBattleVersusNpcResults");
         InstanceMng.getUIFacade().closePopup(popup,null,true);
         InstanceMng.getGUIControllerPlanet().endAttack();
         this.battleResultClose();
      }
      
      public function openFriendPassedInRankingPopup() : void
      {
         var uiFacade:UIFacade = null;
         var popup:DCIPopup = null;
         uiFacade = InstanceMng.getUIFacade();
         popup = uiFacade.getPopupFactory().getFriendPassedInRankingPopup();
         uiFacade.enqueuePopup(popup);
      }
      
      public function closeFriendPassedInRankingPopup() : void
      {
         InstanceMng.getUIFacade().closePopupById("PopupFriendPassedInRanking");
         this.battleResultClose();
      }
      
      public function openShowIncomingAttackPopup(wave:String, npcSku:String, deployX:String, deployY:String, deployWay:String, duration:Number) : void
      {
         var uiFacade:UIFacade = null;
         var popup:DCIPopup = null;
         this.mBattleResultIncomingAttack = [];
         this.mBattleResultIncomingAttack["wave"] = wave;
         this.mBattleResultIncomingAttack["npcSku"] = npcSku;
         this.mBattleResultIncomingAttack["x"] = deployX;
         this.mBattleResultIncomingAttack["y"] = deployY;
         this.mBattleResultIncomingAttack["deployWay"] = deployWay;
         this.mBattleResultIncomingAttack["duration"] = duration;
         popup = (uiFacade = InstanceMng.getUIFacade()).getPopupFactory().getShowIncomingAttackPopup(wave,npcSku);
         uiFacade.enqueuePopup(popup);
      }
      
      public function showIncomingAttackOnAccept() : void
      {
         var duration:Number = NaN;
         if(this.mBattleResultIncomingAttack != null)
         {
            InstanceMng.getUserInfoMng().setUserToVisitByAccountId(this.mBattleResultIncomingAttack["npcSku"]);
            duration = Number(this.mBattleResultIncomingAttack["duration"] > 0 ? this.mBattleResultIncomingAttack["duration"] : -1);
            InstanceMng.getUserDataMng().mBattleStartWithScore = Math.floor(InstanceMng.getUserInfoMng().getProfileLogin().getScore());
            this.battleStart(6,duration,this.mBattleResultIncomingAttack,this.mBattleResultIncomingAttack["deployWay"]);
            this.showIncomingAttackOnClose();
         }
      }
      
      public function showIncomingAttackOnCancel() : void
      {
         this.showIncomingAttackOnClose();
      }
      
      private function showIncomingAttackOnClose() : void
      {
         InstanceMng.getUIFacade().closePopupById("PopupShowIncomingAttack");
         this.mBattleResultIncomingAttack = null;
      }
      
      private function openBlackHoleShowReward() : void
      {
         var uiFacade:UIFacade = null;
         var popup:DCIPopup = null;
         uiFacade = InstanceMng.getUIFacade();
         popup = uiFacade.getPopupFactory().getBlackHoleShowRewardPopup(this.blackHoleShowRewardOnClose);
         popup.setIsStackable(true);
         uiFacade.enqueuePopup(popup);
      }
      
      private function blackHoleShowRewardOnClose(e:EEvent = null) : void
      {
         InstanceMng.getUIFacade().closePopupById("PopupBlackHoleShowReward");
         this.openBattleVersusNpcResultPopup();
      }
      
      private function preAttackDestroy() : void
      {
         this.mPreAttackEvent = null;
      }
      
      public function preAttackOpenPopup(e:Object) : void
      {
         var targetAccountId:String = null;
         var targetPlanetId:String = null;
         var targetPlanetSku:String = null;
         var uInfoAttacked:UserInfo = null;
         var isNpc:Boolean = false;
         var skipPopup:* = false;
         var profileLogin:Profile = null;
         var attackingPlanet:Planet = null;
         var attackingPlanetSku:String = null;
         var defendingPlanet:Planet = null;
         var distance:Number = NaN;
         var mineralCost:Number = NaN;
         var attackCostPercentage:int = 0;
         var uiFacade:UIFacade = null;
         var popup:DCIPopup = null;
         this.mPreAttackEvent = e;
         targetAccountId = String(e.goToRequestUserId);
         targetPlanetId = String(e.goToRequestPlanetId);
         targetPlanetSku = String(e.goToRequestPlanetSku);
         isNpc = (uInfoAttacked = InstanceMng.getUserInfoMng().getUserInfoObj(targetAccountId,0)) != null && uInfoAttacked.mIsNPC.value;
         e.isNpc = isNpc;
         skipPopup = false;
         if(InstanceMng.getSettingsDefMng().getSkipAttackDistancePopupIfFree() == 1)
         {
            attackingPlanetSku = (attackingPlanet = (profileLogin = InstanceMng.getUserInfoMng().getProfileLogin()).getUserInfoObj().getPlanetById(profileLogin.getCurrentPlanetId())).getSku();
            defendingPlanet = new Planet();
            if(uInfoAttacked.mIsNPC.value)
            {
               defendingPlanet.setSku(attackingPlanet.getSku());
               defendingPlanet.setPlanetId(uInfoAttacked.mAccountId);
               defendingPlanet.setColonyIdx(0);
               defendingPlanet.setIsCapital(true);
               defendingPlanet.setName(defendingPlanet.getStringId());
            }
            else
            {
               defendingPlanet.setSku(targetPlanetSku);
               defendingPlanet.setPlanetId(targetPlanetId);
               defendingPlanet.setColonyIdx(parseInt(defendingPlanet.getPlanetId()) - 1);
               defendingPlanet.setIsCapital(defendingPlanet.getColonyIdx() == 0);
               defendingPlanet.setName(defendingPlanet.getStringId());
            }
            distance = Math.floor(InstanceMng.getMapViewGalaxy().getDistanceBetweenPlanets(attackingPlanet.getSku(),defendingPlanet.getSku()));
            mineralCost = InstanceMng.getRuleMng().getAttackDistanceMineralCostByDistance(distance);
            if(isNpc)
            {
               attackCostPercentage = uInfoAttacked.getAttackCostPercentage();
               mineralCost = InstanceMng.getRuleMng().getAmountDependingOnCapacity(attackCostPercentage,false);
            }
            e.mineralCost = mineralCost;
            skipPopup = mineralCost == 0;
         }
         if(skipPopup)
         {
            this.preAttackGoToAttack();
         }
         else
         {
            e.phase = "OUT";
            (popup = (uiFacade = InstanceMng.getUIFacade()).getPopupFactory().getPreAttackPopup(targetAccountId,targetPlanetId,targetPlanetSku,this.preAttackGoToAttack,this.preAttackClosePopup)).setEvent(e);
            uiFacade.enqueuePopup(popup);
         }
      }
      
      private function preAttackClosePopup(e:EEvent = null) : void
      {
         this.mPreAttackEvent = null;
      }
      
      private function preAttackGoToAttack(e:EEvent = null) : void
      {
         var goOn:Boolean = false;
         var goToPlanet:Boolean = false;
         goOn = true;
         if(this.mPreAttackEvent != null)
         {
            if(InstanceMng.getFlowStatePlanet().isTutorialRunning())
            {
               InstanceMng.getViewMngGame().removeAllHighlights();
            }
            goToPlanet = false;
            if(goOn)
            {
               if(this.mPreAttackEvent.isNpc)
               {
                  goToPlanet = true;
               }
            }
            this.mPreAttackEvent.gotoPlanet = goToPlanet;
            this.mPreAttackEvent.sendResponseTo = InstanceMng.getGUIController();
            InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),this.mPreAttackEvent,true);
            this.mPreAttackEvent = null;
         }
      }
      
      public function getAllAttackingUnits() : Vector.<Vector.<MyUnit>>
      {
         var result:Vector.<Vector.<MyUnit>> = null;
         result = new Vector.<Vector.<MyUnit>>();
         result.push(this.mSceneUnits[2]);
         result.push(this.mSceneUnits[8]);
         result.push(this.mSceneUnits[10]);
         return result;
      }
      
      public function getAllDefendingUnits() : Vector.<Vector.<MyUnit>>
      {
         var result:Vector.<Vector.<MyUnit>> = null;
         result = new Vector.<Vector.<MyUnit>>();
         result.push(this.mSceneUnits[3]);
         result.push(this.mSceneUnits[9]);
         result.push(this.mSceneUnits[11]);
         return result;
      }
      
      public function getTotalScoreWithDestroyedAtStart() : Number
      {
         return this.mTotalScoreAttackWithDestroyedAtStart.value;
      }
   }
}
