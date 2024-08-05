package com.dchoc.game.model.unit.mngs
{
   import com.dchoc.game.controller.hangar.Bunker;
   import com.dchoc.game.controller.hangar.BunkerController;
   import com.dchoc.game.controller.hangar.Hangar;
   import com.dchoc.game.controller.hangar.HangarController;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.components.goal.UnitComponentGoal;
   import com.dchoc.game.model.unit.components.movement.UnitComponentMovement;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.core.component.DCComponent;
   import flash.utils.Dictionary;
   
   public class Army extends DCComponent
   {
      
      public static const LOOT_COINS_ID:int = 0;
      
      public static const LOOT_MINERALS_ID:int = 1;
      
      public static const SCORE_GAINED:int = 2;
      
      private static const LOOT_COUNT:int = 3;
       
      
      private var mBattleStarted:Boolean;
      
      private var mFaction:int;
      
      private var mUnitsCount:int;
      
      private var mUnitsInSceneCount:int;
      
      private var mUnitsInScene:Dictionary;
      
      private var mUnitsKilledCount:int;
      
      public var mLootAmount:Array;
      
      private var mRetreatUnitsThreshold:int;
      
      private var mRetreatUnitsGiven:Boolean;
      
      private var mHangarController:HangarController;
      
      private var mBunkerController:BunkerController;
      
      public function Army(faction:int)
      {
         super();
         this.mFaction = faction;
      }
      
      override protected function loadDoStep(step:int) : void
      {
         if(step == 0)
         {
            this.mLootAmount = new Array(3);
            this.mUnitsInScene = new Dictionary(true);
         }
      }
      
      override protected function unloadDo() : void
      {
         this.mLootAmount = null;
         this.mHangarController = null;
         this.mBunkerController = null;
         this.mUnitsInScene = null;
      }
      
      override protected function buildDoAsyncStep(step:int) : void
      {
         var i:int = 0;
         if(step == 0)
         {
            this.mRetreatUnitsThreshold = 0;
            this.mRetreatUnitsGiven = false;
            for(i = 0; i < 3; )
            {
               this.mLootAmount[i] = 0;
               i++;
            }
         }
      }
      
      override protected function unbuildDo() : void
      {
         this.mLootAmount.length = 0;
         this.mBattleStarted = false;
         this.resetUnits();
         this.resetBattle();
      }
      
      private function resetUnits() : void
      {
         var k:* = null;
         this.mUnitsCount = 0;
         this.mUnitsInSceneCount = 0;
         for(k in this.mUnitsInScene)
         {
            delete this.mUnitsInScene[k];
         }
      }
      
      public function resetBattle() : void
      {
         this.mUnitsKilledCount = 0;
      }
      
      override protected function beginDo() : void
      {
         this.mHangarController = InstanceMng.getHangarControllerMng().getHangarController();
         this.mBunkerController = InstanceMng.getBunkerController();
      }
      
      public function setRetreatUnitsThreshold(value:int) : void
      {
         this.mRetreatUnitsThreshold = value + 1;
         this.mRetreatUnitsGiven = this.mUnitsCount < this.mRetreatUnitsThreshold;
      }
      
      public function battleStart() : void
      {
         this.mBattleStarted = true;
      }
      
      override public function notify(e:Object) : Boolean
      {
         var msg:String = null;
         var c:UnitComponentGoal = null;
         var bunker:Bunker = null;
         var returnValue:Boolean = true;
         var u:MyUnit = e.unit;
         if(Config.DEBUG_MODE)
         {
            msg = "MyArmy[" + GameConstants.UNIT_FACTION_TO_STRING[this.mFaction] + "] ->> " + e.cmd;
         }
         var goAhead:Boolean;
         if(goAhead = true)
         {
            switch(e.cmd)
            {
               case "unitEventAddedToScene":
                  if(u.isTakenIntoConsiderationInBattle(true))
                  {
                     this.mUnitsCount++;
                     this.mUnitsInSceneCount++;
                     this.mUnitsInScene[u.mId] = u;
                  }
                  break;
               case "unitEventKilled":
                  this.notifyUnitItem(u,e);
                  if(u.isTakenIntoConsiderationInBattle(false))
                  {
                     this.mUnitsCount--;
                     this.mUnitsKilledCount++;
                     if(this.mUnitsCount < this.mRetreatUnitsThreshold && !this.mRetreatUnitsGiven)
                     {
                        MyUnit.smUnitScene.sceneSendEventToUnitType(2,{"cmd":"battleArmyEvenRetreat"});
                        MyUnit.smUnitScene.sceneSendEventToUnitType(8,{"cmd":"battleArmyEvenRetreat"});
                        MyUnit.smUnitScene.sceneSendEventToUnitType(10,{"cmd":"battleArmyEvenRetreat"});
                        this.mRetreatUnitsGiven = true;
                     }
                  }
                  break;
               case "unitEventRemovedFromScene":
                  if(MyUnit.smUnitScene.battleIsRunning())
                  {
                     if(u.mDef.isABuilding())
                     {
                     }
                     if(this.mUnitsInScene[u.mId] == u)
                     {
                        this.mUnitsInSceneCount--;
                        if(this.mUnitsInSceneCount == 0 || this.onlyHealersInScene())
                        {
                           MyUnit.smUnitScene.battleEventsNotifyArmyFinish(this.mFaction);
                        }
                     }
                  }
                  break;
               case "battleUnitEventWasHit":
                  this.notifyUnitItem(u,e);
                  this.hitUnit(e.transaction);
                  break;
               case "battleEventHasFinished":
                  if(u == null)
                  {
                     MyUnit.smUnitScene.battleEventsNotifyBattleFinished(this.mFaction);
                  }
                  else if(this.mFaction == 0)
                  {
                     u.exitSceneStart(1);
                  }
                  else if((c = u.getGoalComponent()) != null)
                  {
                     c.notify({"cmd":"battleArmyEventRetreatAfterWinning"});
                  }
                  if(this.mFaction == 0)
                  {
                     this.resetUnits();
                  }
                  break;
               case "battleArmyEvenRetreat":
                  if(u.mDef.isTerrainUnit())
                  {
                     if((c = u.getGoalComponent()) != null)
                     {
                        c.notify(e);
                     }
                  }
                  else
                  {
                     this.setEmptyGoal(u);
                  }
                  break;
               case "battleArmyRemoveUnits":
                  if(u == null)
                  {
                     MyUnit.smUnitScene.battleEventsNotifyArmyRemoveUnits(this.mFaction);
                  }
                  else
                  {
                     u.exitSceneStart(1);
                  }
               default:
                  returnValue = false;
            }
         }
         else if(this.mFaction == 1 && e.cmd == "unitEventKilled")
         {
            bunker = u.mData[34];
            if(bunker != null)
            {
               bunker.removeConcreteUnit(u);
            }
         }
         return returnValue;
      }
      
      private function notifyUnitItem(u:MyUnit, e:Object) : void
      {
         var type:int = 0;
         var hangarController:HangarController = null;
         var hangar:Hangar = null;
         var unitItem:WorldItemObject;
         if((unitItem = u.mData[35]) != null)
         {
            loop0:
            switch((type = unitItem.mDef.getTypeId()) - 7)
            {
               case 0:
               case 1:
                  if((hangarController = type == 7 ? this.mHangarController : this.mBunkerController) != null)
                  {
                     hangar = hangarController.getFromSid(unitItem.mSid);
                     if(hangar != null)
                     {
                        switch(e.cmd)
                        {
                           case "unitEventKilled":
                              hangarController.removeUnits(hangar.getSid());
                              break loop0;
                           case "battleUnitEventWasHit":
                        }
                     }
                     break;
                  }
            }
         }
      }
      
      private function setEmptyGoal(u:MyUnit) : void
      {
         var m:UnitComponentMovement = u.getMovementComponent();
         if(m != null)
         {
            m.wander(0.5);
         }
         MyUnit.smUnitScene.unitsSetGoal(u,null);
      }
      
      private function hitUnit(transaction:Transaction) : void
      {
         if(transaction != null)
         {
            this.accumLoot(0,transaction.getTransCoins());
            this.accumLoot(1,transaction.getTransMinerals());
            this.accumLoot(2,transaction.getTransScore());
         }
      }
      
      private function accumLoot(lootId:int, amount:int) : void
      {
         if(amount == 0)
         {
            return;
         }
         switch(lootId)
         {
            case 0:
               this.mLootAmount[lootId] += amount;
               InstanceMng.getTopHudFacade().battleSetLootCoins(this.mLootAmount[lootId]);
               break;
            case 1:
               this.mLootAmount[lootId] += amount;
               InstanceMng.getTopHudFacade().battleSetLootMinerals(this.mLootAmount[lootId]);
               break;
            case 2:
               this.mLootAmount[lootId] += amount;
               if(this.mFaction == 1)
               {
                  InstanceMng.getTopHudFacade().battleSetLootScore(this.mLootAmount[lootId]);
                  break;
               }
         }
      }
      
      public function getUnitsKilledCount() : int
      {
         return this.mUnitsKilledCount;
      }
      
      private function onlyHealersInScene() : Boolean
      {
         for each(var u in this.mUnitsInScene)
         {
            if(u != null)
            {
               if(!u.mDef.isHealer() && u.getIsAlive())
               {
                  return false;
               }
            }
         }
         return true;
      }
      
      public function debugArmy() : String
      {
         return " unitsCount = " + this.mUnitsCount + " unitsInScene = " + this.mUnitsInSceneCount + " coins looted = " + this.mLootAmount[0] + " minerals looted = " + this.mLootAmount[1] + " score = " + this.mLootAmount[2];
      }
   }
}
