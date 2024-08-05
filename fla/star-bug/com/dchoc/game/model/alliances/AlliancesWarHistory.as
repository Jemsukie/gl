package com.dchoc.game.model.alliances
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   
   public class AlliancesWarHistory
   {
       
      
      private var mId:String = "";
      
      private var mNumWins:int = 0;
      
      private var mNumLoses:int = 0;
      
      private var mHistoric:Vector.<AlliancesWarHistoryEntry> = null;
      
      public function AlliancesWarHistory()
      {
         super();
      }
      
      public function destroy() : void
      {
         this.mId = null;
         this.mHistoric = null;
      }
      
      public function setNumWins(value:int) : void
      {
         this.mNumWins = value;
      }
      
      public function setNumLoses(value:int) : void
      {
         this.mNumLoses = value;
      }
      
      public function getNumWins() : int
      {
         return this.mNumWins;
      }
      
      public function getNumLoses() : int
      {
         return this.mNumLoses;
      }
      
      public function getTotalWars() : int
      {
         return this.getNumWins() + this.getNumLoses();
      }
      
      public function getWinRatioPercent() : int
      {
         return this.getNumWins() / this.getTotalWars() * 100;
      }
      
      public function getEntry(i:int) : AlliancesWarHistoryEntry
      {
         if(this.mHistoric && this.mHistoric.length > i && i >= 0)
         {
            return this.mHistoric[i];
         }
         return null;
      }
      
      public function fromJSON(file:Object) : void
      {
         var warJSON:Object = null;
         var isWin:Boolean = false;
         var myAlliance:Alliance = null;
         if(this.mHistoric == null)
         {
            this.mHistoric = new Vector.<AlliancesWarHistoryEntry>(0);
         }
         else
         {
            this.mHistoric.length = 0;
         }
         for each(warJSON in file.wars)
         {
            if(isWin = this.addWarEntryJSON(warJSON))
            {
               this.mNumWins++;
            }
            else
            {
               this.mNumLoses++;
            }
         }
         myAlliance = InstanceMng.getAlliancesController().getMyAlliance();
         if(myAlliance != null)
         {
            this.mId = myAlliance.getId();
         }
      }
      
      private function addWarEntryJSON(file:Object) : Boolean
      {
         var allianceWarLine:AlliancesWarHistoryEntry = new AlliancesWarHistoryEntry();
         allianceWarLine.fromJSON(file);
         this.mHistoric.push(allianceWarLine);
         return allianceWarLine.hasMyAllianceWon();
      }
      
      public function clone(value:AlliancesWarHistory, lineStartIndex:int = 0, lineCount:int = -1) : void
      {
         this.mId = value.mId;
         this.mNumWins = value.getNumWins();
         this.mNumLoses = value.getNumLoses();
         if(lineCount == -1)
         {
            if(this.mHistoric == null)
            {
               lineCount = 0;
            }
            else
            {
               lineCount = int(this.mHistoric.length);
            }
         }
         this.mHistoric = value.mHistoric.slice(lineStartIndex,lineStartIndex + lineCount);
      }
      
      public function updateNewsInformation(allianceNew:AlliancesNewResultWar) : void
      {
         var allianceName:String = null;
         var timeStamp:Number = NaN;
         var entry:AlliancesWarHistoryEntry = null;
         var i:int = 0;
         var length:int = 0;
         var diff:Number = NaN;
         var diffTimeToConsiderAMatch:Number = NaN;
         var diffTimeToStopSearching:Number = NaN;
         var indexMatched:* = 0;
         if(this.mHistoric != null)
         {
            allianceName = allianceNew.getEnemyAllianceName();
            timeStamp = allianceNew.getTimeStampMillis();
            length = int(this.mHistoric.length);
            diffTimeToConsiderAMatch = DCTimerUtil.daysToMs(1);
            diffTimeToStopSearching = DCTimerUtil.daysToMs(3);
            indexMatched = -1;
            i = 0;
            while(i < length && indexMatched == -1)
            {
               entry = this.mHistoric[i];
               if((diff = timeStamp - entry.getTimeEnded()) > diffTimeToStopSearching)
               {
                  break;
               }
               if(entry.getEnemyAllianceName() == allianceName && entry.hasMyAllianceWon() == allianceNew.hasMyAllianceWon())
               {
                  diff = timeStamp - entry.getTimeEnded();
                  if(Math.abs(diff) < diffTimeToConsiderAMatch)
                  {
                     indexMatched = i;
                  }
               }
               i++;
            }
            if(indexMatched > -1 && indexMatched < length)
            {
               entry = this.mHistoric[indexMatched];
               allianceNew.updateFromWarHistoryEntry(entry);
            }
         }
      }
   }
}
