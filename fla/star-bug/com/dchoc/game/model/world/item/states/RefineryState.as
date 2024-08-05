package com.dchoc.game.model.world.item.states
{
   import com.dchoc.game.eview.popups.ERefineryPopup;
   import com.dchoc.game.model.world.item.WorldItemObject;
   
   public class RefineryState extends WorldItemObjectState
   {
       
      
      protected var mInBattle:Boolean;
      
      private var mIconAnimTypeId:int;
      
      public function RefineryState(stateId:int, overEvent:String, waitingTimeMS:Number = 0, actionUIId:int = -1, baseAnimId:int = -2, iconAnimId:int = -1, animConditionId:int = -1, barAnimId:int = -1)
      {
         super(stateId,overEvent,waitingTimeMS,actionUIId,baseAnimId,-1,animConditionId,barAnimId);
         mViewLayersAnimIds[3] = iconAnimId;
         this.mIconAnimTypeId = iconAnimId;
         this.mInBattle = false;
      }
      
      override public function unload() : void
      {
         super.unload();
      }
      
      override public function begin(item:WorldItemObject, resetState:Boolean = false) : void
      {
         super.begin(item,resetState);
         item.viewLayersTypeRequiredSet(3,this.mIconAnimTypeId);
      }
      
      public function isWorking(item:WorldItemObject) : Boolean
      {
         return !this.mInBattle && ERefineryPopup.isRefiningSomething() && !item.isBroken();
      }
      
      override public function logicUpdate(item:WorldItemObject, dt:int) : void
      {
         var isFinished:Boolean = this.isWorking(item) && ERefineryPopup.getRemainingTime() <= 0;
         item.viewLayersTypeRequiredSet(3,this.isWorking(item) ? 19 : -1);
         item.viewLayersTypeRequiredSet(5,isFinished ? 46 : -1);
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
