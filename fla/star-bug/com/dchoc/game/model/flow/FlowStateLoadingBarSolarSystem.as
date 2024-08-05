package com.dchoc.game.model.flow
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.flow.DCFlowState;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   
   public class FlowStateLoadingBarSolarSystem extends FlowStateLoadingBarVisiting
   {
      
      private static var mCoords:DCCoordinate;
      
      private static var mStarId:Number;
      
      private static var mStarType:int;
       
      
      public function FlowStateLoadingBarSolarSystem(flowState:DCFlowState, barResourceId:String)
      {
         super(flowState,barResourceId);
      }
      
      public static function setCoordinates(coords:DCCoordinate) : void
      {
         mCoords = coords;
      }
      
      public static function getCoordinates() : DCCoordinate
      {
         return mCoords;
      }
      
      public static function setStarId(starId:Number) : void
      {
         mStarId = starId;
      }
      
      public static function getStarId() : Number
      {
         return mStarId;
      }
      
      public static function setStarType(starType:int) : void
      {
         mStarType = starType;
      }
      
      public static function getStarType() : int
      {
         return mStarType;
      }
      
      override protected function changeStateOnBatchLoadEnd() : void
      {
         InstanceMng.getApplication().fsmChangeState(7);
      }
      
      override protected function batchWaitForUserData() : void
      {
         mFlowState.requestResources();
         if(mStarId != -1)
         {
            FlowState(mFlowState).solarSystemAskWindow(mCoords.x,mCoords.y,mStarId);
         }
         else
         {
            DCDebug.traceCh("ErrGalaxy","StarId was null when executing \'batchWaitForUserData\' method in FlowStateLoadingBar");
         }
      }
      
      override protected function getLoadingLayer() : String
      {
         return "layer1";
      }
   }
}
