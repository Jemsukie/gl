package com.dchoc.game.model.items
{
   import com.dchoc.game.controller.notifications.Notification;
   import com.dchoc.game.controller.notifications.NotificationsMng;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.utils.def.DCDefMng;
   
   public class MisteryRewardDefMng extends DCDefMng
   {
       
      
      public function MisteryRewardDefMng(resourceDefs:Vector.<String>, typeSkus:Vector.<String> = null, directoryPath:String = null)
      {
         super(resourceDefs,typeSkus,directoryPath);
      }
      
      override protected function createDef(type:String) : DCDef
      {
         return new MisteryRewardDef();
      }
      
      public function openBox(item:ItemObject) : Boolean
      {
         var notification:Notification = null;
         var rewardSku:String = null;
         var reward:RewardObject = null;
         var def:ItemsDef;
         var sequence:Array = (def = item.mDef).getRewardSequence();
         var notificationsMng:NotificationsMng = InstanceMng.getNotificationsMng();
         var pos:int;
         if((pos = item.positionIndex) >= sequence.length)
         {
            pos = 0;
         }
         if(item.getTimeLeft() > 0)
         {
            notification = notificationsMng.createNotificationMisteryGiftOpenedTooEarly();
            notificationsMng.guiOpenNotificationMessage(notification,false);
            return false;
         }
         rewardSku = "" + sequence[pos];
         reward = InstanceMng.getRuleMng().createRewardObjectFromMisteryRewardSku(rewardSku);
         item.positionIndex = (pos + 1) % sequence.length;
         item.setTimeLeft(InstanceMng.getSettingsDefMng().mSettingsDef.getMysteryGiftActionTime() * 60 * 60 * 1000);
         if(reward.getRewardType() == "item")
         {
            InstanceMng.getItemsMng().applyReward(reward);
         }
         notificationsMng.guiOpenTradeInPopup("pending",reward,true);
         return true;
      }
   }
}
