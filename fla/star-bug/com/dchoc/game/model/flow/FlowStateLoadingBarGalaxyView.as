package com.dchoc.game.model.flow
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.flow.DCFlowState;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   
   public class FlowStateLoadingBarGalaxyView extends FlowStateLoadingBarVisiting
   {
      
      public static const COORD_TARGET_ORIGINAL:int = 0;
      
      public static const COORD_MIN:int = 1;
      
      public static const COORD_MAX:int = 2;
      
      private static var mCoordsRequested:DCCoordinate;
      
      private static var mCoordMin:DCCoordinate;
      
      private static var mCoordMax:DCCoordinate;
       
      
      public function FlowStateLoadingBarGalaxyView(flowState:DCFlowState, barResourceId:String)
      {
         super(flowState,barResourceId);
      }
      
      public static function setCoordinates(coordsRequested:DCCoordinate, coordMin:DCCoordinate, coordMax:DCCoordinate) : void
      {
         mCoordsRequested = coordsRequested;
         mCoordMin = coordMin;
         mCoordMax = coordMax;
      }
      
      public static function getCoordinates(type:int) : DCCoordinate
      {
         var returnValue:DCCoordinate = null;
         switch(type)
         {
            case 0:
               returnValue = mCoordsRequested;
               break;
            case 1:
               returnValue = mCoordMin;
               break;
            case 2:
               returnValue = mCoordMax;
         }
         return returnValue;
      }
      
      override protected function changeStateOnBatchLoadEnd() : void
      {
         InstanceMng.getApplication().fsmChangeState(5);
      }
      
      override protected function batchWaitForUserData() : void
      {
         mFlowState.requestResources();
         InstanceMng.getApplication().galaxyInfoWait(mCoordMin,mCoordMax,false,true);
      }
      
      override protected function getLoadingLayer() : String
      {
         return "layer1";
      }
   }
}
