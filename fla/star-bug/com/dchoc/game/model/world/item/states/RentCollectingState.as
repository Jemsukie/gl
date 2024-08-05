package com.dchoc.game.model.world.item.states
{
   import com.dchoc.game.model.world.item.WorldItemObject;
   
   public class RentCollectingState extends WorldItemObjectState
   {
       
      
      public function RentCollectingState(stateId:int)
      {
         super(stateId,"WIORentCollectingEnd",0,25,1,-1,0);
      }
      
      override protected function changeViewLayersAnimIds(item:WorldItemObject) : void
      {
         super.changeViewLayersAnimIds(item);
         mViewLayersAnimIds[5] = this.getIconTypeId(item);
      }
      
      private function getIconTypeId(item:WorldItemObject) : int
      {
         return item.mDef.getTypeId() == 0 ? 13 : 16;
      }
   }
}
