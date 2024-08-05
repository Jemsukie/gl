package com.dchoc.game.model.world.item.states
{
   import com.dchoc.game.model.world.item.WorldItemObject;
   
   public class CouldBeWorkingState extends WorldItemObjectState
   {
       
      
      protected var mIconAnimTypeId:int;
      
      protected var mInBattle:Boolean;
      
      public function CouldBeWorkingState(stateId:int, overEvent:String, waitingTimeMS:Number = 0, actionUIId:int = -1, baseAnimId:int = -2, iconAnimId:int = -1, animConditionId:int = -1, barAnimId:int = -1)
      {
         super(stateId,overEvent,waitingTimeMS,actionUIId,baseAnimId,-1,animConditionId,barAnimId);
         mViewLayersAnimIds[3] = iconAnimId;
         this.mIconAnimTypeId = iconAnimId;
         this.mInBattle = false;
      }
      
      override public function begin(item:WorldItemObject, resetState:Boolean = false) : void
      {
         super.begin(item,resetState);
         item.viewLayersTypeRequiredSet(3,this.mIconAnimTypeId);
      }
      
      override public function logicUpdate(item:WorldItemObject, dt:int) : void
      {
         var showAnimation:Boolean = !this.mInBattle && this.isWorking(item) && !item.isFlatBed() && !item.isBroken();
         item.viewLayersTypeRequiredSet(5,showAnimation ? 19 : -1);
         super.logicUpdate(item,dt);
      }
      
      public function isWorking(item:WorldItemObject) : Boolean
      {
         return false;
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
