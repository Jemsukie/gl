package com.dchoc.game.controller.shop
{
   import com.dchoc.game.controller.entry.Entry;
   import com.dchoc.game.controller.entry.EntryFactory;
   import com.dchoc.game.controller.notifications.Notification;
   import com.dchoc.game.controller.notifications.NotificationsMng;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.rule.BuyResourcesBoxDef;
   import com.dchoc.game.model.rule.SpyCapsulesShopDef;
   import com.dchoc.game.model.unit.FireWorksMng;
   import com.dchoc.game.model.unit.defs.DroidDef;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.view.facade.UIFacade;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   
   public class ShopsDrawer extends DCComponent
   {
       
      
      private var mResourcesPopup:DCIPopup;
      
      private var mResourcesDefs:Vector.<BuyResourcesBoxDef>;
      
      public function ShopsDrawer()
      {
         super();
      }
      
      override protected function unloadDo() : void
      {
         this.resourcesUnload();
      }
      
      public function openChipsPopup() : DCIPopup
      {
         var popup:DCIPopup = null;
         if(InstanceMng.getPlatformSettingsDefMng().getUsePlatformCreditsPopup())
         {
            InstanceMng.getApplication().setToWindowedMode();
            InstanceMng.getUserDataMng().openCreditsPopup();
         }
         else
         {
            popup = InstanceMng.getUIFacade().getPopupFactory().getChipsPopup();
            InstanceMng.getUIFacade().enqueuePopup(popup);
            popup.setIsStackable(true);
         }
         return popup;
      }
      
      public function openBuySpyCapsulesPopup() : DCIPopup
      {
         var uiFacade:UIFacade = InstanceMng.getUIFacade();
         var popup:DCIPopup = uiFacade.getPopupFactory().getBuySpyCapsulesPopup();
         uiFacade.enqueuePopup(popup);
         return popup;
      }
      
      public function spyCapsulesNotifyPurchaseAccepted(id:int) : void
      {
         var spyCapsShopDef:SpyCapsulesShopDef = null;
         var entry:Entry = null;
         var transaction:Transaction = null;
         var o:Object = null;
         var defs:Vector.<DCDef> = InstanceMng.getSpyCapsulesShopDefMng().getDefs();
         if(defs != null && id > -1 && id < defs.length)
         {
            entry = (spyCapsShopDef = defs[id] as SpyCapsulesShopDef).getEntry();
            transaction = new Transaction();
            transaction = entry.toTransaction(transaction);
            (o = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NOTIFY_BUY_SPY_CAPSULES")).transaction = transaction;
            o.shopSku = spyCapsShopDef.mSku;
            o.phase = "OUT";
            o.button = "EventYesButtonPressed";
            InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o,true);
         }
      }
      
      public function openBuyColonyPopup(e:Object) : void
      {
         var popup:DCIPopup = null;
         popup = InstanceMng.getUIFacade().getPopupFactory().getBuyColonyPopup(e);
         InstanceMng.getUIFacade().enqueuePopup(popup);
      }
      
      public function openColonyBoughtPopup(e:Object) : void
      {
         var popup:DCIPopup = null;
         popup = InstanceMng.getUIFacade().getPopupFactory().getColonyBoughtPopup(e);
         InstanceMng.getUIFacade().enqueuePopup(popup);
      }
      
      public function openSelectColonyPopup(e:Object) : void
      {
         var popup:DCIPopup = InstanceMng.getUIFacade().getPopupFactory().getSelectColonyPopup(e);
         InstanceMng.getUIFacade().enqueuePopup(popup);
      }
      
      public function openBuyWorkerPopup() : void
      {
         var uiFacade:UIFacade = null;
         var popup:DCIPopup = null;
         var notification:Notification = null;
         var workerDef:DroidDef = InstanceMng.getDroidDefMng().getCurrentDroidDef();
         if(workerDef != null)
         {
            popup = (uiFacade = InstanceMng.getUIFacade()).getPopupFactory().getBuyWorkerPopup(workerDef);
            uiFacade.enqueuePopup(popup);
         }
         else
         {
            notification = InstanceMng.getNotificationsMng().createNotificationMaxAmountOfWorkersReached();
            InstanceMng.getNotificationsMng().guiOpenNotificationMessage(notification);
         }
      }
      
      public function buyWorkerPopupOnClickOnInvests() : void
      {
         if(Config.useInvests())
         {
            InstanceMng.getInvestMng().openInvestsPopupDependingOnSituation();
         }
      }
      
      public function buyWorkerPopupOnClickOnHireWorker(workerDef:DroidDef, useInvests:Boolean) : void
      {
         var oldPackage:Object = null;
         var transType:String = useInvests ? "typeInvest" : "typeStandard";
         var transaction:Transaction;
         if((transaction = InstanceMng.getRuleMng().getTransactionDroidBuy(workerDef,transType)) != null)
         {
            if(transaction.performAllTransactions())
            {
               InstanceMng.getUIFacade().closePopupById("PopupBuyWorker");
               InstanceMng.getUserDataMng().updateProfile_buyDroid(workerDef.mSku,transaction);
               InstanceMng.getTargetMng().updateProgress("buyDroid",1);
               this.buyWorkerPerformOps(1);
            }
            if((oldPackage = transaction.getTransInfoPackage()) != null)
            {
               InstanceMng.getGUIControllerPlanet().notify(oldPackage);
            }
         }
      }
      
      public function buyWorkerPerformOps(amount:int = 1) : void
      {
         InstanceMng.getUserInfoMng().getProfileLogin().addDroids(amount);
         InstanceMng.getUserInfoMng().getProfileLogin().addMaxDroidsAmount(amount);
         InstanceMng.getDroidDefMng().upgradeCurrentDroidDef();
         InstanceMng.getMapControllerPlanet().centerCameraInHQ(2,InstanceMng.getGUIControllerPlanet(),"NotifyDroidsCreateADroidInHQ");
         FireWorksMng.getInstance().showFireworks(5000);
      }
      
      public function openShowUnitInfoPopup(unitSku:String) : void
      {
         var uiFacade:UIFacade = InstanceMng.getUIFacade();
         var popup:DCIPopup = uiFacade.getPopupFactory().getShowUnitInfoPopup(unitSku);
         uiFacade.enqueuePopup(popup);
      }
      
      private function resourcesUnload() : void
      {
         this.resourcesClosePopup();
         this.mResourcesDefs = null;
      }
      
      private function resourcesCalculateDefs(currencyId:int, deleteNotValidEntries:Boolean) : void
      {
         var def:BuyResourcesBoxDef = null;
         var i:int = 0;
         var cost:Number = NaN;
         var lastCost:* = NaN;
         if(this.mResourcesDefs == null)
         {
            this.mResourcesDefs = new Vector.<BuyResourcesBoxDef>(0);
         }
         else
         {
            this.mResourcesDefs.length = 0;
         }
         var defs:Vector.<DCDef> = InstanceMng.getBuyResourcesBoxDefMng().getDefs();
         var length:int = int(defs.length);
         for(i = 0; i < length; )
         {
            if((def = defs[i] as BuyResourcesBoxDef).getCurrencyId() == currencyId)
            {
               this.mResourcesDefs.push(def);
            }
            i++;
         }
         this.mResourcesDefs.sort(this.resourcesSortDefs);
         if(deleteNotValidEntries)
         {
            if((length = int(this.mResourcesDefs.length)) > 1)
            {
               if((lastCost = this.resourcesGetCostById(length - 1)) == 0)
               {
                  this.mResourcesDefs.length = 0;
               }
               else
               {
                  for(i = length - 2; i > -1; )
                  {
                     def = this.mResourcesDefs[i] as BuyResourcesBoxDef;
                     if((cost = this.resourcesGetCostByDef(def)) == lastCost)
                     {
                        this.mResourcesDefs.splice(i,1);
                     }
                     else
                     {
                        lastCost = cost;
                     }
                     i--;
                  }
               }
            }
         }
      }
      
      private function resourcesSortDefs(a:BuyResourcesBoxDef, b:BuyResourcesBoxDef) : int
      {
         var returnValue:int = 0;
         var diff:Number;
         if((diff = a.getAmount() - b.getAmount()) > 0)
         {
            returnValue = 1;
         }
         else if(diff < 0)
         {
            returnValue = -1;
         }
         return returnValue;
      }
      
      private function resourcesGetDefById(id:int) : BuyResourcesBoxDef
      {
         var returnValue:BuyResourcesBoxDef = null;
         if(this.mResourcesDefs != null && id > -1 && id < this.mResourcesDefs.length)
         {
            returnValue = this.mResourcesDefs[id];
         }
         return returnValue;
      }
      
      public function resourcesGetEntriesAmount() : int
      {
         return this.mResourcesDefs.length;
      }
      
      public function resourcesGetEntryToGiveById(id:int) : Entry
      {
         var currencyId:int = 0;
         var amount:Number = NaN;
         var returnValue:Entry = null;
         var resourceDef:BuyResourcesBoxDef = this.resourcesGetDefById(id);
         if(resourceDef != null)
         {
            currencyId = resourceDef.getCurrencyId();
            amount = this.resourcesGetAmountToGiveById(id);
            if(currencyId == 2)
            {
               returnValue = EntryFactory.createMineralsSingleEntry(amount);
            }
            else
            {
               returnValue = EntryFactory.createCoinsSingleEntry(amount);
            }
         }
         return returnValue;
      }
      
      public function resourcesGetEntryToPayById(id:int) : Entry
      {
         var cost:Number = this.resourcesGetCostById(id);
         return EntryFactory.createCashSingleEntry(cost,true);
      }
      
      public function resourcesGetAmountToGiveById(id:int) : Number
      {
         var resourceDef:BuyResourcesBoxDef = this.resourcesGetDefById(id);
         return this.resourcesGetAmountToGiveByDef(resourceDef);
      }
      
      public function resourcesGetCostById(id:int) : Number
      {
         var resourceDef:BuyResourcesBoxDef = this.resourcesGetDefById(id);
         return this.resourcesGetCostByDef(resourceDef);
      }
      
      private function resourcesGetAmountToGiveByDef(resourceDef:BuyResourcesBoxDef) : Number
      {
         var currencyId:int = 0;
         var percent:Number = NaN;
         var resourcesLeftToMax:Number = NaN;
         var maxCapacity:Number = NaN;
         var currResources:Number = NaN;
         var returnValue:Number = 0;
         if(resourceDef != null)
         {
            currencyId = resourceDef.getCurrencyId();
            percent = resourceDef.getAmount();
            if(currencyId == 2)
            {
               maxCapacity = InstanceMng.getUserInfoMng().getProfileLogin().getMineralsCapacity();
               currResources = InstanceMng.getUserInfoMng().getProfileLogin().getMinerals();
            }
            else
            {
               maxCapacity = InstanceMng.getUserInfoMng().getProfileLogin().getCoinsCapacity();
               currResources = InstanceMng.getUserInfoMng().getProfileLogin().getCoins();
            }
            resourcesLeftToMax = maxCapacity - currResources;
            returnValue = Math.floor(resourcesLeftToMax * (percent / 100));
         }
         return returnValue;
      }
      
      private function resourcesGetCostByDef(def:BuyResourcesBoxDef) : Number
      {
         var amount:Number = this.resourcesGetAmountToGiveByDef(def);
         return amount < 0 ? 0 : Math.floor(InstanceMng.getRuleMng().calculateResourcesPrice(amount));
      }
      
      private function resourcesOpenPopup(currencyId:int, deleteNotValidEntries:Boolean) : DCIPopup
      {
         var notification:Notification = null;
         var notificationsMng:NotificationsMng = null;
         var uiFacade:UIFacade = null;
         this.resourcesCalculateDefs(currencyId,deleteNotValidEntries);
         var entriesAmount:int;
         if((entriesAmount = this.resourcesGetEntriesAmount()) == 0)
         {
            notificationsMng = InstanceMng.getNotificationsMng();
            if(currencyId == 1)
            {
               notification = notificationsMng.createNotificationBanksAreFull();
            }
            else
            {
               notification = notificationsMng.createNotificationSilosAreFull();
            }
            notificationsMng.guiOpenNotificationMessage(notification);
         }
         else
         {
            uiFacade = InstanceMng.getUIFacade();
            if(currencyId == 1)
            {
               this.mResourcesPopup = uiFacade.getPopupFactory().getBuyCoinsPopup();
            }
            else
            {
               this.mResourcesPopup = uiFacade.getPopupFactory().getBuyMineralsPopup();
            }
            uiFacade.enqueuePopup(this.mResourcesPopup);
         }
         return this.mResourcesPopup;
      }
      
      public function resourcesOpenBuyCoinsPopup() : DCIPopup
      {
         return this.resourcesOpenPopup(1,true);
      }
      
      public function resourcesOpenBuyMineralsPopup() : DCIPopup
      {
         return this.resourcesOpenPopup(2,true);
      }
      
      public function resourcesClosePopup() : void
      {
         if(this.mResourcesPopup != null)
         {
            InstanceMng.getUIFacade().closePopup(this.mResourcesPopup);
            this.mResourcesDefs = null;
         }
      }
      
      public function resourcesNotifyPurchaseAccepted(id:int) : void
      {
         var payTransaction:Transaction = null;
         var transAddResource:Transaction = null;
         var type:String = null;
         var addMinerals:* = false;
         var coins:int = 0;
         var minerals:int = 0;
         var entryToPay:Entry = this.resourcesGetEntryToPayById(id);
         var entryToGive:Entry = this.resourcesGetEntryToGiveById(id);
         if(entryToPay != null && entryToGive != null)
         {
            payTransaction = entryToPay.toTransaction();
            transAddResource = entryToGive.toTransaction();
            addMinerals = (type = entryToGive.getKey()) == "minerals";
            this.resourcesClosePopup();
            if(InstanceMng.getGUIController().flowCheckIfEnoughCash(payTransaction,null,false))
            {
               payTransaction.performAllTransactions();
               transAddResource.performAllTransactions();
               if(addMinerals)
               {
                  InstanceMng.getUserDataMng().updateProfile_exchangeCashToMinerals(-payTransaction.getTransCash(),transAddResource.getTransMinerals());
               }
               else
               {
                  InstanceMng.getUserDataMng().updateProfile_exchangeCashToCoins(-payTransaction.getTransCash(),transAddResource.getTransCoins());
               }
            }
         }
      }
   }
}
