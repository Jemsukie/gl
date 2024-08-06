package com.dchoc.game.eview.popups.options
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import flash.text.TextField;
   
   public class EPopupTextOptions extends EGamePopup
   {
       
      
      private const SKU_BAR_SHARPNESS:String = "barSharpness";
      
      private const SKU_BAR_THICKNESS:String = "barThickness";
      
      private var mAAPaginator:EOptionPaginator;
      
      private var mBarSharpness:EOptionSlider;
      
      private var mBarThickness:EOptionSlider;
      
      private var mPreviewTexts:ESpriteContainer;
      
      private var mBodyArea:ELayoutArea;
      
      private var mProfile:Profile;
      
      private var mAAType:String = "advanced";
      
      private var mSharpness:int = 0;
      
      private var mThickness:int = 0;
      
      private var mApplyCallback:Function;
      
      public function EPopupTextOptions()
      {
         super();
      }
      
      override public function setup(popupId:String, viewFactory:ViewFactory, skinId:String) : void
      {
         super.setup(popupId,viewFactory,skinId);
         this.mProfile = InstanceMng.getUserInfoMng().getProfileLogin();
         this.mPreviewTexts = mViewFactory.getESpriteContainer();
         this.setupBackground();
         setTitleText(DCTextMng.getText(4312));
         this.setupBody();
      }
      
      public function setApplyCallback(func:Function) : void
      {
         this.mApplyCallback = func;
      }
      
      private function setupBackground() : void
      {
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopM");
         setLayoutArea(layoutFactory.getContainerLayoutArea());
         var bkg:EImage = mViewFactory.getEImage("pop_m",null,false,layoutFactory.getArea("bg"));
         setBackground(bkg);
         eAddChild(bkg);
         var field:ETextField = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_title"),"text_header");
         setTitle(field);
         bkg.eAddChild(field);
         var button:EButton = mViewFactory.getButtonClose(null,layoutFactory.getArea("btn_close"));
         setCloseButton(button);
         bkg.eAddChild(button);
         button.eAddEventListener("click",this.onCloseClick);
         this.mBodyArea = layoutFactory.getArea("body");
         mFooterArea = layoutFactory.getArea("footer");
      }
      
      private function setupBody() : void
      {
         var initialPage:int = 0;
         var previewTextField:ETextField = null;
         var miniLayout:ELayoutArea = null;
         var i:int = 0;
         var initialAAType:String = this.mProfile.getTextAntiAliasingMode();
         var layout:ELayoutArea = ELayoutAreaFactory.createLayoutArea(240,130);
         var options:Vector.<String>;
         if((initialPage = (options = new <String>["normal","advanced"]).indexOf(initialAAType)) > -1)
         {
            this.mAAType = initialAAType;
         }
         else
         {
            initialPage = 1;
         }
         this.mAAPaginator = new EOptionPaginator(4313,options,new <int>[4314,4315],this.onOptionChanged,this.isAATypeSelected);
         this.mAAPaginator.init(this,layout);
         this.mAAPaginator.setPageId(null,initialPage);
         setContent("aaTypePaginator",this.mAAPaginator);
         eAddChild(this.mAAPaginator);
         var boxes:Array = [];
         var textProps:Vector.<String> = new <String>["text_body","text_title_0","text_header"];
         for(i = 0; i < 3; )
         {
            miniLayout = ELayoutAreaFactory.createLayoutArea(80 + i * 50,60);
            (previewTextField = mViewFactory.getETextField(null,ELayoutAreaFactory.createLayoutTextAreaFromLayoutArea(miniLayout),textProps[i])).setText(DCTextMng.getText(4318));
            previewTextField.setFontSize(10 + i * 10);
            this.mPreviewTexts.setContent("previewText-" + i,previewTextField);
            this.mPreviewTexts.eAddChild(previewTextField);
            boxes.push(previewTextField);
            i++;
         }
         var previewLayout:ELayoutArea = mViewFactory.createMinimumLayoutArea(boxes,0,1);
         this.mPreviewTexts.setLayoutArea(previewLayout);
         mViewFactory.distributeSpritesInArea(previewLayout,boxes,1,1,-1,1);
         setContent("previewTexts",this.mPreviewTexts);
         eAddChild(this.mPreviewTexts);
         var barRow:ESpriteContainer = mViewFactory.getESpriteContainer();
         layout = ELayoutAreaFactory.createLayoutArea(240,60);
         this.mBarSharpness = new EOptionSlider("barSharpness",4316,this.onOptionChanged);
         this.mBarSharpness.setBounds(-400,400);
         this.mBarSharpness.init(layout);
         this.mBarSharpness.setValue(this.mProfile.getTextSharpness());
         barRow.setContent("barSharpness",this.mBarSharpness);
         barRow.eAddChild(this.mBarSharpness);
         layout = ELayoutAreaFactory.createLayoutArea(240,60);
         this.mBarThickness = new EOptionSlider("barThickness",4317,this.onOptionChanged);
         this.mBarThickness.setBounds(-200,200);
         this.mBarThickness.init(layout);
         this.mBarThickness.setValue(this.mProfile.getTextThickness());
         barRow.setContent("barThickness",this.mBarThickness);
         barRow.eAddChild(this.mBarThickness);
         this.mBodyArea.centerContent(this.mAAPaginator);
         var barArea:ELayoutArea = mViewFactory.createMinimumLayoutArea([this.mBarSharpness,this.mBarThickness],2,1);
         barRow.setLayoutArea(barArea);
         mViewFactory.distributeSpritesInArea(barArea,[this.mBarSharpness,this.mBarThickness],1,1,-1,1);
         setContent("barRow",barRow);
         eAddChild(barRow);
         if(!this.antiAliasTypeHasCapabilities(initialAAType))
         {
            this.mBarSharpness.visible = false;
            this.mBarThickness.visible = false;
         }
         mViewFactory.distributeSpritesInArea(this.mBodyArea,[this.mAAPaginator,barRow,this.mPreviewTexts],1,1,1,-1,true);
         var button:EButton = mViewFactory.getButtonByTextWidth(DCTextMng.getText(3969),0,"btn_accept");
         addButton("resetBtn",button);
         button.eAddEventListener("click",this.onResetClicked);
         button = mViewFactory.getButtonByTextWidth(DCTextMng.getText(4319),0,"btn_accept");
         addButton("applyBtn",button);
         button.eAddEventListener("click",this.onApplyClicked);
      }
      
      private function onOptionChanged(sku:String, value:int = 0) : void
      {
         var i:int = 0;
         var tf:TextField = null;
         var hasCapabilities:Boolean = false;
         switch(sku)
         {
            case "barSharpness":
               this.mSharpness = value;
               for(i = 0; i < this.mPreviewTexts.numChildren; )
               {
                  tf = (this.mPreviewTexts.getChildAt(i) as ETextField).getTextField();
                  tf.sharpness = value;
                  i++;
               }
               break;
            case "barThickness":
               this.mThickness = value;
               for(i = 0; i < this.mPreviewTexts.numChildren; )
               {
                  tf = (this.mPreviewTexts.getChildAt(i) as ETextField).getTextField();
                  tf.thickness = value;
                  i++;
               }
               break;
            default:
               this.mAAType = sku;
               for(i = 0; i < this.mPreviewTexts.numChildren; )
               {
                  tf = (this.mPreviewTexts.getChildAt(i) as ETextField).getTextField();
                  tf.antiAliasType = sku;
                  i++;
               }
               hasCapabilities = this.antiAliasTypeHasCapabilities(sku);
               this.mBarSharpness.visible = hasCapabilities;
               this.mBarThickness.visible = hasCapabilities;
         }
      }
      
      private function isAATypeSelected(sku:String) : Boolean
      {
         return sku == this.mAAType;
      }
      
      private function antiAliasTypeHasCapabilities(aaType:String) : Boolean
      {
         return aaType == "advanced";
      }
      
      private function onResetClicked(e:EEvent) : void
      {
         this.mAAType = "advanced";
         this.mSharpness = 0;
         this.mThickness = 0;
         this.mAAPaginator.setPageId(null,1);
         this.mBarSharpness.setValue(this.mSharpness);
         this.mBarThickness.setValue(this.mThickness);
         this.mBarSharpness.visible = true;
         this.mBarThickness.visible = true;
      }
      
      private function onApplyClicked(e:EEvent) : void
      {
         this.mApplyCallback({
            "AA":this.mAAType,
            "sharpness":this.mSharpness,
            "thickness":this.mThickness
         });
         this.onCloseClick(null);
      }
      
      private function onCloseClick(e:EEvent) : void
      {
         InstanceMng.getUIFacade().closePopup(this);
      }
   }
}
