package com.dchoc.game.model.world.item.states
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.world.item.WorldItemObject;
   
   public class LaboratoryState extends CouldBeWorkingState
   {
       
      
      public function LaboratoryState(stateId:int, overEvent:String, waitingTimeMS:Number = 0, actionUIId:int = -1, baseAnimId:int = -2, iconAnimId:int = -1, animConditionId:int = -1, barAnimId:int = -1)
      {
         super(stateId,overEvent,waitingTimeMS,actionUIId,baseAnimId,-1,animConditionId,barAnimId);
      }
      
      override public function isWorking(item:WorldItemObject) : Boolean
      {
         return InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getUpgradingUnit() != null;
      }
   }
}
