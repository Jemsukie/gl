package com.dchoc.game.model.alliances
{
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.toolkit.core.instance.DCInstanceMng;
   
   public class Alliance
   {
      
      public static const SORT_NO_SORT:int = 0;
      
      public static const SORT_BY_ROLE_AND_WARPOINTS_AND_LEVEL_AND_NAME:int = 1;
      
      public static const SORT_BY_CURRENT_WARPOINTS_AND_LEVEL_AND_NAME:int = 2;
      
      private static const DEFAULT_LOGO:Array = [0,0,0];
       
      
      private var mId:String = "";
      
      private var mName:String = "";
      
      private var mDescription:String = "";
      
      private var mLeader:AlliancesUser;
      
      private var mMembers:Array;
      
      private var mMembersSorted:Array;
      
      private var mCurrentSort:int = 0;
      
      private var mTotalMembers:int = 0;
      
      private var mMaxMembers:int;
      
      private var mCurrentWarEnemyAllianceId:String;
      
      private var mCurrentWarTimeStarted:Number;
      
      private var mCurrentWarTimeLeft:Number;
      
      private var mCurrentWarScore:Number;
      
      private var mCurrentWarKnockoutPoints:Number;
      
      private var mScore:Number;
      
      private var mLogo:Array;
      
      private var mWarsWon:uint;
      
      private var mWarsLost:uint;
      
      private var mIsPublic:Boolean;
      
      private var mNewsUnreadCount:int;
      
      private var mNewsTotal:int;
      
      private var mPostWarShield:Number;
      
      private var mRank:int;
      
      public function Alliance(id:String = "", name:String = "", description:String = "")
      {
         super();
         this.mLeader = new AlliancesUser();
         this.mId = id;
         this.mName = name;
         this.mDescription = description;
         this.init();
      }
      
      private function init() : void
      {
         this.mMembers = [];
         this.mMembersSorted = [];
         this.mCurrentSort = 0;
         this.setMaxMembers(50);
         this.setWarsWon(0);
         this.setWarsLost(0);
         this.setScore(0);
         this.setCurrentWarScore(0);
         this.setIsPublic(false);
         this.setNewsUnreadCount(0);
         this.setNewsTotal(0);
         this.setCurrentWarTimeLeft(0);
         this.setPostWarShield(0);
         this.setCurrentWarKnockoutPoints(AlliancesConstants.KO_BAR_NOT_USED);
      }
      
      public function toRow() : Array
      {
         var ret:Array = [];
         ret["alliance"] = this;
         ret["user"] = this.mLeader;
         ret["id"] = this.mId;
         ret["name"] = this.mName;
         ret["leader"] = this.mLeader.getName();
         ret["member_count"] = Math.max(this.mTotalMembers,this.mMembers.length);
         ret["friend_count"] = this.mMembers.length;
         return ret;
      }
      
      public function getId() : String
      {
         return this.mId;
      }
      
      private function setId(value:String) : void
      {
         this.mId = value;
      }
      
      public function getName() : String
      {
         return this.mName;
      }
      
      public function setName(value:String) : void
      {
         this.mName = value;
      }
      
      public function getDescription() : String
      {
         return this.mDescription;
      }
      
      public function setDescription(value:String) : void
      {
         this.mDescription = value;
      }
      
      public function setLeader(value:AlliancesUser) : void
      {
         this.mLeader = value;
      }
      
      public function getLeader() : AlliancesUser
      {
         return this.mLeader;
      }
      
      public function setMembers(value:Array) : void
      {
         this.mMembers = value;
      }
      
      public function addMember(value:AlliancesUser) : void
      {
         if(this.mMembers == null)
         {
            this.mMembers = [];
         }
         this.mMembers.push(value);
         this.mMembersSorted.push(value);
         this.mTotalMembers++;
      }
      
      private function removeMemberFromList(userId:String, list:Array) : void
      {
         var i:int = 0;
         var user:AlliancesUser = null;
         var length:int = int(list.length);
         for(i = 0; i < length; )
         {
            if((user = list[i]).getId() == userId)
            {
               list.splice(i,1);
               return;
            }
            i++;
         }
      }
      
      public function removeMember(userId:String) : void
      {
         if(this.mMembers != null)
         {
            this.removeMemberFromList(userId,this.mMembers);
            this.mTotalMembers = this.mMembers.length;
         }
         if(this.mMembersSorted != null)
         {
            this.removeMemberFromList(userId,this.mMembersSorted);
         }
      }
      
      public function getMember(userId:String) : AlliancesUser
      {
         var i:int = 0;
         var returnValue:AlliancesUser = null;
         var length:int = int(this.mMembers.length);
         i = 0;
         while(i < length && returnValue == null)
         {
            returnValue = this.mMembers[i];
            if(returnValue.getId() != userId)
            {
               returnValue = null;
            }
            i++;
         }
         return returnValue;
      }
      
      public function setMaxMembers(value:int) : void
      {
         this.mMaxMembers = value;
      }
      
      public function getTotalMembers() : int
      {
         return this.mTotalMembers;
      }
      
      public function setTotalMembers(value:int) : void
      {
         this.mTotalMembers = value;
      }
      
      public function getScore() : Number
      {
         return this.mScore;
      }
      
      public function setScore(value:Number) : void
      {
         this.mScore = value;
      }
      
      public function getCurrentWarScore() : Number
      {
         return this.mCurrentWarScore;
      }
      
      private function setCurrentWarScore(value:Number) : void
      {
         this.mCurrentWarScore = value;
      }
      
      public function declareWar(enemyAllianceId:String, timeLeft:Number) : void
      {
         this.mCurrentWarEnemyAllianceId = enemyAllianceId;
         this.mCurrentWarTimeLeft = timeLeft;
         this.mCurrentWarTimeStarted = InstanceMng.getUserDataMng().getServerCurrentTimemillis();
         this.mCurrentWarKnockoutPoints = 0;
      }
      
      public function getLogo() : Array
      {
         return this.mLogo == null ? DEFAULT_LOGO : this.mLogo;
      }
      
      public function setLogo(value:Array) : void
      {
         this.mLogo = value;
      }
      
      public function setLogoAsString(value:String) : void
      {
         this.setLogo(AlliancesConstants.getLogoArrayFromString(value));
      }
      
      public function getLogoAsString() : String
      {
         return AlliancesConstants.getLogoArrayAsString(this.getLogo());
      }
      
      public function getWarsWon() : int
      {
         return this.mWarsWon;
      }
      
      public function setWarsWon(value:int) : void
      {
         this.mWarsWon = value;
      }
      
      public function getWarsLost() : int
      {
         return this.mWarsLost;
      }
      
      public function setWarsLost(value:int) : void
      {
         this.mWarsLost = value;
      }
      
      public function getMembers() : Array
      {
         return this.mMembers;
      }
      
      private function setCurrentWarKnockoutPoints(value:Number) : void
      {
         this.mCurrentWarKnockoutPoints = value;
      }
      
      public function getCurrentWarKnockoutPoints() : Number
      {
         return this.mCurrentWarKnockoutPoints;
      }
      
      public function getMemberByIndex(index:int, sort:int = 1) : AlliancesUser
      {
         if(this.mMembers == null || index >= this.mMembers.length)
         {
            return null;
         }
         this.sortMembersBy(sort);
         return sort == 0 ? this.mMembers[index] : this.mMembersSorted[index];
      }
      
      private function sortMembersBy(sortType:int) : void
      {
         if(this.mMembersSorted == null)
         {
            return;
         }
         this.mCurrentSort = sortType;
         var sortFunction:Function = null;
         switch(sortType - 1)
         {
            case 0:
               sortFunction = this.sortByRoleAndWarpointsAndLevelAndName;
               break;
            case 1:
               sortFunction = this.sortByCurrentWarpointsAndLevelAndName;
         }
         if(sortFunction != null)
         {
            this.mMembersSorted.sort(sortFunction);
         }
      }
      
      private function sortByRoleAndWarpointsAndLevelAndName(a:AlliancesUser, b:AlliancesUser) : Number
      {
         var aVal:Number = a.getRoleAsNumericValue();
         var bVal:Number = b.getRoleAsNumericValue();
         if(aVal > bVal)
         {
            return -1;
         }
         if(aVal < bVal)
         {
            return 1;
         }
         aVal = a.getScore();
         bVal = b.getScore();
         if(aVal > bVal)
         {
            return -1;
         }
         if(aVal < bVal)
         {
            return 1;
         }
         aVal = a.getGameLevel();
         bVal = b.getGameLevel();
         if(aVal > bVal)
         {
            return -1;
         }
         if(aVal < bVal)
         {
            return 1;
         }
         var aValStr:String = a.getName();
         var bValStr:String = b.getName();
         if(aValStr > bValStr)
         {
            return 1;
         }
         if(aValStr < bValStr)
         {
            return -1;
         }
         return 0;
      }
      
      private function sortByCurrentWarpointsAndLevelAndName(a:AlliancesUser, b:AlliancesUser) : Number
      {
         var aVal:Number = a.getCurrentWarScore();
         var bVal:Number = b.getCurrentWarScore();
         if(aVal > bVal)
         {
            return -1;
         }
         if(aVal < bVal)
         {
            return 1;
         }
         aVal = a.getGameLevel();
         bVal = b.getGameLevel();
         if(aVal > bVal)
         {
            return -1;
         }
         if(aVal < bVal)
         {
            return 1;
         }
         var aValStr:String = a.getName();
         var bValStr:String = b.getName();
         if(aValStr > bValStr)
         {
            return 1;
         }
         if(aValStr < bValStr)
         {
            return -1;
         }
         return 0;
      }
      
      public function getRank() : int
      {
         return this.mRank;
      }
      
      private function setRank(value:int) : void
      {
         this.mRank = value;
      }
      
      public function getIsPublic() : Boolean
      {
         return this.mIsPublic;
      }
      
      public function setIsPublic(value:Boolean) : void
      {
         this.mIsPublic = value;
      }
      
      public function getNewsUnreadCount() : int
      {
         return this.mNewsUnreadCount;
      }
      
      public function setNewsUnreadCount(value:int) : void
      {
         this.mNewsUnreadCount = value;
         MessageCenter.getInstance().sendMessage("updateAlliancesNotifications");
      }
      
      public function getNewsTotal() : int
      {
         return this.mNewsTotal;
      }
      
      public function setNewsTotal(value:int) : void
      {
         this.mNewsTotal = value;
      }
      
      public function fromJSON(json:Object, useMyUser:Boolean = false) : void
      {
         var length:int = 0;
         var i:int = 0;
         var m:Object = null;
         var u:AlliancesUser = null;
         var myUserId:String = null;
         var allianceId:String = null;
         var warEndTime:Number = NaN;
         var currentTimeMillis:Number = NaN;
         if(json.id != null)
         {
            this.setId(json.id);
         }
         if(json.name != null)
         {
            this.setName(json.name);
         }
         if(json.description != null)
         {
            this.setDescription(json.description);
         }
         if(json.logo != null)
         {
            this.setLogoAsString(json.logo);
         }
         if(json.totalWarScore != null)
         {
            this.setScore(Number(json.totalWarScore));
         }
         if(json.currentWarScore != null)
         {
            this.setCurrentWarScore(Number(json.currentWarScore));
         }
         if(json.warsWon != null)
         {
            this.setWarsWon(int(json.warsWon));
         }
         if(json.warsLost != null)
         {
            this.setWarsLost(int(json.warsLost));
         }
         if(json.knockoutPoints != null)
         {
            this.setCurrentWarKnockoutPoints(parseInt(json.knockoutPoints));
         }
         if(json.members != null)
         {
            length = int(json.members.length);
            myUserId = AlliancesSessionUser.getInstance().getId();
            allianceId = this.getId();
            for(i = 0; i < length; )
            {
               if((m = json.members[i]).id == myUserId && useMyUser)
               {
                  u = AlliancesSessionUser.getInstance();
               }
               else
               {
                  u = new AlliancesUser();
               }
               u.fromJSON(m);
               u.setAllianceId(allianceId);
               this.addMember(u);
               if(u.isLeader())
               {
                  this.mLeader = u;
               }
               i++;
            }
            this.mTotalMembers = length;
         }
         else if(json.totalMembers != null)
         {
            this.mTotalMembers = json.totalMembers;
         }
         if("enemyAllianceId" in json)
         {
            this.mCurrentWarEnemyAllianceId = json.enemyAllianceId;
            this.mCurrentWarTimeStarted = json.warStartTime;
            if(json.currentWarTimeLeft != null)
            {
               this.setCurrentWarTimeLeft(json.currentWarTimeLeft);
            }
            else
            {
               warEndTime = Number(json.warEndTime);
               currentTimeMillis = InstanceMng.getUserDataMng().getServerCurrentTimemillis();
               if(warEndTime > currentTimeMillis)
               {
                  this.setCurrentWarTimeLeft(warEndTime - currentTimeMillis);
               }
            }
         }
         if(json.publicRecruit)
         {
            this.setIsPublic(json.publicRecruit == "true" || json.publicRecruit == true);
         }
         if(json.unreadNews)
         {
            this.setNewsUnreadCount(json.unreadNews);
         }
         if(json.totalNews)
         {
            this.setNewsTotal(json.totalNews);
         }
         if(json.rank)
         {
            this.setRank(json.rank);
         }
         if(json.postWarShield)
         {
            this.setPostWarShield(Number(json.postWarShield));
         }
      }
      
      public function getJSON() : Object
      {
         var m:AlliancesUser = null;
         var data:Object = {
            "id":this.getId(),
            "name":this.getName(),
            "description":this.getDescription(),
            "logo":this.getLogoAsString(),
            "totalWarScore":this.getScore(),
            "warsWon":this.getWarsWon(),
            "warsLost":this.getWarsLost(),
            "publicRecruit":this.getIsPublic(),
            "unreadNews":this.getNewsUnreadCount(),
            "totalNews":this.getNewsTotal(),
            "rank":this.getRank(),
            "postWarShield":this.getPostWarShieldTimestamp(),
            "knockoutPoints":this.getCurrentWarKnockoutPoints()
         };
         if(this.mCurrentWarEnemyAllianceId != null)
         {
            data.currentWarScore = this.getCurrentWarScore();
            data.enemyAllianceId = this.mCurrentWarEnemyAllianceId;
            data.warEndTime = InstanceMng.getUserDataMng().getServerCurrentTimemillis() + this.mCurrentWarTimeLeft;
            data.warStartTime = this.mCurrentWarTimeStarted;
         }
         var members:Array = [];
         for each(m in this.mMembers)
         {
            members.push(m.getJSON());
         }
         data.members = members;
         return data;
      }
      
      public function getPostWarShieldTimestamp() : Number
      {
         return this.mPostWarShield;
      }
      
      public function getPostWarShieldTimeLeft() : Number
      {
         var returnValue:Number = NaN;
         var currTime:Number = DCInstanceMng.getInstance().getApplication().getCurrentServerTimeMillis();
         var timeLeft:Number = this.mPostWarShield - currTime;
         return timeLeft > 0 ? timeLeft : 0;
      }
      
      public function setPostWarShield(value:Number) : void
      {
         this.mPostWarShield = value;
      }
      
      public function getCurrentWarEnemyAllianceId() : String
      {
         return this.mCurrentWarEnemyAllianceId;
      }
      
      public function getCurrentWarTimeLeft() : Number
      {
         return this.mCurrentWarTimeLeft;
      }
      
      public function setCurrentWarTimeLeft(value:Number) : void
      {
         this.mCurrentWarTimeLeft = value;
      }
      
      public function getCurrentWarTimeStarted() : Number
      {
         return this.mCurrentWarTimeStarted;
      }
      
      public function isInAWar() : Boolean
      {
         return this.mCurrentWarEnemyAllianceId != null && this.mCurrentWarTimeLeft > 0;
      }
      
      public function canBeDeclaredAWarAgainst() : Boolean
      {
         return !this.isInAWar() && this.getPostWarShieldTimeLeft() <= 0;
      }
      
      public function endWar() : void
      {
         this.mCurrentWarEnemyAllianceId = null;
         this.mCurrentWarTimeLeft = 0;
         this.mCurrentWarTimeStarted = 0;
         this.mCurrentWarScore = 0;
      }
      
      public function getFriendsCount() : int
      {
         var friend:AlliancesUser = null;
         var user:UserInfo = null;
         var count:int = 0;
         for each(friend in this.mMembers)
         {
            user = InstanceMng.getUserInfoMng().getUserInfoObj(friend.getId(),0,1);
            if(user != null)
            {
               count++;
            }
            else
            {
               user = InstanceMng.getUserInfoMng().getUserInfoObj(friend.getId(),0,2);
            }
            if(user != null)
            {
               count++;
            }
         }
         return count;
      }
      
      public function getAllianceState() : int
      {
         var returnValue:int = 0;
         if(this.isInAWar())
         {
            returnValue = 2;
         }
         else if(this.getPostWarShieldTimeLeft() > 0)
         {
            returnValue = 1;
         }
         return returnValue;
      }
   }
}
