package com.dchoc.game.controller.gui
{
   import com.dchoc.game.controller.notifications.Notification;
   import com.dchoc.game.controller.notifications.NotificationsMng;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.view.dc.mng.ViewMngrGame;
   import com.dchoc.toolkit.utils.def.DCDef;
   
   public class GUIControllerSolarSystem extends GUIController
   {
       
      
      public function GUIControllerSolarSystem()
      {
         super();
      }
      
      override protected function childrenCreate() : void
      {
         setViewMng(InstanceMng.getFlowStatePlanet().viewMngGet() as ViewMngrGame);
         super.childrenCreate();
      }
      
      override protected function notifyPopup(e:Object, checkRetardedIf:Boolean = true) : Boolean
      {
         var returnValue:Boolean = false;
         if(checkIfNeedsToCallServer(checkRetardedIf,e) == true)
         {
            return true;
         }
         return super.notifyPopup(e,checkRetardedIf);
      }
      
      override public function checkIfOperationIsPossible(def:DCDef, trans:Transaction, isUpgradingOp:Boolean = false, isPremiumOp:Boolean = false, checkSiloCapacity:Boolean = true) : Notification
      {
         var obsLevelRequired:int = 0;
         var returnValue:Notification = null;
         var obsLevel:Number = InstanceMng.getWorld().itemsGetObservatoryLevel();
         var profileLogin:Profile;
         var maxCoinsCapacity:Number = (profileLogin = InstanceMng.getUserInfoMng().getProfileLogin()).getCoinsCapacity();
         var maxMineralsCapacity:Number = profileLogin.getMineralsCapacity();
         var notificationsMng:NotificationsMng = InstanceMng.getNotificationsMng();
         if(def != null)
         {
            obsLevelRequired = getLevelRequiredByItemDef(def,isUpgradingOp);
            if(obsLevel < obsLevelRequired - 1)
            {
               return notificationsMng.createNotificationNotEnoughObservatoryLevel("labs_observatory",obsLevelRequired,def.mSku);
            }
            if(obsLevelRequired == -1)
            {
               return notificationsMng.createNotificationUserAlreadyHasAllColonies();
            }
            if(trans != null)
            {
               if(maxCoinsCapacity < Math.abs(trans.getTransCoins()))
               {
                  returnValue = notificationsMng.createNotificationNotEnoughRoomInBanks();
               }
               if(maxMineralsCapacity < Math.abs(trans.getTransMinerals()))
               {
                  returnValue = notificationsMng.createNotificationNotEnoughRoomInSilos();
               }
            }
            else
            {
               returnValue = notificationsMng.createNotificationNullTransaction();
            }
         }
         else
         {
            returnValue = notificationsMng.createNotificationNullWIO();
         }
         return returnValue;
      }
      
      override protected function guiGetViewSku() : String
      {
         return "viewsSolarSystem";
      }
   }
}
