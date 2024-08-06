package com.dchoc.game.utils
{
   import com.dchoc.game.controller.alliances.AlliancesControllerStar;
   import com.dchoc.game.controller.entry.EntryFactory;
   import com.dchoc.game.controller.shop.ShopController;
   import com.dchoc.game.core.flow.Application;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.rule.RuleMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.hud.EWarBarMercenariesBox;
   import com.dchoc.game.eview.widgets.hud.EUnitItemViewShipyardBarTraining;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.userdata.UserDataMng;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.game.model.userdata.UserInfoMng;
   import com.dchoc.game.model.waves.WaveSpawnDef;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.model.world.target.action.ActionStartInvestsIntro;
   import com.dchoc.game.view.dc.mng.ViewMngPlanet;
   import com.dchoc.game.view.facade.UIFacade;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.media.SoundManager;
   import com.dchoc.toolkit.core.resource.DCResourceMng;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.services.advertising.DCAdsManager;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   import esparragon.core.Esparragon;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.layout.behaviors.ELayoutBehaviorCenterAndScale;
   import esparragon.widgets.EButton;
   import esparragonFlash.display.FlashTextField;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   
   public class CheatConsole
   {
      
      private static const EXIT:String = "EXIT";
      
      private static const TST:String = "TST";
      
      private static const AFK:String = "AFK";
      
      private static const WN:String = "WN";
      
      private static const LS:String = "LS";
      
      private static const ALLIS_WELCOME_POPUP:String = "AL_WP";
      
      private static const ALLIS_ERROR:String = "AL_E";
      
      private static const ALLIS_ERROR_DISABLED:String = "AL_ED";
      
      private static const ALLIS_KICKED:String = "AL_KICKED";
      
      private static const ALLIS:String = "AL";
      
      private static const ALLIS_PRINT_REMINDERS:String = "PRINT_REMINDERS";
      
      private static const ADDXP:String = "ADDXP";
      
      private static const SWITCH_ATTACK_TOOL:String = "TOOL1";
      
      private static const FUNNEL:String = "FUNNEL";
      
      private static const DRAW_BORDERS:String = "DB";
      
      private static const REMOVE_BORDERS:String = "RB";
      
      private static const BATTLE_RESULT_POPUP:String = "BRP";
      
      private static const PLAY_SOUND_FADE:String = "SOUND";
      
      private static const REQ_FRIEND_LIST:String = "RFL";
      
      private static const REQ_NEIGH_LIST:String = "RNL";
      
      private static const INVEST_POPUP:String = "INV";
      
      private static const INVEST_TUTO_POPUP:String = "IT";
      
      private static const PASS_FRIENDS_RANKING_POPUP:String = "PFR";
      
      private static const PASS_FRIENDS_LEVEL:String = "PFL";
      
      private static const NUKE:String = "NUKE";
      
      private static const BUY_SPY_CAPSULES:String = "SPY";
      
      private static const SPY_TOOL:String = "SPY_TOOL";
      
      private static const CURRENCY:String = "CURRENCY";
      
      private static const PURCHASE_PROMOTION:String = "PROMO";
      
      private static const MERCENARIES:String = "MERCENARIES";
      
      private static const OFFER_POPUP:String = "OFFER";
      
      private static const BUY_TIME:String = "TIME";
      
      private static const BUY_TIME_2:String = "TIME2";
      
      private static const SPAWN_WAVE:String = "WAV";
      
      private static const HALLOWEEN_INCOMING_WAVE:String = "WAVE";
      
      private static const SHOW_ADV:String = "ADV";
      
      private static const ATTACKED_INGAME:String = "ATT";
      
      private static const BET:String = "BET";
      
      private static const CONTEST:String = "CONTEST";
      
      private static const POPUP_MESSAGE_TEXT:String = "PMT";
      
      private static const CONTEST_RESULTS:String = "CONRES";
      
      private static const PREMIUM_SHOP:String = "PREM";
      
      private static const STAR_TREK_SHOP:String = "TREK";
      
      private static const RELOAD:String = "RELOAD";
      
      private static const FREE_OFFERS:String = "FREEOFF";
      
      private static const SPIL_AD:String = "SPILAD";
      
      private static const IDLE:String = "IDLE";
      
      private static const END_TUTORIAL:String = "ENDTUTORIAL";
      
      private static const KIDNAP_START:String = "KIDNAP_START";
      
      private static const KIDNAP_END:String = "KIDNAP_END";
      
      private static const EIMAGE_ADD:String = "EA";
      
      private static const EIMAGE_SET_TEXTURE_1:String = "1";
      
      private static const EIMAGE_SET_TEXTURE_2:String = "EIMAGE_SET_TEXTURE_2";
      
      private static const MOBILE_PAYMENTS:String = "MP";
      
      private static const USER_CURRENCY:String = "UC";
      
      private static const TEXT_1:String = "TEXT1";
      
      private static const TEXT_2:String = "TEXT2";
      
      private static const RESET_TEXT:String = "RESETTEXT";
      
      private static const PRINT_LOADER_INFO:String = "PLI";
      
      private static const ESPRITE_TUTORIAL:String = "ET";
      
      private static const ESPRITE_TUTORIAL_ROTATE:String = "ETR";
      
      private static const ESPRITE_TUTORIAL_MOVE:String = "ETM";
      
      private static const RECEIVE_GIFT:String = "RG";
      
      private static const ACCEPT_NEIGHBOR:String = "AN";
      
      private static const OPEN_INVENTORY:String = "OI";
      
      private static const BTN_PAY:String = "BP";
      
      private static const MOVIECLIP_CREATE:String = "MCC";
      
      private static const MOVIECLIP_DESTROY:String = "MCD";
      
      private static const ALLIANCES_OPENED:String = "AOP";
      
      private static const OPEN_POPUP:String = "OP";
      
      private static const SHOW_TEXT_FEEDBACK:String = "STF";
      
      private static const SHOW_COINS_BAR:String = "SCB";
      
      private static const ERROR_SERVER:String = "ES";
      
      private static const SPEECH_POPUP:String = "SP";
      
      private static const INFORMATION_POPUP:String = "IP";
      
      private static const DEBUG_UNIT_SCENE:String = "DUS";
      
      private static const NETWORK_BUSY:String = "NWB";
      
      private static const UPGRADE_HQ:String = "UPHQ";
      
      private static const MISSION:String = "MISSION";
      
      private static var smLogicUpdateIntervalId:uint;
      
      private static var smPassFriendsRankingPopup:Boolean = false;
      
      private static var mETextField:ETextField;
      
      private static var smRotation:Number = 0;
      
      private static var mInputTextField:TextField;
      
      private static var smTestImage:ESprite;
      
      private static var smTestImage2:EImage;
      
      private static var smESpriteTutorialESprite:EImage;
      
      private static var smESpriteTutorialCrossAnchor:Sprite;
      
      private static var smESpriteTutorialCrossPivot:Sprite;
      
      private static var smESpriteTutorialCrossAtReference:Sprite;
      
      private static var smEspriteTutorialNeedsToRotate:Boolean = false;
      
      private static var smAddEspritesToView:Boolean = false;
      
      private static const positionOfAnchorX:int = 200;
      
      private static const positionOfAnchorY:int = 200;
      
      private static var smTab:ESpriteContainer;
      
      private static var smMovieClip:ESprite;
       
      
      public function CheatConsole()
      {
         super();
      }
      
      private static function createETextField() : void
      {
         var stage:Stage = null;
         if(mETextField == null)
         {
            stage = InstanceMng.getApplication().stageGetStage().getImplementation();
            mETextField = new FlashTextField(100,200,"","font_esparragon");
            stage.addChild(mETextField);
         }
      }
      
      private static function doAction(code:String) : void
      {
         var cmd:String = null;
         var o:Object = null;
         var arr:Array = null;
         var text:String = null;
         var uiFacade:UIFacade = null;
         var popup:DCIPopup = null;
         var str:String = null;
         var obj:Object = null;
         var transaction:Transaction = null;
         var pfl:Object = null;
         var userInfo:UserInfo = null;
         var action:ActionStartInvestsIntro = null;
         var sku:String = null;
         var controller:ShopController = null;
         var objectMb:Object = null;
         var esprite:EImage = null;
         var espriteArea:ELayoutArea = null;
         var tokens:Array = null;
         var waveSpawnDef:WaveSpawnDef = null;
         var pos:int = 0;
         var errorCodeStr:String = null;
         cmd = code.toUpperCase();
         text = "a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a";
         InstanceMng.getUserDataMng().updateProfile_cheater("cheatConsole",{"code":code});
         switch(cmd)
         {
            case "DUS":
               InstanceMng.getUnitScene().debugBattle();
               break;
            case "IP":
               popup = (uiFacade = InstanceMng.getUIFacade()).getPopupFactory().getInformationPopup("title",null,text);
               uiFacade.enqueuePopup(popup);
               break;
            case "SP":
               InstanceMng.getApplication().speechPopupOpen("captain_happy","speech title",text,"accept","Body_7.mp3",null,true,false,75,0,true);
               break;
            case "KIDNAP_START":
               InstanceMng.getFlowStatePlanet().createTutorialKidnapMng();
               InstanceMng.getTutorialKidnapMng().notifyStartKidnapping();
               break;
            case "KIDNAP_END":
               InstanceMng.getFlowStatePlanet().createTutorialKidnapMng();
               InstanceMng.getTutorialKidnapMng().notifyEndKidnapping();
               break;
            case "ENDTUTORIAL":
               InstanceMng.getFlowStatePlanet().openIdlePopupAfterTutorial();
               break;
            case "NWB":
               InstanceMng.getPopupMng().openNetworkBusyPopup();
               break;
            case "IDLE":
               InstanceMng.getFlowState().showIdlePopup();
               break;
            case "EA":
               testImageAddImage();
               break;
            case "TAB":
               tabCreate();
               break;
            case "PROPS":
               if(smTab != null)
               {
                  if((esprite = smTab.getContent("background") as EImage) != null)
                  {
                     if((espriteArea = esprite.getLayoutArea()) != null)
                     {
                        InstanceMng.getEResourcesMng().resizeImage(esprite,500,espriteArea.height);
                     }
                  }
               }
               break;
            case "EIMAGE_SET_TEXTURE_2":
               break;
            case "1":
               smRotation += 5;
               smRotation %= 360;
               smTestImage.rotation = smRotation;
               break;
            case "EXIT":
               removeFromScreen();
               break;
            case "TST":
               try
               {
                  arr = InstanceMng.getAlliancesController().getEnemyAlliance().getMembers();
                  str = "members -> " + arr.toString();
               }
               catch(e:Error)
               {
                  str = "members -> catch error " + e.toString();
               }
               DCDebug.traceCh("ALLIANCES",str);
               break;
            case "AFK":
               (o = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NotifyAFKPopup")).msg = "cheat console afk";
               o.title = "--";
               InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o,true);
               break;
            case "WN":
            case "LS":
               if(cmd == "WN")
               {
                  AlliancesControllerStar(InstanceMng.getAlliancesController()).openWarIsWonPopup(false,"pepe");
               }
               else
               {
                  AlliancesControllerStar(InstanceMng.getAlliancesController()).openWarIsLostPopup(false);
               }
               break;
            case "AL_WP":
               (o = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NOTIFY_ALLIANCES_WELCOME_POPUP")).body = DCTextMng.getText(2954);
               AlliancesControllerStar(InstanceMng.getAlliancesController()).guiOpenAllianceNotification(o);
               break;
            case "AL_ED":
               InstanceMng.getAlliancesController().errorDisable();
               break;
            case "AL_KICKED":
               AlliancesControllerStar(InstanceMng.getAlliancesController()).openKickedFromAlliancePopup();
               break;
            case "AL":
               AlliancesControllerStar(InstanceMng.getAlliancesController()).guiOpenAlliancesPopup();
               break;
            case "PRINT_REMINDERS":
               InstanceMng.getAlliancesController().remindersRemindersInvitationsPrint();
               break;
            case "TOOL1":
               InstanceMng.getToolsMng().setToolWarCircle("groundUnits_001_001");
               break;
            case "FUNNEL":
               InstanceMng.getApplication().funnelSetIsEnabled(true);
               break;
            case "DB":
               InstanceMng.getMapViewPlanet().drawAllItemsBorder();
               break;
            case "RB":
               InstanceMng.getMapViewPlanet().removeAttachedToMouseItemBorder();
               break;
            case "BRP":
               (obj = {}).lootedCoins = 0;
               obj.lootedMineral = 0;
               obj.scoreGained = 12;
               obj.showAllianceScore = false;
               obj.battleOverWhileAttacking = false;
               InstanceMng.getUnitScene().openBattleResultPopup(obj);
               break;
            case "SOUND":
               SoundManager.getInstance().fadeMusic(1,0,2);
               break;
            case "SOUND_UP":
               SoundManager.getInstance().fadeMusic(0,1,4);
            case "RFL":
               InstanceMng.getUserDataMng().requestFile(UserDataMng.KEY_FRIENDS_LIST,DCResourceMng.getFileName("userdata/friendsList.xml"));
               break;
            case "RNL":
               InstanceMng.getUserDataMng().requestFile(UserDataMng.KEY_NEIGHBOR_LIST,DCResourceMng.getFileName("userdata/neighborList.xml"));
               break;
            case "INV":
               InstanceMng.getInvestMng().openInvestsPopupDependingOnSituation(false);
               break;
            case "IT":
               transaction = InstanceMng.getRuleMng().createTransactionAcceptInvest();
               InstanceMng.getInvestMng().guiOpenInvestRewardTutorialPopup("2",transaction);
               break;
            case "PFR":
               smPassFriendsRankingPopup = true;
               break;
            case "PFL":
               pfl = InstanceMng.getGUIControllerPlanet().createNotifyEvent("EventPopup","NOTIFY_PASS_FRIENDS_LEVELUP_POPUP");
               userInfo = InstanceMng.getUserInfoMng().getUserInfoObj("1",0);
               pfl["friendsPassed"] = new Vector.<UserInfo>(0);
               pfl["friendsPassed"].push(userInfo);
               InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),pfl,true);
               break;
            case "SPY":
               o = InstanceMng.getGUIControllerPlanet().createNotifyEvent("EventPopup","NOTIFY_SHOW_SPY_CAPSULES_SHOP");
               InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),o,true);
               break;
            case "SPY_TOOL":
               InstanceMng.getToolsMng().setTool(10);
               break;
            case "CURRENCY":
               Application.externalNotification(4,{
                  "cmd":"currencyPlatform",
                  "user_currency":"EUR",
                  "currency_exchange_inverse":0.07969
               });
               break;
            case "PROMO":
               Application.externalNotification(4,{
                  "cmd":"promotionStatus",
                  "is_eligible_promo":1
               });
               break;
            case "OFFER":
               InstanceMng.getUserInfoMng().getProfileLogin().setShowOfferNewPayerPromo(true);
               InstanceMng.getTopHudFacade().refreshVisibilityOfferButton();
               break;
            case "TIME":
               (transaction = new Transaction()).setTransCash(-20);
               transaction.computeAmountsLeftValues();
               if(transaction.getTransHasBeenPerformed() == false)
               {
                  transaction.performAllTransactions();
               }
               InstanceMng.getUserDataMng().updateBattle_specialAttack_usingCash("50",0,0,null,null,-1,transaction);
               break;
            case "TIME2":
               (transaction = new Transaction()).setTransCash(-30);
               transaction.computeAmountsLeftValues();
               if(transaction.getTransHasBeenPerformed() == false)
               {
                  transaction.performAllTransactions();
               }
               InstanceMng.getUserDataMng().updateBattle_specialAttack_usingCash("51",0,0,null,null,-1,transaction);
               break;
            case "I":
               (action = new ActionStartInvestsIntro()).execute(null,false);
               break;
            case "IN":
               InstanceMng.getMapViewPlanet().investsBuildingPlayConstructionAnim();
               break;
            case "NUKE":
               InstanceMng.getToolsMng().setToolLaunchSpecialAttack("3",true);
               break;
            case "MERCENARIES":
               InstanceMng.getToolsMng().setToolLaunchSpecialAttack("10",true);
               break;
            case "ADV":
               InstanceMng.getUserDataMng().getAdsManager().adsReady(true,"");
               break;
            case "ATT":
               Application.externalNotification(27,null);
               break;
            case "BET":
               if(Config.useBets())
               {
                  InstanceMng.getBetMng().requestBet("1");
               }
               break;
            case "CONTEST":
               InstanceMng.getContestMng().guiOpenInfoPopup();
               break;
            case "PMT":
               break;
            case "CONRES":
               InstanceMng.getContestMng().guiOpenResultsUserHasLostPopup("easter_0");
               break;
            case "PREM":
            case "TREK":
               sku = cmd == "PREM" ? "premium" : "starTrek";
               if((controller = InstanceMng.getApplication().shopControllersGetControllerBySku(sku)) != null)
               {
                  controller.clickOnHudButton();
               }
               break;
            case "RELOAD":
               InstanceMng.getUserDataMng().browserRefresh();
               break;
            case "SPILAD":
               DCAdsManager.getInstance().spilAdSetNeedsToRequestAd(true);
               break;
            case "TRANSACTIONS":
               InstanceMng.getUserDataMng().queryVerifyCreditsPurchase(false);
               break;
            case "MP":
               (objectMb = {}).cmd = "mobilePricePoints";
               arr = [];
               arr.push({
                  "credits":9,
                  "local_currency":"EUR",
                  "sku":"mobile0",
                  "user_price":"1.82",
                  "items":"10:2"
               });
               arr.push({
                  "credits":19,
                  "local_currency":"EUR",
                  "sku":"mobile1",
                  "user_price":"2.82",
                  "items":"10:2"
               });
               arr.push({
                  "credits":29,
                  "local_currency":"EUR",
                  "sku":"mobile2",
                  "user_price":"3.82",
                  "items":"10:2"
               });
               arr.push({
                  "credits":49,
                  "local_currency":"EUR",
                  "sku":"mobile4",
                  "user_price":"5.82",
                  "items":"10:2"
               });
               arr.push({
                  "credits":39,
                  "local_currency":"EUR",
                  "sku":"mobile3",
                  "user_price":"4.82",
                  "items":"10:2"
               });
               objectMb.mobile = arr;
               Application.externalNotification(4,objectMb);
               break;
            case "UC":
               Application.externalNotification(4,{
                  "cmd":"currencyPlatform",
                  "user_currency":"dollar",
                  "currency_exchange_inverse":1
               });
               break;
            case "TEXT1":
               createETextField();
               mETextField.setText("Hola");
               mETextField.autoSize(true);
               break;
            case "TEXT2":
               createETextField();
               mETextField.setText("Hola esto es un texto largo. Escalate por favor");
               mETextField.autoSize(true);
               break;
            case "RESETTEXT":
               createETextField();
               mETextField.setText("");
               mETextField.autoSize(true);
               break;
            case "PLI":
               Esparragon.getResourcesMng().getELoaderMng().requestsTraceDebug();
               break;
            case "BP":
               btnPayForUnlockingSlot(500,200);
               break;
            case "MCC":
               testEMovieClipCreate(300,300);
               break;
            case "MCD":
               testEMovieClipDestroy();
               break;
            case "ET":
               espriteTutorial01();
               espriteTutorial11();
               break;
            case "ETR":
               espriteTutorialToggleRotate();
               break;
            case "ETM":
               smESpriteTutorialESprite.logicX += 50;
               smESpriteTutorialCrossPivot.x += 50;
               smESpriteTutorialCrossAnchor.x += 50;
               break;
            case "FREEOFF":
               InstanceMng.getSettingsDefMng().mSettingsDef.setShowFreeOffers(true);
               break;
            case "STF":
               InstanceMng.getUIFacade().showTextFeedback("holaaa",10000,0);
               break;
            case "SCB":
               showCoinsBar(200,200);
               break;
            default:
               if(false && cmd.search("WAV") > -1)
               {
                  tokens = cmd.split(" ");
                  if((waveSpawnDef = InstanceMng.getWaveSpawnDefMng().getDefBySku(tokens[1]) as WaveSpawnDef) == null)
                  {
                     waveSpawnDef = WaveSpawnDef(InstanceMng.getWaveSpawnDefMng().getDefs()[0]);
                  }
                  if(waveSpawnDef != null)
                  {
                     InstanceMng.getUnitScene().battleHappeningWaveSpawnStart("halloween",waveSpawnDef,null,true);
                  }
               }
               else if((pos = cmd.search("AL_E")) > -1)
               {
                  errorCodeStr = cmd.substr("AL_E".length);
                  InstanceMng.getAlliancesController().errorEnable(parseInt(errorCodeStr));
               }
               else if(executeWithParams(code) != true)
               {
                  if(executeAsProgrammingCode(code) == false)
                  {
                     setWrongFormat();
                     setTimeout(setCorrectFormat,1000);
                  }
               }
         }
         DCDebug.traceCh("CHEAT CONSOLE","code entered > " + code);
      }
      
      private static function executeWithParams(code:String) : Boolean
      {
         var args:Array = null;
         var n:Number = NaN;
         var sku:String = null;
         var ruleMng:RuleMng = null;
         var hqWIO:WorldItemObject = null;
         var wioEvent:Object = null;
         var allok:Boolean = true;
         args = code.split(" ");
         var cmd:String = args.shift();
         DCDebug.traceCh("CHEAT CONSOLE","cmd > " + cmd);
         DCDebug.traceCh("CHEAT CONSOLE","args > " + args);
         InstanceMng.getUserDataMng().updateProfile_cheater("cheatConsole",{"code":code});
         switch(cmd.toUpperCase())
         {
            case "ADDXP":
               n = parseFloat(args[0]);
               if(isNaN(n))
               {
                  n = 0;
               }
               InstanceMng.getUserInfoMng().getProfileLogin().addScore(n);
               break;
            case "SERVER":
               if(args.length > 0)
               {
                  if(args[0] == "hq")
                  {
                     InstanceMng.getUserDataMng().updateMisc_upSellingStarted("HQLevelUp");
                  }
                  if(args[0] == "units")
                  {
                     InstanceMng.getUserDataMng().updateMisc_upSellingStarted("units");
                  }
               }
               break;
            case "RG":
               Application.externalNotification(4,{
                  "cmd":"msgCenterReceiveGift",
                  "sku":args[0]
               });
               break;
            case "OI":
               InstanceMng.getActionsLibrary().launchAction("openInventory",{"itemSku":args[0]});
               break;
            case "AOP":
               break;
            case "OP":
               sku = String(args[0]);
               ruleMng = InstanceMng.getRuleMng();
               InstanceMng.getUnitScene().openShowIncomingAttackPopup(ruleMng.npcsGetAttack(sku),ruleMng.npcsGetNpcSku(sku),ruleMng.npcsGetDeployX(sku),ruleMng.npcsGetDeployY(sku),ruleMng.npcsGetDeployWay(sku),ruleMng.npcsGetDuration(sku));
               break;
            case "UPHQ":
               hqWIO = InstanceMng.getWorld().itemsGetHeadquarters();
               wioEvent = {
                  "item":hqWIO,
                  "levelsToUpgrade":1,
                  "cmd":"WIOEventUpgradePremium"
               };
               InstanceMng.getWorldItemObjectController().notify(wioEvent);
               break;
            default:
               allok = false;
         }
         return allok;
      }
      
      private static function setText(text:String) : void
      {
         if(mInputTextField)
         {
            mInputTextField.text = text;
         }
      }
      
      private static function init(stageW:Number, stageH:Number) : void
      {
         if(mInputTextField == null)
         {
            mInputTextField = new TextField();
            mInputTextField.selectable = true;
            mInputTextField.type = "input";
            mInputTextField.border = true;
            mInputTextField.background = true;
            mInputTextField.backgroundColor = 0;
            setCorrectFormat();
            mInputTextField.textColor = 65280;
            mInputTextField.addEventListener("focusIn",onGainFocus,false,0,true);
            mInputTextField.addEventListener("focusOut",onLoseFocus,false,0,true);
            mInputTextField.addEventListener("keyUp",onTextKeyUp,false,0,true);
         }
         onLoseFocus(null);
         mInputTextField.x = 0;
         mInputTextField.y = stageH - 25;
         mInputTextField.width = stageW;
         mInputTextField.height = 25;
      }
      
      private static function setWrongFormat() : void
      {
         mInputTextField.borderColor = 16711680;
         mInputTextField.textColor = 16711680;
      }
      
      private static function setCorrectFormat() : void
      {
         mInputTextField.borderColor = 65280;
         mInputTextField.textColor = 65280;
      }
      
      public static function isActive() : Boolean
      {
         return mInputTextField != null && mInputTextField.visible;
      }
      
      public static function toggle() : void
      {
         if(mInputTextField == null)
         {
            addToScreen();
         }
         else if(mInputTextField.visible == false)
         {
            addToScreen();
         }
         else
         {
            removeFromScreen();
         }
      }
      
      public static function addToScreen() : void
      {
         var stage:Stage = InstanceMng.getApplication().stageGetStage().getImplementation();
         if(stage)
         {
            init(stage.stageWidth,stage.stageHeight);
            if(mInputTextField != null && stage.contains(mInputTextField) == false)
            {
               stage.addChild(mInputTextField);
               mInputTextField.visible = true;
               stage.focus = mInputTextField;
            }
            smLogicUpdateIntervalId = setInterval(logicUpdate,50);
         }
      }
      
      private static function logicUpdate() : void
      {
         var userInfoMng:UserInfoMng = null;
         if(smPassFriendsRankingPopup)
         {
            userInfoMng = InstanceMng.getUserInfoMng();
            userInfoMng.loadWeeklyScoreList(11000);
            if(userInfoMng.isWeeklyScoreListLoaded())
            {
               smPassFriendsRankingPopup = false;
               if(userInfoMng.hasTheUserPassedAnyFriends())
               {
                  InstanceMng.getUnitScene().openFriendPassedInRankingPopup();
               }
            }
         }
         espriteTutorialLogicUpdate(50);
      }
      
      public static function removeFromScreen() : void
      {
         var stage:Stage = InstanceMng.getApplication().stageGetStage().getImplementation();
         if(stage != null && mInputTextField != null && stage.contains(mInputTextField) == true)
         {
            stage.removeChild(mInputTextField);
            mInputTextField.visible = false;
            clearInterval(smLogicUpdateIntervalId);
         }
      }
      
      private static function onGainFocus(e:FocusEvent) : void
      {
         setText("");
      }
      
      private static function onLoseFocus(e:FocusEvent) : void
      {
         setText("enter code");
      }
      
      private static function onTextKeyUp(e:KeyboardEvent) : void
      {
         var actionCode:String = null;
         if(e.keyCode == 13)
         {
            actionCode = mInputTextField.text;
            onGainFocus(null);
            doAction(actionCode);
         }
      }
      
      private static function executeAsProgrammingCode(code:String) : Boolean
      {
         var arr:Array = null;
         var d:DisplayObjectContainer = null;
         var x:Number = NaN;
         var y:Number = NaN;
         var ok:Boolean = false;
         try
         {
            arr = code.split(",");
            d = InstanceMng.getPopupMng().getPopupBeingShown().getForm();
            x = parseFloat(arr[0]);
            y = parseFloat(arr[1]);
            d.scaleX = x;
            d.scaleY = y;
            ok = true;
         }
         catch(e:Error)
         {
         }
         return ok;
      }
      
      private static function testAddTestImageWithFrame(callback:Function = null) : void
      {
         var x:int = 0;
         var y:int = 0;
         var width:int = 0;
         var height:int = 0;
         var image:EImage = null;
         if(smTestImage is EImage)
         {
            if(callback == null)
            {
               callback = onTestLoaded;
            }
            image = smTestImage as EImage;
            image.onSetTextureLoaded = callback;
         }
         var viewMng:ViewMngPlanet;
         (viewMng = InstanceMng.getViewMngPlanet()).addESpriteToLayer(smTestImage,viewMng.getHudLayerSku(),1);
         var area:ELayoutArea = smTestImage.getLayoutArea();
         if(area != null)
         {
            x = area.x;
            y = area.y;
            width = area.width;
            height = area.height;
         }
         else
         {
            x = smTestImage.x;
            y = smTestImage.y;
            width = 25;
            height = 24;
         }
         testAddShapeFrame(x,y,width,height);
      }
      
      private static function testArrowBetResults() : void
      {
         var layoutFactory:ELayoutAreaFactory = InstanceMng.getViewFactory().getLayoutAreaFactory("PopBattle");
         var area:ELayoutArea = layoutFactory.getArea("arrow");
         area.x = 200;
         area.y = 200;
         area.flipH = false;
         var assetId:String = "speech_arrow";
         smTestImage = InstanceMng.getViewFactory().getEImage(assetId,null,true,area,null);
         testAddTestImageWithFrame();
      }
      
      private static function testArrowHudMissions() : void
      {
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         var layout:ELayoutAreaFactory = viewFactory.getLayoutAreaFactory("img_laurel");
         var area:ELayoutArea = layout.getArea("btn_arrow");
         smTestImage = viewFactory.getEImage("skin_icon_arrow",null,false,area,null);
         testAddTestImageWithFrame();
      }
      
      private static function testLaurelFlip() : void
      {
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         var layout:ELayoutAreaFactory = viewFactory.getLayoutAreaFactory("PopVictory");
         var area:ELayoutArea = layout.getArea("img_laurel_flip");
         area.x = 200;
         area.y = 200;
         smTestImage = viewFactory.getEImage("betLaurel",null,true,area);
         testAddTestImageWithFrame();
      }
      
      private static function testPaginatorArrowLeft() : void
      {
         var viewFactory:ViewFactory;
         var layoutFactory:ELayoutAreaFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("Pagination");
         var area:ELayoutArea = layoutFactory.getArea("btn_arrow_flip");
         area.x = 200;
         area.y = 200;
         var button:EButton = viewFactory.getButtonImage("btn_arrow",null,area);
         smTestImage = button;
         testAddTestImageWithFrame();
      }
      
      private static function testPaginatorAsset() : void
      {
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         var paginatorAsset:ESpriteContainer = viewFactory.getPaginatorAsset(null);
         smTestImage = paginatorAsset;
         testAddTestImageWithFrame();
      }
      
      private static function testRays() : void
      {
         var viewFactory:ViewFactory;
         var layoutAreaFactory:ELayoutAreaFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("BoxInventory");
         var area:ELayoutArea = layoutAreaFactory.getArea("area_items");
         area.x = 200;
         area.y = 200;
         var image:EImage = viewFactory.getEImage("captain_normal",null,false,area);
         smTestImage = image;
         testAddTestImageWithFrame(centerRays);
      }
      
      private static function centerRays(img:EImage) : void
      {
         smTestImage.rotation = 0;
         var area:ELayoutArea = smTestImage.getLayoutArea();
         smTestImage.x = 200 + area.width / 2;
         smTestImage.y = 200 + area.height / 2;
         smTestImage.setPivotLogicXY(0.5,0.5);
         smTestImage.width = area.width;
         smTestImage.height = area.height;
      }
      
      private static function testImageFlip() : void
      {
         var area:ELayoutArea = new ELayoutArea();
         area.x = 200;
         area.y = 200;
         area.width = 50;
         area.height = 50;
         area.addBehavior(new ELayoutBehaviorCenterAndScale());
         var assetId:String = "tooltip_arrow";
         smTestImage = InstanceMng.getViewFactory().getEImage(assetId,null,true,area,null);
         testAddTestImageWithFrame();
      }
      
      private static function testAtlasSimple() : void
      {
         var frameId:String = "skin_icon_contest_tool";
         var image:EImage = InstanceMng.getViewFactory().getEImage(frameId,"default",true,null,null);
         image.onSetTextureLoaded = onTestLoaded;
         smTestImage = image;
         var viewMng:ViewMngPlanet = InstanceMng.getViewMngPlanet();
         smTestImage.x = 200;
         smTestImage.y = 200;
         testAddShapeFrame(smTestImage.x,smTestImage.y,60,60);
         viewMng.addESpriteToLayer(smTestImage,viewMng.getHudLayerSku(),1);
      }
      
      private static function testAddShapeFrame(x:int, y:int, width:int, height:int) : void
      {
         var viewMng:ViewMngPlanet = InstanceMng.getViewMngPlanet();
         var g:Graphics;
         var shape:Shape;
         (g = (shape = new Shape()).graphics).beginFill(0);
         g.drawRect(0,0,width,height);
         g.endFill();
         shape.x = x;
         shape.y = y;
         shape.alpha = 0.6;
         viewMng.addChildToLayer(shape,viewMng.getHudLayerSku());
      }
      
      private static function testAtlasTileRow() : void
      {
         var area:ELayoutArea = new ELayoutArea();
         area.width = 100;
         area.height = 100;
         var image:EImage = InstanceMng.getViewFactory().getEImage("test_btn_common","skin_old",true,null,null);
         image.onSetTextureLoaded = onTestLoaded;
         smTestImage = image;
         var viewMng:ViewMngPlanet = InstanceMng.getViewMngPlanet();
         smTestImage.x = 200;
         smTestImage.y = 200;
         viewMng.addESpriteToLayer(smTestImage,viewMng.getHudLayerSku(),1);
      }
      
      private static function testImageAddImage() : void
      {
         if(smTestImage == null)
         {
            testRays();
         }
      }
      
      private static function onTestLoaded(img:EImage) : void
      {
         var viewMng:ViewMngPlanet = InstanceMng.getViewMngPlanet();
      }
      
      private static function testImageSetTexture(assetId:String, skinSku:String) : void
      {
         if(smTestImage == null)
         {
            testImageAddImage();
         }
         var image:EImage = smTestImage as EImage;
         InstanceMng.getEResourcesMng().setTextureToImage(assetId,skinSku,image.getLayoutArea(),image);
      }
      
      private static function espriteTutorialToggleRotate() : void
      {
         smEspriteTutorialNeedsToRotate = !smEspriteTutorialNeedsToRotate;
      }
      
      private static function espriteTutorialLogicUpdate(dt:int) : void
      {
         var image:EImage = null;
         var area:ELayoutArea = null;
         var x:int = 0;
         var y:int = 0;
         if(smESpriteTutorialESprite != null && smEspriteTutorialNeedsToRotate)
         {
            smESpriteTutorialESprite.rotation += 5;
         }
         if(smAddEspritesToView)
         {
            smAddEspritesToView = false;
            image = smESpriteTutorialESprite;
            espriteTutorialDrawCrossPivot(image);
            espriteTutorialDrawCrossAnchor(image);
            espriteTutorialDrawCrossAtReference();
            area = image.getLayoutArea();
            if(area != null)
            {
               x = area.x;
               y = area.y;
               if(!area.isSetPositionEnabled)
               {
                  x = image.logicLeft;
                  y = image.logicTop;
               }
               testAddShapeFrame(x,y,area.width,area.height);
            }
         }
      }
      
      private static function espriteTutorialDrawCrossAnchor(s:EImage) : void
      {
         var g:Graphics = null;
         if(smESpriteTutorialCrossAnchor == null)
         {
            smESpriteTutorialCrossAnchor = new Sprite();
            g = smESpriteTutorialCrossAnchor.graphics;
            drawCross(g,16711935,s.logicLeft,s.logicTop);
         }
         var viewMng:ViewMngPlanet = InstanceMng.getViewMngPlanet();
         viewMng.addChildToLayer(smESpriteTutorialCrossAnchor,viewMng.getHudLayerSku());
      }
      
      private static function espriteTutorialDrawCrossAtReference() : void
      {
         var sprite:Sprite = null;
         var g:Graphics = null;
         if(smESpriteTutorialCrossAtReference == null)
         {
            smESpriteTutorialCrossAtReference = new Sprite();
            sprite = new Sprite();
            smESpriteTutorialCrossAtReference.addChild(sprite);
            smESpriteTutorialCrossAtReference.x = 200;
            smESpriteTutorialCrossAtReference.y = 200;
            g = sprite.graphics;
            drawCross(g,0,0,0);
            sprite.rotation = 45;
         }
         var viewMng:ViewMngPlanet = InstanceMng.getViewMngPlanet();
         viewMng.addChildToLayer(smESpriteTutorialCrossAtReference,viewMng.getHudLayerSku());
      }
      
      private static function espriteTutorialDrawCrossPivot(s:EImage) : void
      {
         var g:Graphics = null;
         if(smESpriteTutorialCrossPivot == null)
         {
            smESpriteTutorialCrossPivot = new Sprite();
            g = smESpriteTutorialCrossPivot.graphics;
            drawCross(g,255,s.logicX,s.logicY);
         }
         var viewMng:ViewMngPlanet = InstanceMng.getViewMngPlanet();
         viewMng.addChildToLayer(smESpriteTutorialCrossPivot,viewMng.getHudLayerSku());
      }
      
      private static function espriteTutorialBlueArea() : void
      {
         var crossX:int = 200;
         var crossY:int = 200;
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         var assetId:String = "btn_back";
         var area:ELayoutArea = ELayoutAreaFactory.createLayoutArea(100,100);
         area.isSetPositionEnabled = false;
         smESpriteTutorialESprite = viewFactory.getEImage(assetId,null,false,area);
         smESpriteTutorialESprite.logicX = crossX;
         smESpriteTutorialESprite.logicY = crossY;
         var viewMng:ViewMngPlanet;
         (viewMng = InstanceMng.getViewMngPlanet()).addESpriteToLayer(smESpriteTutorialESprite,viewMng.getHudLayerSku(),1);
         testAddShapeFrame(crossX,crossY,area.width,area.height);
      }
      
      private static function espriteTutorialOnLoaded(image:EImage) : void
      {
         smAddEspritesToView = true;
      }
      
      private static function drawCross(g:Graphics, color:uint = 0, x:int = 0, y:int = 0) : void
      {
         g.beginFill(color);
         g.lineStyle(2,color);
         var size:int;
         var semiSize:int = (size = 20) / 2;
         g.drawRect(x - semiSize,y,size,1);
         g.drawRect(x,y - semiSize,1,size);
         g.endFill();
      }
      
      private static function espriteTutorialBasic(area:ELayoutArea = null) : void
      {
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         var assetId:String = "alliance_icon";
         smESpriteTutorialESprite = viewFactory.getEImage(assetId,null,false,area);
         smESpriteTutorialESprite.onSetTextureLoaded = espriteTutorialOnLoaded;
         var viewMng:ViewMngPlanet = InstanceMng.getViewMngPlanet();
         viewMng.addESpriteToLayer(smESpriteTutorialESprite,viewMng.getHudLayerSku(),1);
      }
      
      private static function espriteTutorial01() : void
      {
         espriteTutorialBasic();
         smESpriteTutorialESprite.logicLeft = 200;
         smESpriteTutorialESprite.logicTop = 200;
      }
      
      private static function espriteTutorial02() : void
      {
         espriteTutorialBasic();
         smESpriteTutorialESprite.logicX = 200;
         smESpriteTutorialESprite.logicY = 200;
      }
      
      private static function espriteTutorial03() : void
      {
         espriteTutorialBasic();
         smESpriteTutorialESprite.logicLeft = 200;
         smESpriteTutorialESprite.logicTop = 200;
         smESpriteTutorialESprite.setPivotLogicXY(0.5,0.5);
      }
      
      private static function espriteTutorial04() : void
      {
         espriteTutorialBasic();
         smESpriteTutorialESprite.setPivotLogicXY(0.5,0.5);
         smESpriteTutorialESprite.logicX = 200;
         smESpriteTutorialESprite.logicY = 200;
      }
      
      private static function espriteTutorial05() : void
      {
         var area:ELayoutArea = ELayoutAreaFactory.createLayoutArea(50,50);
         area.rotation = 10;
         espriteTutorialBasic(area);
      }
      
      private static function espriteTutorial06() : void
      {
         var area:ELayoutArea = ELayoutAreaFactory.createLayoutArea(50,50);
         area.rotation = 10;
         area.pivotX = 0.5;
         area.pivotY = 0.5;
         espriteTutorialBasic(area);
      }
      
      private static function espriteTutorial07() : void
      {
         var area:ELayoutArea = ELayoutAreaFactory.createLayoutArea(50,50);
         area.rotation = 10;
         area.pivotX = 0.5;
         area.pivotY = 0.5;
         espriteTutorialBasic(area);
         smESpriteTutorialESprite.setPivotLogicXY(0.5,0.5);
      }
      
      private static function espriteTutorial08() : void
      {
         var area:ELayoutArea = ELayoutAreaFactory.createLayoutArea(50,50);
         area.rotation = 10;
         area.pivotX = 0.5;
         area.pivotY = 0.5;
         area.x = 200;
         area.y = 200;
         espriteTutorialBasic(area);
         smESpriteTutorialESprite.setPivotLogicXY(0.5,0.5);
      }
      
      private static function espriteTutorial09() : void
      {
         var area:ELayoutArea = ELayoutAreaFactory.createLayoutArea(50,50);
         area.addBehavior(new ELayoutBehaviorCenterAndScale());
         espriteTutorialBasic(area);
      }
      
      private static function espriteTutorial10() : void
      {
         var area:ELayoutArea = ELayoutAreaFactory.createLayoutArea(50,50);
         area.addBehavior(new ELayoutBehaviorCenterAndScale());
         area.x = 200;
         area.y = 200;
         espriteTutorialBasic(area);
      }
      
      private static function espriteTutorial11() : void
      {
         var area:ELayoutArea = ELayoutAreaFactory.createLayoutArea(50,50);
         area.addBehavior(new ELayoutBehaviorCenterAndScale());
         area.isSetPositionEnabled = false;
         espriteTutorialBasic(area);
         smESpriteTutorialESprite.setPivotLogicXY(0.5,0.5);
         smESpriteTutorialESprite.logicX = 200;
         smESpriteTutorialESprite.logicY = 200;
      }
      
      private static function tabCreate() : void
      {
         if(smTab == null)
         {
            smTab = InstanceMng.getViewFactory().getTextTabHeaderPopup("test");
         }
         var viewMng:ViewMngPlanet = InstanceMng.getViewMngPlanet();
         smTab.x = -8;
         smTab.y = -8;
         viewMng.addESpriteToLayer(smTab,viewMng.getHudLayerSku(),5);
      }
      
      private static function shipyardView(x:int, y:int) : void
      {
         var trainingUnitView:EUnitItemViewShipyardBarTraining;
         (trainingUnitView = new EUnitItemViewShipyardBarTraining()).build();
         trainingUnitView.x = x;
         trainingUnitView.y = y;
         var viewMng:ViewMngPlanet = InstanceMng.getViewMngPlanet();
         viewMng.addESpriteToLayer(trainingUnitView,viewMng.getHudLayerSku(),1);
      }
      
      private static function mercenariesBox(x:int, y:int) : void
      {
         var viewFactory:ViewFactory;
         var layoutFactory:ELayoutAreaFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("LayoutHudBottomAttack");
         var mercenariesVector:Vector.<Array>;
         var def:Array = (mercenariesVector = InstanceMng.getItemsMng().getArrayVectorForSpecialAttacks("showInMercenariesBar"))[0];
         var s:EWarBarMercenariesBox = new EWarBarMercenariesBox(def[0]);
         var area:ELayoutArea = layoutFactory.getArea("area_mercenaries");
         s.build(area);
         s.logicLeft = x;
         s.logicTop = y;
         var viewMng:ViewMngPlanet;
         (viewMng = InstanceMng.getViewMngPlanet()).addESpriteToLayer(s,viewMng.getHudLayerSku(),1);
         testAddShapeFrame(x,y,area.width,area.height);
      }
      
      private static function btnPayForUnlockingSlot(x:int, y:int) : void
      {
         var viewFactory:ViewFactory;
         var layoutFactory:ELayoutAreaFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("BoxUnitsButtonsSmall");
         var areaName:String = "btn";
         var area:ELayoutArea = layoutFactory.getArea(areaName);
         var btn:EButton;
         (btn = viewFactory.getButtonPayment(area,EntryFactory.createCashSingleEntry(100),null)).logicLeft = x;
         btn.logicTop = y;
         var viewMng:ViewMngPlanet;
         (viewMng = InstanceMng.getViewMngPlanet()).addESpriteToLayer(btn,viewMng.getHudLayerSku(),1);
         testAddShapeFrame(x,y,area.width,area.height);
      }
      
      private static function btnPayShow(x:int, y:int) : void
      {
         var layoutFactory:ELayoutAreaFactory;
         var viewFactory:ViewFactory;
         var area:ELayoutArea = (layoutFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("ContainerItemButtonIcon")).getArea("ibtn");
         var payBtn:EButton;
         (payBtn = viewFactory.getButtonPayment(area,EntryFactory.createCashSingleEntry(300000),null)).logicLeft = x;
         payBtn.logicTop = y;
         var viewMng:ViewMngPlanet;
         (viewMng = InstanceMng.getViewMngPlanet()).addESpriteToLayer(payBtn,viewMng.getHudLayerSku(),1);
         testAddShapeFrame(x,y,area.width,area.height);
      }
      
      private static function btnUseShow(x:int, y:int) : void
      {
         var layoutFactory:ELayoutAreaFactory;
         var viewFactory:ViewFactory;
         var area:ELayoutArea = (layoutFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("ContainerItemButtonIcon")).getArea("ibtn");
         var btn:EButton;
         (btn = viewFactory.getButtonByTextWidth(DCTextMng.getText(623),area.width,"btn_common",null,null,"XS",area)).logicLeft = x;
         btn.logicTop = y;
         var viewMng:ViewMngPlanet;
         (viewMng = InstanceMng.getViewMngPlanet()).addESpriteToLayer(btn,viewMng.getHudLayerSku(),1);
         testAddShapeFrame(x,y,area.width,area.height);
      }
      
      private static function testEMovieClipCreate(x:int, y:int) : void
      {
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         var area:ELayoutArea = ELayoutAreaFactory.createLayoutArea(100,50);
         area.x = x;
         area.y = y;
         smMovieClip = viewFactory.getResourceAsESprite("cutscene_alliances_war_lost",null,true,area,onMovieClipLoaded);
         var viewMng:ViewMngPlanet;
         (viewMng = InstanceMng.getViewMngPlanet()).addESpriteToLayer(smMovieClip,viewMng.getHudLayerSku(),1);
         testAddShapeFrame(x,y,area.width,area.height);
      }
      
      private static function onMovieClipLoaded(e:ESprite) : void
      {
      }
      
      private static function testEMovieClipDestroy() : void
      {
         if(smMovieClip != null)
         {
            smMovieClip.destroy();
            smMovieClip = null;
         }
      }
      
      private static function showESprite(e:ESprite, x:int, y:int, area:ELayoutArea) : void
      {
         e.logicLeft = x;
         e.logicTop = y;
         var viewMng:ViewMngPlanet;
         (viewMng = InstanceMng.getViewMngPlanet()).addESpriteToLayer(e,viewMng.getHudLayerSku(),1);
         if(area != null)
         {
            testAddShapeFrame(x,y,area.width,area.height);
         }
      }
      
      private static function showCoinsBar(x:int, y:int) : void
      {
         var layoutFactory:ELayoutAreaFactory;
         var viewFactory:ViewFactory;
         var area:ELayoutArea = (layoutFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("LayoutHudLootingInfo")).getArea("container_bars_coins");
         var e:ESprite = viewFactory.getIconBar(area,"IconBarHudMNoBtn","color_coins","icon_bag_coins");
         showESprite(e,x,y,area);
      }
   }
}
