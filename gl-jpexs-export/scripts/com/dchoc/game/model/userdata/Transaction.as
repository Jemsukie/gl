package com.dchoc.game.model.userdata
{
   import com.dchoc.game.controller.entry.CompositeEntry;
   import com.dchoc.game.controller.entry.Entry;
   import com.dchoc.game.controller.entry.EntryFactory;
   import com.dchoc.game.controller.notifications.Notification;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.rule.RuleMng;
   import com.dchoc.game.model.items.ItemObject;
   import com.dchoc.game.model.items.ItemsDef;
   import com.dchoc.game.model.items.ItemsDefMng;
   import com.dchoc.game.model.items.ItemsMng;
   import com.dchoc.game.model.items.RewardObject;
   import com.dchoc.game.model.unit.ParticleMng;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.utils.anticheat.SecureBoolean;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.game.utils.anticheat.SecureString;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import flash.utils.Dictionary;
   
   public class Transaction extends DCComponent
   {
      
      public static const TRANS_TYPE_STANDARD:String = "typeStandard";
      
      public static const TRANS_TYPE_INVEST:String = "typeInvest";
       
      
      private var mTransCash:SecureNumber;
      
      private var mTransCoins:SecureNumber;
      
      private var mTransMinerals:SecureNumber;
      
      private var mTransBadges:SecureNumber;
      
      private var mTransXp:SecureNumber;
      
      private var mTransScore:SecureNumber;
      
      private var mTransDroids:SecureInt;
      
      private var mTransAmountOwned:SecureInt;
      
      private var mTransAmountAllowed:SecureInt;
      
      private var mTransItems:Dictionary;
      
      private var mTransRewardObject:RewardObject;
      
      private var mTransRewardObjectAmount:SecureInt;
      
      private var mWorldItemObject:WorldItemObject;
      
      private var mWorldItemDef:WorldItemDef;
      
      private var mTransEvent:SecureString;
      
      private var mProfile:Profile;
      
      private var mParticlePosInQueue:int;
      
      private var mInfoPackage:Object;
      
      public var mDifferenceCash:SecureNumber;
      
      public var mDifferenceCoins:SecureNumber;
      
      public var mDifferenceMinerals:SecureNumber;
      
      private var mDifferenceBadges:SecureNumber;
      
      public var mDifferenceDroids:SecureInt;
      
      public var mDifferenceAmount:SecureInt;
      
      public var mDifferencesItemsAmount:Dictionary;
      
      public var mDifferenceRewardObjectAmount:SecureInt;
      
      private var mLogEvents:Array;
      
      private var mResponseObject:Object;
      
      private var mServerResponseReceived:SecureBoolean;
      
      private var mTransTime:SecureNumber;
      
      private var mTransCashToPay:SecureInt;
      
      private var mTransCashToExchange:SecureInt;
      
      private var mTransCoinsLeftToPay:SecureInt;
      
      private var mTransDroidsCash:SecureInt;
      
      private var mTransMineralsLeftToPay:SecureInt;
      
      private var mTransBadgesLeftToPay:SecureInt;
      
      private var mPayableCoins:SecureInt;
      
      private var mPayableMinerals:SecureInt;
      
      private var mPayableBadges:SecureInt;
      
      private var mPayableCash:SecureInt;
      
      private var mTransPaymentObject:Object;
      
      private var mHasBeenAlreadyPerformed:SecureBoolean;
      
      private var mApplyOnProfile:SecureBoolean;
      
      private var mIsDevolution:SecureBoolean;
      
      public var mProfileImageCash:SecureNumber;
      
      public var mProfileImageCoins:SecureNumber;
      
      public var mProfileImageMinerals:SecureNumber;
      
      public var mProfileImageBadges:SecureNumber;
      
      public var mProfileImageXp:SecureNumber;
      
      public var mProfileImageScore:SecureNumber;
      
      public var mClientDebugInfo:String = null;
      
      private var mDroidsWillBePayedWithCash:SecureBoolean;
      
      private var mCheckServerResponseEnabled:SecureBoolean;
      
      private var mTransWIOItems:Vector.<WorldItemObject>;
      
      private var mTransType:SecureString;
      
      private var mCheckItemLimit:SecureBoolean;
      
      private var mItemSkusWithOffer:Array = null;
      
      private var mCloseOpenedPopups:Boolean = true;
      
      public function Transaction()
      {
         mTransCash = new SecureNumber("Transaction.mTransCash");
         mTransCoins = new SecureNumber("Transaction.mTransCoins");
         mTransMinerals = new SecureNumber("Transaction.mTransMinerals");
         mTransBadges = new SecureNumber("Transaction.mTransBadges");
         mTransXp = new SecureNumber("Transaction.mTransXp");
         mTransScore = new SecureNumber("Transaction.mTransScore");
         mTransDroids = new SecureInt("Transaction.mTransDroids");
         mTransAmountOwned = new SecureInt("Transaction.mTransAmountOwned");
         mTransAmountAllowed = new SecureInt("Transaction.mTransAmountAllowed");
         mTransRewardObjectAmount = new SecureInt("Transaction.mTransRewardObjectAmount");
         mTransEvent = new SecureString("Transaction.mTransEvent");
         mDifferenceCash = new SecureNumber("Transaction.mDifferenceCash");
         mDifferenceCoins = new SecureNumber("Transaction.mDifferenceCoins");
         mDifferenceMinerals = new SecureNumber("Transaction.mDifferenceMinerals");
         mDifferenceBadges = new SecureNumber("Transaction.mDifferenceBadges");
         mDifferenceDroids = new SecureInt("Transaction.mDifferenceDroids");
         mDifferenceAmount = new SecureInt("Transaction.mDifferenceAmount");
         mDifferenceRewardObjectAmount = new SecureInt("Transaction.mDifferenceRewardObjectAmount");
         mServerResponseReceived = new SecureBoolean("Transaction.mServerResponseReceived");
         mTransTime = new SecureNumber("Transaction.mTransTime");
         mTransCashToPay = new SecureInt("Transaction.mTransCashToPay");
         mTransCashToExchange = new SecureInt("Transaction.mTransCashToExchange");
         mTransCoinsLeftToPay = new SecureInt("Transaction.mTransCoinsLeftToPay");
         mTransDroidsCash = new SecureInt("Transaction.mTransDroidsCash");
         mTransMineralsLeftToPay = new SecureInt("Transaction.mTransMineralsLeftToPay");
         mTransBadgesLeftToPay = new SecureInt("Transaction.mTransBadgesLeftToPay");
         mPayableCoins = new SecureInt("Transaction.mPayableCoins");
         mPayableMinerals = new SecureInt("Transaction.mPayableMinerals");
         mPayableBadges = new SecureInt("Transaction.mPayableBadges");
         mPayableCash = new SecureInt("Transaction.mPayableCash");
         mHasBeenAlreadyPerformed = new SecureBoolean("Transaction.mHasBeenAlreadyPerformed");
         mApplyOnProfile = new SecureBoolean("Transaction.mApplyOnProfile");
         mIsDevolution = new SecureBoolean("Transaction.mIsDevolution");
         mProfileImageCash = new SecureNumber("Transaction.mIsDevolution");
         mProfileImageCoins = new SecureNumber("Transaction.mIsDevolution");
         mProfileImageMinerals = new SecureNumber("Transaction.mIsDevolution");
         mProfileImageBadges = new SecureNumber("Transaction.mIsDevolution");
         mProfileImageXp = new SecureNumber("Transaction.mIsDevolution");
         mProfileImageScore = new SecureNumber("Transaction.mIsDevolution");
         mDroidsWillBePayedWithCash = new SecureBoolean("Transaction.mDroidsWillBePayedWithCash");
         mCheckServerResponseEnabled = new SecureBoolean("Transaction.mCheckServerResponseEnabled");
         mTransType = new SecureString("Transaction.mTransType","typeStandard");
         mCheckItemLimit = new SecureBoolean("Transaction.mCheckItemLimit",true);
         super();
         this.initVars();
      }
      
      private function initVars() : void
      {
         this.mProfile = InstanceMng.getUserInfoMng().getProfileLogin();
         this.mTransCash.value = 0;
         this.mTransCoins.value = 0;
         this.mTransMinerals.value = 0;
         this.mTransBadges.value = 0;
         this.mTransXp.value = 0;
         this.mTransDroids.value = 0;
         this.mTransEvent.value = "";
         this.mDifferenceCash.value = 0;
         this.mDifferenceCoins.value = 0;
         this.mDifferenceMinerals.value = 0;
         this.mDifferenceBadges.value = 0;
         this.mTransTime.value = -1;
         this.mTransScore.value = 0;
         this.mTransAmountOwned.value = -1;
         this.mTransAmountAllowed.value = -1;
         this.mTransItems = null;
         this.mTransRewardObject = null;
         this.mTransRewardObjectAmount.value = 0;
         this.mWorldItemObject = null;
         this.mWorldItemDef = null;
         this.mInfoPackage = null;
         this.mIsDevolution.value = false;
         this.mDroidsWillBePayedWithCash.value = false;
         this.mCheckServerResponseEnabled.value = true;
         this.mTransPaymentObject = {};
         this.mTransWIOItems = new Vector.<WorldItemObject>(0);
         this.mCheckItemLimit.value = true;
         this.reset();
      }
      
      public function reset() : void
      {
         this.mServerResponseReceived.value = false;
         this.mHasBeenAlreadyPerformed.value = false;
         this.mParticlePosInQueue = 0;
         this.mApplyOnProfile.value = true;
         this.mIsDevolution.value = false;
         this.mInfoPackage = null;
         this.mClientDebugInfo = null;
         this.mDifferencesItemsAmount = null;
         this.mItemSkusWithOffer = null;
      }
      
      public function getTransCash() : Number
      {
         return this.mTransCash.value;
      }
      
      public function getTransCoins() : Number
      {
         return this.mTransCoins.value;
      }
      
      public function getTransMinerals() : Number
      {
         return this.mTransMinerals.value;
      }
      
      public function getTransBadges() : Number
      {
         return this.mTransBadges.value;
      }
      
      public function getTransXp() : Number
      {
         return this.mTransXp.value;
      }
      
      public function getTransScore() : Number
      {
         return this.mTransScore.value;
      }
      
      public function getTransDroids() : int
      {
         return this.mTransDroids.value;
      }
      
      public function getTransWIO() : WorldItemObject
      {
         return this.mWorldItemObject;
      }
      
      public function getTransWIDef() : WorldItemDef
      {
         return this.mWorldItemDef;
      }
      
      public function getTransEvent() : String
      {
         return this.mTransEvent.value;
      }
      
      public function getTransProfile() : Profile
      {
         return this.mProfile;
      }
      
      public function getTransInfoPackage() : Object
      {
         return this.mInfoPackage;
      }
      
      public function getTransItems() : Dictionary
      {
         return this.mTransItems;
      }
      
      public function getTransRewardObject() : RewardObject
      {
         return this.mTransRewardObject;
      }
      
      public function getTransResponseToValue() : Object
      {
         return this.mResponseObject;
      }
      
      public function getTransAmountOwned() : int
      {
         return this.mTransAmountOwned.value;
      }
      
      public function getTransAmountAllowed() : int
      {
         return this.mTransAmountAllowed.value;
      }
      
      public function getTransHasReceivedServerResponse() : Boolean
      {
         return this.mServerResponseReceived.value;
      }
      
      public function getTransTime() : Number
      {
         return this.mTransTime.value;
      }
      
      public function getTransPaymentObject() : Object
      {
         return this.mTransPaymentObject;
      }
      
      public function getTransCashToPay() : int
      {
         return this.mTransCashToPay.value;
      }
      
      public function getTransCashToExchange() : int
      {
         return this.mTransCashToExchange.value;
      }
      
      public function getTransType() : String
      {
         return this.mTransType.value;
      }
      
      public function getApplyOnProfile() : Boolean
      {
         return this.mApplyOnProfile.value;
      }
      
      public function getPayableCurrency(currencyId:int) : Number
      {
         var returnValue:Number = NaN;
         switch(currencyId)
         {
            case 0:
               returnValue = this.mPayableCash.value;
               break;
            case 1:
               returnValue = this.mPayableCoins.value;
               break;
            case 2:
               returnValue = this.mPayableMinerals.value;
               break;
            case 8:
               returnValue = this.mPayableBadges.value;
         }
         return returnValue;
      }
      
      public function getTransCurrencyLeftToPay(currencyId:int) : Number
      {
         var returnValue:Number = NaN;
         switch(currencyId - 1)
         {
            case 0:
               returnValue = this.mTransCoinsLeftToPay.value;
               break;
            case 1:
               returnValue = this.mTransMineralsLeftToPay.value;
               break;
            case 7:
               returnValue = this.mTransBadgesLeftToPay.value;
         }
         return returnValue;
      }
      
      public function getTransHasBeenPerformed() : Boolean
      {
         return this.mHasBeenAlreadyPerformed.value;
      }
      
      public function isDevolution() : Boolean
      {
         return this.mIsDevolution.value;
      }
      
      public function getDroidsWillBePayedWithCash() : Boolean
      {
         return this.mDroidsWillBePayedWithCash.value;
      }
      
      public function getTransDroidsCash() : int
      {
         return this.mTransDroidsCash.value;
      }
      
      public function getLogicCashToPay() : int
      {
         return this.mTransCashToPay.value + this.mTransDroidsCash.value;
      }
      
      public function getWIOItemsInvolved() : Vector.<WorldItemObject>
      {
         return this.mTransWIOItems;
      }
      
      public function resetTransCashToPay() : void
      {
         this.mTransCash.value = -this.mTransCashToExchange.value;
         this.mTransCashToPay.value = this.mTransCashToExchange.value;
      }
      
      public function setTransCash(cash:Number) : void
      {
         this.mTransCash.value = cash;
      }
      
      public function setTransCoins(coins:Number) : void
      {
         this.mTransCoins.value = int(Math.floor(coins));
      }
      
      public function setTransMinerals(minerals:Number) : void
      {
         this.mTransMinerals.value = int(minerals);
      }
      
      public function setTransBadges(badges:Number) : void
      {
         this.mTransBadges.value = int(badges);
      }
      
      public function setTransXp(xp:Number) : void
      {
         var xpAsInt:Number = Math.floor(xp * 1);
         this.mTransXp.value = xpAsInt / 1;
      }
      
      public function setTransScore(value:Number) : void
      {
         this.mTransScore.value = value;
      }
      
      public function setTransDroids(droids:int) : void
      {
         this.mTransDroids.value = droids;
      }
      
      public function setTransAmountOwned(value:int) : void
      {
         this.mTransAmountOwned.value = value;
      }
      
      public function setTransAmountAllowed(value:int) : void
      {
         this.mTransAmountAllowed.value = value;
      }
      
      public function setWorldItemObject(wio:WorldItemObject) : void
      {
         this.mWorldItemObject = wio;
         this.mWorldItemDef = this.mWorldItemObject.mDef;
      }
      
      public function setWorldItemDef(worldItemDef:WorldItemDef) : void
      {
         this.mWorldItemDef = worldItemDef;
      }
      
      public function setTransEvent(transactionEvent:String) : void
      {
         this.mTransEvent.value = transactionEvent;
      }
      
      public function setPositionInQueue(value:int) : void
      {
         this.mParticlePosInQueue = value;
      }
      
      public function setTransInfoPackage(value:Object) : void
      {
         this.mInfoPackage = value;
      }
      
      public function setTransProfile(value:Profile) : void
      {
         this.mProfile = value;
      }
      
      public function setTransResponseToValue(value:Object) : void
      {
         this.mResponseObject = value;
      }
      
      public function setTransType(type:String) : void
      {
         this.mTransType.value = type;
      }
      
      public function addTransItem(sku:String, amount:Number, usesChips:Boolean = true) : void
      {
         if(sku == "" || amount == 0)
         {
            return;
         }
         if(this.mTransItems == null)
         {
            this.mTransItems = new Dictionary();
         }
         if(this.mTransItems[sku] == null)
         {
            this.mTransItems[sku] = {};
            this.mTransItems[sku]["amount"] = 0;
            this.mTransItems[sku]["usesChips"] = usesChips;
         }
         this.mTransItems[sku]["amount"] += amount;
      }
      
      public function setTransRewardObject(object:RewardObject, amount:int) : void
      {
         this.mTransRewardObject = object;
         this.mTransRewardObjectAmount.value = amount;
      }
      
      public function setTransHasReceivedServerResponse(value:Boolean) : void
      {
         this.mServerResponseReceived.value = value;
      }
      
      public function setTransTime(value:Number) : void
      {
         this.mTransTime.value = value;
      }
      
      public function setTransHasBeenPerformed(value:Boolean) : void
      {
         this.mHasBeenAlreadyPerformed.value = value;
      }
      
      public function setApplyOnProfile(value:Boolean) : void
      {
         this.mApplyOnProfile.value = value;
      }
      
      public function setIsDevolution(value:Boolean) : void
      {
         this.mIsDevolution.value = value;
      }
      
      public function setTransDroidsCash(value:int) : void
      {
         this.mTransDroidsCash.value = value;
      }
      
      public function setWIOItemsInvolved(value:Vector.<WorldItemObject>) : void
      {
         this.mTransWIOItems = value;
      }
      
      public function setCloseOpenedPopups(value:Boolean) : void
      {
         this.mCloseOpenedPopups = value;
      }
      
      public function performAllTransactions(launchParticles:Boolean = true) : Boolean
      {
         var returnValue:Boolean = true;
         this.computeAmountsLeftValues();
         if(!InstanceMng.getRole().hasToBeChargedOnTransactions())
         {
            DCDebug.trace("ATTENTION, TRANSACTION EXECUTED IN EDITOR MODE; NO CHARGES APPLIED");
         }
         else if(this.mProfile != InstanceMng.getUserInfoMng().getProfileLogin())
         {
            this.processResourcesNoProfileLogin();
            this.performTransactionCash();
            this.performTransactionCoins(launchParticles);
            this.performTransactionMinerals(launchParticles);
            this.performTransactionScore(launchParticles);
            this.performTransactionBadges();
            this.performTransactionItems();
            this.performTransactionRewardObject();
         }
         else if(this.checkIfEnoughResources())
         {
            this.performTransactionCash();
            this.performTransactionCoins(launchParticles);
            this.performTransactionMinerals(launchParticles);
            this.performTransactionScore(launchParticles);
            this.performTransactionBadges();
            this.performTransactionItems();
            this.performTransactionRewardObject();
         }
         else
         {
            returnValue = false;
         }
         this.fillTransactionLog(returnValue);
         this.setTransHasBeenPerformed(returnValue);
         return returnValue;
      }
      
      private function fillTransactionLog(success:Boolean) : void
      {
         if(this.mLogEvents == null)
         {
            this.mLogEvents = [];
         }
         var o:Object = {};
         o.success = success;
         o.diffCoins = this.mDifferenceCoins.value;
         o.diffCash = this.mDifferenceCash.value;
         o.diffMinerals = this.mDifferenceMinerals.value;
         o.diffBadges = this.mDifferenceBadges.value;
         o.diffDroids = this.mDifferenceDroids.value;
         o.diffItemsAmount = this.mDifferencesItemsAmount;
         this.mLogEvents[this.mLogEvents.length] = o;
      }
      
      public function getTransactionLog(index:int = -1) : Object
      {
         var returnValue:Object = null;
         if(this.mLogEvents != null)
         {
            if(index == -1)
            {
               index = this.mLogEvents.length - 1;
            }
            if(this.mLogEvents[index] != null)
            {
               returnValue = this.mLogEvents[index];
            }
         }
         return returnValue;
      }
      
      private function processResourcesNoProfileLogin() : void
      {
         var enoughCoins:* = this.mDifferenceCoins.value >= 0;
         var enoughMinerals:* = this.mDifferenceMinerals.value >= 0;
         var enoughBadges:* = this.mDifferenceBadges.value >= 0;
         if(!InstanceMng.getRole().hasToBeChargedOnTransactions())
         {
            DCDebug.trace("ATTENTION, TRANSACTION EXECUTED IN EDITOR MODE; NO CHARGES APPLIED");
         }
         else
         {
            if(!enoughCoins)
            {
               this.mTransCoins.value += Math.abs(this.mDifferenceCoins.value);
            }
            if(!enoughMinerals)
            {
               this.mTransMinerals.value += Math.abs(this.mDifferenceMinerals.value);
            }
            if(!enoughBadges)
            {
               this.mTransBadges.value += Math.abs(this.mDifferenceBadges.value);
            }
         }
      }
      
      public function checkEnoughItems() : Boolean
      {
         var itemObj:ItemObject = null;
         var itemSku:* = null;
         var enoughItems:* = false;
         var amount:int = 0;
         if(this.mTransItems == null)
         {
            return true;
         }
         for(itemSku in this.mTransItems)
         {
            if(itemSku != null && itemSku != "")
            {
               amount = int(this.mTransItems[itemSku]["amount"]);
               itemObj = InstanceMng.getItemsMng().getItemObjectBySku(itemSku);
               if(amount < 0 && itemObj.mDef.getChipsCost() > 0)
               {
                  enoughItems = itemObj.quantity >= Math.abs(amount);
                  if(!enoughItems)
                  {
                     return false;
                  }
               }
            }
         }
         return true;
      }
      
      public function checkIfValidAmount() : Boolean
      {
         var goldEventObj:Object = null;
         var returnValue:Boolean = true;
         var enoughAmount:* = this.mDifferenceAmount.value > 0;
         if(!enoughAmount)
         {
            goldEventObj = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NOTIFY_POPUP_OPEN_AMOUNT_FAIL",null,this.mWorldItemObject);
            goldEventObj.itemDef = this.mWorldItemDef;
            InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),goldEventObj,true);
            returnValue = false;
         }
         return returnValue;
      }
      
      public function checkIfOnlyCashTransaction() : Boolean
      {
         return this.mTransCash.value < 0;
      }
      
      public function checkIfEnoughResources(throwEvents:Boolean = true) : Boolean
      {
         var goldEventObj:Object = null;
         var droidsAndResourcesMissingObj:Object = null;
         var event:String = null;
         var notification:Notification = null;
         var returnValue:Boolean = true;
         var enoughCash:* = this.mDifferenceCash.value >= 0;
         var enoughCoins:* = this.mDifferenceCoins.value >= 0;
         var enoughMinerals:* = this.mDifferenceMinerals.value >= 0;
         var enoughBadges:* = this.mDifferenceBadges.value >= 0;
         var enoughDroids:* = this.mDifferenceDroids.value >= 0;
         var enoughAmount:* = this.mDifferenceAmount.value > 0;
         var enoughCapacity:Boolean = this.mProfile.getCoinsCapacity() >= Math.abs(this.mTransCoins.value) && this.mProfile.getMineralsCapacity() >= Math.abs(this.mTransMinerals.value) && this.mProfile.getBadgesCapacity() >= Math.abs(this.mTransBadges.value);
         var enoughItems:Boolean = this.checkEnoughItems();
         var enoughRewardObjectAmount:* = this.mDifferenceRewardObjectAmount.value >= 0;
         if(!InstanceMng.getRole().hasToBeChargedOnTransactions())
         {
            DCDebug.trace("ATTENTION, TRANSACTION EXECUTED IN EDITOR MODE; NO CHARGES APPLIED");
         }
         else
         {
            if(!this.checkIfValidAmount())
            {
               return false;
            }
            if(!enoughCoins || !enoughMinerals || !enoughBadges || !enoughItems)
            {
               if(throwEvents)
               {
                  if(!enoughCapacity)
                  {
                     if(this.mDifferenceCoins.value < 0)
                     {
                        notification = InstanceMng.getNotificationsMng().createNotificationNotEnoughRoomInBanks();
                     }
                     else
                     {
                        notification = InstanceMng.getNotificationsMng().createNotificationNotEnoughRoomInSilos();
                     }
                     InstanceMng.getNotificationsMng().guiOpenNotificationMessage(notification,false);
                  }
                  else
                  {
                     if(enoughDroids)
                     {
                        event = "NotifyResourcesNeeded";
                     }
                     else
                     {
                        event = "NotifyResourcesAndDroidNeeded";
                     }
                     if(enoughCoins && enoughMinerals && enoughBadges && !enoughItems)
                     {
                        if(this.getLogicCashToPay() == 0)
                        {
                           return false;
                        }
                     }
                     (droidsAndResourcesMissingObj = InstanceMng.getGUIController().createNotifyEvent("EventNotEnoughResources",event,InstanceMng.getGUIController(),this.mWorldItemObject,null,null,this.mWorldItemDef,this)).closeOpenedPopups = this.mCloseOpenedPopups;
                     InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),droidsAndResourcesMissingObj,true);
                     if(InstanceMng.getFlowStatePlanet().getCurrentRoleId() == 3)
                     {
                        InstanceMng.getUIFacade().getWarBarSpecial().popupShown = true;
                     }
                  }
               }
               return false;
            }
            if(!enoughDroids)
            {
               if(throwEvents)
               {
                  droidsAndResourcesMissingObj = InstanceMng.getGUIController().createNotifyEvent("EventNotEnoughResources","NotifyDroidNeeded",InstanceMng.getGUIController(),this.mWorldItemObject,null,null,this.mWorldItemDef,this);
                  InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),droidsAndResourcesMissingObj,true);
               }
               return false;
            }
            if(!enoughRewardObjectAmount)
            {
               if(throwEvents)
               {
                  (goldEventObj = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NOTIFY_POPUP_OPEN_AMOUNT_FAIL",null,this.mWorldItemObject)).error = InstanceMng.getNotificationsMng().createNotificationNotEnoughItems();
                  InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),goldEventObj,true);
               }
               return false;
            }
         }
         return returnValue;
      }
      
      public function performTransactionCash() : void
      {
         this.mProfileImageCash.value = this.mProfile.getCash();
         if(this.mTransCash.value != 0 && this.mApplyOnProfile.value)
         {
            this.mProfile.addCash(this.mTransCash.value);
         }
      }
      
      public function performTransactionCoins(launchParticles:Boolean) : void
      {
         this.mProfileImageCoins.value = this.mProfile.getCoins();
         if(this.mTransCoins.value != 0)
         {
            this.mParticlePosInQueue++;
            if(this.mApplyOnProfile.value)
            {
               this.mProfile.addCoins(this.mTransCoins.value);
            }
            if(this.mWorldItemObject != null && launchParticles)
            {
               ParticleMng.launchParticle(1,this.mTransCoins.value,this.mWorldItemObject,this.mParticlePosInQueue);
            }
         }
      }
      
      public function performTransactionMinerals(launchParticles:Boolean) : void
      {
         this.mProfileImageMinerals.value = this.mProfile.getMinerals();
         if(this.mTransMinerals.value != 0)
         {
            this.mParticlePosInQueue++;
            if(this.mApplyOnProfile.value)
            {
               this.mProfile.addMinerals(this.mTransMinerals.value);
            }
            if(this.mWorldItemObject != null && launchParticles)
            {
               ParticleMng.launchParticle(2,this.mTransMinerals.value,this.mWorldItemObject,this.mParticlePosInQueue);
            }
         }
      }
      
      public function performTransactionBadges() : void
      {
         this.mProfileImageBadges.value = this.mProfile.getBadges();
         if(this.mTransBadges.value != 0)
         {
            if(this.mApplyOnProfile.value)
            {
               this.mProfile.addBadges(this.mTransBadges.value);
            }
         }
      }
      
      public function performTransactionXp(launchParticles:Boolean) : void
      {
         var amountNumber:Number = NaN;
         var profile:Profile = null;
         var profileXp:Number = NaN;
         var profileXpAsInt:int = 0;
         var profileXpDecimals:Number = NaN;
         var amount:int = 0;
         this.mProfileImageXp.value = this.mProfile.getXp();
         if(this.mTransXp.value != 0)
         {
            this.mParticlePosInQueue++;
            amountNumber = this.mTransXp.value;
            profileXpDecimals = (profileXpAsInt = (profile = InstanceMng.getUserInfoMng().getProfileLogin()).getXp()) - profileXpAsInt;
            amountNumber += profileXpDecimals;
            amount = amountNumber;
            if(this.mApplyOnProfile.value)
            {
               this.mProfile.addXp(this.mTransXp.value);
            }
            if(this.mWorldItemObject != null && launchParticles)
            {
               ParticleMng.launchParticle(6,amount,this.mWorldItemObject,this.mParticlePosInQueue);
            }
         }
      }
      
      public function performTransactionScore(launchParticles:Boolean) : void
      {
         var score:Number = NaN;
         this.mProfileImageScore.value = this.mProfile.getScore();
         if(this.mTransScore.value == 0)
         {
            return;
         }
         if(this.mApplyOnProfile.value && this.mProfile != null)
         {
            this.mProfile.addScore(this.mTransScore.value);
         }
         if(this.mWorldItemObject != null && launchParticles)
         {
            score = InstanceMng.getRuleMng().getScoreDependingOnRole(this.mTransScore.value);
            ParticleMng.launchParticle(6,score,this.mWorldItemObject,++this.mParticlePosInQueue,0,0,true);
         }
      }
      
      public function performTransactionItems() : void
      {
         var sku:String = null;
         var item:ItemObject = null;
         if(this.mTransItems == null || !this.mApplyOnProfile.value)
         {
            return;
         }
         var i:* = 0;
         var amount:int = 0;
         var usesChips:Boolean = false;
         for(sku in this.mTransItems)
         {
            if(sku != null && sku != "")
            {
               amount = int(this.mTransItems[sku]["amount"]);
               usesChips = Boolean(this.mTransItems[sku]["usesChips"]);
               if(this.mWorldItemObject != null && this.mIsDevolution.value)
               {
                  for(i = amount; i > 0; )
                  {
                     InstanceMng.getItemsMng().getCollectibleItemsParticle(sku,this.mWorldItemObject.mViewCenterWorldX,this.mWorldItemObject.mViewCenterWorldY);
                     i--;
                  }
               }
               else if(!usesChips || amount < 0)
               {
                  InstanceMng.getItemsMng().addItemAmount(sku,amount,false,false,this.mCheckItemLimit.value,true);
                  item = InstanceMng.getItemsMng().getItemObjectBySku(sku);
                  if(item != null && item.mDef.getActionType() == "item" && item.mDef.getUseNow())
                  {
                     InstanceMng.getItemsMng().useItemFromInventory(item);
                  }
               }
            }
         }
      }
      
      public function performTransactionRewardObject() : void
      {
         if(this.mTransRewardObject == null || this.mTransRewardObjectAmount.value == 0 || this.mApplyOnProfile.value)
         {
            return;
         }
         this.mTransRewardObject.addAmountOwned(this.mTransRewardObjectAmount.value);
      }
      
      public function computeAmountsLeftValues(coinsCapacity:Number = -1, mineralsCapacity:Number = -1, badgesCapacity:Number = -1) : void
      {
         var profileCoins:Number = NaN;
         var diffCoins:Number = NaN;
         var profileMinerals:Number = NaN;
         var diffMinerals:Number = NaN;
         var profileBadges:Number = NaN;
         var diffBadges:Number = NaN;
         var availableDroids:int = 0;
         var itemSku:* = null;
         var currentItemAmount:int = 0;
         var amount:int = 0;
         var usesChips:Boolean = false;
         if(this.mApplyOnProfile.value)
         {
            if(this.mTransCash.value < 0)
            {
               this.mDifferenceCash.value = this.mProfile.getCash() - Math.abs(this.mTransCash.value);
            }
            if(this.mTransCoins.value > 0)
            {
               if(coinsCapacity == -1)
               {
                  coinsCapacity = this.mProfile.getCoinsCapacity();
               }
               profileCoins = this.mProfile.getCoins();
               if((diffCoins = coinsCapacity - profileCoins) < this.mTransCoins.value)
               {
                  this.mDifferenceCoins.value = this.mTransCoins.value - diffCoins;
                  this.mTransCoins.value = diffCoins;
                  if(this.mTransCoins.value < 0)
                  {
                     this.mDifferenceCoins.value = 0;
                     this.mTransCoins.value = 0;
                  }
               }
            }
            else if(this.mTransCoins.value != 0)
            {
               this.mDifferenceCoins.value = this.mProfile.getCoins() - Math.abs(this.mTransCoins.value);
            }
            if(this.mTransMinerals.value > 0)
            {
               if(mineralsCapacity == -1)
               {
                  mineralsCapacity = this.mProfile.getMineralsCapacity();
               }
               profileMinerals = this.mProfile.getMinerals();
               if((diffMinerals = mineralsCapacity - profileMinerals) < this.mTransMinerals.value)
               {
                  this.mDifferenceMinerals.value = this.mTransMinerals.value - diffMinerals;
                  this.mTransMinerals.value = diffMinerals;
                  if(this.mTransMinerals.value < 0)
                  {
                     this.mDifferenceMinerals.value = 0;
                     this.mTransMinerals.value = 0;
                  }
               }
            }
            else if(this.mTransMinerals.value != 0)
            {
               this.mDifferenceMinerals.value = this.mProfile.getMinerals() - Math.abs(this.mTransMinerals.value);
            }
            if(this.mTransBadges.value > 0)
            {
               if(badgesCapacity == -1)
               {
                  badgesCapacity = this.mProfile.getBadgesCapacity();
               }
               profileBadges = this.mProfile.getBadges();
               if((diffBadges = badgesCapacity - profileBadges) < this.mTransBadges.value)
               {
                  this.mDifferenceBadges.value = this.mTransBadges.value - diffBadges;
                  this.mTransBadges.value = diffBadges;
                  if(this.mTransBadges.value < 0)
                  {
                     this.mDifferenceBadges.value = 0;
                     this.mTransBadges.value = 0;
                  }
               }
            }
            else if(this.mTransBadges.value != 0)
            {
               this.mDifferenceBadges.value = this.mProfile.getBadges() - Math.abs(this.mTransBadges.value);
            }
         }
         if(this.mTransDroids.value > 0)
         {
            availableDroids = InstanceMng.getTrafficMng().droidsGetAvailableDroidsCount();
            this.mDifferenceDroids.value = availableDroids - Math.abs(this.mTransDroids.value);
         }
         this.mDifferenceAmount.value = 2147483647;
         if(this.mTransAmountAllowed.value > -1)
         {
            this.mDifferenceAmount.value = this.mTransAmountAllowed.value - this.mTransAmountOwned.value;
         }
         if(this.mTransItems != null)
         {
            for(itemSku in this.mTransItems)
            {
               currentItemAmount = InstanceMng.getItemsMng().getItemObjectBySku(itemSku).quantity;
               if(this.mDifferencesItemsAmount == null)
               {
                  this.mDifferencesItemsAmount = new Dictionary();
               }
               amount = int(this.mTransItems[itemSku]["amount"]);
               usesChips = Boolean(this.mTransItems[itemSku]["usesChips"]);
               if(amount < 0)
               {
                  this.mDifferencesItemsAmount[itemSku] = -(currentItemAmount - Math.abs(amount));
               }
               else if(usesChips)
               {
                  this.mDifferencesItemsAmount[itemSku] = amount;
               }
               else
               {
                  this.mDifferencesItemsAmount[itemSku] = 0;
               }
            }
         }
         if(this.mTransRewardObject != null)
         {
            this.mDifferenceRewardObjectAmount.value = this.mTransRewardObject.getAmountOwned() + this.mTransRewardObjectAmount.value;
         }
         this.getTransactionParametersBeforePaying();
      }
      
      public function getItemSkusWithOffer() : Array
      {
         var itemSku:* = null;
         var itemDef:ItemsDef = null;
         var itemsDefMng:ItemsDefMng = null;
         if(this.mItemSkusWithOffer == null)
         {
            this.mItemSkusWithOffer = [];
            itemsDefMng = InstanceMng.getItemsDefMng();
            for(itemSku in this.mTransItems)
            {
               itemDef = itemsDefMng.getDefBySku(itemSku) as ItemsDef;
               if(itemDef != null && itemDef.isOfferEnabled())
               {
                  this.mItemSkusWithOffer.push(itemSku);
               }
            }
         }
         return this.mItemSkusWithOffer;
      }
      
      public function getTransactionFinalCoins() : Number
      {
         this.computeAmountsLeftValues();
         return this.mTransCoins.value;
      }
      
      public function getTransactionFinalMinerals() : Number
      {
         this.computeAmountsLeftValues();
         return this.mTransMinerals.value;
      }
      
      public function getTransactionFinalBadges() : Number
      {
         this.computeAmountsLeftValues();
         return this.mTransBadges.value;
      }
      
      public function getTransactionNeedsServerResponse() : Boolean
      {
         return this.mTransCashToPay.value != 0 && !this.mServerResponseReceived.value && this.mCheckServerResponseEnabled.value;
      }
      
      public function getTransactionParametersBeforePaying() : void
      {
         var itemSku:String = null;
         var smallerTimeForFreeDroid:Number = NaN;
         var cashToExchangeFromDroids:int = 0;
         var droidReleaseCost:int = 0;
         var droidReleaseCurrency:int = 0;
         var itemPrice:int = 0;
         var allItemsMissingPrice:int = 0;
         var item:ItemObject = null;
         var instantBuildThreshold:Number = InstanceMng.getSettingsDefMng().getInstantBuildThreshold();
         var ruleMng:RuleMng = InstanceMng.getRuleMng();
         this.mTransCoinsLeftToPay.value = 0;
         this.mTransMineralsLeftToPay.value = 0;
         this.mTransBadgesLeftToPay.value = 0;
         this.mTransCashToPay.value = 0;
         this.mTransCashToExchange.value = 0;
         this.mPayableCoins.value = Math.min(this.mProfile.getCoins(),Math.abs(this.mTransCoins.value));
         this.mPayableMinerals.value = Math.min(this.mProfile.getMinerals(),Math.abs(this.mTransMinerals.value));
         this.mPayableBadges.value = Math.min(this.mProfile.getBadges(),Math.abs(this.mTransBadges.value));
         this.mPayableCash.value = Math.min(this.mProfile.getCash(),Math.abs(this.mTransCash.value));
         if(this.mDifferenceCoins.value < 0)
         {
            this.mTransCoinsLeftToPay.value = Math.abs(this.mDifferenceCoins.value);
         }
         if(this.mDifferenceMinerals.value < 0)
         {
            this.mTransMineralsLeftToPay.value = Math.abs(this.mDifferenceMinerals.value);
         }
         if(this.mDifferenceBadges.value < 0)
         {
            this.mTransBadgesLeftToPay.value = Math.abs(this.mDifferenceBadges.value);
         }
         if(this.mDifferenceDroids.value < 0)
         {
            if((smallerTimeForFreeDroid = InstanceMng.getTrafficMng().droidsGetSmallestTimeForFreeDroid()) < instantBuildThreshold)
            {
               droidReleaseCost = Math.abs(InstanceMng.getRuleMng().getDroidReleasePrice());
               switch((droidReleaseCurrency = InstanceMng.getRuleMng().getInstantOperationsCurrency()) - 1)
               {
                  case 0:
                     if(droidReleaseCost + this.mPayableCoins.value <= this.mProfile.getCoins())
                     {
                        this.mPayableCoins.value += droidReleaseCost;
                     }
                     else
                     {
                        this.mTransCoinsLeftToPay.value += droidReleaseCost;
                        this.mTransDroidsCash.value = 0;
                        this.mDroidsWillBePayedWithCash.value = true;
                     }
                     break;
                  case 1:
                     if(droidReleaseCost + this.mPayableMinerals.value <= this.mProfile.getMinerals())
                     {
                        this.mPayableMinerals.value += droidReleaseCost;
                        break;
                     }
                     this.mTransMineralsLeftToPay.value += droidReleaseCost;
                     this.mTransDroidsCash.value = 0;
                     this.mDroidsWillBePayedWithCash.value = true;
                     break;
               }
            }
            else
            {
               cashToExchangeFromDroids = Math.abs(ruleMng.exchangeMinsToCash(DCTimerUtil.msToMin(smallerTimeForFreeDroid),"instantHouses"));
               this.mTransDroidsCash.value = cashToExchangeFromDroids;
               this.mDroidsWillBePayedWithCash.value = true;
            }
         }
         if(this.mDifferenceCash.value < 0)
         {
            this.mTransCashToPay.value += Math.abs(this.mDifferenceCash.value);
         }
         if(this.mDifferencesItemsAmount != null)
         {
            allItemsMissingPrice = 0;
            for(itemSku in this.mTransItems)
            {
               item = InstanceMng.getItemsMng().getItemObjectBySku(itemSku);
               itemPrice = item.mDef.getChipsCost();
               this.mTransItems[itemSku]["offer"] = 0;
               if(item.mDef.isOfferEnabled())
               {
                  this.mTransItems[itemSku]["offer"] = 1;
               }
               if(!this.mIsDevolution.value)
               {
                  if(this.mDifferencesItemsAmount[itemSku] > 0 && this.mTransItems[itemSku]["usesChips"])
                  {
                     allItemsMissingPrice += this.mDifferencesItemsAmount[itemSku] * itemPrice;
                  }
               }
            }
            this.mTransCashToExchange.value += allItemsMissingPrice;
            this.mTransCashToPay.value += allItemsMissingPrice;
         }
         var cashFromCoinsAndMinerals:int = ruleMng.calculateResourcesPrice(this.mTransCoinsLeftToPay.value,this.mTransMineralsLeftToPay.value);
         this.mTransCashToExchange.value += cashFromCoinsAndMinerals;
         this.mTransCashToPay.value += cashFromCoinsAndMinerals;
         this.mTransCashToPay.value += this.mPayableCash.value;
         this.mTransPaymentObject.payableCoins = this.mPayableCoins.value;
         this.mTransPaymentObject.payableMinerals = this.mPayableMinerals.value;
         this.mTransPaymentObject.payableBadges = this.mPayableBadges.value;
         this.mTransPaymentObject.payableCash = this.mPayableCash.value;
         this.mTransPaymentObject.coinsLeftToPay = this.mTransCoinsLeftToPay.value;
         this.mTransPaymentObject.mineralsLeftToPay = this.mTransMineralsLeftToPay.value;
         this.mTransPaymentObject.badgesLeftToPay = this.mTransBadgesLeftToPay.value;
         this.mTransPaymentObject.cashToExchange = this.mTransCashToExchange.value;
         this.mTransPaymentObject.totalCashToPay = this.mTransCashToPay.value;
      }
      
      public function setCheckServerResponseEnabled(value:Boolean) : void
      {
         this.mCheckServerResponseEnabled.value = value;
      }
      
      public function setClientDebugInfo(value:String) : void
      {
         this.mClientDebugInfo = value;
      }
      
      public function setCheckItemLimit(value:Boolean) : void
      {
         this.mCheckItemLimit.value = value;
      }
      
      public function isEquivalent(t:Transaction) : Boolean
      {
         var tItems:Dictionary = null;
         var k:* = null;
         var itemSku:String = null;
         var amount:int = 0;
         var item:Object = null;
         var tItem:Object = null;
         var returnValue:Boolean = false;
         if(t != null)
         {
            if(returnValue = t.getTransCash() == this.getTransCash() && t.getTransCoins() == this.getTransCoins() && t.getTransMinerals() == this.getTransMinerals() && t.getTransBadges() == this.getTransBadges())
            {
               tItems = t.getTransItems();
               if(tItems != null && this.mTransItems != null)
               {
                  for(k in this.mTransItems)
                  {
                     itemSku = k;
                     item = this.mTransItems[itemSku];
                     if((tItem = tItems[itemSku]) == null || tItem.amount != item.amount)
                     {
                        returnValue = false;
                        break;
                     }
                  }
               }
               else
               {
                  returnValue = tItems == null && this.mTransItems == null;
               }
            }
         }
         return returnValue;
      }
      
      public function getEntry() : Entry
      {
         var amountLeft:Number = NaN;
         var entry:Entry = null;
         var neededAmount:int = 0;
         var itemSku:* = null;
         var item:ItemObject = null;
         var itemsMng:ItemsMng = null;
         var returnValue:String = "";
         var usingCoins:* = this.getTransCoins() != 0;
         var usingMinerals:* = this.getTransMinerals() != 0;
         var usingBadges:* = this.getTransBadges() != 0;
         var entries:Vector.<Entry> = new Vector.<Entry>(0);
         if(usingCoins)
         {
            entry = EntryFactory.createCoinsSingleEntry(this.mTransCoins.value);
            entries.push(entry);
         }
         if(usingMinerals)
         {
            entry = EntryFactory.createMineralsSingleEntry(this.mTransMinerals.value);
            entries.push(entry);
         }
         if(usingBadges)
         {
            entry = EntryFactory.createBadgesSingleEntry(this.mTransBadges.value);
            entries.push(entry);
         }
         var transItems:Dictionary = this.getTransItems();
         if(transItems != null)
         {
            itemsMng = InstanceMng.getItemsMng();
            for(itemSku in transItems)
            {
               if((item = itemsMng.getItemObjectBySku(itemSku)) != null)
               {
                  neededAmount = Math.abs(transItems[itemSku]["amount"]);
                  entry = EntryFactory.createItemSingleEntry(itemSku,neededAmount,false);
                  entries.push(entry);
               }
            }
         }
         if(this.getTransCash() != 0)
         {
            entry = EntryFactory.createCashSingleEntry(this.mTransCash.value);
            entries.push(entry);
         }
         return new CompositeEntry(entries);
      }
      
      public function getNotEnoughResourcesEntry() : Entry
      {
         var amountLeft:Number = NaN;
         var entry:Entry = null;
         var currentAmount:int = 0;
         var neededAmount:int = 0;
         var itemSku:* = null;
         var item:ItemObject = null;
         var itemsMng:ItemsMng = null;
         var returnValue:String = "";
         var usingCoins:* = this.mDifferenceCoins.value < 0;
         var usingMinerals:* = this.mDifferenceMinerals.value < 0;
         var usingBadges:* = this.mDifferenceBadges.value < 0;
         var entries:Vector.<Entry> = new Vector.<Entry>(0);
         if(usingCoins)
         {
            entry = EntryFactory.createCoinsSingleEntry(this.mDifferenceCoins.value);
            entries.push(entry);
         }
         if(usingMinerals)
         {
            entry = EntryFactory.createMineralsSingleEntry(this.mDifferenceMinerals.value);
            entries.push(entry);
         }
         if(usingBadges)
         {
            entry = EntryFactory.createBadgesSingleEntry(this.mDifferenceBadges.value);
            entries.push(entry);
         }
         var transItems:Dictionary = this.getTransItems();
         if(transItems != null)
         {
            itemsMng = InstanceMng.getItemsMng();
            for(itemSku in transItems)
            {
               item = itemsMng.getItemObjectBySku(itemSku);
               if(item != null)
               {
                  currentAmount = item.quantity;
                  neededAmount = Math.abs(transItems[itemSku]["amount"]);
                  if(currentAmount < neededAmount)
                  {
                     entry = EntryFactory.createItemSingleEntry(itemSku,neededAmount - currentAmount,true);
                     entries.push(entry);
                  }
               }
            }
         }
         return new CompositeEntry(entries);
      }
      
      public function getTransactionDebugString() : String
      {
         return this.getTransCoins() + " coins, " + this.getTransMinerals() + " minerals, " + this.getTransCash() + " cash, " + this.getTransScore() + " score, " + this.getTransBadges() + " badges, " + this.getTransXp() + " XP, " + this.getTransDroids() + " droids, " + this.mTransItems + " items | performed? " + this.getTransHasBeenPerformed() + ", apply? " + this.getApplyOnProfile();
      }
   }
}
