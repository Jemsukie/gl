package com.dchoc.game.model.world.item.states
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.world.item.WorldItemObject;
   
   public class ItemOrientedState extends WorldItemObjectState
   {
       
      
      public function ItemOrientedState(stateId:int, overEvent:String, waitingTimeMS:Number = 0, actionUIId:int = -1, baseAnimId:int = -2, iconAnimId:int = -1, animConditionId:int = -1, barAnimId:int = -1)
      {
         super(stateId,overEvent,waitingTimeMS,actionUIId,baseAnimId,iconAnimId,animConditionId,barAnimId);
      }
      
      override protected function changeViewLayersAnimIds(item:WorldItemObject) : void
      {
         var baseId:int = 0;
         var roleId:int = 0;
         super.changeViewLayersAnimIds(item);
         switch(item.mServerStateId)
         {
            case 0:
               baseId = 0;
               break;
            case 2:
               baseId = 0;
               if(item.mDef.showsNormalWhenUpgradingInBattle())
               {
                  roleId = InstanceMng.getRole().mId;
                  if(roleId == 3 || roleId == 7)
                  {
                     baseId = 1;
                  }
               }
               break;
            default:
               baseId = 1;
         }
         mViewLayersAnimIds[1] = baseId;
      }
   }
}
