package com.dchoc.game.eview.popups.help
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.eview.widgets.paginator.PaginatorView;
   import com.dchoc.game.model.rule.HelpDef;
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
   
   public class EPopupHelp extends EGamePopup implements EPaginatorController
   {
      
      protected static const DESCRIPTION_TEXT:String = "description";
      
      protected static const BODY:String = "Body";
      
      private static const ADVISOR:String = "advisor";
      
      private static const SPEECH_TEXT:String = "speechText";
      
      private static const DESCRIPTION_BKG:String = "description_bkg";
      
      private static const ARROW:String = "arrow";
      
      private static const PAGINATOR:String = "paginator";
       
      
      protected var mTextDescriptionArea:ELayoutTextArea;
      
      protected var mBkgDescArea:ELayoutArea;
      
      private var mSpeechArea:ELayoutArea;
      
      private var mArrowArea:ELayoutArea;
      
      protected var mHelpDef:HelpDef;
      
      protected var mHelpDefSku:String;
      
      protected var mCurrentPage:int = -1;
      
      private var mPaginator:PaginatorView;
      
      private var mPaginatorComponent:EPaginatorComponent;
      
      public function EPopupHelp(helpDefSku:String)
      {
         super();
         setIsStackable(true);
         this.mHelpDefSku = helpDefSku;
      }
      
      override public function setup(popupId:String, viewFactory:ViewFactory, skinId:String) : void
      {
         super.setup(popupId,viewFactory,skinId);
         this.mHelpDef = InstanceMng.getHelpsDefMng().getDefBySku(this.mHelpDefSku) as HelpDef;
         this.setupBackground();
         this.setupBody();
         this.setPageId(null,0);
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         this.mSpeechArea = null;
         this.mTextDescriptionArea = null;
         this.mArrowArea = null;
         this.mBkgDescArea = null;
      }
      
      private function setupBackground() : void
      {
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopM");
         var img:EImage = mViewFactory.getEImage("pop_m",mSkinSku,false,layoutFactory.getArea("bg"));
         eAddChild(img);
         setBackground(img);
         var field:ETextField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_title"),"text_title_0");
         img.eAddChild(field);
         setTitle(field);
         var button:EButton = mViewFactory.getButtonClose(mSkinSku,layoutFactory.getArea("btn_close"));
         img.eAddChild(button);
         setCloseButton(button);
         button.eAddEventListener("click",this.onCloseClick);
         var body:ESprite = mViewFactory.getESprite(mSkinSku,layoutFactory.getArea("body"));
         img.eAddChild(body);
         setContent("Body",body);
         var footer:ELayoutArea = layoutFactory.getArea("footer");
         var paginatorAsset:ESpriteContainer = mViewFactory.getPaginatorAsset(mSkinSku);
         img.eAddChild(paginatorAsset);
         setContent("paginator",paginatorAsset);
         mViewFactory.distributeSpritesInArea(footer,[paginatorAsset],1,1,1,1,true);
         this.mPaginator = new PaginatorView(paginatorAsset,this.mHelpDef.getPagesCount());
         this.mPaginatorComponent = new EPaginatorComponent();
         this.mPaginatorComponent.init(this.mPaginator,this);
         this.mPaginator.setPaginatorComponent(this.mPaginatorComponent);
      }
      
      private function setupBody() : void
      {
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("LayoutPopupInstructions");
         var body:ESprite = getContent("Body");
         this.mSpeechArea = layoutFactory.getArea("area_speech");
         var img:EImage = mViewFactory.getEImage(this.mHelpDef.getAdvisor(),mSkinSku,true,layoutFactory.getArea("character"));
         body.eAddChild(img);
         setContent("advisor",img);
         var field:ETextField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_tip"),"text_body");
         setContent("speechText",field);
         this.mBkgDescArea = layoutFactory.getArea("area_instructions");
         img = mViewFactory.getEImage("generic_box",mSkinSku,false,this.mBkgDescArea);
         setContent("description_bkg",img);
         body.eAddChild(img);
         this.mTextDescriptionArea = layoutFactory.getTextArea("text_instructions");
         field = mViewFactory.getETextField(mSkinSku,this.mTextDescriptionArea,"text_body_2");
         body.eAddChild(field);
         setContent("description",field);
         this.mArrowArea = layoutFactory.getArea("arrow");
         img = mViewFactory.getEImage("speech_arrow",mSkinSku,false,this.mArrowArea,"speech_color");
         setContent("arrow",img);
      }
      
      protected function setupSpeechBubble() : void
      {
         var field:ETextField = getContentAsETextField("speechText");
         field.setText(this.mHelpDef.getText(this.mCurrentPage));
         DCTextMng.changeColors(field.getTextField());
         var speech:ESprite = mViewFactory.getSpeechBubble(this.mSpeechArea,this.mArrowArea,field,mSkinSku,"speech_color");
         var arrow:ESprite = getContent("arrow");
         var body:ESprite;
         (body = getContent("Body")).eAddChild(arrow);
         body.eAddChild(speech);
         body.eAddChild(field);
      }
      
      public function setPageId(pc:EPaginatorComponent, id:int) : void
      {
         var field:ETextField = null;
         if(this.mCurrentPage != id)
         {
            this.mCurrentPage = id;
            this.setupSpeechBubble();
            setTitleText(DCTextMng.replaceParameters(this.mHelpDef.getTitle(id),["" + this.mHelpDef.getPagesCount()]));
            field = getContentAsETextField("description");
            field.setText(this.mHelpDef.getTip(id));
            DCTextMng.changeColors(field.getTextField());
         }
      }
      
      public function setHelpDefSku(sku:String) : void
      {
         this.mHelpDefSku = sku;
      }
      
      private function onCloseClick(e:EEvent) : void
      {
         InstanceMng.getUIFacade().closePopup(this);
      }
   }
}
