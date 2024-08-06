package com.dchoc.game.model.userdata
{
   import com.dchoc.game.core.instance.InstanceMng;
   
   public class UserScoreInfo
   {
       
      
      private var mScore:Number;
      
      private var mAccountId:String;
      
      private var mIsMe:Boolean;
      
      public function UserScoreInfo(score:Number, account:String)
      {
         super();
         this.mScore = score;
         this.mAccountId = account;
         this.mIsMe = InstanceMng.getUserInfoMng().getProfileLogin().getAccountId() == this.mAccountId;
      }
      
      public function setScore(value:Number) : void
      {
         this.mScore = value;
      }
      
      public function addScore(score:Number) : void
      {
         this.mScore += score;
      }
      
      public function getScore() : Number
      {
         return this.mScore;
      }
      
      public function getAccountId() : String
      {
         return this.mAccountId;
      }
      
      public function IsMe() : Boolean
      {
         return this.mIsMe;
      }
   }
}
