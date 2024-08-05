package com.dchoc.game.model.world.item.states
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.world.item.WorldItemObject;
   
   public class BuildingState extends WorldItemObjectState
   {
       
      
      public function BuildingState(stateId:int, event:String, actionUIId:int)
      {
         super(stateId,event,0,actionUIId,0);
      }
      
      override protected function viewLayersDoPopulateAnimIds() : void
      {
         mViewLayersAnimIds[2] = 25;
      }
      
      override protected function beginDo(item:WorldItemObject, resetState:Boolean = false) : void
      {
         WorldItemObject.smWorldItemObjectController.changeServerState(item,false,item.mServerStateId,1);
         item.viewLayersSetAttribute(-1,2,"currentParticleId");
         mWaitingTimeMS = InstanceMng.getRuleMng().getConstructionTime(item);
         super.beginDo(item,resetState);
      }
      
      override public function end(item:WorldItemObject) : void
      {
         item.viewLayersImpCurrentSet(3,-1);
      }
      
      override public function notify(item:WorldItemObject, e:Object) : Boolean
      {
         if(e != null)
         {
            switch(e.cmd)
            {
               case "battleEventHasStarted":
                  item.viewLayersTypeRequiredSet(2,-1);
                  break;
               case "battleEventHasFinished":
                  if(!item.isBroken())
                  {
                     item.viewLayersTypeRequiredSet(2,25);
                  }
            }
         }
         return super.notify(item,e);
      }
   }
}
