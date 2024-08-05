package com.dchoc.game.model.alliances
{
   import com.dchoc.game.controller.alliances.AlliancesControllerStar;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   
   public class AlliancesConstants
   {
      
      public static const TIME_BETWEEN_AUTOMATIC_INITIALIZES_MS:Number = DCTimerUtil.minToMs(5);
      
      public static const MAX_MEMBERS_TO_INVITE:int = 5000;
      
      public static const ROLE_LEADER:String = "LEADER";
      
      public static const ROLE_ADMIN:String = "ADMIN";
      
      public static const ROLE_REGULAR:String = "REGULAR";
      
      public static const KO_BAR_NOT_USED:Number = Number.MIN_VALUE;
      
      public static const STATE_NORMAL:int = 0;
      
      public static const STATE_HAS_SHIELD:int = 1;
      
      public static const STATE_IN_WAR:int = 2;
      
      public static const ROLE_TIDS:Array = [2814,2816,2818];
      
      public static const ROLE_NUM_VALUES:Array = [2,1,0];
      
      public static const NEWS_TYPE_ALLIANCE:int = 0;
      
      public static const NEWS_TYPE_MEMBERS:int = 1;
      
      public static const NEWS_TYPE_WAR:int = 2;
      
      public static const NEWS_SUBTYPE_ALLIANCE_LEVEL_UP:int = 0;
      
      public static const NEWS_SUBTYPE_MEMBERS_JOIN:int = 1;
      
      public static const NEWS_SUBTYPE_MEMBERS_LEFT:int = 2;
      
      public static const NEWS_SUBTYPE_MEMBERS_KICKED:int = 3;
      
      public static const NEWS_SUBTYPE_MEMBERS_PROMOTED_TO_LEADER:int = 4;
      
      public static const NEWS_SUBTYPE_MEMBERS_PROMOTED_TO_ADMIN:int = 5;
      
      public static const NEWS_SUBTYPE_MEMBERS_DEMOTED_TO_ADMIN:int = 6;
      
      public static const NEWS_SUBTYPE_MEMBERS_DEMOTED_TO_REGULAR:int = 7;
      
      public static const NEWS_SUBTYPE_WAR_DECLARE_WAR:int = 8;
      
      public static const NEWS_SUBTYPE_WAR_WAR_DECLARED:int = 9;
      
      public static const NEWS_SUBTYPE_WAR_WAR_WON:int = 10;
      
      public static const NEWS_SUBTYPE_WAR_WAR_LOST:int = 11;
      
      public static const NEWS_SUBTYPE_ALLIANCE_CREATED:int = 12;
      
      public static const NEWS_SUBTYPE_MEMBERS_NEW_GENERAL:int = 13;
      
      public static const NEWS_SUBTYPE_WAR_WAR_LOOKING:int = 14;
      
      public static const ERROR_CODE_NEED_TO_WAIT_FOR_SEND_REQUEST_AGAIN:int = 99;
      
      public static const ERROR_CODE_UNDEFINED:int = 0;
      
      public static const ERROR_CODE_INVALID_COMMAND:int = 1;
      
      public static const ERROR_CODE_INVALID_PARAMETERS:int = 2;
      
      public static const ERROR_CODE_NAME_TOO_SHORT:int = 3;
      
      public static const ERROR_CODE_NAME_ALREADY_TAKEN:int = 4;
      
      public static const ERROR_CODE_ALREADY_MEMBER_OF_AN_ALLIANCE:int = 5;
      
      public static const ERROR_CODE_ALLIANCE_IS_FULL:int = 6;
      
      public static const ERROR_CODE_ALLIANCE_WAS_EMPTY:int = 7;
      
      public static const ERROR_CODE_ALLIANCE_NOT_FOUND:int = 8;
      
      public static const ERROR_CODE_MEMBER_NOT_FOUND:int = 9;
      
      public static const ERROR_CODE_MEMBER_NOT_IN_AN_ALLIANCE:int = 10;
      
      public static const ERROR_CODE_INTERNAL_ERROR:int = 11;
      
      public static const ERROR_CODE_TIMEOUT:int = 12;
      
      public static const ERROR_CODE_NO_PERMISSION:int = 13;
      
      public static const ERROR_CODE_MY_ALLIANCE_ALREADY_IN_WAR:int = 14;
      
      public static const ERROR_CODE_ALLIANCE_ALREADY_IN_WAR:int = 15;
      
      public static const ERROR_CODE_ALLIANCE_LOCKED:int = 16;
      
      public static const ERROR_CODE_ALLIANCE_HAS_POST_WAR_SHIELD:int = 17;
      
      public static const ERROR_CODE_LEVEL_TOO_LOW:int = 18;
      
      public static const ERROR_CODE_MEMBER_NOT_ALLOWED_TO_LEAVE_ALLIANCE:int = 19;
      
      public static const ENEMY_CODE_ALLIANCE_TOO_WEAK:int = 20;
      
      public static const ENEMY_CODE_ALLIANCE_TOO_STRONG:int = 21;
      
      public static const ENEMY_CODE_ALLIANCE_ATTACKED_RECENTLY:int = 22;
      
      public static const ERROR_CODE_NO_ALLIANCE_FOUND_TO_WAR:int = 23;
      
      public static const ERROR_COUNT:int = 24;
      
      public static const ERROR_CODE_TO_TID:Array = [-1,2907,2909,2911,2913,2915,2917,2919,2921,2923,2925,2927,2929,2931,2933,2935,2937,2939,2905,3055,3058,3060,3062,3074,3641];
      
      public static const ERROR_CODE_TO_TID_TITLE:Array = [-1,2906,2908,2910,2912,2914,2916,2918,2920,2922,2924,2926,2928,2930,2932,2934,2936,2938,2904,191,3057,3059,3059,3073,3640];
      
      public static const OBJ_KEY_ACTION:String = "action";
      
      public static const OBJ_KEY_CLIENT_CMD:String = "clientCmd";
      
      public static const OBJ_KEY_ADMIN_ID:String = "adminId";
      
      public static const OBJ_KEY_MEMBER_ID:String = "memberId";
      
      public static const OBJ_KEY_ROLE:String = "role";
      
      public static const OBJ_KEY_ALLIANCE_ID:String = "aid";
      
      public static const OBJ_KEY_NAME:String = "name";
      
      public static const OBJ_KEY_DESCRIPTION:String = "description";
      
      public static const OBJ_KEY_LOGO:String = "logo";
      
      public static const OBJ_KEY_PUBLIC_VISIBILITY:String = "publicRecruit";
      
      public static const OBJ_KEY_INCLUDE_MEMBERS:String = "includeMembers";
      
      public static const OBJ_KEY_FROM:String = "from";
      
      public static const OBJ_KEY_COUNT:String = "count";
      
      public static const OBJ_KEY_SEARCH_KEY:String = "searchKey";
      
      public static const OBJ_KEY_MESSAGE:String = "message";
      
      public static const OBJ_KEY_NEWS_TYPES:String = "types";
      
      public static const OBJ_KEY_RETURN_USER_PAGE:String = "userPage";
      
      public static const OBJ_KEY_PARAMS_OK:String = "paramsOk";
      
      public static const OBJ_KEY_LOCK_UI:String = "lockUI";
      
      public static const OBJ_KEY_ON_SUCCESS:String = "onSuccess";
      
      public static const OBJ_KEY_ON_FAIL:String = "onFail";
       
      
      public function AlliancesConstants()
      {
         super();
      }
      
      private static function getErrorCodeProcessed(errorCode:int) : int
      {
         var popupShown:Boolean = Boolean(AlliancesControllerStar(InstanceMng.getAlliancesController()).isPopupAlliancesBeingShown());
         if(errorCode == 11 && popupShown)
         {
            errorCode = 16;
         }
         return errorCode;
      }
      
      public static function getErrorMsg(errorCode:int, errorData:Object = null) : String
      {
         var timeLeft:Number = NaN;
         var alliName:String = null;
         errorCode = getErrorCodeProcessed(errorCode);
         var tid:int = int(errorCode < 0 || errorCode >= ERROR_CODE_TO_TID.length ? -1 : int(ERROR_CODE_TO_TID[errorCode]));
         var msg:String = "error " + errorCode;
         if(tid > -1)
         {
            switch(errorCode - 5)
            {
               case 0:
                  alliName = null;
                  if(errorData != null)
                  {
                     alliName = String(errorData["name"]);
                  }
                  if(alliName != null && alliName != "")
                  {
                     msg = DCTextMng.replaceParameters(tid,[alliName]);
                  }
                  else
                  {
                     msg = DCTextMng.getText(tid);
                     msg = msg.substring(0,msg.length - 4);
                  }
                  break;
               case 17:
                  timeLeft = 0;
                  if(errorData != null)
                  {
                     timeLeft = Number(errorData["timeLeft"]);
                  }
                  if(timeLeft < 3600000)
                  {
                     timeLeft = 3600000;
                  }
                  msg = DCTextMng.replaceParameters(tid,[DCTextMng.convertTimeToString(timeLeft,true,false)]);
                  break;
               default:
                  msg = DCTextMng.getText(tid);
            }
         }
         return msg;
      }
      
      public static function getErrorTitle(errorCode:int) : String
      {
         var tid:int = 0;
         if(errorCode == 99)
         {
            tid = 2989;
         }
         else
         {
            errorCode = getErrorCodeProcessed(errorCode);
            tid = int(errorCode < 0 || errorCode >= ERROR_CODE_TO_TID_TITLE.length ? -1 : int(ERROR_CODE_TO_TID_TITLE[errorCode]));
         }
         return tid == -1 ? "error " + errorCode : DCTextMng.getText(tid);
      }
      
      public static function toNumericCode(role:String) : int
      {
         switch(role)
         {
            case "LEADER":
               return 0;
            case "ADMIN":
               return 1;
            case "REGULAR":
               return 2;
            default:
               return -1;
         }
      }
      
      public static function getLogoArrayFromString(value:String) : Array
      {
         var str:String = null;
         if(value == "" || value == null)
         {
            return null;
         }
         var logoStrArray:Array = value.split(",");
         var logoArray:Array = [];
         for each(str in logoStrArray)
         {
            if(str != "")
            {
               logoArray.push(int(str));
            }
         }
         return logoArray;
      }
      
      public static function getLogoArrayAsString(logo:Array) : String
      {
         var d:int = 0;
         var returnValue:String = "";
         for each(d in logo)
         {
            returnValue += d + ",";
         }
         return returnValue;
      }
      
      public static function getScoreFromRaw(value:Number) : Number
      {
         if(isNaN(value))
         {
            value = 0;
         }
         return value;
      }
      
      public static function getScoreRawFromScore(value:Number) : Number
      {
         return value;
      }
      
      public static function canRoleDoActionsOverMembers(role:String) : Boolean
      {
         return role == "LEADER";
      }
      
      public static function canRoleInvitePeople(role:String) : Boolean
      {
         return role == "LEADER" || role == "ADMIN";
      }
      
      public static function canRoleDeclareWar(role:String) : Boolean
      {
         return role == "LEADER" || role == "ADMIN";
      }
      
      public static function getRoleAsText(role:String) : String
      {
         var returnValue:String = "";
         var code:int = toNumericCode(role);
         if(code > -1)
         {
            returnValue = DCTextMng.getText(ROLE_TIDS[code]);
         }
         return returnValue;
      }
      
      public static function getRoleAsNumericValue(role:String) : Number
      {
         return ROLE_NUM_VALUES[toNumericCode(role)];
      }
      
      public static function getVisitRoleId(accountId:String, forcedSpy:Boolean = false) : int
      {
         var userInfo:UserInfo = null;
         var returnValue:int = 2;
         if(!forcedSpy)
         {
            userInfo = InstanceMng.getUserInfoMng().getUserInfoObj(accountId,0,2);
            returnValue = userInfo != null ? 1 : 2;
         }
         return returnValue;
      }
      
      public static function objCreateGetMyAlliance(clientCmd:String, adminId:String) : Object
      {
         var data:Object = {};
         data["clientCmd"] = clientCmd;
         data["action"] = "getMyAlliance";
         data["paramsOk"] = true;
         return data;
      }
      
      public static function objCreateGetAllianceByUserId(clientCmd:String, userId:String, includeMembers:Boolean) : Object
      {
         var data:Object;
         (data = {})["clientCmd"] = clientCmd;
         data["action"] = "getAlliance";
         data["guid"] = userId;
         data[objGetKey(data,"includeMembers")] = includeMembers;
         data[objGetKey(data,"memberId")] = userId;
         data["paramsOk"] = userId != null;
         return data;
      }
      
      public static function objCreateGetAllianceById(clientCmd:String, allianceId:String, includeMembers:Boolean) : Object
      {
         var data:Object;
         (data = {})["clientCmd"] = clientCmd;
         data["action"] = "getAlliance";
         data[objGetKey(data,"aid")] = allianceId;
         data[objGetKey(data,"includeMembers")] = includeMembers;
         data["paramsOk"] = allianceId != null;
         return data;
      }
      
      public static function objCreateCreateAlliance(clientCmd:String, adminId:String, name:String, description:String, logo:String, isPublic:Boolean) : Object
      {
         var data:Object;
         (data = {})["clientCmd"] = clientCmd;
         data["action"] = "createAlliance";
         data["guid"] = adminId;
         data[objGetKey(data,"name")] = name;
         data[objGetKey(data,"description")] = description;
         data[objGetKey(data,"logo")] = logo;
         data["limit"] = 50;
         data[objGetKey(data,"publicRecruit")] = isPublic;
         data["paramsOk"] = adminId != null && name != null && description != null && logo != null;
         return data;
      }
      
      public static function objCreateEditAlliance(clientCmd:String, adminId:String, description:String, logo:String, isPublic:Boolean) : Object
      {
         var data:Object;
         (data = {})["clientCmd"] = clientCmd;
         data["action"] = "editAlliance";
         data["guid"] = adminId;
         data[objGetKey(data,"description")] = description;
         data[objGetKey(data,"logo")] = logo;
         data[objGetKey(data,"publicRecruit")] = isPublic;
         data["paramsOk"] = adminId != null && description != null && logo != null;
         return data;
      }
      
      public static function objCreateGetAlliances(clientCmd:String, start_index:int, count:int, search_string:String, centerInUserPage:Boolean) : Object
      {
         var data:Object;
         (data = {})["clientCmd"] = clientCmd;
         data["action"] = "getAlliances";
         data[objGetKey(data,"from")] = start_index;
         data[objGetKey(data,"count")] = count;
         if(search_string != null && search_string != "")
         {
            data[objGetKey(data,"searchKey")] = search_string;
         }
         data[objGetKey(data,"userPage")] = centerInUserPage;
         data["paramsOk"] = count > 0;
         return data;
      }
      
      public static function objCreateJoin(clientCmd:String, adminId:String, allianceId:String) : Object
      {
         var data:Object;
         (data = {})["clientCmd"] = clientCmd;
         data["action"] = "joinAlliance";
         data["guid"] = adminId;
         data[objGetKey(data,"aid")] = allianceId;
         data["paramsOk"] = adminId != null && allianceId != null;
         return data;
      }
      
      public static function objCreateLeave(clientCmd:String, adminId:String) : Object
      {
         var data:Object = {};
         data["clientCmd"] = clientCmd;
         data["action"] = "leaveAlliance";
         data["guid"] = adminId;
         data["paramsOk"] = adminId != null;
         return data;
      }
      
      private static function objCreateChangeRole(clientCmd:String, adminId:String, memberId:String, newRole:String) : Object
      {
         var data:Object;
         (data = {})["clientCmd"] = clientCmd;
         data["action"] = "grantMember";
         data["adminId"] = adminId;
         data[objGetKey(data,"memberId")] = memberId;
         data[objGetKey(data,"role")] = newRole;
         data["paramsOk"] = adminId != null && memberId != null && newRole != null;
         return data;
      }
      
      public static function objCreatePromoteTo(clientCmd:String, adminId:String, memberId:String, role:String) : Object
      {
         return objCreateChangeRole(clientCmd,adminId,memberId,role);
      }
      
      public static function objCreateDemoteTo(clientCmd:String, adminId:String, memberId:String, role:String) : Object
      {
         return objCreateChangeRole(clientCmd,adminId,memberId,role);
      }
      
      public static function objCreateKick(clientCmd:String, adminId:String, memberId:String) : Object
      {
         var data:Object;
         (data = {})["clientCmd"] = clientCmd;
         data["action"] = "kickMember";
         data["adminId"] = adminId;
         data[objGetKey(data,"memberId")] = memberId;
         data["paramsOk"] = adminId != null && memberId;
         return data;
      }
      
      public static function objCreateDeclareWar(clientCmd:String, adminId:String, allianceAgainstId:String) : Object
      {
         var data:Object;
         (data = {})["clientCmd"] = clientCmd;
         data["action"] = "declareWar";
         data["gui"] = adminId;
         data[objGetKey(data,"aid")] = allianceAgainstId;
         data["paramsOk"] = adminId != null && allianceAgainstId != null && allianceAgainstId != "0";
         return data;
      }
      
      public static function objCreateGetWarsHistory(clientCmd:String, allianceId:String, startIndex:int, count:int) : Object
      {
         var data:Object;
         (data = {})["clientCmd"] = clientCmd;
         data["action"] = "warHistory";
         data["aid"] = allianceId;
         data[objGetKey(data,"from")] = startIndex;
         data[objGetKey(data,"count")] = count;
         data["paramsOk"] = allianceId != null;
         return data;
      }
      
      public static function objCreateGetNews(clientCmd:String, types:Array, adminId:String, start_index:int, count:int, onSuccess:Function, onFail:Function, lockUI:Boolean) : Object
      {
         var data:Object;
         (data = {})["clientCmd"] = clientCmd;
         data["action"] = "getNews";
         data["guid"] = adminId;
         data[objGetKey(data,"from")] = start_index;
         data[objGetKey(data,"count")] = count;
         data[objGetKey(data,"types")] = types;
         data["paramsOk"] = adminId != null && count > 0;
         data["onSuccess"] = onSuccess;
         data["onFail"] = onFail;
         data["lockUI"] = lockUI;
         return data;
      }
      
      public static function objCreateInviteFriends(clientCmd:String) : Object
      {
         var data:Object = {};
         data["clientCmd"] = clientCmd;
         data["blacklist"] = objWishlistFriends(true);
         data["message"] = DCTextMng.getText(3483);
         data["title"] = DCTextMng.getText(3482);
         data["paramsOk"] = true;
         return data;
      }
      
      public static function objCreateGetSuggestedWarAlliance(clientCmd:String, type:String, aid:String) : Object
      {
         var data:Object;
         (data = {})["clientCmd"] = clientCmd;
         data["action"] = clientCmd;
         data["type"] = type;
         data["aid"] = aid;
         return data;
      }
      
      public static function objWishlistFriends(useAsWhiteList:Boolean = false) : Object
      {
         var v:Vector.<String> = InstanceMng.getAlliancesController().getUsersNotAllowedToBeInvitedToMyAlliance();
         DCDebug.traceChObject("alInvites",v,"excluded:");
         return InstanceMng.getUserInfoMng().getPlatformUsersObject(v,useAsWhiteList);
      }
      
      public static function objGetKey(params:Object, key:String) : String
      {
         var action:String = null;
         var returnValue:* = key;
         if(params != null)
         {
            action = String(params["action"]);
            var _loc5_:* = key;
            if("from" !== _loc5_)
            {
               switch(action)
               {
                  case "getNews":
                     returnValue = "fromIndex";
                     break;
                  case "warHistory":
                     returnValue = "startIndex";
               }
            }
            else
            {
               switch(action)
               {
                  case "getNews":
                     returnValue = "fromIndex";
                     break;
                  case "warHistory":
                     returnValue = "startIndex";
               }
            }
         }
         return returnValue;
      }
      
      public function getScoreText(value:Number) : String
      {
         return DCTextMng.convertNumberToString(value,0,0);
      }
   }
}
