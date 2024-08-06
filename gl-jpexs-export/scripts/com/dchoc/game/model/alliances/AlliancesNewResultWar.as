package com.dchoc.game.model.alliances
{
   public class AlliancesNewResultWar extends AlliancesNew
   {
       
      
      private var mMyScore:Number;
      
      private var mEnemyScore:Number;
      
      private var mEnemyAllianceId:String;
      
      private var mHasFinishedByKO:Boolean;
      
      public function AlliancesNewResultWar()
      {
         super();
      }
      
      override public function fromJSON(data:Object) : void
      {
         super.fromJSON(data);
         var value:String = String(data.onKnockout);
         var valueBoolean:* = value == "true";
         this.setHasFinishedByKO(valueBoolean);
         this.setEnemyAllianceId(data.enemyId);
         this.setMyScore(data.warScore);
         this.setEnemyScore(data.enemyWarScore);
      }
      
      public function updateFromWarHistoryEntry(entry:AlliancesWarHistoryEntry) : void
      {
         this.setHasFinishedByKO(entry.isOnKnockout());
         this.setEnemyAllianceId(entry.getEnemyAllianceId());
         this.setMyScore(entry.getMyAllianceWarScore());
         this.setEnemyScore(entry.getEnemyAllianceWarScore());
      }
      
      public function hasIncompleteInformation() : Boolean
      {
         return this.mEnemyAllianceId == null;
      }
      
      public function hasMyAllianceWon() : Boolean
      {
         return getSubType() == 10;
      }
      
      public function hasFinishedByKO() : Boolean
      {
         return this.mHasFinishedByKO;
      }
      
      private function setHasFinishedByKO(value:Boolean) : void
      {
         this.mHasFinishedByKO = value;
      }
      
      public function getEnemyAllianceId() : String
      {
         return this.mEnemyAllianceId;
      }
      
      private function setEnemyAllianceId(value:String) : void
      {
         this.mEnemyAllianceId = value;
      }
      
      public function getEnemyAllianceName() : String
      {
         return getName();
      }
      
      public function getEnemyAllianceLogo() : String
      {
         return getLogo();
      }
      
      public function getMyScore() : Number
      {
         return this.mMyScore;
      }
      
      private function setMyScore(value:Number) : void
      {
         this.mMyScore = value;
      }
      
      public function getEnemyScore() : Number
      {
         return this.mEnemyScore;
      }
      
      private function setEnemyScore(value:Number) : void
      {
         this.mEnemyScore = value;
      }
   }
}
