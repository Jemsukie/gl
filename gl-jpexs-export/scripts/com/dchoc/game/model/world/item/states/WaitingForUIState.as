package com.dchoc.game.model.world.item.states
{
   import com.dchoc.game.model.world.item.WorldItemObject;
   
   public class WaitingForUIState extends WorldItemObjectState
   {
       
      
      public function WaitingForUIState(stateId:int, overEvent:String, waitingTimeMS:int = 0, actionUIId:int = -1, baseAnimId:int = -2, iconAnimId:int = -1, animConditionId:int = -1, barAnimId:int = -1)
      {
         super(stateId,overEvent,waitingTimeMS,actionUIId,baseAnimId,iconAnimId,animConditionId,barAnimId);
      }
      
      override public function actionUIIsAllowed(actionId:int) : Boolean
      {
         var returnValue:Boolean = true;
         switch(actionId - 7)
         {
            case 0:
               returnValue = false;
         }
         return returnValue;
      }
      
      override public function moveCanBeMoved() : Boolean
      {
         return false;
      }
      
      override public function pauseToReceiveAttack(item:WorldItemObject) : void
      {
         dispatchEvent(item);
      }
   }
}
