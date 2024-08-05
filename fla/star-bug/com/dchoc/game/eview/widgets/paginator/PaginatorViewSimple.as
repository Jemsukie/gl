package com.dchoc.game.eview.widgets.paginator
{
   import esparragon.display.ESpriteContainer;
   import esparragon.events.EEvent;
   import esparragon.widgets.EButton;
   import esparragon.widgets.paginator.EPaginatorComponent;
   import esparragon.widgets.paginator.EPaginatorView;
   
   public class PaginatorViewSimple implements EPaginatorView
   {
      
      public static const ARROW_PREVIOUS:String = "arrowPrevious";
      
      public static const ARROW_NEXT:String = "arrowNext";
       
      
      protected var mPaginatorAsset:ESpriteContainer;
      
      protected var mMaxPages:int;
      
      protected var mPreviousButton:EButton;
      
      protected var mNextButton:EButton;
      
      protected var mCurrentPage:int;
      
      protected var mPaginatorComponent:EPaginatorComponent;
      
      public function PaginatorViewSimple(paginator:ESpriteContainer, maxPages:int)
      {
         super();
         this.mPaginatorAsset = paginator;
         this.mPreviousButton = this.mPaginatorAsset.getContent("arrowPrevious") as EButton;
         this.mNextButton = this.mPaginatorAsset.getContent("arrowNext") as EButton;
         this.mPaginatorAsset.eAddEventListener("click",this.onPaginatorClick);
         this.setTotalPages(maxPages);
         this.setPageId(0);
      }
      
      public function destroy() : void
      {
         this.mPaginatorAsset = null;
         this.mPreviousButton = null;
         this.mNextButton = null;
         this.mPaginatorComponent = null;
      }
      
      public function setPageId(id:int) : void
      {
         this.mCurrentPage = id;
         this.mPreviousButton.setIsEnabled(true);
         this.mNextButton.setIsEnabled(true);
         if(this.mCurrentPage == 0)
         {
            this.mPreviousButton.setIsEnabled(false);
         }
         else if(this.mCurrentPage == this.mMaxPages - 1)
         {
            this.mNextButton.setIsEnabled(false);
         }
      }
      
      public function setPaginatorComponent(pc:EPaginatorComponent) : void
      {
         this.mPaginatorComponent = pc;
      }
      
      public function setTotalPages(pages:int) : void
      {
         this.mMaxPages = pages;
         this.mPreviousButton.visible = pages > 1;
         this.mNextButton.visible = pages > 1;
      }
      
      public function getCurrentPage() : int
      {
         return this.mCurrentPage;
      }
      
      protected function onPaginatorClick(e:EEvent) : void
      {
         var nextPage:int = this.mCurrentPage;
         var target:Object = e.getTarget();
         switch(target)
         {
            case this.mPreviousButton:
               if(this.mCurrentPage > 0)
               {
                  nextPage = this.mCurrentPage - 1;
               }
               break;
            case this.mNextButton:
               if(this.mCurrentPage < this.mMaxPages - 1)
               {
                  nextPage = this.mCurrentPage + 1;
               }
         }
         if(this.mPaginatorComponent != null && nextPage != this.mCurrentPage)
         {
            this.mPaginatorComponent.setPageId(nextPage);
         }
      }
   }
}
