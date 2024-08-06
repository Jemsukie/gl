package com.dchoc.game.eview.widgets.paginator
{
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.widgets.EButton;
   import esparragon.widgets.paginator.EPaginatorView;
   import flash.events.MouseEvent;
   
   public class PaginatorView extends PaginatorViewSimple implements EPaginatorView
   {
      
      public static const ARROW_FIRST:String = "arrowFirst";
      
      public static const ARROW_LAST:String = "arrowLast";
      
      public static const TEXT_PAGE:String = "textPage";
       
      
      private var mFirstButton:EButton;
      
      private var mLastButton:EButton;
      
      private var mText:ETextField;
      
      public function PaginatorView(paginator:ESpriteContainer, maxPages:int)
      {
         mPaginatorAsset = paginator;
         this.mFirstButton = mPaginatorAsset.getContent("arrowFirst") as EButton;
         this.mLastButton = mPaginatorAsset.getContent("arrowLast") as EButton;
         this.mText = mPaginatorAsset.getContent("textPage") as ETextField;
         super(paginator,maxPages);
      }
      
      override public function setPageId(id:int) : void
      {
         var mouseEvent:MouseEvent = null;
         mCurrentPage = id;
         this.mText.setText(mCurrentPage + 1 + "/" + mMaxPages);
         this.mFirstButton.setIsEnabled(true);
         mPreviousButton.setIsEnabled(true);
         mNextButton.setIsEnabled(true);
         this.mLastButton.setIsEnabled(true);
         if(mCurrentPage == 0)
         {
            mouseEvent = new MouseEvent("rollOut");
            this.mFirstButton.dispatchEvent(mouseEvent);
            mPreviousButton.dispatchEvent(mouseEvent);
            this.mFirstButton.setIsEnabled(false);
            mPreviousButton.setIsEnabled(false);
         }
         else if(mCurrentPage == mMaxPages - 1)
         {
            mouseEvent = new MouseEvent("rollOut");
            this.mLastButton.dispatchEvent(mouseEvent);
            mNextButton.dispatchEvent(mouseEvent);
            this.mLastButton.setIsEnabled(false);
            mNextButton.setIsEnabled(false);
         }
      }
      
      override protected function onPaginatorClick(e:EEvent) : void
      {
         var nextPage:int = mCurrentPage;
         var target:Object = e.getTarget();
         var done:Boolean = false;
         switch(target)
         {
            case this.mFirstButton:
               nextPage = 0;
               done = true;
               break;
            case this.mLastButton:
               nextPage = mMaxPages - 1;
               done = true;
         }
         if(done)
         {
            if(mPaginatorComponent != null)
            {
               mPaginatorComponent.setPageId(nextPage);
            }
         }
         else
         {
            super.onPaginatorClick(e);
         }
      }
   }
}
