package com.dchoc.game.model.world.item.states
{
   import com.dchoc.game.model.world.item.WorldItemObject;
   
   public class RentReadyState extends WorldItemObjectState
   {
       
      
      public function RentReadyState(stateId:int)
      {
         super(stateId,null,0,11,1);
      }
      
      override protected function changeViewLayersAnimIds(item:WorldItemObject) : void
      {
         super.changeViewLayersAnimIds(item);
         mViewLayersAnimIds[5] = this.getIconTypeId(item);
      }
      
      private function getIconTypeId(item:WorldItemObject) : int
      {
         return item.mDef.getTypeId() == 0 ? 12 : 15;
      }
      
      override public function notify(item:WorldItemObject, e:Object) : Boolean
      {
         if(e != null)
         {
            switch(e.cmd)
            {
               case "battleEventHasStarted":
                  item.viewLayersTypeRequiredSet(5,-1);
                  break;
               case "battleEventHasFinished":
                  if(item.getIncomeAmount() == item.mDef.getIncomeCapacity())
                  {
                     item.viewLayersTypeRequiredSet(5,this.getIconTypeId(item));
                  }
            }
         }
         return super.notify(item,e);
      }
   }
}
