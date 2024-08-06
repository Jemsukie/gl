package com.dchoc.game.model.items
{
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.utils.def.DCDef;
   
   public class AlliancesRewardsMng extends DCComponent
   {
       
      
      private var mRewardsGained:Vector.<String>;
      
      private var mLastRewardsAvailable:int;
      
      public function AlliancesRewardsMng()
      {
         super();
      }
      
      public function setRewardsGained(info:String) : void
      {
         var infoArr:Array = null;
         var sku:String = null;
         var i:int = 0;
         if(info != null)
         {
            infoArr = info.split(",");
            if(infoArr != null)
            {
               i = 0;
               for(i = 0; i < infoArr.length; )
               {
                  sku = String(infoArr[i]);
                  this.setRewardGained(sku,null,true);
                  i++;
               }
            }
         }
      }
      
      public function setRewardGained(sku:String, trans:Transaction = null, notifyServer:Boolean = true) : void
      {
         if(this.mRewardsGained == null)
         {
            this.mRewardsGained = new Vector.<String>(0);
         }
         if(this.isRewardGained(sku) == false)
         {
            this.mRewardsGained.push(sku);
            if(notifyServer)
            {
               InstanceMng.getUserDataMng().updateProfile_allianceRewardGained(sku,trans);
            }
         }
      }
      
      public function isRewardGained(sku:String) : Boolean
      {
         var reward:String = null;
         var returnValue:Boolean = false;
         if(this.mRewardsGained != null)
         {
            for each(reward in this.mRewardsGained)
            {
               if(reward == sku)
               {
                  returnValue = true;
               }
            }
         }
         else
         {
            this.requestRewardsGained();
         }
         return returnValue;
      }
      
      private function requestRewardsGained() : void
      {
         var profileLogin:Profile = null;
         var rewardsGained:String = null;
         if(this.mRewardsGained == null)
         {
            profileLogin = InstanceMng.getUserInfoMng().getProfileLogin();
            if(profileLogin != null)
            {
               rewardsGained = profileLogin.getAlliancesRewardGainedData();
               if(rewardsGained != "")
               {
                  this.setRewardsGained(rewardsGained);
               }
            }
         }
      }
      
      public function isPlayerEligibleForReward(sku:String) : Boolean
      {
         var returnValue:Boolean = false;
         var alliancesRewardDefMng:AlliancesRewardDefMng = InstanceMng.getAlliancesRewardDefMng();
         if(alliancesRewardDefMng != null)
         {
            returnValue = alliancesRewardDefMng.isPlayerEligibleForReward(sku);
         }
         return returnValue;
      }
      
      public function userHasAlreadyReceivedRewardItem(sku:String) : Boolean
      {
         var item:ItemObject = null;
         var returnValue:* = false;
         var itemsMng:ItemsMng;
         if((itemsMng = InstanceMng.getItemsMng()) != null)
         {
            item = InstanceMng.getItemsMng().getItemObjectBySku(sku);
            if(item != null)
            {
               returnValue = item.quantity > 0;
            }
         }
         return returnValue;
      }
      
      public function getRewardsAvailable() : int
      {
         var rewardsDefsVec:Vector.<DCDef> = null;
         var rewardDef:DCDef = null;
         var isPlayerEligible:Boolean = false;
         var userHasReceivedItem:Boolean = false;
         var returnValue:int = 0;
         if(InstanceMng.getAlliancesRewardDefMng().isBuilt())
         {
            rewardsDefsVec = InstanceMng.getAlliancesRewardDefMng().getDefs();
            isPlayerEligible = false;
            userHasReceivedItem = false;
            for each(rewardDef in rewardsDefsVec)
            {
               isPlayerEligible = this.isPlayerEligibleForReward(rewardDef.mSku);
               userHasReceivedItem = this.userHasAlreadyReceivedRewardItem(AlliancesRewardDef(rewardDef).getRewardItemSku());
               if(isPlayerEligible && userHasReceivedItem == false)
               {
                  returnValue++;
               }
            }
         }
         if(this.mLastRewardsAvailable != returnValue)
         {
            this.mLastRewardsAvailable = returnValue;
            MessageCenter.getInstance().sendMessage("updateAlliancesNotifications");
         }
         return returnValue;
      }
   }
}
