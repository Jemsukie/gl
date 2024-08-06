package com.dchoc.game.model.flow
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.flow.DCFlowState;
   import com.dchoc.toolkit.core.view.display.DCDisplayObjectSWF;
   import flash.display.Bitmap;
   
   public class FlowStateLoadingBarVisiting extends FlowStateLoadingBar
   {
       
      
      private var mBitmap:Bitmap;
      
      private var mDCBitmap:DCDisplayObjectSWF;
      
      public function FlowStateLoadingBarVisiting(flowState:DCFlowState, barResourceId:String)
      {
         super(flowState,barResourceId);
         mFirstLoading = false;
      }
      
      override protected function beginDo() : void
      {
         super.beginDo();
         if(FlowState.mBitmap != null)
         {
            this.mDCBitmap = new DCDisplayObjectSWF(FlowState.mBitmap);
            InstanceMng.getViewMng().addChildToLayer(this.mDCBitmap,this.getLoadingLayer(),0);
            this.mDCBitmap.setInk(0,0.3);
            this.mDCBitmap.filters = [GameConstants.FILTER_BLUR_SCREENSHOT];
         }
      }
      
      override protected function endDo() : void
      {
         if(this.mDCBitmap != null)
         {
            InstanceMng.getViewMng().removeChildFromLayer(this.mDCBitmap,this.getLoadingLayer());
            FlowState.mBmpDataLoading.dispose();
            FlowState.mBitmap = null;
         }
      }
      
      protected function getLoadingLayer() : String
      {
         return "layer1";
      }
   }
}
