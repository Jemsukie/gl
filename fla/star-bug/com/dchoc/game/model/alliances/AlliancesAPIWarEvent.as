package com.dchoc.game.model.alliances
{
   public class AlliancesAPIWarEvent extends AlliancesAPIEvent
   {
       
      
      private var mWar:AlliancesWar;
      
      private var mWars:Array;
      
      private var mWarHistory:AlliancesWarHistory;
      
      public function AlliancesAPIWarEvent(type:String, requestParams:Object, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,requestParams,bubbles,cancelable);
      }
      
      public function getWar() : AlliancesWar
      {
         return this.mWar;
      }
      
      public function setWar(value:AlliancesWar) : void
      {
         this.mWar = value;
      }
      
      public function getWars() : Array
      {
         return this.mWars;
      }
      
      public function setWars(value:Array) : void
      {
         this.mWars = value;
      }
      
      public function setWarHistory(value:AlliancesWarHistory) : void
      {
         this.mWarHistory = value;
      }
      
      public function getWarHistory() : AlliancesWarHistory
      {
         return this.mWarHistory;
      }
   }
}
