package com.dchoc.game.eview.popups.messages
{
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.paginator.PaginatorView;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.layout.ELayoutTextArea;
   import esparragon.widgets.paginator.EPaginatorComponent;
   import esparragon.widgets.paginator.EPaginatorController;
   
   public class ENotificationWithImageAndText extends ENotificationWithImage implements EPaginatorController
   {
      
      private static const CONTENT_BODY_TEXT:String = "bodyText";
      
      private static const CONTENT_PAGINATOR:String = "paginator";
       
      
      private var mTitles:Vector.<String>;
      
      private var mImageIds:Vector.<String>;
      
      private var mBodies:Vector.<String>;
      
      protected var mPaginatorCurrentPageId:int = -1;
      
      private var mPaginatorView:PaginatorView;
      
      private var mPaginatorComponent:EPaginatorComponent;
      
      public function ENotificationWithImageAndText()
      {
         super();
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         this.paginatorDestroy();
         this.mTitles = null;
         this.mImageIds = null;
         this.mBodies = null;
      }
      
      override protected function setAreas() : void
      {
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("LayoutColonized");
         mBottomArea = layoutFactory.getTextArea("text_info");
         mImageArea = layoutFactory.getArea("img_pop_m");
      }
      
      override public function setup(popupId:String, viewFactory:ViewFactory, skinId:String) : void
      {
         super.setup(popupId,viewFactory,skinId);
         this.setAreas();
         setupBackground("PopM","pop_m");
         var body:ESprite = getContent("body");
         var tf:ETextField = mViewFactory.getETextField(skinId,mBottomArea as ELayoutTextArea,"text_body");
         body.eAddChild(tf);
         setContent("bodyText",tf);
      }
      
      public function setContents(imageIds:Vector.<String>, titles:Vector.<String>, bodies:Vector.<String>, currentPageId:int = 0) : void
      {
         this.mImageIds = imageIds;
         this.mTitles = titles;
         this.mBodies = bodies;
         var pagesAmount:int;
         if((pagesAmount = this.paginatorGetPagesAmount()) > 1)
         {
            this.paginatorLoad();
         }
         this.setPageId(null,currentPageId);
      }
      
      private function setupBodyText(text:String) : void
      {
         var tf:ETextField = getContentAsETextField("bodyText");
         if(tf != null)
         {
            tf.setText(text);
         }
      }
      
      private function paginatorGetPagesAmount() : int
      {
         return this.mImageIds == null ? 0 : int(this.mImageIds.length);
      }
      
      private function paginatorLoad() : void
      {
         var paginatorESprite:ESpriteContainer = null;
         if(this.mPaginatorComponent == null)
         {
            paginatorESprite = mViewFactory.getPaginatorAsset(mSkinSku);
            mViewFactory.distributeSpritesInArea(mFooterArea,[paginatorESprite],1,1,1,1,true);
            eAddChild(paginatorESprite);
            setContent("paginator",paginatorESprite);
            this.mPaginatorView = new PaginatorView(paginatorESprite,this.paginatorGetPagesAmount());
            this.mPaginatorComponent = new EPaginatorComponent();
            this.mPaginatorComponent.init(this.mPaginatorView,this);
            this.mPaginatorView.setPaginatorComponent(this.mPaginatorComponent);
         }
      }
      
      private function paginatorDestroy() : void
      {
         this.mPaginatorCurrentPageId = -1;
         if(this.mPaginatorView != null)
         {
            this.mPaginatorView.destroy();
            this.mPaginatorView = null;
         }
         if(this.mPaginatorComponent != null)
         {
            this.mPaginatorComponent.destroy();
            this.mPaginatorComponent = null;
         }
      }
      
      public function setPageId(pc:EPaginatorComponent, id:int) : void
      {
         var pagesAmount:int = 0;
         if(this.mPaginatorCurrentPageId != id)
         {
            pagesAmount = this.paginatorGetPagesAmount();
            if(pagesAmount > 0 && id >= 0 && id < pagesAmount)
            {
               this.mPaginatorCurrentPageId = id;
               setTitleText(this.mTitles[id]);
               setupImage(this.mImageIds[id],mImageArea);
               this.setupBodyText(this.mBodies[id]);
            }
         }
      }
   }
}
