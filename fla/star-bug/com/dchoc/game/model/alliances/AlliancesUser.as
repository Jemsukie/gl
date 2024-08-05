package com.dchoc.game.model.alliances
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.userdata.UserInfo;
   
   public class AlliancesUser
   {
       
      
      private var mId:String;
      
      private var mName:String = "";
      
      private var mPicture:String;
      
      private var mAllianceId:String;
      
      private var mRole:String;
      
      private var mScore:Number = 0;
      
      private var mCurrentWarScore:Number = 0;
      
      private var mGameScore:Number = 0;
      
      public function AlliancesUser()
      {
         super();
      }
      
      public function getId() : String
      {
         return this.mId;
      }
      
      public function setId(value:String) : void
      {
         this.mId = value;
      }
      
      public function getName() : String
      {
         return this.mName;
      }
      
      private function setName(value:String) : void
      {
         this.mName = value;
      }
      
      public function getPictureUrl() : String
      {
         return this.mPicture;
      }
      
      private function setPictureUrl(value:String) : void
      {
         this.mPicture = value;
      }
      
      public function getRole() : String
      {
         return this.mRole;
      }
      
      public function getRoleAsText() : String
      {
         return AlliancesConstants.getRoleAsText(this.mRole);
      }
      
      public function getRoleAsNumericValue() : Number
      {
         return AlliancesConstants.getRoleAsNumericValue(this.mRole);
      }
      
      public function setRole(value:String) : void
      {
         this.mRole = value;
      }
      
      public function getAllianceId() : String
      {
         return this.mAllianceId;
      }
      
      public function setAllianceId(value:String) : void
      {
         this.mAllianceId = value;
      }
      
      public function getVisitId() : String
      {
         return this.mId;
      }
      
      public function getScore() : Number
      {
         return this.mScore;
      }
      
      private function setScore(value:Number) : void
      {
         this.mScore = value;
      }
      
      public function getGameLevel() : int
      {
         return InstanceMng.getRuleMng().getLevel(this.mGameScore);
      }
      
      public function getGameScore() : Number
      {
         return this.mGameScore;
      }
      
      public function setGameScore(value:Number) : void
      {
         this.mGameScore = value;
      }
      
      public function getCurrentWarScore() : Number
      {
         return this.mCurrentWarScore;
      }
      
      private function setCurrentWarScore(value:Number) : void
      {
         this.mCurrentWarScore = value;
      }
      
      public function toString() : String
      {
         return this.mName;
      }
      
      public function toRow() : Array
      {
         var ret:Array = [];
         ret["id"] = this.mId;
         ret["name"] = this.mName;
         ret["picture"] = this.mPicture;
         ret["role"] = this.mRole;
         ret["user"] = this;
         return ret;
      }
      
      public function isInAnyAlliance() : Boolean
      {
         return this.mAllianceId != null && this.mAllianceId != "";
      }
      
      public function leaveAlliance() : void
      {
         this.mAllianceId = null;
      }
      
      public function clone(value:AlliancesUser) : void
      {
         this.setId(value.getId());
         this.setName(value.getName());
         this.setPictureUrl(value.getPictureUrl());
         this.setRole(value.getRole());
         this.setGameScore(value.getGameScore());
         this.setScore(value.getScore());
         this.setCurrentWarScore(value.getCurrentWarScore());
         this.setAllianceId(value.getAllianceId());
      }
      
      public function isLeader() : Boolean
      {
         return this.mRole == "LEADER";
      }
      
      public function getJSON() : Object
      {
         return {
            "id":this.getId(),
            "name":this.getName(),
            "pictureUrl":this.getPictureUrl(),
            "role":this.getRole(),
            "score":this.getGameScore(),
            "totalWarScore":AlliancesConstants.getScoreRawFromScore(this.getScore()),
            "currentWarScore":AlliancesConstants.getScoreRawFromScore(this.getCurrentWarScore()),
            "allianceId":this.getAllianceId()
         };
      }
      
      public function fromJSON(json:Object) : void
      {
         if(json.id != null)
         {
            this.setId(json.id);
         }
         if(json.name != null)
         {
            this.setName(json.name);
         }
         if(json.pictureUrl != null)
         {
            this.setPictureUrl(json.pictureUrl);
         }
         if(json.role != null)
         {
            this.setRole(json.role);
         }
         if(json.score != null)
         {
            this.setGameScore(json.score);
         }
         if(json.totalWarScore != null)
         {
            this.setScore(AlliancesConstants.getScoreFromRaw(Number(json.totalWarScore)));
         }
         if(json.currentWarScore != null)
         {
            this.setCurrentWarScore(AlliancesConstants.getScoreFromRaw(Number(json.currentWarScore)));
         }
         if(json.allianceId != null)
         {
            this.setAllianceId(json.allianceId);
         }
      }
      
      public function isFriend() : Boolean
      {
         var user:UserInfo = InstanceMng.getUserInfoMng().getUserInfoObj(this.getVisitId(),0,2);
         return user != null;
      }
   }
}
