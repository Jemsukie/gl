package com.dchoc.game.eview.popups.buffer
{
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.layout.ELayoutTextArea;
   import esparragon.widgets.EButton;
   
   public class EPopupTemplateImport extends EGamePopup
   {
       
      
      private const BODY:String = "body";
      
      private var mBodyArea:ELayoutArea;
      
      private var mInputField:ETextField;
      
      private var mImportCode:String;
      
      private var mSlotId:int;
      
      public function EPopupTemplateImport()
      {
         super();
      }
      
      override public function setup(popupId:String, viewFactory:ViewFactory, skinId:String) : void
      {
         super.setup(popupId,viewFactory,skinId);
         this.setupBackground();
         setTitleText(DCTextMng.getText(4068));
         this.setupBody();
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
         var body:ESprite = mViewFactory.getESprite(null,this.mBodyArea);
         bkg.eAddChild(body);
         setContent("body",body);
         mFooterArea = layoutFactory.getArea("footer");
      }
      
      private function setupBody() : void
      {
         var body:ESprite = getContent("body");
         var layoutFactory:ELayoutAreaFactory;
         var area:ELayoutTextArea = (layoutFactory = mViewFactory.getLayoutAreaFactory("ContainerTextField")).getTextArea("text_info");
         var tArea1:ELayoutTextArea = ELayoutAreaFactory.createLayoutTextAreaFromLayoutTextArea(area);
         var tArea2:ELayoutTextArea = ELayoutAreaFactory.createLayoutTextAreaFromLayoutTextArea(area);
         var OFFSET:int = 10;
         var HEIGHT:int = 36;
         tArea1.width = this.mBodyArea.width - OFFSET;
         tArea1.height = HEIGHT;
         tArea2.width = this.mBodyArea.width - OFFSET;
         tArea2.height = this.mBodyArea.height - HEIGHT;
         tArea1.x = OFFSET / 2;
         tArea1.y = 0;
         tArea2.x = OFFSET / 2;
         tArea2.y = HEIGHT;
         var field:ETextField;
         (field = mViewFactory.getETextField(null,tArea1,"text_subheader")).setText(DCTextMng.getText(4069));
         field.setHAlign("left");
         body.eAddChild(field);
         setContent("titleField",field);
         var img:EImage = mViewFactory.getEImage("box_simple",null,false,tArea2,"color_blue_box");
         body.eAddChild(img);
         setContent("inputBkg",img);
         this.mInputField = mViewFactory.getETextField(null,tArea2,"text_body");
         this.mInputField.setText("");
         this.mInputField.setEditable(true);
         this.mInputField.setHAlign("left");
         this.mInputField.setVAlign("top");
         this.mInputField.setMultiline(false);
         this.mInputField.setWordWrap(true);
         this.mInputField.setMaxChars(36);
         this.mInputField.setFontSize(32);
         this.mInputField.eAddEventListener("keyUp",updateCode);
         body.eAddChild(this.mInputField);
         setContent("input",this.mInputField);
         var button:EButton = mViewFactory.getButtonByTextWidth(DCTextMng.getText(4068),0,"btn_accept");
         addButton("doImport",button);
         button.eAddEventListener("click",this.doImport);
      }
      
      public function setSlotId(value:int) : void
      {
         this.mSlotId = value;
      }
      
      private function updateCode(e:EEvent) : void
      {
         this.mImportCode = this.mInputField.getText().toLowerCase().replace(/[\s|\t|\n]*/g,"");
      }
      
      private function clearCode() : void
      {
         this.mInputField.setText("");
         this.updateCode(null);
      }
      
      private function doImport(e:EEvent) : void
      {
         var codeFormatIsValid:Boolean = false;
         if(this.mImportCode != null && this.mImportCode != "")
         {
            if(this.mImportCode.length == 24 && /^[0-9a-fA-F]+$/g.test(this.mImportCode))
            {
               codeFormatIsValid = true;
            }
         }
         if(codeFormatIsValid)
         {
            this.onCloseClick(null);
            MessageCenter.getInstance().sendMessage("lockTemplatesPopup");
            InstanceMng.getUserDataMng().updateTemplates_importTemplate(this.mSlotId,this.mImportCode);
         }
         else
         {
            InstanceMng.getNotificationsMng().guiOpenTemplateError(5);
            this.clearCode();
         }
      }
      
      private function onCloseClick(e:EEvent) : void
      {
         InstanceMng.getUIFacade().closePopup(this);
      }
   }
}
