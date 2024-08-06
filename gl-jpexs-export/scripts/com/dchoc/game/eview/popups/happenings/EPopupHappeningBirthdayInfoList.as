package com.dchoc.game.eview.popups.happenings
{
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.eview.widgets.paginator.PaginatorView;
   import com.dchoc.game.model.happening.HappeningDef;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.layout.ELayoutTextArea;
   import esparragon.widgets.EButton;
   import esparragon.widgets.paginator.EPaginatorComponent;
   import esparragon.widgets.paginator.EPaginatorController;
   import flash.utils.Dictionary;
   
   public class EPopupHappeningBirthdayInfoList extends EGamePopup implements EPaginatorController
   {
      
      private static const CONTENT_PAGINATOR:String = "paginator";
       
      
      private var mTitles:Vector.<String>;
      
      private var mBodyContent:Vector.<ESprite>;
      
      private var mImageArea:ELayoutArea;
      
      private var mTextArea:ELayoutTextArea;
      
      protected const LAYOUT_IMG_TOP:String = "img_pop_m";
      
      protected const LAYOUT_TEXT_BOTTOM:String = "text_info";
      
      protected const CONTENT_BODY_SLIDE:String = "slideContentBody";
      
      protected var mPaginatorCurrentPageId:int = -1;
      
      private var mPaginatorView:PaginatorView;
      
      private var mPaginatorComponent:EPaginatorComponent;
      
      public function EPopupHappeningBirthdayInfoList()
      {
         super();
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         this.paginatorDestroy();
         this.mTitles = null;
      }
      
      private function setAreas() : void
      {
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("LayoutHappeningsBirthdayInitial");
         this.mImageArea = layoutFactory.getArea("img_pop_m");
         this.mTextArea = layoutFactory.getTextArea("text_info");
      }
      
      protected function setupBackground(layoutName:String, background:String) : void
      {
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory(layoutName);
         setLayoutArea(layoutFactory.getArea("bg"),true);
         var bkg:EImage = mViewFactory.getEImage(background,null,false,layoutFactory.getArea("bg"));
         setBackground(bkg);
         eAddChild(bkg);
         var field:ETextField = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_title"),"text_header");
         setTitle(field);
         bkg.eAddChild(field);
         var button:EButton = mViewFactory.getButtonClose(null,layoutFactory.getArea("btn_close"));
         button.eAddEventListener("click",this.onCloseClick);
         bkg.eAddChild(button);
         setCloseButton(button);
         var body:ESprite = mViewFactory.getESprite(null,layoutFactory.getArea("body"));
         bkg.eAddChild(body);
         setContent("contentBody",body);
         mFooterArea = layoutFactory.getArea("footer");
      }
      
      public function setContents(currentPageId:int = 0) : void
      {
         var pagesAmount:int = this.paginatorGetPagesAmount();
         if(pagesAmount > 1)
         {
            this.paginatorLoad();
         }
         this.setPageId(null,currentPageId);
      }
      
      public function setupHappening(happeningDef:HappeningDef) : void
      {
         var img:ESprite = null;
         var tf:ETextField = null;
         this.mTitles = happeningDef.getArrayTextsStoryTitle();
         this.mBodyContent = new Vector.<ESprite>(0);
         this.setAreas();
         this.setupBackground("LayoutHappeningsBirthdayInitial","pop_l");
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("LayoutHappeningsBirthdayInitial");
         var slide:ESprite = mViewFactory.getESprite(null,layoutFactory.getArea("bg"));
         img = mViewFactory.getResourceAsESprite("birthday_1",null,true,this.mImageArea);
         slide.eAddChild(img);
         (tf = mViewFactory.getETextField(null,this.mTextArea,"text_body")).setText(happeningDef.getArrayTextsStoryBody()[0]);
         slide.eAddChild(tf);
         this.mBodyContent.push(slide);
         slide = mViewFactory.getESprite(null,layoutFactory.getArea("bg"));
         var button1:EButton = mViewFactory.getButtonImage("icon_sale",InstanceMng.getSkinsMng().getCurrentSkinSku(),layoutFactory.getArea("slide_img_1"));
         slide.eAddChild(button1);
         button1.eAddEventListener("click",this.onSaleButtonClicked);
         var tf1:ETextField;
         (tf1 = mViewFactory.getETextField(null,layoutFactory.getTextArea("slide_text_1"),"text_body")).setText(DCTextMng.getText(3377));
         slide.eAddChild(tf1);
         var button2:EButton = mViewFactory.getButtonImage("star_battery_pack",InstanceMng.getSkinsMng().getCurrentSkinSku(),layoutFactory.getArea("slide_img_2"));
         slide.eAddChild(button2);
         button2.eAddEventListener("click",this.onStarButtonClicked);
         var tf2:ETextField = mViewFactory.getETextField(null,layoutFactory.getTextArea("slide_text_2"),"text_body");
         tf2.setText(DCTextMng.getText(3378));
         slide.eAddChild(tf2);
         var button3:EButton = mViewFactory.getButtonImage("icon_decorations",InstanceMng.getSkinsMng().getCurrentSkinSku(),layoutFactory.getArea("slide_img_3"));
         slide.eAddChild(button3);
         button3.eAddEventListener("click",this.onDecorationsButtonClicked);
         var tf3:ETextField = mViewFactory.getETextField(null,layoutFactory.getTextArea("slide_text_3"),"text_body");
         tf3.setText(DCTextMng.getText(3379));
         slide.eAddChild(tf3);
         this.mBodyContent.push(slide);
         slide = mViewFactory.getESprite(null,layoutFactory.getArea("bg"));
         img = mViewFactory.getResourceAsESprite("birthday_3",null,true,this.mImageArea);
         slide.eAddChild(img);
         (tf = mViewFactory.getETextField(null,this.mTextArea,"text_body")).setText(happeningDef.getArrayTextsStoryBody()[2]);
         slide.eAddChild(tf);
         this.mBodyContent.push(slide);
         this.setContents();
      }
      
      protected function onCloseClick(e:EEvent) : void
      {
         var o:Object = null;
         if(getEvent())
         {
            o = getEvent();
            o.button = "EventCloseButtonPressed";
            InstanceMng.getNotifyMng().addEvent(InstanceMng.getGUIController(),o);
         }
         InstanceMng.getUIFacade().closePopup(this);
      }
      
      protected function onStarButtonClicked(e:EEvent) : void
      {
         this.onCloseClick(null);
         var params:Dictionary = new Dictionary();
         params["tab"] = "specials";
         MessageCenter.getInstance().sendMessage("openPremiumShop",params);
      }
      
      protected function onSaleButtonClicked(e:EEvent) : void
      {
         this.onCloseClick(null);
         var params:Dictionary = new Dictionary();
         params["tab"] = "attack";
         MessageCenter.getInstance().sendMessage("openPremiumShop",params);
      }
      
      protected function onDecorationsButtonClicked(e:EEvent) : void
      {
         this.onCloseClick(null);
         var params:Dictionary = new Dictionary();
         params["tab"] = "decorations";
         MessageCenter.getInstance().sendMessage("hudBuildButtonClicked",params);
      }
      
      private function paginatorGetPagesAmount() : int
      {
         return this.mTitles == null ? 0 : int(this.mTitles.length);
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
         var slide:ESprite = null;
         if(this.mPaginatorCurrentPageId != id)
         {
            pagesAmount = this.paginatorGetPagesAmount();
            if(pagesAmount > 0 && id >= 0 && id < pagesAmount)
            {
               this.mPaginatorCurrentPageId = id;
               setTitleText(this.mTitles[id]);
               if((slide = getContent("slideContentBody")) != null)
               {
                  eRemoveChild(getContent("slideContentBody"));
               }
               setContent("slideContentBody",this.mBodyContent[id]);
               eAddChild(getContent("slideContentBody"));
            }
         }
      }
   }
}
