package com.dchoc.toolkit.core.flow
{
   import com.dchoc.toolkit.core.component.DCComponentUI;
   import com.dchoc.toolkit.core.view.mng.DCViewMng;
   import com.dchoc.toolkit.core.view.mng.DCViewMngSimple;
   
   public class DCFlowState extends DCComponentUI
   {
       
      
      public var mChildrensCreated:Boolean = false;
      
      protected var mViewMng:DCViewMng;
      
      public function DCFlowState()
      {
         super();
      }
      
      override protected function beginDo() : void
      {
         this.onResize(this.mViewMng.getStageWidth(),this.mViewMng.getStageHeight());
      }
      
      public function provideData() : void
      {
      }
      
      public function isALoadingState() : Boolean
      {
         return false;
      }
      
      override protected function childrenCreate() : void
      {
         this.mChildrensCreated = true;
         childrenAddChild(this.viewMngGet());
      }
      
      public function viewMngGet() : DCViewMng
      {
         if(this.mViewMng == null)
         {
            this.viewMngCreate();
         }
         return this.mViewMng;
      }
      
      protected function viewMngCreate() : void
      {
         this.mViewMng = new DCViewMngSimple(1);
      }
      
      public function viewMngSet(value:DCViewMng) : void
      {
         this.mViewMng = value;
      }
      
      public function guiControllerGet() : *
      {
         this.guiControllerCreate();
      }
      
      protected function guiControllerCreate() : void
      {
      }
      
      override public function onResize(stageWidth:int, stageHeight:int) : void
      {
         this.mViewMng.onResize(stageWidth,stageHeight);
      }
   }
}
