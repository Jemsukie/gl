package com.dchoc.game.controller.alliances
{
   import com.dchoc.game.controller.notifications.Notification;
   import com.dchoc.game.controller.notifications.NotificationsMng;
   import com.dchoc.game.core.flow.Application;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.popups.alliances.EPopupAlliances;
   import com.dchoc.game.model.alliances.Alliance;
   import com.dchoc.game.model.alliances.AlliancesAPIEvent;
   import com.dchoc.game.model.alliances.AlliancesAPIWarEvent;
   import com.dchoc.game.model.alliances.AlliancesConstants;
   import com.dchoc.game.model.alliances.AlliancesNewResultWar;
   import com.dchoc.game.model.alliances.AlliancesSessionUser;
   import com.dchoc.game.model.alliances.AlliancesUser;
   import com.dchoc.game.model.alliances.AlliancesWarHistory;
   import com.dchoc.game.model.alliances.AlliancesWarHistoryEntry;
   import com.dchoc.game.model.rule.AlliancesSettingsDefMng;
   import com.dchoc.game.model.rule.AlliancesWarTypesDef;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.userdata.UserDataMng;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.events.KeyboardEvent;
   
   public class AlliancesControllerStar extends AlliancesController
   {
      
      private static const MIN_TIME_TO_SHOW_TO_THE_USER:Number = DCTimerUtil.hourToMs(1);
      
      public static const NOTIFICATION_INCORRECT_ALLIANCE_NAME:String = "NotificationIncorrectAllianceName";
      
      public static const NOTIFICATION_JOIN_REQUIREMENT_FAILED:String = "NotificationJoinRequirementFailed";
       
      
      private var mInitNeedsToOpenPopup:Boolean;
      
      private var mInitIsInitialized:Boolean = false;
      
      private var mInitLastTimeItWasInitialized:Number = 0;
      
      private var mInitTimeToAutomaticInit:Number = 0;
      
      private var mInitWorldVisitorDone:Boolean;
      
      private var mPopupAlliance:DCIPopup;
      
      private const ALLIANCES_WELCOME_FIRST_TIME:int = -1;
      
      private var mAlliancesPopupOpenInfo:Boolean = false;
      
      private var mWarsCompleteHistory:AlliancesWarHistory;
      
      private var mReadyForRequestNews:Boolean = false;
      
      private var mRequestNews:Object;
      
      private const BASE:String = "base";
      
      private const PATTERN:String = "pattern";
      
      private const MASK:String = "mask";
      
      private const EMBLEM:String = "emblem";
      
      private var mPatternPetition:Array;
      
      private var mAllianceToDeclareWarId:String;
      
      public function AlliancesControllerStar()
      {
         super();
      }
      
      override public function initialize(mode:int, lockUI:Boolean = false) : void
      {
         var user:AlliancesUser = null;
         if(mInitMode != mode)
         {
            this.mInitLastTimeItWasInitialized = -1;
         }
         var userDataMng:UserDataMng = InstanceMng.getUserDataMng();
         var canInit:Boolean;
         if(canInit = userDataMng.isLogged() && userDataMng.isLoaded() && InstanceMng.getGUIController().isBuilt() && this.mInitLastTimeItWasInitialized <= 0)
         {
            super.initialize(mode,lockUI);
            if(lockUI)
            {
               InstanceMng.getApplication().lockUIWaitForAlliancesRequest();
               timerStart();
            }
            cacheReset();
            (user = getMyUser()).setId(userDataMng.mUserAccountId);
            this.mInitLastTimeItWasInitialized = InstanceMng.getAlliancesSettingsDefMng().getRefreshInfoTime();
            this.initSetIsInitialized(false,false);
            this.requestMyAlliance(this.onRequestMyAlliance,this.onRequestMyAllianceFailed);
            initSetModeToInit(-1);
         }
      }
      
      override public function isInitialized() : Boolean
      {
         return this.mInitIsInitialized;
      }
      
      private function initSetIsInitialized(value:Boolean, resetIsInitializing:Boolean = true) : void
      {
         var application:Application = null;
         if(resetIsInitializing)
         {
            mInitIsInitializing = false;
         }
         this.mInitIsInitialized = value;
         if(this.mInitIsInitialized)
         {
            DCDebug.traceCh("ALLIANCES","INITIALIZE");
            application = InstanceMng.getApplication();
            if(application.lockUIGetReason() == 7)
            {
               application.lockUIReset();
            }
            DCDebug.traceCh("ALLIANCES","TIME PASSED : " + timerGetTimePassed());
            timerEnd();
            if(this.isPopupAlliancesBeingShown())
            {
               DCDebug.traceCh("ALLIANCES","INITIALIZE REFRESH ALLIANCES POPUP");
               EPopupAlliances(this.getPopupAlliance()).reloadPopup();
            }
         }
      }
      
      override public function resetInitializeTimer() : void
      {
         this.mInitLastTimeItWasInitialized = 0;
      }
      
      override public function isEnabled() : Boolean
      {
         return canBeEnabled() && this.mInitIsInitialized && mIsEnabled;
      }
      
      override public function openPopup() : void
      {
         this.initialize(0,true);
         this.mInitNeedsToOpenPopup = true;
      }
      
      override protected function unloadDo() : void
      {
         super.unloadDo();
         if(this.mWarsCompleteHistory != null)
         {
            this.mWarsCompleteHistory.destroy();
            this.mWarsCompleteHistory = null;
         }
         this.mRequestNews = null;
         this.mReadyForRequestNews = false;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         buildAdvanceSyncStep();
      }
      
      override protected function beginDo() : void
      {
         super.beginDo();
         this.mInitWorldVisitorDone = InstanceMng.getFlowStatePlanet().isTutorialRunning() || !logoIsWorldVisitor();
         if(this.mInitWorldVisitorDone)
         {
            logoUpdateView(null,1);
         }
         DCDebug.traceCh("ALLIANCES","BEGINDO: " + this.mInitWorldVisitorDone + " tutorialRunning = " + InstanceMng.getFlowStatePlanet().isTutorialRunning() + " logoIsWorldVisitor = " + logoIsWorldVisitor() + " mode = " + InstanceMng.getApplication().viewGetMode() + " roleId = " + InstanceMng.getRole().mId + " roleRequestId = " + InstanceMng.getApplication().goToGetRequestRoleId());
      }
      
      override public function setEnabled(v:Boolean) : void
      {
         super.setEnabled(v);
         if(v)
         {
            this.updateMyAlliance();
         }
         else
         {
            this.mInitLastTimeItWasInitialized = 0;
            this.mInitTimeToAutomaticInit = AlliancesConstants.TIME_BETWEEN_AUTOMATIC_INITIALIZES_MS;
         }
      }
      
      private function updateMyAlliance() : void
      {
         var profile:Profile = null;
         var myUser:AlliancesUser = null;
         var myScore:Number = NaN;
         var myAlliance:Alliance;
         if((myAlliance = getMyAlliance()) != null)
         {
            profile = InstanceMng.getUserInfoMng().getProfileLogin();
            if(profile != null && profile.isBuilt())
            {
               myUser = getMyUser();
               if(myUser != null)
               {
                  myScore = profile.getScore();
                  myUser.setGameScore(myScore);
                  myUser = myAlliance.getMember(myUser.getId());
                  if(myUser != null)
                  {
                     myUser.setGameScore(myScore);
                  }
               }
            }
         }
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var id:String = null;
         var myAlliance:Alliance = null;
         var time:Number = NaN;
         super.logicUpdateDo(dt);
         if(logoIsWorldVisitor() && !this.mInitWorldVisitorDone)
         {
            id = InstanceMng.getApplication().goToGetRequestUserId();
            if(id != null && !InstanceMng.getUserInfoMng().isThisSkuFromNPC(id))
            {
               DCDebug.traceCh("ALLIANCES","REQUEST VISIT ALLIANCE " + id);
               this.requestAllianceByUserId(id,true,this.onRequestVisitorAlliance,this.onRequestVisitorAlliance);
            }
            this.mInitWorldVisitorDone = true;
         }
         if(canBeEnabled())
         {
            if(mInitModeToInit != -1 && !mInitIsInitializing)
            {
               this.initialize(mInitModeToInit);
            }
            if(this.mInitLastTimeItWasInitialized > 0)
            {
               this.mInitLastTimeItWasInitialized -= dt;
            }
            if(this.mInitIsInitialized)
            {
               if(!this.isEnabled())
               {
                  this.mInitTimeToAutomaticInit -= dt;
                  if(this.mInitTimeToAutomaticInit <= 0)
                  {
                     this.initialize(mInitMode,false);
                  }
               }
               if(this.mInitNeedsToOpenPopup)
               {
                  this.openPopupDependingOnSituation();
                  this.mInitNeedsToOpenPopup = false;
               }
            }
         }
         if(this.mInitIsInitialized)
         {
            myAlliance = cacheGetMyAlliance();
            if(myAlliance != null)
            {
               if(myAlliance.isInAWar())
               {
                  if((time = (time = myAlliance.getCurrentWarTimeLeft()) - dt) <= 0)
                  {
                     time = 0;
                     this.endWar();
                  }
                  else
                  {
                     myAlliance.setCurrentWarTimeLeft(time);
                  }
               }
            }
            this.checkPatternPetitions();
         }
      }
      
      private function endWar() : void
      {
         var myAlliance:Alliance = cacheGetMyAlliance();
         if(myAlliance != null)
         {
            myAlliance.endWar();
            DCDebug.traceCh("ALLIANCES"," CACHE_ENEMY 2");
            cacheSetEnemyAlliance(null);
            this.requestWarsHistory(0,1,this.onRequestWarHistory,this.onRequestWarHistoryFailed);
         }
         InstanceMng.getUIFacade().alliancesNotifyWasHasEnded();
      }
      
      private function onRequestMyAlliance(event:AlliancesAPIEvent) : void
      {
         var myUser:AlliancesUser = null;
         var alliance:Alliance = event.alliance;
         if(alliance != null)
         {
            myUser = getMyUser();
            if(alliance.getMember(myUser.getId()) == null)
            {
               this.initSetIsInitialized(true);
               this.setEnabled(false);
               DCDebug.traceCh("ALLIANCES","Error: Alliances disabled because the response for getMyAlliance() returns an alliance that doesn\'t contain this user as a member. myUser.id = " + myUser.getId());
            }
            else if(alliance.isInAWar())
            {
               DCDebug.traceCh("ALLIANCES","ASK FOR ENEMY ALLIANCE");
               this.requestAllianceById(alliance.getCurrentWarEnemyAllianceId(),true,this.onRequestEnemyAlliance,this.onRequestEnemyAllianceFailed);
            }
            else
            {
               this.requestWarsHistory(0,1,this.onRequestWarHistory,this.onRequestWarHistoryFailed);
            }
         }
         else
         {
            this.initSetIsInitialized(true);
            this.setEnabled(true);
         }
      }
      
      private function onRequestMyAllianceFailed(event:AlliancesAPIEvent) : void
      {
         this.initSetIsInitialized(true);
         var errorCode:int = event.getErrorCode();
         if(errorCode == 11 || errorCode == 12)
         {
            this.setEnabled(false);
         }
      }
      
      private function onRequestEnemyAlliance(event:AlliancesAPIEvent) : void
      {
         DCDebug.traceCh("ALLIANCES"," CACHE_ENEMY 1");
         cacheSetEnemyAlliance(event.alliance);
         this.initSetIsInitialized(true);
         this.setEnabled(true);
      }
      
      private function onRequestEnemyAllianceFailed(event:AlliancesAPIEvent) : void
      {
         if(event != null && event.getErrorCode() == 8)
         {
            this.endWar();
         }
         else
         {
            this.initSetIsInitialized(true);
            this.setEnabled(false);
         }
      }
      
      private function onRequestVisitorAlliance(e:AlliancesAPIEvent) : void
      {
         var str:* = null;
         var alliance:Alliance = null;
         if(e.type == "alliance_api_success")
         {
            str = "LOGO WORLD: ";
            alliance = e.alliance;
            if(alliance != null)
            {
               logoUpdateView(alliance.getLogo(),1);
               str += alliance.getName();
            }
            else
            {
               str += " empty";
            }
            DCDebug.traceCh("ALLIANCES",str);
            cacheSetWorldAlliance(alliance);
         }
         else
         {
            DCDebug.traceCh("ALLIANCES","REQUEST VISIT ALLIANCE error");
            cacheSetWorldAlliance(null);
            logoUpdateView(null,1);
         }
      }
      
      private function onRequestWarHistory(event:AlliancesAPIWarEvent) : void
      {
         var allianceSettingsDefMng:AlliancesSettingsDefMng = null;
         var shieldTime:Number = NaN;
         var shieldTimeTimeStamp:Number = NaN;
         var shieldTimeOverTimeStamp:Number = NaN;
         var alliancesWarHistory:AlliancesWarHistory = null;
         var entry:AlliancesWarHistoryEntry = null;
         if(!this.mInitIsInitialized)
         {
            this.initSetIsInitialized(true);
            this.setEnabled(true);
         }
         else
         {
            shieldTime = (allianceSettingsDefMng = InstanceMng.getAlliancesSettingsDefMng()).getAllianceLooserPostWarShield();
            if(event != null)
            {
               alliancesWarHistory = event.getWarHistory();
               if(alliancesWarHistory != null)
               {
                  entry = alliancesWarHistory.getEntry(0);
                  if(entry != null && entry.hasMyAllianceWon())
                  {
                     shieldTime = allianceSettingsDefMng.getAllianceWinnerPostWarShield();
                  }
               }
            }
            shieldTimeTimeStamp = DCTimerUtil.hourToMs(shieldTime);
            shieldTimeOverTimeStamp = InstanceMng.getApplication().getCurrentServerTimeMillis() + shieldTimeTimeStamp;
            getMyAlliance().setPostWarShield(shieldTimeOverTimeStamp);
            if(this.isPopupAlliancesBeingShown())
            {
               EPopupAlliances(this.getPopupAlliance()).setTabPage(1);
            }
         }
      }
      
      private function onRequestWarHistoryFailed(event:AlliancesAPIEvent) : void
      {
         if(!this.mInitIsInitialized)
         {
            this.initSetIsInitialized(true);
         }
      }
      
      override public function openPopupDependingOnSituation() : void
      {
         var welcomeText:String = null;
         var o:Object = null;
         var user:AlliancesUser = null;
         var profile:Profile = null;
         var alliance:Alliance = null;
         var allianceId:String = null;
         var alliancesSettingsWelcomeFlagId:int = getSettingsAlliancesWelcomeId();
         var profileAllianceWelcomeFlagId:int = getProfileWelcomeId();
         var showDefaultPopup:Boolean = true;
         var minimumPlayerLevel:int = getSettingsAlliancesMinimumPlayerLevel();
         var playerLevel:int = InstanceMng.getUserInfoMng().getProfileLogin().getLevel();
         var minimumHQLevel:int = InstanceMng.getAlliancesSettingsDefMng().getMinimumHQLevel();
         var HQLevel:int = InstanceMng.getUserInfoMng().getProfileLogin().getMaxHqLevelInAllPlanets();
         if(!this.isEnabled())
         {
            this.openErrorFromAllianceService();
            showDefaultPopup = false;
            return;
         }
         if(HQLevel < minimumHQLevel && getMyAlliance() == null)
         {
            welcomeText = DCTextMng.replaceParameters(4062,[minimumHQLevel]);
            (o = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NOTIFY_ALLIANCES_NOT_ENOUGH_LEVEL_POPUP"))["body"] = welcomeText;
            this.guiOpenAllianceNotification(o);
            showDefaultPopup = false;
         }
         else if(profileAllianceWelcomeFlagId < alliancesSettingsWelcomeFlagId)
         {
            this.mAlliancesPopupOpenInfo = true;
            switch(profileAllianceWelcomeFlagId - -1)
            {
               case 0:
                  welcomeText = DCTextMng.getText(2954);
            }
            (o = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NOTIFY_ALLIANCES_WELCOME_POPUP"))["body"] = welcomeText;
            this.guiOpenAllianceNotification(o);
            updateProfileWelcomeId(alliancesSettingsWelcomeFlagId);
            showDefaultPopup = false;
         }
         else if(needsToShowKickedFromAlliancePopup())
         {
            if((user = getMyUser()) != null)
            {
               user.leaveAlliance();
            }
            logoUpdateView(null,0);
            this.openKickedFromAlliancePopup();
            updateProfileWithNewMyAlliance();
            showDefaultPopup = false;
         }
         else
         {
            profile = InstanceMng.getUserInfoMng().getProfileLogin();
            alliance = cacheGetMyAlliance();
            allianceId = alliance == null ? "" : alliance.getId();
            if(profile.flagsGetMyAllianceId() != allianceId)
            {
               profile.flagsSetMyAllianceId(allianceId);
            }
            if(needsToShowDeclareWarPopup())
            {
               o = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NOTIFY_ALLIANCES_DECLARE_WAR");
               if(getMyAlliance() != null)
               {
                  o.alliance = getMyAlliance();
                  InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o);
                  saveCurrentWarInProfile();
                  InstanceMng.getUIFacade().alliancesNotifyWarHasBegun();
                  showDefaultPopup = false;
               }
            }
            else if(needsToShowWarIsOverPopup())
            {
               this.showPopupOnWarOver();
               showDefaultPopup = false;
            }
         }
         if(showDefaultPopup)
         {
            this.updateMyAlliance();
            this.guiOpenAlliancesPopup();
            if(this.mAlliancesPopupOpenInfo)
            {
               this.guiOpenAlliancesHelpPopup();
               this.mAlliancesPopupOpenInfo = false;
            }
         }
      }
      
      public function showPopupOnWarOver() : void
      {
         var battleWon:Boolean = false;
         var isKO:Boolean = false;
         var o:Object = null;
         var alliancesWarEntry:AlliancesWarHistoryEntry = getMyLastWarEntry();
         if(alliancesWarEntry != null)
         {
            battleWon = alliancesWarEntry.hasMyAllianceWon();
            isKO = alliancesWarEntry.isOnKnockout();
            if(battleWon)
            {
               this.openWarIsWonPopup(isKO,alliancesWarEntry.getEnemyAllianceName());
            }
            else
            {
               this.openWarIsLostPopup(isKO);
            }
            resetCurrentWarInProfile();
         }
      }
      
      private function doRequest(lockUI:Boolean) : void
      {
         if(lockUI)
         {
            InstanceMng.getApplication().lockUIWaitForAlliancesRequest();
         }
      }
      
      override public function isMeInAnyAlliance() : Boolean
      {
         var returnValue:Boolean = false;
         var me:AlliancesSessionUser = AlliancesSessionUser.getInstance();
         if(me != null)
         {
            returnValue = me.isInAnyAlliance();
         }
         return returnValue;
      }
      
      override public function createAlliance(name:String, description:String, logo:Array, isPublic:Boolean, successCallback:Function = null, failedCallback:Function = null, transaction:Transaction = null, lockUI:Boolean = false) : void
      {
         var userDataMng:UserDataMng = InstanceMng.getUserDataMng();
         var clientCmd:String = "createAlliance";
         notificationsStoreNotification(clientCmd,successCallback,failedCallback,lockUI);
         var data:Object;
         if((data = AlliancesConstants.objCreateCreateAlliance(clientCmd,userDataMng.mUserAccountId,name,description,AlliancesConstants.getLogoArrayAsString(logo),isPublic))["paramsOk"])
         {
            userDataMng.createAlliance(data,transaction);
            this.doRequest(lockUI);
         }
         else
         {
            notificationsNotify(clientCmd,false,{
               "result":false,
               "error":11
            },data);
         }
      }
      
      override public function editMyAlliance(logo:Array, description:String, isPublic:Boolean, successCallback:Function = null, failedCallback:Function = null, transaction:Transaction = null, lockUI:Boolean = false) : void
      {
         var userDataMng:UserDataMng = InstanceMng.getUserDataMng();
         var clientCmd:String = "editAlliance";
         notificationsStoreNotification(clientCmd,successCallback,failedCallback,lockUI);
         var data:Object = AlliancesConstants.objCreateEditAlliance(clientCmd,userDataMng.mUserAccountId,description,AlliancesConstants.getLogoArrayAsString(logo),isPublic);
         var currentAlliance:Alliance;
         if((currentAlliance = cacheGetMyAlliance()) != null && data["paramsOk"])
         {
            userDataMng.editAlliance(data,transaction);
            this.doRequest(lockUI);
         }
         else
         {
            notificationsNotify(clientCmd,false,{
               "result":false,
               "error":11
            },data);
         }
      }
      
      override public function requestMyAlliance(successCallback:Function = null, failedCallback:Function = null, lockUI:Boolean = false) : void
      {
         var userDataMng:UserDataMng = InstanceMng.getUserDataMng();
         var clientCmd:String = "requestMyAlliance";
         notificationsStoreNotification(clientCmd,successCallback,failedCallback,lockUI);
         var data:Object = AlliancesConstants.objCreateGetMyAlliance(clientCmd,userDataMng.mUserAccountId);
         var user:AlliancesUser;
         if((user = getMyUser()) != null && data["paramsOk"])
         {
            userDataMng.requestMyAlliance(data);
            this.doRequest(lockUI);
         }
         else
         {
            notificationsNotify(clientCmd,false,{
               "result":false,
               "error":11
            },data);
         }
      }
      
      override public function requestAllianceByUserId(userId:String, includeMembers:Boolean, successCallback:Function = null, failedCallback:Function = null, lockUI:Boolean = false) : void
      {
         var clientCmd:String = "requestAllianceByUserId";
         notificationsStoreNotification(clientCmd,successCallback,failedCallback,lockUI);
         var data:Object;
         if((data = AlliancesConstants.objCreateGetAllianceByUserId(clientCmd,userId,includeMembers))["paramsOk"])
         {
            InstanceMng.getUserDataMng().requestAllianceByUserId(data);
            this.doRequest(lockUI);
         }
         else
         {
            notificationsNotify(clientCmd,false,{
               "result":false,
               "error":11
            },data);
         }
      }
      
      override public function requestAllianceById(allianceId:String, includeMembers:Boolean, successCallback:Function = null, failedCallback:Function = null, lockUI:Boolean = false) : void
      {
         var clientCmd:String = "requestAllianceById";
         notificationsStoreNotification(clientCmd,successCallback,failedCallback,lockUI);
         var data:Object;
         if((data = AlliancesConstants.objCreateGetAllianceById(clientCmd,allianceId,includeMembers))["paramsOk"])
         {
            InstanceMng.getUserDataMng().requestAllianceById(data);
            this.doRequest(lockUI);
         }
         else
         {
            notificationsNotify(clientCmd,false,{
               "result":false,
               "error":11
            },data);
         }
      }
      
      override public function requestAlliances(successCallback:Function = null, failedCallback:Function = null, lockUI:Boolean = false, start_index:uint = 0, count:uint = 100, search_string:String = null, centerInUserPage:Boolean = false) : void
      {
         var clientCmd:String = "requestAlliancesList";
         notificationsStoreNotification(clientCmd,successCallback,failedCallback,lockUI);
         var data:Object;
         if((data = AlliancesConstants.objCreateGetAlliances(clientCmd,start_index,count,search_string,centerInUserPage))["paramsOk"])
         {
            InstanceMng.getUserDataMng().requestAlliances(data);
            this.doRequest(lockUI);
         }
         else
         {
            notificationsNotify(clientCmd,false,{
               "result":false,
               "error":11
            },data);
         }
      }
      
      override public function joinRequirementFailedNotification(levelRequired:int) : void
      {
         var notif:Notification = new Notification("NotificationJoinRequirementFailed",DCTextMng.getText(77),DCTextMng.replaceParameters(4097,[levelRequired]),"alliance_council_angry");
         InstanceMng.getNotificationsMng().guiOpenNotificationMessage(notif);
      }
      
      override public function joinAlliance(allianceId:String, successCallback:Function = null, failedCallback:Function = null, lockUI:Boolean = false) : void
      {
         var userDataMng:UserDataMng = null;
         var data:Object = null;
         var diff:Number = NaN;
         var timeToWait:Number = NaN;
         var pErrorMsg:String = null;
         var clientCmd:String = "joinAlliance";
         notificationsStoreNotification(clientCmd,successCallback,failedCallback,lockUI);
         if(isRequestForJoinAllianceAllowed(allianceId))
         {
            userDataMng = InstanceMng.getUserDataMng();
            if((data = AlliancesConstants.objCreateJoin(clientCmd,userDataMng.mUserAccountId,allianceId))["paramsOk"])
            {
               userDataMng.joinAlliance(data);
               this.doRequest(lockUI);
            }
            else
            {
               notificationsNotify(clientCmd,false,{
                  "result":false,
                  "error":11
               },data);
            }
         }
         else
         {
            diff = InstanceMng.getUserDataMng().getServerCurrentTimemillis() - mRemindersJoins[allianceId];
            if((timeToWait = InstanceMng.getAlliancesSettingsDefMng().getRemindJoinTime() - diff) < MIN_TIME_TO_SHOW_TO_THE_USER)
            {
               timeToWait = MIN_TIME_TO_SHOW_TO_THE_USER;
            }
            pErrorMsg = DCTextMng.replaceParameters(2990,[DCTextMng.convertTimeToString(timeToWait,true)]);
            notificationsNotify("joinAlliance",false,{
               "error":99,
               "errorMsg":pErrorMsg
            });
         }
      }
      
      override public function leaveMyAlliance(successCallback:Function = null, failedCallback:Function = null, lockUI:Boolean = false) : void
      {
         var alliance:Alliance = null;
         var userDataMng:UserDataMng = InstanceMng.getUserDataMng();
         var clientCmd:String = "leaveAlliance";
         notificationsStoreNotification(clientCmd,successCallback,failedCallback,lockUI);
         var data:Object = AlliancesConstants.objCreateLeave(clientCmd,userDataMng.mUserAccountId);
         var user:AlliancesUser;
         if((user = getMyUser()) != null && data["paramsOk"])
         {
            if((alliance = cacheGetMyAlliance()) != null && alliance.isInAWar())
            {
               notificationsNotify(clientCmd,false,{
                  "result":false,
                  "error":16
               },data);
            }
            userDataMng.leaveAlliance(data);
            this.doRequest(lockUI);
         }
         else
         {
            notificationsNotify(clientCmd,false,{
               "result":false,
               "error":11
            },data);
         }
      }
      
      override public function promote(user:AlliancesUser, successCallback:Function = null, failedCallback:Function = null, lockUI:Boolean = false) : void
      {
         var memberId:String = null;
         var newRole:String = null;
         var userDataMng:UserDataMng = InstanceMng.getUserDataMng();
         var clientCmd:String = "changeUserRole";
         notificationsStoreNotification(clientCmd,successCallback,failedCallback,lockUI);
         if(user != null)
         {
            memberId = user.getId();
         }
         if(user != null && user.getRole() == "ADMIN")
         {
            newRole = "LEADER";
         }
         else
         {
            newRole = "ADMIN";
         }
         var data:Object;
         if((data = AlliancesConstants.objCreatePromoteTo(clientCmd,userDataMng.mUserAccountId,memberId,newRole))["paramsOk"])
         {
            userDataMng.promote(data);
            this.doRequest(lockUI);
         }
         else
         {
            notificationsNotify(clientCmd,false,{
               "result":false,
               "error":11
            },data);
         }
      }
      
      override public function demote(user:AlliancesUser, successCallback:Function = null, failedCallback:Function = null, lockUI:Boolean = false) : void
      {
         var memberId:String = null;
         var newRole:String = null;
         var userDataMng:UserDataMng = InstanceMng.getUserDataMng();
         var clientCmd:String = "changeUserRole";
         notificationsStoreNotification(clientCmd,successCallback,failedCallback,lockUI);
         if(user != null)
         {
            memberId = user.getId();
         }
         if(user != null && user.getRole() == "LEADER")
         {
            newRole = "ADMIN";
         }
         else
         {
            newRole = "REGULAR";
         }
         var data:Object;
         if((data = AlliancesConstants.objCreateDemoteTo(clientCmd,userDataMng.mUserAccountId,memberId,newRole))["paramsOk"])
         {
            InstanceMng.getUserDataMng().demote(data);
            this.doRequest(lockUI);
         }
         else
         {
            notificationsNotify(clientCmd,false,{
               "result":false,
               "error":11
            },data);
         }
      }
      
      override public function kickUser(user:AlliancesUser, successCallback:Function = null, failedCallback:Function = null, lockUI:Boolean = false) : void
      {
         var memberId:String = null;
         var userDataMng:UserDataMng = InstanceMng.getUserDataMng();
         var clientCmd:String = "kickUser";
         notificationsStoreNotification(clientCmd,successCallback,failedCallback,lockUI);
         if(user != null)
         {
            memberId = user.getId();
         }
         var data:Object;
         if((data = AlliancesConstants.objCreateKick(clientCmd,userDataMng.mUserAccountId,memberId))["paramsOk"])
         {
            userDataMng.kickUser(data);
            this.doRequest(lockUI);
         }
         else
         {
            notificationsNotify(clientCmd,false,{
               "result":false,
               "error":11
            },data);
         }
      }
      
      override public function inviteFriends(lockUI:Boolean) : void
      {
         var data:Object = AlliancesConstants.objCreateInviteFriends("friendsToInvite");
         InstanceMng.getUserDataMng().allianceInviteFriends(data);
      }
      
      override protected function setWarCompleteHistory(data:Object) : void
      {
         if(this.mWarsCompleteHistory == null)
         {
            this.mWarsCompleteHistory = new AlliancesWarHistory();
         }
         this.mWarsCompleteHistory.fromJSON(data);
      }
      
      override protected function getWarCompleteHistory() : AlliancesWarHistory
      {
         return this.mWarsCompleteHistory;
      }
      
      override public function requestWarsHistory(startIndex:uint = 0, count:int = 9, successCallback:Function = null, failedCallback:Function = null, lockUI:Boolean = false) : void
      {
         var clientCmd:String = "requestWarHistory";
         notificationsStoreNotification(clientCmd,successCallback,failedCallback,lockUI);
         var user:AlliancesUser = getMyUser();
         var allianceId:String = null;
         if(user != null)
         {
            allianceId = user.getAllianceId();
         }
         var data:Object;
         if((data = AlliancesConstants.objCreateGetWarsHistory(clientCmd,allianceId,startIndex,count))["paramsOk"])
         {
            InstanceMng.getUserDataMng().requestWarsHistory(data);
            this.doRequest(lockUI);
         }
         else
         {
            notificationsNotify(clientCmd,false,{
               "result":false,
               "error":11
            },data);
         }
      }
      
      override public function declareWar(allianceAgainstId:String, successCallback:Function = null, failedCallback:Function = null, lockUI:Boolean = false) : void
      {
         var userDataMng:UserDataMng = InstanceMng.getUserDataMng();
         var clientCmd:String = "declareWar";
         notificationsStoreNotification(clientCmd,successCallback,failedCallback,lockUI);
         var data:Object = AlliancesConstants.objCreateDeclareWar(clientCmd,userDataMng.mUserAccountId,allianceAgainstId);
         var user:AlliancesUser;
         if((user = getMyUser()) != null && data["paramsOk"])
         {
            userDataMng.declareWar(data);
            this.doRequest(lockUI);
         }
         else
         {
            notificationsNotify(clientCmd,false,{
               "result":false,
               "error":11
            },data);
         }
      }
      
      override public function requestNews(successCallback:Function, failedCallback:Function, types:Array, start_index:uint = 0, count:uint = 9, lockUI:Boolean = false) : void
      {
         var clientCmd:String = "requestNews";
         var data:Object;
         if((data = AlliancesConstants.objCreateGetNews(clientCmd,types,InstanceMng.getUserDataMng().mUserAccountId,start_index,count,successCallback,failedCallback,lockUI))["paramsOk"])
         {
            if(this.newsIsReadyForRequest())
            {
               this.actualRequestNews(data,successCallback,failedCallback,lockUI);
            }
            else
            {
               this.mRequestNews = data;
               requestWarsCompleteHistory(this.newsOnWarsCompleteHistoryReady,this.newsOnWarsCompleteHistoryReady,false);
               this.doRequest(true);
            }
         }
         else
         {
            notificationsNotify(clientCmd,false,{
               "result":false,
               "error":11
            },data);
         }
      }
      
      private function actualRequestNews(data:Object, successCallback:Function, failedCallback:Function, lockUI:Boolean) : void
      {
         var clientCmd:String = "requestNews";
         notificationsStoreNotification(clientCmd,successCallback,failedCallback,lockUI);
         InstanceMng.getUserDataMng().requestNews(data);
         this.doRequest(lockUI);
      }
      
      private function newsIsReadyForRequest() : Boolean
      {
         return this.mReadyForRequestNews;
      }
      
      private function newsOnWarsCompleteHistoryReady(e:AlliancesAPIEvent) : void
      {
         this.mReadyForRequestNews = true;
         if(this.mRequestNews != null)
         {
            this.actualRequestNews(this.mRequestNews,this.mRequestNews["onSuccess"],this.mRequestNews["onFail"],this.mRequestNews["lockUI"]);
            this.mRequestNews = null;
         }
      }
      
      override protected function updateNewsInformation(allianceNew:AlliancesNewResultWar) : void
      {
         if(this.mWarsCompleteHistory != null)
         {
            this.mWarsCompleteHistory.updateNewsInformation(allianceNew);
         }
      }
      
      private function onRequestMyAllianceSuccess(e:AlliancesAPIEvent) : void
      {
         var alliance:Alliance = null;
         if(e != null)
         {
            alliance = e.alliance;
            if(alliance != null)
            {
               DCDebug.traceCh("ALLIANCES","Alliance name : " + alliance.getName());
            }
         }
      }
      
      private function onRequestAlliancesSuccess(event:AlliancesAPIEvent) : void
      {
         var a:Alliance = null;
         var tmp:Object = null;
         for each(a in event.alliance_array)
         {
            DCDebug.traceCh("ALLIANCES",a.getName() + " id = " + a.getId());
            tmp = a.toRow();
         }
      }
      
      private function onRequestAlliancesFailed(event:AlliancesAPIEvent) : void
      {
         DCDebug.traceCh("ALLIANCES"," request alliances has failed");
      }
      
      private function onPromoteToAdmin(event:AlliancesAPIEvent) : void
      {
         var alliance:Alliance = null;
         var members:Array = null;
         var user:AlliancesUser = null;
         if(event != null)
         {
            alliance = event.alliance;
            if(alliance != null)
            {
               members = alliance.getMembers();
               if(members != null && members.length > 1)
               {
                  if((user = members[1]) != null)
                  {
                     this.promote(user,null,null);
                  }
               }
            }
         }
      }
      
      override public function onKeyUp(e:KeyboardEvent) : void
      {
      }
      
      override public function onKeyDown(e:KeyboardEvent) : void
      {
         var isInAnyAlliance:Boolean = false;
         var entry:AlliancesWarHistoryEntry = null;
         switch(int(e.keyCode) - 112)
         {
            case 0:
               isInAnyAlliance = this.isMeInAnyAlliance();
               DCDebug.traceCh("ALLIANCES"," isMeInAnyAlliance = " + isInAnyAlliance);
               this.requestMyAlliance(this.onRequestMyAllianceSuccess,null);
               break;
            case 1:
               this.requestAlliances(this.onRequestAlliancesSuccess,this.onRequestAlliancesFailed,true,2,7,"knight");
               break;
            case 2:
               entry = getMyLastWarEntry();
               if(entry != null)
               {
               }
               break;
            case 4:
               this.requestMyAlliance(this.onPromoteToAdmin);
               break;
            case 5:
               this.declareWar("2",null,null);
               break;
            case 6:
               break;
            case 8:
               this.createAlliance("calleAlaba","1",[0,0,1],true,null,null);
               this.initialize(0);
         }
      }
      
      public function guiOpenAlliancesHelpPopup() : void
      {
         var popup:DCIPopup = null;
         popup = InstanceMng.getUIFacade().getPopupFactory().getHelpAlliancesPopup();
         InstanceMng.getUIFacade().enqueuePopup(popup);
      }
      
      public function guiOpenAllianceJoinRequestsPopup() : void
      {
         var popup:DCIPopup = null;
         popup = InstanceMng.getUIFacade().getPopupFactory().getAllianceJoinRequestsPopup();
         InstanceMng.getUIFacade().enqueuePopup(popup);
      }
      
      public function guiOpenCreateAlliancePopup() : void
      {
         var popup:DCIPopup = null;
         popup = InstanceMng.getUIFacade().getPopupFactory().getCreateAlliancePopup();
         InstanceMng.getUIFacade().enqueuePopup(popup);
      }
      
      public function guiOpenEditAlliancePopup() : void
      {
         var popup:DCIPopup = null;
         popup = InstanceMng.getUIFacade().getPopupFactory().getEditAlliancePopup();
         InstanceMng.getUIFacade().enqueuePopup(popup);
      }
      
      public function guiOpenAlliancesPopup() : void
      {
         var popup:DCIPopup = null;
         popup = InstanceMng.getUIFacade().getPopupFactory().getAlliancePopup();
         this.mPopupAlliance = popup;
         popup.setIsStackable(false);
         InstanceMng.getUIFacade().enqueuePopup(popup);
      }
      
      public function guiOpenPopupAllianceMembers(alliance:Alliance, stripe:ESprite) : void
      {
         var popup:DCIPopup = InstanceMng.getUIFacade().getPopupFactory().getAllianceMembersPopup(alliance,stripe);
         InstanceMng.getUIFacade().enqueuePopup(popup);
      }
      
      public function getPopupAlliance() : DCIPopup
      {
         return this.mPopupAlliance;
      }
      
      public function getAllianceFlag(base:int, pattern:int, emblem:int, area:ELayoutArea = null) : ESpriteContainer
      {
         var img:EImage = null;
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         var container:ESpriteContainer = new ESpriteContainer();
         var patternCont:ESpriteContainer = this.getAlliancePattern(base,pattern);
         container.eAddChild(patternCont);
         container.setContent("pattern",patternCont);
         img = viewFactory.getEImage("flag_base_" + base,null,false);
         container.eAddChild(img);
         container.setContent("base",img);
         img = viewFactory.getEImage("flag_emblem_" + emblem,null,false);
         container.eAddChild(img);
         container.setContent("emblem",img);
         if(area != null)
         {
            container.setLayoutArea(area,true);
         }
         container.mouseChildren = false;
         return container;
      }
      
      public function getAlliancePattern(mask:int, pattern:int, area:ELayoutArea = null) : ESpriteContainer
      {
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         var container:ESpriteContainer = new ESpriteContainer();
         if(this.mPatternPetition == null)
         {
            this.mPatternPetition = [];
         }
         var img:EImage = viewFactory.getEImage("flag_mask_" + mask,null,false);
         container.setContent("mask",img);
         img = viewFactory.getEImage("flag_pattern_" + pattern,null,false);
         container.setContent("pattern",img);
         this.mPatternPetition.push(container);
         container.mouseChildren = false;
         if(area != null)
         {
            container.setLayoutArea(area);
         }
         return container;
      }
      
      private function checkPatternPetition(petition:ESpriteContainer) : Boolean
      {
         var sp:Shape = null;
         var area:ELayoutArea = null;
         var returnValue:Boolean = false;
         var pattern:EImage = petition.getContentAsEImage("pattern");
         var mask:EImage = petition.getContentAsEImage("mask");
         if(pattern != null && mask != null && pattern.isTextureLoaded() && mask.isTextureLoaded())
         {
            returnValue = true;
            sp = this.createMask(mask);
            pattern.setMask(sp);
            pattern.addChild(sp);
            petition.eAddChild(pattern);
            area = petition.getLayoutArea();
            if(area != null)
            {
               petition.setLayoutArea(area,true);
            }
         }
         return returnValue;
      }
      
      private function checkPatternPetitions() : void
      {
         var petition:ESpriteContainer = null;
         var count:int = 0;
         var i:int = 0;
         if(this.mPatternPetition != null)
         {
            count = int(this.mPatternPetition.length);
            for(i = 0; i < count; )
            {
               petition = this.mPatternPetition[i];
               if(this.checkPatternPetition(petition))
               {
                  this.mPatternPetition.splice(i,1);
                  i--;
                  count--;
               }
               i++;
            }
         }
      }
      
      public function createMask(esp:ESprite) : Shape
      {
         var pixel:uint = 0;
         var x:int = 0;
         var y:int = 0;
         var sp:Shape = null;
         var bmp:BitmapData = null;
         if(esp != null)
         {
            bmp = new BitmapData(esp.width,esp.height,true,16711935);
            bmp.draw(esp);
            (sp = new Shape()).graphics.clear();
            for(y = 0; y < bmp.height; )
            {
               for(x = 0; x < bmp.width; )
               {
                  if((pixel = bmp.getPixel32(x,y)) == 0)
                  {
                     sp.graphics.beginFill(16711935);
                     sp.graphics.drawRect(x,y,1,1);
                     sp.graphics.endFill();
                  }
                  x++;
               }
               y++;
            }
         }
         return sp;
      }
      
      public function createNotificationIncorrectAllianceName() : Notification
      {
         var title:String = DCTextMng.getText(77);
         var body:String = DCTextMng.getText(2911);
         return new Notification("NotificationIncorrectAllianceName",title,body,"alliance_council_angry");
      }
      
      public function throwErrorMessage(title:String, body:String) : void
      {
         var returnValue:Notification = new Notification("NotificationIncorrectAllianceName",title,body,"alliance_council_angry");
         InstanceMng.getNotificationsMng().guiOpenNotificationMessage(returnValue);
      }
      
      public function guiOpenAllianceNotification(e:Object) : void
      {
         var popup:DCIPopup = null;
         popup = InstanceMng.getUIFacade().getPopupFactory().getAlliancesNotification(e);
         InstanceMng.getUIFacade().enqueuePopup(popup);
      }
      
      public function openWarIsLostPopup(endByKO:Boolean) : void
      {
         var o:Object = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NOTIFY_ALLIANCES_CURRENT_WAR_LOSE");
         o.endByKO = endByKO;
         this.guiOpenAllianceNotification(o);
      }
      
      public function openWarIsWonPopup(endByKO:Boolean, allianceName:String) : void
      {
         var o:Object = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NOTIFY_ALLIANCES_CURRENT_WAR_WIN");
         o["endByKO"] = endByKO;
         o["allianceName"] = allianceName;
         this.guiOpenAllianceNotification(o);
      }
      
      public function isPopupAlliancesBeingShown() : Boolean
      {
         return this.mPopupAlliance != null && this.mPopupAlliance.isPopupBeingShown();
      }
      
      public function openErrorFromAllianceService() : void
      {
         var notificationsMng:NotificationsMng = InstanceMng.getNotificationsMng();
         var notification:Notification = notificationsMng.createNotificationErrorFromAlliancesService();
         notificationsMng.guiOpenNotificationMessage(notification,false,true);
      }
      
      public function openKickedFromAlliancePopup() : void
      {
         this.throwErrorMessage(DCTextMng.getText(3004),DCTextMng.getText(3005));
      }
      
      public function requestWarSuggested(type:String) : void
      {
         var clientCmd:String = "getShuffledSuggestedAlliances";
         var data:Object = AlliancesConstants.objCreateGetSuggestedWarAlliance(clientCmd,type,getMyAlliance().getId());
         notificationsStoreNotification(clientCmd,this.onRequestWarSuggestedSuccess,this.onRequestWarSuggestedFail,true);
         InstanceMng.getUserDataMng().requestAlliancesWarSuggested(data);
      }
      
      private function onRequestWarSuggestedSuccess(ae:AlliancesAPIEvent) : void
      {
         var isChosenType:Boolean = false;
         var allTypeDef:AlliancesWarTypesDef = null;
         var text:String = null;
         var alliance:Alliance = ae.alliance;
         var requestParams:Object = ae.getRequestParams();
         if(requestParams.hasOwnProperty("isChosenType"))
         {
            isChosenType = Boolean(requestParams["isChosenType"]);
         }
         else
         {
            isChosenType = false;
         }
         this.mAllianceToDeclareWarId = alliance.getId();
         if(isChosenType)
         {
            this.doDeclareWar(null);
         }
         else
         {
            allTypeDef = InstanceMng.getAlliancesWarTypesDefMng().getDefBySku(requestParams["type"]) as AlliancesWarTypesDef;
            text = DCTextMng.replaceParameters(3072,[allTypeDef.getNameToDisplay()]);
            InstanceMng.getNotificationsMng().guiOpenConfirmPopup("isNotAllianceChosen",DCTextMng.getText(3071),text,"alliance_council_happy",DCTextMng.getText(1),DCTextMng.getText(2),this.doDeclareWar,null,false);
         }
      }
      
      private function doDeclareWar(e:EEvent) : void
      {
         this.declareWar(this.mAllianceToDeclareWarId,this.onDeclareWarCallBack,this.onDeclareWarCallBack);
      }
      
      private function onRequestWarSuggestedFail(ae:AlliancesAPIEvent) : void
      {
         this.throwErrorMessage(ae.getErrorTitle(),ae.getErrorMsg());
      }
      
      private function onDeclareWarCallBack(ae:AlliancesAPIEvent) : void
      {
         var data:Object = null;
         var allianceEnemy:Alliance = null;
         var success:*;
         if(success = ae.type == "alliance_api_success")
         {
            data = {};
            allianceEnemy = getEnemyAlliance();
            data["alreadyAtWar"] = getMyAlliance().isInAWar();
            data["allianceName"] = allianceEnemy != null ? allianceEnemy.getName() : null;
            data["cmd"] = "NOTIFY_ALLIANCES_DECLARE_WAR";
            data["showPublish"] = true;
            this.guiOpenAllianceNotification(data);
         }
      }
   }
}
