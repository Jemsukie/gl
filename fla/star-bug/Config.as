package
{
   import com.dchoc.game.core.instance.InstanceMng;
   
   public class Config
   {
      
      public static const PROJECT_ID:int = 37;
      
      public static const DEFAULT_PLATFORM:String = "facebook";
      
      public static const DEFAULT_LANGUAGE:String = "EN";
      
      public static var OFFLINE_GAMEPLAY_MODE:Boolean = false;
      
      public static var IGNORE_LOGOUT:Boolean = false;
      
      public static var USE_LOCALE:Boolean = true;
      
      public static var USE_LAZY_SERVER_RESPONSE:Boolean = false;
      
      public static var USE_LAZY_LOGIC_UPDATES:Boolean = false;
      
      public static const USE_SCREEN_DRAW_ONLY_VISIBLE_ITEMS:Boolean = true;
      
      public static var USE_NEWS_FEEDS:Boolean = true;
      
      public static var USE_METRICS:Boolean = false;
      
      public static const USE_UNITS_PATHFINDING:Boolean = true;
      
      public static const USE_UNITS_SEPARATE_EACH_OTHER:Boolean = true;
      
      public static const GALAXY_WINDOW_SERVER_REQUEST_OFFSET_MIN:int = 20;
      
      public static const GALAXY_WINDOW_SERVER_REQUEST_OFFSET_MAX:int = 20;
      
      private static var USE_ALLIANCES:Boolean = true;
      
      public static var OFFLINE_ALLIANCES_MODE:Boolean = OFFLINE_GAMEPLAY_MODE;
      
      public static const XP_DECIMALS_FACTOR:int = 1;
      
      public static const USE_HALLOWEEN_POPUPS:Boolean = true;
      
      public static const CLIENT_SEND_REWARD_OF_VIDEO_COMPLETED:Boolean = false;
      
      public static var DEBUG_MODE:Boolean = false;
      
      public static var DEBUG_CATCH_EXCEPTIONS:Boolean = false;
      
      public static var NOTIFY_EXCEPTIONS_TO_SERVER:Boolean = false;
      
      public static var DEBUG_UNIT_SCENE:Boolean = DEBUG_MODE;
      
      public static var DEBUG_SCREEN:Boolean = DEBUG_MODE;
      
      public static var DEBUG_LOADING:Boolean = DEBUG_MODE;
      
      public static var DEBUG_SERVER:Boolean = DEBUG_MODE;
      
      public static var DEBUG_CONSOLE:Boolean = DEBUG_MODE;
      
      public static var DEBUG_ASSERTS:Boolean = DEBUG_MODE;
      
      public static var DEBUG_MEMORY:Boolean = DEBUG_MODE;
      
      public static var DEBUG_PATHS:Boolean = DEBUG_MODE;
      
      public static var DEBUG_ITEMS:Boolean = DEBUG_MODE;
      
      public static var DEBUG_BATTLE:Boolean = DEBUG_MODE && false;
      
      public static var DEBUG_FLAGS:Boolean = DEBUG_MODE && false;
      
      public static var DEBUG_SIG:Boolean = DEBUG_MODE && false;
      
      public static var DEBUG_REQ_TIME:Boolean = DEBUG_MODE && false;
      
      public static var DEBUG_SHORTEN_NOISY:Boolean = DEBUG_MODE && false;
      
      public static var DEBUG_SHORTEN_NOISY_CMDS:Array = ["ping","universe","battleReplay","requestAlliancesList","requestAllianceById"];
      
      public static var DEBUG_SHORTEN_NOISY_ACTIONS:Array = ["battleDamagesPack","setFlag","getAlliances","getAlliance"];
      
      public static const THROW_EXCEPTION_IF_ERROR_IN_ASSETS_OR_SKINS:Boolean = DEBUG_MODE;
      
      public static var ENABLE_PROFILING:Boolean = false;
      
      private static const DEFAULT_ROOT:String = "";
      
      public static const DIR_DATA:String = "";
      
      public static var USE_SOUNDS:Boolean = true;
      
      public static const BUTTON_USE_HAND_CURSOR:Boolean = false;
      
      public static const COMPONENT_CHILDREN_LOAD_MAX_STEPS:int = 1;
      
      public static const COMPONENT_CHILDREN_BUILD_MAX_STEPS:int = 1;
      
      public static const COOKIE_SETTINGS_NAME:String = "Settings";
      
      public static const COOKIE_SETTINGS_NAME_MUSIC:String = "Music";
      
      public static const COOKIE_SETTINGS_NAME_SFX:String = "Sfx";
      
      public static const COOKIE_SETTINGS_NAME_QUALITY:String = "Quality";
      
      public static const SCREEN_WIDTH:int = 760;
      
      public static const SCREEN_HEIGHT:int = 594;
      
      public static const EDIT_MODE:Boolean = OFFLINE_GAMEPLAY_MODE;
      
      public static const CHEATS_ENABLED:Boolean = false;
      
      public static const CHEATS_VIPS:Boolean = false;
      
      public static const CHEATS_CHECK_ENV:Boolean = true;
      
      public static const CHEAT_TIME_ID:int = 0;
      
      public static const CHEAT_EXP_ID:int = 1;
      
      public static const CHEAT_HARD_RESET_ID:int = 2;
      
      public static const CHEAT_DCCOINS_ID:int = 3;
      
      public static const CHEAT_DCCASH_ID:int = 4;
      
      public static const CHEAT_DEBUG_ID:int = 5;
      
      public static const CHEAT_ANY_ID:int = 2147483647;
      
      private static const CHEATS_VIP_ALLOWED_IDS:Array = [5];
      
      public static const BACKGROUND_DEFAULT_COLOR:uint = 16777215;
      
      public static const LOADING_BACKGROUND_DEFAULT_COLOR:uint = 0;
      
      public static const NUMBER_COMPARISON_EPSILON:Number = 0.000001;
      
      public static const RESOURCES_LOADING_ATTEMPTS_MAX:int = 3;
      
      public static const RESOURCES_LOADING_QUEUE_ENABLED:Boolean = false;
      
      public static const RESOURCES_LOADING_QUEUE_SIMULTANEOUSLY:int = 1;
      
      public static const TILE_WIDTH:int = 22;
      
      public static const TILE_HEIGHT:int = 22;
      
      public static const TILE_SEMI_WIDTH:int = 11;
      
      public static const TILE_SEMI_HEIGHT:int = 11;
      
      public static const TILE_VIEW_WIDTH:int = 32;
      
      public static const TILE_VIEW_HEIGHT:int = 16;
      
      public static var FIX_UNIT_NOT_DRAWN_WHEN_ENTERING_IN_CAMERA:Boolean = true;
      
      public static const SEND_HANGARS_CONTENTS_IN_CHECK_AVAILABLE_ATTACK_SERVER_QUERY:Boolean = true;
      
      public static const PLATFORM_FB_ID:int = 0;
      
      public static const PLATFORM_PAID_CURRENCY_KEYS:Array = ["fbc"];
      
      public static const PAID_CURRENCY_PC_KEY:String = "pc";
      
      public static const PAID_CURRENCY_FB_KEY:String = "fbc";
      
      public static const PAID_CURRENCY_DEFAULT_KEY:String = "pc";
      
      public static const PAID_CURRENCY_KEYS:Array = ["pc","fbc"];
      
      public static const PAID_CURRENCY_COUNT:int = PAID_CURRENCY_KEYS.length;
      
      private static var smUseEncryption:Boolean = false;
      
      private static var smUseRulesEncryption:Boolean = false;
      
      private static var mRoot:String = "";
       
      
      public function Config()
      {
         super();
      }
      
      public static function useEncriptation() : Boolean
      {
         return smUseEncryption;
      }
      
      public static function useRulesEncriptation() : Boolean
      {
         return smUseRulesEncryption;
      }
      
      public static function init() : void
      {
         var flashVars:Object = Star.getFlashVars();
         smUseEncryption = flashVars["env"] == "stage" || flashVars["env"] == "prod";
         smUseRulesEncryption = false;
      }
      
      public static function setRoot(root:String) : void
      {
         mRoot = root;
      }
      
      public static function getRoot() : String
      {
         return mRoot;
      }
      
      public static function cheatsAreEnabled() : Boolean
      {
         return false;
      }
      
      public static function useAlliances() : Boolean
      {
         var flashVars:Object = null;
         var returnValue:Boolean = USE_ALLIANCES;
         if(returnValue)
         {
            flashVars = Star.getFlashVars();
            if(flashVars != null)
            {
               returnValue = flashVars.useAlliances != null && flashVars.useAlliances == "true" || flashVars.useAlliances == true;
            }
         }
         return returnValue;
      }
      
      public static function useTelemetry() : Boolean
      {
         return true;
      }
      
      public static function useInvests() : Boolean
      {
         var flashVars:Object = null;
         var returnValue:Boolean = true;
         if(returnValue)
         {
            flashVars = Star.getFlashVars();
            if(flashVars != null)
            {
               returnValue = flashVars.useInvests != null && flashVars.useInvests == "true" || flashVars.useInvests == true;
            }
         }
         return returnValue;
      }
      
      public static function getCurrentPlatform() : String
      {
         return Star.getFlashVars().platform;
      }
      
      public static function useBuyBattleTime() : Boolean
      {
         return true;
      }
      
      public static function useReorderUnits() : Boolean
      {
         return true;
      }
      
      public static function useOfferInHUD() : Boolean
      {
         return true;
      }
      
      public static function useHappenings() : Boolean
      {
         return true;
      }
      
      public static function useRepairForFree() : Boolean
      {
         return true;
      }
      
      public static function usePowerUps() : Boolean
      {
         return true;
      }
      
      public static function useDoomsdayPopups() : Boolean
      {
         return false;
      }
      
      public static function useOptSenseWalls() : Boolean
      {
         return true;
      }
      
      public static function useQuickAttack() : Boolean
      {
         return true;
      }
      
      public static function useQuickAttackFirstTimeFree() : Boolean
      {
         return useQuickAttack() && false;
      }
      
      public static function useNaranjitoOnAttackInProgress() : Boolean
      {
         return InstanceMng.getPlatformSettingsDefMng().getUseNaranjito();
      }
      
      public static function useEsparragon() : Boolean
      {
         return true;
      }
      
      public static function useEsparragonGUI() : Boolean
      {
         return true;
      }
      
      public static function useEsparragonTooltips() : Boolean
      {
         return useEsparragon();
      }
      
      public static function useBets() : Boolean
      {
         return true;
      }
      
      public static function useContests() : Boolean
      {
         return true;
      }
      
      public static function useUmbrella() : Boolean
      {
         return true;
      }
      
      public static function useStarTrekShop() : Boolean
      {
         return true;
      }
      
      public static function useRulesPackage() : Boolean
      {
         return true;
      }
      
      public static function useSpilAd() : Boolean
      {
         return true;
      }
      
      public static function useUpSelling() : Boolean
      {
         return true;
      }
      
      public static function useMobilePaymentsWithServer() : Boolean
      {
         return true;
      }
      
      public static function useStartNow() : Boolean
      {
         return false;
      }
      
      public static function useAlliancesSuggested() : Boolean
      {
         return true;
      }
   }
}
