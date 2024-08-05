package com.dchoc.game.eview.widgets.tooltips
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ETooltipComplex extends ETooltip
   {
      
      private static const ARROW_MARGIN:int = 7;
       
      
      protected var mContent:ESpriteContainer;
      
      protected var mArrow:EImage;
      
      protected var mTitle:ETextField;
      
      protected var mMaxWidth:int;
      
      public function ETooltipComplex()
      {
         super();
         mType = 1;
      }
      
      public function build(info:ETooltipInfo) : void
      {
         var textfield:ETextField = null;
         this.eRemoveAllChildren();
         this.mMaxWidth = 0;
         var skinSku:String = InstanceMng.getSkinsMng().getCurrentSkinSku();
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         this.mTitle = this.createTextfield(info.title,viewFactory,skinSku,"center");
         this.mTitle.applySkinProp(skinSku,"text_title_0");
         this.mMaxWidth = Math.max(this.mMaxWidth,this.mTitle.width);
         this.mContent = viewFactory.getESpriteContainer();
         if(info.text)
         {
            textfield = this.createTextfield(info.text,viewFactory,skinSku,"left",info.textPropSku);
            this.mMaxWidth = Math.max(this.mMaxWidth,textfield.width);
            this.mContent.eAddChild(textfield);
            this.mContent.setContent("text",textfield);
         }
         this.buildContent(info,viewFactory,skinSku);
         this.mContent.logicTop = this.mTitle.height;
         var layout:ELayoutArea = ELayoutAreaFactory.createLayoutArea();
         layout.height = this.mTitle.textWithMarginHeight + this.mContent.height + 2 * 12;
         layout.width = this.mMaxWidth + 2 * 12;
         var bkg:EImage = viewFactory.getEImage(info.bkgPropSku,skinSku,false,layout);
         this.mTitle.width = Math.max(this.mTitle.width,this.mMaxWidth);
         this.mTitle.logicLeft = 12;
         if(textfield)
         {
            textfield.logicLeft = 12;
            textfield.width = this.mMaxWidth;
         }
         this.eAddChild(bkg);
         bkg.eAddChild(this.mTitle);
         bkg.eAddChild(this.mContent);
         setContent("bkg",bkg);
         setContent("title",this.mTitle);
         setContent("content",this.mContent);
      }
      
      public function setText(text:String) : void
      {
         var textField:ETextField = this.mContent.getContentAsETextField("text");
         if(textField)
         {
            textField.setText(text);
         }
      }
      
      protected function buildContent(info:ETooltipInfo, viewFactory:ViewFactory, skin:String) : void
      {
      }
      
      protected function createTextfield(text:String, viewFactory:ViewFactory, skin:String, halign:String = "left", propSku:String = "text_body") : ETextField
      {
         var textfield:ETextField;
         (textfield = viewFactory.getETextField(skin)).width = 200;
         textfield.setAutoScale(false);
         textfield.applySkinProp(skin,propSku);
         textfield.setText(text);
         textfield.setHAlign(halign);
         textfield.height = textfield.textWithMarginHeight + 12;
         textfield.width = Math.min(textfield.textWithMarginWidth + 10 + 12,200);
         textfield.logicLeft = 12 >> 1;
         return textfield;
      }
      
      override public function setArrowVisible(value:Boolean, sp:ESprite) : void
      {
         var arrowResource:String = null;
         var arrowPivotX:Number = NaN;
         var arrowPivotY:Number = NaN;
         var arrowGlobalX:int = 0;
         var arrowGlobalY:int = 0;
         var localPoint:Point = null;
         var thisRect:Rectangle = null;
         var spRect:Rectangle = null;
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         if(visible && sp)
         {
            arrowResource = "tooltip_arrow";
            arrowPivotX = 0.5;
            arrowPivotY = 0;
            arrowGlobalX = 0;
            arrowGlobalY = 0;
            localPoint = new Point();
            if(this.stage)
            {
               thisRect = this.getRect(this.stage);
               thisRect = new Rectangle(thisRect.left,thisRect.top,this.getLogicWidth(),this.getLogicHeight());
            }
            else
            {
               thisRect = new Rectangle(this.logicLeft,this.logicTop,this.getLogicWidth(),this.getLogicHeight());
            }
            localPoint = sp.getRect(sp.stage).topLeft;
            spRect = new Rectangle(localPoint.x,localPoint.y,sp.getLogicWidth(),sp.getLogicHeight());
            if(thisRect.top > spRect.bottom)
            {
               arrowResource = "tooltip_arrow_up";
               arrowPivotY = 0;
               arrowGlobalX = spRect.left + sp.getLogicWidth() / 2;
               arrowGlobalY = thisRect.top + 7 + 1;
            }
            else if(thisRect.bottom < spRect.top)
            {
               arrowResource = "tooltip_arrow";
               arrowPivotY = 0;
               arrowGlobalX = spRect.left + sp.getLogicWidth() / 2;
               arrowGlobalY = thisRect.bottom - 7;
            }
            if(this.mArrow)
            {
               this.mArrow.visible = true;
            }
            else
            {
               localPoint = new Point(arrowGlobalX,arrowGlobalY);
               this.mArrow = viewFactory.getEImage(arrowResource,null,false);
               this.mArrow.logicX = arrowGlobalX - this.logicLeft;
               this.mArrow.logicY = arrowGlobalY - this.logicTop;
               this.mArrow.setPivotLogicXY(arrowPivotX,arrowPivotY);
               getContent("bkg").eAddChildAt(this.mArrow,1);
               setContent("arrow",this.mArrow);
            }
         }
         else if(this.mArrow)
         {
            this.mArrow.visible = false;
         }
      }
   }
}
