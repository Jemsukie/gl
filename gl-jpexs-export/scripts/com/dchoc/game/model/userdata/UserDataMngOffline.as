package com.dchoc.game.model.userdata
{
   import com.dchoc.game.controller.alliances.AlliancesController;
   import com.dchoc.game.core.flow.Application;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.alliances.Alliance;
   import com.dchoc.game.model.alliances.AlliancesConstants;
   import com.dchoc.game.model.alliances.AlliancesUser;
   import com.dchoc.game.model.rule.CreditsDef;
   import com.dchoc.game.model.upselling.UpSellingOffer;
   import com.dchoc.game.model.userdata.contest.ContestOffline;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.resource.DCResourceMng;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import flash.events.Event;
   import flash.net.FileReference;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.clearInterval;
   import flash.utils.setTimeout;
   
   public class UserDataMngOffline extends UserDataMng
   {
      
      private static const CALL_DELAY_MS:int = 100;
      
      private static const PING_STATE_DISABLED:int = -2;
      
      private static const PING_STATE_NONE:int = -1;
      
      private static const PING_STATE_SEND_HIS_IS_READY:int = 1;
      
      private static const PING_STATE_SEND_HIS_BATTLE_HAS_STARTED:int = 2;
      
      private static const PING_STATE_SEND_HIS_BATTLE_PROGRESS:int = 3;
      
      private static const PING_STATE_SEND_HIS_BATTLE_HAS_FINISHED:int = 4;
       
      
      private var mIsFinished:Boolean;
      
      private var mLoadingFiles:Boolean;
      
      private var mTimeToFinishLogin:int = 2000;
      
      private var mPurchaseCreditsSku:String;
      
      private var mChaseSids:Array;
      
      private var mHangarsOwnerXML:XML;
      
      private var mCount:int = 0;
      
      private var mTimeoutsIds:Vector.<uint>;
      
      private const TRANS_TIME:int = 500;
      
      private var mTransactionTimer:Number = -1;
      
      private var mQueryResponseData:Object;
      
      private var mNeighborInfoData:Object;
      
      private const SPACE_MAPS_TIMEOUT:int = 500;
      
      private var mSolarSystemTimer:Number = -1;
      
      private var mSolarSystemQueryResponseData:Object;
      
      private var mGalaxyTimer:Number = -1;
      
      private var mGalaxyQueryResponseData:Object;
      
      private var mColonyAvailabilityTimer:Number = -1;
      
      private var mColonyAvailabilityResponseData:Object;
      
      private var mColonyPurchaseTimer:Number = -1;
      
      private var mColonyPurchaseResponseData:Object;
      
      private var mColonyMoveTimer:Number = -1;
      
      private var mColonyMoveResponseData:Object;
      
      private var mUses2:Boolean = false;
      
      private var mAttempts:int = 0;
      
      private var mIndex:int = 0;
      
      private var mQuickAttackUsesCount:int = 0;
      
      private var mCancelRequestBet:Boolean = false;
      
      private var mPingState:int;
      
      private var mPingTimeChangeState:Number;
      
      private var mContestOffline:ContestOffline;
      
      public function UserDataMngOffline()
      {
         this.mChaseSids = [];
         super(true);
         init();
         mUserIsVIP = false;
      }
      
      override public function loadFiles() : void
      {
         var universeName:String = null;
         if(!this.mIsFinished)
         {
            universeName = "userdata/universe.xml";
            requestFile(KEY_UNIVERSE,DCResourceMng.getFileName(universeName));
            requestFile(KEY_FRIENDS_LIST,DCResourceMng.getFileName("userdata/friendsList.xml"));
            requestFile(KEY_NEIGHBOR_LIST,DCResourceMng.getFileName("userdata/neighborList.xml"));
            requestFile(KEY_NPC_NEIGHBOR_LIST,DCResourceMng.getFileName("userdata/npcList.xml"));
            requestFile(KEY_ITEMS_LIST,DCResourceMng.getFileName("userdata/itemsList.xml"));
            requestFile(KEY_ACTIONS_PERFORMED_BY_FRIENDS_LIST,DCResourceMng.getFileName("userdata/actionsPerformedByFriendsList.xml"));
            requestFile(KEY_HANGARS_HELP_LIST,DCResourceMng.getFileName("userdata/hangarsHelpList.xml"));
            requestFile(KEY_BOOKMARKS,DCResourceMng.getFileName("userdata/bookmarks.xml"));
            requestFile(KEY_CUSTOMIZER,DCResourceMng.getFileName("userdata/customizer.xml"));
            requestFile(KEY_ATTACKER_LIST,DCResourceMng.getFileName("userdata/attackerList.xml"));
            requestFile(KEY_BATTLE_REPLAY,DCResourceMng.getFileName("userdata/battleReplay.xml"));
            if(Config.OFFLINE_ALLIANCES_MODE)
            {
               requestFile(KEY_ALLIANCES_LIST,DCResourceMng.getFileName("userdata/alliancesList.json"));
               requestFile(KEY_ALLIANCES_LIST_2,DCResourceMng.getFileName("userdata/alliancesList2.json"));
               requestFile(KEY_ALLIANCES_WARS_HISTORY_LIST,DCResourceMng.getFileName("userdata/alliancesWarsHistory.json"));
               requestFile(KEY_ALLIANCES_WARS_HISTORY_LIST_2,DCResourceMng.getFileName("userdata/alliancesWarsHistory2.json"));
               requestFile(KEY_ALLIANCES_NEWS,DCResourceMng.getFileName("userdata/alliancesNews.json"));
               requestFile(KEY_PENDING_TRANSACTIONS,DCResourceMng.getFileName("userdata/pendingTransactions.xml"));
               requestFile(KEY_ALLIANCES_SUGGESTED_WAR,DCResourceMng.getFileName("userdata/alliancesSuggestedWar.json"));
            }
            if(Config.useContests())
            {
               requestFile(KEY_CONTEST_LIST,DCResourceMng.getFileName("userdata/contestList.json"));
               requestFile(KEY_CONTEST_PROGRESS,DCResourceMng.getFileName("userdata/contestProgress.json"));
               requestFile(KEY_CONTEST_LEADERBOARD,DCResourceMng.getFileName("userdata/contestLeaderboard.json"));
            }
            requestFile(KEY_WEEKLY_SCORE_LIST,DCResourceMng.getFileName("userdata/weeklyScoreList.xml"));
            requestFile(KEY_UPSELLING,DCResourceMng.getFileName("userdata/upSelling.xml"));
            requestFile(KEY_TEMPLATES,DCResourceMng.getFileName("userdata/templates.xml"));
            this.mLoadingFiles = true;
         }
      }
      
      private function getOwnerUniverseName(isCapital:Boolean) : String
      {
         var universeName:String = isCapital ? "userdata/universe.xml" : "userdata/universeColony.xml";
         if(InstanceMng.getFlowStatePlanet().isTutorialRunning() && !InstanceMng.getFlowStatePlanet().isPlayerIsBackFromVisiting())
         {
            universeName = "userdata/universe.xml";
         }
         return universeName;
      }
      
      override protected function unloadDo() : void
      {
         var id:uint = 0;
         super.unloadDo();
         if(this.mTimeoutsIds != null)
         {
            while(this.mTimeoutsIds.length > 0)
            {
               id = this.mTimeoutsIds.shift();
               clearInterval(id);
            }
         }
         this.mTimeoutsIds = null;
         this.mIsFinished = false;
         this.mLoadingFiles = false;
         this.mTimeToFinishLogin = 2000;
         this.mPurchaseCreditsSku = null;
      }
      
      override public function isLoaded() : Boolean
      {
         return this.mIsFinished && allFilesLoaded();
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         super.logicUpdateDo(dt);
         if(this.mTimeToFinishLogin >= 0)
         {
            this.mTimeToFinishLogin -= dt;
            if(this.mTimeToFinishLogin <= 0)
            {
               mUserIsVIP = true;
            }
         }
         if(!this.mIsFinished && this.mLoadingFiles)
         {
            this.mIsFinished = allFilesLoaded();
            if(this.mIsFinished)
            {
               build();
            }
         }
         this.transactionOnHoldLogicUpdate(dt);
         this.solarSystemInfoOnHoldLogicUpdate(dt);
         this.colonyAvailabilityOnHoldLogicUpdate(dt);
         this.colonyPurchaseOnHoldLogicUpdate(dt);
         this.colonyMoveOnHoldLogicUpdate(dt);
         this.galaxyInfoOnHoldLogicUpdate(dt);
      }
      
      override public function updateItem_destroy(sid:int, transaction:Transaction = null) : void
      {
         if(this.mChaseSids.indexOf(sid) <= -1)
         {
            this.mChaseSids.push(sid);
         }
      }
      
      override public function updateItem_instantRecicle(sid:int, transaction:Transaction = null) : void
      {
      }
      
      private function transactionOnHoldLogicUpdate(dt:int) : void
      {
         if(this.mTransactionTimer >= 0)
         {
            this.mTransactionTimer -= dt;
            if(this.mTransactionTimer <= 0)
            {
               this.mTransactionTimer = -1;
               Application.externalNotification(5,this.mQueryResponseData);
            }
         }
      }
      
      private function solarSystemInfoOnHoldLogicUpdate(dt:int) : void
      {
         if(this.mSolarSystemTimer != -1)
         {
            this.mSolarSystemTimer -= dt;
            if(this.mSolarSystemTimer <= 0)
            {
               this.mSolarSystemTimer = -1;
               Application.externalNotification(7,this.mSolarSystemQueryResponseData);
            }
         }
      }
      
      private function galaxyInfoOnHoldLogicUpdate(dt:int) : void
      {
         if(this.mGalaxyTimer != -1)
         {
            this.mGalaxyTimer -= dt;
            if(this.mGalaxyTimer <= 0)
            {
               this.mGalaxyTimer = -1;
               Application.externalNotification(15,this.mGalaxyQueryResponseData);
            }
         }
      }
      
      private function colonyAvailabilityOnHoldLogicUpdate(dt:int) : void
      {
         if(this.mColonyAvailabilityTimer != -1)
         {
            this.mColonyAvailabilityTimer -= dt;
            if(this.mColonyAvailabilityTimer <= 0)
            {
               this.mColonyAvailabilityTimer = -1;
               Application.externalNotification(9,this.mColonyAvailabilityResponseData);
            }
         }
      }
      
      private function colonyPurchaseOnHoldLogicUpdate(dt:int) : void
      {
         if(this.mColonyPurchaseTimer != -1)
         {
            this.mColonyPurchaseTimer -= dt;
            if(this.mColonyPurchaseTimer <= 0)
            {
               this.mColonyPurchaseTimer = -1;
               Application.externalNotification(11,this.mColonyPurchaseResponseData);
            }
         }
      }
      
      private function colonyMoveOnHoldLogicUpdate(dt:int) : void
      {
         if(this.mColonyMoveTimer != -1)
         {
            this.mColonyMoveTimer -= dt;
            if(this.mColonyMoveTimer <= 0)
            {
               this.mColonyMoveTimer = -1;
               Application.externalNotification(23,this.mColonyMoveResponseData);
            }
         }
      }
      
      override public function login(retry:Boolean = false) : void
      {
         mUserAccountId = "a-10";
         mServerCurrentTimeMillis = DCTimerUtil.currentTimeMillis();
      }
      
      override public function isLogged() : Boolean
      {
         return this.mTimeToFinishLogin <= 0;
      }
      
      private function doRequestUniverse(task:String, data:Object = null, transaction:Transaction = null) : void
      {
         var fileName:String = null;
         var profile:Profile = null;
         var isCapital:* = false;
         var userInfo:UserInfo = null;
         if(data.userId == mUserAccountId)
         {
            isCapital = (profile = InstanceMng.getUserInfoMng().getProfileLogin()).getCapitalPlanet().getPlanetId() == data.planetId;
            fileName = this.getOwnerUniverseName(isCapital);
         }
         else
         {
            if(data.userId != null)
            {
               userInfo = InstanceMng.getUserInfoMng().getUserInfoObj(data.userId,0,2);
            }
            else
            {
               userInfo = InstanceMng.getUserInfoMng().getUserInfoObj(data.advisorSku,0,3);
            }
            if(userInfo != null && userInfo.mIsNPC.value)
            {
               fileName = "userdata/universe_" + userInfo.mExtId + "0.xml";
            }
            else if(data.attack == "1")
            {
               fileName = "userdata/universeFriend2.xml";
            }
            else
            {
               fileName = this.mCount % 2 == 0 ? "userdata/universeFriend.xml" : "userdata/universeFriend2.xml";
               this.mCount++;
            }
         }
         requestFile(task,DCResourceMng.getFileName(fileName));
      }
      
      private function timeoutsAddId(id:uint) : void
      {
         if(this.mTimeoutsIds == null)
         {
            this.mTimeoutsIds = new Vector.<uint>(0);
         }
         this.mTimeoutsIds.push(id);
      }
      
      override public function requestTask(task:String, data:Object = null, transaction:Transaction = null) : void
      {
         var fileName:String = null;
         var tokens:Array = null;
         super.requestTask(task,data,transaction);
         if(data == null)
         {
            data = {};
         }
         switch(task)
         {
            case KEY_HANGARS_OWNER:
               this.mHangarsOwnerXML = InstanceMng.getHangarControllerMng().getProfileLoginHangarController().persistenceGetData();
               fileName = "userdata/hangarsOwnerList.xml";
               requestFile(task,DCResourceMng.getFileName(fileName));
               break;
            case KEY_UNIVERSE:
               reserveFile(KEY_UNIVERSE);
               this.timeoutsAddId(setTimeout(this.doRequestUniverse,1000,task,data,transaction));
               break;
            case KEY_GALAXY_WINDOW:
               fileName = "userdata/galaxyWindow.xml";
               requestFile(task,DCResourceMng.getFileName(fileName));
               this.timeoutsAddId(setTimeout(this.queryGetGalaxyWindow,1000,data.topLeftCoordX,data.topLeftCoordY,data.bottomRightCoordX,data.bottomRightCoordY));
               break;
            case KEY_STAR_PLANETS_WINDOW:
               DCDebug.trace("data.starId : " + data.starId);
               fileName = "userdata/starPlanetsWindow.xml";
               requestFile(task,DCResourceMng.getFileName(fileName));
               this.timeoutsAddId(setTimeout(this.queryGetStarPlanetsByCoord,1000,data.coords));
               break;
            case KEY_BOOKMARKS:
               fileName = "userdata/bookmarks.xml";
               requestFile(task,DCResourceMng.getFileName(fileName));
               break;
            case KEY_CHECK_AVAILABLE_ATTACK:
            case KEY_CHECK_WARP_BUNKER_TRANSFER:
               this.timeoutsAddId(setTimeout(this.simulateServerResponse,10,task));
               break;
            case KEY_PURCHASE_CREDITS:
               this.doPurchaseCredits();
               tokens = data.sku.split(":");
               this.mPurchaseCreditsSku = tokens[1];
               break;
            case KEY_SPY_STATUS:
               DCDebug.trace("***Can\'t perform server action: " + data.action);
               break;
            case KEY_OFFER_CREDITS:
               InstanceMng.getApplication().setToWindowedMode();
               break;
            case KEY_INVESTS_LIST:
               if(Config.useInvests())
               {
                  this.timeoutsAddId(setTimeout(this.onResponseInvestsList,2000));
               }
               break;
            case KEY_UPSELLING:
               fileName = "userdata/upSelling.xml";
               requestFile(task,DCResourceMng.getFileName(fileName));
         }
      }
      
      private function onResponseInvestsList() : void
      {
         requestFile(KEY_INVESTS_LIST,DCResourceMng.getFileName("userdata/investsList.xml"));
      }
      
      private function simulateServerResponse(task:String) : void
      {
         var data:Object = null;
         switch(task)
         {
            case KEY_CHECK_AVAILABLE_ATTACK:
               data = {
                  "attack":true,
                  "lockApplied":1
               };
               break;
            case KEY_CHECK_WARP_BUNKER_TRANSFER:
               requestFile(KEY_CHECK_WARP_BUNKER_TRANSFER,DCResourceMng.getFileName("userdata/hangarUpdated.xml"));
         }
         if(data != null)
         {
            setFile(task,data);
         }
      }
      
      override protected function onSetFile(key:String, data:Object) : void
      {
         super.setFile(key,data);
         if(key == KEY_HANGARS_OWNER)
         {
            mFileCache[KEY_HANGARS_OWNER] = this.mHangarsOwnerXML;
         }
      }
      
      override public function saveUniverse(u:XML, fileName:String) : void
      {
         var str:String = u.toXMLString();
         var ba:ByteArray;
         (ba = new ByteArray()).writeUTFBytes(str);
         var fr:FileReference;
         (fr = new FileReference()).save(ba,fileName);
         fr.addEventListener("complete",this.onSaveUniverseComplete);
      }
      
      private function onSaveUniverseComplete(e:Event) : void
      {
         var fr:FileReference = e.target as FileReference;
         if(fr != null)
         {
            fr.removeEventListener("complete",this.onSaveUniverseComplete);
         }
      }
      
      override public function flushUniverse() : void
      {
      }
      
      override public function queryVerifyMoneyTransaction(trans:Transaction) : void
      {
         var itemSku:* = null;
         this.mTransactionTimer = 500;
         var itemsToBuy:Object = {};
         var transItems:Dictionary = trans.mDifferencesItemsAmount;
         if(transItems != null)
         {
            for(itemSku in transItems)
            {
               itemsToBuy[itemSku] = transItems[itemSku];
            }
         }
         var profile:Profile;
         var profCash:Number = (profile = InstanceMng.getUserInfoMng().getProfileLogin()).getCash();
         var transCash:int = Math.abs(trans.getTransCashToExchange());
         var futureProfileCash:Number = profCash >= transCash ? -transCash : transCash - profCash;
         var futureCoins:Number = trans.getTransCurrencyLeftToPay(1);
         var futureMinerals:Number = trans.getTransCurrencyLeftToPay(2);
         this.mQueryResponseData = {
            "cash":futureProfileCash,
            "coins":futureCoins,
            "minerals":futureMinerals,
            "items":itemsToBuy
         };
      }
      
      override public function openNeighborsTab(params:Object = null) : void
      {
         InstanceMng.getApplication().setToWindowedMode();
      }
      
      override public function queryGetGalaxyWindow(topLeftCoordX:int, topLeftCoordY:int, bottomRightCoordX:int, bottomRightCoordY:int) : void
      {
         var galaxyXML:XML;
         if((galaxyXML = getFileXML(KEY_GALAXY_WINDOW)) != null)
         {
            this.mGalaxyQueryResponseData = {"xml":galaxyXML};
            Application.externalNotification(15,this.mGalaxyQueryResponseData);
         }
      }
      
      override public function queryGetStarPlanetsByCoord(coords:DCCoordinate) : void
      {
         var solarSystemsXML:XML = getFileXML(KEY_STAR_PLANETS_WINDOW);
         if(solarSystemsXML != null)
         {
            this.mSolarSystemQueryResponseData = {"xml":solarSystemsXML};
            Application.externalNotification(7,this.mSolarSystemQueryResponseData);
         }
      }
      
      override public function queryGetColonyAvailability(sku:String, starId:Number) : void
      {
         this.mColonyAvailabilityTimer = 500;
         this.mColonyAvailabilityResponseData = {"colonyAvailable":true};
      }
      
      override public function queryGetColonyConfirmPurchase(sku:String, trans:Transaction, starId:Number) : void
      {
         this.mColonyPurchaseTimer = 500;
         var planetId:String = "2";
         var starIdStr:String = "" + starId;
         var playerInfo:UserInfo;
         if((playerInfo = InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj()) != null)
         {
            planetId = "" + (playerInfo.getPlanetsAmount() + 1);
            if(playerInfo.getCapital())
            {
               starIdStr = "" + playerInfo.getCapital().getParentStarId();
            }
         }
         this.mColonyPurchaseResponseData = {
            "colonyPurchase":true,
            "planetSku":sku,
            "planetId":planetId,
            "starId":starIdStr
         };
      }
      
      override public function queryGetColonyConfirmMove(planetId:int, starId:Number, sku:String, transaction:Transaction) : void
      {
         this.mColonyMoveTimer = 500;
         var starIdStr:String = "" + starId;
         var playerInfo:UserInfo;
         if((playerInfo = InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj()) != null)
         {
            if(playerInfo.getCapital())
            {
               starIdStr = "" + playerInfo.getCapital().getParentStarId();
            }
         }
         this.mColonyMoveResponseData = {
            "colonyMove":true,
            "planetSku":sku,
            "planetId":planetId,
            "starId":starIdStr
         };
      }
      
      private function doPurchaseCredits() : void
      {
         this.timeoutsAddId(setTimeout(this.updateCredits,1000,true));
      }
      
      override public function queryVerifyCreditsPurchase(useRetries:Boolean) : void
      {
         this.timeoutsAddId(setTimeout(this.updateCredits,1000,false));
      }
      
      private function updateCredits(purchaseCredits:Boolean = false) : void
      {
         var transactionXml:XML = null;
         var value:int = 0;
         var items:Array = null;
         var item:Array = null;
         var sourceStr:String = null;
         var paramsStr:String = null;
         var offer:UpSellingOffer = null;
         var pendingTransactionsXml:XML = <pendingTransactions/>;
         var id:String = InstanceMng.getApplication().getCreditId();
         var creditDef:CreditsDef;
         if((creditDef = InstanceMng.getCreditsMng().getDefBySku(id) as CreditsDef) != null)
         {
            value = creditDef.getFreePremiumCurrency() + creditDef.getPremiumCurrency();
            Application.externalNotification(14,{
               "status":true,
               "value":value
            });
            if((items = creditDef.getItems()) != null)
            {
               for each(item in items)
               {
                  sourceStr = "purchase";
                  paramsStr = "";
                  if(InstanceMng.getUpSellingMng().isItemSkuOfferedByCurrentOffer(item[0]))
                  {
                     sourceStr = "upSelling";
                     offer = InstanceMng.getUpSellingMng().getOfferRunning();
                     if(offer != null)
                     {
                        paramsStr = "sku:" + offer.getSku();
                     }
                  }
                  transactionXml = <Transaction id="1" type="item" source="{sourceStr}" itemSku="{item[0]}" amount="{item[1]}" notifyServerByAddItem="0" params="{paramsStr}"/>;
                  pendingTransactionsXml.appendChild(transactionXml);
                  Application.externalNotification(21,{"pendingTransactions":pendingTransactionsXml});
               }
            }
         }
         else if(this.mPurchaseCreditsSku != null)
         {
            if(purchaseCredits)
            {
               Application.externalNotification(13,{"status":true});
            }
            else
            {
               transactionXml = <Transaction id="1" type="item" source="purchase" itemSku="{this.mPurchaseCreditsSku}" amount="1" notifyServerByAddItem="0"/>;
               pendingTransactionsXml.appendChild(transactionXml);
               Application.externalNotification(21,{"pendingTransactions":pendingTransactionsXml});
            }
         }
      }
      
      override public function sendWishlistItem(itemSku:String, accountId:String) : void
      {
         var data:Object = {};
         data.cmd = "wishlistSentItem";
         data.accountId = accountId;
         data.sku = itemSku;
         data.requestId = 0;
         this.timeoutsAddId(setTimeout(this.sendItemFinish,2000,4,data));
      }
      
      override public function startRefining(stageId:int, rewardSku:String, timeMinutes:Number, minerals:Number) : void
      {
      }
      
      override public function completeRefining() : void
      {
      }
      
      private function sendItemFinish(notify:int, data:Object) : void
      {
         Application.externalNotification(notify,data);
      }
      
      override public function getServerCurrentTimemillis() : Number
      {
         var time:Date = new Date();
         return time.valueOf();
      }
      
      public function alliancesSetUses2(value:Boolean) : void
      {
         this.mUses2 = value;
      }
      
      private function getAlliancesListContent() : String
      {
         var key:String = this.mUses2 ? UserDataMng.KEY_ALLIANCES_LIST_2 : UserDataMng.KEY_ALLIANCES_LIST;
         return String(InstanceMng.getUserDataMng().getFile(key));
      }
      
      private function getAlliancesWarsHistoryContent() : String
      {
         var key:String = this.mUses2 ? UserDataMng.KEY_ALLIANCES_WARS_HISTORY_LIST_2 : UserDataMng.KEY_ALLIANCES_WARS_HISTORY_LIST;
         return String(InstanceMng.getUserDataMng().getFile(key));
      }
      
      override public function createAlliance(data:Object, transaction:Transaction = null) : void
      {
         var key:String = AlliancesConstants.objGetKey(data,"name");
         var name:String = String(data[key]);
         key = AlliancesConstants.objGetKey(data,"description");
         var description:String = String(data[key]);
         key = AlliancesConstants.objGetKey(data,"logo");
         var logo:String = String(data[key]);
         key = AlliancesConstants.objGetKey(data,"publicRecruit");
         var isPublic:Boolean = Boolean(data[key]);
         this.timeoutsAddId(setTimeout(this.onCreateAlliance,100,name,description,logo,isPublic,transaction));
      }
      
      override public function editAlliance(data:Object, transaction:Transaction = null) : void
      {
         var key:String = AlliancesConstants.objGetKey(data,"description");
         var description:String = String(data[key]);
         key = AlliancesConstants.objGetKey(data,"logo");
         var logo:String = String(data[key]);
         this.timeoutsAddId(setTimeout(this.onEditAlliance,100,description,logo,transaction));
      }
      
      override public function requestMyAlliance(data:Object) : void
      {
         var fileString:String = this.getAlliancesListContent();
         var file:Object = JSON.parse(fileString);
         var allianceId:String = String(file.allianceId);
         if(this.mAttempts > 1)
         {
            allianceId = "11";
         }
         this.timeoutsAddId(setTimeout(this.onRequestAllianceById,100,allianceId,true,"requestMyAlliance",data));
      }
      
      override public function requestAllianceByUserId(data:Object) : void
      {
         var key:String = AlliancesConstants.objGetKey(data,"memberId");
         var userId:String = String(data[key]);
         this.timeoutsAddId(setTimeout(this.onRequestAllianceById,100,userId,false,"requestAllianceByUserId",data));
      }
      
      override public function requestAllianceById(data:Object) : void
      {
         var key:String = AlliancesConstants.objGetKey(data,"aid");
         var allianceId:String = String(data[key]);
         key = AlliancesConstants.objGetKey(data,"includeMembers");
         var includeMembers:Boolean = Boolean(data[key]);
         this.timeoutsAddId(setTimeout(this.onRequestAllianceById,100,allianceId,includeMembers,"requestAllianceById",data));
      }
      
      override public function requestAlliances(data:Object) : void
      {
         this.timeoutsAddId(setTimeout(this.onRequestAlliancesSuccess,100,data));
      }
      
      override public function requestAlliancesWarSuggested(data:Object) : void
      {
         this.timeoutsAddId(setTimeout(this.onRequestAlliancesWarSuggestedSuccess,100,data));
      }
      
      override public function joinAlliance(data:Object) : void
      {
         this.timeoutsAddId(setTimeout(this.onJoinAllianceSuccess,100,data));
      }
      
      override public function leaveAlliance(data:Object) : void
      {
         if(InstanceMng.getAlliancesController().getMyAlliance().isInAWar())
         {
            this.timeoutsAddId(setTimeout(this.onAlliancesFailed,100,"leaveAlliance",19,data));
         }
         else
         {
            this.timeoutsAddId(setTimeout(this.onAlliancesSuccess,100,"leaveAlliance",data));
         }
      }
      
      override public function promote(data:Object) : void
      {
         this.timeoutsAddId(setTimeout(this.onAlliancesSuccess,100,"changeUserRole",data));
      }
      
      override public function demote(data:Object) : void
      {
         this.timeoutsAddId(setTimeout(this.onAlliancesSuccess,100,"changeUserRole",data));
      }
      
      override public function kickUser(data:Object) : void
      {
         if(InstanceMng.getAlliancesController().getMyAlliance().isInAWar())
         {
            this.timeoutsAddId(setTimeout(this.onAlliancesFailed,100,"kickUser",11,data));
         }
         else
         {
            this.timeoutsAddId(setTimeout(this.onAlliancesSuccess,100,"kickUser",data));
         }
      }
      
      override public function requestWarsHistory(data:Object) : void
      {
         this.timeoutsAddId(setTimeout(this.onRequestWarsHistorySuccess,100,data));
      }
      
      override public function declareWar(data:Object) : void
      {
         this.timeoutsAddId(setTimeout(this.onDeclareWarSuccess,100,data));
      }
      
      override public function requestNews(data:Object) : void
      {
         this.timeoutsAddId(setTimeout(this.onRequestNewsSuccess,100,data));
      }
      
      override public function allianceInviteFriends(data:Object) : void
      {
      }
      
      private function onRequestNewsSuccess(params:Object) : void
      {
         var newJSON:Object = null;
         var data:Object = null;
         var start_index:int = int(params["fromIndex"]);
         var count:int = int(params["count"]);
         var fileString:String = String(InstanceMng.getUserDataMng().getFile(UserDataMng.KEY_ALLIANCES_NEWS));
         var file:Object = JSON.parse(fileString);
         var currentId:int = 0;
         var lastId:int = start_index + count - 1;
         var news:Array = [];
         var pTotalNews:int = 0;
         for each(newJSON in file.News.New)
         {
            if(currentId <= lastId)
            {
               if(currentId >= start_index)
               {
                  news.push(newJSON);
               }
            }
            currentId++;
            pTotalNews++;
         }
         (data = {}).News = {
            "totalNews":pTotalNews,
            "New":news
         };
         InstanceMng.getAlliancesController().notificationsNotify("requestNews",true,data,params);
      }
      
      private function onDeclareWarSuccess(params:Object) : void
      {
         InstanceMng.getAlliancesController().notificationsNotify("declareWar",true,null,params);
      }
      
      private function onRequestAlliancesWarSuggestedSuccess(params:Object) : void
      {
         getOneAllianceFromAlliancesWarSuggested(getFile(KEY_ALLIANCES_SUGGESTED_WAR) as String,params["type"]);
      }
      
      private function onRequestWarsHistorySuccess(params:Object) : void
      {
         var fileString:String = this.getAlliancesWarsHistoryContent();
         var file:Object = JSON.parse(fileString);
         InstanceMng.getAlliancesController().notificationsNotify("requestWarHistory",true,file,params);
      }
      
      private function onJoinAllianceSuccess(params:Object) : void
      {
         var pAllianceId:String = String(params["aid"]);
         var alliance:Alliance = this.getAllianceById(pAllianceId,false);
         if(alliance == null)
         {
            InstanceMng.getAlliancesController().notificationsNotify("joinAlliance",false,{
               "result":"false",
               "error":8
            },params);
         }
         else
         {
            InstanceMng.getAlliancesController().notificationsNotify("joinAlliance",true,{"result":"true"},params);
         }
      }
      
      private function onAlliancesSuccess(cmd:String, params:Object) : void
      {
         InstanceMng.getAlliancesController().notificationsNotify(cmd,true,null,params);
      }
      
      private function onAlliancesFailed(cmd:String, errorCode:int, params:Object) : void
      {
         InstanceMng.getAlliancesController().notificationsNotify(cmd,false,{
            "result":false,
            "error":errorCode
         },params);
      }
      
      private function onRequestAlliancesSuccess(params:Object) : void
      {
         var allianceObject:Object = null;
         var dataJSON:Object = null;
         var start_index:* = int(params["from"]);
         var count:int = int(params["count"]);
         var searchMyAlli:Boolean = Boolean(params["userPage"]);
         var myAlli:Alliance = InstanceMng.getAlliancesController().getMyAlliance();
         var currentId:int = 0;
         var alliances:Array = [];
         var fileString:String = this.getAlliancesListContent();
         var file:Object = JSON.parse(fileString);
         var pTotalAlliances:int = 0;
         var index:int = 0;
         if(searchMyAlli && myAlli != null)
         {
            for each(allianceObject in file.alliances)
            {
               if(allianceObject["id"] == myAlli.getId())
               {
                  break;
               }
               index++;
            }
            start_index = index;
            while(start_index % count > 0)
            {
               start_index--;
            }
         }
         var lastId:int = start_index + count - 1;
         for each(allianceObject in file.alliances)
         {
            if(currentId <= lastId)
            {
               if(currentId >= start_index)
               {
                  alliances.push(allianceObject);
               }
            }
            currentId++;
            pTotalAlliances++;
         }
         dataJSON = {
            "totalSize":file.alliances.length,
            "alliances":alliances
         };
         InstanceMng.getAlliancesController().notificationsNotify("requestAlliancesList",true,dataJSON,params);
      }
      
      private function onCreateAlliance(name:String, description:String, logo:String, isPublic:Boolean, transaction:Transaction = null) : void
      {
         var controller:AlliancesController = InstanceMng.getAlliancesController();
         var data:Object = {
            "id":"0",
            "name":name,
            "description":description,
            "logo":logo,
            "publicRecruit":isPublic
         };
         var myUser:AlliancesUser;
         (myUser = controller.getMyUser()).setRole("LEADER");
         if(myUser != null)
         {
            data.members = [myUser.getJSON()];
         }
         var requestParams:Object = AlliancesConstants.objCreateCreateAlliance("createAlliance",mUserAccountId,name,description,logo,isPublic);
         controller.notificationsNotify("createAlliance",true,data,requestParams);
      }
      
      private function onEditAlliance(description:String, logo:String, isPublic:Boolean, transaction:Transaction = null) : void
      {
         var obj:Object = null;
         var alliance:Alliance;
         var controller:AlliancesController;
         if((alliance = (controller = InstanceMng.getAlliancesController()).getMyAlliance()) != null)
         {
            alliance.setDescription(description);
            alliance.setLogo(AlliancesConstants.getLogoArrayFromString(logo));
            obj = AlliancesConstants.objCreateEditAlliance("editAlliance",mUserAccountId,description,logo,isPublic);
            controller.notificationsNotify("editAlliance",true,alliance.getJSON(),obj);
         }
      }
      
      private function getAllianceById(allianceId:String, useMyUser:Boolean) : Alliance
      {
         var allianceXml:Object = null;
         var fileString:String = this.getAlliancesListContent();
         var file:Object = JSON.parse(fileString);
         var alliance:Alliance = null;
         for each(allianceXml in file.alliances)
         {
            if(allianceXml.id == allianceId)
            {
               (alliance = new Alliance()).fromJSON(allianceXml,useMyUser);
               break;
            }
         }
         return alliance;
      }
      
      private function getAllianceByUserId(userId:String) : Alliance
      {
         userId = "623020301";
         this.mIndex = (this.mIndex + 1) % 3;
         if(this.mIndex == 2)
         {
            return null;
         }
         return this.getAllianceById("" + (this.mIndex + 1),false);
      }
      
      private function onRequestAllianceById(id:String, includeMembers:Boolean, notifyCmd:String, params:Object) : void
      {
         var alliance:Alliance = null;
         var response:Object = null;
         var errorCode:int = 0;
         var controller:AlliancesController = InstanceMng.getAlliancesController();
         var useMyUser:* = notifyCmd == "requestMyAlliance";
         if(notifyCmd == "requestAllianceByUserId")
         {
            alliance = this.getAllianceByUserId(id);
         }
         else
         {
            alliance = this.getAllianceById(id,useMyUser);
         }
         if(alliance != null)
         {
            response = {"alliance":alliance.getJSON()};
            if(useMyUser)
            {
               response.profile = this.alliancesGetUserProfile();
            }
            controller.notificationsNotify(notifyCmd,true,response,params);
         }
         else
         {
            errorCode = 8;
            if(useMyUser)
            {
               errorCode = 9;
            }
            response = {
               "result":false,
               "error":errorCode
            };
            controller.notificationsNotify(notifyCmd,false,response,params);
         }
      }
      
      private function alliancesGetUserProfile() : Object
      {
         var fileString:String = this.getAlliancesListContent();
         var file:Object = JSON.parse(fileString);
         return {
            "invitesSent":file.invitesSent,
            "joinsSent":file.joinsSent
         };
      }
      
      override public function updateMisc_firstLoadingSuccess(chk:Number) : void
      {
         this.timeoutsAddId(setTimeout(this.onUpdateMisc_firstLoadingSuccess,1000));
      }
      
      private function onUpdateMisc_applyPurchasesFromMobileAdjust(mobilePaymentSlots:Array) : void
      {
         Application.externalNotification(31,mobilePaymentSlots);
      }
      
      override public function updateMisc_applyPurchasesFromMobileAdjust(oneCreditLocalPrice:Number, currency:String, mobilePaymentSlots:Array) : void
      {
         this.timeoutsAddId(setTimeout(this.onUpdateMisc_applyPurchasesFromMobileAdjust,1000,mobilePaymentSlots));
      }
      
      public function onUpdateMisc_firstLoadingSuccess() : void
      {
         var pendingTransactionsXml:XML = InstanceMng.getUserDataMng().getFileXML(UserDataMng.KEY_PENDING_TRANSACTIONS);
         Application.externalNotification(21,{"pendingTransactions":pendingTransactionsXml});
      }
      
      override public function updateInvest_investInFriends(blackList:Array) : void
      {
         this.timeoutsAddId(setTimeout(this.onUpdateInvest_investInFriends,1000));
      }
      
      override public function updateInvest_remind(extId:String, platformId:String) : void
      {
         var data:Object = {};
         data["action"] = "remind";
         data["platformId"] = platformId;
         data["extId"] = extId;
      }
      
      override public function updateInvest_hurryUp(accountId:String, extId:String) : void
      {
         var data:Object = {};
         data["action"] = "hurryUp";
         data["accountId"] = accountId;
      }
      
      override public function updateInvest_investInFriend(extId:String) : void
      {
         this.timeoutsAddId(setTimeout(this.onUpdateInvest_investInFriend,1000,extId));
      }
      
      private function onUpdateInvest_investInFriend(extId:String) : void
      {
         Application.externalNotification(22,{"extIds":[extId]});
      }
      
      private function onUpdateInvest_investInFriends() : void
      {
         Application.externalNotification(22,{"extIds":["543286207","1172861822"]});
      }
      
      override public function updateSocialItem_buyItem(sku:String, transaction:Transaction = null) : void
      {
      }
      
      override public function updateSocialItem_useItem(sku:String, amount:int) : void
      {
      }
      
      override public function quickAttackFindTarget() : void
      {
         this.timeoutsAddId(setTimeout(this.doQuickAttackFindTarget,1000));
      }
      
      private function doQuickAttackFindTarget() : void
      {
         var accountId:String = "4740";
         var url:String = "";
         var planetId:String = "1";
         var xml:XML = <user accountId="{accountId}" url="{url}" planetId="{planetId}"/>;
         if(this.mQuickAttackUsesCount == 0)
         {
            Application.externalNotification(25,{"userInfo":xml});
         }
         else
         {
            Application.externalNotification(26,null);
         }
         this.mQuickAttackUsesCount = (this.mQuickAttackUsesCount + 1) % 2;
      }
      
      override public function updateBets_requestBet(betSku:String) : void
      {
         this.mCancelRequestBet = false;
         this.timeoutsAddId(setTimeout(this.doUpdateBets_requestBet,10000));
      }
      
      override public function updateBets_cancelRequestBet() : void
      {
         this.mCancelRequestBet = true;
      }
      
      override public function updateBets_requestResult(sku:String) : void
      {
         this.timeoutsAddId(setTimeout(this.doUpdateBets_requestResult,10000));
      }
      
      private function doUpdateBets_requestBet() : void
      {
         var accountId:String = null;
         var url:String = null;
         var planetId:String = null;
         var xml:XML = null;
         if(!this.mCancelRequestBet)
         {
            accountId = "4740";
            url = "";
            planetId = "1";
            xml = <user accountId="{accountId}" url="{url}" planetId="{planetId}"/>;
            Application.externalNotification(28,{"userInfo":xml});
            this.pingReset();
         }
      }
      
      private function doUpdateBets_requestResult() : void
      {
         var xml:XML = <Bet id="35456" accountId="354584151" planetId="1" state="0" bet="cash:3" reward="cash:5" hisName="Pachiiiiii" hisUrl="" sku="1" myCoins="2010254" myCoinsTotal="2500000" myMinerals="3148457" myMineralsTotal="4000000" myScore="175420" myScoreTotal="215473" myScorePercent="81" myTime="180" hisCoins="2478015" hisCoinsTotal="5000012" hisMinerals="3954000" hisMineralsTotal="7000051" hisScore="175420" hisScoreTotal="215473" hisScorePercent="81" hisTime="170"/>;
         Application.externalNotification(30,{"result":xml});
      }
      
      private function pingReset() : void
      {
         this.pingSetState(2);
      }
      
      private function pingSetState(state:int) : void
      {
         this.mPingState = state;
         var timeToWait:int = 0;
         switch(this.mPingState - 3)
         {
            case 0:
               timeToWait = DCTimerUtil.secondToMs(100);
         }
         this.mPingTimeChangeState = DCTimerUtil.currentTimeMillis() + timeToWait;
      }
      
      override public function updateBattle_ping() : void
      {
         this.timeoutsAddId(setTimeout(this.doUpdateBattle_ping,100));
      }
      
      public function doUpdateBattle_ping() : void
      {
         var changeState:* = DCTimerUtil.currentTimeMillis() >= this.mPingTimeChangeState;
         switch(this.mPingState - -2)
         {
            case 0:
               if(changeState)
               {
                  Application.externalNotification(29,{"state":0});
                  this.pingSetState(-1);
               }
               break;
            case 3:
               if(changeState)
               {
                  Application.externalNotification(29,{"state":3});
                  this.pingSetState(-2);
               }
               break;
            case 4:
               if(changeState)
               {
                  Application.externalNotification(29,{"state":2});
                  this.pingSetState(1);
               }
               break;
            case 5:
               if(changeState)
               {
                  this.pingSetState(4);
               }
               else
               {
                  Application.externalNotification(29,{
                     "state":4,
                     "hisCoins":1000,
                     "hisMinerals":1000,
                     "hisScore":200,
                     "hisScorePercent":60
                  });
               }
               break;
            case 6:
               if(changeState)
               {
                  Application.externalNotification(29,{
                     "state":5,
                     "hisCoins":1000,
                     "hisMinerals":1000,
                     "hisScore":200,
                     "hisScorePercent":60
                  });
                  this.pingSetState(-1);
                  break;
               }
         }
      }
   }
}
