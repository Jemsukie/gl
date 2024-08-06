package com.dchoc.game.model.dailyreward
{
   import com.dchoc.game.controller.gui.popups.PopupFactory;
   import com.dchoc.game.controller.notifications.Notification;
   import com.dchoc.game.controller.notifications.NotificationsMng;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.items.ItemsDef;
   import com.dchoc.game.model.items.RewardObject;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.view.facade.UIFacade;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   
   public class DailyRewardMng extends DCComponent
   {
      
      private static const REWARD_BOX_SKU:int = 1200;
      
      private static const DAYS_PER_CUBE:int = 7;
      
      private static const NUMBER_OF_CUBES:int = 9;
      
      private static const NO_CLAIM_REASON_SILOS:String = "silosFull";
      
      private static const NO_CLAIM_REASON_BANKS:String = "banksFull";
       
      
      private var needsToShowPopup:Boolean = true;
      
      private var mRewardObject:RewardObject;
      
      private var mTransaction:Transaction;
      
      public function DailyRewardMng()
      {
         super();
      }
      
      public function notificationsNotify(cmd:String, ok:Boolean, data:Object, requestParams:Object = null) : void
      {
         if(ok)
         {
            if(cmd == "getReward")
            {
               this.needsToShowPopup = true;
               InstanceMng.getUserInfoMng().getProfileLogin().setDailyLoginStreak(data["dailyLoginStreak"]);
               InstanceMng.getUserInfoMng().getProfileLogin().setDailyRewardClaimed(false);
            }
         }
      }
      
      public function openDailyRewardPopup() : void
      {
         var profile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         var uiFacade:UIFacade;
         var popupFactory:PopupFactory = (uiFacade = InstanceMng.getUIFacade()).getPopupFactory();
         var claimed:Boolean = profile.getDailyRewardClaimed();
         var streakIndex:int = profile.getDailyLoginStreak();
         if(!claimed)
         {
            streakIndex -= 1;
         }
         var cubeSku:String = String(1200 + Math.floor(streakIndex / 7) % 9);
         var pos:int = streakIndex % 7;
         var cubeDef:ItemsDef = InstanceMng.getItemsDefMng().getDefBySku(cubeSku) as ItemsDef;
         var cubeRewards:Array = cubeDef.getRewardSequence();
         this.mRewardObject = InstanceMng.getRuleMng().createRewardObjectFromMisteryRewardSku("" + cubeRewards[pos],false);
         var popup:DCIPopup = popupFactory.getDailyRewardPopup(cubeSku,cubeRewards,pos,claimed);
         uiFacade.enqueuePopup(popup,true,true,false);
         this.needsToShowPopup = false;
      }
      
      public function isClaimable() : Boolean
      {
         var profile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         return !profile.getDailyRewardClaimed() && profile.getDailyLoginStreak() > 0;
      }
      
      override public function logicUpdate(dt:int) : void
      {
         if(InstanceMng.getRole().mId == 0 && this.needsToShowPopup && this.isClaimable() && InstanceMng.getApplication().canStartLoading() && !(InstanceMng.getPopupMng().isAnyPopupBeingShownOrWaiting() || InstanceMng.getFlowStatePlanet().isTutorialRunning()))
         {
            openDailyRewardPopup();
         }
      }
      
      private function createTransaction(reward:RewardObject) : String
      {
         var REWARD_PACK_VALUE:int = 1000;
         var profile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         var amt:int = reward.getAmount();
         var packAmount:int = 0;
         this.mTransaction = InstanceMng.getRuleMng().createSingleTransaction(false,0,0,0,0);
         switch(reward.getRewardType())
         {
            case "coins":
               if(amt > 0 && amt + profile.getCoins() > profile.getCoinsCapacity())
               {
                  return "banksFull";
               }
               this.mTransaction = InstanceMng.getRuleMng().createSingleTransaction(false,0,amt,0,0);
               break;
            case "minerals":
               if(amt > 0 && amt + profile.getMinerals() > profile.getMineralsCapacity())
               {
                  return "banksFull";
               }
               this.mTransaction = InstanceMng.getRuleMng().createSingleTransaction(false,0,0,amt,0);
               break;
            case "chips":
               this.mTransaction = InstanceMng.getRuleMng().createSingleTransaction(false,amt,0,0,0);
               break;
            case "item":
               this.mTransaction.addTransItem(reward.getItem().mDef.getSku(),amt,false);
         }
         return null;
      }
      
      public function tryToClaim() : void
      {
         if(!this.isClaimable())
         {
            return;
         }
         var transResult:String = this.createTransaction(this.mRewardObject);
         var notif:Notification = null;
         var notifMng:NotificationsMng = InstanceMng.getNotificationsMng();
         switch(transResult)
         {
            case "silosFull":
               notif = notifMng.createNotificationSilosAreFull();
               break;
            case "banksFull":
               notif = notifMng.createNotificationBanksAreFull();
         }
         if(notif)
         {
            notifMng.guiOpenNotificationMessage(notif);
         }
         else if(this.mTransaction.performAllTransactions())
         {
            InstanceMng.getUserInfoMng().getProfileLogin().setDailyRewardClaimed(true);
            InstanceMng.getUserDataMng().updateDailyReward_sendTransaction(this.mTransaction);
            MessageCenter.getInstance().sendMessage("updateHud");
         }
      }
   }
}
