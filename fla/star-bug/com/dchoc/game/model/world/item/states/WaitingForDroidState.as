package com.dchoc.game.model.world.item.states
{
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   
   public class WaitingForDroidState extends WorldItemObjectState
   {
       
      
      public function WaitingForDroidState(stateId:int, baseAnimId:int = -2)
      {
         super(stateId,null,0,6,baseAnimId);
      }
      
      override public function actionUIIsAllowed(actionId:int) : Boolean
      {
         return actionId == 7 ? false : super.actionUIIsAllowed(actionId);
      }
      
      override protected function beginDo(item:WorldItemObject, resetState:Boolean = false) : void
      {
         var dspObj:DCDisplayObject = item.viewLayersAnimGet(1);
         if(dspObj != null)
         {
            if(item.mDef.needsGround())
            {
               dspObj.filters = [GameConstants.FILTER_WAITING_FOR_DROID_FOR_RECYCLING_BLUE];
            }
            else
            {
               item.viewSetOutline(7);
            }
            dspObj.alpha = 0.7;
         }
      }
      
      override public function end(item:WorldItemObject) : void
      {
         var dspObj:DCDisplayObject = item.viewLayersAnimGet(1);
         if(dspObj != null)
         {
            if(item.mDef.needsGround())
            {
               dspObj.filters = null;
            }
            else
            {
               item.viewSetOutline(-1);
            }
            dspObj.alpha = 1;
         }
      }
   }
}
