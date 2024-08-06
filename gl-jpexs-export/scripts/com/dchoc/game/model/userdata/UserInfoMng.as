package com.dchoc.game.model.userdata
{
   import com.adobe.utils.ArrayUtil;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.rule.RuleMng;
   import com.dchoc.game.model.cache.GraphicsCacheMng;
   import com.dchoc.game.model.rule.LevelScoreDef;
   import com.dchoc.game.model.space.Planet;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.DCUtils;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.math.DCMath;
   import esparragon.utils.EUtils;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.utils.Dictionary;
   
   public class UserInfoMng extends DCComponent
   {
      
      public static const SEARCH_ON_ALL:int = -1;
      
      public static const SEARCH_ON_NON_PLAYING_FRIENDS:int = 0;
      
      public static const SEARCH_ON_PLAYING_FRIENDS:int = 1;
      
      public static const SEARCH_ON_NEIGHBOR_FRIENDS:int = 2;
      
      public static const SEARCH_ON_NPC:int = 3;
      
      public static const SEARCH_ON_USER_OWNER:int = 4;
      
      public static const SEARCH_ON_OTHER_PLAYERS:int = 5;
      
      public static const SEARCH_ON_FIGHT_PLAYERS:int = 6;
      
      public static const SEARCH_BY_ACCOUNT_ID:int = 0;
      
      public static const SEARCH_BY_EXT_ID:int = 1;
      
      public static const SORT_BY_EXP_DESC:int = 0;
      
      public static const SORT_BY_EXP_ASC:int = 1;
      
      public static const SORT_BY_EXT_ID_DESC:int = 2;
      
      public static const SORT_BY_NUMFIGHTS_DESC:int = 3;
      
      public static const SORT_BY_SCORE_DESC:int = 4;
      
      public static const SORT_BY_PERCENTAGE_MIXED_SCORE_XP_DESC:int = 5;
      
      public static const PROFILES_OWNER:int = 0;
      
      public static const PROFILES_VISITING:int = 1;
      
      public static const PROFILES_COUNT:int = 2;
       
      
      private var mNoPlayerFriendsList:Vector.<UserInfo>;
      
      private var mPlayerFriendsList:Vector.<UserInfo>;
      
      private var mNeighborsList:Vector.<UserInfo>;
      
      private var mNPCsList:Vector.<UserInfo>;
      
      private var mUserOwnerList:Vector.<UserInfo>;
      
      private var mOtherPlayersList:Vector.<UserInfo>;
      
      private var mUserInfoList:Vector.<Vector.<UserInfo>>;
      
      private var mUserListsCatalog:Dictionary;
      
      public var mInfoLoaded:Boolean;
      
      public var mFriendsListLoaded:Boolean;
      
      public var mNeighborsListLoaded:Boolean;
      
      private var mUserToVisit:UserInfo;
      
      private var mTaskWaiting:String;
      
      private var mAttackerUserInfo:UserInfo;
      
      private var mAttackedUserInfo:UserInfo;
      
      public var mNPCListInfo:XML = null;
      
      private var mNPCInstancesCreated:Boolean = false;
      
      private var mCurrentProfileLoaded:int = 0;
      
      public var mProfilesList:Vector.<Profile>;
      
      private var mDamageProtectionTimeUsers:Vector.<UserInfo>;
      
      private var mOnlineUsers:Vector.<UserInfo>;
      
      private var mLastAttackers:Vector.<UserInfo>;
      
      private var mAttackersCatalog:Dictionary;
      
      private var mLastAttack:AttackStatistics;
      
      private var mWeeklyScoreList:Vector.<UserScoreInfo>;
      
      private var mOldWeeklyScoreList:Vector.<UserScoreInfo>;
      
      private var mUserOldPosWeeklyList:int = -1;
      
      private var mWeeklyScoreFriendsPassed:Vector.<UserInfo>;
      
      private var mWeeklyScoreListRequested:Boolean = false;
      
      private var mWeeklyScoreUserScoreOff:Number = -1;
      
      public function UserInfoMng()
      {
         this.mNoPlayerFriendsList = new Vector.<UserInfo>(0);
         this.mPlayerFriendsList = new Vector.<UserInfo>(0);
         this.mNeighborsList = new Vector.<UserInfo>(0);
         this.mNPCsList = new Vector.<UserInfo>(0);
         this.mUserOwnerList = new Vector.<UserInfo>(1,true);
         this.mOtherPlayersList = new Vector.<UserInfo>(0);
         this.mUserInfoList = new <Vector.<UserInfo>>[this.mNoPlayerFriendsList,this.mPlayerFriendsList,this.mNeighborsList,this.mNPCsList,this.mUserOwnerList,this.mOtherPlayersList];
         this.mUserListsCatalog = new Dictionary();
         super();
      }
      
      public static function getUserPic(accId:String) : Bitmap
      {
         var usrImage:Bitmap = null;
         var bitmapData:BitmapData = null;
         var uInfo:UserInfo = InstanceMng.getUserInfoMng().getUserInfoObj(accId,0);
         if(uInfo != null)
         {
            bitmapData = InstanceMng.getGraphicsCacheMng().getCachedImage(uInfo.mThumbnailURL);
            usrImage = new Bitmap();
            usrImage.name = uInfo.mThumbnailURL;
            usrImage.bitmapData = bitmapData;
         }
         return usrImage;
      }
      
      public static function getUserPicByURL(url:String) : Bitmap
      {
         var usrImage:Bitmap = null;
         var bitmapData:BitmapData = null;
         if(url == null)
         {
            url = "";
         }
         var graphicsCacheMng:GraphicsCacheMng = InstanceMng.getGraphicsCacheMng();
         if(url == "" || url == null)
         {
            bitmapData = graphicsCacheMng.getDefaultPicture();
         }
         else
         {
            bitmapData = graphicsCacheMng.getCachedImage(url);
         }
         usrImage = new Bitmap();
         usrImage.name = url;
         usrImage.bitmapData = bitmapData;
         return usrImage;
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildAsyncTotalSteps = 0;
         mBuildSyncTotalSteps = 1;
      }
      
      override protected function loadDoStep(step:int) : void
      {
         this.lastAttackersLoad();
         this.damageProtectionTimeUsersLoad();
         this.profilesLoad();
      }
      
      override protected function unloadDo() : void
      {
         this.lastAttackersUnload();
         this.damageProtectionTimeUsersUnload();
         this.profilesUnload();
         this.mCurrentProfileLoaded = 0;
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var profile:Profile = null;
         var isNpcListNull:* = false;
         var isNPCInfoLoaded:Boolean = false;
         var ruleMng:RuleMng = null;
         var filesLoaded:Boolean = false;
         var str:String = null;
         var count:int = 0;
         var v:Vector.<UserInfo> = null;
         var u:UserInfo = null;
         var arr2:Array = null;
         var arr3:Array = null;
         var arr:Array = null;
         var user:UserInfo = null;
         var userData:UserDataMng = InstanceMng.getUserDataMng();
         for each(profile in this.mProfilesList)
         {
            profile.logicUpdate(dt);
         }
         isNpcListNull = userData.getFileXML(UserDataMng.KEY_NPC_NEIGHBOR_LIST) == null;
         isNPCInfoLoaded = isNpcListNull == false && this.mNPCInstancesCreated;
         if(this.mNPCListInfo == null && isNPCInfoLoaded)
         {
            this.setNPCExtraInfo(userData.getFileXML(UserDataMng.KEY_NPC_NEIGHBOR_LIST));
         }
         if(Config.USE_LAZY_SERVER_RESPONSE == true)
         {
            if(userData.isFileLoaded(UserDataMng.KEY_FRIENDS_LIST))
            {
               if(this.mFriendsListLoaded == false)
               {
                  this.mFriendsListLoaded = true;
                  this.setNoPlayersFriendsListXML(userData.getFileXML(UserDataMng.KEY_FRIENDS_LIST));
               }
            }
            if(userData.isFileLoaded(UserDataMng.KEY_NEIGHBOR_LIST))
            {
               if(this.mNeighborsListLoaded == false)
               {
                  this.mNeighborsListLoaded = true;
                  this.setNeighborListXML(userData.getFileXML(UserDataMng.KEY_NEIGHBOR_LIST));
                  InstanceMng.getUIFacade().friendsBarReload();
                  InstanceMng.getUserDataMng().freeFile(UserDataMng.KEY_NEIGHBOR_LIST);
               }
            }
         }
         if(!this.mInfoLoaded)
         {
            ruleMng = InstanceMng.getRuleMng();
            if((filesLoaded = userData.isFileLoaded(UserDataMng.KEY_FRIENDS_LIST) && userData.isFileLoaded(UserDataMng.KEY_NEIGHBOR_LIST) || Config.USE_LAZY_SERVER_RESPONSE) && userData.isFileLoaded(UserDataMng.KEY_ATTACKER_LIST) && ruleMng.filesIsFileLoaded("npcDefinitions.xml") && this.getProfileLogin().isBuilt())
            {
               if(Config.USE_LAZY_SERVER_RESPONSE == false)
               {
                  this.setNoPlayersFriendsListXML(userData.getFileXML(UserDataMng.KEY_FRIENDS_LIST));
                  this.setNeighborListXML(userData.getFileXML(UserDataMng.KEY_NEIGHBOR_LIST));
                  InstanceMng.getUserDataMng().freeFile(UserDataMng.KEY_NEIGHBOR_LIST);
               }
               this.setNPCFriendDefsXML(ruleMng.filesGetFileAsXML("npcDefinitions.xml"));
               this.setLastAttackersXML(userData.getFileXML(UserDataMng.KEY_ATTACKER_LIST));
               this.createOwnerUserInfo();
               this.mInfoLoaded = true;
               if(Config.DEBUG_MODE)
               {
                  str = "";
                  count = 0;
                  DCDebug.traceCh("Friends","Files loaded ");
                  for each(v in this.mUserInfoList)
                  {
                     str = " list " + count;
                     str = "";
                     for each(u in v)
                     {
                        str += u.mAccountId + " = " + u.getPlayerName() + ", ";
                     }
                     count++;
                  }
               }
            }
         }
         else
         {
            arr2 = this.mDamageProtectionTimeUsers == null ? [] : DCUtils.vector2Array(this.mDamageProtectionTimeUsers);
            arr3 = this.mOnlineUsers == null ? [] : DCUtils.vector2Array(this.mOnlineUsers);
            arr = ArrayUtil.createUniqueCopy(arr2.concat(arr3));
            for each(user in arr)
            {
               user.logicUpdateDamageProtectionTime(dt);
               user.logicUpdateOnlineTime(dt);
            }
            this.lastAttackersLogicUpdate(dt);
            this.removeFinishedUsers(arr);
         }
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         if(step == 0 && InstanceMng.getUserDataMng().isLogged())
         {
            this.createOwnerUserInfo();
            this.fillUserListsCatalog();
            buildAdvanceSyncStep();
         }
      }
      
      public function unBuildNPCList() : void
      {
         this.mNPCListInfo = null;
      }
      
      public function unbuildProfileVisiting() : void
      {
         this.mProfilesList[1].unbuild();
         this.mCurrentProfileLoaded = 1;
      }
      
      public function setupUserInfoObj(userInfo:UserInfo, xml:XML, isOwner:Boolean = false) : UserInfo
      {
         if(userInfo == null)
         {
            userInfo = new UserInfo();
         }
         var attribute:String = "accountId";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            userInfo.setAccountId(EUtils.xmlReadString(xml,attribute));
         }
         attribute = "extId";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            userInfo.setExtId(EUtils.xmlReadString(xml,attribute));
         }
         attribute = "url";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            userInfo.setThumbnailURL(EUtils.xmlReadString(xml,attribute));
         }
         attribute = "isNeighbor";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            userInfo.setIsNeighbor(EUtils.xmlReadBoolean(xml,attribute));
         }
         attribute = "name";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            userInfo.setPlayerName(EUtils.xmlReadString(xml,attribute));
         }
         attribute = "wishlist";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            userInfo.setWishlist(EUtils.xmlReadString(xml,attribute));
         }
         attribute = "platform";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            userInfo.setPlatform(EUtils.xmlReadString(xml,attribute));
         }
         attribute = "score";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            userInfo.setScore(EUtils.xmlReadNumber(xml,attribute));
         }
         attribute = "HQLevel";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            userInfo.setHQLevel(EUtils.xmlReadString(xml,attribute));
         }
         userInfo.setIsOwnerProfile(isOwner);
         userInfo.mIsNPC.value = false;
         userInfo.setDamageProtectionLeft(EUtils.xmlReadNumber(xml,"damageProtectionTimeLeft"));
         userInfo.setIsOnline(EUtils.xmlReadBoolean(xml,"isOnline"));
         userInfo.setIsOnlineCooldownTimeLeft(userInfo.mIsOnline.value ? GameConstants.USERDATA_ISONLINE_COOLDOWN_TIME : 0);
         userInfo.setIsTutorialCompleted(EUtils.xmlReadBoolean(xml,"tutorialCompleted"));
         return userInfo;
      }
      
      private function setupNPCUserInfoObj(userInfo:UserInfo, xml:XML) : UserInfo
      {
         var sku:String = null;
         var tidName:String = null;
         var phraseTid:String = null;
         userInfo = this.setupUserInfoObj(userInfo,xml);
         userInfo.mIsNPC.value = true;
         userInfo.setIsTutorialCompleted(true);
         var attribute:String = "sku";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            sku = EUtils.xmlReadString(xml,attribute);
            userInfo.setAccountId(sku);
            userInfo.setExtId(sku);
         }
         attribute = "tidName";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            tidName = EUtils.xmlReadString(xml,attribute);
            userInfo.setPlayerName(DCTextMng.getText(TextIDs[tidName]));
            phraseTid = tidName.replace("_NAME","_PHRASE");
            userInfo.mNpcPhrase = DCTextMng.getText(TextIDs[phraseTid]);
         }
         attribute = "background";
         if(sku != null && sku == "npc_A")
         {
            userInfo.mBackgroundType = "-1";
         }
         else if(sku != null && sku == "npc_D")
         {
            userInfo.mBackgroundType = "ice";
         }
         else if(EUtils.xmlIsAttribute(xml,attribute))
         {
            userInfo.mBackgroundType = EUtils.xmlReadString(xml,attribute);
         }
         attribute = "unlockedMissionSku";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            userInfo.mMissionSku = EUtils.xmlReadString(xml,attribute);
         }
         attribute = "unlockHQlevel";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            userInfo.mHQLevelRequired = EUtils.xmlReadString(xml,attribute);
         }
         attribute = "tidDesc";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            userInfo.mDescription = DCTextMng.getText(TextIDs[EUtils.xmlReadString(xml,attribute)]);
         }
         attribute = "checkHQLevelForSpying";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            userInfo.setHasToCheckHQLevelForSpying(EUtils.xmlReadBoolean(xml,attribute));
         }
         attribute = "attackCostPercentage";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            userInfo.setAttackCostPercentage(EUtils.xmlReadInt(xml,attribute));
         }
         return userInfo;
      }
      
      private function createOwnerUserInfo() : void
      {
         if(this.mUserOwnerList[0] == null)
         {
            this.mUserOwnerList[0] = new UserInfo();
         }
         var usrDataMng:UserDataMng = InstanceMng.getUserDataMng();
         var userInfoObj:UserInfo = this.mUserOwnerList[0];
         var ownerXML:XML = EUtils.stringToXML("<owner accountId=\"" + usrDataMng.mUserAccountId + "\" extId=\"" + usrDataMng.mUserExtId + "\" url=\"" + usrDataMng.mUserPhotoUrl + "\" name=\"" + usrDataMng.mUserName + "\" isNeighbor=\"1\"/>");
         userInfoObj = this.setupUserInfoObj(userInfoObj,ownerXML,true);
         var profile:Profile = userInfoObj.getParentProfile();
         if(profile != null)
         {
            profile.setIsOwner(true);
         }
         if(Config.DEBUG_MODE)
         {
         }
      }
      
      public function setNoPlayersFriendsListXML(xmlDoc:XML) : void
      {
         var item:XML = null;
         for each(item in EUtils.xmlGetChildrenList(xmlDoc,"friend"))
         {
            if(EUtils.xmlReadBoolean(item,"appInstalled"))
            {
               this.addFriendPlayerFromXml(item);
            }
            else
            {
               this.addNoPlayerFriend(item);
            }
         }
      }
      
      public function addFriendPlayerFromXml(item:XML) : void
      {
         var usrInfoObj:UserInfo = new UserInfo();
         usrInfoObj = this.setupUserInfoObj(usrInfoObj,item);
         if(this.getUserInfoObj(usrInfoObj.mExtId,1,2) == null)
         {
            this.mUserInfoList[1].push(usrInfoObj);
         }
      }
      
      public function addNoPlayerFriend(item:XML) : void
      {
         var usrInfoObj:UserInfo = new UserInfo();
         usrInfoObj = this.setupUserInfoObj(usrInfoObj,item);
         if(this.getUserInfoObj(usrInfoObj.mAccountId,0,2) == null)
         {
            this.mUserInfoList[0].push(usrInfoObj);
         }
      }
      
      public function setNeighborListXML(xmlDoc:XML) : void
      {
         var item:XML = null;
         for each(item in EUtils.xmlGetChildrenList(xmlDoc,"neighbor"))
         {
            this.addNeighbor(item);
         }
      }
      
      public function addNeighbor(item:XML) : void
      {
         var usrInfoObj:UserInfo = null;
         var neighbor:Boolean = false;
         usrInfoObj = this.getUserInfoObj(EUtils.xmlReadString(item,"extId"),1,0);
         usrInfoObj = this.setupUserInfoObj(usrInfoObj,item);
         neighbor = EUtils.xmlReadBoolean(item,"isNeighbor");
         if(item.hasOwnProperty("Planets"))
         {
            usrInfoObj.setPlanetsInfo(EUtils.xmlGetChildrenListAsXML(item,"Planets"));
         }
         this.removeNoPlayerFriend(EUtils.xmlReadString(item,"extId"));
         var listId:int = neighbor ? 2 : 1;
         var list:Vector.<UserInfo> = this.mUserInfoList[listId];
         var existingUserInfoObj:UserInfo;
         if((existingUserInfoObj = this.getUserInfoObj(usrInfoObj.getAccountId(),0,listId)) == null)
         {
            list.push(usrInfoObj);
         }
         if(usrInfoObj.mDamageProtectionTimeLeft.value > 0)
         {
            this.damageProtectionTimeUsersAdd(usrInfoObj);
         }
         if(usrInfoObj.mIsOnline.value)
         {
            this.onlineUsersAdd(usrInfoObj);
         }
      }
      
      public function addOtherPlayerInfo(xmlDoc:XML) : UserInfo
      {
         var accId:String = EUtils.xmlReadString(xmlDoc,"accountId");
         var usrInfoObj:UserInfo = this.getUserInfoObj(accId,0,-1);
         var isOwner:Boolean = false;
         if(usrInfoObj != null)
         {
            isOwner = usrInfoObj.getIsOwnerProfile();
         }
         usrInfoObj = this.setupUserInfoObj(usrInfoObj,xmlDoc,isOwner);
         if(this.mOtherPlayersList.indexOf(usrInfoObj) == -1)
         {
            this.mOtherPlayersList.push(usrInfoObj);
         }
         if(usrInfoObj.mIsOnline.value)
         {
            this.onlineUsersAdd(usrInfoObj);
         }
         if(usrInfoObj.mDamageProtectionTimeLeft.value > 0)
         {
            this.damageProtectionTimeUsersAdd(usrInfoObj);
         }
         return usrInfoObj;
      }
      
      public function setPlanetInfoToPlayer(xmlDoc:XML) : void
      {
         var role:int = 0;
         var planetsInfo:XML = null;
         var add:* = false;
         var sku1:String = null;
         var sku2:String = null;
         var planetXML:XML = null;
         var accId:String = EUtils.xmlReadString(xmlDoc,"accountId");
         var usrInfoObj:UserInfo;
         if((usrInfoObj = this.getUserInfoObj(accId,0,-1)) != null)
         {
            if((planetsInfo = usrInfoObj.mPlanetsInfo) == null)
            {
               planetsInfo = <Planets/>;
            }
            role = InstanceMng.getRole().mId;
            add = planetsInfo.Planets.length > 0;
            sku1 = EUtils.xmlReadString(xmlDoc,"sku");
            for each(planetXML in planetsInfo.Planets)
            {
               sku2 = EUtils.xmlReadString(planetXML,"sku");
               if(sku2 == sku1)
               {
                  add = false;
                  break;
               }
            }
            if(add)
            {
               planetsInfo.appendChild(xmlDoc);
               usrInfoObj.setPlanetsInfo(planetsInfo);
            }
         }
      }
      
      public function setNPCFriendDefsXML(xmlDoc:XML) : void
      {
         var usrInfoObj:UserInfo = null;
         var item:XML = null;
         for each(item in EUtils.xmlGetChildrenList(xmlDoc,"Definition"))
         {
            usrInfoObj = new UserInfo();
            usrInfoObj = this.setupNPCUserInfoObj(usrInfoObj,item);
            this.mUserInfoList[3].push(usrInfoObj);
         }
         this.mNPCInstancesCreated = true;
      }
      
      private function setNPCExtraInfo(xmlDoc:XML) : void
      {
         var uInfo:UserInfo = null;
         var item:XML = null;
         if(xmlDoc != null)
         {
            for each(item in EUtils.xmlGetChildrenList(xmlDoc,"npc"))
            {
               uInfo = this.getUserInfoObj(EUtils.xmlReadString(item,"sku"),0,3);
               if(uInfo != null)
               {
                  uInfo.setHQLevel(EUtils.xmlReadString(item,"HQLevel"));
                  uInfo.setScore(EUtils.xmlReadNumber(item,"score"));
               }
            }
            InstanceMng.getUserDataMng().freeFile(UserDataMng.KEY_NPC_NEIGHBOR_LIST);
            this.mNPCListInfo = new XML(xmlDoc);
         }
      }
      
      private function removeFinishedUsers(arr:Array) : void
      {
         var user:UserInfo = null;
         var pos:int = 0;
         for each(user in arr)
         {
            if(user.mDamageProtectionTimeLeft.value == 0)
            {
               this.damageProtectionTimeUsersRemove(user);
            }
            if(user.mIsOnlineCooldownTimeLeft.value == 0)
            {
               this.onlineUsersRemove(user);
            }
         }
      }
      
      public function removeNeighbor(accId:String) : UserInfo
      {
         var neighborInfoObj:UserInfo = null;
         var found:Boolean = false;
         neighborInfoObj = this.getUserInfoObj(accId,0,2);
         if(neighborInfoObj != null)
         {
            found = true;
            this.addFriendPlayer(neighborInfoObj);
            this.mNeighborsList.splice(this.mNeighborsList.indexOf(neighborInfoObj),1);
            return neighborInfoObj;
         }
         InstanceMng.getUIFacade().friendsBarRemoveSelectedNeighbor();
         return null;
      }
      
      public function removeNoPlayerFriend(extId:String) : UserInfo
      {
         var userInfoObj:UserInfo = null;
         userInfoObj = this.getUserInfoObj(extId,1,0);
         if(userInfoObj != null)
         {
            this.mNoPlayerFriendsList.splice(this.mNoPlayerFriendsList.indexOf(userInfoObj),1);
            return userInfoObj;
         }
         return null;
      }
      
      public function playerFriendsListContains(accountId:String) : Boolean
      {
         var user:UserInfo = null;
         for each(user in this.mPlayerFriendsList)
         {
            if(user.mAccountId == accountId)
            {
               return true;
            }
         }
         return false;
      }
      
      private function filterByIsUserInfoAttackable(userInfo:UserInfo, index:int, v:Vector.<UserInfo>) : Boolean
      {
         return this.isUserInfoAttackable(userInfo);
      }
      
      private function filterByIsExperienceAndIsAttackable(userInfo:UserInfo, index:int, v:Vector.<UserInfo>) : Boolean
      {
         var b1:Boolean = this.isUserInfoAttackable(userInfo);
         var b2:Boolean = this.checkCompatibilityLevel(userInfo,2);
         return b1 && b2;
      }
      
      private function filterByIsNeighbor(userInfo:UserInfo, index:int, v:Vector.<UserInfo>) : Boolean
      {
         return userInfo.mIsNeighbor.value;
      }
      
      private function getFunctionFromSortType(sortType:int) : Function
      {
         switch(sortType)
         {
            case 0:
               return this.sortByExpDescendent;
            case 1:
               return this.sortByExpAscendent;
            case 2:
               return this.sortByExtIdDescendent;
            case 3:
               return this.sortByNumFightsDescendent;
            case 4:
               return this.sortByScoreDesc;
            case 5:
               return this.sortByPercentageMixedScoreXpDesc;
            default:
               return null;
         }
      }
      
      public function getPlayerList(sortType:int, includeNonAttackable:Boolean, listArr:Array) : Vector.<UserInfo>
      {
         var playerList:* = null;
         var current:Vector.<UserInfo> = null;
         var listId:int = 0;
         var fn:Function = null;
         if(listArr == null)
         {
            return null;
         }
         if(listArr.indexOf(-1) > -1)
         {
            listArr = [0,1,2,3,5];
         }
         for each(listId in listArr)
         {
            current = this.mUserInfoList[listId];
            if(includeNonAttackable == false)
            {
               current = current.filter(this.filterByIsUserInfoAttackable);
            }
            if(playerList == null)
            {
               playerList = current;
            }
            else
            {
               playerList = playerList.concat(current);
            }
         }
         if(playerList != null)
         {
            fn = this.getFunctionFromSortType(sortType);
            playerList.sort(fn);
         }
         return playerList;
      }
      
      public function getLastAttackersList(sortType:int, includeNonAttackable:Boolean = true) : Vector.<UserInfo>
      {
         if(this.mLastAttackers == null)
         {
            return null;
         }
         var v:Vector.<UserInfo> = this.mLastAttackers;
         if(includeNonAttackable == false)
         {
            v = v.filter(this.filterByIsUserInfoAttackable);
         }
         var fn:Function = this.getFunctionFromSortType(sortType);
         v.sort(fn);
         return v;
      }
      
      public function getNoPlayerFriendsList() : Vector.<UserInfo>
      {
         return this.mNoPlayerFriendsList;
      }
      
      public function getPlayersFriendsList() : Vector.<UserInfo>
      {
         return this.mPlayerFriendsList;
      }
      
      public function getRankingNeighborsList(sortType:int) : Vector.<UserInfo>
      {
         var list:Vector.<UserInfo> = this.getPlayerList(sortType,true,[2,3,4]);
         return list.filter(this.filterByIsNeighbor);
      }
      
      public function getPassedFriendsByLevel(oldLevel:int) : Vector.<UserInfo>
      {
         var i:int = 0;
         var friendsPassed:Vector.<UserInfo> = null;
         var friends:Vector.<UserInfo> = this.getRankingNeighborsList(5);
         var myPos:* = -1;
         var friendsCount:int = int(friends.length);
         for(i = 0; i < friendsCount; )
         {
            if(friends[i].getIsOwnerProfile())
            {
               myPos = i;
               break;
            }
            i++;
         }
         if(myPos > -1)
         {
            friendsPassed = new Vector.<UserInfo>(0);
            for(i = myPos + 1; i < friendsCount; )
            {
               if(oldLevel > friends[i].getLevel())
               {
                  break;
               }
               friendsPassed.push(friends[i]);
               i++;
            }
            return friendsPassed;
         }
         return null;
      }
      
      public function getPassedFriendsByScore(initialScore:int) : Vector.<UserInfo>
      {
         var i:int = 0;
         var friendsPassed:Vector.<UserInfo> = null;
         var friends:Vector.<UserInfo> = this.getRankingNeighborsList(5);
         var myPos:* = -1;
         var friendsCount:int = int(friends.length);
         for(i = 0; i < friendsCount; )
         {
            if(friends[i].getIsOwnerProfile())
            {
               myPos = i;
               break;
            }
            i++;
         }
         if(myPos > -1)
         {
            friendsPassed = new Vector.<UserInfo>(0);
            for(i = myPos + 1; i < friendsCount; )
            {
               if(initialScore >= friends[i].getScore())
               {
                  break;
               }
               friendsPassed.push(friends[i]);
               i++;
            }
            return friendsPassed;
         }
         return null;
      }
      
      public function getRandomFriendsToInvite() : Vector.<UserInfo>
      {
         var noPlayersCount:int = 0;
         var playersCount:int = 0;
         var finalFriends:Vector.<UserInfo> = null;
         var noPlayers:Vector.<UserInfo> = null;
         var players:Vector.<UserInfo> = null;
         var finalFriendsCount:int = 0;
         var noPlayersIndex:int = 0;
         var playersIndex:int = 0;
         var f:int = 0;
         if(this.isBuilt())
         {
            noPlayersCount = 0;
            if(this.mNoPlayerFriendsList != null)
            {
               noPlayersCount = int(this.mNoPlayerFriendsList.length);
            }
            playersCount = 0;
            if(this.mPlayerFriendsList != null)
            {
               playersCount = int(this.mPlayerFriendsList.length);
            }
            if(noPlayersCount > 0 || playersCount > 0)
            {
               if(noPlayersCount > 0)
               {
                  noPlayers = this.getFriendsFromList(this.mNoPlayerFriendsList,InstanceMng.getSettingsDefMng().getNoFriendsBarRandomPlayers());
               }
               if(playersCount > 0)
               {
                  players = this.getFriendsFromList(this.mPlayerFriendsList,InstanceMng.getSettingsDefMng().getFriendsBarRandomPlayers());
               }
               noPlayersCount = 0;
               if(noPlayers != null)
               {
                  noPlayersCount = int(noPlayers.length);
               }
               playersCount = 0;
               if(players != null)
               {
                  playersCount = int(players.length);
               }
               finalFriendsCount = noPlayersCount + playersCount;
               finalFriends = new Vector.<UserInfo>(finalFriendsCount);
               noPlayersIndex = 0;
               playersIndex = 0;
               for(f = 0; f < finalFriendsCount; )
               {
                  if((f + 1) % 3 == 0 && playersIndex < playersCount)
                  {
                     finalFriends[f] = players[playersIndex];
                     playersIndex++;
                  }
                  else if(noPlayersIndex < noPlayersCount)
                  {
                     finalFriends[f] = noPlayers[noPlayersIndex];
                     noPlayersIndex++;
                  }
                  else
                  {
                     finalFriends[f] = players[playersIndex];
                     playersIndex++;
                  }
                  f++;
               }
            }
         }
         return finalFriends;
      }
      
      public function getFriendsFromList(friendsListOrigin:Vector.<UserInfo>, maxCount:int) : Vector.<UserInfo>
      {
         var i:int = 0;
         var friends:* = null;
         var friend:UserInfo = null;
         var end:int = 0;
         var index:int = 0;
         var count:int = int(friendsListOrigin.length);
         var friendsListOriginFiltered:Vector.<UserInfo> = new Vector.<UserInfo>(0);
         for(i = 0; i < count; )
         {
            friend = friendsListOrigin[i];
            if(this.getUserInfoObj(friend.getExtId(),1,2) == null)
            {
               friendsListOriginFiltered.push(friend);
            }
            i++;
         }
         if((count = int(friendsListOriginFiltered.length)) > 0)
         {
            if(count > maxCount)
            {
               friends = new Vector.<UserInfo>(maxCount,true);
               end = 0;
               while(end < maxCount)
               {
                  index = Math.random() * count;
                  friend = friendsListOriginFiltered[index];
                  if(this.getUserInfoObj(friend.getExtId(),1,2) == null && friends.indexOf(friend) == -1)
                  {
                     friends[end] = friend;
                     end++;
                  }
               }
            }
            else
            {
               friends = friendsListOriginFiltered;
            }
         }
         return friends;
      }
      
      public function getNPCList(sortType:int) : Vector.<UserInfo>
      {
         var fn:Function = this.getFunctionFromSortType(sortType);
         this.mNPCsList.sort(fn);
         return this.mNPCsList;
      }
      
      private function sortByExtIdDescendent(a:UserInfo, b:UserInfo) : Number
      {
         var aValue:String = a.mExtId;
         var bValue:String = b.mExtId;
         return aValue.localeCompare(bValue);
      }
      
      private function sortByNumFightsDescendent(a:UserInfo, b:UserInfo) : Number
      {
         var aValue:Number = a.mAttackInfoAmountAttacks.value;
         var bValue:Number = b.mAttackInfoAmountAttacks.value;
         if(aValue > bValue)
         {
            return -1;
         }
         if(aValue < bValue)
         {
            return 1;
         }
         return 0;
      }
      
      private function sortByExpAscendent(a:UserInfo, b:UserInfo) : Number
      {
         var aValue:Number = a.getXp();
         var bValue:Number = b.getXp();
         if(aValue > bValue)
         {
            return 1;
         }
         if(aValue < bValue)
         {
            return -1;
         }
         return 0;
      }
      
      private function sortByExpDescendent(a:UserInfo, b:UserInfo) : Number
      {
         var aValue:Number = a.getXp();
         var bValue:Number = b.getXp();
         if(aValue > bValue)
         {
            return -1;
         }
         if(aValue < bValue)
         {
            return 1;
         }
         return 0;
      }
      
      private function sortByScoreDesc(a:UserInfo, b:UserInfo) : Number
      {
         var aVal:Number = a.getScore();
         var bVal:Number = b.getScore();
         if(aVal > bVal)
         {
            return -1;
         }
         if(aVal < bVal)
         {
            return 1;
         }
         return 0;
      }
      
      private function sortByPercentageMixedScoreXpDesc(a:UserInfo, b:UserInfo) : Number
      {
         var aVal:Number = this.getLevelAsPercentageNumber(a);
         var bVal:Number = this.getLevelAsPercentageNumber(b);
         if(aVal > bVal)
         {
            return -1;
         }
         if(aVal < bVal)
         {
            return 1;
         }
         return 0;
      }
      
      private function getLevelAsPercentageNumber(user:UserInfo) : Number
      {
         var level:Number = NaN;
         var percentage:Number = NaN;
         var levelDef:DCDef = null;
         level = parseFloat(InstanceMng.getLevelScoreDefMng().getLevelFromValue(user.getScore()));
         levelDef = InstanceMng.getLevelScoreDefMng().getDefBySku(level.toString());
         percentage = (levelDef as LevelScoreDef).mMinXp.value;
         percentage = (percentage = DCMath.ruleOf3(user.getScore() - percentage,(levelDef as LevelScoreDef).mMaxXp.value - percentage,100)) * 0.01;
         return level + percentage;
      }
      
      public function getUserInfoObj(id:String, searchBy:int, searchOn:int = -1) : UserInfo
      {
         var user:UserInfo = null;
         var count:int = 0;
         var i:int = 0;
         if(searchOn == -1)
         {
            count = int(this.mUserInfoList.length);
            for(i = 0; i < count; )
            {
               if((user = this.getUserInfoObj(id,searchBy,i)) != null)
               {
                  return user;
               }
               i++;
            }
            return null;
         }
         var mCurrentSearchVector:Vector.<UserInfo>;
         if((mCurrentSearchVector = this.mUserInfoList[searchOn]) != null && mCurrentSearchVector.length != 0)
         {
            for each(user in mCurrentSearchVector)
            {
               if(user != null && (searchBy == 1 && user.mExtId == id || searchBy == 0 && user.mAccountId == id))
               {
                  return user;
               }
            }
         }
         return null;
      }
      
      public function getAccIdListByExtId(extIds:String) : String
      {
         var accId:String = null;
         var i:int = 0;
         var returnValue:* = "";
         var requestsArr:Array = extIds.split(",");
         for(i = 0; i < requestsArr.length; )
         {
            if((accId = this.getAccIdByExtId(requestsArr[i])) != null)
            {
               returnValue += accId;
               if(i < requestsArr.length - 1)
               {
                  returnValue += ",";
               }
            }
            i++;
         }
         return returnValue;
      }
      
      private function getAccIdByExtId(extId:String) : String
      {
         var returnValue:String = null;
         var uInfo:UserInfo = this.getUserInfoObj(extId,1);
         if(uInfo != null)
         {
            returnValue = uInfo.getAccountId();
         }
         return returnValue;
      }
      
      public function getExtIdByAccId(accountId:String) : String
      {
         var returnValue:String = null;
         var uInfo:UserInfo = this.getUserInfoObj(accountId,0);
         if(uInfo != null)
         {
            returnValue = uInfo.getExtId();
         }
         else
         {
            uInfo = this.getUserInfoObj(accountId,1);
            if(uInfo != null)
            {
               returnValue = uInfo.getExtId();
            }
         }
         return returnValue;
      }
      
      public function getFriendShipByAccId(accId:String) : int
      {
         var i:int = 0;
         var uInfo:UserInfo = null;
         var returnValue:* = -1;
         var count:int = int(this.mUserInfoList.length);
         for(i = 0; i < count; )
         {
            uInfo = null;
            uInfo = this.getUserInfoObj(accId,0,i);
            if(uInfo != null)
            {
               returnValue = i;
            }
            i++;
         }
         return returnValue;
      }
      
      public function isThisSkuFromNPC(id:String) : Boolean
      {
         var returnValue:Boolean = false;
         var uInfo:UserInfo = this.getUserInfoObj(id,1,3);
         if(uInfo != null)
         {
            returnValue = uInfo.mIsNPC.value;
         }
         return returnValue;
      }
      
      public function getPlatformUsersObject(extIds:Vector.<String> = null, useAsWhiteList:Boolean = false) : Object
      {
         var extId:String = null;
         var uInfo:UserInfo = null;
         var currentPlatform:* = null;
         var arraySearch:Array = null;
         var count:int = 0;
         var n:int = 0;
         var v:Vector.<UserInfo> = null;
         var o:Object = {};
         var myPlatform:String = String(Star.getFlashVars().platform);
         if(useAsWhiteList)
         {
            for each(extId in extIds)
            {
               uInfo = this.getUserInfoObj(extId,1,-1);
               if(uInfo != null)
               {
                  if((currentPlatform = uInfo.getPlatform()) == null)
                  {
                     currentPlatform = myPlatform;
                  }
                  if(o[currentPlatform] == null)
                  {
                     o[currentPlatform] = [];
                  }
                  if((o[currentPlatform] as Array).indexOf(uInfo.mExtId) == -1)
                  {
                     o[currentPlatform].push(uInfo.mExtId);
                  }
               }
            }
         }
         else
         {
            arraySearch = [1,0,2];
            count = 0;
            for each(n in arraySearch)
            {
               v = this.mUserInfoList[n];
               for each(uInfo in v)
               {
                  if(extIds == null || extIds.indexOf(uInfo.mExtId) == -1)
                  {
                     if((currentPlatform = uInfo.getPlatform()) == null)
                     {
                        currentPlatform = myPlatform;
                     }
                     if(o[currentPlatform] == null)
                     {
                        o[currentPlatform] = [];
                     }
                     if((o[currentPlatform] as Array).indexOf(uInfo.mExtId) == -1)
                     {
                        o[currentPlatform].push(uInfo.mExtId);
                        count++;
                        if(count == 5000)
                        {
                           return o;
                        }
                     }
                  }
               }
            }
            if(o != null && o[myPlatform] != null)
            {
               DCDebug.traceChObject("alInvites",o[myPlatform],"sent:");
            }
         }
         return o;
      }
      
      public function profilesLoad() : void
      {
         var i:int = 0;
         this.mProfilesList = new Vector.<Profile>(2);
         for(i = 0; i < 2; )
         {
            this.mProfilesList[i] = new Profile();
            this.mProfilesList[i].load();
            i++;
         }
         this.mProfilesList[0].setId(0);
         this.mProfilesList[1].setId(1);
      }
      
      public function profilesUnload() : void
      {
         var i:int = 0;
         for(i = 0; i < 2; )
         {
            this.mProfilesList[i].unload();
            i++;
         }
         this.mProfilesList = null;
      }
      
      public function setProfileXML(xml:XML, userId:String = "0") : void
      {
         var owner:UserInfo = null;
         var isOwnerProfileBuilt:Boolean = this.mProfilesList[0].isBuilt();
         var ownerProfileId:int = this.mProfilesList[0].getId();
         var userInfoObj:UserInfo;
         if((userInfoObj = this.getUserInfoObj(userId,0)) == null)
         {
            DCDebug.trace("[UserInfoMng.setProfileXML] The userInfoObj was not found for the userId: " + userId,1);
         }
         if(userInfoObj.mIsNPC.value == false && xml.hasOwnProperty("Planets"))
         {
            userInfoObj.setPlanetsInfo(EUtils.xmlGetChildrenListAsXML(xml,"Planets"));
         }
         if(isOwnerProfileBuilt == true)
         {
            owner = this.getUserInfoObj(userId,0,4);
            if(owner != null)
            {
               this.mCurrentProfileLoaded = ownerProfileId;
               if(xml.hasOwnProperty("Planets"))
               {
                  owner.setPlanetsInfo(EUtils.xmlGetChildrenListAsXML(xml,"Planets"));
               }
            }
            else
            {
               this.mProfilesList[1].unbuild();
               this.mProfilesList[1].persistenceSetData(xml);
               this.mProfilesList[1].setUserInfoObj(userInfoObj);
               this.mProfilesList[1].build();
               this.mCurrentProfileLoaded = 1;
            }
         }
         else
         {
            this.mProfilesList[0].persistenceSetData(xml);
            this.mProfilesList[0].setUserInfoObj(userInfoObj);
            this.mProfilesList[0].build();
            this.mCurrentProfileLoaded = ownerProfileId;
         }
         this.printProfile(this.mCurrentProfileLoaded);
      }
      
      private function damageProtectionTimeUsersLoad() : void
      {
         this.mDamageProtectionTimeUsers = new Vector.<UserInfo>(0);
      }
      
      private function damageProtectionTimeUsersUnload() : void
      {
         this.mDamageProtectionTimeUsers = null;
      }
      
      private function damageProtectionTimeUsersAdd(u:UserInfo) : void
      {
         if(this.mDamageProtectionTimeUsers == null)
         {
            this.damageProtectionTimeUsersLoad();
         }
         if(this.mDamageProtectionTimeUsers.indexOf(u) == -1)
         {
            this.mDamageProtectionTimeUsers.push(u);
         }
      }
      
      private function damageProtectionTimeUsersRemove(u:UserInfo) : void
      {
         if(this.mDamageProtectionTimeUsers == null)
         {
            return;
         }
         var pos:int = this.mDamageProtectionTimeUsers.indexOf(u);
         if(pos == -1)
         {
            return;
         }
         this.mDamageProtectionTimeUsers.splice(pos,1);
         if(this.mDamageProtectionTimeUsers.length == 0)
         {
            this.mDamageProtectionTimeUsers = null;
         }
      }
      
      private function onlineUsersLoad() : void
      {
         this.mOnlineUsers = new Vector.<UserInfo>(0);
      }
      
      private function onlineUsersUnload() : void
      {
         this.mOnlineUsers = null;
      }
      
      private function onlineUsersAdd(u:UserInfo) : void
      {
         if(this.mOnlineUsers == null)
         {
            this.onlineUsersLoad();
         }
         if(this.mOnlineUsers.indexOf(u) == -1)
         {
            this.mOnlineUsers.push(u);
         }
      }
      
      private function onlineUsersRemove(u:UserInfo) : void
      {
         if(this.mOnlineUsers == null)
         {
            return;
         }
         var pos:int = this.mOnlineUsers.indexOf(u);
         if(pos == -1)
         {
            return;
         }
         this.mOnlineUsers.splice(pos,1);
         if(this.mOnlineUsers.length == 0)
         {
            this.mOnlineUsers = null;
         }
      }
      
      private function lastAttackersLoad() : void
      {
         this.mLastAttackers = new Vector.<UserInfo>(0);
      }
      
      private function lastAttackersUnload() : void
      {
         this.mLastAttackers = null;
      }
      
      private function lastAttackersLogicUpdate(dt:int) : void
      {
         var userInfo:UserInfo = null;
         var attacksArr:Array = null;
         var attackStatistics:AttackStatistics = null;
         var amountRevengesLeft:int = 0;
         var pos:int = 0;
         if(this.mLastAttackers == null)
         {
            return;
         }
         var usersToRemove:Vector.<UserInfo> = new Vector.<UserInfo>(0);
         for each(userInfo in this.mLastAttackers)
         {
            amountRevengesLeft = 0;
            attacksArr = this.mAttackersCatalog[userInfo.mAccountId];
            for each(attackStatistics in attacksArr)
            {
               attackStatistics.mRevengeTimeLeft.value = Math.max(0,attackStatistics.mRevengeTimeLeft.value - dt);
               if(attackStatistics.mRevengeTimeLeft.value > 0)
               {
                  amountRevengesLeft++;
               }
            }
            if(amountRevengesLeft == 0)
            {
               usersToRemove.push(userInfo);
            }
         }
         for each(userInfo in usersToRemove)
         {
            if((pos = this.mLastAttackers.indexOf(userInfo)) > -1)
            {
               this.mLastAttackers.splice(pos,1);
            }
         }
         if(this.mLastAttackers.length == 0)
         {
            this.mLastAttackers = null;
         }
      }
      
      public function lastAttackersPerformRevenge(userInfo:UserInfo, revengeId:String) : void
      {
         var attacksArr:Array = null;
         var attackStatistics:AttackStatistics = null;
         if(this.mLastAttackers == null || userInfo == null)
         {
            return;
         }
         var pos:int;
         if((pos = this.mLastAttackers.indexOf(userInfo)) > -1)
         {
            attacksArr = this.mAttackersCatalog[userInfo.mAccountId];
            for each(attackStatistics in attacksArr)
            {
               if(attackStatistics.mAttackEntry.value == revengeId)
               {
                  attackStatistics.performRevenge();
               }
            }
         }
      }
      
      public function getLastAttack() : AttackStatistics
      {
         return this.mLastAttack;
      }
      
      public function setLastAttackersXML(xmlDoc:XML) : void
      {
         var accountId:String = null;
         var xml:XML = null;
         var userInfo:UserInfo = null;
         var attackTime:Number = NaN;
         var revengeTimeLeft:Number = NaN;
         var coinsTaken:Number = NaN;
         var mineralsTaken:Number = NaN;
         var revengesPerformed:int = 0;
         var attackEntry:String = null;
         var lastAttacksByAccountId:Array = null;
         var nowTime:Number = new Date().getTime();
         var revengeTime:Number = InstanceMng.getSettingsDefMng().getRevengeTime();
         var lastAttackAccountId:* = null;
         for each(xml in EUtils.xmlGetChildrenList(xmlDoc,"attacker"))
         {
            accountId = EUtils.xmlReadString(xml,"accountId");
            userInfo = this.getUserInfoObj(accountId,0);
            if(userInfo == null)
            {
               userInfo = new UserInfo();
               userInfo.setAccountId(accountId);
            }
            userInfo.setIsTutorialCompleted(true);
            attackTime = EUtils.xmlReadNumber(xml,"attackDate");
            revengeTimeLeft = Math.max(revengeTime - (nowTime - attackTime),0);
            revengesPerformed = EUtils.xmlReadInt(xml,"revenges");
            attackEntry = EUtils.xmlReadString(xml,"id");
            coinsTaken = EUtils.xmlReadNumber(xml,"coinsTaken");
            mineralsTaken = EUtils.xmlReadNumber(xml,"mineralsTaken");
            userInfo.attackAddAttack(attackTime);
            this.refreshAttacksInfo(attackEntry,accountId,attackTime,coinsTaken,mineralsTaken,revengesPerformed,revengeTimeLeft);
            lastAttackAccountId = accountId;
            if(revengeTimeLeft > 0 && this.mLastAttackers.indexOf(userInfo) == -1)
            {
               this.mLastAttackers.push(userInfo);
            }
         }
         this.mLastAttack = null;
         if(this.mAttackersCatalog != null)
         {
            if((lastAttacksByAccountId = this.mAttackersCatalog[lastAttackAccountId]) != null)
            {
               this.mLastAttack = lastAttacksByAccountId[lastAttacksByAccountId.length - 1];
            }
         }
      }
      
      public function getRevengeAvailable(userInfo:UserInfo) : String
      {
         var attacks:Array = null;
         var attackObj:AttackStatistics = null;
         if(this.mLastAttackers != null && this.mLastAttackers.indexOf(userInfo) > -1)
         {
            attacks = this.mAttackersCatalog[userInfo.mAccountId];
            for each(attackObj in attacks)
            {
               if(attackObj.mRevengeTimeLeft.value > 0)
               {
                  return attackObj.mAttackEntry.value;
               }
            }
         }
         return null;
      }
      
      private function refreshAttacksInfo(attackEntry:String, accountId:String, attackTime:Number, coinsTaken:Number, mineralsTaken:Number, revengesPerformed:int, revengeTimeLeft:Number) : void
      {
         if(this.mAttackersCatalog == null)
         {
            this.mAttackersCatalog = new Dictionary();
         }
         var attackObj:AttackStatistics;
         (attackObj = new AttackStatistics()).setCoinsTaken(coinsTaken);
         attackObj.setMineralsTaken(mineralsTaken);
         attackObj.mAttackEntry.value = attackEntry;
         attackObj.mRevengeTimeLeft.value = revengesPerformed == 0 ? revengeTimeLeft : 0;
         var attackTimeArr:Array;
         if((attackTimeArr = this.mAttackersCatalog[accountId]) == null)
         {
            attackTimeArr = [];
         }
         attackTimeArr.push(attackObj);
         this.mAttackersCatalog[accountId] = attackTimeArr;
      }
      
      public function updateUserByServerAttackResponse(userId:String, response:Object) : void
      {
         var user:UserInfo = this.getUserInfoObj(userId,0,-1);
         if(user != null)
         {
            switch(response.lockType)
            {
               case UserDataMng.ACCOUNT_LOCKED_BY_OWNER:
                  user.mIsOnline.value = true;
                  user.mIsOnlineCooldownTimeLeft.value = GameConstants.USERDATA_ISONLINE_COOLDOWN_TIME;
                  this.onlineUsersAdd(user);
                  break;
               case UserDataMng.ACCOUNT_LOCKED_OWNER_HAS_DAMAGE_PROTECTION:
                  user.mDamageProtectionTimeLeft.value = response.unlockTimeLeft;
                  this.damageProtectionTimeUsersAdd(user);
            }
         }
      }
      
      private function fillUserListsCatalog() : void
      {
         this.mUserListsCatalog["unknown"] = 0;
         this.mUserListsCatalog["friends"] = 1;
         this.mUserListsCatalog["neighbors"] = 2;
         this.mUserListsCatalog["npcs"] = 3;
      }
      
      public function getUserListByKey(key:String) : int
      {
         var isDefined:* = this.mUserListsCatalog[key] != undefined;
         if(isDefined == false)
         {
            return -1;
         }
         return this.mUserListsCatalog[key];
      }
      
      public function isUserInfoAttackable(userInfo:UserInfo) : Boolean
      {
         if(userInfo.mIsNPC.value)
         {
            if(this.isUserInfoLocked(userInfo) == true)
            {
               return false;
            }
            return userInfo.isFriendlyNPC() == false;
         }
         if(userInfo.mIsOwnerProfile.value)
         {
            return false;
         }
         if(userInfo.mIsTutorialCompleted.value == false)
         {
            return false;
         }
         if(userInfo.mDamageProtectionTimeLeft.value > 0)
         {
            return false;
         }
         return !userInfo.mIsOnline.value;
      }
      
      public function getUserInfoLock(userInfo:UserInfo) : int
      {
         if(userInfo.mIsNPC.value == false)
         {
            return UserDataMng.ACCOUNT_NOT_LOCKED;
         }
         if(userInfo.mMissionSku == "" || userInfo.mMissionSku == null)
         {
            if(!this.ownerHasMinHQLevelRequired(userInfo))
            {
               return UserDataMng.ACCOUNT_LOCKED_BY_HQ_LEVEL_TOO_LOW;
            }
            return UserDataMng.ACCOUNT_NOT_LOCKED;
         }
         if(InstanceMng.getMissionsMng().isMissionStarted(userInfo.mMissionSku) == true)
         {
            if(!this.ownerHasMinHQLevelRequired(userInfo))
            {
               return UserDataMng.ACCOUNT_LOCKED_BY_HQ_LEVEL_TOO_LOW;
            }
            return UserDataMng.ACCOUNT_NOT_LOCKED;
         }
         return UserDataMng.ACCOUNT_LOCKED_BY_MISSION_NOT_COMPLETED;
      }
      
      public function isUserInfoLocked(userInfo:UserInfo) : Boolean
      {
         return this.getUserInfoLock(userInfo) != UserDataMng.ACCOUNT_NOT_LOCKED;
      }
      
      private function ownerHasMinHQLevelRequired(userInfo:UserInfo) : Boolean
      {
         var returnValue:* = true;
         var hqLevel:int = 0;
         var profileLogin:Profile;
         if((profileLogin = InstanceMng.getUserInfoMng().getProfileLogin()) != null)
         {
            hqLevel = profileLogin.getCapitalHqLevel();
         }
         if(userInfo.mHQLevelRequired == "" || userInfo.mHQLevelRequired == null)
         {
            returnValue = true;
         }
         else
         {
            returnValue = hqLevel >= int(userInfo.mHQLevelRequired);
         }
         return returnValue;
      }
      
      public function checkCompatibilityLevel(userInfo:UserInfo, levelBias:int) : Boolean
      {
         var ownLevel:int = this.getProfileLogin().getLevel();
         var userLevel:int = userInfo.getLevel();
         return userLevel - levelBias <= ownLevel && ownLevel <= userLevel + levelBias;
      }
      
      public function printUserList(searchOn:int) : void
      {
         var usrInfoObj:UserInfo = null;
         if(this.mUserInfoList[searchOn] != null)
         {
            for each(usrInfoObj in this.mUserInfoList[searchOn])
            {
               this.printUserInfoObj(usrInfoObj);
            }
         }
      }
      
      public function printNoPlayerFriendsList() : void
      {
         DCDebug.trace("***NEXT NO-PLAYER FRIEND ***");
         this.printUserList(0);
         DCDebug.trace("***END OF NO-PLAYER FRIENDS ***");
      }
      
      public function printPlayerFriendsList() : void
      {
         DCDebug.trace("***NEXT PLAYER FRIEND ***");
         this.printUserList(1);
         DCDebug.trace("***END OF PLAYER FRIENDS ***");
      }
      
      public function printNeighborsList() : void
      {
         DCDebug.trace("***NEXT NEIGHBOR ***");
         this.printUserList(2);
         DCDebug.trace("***END OF NEIGHBORS ***");
      }
      
      public function printUserInfoObj(usrInfoObj:UserInfo) : void
      {
         DCDebug.trace("mExtID: " + usrInfoObj.mExtId);
         DCDebug.trace("mName: " + usrInfoObj.getPlayerName());
         DCDebug.trace("mAccountId: " + usrInfoObj.mAccountId);
         DCDebug.trace("mThumbnailURL: " + usrInfoObj.mThumbnailURL);
         DCDebug.trace("mAccountId: " + usrInfoObj.mAccountId);
         DCDebug.trace("mXp.value: " + usrInfoObj.getXp());
         DCDebug.trace("mScore: " + usrInfoObj.getScore());
         DCDebug.trace("mIsNeighbor.value: " + usrInfoObj.mIsNeighbor.value);
         DCDebug.trace("  ");
      }
      
      public function printProfile(id:int) : void
      {
         if(this.mProfilesList != null)
         {
            if(this.mProfilesList[id] != null)
            {
               DCDebug.trace("**----------------**");
               DCDebug.trace("**----PROFILE-----**");
               DCDebug.trace("* Cash: " + this.mProfilesList[id].getCash());
               DCDebug.trace("* Coins: " + this.mProfilesList[id].getCoins());
               DCDebug.trace("* Xp: " + this.mProfilesList[id].getXp());
               DCDebug.trace("* Level: " + this.mProfilesList[id].getLevel());
               DCDebug.trace("* IsOwner: " + this.mProfilesList[id].getIsOwner());
               DCDebug.trace("* id: " + this.mProfilesList[id].getId());
               DCDebug.trace("* Minerals: " + this.mProfilesList[id].getMinerals());
               DCDebug.trace("* MaxMinerals: " + this.mProfilesList[id].getMineralsCapacity());
               DCDebug.trace("* Droids: " + this.mProfilesList[id].getDroids());
               DCDebug.trace("* MaxDroids: " + this.mProfilesList[id].getMaxDroidsAmount());
               DCDebug.trace("* AccId: " + this.mProfilesList[id].getAccountId());
               DCDebug.trace("**-END OF PROFILE-**");
               DCDebug.trace("**----------------**");
            }
         }
         else
         {
            DCDebug.trace("PROFILES LIST NOT LOAD YET",3);
         }
      }
      
      public function getIsNPCFriendlyByAccId(accId:String) : Boolean
      {
         var returnValue:Boolean = false;
         var uInfoObj:UserInfo = this.getUserInfoObj(accId,0);
         if(uInfoObj.mIsNPC.value)
         {
            switch(accId)
            {
               case "npc_A":
                  returnValue = true;
                  break;
               case "npc_B":
               case "npc_C":
               case "npc_D":
                  returnValue = false;
            }
         }
         return returnValue;
      }
      
      public function getCapitalByAccountId(accId:String) : Planet
      {
         var returnValue:Planet = null;
         var uInfo:UserInfo = this.getUserInfoObj(accId,0);
         if(uInfo != null)
         {
            returnValue = uInfo.getCapital();
         }
         return returnValue;
      }
      
      public function getProfileLogin() : Profile
      {
         var returnValue:Profile = null;
         if(this.mProfilesList != null)
         {
            return this.mProfilesList[0];
         }
         return returnValue;
      }
      
      public function getCurrentProfileLoaded() : Profile
      {
         var returnValue:Profile = null;
         if(this.mProfilesList != null)
         {
            returnValue = this.mProfilesList[this.mCurrentProfileLoaded];
         }
         return returnValue;
      }
      
      public function getCurrentProfileLoadedId() : int
      {
         return this.mCurrentProfileLoaded;
      }
      
      public function setAttacked(account:String) : void
      {
         this.mAttackedUserInfo = this.getUserInfoObj(account,0);
      }
      
      public function setAttacker(account:String) : void
      {
         this.mAttackerUserInfo = this.getUserInfoObj(account,0);
      }
      
      public function getAttacked() : UserInfo
      {
         return this.mAttackedUserInfo;
      }
      
      public function getAttacker() : UserInfo
      {
         return this.mAttackerUserInfo;
      }
      
      public function existsBattleInfoFromAttackerAndAttacked() : Boolean
      {
         if(this.mAttackerUserInfo.getLevel() <= 1 || this.mAttackerUserInfo.getHQLevel() <= 0)
         {
            return false;
         }
         if(this.mAttackedUserInfo.getLevel() <= 1 || this.mAttackedUserInfo.getHQLevel() <= 0)
         {
            return false;
         }
         return true;
      }
      
      public function getUInfoObjIdFromNeighborsList(accountId:String) : int
      {
         var i:int = 0;
         var returnValue:int = -1;
         var max:int = int(this.mUserInfoList[2].length);
         for(i = 0; i < max; )
         {
            if(this.mUserInfoList[2][i].mAccountId == accountId)
            {
               return i;
            }
            i++;
         }
         return returnValue;
      }
      
      public function clearOtherPlayerInfo() : void
      {
         var u:UserInfo = null;
         if(this.mOtherPlayersList != null)
         {
            for each(u in this.mOtherPlayersList)
            {
               this.onlineUsersRemove(u);
               this.damageProtectionTimeUsersRemove(u);
            }
            this.mOtherPlayersList.length = 0;
         }
      }
      
      public function addFriendPlayer(usrInfoObj:UserInfo) : UserInfo
      {
         if(this.getUserInfoObj(usrInfoObj.mExtId,1,1) == null)
         {
            this.mUserInfoList[1].push(usrInfoObj);
         }
         return null;
      }
      
      public function setUserToVisit(userInfo:UserInfo) : void
      {
         this.mUserToVisit = userInfo;
         var accountId:String = String(this.mUserToVisit != null ? this.mUserToVisit.mAccountId : null);
      }
      
      public function getUserToVisit() : UserInfo
      {
         return this.mUserToVisit;
      }
      
      public function getUserToVisitAccountId() : String
      {
         return this.mUserToVisit != null ? this.mUserToVisit.mAccountId : null;
      }
      
      public function setUserToVisitByAccountId(accountId:String) : void
      {
         var user:UserInfo = this.getUserInfoObj(accountId,0,-1);
         if(user != null)
         {
            this.setUserToVisit(user);
         }
      }
      
      public function loadWeeklyScoreList(userScoreOff:Number = -1) : void
      {
         this.mWeeklyScoreUserScoreOff = userScoreOff;
      }
      
      public function isWeeklyScoreListLoaded() : Boolean
      {
         return InstanceMng.getUserDataMng().isFileLoaded(UserDataMng.KEY_WEEKLY_SCORE_LIST);
      }
      
      public function getWeeklyScoreList() : Vector.<UserScoreInfo>
      {
         return this.mWeeklyScoreList;
      }
      
      public function getOldWeeklyScoreList() : Vector.<UserScoreInfo>
      {
         return this.mOldWeeklyScoreList;
      }
      
      public function getUserOldPosWeeklyScoreList() : int
      {
         return this.mUserOldPosWeeklyList;
      }
      
      public function hasTheUserPassedAnyFriends() : Boolean
      {
         this.updateWeeklyScoreList();
         return this.mWeeklyScoreFriendsPassed != null && this.mWeeklyScoreFriendsPassed.length > 0;
      }
      
      public function updateWeeklyScoreList() : void
      {
         var scoresCount:int = 0;
         var userScoreInfo:UserScoreInfo = null;
         var myPos:* = 0;
         var myPosUpdated:* = 0;
         var i:int = 0;
         var info:XML = null;
         var neighbor:XML = null;
         var userScore:UserScoreInfo = null;
         var score:Number = NaN;
         var account:String = null;
         var userInfo:UserInfo = null;
         var scoreOff:Number;
         if((scoreOff = this.mWeeklyScoreUserScoreOff > -1 ? this.mWeeklyScoreUserScoreOff : InstanceMng.getUserInfoMng().getProfileLogin().getScoreOff()) > 0)
         {
            if(this.mWeeklyScoreUserScoreOff == -1)
            {
               InstanceMng.getUserInfoMng().getProfileLogin().resetScoreOff();
            }
            if(this.mWeeklyScoreList == null)
            {
               this.mWeeklyScoreList = new Vector.<UserScoreInfo>();
               if((info = InstanceMng.getUserDataMng().getFileXML(UserDataMng.KEY_WEEKLY_SCORE_LIST)) != null)
               {
                  for each(neighbor in info.neighbor)
                  {
                     score = EUtils.xmlReadNumber(neighbor,"score");
                     account = EUtils.xmlReadString(neighbor,"accountId");
                     userScore = new UserScoreInfo(score,account);
                     this.mWeeklyScoreList.push(userScore);
                  }
               }
            }
            scoresCount = int(this.mWeeklyScoreList.length);
            myPos = -1;
            myPosUpdated = -1;
            for(i = 0; i < scoresCount; )
            {
               if((userScoreInfo = this.mWeeklyScoreList[i]).IsMe())
               {
                  myPos = i;
                  this.mUserOldPosWeeklyList = myPos;
                  break;
               }
               i++;
            }
            if(this.mWeeklyScoreFriendsPassed == null)
            {
               this.mWeeklyScoreFriendsPassed = new Vector.<UserInfo>(0);
            }
            else
            {
               this.mWeeklyScoreFriendsPassed.length = 0;
            }
            if(myPos > -1)
            {
               this.mOldWeeklyScoreList = this.mWeeklyScoreList.concat();
               this.mWeeklyScoreList[myPos].addScore(scoreOff);
               this.mWeeklyScoreList = this.mWeeklyScoreList.sort(this.sortWeeklyScoreList);
               for(i = 0; i < scoresCount; )
               {
                  if((userScoreInfo = this.mWeeklyScoreList[i]).IsMe())
                  {
                     myPosUpdated = i;
                     break;
                  }
                  i++;
               }
               if(myPosUpdated > -1)
               {
                  for(i = myPosUpdated + 1; i <= myPos; )
                  {
                     if((userInfo = this.getUserInfoObj(this.mWeeklyScoreList[i].getAccountId(),0,-1)) != null)
                     {
                        this.mWeeklyScoreFriendsPassed.push(userInfo);
                     }
                     i++;
                  }
               }
            }
         }
      }
      
      public function getWeeklyScoreListPassedFriends() : Vector.<UserInfo>
      {
         return this.mWeeklyScoreFriendsPassed;
      }
      
      private function sortWeeklyScoreList(a:UserScoreInfo, b:UserScoreInfo) : int
      {
         var scoreA:Number = a.getScore();
         var scoreB:Number = b.getScore();
         if(scoreA > scoreB)
         {
            return -1;
         }
         if(scoreA < scoreB)
         {
            return 1;
         }
         return 0;
      }
   }
}
