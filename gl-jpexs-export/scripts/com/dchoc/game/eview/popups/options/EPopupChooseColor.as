package com.dchoc.game.eview.popups.options
{
   import com.dchoc.game.controller.entry.EntryFactory;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.gskinner.geom.ColorMatrix;
   import esparragon.display.EImage;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import flash.filters.ColorMatrixFilter;
   
   public class EPopupChooseColor extends EGamePopup
   {
       
      
      private const SKU_BAR_HUE:String = "barHue";
      
      private const SKU_BAR_BRIGHTNESS:String = "barBrightness";
      
      private const SKU_BAR_SATURATION:String = "barSaturation";
      
      private var mColor:Vector.<int>;
      
      private var mColorBars:Array;
      
      private var mColorBarsContainer:ESpriteContainer;
      
      private var mColorPreview:EImage;
      
      private var mBodyArea:ELayoutArea;
      
      private var mApplyCallback:Function;
      
      public function EPopupChooseColor()
      {
         mColor = new Vector.<int>(1);
         mColorBars = [];
         super();
      }
      
      override public function setup(popupId:String, viewFactory:ViewFactory, skinId:String) : void
      {
         super.setup(popupId,viewFactory,skinId);
         this.setupBackground();
         setTitleText(DCTextMng.getText(4292));
         this.setupBody();
      }
      
      public function setApplyCallback(func:Function) : void
      {
         this.mApplyCallback = func;
      }
      
      private function setupBackground() : void
      {
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopS");
         setLayoutArea(layoutFactory.getContainerLayoutArea());
         var bkg:EImage = mViewFactory.getEImage("pop_s",null,false,layoutFactory.getArea("bg"));
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
         var button:EButton = null;
         var optionSlider:EOptionSlider = null;
         var i:int = 0;
         var barSku:String = null;
         var barTid:int = 0;
         var barBounds:* = undefined;
         var barValue:int = 0;
         this.mColorBarsContainer = mViewFactory.getESpriteContainer();
         var layout:ELayoutArea;
         (layout = ELayoutAreaFactory.createLayoutArea(250,60)).isSetPositionEnabled = false;
         var BARS_SKUS:Vector.<String> = new <String>["barHue","barBrightness","barSaturation"];
         var BARS_TIDS:Vector.<int> = new <int>[4296,4297,4298];
         var BARS_BOUNDS:Vector.<Vector.<int>> = new <Vector.<int>>[new <int>[-180,180],new <int>[-255,255],new <int>[-100,100]];
         var barsInitValues:Array = [];
         var loadedColor:String;
         if((loadedColor = InstanceMng.getUserInfoMng().getProfileLogin().getCivilsColor()) && loadedColor != "")
         {
            barsInitValues = loadedColor.split(",");
         }
         i = 0;
         while(i < this.mColor.length)
         {
            barSku = BARS_SKUS[i];
            barTid = BARS_TIDS[i];
            barBounds = BARS_BOUNDS[i];
            barValue = 0;
            if(i < barsInitValues.length)
            {
               barValue = parseInt(barsInitValues[i]);
            }
            this.mColor[i] = barValue;
            (optionSlider = new EOptionSlider(barSku,barTid,this.onColorChanged)).setBounds(barBounds[0],barBounds[1]);
            optionSlider.init(layout);
            optionSlider.setValue(barValue,false);
            this.mColorBarsContainer.setContent(barSku,optionSlider);
            this.mColorBarsContainer.eAddChild(optionSlider);
            this.mColorBars.push(optionSlider);
            i++;
         }
         eAddChild(this.mColorBarsContainer);
         setContent("barsContainer",this.mColorBarsContainer);
         this.mColorBarsContainer.setLayoutArea(this.mBodyArea,true);
         optionSlider.x = (this.mBodyArea.width - optionSlider.width) / 2;
         optionSlider.y = 0;
         (layout = ELayoutAreaFactory.createLayoutArea(100,100)).x = this.mBodyArea.width / 2 - 25;
         layout.y = this.mBodyArea.height - 40;
         this.mColorPreview = this.mViewFactory.getEImage("orange_normal",null,false,layout);
         this.mColorPreview.scaleX = 0.4;
         this.mColorPreview.scaleY = 0.4;
         eAddChild(this.mColorPreview);
         setContent("colorPreview",this.mColorPreview);
         button = mViewFactory.getButtonByTextWidth(DCTextMng.getText(3969),0,"btn_accept");
         addButton("resetBtn",button);
         button.eAddEventListener("click",this.onResetClicked);
         var price:int = InstanceMng.getSettingsDefMng().mSettingsDef.getStarlingColorPrice();
         button = mViewFactory.getButtonPayment(null,EntryFactory.createCashSingleEntry(-price));
         addButton("applyBtn",button);
         button.eAddEventListener("click",this.onApplyClicked);
      }
      
      private function onColorChanged(sku:String, value:int) : void
      {
         switch(sku)
         {
            case "barHue":
               this.mColor[0] = value;
               break;
            case "barBrightness":
               this.mColor[1] = value;
               break;
            case "barSaturation":
               this.mColor[2] = value;
         }
         var colorMatrix:ColorMatrix = new ColorMatrix();
         colorMatrix.adjustHue(this.mColor[0]);
         this.mColorPreview.filters = [new ColorMatrixFilter(colorMatrix.toArray())];
      }
      
      private function onResetClicked(e:EEvent) : void
      {
         var i:int = 0;
         var bar:EOptionSlider = null;
         for(i = 0; i < this.mColor.length; )
         {
            bar = this.mColorBars[i];
            bar.setValue(0);
            i++;
         }
      }
      
      private function onApplyClicked(e:EEvent) : void
      {
         var result:String = "";
         if(this.mColor[0] != 0)
         {
            result = "" + this.mColor[0];
         }
         this.mApplyCallback(result);
         this.onCloseClick(null);
      }
      
      private function onCloseClick(e:EEvent) : void
      {
         InstanceMng.getUIFacade().closePopup(this);
      }
   }
}
