package com.dchoc.game.model.userdata
{
   import com.adobe.utils.ArrayUtil;
   import com.dchoc.game.core.flow.Application;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.alliances.Alliance;
   import com.dchoc.game.model.alliances.AlliancesConstants;
   import com.dchoc.game.model.rule.NewsFeedDef;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.services.advertising.DCAdsManager;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   import esparragon.utils.EUtils;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.Dictionary;
   
   public class UserDataMng extends DCComponent
   {
      
      public static var mUserIsFan:Boolean = false;
      
      public static var mUserIsVIP:Boolean = false;
      
      public static var mUserHasScoreDisplays:Boolean = false;
      
      public static var TASK_LOAD_SUCCESS:String = "loadSuccess";
      
      public static var TASK_ASK_FOR_HELP_ACCELERATE_CONSTRUCTION:String = "askForHelp_accelerateConstruction";
      
      public static var TASK_BROWSER_REFRESH:String = "browserRefresh";
      
      public static var KEY_UNIVERSE:String = "universe";
      
      public static var KEY_SOCIAL_USER_INFO:String = "socialUserInfo";
      
      public static var KEY_FRIENDS_LIST:String = "friendsList";
      
      public static var KEY_NEIGHBOR_LIST:String = "neighborList";
      
      public static var KEY_NEIGHBOR_INFO:String = "neighborInfo";
      
      public static var KEY_NPC_NEIGHBOR_LIST:String = "NPCNeighborList";
      
      public static var KEY_ATTACKER_LIST:String = "attackerList";
      
      public static var KEY_ASK_FOR_HELP_STATUS_LIST:String = "askForHelpStatusList";
      
      public static var KEY_ACTIONS_PERFORMED_BY_FRIENDS_LIST:String = "actionsPerformedByFriendsList";
      
      public static var KEY_ITEMS_LIST:String = "itemsList";
      
      public static var KEY_HANGARS_HELP_LIST:String = "hangarsHelpList";
      
      public static var KEY_CHECK_AVAILABLE_ATTACK:String = "checkAvailableAttack";
      
      public static var KEY_FREE_LOCKED_ATTACK:String = "freeLockedAttack";
      
      public static var KEY_NON_FRIENDS_LIST:String = "nonFriendsList";
      
      public static var KEY_GALAXY_WINDOW:String = "galaxyWindow";
      
      public static var KEY_STAR_PLANETS_WINDOW:String = "starPlanetsWindow";
      
      public static var KEY_BOOKMARKS:String = "bookmark";
      
      public static var KEY_COLONY_AVAILABILITY:String = "colonyAvailability";
      
      public static var KEY_COLONY_PURCHASE:String = "colonyPurchase";
      
      public static var KEY_IS_FAN:String = "userIsFan";
      
      public static var KEY_UPSELLING:String = "upSelling";
      
      public static var KEY_CUSTOMIZER:String = "customizer";
      
      public static var KEY_PURCHASE_CREDITS:String = "purchaseCredits";
      
      public static var KEY_INTRO_OVER:String = "introOver";
      
      public static var KEY_SPY_STATUS:String = "spyStatus";
      
      public static var KEY_REQUEST_CREDITS_POPUP:String = "openCreditsPopup";
      
      public static var KEY_OPEN_FREE_GIFT:String = "openFreeGifts";
      
      public static var KEY_OPEN_INVITE_TAB:String = "openInviteTab";
      
      public static var KEY_OPEN_LEADERBOARD_TAB:String = "openLeaderboardTab";
      
      public static var KEY_USER_ITEMS_AMOUNT_INFO:String = "itemsAmountInfo";
      
      public static var KEY_PURCHASE_MOBILE_PAYMENTS:String = "purchaseMobilePayments";
      
      public static var KEY_CHECK_WARP_BUNKER_TRANSFER:String = "checkWarpBunkerTransfer";
      
      public static var KEY_BATTLE_REPLAY:String = "battleReplay";
      
      public static var POST_DEFAULT:String = "vir_fb_default";
      
      public static var CLIENT_SHOW_INFO:String = "clientShowInfo";
      
      public static var KEY_OFFER_CREDITS:String = "offerCredits";
      
      public static var KEY_ALLIANCES_LIST:String = "alliancesList";
      
      public static var KEY_ALLIANCES_WARS_HISTORY_LIST:String = "alliancesWarsHistory";
      
      public static var KEY_ALLIANCES_LIST_2:String = "alliancesList2";
      
      public static var KEY_ALLIANCES_WARS_HISTORY_LIST_2:String = "alliancesWarsHistory2";
      
      public static var KEY_ALLIANCES_NEWS:String = "alliancesNews";
      
      public static var KEY_PENDING_TRANSACTIONS:String = "pendingTransactions";
      
      public static var KEY_INVESTS_LIST:String = "investsList";
      
      public static var KEY_ALLIANCES_SUGGESTED_WAR:String = "shuffleSuggestedAlliances";
      
      public static var KEY_CONTEST_LIST:String = "contestList";
      
      public static var KEY_CONTEST_PROGRESS:String = "contestProgress";
      
      public static var KEY_CONTEST_LEADERBOARD:String = "contestLeaderboard";
      
      public static const KEY_INVITE_INDIVIDUAL_FRIEND:String = "inviteIndividualFriend";
      
      public static const KEY_ADD_NEIGHBOR:String = "addNeighbor";
      
      public static var KEY_CRM3:String = "crm3";
      
      public static var KEY_CHECK_IN_GAME_AD:String = "checkInGameAd";
      
      public static var KEY_WEEKLY_SCORE_LIST:String = "weeklyScoreList";
      
      public static var KEY_SEND_STATS:String = "sendStats";
      
      public static var KEY_SEND_FACEBOOK_OPENGRAPH:String = "sendFacebookOpengraph";
      
      public static var KEY_PURCHASE_PROMOTION:String = "purchasePromotion";
      
      public static var KEY_SHOW_CROSS_PROMOTION:String = "showCrossPromoPopup";
      
      public static var KEY_SEND_CUSTOMIZER:String = "sendCustomizer";
      
      public static var KEY_SEND_ACHIEVEMENT:String = "sendAchievement";
      
      public static var KEY_SEND_STAGE_SCREENSHOT:String = "responseScreenshot";
      
      public static var KEY_SHOW_STAGE_SCREENSHOT:String = "showScreenshot";
      
      public static var KEY_HIDE_STAGE_SCREENSHOT:String = "hideScreenshot";
      
      public static var KEY_ATTACK_IN_PROGRESS:String = "attackInProgress";
      
      public static var KEY_START_NOW_ASK_PERMISSIONS:String = "askPermissions";
      
      public static var KEY_HANGARS_OWNER:String = "hangarsOwner";
      
      public static var KEY_TEMPLATES:String = "templates";
      
      public static var KEY_POLL:String = "poll";
      
      public static var ACCOUNT_NOT_LOCKED:int = 0;
      
      public static var ACCOUNT_LOCKED_BY_OWNER:int = 1;
      
      public static var ACCOUNT_LOCKED_BY_OTHER_ACCOUNT:int = 2;
      
      public static var ACCOUNT_LOCKED_OWNER_HAS_DAMAGE_PROTECTION:int = 3;
      
      public static var ACCOUNT_LOCKED_YOU_ARE_UNDER_ATTACK:int = 4;
      
      public static var ACCOUNT_LOCKED_YOUR_LEVEL_TOO_HIGH:int = 5;
      
      public static var ACCOUNT_LOCKED_TUTORIAL_NOT_FINISHED:int = 6;
      
      public static var ACCOUNT_LOCKED_PLANET_NOT_CREATED:int = 7;
      
      public static var ACCOUNT_LOCKED_BY_MISSION_NOT_COMPLETED:int = 8;
      
      public static var ACCOUNT_LOCKED_BY_MAINTENANCE_OF_SERVERS:int = 9;
      
      public static var ACCOUNT_LOCKED_BY_HQ_LEVEL_TOO_LOW:int = 10;
      
      public static var ACCOUNT_LOCKED_HANGARS_EMPTY:int = 11;
      
      public static var ACCOUNT_LOCKED_QUICK_ATTACK_TARGET_NOT_FOUND:int = 12;
      
      public static var ACCOUNT_LOCKED_BET_TIMEOUT_FOR_OPPONENT_EXPIRED:int = 13;
      
      public static var ACCOUNT_LOCKED_TRYING_TO_ATTACK_ELDERBY:int = 14;
      
      public static var ACCOUNT_LOCKED_NOT_ENOUGH_MINERALS_CAPACITY:int = 15;
      
      public static var ACCOUNT_LOCKED_DESTROYED:int = 16;
      
      public static var ACCOUNT_TOO_MANY_ATTACKS:int = 17;
      
      public static const VISIT_HELP_BUNKER_NOT_EXIST:int = -1;
      
      public static const VISIT_HELP_BUNKER_IS_FULL:int = 0;
      
      public static const VISIT_HELP_BUNKER_SUCCESS:int = 1;
       
      
      public var mUserExtId:String = "0";
      
      public var mUserAccountId:String = "-1";
      
      public var mUserName:String = "You";
      
      public var mUserPhotoUrl:String = "https://fbcdn-profile-a.akamaihd.net/hprofile-ak-ash2/c63.63.793.793/s160x160/379784_10151652581875039_1191984017_n.jpg";
      
      protected var mServerCurrentTimeMillis:Number = 0;
      
      protected var mGameRunningMillis:Number = 0;
      
      protected var mPlanetRunningMillis:Number = 0;
      
      protected var mAdsManager:DCAdsManager;
      
      protected var mNeedsToVerifyCreditsPurchase:Boolean = false;
      
      protected var mFileCache:Object;
      
      private var mFileCacheKey:Object;
      
      private var mRequestsTimes:Dictionary;
      
      public function UserDataMng(safe:Boolean = false)
      {
         this.mFileCache = {};
         this.mFileCacheKey = {};
         super();
         if(!safe)
         {
            throw new Error("ERROR: UserDataMng Error: instantiation not safe");
         }
      }
      
      protected function init() : void
      {
      }
      
      public function login(retry:Boolean = false) : void
      {
      }
      
      public function isLogged() : Boolean
      {
         return true;
      }
      
      public function isUniverseLocked() : Boolean
      {
         return false;
      }
      
      public function logout() : void
      {
      }
      
      public function loadFiles() : void
      {
      }
      
      override public function isLoaded() : Boolean
      {
         return false;
      }
      
      override protected function childrenCreate() : void
      {
         this.mAdsManager = DCAdsManager.getInstance();
         this.mAdsManager.subscribe(this);
         childrenAddChild(this.mAdsManager);
      }
      
      override protected function buildDoAsyncStep(step:int) : void
      {
         if(step == 0)
         {
            if(!Config.DEBUG_CONSOLE)
            {
               DCDebug.DEBUG = Config.cheatsAreEnabled();
               DCDebug.setVisible(DCDebug.DEBUG);
               DCDebug.startConsole(InstanceMng.getApplication().stageGetStage());
            }
         }
      }
      
      override protected function unloadDo() : void
      {
         mUserIsFan = false;
         mUserIsVIP = false;
         mUserHasScoreDisplays = false;
         this.mAdsManager = null;
         this.logout();
      }
      
      override protected function logicUpdateDo(deltaTime:int) : void
      {
         this.mServerCurrentTimeMillis += deltaTime;
         this.mGameRunningMillis += deltaTime;
         this.mPlanetRunningMillis += deltaTime;
      }
      
      protected function setNeedsToVerifyCreditsPurchase(value:Boolean) : void
      {
         this.mNeedsToVerifyCreditsPurchase = value;
      }
      
      public function getNeedsToVerifyCreditsPurchase() : Boolean
      {
         return this.mNeedsToVerifyCreditsPurchase;
      }
      
      public function anyCommandPendingToSend() : Boolean
      {
         return false;
      }
      
      public function saveUniverse(u:XML, fileName:String) : void
      {
      }
      
      public function flushUniverse() : void
      {
      }
      
      public function flushAllPendingCommandsToServer() : void
      {
      }
      
      public function isEditorEnabled() : Boolean
      {
         var world:XML = null;
         var returnValue:Boolean = Config.EDIT_MODE;
         if(returnValue)
         {
            world = this.getFileXML(KEY_UNIVERSE);
            returnValue = EUtils.xmlReadBoolean(world,"role");
         }
         return returnValue;
      }
      
      public function isTutorialRequired() : Boolean
      {
         var returnValue:* = true;
         var world:XML = this.getFileXML(KEY_UNIVERSE);
         var profile:XML = EUtils.xmlGetChildrenListAsXML(world,"Profile");
         if(Config.EDIT_MODE && EUtils.xmlReadBoolean(world,"role"))
         {
            returnValue = false;
         }
         else if(EUtils.xmlIsAttribute(profile,"tutorialEnd"))
         {
            returnValue = !EUtils.xmlReadBoolean(profile,"tutorialEnd");
         }
         return returnValue;
      }
      
      public function getUniverseLevel() : int
      {
         var returnValue:int = -1;
         var world:XML = this.getFileXML(KEY_UNIVERSE);
         if(world != null && EUtils.xmlIsAttribute(world,"universeLevel"))
         {
            returnValue = EUtils.xmlReadInt(world,"universeLevel");
         }
         return returnValue;
      }
      
      public function serverIsBusy() : int
      {
         return 0;
      }
      
      public function notifyWCRM(groupName:String, eventName:String, label:String, jsonParams:Object = null) : void
      {
      }
      
      private function notifyJsPopupOpen() : void
      {
         var objectMb:Object = {};
         objectMb.cmd = "requestScreenshot";
         objectMb.extraTask = KEY_SHOW_STAGE_SCREENSHOT;
         Application.externalNotification(4,objectMb);
      }
      
      private function notifyJsPopupClose() : void
      {
         this.requestTask(KEY_HIDE_STAGE_SCREENSHOT);
      }
      
      override public function notify(e:Object) : Boolean
      {
         var message:String = null;
         var sku:String = null;
         var transactionXML:XML = null;
         var pendingTransactionsXML:XML = null;
         var returnValue:Boolean = false;
         if("message" in e)
         {
            switch(message = String(e.message))
            {
               case "videoAdPlay":
                  this.notifyJsPopupOpen();
                  returnValue = true;
                  break;
               case "videoAdCancelled":
                  this.notifyJsPopupClose();
                  returnValue = true;
                  break;
               case "videoAdCompleted":
                  this.notifyJsPopupClose();
                  if(false)
                  {
                     sku = String(e.itemSku);
                     transactionXML = <Transaction id="1" type="item" itemSku="{sku}" amount="1" notifyServerByAddItem="1"/>;
                     (pendingTransactionsXML = <pendingTransactions/>).appendChild(transactionXML);
                     Application.externalNotification(21,{"pendingTransactions":pendingTransactionsXML});
                     returnValue = true;
                  }
                  else
                  {
                     this.queryVerifyCreditsPurchase(true);
                  }
            }
         }
         return returnValue;
      }
      
      protected function postToFeedGetParams(newFeed:NewsFeedDef, data:Object) : Object
      {
         var text:String = null;
         var urlImage:String = null;
         var swfUrl:String = null;
         var temp:Number = NaN;
         var feed:* = 0;
         var feedTail:String = "";
         var feedAmount:int;
         if((feedAmount = newFeed.getFeedsAmount()) > 1)
         {
            feed = (temp = Math.random() * feedAmount) + 1;
            if(feed > feedAmount)
            {
               feed = feedAmount;
            }
            if(feed > 1)
            {
               feedTail = "" + feed;
            }
         }
         var paramObj:Object;
         (paramObj = {})["feedTail"] = feedTail;
         paramObj["feedSku"] = newFeed.mSku;
         text = DCTextMng.getText(TextIDs[newFeed.getTitle() + feedTail]);
         if(data.hasOwnProperty("wallName"))
         {
            text = DCTextMng.checkAndReplaceTargetName(text,data["wallName"]);
         }
         if((text = DCTextMng.checkTags(text)).indexOf("%U") > -1)
         {
            if(data.hasOwnProperty("titleParams"))
            {
               text = DCTextMng.replaceParameters(text,data["titleParams"]);
            }
         }
         paramObj["title"] = text;
         DCDebug.traceCh("Feeds","title: " + paramObj["title"]);
         text = DCTextMng.getText(TextIDs[newFeed.getText() + feedTail]);
         if(data.hasOwnProperty("wallName"))
         {
            text = DCTextMng.checkAndReplaceTargetName(text,data["wallName"]);
         }
         if((text = DCTextMng.checkTags(text)).indexOf("%U") > -1)
         {
            if(data.hasOwnProperty("params"))
            {
               text = DCTextMng.replaceParameters(text,data["params"]);
            }
         }
         paramObj["text"] = text;
         DCDebug.traceCh("Feeds","text: " + paramObj["text"]);
         text = DCTextMng.getText(TextIDs[newFeed.getCaption() + feedTail]);
         if(data.hasOwnProperty("wallName"))
         {
            text = DCTextMng.checkAndReplaceTargetName(text,data["wallName"]);
         }
         if((text = DCTextMng.checkTags(text)).indexOf("%U") > -1)
         {
            if(data.hasOwnProperty("captionParams"))
            {
               text = DCTextMng.replaceParameters(text,data["captionParams"]);
            }
         }
         paramObj["caption"] = text;
         DCDebug.traceCh("Feeds","caption: " + paramObj["caption"]);
         text = DCTextMng.getText(TextIDs[newFeed.getUrlText() + feedTail]);
         if(data.hasOwnProperty("wallName"))
         {
            text = DCTextMng.checkAndReplaceTargetName(text,data["wallName"]);
         }
         text = DCTextMng.checkTags(text);
         paramObj["urlText"] = text;
         DCDebug.traceCh("Feeds","urlText: " + paramObj["urlText"]);
         if(feed > 1)
         {
            feedTail = "_" + feed;
         }
         if(data.hasOwnProperty("urlImage"))
         {
            urlImage = InstanceMng.getResourceMng().getNewsFeedImageFullPath(String(data["urlImage"]).toLowerCase() + feedTail,true);
         }
         else
         {
            urlImage = InstanceMng.getResourceMng().getNewsFeedImageFullPath(newFeed.getAssetId().toLowerCase() + feedTail,true);
         }
         if(urlImage != null)
         {
            paramObj["urlImage"] = urlImage.toLowerCase();
         }
         DCDebug.traceCh("Feeds","urlImage: " + paramObj["urlImage"]);
         if(data.hasOwnProperty("swfUrl"))
         {
            if((swfUrl = String(data["swfUrl"])) != null)
            {
               swfUrl = InstanceMng.getResourceMng().getNewsFeedSwfFullPath(swfUrl.toLowerCase());
            }
         }
         else if(newFeed.getSwfUrl() != "")
         {
            swfUrl = InstanceMng.getResourceMng().getNewsFeedSwfFullPath(newFeed.getSwfUrl());
         }
         if(swfUrl != null)
         {
            paramObj["swfUrl"] = swfUrl;
            DCDebug.traceCh("Feeds","swfUrl: " + swfUrl);
         }
         if(data.hasOwnProperty("wallId"))
         {
            paramObj["wallId"] = data["wallId"];
         }
         if(data.hasOwnProperty("group"))
         {
            paramObj["group"] = data["group"];
         }
         return paramObj;
      }
      
      public function postToFeedObject(o:Object) : void
      {
      }
      
      public function postToFeed(sku:String, data:Object, popup:DCIPopup) : void
      {
      }
      
      protected function postToFeedNow(newFeed:NewsFeedDef, data:Object, paramObj:Object, popup:DCIPopup) : void
      {
         if(!Config.USE_NEWS_FEEDS)
         {
            return;
         }
         InstanceMng.getApplication().setToWindowedMode();
         this.postToFeedParams(newFeed,data,paramObj);
         if(InstanceMng.getPlatformSettingsDefMng().getClosePopupAfterPublish() && popup != null)
         {
            InstanceMng.getPopupMng().closePopup(popup);
         }
      }
      
      protected function postToFeedParams(newFeed:NewsFeedDef, data:Object, params:Object) : void
      {
      }
      
      public function updateProfile_tutorialCompleted() : void
      {
      }
      
      public function updateProfile_exchangeCashToCoins(cash:Number, coins:Number) : void
      {
      }
      
      public function updateProfile_exchangeCashToMinerals(cash:Number, minerals:Number) : void
      {
      }
      
      public function updateProfile_buyCash(cash:Number) : void
      {
      }
      
      public function updateProfile_buyDroid(sku:String, transaction:Transaction) : void
      {
      }
      
      public function updateProfile_buyDamageProtectionTime(sku:String, transaction:Transaction = null) : void
      {
      }
      
      public function updateProfile_levelUp(level:int, transaction:Transaction) : void
      {
      }
      
      public function updateProfile_setFlag(key:String, value:Object, transaction:Transaction = null) : void
      {
      }
      
      public function updateProfile_removeFlag(key:String) : void
      {
      }
      
      public function updateProfile_allianceRewardGained(sku:String, transaction:Transaction) : void
      {
      }
      
      public function updateProfile_cheater(type:String, info:Object) : void
      {
      }
      
      public function updateProfile_crash(type:String, info:Object) : void
      {
      }
      
      public function updateMissions_newState(sku:String, state:int, transaction:Transaction = null, rewardItemSku:String = "") : void
      {
      }
      
      public function updateTargets_addProgress(sku:String, subTargetIndex:int, amount:int, transaction:Transaction = null) : void
      {
      }
      
      public function updateItem_newItem(item:XML, transaction:Transaction = null) : void
      {
      }
      
      public function updateItem_newState(sid:int, oldState:int, newState:int, newMode:int, newTime:Number, timePassed:Number, hasBonus:Boolean, incomeToRestore:int, transaction:Transaction) : void
      {
      }
      
      public function updateItem_newStates(items:Array, transaction:Transaction) : void
      {
      }
      
      public function updateItem_rotate(sid:int, newX:int, newY:int, isFlipped:Boolean) : void
      {
      }
      
      public function updateItem_move(sid:int, newX:int, newY:int) : void
      {
      }
      
      public function updateItem_moveBulk(items:Array) : void
      {
      }
      
      public function updateItem_moveAll(items:Array) : void
      {
      }
      
      public function updateItem_destroy(sid:int, transaction:Transaction = null) : void
      {
      }
      
      public function updateItem_startRepairing(sid:int, time:Number) : void
      {
      }
      
      public function updateItem_endRepairing(sid:int, energy:int, transaction:Transaction = null) : void
      {
      }
      
      public function updateItem_cancelUpgrade(sid:int, newTime:Number, transaction:Transaction = null) : void
      {
      }
      
      public function updateItem_cancelBuild(sid:int, transaction:Transaction = null) : void
      {
      }
      
      public function updateItem_instantRecicle(sid:int, transaction:Transaction = null) : void
      {
      }
      
      public function updateItem_instantRepairAll(items:Array, transaction:Transaction) : void
      {
      }
      
      public function updateItem_upgradePremium(sid:int, newUpgradeId:int, newTime:Number, incomeToRestore:int, transaction:Transaction) : void
      {
      }
      
      public function updateShips_shipAdded(sid:int, sku:String, slot:int, timeLeft:Number, transaction:Transaction = null) : void
      {
      }
      
      public function updateShips_shipRemoved(sid:int, sku:String, slot:int, transaction:Transaction = null) : void
      {
      }
      
      public function updateShips_shipCompleted(sid:int, sku:String, hangarSid:int) : void
      {
      }
      
      public function updateShips_moveFromHangarToBunker(unitSku:String, amount:int, hangarSid:int, bunkerSid:int, bunkerContent:Object, transaction:Transaction = null) : void
      {
      }
      
      public function updateShips_killUnitFromHangar(unitSku:String, hangarSid:int, transaction:Transaction = null) : void
      {
      }
      
      public function updateShips_killUnitFromBunker(unitSku:String, bunkerSid:int, transaction:Transaction = null) : void
      {
      }
      
      public function updateShips_addSlot(sid:int, transaction:Transaction = null) : void
      {
      }
      
      public function updateShips_speedUp(sid:int, slotsContentsAccelerated:Array, transaction:Transaction) : void
      {
      }
      
      public function updateShips_block(sid:int, block:Boolean) : void
      {
      }
      
      public function updateShips_giftUnitToHangar(unitSku:String, amount:int, hangarSid:int, transaction:Transaction = null) : void
      {
      }
      
      public function updateGameUnits_unlockStart(sku:String, timeLeft:Number, transaction:Transaction = null) : void
      {
      }
      
      public function updateGameUnits_unlockCancel(sku:String, transaction:Transaction = null) : void
      {
      }
      
      public function updateGameUnits_unlockCompleted(sku:String, transaction:Transaction = null) : void
      {
      }
      
      public function updateGameUnits_upgradeStart(sku:String, upgradeId:int, timeLeft:Number, transaction:Transaction = null) : void
      {
      }
      
      public function updateGameUnits_upgradeCancel(sku:String, upgradeId:int, transaction:Transaction = null) : void
      {
      }
      
      public function updateGameUnits_upgradeCompleted(sku:String, upgradeId:int, transaction:Transaction = null) : void
      {
      }
      
      public function updateSocialItem_nextStep(sku:String, sequence:Boolean, position:Boolean, currentSequence:int, currentPosition:int, currentCount:int, currentQuantity:int) : void
      {
      }
      
      public function updateSocialItem_addItem(sku:String, amount:int) : void
      {
      }
      
      public function updateSocialItem_buyItem(sku:String, transaction:Transaction = null) : void
      {
      }
      
      public function updateSocialItem_useItem(sku:String, amount:int) : void
      {
      }
      
      public function updateSocialItem_removeItem(sku:String, amount:int) : void
      {
      }
      
      public function updateSocialItem_addItemToWishList(sku:String) : void
      {
      }
      
      public function updateSocialItem_sendItemToNeighborWishList(sku:String, toAccountId:String, requestId:String, platform:String) : void
      {
      }
      
      public function updateSocialItem_removeItemFromWishList(sku:String) : void
      {
      }
      
      public function updateSocialItem_applyCrafting(craftSku:String, transaction:Transaction = null) : void
      {
      }
      
      public function updateSocialItem_applyCollectable(sku:String) : void
      {
      }
      
      public function updateAlliances_GetReward(sku:String) : void
      {
      }
      
      public function updateTelemetry_mouseMove(x:int, y:int, w:int, h:int, time:Number) : void
      {
      }
      
      public function updateTelemetry_mouseClick(x:int, y:int, w:int, h:int, time:Number) : void
      {
      }
      
      public function queryVerifyMoneyTransaction(trans:Transaction) : void
      {
      }
      
      public function queryVerifyMoneyConversion(socialCashToBuy:Number, mineralsToBuy:Number, coinsToBuy:Number, cashToBuy:Number, badgesToBuy:Number, itemsToBuy:Object = null, itemsWithOffer:Array = null) : void
      {
      }
      
      public function queryVerifyCreditsPurchase(useRetries:Boolean) : void
      {
      }
      
      public function sendWishlistItem(itemSku:String, accountId:String) : void
      {
      }
      
      public function startRefining(stageId:int, rewardSku:String, timeMinutes:Number, minerals:Number) : void
      {
      }
      
      public function completeRefining() : void
      {
      }
      
      public function quickAttackFindTarget() : void
      {
      }
      
      public function queryGetGalaxyWindow(topLeftCoordX:int, topLeftCoordY:int, bottomRightCoordX:int, bottomRightCoordY:int) : void
      {
      }
      
      public function queryGetStarPlanetsByCoord(coords:DCCoordinate) : void
      {
      }
      
      public function queryGetColonyAvailability(sku:String, starId:Number) : void
      {
      }
      
      public function queryGetColonyConfirmPurchase(sku:String, trans:Transaction, starId:Number) : void
      {
      }
      
      public function queryGetColonyConfirmMove(planetId:int, starId:Number, sku:String, transaction:Transaction) : void
      {
      }
      
      public function queryGetNeighborInfo(accountId:String) : void
      {
      }
      
      public function updateBookmarks_addBookmark(coordX:Number, coordY:Number, starName:String, starNameUserGenerated:String, starId:Number, starType:String) : void
      {
      }
      
      public function updateBookmarks_removeBookmark(coordX:Number, coordY:Number) : void
      {
      }
      
      public function updateTemplates_saveTemplate(slotId:int, itemsData:Object, thumbnailByteArray:String) : void
      {
      }
      
      public function updateTemplates_deleteTemplate(slotId:int) : void
      {
      }
      
      public function updateTemplates_importTemplate(slotId:int, templateUUID:String) : void
      {
      }
      
      public function updatePoll_vote(optionId:int) : void
      {
      }
      
      public function updateBattle_npcAttackStart(happeningSku:String, activePowerUps:String) : void
      {
      }
      
      public function updateBattle_unitDamaged(unitId:int, fromBunkerSid:int, damage:int, unitSku:String, destroyed:Boolean, energyBeforeShot:int, attackerInfo:Object, transaction:Transaction = null) : void
      {
      }
      
      public function updateBattle_itemDamaged(itemSid:int, damage:int, umbrellaDamage:int, destroyed:Boolean, energyBeforeShot:int, attackerInfo:Object, tVictim:Transaction = null, tAttacker:Transaction = null, bunkerContent:Object = null) : void
      {
      }
      
      public function updateBattle_itemMineExploded(itemSid:int) : void
      {
      }
      
      public function updateBattle_started(transaction:Transaction) : void
      {
      }
      
      public function updateBattle_finished(battleTime:Number, coinsStolen:Number = 0, coinsMax:Number = 0, mineralsStolen:Number = 0, mineralsMax:Number = 0, score:Number = 0, scoreMax:Number = 0) : void
      {
      }
      
      public function updateBattle_deployUnits(hangarSid:int, socialItemSku:String, unitsSkus:Array, unitsIds:Array, shotWaitingTimes:Array, shotDamages:Array, energies:Array, x:int, y:int, tileX:int, tileY:int, transaction:Transaction = null) : void
      {
      }
      
      public function updateBattle_specialAttack_usingCash(sku:String, x:int, y:int, unitsSkus:Array, unitsIds:Array, specialAttackId:int, transaction:Transaction = null) : void
      {
      }
      
      public function updateBattle_specialAttack_usingItem(socialItemSku:String, x:int, y:int, unitsSkus:Array, unitsIds:Array, specialAttackId:int) : void
      {
      }
      
      public function updateBattle_ping() : void
      {
      }
      
      public function updateBattle_preStartTimeout() : void
      {
      }
      
      public function updateBattle_umbrellaDamaged(damage:int) : void
      {
      }
      
      public function updateVisitHelp_accelerateItem(sid:int, transaction:Transaction = null) : void
      {
      }
      
      public function updateVisitHelp_dailyBonusDone(coins:Number) : void
      {
      }
      
      public function updateVisitHelp_allActionsDone(minerals:Number) : void
      {
      }
      
      public function updateMisc_visitHelpDone(neighborAccountId:String, accepted:Boolean, clientHelps:Array = null) : void
      {
      }
      
      public function updateMisc_hangarHelpDone(sid:int) : void
      {
      }
      
      public function updateMisc_firstLoadingSuccess(chk:Number) : void
      {
      }
      
      public function updateMisc_coopMission_advanceProgress(sku:String, accountIds:Array) : void
      {
      }
      
      public function updateMisc_pendingTransactionsProcessed(transactionIds:Array) : void
      {
      }
      
      public function updateMisc_spyCapsuleForFree(transaction:Transaction) : void
      {
      }
      
      public function updateMisc_spyCapsuleBought(sku:String, transaction:Transaction) : void
      {
      }
      
      public function updateMisc_upSellingStarted(sku:String) : void
      {
      }
      
      public function updateMisc_serverTest(test:String) : void
      {
      }
      
      public function updateMisc_applyPurchasesFromMobileAdjust(oneCreditLocalPrice:Number, currency:String, mobilePaymentSlots:Array) : void
      {
      }
      
      public function updateHappening_stateCountdown(happeningSku:String) : void
      {
      }
      
      public function updateHappening_stateReadyToStart(happeningSku:String) : void
      {
      }
      
      public function updateHappening_stateRunning(happeningSku:String, HQLevel:int, countdownWaveTime:Number, firstWaveSpawnSku:String, initialKitTransaction:Transaction) : void
      {
      }
      
      public function updateHappening_stateCompleted(happeningSku:String, happeningTransaction:Transaction) : void
      {
      }
      
      public function updateHappening_buyReward(happeningSku:String, idxPack:int, packTransaction:Transaction) : void
      {
      }
      
      public function updateHappening_stateOver(happeningSku:String) : void
      {
      }
      
      public function updateHappeningWave_stateReadyToStart(happeningSku:String, speedUpWaveTransaction:Transaction = null, timeLeft:Number = 0) : void
      {
      }
      
      public function updateHappeningWave_delayWave(happeningSku:String) : void
      {
      }
      
      public function updateHappeningWave_stateRunning(happeningSku:String) : void
      {
      }
      
      public function updateHappeningWave_stateCompleted(happeningSku:String, idxNextWave:int, nextWaveSpawnSku:String, waveTransaction:Transaction) : void
      {
      }
      
      public function updateBets_requestBet(betSku:String) : void
      {
      }
      
      public function updateBets_cancelRequestBet() : void
      {
      }
      
      public function updateBets_requestResult(sku:String) : void
      {
      }
      
      public function updateBets_closeBet(transaction:Transaction) : void
      {
      }
      
      public function updateBets_timeUp() : void
      {
      }
      
      public function updateContest_requestContest() : void
      {
      }
      
      public function updateContest_requestProgress(contestType:String) : void
      {
      }
      
      public function updateContest_requestLeaderboard(contestType:String) : void
      {
      }
      
      public function updateContest_clickMePressed(contestType:String) : void
      {
      }
      
      public function updateContest_lostPopupShown(contestType:String) : void
      {
      }
      
      public function updateContest_flushCommands() : void
      {
      }
      
      public function updateDailyReward_sendTransaction(transaction:Transaction) : void
      {
      }
      
      public function browserRefresh() : void
      {
      }
      
      public function guestUserRegistration() : void
      {
      }
      
      public function browserNavigateToUrl(url:String, window:String = "_blank") : void
      {
         navigateToURL(new URLRequest(url),window);
      }
      
      public function openNeighborsTab(params:Object = null) : void
      {
      }
      
      public function createAlliance(data:Object, transaction:Transaction = null) : void
      {
      }
      
      public function editAlliance(data:Object, transaction:Transaction = null) : void
      {
      }
      
      public function editPublicAllianceVisibility(data:Object) : void
      {
      }
      
      public function requestMyAlliance(data:Object) : void
      {
      }
      
      public function requestAllianceByUserId(data:Object) : void
      {
      }
      
      public function requestAllianceById(data:Object) : void
      {
      }
      
      public function requestAlliances(data:Object) : void
      {
      }
      
      public function requestAlliancesSuggested(data:Object) : void
      {
      }
      
      public function requestAlliancesWarSuggested(data:Object) : void
      {
      }
      
      public function joinAlliance(data:Object) : void
      {
      }
      
      public function leaveAlliance(data:Object) : void
      {
      }
      
      public function promote(data:Object) : void
      {
      }
      
      public function demote(data:Object) : void
      {
      }
      
      public function kickUser(data:Object) : void
      {
      }
      
      public function sendMessage(data:Object) : void
      {
      }
      
      public function requestWarsHistory(data:Object) : void
      {
      }
      
      public function declareWar(data:Object) : void
      {
      }
      
      public function requestNews(data:Object) : void
      {
      }
      
      public function allianceInviteFriends(data:Object) : void
      {
      }
      
      protected function getOneAllianceFromAlliancesWarSuggested(fileString:String, type:String) : void
      {
         var typeId:int = 0;
         var originalType:* = 0;
         var allianceObj:Object = null;
         var alliance:Alliance = null;
         var errorData:Object = null;
         var alliances:Array = [];
         var objJSON:Object;
         if((objJSON = JSON.parse(fileString)).hasOwnProperty("locked") && objJSON["locked"] == 1)
         {
            (errorData = {})["error"] = 23;
            errorData["errorMsg"] = AlliancesConstants.getErrorMsg(23);
            InstanceMng.getAlliancesController().notificationsNotify("getShuffledSuggestedAlliances",false,errorData,null);
            return;
         }
         if(type == "easy")
         {
            typeId = 0;
         }
         else if(type == "medium")
         {
            typeId = 1;
         }
         else if(type == "hard")
         {
            typeId = 2;
         }
         originalType = typeId;
         alliances = objJSON["alliances"];
         var aId:String = "-1";
         var tries:int = 0;
         var goOn:Boolean = false;
         for(tries = 0; tries < 3; )
         {
            allianceObj = alliances[0][typeId];
            if((aId = String(allianceObj["id"])) != "-1")
            {
               goOn = true;
               break;
            }
            typeId++;
            typeId %= 3;
            tries++;
         }
         if(goOn)
         {
            (alliance = new Alliance()).fromJSON(allianceObj);
            InstanceMng.getAlliancesController().notificationsNotify("getShuffledSuggestedAlliances",true,null,{
               "alliance":alliance,
               "isChosenType":typeId == originalType,
               "type":type
            });
         }
         else
         {
            (errorData = {})["error"] = 23;
            errorData["errorMsg"] = AlliancesConstants.getErrorMsg(23);
            InstanceMng.getAlliancesController().notificationsNotify("getShuffledSuggestedAlliances",false,errorData,null);
         }
      }
      
      public function updateInvest_investInFriends(blackList:Array) : void
      {
      }
      
      public function updateInvest_investInFriend(extId:String) : void
      {
      }
      
      public function updateInvest_cancelByAccountId(accountId:String) : void
      {
      }
      
      public function updateInvest_cancelByExtId(extId:String, platformId:String) : void
      {
      }
      
      public function updateInvest_remind(extId:String, platformId:String) : void
      {
      }
      
      public function updateInvest_hurryUp(accountId:String, extId:String) : void
      {
      }
      
      public function updateInvest_applyResult(accountId:String, rewardSku:String = "", transaction:Transaction = null) : void
      {
      }
      
      public function updateInvest_accept(transaction:Transaction) : void
      {
      }
      
      public function updateInvest_sendGift(accountId:String, extId:String) : void
      {
      }
      
      public function purchaseCredits(sku:String, dollars:Number, credits:int) : void
      {
         var data:Object = {
            "sku":"creditsSku:" + sku,
            "dollars":dollars,
            "credits":credits
         };
         this.requestTask(KEY_PURCHASE_CREDITS,data);
      }
      
      public function purchaseItem(sku:String, platformCreditsTag:String) : void
      {
         var data:Object = {"sku":"item:" + sku};
         if(platformCreditsTag != null)
         {
            data.type = platformCreditsTag;
         }
         this.requestTask(KEY_PURCHASE_CREDITS,data);
      }
      
      public function notifyShowCrossPromotion() : void
      {
         this.requestTask(KEY_SHOW_CROSS_PROMOTION);
      }
      
      public function notifyPurchasePromotion(entryStr:String, originStr:String) : void
      {
         this.requestTask(KEY_PURCHASE_PROMOTION,{
            "entry":entryStr,
            "origin":originStr
         });
      }
      
      public function notifyAttackInProgress() : void
      {
         this.requestTask(KEY_ATTACK_IN_PROGRESS);
         DCDebug.traceChObject("NARAN","Calling Naranjito...");
      }
      
      public function startNowAskPermissions() : void
      {
         this.requestTask(KEY_START_NOW_ASK_PERMISSIONS);
      }
      
      public function requestTask(task:String, data:Object = null, transaction:Transaction = null) : void
      {
         var _loc4_:* = task;
         if(KEY_PURCHASE_CREDITS === _loc4_)
         {
            if(InstanceMng.getPlatformSettingsDefMng().getUsePlatformCreditsPopup())
            {
               InstanceMng.getApplication().setToWindowedMode();
            }
            else
            {
               InstanceMng.getApplication().lockUIWaitForPurchaseCredits();
            }
         }
      }
      
      public function requestFile(key:String, url:String) : void
      {
         var loader:URLLoader = new URLLoader();
         loader.addEventListener("complete",this.onLoadFile_COMPLETE);
         loader.addEventListener("ioError",this.onLoadFile_ERROR);
         this.mFileCacheKey[key] = loader;
         this.mFileCache[key] = null;
         try
         {
            loader.load(new URLRequest(url));
         }
         catch(error:Error)
         {
            DCDebug.trace("loadFile-Engine: Unable to load " + url);
         }
      }
      
      private function onLoadFile_COMPLETE(event:Event) : void
      {
         var param:* = null;
         for(param in this.mFileCacheKey)
         {
            if(this.mFileCacheKey[param] == event.target)
            {
               this.mFileCache[param] = event.target.data;
               this.mFileCacheKey[param] = null;
               event.target.removeEventListener("complete",this.onLoadFile_COMPLETE);
               this.onSetFile(param,event.target.data);
               break;
            }
         }
      }
      
      protected function onSetFile(key:String, data:Object) : void
      {
      }
      
      private function onLoadFile_ERROR(event:IOErrorEvent) : void
      {
         event.target.removeEventListener("ioError",this.onLoadFile_ERROR);
         if(Config.DEBUG_MODE)
         {
            DCDebug.traceCh("ERROR","ERROR: UserDataMng:onLoadFile_ERROR: unable to load : " + event,3);
         }
      }
      
      protected function reserveFile(key:String) : void
      {
         this.mFileCacheKey[key] = {};
         this.mFileCache[key] = null;
      }
      
      public function isFileLoaded(key:String) : Boolean
      {
         return this.mFileCache.hasOwnProperty(key) && this.mFileCacheKey[key] == null;
      }
      
      public function allFilesLoaded(printTrace:Boolean = false) : Boolean
      {
         var param:* = null;
         var returnValue:Boolean = true;
         for(param in this.mFileCacheKey)
         {
            if(this.mFileCacheKey[param] != null)
            {
               if(!printTrace || Config.DEBUG_SHORTEN_NOISY)
               {
                  return false;
               }
               DCDebug.traceCh("wait","************* File " + param + " requested to the server not found");
               returnValue = false;
            }
         }
         return returnValue;
      }
      
      public function allFilesLoadedExclude(exclude:Array, printTrace:Boolean = false) : Boolean
      {
         var param:* = null;
         var returnValue:Boolean = true;
         for(param in this.mFileCacheKey)
         {
            if(!ArrayUtil.arrayContainsValue(exclude,param))
            {
               if(this.mFileCacheKey[param] != null)
               {
                  if(!printTrace || Config.DEBUG_SHORTEN_NOISY)
                  {
                     return false;
                  }
                  DCDebug.traceCh("wait","************* File " + param + " requested to the server not found");
                  returnValue = false;
               }
            }
         }
         return returnValue;
      }
      
      public function getFile(key:String) : Object
      {
         var param:* = null;
         for(param in this.mFileCache)
         {
            if(param == key && this.isFileLoaded(key))
            {
               return this.mFileCache[param];
            }
         }
         return null;
      }
      
      public function getFileXML(key:String) : XML
      {
         var data:Object = this.getFile(key);
         if(data != null)
         {
            return new XML(data);
         }
         return null;
      }
      
      protected function setFile(key:String, data:Object) : void
      {
         DCDebug.traceCh("SERVER","=======------ Response: setFile(key: " + key + ")");
         if(!Config.DEBUG_SHORTEN_NOISY || Config.DEBUG_SHORTEN_NOISY_CMDS.indexOf(key) == -1)
         {
            if(data is XML)
            {
               DCDebug.traceCh("SERVER",XML(data).toXMLString());
            }
            else
            {
               DCDebug.traceChObject("SERVER",data);
            }
         }
         else
         {
            DCDebug.traceCh("SERVER",key + " info omitted");
         }
         DCDebug.traceCh("SERVER","----------===================");
         this.mFileCache[key] = data;
         this.mFileCacheKey[key] = null;
      }
      
      public function freeFile(key:String) : void
      {
         delete this.mFileCache[key];
         delete this.mFileCacheKey[key];
      }
      
      public function getServerCurrentTimemillis() : Number
      {
         return this.mServerCurrentTimeMillis;
      }
      
      public function getGameCurrentTimemillis() : Number
      {
         return this.mGameRunningMillis;
      }
      
      public function getTimeFromLastLogin() : Number
      {
         return 0;
      }
      
      public function getAdsManager() : DCAdsManager
      {
         return this.mAdsManager;
      }
      
      public function notifyException(name:String, message:String, stacktrace:String) : void
      {
      }
      
      public function openCreditsPopup() : void
      {
      }
      
      public function saveTemplatesLocally(data:Object) : void
      {
      }
      
      public function isNewPayerOfferPromoAvailable() : Boolean
      {
         return true;
      }
      
      public function addRequestTaskReceived(cmd:String) : void
      {
         if(this.mRequestsTimes == null)
         {
            this.mRequestsTimes = new Dictionary();
         }
         if(this.mRequestsTimes[cmd] == null)
         {
            this.mRequestsTimes[cmd] = this.getServerCurrentTimemillis();
         }
      }
      
      public function onServerResponseReceived(cmd:String) : void
      {
         var reqTime:Number = NaN;
         var currTimeMs:Number = NaN;
         var totalReqTime:Number = NaN;
         var totalReqTimeSecs:Number = NaN;
         if(this.mRequestsTimes != null)
         {
            if(this.mRequestsTimes[cmd] != null)
            {
               reqTime = Number(this.mRequestsTimes[cmd]);
               totalReqTime = (currTimeMs = this.getServerCurrentTimemillis()) - reqTime;
               totalReqTimeSecs = totalReqTime / 1000;
               if(Config.DEBUG_REQ_TIME)
               {
                  DCDebug.traceCh("REQTIME","Request cmd: [" + cmd + "]");
                  DCDebug.traceCh("REQTIME","Request timestamp: " + DCTimerUtil.dateFromMs(reqTime));
                  DCDebug.traceCh("REQTIME","Response timestamp: " + DCTimerUtil.dateFromMs(currTimeMs));
                  DCDebug.traceCh("REQTIME","Total response time: " + totalReqTimeSecs + " seconds.");
                  DCDebug.traceCh("REQTIME","******************************");
                  DCDebug.traceCh("REQTIME","");
               }
               this.mRequestsTimes[cmd] = null;
            }
         }
      }
      
      protected function getMyName() : String
      {
         var name:String = null;
         var userInfo:UserInfo = InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj();
         if(userInfo != null)
         {
            name = userInfo.getPlayerName();
         }
         return name != null ? name : "";
      }
      
      protected function getNameByAccountId(accountId:String) : String
      {
         var name:String = null;
         var userInfo:UserInfo = InstanceMng.getUserInfoMng().getUserInfoObj(accountId,0);
         if(userInfo != null)
         {
            name = userInfo.getPlayerName();
         }
         return name != null ? name : "";
      }
      
      public function get mBattleStartWithScore() : int
      {
         return 0;
      }
      
      public function set mBattleStartWithScore(value:int) : void
      {
      }
   }
}
