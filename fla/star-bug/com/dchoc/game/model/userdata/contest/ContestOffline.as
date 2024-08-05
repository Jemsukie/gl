package com.dchoc.game.model.userdata.contest
{
   import com.dchoc.game.core.flow.Application;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.userdata.UserDataMng;
   
   public class ContestOffline
   {
       
      
      private var mUserDataMng:UserDataMng;
      
      private var mStartTime:Number = -1;
      
      private var mEndTime:Number = -1;
      
      private var mExpiryTime:Number = -1;
      
      private var mUserShowClickMe:Boolean = true;
      
      private var mUserTimes:int = 0;
      
      public function ContestOffline(userDataMng:UserDataMng)
      {
         super();
         this.mUserDataMng = userDataMng;
      }
      
      private function getContestListContent() : String
      {
         return String(this.mUserDataMng.getFile(UserDataMng.KEY_CONTEST_LIST));
      }
      
      private function getContestProgressContent() : String
      {
         return String(this.mUserDataMng.getFile(UserDataMng.KEY_CONTEST_PROGRESS));
      }
      
      private function getContestLeaderboardContent() : String
      {
         return String(this.mUserDataMng.getFile(UserDataMng.KEY_CONTEST_LEADERBOARD));
      }
      
      public function requestContest(params:Object) : void
      {
         var errorCode:int = 0;
         var fileString:String = null;
         var file:Object = null;
         var secondTime:* = false;
         var doError:Boolean = false;
         var addedTime:int = 1000000;
         if(doError || true)
         {
            errorCode = 0;
            InstanceMng.getContestMng().notificationsNotify("requestContest",false,null,params);
         }
         else
         {
            fileString = this.getContestListContent();
            file = JSON.parse(fileString);
            secondTime = this.mStartTime > -1;
            this.mStartTime = this.mUserDataMng.getServerCurrentTimemillis();
            if(secondTime)
            {
               this.mStartTime += addedTime;
               this.setShowClickMe(true);
            }
            this.mEndTime = this.mStartTime + addedTime;
            this.mExpiryTime = this.mEndTime + addedTime;
            file.startTime = this.mStartTime;
            file.endTime = this.mEndTime;
            file.expiryTime = this.mExpiryTime;
            InstanceMng.getContestMng().notificationsNotify("requestContest",true,file,params);
         }
      }
      
      public function requestUserProgress(params:Object) : void
      {
         var errorCode:int = 0;
         var mustWin:Boolean = false;
         var fileString:String = null;
         var file:Object = null;
         var isFinished:* = false;
         var transactionXML:XML = null;
         var pendingTransactionsXML:XML = null;
         var doError:*;
         if(doError = this.mUserTimes > 0)
         {
            errorCode = 0;
            InstanceMng.getContestMng().notificationsNotify("requestProgress",false,{
               "result":false,
               "error":errorCode
            },params);
         }
         else
         {
            mustWin = false;
            fileString = this.getContestProgressContent();
            file = JSON.parse(fileString);
            file.showClickMe = this.mUserShowClickMe ? "1" : "0";
            isFinished = this.mUserDataMng.getServerCurrentTimemillis() >= this.mEndTime;
            file.showLost = isFinished && !mustWin ? "1" : "0";
            InstanceMng.getContestMng().notificationsNotify("requestProgress",true,file,params);
            if(isFinished && mustWin)
            {
               transactionXML = <Transaction id="1" type="coins" amount="5" notifyServerByAddItem="1" source="contest" params="rank:2,id:3,sku:easter_0"/>;
               (pendingTransactionsXML = <pendingTransactions/>).appendChild(transactionXML);
               transactionXML = <Transaction id="1" type="chips" amount="5" notifyServerByAddItem="1"/>;
               pendingTransactionsXML.appendChild(transactionXML);
               Application.externalNotification(21,{"pendingTransactions":pendingTransactionsXML});
            }
         }
         this.mUserTimes++;
      }
      
      public function setShowClickMe(value:Boolean) : void
      {
         this.mUserShowClickMe = value;
      }
      
      public function requestLeaderboard(params:Object) : void
      {
         var errorCode:int = 0;
         var fileString:String = null;
         var file:Object = null;
         var doError:Boolean = false;
         if(doError)
         {
            errorCode = 0;
            InstanceMng.getContestMng().notificationsNotify("requestLeaderboard",false,{
               "result":false,
               "error":errorCode
            },params);
         }
         else
         {
            fileString = this.getContestLeaderboardContent();
            file = JSON.parse(fileString);
            InstanceMng.getContestMng().notificationsNotify("requestLeaderboard",true,file,params);
         }
      }
      
      public function commandsFlushed(e:Object) : void
      {
         InstanceMng.getContestMng().notificationsNotify("commandsFlushed",true,{});
      }
   }
}
