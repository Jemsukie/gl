package com.dchoc.game.controller.alliances
{
   import com.dchoc.game.controller.role.Role;
   import com.dchoc.game.core.flow.Application;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.alliances.Alliance;
   import com.dchoc.game.model.alliances.AlliancesAPIEvent;
   import com.dchoc.game.model.alliances.AlliancesAPINewsEvent;
   import com.dchoc.game.model.alliances.AlliancesAPIWarEvent;
   import com.dchoc.game.model.alliances.AlliancesConstants;
   import com.dchoc.game.model.alliances.AlliancesNew;
   import com.dchoc.game.model.alliances.AlliancesNewResultWar;
   import com.dchoc.game.model.alliances.AlliancesSessionUser;
   import com.dchoc.game.model.alliances.AlliancesUser;
   import com.dchoc.game.model.alliances.AlliancesWar;
   import com.dchoc.game.model.alliances.AlliancesWarHistory;
   import com.dchoc.game.model.alliances.AlliancesWarHistoryEntry;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.game.model.userdata.UserInfoMng;
   import com.dchoc.game.model.world.World;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.core.component.DCComponentUI;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import esparragon.utils.EUtils;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.utils.Dictionary;
   
   public class AlliancesController extends DCComponentUI
   {
      
      public static const INIT_MODE_OWNER:int = 0;
      
      public static const NOTIFICATIONS_CREATE_ALLIANCE:String = "createAlliance";
      
      public static const NOTIFICATIONS_EDIT_ALLIANCE:String = "editAlliance";
      
      public static const NOTIFICATIONS_REQUEST_MY_ALLIANCE:String = "requestMyAlliance";
      
      public static const NOTIFICATIONS_REQUEST_ALLIANCE_BY_USER_ID:String = "requestAllianceByUserId";
      
      public static const NOTIFICATIONS_REQUEST_ALLIANCE_BY_ID:String = "requestAllianceById";
      
      public static const NOTIFICATIONS_REQUEST_ALLIANCES_LIST:String = "requestAlliancesList";
      
      public static const NOTIFICATIONS_JOIN_ALLIANCE:String = "joinAlliance";
      
      public static const NOTIFICATIONS_LEAVE_ALLIANCE:String = "leaveAlliance";
      
      public static const NOTIFICATIONS_CHANGE_USER_ROLE:String = "changeUserRole";
      
      public static const NOTIFICATIONS_KICK_USER:String = "kickUser";
      
      public static const NOTIFICATIONS_REQUEST_WAR_HISTORY:String = "requestWarHistory";
      
      public static const NOTIFICATIONS_DECLARE_WAR:String = "declareWar";
      
      public static const NOTIFICATIONS_REQUEST_NEWS:String = "requestNews";
      
      public static const NOTIFICATIONS_REQUEST_FRIENDS_TO_INVITE:String = "friendsToInvite";
      
      public static const NOTIFICATIONS_REQUEST_ALLIANCE_WAR_SUGGESTED:String = "getShuffledSuggestedAlliances";
      
      protected static const LOGO_LOGIN_ID:int = 0;
      
      protected static const LOGO_WORLD_ID:int = 1;
      
      private static const LOGO_COUNT:int = 2;
      
      private static const LOGO_NOTIFY_OPTIONS_TOOL:int = 0;
      
      private static const LOGO_NOTIFY_HQ_FLAGS:int = 1;
      
      private static const LOGO_NOTIFY_ALLIANCE_FLAGS:int = 2;
      
      private static const LOGO_NOTIFY_COUNT:int = 3;
       
      
      private var mUsersNotAllowedToBeInvitedToMyAlliance:Vector.<String>;
      
      private var mInitNotified:Boolean = false;
      
      protected var mInitModeToInit:int = 0;
      
      protected var mInitMode:int = -1;
      
      protected var mInitIsInitializing:Boolean = false;
      
      private var mNotificationsLockUI:Dictionary;
      
      private var mNotificationsSuccess:Dictionary;
      
      private var mNotificationsFailed:Dictionary;
      
      private var mNotificationsWarHistory:AlliancesWarHistory;
      
      private var mNotificationsFinishCurrentWarCmdKey:String;
      
      private var mCacheMyAlliance:Alliance;
      
      private var mCacheEnemyAlliance:Alliance;
      
      private var mCacheWorldAlliance:Alliance;
      
      private var mCacheWarHistory:AlliancesWarHistory;
      
      private var mErrorIsEnabled:Boolean = false;
      
      private var mErrorCode:int;
      
      private var mLogoLatest:Vector.<String>;
      
      private var mLogoToApply:Vector.<String>;
      
      private var mLogoNotifiers:Vector.<Vector.<Boolean>>;
      
      private var mTimerStarted:Number = 0;
      
      private var mRemindersInvitations:Dictionary;
      
      protected var mRemindersJoins:Dictionary;
      
      public function AlliancesController()
      {
         super();
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildAsyncTotalSteps = 0;
         mBuildSyncTotalSteps = 1;
      }
      
      override protected function loadDoStep(step:int) : void
      {
         if(step == 0)
         {
            this.mNotificationsSuccess = new Dictionary();
            this.mNotificationsFailed = new Dictionary();
            this.mNotificationsLockUI = new Dictionary();
            this.logoLoad();
         }
      }
      
      override protected function unloadDo() : void
      {
         this.mNotificationsSuccess = null;
         this.mNotificationsFailed = null;
         this.mNotificationsWarHistory = null;
         this.mNotificationsFinishCurrentWarCmdKey = null;
         this.mNotificationsLockUI = null;
         this.mUsersNotAllowedToBeInvitedToMyAlliance = null;
         this.mRemindersInvitations = null;
         this.mRemindersJoins = null;
         this.logoUnload();
      }
      
      override protected function unbuildDo() : void
      {
         this.cacheUnbuild();
         this.logoUnbuild();
      }
      
      override protected function beginDo() : void
      {
         super.beginDo();
         var role:int = InstanceMng.getRole().mId;
         if(role == 3)
         {
            setEnabled(false);
         }
         this.logoSetLogoToApply(this.mLogoLatest[0],0);
      }
      
      public function canBeEnabled() : Boolean
      {
         var roleId:int = InstanceMng.getFlowState().getCurrentRoleId();
         return roleId != 3 && roleId != 7 && InstanceMng.getUnitScene().battleIsRunning() == false;
      }
      
      public function isEnabled() : Boolean
      {
         return false;
      }
      
      public function isPopupOpen() : Boolean
      {
         return false;
      }
      
      public function openPopup() : void
      {
      }
      
      public function openPopupDependingOnSituation() : void
      {
      }
      
      public function closePopup(force:Boolean = false) : void
      {
      }
      
      public function showErrorPopup(data:Object = null) : void
      {
      }
      
      public function isAlliancesVisible() : Boolean
      {
         return false;
      }
      
      protected function getCurrentWarJSON() : Object
      {
         var data:Object = {};
         var alliance:Alliance = this.cacheGetMyAlliance();
         var enemyAlliance:Alliance = this.cacheGetEnemyAlliance();
         data.CurrentWar = {
            "time":alliance.getCurrentWarTimeLeft(),
            "winnerIndex":-1
         };
         var alliances:Array;
         (alliances = []).push(alliance.getJSON());
         alliances.push(enemyAlliance.getJSON());
         data.CurrentWar.Alliance = alliances;
         return data;
      }
      
      public function needsToShowDeclareWarPopup() : Boolean
      {
         var returnValue:Boolean = false;
         var profile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         var alliance:Alliance = this.getMyAlliance();
         if(alliance != null)
         {
            if(alliance.isInAWar())
            {
               returnValue = alliance.getCurrentWarEnemyAllianceId() != profile.flagsGetCurrentWarEnemyAllianceId() || alliance.getCurrentWarTimeStarted() > profile.flagsGetCurrentWarTimeStarted();
            }
         }
         return returnValue;
      }
      
      public function saveCurrentWarInProfile() : void
      {
         var profile:Profile = null;
         var alliance:Alliance = null;
         if(this.needsToShowDeclareWarPopup())
         {
            profile = InstanceMng.getUserInfoMng().getProfileLogin();
            alliance = this.getMyAlliance();
            profile.flagsSetCurrentWarEnemyAllianceId(alliance.getCurrentWarEnemyAllianceId());
            profile.flagsSetCurrentWarTimeStarted(alliance.getCurrentWarTimeStarted());
         }
      }
      
      public function needsToShowWarIsOverPopup() : Boolean
      {
         var warHistory:AlliancesWarHistory = null;
         var entry:AlliancesWarHistoryEntry = null;
         var diff:Number = NaN;
         var returnValue:Boolean = false;
         var profile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         var alliance:Alliance = this.getMyAlliance();
         if(alliance != null)
         {
            if(!alliance.isInAWar())
            {
               if((warHistory = this.cacheGetWarHistory()) != null)
               {
                  entry = warHistory.getEntry(0);
                  if(entry != null)
                  {
                     diff = Math.abs(entry.getTimeStarted() - profile.flagsGetCurrentWarTimeStarted());
                     returnValue = entry.getEnemyAllianceId() == profile.flagsGetCurrentWarEnemyAllianceId() && diff < 600000;
                  }
                  else
                  {
                     DCDebug.traceCh("WARS","ENTRY is null");
                  }
               }
               else
               {
                  DCDebug.traceCh("WARS","WarHistory is null");
               }
            }
            else
            {
               DCDebug.traceCh("WARS","the alliance is still in war");
            }
         }
         return returnValue;
      }
      
      public function needsToShowKickedFromAlliancePopup() : Boolean
      {
         var returnValue:Boolean = false;
         var profile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         var myLastAllianceId:String = profile.flagsGetMyAllianceId();
         var myAlliance:Alliance = this.cacheGetMyAlliance();
         return myLastAllianceId != "" && (myAlliance == null || myAlliance.getId() != myLastAllianceId);
      }
      
      protected function updateProfileWithNewMyAlliance() : void
      {
         var profile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         var myAlliance:Alliance = this.cacheGetMyAlliance();
         if(myAlliance == null)
         {
            profile.flagsSetMyAllianceId("");
            this.resetCurrentWarInProfile();
         }
         else
         {
            profile.flagsSetMyAllianceId(myAlliance.getId());
            profile.flagsSetCurrentWarEnemyAllianceId(myAlliance.getCurrentWarEnemyAllianceId());
            profile.flagsSetCurrentWarTimeStarted(myAlliance.getCurrentWarTimeStarted());
         }
      }
      
      public function resetCurrentWarInProfile() : void
      {
         var profile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         profile.flagsSetCurrentWarEnemyAllianceId("");
         profile.flagsSetCurrentWarTimeStarted(0);
      }
      
      public function initializeSetup(mode:int) : void
      {
         this.mInitModeToInit = mode;
      }
      
      public function initialize(mode:int, lockUI:Boolean = false) : void
      {
         this.mInitMode = mode;
         this.mInitIsInitializing = true;
      }
      
      public function isInitialized() : Boolean
      {
         return false;
      }
      
      public function isInitializing() : Boolean
      {
         return this.mInitIsInitializing;
      }
      
      protected function initSetModeToInit(mode:int) : void
      {
         this.mInitModeToInit = mode;
      }
      
      public function resetInitializeTimer() : void
      {
      }
      
      protected function getProfileWelcomeId() : int
      {
         return InstanceMng.getUserInfoMng().getProfileLogin().flagsGetAlliancesWelcomeId();
      }
      
      protected function getSettingsAlliancesWelcomeId() : int
      {
         return InstanceMng.getAlliancesSettingsDefMng().getAllianceWelcomeId();
      }
      
      protected function getSettingsAlliancesMinimumPlayerLevel() : int
      {
         return InstanceMng.getAlliancesSettingsDefMng().getMinimumPlayerLevel();
      }
      
      public function updateProfileWelcomeId(id:int) : void
      {
         InstanceMng.getUserInfoMng().getProfileLogin().flagsSetAlliancesWelcomeId(id);
      }
      
      public function haveIRequestedForJoinAlliance(allianceId:String) : Boolean
      {
         var value:Number = NaN;
         var returnValue:* = false;
         if(this.mRemindersJoins != null && this.mRemindersJoins[allianceId] != null)
         {
            value = Number(this.mRemindersJoins[allianceId]);
            returnValue = value > 0;
         }
         return returnValue;
      }
      
      public function isRequestForJoinAllianceAllowed(allianceId:String) : Boolean
      {
         var diff:Number = NaN;
         var returnValue:* = true;
         if(this.mRemindersJoins != null && this.mRemindersJoins[allianceId] != null)
         {
            diff = InstanceMng.getUserDataMng().getServerCurrentTimemillis() - this.mRemindersJoins[allianceId];
            returnValue = diff >= InstanceMng.getAlliancesSettingsDefMng().getRemindJoinTime();
         }
         return returnValue;
      }
      
      public function saveAllianceIdRequestedForJoin(allianceId:String) : void
      {
         this.remindersAddAllianceIdToJoin(allianceId);
      }
      
      public function getMyUser() : AlliancesUser
      {
         return AlliancesSessionUser.getInstance();
      }
      
      public function getMyAlliance() : Alliance
      {
         return this.cacheGetMyAlliance();
      }
      
      public function getEnemyAlliance() : Alliance
      {
         return this.cacheGetEnemyAlliance();
      }
      
      public function getWorldAlliance() : Alliance
      {
         var returnValue:Alliance = null;
         if(this.logoIsWorldVisitor())
         {
            returnValue = this.cacheGetWorldAlliance();
         }
         else
         {
            returnValue = this.cacheGetMyAlliance();
         }
         return returnValue;
      }
      
      public function getMyLastWarEntry() : AlliancesWarHistoryEntry
      {
         var returnValue:AlliancesWarHistoryEntry = null;
         var alliancesWarHistory:AlliancesWarHistory = this.cacheGetWarHistory();
         if(alliancesWarHistory != null)
         {
            returnValue = alliancesWarHistory.getEntry(0);
         }
         return returnValue;
      }
      
      public function isMyAllianceInAWar() : Boolean
      {
         var myAlliance:Alliance = this.getMyAlliance();
         return myAlliance != null && myAlliance.isInAWar();
      }
      
      public function isMyAllianceInAWarAgainstUserId(userId:String) : Boolean
      {
         return this.isMyAllianceInAWar() && this.getEnemyAlliance().getMember(userId) != null;
      }
      
      public function isMeInAnyAlliance() : Boolean
      {
         return false;
      }
      
      public function createAlliance(name:String, description:String, logo:Array, isPublic:Boolean, successCallback:Function = null, failedCallback:Function = null, transaction:Transaction = null, lockUI:Boolean = false) : void
      {
      }
      
      public function editMyAlliance(logo:Array, description:String, isPublic:Boolean, successCallback:Function = null, failedCallback:Function = null, transaction:Transaction = null, lockUI:Boolean = false) : void
      {
      }
      
      public function requestMyAlliance(successCallback:Function = null, failedCallback:Function = null, lockUI:Boolean = false) : void
      {
      }
      
      public function requestAllianceByUserId(userId:String, includeMembers:Boolean, successCallback:Function = null, failedCallback:Function = null, lockUI:Boolean = false) : void
      {
      }
      
      public function requestAllianceById(allianceId:String, includeMembers:Boolean, successCallback:Function = null, failedCallback:Function = null, lockUI:Boolean = false) : void
      {
      }
      
      public function requestAlliances(successCallback:Function = null, failedCallback:Function = null, lockUI:Boolean = false, start_index:uint = 0, count:uint = 100, search_string:String = null, centerInUserPage:Boolean = false) : void
      {
      }
      
      public function joinRequirementFailedNotification(levelRequired:int) : void
      {
      }
      
      public function joinAlliance(allianceId:String, successCallback:Function = null, failedCallback:Function = null, lockUI:Boolean = false) : void
      {
      }
      
      public function leaveMyAlliance(successCallback:Function = null, failedCallback:Function = null, lockUI:Boolean = false) : void
      {
      }
      
      public function promote(user:AlliancesUser, successCallback:Function = null, failedCallback:Function = null, lockUI:Boolean = false) : void
      {
      }
      
      public function demote(user:AlliancesUser, successCallback:Function = null, failedCallback:Function = null, lockUI:Boolean = false) : void
      {
      }
      
      public function kickUser(user:AlliancesUser, successCallback:Function = null, failedCallback:Function = null, lockUI:Boolean = false) : void
      {
      }
      
      public function visitUser(accountID:String, userName:String, imgURL:String, forcedSpy:Boolean = false) : void
      {
         var str:* = null;
         var userInfoMng:UserInfoMng;
         var userInfo:UserInfo = (userInfoMng = InstanceMng.getUserInfoMng()).getUserInfoObj(accountID,0);
         userName = userName.replace("\'","&apos;");
         if(userInfo == null)
         {
            str = "<allianceVisit accountId=\'" + accountID + "\' name=\'" + userName + "\' url=\'" + imgURL + "\' tutorialCompleted=\'1\'/>";
            userInfoMng.addOtherPlayerInfo(EUtils.stringToXML(str));
         }
         this.closePopup(true);
         DCDebug.trace("AlliancesMng: visit_clickHandler uid " + accountID);
         var role:int = AlliancesConstants.getVisitRoleId(accountID,forcedSpy);
         InstanceMng.getApplication().requestPlanet(accountID,"-2",role);
      }
      
      public function getUsersNotAllowedToBeInvitedToMyAlliance() : Vector.<String>
      {
         var extId:String = null;
         var members:Array = null;
         var member:AlliancesUser = null;
         var timeToWait:Number = NaN;
         var serverTime:Number = NaN;
         var invitationTime:Number = NaN;
         var diff:Number = NaN;
         var id:* = null;
         if(this.mUsersNotAllowedToBeInvitedToMyAlliance == null)
         {
            this.mUsersNotAllowedToBeInvitedToMyAlliance = new Vector.<String>(0);
         }
         else
         {
            this.mUsersNotAllowedToBeInvitedToMyAlliance.splice(0,this.mUsersNotAllowedToBeInvitedToMyAlliance.length);
         }
         var myAlliance:Alliance;
         if((myAlliance = this.getMyAlliance()) != null)
         {
            members = myAlliance.getMembers();
            if(members != null)
            {
               for each(member in members)
               {
                  if((extId = InstanceMng.getUserInfoMng().getExtIdByAccId(member.getId())) != null)
                  {
                     if(this.mUsersNotAllowedToBeInvitedToMyAlliance.indexOf(extId) == -1)
                     {
                        this.mUsersNotAllowedToBeInvitedToMyAlliance.push(extId);
                     }
                  }
               }
            }
         }
         DCDebug.traceChObject("alInvites",this.mRemindersInvitations,"invitations:");
         if(this.mRemindersInvitations != null)
         {
            timeToWait = InstanceMng.getAlliancesSettingsDefMng().getRemindInvitationTime();
            serverTime = InstanceMng.getUserDataMng().getServerCurrentTimemillis();
            for(id in this.mRemindersInvitations)
            {
               invitationTime = Number(this.mRemindersInvitations[id]);
               if((diff = serverTime - invitationTime) < timeToWait)
               {
                  if(this.mUsersNotAllowedToBeInvitedToMyAlliance.indexOf(id) == -1)
                  {
                     this.mUsersNotAllowedToBeInvitedToMyAlliance.push(id);
                  }
               }
               else
               {
                  this.mRemindersInvitations[id] = null;
                  DCDebug.traceCh("Optim","setting id: " + id + " to null");
                  DCDebug.traceCh("Optim","diff < timeToWait? " + (diff < timeToWait).toString());
                  DCDebug.traceCh("Optim","diff: " + diff);
                  DCDebug.traceCh("Optim","timeToWait: " + timeToWait);
               }
            }
         }
         return this.mUsersNotAllowedToBeInvitedToMyAlliance;
      }
      
      public function inviteFriends(lockUI:Boolean) : void
      {
      }
      
      protected function requestWarsCompleteHistory(successCallback:Function = null, failedCallback:Function = null, lockUI:Boolean = false) : void
      {
         this.requestWarsHistory(0,-1,successCallback,failedCallback,lockUI);
      }
      
      protected function setWarCompleteHistory(data:Object) : void
      {
      }
      
      protected function getWarCompleteHistory() : AlliancesWarHistory
      {
         return null;
      }
      
      public function requestWarsHistory(startIndex:uint = 0, count:int = 9, successCallback:Function = null, failedCallback:Function = null, lockUI:Boolean = false) : void
      {
      }
      
      public function declareWar(allianceAgainstId:String, successCallback:Function = null, failedCallback:Function = null, lockUI:Boolean = false) : void
      {
      }
      
      public function requestNews(successCallback:Function, failedCallback:Function, types:Array, start_index:uint = 0, count:uint = 9, lockUI:Boolean = false) : void
      {
      }
      
      protected function updateNewsInformation(news:AlliancesNewResultWar) : void
      {
      }
      
      protected function notificationsStoreNotification(key:String, success:Function, failed:Function, lockUI:Boolean) : void
      {
         DCDebug.traceCh("ALLIANCES","notificationsStoreNotification " + key + " success = " + success + " failed = " + failed);
         this.mNotificationsSuccess[key] = success;
         this.mNotificationsFailed[key] = failed;
         this.mNotificationsLockUI[key] = lockUI;
      }
      
      private function notificationsIsCorrectFormat(cmd:String, data:Object) : Boolean
      {
         var returnValue:Boolean = true;
         var _loc4_:* = cmd;
         if("requestMyAlliance" === _loc4_)
         {
            returnValue = data != null && data.alliance != null;
         }
         return returnValue;
      }
      
      public function notificationsNotify(cmd:String, ok:Boolean, data:Object, requestParams:Object = null) : void
      {
         var allianceEvent:AlliancesAPIEvent = null;
         var callback:Function = null;
         var errorCode:int = 0;
         var errorMsg:String = null;
         var alliance:Alliance = null;
         var allianceId:String = null;
         var warEvent:AlliancesAPIWarEvent = null;
         var war:AlliancesWar = null;
         var user:AlliancesUser = null;
         var myUser:AlliancesUser = null;
         var profile:Profile = null;
         var myAllianceId:String = null;
         var key:String = null;
         var allianceJSON:* = null;
         var userInfoMng:UserInfoMng = null;
         var members:Array = null;
         var member:AlliancesUser = null;
         var userInfo:UserInfo = null;
         var memberFriendExternalIds:String = null;
         var length:int = 0;
         var alliances:Array = null;
         var totalAlliances:int = 0;
         var aObject:Object = null;
         var newRole:String = null;
         var myUserInAlliance:AlliancesUser = null;
         var enemyAllianceId:String = null;
         var enemyAlliance:Alliance = null;
         var myAlliance:Alliance = null;
         var lineStartIndex:int = 0;
         var lineCount:int = 0;
         var historic:AlliancesWarHistory = null;
         var alliancesNewsEvent:AlliancesAPINewsEvent = null;
         var totalNews:uint = 0;
         var news:Vector.<AlliancesNew> = null;
         var allianceNew:AlliancesNew = null;
         var nJSON:Object = null;
         var application:Application = null;
         DCDebug.traceCh("ALLIANCES","++++++++++++++++++++++");
         DCDebug.traceCh("ALLIANCES"," responseAlliances: " + cmd + " ok = " + ok);
         if(data == null)
         {
            DCDebug.traceCh("ALLIANCES","data: null");
         }
         else if(!Config.DEBUG_SHORTEN_NOISY || Config.DEBUG_SHORTEN_NOISY_CMDS.indexOf(cmd) == -1)
         {
            DCDebug.traceChObject("ALLIANCES",data);
         }
         else
         {
            DCDebug.traceCh("ALLIANCES",cmd + " info omitted");
         }
         if(this.timerIsWorking())
         {
            DCDebug.traceCh("ALLIANCES"," TIME PASSED : " + this.timerGetTimePassed());
         }
         DCDebug.traceCh("ALLIANCES","++++++++++++++++++++++");
         DCDebug.traceCh("ALLIANCES","");
         if(this.errorGetIsEnabled())
         {
            ok = false;
            data = {
               "result":"false",
               "error":this.mErrorCode
            };
         }
         var cmdKey:* = cmd;
         if(ok)
         {
            ok = this.notificationsIsCorrectFormat(cmd,data);
            if(!ok)
            {
               DCDebug.traceCh("ALLIANCES"," ERROR: DATA INVALID FORMAT.");
               data = {
                  "result":"false",
                  "error":11
               };
            }
         }
         if(!ok)
         {
            var _loc43_:* = cmdKey;
            if("requestMyAlliance" === _loc43_)
            {
               if(data != null)
               {
                  this.profileSetData(data.profile);
               }
            }
            callback = this.mNotificationsFailed[cmdKey];
            DCDebug.traceCh("ALLIANCES","callback: " + callback);
            if(callback != null)
            {
               errorCode = 0;
               errorMsg = null;
               if(data != null && data.hasOwnProperty("error"))
               {
                  errorCode = int(data.error);
                  errorMsg = String(data.errorMsg);
               }
               DCDebug.traceCh("ALLIANCES","error launched: errorCode = " + errorCode + " | errorMsg = " + errorMsg + " | data:");
               DCDebug.traceChObject("ALLIANCES",data);
               (allianceEvent = new AlliancesAPIEvent("alliance_api_error",requestParams)).setError(errorCode,errorMsg,data);
               callback(allianceEvent);
            }
         }
         else
         {
            callback = this.mNotificationsSuccess[cmdKey];
            myUser = this.getMyUser();
            profile = InstanceMng.getUserInfoMng().getProfileLogin();
            myAllianceId = myUser.getAllianceId();
            if(callback != null)
            {
               switch(cmdKey)
               {
                  case "createAlliance":
                  case "editAlliance":
                  case "requestMyAlliance":
                  case "requestAllianceById":
                  case "requestAllianceByUserId":
                     allianceJSON = data;
                     if(data != null && (cmdKey == "requestMyAlliance" || cmdKey == "requestAllianceById" || cmdKey == "requestAllianceByUserId"))
                     {
                        allianceJSON = data.alliance;
                        if(cmdKey == "requestMyAlliance" && data.profile != null)
                        {
                           this.profileSetData(data.profile);
                        }
                     }
                     (alliance = new Alliance()).fromJSON(allianceJSON);
                     if(cmdKey == "createAlliance")
                     {
                        profile.flagsSetMyAllianceId(alliance.getId());
                     }
                     if(cmdKey == "requestMyAlliance")
                     {
                        allianceId = alliance.getId();
                        if(profile.flagsGetMyAllianceId() != allianceId)
                        {
                           profile.flagsSetMyAllianceId(allianceId);
                           userInfoMng = InstanceMng.getUserInfoMng();
                           members = alliance.getMembers();
                           memberFriendExternalIds = "";
                           for each(member in members)
                           {
                              if(member.isFriend())
                              {
                                 memberFriendExternalIds += userInfoMng.getExtIdByAccId(member.getId()) + ",";
                              }
                           }
                           if((length = memberFriendExternalIds.length) > 0)
                           {
                              memberFriendExternalIds = memberFriendExternalIds.substring(0,length - 1);
                           }
                        }
                     }
                     if(cmdKey != "requestAllianceById" && cmdKey != "requestAllianceByUserId")
                     {
                        if(myUser != null)
                        {
                           if((user = alliance.getMember(InstanceMng.getUserDataMng().mUserAccountId)) != null)
                           {
                              myUser.clone(user);
                           }
                        }
                        this.cacheSetMyAlliance(alliance);
                        this.logoUpdateView(alliance.getLogo(),0);
                     }
                     (allianceEvent = new AlliancesAPIEvent("alliance_api_success",requestParams)).alliance = alliance;
                     callback(allianceEvent);
                     break;
                  case "joinAlliance":
                     if(myUser != null && requestParams != null)
                     {
                        key = AlliancesConstants.objGetKey(requestParams,"aid");
                        allianceId = String(requestParams[key]);
                        this.saveAllianceIdRequestedForJoin(allianceId);
                        allianceEvent = new AlliancesAPIEvent("alliance_api_success",requestParams);
                        callback(allianceEvent);
                     }
                     break;
                  case "requestAlliancesList":
                     alliances = [];
                     totalAlliances = 0;
                     for each(aObject in data.alliances)
                     {
                        (alliance = new Alliance()).fromJSON(aObject);
                        alliances.push(alliance);
                     }
                     alliances.sort(this.sortByRankAsc);
                     totalAlliances = Math.abs(data.totalSize);
                     (allianceEvent = new AlliancesAPIEvent("alliance_api_success",requestParams)).count = totalAlliances;
                     allianceEvent.alliance_array = alliances;
                     callback(allianceEvent);
                     break;
                  case "getShuffledSuggestedAlliances":
                     (allianceEvent = new AlliancesAPIEvent("alliance_api_success",requestParams)).alliance = requestParams["alliance"] as Alliance;
                     callback(allianceEvent);
                     break;
                  case "leaveAlliance":
                     myUser.leaveAlliance();
                     this.cacheReset();
                     this.logoUpdateView(null,0);
                     this.updateProfileWithNewMyAlliance();
                     allianceEvent = new AlliancesAPIEvent("alliance_api_success",requestParams);
                     callback(allianceEvent);
                     break;
                  case "kickUser":
                     if((alliance = this.getMyAlliance()) != null && requestParams != null)
                     {
                        key = AlliancesConstants.objGetKey(requestParams,"memberId");
                        alliance.removeMember(requestParams[key]);
                        allianceEvent = new AlliancesAPIEvent("alliance_api_success",requestParams);
                        callback(allianceEvent);
                     }
                     break;
                  case "changeUserRole":
                     if((alliance = this.getMyAlliance()) != null && requestParams != null)
                     {
                        key = AlliancesConstants.objGetKey(requestParams,"memberId");
                        if((user = alliance.getMember(requestParams[key])) != null)
                        {
                           key = AlliancesConstants.objGetKey(requestParams,"role");
                           if((newRole = String(requestParams[key])) == "LEADER")
                           {
                              myUser.setRole("ADMIN");
                              if((myUserInAlliance = alliance.getMember(myUser.getId())) != null)
                              {
                                 myUserInAlliance.setRole("ADMIN");
                              }
                              alliance.setLeader(user);
                           }
                           user.setRole(newRole);
                        }
                        allianceEvent = new AlliancesAPIEvent("alliance_api_success",requestParams);
                        callback(allianceEvent);
                     }
                     break;
                  case "declareWar":
                     key = AlliancesConstants.objGetKey(requestParams,"aid");
                     enemyAllianceId = String(requestParams == null ? null : requestParams[key]);
                     if((enemyAlliance = this.cacheGetEnemyAlliance()) == null)
                     {
                        if(enemyAllianceId == null)
                        {
                           this.notificationsNotify(cmdKey,false,null,requestParams);
                        }
                        else
                        {
                           this.mNotificationsFinishCurrentWarCmdKey = cmdKey;
                           this.requestAllianceById(enemyAllianceId,true,this.notificationsFinishCurrentWar,this.mNotificationsFailed[cmdKey]);
                        }
                     }
                     else
                     {
                        if((myAlliance = this.cacheGetMyAlliance()).getCurrentWarEnemyAllianceId() == null)
                        {
                           myAlliance.declareWar(enemyAlliance.getId(),InstanceMng.getAlliancesSettingsDefMng().getWarDuration());
                        }
                        if(enemyAlliance.getCurrentWarEnemyAllianceId() == null)
                        {
                           enemyAlliance.declareWar(myAlliance.getId(),InstanceMng.getAlliancesSettingsDefMng().getWarDuration());
                        }
                        data = this.getCurrentWarJSON();
                        if(cmdKey == "declareWar")
                        {
                           profile.flagsSetCurrentWarEnemyAllianceId(enemyAlliance.getId());
                           profile.flagsSetCurrentWarTimeStarted(myAlliance.getCurrentWarTimeStarted());
                        }
                        (war = new AlliancesWar()).fromJSON(data);
                        (warEvent = new AlliancesAPIWarEvent("alliance_api_success",requestParams)).setWar(war);
                        callback(warEvent);
                     }
                     break;
                  case "requestWarHistory":
                     key = AlliancesConstants.objGetKey(requestParams,"from");
                     lineStartIndex = int(requestParams[key]);
                     key = AlliancesConstants.objGetKey(requestParams,"count");
                     lineCount = int(requestParams[key]);
                     DCDebug.traceChObject("ALLIANCES",requestParams);
                     DCDebug.traceCh("ALLIANCES"," lineStartIndex = " + lineStartIndex + " lineCount = " + lineCount);
                     if(lineCount == -1)
                     {
                        this.setWarCompleteHistory(data);
                        historic = this.getWarCompleteHistory();
                        (warEvent = new AlliancesAPIWarEvent("alliance_api_success",requestParams)).setWarHistory(historic);
                        callback(warEvent);
                     }
                     else
                     {
                        (historic = new AlliancesWarHistory()).fromJSON(data);
                        this.cacheSetWarHistory(historic);
                        if(this.mNotificationsWarHistory == null)
                        {
                           this.mNotificationsWarHistory = new AlliancesWarHistory();
                        }
                        DCDebug.traceCh("ALLIANCES"," HISTORIC:");
                        DCDebug.traceChObject("ALLIANCES",historic);
                        if(Config.OFFLINE_GAMEPLAY_MODE)
                        {
                           this.mNotificationsWarHistory.clone(historic,lineStartIndex,lineCount);
                        }
                        else
                        {
                           this.mNotificationsWarHistory.clone(historic,0,lineCount);
                        }
                        DCDebug.traceCh("ALLIANCES"," WARHISTORY:");
                        DCDebug.traceChObject("ALLIANCES",this.mNotificationsWarHistory);
                        (warEvent = new AlliancesAPIWarEvent("alliance_api_success",requestParams)).setWarHistory(this.mNotificationsWarHistory);
                        callback(warEvent);
                     }
                     break;
                  case "requestNews":
                     alliancesNewsEvent = new AlliancesAPINewsEvent("alliance_api_success",requestParams);
                     news = new Vector.<AlliancesNew>(0);
                     for each(nJSON in data.News.theNew)
                     {
                        allianceNew = this.createAllianceNewFromJSON(nJSON);
                        news.push(allianceNew);
                     }
                     totalNews = uint(data.News.totalNews);
                     alliancesNewsEvent.setup(news,totalNews);
                     callback(alliancesNewsEvent);
                     break;
                  default:
                     allianceEvent = new AlliancesAPIEvent("alliance_api_success",requestParams);
                     callback(allianceEvent);
               }
            }
         }
         if(this.mNotificationsLockUI[cmdKey])
         {
            if((application = InstanceMng.getApplication()).lockUIGetReason() == 7)
            {
               application.lockUIReset();
            }
         }
      }
      
      private function createAllianceNewFromJSON(data:Object) : AlliancesNew
      {
         var allianceNew:AlliancesNew = null;
         var allianceNewResultWar:AlliancesNewResultWar = null;
         var type:int = int(data.type);
         var subtype:int = int(data.subType);
         var isAWarResultNew:Boolean;
         if(isAWarResultNew = type == 2 && (subtype == 11 || subtype == 10))
         {
            allianceNew = new AlliancesNewResultWar();
         }
         else
         {
            allianceNew = new AlliancesNew();
         }
         allianceNew.fromJSON(data);
         if(isAWarResultNew)
         {
            if((allianceNewResultWar = allianceNew as AlliancesNewResultWar).hasIncompleteInformation())
            {
               this.updateNewsInformation(allianceNewResultWar);
            }
         }
         return allianceNew;
      }
      
      private function sortByRankAsc(a:Alliance, b:Alliance) : Number
      {
         var aVal:Number = a.getRank();
         var bVal:Number = b.getRank();
         if(aVal > bVal)
         {
            return 1;
         }
         if(aVal < bVal)
         {
            return -1;
         }
         return 0;
      }
      
      private function notificationsFinishCurrentWar(event:AlliancesAPIEvent) : void
      {
         var enemyAlliance:Alliance = event.alliance;
         DCDebug.traceCh("ALLIANCES"," CACHE_ENEMY 3");
         this.cacheSetEnemyAlliance(enemyAlliance);
         if(enemyAlliance == null)
         {
            this.notificationsNotify(this.mNotificationsFinishCurrentWarCmdKey,false,null,null);
         }
         else
         {
            this.notificationsNotify(this.mNotificationsFinishCurrentWarCmdKey,true,null,null);
         }
      }
      
      private function cacheUnbuild() : void
      {
         this.mCacheMyAlliance = null;
         this.mCacheEnemyAlliance = null;
         this.mCacheWorldAlliance = null;
         this.mCacheWarHistory = null;
      }
      
      public function cacheReset() : void
      {
         this.mCacheMyAlliance = null;
         this.mCacheEnemyAlliance = null;
         this.mCacheWarHistory = null;
         this.profileSetData(null);
      }
      
      private function cacheSetMyAlliance(value:Alliance) : void
      {
         this.mCacheMyAlliance = value;
      }
      
      protected function cacheGetMyAlliance() : Alliance
      {
         return this.mCacheMyAlliance;
      }
      
      protected function cacheSetEnemyAlliance(value:Alliance) : void
      {
         DCDebug.traceCh("ALLIANCES"," cacheSEtEnemyAlliance:");
         DCDebug.traceChObject("ALLIANCES",value);
         this.mCacheEnemyAlliance = value;
      }
      
      protected function cacheGetEnemyAlliance() : Alliance
      {
         return this.mCacheEnemyAlliance;
      }
      
      protected function cacheGetWorldAlliance() : Alliance
      {
         return this.mCacheWorldAlliance;
      }
      
      protected function cacheSetWorldAlliance(value:Alliance) : void
      {
         this.mCacheWorldAlliance = value;
      }
      
      protected function cacheGetWarHistory() : AlliancesWarHistory
      {
         return this.mCacheWarHistory;
      }
      
      protected function cacheSetWarHistory(value:AlliancesWarHistory) : void
      {
         this.mCacheWarHistory = value;
      }
      
      protected function errorGetIsEnabled() : Boolean
      {
         return this.mErrorIsEnabled;
      }
      
      public function errorDisable() : void
      {
         this.mErrorIsEnabled = false;
      }
      
      public function errorEnable(value:int) : void
      {
         if(value >= 0 && value < 24)
         {
            this.mErrorIsEnabled = true;
            this.mErrorCode = value;
         }
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var logoId:int = 0;
         var notifiersDoneCount:int = 0;
         var layerId:int = 0;
         var logoToApply:String = null;
         var logo:Array = null;
         var currentWarTimeLeft:Number = NaN;
         if(this.canBeEnabled())
         {
            if(!this.mInitNotified)
            {
               if(InstanceMng.getUIFacade().alliancesUpdateStarButtons())
               {
                  this.mInitNotified = true;
               }
            }
         }
         if(this.mLogoToApply != null)
         {
            notifiersDoneCount = 0;
            for(logoId = 0; logoId < 2; )
            {
               if((logoToApply = this.mLogoToApply[logoId]) != null)
               {
                  notifiersDoneCount = 0;
                  logo = AlliancesConstants.getLogoArrayFromString(logoToApply);
                  for(layerId = 0; layerId < 3; )
                  {
                     if(this.mLogoNotifiers[logoId][layerId])
                     {
                        continue;
                     }
                     switch(layerId)
                     {
                        case 0:
                           if(logoToApply == "")
                           {
                              InstanceMng.getUIFacade().alliancesSetDefaultFlag();
                           }
                           else
                           {
                              currentWarTimeLeft = -1;
                              if(this.getMyAlliance() != null)
                              {
                                 currentWarTimeLeft = this.getMyAlliance().getCurrentWarTimeLeft();
                              }
                              InstanceMng.getUIFacade().alliancesButtonReplaceByUserFlag(logo,currentWarTimeLeft);
                           }
                           this.mLogoNotifiers[logoId][layerId] = true;
                           break;
                        case 1:
                           this.logoSetHQFlag(logoId,layerId,logo);
                           break;
                        case 2:
                           this.logoSetWorldAnimation(logoId,layerId,logo);
                           break;
                     }
                     if(this.mLogoNotifiers[logoId][layerId])
                     {
                        notifiersDoneCount++;
                     }
                     layerId++;
                  }
                  if(notifiersDoneCount == 3)
                  {
                     this.mLogoToApply[logoId] = null;
                  }
               }
               logoId++;
            }
         }
      }
      
      private function logoSetHQFlag(logoId:int, layerId:int, logo:Array) : void
      {
         var hq:WorldItemObject = null;
         var dc:DCDisplayObject = null;
         var world:World;
         if((world = InstanceMng.getWorld()).isBuilt())
         {
            if((hq = world.itemsGetHeadquarters()) != null)
            {
               if((dc = hq.viewLayersAnimGet(3)) != null)
               {
                  InstanceMng.getResourceMng().applyFlagFilter(dc.getDisplayObject(),logo);
                  this.mLogoNotifiers[logoId][layerId] = true;
               }
            }
         }
      }
      
      private function logoSetWorldAnimation(logoId:int, layerId:int, logo:Array) : void
      {
         var allianceName:String = null;
         var resourceLoaded:Boolean = false;
         var allianceAnimFlagDOC:DisplayObjectContainer = null;
         var flags:DisplayObject = null;
         var myAlliance:Alliance;
         if((myAlliance = this.getWorldAlliance()) != null && !InstanceMng.getUserInfoMng().getCurrentProfileLoaded().getUserInfoObj().mIsNPC.value)
         {
            if((allianceName = InstanceMng.getBackgroundController().getAllianceAnimationAssetForCurrentSituation()) != null)
            {
               if(!(resourceLoaded = InstanceMng.getResourceMng().isResourceLoaded(allianceName)))
               {
                  InstanceMng.getResourceMng().requestResource(allianceName);
               }
               else if((allianceAnimFlagDOC = InstanceMng.getMapViewPlanet().getAllianceAnimDOC()) != null)
               {
                  flags = allianceAnimFlagDOC.getChildByName("flag_group");
                  InstanceMng.getResourceMng().applyFlagFilter(flags,logo);
                  InstanceMng.getMapViewPlanet().setAllianceFlagsAnimationVisibility(true);
                  this.mLogoNotifiers[logoId][layerId] = true;
               }
            }
         }
         else
         {
            InstanceMng.getMapViewPlanet().setAllianceFlagsAnimationVisibility(false);
            this.mLogoNotifiers[logoId][layerId] = false;
         }
      }
      
      private function logoLoad() : void
      {
         if(this.mLogoLatest == null)
         {
            this.mLogoLatest = new Vector.<String>(2);
         }
         if(this.mLogoToApply == null)
         {
            this.mLogoToApply = new Vector.<String>(2);
         }
         if(this.mLogoNotifiers == null)
         {
            this.mLogoNotifiers = new Vector.<Vector.<Boolean>>(2);
         }
         this.logoBuild();
      }
      
      private function logoUnload() : void
      {
         this.mLogoNotifiers = null;
         this.mLogoLatest = null;
         this.mLogoToApply = null;
      }
      
      private function logoBuild() : void
      {
         var i:int = 0;
         if(this.mLogoLatest != null)
         {
            i = 0;
            for(i = 0; i < 2; )
            {
               this.mLogoToApply[i] = null;
               this.mLogoLatest[i] = "";
               i++;
            }
         }
      }
      
      protected function logoUnbuild() : void
      {
         this.logoBuild();
      }
      
      private function logoSetLogoToApply(logoStr:String, logoId:int) : void
      {
         var i:int = 0;
         var application:Application = null;
         var planetBelongToUser:Boolean = false;
         this.mLogoToApply[logoId] = logoStr;
         if(this.mLogoNotifiers[logoId] == null)
         {
            this.mLogoNotifiers[logoId] = new Vector.<Boolean>(3);
         }
         i = 0;
         while(i < 3)
         {
            if(i == 0)
            {
               this.mLogoNotifiers[logoId][i] = logoId != 0;
            }
            else
            {
               application = InstanceMng.getApplication();
               planetBelongToUser = Role.doesPlanetBelongToUser(application.goToGetRequestRoleId());
               this.mLogoNotifiers[logoId][i] = !(application.viewGetMode() == 0 && (logoId == 0 && planetBelongToUser || !planetBelongToUser && logoId == 1));
            }
            i++;
         }
      }
      
      protected function logoUpdateView(logo:Array, logoId:int) : void
      {
         var logoStr:String = InstanceMng.getUserInfoMng().getProfileLogin().isTutorialCompleted() ? AlliancesConstants.getLogoArrayAsString(logo) : "";
         DCDebug.traceCh("ALLIANCES","LOGO_UPDATE_VIEW: " + AlliancesConstants.getLogoArrayAsString(logo) + " logoId = " + logoId + " logoStr = " + logoStr + " latest = " + this.mLogoLatest[logoId]);
         if(logoStr != this.mLogoLatest[logoId] || logoId == 1)
         {
            this.logoSetLogoToApply(logoStr,logoId);
            this.mLogoLatest[logoId] = logoStr;
         }
      }
      
      protected function logoIsWorldVisitor() : Boolean
      {
         var application:Application = InstanceMng.getApplication();
         var planetBelongToUser:Boolean = Role.doesPlanetBelongToUser(application.goToGetRequestRoleId());
         return application.viewGetMode() == 0 && !planetBelongToUser;
      }
      
      protected function timerStart() : void
      {
         this.mTimerStarted = InstanceMng.getUserDataMng().getServerCurrentTimemillis();
      }
      
      protected function timerEnd() : void
      {
         this.mTimerStarted = 0;
      }
      
      protected function timerIsWorking() : Boolean
      {
         return this.mTimerStarted != 0;
      }
      
      protected function timerGetTimePassed() : Number
      {
         return InstanceMng.getUserDataMng().getServerCurrentTimemillis() - this.mTimerStarted;
      }
      
      private function remindersSetInvitations(invitations:String) : void
      {
         if(invitations != null)
         {
            this.mRemindersInvitations = new Dictionary();
            this.reminderProcessData(invitations,this.mRemindersInvitations);
            DCDebug.traceChObject("alInvites",this.mRemindersInvitations,"setInvitations:" + invitations + " ------------");
         }
      }
      
      public function remindersAddInvitations(invitations:String) : void
      {
         var requests:Array = null;
         var r:String = null;
         if(invitations != null)
         {
            if(this.mRemindersInvitations == null)
            {
               this.mRemindersInvitations = new Dictionary();
            }
            requests = invitations.split(",");
            for each(r in requests)
            {
               if(r != null)
               {
                  this.mRemindersInvitations[r] = InstanceMng.getApplication().getCurrentServerTimeMillis();
               }
            }
         }
      }
      
      public function remindersRemindersInvitationsPrint() : void
      {
         var s:* = null;
         if(this.mRemindersInvitations != null)
         {
            for(s in this.mRemindersInvitations)
            {
               DCDebug.traceCh("Optim","Key: " + s + " value: " + this.mRemindersInvitations[s]);
            }
         }
         else
         {
            DCDebug.traceCh("Optim","mRemindersInvitations is null");
         }
      }
      
      private function remindersSetJoins(joins:String) : void
      {
         if(joins != null)
         {
            this.mRemindersJoins = new Dictionary();
            this.reminderProcessData(joins,this.mRemindersJoins);
         }
      }
      
      private function reminderProcessData(data:String, d:Dictionary) : void
      {
         var length:int = 0;
         var myPattern:RegExp = null;
         var requests:Array = null;
         var r:String = null;
         var tokens:Array = null;
         var extId:String = null;
         var userInfoMng:UserInfoMng = null;
         if(data != null)
         {
            if((length = data.length) > 2)
            {
               myPattern = /(")|}|{/g;
               data = data.replace(myPattern,"");
               requests = data.split(",");
               userInfoMng = InstanceMng.getUserInfoMng();
               for each(r in requests)
               {
                  if(r != null)
                  {
                     if((tokens = r.split(":")).length == 2)
                     {
                        if(userInfoMng != null)
                        {
                           if((extId = String(tokens[0])) != null)
                           {
                              d[extId] = Number(tokens[1]);
                           }
                        }
                     }
                  }
               }
            }
         }
      }
      
      private function remindersAddAllianceIdToJoin(allianceId:String) : void
      {
         if(this.mRemindersJoins == null)
         {
            this.mRemindersJoins = new Dictionary();
         }
         this.mRemindersJoins[allianceId] = InstanceMng.getUserDataMng().getServerCurrentTimemillis();
      }
      
      private function profileSetData(data:Object) : void
      {
         if(data != null)
         {
            this.remindersSetInvitations(data.invitesSent);
            this.remindersSetJoins(data.joinsSent);
         }
      }
      
      public function createDeclareWarEvent(allianceId:String, allianceName:String) : void
      {
         var o:Object = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NOTIFY_ALLIANCES_DECLARE_WAR");
         o.allianceId = allianceId;
         o.allianceName = allianceName;
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o);
      }
   }
}
