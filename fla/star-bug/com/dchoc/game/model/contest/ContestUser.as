package com.dchoc.game.model.contest
{
   import com.dchoc.game.utils.anticheat.SecureBoolean;
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.game.utils.anticheat.SecureString;
   
   public class ContestUser
   {
       
      
      private var mId:SecureString;
      
      private var mScore:SecureNumber;
      
      private var mRank:SecureNumber;
      
      private var mName:SecureString;
      
      private var mPicUrl:SecureString;
      
      private var mIsMe:SecureBoolean;
      
      public function ContestUser(id:String = null)
      {
         mId = new SecureString("ContestUser.mId");
         mScore = new SecureNumber("ContestUser.mScore");
         mRank = new SecureNumber("ContestUser.mRank");
         mName = new SecureString("ContestUser.mName");
         mPicUrl = new SecureString("ContestUser.mPicUrl");
         mIsMe = new SecureBoolean("ContestUser.mIsMe");
         super();
         this.reset();
         this.mId.value = id;
      }
      
      public function destroy() : void
      {
         this.mId.value = null;
         this.mName.value = null;
         this.mPicUrl.value = null;
      }
      
      private function reset() : void
      {
         this.mId.value = null;
         this.setScore(0);
         this.setRank(0);
         this.mName.value = "";
         this.mPicUrl.value = null;
         this.setIsMe(false);
      }
      
      public function fromJSON(json:Object) : void
      {
         if(json.id != null)
         {
            this.mId.value = json.id;
         }
         if(json.score != null)
         {
            this.setScore(Number(json.score));
         }
         if(json.rank != null)
         {
            this.setRank(Number(json.rank));
         }
         if(json.name != null)
         {
            this.mName.value = json.name;
         }
         if(json.pictureUrl != null)
         {
            this.mPicUrl.value = json.pictureUrl;
         }
      }
      
      public function getId() : String
      {
         return this.mId.value;
      }
      
      public function getScore() : Number
      {
         return this.mScore.value;
      }
      
      public function setScore(value:Number) : void
      {
         this.mScore.value = value;
      }
      
      public function getRank() : Number
      {
         return this.mRank.value;
      }
      
      public function setRank(value:Number) : void
      {
         this.mRank.value = value;
      }
      
      public function getName() : String
      {
         return this.mName.value;
      }
      
      public function getPicUrl() : String
      {
         return this.mPicUrl.value;
      }
      
      public function getIsMe() : Boolean
      {
         return this.mIsMe.value;
      }
      
      public function setIsMe(value:Boolean) : void
      {
         this.mIsMe.value = value;
      }
   }
}
