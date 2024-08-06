package com.dchoc.game.model.bet
{
   import com.dchoc.game.controller.entry.Entry;
   import com.dchoc.game.controller.entry.EntryFactory;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.utils.anticheat.SecureBoolean;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.game.utils.anticheat.SecureString;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import esparragon.utils.EUtils;
   
   public class Bet
   {
      
      public static const PROGRESS_COINS:int = 0;
      
      public static const PROGRESS_COINS_TOTAL:int = 1;
      
      public static const PROGRESS_MINERALS:int = 2;
      
      public static const PROGRESS_MINERALS_TOTAL:int = 3;
      
      public static const PROGRESS_SCORE:int = 4;
      
      public static const PROGRESS_SCORE_TOTAL:int = 5;
      
      public static const PROGRESS_SCORE_PERCENT:int = 6;
      
      public static const PROGRESS_TIME:int = 7;
      
      private static const PROGRESS_TOTAL:int = 8;
      
      public static const STATE_NONE:int = -1;
      
      public static const STATE_RUNNING:int = 0;
      
      public static const STATE_FINISHED:int = 1;
      
      public static const STATE_CLOSED:int = 2;
       
      
      private var mBetDef:BetDef;
      
      private var mBetReward:SecureString;
      
      private var mBet:SecureString;
      
      private var mHisAccountId:SecureString;
      
      private var mHisPlanetId:SecureInt;
      
      private var mIsMyWinner:SecureBoolean;
      
      private var mMyBattleIsEnded:SecureBoolean;
      
      private var mHisBattleIsEnded:SecureBoolean;
      
      private var mMyProgress:Array;
      
      private var mHisProgress:Array;
      
      private var mWinnerAccount:SecureString;
      
      private var mHisName:SecureString;
      
      private var mHisUrl:SecureString;
      
      private var mHisBattleMaxDateOver:SecureNumber;
      
      public function Bet()
      {
         mBetReward = new SecureString("Bet.mBetReward");
         mBet = new SecureString("Bet.mBet");
         mHisAccountId = new SecureString("Bet.mHisAccountId");
         mHisPlanetId = new SecureInt("Bet.mHisPlanetId");
         mIsMyWinner = new SecureBoolean("Bet.mIsMyWinner");
         mMyBattleIsEnded = new SecureBoolean("Bet.mMyBattleIsEnded");
         mHisBattleIsEnded = new SecureBoolean("Bet.mHisBattleIsEnded");
         mWinnerAccount = new SecureString("Bet.mWinnerAccount");
         mHisName = new SecureString("Bet.mHisName");
         mHisUrl = new SecureString("Bet.mHisUrl");
         mHisBattleMaxDateOver = new SecureNumber("Bet.mHisBattleMaxDateOver");
         super();
      }
      
      public function load() : void
      {
         this.mIsMyWinner.value = false;
         this.mMyBattleIsEnded.value = false;
         this.mHisBattleIsEnded.value = false;
         this.mMyProgress = new Array(8);
         this.mHisProgress = new Array(8);
      }
      
      public function unload() : void
      {
         this.mBetDef = null;
         this.mMyProgress = null;
         this.mHisProgress = null;
         this.mBet.value = null;
         this.mBetReward.value = null;
         this.mWinnerAccount.value = null;
         this.mHisAccountId.value = null;
      }
      
      public function build(xml:XML) : void
      {
         var entry:Entry = null;
         var sku:String = EUtils.xmlReadString(xml,"sku");
         var attribute:String = "accountId";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.mHisAccountId.value = EUtils.xmlReadString(xml,attribute);
         }
         attribute = "planetId";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.mHisPlanetId.value = EUtils.xmlReadInt(xml,attribute);
         }
         this.setMyWholeProgress(xml);
         this.setHisWholeProgress(xml);
         this.mBetDef = InstanceMng.getBetDefMng().getDefBySku(sku) as BetDef;
         if(this.mBetDef == null)
         {
            DCDebug.traceCh("ASSERT","<" + sku + "> sku not found in betsDefinitions.xml");
         }
         attribute = "reward";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.mBetReward.value = EUtils.xmlReadString(xml,attribute);
         }
         else
         {
            this.mBetReward.value = this.mBetDef.getReward();
         }
         this.mBet.value = null;
         attribute = "bet";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.mBet.value = EUtils.xmlReadString(xml,attribute);
         }
         if(this.mBet.value == null || this.mBet.value == "")
         {
            this.mBet.value = this.mBetDef.getBet();
            entry = EntryFactory.createSingleEntryFromString(this.mBet.value);
            entry.setAmount(0);
            this.mBet.value = entry.getEntryRaw();
         }
         attribute = "winner";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.mWinnerAccount.value = EUtils.xmlReadString(xml,attribute);
         }
         attribute = "hisName";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.mHisName.value = EUtils.xmlReadString(xml,attribute);
         }
         attribute = "hisUrl";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.mHisUrl.value = EUtils.xmlReadString(xml,attribute);
         }
      }
      
      public function unbuild() : void
      {
         this.mMyProgress.length = 0;
         this.mHisProgress.length = 0;
      }
      
      public function setMyWholeProgress(xml:XML) : void
      {
         this.resetMyProgress();
         var attribute:String = "myCoins";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.setMyProgress(0,EUtils.xmlReadNumber(xml,attribute));
         }
         attribute = "myCoinsTotal";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.setMyProgress(1,EUtils.xmlReadNumber(xml,attribute));
         }
         attribute = "myMinerals";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.setMyProgress(2,EUtils.xmlReadNumber(xml,attribute));
         }
         attribute = "myMineralsTotal";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.setMyProgress(3,EUtils.xmlReadNumber(xml,attribute));
         }
         attribute = "myScore";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.setMyProgress(4,EUtils.xmlReadNumber(xml,attribute));
         }
         attribute = "myScoreTotal";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.setMyProgress(5,EUtils.xmlReadNumber(xml,attribute));
         }
         attribute = "myScorePercent";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.setMyProgress(6,EUtils.xmlReadNumber(xml,attribute));
         }
         attribute = "myTime";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.setMyProgress(7,EUtils.xmlReadInt(xml,attribute));
         }
      }
      
      public function setHisWholeProgress(xml:XML) : void
      {
         this.resetHisProgress();
         var attribute:String = "hisCoins";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.setHisProgress(0,EUtils.xmlReadNumber(xml,attribute));
         }
         attribute = "hisCoinsTotal";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.setHisProgress(1,EUtils.xmlReadNumber(xml,attribute));
         }
         attribute = "hisMinerals";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.setHisProgress(2,EUtils.xmlReadNumber(xml,attribute));
         }
         attribute = "hisMineralsTotal";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.setHisProgress(3,EUtils.xmlReadNumber(xml,attribute));
         }
         attribute = "hisScore";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.setHisProgress(4,EUtils.xmlReadNumber(xml,attribute));
         }
         attribute = "hisScoreTotal";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.setHisProgress(5,EUtils.xmlReadNumber(xml,attribute));
         }
         attribute = "hisScorePercent";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.setHisProgress(6,EUtils.xmlReadNumber(xml,attribute));
         }
         attribute = "hisTime";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.setHisProgress(7,EUtils.xmlReadInt(xml,attribute));
         }
      }
      
      public function resetMyProgress() : void
      {
         var i:int = 0;
         for(i = 0; i < this.mMyProgress.length; )
         {
            this.mMyProgress[i] = 0;
            i++;
         }
      }
      
      public function resetHisProgress() : void
      {
         var i:int = 0;
         for(i = 0; i < this.mHisProgress.length; )
         {
            this.mHisProgress[i] = 0;
            i++;
         }
      }
      
      public function setMyProgress(id:int, value:Number) : void
      {
         if(this.mMyProgress != null)
         {
            this.mMyProgress[id] = value;
         }
      }
      
      public function setHisProgress(id:int, value:Number) : void
      {
         if(this.mHisProgress != null)
         {
            this.mHisProgress[id] = value;
         }
      }
      
      public function accumMyProgress(id:int, value:Number) : void
      {
         if(this.mMyProgress != null)
         {
            this.mMyProgress[id] += value;
         }
      }
      
      public function accumHisProgress(id:int, value:Number) : void
      {
         if(this.mHisProgress != null)
         {
            this.mHisProgress[id] += value;
         }
      }
      
      public function getMyProgress(id:int) : Number
      {
         if(this.mMyProgress != null && this.mMyProgress[id] != null)
         {
            return Number(this.mMyProgress[id]);
         }
         DCDebug.traceCh("bets","Bet::getMyProgress: My progress with id \"" + id + "\" not found");
         return 0;
      }
      
      public function getHisProgress(id:int) : Number
      {
         if(this.mHisProgress != null && this.mHisProgress[id] != null)
         {
            return Number(this.mHisProgress[id]);
         }
         DCDebug.traceCh("bets","Bet::getHisProgress: His progress with id \"" + id + "\" not found");
         return 0;
      }
      
      public function setHisBattleMaxDateOver(value:Number) : void
      {
         this.mHisBattleMaxDateOver.value = value;
      }
      
      public function getHisBattleTimeLeft() : Number
      {
         var returnValue:Number = this.mHisBattleMaxDateOver.value - DCTimerUtil.currentTimeMillis();
         if(returnValue < 0)
         {
            returnValue = 0;
         }
         return returnValue;
      }
      
      public function areBothBattlesFinished() : Boolean
      {
         return this.mMyBattleIsEnded.value && this.mHisBattleIsEnded.value;
      }
      
      public function areScoresPercentEqual() : Boolean
      {
         return this.getMyProgress(6) == this.getHisProgress(6);
      }
      
      public function areBattleTimesEqual() : Boolean
      {
         return this.getMyProgress(7) == this.getHisProgress(7);
      }
      
      public function isADraw() : Boolean
      {
         return this.mWinnerAccount.value == "-1";
      }
      
      public function amITheWinner() : Boolean
      {
         if(this.mWinnerAccount.value != null && this.mWinnerAccount.value != "")
         {
            this.mIsMyWinner.value = this.mWinnerAccount.value == InstanceMng.getUserInfoMng().getProfileLogin().getAccountId();
         }
         else
         {
            DCDebug.traceCh("bets","Bet::amITheWinner: winner not found in the xml. Calculate in the client side");
            if(this.mMyProgress[6] != this.mHisProgress[6])
            {
               this.mIsMyWinner.value = this.mMyProgress[6] > this.mHisProgress[6];
            }
            else
            {
               this.mIsMyWinner.value = this.mMyProgress[7] < this.mHisProgress[7];
            }
         }
         return this.mIsMyWinner.value;
      }
      
      public function amITheLoser() : Boolean
      {
         return this.isADraw() == false && this.amITheWinner() == false;
      }
      
      public function getBetDef() : BetDef
      {
         return this.mBetDef;
      }
      
      public function isMyBattleEnded() : Boolean
      {
         return this.mMyBattleIsEnded.value;
      }
      
      public function isHisBattleEnded() : Boolean
      {
         return this.mHisBattleIsEnded.value;
      }
      
      public function getReward() : String
      {
         return this.isADraw() ? this.mBet.value : this.mBetReward.value;
      }
      
      public function getRefund() : String
      {
         return this.mBet.value;
      }
      
      public function getHisName() : String
      {
         return this.mHisName.value;
      }
      
      public function getHisUrl() : String
      {
         return this.mHisUrl.value;
      }
      
      public function setMyBattleEnded(value:Boolean) : void
      {
         this.mMyBattleIsEnded.value = value;
      }
      
      public function setHisBattleEnded(value:Boolean) : void
      {
         this.mHisBattleIsEnded.value = value;
      }
   }
}
