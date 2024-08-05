package com.dchoc.game.model.happening
{
   import com.dchoc.game.controller.entry.Entry;
   import com.dchoc.game.controller.entry.EntryFactory;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.resource.ResourceMng;
   import com.dchoc.game.model.items.ItemsDef;
   import com.dchoc.game.model.rule.PopupSkinDef;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.utils.anticheat.SecureBoolean;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.media.SoundManager;
   import com.dchoc.toolkit.core.resource.DCResourceMng;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.DCTimerUtil;
   import esparragon.utils.EUtils;
   import flash.utils.Dictionary;
   
   public class Happening
   {
      
      public static const STATE_NONE:int = -1;
      
      public static const STATE_COUNTDOWN:int = 0;
      
      public static const STATE_READY_TO_START:int = 1;
      
      public static const STATE_RUNNING:int = 2;
      
      public static const STATE_COMPLETED:int = 3;
      
      public static const STATE_OVER:int = 4;
      
      public static const STATE_FORCE_COMPLETED:int = 5;
      
      public static const STATE_FORCE_OVER:int = 6;
       
      
      private var mHappeningDef:HappeningDef;
      
      private var mHappeningType:HappeningType;
      
      private var mStartDateMS:SecureNumber;
      
      private var mCountdownStartMS:SecureNumber;
      
      private var mEndDateMS:SecureNumber;
      
      private var mOverDateMS:SecureNumber;
      
      private var mOptionBuyRewardTimeOver:SecureNumber;
      
      private var mShowOptionBuyRewardAfterCompleted:SecureBoolean;
      
      private var mGiveInitialKit:SecureBoolean;
      
      private var mGiveReward:SecureBoolean;
      
      private var mPersistence:XML;
      
      private var mState:SecureInt;
      
      private var mOldState:SecureInt;
      
      private var mOldStateForceCompleted:SecureInt;
      
      private var mShopOffers:SecureBoolean;
      
      public function Happening()
      {
         mStartDateMS = new SecureNumber("Happening.mStartDateMS");
         mCountdownStartMS = new SecureNumber("Happening.mCountdownStartMS");
         mEndDateMS = new SecureNumber("Happening.mEndDateMS");
         mOverDateMS = new SecureNumber("Happening.mOverDateMS");
         mOptionBuyRewardTimeOver = new SecureNumber("Happening.mOptionBuyRewardTimeOver");
         mShowOptionBuyRewardAfterCompleted = new SecureBoolean("Happening.mShowOptionBuyRewardAfterCompleted");
         mGiveInitialKit = new SecureBoolean("Happening.mGiveInitialKit");
         mGiveReward = new SecureBoolean("Happening.mGiveReward");
         mState = new SecureInt("Happening.mState",-1);
         mOldState = new SecureInt("Happening.mOldState",-1);
         mOldStateForceCompleted = new SecureInt("Happening.mOldStateForceCompleted",-1);
         mShopOffers = new SecureBoolean("Happening.mShopOffers");
         super();
      }
      
      public function build(xml:XML) : void
      {
         this.mPersistence = xml;
         var sku:String = EUtils.xmlReadString(xml,"sku");
         var state:int = EUtils.xmlReadInt(xml,"state");
         this.mShowOptionBuyRewardAfterCompleted.value = false;
         this.mOptionBuyRewardTimeOver.value = 0;
         var attribute:String = "timeLeft";
         var timeLeft:Number = 0;
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            timeLeft = EUtils.xmlReadNumber(xml,attribute);
         }
         attribute = "timeOver";
         if(EUtils.xmlIsAttribute(xml,attribute) && timeLeft > 0)
         {
            this.mOptionBuyRewardTimeOver.value = EUtils.xmlReadNumber(xml,attribute);
            this.mShowOptionBuyRewardAfterCompleted.value = true;
            DCDebug.traceCh("HAPP","Happening timeOver = " + this.mOptionBuyRewardTimeOver.value);
         }
         this.mGiveInitialKit.value = true;
         attribute = "initialKitGiven";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            if(EUtils.xmlReadInt(xml,attribute) == 1)
            {
               this.mGiveInitialKit.value = false;
            }
         }
         this.mHappeningDef = InstanceMng.getHappeningDefMng().getDefBySku(sku) as HappeningDef;
         if(this.mHappeningDef == null)
         {
            DCDebug.traceCh("ASSERT","<" + sku + "> sku not found in happeningDefinitions.xml");
         }
         else
         {
            this.mHappeningType = InstanceMng.getHappeningTypeDefMng().createHappeningType(this.mHappeningDef.getType(),this.mHappeningDef.getTypeSku());
            this.mStartDateMS.value = this.mHappeningDef.validDateGetStartMillis();
            this.mCountdownStartMS.value = this.mHappeningDef.getCountdownStartDateMillis();
            this.mEndDateMS.value = this.mHappeningDef.validDateGetEndMillis();
            this.mOverDateMS.value = this.mHappeningDef.getOverDateMillis();
            if(state == 4)
            {
               this.stateChangeState(state,false);
            }
            else if(this.isOver() && state != 4)
            {
               this.stateChangeState(6,false);
            }
            else if(this.isExpired() && state != 3)
            {
               this.mState.value = state;
               this.mHappeningType.build(this,this.mPersistence.Type[0],false);
               this.stateChangeState(5,false);
            }
            else
            {
               this.stateChangeState(state,false);
            }
            this.requestResources();
         }
      }
      
      public function unbuild() : void
      {
         this.mHappeningDef = null;
         if(this.mHappeningType != null)
         {
            this.mHappeningType.unbuild();
            this.mHappeningType = null;
         }
      }
      
      public function requestResources() : void
      {
         var sounds:Dictionary = null;
         var soundMng:SoundManager = null;
         var k:* = null;
         var key:String = null;
         var params:Array = null;
         if(this.mHappeningDef != null)
         {
            sounds = this.mHappeningDef.getSounds();
            if(sounds != null)
            {
               soundMng = SoundManager.getInstance();
               for(k in sounds)
               {
                  key = k;
                  params = sounds[k] as Array;
                  soundMng.addExternalSound(DCResourceMng.getFileName("sounds/" + params[1] + ".mp3"),params[1],SoundManager.getTypeIdFromKey(params[2]));
               }
            }
         }
      }
      
      public function getSoundKey(key:String) : String
      {
         return this.mHappeningDef == null ? null : this.mHappeningDef.getSoundKey(key);
      }
      
      public function logicUpdate(dt:int) : void
      {
         var currentMS:Number = InstanceMng.getApplication().getCurrentServerTimeMillis();
         switch(this.mState.value - -1)
         {
            case 0:
               if(currentMS >= this.mCountdownStartMS.value)
               {
                  this.stateChangeState(0,true);
               }
               else if(currentMS >= this.mStartDateMS.value)
               {
                  this.stateChangeState(1,true);
               }
               else if(currentMS >= this.mEndDateMS.value)
               {
                  this.stateChangeState(3,true);
               }
               break;
            case 1:
               if(currentMS >= this.mStartDateMS.value)
               {
                  this.stateChangeState(1,true);
                  InstanceMng.getUIFacade().setContestIconTip(null);
               }
               else
               {
                  InstanceMng.getUIFacade().setContestIconTip(DCTextMng.getCountdownTimeLeft(this.mHappeningDef.validDateGetStartMillis()));
               }
               break;
            case 2:
               if(currentMS >= this.mEndDateMS.value)
               {
                  this.stateChangeState(3,true);
               }
               break;
            case 3:
               this.mHappeningType.logicUpdate(dt);
               if(this.mShopOffers.value == false && this.hasTheShopOffers())
               {
                  this.mShopOffers.value = true;
                  this.mHappeningType.setShopOffers(this.mShopOffers.value);
               }
               break;
            case 4:
               if(currentMS >= this.mOptionBuyRewardTimeOver.value)
               {
                  this.stateChangeState(4,true);
               }
               break;
            case 5:
               break;
            case 6:
               this.stateChangeState(3,true);
               break;
            case 7:
               this.stateChangeState(4,true);
         }
      }
      
      public function stateChangeState(newState:int, notifyServer:Boolean) : void
      {
         if(notifyServer && this.mState.value == newState)
         {
            DCDebug.traceCh("HAPP","[" + this.mHappeningDef.mSku + "] WARN Change state to same state: " + newState);
            return;
         }
         this.stateExitState(this.mState.value);
         this.viewExitState();
         DCDebug.traceCh("HAPP","[" + this.mHappeningDef.mSku + "] Change state " + this.mState.value + " to " + newState + " notify? " + notifyServer);
         this.mOldState.value = this.mState.value;
         this.mState.value = newState;
         this.stateEnterState(this.mState.value,notifyServer);
         this.viewEnterState();
      }
      
      private function stateEnterState(state:int, notifyServer:Boolean) : void
      {
         var timeLeft:Number = NaN;
         var minTimeLeft:* = NaN;
         var twoHours:Number = NaN;
         var HQLvl:int = 0;
         var countdownWaveTime:Number = NaN;
         var transaction:Transaction = null;
         var entry:Entry = null;
         var event:Object = null;
         var finalReward:String = null;
         var currentMS:Number = NaN;
         var timeLeftEndHappening:Number = NaN;
         var unitsPurchasablesCost:Vector.<int> = null;
         var rewardsArr:Array = null;
         var i:int = 0;
         var reward:String = null;
         DCDebug.traceCh("HAPP","[" + this.mHappeningDef.mSku + "] Entering state " + this.mState.value);
         switch(state - -1)
         {
            case 0:
               break;
            case 1:
               if(notifyServer)
               {
                  InstanceMng.getUserDataMng().updateHappening_stateCountdown(this.mHappeningDef.mSku);
               }
               break;
            case 2:
               if(notifyServer)
               {
                  InstanceMng.getUserDataMng().updateHappening_stateReadyToStart(this.mHappeningDef.mSku);
               }
               timeLeft = this.mEndDateMS.value - InstanceMng.getApplication().getCurrentServerTimeMillis();
               minTimeLeft = 0;
               if(this.mHappeningDef.getType() == "waves")
               {
                  minTimeLeft = this.mHappeningDef.validDataGetDurationMillis() * 0.2;
               }
               twoHours = DCTimerUtil.hourToMs(2);
               if(minTimeLeft > twoHours)
               {
                  minTimeLeft = twoHours;
               }
               if(timeLeft < minTimeLeft)
               {
                  DCDebug.traceCh("HAPP","[" + this.mHappeningDef.mSku + "] FORCED STATE_OVER from STATE_READY_TO_START timeLeft = " + timeLeft + " minTimeLeft = " + minTimeLeft);
                  this.stateChangeState(4,true);
               }
               this.mPersistence.Type[0] = null;
               break;
            case 3:
               this.mHappeningType.build(this,this.mPersistence.Type[0]);
               HQLvl = int(HappeningTypeWave(this.mHappeningType).getHQLevel());
               countdownWaveTime = Number(HappeningTypeWave(this.mHappeningType).getCurrentWave().getCountdown());
               if(notifyServer)
               {
                  if(this.giveInitialKit())
                  {
                     if((transaction = (entry = EntryFactory.createEntryFromEntrySet(this.mHappeningDef.getInitialKitEntry())).toTransaction(transaction)).performAllTransactions() == true)
                     {
                        if(this.mHappeningType is HappeningTypeWave)
                        {
                           InstanceMng.getUserDataMng().updateHappening_stateRunning(this.mHappeningDef.mSku,HQLvl,countdownWaveTime,HappeningTypeWave(this.mHappeningType).getCurrentWave().mSku,transaction);
                        }
                        else if(this.mHappeningType is HappeningTypeBirthday)
                        {
                           InstanceMng.getUserDataMng().updateHappening_stateRunning(this.mHappeningDef.mSku,HQLvl,countdownWaveTime,HappeningTypeBirthday(this.mHappeningType).getCurrentWave().mSku,transaction);
                        }
                        else if(this.mHappeningType is HappeningTypeWinter)
                        {
                           InstanceMng.getUserDataMng().updateHappening_stateRunning(this.mHappeningDef.mSku,HQLvl,countdownWaveTime,HappeningTypeWinter(this.mHappeningType).getCurrentWave().mSku,transaction);
                        }
                        else
                        {
                           InstanceMng.getUserDataMng().updateHappening_stateRunning(this.mHappeningDef.mSku,HQLvl,countdownWaveTime,HappeningTypeWinter(this.mHappeningType).getCurrentWave().mSku,transaction);
                        }
                     }
                     this.mGiveInitialKit.value = false;
                  }
                  else if(this.mHappeningType is HappeningTypeWave)
                  {
                     InstanceMng.getUserDataMng().updateHappening_stateRunning(this.mHappeningDef.mSku,HQLvl,countdownWaveTime,HappeningTypeWave(this.mHappeningType).getCurrentWave().mSku,null);
                  }
                  else if(this.mHappeningType is HappeningTypeBirthday)
                  {
                     InstanceMng.getUserDataMng().updateHappening_stateRunning(this.mHappeningDef.mSku,HQLvl,countdownWaveTime,HappeningTypeBirthday(this.mHappeningType).getCurrentWave().mSku,null);
                  }
                  else if(this.mHappeningType is HappeningTypeWinter)
                  {
                     InstanceMng.getUserDataMng().updateHappening_stateRunning(this.mHappeningDef.mSku,HQLvl,countdownWaveTime,HappeningTypeWinter(this.mHappeningType).getCurrentWave().mSku,null);
                  }
                  else
                  {
                     InstanceMng.getUserDataMng().updateHappening_stateRunning(this.mHappeningDef.mSku,HQLvl,countdownWaveTime,HappeningTypeWinter(this.mHappeningType).getCurrentWave().mSku,null);
                  }
               }
               InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),{
                  "cmd":"NotifyHappeningEnterRunning",
                  "happeningSku":this.mHappeningDef.mSku
               },true);
               break;
            case 4:
               if(notifyServer)
               {
                  (event = InstanceMng.getGUIControllerPlanet().createNotifyEvent("EventPopup","NotifyHappeningShowFinalReward")).expired = false;
                  event.canShare = true;
                  finalReward = this.mHappeningDef.getReward();
                  if(this.isExpired())
                  {
                     event.expired = true;
                     unitsPurchasablesCost = this.calculateUnitsPurchasables();
                     event.unitsPurchasablesCost = unitsPurchasablesCost;
                     rewardsArr = finalReward.split(",");
                     finalReward = "";
                     i = 0;
                     for each(reward in rewardsArr)
                     {
                        if(unitsPurchasablesCost[i] == -1)
                        {
                           finalReward += reward + ",";
                        }
                        i++;
                     }
                     finalReward = finalReward.substr(0,finalReward.length - 1);
                  }
                  transaction = new Transaction();
                  if((transaction = (entry = EntryFactory.createEntryFromEntrySet(finalReward)).toTransaction(transaction)).performAllTransactions() == true)
                  {
                     InstanceMng.getUserDataMng().updateHappening_stateCompleted(this.mHappeningDef.mSku,transaction);
                  }
                  event.happeningDef = this.mHappeningDef;
                  event.boxEnemyName = HappeningTypeWaveDef(this.mHappeningType.getHappeningTypeDef()).getBoxEnemyName();
                  InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),event);
                  this.mShowOptionBuyRewardAfterCompleted.value = true;
                  currentMS = InstanceMng.getApplication().getCurrentServerTimeMillis();
                  timeLeftEndHappening = this.mEndDateMS.value - currentMS;
                  this.mOptionBuyRewardTimeOver.value = currentMS + timeLeftEndHappening;
                  if(this.mHappeningDef.getExtraDurationToSell() > timeLeftEndHappening)
                  {
                     this.mOptionBuyRewardTimeOver.value = currentMS + this.mHappeningDef.getExtraDurationToSell();
                  }
               }
               break;
            case 5:
               if(notifyServer)
               {
                  InstanceMng.getUserDataMng().updateHappening_stateOver(this.mHappeningDef.mSku);
               }
               break;
            case 6:
               this.mOldStateForceCompleted.value = this.mOldState.value;
         }
      }
      
      private function stateExitState(state:int) : void
      {
         DCDebug.traceCh("HAPP","[" + this.mHappeningDef.mSku + "] Exiting state " + this.mState.value);
         switch(state - -1)
         {
            case 0:
            case 1:
            case 2:
            case 4:
            case 5:
               break;
            case 3:
               InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),{
                  "cmd":"NotifyHappeningExitRunning",
                  "type":"EventPopup",
                  "happeningSku":this.mHappeningDef.mSku
               },true);
               break;
            case 6:
               this.mState.value = this.mOldStateForceCompleted.value;
         }
      }
      
      public function restart() : void
      {
         this.mPersistence.Type[0] = null;
         this.stateChangeState(1,true);
      }
      
      public function getHappeningDef() : HappeningDef
      {
         return this.mHappeningDef;
      }
      
      public function getHappeningType() : HappeningType
      {
         return this.mHappeningType;
      }
      
      public function getState() : int
      {
         return this.mState.value;
      }
      
      public function isRunning() : Boolean
      {
         return this.mState.value == 2;
      }
      
      public function isCompleted() : Boolean
      {
         return this.mState.value == 3;
      }
      
      public function isExpired() : Boolean
      {
         return InstanceMng.getApplication().getCurrentServerTimeMillis() >= this.mEndDateMS.value;
      }
      
      public function isOver() : Boolean
      {
         return InstanceMng.getApplication().getCurrentServerTimeMillis() >= this.mOverDateMS.value;
      }
      
      public function getCurrentProgress() : int
      {
         return this.mHappeningType.getCurrentProgress();
      }
      
      public function getTarget() : int
      {
         return this.mHappeningType.getTarget();
      }
      
      public function getEndTime() : Number
      {
         return this.mEndDateMS.value;
      }
      
      public function giveInitialKit() : Boolean
      {
         return this.mGiveInitialKit.value;
      }
      
      public function getAllUnitsPurchasables() : Vector.<int>
      {
         var cost:int = 0;
         var result:Vector.<int> = new Vector.<int>(0);
         var arrCost:Array = this.mHappeningDef.getRewardCost().split(",");
         for each(cost in arrCost)
         {
            result.push(cost);
         }
         return result;
      }
      
      public function calculateUnitsPurchasables() : Vector.<int>
      {
         var i:int = 0;
         var result:Vector.<int> = new Vector.<int>(0);
         var arrReward:Array = this.mHappeningDef.getReward().split(",");
         var arrCost:Array = this.mHappeningDef.getRewardCost().split(",");
         if(arrReward.length != arrCost.length)
         {
            DCDebug.trace("ERROR! Different lengths from rewards and costs");
            return result;
         }
         var sizeReward:int = int(this.mHappeningDef.getReward().split(",").length);
         var div:Number = 0;
         if(this.mHappeningType != null)
         {
            div = this.getCurrentProgress() / this.getTarget();
         }
         var diff:int = div / (1 / sizeReward);
         for(i = 0; i < arrReward.length; )
         {
            if(i < diff)
            {
               result.push(-1);
            }
            else
            {
               result.push(arrCost[i]);
            }
            i++;
         }
         return result;
      }
      
      public function viewExitState() : void
      {
         if(InstanceMng.getHappeningMng().isHappeningInHud(this.mHappeningDef.mSku))
         {
            switch(this.mState.value - -1)
            {
               case 0:
               case 1:
               case 2:
               case 3:
               case 4:
               case 5:
                  InstanceMng.getHappeningMng().hudRemoveHappeningIcon();
            }
         }
      }
      
      public function viewEnterState() : void
      {
         var popupSkinDef:PopupSkinDef = null;
         var assetPath:String = null;
         var iconFilename:String = null;
         var event:Object = null;
         var tidText:int = 0;
         var tidTip:int = 0;
         if(InstanceMng.getHappeningMng().isHappeningInHud(this.mHappeningDef.mSku))
         {
            switch(this.mState.value - -1)
            {
               case 0:
                  break;
               case 1:
                  InstanceMng.getHappeningMng().hudSetHappeningIcon(this.mHappeningDef.mSku);
                  break;
               case 2:
                  if((popupSkinDef = InstanceMng.getPopupSkinDefMng().getDefBySku(this.mHappeningDef.getPopupSkin()) as PopupSkinDef) != null)
                  {
                     assetPath = String(ResourceMng[popupSkinDef.getResourcePopupId()]);
                     iconFilename = InstanceMng.getHappeningDefMng().getHappeningGraphic(this.mHappeningDef.getPopupSkin(),"icon_ready");
                  }
                  (event = InstanceMng.getGUIControllerPlanet().createNotifyEvent("EventPopup","NotifyHappeningStartIntro")).happeningDef = this.mHappeningDef;
                  InstanceMng.getHappeningMng().hudSetHappeningIcon(this.mHappeningDef.mSku);
                  break;
               case 3:
                  break;
               case 4:
                  if(this.mShowOptionBuyRewardAfterCompleted.value)
                  {
                     if((popupSkinDef = InstanceMng.getPopupSkinDefMng().getDefBySku(this.mHappeningDef.getPopupSkin()) as PopupSkinDef) != null)
                     {
                        assetPath = String(ResourceMng[popupSkinDef.getResourcePopupId()]);
                        iconFilename = InstanceMng.getHappeningDefMng().getHappeningGraphic(this.mHappeningDef.getPopupSkin(),"icon_reward_offer");
                     }
                     (event = InstanceMng.getGUIControllerPlanet().createNotifyEvent("EventPopup","NotifyHappeningShowFinalReward")).happeningDef = this.mHappeningDef;
                     event.boxEnemyName = HappeningTypeWaveDef(this.mHappeningType.getHappeningTypeDef()).getBoxEnemyName();
                     event.optionBuyRewards = true;
                     event.unitsPurchasablesCost = this.getAllUnitsPurchasables();
                     tidText = int(TextIDs[this.mHappeningDef.getTidIconAfterCompleted()]);
                     tidTip = 1673;
                     InstanceMng.getHappeningMng().hudSetHappeningIcon(this.mHappeningDef.getSku());
                  }
                  break;
               case 5:
                  InstanceMng.getHappeningMng().hudRemoveCurrentHappening();
            }
         }
      }
      
      public function hasTheShopOffers() : Boolean
      {
         var i:int = 0;
         var item:ItemsDef = null;
         var itemsSku:Array = this.mHappeningDef.getShopItemsSku();
         if(itemsSku == null)
         {
            return false;
         }
         var count:int = int(itemsSku.length);
         for(i = 0; i < count; )
         {
            item = InstanceMng.getItemsDefMng().getDefBySku(itemsSku[i]) as ItemsDef;
            if(item.isOfferEnabled())
            {
               return true;
            }
            i++;
         }
         return false;
      }
   }
}
