package com.dchoc.game.core.flow
{
   import com.dchoc.game.controller.ActionsLibrary;
   import com.dchoc.game.controller.alliances.AlliancesController;
   import com.dchoc.game.controller.alliances.AlliancesControllerStar;
   import com.dchoc.game.controller.gui.GUIController;
   import com.dchoc.game.controller.gui.popups.PopupMng;
   import com.dchoc.game.controller.gui.popups.WelcomePopupsMng;
   import com.dchoc.game.controller.notifications.Notification;
   import com.dchoc.game.controller.notifications.NotificationsMng;
   import com.dchoc.game.controller.shop.ShopController;
   import com.dchoc.game.controller.shop.ShopsDrawer;
   import com.dchoc.game.controller.tools.Tool;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.resource.EResourceDefLoaded;
   import com.dchoc.game.core.resource.ResourceMng;
   import com.dchoc.game.core.rule.RuleMng;
   import com.dchoc.game.core.utils.animations.TweenEffectsFactory;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.behaviors.BehaviorsMng;
   import com.dchoc.game.eview.facade.EUIFacade;
   import com.dchoc.game.eview.popups.alliances.EPopupAlliances;
   import com.dchoc.game.eview.popups.inventory.EPopupInventory;
   import com.dchoc.game.eview.resources.ResourcesMng;
   import com.dchoc.game.eview.skins.SkinsMng;
   import com.dchoc.game.eview.widgets.premiumShop.PopupPremiumShop;
   import com.dchoc.game.eview.widgets.selectioncircle.ESelectionCircleMng;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.game.model.alliances.Alliance;
   import com.dchoc.game.model.bet.BetMng;
   import com.dchoc.game.model.cache.CacheMng;
   import com.dchoc.game.model.cache.GraphicsCacheMng;
   import com.dchoc.game.model.contest.ContestMng;
   import com.dchoc.game.model.flow.FlowState;
   import com.dchoc.game.model.flow.FlowStateGalaxy;
   import com.dchoc.game.model.flow.FlowStateLoadingBar;
   import com.dchoc.game.model.flow.FlowStateLoadingBarGalaxyView;
   import com.dchoc.game.model.flow.FlowStateLoadingBarSolarSystem;
   import com.dchoc.game.model.flow.FlowStateLoadingBarVisiting;
   import com.dchoc.game.model.flow.FlowStatePlanet;
   import com.dchoc.game.model.flow.FlowStateSolarSystem;
   import com.dchoc.game.model.gameunit.GameUnit;
   import com.dchoc.game.model.happening.HappeningMng;
   import com.dchoc.game.model.hotkey.HotkeyMng;
   import com.dchoc.game.model.invests.InvestMng;
   import com.dchoc.game.model.items.AlliancesRewardsMng;
   import com.dchoc.game.model.items.ItemObject;
   import com.dchoc.game.model.items.ItemsDef;
   import com.dchoc.game.model.items.ItemsMng;
   import com.dchoc.game.model.loading.LoadingMng;
   import com.dchoc.game.model.poll.PollMng;
   import com.dchoc.game.model.powerups.PowerUpMng;
   import com.dchoc.game.model.rule.FunnelStepDef;
   import com.dchoc.game.model.rule.PlatformSettingsDefMng;
   import com.dchoc.game.model.space.Planet;
   import com.dchoc.game.model.space.SolarSystem;
   import com.dchoc.game.model.target.Target;
   import com.dchoc.game.model.target.TargetDef;
   import com.dchoc.game.model.target.TargetDefMng;
   import com.dchoc.game.model.target.TargetMng;
   import com.dchoc.game.model.umbrella.UmbrellaMng;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.ParticleMng;
   import com.dchoc.game.model.unit.UnitScene;
   import com.dchoc.game.model.upselling.UpSellingMng;
   import com.dchoc.game.model.userdata.CustomizerMng;
   import com.dchoc.game.model.userdata.PendingTransaction;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.userdata.UserDataMng;
   import com.dchoc.game.model.userdata.UserDataMngOffline;
   import com.dchoc.game.model.userdata.UserDataMngOnline;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.game.model.userdata.UserInfoMng;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.model.world.target.condition.ConditionComposite;
   import com.dchoc.game.model.world.target.missions.MissionsMng;
   import com.dchoc.game.utils.Debug;
   import com.dchoc.game.utils.anticheat.SecureBoolean;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.game.utils.anticheat.SecureString;
   import com.dchoc.game.utils.popup.PopupEffects;
   import com.dchoc.game.view.dc.facade.DCUIFacade;
   import com.dchoc.game.view.dc.map.MapView;
   import com.dchoc.game.view.dc.mng.ViewMngPlanet;
   import com.dchoc.game.view.dc.mng.ViewMngrGame;
   import com.dchoc.game.view.facade.CursorFacade;
   import com.dchoc.game.view.facade.UIFacade;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.component.DCComponentUI;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.flow.DCApplication;
   import com.dchoc.toolkit.core.instance.DCInstanceMng;
   import com.dchoc.toolkit.core.media.SoundManager;
   import com.dchoc.toolkit.core.resource.DCResourceDef;
   import com.dchoc.toolkit.core.resource.DCResourceMng;
   import com.dchoc.toolkit.core.rule.DCRuleMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.condition.DCCondition;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.services.advertising.DCAdsManager;
   import com.dchoc.toolkit.services.metrics.DCMetrics;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.math.DCMath;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.easing.Exponential;
   import com.reygazu.anticheat.managers.CheatManager;
   import esparragon.core.Esparragon;
   import esparragon.display.EDisplayFactory;
   import esparragon.events.EEventFactory;
   import esparragon.utils.EUtils;
   import esparragonFlash.display.FlashDisplayFactory;
   import esparragonFlash.events.FlashEventFactory;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   
   public class Application extends DCApplication
   {
      
      public static const FSM_LOADING_BAR_ID:int = 0;
      
      public static const FSM_LOADING_BAR_VISITING_ID:int = 1;
      
      public static const FSM_LOADING_BAR_ATTACKING_ID:int = 2;
      
      public static const FSM_GAME_ID:int = 3;
      
      public static const FSM_LOADING_GALAXY_VIEW:int = 4;
      
      public static const FSM_GALAXY_ID:int = 5;
      
      public static const FSM_LOADING_SPACE_STAR_VIEW:int = 6;
      
      public static const FSM_SPACE_STAR_ID:int = 7;
      
      public static const FSM_LOADING_BAR_SPYING_ID:int = 8;
      
      public static const FSM_LOADING_BACK_TO_PLANET:int = 9;
      
      public static const FSM_STATES_COUNT:int = 10;
      
      public static const FSM_LOADING_TUTORIAL_SKU:String = "loadingTutorial";
      
      public static const FSM_LOADING_LOGIN_SKU:String = "loadingLogin";
      
      public static const FSM_LOADING_BACK_TO_PLANET_SKU:String = "loadingBackToPlanet";
      
      public static const FSM_LOADING_SPY_SKU:String = "loadingSpy";
      
      public static const FSM_LOADING_VISIT_SKU:String = "loadingVisit";
      
      public static const FSM_LOADING_ATTACK_SKU:String = "loadingAttack";
      
      public static const FSM_LOADING_GALAXY_NAVIGATION_SKU:String = "loadingGalaxyNavigation";
      
      public static const FSM_LOADING_FIRST_SKU:String = "loadingFirst";
      
      private static var smNotificationsQueue:Vector.<Object>;
      
      public static const NOTIFICATION_GAMEPLAY_LOGOUT:int = 1;
      
      public static const NOTIFICATION_YOUR_CITY_IS_LOCKED:int = 2;
      
      public static const NOTIFICATION_FRIEND_CITY_IS_LOCKED:int = 3;
      
      public static const NOTIFICATION_MSG_CENTER:int = 4;
      
      public static const NOTIFICATION_CASH_PAYMENT_DONE:int = 5;
      
      public static const NOTIFICATION_CASH_PAYMENT_CANCELLED:int = 6;
      
      public static const NOTIFICATION_SPACE_STAR_INFO_RECEIVED:int = 7;
      
      public static const NOTIFICATION_SPACE_STAR_INFO_CANCELLED:int = 8;
      
      public static const NOTIFICATION_COLONY_AVAILABLE:int = 9;
      
      public static const NOTIFICATION_COLONY_NOT_AVAILABLE:int = 10;
      
      public static const NOTIFICATION_COLONY_PURCHASE_CONFIRMED:int = 11;
      
      public static const NOTIFICATION_COLONY_PURCHASE_REFUSED:int = 12;
      
      public static const NOTIFICATION_PURCHASE_CREDITS_STATUS:int = 13;
      
      public static const NOTIFICATION_UPDATE_CREDITS_PURCHASE:int = 14;
      
      public static const NOTIFICATION_GALAXY_WINDOW_ACCEPTED:int = 15;
      
      public static const NOTIFICATION_GALAXY_WINDOW_CANCELLED:int = 16;
      
      public static const NOTIFICATION_NETWORK_BUSY_PAUSE:int = 17;
      
      public static const NOTIFICATION_NETWORK_BUSY_RESUME:int = 18;
      
      public static const NOTIFICATION_NEIGHBOR_INFO_RECEIVED:int = 19;
      
      public static const NOTIFICATION_NEIGHBOR_INFO_REJECTED:int = 20;
      
      public static const NOTIFICATION_PROCESS_PENDING_TRANSACTIONS:int = 21;
      
      public static const NOTIFICATION_INVEST_IN_FRIENDS:int = 22;
      
      public static const NOTIFICATION_COLONY_MOVED_CONFIRMED:int = 23;
      
      public static const NOTIFICATION_COLONY_MOVED_REFUSED:int = 24;
      
      public static const NOTIFICATION_QUICK_ATTACK_FIND_TARGET_CONFIRMED:int = 25;
      
      public static const NOTIFICATION_QUICK_ATTACK_FIND_TARGET_REFUSED:int = 26;
      
      public static const NOTIFICATION_ATTACKED_INGAME:int = 27;
      
      public static const NOTIFICATION_BET_REQUEST_MATCHED:int = 28;
      
      public static const NOTIFICATION_BATTLE_PONG:int = 29;
      
      public static const NOTIFICATION_BET_RESULT:int = 30;
      
      public static const NOTIFICATION_MOBILE_PAYMENTS:int = 31;
      
      public static const NOTIFICATION_OPPONENTS_COLONY_SHIELD_ACTIVATED:int = 32;
      
      public static const NOTIFICATION_SERVER_UNREACHABLE:int = 33;
      
      public static const NOTIFICATION_WISHLIST:int = 34;
      
      public static const MESSAGE_CENTER_RECEIVE_GIFT:String = "msgCenterReceiveGift";
      
      public static const MESSAGE_CENTER_WISH_LIST_SENT_ITEM:String = "wishlistSentItem";
      
      public static const MESSAGE_CENTER_INTRO_OVER:String = "introOver";
      
      public static const MESSAGE_CENTER_PURCHASE_CREDITS_STATUS:String = "purchaseCreditsStatus";
      
      public static const MESSAGE_CENTER_MUTE_OFF:String = "muteOff";
      
      public static const MESSAGE_CENTER_MUTE_ON:String = "muteOn";
      
      public static const MESSAGE_CENTER_VISIT:String = "visit";
      
      public static const MESSAGE_CENTER_CAN_SPY:String = "canSpy";
      
      public static const MESSAGE_CENTER_REPLAY:String = "replay";
      
      public static const MESSAGE_CENTER_NEIGHBOUR_ACCEPTED:String = "neighbourAccepted";
      
      public static const MESSAGE_CENTER_NEIGHBOUR_REMOVED:String = "removeNeighbour";
      
      public static const MESSAGE_CENTER_ALLIANCE_INVITE_ACCEPTED:String = "allianceInviteAccepted";
      
      public static const MESSAGE_CENTER_ALLIANCE_INVITATIONS_SENT:String = "allianceInvitationsSent";
      
      public static const MESSAGE_CENTER_WISH_ITEMS_AMOUNT:String = "checkItemsAmount";
      
      public static const MESSAGE_CENTER_SOCIAL_WALL_OPENED:String = "socialWallOpened";
      
      public static const MESSAGE_CENTER_SOCIAL_WALL_CLOSED:String = "socialWallClosed";
      
      public static const MESSAGE_CENTER_CURRENCY_PLATFORM:String = "currencyPlatform";
      
      public static const MESSAGE_CENTER_PROMOTION_STATUS:String = "promotionStatus";
      
      public static const MESSAGE_CENTER_MOBILE_PRICE_POINTS:String = "mobilePricePoints";
      
      public static const MESSAGE_CENTER_REQUEST_SCREENSHOT:String = "requestScreenshot";
      
      public static const TRANSACTION_EVENT_APPLY:String = "apply";
      
      public static const VIEW_MODE_PLANET:int = 0;
      
      public static const VIEW_MODE_STAR:int = 1;
      
      public static const VIEW_MODE_GALAXY:int = 2;
      
      public static const VISIT_MAIN_PLANET:String = "-2";
      
      public static const FLOW_STATE_UNBUILD_MODE_TOTAL:int = 1;
      
      public static const FLOW_STATE_UNBUILD_MODE_PARTIAL:int = 2;
      
      public static const ATTACK_MODE_NONE:int = -1;
      
      public static const ATTACK_MODE_NORMAL:int = 0;
      
      public static const ATTACK_MODE_QUICK_ATTACK:int = 1;
      
      public static const ATTACK_MODE_BET:int = 2;
      
      private static const ATTACK_STATE_NONE:int = 0;
      
      private static const ATTACK_STATE_CHECK_USER_CAN_ATTACK:int = 0;
      
      private static const CANT_ATTACK_STATE_NONE:int = 0;
      
      private static const CANT_ATTACK_STATE_CHECK:int = 1;
      
      private static const CANT_ATTACK_STATE_SHOW_REASON:int = 2;
      
      public static const CACHE_MNG_GALAXY_PATTERN:String = "galaxy_";
      
      public static const CACHE_MNG_STAR_PATTERN:String = "star_";
      
      private static const LOCK_UI_NO_TIMEOUT:int = -1;
      
      private static const LOCK_UI_TIMEOUT_DEFAULT:int = 10000;
      
      public static const LOCK_UI_REASON_NONE:int = -1;
      
      public static const LOCK_UI_REASON_WAITING_FOR_SERVER_ATTACK_ALLOWED:int = 0;
      
      public static const LOCK_UI_REASON_WAITING_FOR_SERVER_PAYMENT:int = 1;
      
      public static const LOCK_UI_REASON_WAITING_FOR_SERVER_WARP_BUNKER_TRANSFER:int = 2;
      
      public static const LOCK_UI_REASON_WAITING_FOR_SERVER_SOLAR_SYSTEM_INFORMATION:int = 3;
      
      public static const LOCK_UI_REASON_WAITING_FOR_COLONY_AVAILABILITY:int = 4;
      
      public static const LOCK_UI_REASON_WAITING_FOR_SERVER_GALAXY_INFORMATION:int = 5;
      
      public static const LOCK_UI_REASON_WAITING_FOR_ALLIANCES_REQUEST:int = 7;
      
      public static const LOCK_UI_REASON_WAITING_FOR_BATTLE_RESULT:int = 8;
      
      public static const LOCK_UI_REASON_WAITING_FOR_PENDING_TRANSACTIONS:int = 9;
      
      public static const LOCK_UI_REASON_WAITING_FOR_INVESTS:int = 10;
      
      public static const LOCK_UI_REASON_WAITING_FOR_WEEKLY_RANKING:int = 11;
      
      public static const LOCK_UI_REASON_WAITING_FOR_SERVER_ATTACK_ALLOWED_DISABLING_ATTACK_BUTTON:int = 12;
      
      public static const LOCK_UI_REASON_WAITING_FOR_QUICK_ATTACK_TARGET:int = 13;
      
      public static const LOCK_UI_REASON_WAITING_FOR_PURCHASE_CREDITS:int = 14;
      
      public static const LOCK_UI_REASON_WAITING_FOR_CONTEST_REQUEST:int = 15;
      
      public static const LOCK_UI_REASON_WAITING_FOR_COMMANDS_TO_BE_FLUSHED_FOR_THE_CONTEST:int = 16;
      
      public static const LOCK_UI_REASON_WAITING_FOR_MYSTERY_CUBE:int = 17;
      
      public static const QUALITY_LOW:int = 0;
      
      public static const QUALITY_HIGH:int = 1;
      
      public static const SPEECH_POPUP_ADVISOR_SIZE_DEFAULT:int = 75;
      
      public static const SPEECH_ALIGN_V_CENTER:int = 0;
      
      public static const SPEECH_ALIGN_V_BOTTOM:int = 1;
      
      public static const SPEECH_ALIGN_V_TOP:int = 2;
      
      public static const CRASH_TYPE_LOGOUT:String = "LogOut";
      
      public static const CRASH_TYPE_CHK:String = "ChkMismatch";
      
      public static const CRASH_TYPE_NO_RESPONSE:String = "NoResponse";
      
      public static const CRASH_TYPE_BAD_RESPONSE:String = "BadResponse";
      
      public static const CRASH_TYPE_CONNECTION_LOST:String = "ConnectionLost";
      
      public static const CRASH_TYPE_LOGIN_FAIL:String = "LogKO";
       
      
      private var mUserDataMng:UserDataMng;
      
      private var mEselectionMng:ESelectionCircleMng;
      
      private var mUserInfoMng:UserInfoMng;
      
      private var mGraphicsCacheMng:GraphicsCacheMng;
      
      private var mCacheMng:CacheMng;
      
      private var mItemsMng:ItemsMng;
      
      private var mPopupEffects:PopupEffects;
      
      private var mTargetMng:TargetMng;
      
      private var mMissionsMng:MissionsMng;
      
      private var mHappeningMng:HappeningMng;
      
      private var mPowerUpMng:PowerUpMng;
      
      private var mBetMng:BetMng;
      
      private var mContestMng:ContestMng;
      
      private var mETooltipMng:ETooltipMng;
      
      private var mCustomizerMng:CustomizerMng;
      
      private var mInvestMng:InvestMng;
      
      private var mWaitForIntro:SecureBoolean;
      
      private var mWaitForIntroTimeout:SecureNumber;
      
      private var mAlliancesController:AlliancesController;
      
      private var mAlliancesRewardsMng:AlliancesRewardsMng;
      
      private var mSoundManager:SoundManager;
      
      private var mEResourcesMng:ResourcesMng;
      
      private var mBehaviorsMng:BehaviorsMng;
      
      private var mViewFactory:ViewFactory;
      
      private var mSkinsMng:SkinsMng;
      
      private var mUmbrellaMng:UmbrellaMng;
      
      private var mActionsLibrary:ActionsLibrary;
      
      private var mNetworkIsBusy:SecureBoolean;
      
      private var mWishlistItemsSending:Dictionary;
      
      private var mUIFacade:UIFacade;
      
      private var mCreditId:SecureString;
      
      private var mNeedsToReload:SecureBoolean;
      
      private var mUpSellingMng:UpSellingMng;
      
      private var mParticleMng:ParticleMng;
      
      private var mPollMng:PollMng;
      
      private var mHotkeyMng:HotkeyMng;
      
      private var mLoadingMng:LoadingMng;
      
      private var mNotificationsMng:NotificationsMng;
      
      private var mWelcomePopupsMng:WelcomePopupsMng;
      
      private var mShopsDrawer:ShopsDrawer;
      
      private var mKeysOwner:DCComponentUI = null;
      
      public var mTransaction:Transaction;
      
      public var mTransactionListener:DCComponent;
      
      public var mTransactionEvent:Object;
      
      public var mTransactionEventComesFrom:Object;
      
      private var mViewMode:SecureInt;
      
      private var mViewPreviousMode:SecureInt;
      
      private var mTransitionFXFunc:Function;
      
      private var mGoToRequestUserId:SecureString;
      
      private var mLastRequestUserId:SecureString;
      
      private var mGoToRequestPlanetId:SecureString;
      
      private var mLastRequestPlanetId:SecureString;
      
      private var mGoToRequestPlanetSku:SecureString;
      
      private var mGoToRequestRoleId:SecureInt;
      
      private var mGoToPlanetCheckUserCanAttack:SecureBoolean;
      
      private var mGoToPlanetCheckDamageProtection:SecureBoolean;
      
      private var mGoToPlanetCheckTargetIsAttackable:SecureBoolean;
      
      private var mGoToCurrentPlanetId:SecureString;
      
      private var mGoToCurrentStarName:SecureString;
      
      private var mGoToCurrentStarCoors:DCCoordinate;
      
      private var mGoToCurrentStarId:SecureNumber;
      
      private var mGoToCurrentStarType:SecureInt;
      
      private var mGoToAttackMode:SecureInt;
      
      private var mFutureViewId:SecureInt;
      
      private var mGoToGalaxyCoords:DCCoordinate;
      
      public var mFlowStateUnbuildMode:int = 1;
      
      private var mAttackState:SecureInt;
      
      private var mAttackRequestUserId:SecureString;
      
      private var mAttackRequestPlanetId:SecureString;
      
      private var mAttackRequestAttackMode:SecureInt;
      
      private var mAttackRequestCheckTargetIsAttackable:SecureBoolean;
      
      private var mAttackRequestPlanetSku:SecureString;
      
      private var mAttackRequestStarId:SecureNumber;
      
      private var mAttackRequestStarName:SecureString;
      
      private var mAttackRequestStarCoord:DCCoordinate;
      
      private var mAttackRequestPlanet:Planet;
      
      private var mCantAttackState:SecureInt;
      
      private var mCantAttackReasons:Vector.<String>;
      
      private var mCantAttackRivalNoAttackableParam:Object;
      
      private var mAttackIsAllowed:SecureBoolean;
      
      private var mCantAttackNotifier:DCComponent;
      
      private var mCantAttackReasonPopup:DCIPopup;
      
      private var mColonyAvailabilityPlanetSku:SecureString;
      
      private var mColonyAvailabilityPlanetParentStarId:SecureNumber;
      
      protected var mLockUIReason:int = -1;
      
      protected var mLockUIIsEnabled:Boolean;
      
      protected var mLockUITimeout:Number;
      
      protected var mLastCursorId:int = -1;
      
      private var mLockUIData:Object;
      
      private var mFunnelStepDefs:Vector.<DCDef> = null;
      
      private var mFunnelCurrentStep:SecureInt;
      
      private var mPendingTransactionsBatch:Vector.<PendingTransaction>;
      
      private var mPendingTransactionsPopup:DCIPopup;
      
      private var mPendingTransactionsIdsProcessed:Array;
      
      private var mPendingTransactionsOfferIds:Dictionary;
      
      private var mQuickAttackRequestTarget:RequestTargetQuickAttack;
      
      private var mShopControllers:Dictionary;
      
      private var mGamePaused:SecureBoolean;
      
      private var mHasLoggedOut:SecureBoolean;
      
      private var mIdleEvent:Object = null;
      
      private var mSpeechPopup:DCIPopup;
      
      private var mSpeechPopupOnAccept:Function;
      
      public function Application(stage:Stage, context:InteractiveObject, bgColor:uint)
      {
         mWaitForIntro = new SecureBoolean("Application.mWaitForIntro");
         mWaitForIntroTimeout = new SecureNumber("Application.mWaitForIntroTimeout");
         mNetworkIsBusy = new SecureBoolean("Application.mNetworkIsBusy");
         mCreditId = new SecureString("Application.mCreditId");
         mNeedsToReload = new SecureBoolean("Application.mNeedsToReload");
         mViewMode = new SecureInt("Application.mViewMode");
         mViewPreviousMode = new SecureInt("Application.mViewPreviousMode");
         mGoToRequestUserId = new SecureString("Application.mGoToRequestUserId");
         mLastRequestUserId = new SecureString("Application.mLastRequestUserId");
         mGoToRequestPlanetId = new SecureString("Application.mGoToRequestPlanetId");
         mLastRequestPlanetId = new SecureString("Application.mLastRequestPlanetId");
         mGoToRequestPlanetSku = new SecureString("Application.mGoToRequestPlanetSku");
         mGoToRequestRoleId = new SecureInt("Application.mGoToRequestRoleId");
         mGoToPlanetCheckUserCanAttack = new SecureBoolean("Application.mGoToPlanetCheckUserCanAttack");
         mGoToPlanetCheckDamageProtection = new SecureBoolean("Application.mGoToPlanetCheckDamageProtection");
         mGoToPlanetCheckTargetIsAttackable = new SecureBoolean("Application.mGoToPlanetCheckTargetIsAttackable");
         mGoToCurrentPlanetId = new SecureString("Application.mGoToCurrentPlanetId");
         mGoToCurrentStarName = new SecureString("Application.mGoToCurrentStarName");
         mGoToCurrentStarId = new SecureNumber("Application.mGoToCurrentStarId");
         mGoToCurrentStarType = new SecureInt("Application.mGoToCurrentStarType");
         mGoToAttackMode = new SecureInt("Application.mGoToAttackMode");
         mFutureViewId = new SecureInt("Application.mFutureViewId",-1);
         mAttackState = new SecureInt("Application.mAttackState");
         mAttackRequestUserId = new SecureString("Application.mAttackRequestUserId");
         mAttackRequestPlanetId = new SecureString("Application.mAttackRequestPlanetId");
         mAttackRequestAttackMode = new SecureInt("Application.mAttackRequestAttackMode");
         mAttackRequestCheckTargetIsAttackable = new SecureBoolean("Application.mAttackRequestCheckTargetIsAttackable");
         mAttackRequestPlanetSku = new SecureString("Application.mAttackRequestPlanetSku");
         mAttackRequestStarId = new SecureNumber("Application.mAttackRequestStarId");
         mAttackRequestStarName = new SecureString("Application.mAttackRequestStarName");
         mCantAttackState = new SecureInt("Application.mCantAttackState");
         mAttackIsAllowed = new SecureBoolean("Application.mAttackIsAllowed");
         mColonyAvailabilityPlanetSku = new SecureString("Application.mColonyAvailabilityPlanetSku");
         mColonyAvailabilityPlanetParentStarId = new SecureNumber("Application.mColonyAvailabilityPlanetParentStarId");
         mFunnelCurrentStep = new SecureInt("Application.mFunnelCurrentStep");
         mGamePaused = new SecureBoolean("Application.mGamePaused");
         mHasLoggedOut = new SecureBoolean("Application.mHasLoggedOut");
         super(stage,context,bgColor);
         var flashVars:Object;
         if((flashVars = Star.getFlashVars()).hasOwnProperty("waitForIntro") && flashVars["waitForIntro"])
         {
            this.mWaitForIntro.value = flashVars["waitForIntro"] == "true";
         }
         mStage.addEventListener("fullScreen",this.onFullscreenToggle);
         DCDebug.traceChObject("flashVars",flashVars);
      }
      
      public static function externalNotification(notificationId:int, data:Object = null) : void
      {
         if(data == null)
         {
            data = {};
         }
         data["notificationId"] = notificationId;
         DCDebug.traceChObject("notifReceived",data);
         if(smNotificationsQueue == null)
         {
            smNotificationsQueue = new Vector.<Object>(0);
         }
         smNotificationsQueue.push(data);
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildSyncTotalSteps = 7;
      }
      
      override protected function loadDoDoStep(step:int) : void
      {
         var displayFactory:EDisplayFactory = null;
         var eventFactory:EEventFactory = null;
         var flashVars:Object = null;
         var assetsFile:String = null;
         var browserKey:String = null;
         var maxRequestsAllowedSimultaneously:int = 0;
         var esparragon:Esparragon = null;
         GameConstants.init();
         this.mNotificationsMng = new NotificationsMng();
         InstanceMng.registerNotificationsMng(this.mNotificationsMng);
         this.mLoadingMng = new LoadingMng();
         InstanceMng.registerLoadingMng(this.mLoadingMng);
         DCMath.pulseInit();
         DCTextMng.load();
         if(Config.OFFLINE_GAMEPLAY_MODE)
         {
            this.mUserDataMng = new UserDataMngOffline();
         }
         else
         {
            this.mUserDataMng = new UserDataMngOnline();
         }
         this.mUserDataMng.login();
         InstanceMng.registerUserDataMng(this.mUserDataMng);
         this.mEselectionMng = new ESelectionCircleMng();
         InstanceMng.registerESelectionCircleMng(this.mEselectionMng);
         this.mUserInfoMng = new UserInfoMng();
         InstanceMng.registerUserInfoMng(this.mUserInfoMng);
         this.mGraphicsCacheMng = new GraphicsCacheMng();
         InstanceMng.registerGraphicsCacheMng(this.mGraphicsCacheMng);
         this.mCacheMng = new CacheMng();
         InstanceMng.registerCacheMng(this.mCacheMng);
         this.mItemsMng = new ItemsMng();
         InstanceMng.registerItemMng(this.mItemsMng);
         this.mPopupEffects = new PopupEffects();
         InstanceMng.registerPopupEffects(this.mPopupEffects);
         this.mTargetMng = new TargetMng(true);
         InstanceMng.registerTargetMng(this.mTargetMng);
         this.mMissionsMng = new MissionsMng();
         InstanceMng.registerMissionsMng(this.mMissionsMng);
         if(Config.useHappenings())
         {
            this.mHappeningMng = new HappeningMng();
            InstanceMng.registerHappeningMng(this.mHappeningMng);
         }
         if(Config.usePowerUps())
         {
            this.mPowerUpMng = new PowerUpMng();
            InstanceMng.registerPowerUpMng(this.mPowerUpMng);
         }
         if(Config.useBets())
         {
            this.mBetMng = new BetMng();
            InstanceMng.registerBetMng(this.mBetMng);
         }
         this.mContestMng = new ContestMng();
         InstanceMng.registerContestMng(this.mContestMng);
         this.mETooltipMng = ETooltipMng.getInstance();
         this.mCustomizerMng = new CustomizerMng();
         InstanceMng.registerCustomizerMng(this.mCustomizerMng);
         if(Config.useInvests())
         {
            this.mInvestMng = new InvestMng();
            InstanceMng.registerInvestMng(this.mInvestMng);
         }
         if(Config.useEsparragon())
         {
            displayFactory = new FlashDisplayFactory();
            eventFactory = new FlashEventFactory();
            this.mBehaviorsMng = new BehaviorsMng();
            InstanceMng.registerBehaviorsMng(this.mBehaviorsMng);
            this.mViewFactory = new ViewFactory();
            InstanceMng.registerViewFactory(this.mViewFactory);
            this.mSkinsMng = new SkinsMng();
            InstanceMng.registerSkinsMng(this.mSkinsMng);
            assetsFile = String((flashVars = DCApplication.stageGetParameters()).assetsLUT);
            browserKey = String(Star.flashVars.browser);
            maxRequestsAllowedSimultaneously = 2147483647;
            if(browserKey == "mozilla")
            {
               maxRequestsAllowedSimultaneously = 5;
            }
            this.mEResourcesMng = new ResourcesMng();
            InstanceMng.registerEResourcesMng(this.mEResourcesMng);
            esparragon = new Esparragon(displayFactory,eventFactory,this.mBehaviorsMng,this.mEResourcesMng,this.mSkinsMng,new Debug(),this.mViewFactory);
            this.mEResourcesMng.init(displayFactory,Config.getRoot(),assetsFile,this.mSkinsMng.getTextureBuilder,this.mViewFactory.applyTextureToImage,this.mViewFactory.onEMovieClipLoaded,maxRequestsAllowedSimultaneously);
            this.mSkinsMng.init();
         }
         this.mUIFacade = Config.useEsparragonGUI() ? new EUIFacade() : new DCUIFacade();
         InstanceMng.registerUIFacade(this.mUIFacade);
         if(Config.useQuickAttack())
         {
            this.quickAttackLoad();
         }
         if(Config.useUmbrella())
         {
            this.mUmbrellaMng = new UmbrellaMng();
            InstanceMng.registerUmbrellaMng(this.mUmbrellaMng);
            MyUnit.setUmbrellaMng(this.mUmbrellaMng);
         }
         this.mActionsLibrary = new ActionsLibrary();
         InstanceMng.registerActionsLibrary(this.mActionsLibrary);
         this.mUpSellingMng = new UpSellingMng();
         InstanceMng.registerUpSellingMng(this.mUpSellingMng);
         this.mWelcomePopupsMng = new WelcomePopupsMng();
         InstanceMng.registerWelcomePopupsMng(this.mWelcomePopupsMng);
         this.attackReset();
         this.mParticleMng = new ParticleMng();
         this.mPollMng = new PollMng();
         InstanceMng.registerPollMng(this.mPollMng);
         this.mHotkeyMng = new HotkeyMng();
         InstanceMng.registerHotkeyMng(this.mHotkeyMng);
         this.mShopsDrawer = new ShopsDrawer();
         InstanceMng.registerShopsDrawer(this.mShopsDrawer);
         this.viewSetMode(0);
         this.initGamePaused();
      }
      
      override protected function unloadDoDo() : void
      {
         EResourceDefLoaded.unloadStatic();
         DCTarget.unloadStatic();
         DCResourceDef.unloadStatic();
         GameUnit.unloadStatic();
         FlowState.unloadStatic();
         Tool.unloadStatic();
         if(this.mNotificationsMng != null)
         {
            this.mNotificationsMng.unload();
            InstanceMng.unregisterNotificationsMng();
            this.mNotificationsMng = null;
         }
         if(this.mLoadingMng != null)
         {
            this.mLoadingMng.unload();
            InstanceMng.unregisterLoadingMng();
            this.mLoadingMng = null;
         }
         this.mCreditId.value = null;
         DCAdsManager.getInstance().unload();
         this.mWishlistItemsSending = null;
         DCTextMng.unload();
         this.mUserDataMng.unload();
         this.mUserDataMng = null;
         this.mUserInfoMng.unload();
         this.mUserInfoMng = null;
         this.mGraphicsCacheMng.unload();
         this.mGraphicsCacheMng = null;
         this.mCacheMng.unload();
         this.mCacheMng = null;
         this.mItemsMng.unload();
         this.mItemsMng = null;
         this.mPopupEffects.unload();
         this.mPopupEffects = null;
         this.mTargetMng.unload();
         this.mTargetMng = null;
         this.mMissionsMng.unload();
         this.mMissionsMng = null;
         this.mCustomizerMng.unload();
         this.mCustomizerMng = null;
         if(Config.useHappenings() && this.mHappeningMng != null)
         {
            this.mHappeningMng.unload();
            this.mHappeningMng = null;
         }
         if(Config.usePowerUps() && this.mPowerUpMng != null)
         {
            this.mPowerUpMng.unload();
            this.mPowerUpMng = null;
         }
         if(Config.useBets() && this.mBetMng != null)
         {
            this.mBetMng.unload();
            this.mBetMng = null;
         }
         if(this.mContestMng != null)
         {
            this.mContestMng.unload();
            this.mContestMng = null;
         }
         if(Config.useInvests())
         {
            this.mInvestMng.unload();
            this.mInvestMng = null;
         }
         if(Config.useAlliances() && this.mAlliancesController != null)
         {
            InstanceMng.unregisterAlliancesController();
            this.mAlliancesController.unload();
            this.mAlliancesController = null;
            InstanceMng.unregisterAlliancesRewardsMng();
            this.mAlliancesRewardsMng.unload();
            this.mAlliancesRewardsMng = null;
         }
         this.pendingTransactionsUnload();
         if(Config.useQuickAttack())
         {
            this.quickAttackUnload();
         }
         this.cantAttackUnload();
         if(Config.useUmbrella())
         {
            InstanceMng.unregisterUmbrellaMng();
            this.mUmbrellaMng.unload();
            this.mUmbrellaMng = null;
         }
         this.shopControllersUnload();
         if(Config.useEsparragon())
         {
            if(this.mBehaviorsMng != null)
            {
               InstanceMng.unregisterBehaviorsMng();
               this.mBehaviorsMng.destroy();
               this.mBehaviorsMng = null;
            }
            if(this.mViewFactory != null)
            {
               InstanceMng.unregisterViewFactory();
               this.mViewFactory.destroy();
               this.mViewFactory = null;
            }
            if(this.mSkinsMng != null)
            {
               InstanceMng.unregisterSkinsMng();
               this.mSkinsMng.destroy();
               this.mSkinsMng = null;
            }
            if(this.mEResourcesMng != null)
            {
               InstanceMng.unregisterEResourcesMng();
               this.mEResourcesMng.destroy();
               this.mEResourcesMng = null;
            }
         }
         smNotificationsQueue = null;
         if(this.mActionsLibrary != null)
         {
            InstanceMng.unregisterActionsLibrary();
            this.mActionsLibrary.unload();
            this.mActionsLibrary = null;
         }
         this.transactionReset();
         this.viewUnload();
         this.transitionUnload();
         this.colonyAvailabilityUnload();
         this.lockUIUnload();
         this.funnelUnload();
         WorldItemObject.unloadStatic();
         if(this.mUpSellingMng != null)
         {
            InstanceMng.unregisterUpSellingMng();
            this.mUpSellingMng.unload();
            this.mUpSellingMng = null;
         }
         if(this.mParticleMng != null)
         {
            this.mParticleMng.unload();
            this.mParticleMng = null;
         }
         if(this.mWelcomePopupsMng != null)
         {
            this.mWelcomePopupsMng.unload();
            this.mWelcomePopupsMng = null;
         }
         if(this.mPollMng != null)
         {
            InstanceMng.unregisterPollMng();
            this.mPollMng.unload();
            this.mPollMng = null;
         }
         if(this.mHotkeyMng != null)
         {
            InstanceMng.unregisterHotkeyMng();
            this.mHotkeyMng.unload();
            this.mHotkeyMng = null;
         }
         if(this.mShopsDrawer != null)
         {
            this.mShopsDrawer.unload();
            InstanceMng.unregisterShopsDrawer();
            this.mShopsDrawer = null;
         }
         InstanceMng.unregisterDailyRewardMng();
         this.idleUnload();
         this.speechPopupUnload();
         this.reset();
      }
      
      private function reset() : void
      {
         this.mNeedsToReload.value = false;
         this.goToReset();
         this.mNetworkIsBusy.value = false;
         this.mKeysOwner = null;
         smNotificationsQueue = null;
         this.initGamePaused();
      }
      
      protected function getLoadingScreenSku() : String
      {
         if(this.getWaitForIntro())
         {
            return "loading_first";
         }
         return InstanceMng.getPlatformSettingsDefMng().getLoadingScreenSku();
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         var platformSettingsDefMng:PlatformSettingsDefMng = null;
         var langSku:String = null;
         var langId:* = null;
         var flashVars:Object = null;
         var locale:String = null;
         var languageIds:Array = null;
         var id:String = null;
         var resourceMng:ResourceMng = InstanceMng.getResourceMng();
         switch(step)
         {
            case 0:
               if(this.mEResourcesMng.isReady() && resourceMng.isBuilt() && this.mSkinsMng.isReady())
               {
                  if(Config.useRulesPackage())
                  {
                     this.mEResourcesMng.loadAsset("rules_bin","rules");
                  }
                  else
                  {
                     this.mEResourcesMng.loadAsset("platformSettingsDefinitions.xml","rules");
                  }
                  DCDebug.traceCh("version","v3");
                  buildAdvanceSyncStep();
               }
               break;
            case 1:
               platformSettingsDefMng = InstanceMng.getPlatformSettingsDefMng();
               platformSettingsDefMng.logicUpdate(0);
               if(platformSettingsDefMng.isBuilt())
               {
                  buildAdvanceSyncStep();
                  this.mEResourcesMng.loadAsset(this.getLoadingScreenSku(),"legacy");
               }
               break;
            case 2:
               if(this.mEResourcesMng.isAssetLoaded(this.getLoadingScreenSku(),"legacy"))
               {
                  this.mEResourcesMng.loadAsset("loadingText.xml","locale");
                  this.mEResourcesMng.loadAsset("loadingDefinitions.xml","rules");
                  this.mEResourcesMng.loadAsset("loadingTips.xml","rules");
                  this.fsmBuild();
                  buildAdvanceSyncStep();
               }
               break;
            case 3:
               if(this.mEResourcesMng.isAssetLoaded("loadingText.xml","locale"))
               {
                  DCTextMng.langListBuild(this.mEResourcesMng.getAssetXML("loadingText.xml","locale"));
                  langId = null;
                  if(Config.USE_LOCALE)
                  {
                     flashVars = stageGetParameters();
                     if((locale = String(flashVars.locale)) == null)
                     {
                        locale = "EN";
                     }
                     else if(locale.toLowerCase() == "pt_br")
                     {
                        locale = "br";
                     }
                     if(locale != null && locale.length > 0)
                     {
                        languageIds = DCTextMng.langListGetIds();
                        for each(id in languageIds)
                        {
                           if(locale.indexOf(id) >= 0 || locale.indexOf(id.toLowerCase()) >= 0 || locale.indexOf(id.toUpperCase()) >= 0)
                           {
                              langId = id;
                           }
                        }
                     }
                  }
                  DCTextMng.langSetLang(langId);
                  for each(var everyLang in DCTextMng.langListGetIds())
                  {
                     this.mEResourcesMng.loadAsset(everyLang,"locale");
                  }
                  buildAdvanceSyncStep();
               }
               break;
            case 4:
               if(this.mEResourcesMng.isAssetLoaded("loadingDefinitions.xml","rules"))
               {
                  buildAdvanceSyncStep();
               }
               break;
            case 5:
               if(this.mEResourcesMng.isAssetLoaded("loadingTips.xml","rules"))
               {
                  buildAdvanceSyncStep();
               }
               break;
            case 6:
               langSku = DCTextMng.lang;
               if(this.mEResourcesMng.isAssetLoaded(langSku,"locale"))
               {
                  DCTextMng.langBuild(this.mEResourcesMng.getAssetString(langSku,"locale"));
                  this.mLoadingMng.setupData(this.mEResourcesMng.getAssetXML("loadingDefinitions.xml","rules"),this.mEResourcesMng.getAssetXML("loadingTips.xml","rules"));
                  if(Config.USE_METRICS)
                  {
                     DCMetrics.sendMetric("Loading Game","1. Load Texts","First Loading");
                  }
                  buildAdvanceSyncStep();
                  break;
               }
         }
      }
      
      override public function logicUpdate(dt:int) : void
      {
         super.logicUpdate(dt);
         if(this.mNeedsToReload.value)
         {
            this.mNeedsToReload.value = false;
            unload();
            return;
         }
         if(Config.useAlliances() && this.mAlliancesController == null && InstanceMng.getUserDataMng().isLogged())
         {
            this.mAlliancesController = new AlliancesControllerStar();
            InstanceMng.registerAlliancesController(this.mAlliancesController);
            this.mAlliancesRewardsMng = new AlliancesRewardsMng();
            InstanceMng.registerAlliancesRewardsMng(this.mAlliancesRewardsMng);
         }
         if(this.mSoundManager == null)
         {
            this.mSoundManager = SoundManager.getInstance();
         }
         this.mSoundManager.logicUpdate(dt);
         CheatManager.getInstance().logicUpdate(dt);
         if(this.mEResourcesMng != null)
         {
            this.mEResourcesMng.logicUpdate(dt);
         }
         this.cantAttackLogicUpdate(dt);
         if(this.mUpSellingMng != null)
         {
            this.mUpSellingMng.logicUpdate(dt);
         }
         if(this.mParticleMng != null)
         {
            this.mParticleMng.logicUpdate(dt);
         }
         if(this.mLoadingMng != null)
         {
            this.mLoadingMng.logicUpdate(dt);
         }
         if(this.mNotificationsMng != null)
         {
            this.mNotificationsMng.logicUpdate(dt);
         }
         if(this.mWelcomePopupsMng != null)
         {
            this.mWelcomePopupsMng.logicUpdate(dt);
         }
         if(this.mShopsDrawer != null)
         {
            this.mShopsDrawer.logicUpdate(dt);
         }
         if(this.mHotkeyMng != null)
         {
            this.mHotkeyMng.logicUpdate(dt);
         }
      }
      
      override protected function logicUpdateDoDo(dt:int) : void
      {
         if(this.mLockUIIsEnabled)
         {
            this.lockUILogicUpdate(dt);
         }
         this.mUserDataMng.logicUpdate(dt);
         this.mUserInfoMng.logicUpdate(dt);
         this.externalNotificationsLogicUpdate(dt);
         this.pendingTransactionsLogicUpdate(dt);
         this.mItemsMng.logicUpdate(dt);
         this.mPopupEffects.logicUpdate(dt);
         this.mTargetMng.logicUpdate(dt);
         this.mMissionsMng.logicUpdate(dt);
         this.mETooltipMng.logicUpdate(dt);
         this.mCustomizerMng.logicUpdate(dt);
         if(Config.useHappenings())
         {
            this.mHappeningMng.logicUpdate(dt);
         }
         if(Config.usePowerUps())
         {
            this.mPowerUpMng.logicUpdate(dt);
         }
         if(Config.useBets())
         {
            this.mBetMng.logicUpdate(dt);
         }
         if(Config.useContests())
         {
            this.mContestMng.logicUpdate(dt);
         }
         if(Config.useInvests())
         {
            this.mInvestMng.logicUpdate(dt);
         }
         if(Config.useAlliances() && this.mAlliancesController != null)
         {
            this.mAlliancesController.logicUpdate(dt);
            this.mAlliancesRewardsMng.logicUpdate(dt);
         }
         if(Config.useUmbrella() && this.mUmbrellaMng != null)
         {
            this.mUmbrellaMng.logicUpdate(dt);
         }
         this.mUIFacade.logicUpdate(dt);
         if(this.mWaitForIntro.value)
         {
            this.mWaitForIntroTimeout.value += dt;
            if(InstanceMng.getSettingsDefMng().areDefsCreated())
            {
               if(this.mWaitForIntroTimeout.value >= InstanceMng.getSettingsDefMng().getWaitForIntroTimeOut())
               {
                  this.setWaitForIntro(false);
               }
            }
         }
         this.shopControllersLogicUpdate(dt);
         InstanceMng.getDailyRewardMng().logicUpdate(dt);
      }
      
      public function networkIsBusy() : Boolean
      {
         return this.mNetworkIsBusy.value;
      }
      
      override protected function onKeyDown(e:KeyboardEvent) : void
      {
         var focusObj:*;
         var inTextBox:* = (focusObj = this.stageGetStage().getImplementation().focus) is TextField;
         var goAhead:Boolean = (Config.DEBUG_MODE || UserDataMng.mUserIsVIP) && this.mHotkeyMng && !inTextBox;
         if(goAhead && this.mHotkeyMng.isControlPressed())
         {
            if(e.keyCode == 114)
            {
               InstanceMng.getSkinsMng().cycleSkin();
            }
            if(e.keyCode == 116)
            {
               InstanceMng.getUserDataMng().browserRefresh();
               return;
            }
            if(e.keyCode == 66 && Config.OFFLINE_ALLIANCES_MODE)
            {
               this.mKeysOwner = this.mKeysOwner == null ? this.mAlliancesController : null;
               return;
            }
            if(e.keyCode == 48)
            {
               InstanceMng.getUIFacade().showTextFeedback("holaaa",10000,0);
            }
            if(this.mKeysOwner != null)
            {
               this.mKeysOwner.onKeyDown(e);
            }
            else
            {
               super.onKeyDown(e);
            }
         }
      }
      
      private function onFullscreenToggle(e:Event) : void
      {
         var params:Dictionary = new Dictionary();
         params["value"] = this.isFullScreen();
         MessageCenter.getInstance().sendMessage("fullscreenSetting",params);
      }
      
      public function isFullScreen() : Boolean
      {
         var state:String = mStage.getDisplayState();
         return state == "fullScreen" || state == "fullScreenInteractive";
      }
      
      override public function notify(e:Object) : Boolean
      {
         var returnValue:Boolean = super.notify(e);
         var _loc3_:* = e.cmd;
         if("NotifyAttackAllowed" === _loc3_)
         {
            returnValue = true;
            this.attackProceed();
         }
         return returnValue;
      }
      
      override protected function fsmDoLoad() : void
      {
         mFsmStatesCount = 10;
      }
      
      override protected function fsmBuild() : void
      {
         this.mWishlistItemsSending = new Dictionary();
         mFsmStates[3] = new FlowStatePlanet();
         InstanceMng.registerFlowStatePlanet(FlowStatePlanet(mFsmStates[3]));
         mFsmStates[5] = new FlowStateGalaxy();
         InstanceMng.registerFlowStateGalaxy(FlowStateGalaxy(mFsmStates[5]));
         mFsmStates[7] = new FlowStateSolarSystem();
         InstanceMng.registerFlowStateSolarSystem(FlowStateSolarSystem(mFsmStates[7]));
         mFsmStates[0] = new FlowStateLoadingBar(mFsmStates[3],"loadingFirst");
         mFsmStates[1] = new FlowStateLoadingBarVisiting(mFsmStates[3],"loadingVisit");
         mFsmStates[2] = new FlowStateLoadingBarVisiting(mFsmStates[3],"loadingAttack");
         mFsmStates[4] = new FlowStateLoadingBarGalaxyView(mFsmStates[5],"loadingGalaxyNavigation");
         mFsmStates[6] = new FlowStateLoadingBarSolarSystem(mFsmStates[7],"loadingGalaxyNavigation");
         mFsmStates[8] = new FlowStateLoadingBarVisiting(mFsmStates[3],"loadingSpy");
         mFsmStates[9] = new FlowStateLoadingBarVisiting(mFsmStates[3],"loadingBackToPlanet");
      }
      
      override public function fsmChangeState(id:int, howToEndOutingState:int = 1, changeViewMng:Boolean = true) : void
      {
         var viewMngGame:ViewMngrGame;
         if((viewMngGame = InstanceMng.getViewMngGame()) == null)
         {
            InstanceMng.registerViewMngGame(InstanceMng.getViewMngPlanet());
         }
         super.fsmChangeState(id,howToEndOutingState,changeViewMng);
         switch(this.viewGetMode())
         {
            case 0:
               viewMngGame = InstanceMng.getViewMngPlanet();
               break;
            default:
               viewMngGame = InstanceMng.getViewMngSpace();
         }
         InstanceMng.registerViewMngGame(viewMngGame);
         if(mFsmCurrentState != null)
         {
            if(mFsmCurrentState.isALoadingState())
            {
               this.mTargetMng.end();
               this.mTargetMng.setIsAutomaticBegin(false);
               this.mMissionsMng.end();
               this.mMissionsMng.setIsAutomaticBegin(false);
            }
            else
            {
               if(Config.useAlliances())
               {
                  this.mAlliancesController.end();
               }
               this.mTargetMng.setIsAutomaticBegin(true);
               this.mMissionsMng.setIsAutomaticBegin(true);
            }
            if(this.mParticleMng != null)
            {
               this.mParticleMng.end();
            }
         }
         if(Config.DEBUG_CONSOLE)
         {
            DCDebug.traceCh("LOADING","Application:fsmChangeState id=" + id,0);
         }
      }
      
      public function isLoading() : Boolean
      {
         return mFsmCurrentState == null || mFsmCurrentState.isALoadingState();
      }
      
      public function canStartLoading() : Boolean
      {
         return !this.lockUIIsLocked() && !this.isLoading() && !InstanceMng.getUnitScene().battleIsRunning();
      }
      
      override protected function mngCreateInstanceMng() : DCInstanceMng
      {
         return new InstanceMng();
      }
      
      override protected function mngCreateResourceMng() : DCResourceMng
      {
         return new ResourceMng();
      }
      
      override protected function mngCreateRuleMng() : DCRuleMng
      {
         return new RuleMng();
      }
      
      private function externalNotificationsLogicUpdate(dt:int) : void
      {
         var userName:String = null;
         var item:ItemObject = null;
         var obj:Object = null;
         var notificationsCount:int = 0;
         var i:int = 0;
         var errObj:Object = null;
         var cash:Number = NaN;
         var coins:Number = NaN;
         var minerals:Number = NaN;
         var planetId:String = null;
         var planetSku:String = null;
         var reason:int = 0;
         var type:String = null;
         var itemsBoughtObj:Object = null;
         var itemSku:* = null;
         var itemDef:ItemsDef = null;
         var showStar:* = false;
         var pendingTransactionsXml:XML = null;
         if(smNotificationsQueue == null)
         {
            smNotificationsQueue = new Vector.<Object>(0);
         }
         else
         {
            notificationsCount = int(smNotificationsQueue.length);
            for(i = 0; i < notificationsCount; )
            {
               obj = smNotificationsQueue[i];
               if(this.isReadyForNotification(obj))
               {
                  DCDebug.traceChObject("notifServed",obj);
                  smNotificationsQueue.splice(i,1);
                  switch(obj.notificationId)
                  {
                     case 1:
                        this.mHasLoggedOut.value = true;
                        (errObj = InstanceMng.getGUIControllerPlanet().createNotifyEvent("EventPopup","NotifyErrorInfo")).title = "OUT-OF-SYNC";
                        if(obj != null)
                        {
                           errObj.msg = obj["text"];
                           type = String(obj.type);
                           errObj.errorType = type;
                        }
                        errObj.viewMng = DCInstanceMng.getInstance().getViewMng();
                        InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),errObj,true);
                        break;
                     case 34:
                        if(obj.hasOwnProperty("success") && obj["success"] == 1)
                        {
                           userName = InstanceMng.getUserInfoMng().getUserInfoObj(obj.toAccountId,0).getPlayerName();
                           item = InstanceMng.getItemsMng().getItemObjectBySku(obj.sku);
                           this.mNotificationsMng.guiOpenMessagePopup("PopupWishListItem",DCTextMng.getText(621),DCTextMng.replaceParameters(3992,[item.mDef.getNameToDisplay(),userName]),"orange_happy");
                           InstanceMng.getItemsMng().removeItemFromInventory(item,false,false);
                           InstanceMng.getApplication().setSendingWishlistItem(obj.toAccountId + obj.sku,false);
                           InstanceMng.getTargetMng().updateProgress("sendWishlistItem",1,obj.sku);
                        }
                        else
                        {
                           this.mNotificationsMng.guiOpenMessagePopup("PopupWishListItem",DCTextMng.getText(621),DCTextMng.getText(3643),"builder_worried");
                        }
                        break;
                     case 33:
                        this.mNotificationsMng.guiOpenMessageServerPopup();
                        break;
                     case 2:
                        this.mNotificationsMng.guiOpenMessageUnderAttackPopup();
                        break;
                     case 4:
                        this.msgCenterApplyMessage(obj);
                        break;
                     case 5:
                        DCDebug.traceObject(obj);
                        cash = Number(obj["cash"]);
                        coins = Number(obj["coins"]);
                        minerals = Number(obj["minerals"]);
                        InstanceMng.getUserInfoMng().getProfileLogin().addCash(cash);
                        InstanceMng.getUserInfoMng().getProfileLogin().addCoins(coins);
                        InstanceMng.getUserInfoMng().getProfileLogin().addMinerals(minerals);
                        if(obj.hasOwnProperty("items"))
                        {
                           itemsBoughtObj = obj["items"];
                           for(itemSku in itemsBoughtObj)
                           {
                              showStar = (itemDef = InstanceMng.getItemsDefMng().getDefBySku(itemSku) as ItemsDef).getMenusList().indexOf("inventory") > -1;
                              InstanceMng.getItemsMng().addItemAmount(itemSku,int(itemsBoughtObj[itemSku]),true,false,true,showStar);
                           }
                        }
                        this.transactionOk();
                        if(Config.USE_METRICS)
                        {
                           coins = Math.abs(coins);
                           minerals = Math.abs(minerals);
                           cash = Math.abs(cash);
                           if(coins != 0)
                           {
                              DCMetrics.sendMetric("Spend PC","Buy GC With PC","Coins",null,null,0,cash);
                              DCMetrics.sendMetric("Earn GC","Buy GC With PC","Coins",null,null,coins,0);
                           }
                           if(minerals != 0)
                           {
                              DCMetrics.sendMetric("Spend PC","Buy GC With PC","Minerals",null,null,0,cash);
                              DCMetrics.sendMetric("Earn GC","Buy GC With PC","Minerals",null,null,minerals,0);
                           }
                           if(itemsBoughtObj != null)
                           {
                              for(itemSku in itemsBoughtObj)
                              {
                                 DCMetrics.sendMetric("Get Items","Buy Item","Confirmed",itemSku,null,0,cash);
                              }
                           }
                        }
                        break;
                     case 6:
                        this.transactionCancel();
                        break;
                     case 7:
                        this.solarSystemInfoOk(XML(obj["xml"]));
                        break;
                     case 15:
                        this.galaxyInfoOk(XML(obj["xml"]));
                        break;
                     case 19:
                        this.neighborInfoResume(XML(obj["xml"]));
                        break;
                     case 8:
                        this.solarSystemInfoCancel();
                        break;
                     case 9:
                        this.colonyAvailabilityOk();
                        break;
                     case 10:
                        this.colonyAvailabilityCancel();
                        break;
                     case 11:
                        planetId = String(obj.planetId);
                        planetSku = String(obj.planetSku);
                        this.colonyPurchaseOk(planetId,planetSku);
                        break;
                     case 12:
                        this.colonyPurchaseCancel();
                        break;
                     case 23:
                        planetId = String(obj.planetId);
                        planetSku = String(obj.planetSku);
                        this.colonyMovedOk(planetId,planetSku);
                        break;
                     case 24:
                        this.colonyMovedCancel();
                        break;
                     case 13:
                        this.purchaseCreditsStatus(obj);
                        break;
                     case 14:
                        if(obj.status)
                        {
                           InstanceMng.getUserInfoMng().getProfileLogin().addCash(obj.value);
                        }
                        this.mCreditId.value = null;
                        this.lockUIReset();
                        break;
                     case 17:
                        InstanceMng.getPopupMng().openNetworkBusyPopup();
                        this.mNetworkIsBusy.value = true;
                        break;
                     case 18:
                        if(obj.resume != null && obj.resume)
                        {
                           InstanceMng.getPopupMng().closeNetworkBusyPopup();
                        }
                        this.mNetworkIsBusy.value = false;
                        break;
                     case 21:
                        DCDebug.traceCh("PendingTransaction","app received notif with obj = " + obj);
                        if(obj != null)
                        {
                           pendingTransactionsXml = obj.pendingTransactions;
                           this.pendingTransactionsProcessBatch(pendingTransactionsXml);
                        }
                        break;
                     case 22:
                        InstanceMng.getInvestMng().investInFriends(obj.extIds);
                        break;
                     case 25:
                        this.quickAttackSetTargetInfo(obj.userInfo as XML);
                        break;
                     case 26:
                        this.quickAttackSetNoTargetFound();
                        break;
                     case 27:
                        (errObj = InstanceMng.getGUIControllerPlanet().createNotifyEvent("EventPopup","NotifyErrorInfo")).errorType = "NOTIFY_ATTACKED_INGAME";
                        InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),errObj,true);
                        break;
                     case 28:
                        if(Config.useBets())
                        {
                           InstanceMng.getBetMng().betRequestMatched(obj.userInfo as XML);
                        }
                        break;
                     case 29:
                        InstanceMng.getUnitScene().pingReceive(obj);
                        break;
                     case 30:
                        InstanceMng.getBetMng().notifyBattleResult(obj.result as XML);
                        break;
                     case 31:
                        InstanceMng.getCreditsMng().mobilePaymentsSetDataFromServer(obj as Array);
                        break;
                     case 32:
                        reason = obj["reason"] as int;
                        InstanceMng.getUnitScene().addMessage(DCTextMng.getText(GameConstants.colonyShieldGetWarningText(reason)),5000);
                  }
                  break;
               }
               i++;
            }
         }
      }
      
      private function purchaseCreditsStatus(obj:Object) : void
      {
         DCDebug.trace("purchase credits Status: " + obj.status);
         if(obj.status)
         {
            InstanceMng.getUserDataMng().queryVerifyCreditsPurchase(true);
         }
         DCDebug.traceCh("lockUI"," reset because of purchase credits status");
         this.lockUIReset();
      }
      
      private function isReadyForNotification(obj:Object) : Boolean
      {
         var cmd:String = null;
         var popupMng:PopupMng = null;
         var returnValue:* = isBuilt();
         if(returnValue)
         {
            switch(obj.notificationId)
            {
               case 1:
                  returnValue = obj != null;
               case 33:
               case 2:
                  if(returnValue)
                  {
                     popupMng = InstanceMng.getPopupMng();
                     returnValue = popupMng != null && popupMng.isBuilt();
                  }
                  break;
               case 4:
                  if((cmd = String(obj.cmd)) == "requestScreenshot")
                  {
                     returnValue = true;
                  }
                  else
                  {
                     returnValue = InstanceMng.getItemsMng().isBuilt();
                  }
                  break;
               case 21:
                  returnValue = this.pendingTransactionsBatchIsDone() && InstanceMng.getUserInfoMng().getProfileLogin().isTutorialCompleted();
            }
         }
         return returnValue;
      }
      
      private function msgCenterApplyMessage(obj:Object) : void
      {
         var item:ItemObject = null;
         var sku:String = null;
         var toAccountId:String = null;
         var requestId:String = null;
         var platform:String = null;
         var itemSku:String = null;
         var itemsAmount:int = 0;
         var value:Boolean = false;
         var data:Object = null;
         var alliancesController:AlliancesController = null;
         var screenShotString:String = null;
         var added:Boolean = false;
         var userInfo:UserInfo = null;
         var star:String = null;
         var name:String = null;
         var index:int = 0;
         var planet:String = null;
         var userStr:* = null;
         var popup:DCIPopup = null;
         if(obj.hasOwnProperty("cmd"))
         {
            DCDebug.traceCh("msgCenter",obj.cmd);
            DCDebug.trace("message center cmd: " + obj.cmd);
            DCDebug.traceObject(obj,"message: ");
         }
         switch(obj.cmd)
         {
            case "neighbourAccepted":
               this.neighborInfoWait(obj.accountId);
               break;
            case "removeNeighbour":
               InstanceMng.getUserInfoMng().removeNeighbor(obj.accountId);
               break;
            case "replay":
               this.goToPlanet(InstanceMng.getUserDataMng().mUserAccountId,this.goToGetCurrentPlanetId(),7);
               break;
            case "muteOff":
               SoundManager.getInstance().muteOff();
               break;
            case "muteOn":
               SoundManager.getInstance().muteOn();
               break;
            case "msgCenterReceiveGift":
               item = InstanceMng.getItemsMng().getItemObjectBySku(obj.sku);
               if(item != null)
               {
                  if((added = InstanceMng.getItemsMng().incrementItemAmount(item,1,true,true)) && item.mDef.getShowInInventory())
                  {
                     this.showInventoryStar(item);
                  }
               }
               break;
            case "checkItemsAmount":
               DCDebug.trace("Checking wish list item amount availability");
               itemSku = String(obj.sku);
               itemsAmount = InstanceMng.getItemsMng().getItemObjectBySku(sku).quantity;
               InstanceMng.getUserDataMng().requestTask(UserDataMng.KEY_USER_ITEMS_AMOUNT_INFO,{
                  "sku":itemSku,
                  "amount":itemsAmount
               });
               break;
            case "introOver":
               this.setWaitForIntro(false);
               DCDebug.traceCh("LOADING","setWaitForIntro false");
               break;
            case "purchaseCreditsStatus":
               this.purchaseCreditsStatus(obj);
               break;
            case "visit":
               DCDebug.traceCh("Revenge Flow","Spy started from Battle log");
               DCDebug.traceChObject("Revenge Flow",obj);
               DCDebug.traceCh("Revenge Flow","  Can we go to another planet?");
               if(this.canStartLoading())
               {
                  DCDebug.traceCh("Revenge Flow","    Yes. Go to spy user " + obj.accountId);
                  if(obj.accountId != null)
                  {
                     userInfo = InstanceMng.getUserInfoMng().getUserInfoObj(obj.accountId,0);
                     star = String(obj.star);
                     index = (name = String(obj.userName)).indexOf(" ");
                     if(obj.planet != null)
                     {
                        planet = String(obj.planet);
                     }
                     if(index > 0)
                     {
                        name = name.substr(0,index);
                     }
                     star = star.replace(",",":").replace(",",":");
                     if(userInfo == null)
                     {
                        name = name.replace("\'","&apos;");
                        userStr = "<pvpSpy accountId=\'" + obj.accountId + "\' name=\'" + name + "\' url=\'" + obj.pictureUrl + "\'/>";
                        InstanceMng.getUserInfoMng().addOtherPlayerInfo(EUtils.stringToXML(userStr));
                     }
                     else
                     {
                        userInfo.setPlayerName(name);
                        userInfo.setThumbnailURL(obj.pictureUrl);
                     }
                     if(planet != null)
                     {
                        this.goToPlanet(obj.accountId,planet,2,star);
                     }
                     else
                     {
                        this.goToPlanet(obj.accountId,"-2",2,star);
                     }
                  }
               }
               break;
            case "canSpy":
               DCDebug.traceChObject("Revenge Flow",obj);
               DCDebug.traceCh("Revenge Flow","Check if the game is ready to spy. GUI locked? " + this.lockUIIsLocked() + " | Game is loading? " + this.isLoading() + " | Battle is running?" + InstanceMng.getUnitScene().battleIsRunning());
               (data = {}).cmd = UserDataMng.KEY_SPY_STATUS;
               data.status = this.canStartLoading();
               InstanceMng.getUserDataMng().requestTask(UserDataMng.KEY_SPY_STATUS,data);
               break;
            case "allianceInviteAccepted":
               DCDebug.traceCh("ALLIANCES","Invitation to alliance accepted");
               if((alliancesController = InstanceMng.getAlliancesController()) != null)
               {
                  alliancesController.initializeSetup(0);
               }
               break;
            case "allianceInvitationsSent":
               if(obj.hasOwnProperty("to"))
               {
                  InstanceMng.getAlliancesController().remindersAddInvitations(obj.to);
                  if((popup = InstanceMng.getPopupMng().getPopupBeingShown()) is EPopupAlliances)
                  {
                     EPopupAlliances(popup).reloadPopup();
                  }
               }
               break;
            case "socialWallOpened":
               this.pauseGame();
               DCDebug.traceCh("spilAd","pausing game");
               break;
            case "socialWallClosed":
               this.resumeGame();
               if(!this.idleHasBeenToldToOpen())
               {
                  InstanceMng.getFlowState().removeFreezedImage();
               }
               DCDebug.traceCh("spilAd","unpausing game");
               break;
            case "currencyPlatform":
               DCDebug.traceCh("payments","currencyPlatform currency = " + obj.user_currency + " exchange = " + obj.currency_exchange_inverse);
               InstanceMng.getRuleMng().setUserCurrency(obj.user_currency,obj.usd_exchange_inverse / 10);
               break;
            case "promotionStatus":
               if(InstanceMng.getPlatformSettingsDefMng().isPaymentsEnabled())
               {
                  if(obj.is_eligible_promo != null && obj.is_eligible_promo == 1)
                  {
                     InstanceMng.getUserInfoMng().getProfileLogin().setShowOfferNewPayerPromo(true);
                     InstanceMng.getTopHudFacade().refreshVisibilityOfferButton();
                  }
               }
               break;
            case "mobilePricePoints":
               if(obj.mobile != null)
               {
                  DCDebug.traceChObject("payments","mobilePayments");
                  DCDebug.traceChObject("payments",obj.mobile);
                  InstanceMng.getCreditsMng().mobilePaymentsSetDataFromJavascript(obj.mobile);
               }
               break;
            case "requestScreenshot":
               screenShotString = stageExportScreenshot(0.25);
               InstanceMng.getUserDataMng().requestTask(UserDataMng.KEY_SEND_STAGE_SCREENSHOT,{"image":screenShotString});
               if(obj.extraTask != null)
               {
                  InstanceMng.getUserDataMng().requestTask(obj.extraTask);
               }
               break;
            case "wishlistSentItem":
         }
      }
      
      override public function getCurrentServerTimeMillis() : Number
      {
         return InstanceMng.getUserDataMng().getServerCurrentTimemillis();
      }
      
      override public function startResetTargetEvents(targetId:String) : void
      {
         var resetObj:Object = InstanceMng.getGUIControllerPlanet().createNotifyEvent("EventPopup","NotifyMissionExpired");
         resetObj.title = DCTextMng.getText(191);
         resetObj.msg = DCTextMng.getText(234);
         resetObj.targetId = targetId;
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),resetObj);
         var target:DCTarget = InstanceMng.getTargetMng().getTargetById(targetId);
         target.resetTarget();
         var targetCondition:DCCondition;
         if((targetCondition = target.getCondition()) is ConditionComposite)
         {
            ConditionComposite(targetCondition).cleanCondition();
         }
         else
         {
            targetCondition.setConditionAlreadyNotified(false);
         }
         target.changeState(1);
      }
      
      override public function updateTargetProgressOnServer(info:Object) : void
      {
         var missionSku:String = null;
         var targetIndex:int = 0;
         var amount:int = 0;
         var trans:Transaction = null;
         if(InstanceMng.getUserInfoMng().getProfileLogin().isTutorialCompleted())
         {
            missionSku = String(info.sku);
            targetIndex = int(info.index);
            amount = int(info.amount);
            trans = info.transaction;
            InstanceMng.getUserDataMng().updateTargets_addProgress(missionSku,targetIndex,amount,trans);
         }
      }
      
      private function transactionReset() : void
      {
         this.mTransaction = null;
         this.mTransactionListener = null;
         this.mTransactionEvent = null;
         this.mTransactionEventComesFrom = null;
      }
      
      public function transactionOk() : void
      {
         this.transactionResume(true);
      }
      
      public function transactionCancel() : void
      {
         this.transactionResume(false);
      }
      
      private function transactionResume(ok:Boolean) : void
      {
         var infoPackage:Object = null;
         var infoPackageTransaction:Transaction = null;
         if(this.mTransaction != null && this.mTransactionListener != null)
         {
            if(this.mTransactionEvent == null)
            {
               this.mTransactionEvent = {};
            }
            else
            {
               this.mTransactionEvent.typeOrig = this.mTransactionEvent.type;
               this.mTransactionEvent.cmdOrig = this.mTransactionEvent.cmd;
            }
            this.mTransactionEvent.type = "NOTIFY_SERVER_RESPONSE";
            this.mTransactionEvent.cmd = ok ? "EventServerTransOK" : "EventServerTransCancel";
            infoPackage = this.mTransaction.getTransInfoPackage();
            if(infoPackage != null)
            {
               infoPackageTransaction = infoPackage.transaction;
            }
            this.mTransaction.setTransHasReceivedServerResponse(true);
            InstanceMng.getNotifyMng().addEvent(this.mTransactionListener,this.mTransactionEvent,true);
            if(this.lockUIGetReason() == 1)
            {
               this.lockUIReset();
            }
            infoPackage = this.mTransaction.getTransInfoPackage();
            if(infoPackage != null)
            {
               infoPackageTransaction = infoPackage.transaction;
            }
            else
            {
               infoPackageTransaction = null;
            }
            if(ok)
            {
               if(this.mTransactionEventComesFrom != null)
               {
                  infoPackageTransaction = this.mTransactionEventComesFrom.transaction;
                  if(infoPackageTransaction != null && !infoPackageTransaction.getTransHasBeenPerformed())
                  {
                     InstanceMng.getGUIController().performTransactionWhenServerResponseReceived(this.mTransactionEventComesFrom,infoPackageTransaction);
                  }
               }
               else if(infoPackageTransaction != null && !infoPackageTransaction.getTransHasBeenPerformed())
               {
                  InstanceMng.getGUIController().performTransactionWhenServerResponseReceived(infoPackage,this.mTransaction);
               }
            }
            this.transactionReset();
         }
      }
      
      public function transactionWait(trans:Transaction, listener:DCComponent, e:Object = null) : Boolean
      {
         var returnValue:Boolean = true;
         if(this.mTransaction == null && this.mTransactionListener == null)
         {
            this.mTransaction = trans;
            this.mTransactionListener = listener;
            this.mTransactionEvent = e;
            this.mTransactionEventComesFrom = null;
            if(trans.getTransactionNeedsServerResponse())
            {
               InstanceMng.getUserDataMng().queryVerifyMoneyTransaction(this.mTransaction);
               this.lockUIWaitForPayment();
            }
            else
            {
               this.transactionOk();
            }
         }
         else
         {
            returnValue = false;
            DCDebug.trace("It should only be one transaction on hold at a time.",1);
         }
         return returnValue;
      }
      
      private function viewUnload() : void
      {
         this.mViewMode.value = 0;
         this.mViewPreviousMode.value = this.mViewMode.value;
      }
      
      private function viewSetMode(mode:int) : void
      {
         if(Config.USE_SOUNDS)
         {
            if(this.mViewMode.value == 0 && mode != 0 || this.mViewMode.value != 0 && mode == 0)
            {
               SoundManager.getInstance().stopAll(false,false);
            }
         }
         this.mViewPreviousMode.value = this.mViewMode.value;
         this.mViewMode.value = mode;
      }
      
      public function viewGetMode() : int
      {
         return this.mViewMode.value;
      }
      
      public function viewIsChangingOfView() : Boolean
      {
         return this.mViewMode.value != this.mViewPreviousMode.value;
      }
      
      public function viewGetPreviousMode() : int
      {
         return this.mViewPreviousMode.value;
      }
      
      private function transitionUnload() : void
      {
         this.mTransitionFXFunc = null;
      }
      
      public function getDisplayObjectContainerByView() : DisplayObjectContainer
      {
         var doc:DisplayObjectContainer = null;
         switch(this.mViewMode.value)
         {
            case 0:
               doc = ViewMngPlanet(InstanceMng.getViewMng()).createDOCForZoomOutPlanet();
               break;
            case 1:
               doc = InstanceMng.getMapViewSolarSystem().getBackGroundDO();
               break;
            case 2:
               doc = InstanceMng.getMapViewGalaxy().getScene();
         }
         return doc;
      }
      
      private function performTransitionFXEnd() : void
      {
         var mapView:MapView = InstanceMng.getMapView();
         mapView.unlock();
         this.mTransitionFXFunc();
      }
      
      private function performTransitionFX(goToFunction:Function) : void
      {
         var targetPoint:Point = null;
         var zoomMode:int = 0;
         var targetScale:Number = NaN;
         var targetAlpha:Number = NaN;
         var duration:Number = NaN;
         var easeScale:Function = null;
         var mapView:MapView = null;
         var tool:Tool;
         if((tool = InstanceMng.getToolsMng().getCurrentTool()).isSelectionMade())
         {
            tool.destroySelection();
         }
         if(tool.mId != 0)
         {
            InstanceMng.getToolsMng().setTool(0);
         }
         var doc:DisplayObjectContainer;
         if((doc = this.getDisplayObjectContainerByView()) != null && this.isHighQualityEnabled())
         {
            targetPoint = this.getCoordsToCenterZoomWhenLeavingView(doc);
            zoomMode = 1;
            targetScale = 0.25;
            targetAlpha = 1;
            duration = 1;
            easeScale = Exponential.easeIn;
            InstanceMng.getGUIController().hideOpenedBar();
            InstanceMng.getGUIController().hideHud();
            mapView = InstanceMng.getMapView();
            mapView.uiDisable(true,true);
            mapView.lock();
            switch(this.mFutureViewId.value)
            {
               case 0:
                  if(this.mViewMode.value != 0)
                  {
                     zoomMode = 0;
                     targetScale = 3;
                     break;
                  }
                  if(this.hasToShowZoomOutFX() == false)
                  {
                     TweenEffectsFactory.createTransitionAlpha(doc,duration,1,0,easeScale,Exponential.easeOut,goToFunction);
                     return;
                  }
                  break;
               case 1:
                  if(this.mViewMode.value != 0)
                  {
                     zoomMode = 0;
                     easeScale = Exponential.easeInOut;
                     if(targetPoint != null)
                     {
                        targetScale = 3;
                     }
                  }
            }
            if(this.mViewMode.value == 0)
            {
               duration = 0.6;
            }
            targetAlpha = 0;
            this.mTransitionFXFunc = goToFunction;
            TweenEffectsFactory.createTransition(doc,duration,new Point(mStage.getStageWidth() / 2,mStage.getStageHeight() / 2),targetPoint,1,targetScale,1,targetAlpha,easeScale,Exponential.easeOut,this.performTransitionFXEnd);
         }
         else
         {
            goToFunction();
         }
      }
      
      private function hasToShowZoomOutFX() : Boolean
      {
         var oldPlanetId:String = null;
         var returnValue:* = true;
         if(this.mUserInfoMng.getCurrentProfileLoaded().getAccountId() == this.mGoToRequestUserId.value)
         {
            oldPlanetId = InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj().getLastOwnerPlanetIdVisited();
            returnValue = oldPlanetId != this.mGoToCurrentPlanetId.value;
         }
         return returnValue;
      }
      
      public function getCoordsToCenterZoomWhenLeavingView(doc:DisplayObjectContainer = null) : Point
      {
         var bgDocX:int = 0;
         var bgDocY:int = 0;
         var userInfo:UserInfo = null;
         var planetDOC:DisplayObjectContainer = null;
         var solarSystemView:DisplayObjectContainer = null;
         var galaxySceneLayer:DisplayObjectContainer = null;
         var viewMng:ViewMngPlanet = null;
         var coord:DCCoordinate = null;
         var p:Point = null;
         switch(this.viewGetMode())
         {
            case 0:
               viewMng = InstanceMng.getViewMngPlanet();
               p = new Point(mStage.getStageWidth() / 2,mStage.getStageHeight() / 2);
               break;
            case 1:
               bgDocX = InstanceMng.getMapViewSolarSystem().getBackGroundDO().x;
               bgDocY = InstanceMng.getMapViewSolarSystem().getBackGroundDO().y;
               switch(this.mFutureViewId.value)
               {
                  case 0:
                     if((userInfo = InstanceMng.getUserInfoMng().getUserInfoObj(this.mGoToRequestUserId.value,0)) != null)
                     {
                        if((planetDOC = InstanceMng.getMapViewSolarSystem().getPlanetDisplayObject(this.mGoToRequestUserId.value,this.mGoToRequestPlanetId.value,userInfo.mIsNPC.value)) != null)
                        {
                           p = new Point(planetDOC.x,planetDOC.y);
                           p = planetDOC.parent.localToGlobal(p);
                        }
                        break;
                     }
               }
               break;
            case 2:
               switch(this.mFutureViewId.value)
               {
                  case 0:
                  case 1:
                     if((solarSystemView = InstanceMng.getMapViewGalaxy().getStarViewByCoords(this.mGoToCurrentStarCoors)) != null)
                     {
                        galaxySceneLayer = InstanceMng.getMapViewGalaxy().getScene();
                        p = new Point(solarSystemView.x,solarSystemView.y);
                        p = galaxySceneLayer.localToGlobal(p);
                        break;
                     }
               }
         }
         return p;
      }
      
      private function goToReset() : void
      {
         this.mGoToRequestUserId.value = null;
         this.mLastRequestUserId.value = null;
         this.mGoToRequestPlanetId.value = null;
         this.mLastRequestPlanetId.value = null;
         this.mGoToRequestPlanetSku.value = null;
         this.mGoToRequestRoleId.value = 0;
         this.mGoToPlanetCheckUserCanAttack.value = false;
         this.mGoToPlanetCheckDamageProtection.value = false;
         this.mGoToPlanetCheckTargetIsAttackable.value = false;
         this.mGoToCurrentPlanetId.value = null;
         this.mGoToCurrentStarName.value = null;
         this.mGoToCurrentStarCoors = null;
         this.mGoToCurrentStarId.value = 0;
         this.mGoToCurrentStarType.value = 0;
         this.mFutureViewId.value = -1;
         this.mGoToGalaxyCoords = null;
         this.mFlowStateUnbuildMode = 1;
      }
      
      public function goToGetRequestUserId() : String
      {
         return this.mGoToRequestUserId.value;
      }
      
      public function goToGetRequestRoleId() : int
      {
         return this.mGoToRequestRoleId.value;
      }
      
      public function calculateGalaxyWindowByCoord(coord:DCCoordinate) : Object
      {
         var returnValue:Object = {};
         var value:int = 0;
         var coordMin:DCCoordinate = new DCCoordinate();
         var coordMax:DCCoordinate = new DCCoordinate();
         if(coord != null)
         {
            value = int(coord.x - 20 > 0 ? int(coord.x - 20) : 0);
            coordMin.x = value;
            value = int(coord.y - 20 > 0 ? int(coord.y - 20) : 0);
            coordMin.y = value;
            value = int(coord.x + 20 > 0 ? int(coord.x + 20) : 0);
            coordMax.x = value;
            value = int(coord.y + 20 > 0 ? int(coord.y + 20) : 0);
            coordMax.y = value;
         }
         else
         {
            coordMin.x = 0;
            coordMin.y = 0;
            coordMax.x = 0;
            coordMax.y = 0;
         }
         returnValue.coordMin = coordMin;
         returnValue.coordMax = coordMax;
         return returnValue;
      }
      
      public function goToGalaxy(tween:GTween = null) : void
      {
         InstanceMng.getUserInfoMng().setUserToVisit(null);
         this.viewSetMode(2);
         var coordObj:Object = this.calculateGalaxyWindowByCoord(this.mGoToGalaxyCoords);
         FlowStateLoadingBarGalaxyView.setCoordinates(this.mGoToGalaxyCoords,coordObj.coordMin,coordObj.coordMax);
         this.mFlowStateUnbuildMode = 2;
         this.fsmChangeState(4,1);
         InstanceMng.getFlowState().changeRole(0);
      }
      
      public function goToGalaxyCenteredByStarCoord(coords:DCCoordinate) : void
      {
         this.mFutureViewId.value = 2;
         this.mGoToGalaxyCoords = coords;
         this.performTransitionFX(this.goToGalaxy);
      }
      
      public function goToCurrentStar() : void
      {
         var notification:Notification = null;
         if(this.mGoToCurrentStarId.value != 0)
         {
            this.goToSolarSystem(this.mGoToCurrentStarCoors,this.mGoToCurrentStarName.value,this.mGoToCurrentStarId.value,this.mGoToCurrentStarType.value);
         }
         else
         {
            notification = this.mNotificationsMng.createNotificationUserHasLostStarDueInactivity();
            this.mNotificationsMng.guiOpenNotificationMessage(notification);
         }
      }
      
      public function goToSolarSystem(starCoords:DCCoordinate, starName:String, starId:Number, starType:int) : void
      {
         var profile:Profile = null;
         var curPlanet:Planet = null;
         if(starCoords == null)
         {
            curPlanet = (profile = InstanceMng.getUserInfoMng().getProfileLogin()).getUserInfoObj().getPlanetById(profile.getCurrentPlanetId());
            this.mGoToCurrentStarName.value = curPlanet.getParentStarName();
            this.mGoToCurrentStarCoors = curPlanet.getParentStarCoords();
            this.mGoToCurrentStarId.value = curPlanet.getParentStarId();
            this.mGoToCurrentStarType.value = curPlanet.getParentStarType();
         }
         else
         {
            this.mGoToCurrentStarName.value = starName;
            this.mGoToCurrentStarCoors = starCoords;
            this.mGoToCurrentStarId.value = starId;
            this.mGoToCurrentStarType.value = starType;
         }
         this.mFutureViewId.value = 1;
         this.mFlowStateUnbuildMode = 2;
         this.performTransitionFX(this.goToSolarSystemAction);
      }
      
      private function goToSolarSystemAction(tween:GTween = null) : void
      {
         InstanceMng.getUserInfoMng().setUserToVisit(null);
         this.viewSetMode(1);
         FlowStateLoadingBarSolarSystem.setCoordinates(this.mGoToCurrentStarCoors);
         FlowStateLoadingBarSolarSystem.setStarId(this.mGoToCurrentStarId.value);
         FlowStateLoadingBarSolarSystem.setStarType(this.mGoToCurrentStarType.value);
         InstanceMng.getApplication().fsmChangeState(6,1);
         InstanceMng.getFlowState().changeRole(0);
      }
      
      public function requestPlanet(accountId:String, planetId:String, roleId:int, planetSku:String = null, checkUserCanAttack:Boolean = true, checkDamageProtection:Boolean = true, checkTargetIsAttackable:Boolean = true, starId:Number = -1, starName:String = null, starCoord:DCCoordinate = null, lockApplied:Boolean = false, attackMode:int = 0, planet:Planet = null) : void
      {
         if(roleId == 3)
         {
            this.attackRequest(accountId,planetId,attackMode,checkUserCanAttack,checkTargetIsAttackable,planetSku,starId,starName,starCoord,planet);
         }
         else
         {
            this.goToPlanet(accountId,planetId,roleId,planetSku,checkUserCanAttack,checkDamageProtection,checkTargetIsAttackable,starId,starName,starCoord,lockApplied,attackMode,planet);
            InstanceMng.getToolsMng().setTool(0);
         }
      }
      
      private function goToPlanet(accountId:String, planetId:String, roleId:int, planetSku:String = null, checkUserCanAttack:Boolean = true, checkDamageProtection:Boolean = true, checkTargetIsAttackable:Boolean = true, starId:Number = -1, starName:String = null, starCoord:DCCoordinate = null, lockApplied:Boolean = false, attackMode:int = 0, planet:Planet = null) : void
      {
         DCDebug.traceCh("AttackLogic","[APP] goToPlanet accountId = " + accountId + " | planetId = " + planetId + " | roleId = " + roleId + " | planetSku = " + planetSku + " | checkCanAttack? " + checkUserCanAttack + " | checkDmgProt? " + checkDamageProtection + " checkTargetAtkable? " + checkTargetIsAttackable);
         var attackObject:Object = null;
         var canBeAttacked:Boolean = false;
         var ownerHasDamageProtection:Boolean = false;
         var t:Transaction = null;
         if(InstanceMng.getBuildingsBufferController().isBufferOpen())
         {
            InstanceMng.getUIFacade().getBuildingsBufferBar().closeBufferBar();
         }
         if(roleId != 0 && roleId != 7 && roleId != 5 && accountId == InstanceMng.getUserDataMng().mUserAccountId)
         {
            roleId = 0;
         }
         DCDebug.trace("--->>REQUESTING GO TO PLANETId: " + planetId);
         this.mGoToRequestUserId.value = accountId;
         this.mLastRequestUserId.value = this.mGoToRequestUserId.value;
         this.mGoToRequestPlanetId.value = planetId == "-2" ? "1" : planetId;
         this.mLastRequestPlanetId.value = this.mGoToRequestPlanetId.value;
         this.mGoToRequestPlanetSku.value = planetSku;
         this.mGoToRequestRoleId.value = roleId;
         this.mGoToPlanetCheckUserCanAttack.value = checkUserCanAttack;
         this.mGoToPlanetCheckDamageProtection.value = checkDamageProtection;
         this.mGoToPlanetCheckTargetIsAttackable.value = checkTargetIsAttackable;
         this.mGoToCurrentStarId.value = starId;
         this.mGoToCurrentStarCoors = starCoord;
         this.mGoToCurrentStarName.value = starName;
         this.mGoToAttackMode.value = attackMode;
         var isAttackModeNormal:* = attackMode == 0;
         var changePlanetOk:Boolean = true;
         var event:* = null;
         var eventNotifier:DCComponent = InstanceMng.getGUIController();
         var userInfoMng:UserInfoMng;
         var userInfo:UserInfo = (userInfoMng = InstanceMng.getUserInfoMng()).getUserInfoObj(this.mGoToRequestUserId.value,0);
         if(this.mGoToRequestRoleId.value == 3)
         {
            changePlanetOk = false;
            canBeAttacked = true;
            DCDebug.traceCh("AttackLogic","[APP] GoToPlanet is attack");
            DCDebug.traceCh("AttackLogic","[APP] userInfo = " + userInfo + " | planet from userInfo = " + planet + " | planetId = " + this.mGoToRequestPlanetId.value);
            attackObject = this.createIsAttackableObject(this.mAttackRequestUserId.value,planet,false,false,isAttackModeNormal,false);
            if(this.mGoToPlanetCheckUserCanAttack.value)
            {
               canBeAttacked = Boolean(attackObject.isAttackable);
            }
            DCDebug.traceCh("AttackLogic","[APP] GoToPlanet planet = " + planet + " | canBeAttacked? " + canBeAttacked);
            if(canBeAttacked)
            {
               if((ownerHasDamageProtection = this.mGoToPlanetCheckDamageProtection.value && userInfoMng.getProfileLogin().getProtectionTimeLeft() > 0) && !userInfo.mIsNPC.value && (attackObject.isAllianceAttack == false || attackObject.isAllianceAttack == null))
               {
                  (event = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NotifyDamageProtectionWarning")).userInfo = userInfo;
               }
               else if(this.mGoToPlanetCheckTargetIsAttackable.value && isAttackModeNormal && userInfo != null && !userInfo.mIsNPC.value)
               {
                  this.lockUIWaitForAttackAllowed();
                  DCDebug.trace("--->>CHECK IS ATTACKABLE PLANETId: " + this.mGoToRequestPlanetId.value);
                  InstanceMng.getUserDataMng().requestTask(UserDataMng.KEY_CHECK_AVAILABLE_ATTACK,{
                     "userId":this.mGoToRequestUserId.value,
                     "planetId":this.mGoToRequestPlanetId.value,
                     "applyLock":0
                  });
               }
               else
               {
                  changePlanetOk = true;
               }
            }
            else
            {
               if(attackObject.lockType != null)
               {
                  this.lockUIOpenPopupBasedOnResponse(attackObject);
                  return;
               }
               event = attackObject;
            }
         }
         if(event == null)
         {
            if(changePlanetOk)
            {
               if(this.mGoToRequestRoleId.value == 3 && this.mGoToAttackMode.value == 0)
               {
                  DCDebug.trace("--->>REQUESTING ATTACK PLANETId: " + this.mGoToRequestPlanetId.value);
                  (event = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NOTIFY_ATTACK_DISTANCE")).userInfo = userInfo;
                  event.goToRequestUserId = this.mGoToRequestUserId.value;
                  event.goToRequestPlanetId = this.mGoToRequestPlanetId.value;
                  event.goToRequestPlanetSku = this.mGoToRequestPlanetSku.value;
                  event.goToRequestStarId = starId;
                  event.goToRequestStarName = starName;
                  event.goToRequestStarCoord = starCoord;
                  event.lockApplied = lockApplied;
                  if(InstanceMng.getGUIController().getIsAttackWaitingForServerResponse() == true)
                  {
                     event.phase = "OUT";
                  }
               }
               else if(this.mGoToAttackMode.value == 1)
               {
                  event = InstanceMng.getGUIController().createNotifyEvent("EventFlow","NOTIFY_FLOW_QUICK_ATTACK");
                  (t = InstanceMng.getRuleMng().getTransactionQuickAttack(Config.useQuickAttackFirstTimeFree() && InstanceMng.getRole().mId != 3,event)).setCloseOpenedPopups(false);
                  event.starId = starId;
                  event.starName = starName;
                  event.starCoord = starCoord;
                  event.performTransition = true;
                  event.transaction = t;
                  event.resumeOperation = true;
                  event.sendResponseTo = eventNotifier;
               }
               else
               {
                  this.changePlanet(starId,starName,starCoord,planetId != "-2");
               }
            }
         }
         if(event)
         {
            InstanceMng.getNotifyMng().addEvent(eventNotifier,event,true);
         }
      }
      
      public function canUserBeAttacked(userInfo:UserInfo) : void
      {
         var attackObject:Object = this.createIsAttackableObject(userInfo.mAccountId,InstanceMng.getUserInfoMng().getUserInfoObj(this.mGoToRequestUserId.value,0).getPlanetById(this.mGoToRequestPlanetId.value),false,true);
         if(userInfo != null)
         {
            if(attackObject != null)
            {
               if(!attackObject.isAttackable)
               {
                  this.mUIFacade.hudDisableAttackButton(this.getLockUIMessage(attackObject));
               }
               else if(!userInfo.mIsNPC.value)
               {
                  this.lockUIWaitForAttackAllowedDisablingAttackButton();
                  InstanceMng.getUserDataMng().requestTask(UserDataMng.KEY_CHECK_AVAILABLE_ATTACK,{
                     "userId":userInfo.mAccountId,
                     "planetId":this.mGoToRequestPlanetId.value,
                     "applyLock":0
                  });
               }
            }
         }
      }
      
      public function isAttackFree(attackedPlanetSku:String, uInfoAttacked:UserInfo) : Boolean
      {
         var attackingPlanet:Planet;
         var profileLogin:Profile;
         var attackingPlanetSku:String = (attackingPlanet = (profileLogin = InstanceMng.getUserInfoMng().getProfileLogin()).getUserInfoObj().getPlanetById(profileLogin.getCurrentPlanetId())).getSku();
         var distance:int = Math.floor(InstanceMng.getMapViewGalaxy().getDistanceBetweenPlanets(attackingPlanetSku,attackedPlanetSku));
         var mineralCost:int = InstanceMng.getRuleMng().getAttackDistanceMineralCostByDistance(distance);
         var attackPercentage:int;
         if((attackPercentage = uInfoAttacked.getAttackCostPercentage()) > 0)
         {
            mineralCost = InstanceMng.getRuleMng().getAmountDependingOnCapacity(attackPercentage,false);
         }
         return mineralCost == 0;
      }
      
      public function goToHomePlanet() : void
      {
         var profile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         var userInfo:UserInfo = profile.getUserInfoObj();
         this.goToPlanet(userInfo.mAccountId,userInfo.getLastOwnerPlanetIdVisited(),0);
      }
      
      public function changePlanet(starId:Number = -1, starName:String = null, starCoord:DCCoordinate = null, performTransition:Boolean = true) : void
      {
         this.mFutureViewId.value = 0;
         var userInfo:UserInfo;
         var userInfoMng:UserInfoMng;
         if((userInfo = (userInfoMng = InstanceMng.getUserInfoMng()).getUserInfoObj(this.mGoToRequestUserId.value,0)) != null)
         {
            this.goToSetCurrentDestinationInfo(this.mGoToRequestPlanetId.value,userInfo,starId,starName,starCoord);
         }
         this.mFlowStateUnbuildMode = this.mGoToRequestRoleId.value == 0 || this.mGoToRequestRoleId.value == 7 ? 1 : 2;
         if(performTransition)
         {
            this.performTransitionFX(this.changePlanetDo);
         }
         else
         {
            this.changePlanetDo();
         }
      }
      
      private function changePlanetDo(tween:GTween = null) : void
      {
         var timeLeft:Number = NaN;
         var userInfoMng:UserInfoMng;
         var profileLogin:Profile = (userInfoMng = InstanceMng.getUserInfoMng()).getProfileLogin();
         var profileCurrent:Profile = userInfoMng.getCurrentProfileLoaded();
         var userInfo:UserInfo = userInfoMng.getUserInfoObj(this.mGoToRequestUserId.value,0);
         this.viewSetMode(0);
         if(this.mGoToRequestRoleId.value == 3 && (userInfo == null || userInfo.mIsNPC.value == false))
         {
            if((timeLeft = profileLogin.getProtectionTimeLeft()) > 0)
            {
               profileLogin.setProtectionTimeLeft(0);
            }
         }
         InstanceMng.getTrafficMng().civilsLoad();
         if(this.mGoToRequestRoleId.value == 0)
         {
            this.mUIFacade.friendsBarSetSelectedFriendFromList(this.mGoToRequestUserId.value);
            InstanceMng.getUserInfoMng().setUserToVisit(null);
            InstanceMng.getUserInfoMng().getProfileLogin().setCurrentPlanetId(this.mGoToRequestPlanetId.value);
            if(profileLogin != profileCurrent)
            {
               InstanceMng.getFlowStatePlanet().setPlayerIsBackFromVisiting(true);
            }
         }
         else
         {
            if(this.mGoToRequestRoleId.value == 1 || this.mGoToRequestRoleId.value == 2)
            {
               this.mUIFacade.friendsBarSetSelectedFriendFromList(this.mGoToRequestUserId.value);
            }
            else
            {
               this.mUIFacade.friendsBarSetSelectedFriendFromList();
            }
            InstanceMng.getUserInfoMng().setUserToVisit(userInfo);
         }
         InstanceMng.getFlowStatePlanet().visitFriendWorld(this.mGoToRequestUserId.value,this.mGoToRequestRoleId.value,this.mGoToRequestPlanetId.value,this.mGoToRequestPlanetSku.value);
      }
      
      public function goToGetCurrentPlanetId() : String
      {
         return this.mGoToCurrentPlanetId.value;
      }
      
      private function goToSetCurrentPlanetId(value:String) : void
      {
         this.mGoToCurrentPlanetId.value = value == "-2" ? "1" : value;
      }
      
      public function goToGetRequestPlanetSku() : String
      {
         return this.mGoToRequestPlanetSku.value;
      }
      
      public function goToGetCurrentStarName() : String
      {
         return this.mGoToCurrentStarName.value;
      }
      
      public function goToGetCurrentStarCoors() : DCCoordinate
      {
         return this.mGoToCurrentStarCoors;
      }
      
      public function goToGetCurrentStarId() : Number
      {
         return this.mGoToCurrentStarId.value;
      }
      
      public function goToGetCurrentStarType() : int
      {
         return this.mGoToCurrentStarType.value;
      }
      
      public function goToSetCurrentDestinationInfo(planetId:String, userInfo:UserInfo, starId:Number = -1, starName:String = null, starCoords:DCCoordinate = null, planetSku:String = null) : void
      {
         var planet:Planet = null;
         var uInfoLogin:UserInfo = null;
         if(planetId == "-2")
         {
            planetId = "1";
         }
         this.goToSetCurrentPlanetId(planetId);
         if(userInfo.mPlanets == null)
         {
            userInfo.buildPlanetsInfo();
         }
         for each(planet in userInfo.mPlanets)
         {
            if(planet.getPlanetId() == planetId)
            {
               this.mGoToCurrentStarName.value = planet.getParentStarName();
               this.mGoToCurrentStarCoors = planet.getParentStarCoords();
               this.mGoToCurrentStarType.value = planet.getParentStarType();
               this.mGoToCurrentStarId.value = planet.getParentStarId();
               break;
            }
         }
         if(starId != -1)
         {
            this.mGoToCurrentStarId.value = starId;
         }
         if(starName != null)
         {
            this.mGoToCurrentStarName.value = starName;
         }
         if(starCoords != null)
         {
            this.mGoToCurrentStarCoors = starCoords;
         }
         if(planetSku != null)
         {
            this.mGoToRequestPlanetSku.value = planetSku;
         }
         if(userInfo.mIsNPC.value == true)
         {
            uInfoLogin = InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj();
            this.mGoToCurrentStarName.value = uInfoLogin.getCapital().getParentStarName();
            this.mGoToCurrentStarCoors = uInfoLogin.getCapital().getParentStarCoords();
            this.mGoToCurrentStarId.value = uInfoLogin.getCapital().getParentStarId();
         }
      }
      
      public function goToGetAttackMode() : int
      {
         return this.mGoToAttackMode.value;
      }
      
      public function goToGetIsQuickAttack() : Boolean
      {
         return this.mGoToAttackMode.value == 1;
      }
      
      public function goToResumeRequest(checkUserCanAttack:Boolean = true, checkDamageProtection:Boolean = true, checkTargetIsAttackable:Boolean = true, lockApplied:Boolean = false) : void
      {
         this.goToPlanet(this.mGoToRequestUserId.value,this.mGoToRequestPlanetId.value,this.mGoToRequestRoleId.value,this.mGoToRequestPlanetSku.value,checkUserCanAttack,checkDamageProtection,checkTargetIsAttackable,this.mGoToCurrentStarId.value,this.mGoToCurrentStarName.value,this.mGoToCurrentStarCoors,lockApplied,this.mGoToAttackMode.value);
      }
      
      public function hasTheOwnerArmament(checkSpecialAttacks:Boolean = false) : Boolean
      {
         var returnValue:* = !InstanceMng.getHangarControllerMng().getProfileLoginHangarController().areHangarsEmpty() || InstanceMng.getItemsMng().getItemsDeployUnits().length > 0;
         if(!returnValue && checkSpecialAttacks)
         {
            returnValue = InstanceMng.getItemsMng().getAmountSpecialAttacksOwned() > 0;
         }
         return returnValue;
      }
      
      public function createIsAttackableObject(accountId:String, planet:Planet = null, isRevenge:Boolean = false, hasToDisableAttackButton:Boolean = false, checkIfUserIsAttackable:Boolean = true, checkIfOwnerCanAttack:Boolean = true) : Object
      {
         var endChecks:Boolean = false;
         var skipChecks:* = false;
         var strengthCheck:Boolean = false;
         var str:* = null;
         var alliController:AlliancesController = null;
         var allianceEnemy:Alliance = null;
         var e:Object;
         (e = {}).isAttackable = true;
         e.isAttackableCheckTargetReasons = true;
         e.lockType = [];
         var userInfo:UserInfo;
         if((userInfo = InstanceMng.getUserInfoMng().getUserInfoObj(accountId,0)) != null && checkIfUserIsAttackable)
         {
            endChecks = false;
            if(isRevenge == false)
            {
               isRevenge = InstanceMng.getUserInfoMng().getRevengeAvailable(userInfo) != null;
            }
            skipChecks = false;
            str = "ATTACK " + accountId;
            if((alliController = InstanceMng.getAlliancesController()) != null)
            {
               str += " initialized = " + alliController.isInitialized() + " isMeInAnyAlliance = " + alliController.isMeInAnyAlliance() + " isAtWar = " + alliController.isMyAllianceInAWar();
               if(alliController.isInitialized() == false)
               {
                  str += " allianceController not initialized. ";
               }
               else if(alliController.isMeInAnyAlliance() && alliController.isMyAllianceInAWar())
               {
                  skipChecks = alliController.getEnemyAlliance().getMember(userInfo.mAccountId) != null;
                  e.isAllianceAttack = skipChecks;
                  str += " isEnemy = " + skipChecks + " accountId = " + userInfo.mAccountId;
                  if((allianceEnemy = alliController.getEnemyAlliance()).getMembers() == null || allianceEnemy.getMembers().length == 0)
                  {
                     str += " no members";
                  }
                  DCDebug.traceCh("ALLIANCES"," ATTACK alliance enemy:");
                  DCDebug.traceChObject("ALLIANCES",allianceEnemy.getJSON());
               }
            }
            DCDebug.traceCh("ALLIANCES",str);
            if(userInfo.mIsNPC.value && userInfo.isFriendlyNPC())
            {
               e.lockType.push(UserDataMng.ACCOUNT_LOCKED_TRYING_TO_ATTACK_ELDERBY);
               endChecks = true;
            }
            if(userInfo.mIsNPC.value && InstanceMng.getUserInfoMng().isUserInfoLocked(userInfo) > 0 && !InstanceMng.getFlowStatePlanet().isTutorialRunning())
            {
               e.lockType.push(InstanceMng.getUserInfoMng().getUserInfoLock(userInfo));
               endChecks = true;
            }
            DCDebug.traceCh("AttackLogic","[APP] *******\nis attackableObj for user = " + userInfo.getPlayerName() + " (" + userInfo.getAccountId() + ")");
            if(planet != null)
            {
               strengthCheck = InstanceMng.getRuleMng().checkUserCanAttackOtherUserByHQ(InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj(),planet);
               DCDebug.traceCh("AttackLogic","[APP] allowed attack by HQ level? = " + strengthCheck);
               if(!strengthCheck)
               {
                  strengthCheck = InstanceMng.getRuleMng().checkUserCanAttackOtherUserByLevel(InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj(),userInfo);
                  DCDebug.traceCh("AttackLogic","[APP] allowed attack by user level? = " + strengthCheck);
               }
            }
            else
            {
               DCDebug.traceCh("AttackLogic","[APP] PLANET IS NULL");
               strengthCheck = false;
            }
            DCDebug.traceCh("AttackLogic","[APP] final strengthCheck value = " + strengthCheck);
            if(!skipChecks && !userInfo.mIsNPC.value && !isRevenge && !strengthCheck)
            {
               e.lockType.push(UserDataMng.ACCOUNT_LOCKED_YOUR_LEVEL_TOO_HIGH);
               e.userName = userInfo.getPlayerName();
               endChecks = true;
            }
            if(!userInfo.mIsTutorialCompleted.value)
            {
               e.lockType.push(UserDataMng.ACCOUNT_LOCKED_TUTORIAL_NOT_FINISHED);
               endChecks = true;
            }
            if(!skipChecks && userInfo.mDamageProtectionTimeLeft.value > 0)
            {
               e.lockType.push(UserDataMng.ACCOUNT_LOCKED_OWNER_HAS_DAMAGE_PROTECTION);
               e.unlockTimeLeft = userInfo.mDamageProtectionTimeLeft.value;
               endChecks = true;
            }
            if(userInfo.mIsOnline.value)
            {
               e.lockType.push(UserDataMng.ACCOUNT_LOCKED_BY_OWNER);
               endChecks = true;
            }
            if(endChecks)
            {
               e.isAttackable = false;
               e.userInfo = userInfo;
               e.isAttackableCheckTargetReasons = e.isAttackable;
               return e;
            }
         }
         var putUserInfo:Boolean = false;
         if(checkIfOwnerCanAttack)
         {
            if(!this.hasTheOwnerArmament(false))
            {
               e.lockType.push(UserDataMng.ACCOUNT_LOCKED_HANGARS_EMPTY);
               putUserInfo = true;
            }
            else if(InstanceMng.getItemsMng().hasCraftingPending())
            {
               putUserInfo = true;
            }
         }
         if(putUserInfo)
         {
            e.userInfo = userInfo;
            if(!hasToDisableAttackButton)
            {
               e.isAttackable = false;
            }
         }
         return e;
      }
      
      private function attackReset() : void
      {
         this.attackSetState(0);
      }
      
      public function attackRequest(userId:String, planetId:String, attackMode:int = 0, checkIfOwnerCanAttack:Boolean = true, checkIfTargetIsAttackable:Boolean = true, planetSku:String = null, starId:Number = -1, starName:String = null, starCoord:DCCoordinate = null, planet:Planet = null) : void
      {
         this.mAttackRequestUserId.value = userId;
         this.mAttackRequestPlanetId.value = planetId;
         this.mAttackRequestAttackMode.value = attackMode;
         this.mAttackRequestPlanetSku.value = planetSku;
         this.mAttackRequestStarId.value = starId;
         this.mAttackRequestStarName.value = starName;
         this.mAttackRequestStarCoord = starCoord;
         this.mAttackRequestCheckTargetIsAttackable.value = checkIfTargetIsAttackable;
         this.mAttackRequestPlanet = planet;
         if(checkIfOwnerCanAttack)
         {
            DCDebug.traceCh("AttackLogic","[APP] attackRequest checking can attack");
            this.cantAttackCheckOwner(this,true,userId,planetId,attackMode);
         }
         else
         {
            DCDebug.traceCh("AttackLogic","[APP] proceeding with attack");
            this.attackProceed();
         }
      }
      
      private function attackSetState(state:int) : void
      {
         this.mAttackState.value = state;
         switch(this.mAttackState.value)
         {
            case 0:
               this.mAttackRequestUserId.value = null;
               this.mAttackRequestPlanetId.value = null;
               this.mAttackRequestAttackMode.value = -1;
               this.mAttackRequestCheckTargetIsAttackable.value = false;
               this.mAttackRequestPlanetSku.value = null;
               this.mAttackRequestStarId.value = -1;
               this.mAttackRequestStarName.value = null;
               this.mAttackRequestStarCoord = null;
               this.mAttackRequestPlanet = null;
         }
      }
      
      private function attackProceed() : void
      {
         if(this.mAttackRequestAttackMode.value == 1 && this.mAttackRequestUserId.value == null)
         {
            this.lockUIWaitForQuickAttackTarget(false);
         }
         else
         {
            this.goToPlanet(this.mAttackRequestUserId.value,this.mAttackRequestPlanetId.value,3,this.mAttackRequestPlanetSku.value,true,false,this.mAttackRequestCheckTargetIsAttackable.value,this.mAttackRequestStarId.value,this.mAttackRequestStarName.value,this.mAttackRequestStarCoord,false,this.mAttackRequestAttackMode.value,this.mAttackRequestPlanet);
         }
      }
      
      public function quickAttack() : void
      {
         this.attackRequest(null,null,1,true,true);
         if(Config.USE_METRICS)
         {
            DCMetrics.sendMetric("PVP Menu","quick attack");
         }
      }
      
      private function cantAttackUnload() : void
      {
         this.cantAttackSetState(0);
         this.mCantAttackReasons = null;
         this.mCantAttackNotifier = null;
         this.mCantAttackReasonPopup = null;
         this.mCantAttackRivalNoAttackableParam = null;
      }
      
      private function cantAttackSetState(state:int) : void
      {
         this.mCantAttackState.value = state;
         switch(this.mCantAttackState.value)
         {
            case 0:
               if(this.mCantAttackReasons != null)
               {
                  this.mCantAttackReasons.length = 0;
               }
               this.mCantAttackRivalNoAttackableParam = null;
         }
      }
      
      private function cantAttackGetOwnerReasons(checkDamageProtection:Boolean, opponentUserId:String, planetId:String, attackMode:int) : Vector.<String>
      {
         var o:Object = null;
         var ruleMng:RuleMng = null;
         var price:int = 0;
         var profile:Profile = null;
         var addDamageProtectionWarning:Boolean = false;
         var userInfo:UserInfo = null;
         var planet:Planet = null;
         var alliController:AlliancesController = null;
         this.mAttackIsAllowed.value = false;
         if(this.mCantAttackReasons == null)
         {
            this.mCantAttackReasons = new Vector.<String>(0);
         }
         else
         {
            this.mCantAttackReasons.length = 0;
         }
         if(opponentUserId != null)
         {
            (userInfo = InstanceMng.getUserInfoMng().getUserInfoObj(this.mAttackRequestUserId.value,0,-1)).buildPlanetsInfo(true);
            if((planet = InstanceMng.getMapViewSolarSystem().getPlanet(opponentUserId,planetId)) == null)
            {
               planet = userInfo.getPlanetById(this.mAttackRequestPlanetId.value);
            }
            if(!(o = this.createIsAttackableObject(opponentUserId,planet,false,true,false)).isAttackable)
            {
               this.mCantAttackRivalNoAttackableParam = o;
               this.mCantAttackReasons.push("cantAttackRivalNoAttackable");
            }
         }
         if(attackMode == 1)
         {
            price = (ruleMng = InstanceMng.getRuleMng()).getQuickAttackMineralCost();
            if((profile = InstanceMng.getUserInfoMng().getProfileLogin()).getMineralsCapacity() < price)
            {
               this.mCantAttackReasons.push("cantAttackNotEnoughMineralsCapacity");
            }
         }
         if(attackMode == 1 || attackMode == 2)
         {
            if(!this.hasTheOwnerArmament(false))
            {
               this.mCantAttackReasons.push("cantAttackOwnerNoArmy");
            }
            if(InstanceMng.getItemsMng().hasCraftingPending())
            {
               this.mCantAttackReasons.push("cantAttackOwnerCraftPending");
            }
            if(checkDamageProtection && InstanceMng.getUserInfoMng().getProfileLogin().getProtectionTimeLeft() > 0)
            {
               addDamageProtectionWarning = true;
               if(opponentUserId != null)
               {
                  if((userInfo = InstanceMng.getUserInfoMng().getUserInfoObj(opponentUserId,0)) != null && userInfo.mIsNPC.value)
                  {
                     addDamageProtectionWarning = false;
                  }
                  else if((alliController = InstanceMng.getAlliancesController()) != null && alliController.isInitialized() && alliController.isMeInAnyAlliance() && alliController.isMyAllianceInAWar() && alliController.getEnemyAlliance().getMember(opponentUserId) != null)
                  {
                     addDamageProtectionWarning = false;
                  }
               }
               if(addDamageProtectionWarning)
               {
                  this.mCantAttackReasons.push("cantAttackOwnerLooseDamageProtection");
               }
            }
         }
         return this.mCantAttackReasons;
      }
      
      private function cantAttackAnyReasons() : Boolean
      {
         return this.mCantAttackReasons != null && this.mCantAttackReasons.length > 0;
      }
      
      public function cantAttackCheckOwner(notifier:DCComponent, checkDamageProtection:Boolean, opponentUserId:String, planetId:String, attackMode:int) : void
      {
         this.mCantAttackNotifier = notifier;
         this.cantAttackGetOwnerReasons(checkDamageProtection,opponentUserId,planetId,attackMode);
         if(this.cantAttackAnyReasons())
         {
            this.cantAttackSetState(1);
         }
         else
         {
            this.cantAttackNotifyAttackAllowed();
         }
      }
      
      private function cantAttackLogicUpdate(dt:int) : void
      {
         var reason:String = null;
         var guiController:GUIController = null;
         var cmd:String = null;
         var event:Object = null;
         switch(this.mCantAttackState.value - 1)
         {
            case 0:
               reason = this.mCantAttackReasons[0];
               this.cantAttackSetState(2);
               switch(reason)
               {
                  case "cantAttackRivalNoAttackable":
                     this.mCantAttackReasonPopup = this.lockUIOpenPopupBasedOnResponse(this.mCantAttackRivalNoAttackableParam,true,this.cantAttackReasonAccepted);
                     break;
                  case "cantAttackNotEnoughMineralsCapacity":
                     this.mCantAttackReasonPopup = this.lockUIOpenPopupBasedOnResponse({"lockType":UserDataMng.ACCOUNT_LOCKED_NOT_ENOUGH_MINERALS_CAPACITY});
                     break;
                  case "cantAttackOwnerNoArmy":
                     this.mCantAttackReasonPopup = this.lockUIOpenPopupBasedOnResponse({"lockType":UserDataMng.ACCOUNT_LOCKED_HANGARS_EMPTY});
                     break;
                  case "cantAttackOwnerLooseDamageProtection":
                  case "cantAttackOwnerCraftPending":
                     guiController = InstanceMng.getGUIController();
                     cmd = reason == "cantAttackOwnerCraftPending" ? "NotifyCraftingPending" : "NotifyDamageProtectionWarning";
                     (event = guiController.createNotifyEvent("EventPopup",cmd)).notifyCantAttack = true;
                     InstanceMng.getNotifyMng().addEvent(guiController,event,true);
               }
               break;
            case 1:
               var _loc6_:* = this.mCantAttackReasons[0];
               if("cantAttackOwnerNoArmy" === _loc6_)
               {
                  if(this.mCantAttackReasonPopup == null || !this.mCantAttackReasonPopup.isPopupBeingShown())
                  {
                     this.cantAttackReasonAccepted(true);
                  }
                  break;
               }
         }
      }
      
      public function cantAttackReasonAccepted(accept:Boolean = true) : void
      {
         var reason:String = null;
         var stopCheck:Boolean = false;
         if(this.cantAttackAnyReasons())
         {
            reason = this.mCantAttackReasons.shift();
            stopCheck = false;
            switch(reason)
            {
               case "cantAttackRivalNoAttackable":
               case "cantAttackOwnerNoArmy":
               case "cantAttackNotEnoughMineralsCapacity":
                  stopCheck = true;
                  break;
               case "cantAttackOwnerLooseDamageProtection":
               case "cantAttackOwnerCraftPending":
                  if(!accept)
                  {
                     stopCheck = true;
                  }
            }
            if(!stopCheck && this.cantAttackAnyReasons())
            {
               this.cantAttackSetState(1);
            }
            else
            {
               if(!stopCheck)
               {
                  this.cantAttackNotifyAttackAllowed();
               }
               this.cantAttackSetState(0);
            }
         }
         else
         {
            DCDebug.traceCh("ASSERT","Application.cantAttackReasonAccepted(): There\'s no reasons to accept.");
            this.cantAttackSetState(0);
         }
      }
      
      private function cantAttackNotifyAttackAllowed() : void
      {
         if(this.mCantAttackNotifier)
         {
            InstanceMng.getNotifyMng().addEvent(this.mCantAttackNotifier,{"cmd":"NotifyAttackAllowed"},true);
         }
      }
      
      public function composeKeyForSolarSystemCaching(starCoords:DCCoordinate) : String
      {
         var returnValue:String = "";
         return "star_" + starCoords.toStringWithNoParentheses(true);
      }
      
      public function solarSystemInfoWait(coords:DCCoordinate, starId:Number) : void
      {
         var obj:Object = {};
         obj.coordX = coords.x;
         obj.coordY = coords.y;
         obj.coords = coords;
         obj.starId = starId;
         this.lockUIWaitForSolarSystemInfo();
         if(!isNaN(starId))
         {
            InstanceMng.getUserDataMng().requestTask(UserDataMng.KEY_STAR_PLANETS_WINDOW,obj);
         }
      }
      
      private function solarSystemInfoResume(ok:Boolean, info:XML = null) : void
      {
         var viewMode:int = 0;
         if(ok && info != null)
         {
            viewMode = InstanceMng.getApplication().viewGetMode();
            if(viewMode == 2)
            {
               InstanceMng.getMapView().loadPlanetsFromXML(info);
               this.lockUIReset();
            }
         }
         InstanceMng.getTargetMng().updateProgress("loadStarmapAmount",1);
      }
      
      public function solarSystemInfoOk(info:XML) : void
      {
         this.solarSystemInfoResume(true,info);
      }
      
      public function solarSystemInfoCancel() : void
      {
         this.solarSystemInfoResume(false);
      }
      
      public function galaxyInfoWait(minCoord:DCCoordinate, maxCoord:DCCoordinate, lockUI:Boolean = false, requestBookmarks:Boolean = false) : void
      {
         var obj:Object;
         (obj = {}).topLeftCoordX = minCoord.x;
         obj.topLeftCoordY = minCoord.y;
         obj.bottomRightCoordX = maxCoord.x;
         obj.bottomRightCoordY = maxCoord.y;
         if(lockUI == true)
         {
            this.lockUIWaitForGalaxyInfo();
         }
         InstanceMng.getUserDataMng().requestTask(UserDataMng.KEY_GALAXY_WINDOW,obj);
         if(requestBookmarks == true)
         {
            InstanceMng.getUserDataMng().requestTask(UserDataMng.KEY_BOOKMARKS);
         }
      }
      
      private function galaxyInfoResume(ok:Boolean, info:XML) : void
      {
         var isLoadingState:* = mFsmCurrentState is FlowStateLoadingBarGalaxyView;
         if(ok && isLoadingState == false)
         {
            InstanceMng.getMapViewGalaxy().loadSolarSystemsFromXML(info,true);
            this.lockUIReset();
         }
         InstanceMng.getMapViewGalaxy().setWaitingForServerResponse(false);
      }
      
      public function galaxyInfoOk(info:XML) : void
      {
         this.galaxyInfoResume(true,info);
      }
      
      public function galaxyInfoCancel() : void
      {
         this.galaxyInfoResume(false,null);
      }
      
      private function colonyAvailabilityUnload() : void
      {
         this.mColonyAvailabilityPlanetParentStarId.value = 0;
         this.mColonyAvailabilityPlanetSku.value = null;
      }
      
      public function colonyAvailabilityWait(sku:String, starId:Number, starName:String, starType:int) : void
      {
         this.mColonyAvailabilityPlanetSku.value = sku;
         this.mColonyAvailabilityPlanetParentStarId.value = starId;
         InstanceMng.getUserDataMng().queryGetColonyAvailability(sku,starId);
         this.lockUIWaitForColonyAvailability(starId,starName,starType);
      }
      
      private function colonyAvailabilityResume(ok:Boolean) : void
      {
         var o:Object = null;
         var planetsAmount:int = 0;
         this.lockUIReset();
         if(ok)
         {
            o = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NOTIFY_STAR_BUY_PLANET_POPUP",InstanceMng.getMapView());
            o.planetSku = this.mColonyAvailabilityPlanetSku.value;
            o.starId = this.mColonyAvailabilityPlanetParentStarId.value;
            o.starName = this.mLockUIData.starName;
            o.starType = this.mLockUIData.starType;
            InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o);
            planetsAmount = InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj().getPlanetsAmount();
            if(planetsAmount == 1)
            {
               o.colonizeOptions = 1;
            }
            else if(planetsAmount == 12)
            {
               o.colonizeOptions = 2;
            }
            else
            {
               o.colonizeOptions = 3;
            }
            if(this.mViewMode.value == 2)
            {
               InstanceMng.getMapViewGalaxy().setForceToReloadPlanets(true);
            }
         }
         else
         {
            o = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NotifyErrorInfo");
            o.title = DCTextMng.getText(2763);
            o.msg = DCTextMng.getText(2764);
            InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o);
            if(this.mViewMode.value == 1)
            {
               InstanceMng.getMapViewSolarSystem().refreshSolarSystemView();
            }
         }
         this.mColonyAvailabilityPlanetSku.value = "";
         this.mColonyAvailabilityPlanetParentStarId.value = -1;
      }
      
      public function colonyAvailabilityOk() : void
      {
         this.colonyAvailabilityResume(true);
      }
      
      public function colonyAvailabilityCancel() : void
      {
         this.colonyAvailabilityResume(false);
      }
      
      public function colonyPurchaseWait(sku:String, trans:Transaction, starId:Number, starName:String, starType:int) : void
      {
         InstanceMng.getUserDataMng().queryGetColonyConfirmPurchase(sku,trans,starId);
         this.lockUIWaitForColonyAvailability(starId,starName,starType);
      }
      
      private function colonyPurchaseResume(ok:Boolean, planetId:String, planetSku:String, isNewColony:Boolean = true) : void
      {
         var o:Object = null;
         var uInfo:UserInfo = null;
         var oldStarId:Number = NaN;
         var starId:Number = NaN;
         var starName:String = null;
         var starType:int = 0;
         var notifyNewPlanetInGalaxy:Boolean = false;
         var planet:Planet = null;
         var oldPlanet:Planet = null;
         var oldColonySku:String = null;
         var solarSystem:SolarSystem = null;
         this.lockUIReset();
         if(ok)
         {
            uInfo = InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj();
            starId = Number(this.mLockUIData.starId);
            starName = String(this.mLockUIData.starName);
            starType = int(this.mLockUIData.starType);
            notifyNewPlanetInGalaxy = true;
            if(isNewColony)
            {
               planet = uInfo.addColonyBought(planetId,planetSku,1);
            }
            else
            {
               oldColonySku = (oldPlanet = uInfo.mPlanets[parseInt(planetId) - 1]).getSku();
               oldStarId = oldPlanet.getParentStarId();
               planet = uInfo.updateColonyMoved(planetId,planetSku);
               if(oldStarId == starId)
               {
                  notifyNewPlanetInGalaxy = false;
               }
            }
            if(this.mViewMode.value == 1)
            {
               InstanceMng.getMapViewSolarSystem().addPlanetBoughtByPlanet(planet,uInfo);
               if(!isNewColony)
               {
                  InstanceMng.getMapViewSolarSystem().removeOldColony(oldColonySku);
               }
            }
            else
            {
               InstanceMng.getMapView().buyPlanetByUser(planet,uInfo,starId,starName,starType);
            }
            (o = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NOTIFY_STAR_COLONY_BOUGHT")).planetId = planetId;
            o.planetSku = planetSku;
            o.starId = starId.toString();
            o.isNewColony = isNewColony;
            InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o);
            if(this.mViewMode.value == 2)
            {
               if(notifyNewPlanetInGalaxy)
               {
                  if((solarSystem = InstanceMng.getMapViewGalaxy().getSolarSystemById(starId)) != null)
                  {
                     solarSystem.notifyPlanetBought();
                     InstanceMng.getMapViewGalaxy().removeSolarSystemFromStage(solarSystem);
                     InstanceMng.getMapViewGalaxy().createSolarSystemInstance(solarSystem);
                  }
                  if((solarSystem = InstanceMng.getMapViewGalaxy().getSolarSystemById(oldStarId)) != null)
                  {
                     solarSystem.notifyPlanetGone();
                     InstanceMng.getMapViewGalaxy().removeSolarSystemFromStage(solarSystem);
                     InstanceMng.getMapViewGalaxy().createSolarSystemInstance(solarSystem);
                  }
               }
            }
            MessageCenter.getInstance().sendMessage("colonyBought");
         }
         else
         {
            (o = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NotifyErrorInfo")).title = DCTextMng.getText(2763);
            o.msg = DCTextMng.getText(2765);
            o.advisor = "orange_worried";
            InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o);
            if(this.mViewMode.value == 1)
            {
               InstanceMng.getMapViewSolarSystem().refreshSolarSystemView();
            }
         }
      }
      
      public function colonyMovedWait(planetId:int, sku:String, trans:Transaction, starId:Number, starName:String, starType:int) : void
      {
         InstanceMng.getUserDataMng().queryGetColonyConfirmMove(planetId,starId,sku,trans);
         this.lockUIWaitForColonyAvailability(starId,starName,starType);
      }
      
      public function colonyPurchaseOk(planetId:String, planetSku:String) : void
      {
         this.colonyPurchaseResume(true,planetId,planetSku);
      }
      
      public function colonyPurchaseCancel() : void
      {
         this.colonyPurchaseResume(false,"","");
      }
      
      public function colonyMovedOk(planetId:String, planetSku:String) : void
      {
         this.colonyPurchaseResume(true,planetId,planetSku,false);
      }
      
      public function colonyMovedCancel() : void
      {
         this.colonyPurchaseResume(false,"","",false);
      }
      
      public function neighborInfoWait(accountId:String) : void
      {
         var obj:Object = {};
         obj.accountId = accountId;
         InstanceMng.getUserDataMng().requestTask(UserDataMng.KEY_NEIGHBOR_INFO,obj);
      }
      
      private function neighborInfoResume(info:XML) : void
      {
         if(info != null)
         {
            InstanceMng.getUserInfoMng().setNeighborListXML(info);
            this.mUIFacade.friendsBarReload();
         }
      }
      
      public function lockUIReset(resetPreviousLock:Boolean = false) : void
      {
         var cursor:CursorFacade = null;
         var notification:Notification = null;
         DCDebug.traceCh("lockUI"," lockUIReset " + this.mLockUIReason + " resetPreviousLock = " + resetPreviousLock + " lockUIISEnabled =" + this.mLockUIIsEnabled + " mLastCursorID = " + this.mLastCursorId);
         if(this.mLockUIIsEnabled)
         {
            if(resetPreviousLock)
            {
               switch(this.mLockUIReason)
               {
                  case 0:
                     notification = this.mNotificationsMng.createNotificationUserIsNotAllowedToAttackTarget();
                     this.mNotificationsMng.guiOpenNotificationMessage(notification);
                     break;
                  case 8:
                     InstanceMng.getUnitScene().battleOpenResultPopupWithAllianceScore(true);
                     break;
                  case 13:
                     this.quickAttackNotifyRequestForTargetExpired();
                     break;
                  case 15:
                  case 16:
                     InstanceMng.getContestMng().guiUnlockUI(this.mLockUIReason);
                     break;
                  case 17:
                     this.mLockUIData = null;
               }
            }
            cursor = InstanceMng.getUIFacade().getCursorFacade();
            cursor.setCursorId(this.mLastCursorId);
            InstanceMng.getGUIController().unlockGUI();
            this.mLockUIReason = -1;
            this.mLockUIIsEnabled = false;
            this.mLockUITimeout = -1;
            this.mLastCursorId = -1;
         }
      }
      
      public function lockUIUnload() : void
      {
         this.mLockUIData = null;
         this.mLockUIReason = -1;
         this.mLockUIIsEnabled = false;
         this.mLockUITimeout = 0;
         this.mLastCursorId = -1;
      }
      
      private function lockUIWait(reason:int, timeout:Number = 10000) : Boolean
      {
         var cursor:CursorFacade = null;
         DCDebug.traceCh("lockUI"," lockUIWait " + reason + " timeOut = " + timeout + " enabled = " + this.mLockUIIsEnabled);
         var returnValue:Boolean = false;
         this.mLockUIReason = reason;
         if(!this.mLockUIIsEnabled)
         {
            returnValue = true;
            this.mLockUIIsEnabled = true;
            this.mLockUITimeout = timeout;
            InstanceMng.getGUIController().lockGUI();
            cursor = InstanceMng.getUIFacade().getCursorFacade();
            this.mLastCursorId = cursor.getCursorId();
            cursor.setCursorId(19);
         }
         return returnValue;
      }
      
      public function lockUIGetData() : Object
      {
         return this.mLockUIData;
      }
      
      public function lockUIWaitForWeeklyRanking() : void
      {
         this.lockUIWait(11,3000);
      }
      
      public function lockUIWaitForSolarSystemInfo() : void
      {
         this.lockUIWait(3,6000);
      }
      
      public function lockUIWaitForGalaxyInfo() : void
      {
         this.lockUIWait(5);
      }
      
      public function lockUIWaitForColonyAvailability(starId:Number, starName:String, starType:int) : void
      {
         this.mLockUIData = {
            "starId":starId,
            "starName":starName,
            "starType":starType
         };
         this.lockUIWait(4,6000);
      }
      
      public function lockUIWaitForPayment() : void
      {
         this.lockUIWait(1);
      }
      
      public function lockUIWaitForAttackAllowed() : void
      {
         this.lockUIWait(0,10000);
      }
      
      public function lockUIWaitForAttackAllowedDisablingAttackButton() : void
      {
         this.lockUIWait(12,10000);
      }
      
      public function lockUIWaitForWarpBunkerTransfer(pUnits:Vector.<Array>, pBunkerSid:String) : void
      {
         this.lockUIWait(2,-1);
         this.mLockUIData = {
            "bunkerSid":pBunkerSid,
            "units":pUnits
         };
         var pUnitsArray:Array = InstanceMng.getUnitScene().translateUnitsRequestToObject(pUnits,InstanceMng.getHangarControllerMng().getProfileLoginHangarController(),true);
         var data:Object = {
            "bunkerSid":int(pBunkerSid),
            "unitsArray":pUnitsArray
         };
         InstanceMng.getUserDataMng().requestTask(UserDataMng.KEY_CHECK_WARP_BUNKER_TRANSFER,data);
      }
      
      public function lockUIWaitForAlliancesRequest() : void
      {
         this.lockUIWait(7,1.7976931348623157e+308);
      }
      
      public function lockUIWaitForBattleResult() : void
      {
         InstanceMng.getAlliancesController().initialize(0,false);
         this.lockUIWait(8,6000);
      }
      
      public function lockUIWaitForPendingTransactions() : void
      {
         this.lockUIWait(9,3000);
      }
      
      public function lockUIWaitForInvests() : void
      {
         this.lockUIWait(10,3000);
      }
      
      public function lockUIWaitForQuickAttackTarget(checkIfOwnerCanAttack:Boolean) : void
      {
         if(this.lockUIWait(13,-1))
         {
            InstanceMng.getTopHudFacade().disableBattleEndButton();
            InstanceMng.getUIFacade().getWarBar().setNextTargetButtonEnabled(false);
            InstanceMng.getGUIController().getToolBar().setAttackButtonsEnabled(false);
            this.mLockUIData = {"checkIfOwnerCanAttack":checkIfOwnerCanAttack};
            this.quickAttackRequestTarget();
         }
      }
      
      public function lockUIWaitForPurchaseCredits() : void
      {
         if(this.lockUIWait(14,-1))
         {
         }
      }
      
      public function lockUIWaitForContestRequest() : void
      {
         if(this.lockUIWait(15,-1))
         {
         }
      }
      
      public function lockUIWaitForCommandsToBeFlushedForTheContest() : void
      {
         if(this.lockUIWait(16,10000))
         {
         }
      }
      
      public function lockUIWaitForMysteryCube(sku:String) : void
      {
         this.mLockUIData = {"cubeSku":sku};
         this.lockUIWait(17,1.7976931348623157e+308);
      }
      
      protected function lockUILogicUpdate(dt:int) : void
      {
         var response:Object = null;
         var userDataMng:UserDataMng = null;
         var lockApplied:Boolean = false;
         var lockRequested:Boolean = false;
         var responseXml:XML = null;
         var result:int = 0;
         var bunkerSid:String = null;
         var pItemTo:WorldItemObject = null;
         var params:Object = null;
         var unitScene:UnitScene = null;
         var wave:String = null;
         var notification:Notification = null;
         if(InstanceMng.getUIFacade().getCursorFacade().getCursorId() == 19)
         {
         }
         if(this.mLockUITimeout > -1)
         {
            this.mLockUITimeout -= dt;
            if(this.mLockUITimeout <= 0)
            {
               this.lockUIReset(true);
            }
         }
         switch(this.mLockUIReason)
         {
            case 0:
               if((userDataMng = InstanceMng.getUserDataMng()).isFileLoaded(UserDataMng.KEY_CHECK_AVAILABLE_ATTACK))
               {
                  if((response = userDataMng.getFile(UserDataMng.KEY_CHECK_AVAILABLE_ATTACK)).attack)
                  {
                     lockApplied = response.lockApplied != null ? Boolean(response.lockApplied) : false;
                     if((lockRequested = response.lockRequested != null ? Boolean(response.lockRequested) : false) && lockApplied == false)
                     {
                        this.lockUIOpenPopupBasedOnResponse(response);
                        InstanceMng.getUserInfoMng().updateUserByServerAttackResponse(this.mGoToRequestUserId.value,response);
                     }
                     else
                     {
                        userDataMng.freeFile(UserDataMng.KEY_CHECK_AVAILABLE_ATTACK);
                        InstanceMng.getApplication().goToResumeRequest(false,false,false,lockApplied);
                     }
                  }
                  else
                  {
                     this.lockUIOpenPopupBasedOnResponse(response);
                     InstanceMng.getUserInfoMng().updateUserByServerAttackResponse(this.mGoToRequestUserId.value,response);
                  }
                  this.lockUIReset();
               }
               break;
            case 2:
               if(InstanceMng.getUserDataMng().isFileLoaded(UserDataMng.KEY_CHECK_WARP_BUNKER_TRANSFER))
               {
                  responseXml = InstanceMng.getUserDataMng().getFileXML(UserDataMng.KEY_CHECK_WARP_BUNKER_TRANSFER);
                  result = EUtils.xmlReadInt(responseXml,"result");
                  InstanceMng.getHangarControllerMng().helpListUpdateHangar(responseXml);
                  if(result == 1)
                  {
                     if(InstanceMng.getFlowStatePlanet().getCurrentRoleId() == 1)
                     {
                        InstanceMng.getPopupMng().currentPopupCallFunction("onTransferUnitsOK",this.mLockUIData);
                     }
                     bunkerSid = String(this.mLockUIData.bunkerSid);
                     pItemTo = InstanceMng.getWorld().itemsGetItemBySid(bunkerSid);
                     params = null;
                     if(pItemTo != null)
                     {
                        params = {
                           "itemTo":pItemTo,
                           "goalFor":"unitGoalForHangarToBunker"
                        };
                     }
                     unitScene = InstanceMng.getUnitScene();
                     wave = InstanceMng.getUnitScene().translateUnitsRequestToString(this.mLockUIData.units,InstanceMng.getHangarControllerMng().getProfileLoginHangarController());
                     unitScene.startDeployUnits(2100,1200,wave,3,params,false);
                  }
                  else
                  {
                     notification = this.mNotificationsMng.createNotificationUnitsCantBeSentToFriendsBunkerByReason(result);
                     this.mNotificationsMng.guiOpenNotificationMessage(notification);
                  }
                  this.lockUIReset();
               }
               break;
            case 8:
               if(InstanceMng.getAlliancesController().isInitialized())
               {
                  InstanceMng.getUnitScene().battleOpenResultPopupWithAllianceScore(true);
                  this.lockUIReset(false);
               }
               break;
            case 12:
               if((userDataMng = InstanceMng.getUserDataMng()).isFileLoaded(UserDataMng.KEY_CHECK_AVAILABLE_ATTACK))
               {
                  if((response = userDataMng.getFile(UserDataMng.KEY_CHECK_AVAILABLE_ATTACK)).attack)
                  {
                     lockApplied = response.lockApplied != null ? Boolean(response.lockApplied) : false;
                     if((lockRequested = response.lockRequested != null ? Boolean(response.lockRequested) : false) && lockApplied == false)
                     {
                        this.mUIFacade.hudDisableAttackButton(this.getLockUIMessage(response));
                        InstanceMng.getUserInfoMng().updateUserByServerAttackResponse(this.mGoToRequestUserId.value,response);
                     }
                     else
                     {
                        userDataMng.freeFile(UserDataMng.KEY_CHECK_AVAILABLE_ATTACK);
                     }
                  }
                  else
                  {
                     this.mUIFacade.hudDisableAttackButton(this.getLockUIMessage(response));
                     InstanceMng.getUserInfoMng().updateUserByServerAttackResponse(this.mGoToRequestUserId.value,response);
                  }
                  this.lockUIReset();
               }
               break;
            case 13:
               if(!this.quickAttackIsWaitingForTarget())
               {
                  this.lockUIReset();
                  if(this.quickAttackIsTargetFound())
                  {
                     this.quickAttackAttackTarget(this.mLockUIData.checkIfOwnerCanAttack);
                  }
                  else
                  {
                     this.quickAttackShowNoTargetFoundPopup();
                  }
                  InstanceMng.getTopHudFacade().enableBattleEndButton();
                  InstanceMng.getUIFacade().getWarBar().setNextTargetButtonEnabled(true);
                  InstanceMng.getGUIController().getToolBar().setAttackButtonsEnabled(true);
                  break;
               }
         }
      }
      
      public function lockUIOpenPopupBasedOnResponse(response:Object, closeOpenedPopup:Boolean = true, callback:Function = null) : DCIPopup
      {
         var popup:DCIPopup = null;
         var lockType:int = parseInt(response.lockType);
         var msg:String = "";
         var title:String = null;
         msg = this.getLockUIMessage(response);
         switch(lockType)
         {
            case UserDataMng.ACCOUNT_LOCKED_BY_MAINTENANCE_OF_SERVERS:
               title = DCTextMng.getText(415);
               break;
            case UserDataMng.ACCOUNT_LOCKED_BET_TIMEOUT_FOR_OPPONENT_EXPIRED:
               title = DCTextMng.getText(330);
         }
         if(title == null)
         {
            title = DCTextMng.getText(191);
         }
         return this.mNotificationsMng.guiOpenMessagePopup("PopupWarnings",title,msg,"orange_normal",callback);
      }
      
      public function getLockUIMessage(response:Object) : String
      {
         var playerName:String = null;
         var msg:String = null;
         var lockType:int = 0;
         var uInfo:UserInfo = null;
         if(response.lockType is Array)
         {
            lockType = parseInt(response.lockType[0]);
         }
         else
         {
            lockType = parseInt(response.lockType);
         }
         var timeLeft:Number = parseFloat(response.unlockTimeLeft);
         switch(lockType)
         {
            case UserDataMng.ACCOUNT_LOCKED_BY_OTHER_ACCOUNT:
               msg = DCTextMng.getText(188);
               break;
            case UserDataMng.ACCOUNT_LOCKED_BY_OWNER:
               msg = DCTextMng.getText(184);
               break;
            case UserDataMng.ACCOUNT_LOCKED_OWNER_HAS_DAMAGE_PROTECTION:
               msg = DCTextMng.replaceParameters(183,[GameConstants.getTimeTextFromMs(timeLeft)]);
               break;
            case UserDataMng.ACCOUNT_LOCKED_YOUR_LEVEL_TOO_HIGH:
               if((playerName = String(response.userName)) == null)
               {
                  if((playerName = InstanceMng.getUserInfoMng().getUserInfoObj(this.mGoToRequestUserId.value,0).getPlayerName()) == null)
                  {
                     playerName = "this player";
                  }
               }
               msg = DCTextMng.replaceParameters(186,[playerName]);
               break;
            case UserDataMng.ACCOUNT_LOCKED_NOT_ENOUGH_MINERALS_CAPACITY:
               msg = DCTextMng.getText(199);
               break;
            case UserDataMng.ACCOUNT_LOCKED_TRYING_TO_ATTACK_ELDERBY:
               msg = DCTextMng.replaceParameters(187,[response.userInfo.getPlayerName()]);
               break;
            case UserDataMng.ACCOUNT_LOCKED_PLANET_NOT_CREATED:
            case UserDataMng.ACCOUNT_LOCKED_TUTORIAL_NOT_FINISHED:
               msg = DCTextMng.getText(185);
               break;
            case UserDataMng.ACCOUNT_LOCKED_BY_MISSION_NOT_COMPLETED:
               if(response.userInfo != null)
               {
                  msg = DCTextMng.replaceParameters(358,[InstanceMng.getMissionsMng().getMissionName((response.userInfo as UserInfo).mMissionSku)]);
               }
               break;
            case UserDataMng.ACCOUNT_LOCKED_BY_HQ_LEVEL_TOO_LOW:
               uInfo = UserInfo(response.userInfo);
               if(uInfo != null)
               {
                  msg = DCTextMng.replaceParameters(429,[uInfo.mHQLevelRequired]);
               }
               else
               {
                  msg = DCTextMng.getText(429);
               }
               break;
            case UserDataMng.ACCOUNT_LOCKED_BY_MAINTENANCE_OF_SERVERS:
               msg = DCTextMng.getText(416);
               break;
            case UserDataMng.ACCOUNT_LOCKED_HANGARS_EMPTY:
               msg = DCTextMng.getText(168);
               break;
            case UserDataMng.ACCOUNT_LOCKED_QUICK_ATTACK_TARGET_NOT_FOUND:
               msg = DCTextMng.getText(326);
               break;
            case UserDataMng.ACCOUNT_LOCKED_BET_TIMEOUT_FOR_OPPONENT_EXPIRED:
               msg = DCTextMng.getText(331);
               break;
            case UserDataMng.ACCOUNT_LOCKED_DESTROYED:
               msg = DCTextMng.getText(3644);
               break;
            case UserDataMng.ACCOUNT_TOO_MANY_ATTACKS:
               msg = DCTextMng.getText(4098);
         }
         return msg;
      }
      
      public function lockUIIsLocked() : Boolean
      {
         return this.mLockUIReason != -1;
      }
      
      public function lockUIGetReason() : int
      {
         return this.mLockUIReason;
      }
      
      public function setCreditId(id:String) : void
      {
         this.mCreditId.value = id;
      }
      
      public function getCreditId() : String
      {
         return this.mCreditId.value;
      }
      
      public function getWaitForIntro() : Boolean
      {
         return this.mWaitForIntro.value;
      }
      
      public function setWaitForIntro(value:Boolean) : void
      {
         this.mWaitForIntro.value = value;
      }
      
      public function getGameQuality() : int
      {
         var quality:String = null;
         var returnValue:int = -1;
         var guiController:GUIController = InstanceMng.getGUIController();
         if(guiController != null)
         {
            quality = guiController.getGameQuality();
            if(quality != null)
            {
               quality = quality.toUpperCase();
            }
            switch(quality)
            {
               case "low".toUpperCase():
                  returnValue = 0;
                  break;
               case "high".toUpperCase():
                  returnValue = 1;
                  break;
               default:
                  returnValue = 1;
            }
         }
         return returnValue;
      }
      
      public function isHighQualityEnabled() : Boolean
      {
         return this.getGameQuality() == 1;
      }
      
      public function getLastRequestUserId() : String
      {
         return this.mLastRequestUserId.value;
      }
      
      public function goToRequestPlanetId() : String
      {
         return this.mLastRequestPlanetId.value;
      }
      
      public function setSendingWishlistItem(sku:String, value:Boolean) : void
      {
         this.mWishlistItemsSending[sku] = value;
         if(!value)
         {
            delete this.mWishlistItemsSending[sku];
         }
      }
      
      public function getSendingWishlistItem(sku:String) : Boolean
      {
         if(this.mWishlistItemsSending.hasOwnProperty(sku))
         {
            return this.mWishlistItemsSending[sku];
         }
         return false;
      }
      
      public function setToWindowedMode() : void
      {
         var displayState:String = stageGetStage().getDisplayState();
         if(displayState == "fullScreen" || displayState == "fullScreenInteractive")
         {
            stageGetStage().setDisplayState("normal");
            stageGetStage().getImplementation().scaleMode = "noScale";
         }
      }
      
      override public function isTutorialCompleted() : Boolean
      {
         var profile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         return profile != null && profile.isBuilt() && profile.isTutorialCompleted();
      }
      
      override protected function lastClickProcess() : void
      {
         this.funnelNotify(mLastClickLabel);
         mLastClickLabel = null;
      }
      
      private function funnelUnload() : void
      {
         this.mFunnelStepDefs = null;
         this.mFunnelCurrentStep.value = 0;
      }
      
      public function funnelSetIsEnabled(value:Boolean) : void
      {
         var def:FunnelStepDef = null;
         var missionSku:String = null;
         var targetDefMng:TargetDefMng = null;
         var targetDef:TargetDef = null;
         var target:Target = null;
         if(value)
         {
            this.mFunnelCurrentStep.value = 0;
            this.mFunnelStepDefs = InstanceMng.getFunnelStepDefMng().getDefs();
            targetDefMng = InstanceMng.getTargetDefMng();
            for each(def in this.mFunnelStepDefs)
            {
               missionSku = def.getMissionSku();
               if(def.isAMissionStep())
               {
                  targetDef = targetDefMng.getDefBySku(def.getMissionSku()) as TargetDef;
                  target = Target(InstanceMng.getTargetMng().getTargetById(targetDef.mSku));
                  if((targetDef == null || targetDef.getConditionAmount() == "-1") && (target != null && target.State != 2))
                  {
                     this.funnelAdvanceStep();
                  }
               }
            }
         }
         else
         {
            this.mFunnelStepDefs = null;
         }
      }
      
      private function funnelGetCurrentStepDef() : FunnelStepDef
      {
         return this.mFunnelStepDefs == null || this.mFunnelCurrentStep.value >= this.mFunnelStepDefs.length ? null : FunnelStepDef(this.mFunnelStepDefs[this.mFunnelCurrentStep.value]);
      }
      
      private function funnelAdvanceStep() : void
      {
         if(this.mFunnelStepDefs != null)
         {
            this.mFunnelCurrentStep.value++;
            if(this.mFunnelCurrentStep.value >= this.mFunnelStepDefs.length)
            {
               this.funnelSetIsEnabled(false);
            }
         }
      }
      
      public function funnelNotify(label:String) : void
      {
         var funnelCurrentStepDef:FunnelStepDef = null;
         if(this.mFunnelStepDefs != null)
         {
            funnelCurrentStepDef = this.funnelGetCurrentStepDef();
            if(funnelCurrentStepDef == null)
            {
               this.funnelSetIsEnabled(false);
            }
            else if(label != null)
            {
               if(funnelCurrentStepDef.isFail(label))
               {
                  if(funnelCurrentStepDef.needsToDisableSequenceWhenFailed())
                  {
                     this.funnelSetIsEnabled(false);
                  }
               }
               else
               {
                  this.funnelAdvanceStep();
               }
            }
         }
      }
      
      private function pendingTransactionsUnload() : void
      {
         var k:* = null;
         var key:String = null;
         this.mPendingTransactionsBatch = null;
         this.mPendingTransactionsPopup = null;
         this.mPendingTransactionsIdsProcessed = null;
         if(this.mPendingTransactionsOfferIds != null)
         {
            for(k in this.mPendingTransactionsOfferIds)
            {
               key = k as String;
               delete this.mPendingTransactionsOfferIds[key];
            }
            this.mPendingTransactionsOfferIds = null;
         }
      }
      
      private function pendingTransactionsProcessBatch(batch:XML) : void
      {
         DCDebug.traceCh("PendingTransaction","[APP] pendingTransactionsProcessBatch");
         var transactionXml:XML = null;
         var transaction:PendingTransaction = null;
         var source:String = null;
         if(this.mPendingTransactionsBatch == null)
         {
            this.mPendingTransactionsBatch = new Vector.<PendingTransaction>(0);
         }
         else
         {
            this.mPendingTransactionsBatch.length = 0;
         }
         if(this.mPendingTransactionsIdsProcessed == null)
         {
            this.mPendingTransactionsIdsProcessed = [];
         }
         else
         {
            this.mPendingTransactionsIdsProcessed.length = 0;
         }
         if(this.mPendingTransactionsOfferIds == null)
         {
            this.mPendingTransactionsOfferIds = new Dictionary(false);
         }
         var userDataMng:UserDataMng = InstanceMng.getUserDataMng();
         for each(transactionXml in EUtils.xmlGetChildrenList(batch,"Transaction"))
         {
            DCDebug.traceCh("PendingTransaction","[APP] batch found trans");
            (transaction = new PendingTransaction()).fromXML(transactionXml);
            if(transaction.canBeApplied())
            {
               DCDebug.traceCh("PendingTransaction","[APP] is applicable");
               if((source = transaction.getSource()) == "promoAddCreditCard")
               {
                  if(this.mPendingTransactionsOfferIds[source] == null)
                  {
                     this.mPendingTransactionsOfferIds[source] = new Vector.<String>(0);
                  }
                  Vector.<String>(this.mPendingTransactionsOfferIds[source]).push(transaction.getId());
               }
               if(transaction.canBeAccumulated())
               {
                  this.mPendingTransactionsBatch.push(transaction);
               }
               else
               {
                  this.pendingTransactionPresentTransaction(transaction);
               }
               DCDebug.traceCh("PendingTransaction","transaction has been applied by server already? = " + transaction.hasBeenAppliedByServer());
               if(!transaction.hasBeenAppliedByServer())
               {
                  DCDebug.traceCh("PendingTransaction","mPendingTransactionsIdsProcessed pushing " + transaction.getId());
                  this.mPendingTransactionsIdsProcessed.push(transaction.getId());
               }
               else if(transaction.needsToNotifyServerByAddItem())
               {
                  userDataMng.updateSocialItem_addItem(transaction.getItemSku(),transaction.getAmount());
               }
            }
         }
         if(this.lockUIGetReason() == 9)
         {
            this.lockUIReset(false);
         }
         if(this.mPendingTransactionsIdsProcessed.length > 0)
         {
            InstanceMng.getUserDataMng().updateMisc_pendingTransactionsProcessed(this.mPendingTransactionsIdsProcessed);
         }
      }
      
      private function pendingTransactionsBatchIsDone() : Boolean
      {
         return this.mPendingTransactionsBatch == null || this.mPendingTransactionsBatch.length == 0 && this.mPendingTransactionsBatch != null;
      }
      
      private function pendingTransactionsLogicUpdate(dt:int) : void
      {
         var transaction:PendingTransaction = null;
         if(this.mPendingTransactionsBatch != null && (this.mPendingTransactionsBatch.length > 0 || this.mPendingTransactionsBatch != null))
         {
            if(this.mPendingTransactionsPopup == null || !this.mPendingTransactionsPopup.isPopupBeingShown())
            {
               if(this.mPendingTransactionsBatch.length > 0)
               {
                  transaction = this.mPendingTransactionsBatch.shift();
                  this.mPendingTransactionsPopup = this.pendingTransactionPresentTransaction(transaction);
               }
               else
               {
                  this.mPendingTransactionsPopup = null;
               }
            }
         }
      }
      
      private function pendingTransactionPresentTransaction(transaction:PendingTransaction) : DCIPopup
      {
         var source:String = null;
         var v:Vector.<String> = null;
         var index:int = 0;
         if(this.mPendingTransactionsOfferIds != null)
         {
            source = transaction.getSource();
            v = this.mPendingTransactionsOfferIds[source];
            if(v != null)
            {
               index = v.indexOf(transaction.getId());
               if(index > -1)
               {
                  v.splice(index,1);
                  if(v.length == 0)
                  {
                     delete this.mPendingTransactionsOfferIds[source];
                  }
               }
            }
         }
         return transaction.presentToTheUser();
      }
      
      public function showInventoryStar(item:ItemObject) : void
      {
         var popup:DCIPopup = InstanceMng.getPopupMng().getPopupBeingShown();
         if(popup is EPopupInventory)
         {
            (popup as EPopupInventory).incrementStarIconAmountByTabName(item.mDef.getMenusList()[0]);
            (popup as EPopupInventory).reloadView();
         }
         else
         {
            InstanceMng.getGUIControllerPlanet().getToolBar().setStarInventoryVisible();
         }
      }
      
      private function quickAttackLoad() : void
      {
         if(this.mQuickAttackRequestTarget == null)
         {
            this.mQuickAttackRequestTarget = new RequestTargetQuickAttack(1,"quickAttack");
         }
      }
      
      private function quickAttackUnload() : void
      {
         if(this.mQuickAttackRequestTarget != null)
         {
            this.mQuickAttackRequestTarget.unload();
            this.mQuickAttackRequestTarget = null;
         }
      }
      
      private function quickAttackRequestTarget() : void
      {
         this.mQuickAttackRequestTarget.requestTarget();
      }
      
      private function quickAttackActuallyRequestTarget() : void
      {
         this.mQuickAttackRequestTarget.requestTarget();
      }
      
      private function quickAttackSetTargetInfo(obj:XML) : void
      {
         this.mQuickAttackRequestTarget.setTargetInfo(obj);
      }
      
      private function quickAttackSetNoTargetFound() : void
      {
         this.mQuickAttackRequestTarget.setNoTargetFound();
      }
      
      private function quickAttackNotifyRequestForTargetExpired() : void
      {
         this.mQuickAttackRequestTarget.notifyRequestForTargetError("targetNotFound");
      }
      
      private function quickAttackIsWaitingForTarget() : Boolean
      {
         return this.mQuickAttackRequestTarget.isWaitingForTarget();
      }
      
      private function quickAttackIsTargetFound() : Boolean
      {
         return this.mQuickAttackRequestTarget.isTargetFound();
      }
      
      private function quickAttackAttackTarget(checkIfOwnerCanAttack:Boolean) : void
      {
         this.mQuickAttackRequestTarget.attackTarget(checkIfOwnerCanAttack,true);
      }
      
      private function quickAttackShowNoTargetFoundPopup() : void
      {
         this.mQuickAttackRequestTarget.notifyRequestForTargetError("targetNotFound");
      }
      
      public function quickAttackNotifyActualBattleStart() : void
      {
         this.mQuickAttackRequestTarget.notifyActualBattleStart();
      }
      
      private function shopControllersLoad() : void
      {
         if(this.mShopControllers == null)
         {
            this.mShopControllers = new Dictionary(true);
         }
         if(Config.useStarTrekShop() && InstanceMng.getPlatformSettingsDefMng().getUseStarTrekShop())
         {
         }
         this.mShopControllers["premium"] = new ShopController("premium",InstanceMng.getPremiumShopDefMng());
      }
      
      private function shopControllersUnload() : void
      {
         var k:* = null;
         var controller:ShopController = null;
         if(this.mShopControllers != null)
         {
            for(k in this.mShopControllers)
            {
               controller = this.mShopControllers[k];
               if(controller != null)
               {
                  controller.unload();
                  delete this.mShopControllers[k];
               }
            }
            this.mShopControllers = null;
         }
      }
      
      public function shopControllersGetControllerBySku(sku:String) : ShopController
      {
         var returnValue:ShopController = null;
         if(this.mShopControllers != null)
         {
            returnValue = this.mShopControllers[sku];
         }
         return returnValue;
      }
      
      public function shopControllersLogicUpdate(dt:int) : void
      {
         var k:* = null;
         var controller:ShopController = null;
         if(this.mShopControllers == null)
         {
            if(InstanceMng.getPlatformSettingsDefMng().isBuilt())
            {
               this.shopControllersLoad();
            }
         }
         else
         {
            for(k in this.mShopControllers)
            {
               controller = this.mShopControllers[k];
               controller.logicUpdate(dt);
            }
         }
      }
      
      public function shopControllerOpenPopup(sku:String, tabSku:String = null, closeOpenedPopup:Boolean = true) : DCIPopup
      {
         var profile:Profile = null;
         var levelRequirement:int = 0;
         if(sku == "premium")
         {
            profile = InstanceMng.getUserInfoMng().getProfileLogin();
            levelRequirement = InstanceMng.getSettingsDefMng().mSettingsDef.getPremiumShopUnlockLevel();
            if(profile.getLevel() < levelRequirement)
            {
               InstanceMng.getNotificationsMng().guiOpenMessagePopup("NOTIFY_SHOW_PREMIUM_SHOP_WARNING",DCTextMng.getText(77),DCTextMng.replaceParameters(4061,[levelRequirement]),"npc_A_normal");
               return null;
            }
         }
         var shopController:ShopController = this.shopControllersGetControllerBySku(sku);
         var popup:PopupPremiumShop;
         if((popup = this.shopControllerCreatePopup(shopController)) != null)
         {
            this.mUIFacade.enqueuePopup(popup,true,true,closeOpenedPopup,false);
            if(tabSku)
            {
               popup.setTabBySku(tabSku);
            }
            if(Config.USE_METRICS)
            {
               DCMetrics.sendMetric("Purchase Item","Started");
            }
         }
         return popup;
      }
      
      private function shopControllerCreatePopup(shopController:ShopController) : PopupPremiumShop
      {
         var skinSku:String = null;
         var popupId:String = "PopupPurchaseShop";
         var popup:PopupPremiumShop = new PopupPremiumShop();
         popup.extendedSetup(popupId,this.mViewFactory,skinSku,shopController);
         return popup;
      }
      
      public function timeLeftGet(sku:String) : Number
      {
         var returnValue:Number = -1;
         var params:Array;
         var cmd:String = String((params = sku.split(":"))[0]);
         switch(cmd)
         {
            case "shield":
               returnValue = InstanceMng.getUserInfoMng().getProfileLogin().getProtectionTimeLeft();
               break;
            case "powerups":
               returnValue = InstanceMng.getPowerUpMng().getPowerUpTimeLeft(params[1]);
               break;
            case "onlineProtection":
               returnValue = InstanceMng.getUserInfoMng().getProfileLogin().getOnlineProtectionTimeLeft();
         }
         return returnValue;
      }
      
      public function timeLeftGetSku(sku:String) : String
      {
         var returnValue:* = null;
         var params:Array;
         var cmd:String = String((params = sku.split(":"))[0]);
         switch(cmd)
         {
            case "shield":
               returnValue = cmd;
               break;
            case "powerups":
               returnValue = sku;
         }
         return returnValue;
      }
      
      private function initGamePaused() : void
      {
         this.mGamePaused.value = false;
      }
      
      public function pauseGame() : void
      {
         if(!this.mGamePaused.value)
         {
            Application.externalNotification(4,{"cmd":"requestScreenshot"});
            if(Config.USE_SOUNDS)
            {
               SoundManager.getInstance().pauseAll();
            }
         }
         this.mGamePaused.value = true;
      }
      
      public function resumeGame() : void
      {
         if(this.mGamePaused.value)
         {
            Application.externalNotification(4,{"cmd":"socialWallClosed"});
            if(Config.USE_SOUNDS)
            {
               SoundManager.getInstance().resumeAll();
            }
         }
         this.mGamePaused.value = false;
      }
      
      public function reloadGame(checkNaranjito:Boolean = false) : void
      {
         var userDataMng:UserDataMng = InstanceMng.getUserDataMng();
         if(checkNaranjito && Config.useNaranjitoOnAttackInProgress())
         {
            userDataMng.notifyAttackInProgress();
         }
         else if(InstanceMng.getPlatformSettingsDefMng().canRefreshPage())
         {
            userDataMng.browserRefresh();
         }
         else
         {
            this.mNeedsToReload.value = true;
         }
      }
      
      private function idleUnload() : void
      {
         this.mIdleEvent = null;
      }
      
      private function idleGetType(e:Object) : String
      {
         return e != null ? e.idleType : null;
      }
      
      private function idlePopupCanBeOpened(e:Object) : Boolean
      {
         var type:String = null;
         var returnValue:Boolean = this.mIdleEvent == null && e != null;
         if(returnValue)
         {
            type = this.idleGetType(e);
            if(type == "PopupAfkTypeTutorial")
            {
               returnValue = InstanceMng.getPlatformSettingsDefMng().getUseInvite();
            }
         }
         return returnValue;
      }
      
      public function idleOpenPopup(e:Object) : void
      {
         var type:String = null;
         var popup:DCIPopup = null;
         var uiFacade:UIFacade = null;
         var title:String = null;
         var body:String = null;
         if(this.idlePopupCanBeOpened(e))
         {
            uiFacade = InstanceMng.getUIFacade();
            title = String(e.title);
            body = String(e.msg);
            popup = uiFacade.getPopupFactory().getSpeechPopup(e,"orange_worried",title,body,DCTextMng.getText(0),null,this.idleClosePopup,true,75,0,false);
            popup.setPopupType("NotifyAFKPopup");
            popup.setEvent(e);
            popup.setIsStackable(true);
            uiFacade.enqueuePopup(popup,e.viewMng,false,true,true);
            InstanceMng.getPopupMng().setAllowPopups(false);
            this.mIdleEvent = e;
         }
      }
      
      public function idleHasBeenToldToOpen() : Boolean
      {
         return this.mIdleEvent != null;
      }
      
      private function idleClosePopup(e:Object = null) : void
      {
         InstanceMng.getUIFacade().closePopupById("NotifyAFKPopup");
         if(this.mIdleEvent != null)
         {
            InstanceMng.getPopupMng().setAllowPopups(true);
            if(this.mIdleEvent.idleType == "PopupAfkTypeIdle")
            {
               InstanceMng.getGUIController().lockGUI();
               this.reloadGame(false);
            }
            this.mIdleEvent = null;
         }
      }
      
      private function speechPopupUnload() : void
      {
         this.mSpeechPopup = null;
         this.mSpeechPopupOnAccept = null;
      }
      
      public function speechPopupOpen(advisorId:String, title:String, body:String, buttonText:String = null, sound:String = null, onAccept:Function = null, useBubble:Boolean = true, showDarkBackground:Boolean = false, advisorSize:int = 75, vAlign:int = 0, advisorOnRightSide:Boolean = false, openImmediately:Boolean = true) : DCIPopup
      {
         var uiFacade:UIFacade = InstanceMng.getUIFacade();
         if(this.mSpeechPopup != null)
         {
            this.speechPopupClose();
         }
         this.mSpeechPopupOnAccept = onAccept;
         if(buttonText == "")
         {
            buttonText = null;
         }
         this.mSpeechPopup = uiFacade.getPopupFactory().getSpeechPopup(null,advisorId,title,body,buttonText,sound,this.speechPopupClose,useBubble,advisorSize,vAlign,advisorOnRightSide);
         uiFacade.enqueuePopup(this.mSpeechPopup,false,showDarkBackground,true,openImmediately);
         return this.mSpeechPopup;
      }
      
      public function speechPopupClose(e:Object = null) : void
      {
         if(this.mSpeechPopup != null)
         {
            InstanceMng.getUIFacade().closePopup(this.mSpeechPopup);
            this.mSpeechPopup = null;
            if(this.mSpeechPopupOnAccept != null)
            {
               this.mSpeechPopupOnAccept();
               this.mSpeechPopupOnAccept = null;
            }
         }
      }
      
      public function hasBeenToldToLogout() : Boolean
      {
         return this.mHasLoggedOut.value;
      }
      
      public function reloadLatestOwnerPlanet(requireOwner:Boolean = true) : void
      {
         var accId:String = null;
         var planetId:String = null;
         if(!requireOwner || InstanceMng.getFlowState().getCurrentRoleId() == 0)
         {
            accId = InstanceMng.getUserInfoMng().getProfileLogin().getAccountId();
            planetId = InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj().getLastOwnerPlanetIdVisited();
            this.requestPlanet(accId,planetId,0);
         }
      }
   }
}
