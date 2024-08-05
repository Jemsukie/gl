package com.dchoc.game.model.world.target.missions
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.facade.TopHudFacade;
   import com.dchoc.game.eview.popups.missions.EPopupMissionProgress;
   import com.dchoc.game.model.flow.FlowStatePlanet;
   import com.dchoc.game.model.items.ItemObject;
   import com.dchoc.game.model.space.Planet;
   import com.dchoc.game.model.target.Target;
   import com.dchoc.game.model.target.TargetDef;
   import com.dchoc.game.model.target.TargetDefMng;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.game.model.userdata.UserInfoMng;
   import com.dchoc.game.view.facade.UIFacade;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.DCTargetDef;
   import com.dchoc.toolkit.core.target.DCTargetMng;
   import com.dchoc.toolkit.core.target.DCTargetProviderInterface;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   import esparragon.events.EEvent;
   import esparragon.utils.EUtils;
   import flash.utils.setTimeout;
   
   public class MissionsMng extends DCComponent implements DCTargetProviderInterface
   {
      
      private static const MISSION_UNLOCK_FREEZE_TURRET_SKU:String = "mission_057";
      
      public static const MAX_MISSIONS_IN_HUD:int = 5;
       
      
      private var mMissionSkus:Array;
      
      private var mMissionsShown:Array;
      
      private var mMissionsWaiting:Array;
      
      private var mMissionCompletePopupsWaiting:Vector.<Object>;
      
      private var mMissionsHidden:Boolean;
      
      public var mMissionsInHudCount:int;
      
      public var mMissionDropAllowed:Boolean = true;
      
      public var mMissionDropDelay:int = 1000;
      
      private var mNeedsToCheckFixMissions:Boolean = false;
      
      private var mGuiMissionSku:String;
      
      private var mGuiMissionInfoPopup:DCIPopup;
      
      private var mGuiEvent:Object;
      
      public function MissionsMng()
      {
         super();
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildSyncTotalSteps = 1;
         mBuildAsyncTotalSteps = 0;
      }
      
      override protected function loadDoStep(step:int) : void
      {
         super.loadDoStep(step);
         if(step == 0)
         {
            this.mMissionSkus = [];
            this.mMissionSkus[0] = [];
            this.mMissionSkus[1] = [];
            this.mMissionSkus[2] = [];
            this.mMissionSkus[3] = [];
            this.mMissionSkus[4] = [];
         }
      }
      
      override protected function unloadDo() : void
      {
         delete this.mMissionSkus[0];
         delete this.mMissionSkus[1];
         delete this.mMissionSkus[2];
         delete this.mMissionSkus[3];
         delete this.mMissionSkus[4];
         this.mMissionSkus = null;
         this.guiUnload();
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         if((InstanceMng.getMapView() != null && InstanceMng.getMapView().isBuilt()) == false)
         {
            return;
         }
         if(step == 0 && mPersistenceData != null && InstanceMng.getTargetMng().isBuilt())
         {
            if(InstanceMng.getUserInfoMng().getProfileLogin().isTutorialCompleted())
            {
               if(FlowStatePlanet.smMissionsEngineEnabled == true)
               {
                  this.loadFromXML();
               }
            }
            buildAdvanceSyncStep();
         }
      }
      
      public function loadFromXML() : void
      {
         var targetDef:TargetDef = null;
         var currentTime:Number = NaN;
         var missionDef:DCTargetDef = null;
         var id:String = null;
         var missionsXML:XML = null;
         var commaArr:Array = null;
         var state:int = 0;
         var dotArr:Array = null;
         var timedTarget:XML = null;
         var sku:String = null;
         var target:DCTarget = null;
         var targetDefMng:TargetDefMng = InstanceMng.getTargetDefMng();
         var targetMng:DCTargetMng = InstanceMng.getTargetMng();
         var vTargets:Array = [];
         var vMissionDefs:Vector.<DCDef> = targetDefMng.getMissionDefs();
         for each(missionDef in vMissionDefs)
         {
            id = String(missionDef.mSku);
            vTargets[id] = new Target(missionDef,0,this);
            this.mMissionSkus[0].push(id);
         }
         state = 4;
         for each(missionsXML in EUtils.xmlGetChildrenList(mPersistenceData,"Rewarded"))
         {
            commaArr = EUtils.xmlReadString(missionsXML,"chunk").split(",");
            for each(id in commaArr)
            {
               this.changeState(id,state,null,true);
            }
         }
         state = 3;
         for each(missionsXML in EUtils.xmlGetChildrenList(mPersistenceData,"Completed"))
         {
            commaArr = EUtils.xmlReadString(missionsXML,"chunk").split(",");
            for each(id in commaArr)
            {
               this.changeState(id,state,null,true);
            }
         }
         state = 1;
         for each(missionsXML in EUtils.xmlGetChildrenList(mPersistenceData,"ReadyToStart"))
         {
            commaArr = EUtils.xmlReadString(missionsXML,"chunk").split(",");
            for each(id in commaArr)
            {
               if(id != "")
               {
                  targetMng.addTarget(DCTarget(vTargets[id]),state);
                  this.changeState(id,state,null,true);
               }
            }
         }
         state = 2;
         for each(missionsXML in EUtils.xmlGetChildrenList(mPersistenceData,"Available"))
         {
            commaArr = EUtils.xmlReadString(missionsXML,"chunk").split(",");
            for each(id in commaArr)
            {
               if(id != "")
               {
                  dotArr = id.split(":");
                  id = String(dotArr[0]);
                  targetMng.addTarget(DCTarget(vTargets[id]),state);
                  this.changeState(id,state,null,true);
                  targetMng.addProgress(id);
               }
            }
         }
         for each(missionsXML in EUtils.xmlGetChildrenList(mPersistenceData,"Params"))
         {
            for each(timedTarget in EUtils.xmlGetChildrenList(missionsXML,"Target"))
            {
               sku = EUtils.xmlReadString(timedTarget,"sku");
               if((target = InstanceMng.getTargetMng().getTargetById(sku)) == null)
               {
                  DCDebug.trace("[ASSERT]:The target with Sku: " + sku + " should exist, but was not found. XML params loading skipped.",1);
               }
               else
               {
                  target.setXMLParams(timedTarget);
               }
            }
         }
         for each(var stateArray in this.mMissionSkus)
         {
            for each(id in stateArray)
            {
               targetDef = InstanceMng.getTargetDefMng().getDefBySku(id) as TargetDef;
               currentTime = InstanceMng.getUserDataMng().getServerCurrentTimemillis();
               if(targetDef != null && targetDef.validDateHasAnyDate() && targetDef.validDateHasExpired(currentTime))
               {
                  target = InstanceMng.getTargetMng().getTargetById(id);
                  this.changeState(id,4,null,true);
               }
            }
         }
         state = 0;
         for each(id in this.mMissionSkus[state])
         {
            targetMng.addTarget(DCTarget(vTargets[id]),state);
         }
         state = 3;
         for each(id in this.mMissionSkus[state])
         {
            targetMng.addTarget(DCTarget(vTargets[id]),state);
         }
         state = 4;
         for each(id in this.mMissionSkus[state])
         {
            targetMng.addTarget(DCTarget(vTargets[id]),state);
         }
         this.mNeedsToCheckFixMissions = true;
      }
      
      private function changeState(id:String, stateId:int, trans:Transaction = null, doNotNotifyServer:Boolean = false, itemRewardSku:String = "") : void
      {
         var idx:int = 0;
         var state:int = 0;
         if(id == "")
         {
            return;
         }
         if(this.mMissionSkus[stateId].indexOf(id) > -1)
         {
            return;
         }
         this.mMissionSkus[stateId].push(id);
         var oldState:int = InstanceMng.getTargetMng().getTargetStateById(id);
         if(!doNotNotifyServer)
         {
            InstanceMng.getUserDataMng().updateMissions_newState(id,stateId,trans,itemRewardSku);
         }
         this.showMissionInHud(id,stateId);
         for(state = 0; state < 5; )
         {
            idx = int(this.mMissionSkus[state].indexOf(id));
            if(stateId != state && idx > -1)
            {
               this.eraseMissionInHud(id,stateId);
               delete this.mMissionSkus[state][idx];
               return;
            }
            state++;
         }
      }
      
      private function eraseMissionInHud(id:String, stateId:int) : void
      {
         if(this.mMissionsShown != null && this.mMissionsShown.indexOf(id) > -1)
         {
            if(stateId > 2)
            {
               this.mMissionsInHudCount--;
               this.mMissionsShown.splice(this.mMissionsShown.indexOf(id),1);
            }
         }
         if(this.hasToShowMissions())
         {
            this.checkIfAnyMissionWaiting();
         }
      }
      
      public function hideTemporarilyMissionsInHud() : void
      {
         InstanceMng.getTopHudFacade().missionsHideAll();
         this.mMissionsHidden = true;
      }
      
      public function showBackMissionsInHud() : void
      {
         if(this.mMissionsHidden == true && this.hasToShowMissions())
         {
            InstanceMng.getTopHudFacade().missionsShowAll();
            this.mMissionsHidden = false;
         }
      }
      
      public function areMissionsHidden() : Boolean
      {
         return this.mMissionsHidden;
      }
      
      private function showMissionInHud(id:String, stateId:int) : void
      {
         var hud:TopHudFacade = null;
         var def:TargetDef;
         if((def = InstanceMng.getTargetDefMng().getDefBySku(id) as TargetDef) != null && def.getHiddenInHud() == true)
         {
            return;
         }
         if(this.mMissionsShown == null)
         {
            this.mMissionsShown = [];
         }
         var bHasToShowMissions:Boolean = this.hasToShowMissions();
         var correctState:Boolean = stateId > 0 && stateId < 3;
         var isNewMission:* = this.mMissionsShown.indexOf(id) < 0;
         var enoughSpaceInHud:* = this.mMissionsInHudCount < 5;
         if(bHasToShowMissions && correctState && enoughSpaceInHud && this.isMissionDroppingAllowed() && mIsBegun && this.mMissionsHidden == false)
         {
            if(isNewMission)
            {
               this.mMissionsInHudCount++;
               this.mMissionsShown.push(id);
            }
            if((hud = InstanceMng.getTopHudFacade()) != null)
            {
               hud.missionsChangeState(id,stateId);
            }
         }
         else if(this.mMissionsShown.indexOf(id) < 0)
         {
            if(this.mMissionsWaiting == null)
            {
               this.mMissionsWaiting = [];
            }
            this.mMissionsWaiting.push(id);
         }
      }
      
      public function checkIfAnyMissionWaiting() : void
      {
         var missionSku:String = null;
         var missionState:int = 0;
         if(this.mMissionsWaiting != null && this.mMissionsInHudCount < 5)
         {
            missionSku = this.mMissionsWaiting.pop();
            missionState = InstanceMng.getTargetMng().getTargetStateById(missionSku);
            if(missionState < 3)
            {
               this.showMissionInHud(missionSku,missionState);
            }
         }
      }
      
      public function checkIfAnyMissionCompletePopupWaiting() : void
      {
         var missionObj:Object = null;
         if(this.mMissionCompletePopupsWaiting != null)
         {
            missionObj = this.mMissionCompletePopupsWaiting.pop();
            if(missionObj != null)
            {
               this.onChangeStateToComplete(missionObj);
            }
         }
      }
      
      public function isMissionStarted(missionSku:String) : Boolean
      {
         var state:int = InstanceMng.getTargetMng().getTargetStateById(missionSku);
         return state >= 2;
      }
      
      public function isMissionEnded(missionSku:String) : Boolean
      {
         var state:int = InstanceMng.getTargetMng().getTargetStateById(missionSku);
         return state > 2;
      }
      
      public function isJailMissionActive() : Boolean
      {
         return this.isMissionStarted("mission_010");
      }
      
      public function getMissionName(missionSku:String) : String
      {
         var d:DCTargetDef = null;
         var t:DCTarget = InstanceMng.getTargetMng().getTargetById(missionSku);
         if(t != null)
         {
            d = t.getDef();
            if(d != null)
            {
               return DCTextMng.getText(TextIDs[d.getTargetTitle()]);
            }
         }
         return null;
      }
      
      private function hasToShowMissions() : Boolean
      {
         var userProfile:Profile = null;
         var user:UserInfo = null;
         var planet:Planet = null;
         var hasToShowMissions:* = InstanceMng.getRole().hasToShowMissions();
         if(hasToShowMissions)
         {
            user = (userProfile = InstanceMng.getUserInfoMng().getProfileLogin()).getUserInfoObj();
            if(user)
            {
               planet = user.getPlanetById(userProfile.getCurrentPlanetId());
               hasToShowMissions = planet != null;
            }
         }
         return hasToShowMissions;
      }
      
      override public function notify(e:Object) : Boolean
      {
         var state:int = InstanceMng.getTargetMng().getTargetStateById(e.item.Id);
         var trans:Transaction = null;
         switch(e.type)
         {
            case "EVENT_TARGET_CHANGE_STATE":
               if(state == 3)
               {
                  if(this.isMissionDroppingAllowed())
                  {
                     this.onChangeStateToComplete(e);
                  }
                  else
                  {
                     this.addMissionCompletePopupToWaitCue(e);
                  }
               }
               else
               {
                  this.changeState(e.item.Id,state,trans);
               }
               break;
            case "EVENT_SHOW_POPUP":
               this.openMissionPopup(e.item.Id,state);
         }
         return true;
      }
      
      private function onChangeStateToComplete(e:Object) : void
      {
         var missionId:String = String(e.item.Id);
         var state:int = InstanceMng.getTargetMng().getTargetStateById(missionId);
         var target:DCTarget;
         var targetDef:TargetDef = (target = e.target).getDef() as TargetDef;
         var allowChangeState:Boolean = true;
         var trans:Transaction = null;
         if(targetDef.getHiddenInHud() == false)
         {
            this.mMissionDropAllowed = false;
            this.openMissionPopup(missionId,state,target);
         }
         if(allowChangeState)
         {
            trans = this.performOpsOnTargetComplete(target);
            this.changeState(missionId,state,trans);
            if(targetDef.getRepeatable())
            {
               this.changeState(missionId,1);
            }
         }
      }
      
      private function addMissionCompletePopupToWaitCue(obj:Object) : void
      {
         if(this.mMissionCompletePopupsWaiting == null)
         {
            this.mMissionCompletePopupsWaiting = new Vector.<Object>(0);
         }
         var target:DCTarget = DCTarget(obj.target);
         if(this.mMissionCompletePopupsWaiting.indexOf(target) == -1)
         {
            this.mMissionCompletePopupsWaiting.push(obj);
         }
      }
      
      private function performOpsOnTargetComplete(target:DCTarget) : Transaction
      {
         var rewardArr:Array = null;
         var amount:int = 0;
         var item:ItemObject = null;
         var profile:Profile = null;
         var REWARD_PACK_VALUE:int = 0;
         var targetDef:TargetDef;
         var rewardCoins:String = String((targetDef = target.getDef() as TargetDef).getRewardCoins());
         var rewardMinerals:String = String(targetDef.getRewardMinerals());
         var rewardXp:String = String(targetDef.getRewardXp());
         var rewardCash:String = String(targetDef.getRewardCash());
         var rewardItemSku:String = targetDef.getRewardItemSku(false);
         var coins:Number = parseInt(rewardCoins);
         var minerals:Number = parseInt(rewardMinerals);
         var cash:Number = parseInt(rewardCash);
         var transaction:Transaction = InstanceMng.getRuleMng().createSingleTransaction(false,Number(rewardCash),Number(rewardCoins),Number(rewardMinerals),Number(rewardXp));
         if(rewardItemSku != null && rewardItemSku != "")
         {
            rewardArr = rewardItemSku.split(":");
            amount = int(rewardArr[1] != null ? int(rewardArr[1]) : 1);
            rewardItemSku = String(rewardArr[0]);
            if((item = InstanceMng.getItemsMng().getItemObjectBySku(rewardItemSku)) != null)
            {
               transaction.addTransItem(rewardItemSku,amount,false);
            }
         }
         if(coins > 0 || minerals > 0)
         {
            profile = InstanceMng.getUserInfoMng().getProfileLogin();
            if(coins > 0 && coins + profile.getCoins() > profile.getCoinsCapacity() || minerals > 0 && minerals + profile.getMinerals() > profile.getMineralsCapacity())
            {
               REWARD_PACK_VALUE = 1000;
               coins = targetDef.getRewardCoins();
               minerals = targetDef.getRewardMinerals();
               if(coins > 0)
               {
                  amount = coins / REWARD_PACK_VALUE;
                  transaction.setTransCoins(0);
                  transaction.addTransItem("5003",amount,false);
               }
               if(minerals > 0)
               {
                  amount = minerals / REWARD_PACK_VALUE;
                  transaction.setTransMinerals(0);
                  transaction.addTransItem("5004",amount,false);
               }
            }
         }
         transaction.performAllTransactions();
         return transaction;
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var userInfoMng:UserInfoMng = null;
         var profile:Profile = null;
         var target:DCTarget = null;
         var i:int = 0;
         if(this.mNeedsToCheckFixMissions)
         {
            if(!this.isMissionEnded("mission_057"))
            {
               if((userInfoMng = InstanceMng.getUserInfoMng()).isBuilt())
               {
                  profile = userInfoMng.getProfileLogin();
                  if(profile != null && profile.isBuilt())
                  {
                     this.mNeedsToCheckFixMissions = false;
                     if(profile.flagsGetBlackHoleBattleWonPopupWasShown())
                     {
                        if((target = InstanceMng.getTargetMng().getTargetById("mission_057")) != null)
                        {
                           for(i = target.State + 1; i <= 3; )
                           {
                              target.changeState(i);
                              i++;
                           }
                        }
                     }
                  }
               }
            }
            else
            {
               this.mNeedsToCheckFixMissions = false;
            }
         }
         if(this.isMissionDroppingAllowed())
         {
            this.checkIfAnyMissionWaiting();
            this.checkIfAnyMissionCompletePopupWaiting();
         }
      }
      
      public function openMissionPopup(id:String, state:int, eventTarget:DCTarget = null) : void
      {
         var targetDef:TargetDef;
         var target:DCTarget = null;
         var event:Object = null;
         var eventName:String = null;
         var delay:Number = NaN;
         if(eventTarget == null)
         {
            target = InstanceMng.getTargetMng().getTargetById(id);
         }
         else
         {
            target = eventTarget;
         }
         targetDef = TargetDef(target.getDef());
         if(targetDef != null && state == 1)
         {
            if(targetDef.skipMissionInfoPopup())
            {
               state = 2;
            }
         }
         switch(state - 1)
         {
            case 0:
               eventName = "NotifyMissionInfo";
               break;
            case 1:
               eventName = "NotifyMissionProgress";
               break;
            case 2:
               eventName = "NotifyMissionCompleted";
               if(target.getDef().mSku == InstanceMng.getSettingsDefMng().getMercenariesUnlockMissionSku())
               {
                  eventName = "NotifyMercenariesMissionCompleted";
                  break;
               }
         }
         event = InstanceMng.getGUIController().createNotifyEvent("EventPopup",eventName);
         event.target = target;
         if(target != null)
         {
            event.missionSku = target.getDef().getSku();
         }
         if(state == 3)
         {
            delay = 1000;
         }
         else
         {
            delay = 0;
         }
         setTimeout(function():void
         {
            sendEventToGUIController(event);
         },delay);
      }
      
      private function sendEventToGUIController(event:Object) : void
      {
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),event,true);
      }
      
      public function enableMissionDrop(value:Boolean) : void
      {
         this.mMissionDropAllowed = value;
      }
      
      public function isMissionDroppingAllowed() : Boolean
      {
         return this.mMissionDropAllowed && InstanceMng.getApplication().viewGetMode() == 0 && this.hasToShowMissions();
      }
      
      override public function persistenceGetData() : XML
      {
         var id:String = null;
         var xml:XML = null;
         var targetMng:DCTargetMng = InstanceMng.getTargetMng();
         var chunkDead:String = "";
         var chunkCompleted:String = "";
         var chunkAvailable:String = "";
         var chunkReadyToStart:String = "";
         var arrayDead:Array = this.mMissionSkus[4];
         var arrayCompleted:Array = this.mMissionSkus[3];
         var arrayAvailable:Array = this.mMissionSkus[2];
         var arrayReadyToStart:Array = this.mMissionSkus[1];
         for each(id in arrayDead)
         {
            chunkDead += id + ",";
         }
         for each(id in arrayCompleted)
         {
            chunkCompleted += id + ",";
         }
         for each(id in arrayAvailable)
         {
            chunkAvailable += id + ":" + targetMng.getProgress(id) + ",";
         }
         for each(id in arrayReadyToStart)
         {
            chunkReadyToStart += id + ",";
         }
         xml = EUtils.stringToXML("<Missions/>");
         xml.appendChild(EUtils.stringToXML("<Rewarded chunk=\"" + chunkDead + "\"/>"));
         xml.appendChild(EUtils.stringToXML("<Completed chunk=\"" + chunkCompleted + "\"/>"));
         xml.appendChild(EUtils.stringToXML("<ReadyToStart chunk=\"" + chunkReadyToStart + "\"/>"));
         xml.appendChild(EUtils.stringToXML("<Available chunk=\"" + chunkAvailable + "\"/>"));
         return xml;
      }
      
      public function getMissionsByState(stateId:int) : Array
      {
         var array:Array = this.mMissionSkus[stateId];
         if(!array)
         {
            array = [];
         }
         return array.concat();
      }
      
      public function skipMissionByPosition(pos:int) : void
      {
      }
      
      public function setMissionToState(sku:String, state:int) : void
      {
         var target:DCTarget = null;
         var isValidState:Boolean = state >= 0 && state < 5;
         if(!isValidState)
         {
            DCDebug.trace("Tried to set mission sku " + sku + " to invalid state " + state);
            return;
         }
         for each(var stateArray in this.mMissionSkus)
         {
            for each(var missionSku in stateArray)
            {
               if(sku == missionSku)
               {
                  (target = InstanceMng.getTargetMng().getTargetById(sku)).changeState(state);
                  DCDebug.trace("Setting mission sku " + sku + " to state " + state);
                  return;
               }
            }
         }
         DCDebug.trace("Tried to set state of invalid mission sku " + sku);
      }
      
      public function getNumOfMissionsInHud() : int
      {
         return this.mMissionsInHudCount;
      }
      
      public function getMissionDropDelay() : int
      {
         return this.mMissionDropDelay;
      }
      
      public function setMissionDropDelay(value:int) : void
      {
         this.mMissionDropDelay = value;
         DCDebug.trace("Missions drop time set to: " + value + " ms");
      }
      
      public function isThisStateUseful(state:int) : Boolean
      {
         return true;
      }
      
      public function doNPCAttackProgressCheckFromWorld(survivalPercent:int) : void
      {
         var requirement:int = 0;
         var target:DCTarget = null;
         var i:int = 0;
         for each(var missionSku in this.mMissionsShown)
         {
            if(this.isMissionStarted(missionSku))
            {
               target = InstanceMng.getTargetMng().getTargetById(missionSku);
               for(i = 0; i < target.getDef().getNumMinitargetsFound(); )
               {
                  if(target.getDef().getMiniTargetReceiveAttack(i))
                  {
                     if((requirement = target.getDef().getMiniTargetAttackBound(i)) == 0 || survivalPercent >= requirement)
                     {
                        InstanceMng.getTargetMng().updateProgress("resistAttack",1);
                     }
                  }
                  i++;
               }
            }
         }
      }
      
      public function getExtraUnitsForUncompletedTargets(hangarId:String) : Vector.<Array>
      {
         var missionSku:String = null;
         var target:DCTarget = null;
         var params:String = null;
         var i:int = 0;
         var v:Vector.<Array> = null;
         var max:int = 3;
         for each(missionSku in this.mMissionsShown)
         {
            if(this.isMissionStarted(missionSku))
            {
               target = InstanceMng.getTargetMng().getTargetById(missionSku);
               for(i = 0; i < max; )
               {
                  if((params = target.getDef().getMiniTargetTypeParameter(i)) != null)
                  {
                     var _loc8_:* = target.getDef().getMiniTargetTypes(i);
                     if("killEnemyUnit" === _loc8_)
                     {
                        if((params = InstanceMng.getRuleMng().npcsGetAttack(params)) != null)
                        {
                           v = InstanceMng.getUnitScene().getUniqueVectorFromWaves(v,params,hangarId);
                        }
                     }
                  }
                  i++;
               }
            }
         }
         return v;
      }
      
      private function guiUnload() : void
      {
         this.guiResetPopup();
      }
      
      private function guiResetPopup() : void
      {
         this.mGuiMissionSku = null;
         this.mGuiMissionInfoPopup = null;
         this.mGuiEvent = null;
      }
      
      private function guiOnClosePopup(e:EEvent = null) : void
      {
         if(this.mGuiEvent != null)
         {
            this.mGuiEvent.button = "EventCloseButtonPressed";
            InstanceMng.getGUIControllerPlanet().notify(this.mGuiEvent);
            this.guiResetPopup();
         }
      }
      
      public function guiOpenMissionInfoPopup(missionSku:String) : DCIPopup
      {
         var title:String = null;
         var body:String = null;
         var buttonText:String = null;
         var i:int = 0;
         var sound:* = null;
         var advisorState:String = null;
         this.mGuiMissionSku = missionSku;
         var uiFacade:UIFacade = InstanceMng.getUIFacade();
         var targetDef:DCTargetDef = InstanceMng.getTargetDefMng().getDefBySku(missionSku) as DCTargetDef;
         var titleTid:String = targetDef.getTutorialTitle();
         var bodyTid:String = targetDef.getTutorialBody();
         var buttonTid:String = targetDef.getTutorialButton();
         if(missionSku == InstanceMng.getSettingsDefMng().getMercenariesUnlockMissionSku())
         {
            this.mGuiMissionInfoPopup = uiFacade.getPopupFactory().getMissionMercenariesInfo(titleTid,bodyTid,buttonTid,this.guiOpenMissionInfoPopupOnAccept);
            uiFacade.enqueuePopup(this.mGuiMissionInfoPopup);
         }
         else
         {
            title = DCTextMng.stringTidToText(titleTid);
            body = DCTextMng.stringTidToText(bodyTid);
            buttonText = DCTextMng.stringTidToText(buttonTid);
            i = int(Math.random() * 3) + 1;
            sound = "Body_" + i + ".mp3";
            advisorState = targetDef.getAdvisorPresentation() + "_normal";
            this.mGuiMissionInfoPopup = InstanceMng.getApplication().speechPopupOpen(advisorState,title,body,buttonText,sound,this.guiOpenMissionInfoPopupOnAccept,false,true,100);
         }
         return this.mGuiMissionInfoPopup;
      }
      
      private function guiOpenMissionInfoPopupOnAccept(e:EEvent = null) : void
      {
         var obj:Object = null;
         var uiFacade:UIFacade = InstanceMng.getUIFacade();
         uiFacade.closePopup(this.mGuiMissionInfoPopup,null,true);
         if(this.mGuiMissionSku == "mission_000")
         {
            uiFacade.blackStripsShow(true);
            InstanceMng.getMapViewPlanet().mouseEventsSetEnabledAnimsOnMap(false,true);
            InstanceMng.getVisitorMng().uiSetIsEnabled(false);
            InstanceMng.getFlowStatePlanet().createTutorialKidnapMng();
            InstanceMng.getTutorialKidnapMng().setupVars();
         }
         else
         {
            obj = {};
            obj = InstanceMng.getGUIController().createNotifyEvent("EventPopup","NotifyMissionProgress");
            obj["target"] = InstanceMng.getGUIControllerPlanet();
            obj["missionSku"] = this.mGuiMissionSku;
            InstanceMng.getNotifyMng().addEvent(obj.target,obj,true);
         }
         this.guiResetPopup();
      }
      
      public function guiOpenMissionMercenariesCompletedPopup(e:Object, missionSku:String) : DCIPopup
      {
         this.mGuiMissionSku = missionSku;
         this.mGuiEvent = e;
         var uiFacade:UIFacade = InstanceMng.getUIFacade();
         var targetDef:DCTargetDef = InstanceMng.getTargetDefMng().getDefBySku(missionSku) as DCTargetDef;
         var titleTid:String = targetDef.getTutorialTitle();
         var bodyTid:String = "TID_MISSIONS_RESULT_MISSION62";
         e.title = titleTid;
         this.mGuiMissionInfoPopup = uiFacade.getPopupFactory().getMissionMercenariesCompleted(titleTid,bodyTid,this.guiOnClosePopup);
         uiFacade.enqueuePopup(this.mGuiMissionInfoPopup);
         return this.mGuiMissionInfoPopup;
      }
      
      public function guiOpenMissionProgressPopup(missionSku:String) : DCIPopup
      {
         var skinSku:String = null;
         var popup:EPopupMissionProgress = new EPopupMissionProgress();
         var uiFacade:UIFacade = InstanceMng.getUIFacade();
         popup.setup("NotifyMissionProgress",InstanceMng.getViewFactory(),skinSku);
         popup.setTarget(InstanceMng.getTargetMng().getTargetById(missionSku));
         uiFacade.enqueuePopup(popup);
         return popup;
      }
      
      public function guiOpenMissionCompletePopup(e:Object) : DCIPopup
      {
         var uiFacade:UIFacade = InstanceMng.getUIFacade();
         var popup:DCIPopup = uiFacade.getPopupFactory().getMissionCompletePopup(e);
         popup.setEvent(e);
         uiFacade.enqueuePopup(popup,true,true,false);
         return popup;
      }
   }
}
