package com.dchoc.game.model.alliances
{
   public class AlliancesWar
   {
       
      
      private var mId:String = "";
      
      private var mAlliances:Vector.<Alliance>;
      
      private var mTime:Number;
      
      private var mAllianceWinnerIndex:int = -1;
      
      public function AlliancesWar()
      {
         super();
      }
      
      public function getId() : String
      {
         return this.mId;
      }
      
      public function getAlliances() : Vector.<Alliance>
      {
         return this.mAlliances;
      }
      
      public function setAlliances(value:Vector.<Alliance>) : void
      {
         this.mAlliances = value;
      }
      
      public function getTime() : Number
      {
         return this.mTime;
      }
      
      private function setTime(value:Number) : void
      {
         this.mTime = value;
      }
      
      public function isOver() : Boolean
      {
         return this.mTime <= 0;
      }
      
      public function getAllianceWinner() : Alliance
      {
         return this.mAllianceWinnerIndex == -1 ? null : this.mAlliances[this.mAllianceWinnerIndex];
      }
      
      private function setAllianceWinnerIndex(value:int) : void
      {
         this.mAllianceWinnerIndex = value;
      }
      
      public function setup(alliances:Vector.<Alliance>, time:Number, winnerIndex:int = -1) : void
      {
         this.setAlliances(alliances);
         this.setTime(time);
         this.setAllianceWinnerIndex(winnerIndex);
      }
      
      public function fromJSON(json:Object) : void
      {
         var allianceData:Object = null;
         var alliance:Alliance = null;
         var currentWar:Object = json.CurrentWar;
         this.mId = currentWar.id;
         this.setTime(currentWar.time);
         this.setAllianceWinnerIndex(currentWar.winnerIndex);
         this.mAlliances = new Vector.<Alliance>(0);
         for each(allianceData in currentWar.Alliance)
         {
            alliance = new Alliance();
            alliance.fromJSON(allianceData,false);
            this.mAlliances.push(alliance);
         }
      }
   }
}
