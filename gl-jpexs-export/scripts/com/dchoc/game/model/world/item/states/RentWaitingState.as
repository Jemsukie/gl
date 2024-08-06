package com.dchoc.game.model.world.item.states
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.world.item.WorldItemObject;
   
   public class RentWaitingState extends WorldItemObjectState
   {
       
      
      public function RentWaitingState(stateId:int)
      {
         super(stateId,"WIORentWaitingEnd",0,11,1);
      }
      
      override protected function beginDo(item:WorldItemObject, resetState:Boolean = false) : void
      {
         var amount:Number = NaN;
         var incomePace:Number = NaN;
         var paces:Number = NaN;
         var pacesInt:int = 0;
         mWaitingTimeMS = item.mDef.getIncomeTime();
         super.beginDo(item,resetState);
         var incomeToRestore:int;
         if((incomeToRestore = item.getIncomeToRestore()) > 0)
         {
            item.setIncomeAmountLeftToCollect(incomeToRestore);
         }
         if(item.hasIncomeAmountLeftToCollect())
         {
            item.mTime.value = InstanceMng.getRuleMng().wioGetIncomeTimeLeft(item);
            if(incomeToRestore > 0)
            {
               amount = item.getIncomeAmount();
               if(amount < incomeToRestore)
               {
                  incomePace = InstanceMng.getSettingsDefMng().getIncomePace();
                  pacesInt = paces = item.mTime.value / incomePace;
                  item.mTime.value = pacesInt * incomePace;
                  amount = item.getIncomeAmount();
                  if(amount < incomeToRestore)
                  {
                     pacesInt--;
                     item.mTime.value = pacesInt * incomePace;
                  }
               }
            }
         }
         if(incomeToRestore > 0)
         {
            item.setIncomeAmountLeftToCollect(0);
            item.setIncomeToRestore(0);
         }
      }
   }
}
