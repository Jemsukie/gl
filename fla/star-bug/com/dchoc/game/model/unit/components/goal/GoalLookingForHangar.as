package com.dchoc.game.model.unit.components.goal
{
   import com.dchoc.game.controller.hangar.Hangar;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.components.movement.UnitComponentMovement;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.model.world.ship.ShipDef;
   
   public class GoalLookingForHangar extends GoalShip
   {
      
      private static const STATE_LOOKING_FOR_HANGAR:int = 100;
      
      private static const ASK_FOR_HANGAR_PERIOD_MS:int = 3000;
      
      private static const ASK_FOR_PATH_PERIOD_MS:int = 3000;
       
      
      private var mItemFrom:WorldItemObject;
      
      private var mHangarItem:WorldItemObject;
      
      private var mHangar:Hangar;
      
      private var mAskTime:int;
      
      private var mStepItemFromAllowed:Boolean;
      
      private var mStepItemToAllowed:Boolean;
      
      public function GoalLookingForHangar(unit:MyUnit, itemFrom:WorldItemObject = null, hangar:WorldItemObject = null, setUnitPosition:Boolean = false, stepItemFromAllowed:Boolean = false, stepItemToAllowed:Boolean = false)
      {
         super(unit);
         this.mItemFrom = itemFrom;
         if(setUnitPosition && itemFrom != null)
         {
            MyUnit.smUnitScene.shipsGetPositionFromItem(itemFrom,mUnit.mPosition);
         }
         this.setHangar(hangar);
         this.mStepItemFromAllowed = stepItemFromAllowed;
         this.mStepItemToAllowed = stepItemToAllowed;
      }
      
      override public function unbuild(u:MyUnit) : void
      {
         this.mHangarItem = null;
         this.mHangar = null;
      }
      
      override public function activate() : void
      {
         super.activate();
         this.mAskTime = 0;
         if(this.mHangarItem != null)
         {
            this.resume();
         }
         else
         {
            this.wander();
         }
      }
      
      private function resume() : void
      {
         var mov:UnitComponentMovement = null;
         if(this.mHangarItem != null)
         {
            if(mUnit.mDef.isTerrainUnit())
            {
               mov = mUnit.getMovementComponent();
               mov.goToItem(this.mHangarItem,null,false,"unitEventHasArrived");
            }
            else
            {
               MyUnit.smUnitScene.shipsSendFromItemToItem(mUnit,null,this.mHangarItem,"unitEventHasArrived",true);
            }
         }
         else
         {
            this.activate();
         }
      }
      
      private function setHangar(item:WorldItemObject) : void
      {
         this.mHangarItem = item;
         if(item != null)
         {
            this.mHangar = MyUnit.smUnitScene.getHangarFromItem(this.mHangarItem);
         }
      }
      
      override protected function avoidCollisionExit(u:MyUnit) : void
      {
         this.resume();
         this.mAskTime = 3000;
         changeState(100);
      }
      
      private function wander() : void
      {
         mUnit.getMovementComponent().resetBehaviours();
         mUnit.getMovementComponent().mBehaviourWeights[8] = 0.5 + Math.random();
      }
      
      override protected function logicUpdateDoDoDo(dt:int, u:MyUnit) : void
      {
         var nearestAvailableHangar:Hangar = null;
         var mov:UnitComponentMovement = null;
         if(this.mHangarItem == null)
         {
            this.mAskTime -= dt;
            if(this.mAskTime <= 0)
            {
               if((nearestAvailableHangar = InstanceMng.getHangarControllerMng().getHangarController().getHangarForDef(ShipDef(mUnit.mDef),true)) != null)
               {
                  this.setHangar(nearestAvailableHangar.getWIO());
                  this.resume();
               }
               else
               {
                  this.mAskTime = 3000;
               }
            }
            if(this.mHangarItem == null)
            {
               this.wander();
            }
         }
         else if(mUnit.mIsAlive && this.mHangar != null)
         {
            mov = mUnit.getMovementComponent();
            if(mov.getMaxSpeed() <= 1)
            {
               mov.mEaseArrival = false;
            }
            this.mHangar.unitsOnItsWayCheckIsNeededToGet(mUnit);
            if(this.mHangarItem.mUnit == null)
            {
               mUnit.exitSceneStart(1);
            }
         }
      }
      
      override public function goToItem(itemTo:WorldItemObject, itemFrom:WorldItemObject = null, changeState:Boolean = true) : void
      {
         this.mHangarItem = itemTo;
         this.resume();
      }
      
      override public function notify(e:Object) : void
      {
         var _loc2_:* = e.cmd;
         if("unitEventHasArrived" === _loc2_)
         {
            e.hangar = this.mHangarItem;
            if(this.mHangarItem.mDef.isABunker())
            {
               InstanceMng.getBunkerController().unitGettingBunker(mUnit,this.mHangar);
            }
            else
            {
               addr31:
               e.hangar = this.mHangarItem;
               if(this.mHangarItem.mDef.isABunker())
               {
                  InstanceMng.getBunkerController().unitGettingBunker(mUnit,this.mHangar);
               }
            }
            return;
         }
         §§goto(addr31);
      }
   }
}
