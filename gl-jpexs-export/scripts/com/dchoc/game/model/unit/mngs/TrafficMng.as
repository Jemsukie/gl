package com.dchoc.game.model.unit.mngs
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.Path;
   import com.dchoc.game.model.unit.UnitScene;
   import com.dchoc.game.model.unit.components.goal.GoalCivil;
   import com.dchoc.game.model.unit.components.goal.GoalDroidWandering;
   import com.dchoc.game.model.unit.components.movement.UnitComponentMovement;
   import com.dchoc.game.model.unit.defs.UnitDef;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.utils.astar.DCPath;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   
   public class TrafficMng extends DCComponent
   {
      
      private static const UNITS_ENABLED:Boolean = true;
      
      private static const DROIDS_GOAL_WANDER_AROUND_HQ:int = 0;
      
      private static const DROIDS_GOAL_GO_TO_ITEM:int = 1;
      
      private static const DROIDS_GOAL_RETURN_TO_HQ:int = 2;
      
      private static const DROIDS_GOAL_WORKING_ON_ITEM:int = 3;
      
      private static const DROIDS_GOAL_GET_IN_HQ:int = 4;
      
      private static const DROIDS_GOAL_IN_HQ:int = 5;
      
      private static const MAX_CIVILS_TURN:int = 3;
      
      private static var CREATE_TIME:int = 5000;
      
      private static var MAX_CIVILS_IN_CITY:int = 15;
      
      private static var CIVILS_PER_HOUSE:int = 2;
       
      
      public var mUnitScene:UnitScene;
      
      private var mUseJumpingMinions:Boolean;
      
      private var mUnits:Dictionary;
      
      private var mUnitsItemsLinkedToUnit:Dictionary;
      
      private var mUnitsUnitsLinkedToItem:Dictionary;
      
      private var mDroidsDroidDef:UnitDef;
      
      private var mDroidsUnits:Vector.<MyUnit>;
      
      private var mDroidToRelease:MyUnit;
      
      private var mCivilsCount:int;
      
      private var mCivilItems:Vector.<WorldItemObject>;
      
      private var mCivilDef:UnitDef;
      
      private var mTimeToWaitCreateCivil:int;
      
      private var mWarWasBegun:Boolean;
      
      private var mCivilsMax:int;
      
      public function TrafficMng()
      {
         super();
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildAsyncTotalSteps = 0;
         mBuildSyncTotalSteps = 2;
      }
      
      override protected function loadDoStep(step:int) : void
      {
         if(step == 0)
         {
            this.unitsLoad();
            this.droidsLoad();
            this.civilsLoad();
         }
      }
      
      override protected function unloadDo() : void
      {
         this.unitsUnload();
         this.droidsUnload();
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         if(step == 0)
         {
            this.mUnitScene = InstanceMng.getUnitScene();
            this.unitsBuild();
            this.mUseJumpingMinions = InstanceMng.getRole().mId == 0;
            buildAdvanceSyncStep();
         }
         else if(step == 1 && InstanceMng.getUserInfoMng().getCurrentProfileLoaded().isBuilt() && InstanceMng.getUserInfoMng().getProfileLogin().isBuilt())
         {
            this.droidsBuild();
            this.applyPopulationSetting(InstanceMng.getUserInfoMng().getProfileLogin().getCivilsPopulation());
            buildAdvanceSyncStep();
         }
      }
      
      override protected function unbuildDo() : void
      {
         this.unitsUnbuild();
         this.droidsUnbuild();
         this.mUnitScene = null;
      }
      
      override protected function beginDo() : void
      {
         this.droidsBegin();
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         if(true)
         {
            this.civilsUpdate(dt);
         }
      }
      
      private function notifyUnit(e:Object, u:MyUnit = null, type:int = -1) : Boolean
      {
         var returnValue:Boolean = false;
         if(type == -1 && u != null)
         {
            type = u.getTypeId();
         }
         switch(type)
         {
            case 0:
               returnValue = this.droidsNotify(e,u);
               break;
            case 1:
               returnValue = this.civilsNotify(e,u);
         }
         switch(e.cmd)
         {
            case "unitEventRemovedFromScene":
               this.unitsReleaseUnit(u);
               break;
            case "unitEventPathEnded":
               if(type == 0)
               {
                  if(u.goalGetCurrentId() != "unitGoalWanderAroundHq")
                  {
                     u.exitSceneStart(1);
                  }
               }
         }
         return returnValue;
      }
      
      override public function notify(e:Object) : Boolean
      {
         var item:WorldItemObject = null;
         var v:Vector.<MyUnit> = null;
         var b:Boolean = false;
         var returnValue:* = false;
         var u:MyUnit = e.unit;
         switch(e.cmd)
         {
            case "battleEventHasStarted":
               MyUnit.smUnitScene.sceneSendEventToUnitType(1,{"cmd":"civilBattleStarted"});
               this.mWarWasBegun = true;
               break;
            case "battleEventHasFinished":
               MyUnit.smUnitScene.sceneSendEventToUnitType(1,{"cmd":"civilBattleEnd"});
               this.mWarWasBegun = false;
               break;
            case "civilBattleStarted":
               u.getGoalComponent().changeState(107);
               break;
            case "civilBattleEnd":
               u.getGoalComponent().changeState(109);
               break;
            default:
               break;
            case "WorldEventPlaceItem":
               this.civilsSendCivilToRide(e.item);
               return true;
         }
         if(u == null)
         {
            item = e.item;
            if(item != null)
            {
               if((v = this.mUnitsUnitsLinkedToItem[item.mSid]) != null)
               {
                  for each(u in v)
                  {
                     b = this.notifyUnit(e,u);
                     if(!returnValue)
                     {
                        returnValue = b;
                     }
                  }
               }
               else if(this.droidsHasThisItemRequestedADroid(item))
               {
                  returnValue = this.notifyUnit(e,null,0);
               }
            }
         }
         else
         {
            returnValue = this.notifyUnit(e,u);
         }
         return returnValue;
      }
      
      private function unitsLoad() : void
      {
      }
      
      private function unitsUnload() : void
      {
      }
      
      private function unitsBuild() : void
      {
         this.mUnits = new Dictionary(true);
         this.mUnitsItemsLinkedToUnit = new Dictionary(true);
         this.mUnitsUnitsLinkedToItem = new Dictionary(true);
      }
      
      private function unitsUnbuild() : void
      {
         var u:MyUnit = null;
         for each(u in this.mUnits)
         {
            if(u != null)
            {
               this.unitsReleaseUnit(u);
            }
         }
         this.mUnits = null;
         this.mUnitsItemsLinkedToUnit = null;
         this.mUnitsUnitsLinkedToItem = null;
      }
      
      private function unitsRegisterUnit(u:MyUnit, itemTo:WorldItemObject, itemFrom:WorldItemObject = null, link:Boolean = false) : void
      {
         this.mUnits[u.mId] = u;
         if(link)
         {
            this.unitsLinkUnitToItem(u,itemTo.mSid);
            if(itemFrom != null)
            {
               this.unitsLinkUnitToItem(u,itemFrom.mSid);
               this.unitsLinkItemToUnit(itemFrom,u);
            }
            this.unitsLinkItemToUnit(itemTo,u);
         }
      }
      
      private function unitsCreateUnit(unitDef:UnitDef, faction:int, itemTo:WorldItemObject, itemFrom:WorldItemObject = null, link:Boolean = false) : MyUnit
      {
         var u:MyUnit = InstanceMng.getUnitScene().unitsCreateUnitFromDef(unitDef,faction);
         this.unitsRegisterUnit(u,itemTo,itemFrom,link);
         return u;
      }
      
      private function unitsReleaseUnit(u:MyUnit) : void
      {
         var v:Vector.<WorldItemObject> = null;
         var item:WorldItemObject = null;
         if(this.mUnits[u.mId] != null)
         {
            this.mUnits[u.mId] = null;
            v = this.mUnitsItemsLinkedToUnit[u];
            if(v != null)
            {
               for each(item in v)
               {
                  this.unitsUnlinkUnitToItem(u,item.mSid);
                  this.unitsUnlinkItemToUnit(item,u);
               }
            }
         }
      }
      
      private function unitsLinkUnitToItem(u:MyUnit, sid:String) : void
      {
         var v:Vector.<MyUnit> = this.mUnitsUnitsLinkedToItem[sid];
         if(v == null)
         {
            v = new Vector.<MyUnit>(0);
            this.mUnitsUnitsLinkedToItem[sid] = v;
         }
         v.push(u);
      }
      
      private function unitsUnlinkUnitToItem(u:MyUnit, sid:String) : void
      {
         var pos:int = 0;
         var v:Vector.<MyUnit>;
         if((v = this.mUnitsUnitsLinkedToItem[sid]) != null)
         {
            pos = v.indexOf(u);
            if(pos > -1)
            {
               v.splice(pos,1);
            }
            if(v.length == 0)
            {
               this.mUnitsUnitsLinkedToItem[sid] = null;
            }
         }
      }
      
      private function unitsLinkItemToUnit(item:WorldItemObject, u:MyUnit) : void
      {
         var v:Vector.<WorldItemObject> = this.mUnitsItemsLinkedToUnit[u];
         if(v == null)
         {
            v = new Vector.<WorldItemObject>(0);
            this.mUnitsItemsLinkedToUnit[u] = v;
         }
         v.push(item);
      }
      
      private function unitsUnlinkItemToUnit(item:WorldItemObject, u:MyUnit) : void
      {
         var pos:int = 0;
         var v:Vector.<WorldItemObject>;
         if((v = this.mUnitsItemsLinkedToUnit[u]) != null)
         {
            pos = v.indexOf(item);
            if(pos > -1)
            {
               v.splice(pos,1);
            }
            if(v.length == 0)
            {
               this.mUnitsItemsLinkedToUnit[u] = null;
            }
         }
      }
      
      private function droidsLoad() : void
      {
         this.mDroidsUnits = new Vector.<MyUnit>(0);
      }
      
      private function droidsUnload() : void
      {
         this.mDroidsUnits = null;
         this.mDroidsDroidDef = null;
      }
      
      private function droidsBuild() : void
      {
         var profile:Profile = null;
         var maxDroids:int = 0;
         var i:int = 0;
         if(this.mDroidsDroidDef == null)
         {
            this.mDroidsDroidDef = InstanceMng.getUnitScene().droidsGetCurrentDroidDef();
         }
         if(true)
         {
            profile = InstanceMng.getUserInfoMng().getCurrentProfileLoaded();
            maxDroids = profile.getMaxDroidsAmount();
            for(i = 0; i < maxDroids; )
            {
               this.droidsCreateDroid(false);
               i++;
            }
         }
      }
      
      private function droidsBegin() : void
      {
         var profile:Profile = null;
         var maxDroids:int = 0;
         var currentDroids:int = 0;
         var length:int = 0;
         var i:int = 0;
         var u:MyUnit = null;
         if(InstanceMng.getRole().mId == 0 || InstanceMng.getFlowStatePlanet().isPlayerInHerCityInTutorial())
         {
            profile = InstanceMng.getUserInfoMng().getCurrentProfileLoaded();
            maxDroids = profile.getMaxDroidsAmount();
            currentDroids = profile.getDroids();
            length = int(this.mDroidsUnits.length);
            i = 0;
            while(i < length && currentDroids > 0)
            {
               u = this.mDroidsUnits[i];
               if(u.goalGetCurrentId() == null)
               {
                  this.droidsSetGoal(u,0);
                  currentDroids--;
               }
               i++;
            }
         }
      }
      
      private function droidsUnbuild() : void
      {
         this.mDroidsUnits.length = 0;
         this.mDroidToRelease = null;
      }
      
      public function droidsCreateDroid(doBuild:Boolean) : void
      {
         var u:MyUnit = InstanceMng.getUnitScene().unitsCreateUnitFromDef(this.mDroidsDroidDef,-1);
         this.mDroidsUnits.push(u);
         if(doBuild)
         {
            this.droidsSetGoal(u,0,null,null,InstanceMng.getWorldItemDefMng().pathRoadHQGetDoorTileIndex());
         }
      }
      
      private function droidsSetGoal(u:MyUnit, goalId:int, pItemTo:WorldItemObject = null, pItemFrom:WorldItemObject = null, pTileIndex:int = -1) : void
      {
         switch(goalId)
         {
            case 0:
               if(pTileIndex == -1)
               {
                  pTileIndex = InstanceMng.getWorldItemDefMng().pathRoadHQGetARandomTileIndex();
               }
               this.mUnitScene.unitsSetGoal(u,"unitGoalWanderAroundHq",{"tileIndex":pTileIndex});
               break;
            case 1:
               this.mUnitScene.unitsSetGoal(u,"unitGoalGoToItem",{
                  "goalFor":"unitGoalForDroidGoToItem",
                  "itemTo":pItemTo,
                  "itemFrom":pItemFrom
               });
               break;
            case 2:
               this.mUnitScene.unitsSetGoal(u,"unitGoalReturnToHQ",{
                  "goalFor":"unitGoalForDroidGoToItem",
                  "itemTo":pItemTo
               });
               break;
            case 3:
               this.mUnitScene.unitsSetGoal(u,"unitGoalWorkingOnItem",{"item":pItemTo});
               if(u.mSecureIsInScene.value)
               {
                  u.exitSceneStart();
               }
               break;
            case 4:
               this.mUnitScene.unitsSetGoal(u,"unitGetInHQ",{
                  "goalFor":"unitGoalForDroidGoToItem",
                  "itemTo":pItemTo
               });
               break;
            case 5:
               this.mUnitScene.unitsSetGoal(u,"unitInHQ",null);
               if(u.mSecureIsInScene.value)
               {
                  u.exitSceneStart(1);
                  break;
               }
         }
      }
      
      public function droidsSetSpeed(droid:MyUnit) : void
      {
         droid.movementResume();
         var speed:Number = droid.mDef.getMaxSpeed();
         var frameRate:int = 0;
         var goal:String = droid.goalGetCurrentId();
         if(goal == "unitGoalWanderAroundHq" || goal == "unitGoalReturnToHQ")
         {
            speed /= 4;
            frameRate = 2;
         }
         droid.getMovementComponent().setMaxSpeed(speed);
         droid.getViewComponent().setFrameRate(frameRate);
      }
      
      public function droidsGetAvailableDroidsCount() : int
      {
         var profile:Profile = InstanceMng.getUserInfoMng().getCurrentProfileLoaded();
         return int(profile.getDroids());
      }
      
      private function droidsGetTimeLeft(item:WorldItemObject) : Number
      {
         var returnValue:Number = 0;
         if(item != null && item.mDroidLabourId != 2)
         {
            returnValue = item.getTimeLeft(false);
         }
         return returnValue;
      }
      
      public function droidsGetSmallestTimeForFreeDroid() : Number
      {
         var item:WorldItemObject = this.droidsGetSmallestTimeForFreeDroidItem();
         return this.droidsGetTimeLeft(item);
      }
      
      private function droidsGetSmallestTimeForFreeDroidItem() : WorldItemObject
      {
         var droid:MyUnit = this.droidsGetSmallestTimeToFinishDroid();
         return droid == null ? null : droid.goalGetItem();
      }
      
      private function droidsGetSmallestTimeToFinishDroid() : MyUnit
      {
         var item:WorldItemObject = null;
         var droid:MyUnit = null;
         var droidSmaller:* = null;
         var goalId:String = null;
         var itemTime:Number = NaN;
         var smallerTime:* = 1.7976931348623157e+308;
         for each(droid in this.mDroidsUnits)
         {
            goalId = String(droid.goalGetCurrentId());
            if(goalId == "unitGoalWorkingOnItem" || goalId == "unitGoalGoToItem")
            {
               item = droid.goalGetItem();
               if(item != null)
               {
                  if((itemTime = this.droidsGetTimeLeft(item)) < smallerTime)
                  {
                     smallerTime = itemTime;
                     droidSmaller = droid;
                  }
               }
            }
         }
         return droidSmaller;
      }
      
      private function droidsNotify(e:Object, u:MyUnit) : Boolean
      {
         var item:WorldItemObject = e.item;
         var goalId:String = null;
         if(u != null)
         {
            goalId = u.goalGetCurrentId();
         }
         switch(e.cmd)
         {
            case "unitEventPathEnded":
               switch(goalId)
               {
                  case "unitGoalGoToItem":
                     this.droidsStartDroidWorking(u);
                     break;
                  case "unitGoalReturnToHQ":
                     this.droidsSetGoal(u,0);
                     break;
                  case "unitGetInHQ":
                     this.droidsSetGoal(u,5);
               }
               break;
            case "unitEventITemDestroyed":
               this.droidsReturnDroidToHQ(item);
         }
         return true;
      }
      
      private function droidsHasThisItemRequestedADroid(item:WorldItemObject) : Boolean
      {
         return true;
      }
      
      public function droidsReturnDroidToHQ(item:WorldItemObject) : void
      {
         var i:int = 0;
         var u:MyUnit = null;
         var goalId:String = null;
         var length:int = int(this.mDroidsUnits.length);
         i = 0;
         while(i < length && u == null)
         {
            u = this.mDroidsUnits[i];
            if(u.goalGetItem() != item)
            {
               u = null;
            }
            i++;
         }
         if(u != null)
         {
            InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),{"cmd":"NOTIFY_DROIDS_PLUS1"},true);
            if(InstanceMng.getBuildingsBufferController().isBufferOpen())
            {
               u.mEmoticon = 0;
               u.exitSceneStart(1);
            }
            else if(item != null && item.mDef.isHeadQuarters())
            {
               this.droidsSetGoal(u,0);
            }
            else
            {
               this.droidsSetGoal(u,2,item);
            }
         }
      }
      
      public function droidsLockDroid(item:WorldItemObject, doRequest:Boolean) : void
      {
         var length:int = 0;
         var i:int = 0;
         var u:MyUnit = null;
         var goalId:String = null;
         var distance:* = NaN;
         var distanceX:Number = NaN;
         var distanceY:Number = NaN;
         var thisDistance:Number = NaN;
         var itemX:Number = NaN;
         var itemY:Number = NaN;
         var droid:* = null;
         if(this.mDroidToRelease == null)
         {
            length = int(this.mDroidsUnits.length);
            distance = 1.7976931348623157e+308;
            itemX = item.mViewCenterWorldX;
            itemY = item.mViewCenterWorldY;
            for(i = 0; i < length; )
            {
               goalId = (u = this.mDroidsUnits[i]).goalGetCurrentId();
               if(doRequest)
               {
                  if(goalId == "unitGoalWanderAroundHq" || goalId == "unitGoalReturnToHQ" || droid == null && i == length - 1)
                  {
                     distanceX = u.mPositionDrawX - itemX;
                     distanceY = u.mPositionDrawY - itemY;
                     if((thisDistance = distanceX * distanceX + distanceY * distanceY) < distance)
                     {
                        distance = thisDistance;
                        droid = u;
                     }
                  }
               }
               else if(goalId == null)
               {
                  droid = u;
                  break;
               }
               i++;
            }
         }
         else
         {
            droid = this.mDroidToRelease;
         }
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),{"cmd":"NOTIFY_DROIDS_MINUS1"},true);
         if(droid != null)
         {
            if(droid == this.mDroidToRelease)
            {
               this.droidsSetGoal(droid,1,item,this.mDroidToRelease.goalGetItem());
               this.mDroidToRelease = null;
            }
            else if(doRequest)
            {
               this.droidsSetGoal(droid,1,item);
            }
            else
            {
               this.droidsSetGoal(droid,3,item);
            }
         }
      }
      
      public function droidsReleaseSmallestTimeDroid() : void
      {
         var droid:MyUnit = this.droidsGetSmallestTimeToFinishDroid();
         if(droid != null)
         {
            this.droidsReleaseDroid(droid);
         }
      }
      
      private function droidsReleaseDroid(droid:MyUnit) : void
      {
         var event:Object = null;
         var transaction:Transaction = null;
         var eventId:String = null;
         this.mDroidToRelease = droid;
         var item:WorldItemObject = droid.goalGetItem();
         if(item != null)
         {
            eventId = null;
            switch(item.mDroidLabourId)
            {
               case 1:
                  eventId = "WIOEventInstantUpgrade";
               case 0:
                  if(eventId == null)
                  {
                     eventId = "WIOEventInstantBuild";
                  }
                  event = InstanceMng.getGUIControllerPlanet().createNotifyEvent(1,eventId,InstanceMng.getWorldItemObjectController(),item,null,null,null);
                  transaction = InstanceMng.getRuleMng().getTransactionPack(event);
                  event.transaction = transaction;
                  event.phase = "OUT";
                  event.button = "EventYesButtonPressed";
                  InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIControllerPlanet(),event,true);
                  break;
               case 2:
                  eventId = "WIOEventInstantDemolish";
                  event = InstanceMng.getGUIController().createNotifyEvent(1,eventId,InstanceMng.getWorldItemObjectController(),item);
                  if((transaction = InstanceMng.getRuleMng().getTransactionPack(event)).performAllTransactions() == true)
                  {
                     InstanceMng.getUserDataMng().updateItem_instantRecicle(int(item.mSid),transaction);
                     InstanceMng.getNotifyMng().addEvent(InstanceMng.getWorldItemObjectController(),{
                        "cmd":"WIOEventDemolitionEnd",
                        "item":item
                     },true);
                     break;
                  }
            }
         }
      }
      
      public function droidsEnableItemsWithDroid(value:Boolean) : void
      {
         var i:int = 0;
         var u:MyUnit = null;
         var goalId:String = null;
         var item:WorldItemObject = null;
         var length:int = int(this.mDroidsUnits.length);
         for(i = 0; i < length; )
         {
            goalId = (u = this.mDroidsUnits[i]).goalGetCurrentId();
            if(goalId == "unitGoalWorkingOnItem")
            {
               item = u.goalGetItem();
               if(value)
               {
                  item.resume();
               }
               else
               {
                  item.pause();
               }
            }
            else if(goalId == "unitGoalGoToItem")
            {
               if(value)
               {
                  u.movementResume();
               }
               else
               {
                  u.movementStop();
               }
            }
            i++;
         }
      }
      
      private function droidsStartDroidWorking(u:MyUnit) : void
      {
         var pItem:WorldItemObject = u.goalGetItem();
         this.droidsSetGoal(u,3,pItem);
         InstanceMng.getNotifyMng().addEvent(InstanceMng.getWorldItemObjectController(),{
            "cmd":"WIOEventWaitingForDroidEnd",
            "item":pItem
         },true);
      }
      
      public function droidsGetOutHQ() : void
      {
         var u:MyUnit = null;
         var goalId:String = null;
         for each(u in this.mDroidsUnits)
         {
            goalId = u.goalGetCurrentId();
            if(goalId == "unitInHQ")
            {
               u.reset();
               this.droidsSetGoal(u,0);
            }
         }
      }
      
      public function droidsGetInHQ() : void
      {
         var u:MyUnit = null;
         var goalId:String = null;
         for each(u in this.mDroidsUnits)
         {
            goalId = u.goalGetCurrentId();
            if(goalId == "unitGoalReturnToHQ" || goalId == "unitGoalWanderAroundHq")
            {
               this.droidsSetGoal(u,4);
            }
            else if(goalId == "unitGoalGoToItem")
            {
               this.droidsStartDroidWorking(u);
            }
         }
      }
      
      public function droidsUpdateWandering() : void
      {
         var goal:GoalDroidWandering = null;
         var u:MyUnit = null;
         var goalId:String = null;
         for each(u in this.mDroidsUnits)
         {
            goalId = u.goalGetCurrentId();
            if(goalId == "unitGoalWanderAroundHq")
            {
               goal = u.getGoalComponent() as GoalDroidWandering;
               if(goal != null)
               {
                  goal.activate();
               }
            }
         }
      }
      
      public function civilsCreateCivil(def:UnitDef, sceneStart:int = -99, faction:int = -99) : MyUnit
      {
         if(sceneStart == -99)
         {
            sceneStart = 2;
         }
         if(faction == -99)
         {
            faction = 1;
         }
         var u:MyUnit;
         (u = InstanceMng.getUnitScene().unitsCreateUnitFromDef(def,faction)).enterSceneStart(sceneStart);
         this.mUnitScene.sceneAddUnit(u);
         this.mCivilsCount++;
         return u;
      }
      
      private function civilsCreateAndFollowPath(itemFrom:WorldItemObject, itemTo:WorldItemObject, path:DCPath) : MyUnit
      {
         var u:MyUnit = this.unitsCreateUnit(this.mCivilDef,-1,itemFrom,itemTo,false);
         this.mUnitScene.sceneAddUnit(u);
         this.mCivilsCount++;
         return u;
      }
      
      private function civilsAssignPath(u:MyUnit, path:DCPath) : void
      {
         var unitPath:Path = new Path();
         unitPath.buildFromSearchResults(path,false,0);
         u.movementFollowPath(unitPath,true);
         u.getGoalComponent().moveFollowPath(1);
      }
      
      public function civilsSendCivilToRide(item:WorldItemObject) : void
      {
         var unit:MyUnit = null;
         var itempos:Vector3D = null;
         var closestUnit:* = null;
         var closestDist:* = NaN;
         var gc:GoalCivil = null;
         var dpos:Vector3D = null;
         var vdist:Vector3D = null;
         var dist:Number = NaN;
         var civilList:Vector.<MyUnit> = InstanceMng.getUnitScene().sceneGetListById(1);
         var candidates:Vector.<MyUnit> = new Vector.<MyUnit>(0);
         for each(unit in civilList)
         {
            if((gc = unit.getGoalComponent() as GoalCivil) != null && (gc.mCurrentState == 100 || gc.mCurrentState == 106))
            {
               candidates.push(unit);
            }
         }
         itempos = new Vector3D(item.mViewCenterWorldX,item.mViewCenterWorldY,0);
         closestUnit = null;
         closestDist = 100000;
         for each(unit in candidates)
         {
            vdist = (dpos = new Vector3D(unit.mPositionDrawX,unit.mPositionDrawY,0)).subtract(itempos);
            if((dist = vdist.length) < closestDist)
            {
               closestUnit = unit;
               closestDist = dist;
               if(dist < 100)
               {
                  break;
               }
            }
         }
         if(closestUnit != null)
         {
            (gc = closestUnit.getGoalComponent() as GoalCivil).goToRide(item);
            InstanceMng.getTargetMng().updateProgress("sendCivilRide",1,item.mDef.mSku);
         }
      }
      
      public function civilsForceDismount(item:WorldItemObject) : void
      {
         var unit:MyUnit = null;
         var gc:GoalCivil = null;
         var civilList:Vector.<MyUnit> = InstanceMng.getUnitScene().sceneGetListById(1);
         for each(unit in civilList)
         {
            if((gc = unit.getGoalComponent() as GoalCivil).getCurrentAttraction() != null && item != null)
            {
               if(gc.getCurrentAttraction().mSid == item.mSid)
               {
                  gc.changeState(114);
                  return;
               }
            }
         }
      }
      
      private function civilsNotify(e:Object, u:MyUnit) : Boolean
      {
         var gc:GoalCivil = null;
         var returnValue:Boolean = true;
         switch(e.cmd)
         {
            case "unitEventRemovedFromScene":
            case "unitEventITemDestroyed":
               this.mCivilsCount--;
               break;
            case "unitEventPathEnded":
               (gc = u.getGoalComponent() as GoalCivil).pathEnded();
               break;
            default:
               returnValue = false;
         }
         return returnValue;
      }
      
      public function civilsLoad() : void
      {
         this.mCivilItems = InstanceMng.getWorld().itemsGetItemsAllowedToSpawnCivils();
         this.mTimeToWaitCreateCivil = CREATE_TIME;
         this.mCivilsCount = 0;
         this.mCivilsMax = 1;
      }
      
      private function civilsUpdate(dt:int) : void
      {
         if(!this.mWarWasBegun && !InstanceMng.getBuildingsBufferController().isBufferOpen())
         {
            this.mTimeToWaitCreateCivil -= dt;
            if(this.mTimeToWaitCreateCivil <= 0)
            {
               this.mCivilsMax = this.mCivilItems.length * CIVILS_PER_HOUSE;
               if(this.mCivilsMax > MAX_CIVILS_IN_CITY)
               {
                  this.mCivilsMax = MAX_CIVILS_IN_CITY;
               }
               if(this.mCivilsCount < this.mCivilsMax)
               {
                  this.createCivil();
               }
               this.mTimeToWaitCreateCivil = CREATE_TIME;
            }
         }
      }
      
      public function createCivil() : void
      {
         var i:int = 0;
         var startItem:WorldItemObject = null;
         var endItem:WorldItemObject = null;
         var validPath:DCPath = null;
         var mov:UnitComponentMovement = null;
         var repeat:Boolean = false;
         var u:MyUnit = null;
         var gc:GoalCivil = null;
         var numItems:int = int(this.mCivilItems.length);
         if(this.mCivilDef == null)
         {
            this.mCivilDef = InstanceMng.getUnitScene().civilsGetCurrentCivilDef();
         }
         var civilsToCreate:int = int(Math.random() * 3) + 1;
         var count:int = 0;
         for(i = 0; i < civilsToCreate; )
         {
            if(this.mCivilsCount >= this.mCivilsMax)
            {
               return;
            }
            do
            {
               repeat = false;
               startItem = this.mCivilItems[int(Math.random() * numItems)];
               endItem = this.mCivilItems[int(Math.random() * numItems)];
               count++;
               if(count == 20 || numItems == 1)
               {
                  endItem = InstanceMng.getMapModel().mAstarStartItem;
                  break;
               }
            }
            while(startItem == null || startItem != null && startItem == endItem || repeat);
            
            if(startItem != endItem && startItem != null && endItem != null)
            {
               u = this.civilsCreateCivil(this.mCivilDef);
               if(!startItem.mIsFlipped)
               {
                  u.setPositionInViewSpace(startItem.mViewCenterWorldX + 35,startItem.mViewCenterWorldY + 25);
               }
               else
               {
                  u.setPositionInViewSpace(startItem.mViewCenterWorldX - 35,startItem.mViewCenterWorldY + 25);
               }
               (mov = u.getMovementComponent()).goToItem(endItem,startItem,false,null);
               (gc = u.getGoalComponent() as GoalCivil).setHome(startItem);
            }
            i++;
         }
      }
      
      public function civilsSetMaxCivils(value:int) : void
      {
         var civilsUnits:Vector.<MyUnit> = null;
         var length:int = 0;
         var civilsToRemove:int = 0;
         var civil:MyUnit = null;
         var i:int = 0;
         if(this.mUnitScene != null)
         {
            length = int((civilsUnits = this.mUnitScene.sceneGetListById(1)).length);
            if((civilsToRemove = length - value) > 0)
            {
               i = 0;
               while(civilsToRemove > 0)
               {
                  civil = civilsUnits[i];
                  if(civil.mIsAlive)
                  {
                     civil.markToBeReleasedFromScene();
                  }
                  civilsToRemove--;
                  i++;
               }
            }
            this.mCivilsMax = value;
         }
      }
      
      public function applyPopulationSetting(value:int) : void
      {
         switch(value)
         {
            case 0:
               CIVILS_PER_HOUSE = 0;
               MAX_CIVILS_IN_CITY = 0;
               break;
            case 1:
               CREATE_TIME = 5000;
               CIVILS_PER_HOUSE = 1;
               MAX_CIVILS_IN_CITY = 10;
               break;
            case 2:
               CREATE_TIME = 5000;
               CIVILS_PER_HOUSE = 2;
               MAX_CIVILS_IN_CITY = 20;
               break;
            case 3:
               CREATE_TIME = 2500;
               CIVILS_PER_HOUSE = 3;
               MAX_CIVILS_IN_CITY = 60;
               break;
            case 4:
               CREATE_TIME = 1000;
               CIVILS_PER_HOUSE = 5;
               MAX_CIVILS_IN_CITY = 150;
         }
         this.civilsSetMaxCivils(CIVILS_PER_HOUSE * this.mCivilItems.length);
      }
   }
}
