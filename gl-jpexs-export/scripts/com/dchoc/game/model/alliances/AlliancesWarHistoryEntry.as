package com.dchoc.game.model.alliances
{
   import com.dchoc.game.core.instance.InstanceMng;
   
   public class AlliancesWarHistoryEntry
   {
       
      
      private var mEnemyAllianceId:String;
      
      private var mEnemyAllianceLogo:Array;
      
      private var mEnemyAllianceName:String;
      
      private var mEnemyAllianceWarScore:Number;
      
      private var mMyAllianceWarScore:Number;
      
      private var mTimeEnded:Number;
      
      private var mTimeStarted:Number;
      
      private var mMyAllianceWon:Boolean;
      
      private var mOnKnockout:Boolean;
      
      public function AlliancesWarHistoryEntry()
      {
         super();
      }
      
      public static function getJSONFromParameters(enemyId:String, enemyLogo:Array, enemyName:String, enemyWarScore:Number, myWarScore:Number, timeStarted:Number, timeEnded:Number) : Object
      {
         return {
            "enemyAllianceId":enemyId,
            "enemyAllianceLogo":AlliancesConstants.getLogoArrayAsString(enemyLogo),
            "enemyAllianceName":enemyName,
            "enemyAllianceWarScore":enemyWarScore,
            "myAllianceWarScore":myWarScore,
            "warStartTime":timeStarted,
            "warEndTime":timeEnded
         };
      }
      
      private function setEnemyAllianceId(value:String) : void
      {
         this.mEnemyAllianceId = value;
      }
      
      public function getEnemyAllianceId() : String
      {
         return this.mEnemyAllianceId;
      }
      
      private function setEnemyAllianceLogo(value:Array) : void
      {
         this.mEnemyAllianceLogo = value;
      }
      
      public function getEnemyAllianceLogo() : Array
      {
         return this.mEnemyAllianceLogo;
      }
      
      private function setEnemyAllianceName(value:String) : void
      {
         this.mEnemyAllianceName = value;
      }
      
      public function getEnemyAllianceName() : String
      {
         return this.mEnemyAllianceName;
      }
      
      private function setEnemyAllianceWarScore(value:Number) : void
      {
         this.mEnemyAllianceWarScore = value;
      }
      
      public function getEnemyAllianceWarScore() : Number
      {
         return this.mEnemyAllianceWarScore;
      }
      
      private function setMyAllianceWarScore(value:Number) : void
      {
         this.mMyAllianceWarScore = value;
      }
      
      public function getMyAllianceWarScore() : Number
      {
         return this.mMyAllianceWarScore;
      }
      
      private function setTimeEnded(value:Number) : void
      {
         this.mTimeEnded = value;
      }
      
      public function getTimeEnded() : Number
      {
         return this.mTimeEnded;
      }
      
      public function getTimeAgo() : Number
      {
         return InstanceMng.getUserDataMng().getServerCurrentTimemillis() - this.mTimeEnded;
      }
      
      private function setTimeStarted(value:Number) : void
      {
         this.mTimeStarted = value;
      }
      
      public function getTimeStarted() : Number
      {
         return this.mTimeStarted;
      }
      
      public function hasMyAllianceWon() : Boolean
      {
         return this.mMyAllianceWon;
      }
      
      private function setMyAllianceWon(value:Boolean) : void
      {
         this.mMyAllianceWon = value;
      }
      
      public function isOnKnockout() : Boolean
      {
         return this.mOnKnockout;
      }
      
      private function setOnKnockout(value:Boolean) : void
      {
         this.mOnKnockout = value;
      }
      
      public function fromJSON(file:Object) : void
      {
         var allianceWinnerId:String = null;
         this.setEnemyAllianceId(file.enemyAllianceId);
         this.setEnemyAllianceLogo(AlliancesConstants.getLogoArrayFromString(file.enemyAllianceLogo));
         this.setEnemyAllianceName(file.enemyAllianceName);
         this.setEnemyAllianceWarScore(file.enemyAllianceWarScore);
         this.setMyAllianceWarScore(file.myAllianceWarScore);
         this.setTimeStarted(file.warStartTime);
         this.setTimeEnded(file.warEndTime);
         this.setOnKnockout(file.onKnockout == true);
         if(file.winnerId == null)
         {
            this.setMyAllianceWon(this.mMyAllianceWarScore > this.mEnemyAllianceWarScore);
         }
         else
         {
            allianceWinnerId = String(file.winnerId);
            this.setMyAllianceWon(allianceWinnerId != this.mEnemyAllianceId);
         }
      }
   }
}
