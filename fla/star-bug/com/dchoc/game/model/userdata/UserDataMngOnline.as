package com.dchoc.game.model.userdata
{
   import com.dchoc.game.controller.alliances.AlliancesController;
   import com.dchoc.game.controller.shop.BuildingsBufferController;
   import com.dchoc.game.core.flow.Application;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.rule.RuleMng;
   import com.dchoc.game.eview.facade.BuildingBufferFacade;
   import com.dchoc.game.model.alliances.Alliance;
   import com.dchoc.game.model.alliances.AlliancesConstants;
   import com.dchoc.game.model.items.ItemObject;
   import com.dchoc.game.model.items.ItemsDef;
   import com.dchoc.game.model.items.RewardObject;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.online.Browser;
   import com.dchoc.game.online.BrowserEvent;
   import com.dchoc.game.online.Server;
   import com.dchoc.game.online.ServerEvent;
   import com.dchoc.game.online.Server_Echo;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.reygazu.anticheat.managers.CheatManager;
   import esparragon.utils.EUtils;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   
   public class UserDataMngOnline extends UserDataMng
   {
       
      
      private const USE_BATTLE_DAMAGES_OPTIMIZATION:Boolean = true;
      
      private const RETRY_CREDITS_PURCHASE_COUNTS:int = 5;
      
      private const RETRY_CREDITS_PURCHASE_TIMER:int = 10000;
      
      private const RETRY_BETS_COUNTS:int = 500000;
      
      private const RETRY_BETS_TIMER:int = 5000;
      
      private var mBrowser:Browser;
      
      private var mServer:Server;
      
      private var mLoadFilesStarted:Boolean;
      
      private var mLoadFilesFinished:Boolean;
      
      private var mLoadFilesStep:int = 0;
      
      private var mMyAccountIsLocked:Boolean = false;
      
      private var mNotifyExceptionSent:Boolean = false;
      
      private var mNotifyExceptionCount:int = 0;
      
      private var mRetryCreditsPurchaseCount:int = 0;
      
      private var mRetryCreditsPurchaseTimer:int = 0;
      
      private var mRetryCreditsPurchaseSendRetry:Boolean = false;
      
      private var mAttackingUniverse:Boolean = false;
      
      private var mPlatform:String = null;
      
      private var mAttackingToAccount:Boolean = false;
      
      private var mAttackingToNPC:Boolean = false;
      
      private var mFirstLoadingSuccessDone:Boolean = false;
      
      private var mUpdateExternalNotifications:Array;
      
      private var mSecureBattleStartWithScore:SecureInt;
      
      private var mContestPopupCount:int = 0;
      
      private var mBattleSignatureFirst:int = 0;
      
      private var mBattleSignatureNow:int = 0;
      
      private var mBattleSignatureDoneInFirstDeploy:Boolean = false;
      
      private var mRequestFriendsAndNeighborsToServerAllowed:Boolean = true;
      
      private var mRequestFriendsAndNeighborsToServerPending:Boolean = false;
      
      private var mBetSku:String;
      
      private var mBetsCount:int = 0;
      
      private var mBetsTimer:int = 0;
      
      private var mBetsWaitingResponse:Boolean = false;
      
      private var mBattleIsOn:Boolean = false;
      
      private const ITEMS_DAMAGED_FLUSH_TIMER:int = 60000;
      
      private var mBattleDeploysAry:Array = null;
      
      private var mBattleMineExplodedAry:Array = null;
      
      private var mBattleDamagesCmdObj:Object = null;
      
      private var mBattleDamagesOrderAry:Array = null;
      
      private var mBattleTargetsCmdObj:Object = null;
      
      private var mBattleSocialItemAry:Array = null;
      
      private var mBattleDamagesTimer:int = 0;
      
      private var mBattleUmbrellaDamagedAry:Array = null;
      
      private var mGalaxyAreas:Object;
      
      private var mGalaxyStarsID:Object;
      
      private var mGalaxyStarsSku:Object;
      
      private var mTemplateItemsDataWaitingToSave:Object;
      
      public function UserDataMngOnline()
      {
         mSecureBattleStartWithScore = new SecureInt("UserDataMngOnline");
         this.mUpdateExternalNotifications = [];
         this.mGalaxyAreas = {};
         this.mGalaxyStarsID = {};
         this.mGalaxyStarsSku = {};
         super(true);
         DCDebug.allowConsoleVisible = false;
         DCDebug.traceCh("SERVER","UserDataMngOnline<init>");
         var flashVars:Object = Star.getFlashVars();
         if(flashVars != null)
         {
            DCDebug.traceCh("SERVER","flashvars:");
            DCDebug.traceChObject("SERVER",flashVars);
         }
         else
         {
            DCDebug.traceCh("SERVER","flashvars NOT found!");
         }
         mUserAccountId = flashVars["accountId"];
         mUserExtId = flashVars["uid"];
         this.mPlatform = flashVars["platform"];
         this.mBrowser = new Browser();
         this.mBrowser.addEventListener("onBrowserResponse",this.onBrowserResponse);
         this.mServer = new Server_Echo();
         this.mServer.addEventListener("onServerResponse",this.onServerResponse);
         init();
      }
      
      override public function loadFiles() : void
      {
         if(!this.mLoadFilesStarted)
         {
            this.mLoadFilesStep = 0;
            this.loadFilesNextStep();
            this.mLoadFilesStarted = true;
         }
      }
      
      override public function isLoaded() : Boolean
      {
         return this.mLoadFilesFinished;
      }
      
      private function loadFilesNextStep() : void
      {
         switch(this.mLoadFilesStep)
         {
            case 0:
               reserveFile(KEY_CUSTOMIZER);
               this.mServer.sendCommand("obtainCustomizer",{});
               reserveFile(KEY_UNIVERSE);
               this.mServer.sendCommand("obtainUniverse",{"targetAccountId":mUserAccountId});
               reserveFile(KEY_UPSELLING);
               this.mServer.sendCommand("obtainUpSelling",{});
               reserveFile(KEY_NPC_NEIGHBOR_LIST);
               this.mServer.sendCommand("obtainNpcList",{});
               reserveFile(KEY_ATTACKER_LIST);
               this.mServer.sendCommand("obtainAttackerList",{});
               reserveFile(KEY_ITEMS_LIST);
               this.mServer.sendCommand("obtainSocialItems",{});
               reserveFile(KEY_ACTIONS_PERFORMED_BY_FRIENDS_LIST);
               this.mServer.sendCommand("obtainVisitHelps",{});
               reserveFile(KEY_HANGARS_HELP_LIST);
               this.mServer.sendCommand("obtainHangarsHelp",{});
               reserveFile(KEY_BATTLE_REPLAY);
               this.mServer.sendCommand("obtainBattleReplay",{});
               reserveFile(KEY_WEEKLY_SCORE_LIST);
               this.mServer.sendCommandNow("obtainWeeklyScoreList",{});
               this.mServer.sendCommandNow("obtainRefinery",{});
               break;
            case 2:
               reserveFile(KEY_SOCIAL_USER_INFO);
               this.mServer.sendCommand("obtainSocialUserInfo",{});
               reserveFile(KEY_FRIENDS_LIST);
               reserveFile(KEY_NEIGHBOR_LIST);
               if(this.mRequestFriendsAndNeighborsToServerAllowed)
               {
                  this.requestFriendsAndNeighborsToServer();
               }
               else
               {
                  this.mRequestFriendsAndNeighborsToServerPending = true;
                  setTimeout(this.requestFriendsAndNeighborsTimeout,30000);
               }
               break;
            default:
               break;
            case 3:
               this.mLoadFilesFinished = true;
               return;
         }
         this.mServer.mForceSendAllNow = true;
         this.mLoadFilesStep++;
      }
      
      private function requestFriendsAndNeighborsTimeout() : void
      {
         this.mRequestFriendsAndNeighborsToServerAllowed = true;
      }
      
      private function requestFriendsAndNeighborsToServer() : void
      {
         this.mServer.sendCommand("obtainFriendsList",{});
         this.mServer.sendCommand("obtainNeighborsList",{});
      }
      
      override public function login(retry:Boolean = false) : void
      {
         var flashVars:Object = Star.getFlashVars();
         var uid:String = String(flashVars["uid"]);
         if(uid == null)
         {
            DCDebug.traceCh("SERVER","No UID in flashvars");
            return;
         }
         var token:String;
         if((token = String(flashVars["token"])) == null)
         {
            token = "pass";
         }
         this.mServer.login(uid,token,"init",retry);
         Server_Echo(this.mServer).setARC4OutKey(token);
      }
      
      override public function isLogged() : Boolean
      {
         return this.mServer.isLogged();
      }
      
      override public function serverIsBusy() : int
      {
         return this.mServer.serverIsBusy();
      }
      
      override public function isUniverseLocked() : Boolean
      {
         return this.mMyAccountIsLocked;
      }
      
      override public function flushAllPendingCommandsToServer() : void
      {
         this.mServer.flushAllCommandsNow();
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var profile:Profile = null;
         super.logicUpdateDo(dt);
         this.mServer.logicUpdate(dt);
         this.battleDamagesCacheLogicUpdate(dt);
         if(this.mRequestFriendsAndNeighborsToServerPending && this.mRequestFriendsAndNeighborsToServerAllowed)
         {
            this.mRequestFriendsAndNeighborsToServerPending = false;
            this.requestFriendsAndNeighborsToServer();
         }
         if(!this.mLoadFilesFinished)
         {
            if(this.mLoadFilesStarted)
            {
               if(allFilesLoadedExclude([KEY_FRIENDS_LIST,KEY_NEIGHBOR_LIST]))
               {
                  this.loadFilesNextStep();
               }
               if(this.mLoadFilesFinished)
               {
                  build();
               }
            }
         }
         else if(this.mServer.isLogged())
         {
            if(this.mRetryCreditsPurchaseTimer > 0)
            {
               this.mRetryCreditsPurchaseTimer -= dt;
            }
            if(this.mRetryCreditsPurchaseSendRetry && this.mRetryCreditsPurchaseTimer <= 0)
            {
               this.queryVerifyCreditsPurchase(false);
            }
            this.updateBets_logicUpdate(dt);
            if(this.mContestPopupCount > 0)
            {
               this.mContestPopupCount -= dt;
               if(this.mContestPopupCount <= 0 || this.mServer.serverIsBusy() == 2)
               {
                  this.mContestPopupCount = 0;
                  InstanceMng.getContestMng().notificationsNotify("commandsFlushed",true,{});
               }
            }
            profile = InstanceMng.getUserInfoMng().getProfileLogin();
            if(this.mFirstLoadingSuccessDone && profile != null && profile.isBuilt() && !InstanceMng.getApplication().isLoading())
            {
               while(this.mUpdateExternalNotifications.length > 0)
               {
                  this.updateExternalNotification(this.mUpdateExternalNotifications.shift() as Object);
               }
            }
         }
      }
      
      override public function requestTask(task:String, data:Object = null, transaction:Transaction = null) : void
      {
         var params:Object = null;
         var xml:XML = null;
         var data2:Object = null;
         super.requestTask(task,data,transaction);
         if(data == null)
         {
            data = {};
         }
         DCDebug.traceCh("SERVER","--=> userDataMng.requestTask(" + task + ")");
         DCDebug.traceChObject("SERVER",data);
         var paramObj:Object = {};
         if(task == KEY_UNIVERSE)
         {
            this.battleDamagesCacheInit();
            this.mBattleStartWithScore = Math.floor(InstanceMng.getUserInfoMng().getProfileLogin().getScore());
            this.mAttackingToAccount = false;
            this.mAttackingToNPC = false;
            reserveFile(KEY_UNIVERSE);
            if(data.hasOwnProperty("attack"))
            {
               this.mBattleSignatureDoneInFirstDeploy = false;
               paramObj["attack"] = data["attack"];
               this.mAttackingUniverse = int(data["attack"]) == 1;
               if(this.mAttackingUniverse)
               {
                  paramObj["hangarsUnitsInfo"] = InstanceMng.getHangarControllerMng().getProfileLoginHangarController().getUnitsInfo();
               }
               if(data.hasOwnProperty("quickAttack"))
               {
                  paramObj["quickAttack"] = data["quickAttack"];
               }
               if(data.hasOwnProperty("betAttack"))
               {
                  paramObj["betAttack"] = data["betAttack"];
               }
               if(transaction != null)
               {
                  paramObj["transaction"] = this.createTransactionObject(transaction);
               }
            }
            if(data.hasOwnProperty("planetX"))
            {
               paramObj["coordX"] = data["planetX"];
               paramObj["coordY"] = data["planetY"];
            }
            if(data.hasOwnProperty("planetSku"))
            {
               paramObj["planetSku"] = data["planetSku"];
            }
            if(data.hasOwnProperty("userId"))
            {
               paramObj["targetAccountId"] = data["userId"];
               paramObj["planetId"] = data["planetId"];
               this.mAttackingToAccount = true;
               if(data.hasOwnProperty("revengeAttackId"))
               {
                  paramObj["revengeAttackId"] = data["revengeAttackId"];
               }
            }
            else if(data.hasOwnProperty("advisorSku"))
            {
               paramObj["targetAdvisorSku"] = data["advisorSku"];
               this.mAttackingToNPC = true;
            }
            this.mServer.sendCommandNow("obtainUniverse",paramObj);
            reserveFile(KEY_ACTIONS_PERFORMED_BY_FRIENDS_LIST);
            this.mServer.sendCommand("obtainVisitHelps",{});
            reserveFile(KEY_HANGARS_HELP_LIST);
            this.mServer.sendCommand("obtainHangarsHelp",{});
            if(data.hasOwnProperty("userId"))
            {
               reserveFile(KEY_NPC_NEIGHBOR_LIST);
               this.mServer.sendCommand("obtainNpcList",{});
            }
         }
         else if(task == KEY_HANGARS_OWNER)
         {
            reserveFile(KEY_HANGARS_OWNER);
            this.mServer.sendCommand("obtainHangarsOwner",{});
         }
         else if(task == KEY_CHECK_AVAILABLE_ATTACK)
         {
            reserveFile(KEY_CHECK_AVAILABLE_ATTACK);
            params = {
               "targetAccountId":data["userId"],
               "planetId":data["planetId"],
               "applyLock":data["applyLock"]
            };
            this.mServer.sendCommandNow("queryCheckAndLockAccountIfPossible",params);
         }
         else if(task == KEY_FREE_LOCKED_ATTACK)
         {
            this.mServer.sendCommandNow("unlockAccountFromAttack",{"targetAccountId":data["userId"]});
         }
         else if(task == KEY_CHECK_WARP_BUNKER_TRANSFER)
         {
            reserveFile(KEY_CHECK_WARP_BUNKER_TRANSFER);
            this.mServer.sendCommandNow("queryVisitHelpsGiftUnitsOnBunker",data);
         }
         else if(task == KEY_GALAXY_WINDOW)
         {
            reserveFile(KEY_GALAXY_WINDOW);
            if((xml = this.galaxyGetCachedStars(Number(data["topLeftCoordX"]),Number(data["topLeftCoordY"]),Number(data["bottomRightCoordX"]),Number(data["bottomRightCoordY"]))) != null)
            {
               setFile(KEY_GALAXY_WINDOW,xml);
               Application.externalNotification(15,{"xml":xml});
            }
            else
            {
               this.mServer.sendCommandNow("queryGalaxyWindow",data);
            }
         }
         else if(task == KEY_STAR_PLANETS_WINDOW)
         {
            reserveFile(KEY_STAR_PLANETS_WINDOW);
            this.mServer.sendCommandNow("queryStarInfo",data);
            reserveFile(KEY_NPC_NEIGHBOR_LIST);
            this.mServer.sendCommand("obtainNpcList",{});
         }
         else if(task == KEY_BOOKMARKS)
         {
            reserveFile(KEY_BOOKMARKS);
            this.mServer.sendCommandNow("queryStarsBookmarks",data);
         }
         else if(task == KEY_PURCHASE_CREDITS)
         {
            this.mBrowser.taskRequest("purchaseCredits",data);
         }
         else if(task == KEY_USER_ITEMS_AMOUNT_INFO)
         {
            this.mBrowser.taskRequest(KEY_USER_ITEMS_AMOUNT_INFO,data);
         }
         else if(task == KEY_SPY_STATUS)
         {
            this.mBrowser.taskRequest("cantPerformAction",data);
         }
         else if(task == KEY_OFFER_CREDITS)
         {
            InstanceMng.getApplication().setToWindowedMode();
            this.mBrowser.taskRequest("offerCredits");
         }
         else if(task == KEY_NEIGHBOR_INFO)
         {
            reserveFile(KEY_NEIGHBOR_INFO);
            this.mServer.sendCommandNow("obtainNeighborData",data);
         }
         else if(task == KEY_OPEN_INVITE_TAB || task == KEY_OPEN_LEADERBOARD_TAB || task == KEY_OPEN_FREE_GIFT)
         {
            InstanceMng.getApplication().setToWindowedMode();
            this.mBrowser.taskRequest(task,data);
         }
         else if(task == KEY_INVESTS_LIST)
         {
            reserveFile(KEY_INVESTS_LIST);
            this.mServer.sendCommandNow("obtainInvestments",data);
         }
         else if(task == "addNeighbor")
         {
            data.title = DCTextMng.getText(3445);
            data.message = DCTextMng.getText(3463);
            this.mBrowser.taskRequest(task,data);
         }
         else if(task == "inviteIndividualFriend")
         {
            data.title = DCTextMng.getText(25);
            data.message = DCTextMng.getText(3463);
            this.mBrowser.taskRequest(task,data);
         }
         else if(task == KEY_WEEKLY_SCORE_LIST)
         {
            reserveFile(KEY_WEEKLY_SCORE_LIST);
            this.mServer.sendCommandNow("obtainWeeklyScoreList",data);
         }
         else if(task == KEY_PURCHASE_PROMOTION)
         {
            this.mBrowser.taskRequest(task,data);
            (data2 = {})["action"] = "promoAddCreditCard";
            data2["entry"] = data["entry"];
            data2["origin"] = data["origin"];
            this.updateMisc(data2);
            this.mServer.mForceSendAllNow = true;
         }
         else if(task == KEY_PURCHASE_MOBILE_PAYMENTS)
         {
            this.mBrowser.taskRequest(KEY_PURCHASE_MOBILE_PAYMENTS,data);
         }
         else if(task == KEY_SHOW_CROSS_PROMOTION)
         {
            this.mBrowser.taskRequest(KEY_SHOW_CROSS_PROMOTION,data);
         }
         else if(task == KEY_SEND_CUSTOMIZER)
         {
            this.mBrowser.taskRequest(KEY_SEND_CUSTOMIZER,data);
         }
         else if(task == KEY_SEND_ACHIEVEMENT)
         {
            this.mBrowser.taskRequest(KEY_SEND_ACHIEVEMENT,data);
         }
         else if(task == KEY_SEND_STAGE_SCREENSHOT || task == KEY_HIDE_STAGE_SCREENSHOT || task == KEY_SHOW_STAGE_SCREENSHOT)
         {
            this.mBrowser.taskRequest(task,data);
         }
         else if(task == KEY_ATTACK_IN_PROGRESS)
         {
            this.mBrowser.taskRequest(task,data);
         }
         else if(task == KEY_START_NOW_ASK_PERMISSIONS)
         {
            this.mBrowser.taskRequest(task,data);
         }
         else if(task == KEY_TEMPLATES)
         {
            this.mServer.sendCommandNow("obtainTemplates",data);
         }
         else if(task == KEY_POLL)
         {
         }
      }
      
      private function onServerResponse(evt:ServerEvent) : void
      {
         var hasRefinery:* = false;
         var timeLeft:Number = NaN;
         var bufferBar:BuildingBufferFacade = null;
         var bufferController:BuildingsBufferController = null;
         var slotId:int = 0;
         var templateUUID:String = null;
         var template:Object = null;
         var templateDataItems:Object = null;
         var itemsDataConverted:Object = null;
         var paramsOut:Dictionary = null;
         var cubeSku:String = null;
         var lockData:Object = null;
         var cubeLimit:int = 0;
         var rewardObject:RewardObject = null;
         var ruleMng:RuleMng = null;
         var count:* = 0;
         var position:Number = NaN;
         var challengeResult:Object = null;
         var resultS:String = null;
         var verifyResult:Object = null;
         var socialUserInfo:XML = null;
         var customizerXML:XML = null;
         var lockSuccess:* = false;
         var lockType:int = 0;
         var xml:XML = null;
         var colonyPurchaseSuccess:* = false;
         var colonyMovedSuccess:* = false;
         var success2:* = false;
         var result:Array = null;
         var data:Object = null;
         var paramObj:Object = null;
         var success:* = false;
         var cashOnlyMode:* = false;
         var status:* = false;
         var amount:int = 0;
         var pendingTransactionsObj:Object = null;
         var pendingTransactionsAry:Array = null;
         var pendingTransactionsXML:XML = null;
         var sku:String = null;
         var blackList:Array = null;
         var lines:Array = null;
         var text:String = null;
         var responseToController:Object = null;
         var requestParams:Object = null;
         var responseString:String = null;
         var response:Object = null;
         var ok:Boolean = false;
         var alliancesController:AlliancesController = null;
         var alliance:Alliance = null;
         var key:String = null;
         var cmdKey:String = null;
         var type:String = null;
         var responseObj:Object;
         var cmd:String = String((responseObj = evt.params)["cmdName"]);
         var dataObj:Object = responseObj["cmdData"];
         onServerResponseReceived(cmd);
         var action:String = "";
         if(dataObj.hasOwnProperty("action"))
         {
            action = dataObj["action"] as String;
         }
         DCDebug.traceCh("SERVER","<<< processResponse: " + cmd + " / action: " + action);
         if(dataObj != null && !Config.DEBUG_SHORTEN_NOISY || Config.DEBUG_SHORTEN_NOISY_CMDS.indexOf(cmd) == -1)
         {
            DCDebug.traceChObject("SERVER",dataObj);
         }
         else
         {
            DCDebug.traceCh("SERVER",cmd + " response info omitted");
         }
         if(cmd == "obtainUniverse")
         {
            mPlanetRunningMillis = 0;
            setFile(KEY_UNIVERSE,Server.objectToXML(dataObj));
         }
         else if(cmd == "obtainHangarsOwner")
         {
            setFile(KEY_HANGARS_OWNER,Server.objectToXML(dataObj));
         }
         else if(cmd == "obtainSocialUserInfo")
         {
            setFile(KEY_SOCIAL_USER_INFO,Server.objectToXML(dataObj));
            socialUserInfo = Server.objectToXML(dataObj);
            mUserName = EUtils.xmlReadString(socialUserInfo,"name");
            mUserPhotoUrl = EUtils.xmlReadString(socialUserInfo,"photoURL");
         }
         else if(cmd == "obtainFriendsList")
         {
            setFile(KEY_FRIENDS_LIST,Server.objectToXML(dataObj));
         }
         else if(cmd == "obtainNeighborsList")
         {
            setFile(KEY_NEIGHBOR_LIST,Server.objectToXML(dataObj));
         }
         else if(cmd == "obtainNeighborData")
         {
            setFile(KEY_NEIGHBOR_INFO,Server.objectToXML(dataObj));
            Application.externalNotification(19,{"xml":Server.objectToXML(dataObj)});
         }
         else if(cmd == "obtainUpSelling")
         {
            if(dataObj.hasOwnProperty("isUpdate"))
            {
               InstanceMng.getUpSellingMng().updatePremiumOffers(Server.objectToXML(dataObj));
            }
            else
            {
               setFile(KEY_UPSELLING,Server.objectToXML(dataObj));
            }
         }
         else if(cmd == "obtainCustomizer")
         {
            this.mBrowser.taskRequest(KEY_SEND_CUSTOMIZER,dataObj);
            customizerXML = Server.objectToXML(dataObj);
            setFile(KEY_CUSTOMIZER,customizerXML);
         }
         else if(cmd == "obtainNpcList")
         {
            setFile(KEY_NPC_NEIGHBOR_LIST,Server.objectToXML(dataObj));
         }
         else if(cmd == "obtainAttackerList")
         {
            setFile(KEY_ATTACKER_LIST,Server.objectToXML(dataObj));
         }
         else if(cmd == "obtainBattleReplay")
         {
            setFile(KEY_BATTLE_REPLAY,Server.objectToXML(dataObj));
         }
         else if(cmd == "obtainSocialItems")
         {
            setFile(KEY_ITEMS_LIST,Server.objectToXML(dataObj));
         }
         else if(cmd == "obtainVisitHelps")
         {
            setFile(KEY_ACTIONS_PERFORMED_BY_FRIENDS_LIST,Server.objectToXML(dataObj));
         }
         else if(cmd == "obtainInvestments")
         {
            setFile(KEY_INVESTS_LIST,Server.objectToXML(dataObj));
         }
         else if(cmd == "obtainHangarsHelp")
         {
            setFile(KEY_HANGARS_HELP_LIST,Server.objectToXML(dataObj));
         }
         else if(cmd == "obtainWeeklyScoreList")
         {
            setFile(KEY_WEEKLY_SCORE_LIST,Server.objectToXML(dataObj));
         }
         else if(cmd == "obtainRefinery")
         {
            if(hasRefinery = int(dataObj["success"]) != 0)
            {
               sku = String(dataObj["sku"]);
               timeLeft = Number(dataObj["timeLeft"]);
               InstanceMng.getUserInfoMng().getProfileLogin().setRefiningSku(sku);
               InstanceMng.getUserInfoMng().getProfileLogin().setRefiningTime(timeLeft);
            }
         }
         else if(cmd == "obtainTemplates")
         {
            setFile(KEY_TEMPLATES,Server.objectToXML(dataObj));
            if((bufferBar = InstanceMng.getUIFacade().getBuildingsBufferBar()) != null && InstanceMng.getBuildingsBufferController().isBufferOpen())
            {
               bufferBar.updateButtons();
            }
         }
         else if(cmd == "obtainPoll")
         {
            InstanceMng.getPollMng().loadPollData(dataObj);
         }
         else if(cmd == "queryCheckAndLockAccountIfPossible")
         {
            if(!(lockSuccess = int(dataObj["lockSuccess"]) != 0))
            {
               lockType = int(dataObj["lockType"]);
            }
            setFile(KEY_CHECK_AVAILABLE_ATTACK,{
               "attack":lockSuccess,
               "lockApplied":dataObj["lockApplied"],
               "lockType":lockType,
               "unlockTimeLeft":dataObj["unlockTimeLeft"]
            });
         }
         else if(cmd == "queryVisitHelpsGiftUnitsOnBunker")
         {
            setFile(KEY_CHECK_WARP_BUNKER_TRANSFER,Server.objectToXML(dataObj));
         }
         else if(cmd == "queryGalaxyWindow")
         {
            xml = Server.objectToXML(dataObj);
            this.galaxyAreaAdd(xml);
            setFile(KEY_GALAXY_WINDOW,xml);
            Application.externalNotification(15,{"xml":xml});
         }
         else if(cmd == "queryStarInfo")
         {
            xml = Server.objectToXML(dataObj);
            setFile(KEY_STAR_PLANETS_WINDOW,xml);
            Application.externalNotification(7,{"xml":xml});
         }
         else if(cmd == "queryPlanetAvailability")
         {
            lockSuccess = int(dataObj["lockSuccess"]) != 0;
            DCDebug.trace("********* queryPlanetAvailability - lockSuccess: " + lockSuccess);
            if(!lockSuccess)
            {
               setFile(KEY_STAR_PLANETS_WINDOW,Server.objectToXML(dataObj["queryStarInfo"]));
            }
            Application.externalNotification(9,{"colonyAvailable":lockSuccess});
            if(!lockSuccess)
            {
               Application.externalNotification(7,{"xml":Server.objectToXML(dataObj["queryStarInfo"])});
            }
         }
         else if(cmd == "queryGetColonyConfirmPurchase")
         {
            colonyPurchaseSuccess = int(dataObj["colonyPurchaseSuccess"]) != 0;
            DCDebug.trace("********* queryGetColonyConfirmPurchase - Success: " + colonyPurchaseSuccess);
            if(colonyPurchaseSuccess)
            {
               Application.externalNotification(11,{
                  "planetSku":dataObj["planetSku"],
                  "planetId":dataObj["planetId"],
                  "planetName":dataObj["planetName"]
               });
            }
            else
            {
               Application.externalNotification(12,{});
            }
         }
         else if(cmd == "queryGetColonyConfirmMove")
         {
            colonyMovedSuccess = int(dataObj["colonyMovedSuccess"]) != 0;
            DCDebug.trace("********* queryGetColonyConfirmMove - Success: " + colonyMovedSuccess);
            if(colonyMovedSuccess)
            {
               Application.externalNotification(23,{
                  "planetSku":dataObj["planetSku"],
                  "planetId":dataObj["planetId"],
                  "starId":dataObj["starId"]
               });
            }
            else
            {
               Application.externalNotification(24,{});
            }
         }
         else if(cmd == "quickAttackFindTarget")
         {
            success2 = int(dataObj["success"]) != 0;
            DCDebug.trace("********* quickAttackFindTarget - Success: " + success2);
            if(success2)
            {
               Application.externalNotification(25,{"userInfo":Server.objectToXML(dataObj)});
            }
            else
            {
               Application.externalNotification(26,{});
            }
         }
         else if(cmd == "updateBets")
         {
            if(action == "requestBet")
            {
               this.mBetsWaitingResponse = false;
               if(int(dataObj["success"]) != 0)
               {
                  this.mBetsCount = 0;
                  this.mBetsTimer = 0;
                  Application.externalNotification(28,{"userInfo":Server.objectToXML(dataObj)});
               }
               else if(int(dataObj["reason"]) == -1)
               {
                  this.mBetsCount = 0;
                  this.mBetsTimer = 0;
                  this.mBetsWaitingResponse = false;
                  InstanceMng.getBetMng().cancelRequestBet(true);
                  InstanceMng.getApplication().lockUIOpenPopupBasedOnResponse({"lockType":UserDataMng.ACCOUNT_LOCKED_HANGARS_EMPTY});
               }
            }
            else if(action == "requestResult")
            {
               Application.externalNotification(30,{"result":Server.objectToXML(dataObj)});
            }
         }
         else if(cmd == "updateTemplates")
         {
            bufferController = InstanceMng.getBuildingsBufferController();
            if(action == "saveTemplate")
            {
               if(int(dataObj["success"]) != 0)
               {
                  slotId = int(dataObj["slotId"]);
                  templateUUID = String(dataObj["templateId"]);
                  bufferController.saveTemplateLocally(slotId,this.mTemplateItemsDataWaitingToSave,templateUUID,false);
               }
               this.mTemplateItemsDataWaitingToSave = null;
            }
            else if(action == "importTemplate")
            {
               if(int(dataObj["success"]) == 1)
               {
                  slotId = int(dataObj["slotId"]);
                  templateDataItems = (template = dataObj["template"])["Items"];
                  templateUUID = String(template["id"]);
                  InstanceMng.getUIFacade().closePopupById("PopupBufferTemplates");
                  itemsDataConverted = bufferController.convertItemsXMLListToSkuBasedItemsData(EUtils.xmlGetChildrenList(Server.objectToXML({"Items":templateDataItems})));
                  bufferController.saveTemplateLocally(slotId,itemsDataConverted,templateUUID,true);
               }
               else
               {
                  InstanceMng.getNotificationsMng().guiOpenTemplateError(5);
               }
            }
            MessageCenter.getInstance().sendMessage("unlockTemplatesPopup");
         }
         else if(cmd == "updateMisc")
         {
            if(action == "applyPurchasesFromMobileAdjust")
            {
               if((result = dataObj["result"]) != null && result.length > 0)
               {
                  Application.externalNotification(31,result);
               }
            }
         }
         else if(cmd == "updateContest")
         {
            if(action == "requestContest")
            {
               InstanceMng.getContestMng().notificationsNotify(action,int(dataObj["success"]) != 0,dataObj);
            }
            else if(action == "requestProgress")
            {
               InstanceMng.getContestMng().notificationsNotify(action,int(dataObj["success"]) != 0,dataObj);
            }
            else if(action == "requestLeaderboard")
            {
               InstanceMng.getContestMng().notificationsNotify(action,int(dataObj["success"]) != 0,dataObj);
            }
         }
         else if(cmd == "contestUpdated")
         {
            InstanceMng.getContestMng().notificationsNotify("progressNeedsUpdate",true,dataObj);
         }
         else if(cmd == "updateBattle")
         {
            if(action == "ping")
            {
               Application.externalNotification(29,dataObj);
            }
         }
         else if(cmd == "queryStarsBookmarks")
         {
            setFile(KEY_BOOKMARKS,Server.objectToXML(dataObj));
         }
         else if(cmd == "shieldProtectionAdded")
         {
            Application.externalNotification(32,dataObj);
         }
         else if(cmd == "queryVerifyCreditsPurchase")
         {
            DCDebug.traceChObject("SERVER",dataObj);
            success = false;
            if(cashOnlyMode = int(dataObj["cashOnlyMode"]) != 0)
            {
               status = int(dataObj["status"]) != 0;
               amount = int(dataObj["value"]);
               if(status)
               {
                  success = true;
                  Application.externalNotification(14,{
                     "status":status,
                     "value":amount
                  });
                  setNeedsToVerifyCreditsPurchase(true);
               }
            }
            else if(dataObj.hasOwnProperty("pendingTransactions"))
            {
               pendingTransactionsAry = (pendingTransactionsObj = dataObj["pendingTransactions"])["pendingTransactions"] as Array;
               DCDebug.traceCh("PendingTransaction","pendingTransactionsAry = " + pendingTransactionsAry);
               for each(var o in pendingTransactionsAry)
               {
                  DCDebug.traceChObject("PendingTransaction",o);
               }
               if(pendingTransactionsAry != null)
               {
                  success = pendingTransactionsAry.length > 0;
                  pendingTransactionsXML = Server.objectToXML(pendingTransactionsObj);
                  Application.externalNotification(21,{"pendingTransactions":pendingTransactionsXML});
                  DCDebug.traceCh("PendingTransaction","not null, sending to app");
               }
            }
            if(!success && this.mRetryCreditsPurchaseCount > 0)
            {
               this.mRetryCreditsPurchaseCount--;
               this.mRetryCreditsPurchaseSendRetry = true;
            }
            else
            {
               this.mRetryCreditsPurchaseCount = 0;
               this.mRetryCreditsPurchaseTimer = 0;
               this.mRetryCreditsPurchaseSendRetry = false;
            }
         }
         else if(cmd == "addSocialItems")
         {
            sku = dataObj["sku"] as String;
            amount = int(dataObj["amount"]);
            DCDebug.trace("********* adding SocialItem sku \'" + sku + "\' amount: " + amount);
            InstanceMng.getItemsMng().incrementItemAmount(InstanceMng.getItemsMng().getItemObjectBySku(sku),amount);
         }
         else if(cmd == "updateSocialItem")
         {
            paramsOut = new Dictionary();
            cubeSku = "";
            lockData = InstanceMng.getApplication().lockUIGetData();
            paramsOut["cubeSku"] = cubeSku;
            if(lockData != null)
            {
               cubeSku = String(lockData.cubeSku);
            }
            if(dataObj.hasOwnProperty("success") && int(dataObj["success"]) == 0)
            {
               cubeLimit = InstanceMng.getSettingsDefMng().mSettingsDef.getMaxCubesPerDay();
               InstanceMng.getNotificationsMng().guiOpenMessagePopup("PopupTooManyGiftsOpened",DCTextMng.getText(77),DCTextMng.replaceParameters(4100,[cubeLimit]),"scientist_worried");
               InstanceMng.getItemsMng().addItemAmount(cubeSku,1,false,false,false,false);
               MessageCenter.getInstance().sendMessage("mysteryCubeOpened",paramsOut);
               if(InstanceMng.getApplication().lockUIGetReason() == 17)
               {
                  InstanceMng.getApplication().lockUIReset(true);
               }
               return;
            }
            if(action == "useItem")
            {
               sku = dataObj["sku"] as String;
               rewardObject = InstanceMng.getRuleMng().createRewardObjectFromMisteryRewardSku(sku,true);
               InstanceMng.getNotificationsMng().guiOpenTradeInPopup("mysteryCube",rewardObject,false);
               if(rewardObject.getRewardType() == "item")
               {
                  InstanceMng.getItemsMng().applyReward(rewardObject);
               }
               paramsOut["cubeSku"] = cubeSku;
               MessageCenter.getInstance().sendMessage("mysteryCubeOpened",paramsOut);
               if(InstanceMng.getApplication().lockUIGetReason() == 17)
               {
                  InstanceMng.getApplication().lockUIReset(true);
               }
            }
         }
         else if(cmd == "updateInvestments")
         {
            if(action == "obtainBlackList")
            {
               blackList = dataObj["blackList"] as Array;
               this.mBrowser.taskRequest("invest_showMultiQuery",{
                  "blackList":blackList,
                  "title":DCTextMng.getText(3552),
                  "message":DCTextMng.replaceParameters(3553,[getMyName()])
               });
            }
         }
         else if(cmd == "debugText")
         {
            if((lines = dataObj["text"] as Array) != null && lines.length > 0)
            {
               for each(text in lines)
               {
                  DCDebug.traceChObject("ServerDebug",text);
               }
               DCDebug.traceChObject("ServerDebug","<----------------------->");
            }
         }
         else if(cmd == "sendWishListItem")
         {
            Application.externalNotification(34,dataObj);
         }
         else if(cmd == "updateAlliances")
         {
            action = (requestParams = dataObj["requestParams"])["action"] as String;
            responseString = dataObj["responseJSON"] as String;
            response = null;
            if(responseString != null)
            {
               response = JSON.parse(responseString);
            }
            DCDebug.traceCh("ALLIANCES","----------------------");
            DCDebug.traceCh("ALLIANCES"," responseAlliances (accountId): " + mUserAccountId);
            if(!Config.DEBUG_SHORTEN_NOISY || Config.DEBUG_SHORTEN_NOISY_CMDS.indexOf(cmd) == -1 && Config.DEBUG_SHORTEN_NOISY_ACTIONS.indexOf(requestParams["action"]) == -1)
            {
               DCDebug.traceChObject("ALLIANCES",dataObj);
               DCDebug.traceChObject("ALLIANCES",response);
               DCDebug.traceChObject("ALLIANCES",requestParams);
            }
            else
            {
               DCDebug.traceCh("ALLIANCES",requestParams["action"] + " info omitted");
            }
            DCDebug.traceCh("ALLIANCES","----------------------");
            DCDebug.traceCh("ALLIANCES","");
            if(response != null)
            {
               ok = response.result == null || response.result == "true" || response.result == true;
               alliancesController = InstanceMng.getAlliancesController();
               if(action == "getMyAlliance")
               {
                  alliancesController.notificationsNotify("requestMyAlliance",ok,response,requestParams);
               }
               else if(action == "getAlliance")
               {
                  key = AlliancesConstants.objGetKey(requestParams,"aid");
                  cmdKey = requestParams[key] == null ? "requestAllianceByUserId" : "requestAllianceById";
                  alliancesController.notificationsNotify(cmdKey,ok,response,requestParams);
               }
               else if(action == "getAlliances" || action == "getSuggestedAlliances" || action == "getAlliancesNotInWar")
               {
                  alliancesController.notificationsNotify("requestAlliancesList",ok,response,requestParams);
               }
               else if(action == "createAlliance")
               {
                  alliancesController.notificationsNotify("createAlliance",ok,response,requestParams);
               }
               else if(action == "editAlliance")
               {
                  if(ok)
                  {
                     alliance = alliancesController.getMyAlliance();
                     if(alliance != null)
                     {
                        alliance.setDescription(requestParams["description"]);
                        alliance.setLogo(AlliancesConstants.getLogoArrayFromString(requestParams["logo"]));
                        alliance.setIsPublic(requestParams["publicRecruit"]);
                        response = alliance.getJSON();
                     }
                     else
                     {
                        ok = false;
                        response = {
                           "result":"false",
                           "error":11
                        };
                     }
                  }
                  alliancesController.notificationsNotify("editAlliance",ok,response,requestParams);
               }
               else if(action == "joinAlliance")
               {
                  if(ok)
                  {
                     response.allianceId = requestParams["aid"];
                  }
                  alliancesController.notificationsNotify("joinAlliance",ok,response,requestParams);
               }
               else if(action == "leaveAlliance")
               {
                  alliancesController.notificationsNotify("leaveAlliance",ok,response,requestParams);
               }
               else if(action == "grantMember")
               {
                  alliancesController.notificationsNotify("changeUserRole",ok,response,requestParams);
               }
               else if(action == "kickMember")
               {
                  alliancesController.notificationsNotify("kickUser",ok,response,requestParams);
               }
               else if(action == "declareWar")
               {
                  alliancesController.notificationsNotify("declareWar",ok,response,requestParams);
               }
               else if(action == "warHistory")
               {
                  alliancesController.notificationsNotify("requestWarHistory",ok,{"wars":response},requestParams);
               }
               else if(action == "getNews")
               {
                  alliance = alliancesController.getMyAlliance();
                  if(alliance != null)
                  {
                     (responseToController = {}).News = {
                        "totalNews":alliance.getNewsTotal(),
                        "theNew":response
                     };
                     alliancesController.notificationsNotify("requestNews",ok,responseToController,requestParams);
                  }
               }
               else if(action == "getShuffledSuggestedAlliances" || action == "shuffledSuggestedAlliances")
               {
                  DCDebug.traceCh("ALLIANCES","responseStr: " + responseString);
                  getOneAllianceFromAlliancesWarSuggested(responseString,requestParams["type"]);
               }
            }
         }
         else if(cmd == "logOK")
         {
            mUserAccountId = dataObj["userId"];
            mUserIsVIP = int(dataObj["vip"]) != 0;
            DCDebug.allowConsoleVisible = mUserIsVIP;
            mUserHasScoreDisplays = true;
            mServerCurrentTimeMillis = Number(dataObj["currentTimeMillis"]);
            this.mMyAccountIsLocked = int(dataObj["myAccountIsLocked"]) != 0;
            if(dataObj.hasOwnProperty("token"))
            {
               Server_Echo(this.mServer).setToken(dataObj["token"]);
            }
            if(dataObj.hasOwnProperty("init"))
            {
               Server_Echo(this.mServer).setARC4InKey(dataObj["init"]);
            }
            DCDebug.traceChObject("SERVER",dataObj);
         }
         else if(cmd == "logKO")
         {
            if(Config.IGNORE_LOGOUT)
            {
               return;
            }
            InstanceMng.getUserDataMng().updateProfile_crash("LogKO",{"response":responseObj});
            this.mServer.logout();
         }
         else if(cmd == "logOut")
         {
            if(Config.IGNORE_LOGOUT)
            {
               return;
            }
            InstanceMng.getUserDataMng().updateProfile_crash("LogOut",{"response":responseObj});
            this.mServer.logout();
            logout();
            if((type = String(dataObj["type"])) == "underAttack")
            {
               Application.externalNotification(27,dataObj);
            }
            else
            {
               Application.externalNotification(1,dataObj);
            }
            if(dataObj.hasOwnProperty("text"))
            {
               DCDebug.traceCh("SERVER","*******************");
               DCDebug.traceCh("SERVER","*** OUT-OF-SYNC ***");
               DCDebug.traceCh("SERVER","*** " + dataObj["text"]);
               DCDebug.traceCh("SERVER","*******************");
               DCDebug.traceCh("outOfSync","*******************");
               DCDebug.traceCh("outOfSync","*** Type: " + dataObj["type"]);
               DCDebug.traceCh("outOfSync","*** " + dataObj["text"]);
               DCDebug.traceCh("outOfSync","*******************");
            }
         }
         else if(cmd == "purchaseCreditsStatus")
         {
            Application.externalNotification(13,dataObj);
         }
         else if(cmd == "completeRefining")
         {
            this.handleCompleteRefiningResponse(dataObj);
         }
         else if(cmd == "receiveNpcAttack")
         {
            ruleMng = InstanceMng.getRuleMng();
            sku = String(dataObj["sku"]);
            InstanceMng.getUnitScene().openShowIncomingAttackPopup(ruleMng.npcsGetAttack(sku),ruleMng.npcsGetNpcSku(sku),ruleMng.npcsGetDeployX(sku),ruleMng.npcsGetDeployY(sku),ruleMng.npcsGetDeployWay(sku),ruleMng.npcsGetDuration(sku));
         }
         else if(cmd == "updateDailyReward")
         {
            InstanceMng.getDailyRewardMng().notificationsNotify(action,int(dataObj["success"]) != 0,dataObj);
         }
         else if(cmd == "updateServerState")
         {
            if(action == "maintenanceEnabled")
            {
               if(dataObj.hasOwnProperty("timestamp"))
               {
                  InstanceMng.getUserInfoMng().getProfileLogin().setMaintenanceEnabledTimestamp(dataObj["timestamp"]);
               }
            }
         }
         else if(cmd == "challenge")
         {
            if(action == "doCalc")
            {
               count = uint(dataObj["count"]);
               position = Number(dataObj["position"]);
               (challengeResult = {})["action"] = "finishCalc";
               challengeResult["result"] = CheatManager.getInstance().calculateHash(position,count);
               this.mServer.sendCommandNow("challenge",challengeResult);
            }
            else if(action == "doVerify")
            {
               resultS = CheatManager.getInstance().getClientData();
               (verifyResult = new {}())["action"] = "doVerify";
               verifyResult["result"] = resultS;
               this.mServer.sendCommandNow("challenge",verifyResult);
            }
         }
      }
      
      private function handleCompleteRefiningResponse(dataObj:Object) : void
      {
         var sku:String = null;
         var refineryWio:WorldItemObject = null;
         var x:int = 0;
         var y:int = 0;
         var itemObject:ItemObject = null;
         if(dataObj["success"] == true)
         {
            sku = String(dataObj["sku"]);
            if((refineryWio = InstanceMng.getWorld().itemsGetRefinery()) == null)
            {
               refineryWio = InstanceMng.getWorld().itemsGetHeadquarters();
            }
            x = refineryWio.mViewCenterWorldX;
            y = refineryWio.mViewCenterWorldY;
            itemObject = InstanceMng.getItemsMng().getItemObjectBySku(sku);
            if(itemObject != null)
            {
               InstanceMng.getItemsMng().getCollectibleItemsParticle(sku,x,y);
            }
            InstanceMng.getUserInfoMng().getProfileLogin().setRefiningSku("");
         }
      }
      
      private function onBrowserResponse(evt:BrowserEvent) : void
      {
         var success:* = false;
         var selectedFriendsIds:Array = null;
         var action:String = null;
         var extId:String = null;
         var requestId:String = null;
         var responseObj:Object;
         var task:String = String((responseObj = evt.params)["task"]);
         var data:Object = responseObj["data"];
         DCDebug.traceCh("JavaScript","<<< response TASK: " + task);
         DCDebug.traceChObject("JavaScript",data);
         if(task == "messageCenter")
         {
            Application.externalNotification(4,data);
         }
         else if(task == "investmentSent")
         {
            if(success = int(data["status"]) != 0)
            {
               selectedFriendsIds = data["to"] as Array;
               this.updateInvest_investInFriends_callBack(selectedFriendsIds);
               Application.externalNotification(22,{"extIds":selectedFriendsIds});
            }
         }
         else if(task == "friendsFromPlatform")
         {
            this.mRequestFriendsAndNeighborsToServerAllowed = true;
         }
         else if(task == "bridgeJavaScriptWithServer")
         {
            data["action"] = "bridgeJavaScriptWithServer";
            this.mUpdateExternalNotifications.push(data);
         }
         else if(task == "purchaseCreditsStatus")
         {
            this.queryVerifyCreditsPurchase(true);
         }
         else
         {
            DCDebug.trace("sending task: " + task);
            data.cmd = task;
            Application.externalNotification(4,data);
         }
      }
      
      override public function openNeighborsTab(params:Object = null) : void
      {
         if(params == null)
         {
            params = {};
         }
         InstanceMng.getApplication().setToWindowedMode();
         this.mBrowser.taskRequest("inviteFriends",params);
      }
      
      public function updateProfile(data:Object, transaction:Transaction = null) : void
      {
         if(transaction != null)
         {
            data["transaction"] = this.createTransactionObject(transaction);
         }
         this.mServer.sendCommand("updateProfile",data);
      }
      
      private function updateItem(data:Object, transaction:Transaction = null, socialItems:Array = null) : void
      {
         if(transaction != null)
         {
            data["transaction"] = this.createTransactionObject(transaction);
         }
         data["planetId"] = InstanceMng.getUserInfoMng().getProfileLogin().getCurrentPlanetId();
         this.mServer.sendCommand("updateItem",data);
      }
      
      private function updateShips(data:Object, transaction:Transaction = null) : void
      {
         if(transaction != null)
         {
            data["transaction"] = this.createTransactionObject(transaction);
         }
         data["s"] = Math.floor(mGameRunningMillis / 1000);
         this.mServer.sendCommand("updateShips",data);
      }
      
      private function updateMissions(data:Object, transaction:Transaction = null) : void
      {
         if(transaction != null)
         {
            data["transaction"] = this.createTransactionObject(transaction);
         }
         this.mServer.sendCommand("updateMissions",data);
      }
      
      private function updateTargets(data:Object, transaction:Transaction = null) : void
      {
         if(this.mAttackingUniverse)
         {
            if(data["action"] == "addProgress")
            {
               this.updateTargetsCacheAdd(data);
               return;
            }
         }
         if(transaction != null)
         {
            data["transaction"] = this.createTransactionObject(transaction);
         }
         this.mServer.sendCommand("updateTargets",data);
      }
      
      private function updateGameUnits(data:Object, transaction:Transaction = null) : void
      {
         if(transaction != null)
         {
            data["transaction"] = this.createTransactionObject(transaction);
         }
         this.mServer.sendCommand("updateGameUnits",data);
      }
      
      private function updateVisitHelp(data:Object, transaction:Transaction = null) : void
      {
         if(transaction != null)
         {
            data["transaction"] = this.createTransactionObject(transaction);
         }
         this.mServer.sendCommand("updateVisitHelp",data);
      }
      
      private function updateMisc(data:Object, transaction:Transaction = null) : void
      {
         if(transaction != null)
         {
            data["transaction"] = this.createTransactionObject(transaction);
         }
         this.mServer.sendCommand("updateMisc",data);
      }
      
      private function updateBattle(data:Object, transaction:Transaction = null, transactionTarget:Transaction = null, sendNow:Boolean = false) : void
      {
         if(data["action"] != "battleDamagesPack" && data["action"] != "itemDamaged" && data["action"] != "unitDamaged")
         {
            DCDebug.traceCh("Battle","===================>\n* updateBattle_" + data["action"]);
            DCDebug.traceChObject("Battle",data);
         }
         if(transaction != null)
         {
            data["transaction"] = this.createTransactionObject(transaction);
         }
         if(transactionTarget != null)
         {
            data["transactionTarget"] = this.createTransactionObject(transactionTarget);
         }
         if(this.mBattleSignatureNow == this.mBattleSignatureFirst && (data["action"] == "deployUnits" || data["action"] == "specialAttack") && !this.mBattleSignatureDoneInFirstDeploy)
         {
            this.mBattleSignatureDoneInFirstDeploy = true;
            this.mBattleSignatureNow = InstanceMng.getRuleMng().sigGetBattleSig(true);
         }
         if(true)
         {
            if(data["action"] == "itemDamaged")
            {
               this.itemDamagedCacheAdd(data);
               return;
            }
            if(data["action"] == "unitDamaged")
            {
               this.unitDamagedCacheAdd(data);
               return;
            }
            if(data["action"] == "itemMineExploded")
            {
               this.itemMineExplodedCacheAdd(data);
               return;
            }
            if(data["action"] == "deployUnits" || data["action"] == "specialAttack")
            {
               this.deployUnitsCacheAdd(data);
               return;
            }
            if(data["action"] == "umbrellaDamaged")
            {
               this.umbrellaDamagedCacheAdd(data);
               return;
            }
         }
         if(sendNow)
         {
            this.mServer.sendCommandNow("updateBattle",data);
         }
         else
         {
            this.mServer.sendCommand("updateBattle",data);
         }
      }
      
      private function updateSocialItem(data:Object, transaction:Transaction = null) : void
      {
         var sku:String = null;
         var def:ItemsDef = null;
         if(this.mAttackingUniverse && InstanceMng.getUnitScene().actualBattleIsRunning())
         {
            sku = String(data["sku"]);
            def = InstanceMng.getItemsMng().getItemObjectBySku(sku).mDef;
            if(def.getGivingCondition() == null)
            {
               this.mServer.sendCommand("updateSocialItem",data);
               return;
            }
            this.updateSocialItemCacheAdd(data);
            return;
         }
         if(transaction != null)
         {
            data["transaction"] = this.createTransactionObject(transaction);
         }
         this.mServer.sendCommand("updateSocialItem",data);
      }
      
      private function updateStarsBookmarks(data:Object) : void
      {
         this.mServer.sendCommand("updateStarsBookmarks",data);
      }
      
      private function updateTemplates(data:Object) : void
      {
         this.mServer.sendCommand("updateTemplates",data);
      }
      
      private function updatePoll(data:Object) : void
      {
      }
      
      private function updateExternalNotification(data:Object) : void
      {
         this.mServer.sendCommand("updateExternalNotification",data);
      }
      
      private function updateAlliances(data:Object, transaction:Transaction = null) : void
      {
         if(transaction != null)
         {
            data["transaction"] = this.createTransactionObject(transaction);
         }
         DCDebug.traceCh("ALLIANCES","----------------------");
         DCDebug.traceCh("ALLIANCES"," sendAlliances:");
         DCDebug.traceChObject("ALLIANCES",data);
         DCDebug.traceCh("ALLIANCES","----------------------");
         DCDebug.traceCh("ALLIANCES","");
         this.mServer.sendCommandNow("updateAlliances",data);
      }
      
      private function updateInvestments(data:Object, transaction:Transaction = null, sendNow:Boolean = false) : void
      {
         if(transaction != null)
         {
            data["transaction"] = this.createTransactionObject(transaction);
         }
         if(sendNow)
         {
            this.mServer.sendCommandNow("updateInvestments",data);
         }
         else
         {
            this.mServer.sendCommand("updateInvestments",data);
         }
      }
      
      private function updateHappening(data:Object, transaction:Transaction = null) : void
      {
         if(transaction != null)
         {
            data["transaction"] = this.createTransactionObject(transaction);
         }
         this.mServer.sendCommand("updateHappening",data);
      }
      
      private function updateContest(data:Object, transaction:Transaction = null) : void
      {
         if(transaction != null)
         {
            data["transaction"] = this.createTransactionObject(transaction);
         }
         this.mServer.sendCommand("updateContest",data);
      }
      
      private function updateBets(data:Object, transaction:Transaction = null) : void
      {
         if(transaction != null)
         {
            data["transaction"] = this.createTransactionObject(transaction);
         }
         this.mServer.sendCommandNow("updateBets",data);
      }
      
      override public function updateBattle_ping() : void
      {
         var data:Object = {};
         data["action"] = "ping";
         this.updateBattle(data);
      }
      
      override public function updateBattle_umbrellaDamaged(damage:int) : void
      {
         var data:Object = {};
         data["action"] = "umbrellaDamaged";
         data["damage"] = damage;
         this.updateBattle(data);
      }
      
      override public function updateBets_requestBet(betSku:String) : void
      {
         this.mBetSku = betSku;
         this.mBetsCount = 500000;
         this.mBetsTimer = 0;
         this.mBetsWaitingResponse = false;
      }
      
      private function updateBets_logicUpdate(dt:int) : void
      {
         if(this.mBetsCount <= 0 || this.mBetsWaitingResponse)
         {
            return;
         }
         if(this.mBetsTimer > 0)
         {
            this.mBetsTimer -= dt;
            return;
         }
         this.mBetsCount--;
         this.mBetsTimer = 5000;
         this.mBetsWaitingResponse = true;
         var data:Object = {};
         data["action"] = "requestBet";
         data["sku"] = this.mBetSku;
         this.updateBets(data);
      }
      
      override public function updateBets_cancelRequestBet() : void
      {
         this.mBetsCount = 0;
         this.mBetsTimer = 0;
         this.mBetsWaitingResponse = false;
         var data:Object = {};
         data["action"] = "cancelRequestBet";
         this.updateBets(data);
      }
      
      override public function updateBets_requestResult(sku:String) : void
      {
         var data:Object = {};
         data["action"] = "requestResult";
         data["sku"] = sku;
         this.updateBets(data);
      }
      
      override public function updateBets_closeBet(transaction:Transaction) : void
      {
         var data:Object = {};
         data["action"] = "closeBet";
         this.updateBets(data,transaction);
      }
      
      override public function updateBets_timeUp() : void
      {
         var data:Object = {};
         data["action"] = "timeUp";
         this.updateBets(data);
      }
      
      override public function updateProfile_tutorialCompleted() : void
      {
         var data:Object = {};
         data["action"] = "tutorialCompleted";
         this.updateProfile(data);
         this.mBrowser.taskRequest("tutorialCompleted");
         this.setNeedsToVerifyCreditsPurchase(true);
      }
      
      override public function updateProfile_exchangeCashToCoins(cash:Number, coins:Number) : void
      {
         var data:Object = {};
         data["action"] = "exchangeCashToCoins";
         data["cash"] = cash;
         data["coins"] = coins;
         this.updateProfile(data);
      }
      
      override public function updateProfile_exchangeCashToMinerals(cash:Number, minerals:Number) : void
      {
         var data:Object = {};
         data["action"] = "exchangeCashToMinerals";
         data["cash"] = cash;
         data["minerals"] = minerals;
         this.updateProfile(data);
      }
      
      override public function updateProfile_buyCash(cash:Number) : void
      {
         var data:Object = {};
         data["action"] = "buyCash";
         data["cash"] = cash;
         this.updateProfile(data);
      }
      
      override public function updateProfile_buyDroid(sku:String, transaction:Transaction) : void
      {
         var data:Object = {};
         data["action"] = "buyDroid";
         data["sku"] = sku;
         data["transType"] = transaction.getTransType();
         this.updateProfile(data,transaction);
      }
      
      override public function updateProfile_buyDamageProtectionTime(sku:String, transaction:Transaction = null) : void
      {
         var data:Object = {};
         data["action"] = "buyDamageProtectionTime";
         data["sku"] = sku;
         this.updateProfile(data,transaction);
      }
      
      override public function updateProfile_levelUp(level:int, transaction:Transaction) : void
      {
         var data:Object = {};
         data["action"] = "levelUp";
         data["level"] = level;
         this.updateProfile(data,transaction);
      }
      
      override public function updateProfile_setFlag(key:String, value:Object, transaction:Transaction = null) : void
      {
         var data:Object;
         (data = {})["action"] = "setFlag";
         data["key"] = key;
         data["value"] = value;
         this.updateProfile(data,transaction);
      }
      
      override public function updateProfile_removeFlag(key:String) : void
      {
         var data:Object = {};
         data["action"] = "removeFlag";
         data["key"] = key;
         this.updateProfile(data);
      }
      
      override public function updateProfile_cheater(type:String, info:Object) : void
      {
         var data:Object = {};
         data["action"] = "cheater";
         data["type"] = type;
         data["info"] = info;
         this.updateProfile(data);
      }
      
      override public function updateProfile_crash(type:String, info:Object) : void
      {
         var data:Object = {};
         data["action"] = "crash";
         data["type"] = type;
         data["info"] = info;
         this.updateProfile(data);
      }
      
      override public function updateItem_newItem(item:XML, transaction:Transaction = null) : void
      {
         var data:Object = {};
         data["action"] = "newItem";
         data["item"] = Server.XMLToObject(item);
         this.updateItem(data,transaction);
      }
      
      override public function updateItem_newState(sid:int, oldState:int, newState:int, newMode:int, newTime:Number, timePassed:Number, hasBonus:Boolean, incomeToRestore:int, transaction:Transaction) : void
      {
         var data:Object;
         (data = {})["action"] = "newState";
         data["sid"] = sid;
         data["oldState"] = oldState;
         data["newState"] = newState;
         data["time"] = newTime;
         data["timePassed"] = timePassed;
         if(incomeToRestore > 0)
         {
            data["incomeToRestore"] = incomeToRestore;
         }
         if(hasBonus)
         {
            data["hasBonus"] = 1;
         }
         this.updateItem(data,transaction);
      }
      
      override public function updateItem_newStates(items:Array, transaction:Transaction) : void
      {
         var i:int = 0;
         var item:Object = null;
         var data:Object;
         (data = {})["action"] = "newStates";
         data["items"] = [];
         for(i = 0; i < items.length; )
         {
            item = items[i];
            data["items"].push({
               "sid":item.sid,
               "oldState":item.oldState,
               "newState":item.newState,
               "time":item.time,
               "timePassed":item.timePassed,
               "incomeToRestore":item.incomeToRestore,
               "hasBonus":item.hasBonus,
               "upgradeId":item.upgradeId
            });
            i++;
         }
         this.updateItem(data,transaction);
      }
      
      override public function updateItem_rotate(sid:int, newX:int, newY:int, isFlipped:Boolean) : void
      {
         var data:Object;
         (data = {})["action"] = "rotate";
         data["sid"] = sid;
         data["x"] = newX;
         data["y"] = newY;
         data["flip"] = isFlipped ? 1 : 0;
         this.updateItem(data);
      }
      
      override public function updateItem_move(sid:int, newX:int, newY:int) : void
      {
         var data:Object;
         (data = {})["action"] = "move";
         data["sid"] = sid;
         data["x"] = newX;
         data["y"] = newY;
         this.updateItem(data);
      }
      
      override public function updateItem_moveAll(items:Array) : void
      {
         var i:int = 0;
         var data:Object = {};
         data["action"] = "moveAll";
         data["items"] = [];
         for(i = 0; i < items.length; )
         {
            data["items"].push({
               "sid":items[i],
               "x":items[i + 1],
               "y":items[i + 2]
            });
            i += 3;
         }
         this.updateItem(data);
      }
      
      override public function updateItem_cancelBuild(sid:int, transaction:Transaction = null) : void
      {
         var data:Object = {};
         data["action"] = "cancelBuild";
         data["sid"] = sid;
         this.updateItem(data,transaction);
      }
      
      override public function updateItem_cancelUpgrade(sid:int, newTime:Number, transaction:Transaction = null) : void
      {
         var data:Object;
         (data = {})["action"] = "cancelUpgrade";
         data["sid"] = sid;
         data["time"] = newTime;
         this.updateItem(data,transaction);
      }
      
      override public function updateItem_instantRecicle(sid:int, transaction:Transaction = null) : void
      {
         var data:Object = {};
         data["action"] = "instantRecicle";
         data["sid"] = sid;
         this.updateItem(data,transaction);
      }
      
      override public function updateItem_upgradePremium(sid:int, newUpgradeId:int, newTime:Number, incomeToRestore:int, transaction:Transaction) : void
      {
         var data:Object;
         (data = {})["action"] = "upgradePremium";
         data["sid"] = sid;
         data["newUpgradeId"] = newUpgradeId;
         data["time"] = newTime;
         if(incomeToRestore > 0)
         {
            data["incomeToRestore"] = incomeToRestore;
         }
         this.updateItem(data,transaction);
      }
      
      override public function updateItem_destroy(sid:int, transaction:Transaction = null) : void
      {
         var data:Object = {};
         data["action"] = "destroy";
         data["sid"] = sid;
         this.updateItem(data,transaction);
      }
      
      override public function updateShips_shipAdded(sid:int, sku:String, slot:int, timeLeft:Number, transaction:Transaction = null) : void
      {
         var data:Object;
         (data = {})["action"] = "shipAdded";
         data["sid"] = sid;
         data["sku"] = sku;
         data["slot"] = slot;
         data["timeLeft"] = timeLeft;
         this.updateShips(data,transaction);
      }
      
      override public function updateShips_shipRemoved(sid:int, sku:String, slot:int, transaction:Transaction = null) : void
      {
         var data:Object;
         (data = {})["action"] = "shipRemoved";
         data["sid"] = sid;
         data["sku"] = sku;
         data["slot"] = slot;
         this.updateShips(data,transaction);
      }
      
      override public function updateShips_shipCompleted(sid:int, sku:String, hangarSid:int) : void
      {
         var data:Object;
         (data = {})["action"] = "shipCompleted";
         data["sid"] = sid;
         data["sku"] = sku;
         data["hangarSid"] = hangarSid;
         this.updateShips(data);
      }
      
      override public function updateShips_speedUp(sid:int, slotsContentsAccelerated:Array, transaction:Transaction) : void
      {
         var data:Object;
         (data = {})["action"] = "speedUp";
         data["sid"] = sid;
         data["slotsContentsAccelerated"] = slotsContentsAccelerated;
         this.updateShips(data,transaction);
      }
      
      override public function updateShips_block(sid:int, block:Boolean) : void
      {
         var data:Object = {};
         data["action"] = "block";
         data["sid"] = sid;
         data["block"] = block ? 1 : 0;
         this.updateShips(data);
      }
      
      override public function updateShips_moveFromHangarToBunker(unitSku:String, amount:int, hangarSid:int, bunkerSid:int, bunkerUnitsInfo:Object, transaction:Transaction = null) : void
      {
         var data:Object;
         (data = {})["action"] = "moveFromHangarToBunker";
         data["unitSku"] = unitSku;
         data["amount"] = amount;
         data["hangarSid"] = hangarSid;
         data["bunkerSid"] = bunkerSid;
         data["bunkerUnitsInfo"] = bunkerUnitsInfo;
         this.updateShips(data,transaction);
      }
      
      override public function updateShips_killUnitFromHangar(unitSku:String, hangarSid:int, transaction:Transaction = null) : void
      {
         var data:Object;
         (data = {})["action"] = "killUnitFromHangar";
         data["unitSku"] = unitSku;
         data["hangarSid"] = hangarSid;
         this.updateShips(data,transaction);
      }
      
      override public function updateShips_killUnitFromBunker(unitSku:String, bunkerSid:int, transaction:Transaction = null) : void
      {
         var data:Object;
         (data = {})["action"] = "killUnitFromBunker";
         data["unitSku"] = unitSku;
         data["bunkerSid"] = bunkerSid;
         this.updateShips(data,transaction);
      }
      
      override public function updateShips_addSlot(sid:int, transaction:Transaction = null) : void
      {
         var data:Object = {};
         data["action"] = "addSlot";
         data["sid"] = sid;
         this.updateShips(data,transaction);
      }
      
      override public function updateShips_giftUnitToHangar(unitSku:String, amount:int, hangarSid:int, transaction:Transaction = null) : void
      {
         var data:Object;
         (data = {})["action"] = "giftUnitToHangar";
         data["unitSku"] = unitSku;
         data["amount"] = amount;
         data["hangarSid"] = hangarSid;
         this.updateShips(data,transaction);
      }
      
      override public function updateMissions_newState(sku:String, state:int, transaction:Transaction = null, rewardItemSku:String = "") : void
      {
         var data:Object;
         (data = {})["action"] = "newState";
         data["sku"] = sku;
         data["state"] = state;
         this.updateMissions(data,transaction);
      }
      
      override public function updateTargets_addProgress(sku:String, subTargetIndex:int, amount:int, transaction:Transaction = null) : void
      {
         if(amount == 0)
         {
            return;
         }
         var data:Object;
         (data = {})["action"] = "addProgress";
         data["sku"] = sku;
         data["subTargetIndex"] = subTargetIndex;
         data["amount"] = amount;
         this.updateTargets(data,transaction);
      }
      
      override public function updateGameUnits_unlockStart(sku:String, timeLeft:Number, transaction:Transaction = null) : void
      {
         var data:Object;
         (data = {})["action"] = "unlockStart";
         data["sku"] = sku;
         data["timeLeft"] = timeLeft;
         this.updateGameUnits(data,transaction);
      }
      
      override public function updateGameUnits_unlockCancel(sku:String, transaction:Transaction = null) : void
      {
         var data:Object = {};
         data["action"] = "unlockCancel";
         data["sku"] = sku;
         this.updateGameUnits(data,transaction);
      }
      
      override public function updateGameUnits_unlockCompleted(sku:String, transaction:Transaction = null) : void
      {
         var data:Object = {};
         data["action"] = "unlockCompleted";
         data["sku"] = sku;
         this.updateGameUnits(data,transaction);
      }
      
      override public function updateGameUnits_upgradeStart(sku:String, upgradeId:int, timeLeft:Number, transaction:Transaction = null) : void
      {
         var data:Object;
         (data = {})["action"] = "upgradeStart";
         data["sku"] = sku;
         data["upgradeId"] = upgradeId;
         data["timeLeft"] = timeLeft;
         this.updateGameUnits(data,transaction);
      }
      
      override public function updateGameUnits_upgradeCompleted(sku:String, upgradeId:int, transaction:Transaction = null) : void
      {
         var data:Object;
         (data = {})["action"] = "upgradeCompleted";
         data["sku"] = sku;
         data["upgradeId"] = upgradeId;
         this.updateGameUnits(data,transaction);
      }
      
      override public function updateGameUnits_upgradeCancel(sku:String, upgradeId:int, transaction:Transaction = null) : void
      {
         var data:Object;
         (data = {})["action"] = "upgradeCancel";
         data["sku"] = sku;
         data["upgradeId"] = upgradeId;
         this.updateGameUnits(data,transaction);
      }
      
      override public function updateBattle_deployUnits(hangarSid:int, socialItem:String, unitsSkus:Array, unitsIds:Array, shotWaitingTimes:Array, shotDamages:Array, energies:Array, x:int, y:int, tileX:int, tileY:int, transaction:Transaction = null) : void
      {
         var data:Object;
         (data = {})["action"] = "deployUnits";
         data["hangarSid"] = hangarSid;
         data["unitsSkus"] = unitsSkus;
         data["unitsIds"] = unitsIds;
         if(socialItem != null && socialItem.length > 0)
         {
            data["socialItemSku"] = socialItem;
         }
         data["skuE"] = energies;
         data["skuSD"] = shotDamages;
         data["skuSWT"] = shotWaitingTimes;
         data["x"] = x;
         data["y"] = y;
         data["tileX"] = tileX;
         data["tileY"] = tileY;
         data["millis"] = mPlanetRunningMillis;
         this.updateBattle(data,transaction);
      }
      
      override public function updateBattle_unitDamaged(unitId:int, fromBunkerSid:int, damage:int, unitSku:String, destroyed:Boolean, energyBeforeShot:int, attackerInfo:Object, transaction:Transaction = null) : void
      {
         var data:Object;
         (data = {})["action"] = "unitDamaged";
         data["unitId"] = unitId;
         data["unitSku"] = unitSku;
         data["damage"] = damage;
         data["energyBeforeShot"] = energyBeforeShot;
         data["destroyed"] = destroyed ? 1 : 0;
         data["fromBunkerSid"] = fromBunkerSid;
         var type:String = String(attackerInfo["type"]);
         var attackerStr:String = damage + ":" + type;
         if(type == "unit")
         {
            attackerStr = damage + ":u:" + attackerInfo["unitId"];
            if(int(attackerInfo["shotBlastDistanceSqr"]) > 0)
            {
               attackerStr += ":" + attackerInfo["shotBlastDistanceSqr"];
            }
         }
         else if(type == "item")
         {
            attackerStr = damage + ":i:" + attackerInfo["itemSid"];
            if(attackerInfo.hasOwnProperty("shotBlast"))
            {
               attackerStr += ":" + attackerInfo["shotBlast"];
            }
            if(attackerInfo.hasOwnProperty("powerUpSkus"))
            {
               attackerStr += ":pu=" + attackerInfo["powerUpSkus"];
            }
         }
         data["attackers"] = new Array(attackerStr);
         var unitWasDeployed:*;
         if((unitWasDeployed = fromBunkerSid < 0) || destroyed)
         {
            this.updateBattle(data,transaction);
         }
      }
      
      override public function updateBattle_itemDamaged(itemSid:int, damage:int, umbrellaDamage:int, destroyed:Boolean, energyBeforeShot:int, attackerInfo:Object, tVictim:Transaction = null, tAttacker:Transaction = null, bunkerContent:Object = null) : void
      {
         var data:Object;
         (data = {})["action"] = "itemDamaged";
         data["itemSid"] = itemSid;
         data["damage"] = damage;
         data["umbrellaDamage"] = umbrellaDamage;
         data["energyBeforeShot"] = energyBeforeShot;
         data["destroyed"] = destroyed ? 1 : 0;
         if(bunkerContent != null)
         {
            data["bunkerContent"] = bunkerContent;
         }
         var type:String = String(attackerInfo["type"]);
         var attackerStr:String = damage + ":" + type;
         if(type == "unit")
         {
            attackerStr = (attackerStr = (attackerStr = (attackerStr = damage + ":u:" + attackerInfo["unitId"]) + ":" + attackerInfo["sku"]) + ":" + attackerInfo["positionX"]) + ":" + attackerInfo["positionY"];
            if(int(attackerInfo["shotBlastDistanceSqr"]) > 0)
            {
               attackerStr += ":" + attackerInfo["shotBlastDistanceSqr"];
            }
         }
         else if(type == "item")
         {
            attackerStr = damage + ":i:" + attackerInfo["itemSid"];
         }
         else if(type == "specialAttack")
         {
            if(attackerInfo["unit"] != null)
            {
               attackerStr += ":" + attackerInfo["specialAttackId"];
            }
            else
            {
               attackerStr += ":-1";
            }
            attackerStr += ":" + attackerInfo["bullet"];
            if(int(attackerInfo["shotBlastDistanceSqr"]) > 0)
            {
               attackerStr += ":" + attackerInfo["shotBlastDistanceSqr"];
            }
         }
         data["attackers"] = new Array(attackerStr);
         this.updateBattle(data,tAttacker,tVictim);
      }
      
      override public function updateBattle_itemMineExploded(itemSid:int) : void
      {
         var data:Object = {};
         data["action"] = "itemMineExploded";
         data["itemSid"] = itemSid;
         this.updateBattle(data);
      }
      
      override public function updateBattle_specialAttack_usingCash(sku:String, x:int, y:int, unitsSkus:Array, unitsIds:Array, specialAttackId:int, transaction:Transaction = null) : void
      {
         var data:Object;
         (data = {})["action"] = "specialAttack";
         data["sku"] = sku;
         data["x"] = x;
         data["y"] = y;
         data["millis"] = mPlanetRunningMillis;
         data["unitsSkus"] = unitsSkus;
         data["unitsIds"] = unitsIds;
         data["id"] = specialAttackId;
         this.updateBattle(data,transaction);
      }
      
      override public function updateBattle_specialAttack_usingItem(socialItemSku:String, x:int, y:int, unitsSkus:Array, unitsIds:Array, specialAttackId:int) : void
      {
         var data:Object;
         (data = {})["action"] = "specialAttack";
         data["socialItemSku"] = socialItemSku;
         data["x"] = x;
         data["y"] = y;
         data["millis"] = mPlanetRunningMillis;
         data["unitsSkus"] = unitsSkus;
         data["unitsIds"] = unitsIds;
         data["id"] = specialAttackId;
         this.updateBattle(data);
      }
      
      override public function updateBattle_preStartTimeout() : void
      {
         var data:Object = {};
         data["action"] = "preStartTimeout";
         this.updateBattle(data,null,null,true);
      }
      
      override public function updateBattle_started(transaction:Transaction) : void
      {
         var data:Object = {};
         data["action"] = "started";
         this.updateBattle(data,transaction,null,true);
         this.mBattleIsOn = true;
      }
      
      override public function updateBattle_finished(battleTime:Number, coinsStolen:Number = 0, coinsMax:Number = 0, mineralsStolen:Number = 0, mineralsMax:Number = 0, score:Number = 0, scoreMax:Number = 0) : void
      {
         if(!this.mBattleIsOn)
         {
            return;
         }
         this.mBattleIsOn = false;
         this.battleDamagesCacheFlush();
         var data:Object;
         (data = {})["action"] = "finished";
         data["millis"] = mPlanetRunningMillis;
         data["battleDuration"] = battleTime;
         data["deltaScore"] = Math.max(0,Math.floor(InstanceMng.getUserInfoMng().getProfileLogin().getScore()) - this.mBattleStartWithScore);
         if(coinsStolen > 0 && coinsMax > 0)
         {
            data["coinsStolen"] = coinsStolen;
            data["coinsMax"] = coinsMax;
         }
         if(mineralsStolen > 0 && mineralsMax > 0)
         {
            data["mineralsStolen"] = mineralsStolen;
            data["mineralsMax"] = mineralsMax;
         }
         if(score > 0 && scoreMax > 0)
         {
            data["score"] = score;
            data["scoreMax"] = scoreMax;
         }
         this.updateBattle(data,null,null,true);
         DCDebug.traceCh("Battle","********************\nSENDING FINISHING BATTLE with data:");
         DCDebug.traceChObject("Battle",data);
         DCDebug.traceCh("Battle","********************");
         this.mServer.forceSendAllCommandsDangerously();
         this.flushAllPendingCommandsToServer();
      }
      
      override public function updateBattle_npcAttackStart(happeningSku:String, activePowerUps:String) : void
      {
         this.battleDamagesCacheInit();
         var data:Object = {};
         data["action"] = "npcAttackStart";
         if(happeningSku != null && happeningSku.length > 0)
         {
            data["happeningSku"] = happeningSku;
         }
         if(activePowerUps != null && activePowerUps.length > 0)
         {
            data["activePowerUps"] = activePowerUps;
         }
         this.updateBattle(data);
         this.mBattleIsOn = true;
      }
      
      override public function updateSocialItem_nextStep(sku:String, sequence:Boolean, position:Boolean, currentSequence:int, currentPosition:int, currentCount:int, currentQuantity:int) : void
      {
         var data:Object;
         (data = {})["action"] = "nextStep";
         data["sku"] = sku;
         data["sequence"] = sequence ? 1 : 0;
         data["postion"] = position ? 1 : 0;
         data["currentSequence"] = currentSequence;
         data["currentPosition"] = currentPosition;
         data["currentCount"] = currentCount;
         data["currentQuantity"] = currentQuantity;
         this.updateSocialItem(data);
      }
      
      override public function updateSocialItem_addItem(sku:String, amount:int) : void
      {
         var data:Object = {};
         data["action"] = "addItem";
         data["sku"] = sku;
         data["amount"] = amount;
         this.updateSocialItem(data);
      }
      
      override public function updateSocialItem_useItem(sku:String, amount:int) : void
      {
         var data:Object = {};
         data["action"] = "useItem";
         data["sku"] = sku;
         data["amount"] = amount;
         this.updateSocialItem(data);
      }
      
      override public function updateSocialItem_buyItem(sku:String, transaction:Transaction = null) : void
      {
         var data:Object = {};
         data["action"] = "buyItem";
         data["sku"] = sku;
         this.updateSocialItem(data,transaction);
      }
      
      override public function updateSocialItem_removeItem(sku:String, amount:int) : void
      {
         var data:Object = {};
         data["action"] = "removeItem";
         data["sku"] = sku;
         data["amount"] = amount;
         this.updateSocialItem(data);
      }
      
      override public function updateSocialItem_applyCrafting(sku:String, transaction:Transaction = null) : void
      {
         var data:Object = {};
         data["action"] = "applyCrafting";
         data["sku"] = sku;
         this.updateSocialItem(data,transaction);
      }
      
      override public function updateSocialItem_applyCollectable(sku:String) : void
      {
         var data:Object = {};
         data["action"] = "applyCollectable";
         data["sku"] = sku;
         this.updateSocialItem(data);
      }
      
      override public function updateSocialItem_addItemToWishList(sku:String) : void
      {
         var data:Object = {};
         data["action"] = "addItemToWishList";
         data["sku"] = sku;
         this.updateSocialItem(data);
      }
      
      override public function updateSocialItem_removeItemFromWishList(sku:String) : void
      {
         var data:Object = {};
         data["action"] = "removeItemFromWishList";
         data["sku"] = sku;
         this.updateSocialItem(data);
      }
      
      override public function sendWishlistItem(itemSku:String, toAccountId:String) : void
      {
         var data:Object = null;
         var userInfo:UserInfo = InstanceMng.getUserInfoMng().getUserInfoObj(toAccountId,0);
         var item:ItemObject;
         if((item = InstanceMng.getItemsMng().getItemObjectBySku(itemSku)) != null && item.quantity > 0)
         {
            (data = {})["sku"] = itemSku;
            data["toAccountId"] = toAccountId;
            this.mServer.sendCommandNow("sendWishListItem",data);
         }
      }
      
      override public function updateVisitHelp_accelerateItem(sid:int, transaction:Transaction = null) : void
      {
         var data:Object = {};
         data["action"] = "accelerateItem";
         data["sid"] = sid;
         this.updateVisitHelp(data,transaction);
      }
      
      override public function updateVisitHelp_dailyBonusDone(coins:Number) : void
      {
         var data:Object = {};
         data["action"] = "dailyBonusDone";
         data["coins"] = coins;
         this.updateVisitHelp(data);
      }
      
      override public function updateVisitHelp_allActionsDone(minerals:Number) : void
      {
         var data:Object = {};
         data["action"] = "allActionsDone";
         data["minerals"] = minerals;
         this.updateVisitHelp(data);
      }
      
      override public function updateMisc_visitHelpDone(neighborAccountId:String, accepted:Boolean, clientHelps:Array = null) : void
      {
         var data:Object;
         (data = {})["action"] = "visitHelpDone";
         data["neighborAccountId"] = neighborAccountId;
         data["accepted"] = accepted ? 1 : 0;
         data["clientHelps"] = clientHelps;
         this.updateMisc(data);
      }
      
      override public function updateMisc_hangarHelpDone(sid:int) : void
      {
         var data:Object = {};
         data["action"] = "bunkerHelpDone";
         data["sid"] = sid;
         data["unitsMovedToBunker"] = Server.XMLToObject(getFileXML(KEY_HANGARS_HELP_LIST));
         this.updateMisc(data);
      }
      
      override public function updateMisc_firstLoadingSuccess(chk:Number) : void
      {
         var seconds:int = 0;
         var interval:int = 0;
         var label:* = null;
         this.mBattleSignatureFirst = this.mBattleSignatureNow = InstanceMng.getRuleMng().sigGetBattleSig(false);
         var data:Object = {};
         data["action"] = "firstLoadingSuccess";
         data["chk"] = chk;
         data["sig"] = this.mBattleSignatureFirst;
         data["whoami"] = "user.mProfileList";
         if(Config.DEBUG_MODE)
         {
            data["debug"] = "true";
         }
         this.updateMisc(data);
         this.mServer.sendCommandNow("queryVerifyCreditsPurchase",{"apply":0});
         if(!this.mFirstLoadingSuccessDone)
         {
            seconds = getGameCurrentTimemillis() / 1000;
            interval = seconds / 5;
            label = "(" + interval * 5 + "->" + (interval + 1) * 5 + ")";
            if(interval > 24)
            {
               label = "(more than 2 minutes)";
            }
            DCDebug.trace("Loading bar elapsed; " + seconds + " seconds, " + label);
         }
         this.mFirstLoadingSuccessDone = true;
      }
      
      override public function updateMisc_pendingTransactionsProcessed(transactionIds:Array) : void
      {
         var data:Object = {};
         data["action"] = "pendingTransactionsProcessed";
         data["transactionIds"] = transactionIds;
         this.updateMisc(data);
      }
      
      override public function updateMisc_spyCapsuleForFree(transaction:Transaction) : void
      {
         var data:Object = {};
         data["action"] = "spyCapsuleForFree";
         this.updateMisc(data,transaction);
      }
      
      override public function updateMisc_spyCapsuleBought(sku:String, transaction:Transaction) : void
      {
         var data:Object = {};
         data["action"] = "spyCapsuleBought";
         data["sku"] = sku;
         this.updateMisc(data,transaction);
      }
      
      override public function updateMisc_upSellingStarted(sku:String) : void
      {
         var data:Object = {};
         data["action"] = "upSellingStarted";
         data["sku"] = sku;
         this.updateMisc(data);
      }
      
      override public function updateMisc_applyPurchasesFromMobileAdjust(oneCreditLocalPrice:Number, currency:String, mobilePaymentSlots:Array) : void
      {
         var data:Object;
         (data = {})["action"] = "applyPurchasesFromMobileAdjust";
         data["oneCreditLocalPrice"] = oneCreditLocalPrice;
         data["currency"] = currency;
         data["mobilePaymentSlots"] = mobilePaymentSlots;
         this.updateMisc(data);
      }
      
      override public function updateBookmarks_addBookmark(coordX:Number, coordY:Number, starName:String, starNameUserGenerated:String, starId:Number, starType:String) : void
      {
         var data:Object;
         (data = {})["action"] = "addBookmark";
         data["coordX"] = coordX;
         data["coordY"] = coordY;
         data["starName"] = starName;
         data["starNameUserGenerated"] = starNameUserGenerated;
         data["starId"] = starId;
         data["starType"] = starType;
         this.updateStarsBookmarks(data);
      }
      
      override public function updateBookmarks_removeBookmark(coordX:Number, coordY:Number) : void
      {
         var data:Object = {};
         data["action"] = "removeBookmark";
         data["coordX"] = coordX;
         data["coordY"] = coordY;
         this.updateStarsBookmarks(data);
      }
      
      override public function updateTemplates_saveTemplate(slotId:int, itemsData:Object, thumbnailByteArray:String) : void
      {
         var data:Object;
         (data = {})["action"] = "saveTemplate";
         data["slotId"] = slotId;
         data["items"] = itemsData;
         this.mTemplateItemsDataWaitingToSave = itemsData;
         this.updateTemplates(data);
      }
      
      override public function updateTemplates_deleteTemplate(slotId:int) : void
      {
         var data:Object = {};
         data["action"] = "deleteTemplate";
         data["slotId"] = slotId;
         InstanceMng.getBuildingsBufferController().deleteTemplateLocally(slotId);
         this.updateTemplates(data);
      }
      
      override public function updateTemplates_importTemplate(slotId:int, templateUUID:String) : void
      {
         var data:Object = {};
         data["action"] = "importTemplate";
         data["slotId"] = slotId;
         data["templateUUID"] = templateUUID;
         this.updateTemplates(data);
      }
      
      override public function updatePoll_vote(optionId:int) : void
      {
      }
      
      override public function queryVerifyCreditsPurchase(useRetries:Boolean) : void
      {
         var cashOnlyMode:Boolean = InstanceMng.getUnitScene().battleIsRunning();
         if(useRetries && this.mRetryCreditsPurchaseCount == 0)
         {
            this.mRetryCreditsPurchaseCount = 5;
         }
         this.mRetryCreditsPurchaseTimer = 10000;
         this.mServer.sendCommandNow("queryVerifyCreditsPurchase",{"cashOnlyMode":(cashOnlyMode ? 1 : 0)});
      }
      
      override public function queryVerifyMoneyConversion(socialCashToBuy:Number, mineralsToBuy:Number, coinsToBuy:Number, cashToBuy:Number, badgesToBuy:Number, itemsToBuy:Object = null, itemsWithOffer:Array = null) : void
      {
         var data:Object = null;
         var skip:Boolean;
         if(!(skip = socialCashToBuy == cashToBuy && mineralsToBuy == 0 && coinsToBuy == 0 && itemsToBuy == null))
         {
            (data = {})["socialCashToPay"] = socialCashToBuy;
            data["minerals"] = mineralsToBuy;
            data["coins"] = coinsToBuy;
            data["cash"] = cashToBuy;
            data["badges"] = badgesToBuy;
            if(itemsToBuy != null)
            {
               data["items"] = itemsToBuy;
               if(itemsWithOffer != null && itemsWithOffer.length > 0)
               {
                  data["itemsWithOffer"] = itemsWithOffer;
               }
            }
            this.mServer.sendCommandNow("queryVerifyTransaction",data);
         }
         var responseObj:Object;
         (responseObj = {})["minerals"] = mineralsToBuy;
         responseObj["coins"] = coinsToBuy;
         responseObj["cash"] = cashToBuy - socialCashToBuy;
         responseObj["badges"] = badgesToBuy;
         if(itemsToBuy != null)
         {
            responseObj["items"] = itemsToBuy;
            if(itemsWithOffer != null && itemsWithOffer.length > 0)
            {
               responseObj["itemsWithOffer"] = itemsWithOffer;
            }
         }
         Application.externalNotification(5,responseObj);
      }
      
      override public function queryVerifyMoneyTransaction(transaction:Transaction) : void
      {
         var itemSku:* = null;
         var quantity:int = 0;
         var socialCashToPay:Number = transaction.getTransCashToPay();
         var mineralsToBuy:Number = transaction.getTransCurrencyLeftToPay(2);
         var coinsToBuy:Number = transaction.getTransCurrencyLeftToPay(1);
         var badgesToBuy:Number = transaction.getTransCurrencyLeftToPay(8);
         var cashToBuy:Number = transaction.getTransCashToPay() - transaction.getTransCashToExchange();
         var itemsToBuy:Object = null;
         var itemsWithOffer:Array = null;
         var transItems:Dictionary = transaction.mDifferencesItemsAmount;
         if(transItems != null)
         {
            itemsWithOffer = transaction.getItemSkusWithOffer();
            for(itemSku in transItems)
            {
               if((quantity = int(transItems[itemSku])) > 0)
               {
                  if(itemsToBuy == null)
                  {
                     itemsToBuy = {};
                  }
                  itemsToBuy[itemSku] = quantity;
               }
            }
         }
         this.queryVerifyMoneyConversion(socialCashToPay,mineralsToBuy,coinsToBuy,cashToBuy,badgesToBuy,itemsToBuy,itemsWithOffer);
      }
      
      override public function updateInvest_investInFriends(blackList:Array) : void
      {
         var data:Object = {};
         data["action"] = "obtainBlackList";
         data["blackList"] = blackList;
         this.updateInvestments(data,null,true);
      }
      
      override public function updateInvest_investInFriend(extId:String) : void
      {
         this.mBrowser.taskRequest("invest_inSingleFriend",{"platformUserId":extId});
      }
      
      private function updateInvest_investInFriends_callBack(selectedIds:Array) : void
      {
         var data:Object = null;
         if(selectedIds != null && selectedIds.length > 0)
         {
            data = {};
            data["action"] = "investInFriends";
            data["extIds"] = selectedIds;
            this.updateInvestments(data,null,true);
         }
      }
      
      override public function updateInvest_cancelByAccountId(accountId:String) : void
      {
         var data:Object = {};
         data["action"] = "cancel";
         data["accountId"] = accountId;
         this.updateInvestments(data);
      }
      
      override public function updateInvest_cancelByExtId(extId:String, platformId:String) : void
      {
         var data:Object = {};
         data["action"] = "cancel";
         data["platformId"] = platformId;
         data["extId"] = extId;
         this.updateInvestments(data);
      }
      
      override public function updateInvest_remind(extId:String, platformId:String) : void
      {
         var data:Object = {};
         data["action"] = "remind";
         data["platformId"] = platformId;
         data["extId"] = extId;
         this.updateInvestments(data);
      }
      
      override public function updateInvest_hurryUp(accountId:String, extId:String) : void
      {
         var data:Object = {};
         data["action"] = "hurryUp";
         data["accountId"] = accountId;
         this.updateInvestments(data);
      }
      
      override public function updateInvest_applyResult(accountId:String, rewardSku:String = "", transaction:Transaction = null) : void
      {
         var data:Object;
         (data = {})["action"] = "applyResult";
         data["accountId"] = accountId;
         this.updateInvestments(data,transaction);
      }
      
      override public function updateInvest_accept(transaction:Transaction) : void
      {
         var data:Object = {};
         data["action"] = "accept";
         this.updateInvestments(data,transaction);
      }
      
      override public function updateHappening_stateCountdown(sku:String) : void
      {
         var data:Object = {};
         data["action"] = "stateCountdown";
         data["sku"] = sku;
         this.updateHappening(data);
      }
      
      override public function updateHappening_stateReadyToStart(sku:String) : void
      {
         var data:Object = {};
         data["action"] = "stateReadyToStart";
         data["sku"] = sku;
         this.updateHappening(data);
      }
      
      override public function updateHappening_stateRunning(sku:String, HQLevel:int, countdownWaveTime:Number, firstWaveSpawnSku:String, initialKitTransaction:Transaction) : void
      {
         var data:Object;
         (data = {})["action"] = "stateRunning";
         data["sku"] = sku;
         data["waveSpawnSku"] = firstWaveSpawnSku;
         data["countdownWaveTime"] = countdownWaveTime;
         data["HQLevel"] = HQLevel;
         this.updateHappening(data,initialKitTransaction);
      }
      
      override public function updateHappening_stateCompleted(sku:String, transaction:Transaction) : void
      {
         var data:Object = {};
         data["action"] = "stateCompleted";
         data["sku"] = sku;
         this.updateHappening(data,transaction);
      }
      
      override public function updateHappening_stateOver(sku:String) : void
      {
         var data:Object = {};
         data["action"] = "stateOver";
         data["sku"] = sku;
         this.updateHappening(data);
      }
      
      override public function updateHappeningWave_stateReadyToStart(sku:String, speedUpWaveTransaction:Transaction = null, timeLeft:Number = 0) : void
      {
         var data:Object;
         (data = {})["action"] = "waveStateReadyToStart";
         data["sku"] = sku;
         data["timeLeft"] = timeLeft;
         this.updateHappening(data,speedUpWaveTransaction);
      }
      
      override public function updateHappeningWave_delayWave(sku:String) : void
      {
         var data:Object = {};
         data["action"] = "delayWave";
         data["sku"] = sku;
         this.updateHappening(data);
      }
      
      override public function updateHappeningWave_stateRunning(sku:String) : void
      {
         var data:Object = {};
         data["action"] = "waveStateRunning";
         data["sku"] = sku;
         this.updateHappening(data);
      }
      
      override public function updateHappeningWave_stateCompleted(sku:String, idxNextWave:int, nextWaveSpawnSku:String, transaction:Transaction) : void
      {
         var data:Object;
         (data = {})["action"] = "waveStateCompleted";
         data["sku"] = sku;
         data["waveSpawnSku"] = nextWaveSpawnSku;
         data["idxNextWave"] = idxNextWave;
         this.updateHappening(data,transaction);
      }
      
      override public function updateContest_requestContest() : void
      {
         var data:Object = {};
         data["action"] = "requestContest";
         this.updateContest(data);
      }
      
      override public function updateContest_requestProgress(contestType:String) : void
      {
         var data:Object = {};
         data["action"] = "requestProgress";
         data["contestType"] = contestType;
         this.updateContest(data);
      }
      
      override public function updateContest_requestLeaderboard(contestType:String) : void
      {
         var data:Object = {};
         data["action"] = "requestLeaderboard";
         data["contestType"] = contestType;
         this.updateContest(data);
      }
      
      override public function updateContest_clickMePressed(contestType:String) : void
      {
         var data:Object = {};
         data["action"] = "clickMePressed";
         data["contestType"] = contestType;
         this.updateContest(data);
      }
      
      override public function updateContest_lostPopupShown(contestType:String) : void
      {
         var data:Object = {};
         data["action"] = "lostPopupShown";
         data["contestType"] = contestType;
         this.updateContest(data);
      }
      
      override public function updateContest_flushCommands() : void
      {
         this.mServer.flushAllCommandsNow();
         this.mContestPopupCount = 5000;
      }
      
      override public function updateDailyReward_sendTransaction(transaction:Transaction) : void
      {
         var data:Object = {};
         if(transaction != null)
         {
            data["transaction"] = this.createTransactionObject(transaction);
         }
         this.mServer.sendCommandNow("updateDailyReward",data);
      }
      
      override public function quickAttackFindTarget() : void
      {
         this.mServer.sendCommandNow("quickAttackFindTarget",{});
      }
      
      private function createTransactionObject(transaction:Transaction) : Object
      {
         var instantOperationMinutesLeft:Number = NaN;
         var socialItems:Dictionary = null;
         var clientDebugInfo:String = null;
         var wio:WorldItemObject = null;
         var socialItemsArray:Array = null;
         var sku:* = null;
         var profile:Profile = null;
         var commandStringForServer:String = null;
         var transactionObj:Object = {};
         if(transaction != null)
         {
            transactionObj["event"] = transaction.getTransEvent();
            transactionObj["exp"] = transaction.getTransXp();
            transactionObj["minerals"] = transaction.getTransMinerals();
            transactionObj["coins"] = transaction.getTransCoins();
            transactionObj["badges"] = transaction.getTransBadges();
            transactionObj["cash"] = transaction.getTransCash();
            transactionObj["droids"] = transaction.getTransDroids();
            if(transaction.getTransScore() > 0)
            {
               transactionObj["score"] = transaction.getTransScore();
            }
            instantOperationMinutesLeft = transaction.getTransTime();
            if(instantOperationMinutesLeft > 0)
            {
               transactionObj["instantOperationMinutesLeft"] = instantOperationMinutesLeft;
            }
            if((socialItems = transaction.getTransItems()) != null)
            {
               socialItemsArray = [];
               for(sku in socialItems)
               {
                  socialItemsArray.push({
                     "sku":sku,
                     "amount":int(socialItems[sku]["amount"]),
                     "offer":int(socialItems[sku]["offer"])
                  });
               }
               if(socialItemsArray.length > 0)
               {
                  transactionObj["socialItems"] = socialItemsArray;
               }
            }
            if(transaction.getTransHasBeenPerformed())
            {
               transactionObj["client"] = Math.floor(transaction.mProfileImageScore.value) + ":" + transaction.mProfileImageMinerals.value + ":" + transaction.mProfileImageCoins.value + ":" + transaction.mProfileImageCash.value;
            }
            else
            {
               profile = InstanceMng.getUserInfoMng().getProfileLogin();
               transactionObj["client"] = Math.floor(profile.getScore()) + ":" + profile.getMinerals() + ":" + profile.getCoins() + ":" + profile.getCash();
            }
            clientDebugInfo = "";
            if(transaction.mClientDebugInfo != null && transaction.mClientDebugInfo.length > 0)
            {
               clientDebugInfo += transaction.mClientDebugInfo;
            }
            if((wio = transaction.getTransWIO()) != null)
            {
               if((commandStringForServer = wio.getCommandStringForServer()) != null && commandStringForServer.length > 0)
               {
                  clientDebugInfo += "[" + commandStringForServer + "]";
               }
            }
            if(clientDebugInfo.length > 0)
            {
               transactionObj["clientDebugInfo"] = clientDebugInfo;
            }
         }
         return transactionObj;
      }
      
      override public function queryGetColonyAvailability(sku:String, starId:Number) : void
      {
         this.mServer.sendCommandNow("queryPlanetAvailability",{
            "planetSku":sku,
            "starId":starId
         });
      }
      
      override public function queryGetColonyConfirmPurchase(sku:String, transaction:Transaction, starId:Number) : void
      {
         this.mServer.sendCommandNow("queryGetColonyConfirmPurchase",{
            "planetSku":sku,
            "starId":starId,
            "transaction":this.createTransactionObject(transaction)
         });
      }
      
      override public function queryGetColonyConfirmMove(planetId:int, starId:Number, sku:String, transaction:Transaction) : void
      {
         this.mServer.sendCommandNow("queryGetColonyConfirmMove",{
            "planetId":planetId,
            "starId":starId,
            "planetSku":sku,
            "transaction":this.createTransactionObject(transaction)
         });
      }
      
      override public function browserRefresh() : void
      {
         this.mBrowser.taskRequest("browserRefresh");
      }
      
      override public function guestUserRegistration() : void
      {
         this.mBrowser.taskRequest("guestUserRegistration");
      }
      
      override public function notifyException(name:String, message:String, stacktrace:String) : void
      {
         if(this.isLogged())
         {
            this.mNotifyExceptionCount++;
            if(!this.mNotifyExceptionSent)
            {
               this.mServer.sendCommand("notifyClientException",{
                  "name":name,
                  "message":message,
                  "stacktrace":stacktrace
               });
               this.mNotifyExceptionSent = true;
            }
         }
      }
      
      override public function saveTemplatesLocally(data:Object) : void
      {
         setFile(KEY_TEMPLATES,Server.objectToXML(data));
      }
      
      private function battleDamagesCacheInit() : void
      {
         this.mBattleDeploysAry = [];
         this.mBattleMineExplodedAry = [];
         this.mBattleDamagesCmdObj = {};
         this.mBattleDamagesOrderAry = [];
         this.mBattleTargetsCmdObj = {};
         this.mBattleSocialItemAry = [];
         this.mBattleDamagesTimer = 0;
         this.mBattleUmbrellaDamagedAry = [];
      }
      
      private function itemDamagedCacheAdd(data:Object) : void
      {
         var oldObj:Object = null;
         var attackerAry:Array = null;
         var newTransactionObj:Object = null;
         var oldTransactionObj:* = null;
         if(this.mBattleDamagesCmdObj == null)
         {
            return;
         }
         var itemSidKey:String = "i" + String(data["itemSid"]);
         if(!this.mBattleDamagesCmdObj.hasOwnProperty(itemSidKey))
         {
            this.mBattleDamagesCmdObj[itemSidKey] = [];
            this.mBattleDamagesOrderAry.push(itemSidKey);
         }
         var itemsDamagedAry:Array;
         if((itemsDamagedAry = this.mBattleDamagesCmdObj[itemSidKey]).length > 0 && int(data["destroyed"]) == 0)
         {
            (oldObj = itemsDamagedAry[itemsDamagedAry.length - 1])["damage"] = Number(oldObj["damage"]) + Number(data["damage"]);
            oldObj["umbrellaDamage"] = Number(oldObj["umbrellaDamage"]) + Number(data["umbrellaDamage"]);
            attackerAry = oldObj["attackers"] as Array;
            attackerAry.push((data["attackers"] as Array)[0]);
            newTransactionObj = data["transaction"];
            oldTransactionObj = oldObj["transaction"];
            if(newTransactionObj != null)
            {
               if(oldTransactionObj != null)
               {
                  oldTransactionObj["exp"] = Number(oldTransactionObj["exp"]) + Number(newTransactionObj["exp"]);
                  oldTransactionObj["coins"] = Number(oldTransactionObj["coins"]) + Number(newTransactionObj["coins"]);
                  oldTransactionObj["minerals"] = Number(oldTransactionObj["minerals"]) + Number(newTransactionObj["minerals"]);
                  oldTransactionObj["cash"] = Number(oldTransactionObj["cash"]) + Number(newTransactionObj["cash"]);
                  if(newTransactionObj.hasOwnProperty("score"))
                  {
                     oldTransactionObj["score"] = newTransactionObj["score"];
                  }
               }
               else
               {
                  oldTransactionObj = newTransactionObj;
               }
            }
            newTransactionObj = data["transactionTarget"];
            oldTransactionObj = oldObj["transactionTarget"];
            if(newTransactionObj != null)
            {
               if(oldTransactionObj != null)
               {
                  oldTransactionObj["exp"] = Number(oldTransactionObj["exp"]) + Number(newTransactionObj["exp"]);
                  oldTransactionObj["coins"] = Number(oldTransactionObj["coins"]) + Number(newTransactionObj["coins"]);
                  oldTransactionObj["minerals"] = Number(oldTransactionObj["minerals"]) + Number(newTransactionObj["minerals"]);
                  oldTransactionObj["cash"] = Number(oldTransactionObj["cash"]) + Number(newTransactionObj["cash"]);
               }
               else
               {
                  oldTransactionObj = newTransactionObj;
               }
            }
         }
         else
         {
            itemsDamagedAry.push(data);
         }
         if(this.mBattleDamagesTimer == 0)
         {
            this.mBattleDamagesTimer = 60000;
         }
      }
      
      private function unitDamagedCacheAdd(data:Object) : void
      {
         var oldObj:Object = null;
         var attackerAry:Array = null;
         if(this.mBattleDamagesCmdObj == null)
         {
            return;
         }
         var unitIdKey:String = "u" + String(data["unitId"]);
         if(!this.mBattleDamagesCmdObj.hasOwnProperty(unitIdKey))
         {
            this.mBattleDamagesCmdObj[unitIdKey] = [];
            this.mBattleDamagesOrderAry.push(unitIdKey);
         }
         var unitDamagedAry:Array = this.mBattleDamagesCmdObj[unitIdKey];
         if(unitDamagedAry.length > 0 && int(data["destroyed"]) == 0)
         {
            (oldObj = unitDamagedAry[unitDamagedAry.length - 1])["damage"] = Number(oldObj["damage"]) + Number(data["damage"]);
            attackerAry = oldObj["attackers"] as Array;
            attackerAry.push((data["attackers"] as Array)[0]);
         }
         else
         {
            unitDamagedAry.push(data);
         }
         if(this.mBattleDamagesTimer == 0)
         {
            this.mBattleDamagesTimer = 60000;
         }
      }
      
      private function deployUnitsCacheAdd(data:Object) : void
      {
         if(this.mBattleDamagesCmdObj == null)
         {
            return;
         }
         this.mBattleDeploysAry.push(data);
         if(this.mBattleDamagesTimer == 0)
         {
            this.mBattleDamagesTimer = 60000;
         }
      }
      
      private function itemMineExplodedCacheAdd(data:Object) : void
      {
         if(this.mBattleDamagesCmdObj == null)
         {
            return;
         }
         this.mBattleMineExplodedAry.push(data);
         if(this.mBattleDamagesTimer == 0)
         {
            this.mBattleDamagesTimer = 60000;
         }
      }
      
      private function updateSocialItemCacheAdd(data:Object) : void
      {
         if(this.mBattleDamagesCmdObj == null)
         {
            return;
         }
         this.mBattleSocialItemAry.push(data);
         if(this.mBattleDamagesTimer == 0)
         {
            this.mBattleDamagesTimer = 60000;
         }
      }
      
      private function updateTargetsCacheAdd(data:Object) : void
      {
         var oldObj:Object = null;
         if(this.mBattleTargetsCmdObj == null)
         {
            return;
         }
         var key:* = data["sku"] + "[" + data["subTargetIndex"] + "]";
         if(this.mBattleTargetsCmdObj.hasOwnProperty(key))
         {
            oldObj = this.mBattleTargetsCmdObj[key];
            oldObj["amount"] = Number(oldObj["amount"]) + Number(data["amount"]);
         }
         else
         {
            this.mBattleTargetsCmdObj[key] = data;
         }
      }
      
      private function umbrellaDamagedCacheAdd(data:Object) : void
      {
         if(this.mBattleTargetsCmdObj == null)
         {
            return;
         }
         this.mBattleUmbrellaDamagedAry.push(int(data["damage"]));
      }
      
      private function battleDamagesCacheLogicUpdate(deltaTime:int) : void
      {
         if(this.mBattleDamagesCmdObj == null)
         {
            return;
         }
         if(this.mBattleDamagesTimer > 0)
         {
            this.mBattleDamagesTimer -= deltaTime;
            if(this.mBattleDamagesTimer <= 0)
            {
               this.mBattleDamagesTimer = 0;
               this.battleDamagesCacheFlush();
            }
         }
      }
      
      private function battleDamagesCacheFlush() : void
      {
         var itemOrUnitDmgArr:Array = null;
         var itemOrUnitDamagesAry:Array = null;
         var data5:Object = null;
         var skus:Array = null;
         var seqs:Array = null;
         var key:String = null;
         var param:* = null;
         var obj:Object = null;
         var data2:Object = null;
         var data:Object = null;
         var data3:Object = null;
         var damage:int = 0;
         var data4:Object = null;
         if(this.mBattleDamagesCmdObj == null)
         {
            return;
         }
         var battleDeploysAry:Array = this.mBattleDeploysAry;
         var battleMineExplodedAry:Array = this.mBattleMineExplodedAry;
         var battleDamagesOrderAry:Array = this.mBattleDamagesOrderAry;
         var battleDamagesCmdObj:Object = this.mBattleDamagesCmdObj;
         var battleTargetsCmdObj:Object = this.mBattleTargetsCmdObj;
         var battleSocialItemAry:Array = this.mBattleSocialItemAry;
         var battleUmbrellaDamagedAry:Array = this.mBattleUmbrellaDamagedAry;
         this.battleDamagesCacheInit();
         if(battleDeploysAry.length > 0)
         {
            (data2 = {})["action"] = "battleDamagesPack";
            data2["pack"] = battleDeploysAry;
            this.updateBattle(data2);
         }
         if(this.mBattleSignatureNow == this.mBattleSignatureFirst)
         {
            this.mBattleSignatureNow = InstanceMng.getRuleMng().sigGetBattleSig(true);
         }
         var dataRulesSignature:Object;
         (dataRulesSignature = {})["action"] = "gis";
         dataRulesSignature["rs"] = this.mBattleSignatureNow;
         dataRulesSignature["ip"] = InstanceMng.getWorld().getSig();
         dataRulesSignature["bt"] = InstanceMng.getUnitScene().battleGetTimeLeft();
         this.updateBattle(dataRulesSignature);
         if(battleDamagesOrderAry.length > 0)
         {
            itemOrUnitDmgArr = [];
            for each(key in battleDamagesOrderAry)
            {
               if(battleDamagesCmdObj.hasOwnProperty(key))
               {
                  itemOrUnitDamagesAry = battleDamagesCmdObj[key];
                  for each(var dmg in itemOrUnitDamagesAry)
                  {
                     itemOrUnitDmgArr.push(dmg);
                  }
               }
            }
            (data = {})["action"] = "battleDamagesPack";
            data["pack"] = itemOrUnitDmgArr;
            this.updateBattle(data);
         }
         if(battleMineExplodedAry.length > 0)
         {
            (data3 = {})["action"] = "battleDamagesPack";
            data3["pack"] = battleMineExplodedAry;
            this.updateBattle(data3);
         }
         if(battleUmbrellaDamagedAry.length > 0)
         {
            data5 = {};
            (data4 = {})["action"] = "umbrellaDamaged";
            data4["damage"] = 0;
            for each(damage in battleUmbrellaDamagedAry)
            {
               data4["damage"] += damage;
            }
            data5["action"] = "battleDamagesPack";
            data5["pack"] = [data4];
            this.updateBattle(data5);
         }
         for(param in battleTargetsCmdObj)
         {
            this.mServer.sendCommand("updateTargets",battleTargetsCmdObj[param]);
         }
         if(battleSocialItemAry.length > 0)
         {
            (data = {})["action"] = "nextSteps";
            skus = [];
            seqs = [];
            for each(obj in battleSocialItemAry)
            {
               skus.push(obj["sku"]);
               if(obj.hasOwnProperty("sequence"))
               {
                  seqs.push(obj["sequence"]);
               }
               else
               {
                  seqs.push("0");
               }
            }
            data["sku"] = skus.join(",");
            data["seqs"] = seqs.join(",");
            this.mServer.sendCommand("updateSocialItem",data);
         }
      }
      
      private function galaxyAreaAdd(galaxyStars:XML) : void
      {
         var starXML:XML = null;
         var areaKey:String = null;
         var sku:String = null;
         var axes:Array = null;
         var x:Number = NaN;
         var y:Number = NaN;
         var starId:String = null;
         var topLeftX:* = 0;
         var topLeftY:* = 0;
         var bottomRightX:* = 0;
         var bottomRightY:* = 0;
         var loaded:Boolean = false;
         if(EUtils.xmlIsAttribute(galaxyStars,"topLeftCoorX") && EUtils.xmlIsAttribute(galaxyStars,"topLeftCoorY") && EUtils.xmlIsAttribute(galaxyStars,"bottomRightCoorX") && EUtils.xmlIsAttribute(galaxyStars,"bottomRightCoorY"))
         {
            topLeftX = EUtils.xmlReadNumber(galaxyStars,"topLeftCoorX");
            topLeftY = EUtils.xmlReadNumber(galaxyStars,"topLeftCoorY");
            bottomRightX = EUtils.xmlReadNumber(galaxyStars,"bottomRightCoorX");
            bottomRightY = EUtils.xmlReadNumber(galaxyStars,"bottomRightCoorY");
            loaded = true;
         }
         for each(starXML in EUtils.xmlGetChildrenList(galaxyStars,"SpaceStar"))
         {
            x = Number((axes = (sku = EUtils.xmlReadString(starXML,"sku")).split(":"))[0]);
            y = Number(axes[1]);
            if(loaded)
            {
               if(topLeftX > x)
               {
                  topLeftX = x;
               }
               if(topLeftY > y)
               {
                  topLeftY = y;
               }
               if(bottomRightX < x)
               {
                  bottomRightX = x;
               }
               if(bottomRightY < y)
               {
                  bottomRightY = y;
               }
            }
            else
            {
               topLeftX = x;
               topLeftY = y;
               bottomRightX = x;
               bottomRightY = y;
               loaded = true;
            }
            starId = EUtils.xmlReadString(starXML,"starId");
            this.mGalaxyStarsID[starId] = starXML.copy();
            this.mGalaxyStarsSku[sku] = starId;
         }
         areaKey = topLeftX + "," + topLeftY + "/" + bottomRightX + "," + bottomRightY;
         this.mGalaxyAreas[areaKey] = getServerCurrentTimemillis();
         DCDebug.traceCh("galaxyArea","area: " + areaKey + ": added to cache");
      }
      
      private function galaxyGetCachedStars(topLeftCoordX:Number, topLeftCoordY:Number, bottomRightCoordX:Number, bottomRightCoordY:Number) : XML
      {
         var areaKey:* = null;
         var updatedAt:Number = NaN;
         var topBottom:Array = null;
         var axes:Array = null;
         var tlX:Number = NaN;
         var tlY:Number = NaN;
         var brX:Number = NaN;
         var brY:Number = NaN;
         var xml:XML = null;
         var sku:* = null;
         var x:Number = NaN;
         var y:Number = NaN;
         var baseKey:String = topLeftCoordX + "," + topLeftCoordY + "/" + bottomRightCoordX + "," + bottomRightCoordY;
         for(areaKey in this.mGalaxyAreas)
         {
            if((updatedAt = Number(this.mGalaxyAreas[areaKey])) + 60000 < getServerCurrentTimemillis())
            {
               delete this.mGalaxyAreas[areaKey];
               DCDebug.traceCh("galaxyArea","area: " + areaKey + ": expired!");
            }
         }
         DCDebug.traceCh("galaxyArea","------> Searching for area: " + baseKey + " ...");
         for(areaKey in this.mGalaxyAreas)
         {
            tlX = Number((axes = String((topBottom = areaKey.split("/"))[0]).split(","))[0]);
            tlY = Number(axes[1]);
            brX = Number((axes = String(topBottom[1]).split(","))[0]);
            brY = Number(axes[1]);
            if(topLeftCoordX >= tlX && topLeftCoordY >= tlY && bottomRightCoordX <= brX && bottomRightCoordY <= brY)
            {
               DCDebug.traceCh("galaxyArea","area: " + areaKey + ": FOUND in cache, getting it...");
               xml = <galaxyWindow/>;
               for(sku in this.mGalaxyStarsSku)
               {
                  x = Number((axes = sku.split(":"))[0]);
                  y = Number(axes[1]);
                  if(x >= topLeftCoordX && y >= topLeftCoordY && x <= bottomRightCoordX && y <= bottomRightCoordY)
                  {
                     xml.appendChild(XML(this.mGalaxyStarsID[this.mGalaxyStarsSku[sku]]));
                  }
               }
               return xml;
            }
            DCDebug.traceCh("galaxyArea","skipping: " + areaKey + " ...");
         }
         DCDebug.traceCh("galaxyArea","area: " + baseKey + ": NOT found in cache, getting from server...");
         return null;
      }
      
      override public function openCreditsPopup() : void
      {
         DCDebug.trace("open native platform credits popup");
         this.mBrowser.taskRequest(KEY_REQUEST_CREDITS_POPUP,null);
      }
      
      override public function createAlliance(data:Object, transaction:Transaction = null) : void
      {
         this.updateAlliances(data,transaction);
      }
      
      override public function editAlliance(data:Object, transaction:Transaction = null) : void
      {
         this.updateAlliances(data,transaction);
      }
      
      override public function requestMyAlliance(data:Object) : void
      {
         this.updateAlliances(data);
      }
      
      override public function requestAllianceByUserId(data:Object) : void
      {
         this.updateAlliances(data);
      }
      
      override public function requestAllianceById(data:Object) : void
      {
         this.updateAlliances(data);
      }
      
      override public function requestAlliances(data:Object) : void
      {
         this.updateAlliances(data);
      }
      
      override public function joinAlliance(data:Object) : void
      {
         this.updateAlliances(data);
      }
      
      override public function leaveAlliance(data:Object) : void
      {
         this.updateAlliances(data);
      }
      
      override public function promote(data:Object) : void
      {
         this.updateAlliances(data);
      }
      
      override public function demote(data:Object) : void
      {
         this.updateAlliances(data);
      }
      
      override public function kickUser(data:Object) : void
      {
         this.updateAlliances(data);
      }
      
      override public function requestWarsHistory(data:Object) : void
      {
         this.updateAlliances(data);
      }
      
      override public function declareWar(data:Object) : void
      {
         this.updateAlliances(data);
      }
      
      override public function requestNews(data:Object) : void
      {
         this.updateAlliances(data);
      }
      
      override public function requestAlliancesWarSuggested(data:Object) : void
      {
         this.updateAlliances(data);
      }
      
      override public function allianceInviteFriends(data:Object) : void
      {
         InstanceMng.getApplication().setToWindowedMode();
         DCDebug.traceCh("ALLIANCES","----------------------");
         DCDebug.traceCh("ALLIANCES"," allianceInviteFriends:");
         DCDebug.traceChObject("ALLIANCES",data);
         DCDebug.traceCh("ALLIANCES","----------------------");
         DCDebug.traceCh("ALLIANCES","");
         this.mBrowser.taskRequest("allianceInviteRequest",data);
      }
      
      override public function startRefining(stageId:int, rewardSku:String, timeMinutes:Number, minerals:Number) : void
      {
         var profile:Profile;
         (profile = InstanceMng.getUserInfoMng().getProfileLogin()).setRefiningTime(getServerCurrentTimemillis() + timeMinutes * 60000);
         profile.setRefiningSku(rewardSku);
         profile.subtractMinerals(minerals);
         this.mServer.sendCommandNow("startRefining",{
            "stageId":stageId,
            "rewardSku":rewardSku,
            "timeMinutes":timeMinutes,
            "minerals":minerals
         });
         this.mServer.flushAllCommandsNow();
      }
      
      override public function completeRefining() : void
      {
         var profile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         profile.setRefiningSku("");
         this.mServer.sendCommandNow("completeRefining",{});
         this.mServer.flushAllCommandsNow();
      }
      
      private function updateTelemetry(data:Object) : void
      {
         if(Config.useTelemetry())
         {
         }
      }
      
      override public function updateAlliances_GetReward(sku:String) : void
      {
         var data:Object = {};
         data["action"] = "getReward";
         data["sku"] = sku;
         this.updateAlliances(data);
      }
      
      override public function updateTelemetry_mouseMove(x:int, y:int, w:int, h:int, time:Number) : void
      {
         var data:Object;
         (data = {})["action"] = "mouseMove";
         data["x"] = x;
         data["y"] = y;
         data["w"] = w;
         data["h"] = h;
         data["time"] = time;
         this.updateTelemetry(data);
      }
      
      override public function updateTelemetry_mouseClick(x:int, y:int, w:int, h:int, time:Number) : void
      {
         var data:Object;
         (data = {})["action"] = "mouseClick";
         data["x"] = x;
         data["y"] = y;
         data["w"] = w;
         data["h"] = h;
         data["time"] = time;
         this.updateTelemetry(data);
      }
      
      override public function get mBattleStartWithScore() : int
      {
         return this.mSecureBattleStartWithScore.value;
      }
      
      override public function set mBattleStartWithScore(value:int) : void
      {
         this.mSecureBattleStartWithScore.value = value;
      }
   }
}
