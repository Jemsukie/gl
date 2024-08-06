package com.dchoc.game.model.world.item.states
{
   import com.dchoc.game.controller.shop.ShipyardController;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.shop.Shipyard;
   import com.dchoc.game.model.world.item.WorldItemObject;
   
   public class ShipyardState extends WorldItemObjectState
   {
      
      private static var smShipyardController:ShipyardController = null;
       
      
      protected var mInBattle:Boolean;
      
      private var mIconAnimTypeId:int;
      
      public function ShipyardState(stateId:int, overEvent:String, waitingTimeMS:Number = 0, actionUIId:int = -1, baseAnimId:int = -2, iconAnimId:int = -1, animConditionId:int = -1, barAnimId:int = -1)
      {
         super(stateId,overEvent,waitingTimeMS,actionUIId,baseAnimId,-1,animConditionId,barAnimId);
         mViewLayersAnimIds[3] = iconAnimId;
         this.mIconAnimTypeId = iconAnimId;
         this.mInBattle = false;
      }
      
      override public function unload() : void
      {
         super.unload();
         smShipyardController = null;
      }
      
      override public function begin(item:WorldItemObject, resetState:Boolean = false) : void
      {
         if(smShipyardController == null)
         {
            smShipyardController = InstanceMng.getShipyardController();
         }
         super.begin(item,resetState);
         item.viewLayersTypeRequiredSet(3,this.mIconAnimTypeId);
      }
      
      override public function logicUpdate(item:WorldItemObject, dt:int) : void
      {
         var shipyard:Shipyard = smShipyardController.getShipyard(item.mSid);
         var isWorking:Boolean = !this.mInBattle && !(item.isBroken() || item.isFlatBed());
         var isUnlocking:Boolean = !this.mInBattle && shipyard.hasUnlockingUnits() && !(item.isBroken() || item.isFlatBed());
         item.viewLayersTypeRequiredSet(5,isUnlocking ? 19 : -1);
         item.viewLayersTypeRequiredSet(3,isWorking ? this.mIconAnimTypeId : -1);
         super.logicUpdate(item,dt);
      }
      
      override public function notify(item:WorldItemObject, e:Object) : Boolean
      {
         if(e != null)
         {
            switch(e.cmd)
            {
               case "battleEventHasStarted":
                  this.mInBattle = true;
                  break;
               case "battleEventHasFinished":
                  this.mInBattle = false;
            }
         }
         return super.notify(item,e);
      }
   }
}
