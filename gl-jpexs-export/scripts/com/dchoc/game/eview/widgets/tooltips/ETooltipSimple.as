package com.dchoc.game.eview.widgets.tooltips
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import esparragon.display.EImage;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutTextArea;
   
   public class ETooltipSimple extends ETooltip
   {
       
      
      private var mTextField:ETextField;
      
      public function ETooltipSimple()
      {
         super();
         mType = 0;
      }
      
      public function build(text:String, propSku:String = null) : void
      {
         var skinSku:String = InstanceMng.getSkinsMng().getCurrentSkinSku();
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         var layout:ELayoutTextArea = new ELayoutTextArea(viewFactory.getLayoutAreaFactory("TooltipTextfieldText").getTextArea("text_info"));
         this.mTextField = viewFactory.getETextField(skinSku);
         this.mTextField.width = 200;
         this.mTextField.autoSize(true);
         this.mTextField.setAutoScale(false);
         this.mTextField.applySkinProp(skinSku,"text_tooltip");
         this.mTextField.setText(text);
         if(propSku)
         {
            this.mTextField.applySkinProp(skinSku,propSku);
         }
         this.mTextField.height = this.mTextField.textWithMarginHeight;
         this.mTextField.width = Math.min(this.mTextField.textWithMarginWidth + 10,200);
         this.mTextField.logicLeft = 12;
         this.mTextField.logicTop = 12;
         layout.height = this.mTextField.height + 2 * 12;
         layout.width = this.mTextField.width + 2 * 12;
         var bkg:EImage = viewFactory.getEImage("hud_tooltip",skinSku,false,layout);
         this.eAddChild(bkg);
         bkg.eAddChild(this.mTextField);
         setContent("bkg",bkg);
         setContent("content",this.mTextField);
      }
   }
}
