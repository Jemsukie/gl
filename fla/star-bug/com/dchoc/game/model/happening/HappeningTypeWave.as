package com.dchoc.game.model.happening
{
   import com.dchoc.game.controller.entry.Entry;
   import com.dchoc.game.controller.entry.EntryFactory;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.resource.ResourceMng;
   import com.dchoc.game.model.rule.PopupSkinDef;
   import com.dchoc.game.model.unit.defs.UnitDef;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.waves.WaveSpawnDef;
   import com.dchoc.game.utils.anticheat.SecureBoolean;
   import com.dchoc.game.utils.anticheat.SecureInt;
   import com.dchoc.game.utils.anticheat.SecureNumber;
   import com.dchoc.game.utils.anticheat.SecureString;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.utils.EUtils;
   
   public class HappeningTypeWave extends HappeningType
   {
       
      
      private var mCurrentWave:WaveSpawnDef;
      
      private var mCurrentWaveSku:SecureString;
      
      private var mIdxCurrentWave:SecureInt;
      
      private var mWavesDone:SecureInt;
      
      private var mTimeOver:SecureNumber;
      
      private var mTimeLeft:SecureNumber;
      
      private var mHQLevel:SecureInt;
      
      private var mCurrentWaveDelayed:SecureInt;
      
      private var mTarget:SecureInt;
      
      private var mUnitsKilledTotal:SecureInt;
      
      private var mUnitsKilledCurrentWave:SecureInt;
      
      private var mShowShopOffers:SecureBoolean;
      
      private var mSpeedUpWaveTrans:Transaction;
      
      private var mPersistence:XML;
      
      private var mReadyToStartEvent:Object = null;
      
      public function HappeningTypeWave()
      {
         mCurrentWaveSku = new SecureString("HappeningTypeWave.mCurrentWaveSku");
         mIdxCurrentWave = new SecureInt("HappeningTypeWave.mIdxCurrentWave");
         mWavesDone = new SecureInt("HappeningTypeWave.mWavesDone");
         mTimeOver = new SecureNumber("HappeningTypeWave.mTimeOver");
         mTimeLeft = new SecureNumber("HappeningTypeWave.mTimeLeft");
         mHQLevel = new SecureInt("HappeningTypeWave.mHQLevel");
         mCurrentWaveDelayed = new SecureInt("HappeningTypeWave.mCurrentWaveDelayed");
         mTarget = new SecureInt("HappeningTypeWave.mTarget");
         mUnitsKilledTotal = new SecureInt("HappeningTypeWave.mUnitsKilledTotal");
         mUnitsKilledCurrentWave = new SecureInt("HappeningTypeWave.mUnitsKilledCurrentWave");
         mShowShopOffers = new SecureBoolean("HappeningTypeWave.mShowShopOffers");
         super();
         this.mCurrentWaveSku.value = null;
         this.mTarget.value = -1;
         this.mUnitsKilledTotal.value = 0;
         this.mUnitsKilledCurrentWave.value = 0;
         this.mWavesDone.value = 0;
         this.mShowShopOffers.value = false;
         this.mSpeedUpWaveTrans = null;
         this.mTimeLeft.value = 0;
      }
      
      override public function build(happening:Happening, xml:XML, changeState:Boolean = true) : void
      {
         var str:* = null;
         super.build(happening,xml,changeState);
         if(xml == null || xml.attributes().length() == 0)
         {
            this.mHQLevel.value = InstanceMng.getUserInfoMng().getProfileLogin().getCurrentPlanetHqLevel();
            this.mIdxCurrentWave.value = 0;
            this.mCurrentWave = InstanceMng.getWaveSpawnDefMng().getCurrentWave((mHappeningTypeDef as HappeningTypeWaveDef).getWavesSpawnGroup(),this.mHQLevel.value,this.mIdxCurrentWave.value);
            this.mCurrentWaveSku.value = this.mCurrentWave.mSku;
            this.mCurrentWaveDelayed.value = 0;
            this.mTimeOver.value = InstanceMng.getApplication().getCurrentServerTimeMillis() + this.mCurrentWave.getCountdown();
            this.mUnitsKilledTotal.value = 0;
            this.mUnitsKilledCurrentWave.value = 0;
            this.mWavesDone.value = 0;
            str = "<Type HQLevel=\"" + this.mHQLevel.value + "\" waveSpawnSku=\"" + this.mCurrentWaveSku.value + "\" currentWaveIdx=\"" + this.mIdxCurrentWave.value + "\" state=\"" + 0 + "\" timeOver=\"" + this.mTimeOver.value + "\" unitsKilledTotal=\"" + this.mUnitsKilledTotal.value + "\" unitsKilledThisWave=\"" + this.mUnitsKilledCurrentWave.value + "\" />";
            xml = EUtils.stringToXML(str);
         }
         this.mPersistence = xml;
         var attribute:String = "waveSpawnSku";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.mCurrentWaveSku.value = EUtils.xmlReadString(xml,attribute);
         }
         else
         {
            DCDebug.traceCh("HAPP","[" + mHappeningTypeDef.mSku + "] waveSpawnSku not found");
            this.mCurrentWaveSku.value = null;
         }
         attribute = "currentWaveIdx";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.mIdxCurrentWave.value = EUtils.xmlReadInt(xml,attribute);
         }
         else
         {
            this.mIdxCurrentWave.value = 0;
         }
         attribute = "HQLevel";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.mHQLevel.value = EUtils.xmlReadInt(xml,attribute);
         }
         else
         {
            this.mHQLevel.value = InstanceMng.getUserInfoMng().getProfileLogin().getCurrentPlanetHqLevel();
         }
         if(this.mCurrentWaveSku.value != null)
         {
            this.mCurrentWave = InstanceMng.getWaveSpawnDefMng().getDefBySku(this.mCurrentWaveSku.value) as WaveSpawnDef;
         }
         else
         {
            DCDebug.traceCh("HAPP","[" + mHappeningTypeDef.mSku + "] getting waveSpawn from idx current wave (" + this.mIdxCurrentWave.value + ") and HQLevel (" + this.mHQLevel.value + ")");
            this.mCurrentWave = InstanceMng.getWaveSpawnDefMng().getCurrentWave((mHappeningTypeDef as HappeningTypeWaveDef).getWavesSpawnGroup(),this.mHQLevel.value,this.mIdxCurrentWave.value);
            this.mCurrentWaveSku.value = this.mCurrentWave.mSku;
         }
         attribute = "delayed";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.mCurrentWaveDelayed.value = EUtils.xmlReadInt(xml,attribute);
         }
         else
         {
            this.mCurrentWaveDelayed.value = 0;
         }
         var state:int = -1;
         attribute = "state";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            state = EUtils.xmlReadInt(xml,attribute);
         }
         attribute = "timeOver";
         if(EUtils.xmlIsAttribute(xml,attribute) && EUtils.xmlReadNumber(xml,attribute) != 0)
         {
            this.mTimeOver.value = EUtils.xmlReadNumber(xml,attribute);
         }
         else
         {
            this.mTimeOver.value = InstanceMng.getApplication().getCurrentServerTimeMillis() + this.mCurrentWave.getCountdown();
         }
         attribute = "unitsKilledTotal";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.mUnitsKilledTotal.value = EUtils.xmlReadInt(xml,attribute);
         }
         else
         {
            this.mUnitsKilledTotal.value = 0;
         }
         DCDebug.traceCh("HAPP","HappeningTypeWave unitsKilledTotal " + this.mUnitsKilledTotal.value);
         attribute = "unitsKilledThisWave";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.mUnitsKilledCurrentWave.value = EUtils.xmlReadInt(xml,attribute);
         }
         else
         {
            this.mUnitsKilledCurrentWave.value = 0;
         }
         DCDebug.traceCh("HAPP","HappeningTypeWave unitsKilledThisWave " + this.mUnitsKilledCurrentWave.value);
         attribute = "wavesDone";
         if(EUtils.xmlIsAttribute(xml,attribute))
         {
            this.mWavesDone.value = EUtils.xmlReadInt(xml,attribute);
         }
         else
         {
            this.mWavesDone.value = 0;
         }
         this.mTimeLeft.value = 0;
         if(changeState)
         {
            this.stateChangeState(state,false);
         }
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var currentMS:Number = InstanceMng.getApplication().getCurrentServerTimeMillis();
         switch(mState - -1)
         {
            case 0:
               this.stateChangeState(0,true);
               break;
            case 1:
               if(currentMS >= this.mTimeOver.value)
               {
                  this.stateChangeState(1,true);
               }
               else
               {
                  InstanceMng.getUIFacade().setContestIconTip(DCTextMng.getCountdownTime(this.mTimeOver.value - currentMS));
               }
               break;
            case 2:
               if(this.mReadyToStartEvent != null)
               {
                  InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),this.mReadyToStartEvent,true);
                  this.mReadyToStartEvent = null;
               }
               break;
            case 3:
               if(currentMS >= this.mTimeOver.value)
               {
                  this.stateChangeState(3,true);
               }
               break;
            case 5:
               DCDebug.traceCh("HAPP","HappeningTypeWave logicUpdate STATE_FORCE_COMPLETED " + this.mUnitsKilledCurrentWave.value + " added to existing total");
               this.addProgress(this.mUnitsKilledCurrentWave.value);
               this.stateChangeState(3,true);
         }
      }
      
      public function delayWave() : void
      {
         InstanceMng.getUserDataMng().updateHappeningWave_delayWave(getHappeningSku());
         this.mCurrentWaveDelayed.value = 1;
         this.mTimeOver.value = InstanceMng.getApplication().getCurrentServerTimeMillis() + HappeningTypeWaveDef(mHappeningTypeDef).getDelayWaveTime();
         this.stateChangeState(0,true);
      }
      
      public function checkDelayWave() : Boolean
      {
         var endMS:Number = getHappening().getHappeningDef().validDateGetEndMillis();
         var timeOver:Number = InstanceMng.getApplication().getCurrentServerTimeMillis() + HappeningTypeWaveDef(mHappeningTypeDef).getDelayWaveTime();
         return timeOver <= endMS;
      }
      
      override public function stateChangeState(newState:int, notifyServer:Boolean) : void
      {
         if(notifyServer && mState == newState)
         {
            DCDebug.traceCh("HAPP","[" + mHappeningTypeDef.mSku + "] WARN Change WAVE state to same state: " + newState);
            return;
         }
         this.stateExitState(mState);
         this.viewExitState();
         DCDebug.traceCh("HAPP","[" + mHappeningTypeDef.mSku + "]    +++ Change WAVE state " + mState + " to " + newState);
         mState = newState;
         this.stateEnterState(mState,notifyServer);
         this.viewEnterState();
      }
      
      private function stateEnterState(state:int, notifyServer:Boolean) : void
      {
         var canSkipHappening:* = false;
         var event:Object = null;
         var endMS:Number = NaN;
         var nextWaveIdx:int = 0;
         var nextWave:WaveSpawnDef = null;
         var entry:Entry = null;
         var transaction:Transaction = null;
         switch(state - -1)
         {
            case 0:
               break;
            case 1:
               if(notifyServer)
               {
                  endMS = getHappening().getHappeningDef().validDateGetEndMillis();
                  if(this.mTimeOver.value > endMS)
                  {
                     this.mTimeOver.value = endMS;
                     this.mCurrentWaveDelayed.value = 1;
                  }
               }
               else
               {
                  this.stateChangeState(-1,false);
               }
               break;
            case 2:
               canSkipHappening = this.mSpeedUpWaveTrans == null;
               if(notifyServer)
               {
                  InstanceMng.getUserDataMng().updateHappeningWave_stateReadyToStart(getHappeningSku(),this.mSpeedUpWaveTrans,this.mTimeLeft.value);
                  this.mSpeedUpWaveTrans = null;
                  this.mTimeLeft.value = 0;
               }
               this.mReadyToStartEvent = InstanceMng.getGUIControllerPlanet().createNotifyEvent("EventPopup","NotifyHappeningTypeWaveReadyToStart");
               this.mReadyToStartEvent.happeningTypeDef = mHappeningTypeDef;
               this.mReadyToStartEvent.happeningSku = getHappeningSku();
               this.mReadyToStartEvent.waves = InstanceMng.getRuleMng().waveSpawnGetAttack(this.mCurrentWave.getWave());
               this.mReadyToStartEvent.canSkipHappening = canSkipHappening;
               break;
            case 3:
               if(notifyServer)
               {
                  InstanceMng.getUserDataMng().updateHappeningWave_stateRunning(getHappeningSku());
                  if(this.mCurrentWave.getDuration() > 0)
                  {
                     InstanceMng.getUnitScene().battleHappeningWaveSpawnStart(getHappeningSku(),this.mCurrentWave,getHappening().getHappeningDef().getNpcEnemySku());
                  }
                  this.mTimeOver.value = InstanceMng.getApplication().getCurrentServerTimeMillis() + this.mCurrentWave.getDuration();
               }
               else
               {
                  this.stateChangeState(4,false);
               }
               break;
            case 4:
               if(notifyServer)
               {
                  nextWaveIdx = this.mIdxCurrentWave.value;
                  if(InstanceMng.getWaveSpawnDefMng().isLastWave((mHappeningTypeDef as HappeningTypeWaveDef).getWavesSpawnGroup(),this.mHQLevel.value,this.mIdxCurrentWave.value) == false)
                  {
                     nextWaveIdx++;
                  }
                  nextWave = InstanceMng.getWaveSpawnDefMng().getCurrentWave((mHappeningTypeDef as HappeningTypeWaveDef).getWavesSpawnGroup(),this.mHQLevel.value,nextWaveIdx);
                  if(this.mCurrentWave != null)
                  {
                     entry = EntryFactory.createEntryFromEntrySet(this.mCurrentWave.getRewardEntry());
                     if((transaction = entry.toTransaction()).performAllTransactions() == true)
                     {
                        InstanceMng.getUserDataMng().updateHappeningWave_stateCompleted(getHappeningSku(),nextWaveIdx,nextWave.mSku,transaction);
                     }
                  }
                  this.mWavesDone.value++;
               }
               if(InstanceMng.getApplication().viewGetMode() == 0)
               {
                  (event = InstanceMng.getGUIControllerPlanet().createNotifyEvent("EventPopup","NotifyHappeningTypeWaveCompleted")).happeningTypeWave = this;
                  event.happeningSku = getHappeningSku();
                  event.happeningTypeDef = mHappeningTypeDef;
                  InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),event,false,1500);
                  break;
               }
         }
      }
      
      private function stateExitState(state:int) : void
      {
         switch(state - -1)
         {
            case 0:
            case 1:
            case 2:
            case 3:
               break;
            case 4:
               this.mCurrentWaveDelayed.value = 0;
         }
      }
      
      public function processNextStateAndIsHappeningCompletedOrExpired() : Boolean
      {
         DCDebug.traceCh("HAPP","[" + mHappeningTypeDef.mSku + "] currentProgress = " + this.getCurrentProgress() + ", target = " + this.getTarget());
         var happening:Happening = getHappening();
         if(happening.isExpired() || this.getCurrentProgress() >= this.getTarget())
         {
            happening.stateChangeState(3,true);
            return true;
         }
         if(InstanceMng.getWaveSpawnDefMng().isLastWave((mHappeningTypeDef as HappeningTypeWaveDef).getWavesSpawnGroup(),this.mHQLevel.value,this.mIdxCurrentWave.value) == false)
         {
            this.mIdxCurrentWave.value++;
            this.mCurrentWave = InstanceMng.getWaveSpawnDefMng().getCurrentWave((mHappeningTypeDef as HappeningTypeWaveDef).getWavesSpawnGroup(),this.mHQLevel.value,this.mIdxCurrentWave.value);
            this.mCurrentWaveSku.value = this.mCurrentWave.mSku;
         }
         this.mTimeOver.value = InstanceMng.getApplication().getCurrentServerTimeMillis() + this.mCurrentWave.getCountdown();
         this.stateChangeState(0,true);
         return false;
      }
      
      public function speedUpWave(transaction:Transaction, timeLeftWave:Number) : void
      {
         this.mTimeLeft.value = timeLeftWave;
         this.mSpeedUpWaveTrans = transaction;
         this.stateChangeState(1,true);
      }
      
      public function viewExitState() : void
      {
         if(InstanceMng.getHappeningMng().isHappeningInHud(getHappeningSku()))
         {
            switch(mState - -1)
            {
               case 0:
               case 1:
               case 2:
               case 3:
               case 4:
                  InstanceMng.getHappeningMng().hudRemoveHappeningIcon();
            }
         }
      }
      
      public function viewEnterState() : void
      {
         var happening:Happening = null;
         var happeningDef:HappeningDef = null;
         var popupSkinDef:PopupSkinDef = null;
         var assetPath:String = null;
         var iconFilename:String = null;
         var event:Object = null;
         var tidText:int = 0;
         var tidTip:int = 0;
         if(InstanceMng.getHappeningMng().isHappeningInHud(getHappeningSku()))
         {
            switch(mState - -1)
            {
               case 0:
                  break;
               case 1:
                  happeningDef = (happening = getHappening()).getHappeningDef();
                  if((popupSkinDef = InstanceMng.getPopupSkinDefMng().getDefBySku(happeningDef.getPopupSkin()) as PopupSkinDef) != null)
                  {
                     assetPath = String(ResourceMng[popupSkinDef.getResourcePopupId()]);
                  }
                  iconFilename = this.mShowShopOffers.value ? InstanceMng.getHappeningDefMng().getHappeningGraphic(mHappeningTypeDef.mSku,"icon_shop_offer") : InstanceMng.getHappeningDefMng().getHappeningGraphic(mHappeningTypeDef.mSku,"icon_countdown_waves");
                  (event = InstanceMng.getGUIControllerPlanet().createNotifyEvent("EventPopup","NotifyHappeningTypeWaveCountdown")).happeningTypeDef = mHappeningTypeDef;
                  event.happeningSku = happeningDef.mSku;
                  tidText = 3192;
                  tidTip = 1673;
                  InstanceMng.getHappeningMng().hudSetHappeningIcon(getHappeningSku());
                  break;
               case 2:
               case 3:
                  break;
               case 4:
                  InstanceMng.getUIFacade().setContestIconTip(null);
            }
         }
      }
      
      override public function persistenceGetData() : XML
      {
         return <Type HQlevel="{this.mHQLevel.value}" currentWaveIdx="{this.mIdxCurrentWave.value}" state="{mState}" timeOver="{this.mTimeOver.value}" unitsKilledTotal="{this.mUnitsKilledTotal.value}" unitsKilledThisWave="{this.mUnitsKilledCurrentWave.value}"/>;
      }
      
      public function getCurrentWave() : WaveSpawnDef
      {
         return this.mCurrentWave;
      }
      
      public function getIdxCurrentWave() : int
      {
         return this.mIdxCurrentWave.value;
      }
      
      public function getWavesDone() : int
      {
         return this.mWavesDone.value;
      }
      
      public function getCurrentWaveDelayed() : int
      {
         return this.mCurrentWaveDelayed.value;
      }
      
      public function getHQLevel() : int
      {
         return this.mHQLevel.value;
      }
      
      public function getTimeOver() : Number
      {
         return this.mTimeOver.value;
      }
      
      override public function getCurrentWaveMaxEnemies() : int
      {
         var allWaves:String = null;
         var defsList:Vector.<UnitDef> = null;
         var amounts:Vector.<int> = null;
         var amount:int = 0;
         var maxEnemies:int = 0;
         if(this.mCurrentWave != null)
         {
            allWaves = InstanceMng.getRuleMng().waveSpawnGetAttack(this.mCurrentWave.getWave());
            defsList = new Vector.<UnitDef>(0);
            amounts = new Vector.<int>(0);
            InstanceMng.getUnitScene().wavesGetUnitDefsFromString(allWaves,false,defsList,amounts);
            for each(amount in amounts)
            {
               maxEnemies += amount;
            }
         }
         return maxEnemies;
      }
      
      override public function getCurrentProgress() : int
      {
         return this.mUnitsKilledTotal.value;
      }
      
      override public function getCurrentWaveProgress() : int
      {
         return this.mUnitsKilledCurrentWave.value;
      }
      
      override public function getTarget() : int
      {
         if(this.mTarget.value == -1)
         {
            this.mTarget.value = HappeningTypeWaveDef(mHappeningTypeDef).getTarget(this.mHQLevel.value);
         }
         return this.mTarget.value;
      }
      
      override public function addProgress(value:int) : void
      {
         DCDebug.traceCh("HAPP","HappeningTypeWave addProgress " + value + " added to existing total of " + this.mUnitsKilledTotal.value);
         this.mUnitsKilledCurrentWave.value = value;
         this.mUnitsKilledTotal.value += this.mUnitsKilledCurrentWave.value;
      }
      
      override public function setShopOffers(value:Boolean) : void
      {
         this.mShowShopOffers.value = value;
         if(mState == 0)
         {
            this.viewExitState();
            this.viewEnterState();
         }
      }
   }
}
