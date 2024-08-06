package com.dchoc.game.services
{
   import com.adobe.crypto.MD5;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.services.metrics.DCMetrics;
   import flash.display.Stage;
   import flash.utils.getTimer;
   
   public class GameMetrics extends DCMetrics
   {
      
      private static const PROJECT_ID_FACEBOOK:int = 37;
      
      private static const PROJECT_ID_STANDALONE:int = 60;
      
      public static const GA_DEV_PROFILE:String = "UA-2866276-63";
      
      private static var mProfile:Profile;
      
      private static var smHQDestroyed:Boolean;
      
      private static var smAttackedPlanet:String;
      
      private static var smHashUser:String;
      
      public static var smArmyValue:int;
      
      public static var smAttackerPlanet:String;
      
      public static const EVENT_SESSION_STARTED:String = "Session Started";
      
      public static const EVENT_FIRST_INGAME_ACTION:String = "First Ingame Action";
      
      public static const LABEL_ON_FLASH:String = "OnFlash";
      
      public static const EVENT_MISSION_FLOW:String = "Mission Flow";
      
      public static const LABEL_MISSION_DONE:String = "Mission Completed";
      
      public static const LABEL_MISSION_STARTED:String = "Mission Started";
      
      public static const LABEL_MISSION_PROGRESS:String = "Mission Progress";
      
      public static const EVENT_PLAY_TUTORIAL:String = "Play Tutorial";
      
      public static const LABEL_BATTLE_FINISHED:String = "Battle Finished";
      
      public static const EVENT_IDLE_POPUP:String = "Idle Popup Shown";
      
      public static const EVENT_NO_RESOURCES_POPUP:String = "No Resources Popup";
      
      public static const EVENT_FULLSCREEN:String = "FullScreen";
      
      public static const EVENT_FACEBOOK_INVITE_FRIEND:String = "Invite";
      
      public static const EVENT_FRIENDS_BAR:String = "Friends Bar";
      
      public static const EVENT_FANTA_AD:String = "Fanta Ad";
      
      public static const LABEL_FRIENDSBAR_INVITE:String = "FriendsBar Invite";
      
      public static const LABEL_FRIENDSBAR_ADD:String = "FriendsBar Add";
      
      public static const LABEL_FRIENDSBAR_INVITE_FRIENDS:String = "FriendsBar InviteFriends";
      
      public static const LABEL_FREEPLANET_INVITE:String = "FreePlanet Invite";
      
      public static const LABEL_FB_SHOWN:String = "Shown";
      
      public static const LABEL_FB_STARTED:String = "Started";
      
      public static const LABEL_FB_SEND:String = "Sent";
      
      public static const LABEL_FB_CLICKED:String = "Clicked";
      
      public static const LABEL_FB_CANCEL:String = "Cancelled";
      
      public static const LABEL_FB_COMPLETED:String = "Completed";
      
      public static const FROM_FB_SOCIAL_WALL:String = "SocialWall";
      
      public static const LABEL_MOBILE:String = "Mobile";
      
      public static const EVENT_PROGRESSION:String = "Progression";
      
      public static const EVENT_LEVEL_REACHED:String = "Level Reached";
      
      public static const LABEL_LEVEL_UP:String = "Level Up";
      
      public static const LABEL_HQ_LEVEL_UP:String = "HQ Level Up";
      
      public static const LABEL_COLONIZE_PLANET:String = "Colonize Planet";
      
      public static const EVENT_COORDINATE:String = "Coordinate";
      
      public static const LABEL_ATTACK_HQ_DESTROYED:String = "Attack HQ destroyed";
      
      public static const EVENT_BOOKMARK:String = "Bookmark";
      
      public static const EVENT_PURCHASE_PC:String = "PC Purchase";
      
      public static const EVENT_EARN_PC:String = "Earn PC";
      
      public static const EVENT_SPEND_PC:String = "Spend PC";
      
      public static const EVENT_SPEND_GC:String = "Spend GC";
      
      public static const EVENT_EARN_GC:String = "Earn GC";
      
      public static const EVENT_SPEND_MINERAL:String = "Spend Mineral";
      
      public static const EVENT_EARN_MINERAL:String = "Earn Mineral";
      
      public static const EVENT_EXCHANGE_PC:String = "Exchange PC";
      
      public static const EVENT_PURCHASE_ITEM:String = "Purchase Item";
      
      public static const EVENT_ITEM_USED:String = "Item Used";
      
      public static const LABEL_ECONOMY_ADD_GOLD_STARTED:String = "Started";
      
      public static const LABEL_ECONOMY_ADD_GOLD_CONTINUE:String = "Continue";
      
      public static const LABEL_ECONOMY_ADD_GOLD_FREE_OFFERS:String = "Free Offers";
      
      public static const LABEL_ECONOMY_CREATE_ALLIANCE:String = "Create Alliance";
      
      public static const LABEL_CLEAN_OBSTACLES:String = "Cleaning Obstacles";
      
      public static const LABEL_LAUNCH_SPECIAL_ATTACK:String = "Launch Special Attack";
      
      public static const EVENT_GET_ITEMS:String = "Get Items";
      
      public static const EVENT_COLLECTION_COMPLETED:String = "Collection Completed";
      
      public static const EVENT_ATTACK:String = "Attack";
      
      public static const EVENT_GET_WORKER:String = "Get Worker";
      
      public static const EVENT_STAR_TREK:String = "Star Trek";
      
      public static const EVENT_PREMIUM_SHOP:String = "Premium Shop";
      
      public static const EVENT_PVP:String = "PVP Menu";
      
      public static const EVENT_CONTEST:String = "Contest";
      
      public static const PRODUCT_ITEM:String = "Item";
      
      public static const PRODUCT_BUILDING:String = "Building";
      
      public static const PRODUCT_POPUP:String = "Popup";
      
      public static const PRODUCT_BUY_BUILDING:String = "Buy Building";
      
      public static const PRODUCT_SHIP:String = "Ship";
      
      public static const PRODUCT_SOLDIER:String = "Soldier";
      
      public static const PRODUCT_MECA:String = "Meca";
      
      public static const PRODUCT_COINS:String = "Coins";
      
      public static const PRODUCT_MINERALS:String = "Minerals";
      
      public static const PRODUCT_EXPERIENCE:String = "Experience";
      
      public static const PRODUCT_WORKER:String = "Worker";
      
      public static const PRODUCT_WORKER_ITEM:String = "Worker Item";
      
      public static const PRODUCT_PROTECTION_TIME:String = "Protection Time";
      
      public static const PRODUCT_PLANET:String = "Planet";
      
      public static const PRODUCT_PLANET_CAPITAL:String = "capital";
      
      public static const PRODUCT_PLANET_COLONY:String = "colony";
      
      public static const PRODUCT_PREMIUM_CURRENCY:String = "Premium Currency";
      
      public static const PRODUCT_SPECIAL_ATTACK:String = "Special Attack";
      
      public static const PRODUCT_SCORE:String = "Score";
      
      public static const PRODUCT_BUY_ITEM:String = "Buy Item";
      
      public static const PRODUCT_BUY:String = "Buy";
      
      public static const PRODUCT_MOVE:String = "Move";
      
      public static const PRODUCT_TAB:String = "Tab";
      
      public static const PRODUCT_PREMIUM_SHOP:String = "Premium Shop";
      
      public static const PRODUCT_DETAIL_HUD_OPTION_1:String = "Hud Option 1";
      
      public static const PRODUCT_DETAIL_HUD_OPTION_2:String = "Hud Option 2";
      
      public static const PRODUCT_DETAIL_HUD_OPTION_3:String = "Hud Option 3";
      
      public static const PRODUCT_OPENED:String = "Opened";
      
      public static const PRODUCT_STARTED:String = "Started";
      
      public static const PRODUCT_CANCELED:String = "Canceled";
      
      public static const PRODUCT_CONFIRMED:String = "Confirmed";
      
      public static const PRODUCT_CONTINUE:String = "Continue";
      
      public static const PRODUCT_SENT:String = "sent";
      
      public static const PRODUCT_CHAT_WORLD:String = "world";
      
      public static const PRODUCT_CHAT_ALLIANCE:String = "alliance";
      
      public static const PRODUCT_INVEST_IN_FRIEND:String = "Invest in Friend";
      
      public static const PRODUCT_INVEST_CANCELLED:String = "Cancel invest";
      
      public static const PRODUCT_INVEST_SUCCESSFUL:String = "Invest succesful";
      
      public static const PRODUCT_INVEST_FAILED:String = "Invest failed";
      
      public static const PRODUCT_DETAIL_ATTACKING:String = "Attacking";
      
      public static const PRODUCT_DETAIL_NOT:String = "Not";
      
      public static const EVENT_COLONY:String = "Colony";
      
      public static const LABEL_MOVE_COLONY:String = "Move Colony";
      
      public static const LABEL_ECONOMY_BUY_ITEM:String = "Buy Item";
      
      public static const LABEL_ECONOMY_UPGRADE_ITEM:String = "Upgrade Item";
      
      public static const LABEL_ECONOMY_UPGRADE_UNIT:String = "Upgrade Unit";
      
      public static const LABEL_ECONOMY_ACTIVATE_UNIT:String = "Activate Unit";
      
      public static const LABEL_ECONOMY_BUY_INSTANT_BUILD:String = "Buy Instant Build";
      
      public static const LABEL_ECONOMY_BUY_INSTANT_UPGRADE:String = "Buy Instant Upgrade";
      
      public static const LABEL_ECONOMY_BUY_PREMIUM_UPGRADE:String = "Buy Premium Upgrade";
      
      public static const LABEL_ECONOMY_CANCEL_BUY_ITEM:String = "Cancel Buy Item";
      
      public static const LABEL_ECONOMY_CANCEL_ACTIVATE_UNIT:String = "Cancel Activate Unit";
      
      public static const LABEL_ECONOMY_CANCEL_UPGRADE_UNIT:String = "Cancel Upgrade Unit";
      
      public static const LABEL_ECONOMY_BUY_GC_WITH_PC:String = "Buy GC With PC";
      
      public static const LABEL_ECONOMY_BUY_MINERAL_WITH_PC:String = "Buy Mineral With PC";
      
      public static const LABEL_ECONOMY_BUY_UNIT_SLOT:String = "Buy Unit Slot";
      
      public static const LABEL_ECONOMY_BUY_PROTECTION_TIME:String = "Buy Protection Time";
      
      public static const LABEL_ECONOMY_SPEEDUP_QUEUE:String = "Speed Up Queue";
      
      public static const LABEL_ECONOMY_SPEEDUP_ACTIVATE:String = "Speed up Activate Unit";
      
      public static const LABEL_ECONOMY_SPEEDUP_UPGRADE:String = "Speed up Upgrade Unit";
      
      public static const LABEL_ECONOMY_FIVE_HELPS_REWARD:String = "Five Helps Reward";
      
      public static const LABEL_ECONOMY_DAILY_BONUS_VISIT:String = "Daily Bonus Visit";
      
      public static const LABEL_ATTACK:String = "Attack";
      
      public static const LABEL_VISIT:String = "Visit";
      
      public static const LABEL_SPY:String = "Spy";
      
      public static const EVENT_VISIT:String = "Visit";
      
      public static const LABEL_GETSB:String = "GetSB";
      
      public static const PRODUCT_INVITE_INDIVIDUAL:String = "individual";
      
      public static const PRODUCT_INVITE_SOCIAL_WALL:String = "social Wall";
      
      public static const PRODUCT_DETAIL_INVITE_IDLE:String = "idlePopup";
      
      public static const LABEL_SERVER_FAIL:String = "Fail";
      
      public static const LABEL_SERVER_RESOURCE_NAME:String = "Resource Name";
      
      public static const LABEL_SERVER_RESPONSE_CODE:String = "Response Code";
      
      public static const LABEL_FACEBOOK_FAIL:String = "Fail";
      
      public static const LABEL_FACEBOOK_FRIENDS_FAIL:String = "Friends Fail";
      
      public static const LABEL_FACEBOOK_FRIENDS_TIMEOUT:String = "Friends Timeout";
      
      public static const LABEL_FACEBOOK_APP_FRIENDS_FAIL:String = "App Friends Fail";
      
      public static const LABEL_FACEBOOK_APP_FRIENDS_TIMEOUT:String = "App Friends Timeout";
      
      public static const LABEL_FACEBOOK_USER_FAIL:String = "User Fail";
      
      public static const LABEL_FACEBOOK_USER_TIMEOUT:String = "User Timeout";
      
      public static const LABEL_FACEBOOK_FAN_FAIL:String = "Fan Fail";
      
      public static const LABEL_FACEBOOK_FAN_TIMEOUT:String = "Fan Timeout";
      
      public static const EVENT_LOADING:String = "Loading Game";
      
      public static const EVENT_LOADING_TUTORIAL:String = "Loading Tutorial";
      
      public static const LABEL_LOAD_TEXTS:String = "1. Load Texts";
      
      public static const LABEL_LOAD_LOGIN:String = "2. Log in";
      
      public static const LABEL_LOAD_RULES:String = "3. Load Rules";
      
      public static const LABEL_LOAD_WAIT_FOR_USER_DATA:String = "4. Wait For User Data";
      
      public static const LABEL_LOAD_BUILD_COMPONENTS:String = "5. Build Components";
      
      public static const LABEL_LOAD_UNBUILD_COMPONENT:String = "6. Unbuild Components";
      
      public static const LABEL_LOAD_END:String = "6. End";
      
      public static const LABEL_REQUEST_WORLD:String = "Request world";
      
      public static const LABEL_LOADING_RESOURCE_FAIL:String = "Resource Fail";
      
      public static const EVENT_FPS:String = "FPS";
      
      public static const EVENT_FPS_HQ:String = "FPS HQ";
      
      public static const EVENT_FPS_LQ:String = "FPS LQ";
      
      public static const LABEL_VISIT_ELDERBY:String = "Visit Elderby";
      
      public static const LABEL_FPS_ATTACKING:String = "Attacking";
      
      public static const LABEL_COLLECTING_RENTS:String = "Collecting Rents";
      
      public static const EVENT_CRM_POPUP:String = "Get Popup XML";
      
      public static const LABEL_CRM_POPUP_ERROR:String = "Error";
      
      public static const LABEL_CRM_POPUP_TIMEOUT:String = "Timeout";
      
      public static const LABEL_SPEND_GOLD_FREE:String = "free";
      
      public static const LABEL_SPEND_GOLD_PAID:String = "paid";
      
      public static const EVENT_INVESTS_POPUP:String = "Investments";
      
      public static const LABEL_INVEST_START:String = "Invests";
      
      public static const EVENT_ALLIANCES:String = "alliance";
      
      public static const EVENT_ALLIANCE_WAR:String = "allianceWar";
      
      public static const LABEL_ALLIANCES_NEW_ALLIANCE:String = "newAlliance";
      
      public static const LABEL_ALLIANCES_ASK_FOR_JOIN:String = "askForJoin";
      
      public static const LABEL_ALLIANCES_MESSAGE:String = "message";
      
      public static const LABEL_ALLIANCES_CUSTOMIZATION:String = "allianceCustomization";
      
      public static const LABEL_ALLIANCES_RECRUITING:String = "Recruiting";
      
      public static const LABEL_ALLIANCES_DECLARE_WAR_STARTED:String = "declareStarted";
      
      public static const LABEL_ALLIANCES_DECLARE_WAR_CONFIRMED:String = "declareConfirmed";
      
      public static const LABEL_ALLIANCES_ROLE:String = "role";
      
      public static const LABEL_ALLIANCES_LEAVE:String = "resignAlliance";
      
      public static const LABEL_ALLIANCES_GOTOGROUP:String = "GoToGroup";
      
      public static const PRODUCT_CREATED:String = "created";
      
      public static const PRODUCT_CUSTOMIZATION:String = "Customization";
      
      public static const PRODUCT_FIRST:String = "First";
      
      public static const PRODUCT_ICON:String = "emblem";
      
      public static const PRODUCT_SHAPE:String = "form";
      
      public static const PRODUCT_PATTERN:String = "pattern";
      
      public static const PRODUCT_DESCRIPTION:String = "description";
      
      public static const PRODUCT_INFO:String = "info";
      
      public static const PRODUCT_LEADERBOARD:String = "leaderBoard";
      
      public static const PRODUCT_KICK_MEMBER:String = "kickMember";
      
      public static const PRODUCT_RESIGN_MEMBER:String = "resignMember";
      
      public static const PRODUCT_ALLIANCE_ATTACKER:String = "attack";
      
      public static const PRODUCT_ALLIANCE_DEFENDER:String = "defense";
      
      public static const PRODUCT_QUICK_ATTACK_HOME:String = "Home";
      
      public static const PRODUCT_QUICK_ATTACK_CHANGE_TARGET:String = "Change Target";
      
      public static const PRODUCT_QUICK_ATTACK_TIME_OUT:String = "Time Out";
      
      public static const PRODUCT_QUICK_ATTACK_DEPLOY:String = "Deploy";
      
      public static const LABEL_OPEN_POPUP:String = "popup";
      
      public static const SRC_INVITE_FRIENDS_BAR:String = "vir_invitefriend";
      
      public static const SRC_INVITE_EMPTY_PLANET:String = "vir_invitefriendemptyplanet";
      
      public static const LABEL_HAPPENING_ACCEPTED:String = "event begin";
      
      public static const LABEL_DONE:String = "done";
      
      public static const LABEL_GOAL_ACHIEVED:String = "goal_achieved";
      
      public static const LABEL_TIME_EXPIRED:String = "time_expired";
      
      public static const LABEL_QUICK_ATTACK:String = "quick attack";
      
      public static const LABEL_QUICK_ATTACK_CHOSEN:String = "quick attack chosen";
      
      public static const EVENT_START_BETTING:String = "Start Betting";
      
      public static const EVENT_DETAIL_BETTING:String = "Detail Betting";
      
      public static const EVENT_BATTLE_BETTING:String = "Battle Betting";
      
      public static const LABEL_CHOOSE_BET:String = "Choose Bet";
      
      public static const LABEL_FOUND_RIVAL:String = "Found Rival";
      
      public static const LABEL_WAITING_POPUP:String = "Waiting Popup";
      
      public static const LABEL_DELAYED_RESULT:String = "Delayed Result";
      
      public static const PRODUCT_BETTING:String = "Betting";
      
      public static const EVENT_FB_PROMOTION:String = "FB promotion";
      
      public static const GROUP_LEVEL:String = "Level";
      
      public static const GROUP_SOCIAL:String = "Social";
      
      public static const GROUP_LOADING:String = "Loading";
      
      public static const GROUP_PERFORMANCE:String = "Performance";
      
      public static const GROUP_GAME:String = "Game";
      
      public static const GROUP_CRM:String = "CRM";
      
      public static const GROUP_ECONOMY:String = "Economy";
      
      public static const OFFERS_GROUP:String = "offers";
      
      public static const OFFERS_EVENT_POPUP_OPEN:String = "offersPopupOpen";
      
      public static const OFFERS_EVENT_POPUP_ACCEPTED:String = "offersPopupAccepted";
      
      public static const OFFERS_EVENT_PURCHASE_REQUESTED:String = "offersPurchaseRequested";
      
      private static var smOffersLastEventTracked:String = null;
      
      private static var smCreditsCount:int = 0;
       
      
      public function GameMetrics()
      {
         super();
      }
      
      public static function unloadStatic() : void
      {
         mProfile = null;
         smHQDestroyed = false;
         smAttackedPlanet = null;
         smHashUser = null;
         smArmyValue = 0;
         smAttackedPlanet = null;
         smOffersLastEventTracked = null;
         smCreditsCount = 0;
      }
      
      public static function setHQIsDestroyed(value:Boolean) : void
      {
         smHQDestroyed = value;
      }
      
      public static function getHQIsDestroyed() : Boolean
      {
         return smHQDestroyed;
      }
      
      public static function setAttackedPlanet(planet:String) : void
      {
         smAttackedPlanet = planet;
      }
      
      public static function getAttackedPlanet() : String
      {
         return smAttackedPlanet;
      }
      
      public static function setAttackerPlanet(planet:String) : void
      {
         smAttackerPlanet = planet;
      }
      
      public static function getAttackerPlanet() : String
      {
         return smAttackerPlanet;
      }
      
      public static function getProjectId() : int
      {
         return 37;
      }
      
      public static function setup(stage:Stage) : void
      {
         DCMetrics.subscribeEvent("Session Started",[0,1]);
         DCMetrics.subscribeEvent("Play Tutorial",[0,1]);
         DCMetrics.subscribeEvent("Loading Game",[0,1]);
         DCMetrics.subscribeEvent("Loading Tutorial",[0,1]);
         DCMetrics.subscribeEvent("FPS",[0,1]);
         DCMetrics.subscribeEvent("FPS HQ",[0,1]);
         DCMetrics.subscribeEvent("FPS LQ",[0,1]);
      }
      
      public static function isGoal(group:String, event:String, label:String = null, value:Number = NaN) : Boolean
      {
         return false;
      }
      
      public static function getGroupFromEvent(event:String) : String
      {
         switch(event)
         {
            case "Session Started":
            case "Mission Flow":
            case "Progression":
            case "Bookmark":
            case "Play Tutorial":
            case "Level Reached":
               return "Level";
            case "Invite":
               return "Social";
            case "Loading Game":
            case "Resource Fail":
               return "Loading";
            case "FPS":
            case "FPS HQ":
            case "FPS LQ":
               return "Performance";
            case "First Ingame Action":
            case "Idle Popup Shown":
            case "No Resources Popup":
            case "Battle Finished":
            case "Attack":
            case "Collection Completed":
            case "Coordinate":
            case "alliance":
            case "allianceWar":
            case "allianceCustomization":
            case "PVP Menu":
            case "Friends Bar":
            case "Fanta Ad":
            case "Investments":
            case "FullScreen":
            case "Visit":
            case "Colony":
            case "Start Betting":
            case "Detail Betting":
            case "Battle Betting":
            case "Contest":
            case "Star Trek":
            case "Premium Shop":
            case "FB promotion":
            case "Item Used":
               break;
            case "Get Popup XML":
               return "CRM";
            default:
               DCDebug.traceCh("Tracking","Be Careful. We are returning default value \'Economy\'");
               return "Economy";
         }
         return "Game";
      }
      
      public static function getLevel() : int
      {
         setProfile();
         if(mProfile == null)
         {
            return 0;
         }
         return mProfile.getLevel();
      }
      
      public static function getGameCurrency(product:String) : int
      {
         setProfile();
         if(mProfile == null)
         {
            return 0;
         }
         if(product == "Minerals")
         {
            return mProfile.getMinerals();
         }
         return mProfile.getCoins();
      }
      
      public static function getPremiumCurrency() : int
      {
         setProfile();
         if(mProfile != null)
         {
            return mProfile.getCash();
         }
         return 0;
      }
      
      public static function getIsFan() : int
      {
         setProfile();
         if(mProfile == null)
         {
            return 0;
         }
         return mProfile.mIsFan ? 1 : 0;
      }
      
      public static function getFriendsCount() : int
      {
         var count:int = 0;
         try
         {
            if(InstanceMng.getUserInfoMng().isBuilt())
            {
               count += InstanceMng.getUserInfoMng().getNoPlayerFriendsList().length + getApplicationFriendsCount();
            }
         }
         catch(error:Error)
         {
         }
         return count;
      }
      
      public static function getApplicationFriendsCount() : int
      {
         var count:int = 0;
         try
         {
            if(InstanceMng.getUserInfoMng().isBuilt())
            {
               count += InstanceMng.getUserInfoMng().getPlayerList(1,true,[-1]).length;
            }
         }
         catch(error:Error)
         {
         }
         return count;
      }
      
      public static function getNeighborsCount() : int
      {
         var count:int = 0;
         try
         {
            if(InstanceMng.getUserInfoMng().isBuilt())
            {
               count += InstanceMng.getUserInfoMng().getPlayersFriendsList().length;
            }
         }
         catch(error:Error)
         {
         }
         return count;
      }
      
      private static function setProfile() : void
      {
         try
         {
            if(mProfile == null && InstanceMng.getUserInfoMng() != null && InstanceMng.getUserInfoMng().isBuilt())
            {
               mProfile = InstanceMng.getUserInfoMng().getProfileLogin();
            }
         }
         catch(error:Error)
         {
         }
      }
      
      public static function getHQLevel() : String
      {
         var hq:WorldItemObject = InstanceMng.getWorld().itemsGetHeadquarters();
         var returnValue:int = -1;
         if(hq != null)
         {
            returnValue = hq.mUpgradeId;
         }
         return returnValue.toString();
      }
      
      public static function getUserHash() : String
      {
         var seed:String = null;
         if(smHashUser == null)
         {
            setProfile();
            if(mProfile != null)
            {
               seed = mProfile.getExtId() + getTimer();
               smHashUser = MD5.hash(seed);
            }
         }
         return smHashUser;
      }
      
      public static function getNumColonies() : int
      {
         setProfile();
         if(mProfile != null)
         {
            return mProfile.getUserInfoObj().getPlanetsAmount();
         }
         return 0;
      }
      
      public static function getPlanetProductByIndex(index:String) : String
      {
         return index == "1" ? "capital" : "colony" + (String(int(index) - 1));
      }
      
      public static function getCurrentPlanetId() : String
      {
         return InstanceMng.getUserInfoMng().getProfileLogin().getCurrentPlanetId();
      }
      
      private static function offersIsEventAllowed(event:String) : Boolean
      {
         var returnValue:* = true;
         switch(event)
         {
            case "offersPopupAccepted":
               returnValue = smOffersLastEventTracked == "offersPopupOpen";
               break;
            case "offersPurchaseRequested":
               returnValue = smOffersLastEventTracked == "offersPopupAccepted";
         }
         return returnValue;
      }
      
      private static function offersSendEvent(event:String) : void
      {
         if(offersIsEventAllowed(event))
         {
            smOffersLastEventTracked = event;
         }
      }
      
      public static function offersTrackPopupOpen() : void
      {
         offersSendEvent("offersPopupOpen");
      }
      
      public static function offersTrackPopupAccepted() : void
      {
         offersSendEvent("offersPopupAccepted");
      }
      
      public static function offersTrackPurchaseRequested() : void
      {
         offersSendEvent("offersPurchaseRequested");
      }
      
      public static function creditsRequestPurchase(sku:String, creditsCount:int) : void
      {
         DCMetrics.sendMetric("PC Purchase","Continue",sku);
         offersTrackPurchaseRequested();
         smCreditsCount = creditsCount;
      }
      
      public static function creditsCheckPendingTransaction(creditsCount:int) : void
      {
         if(smCreditsCount > 0 && smCreditsCount == creditsCount)
         {
            smCreditsCount = 0;
         }
      }
   }
}
