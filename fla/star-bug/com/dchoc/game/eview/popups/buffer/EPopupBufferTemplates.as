package com.dchoc.game.eview.popups.buffer
{
   import com.dchoc.game.core.flow.messaging.INotifyReceiver;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.model.userdata.UserDataMng;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.EScrollArea;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.utils.EUtils;
   import esparragon.widgets.EButton;
   import flash.display.BitmapData;
   import flash.utils.Dictionary;
   
   public class EPopupBufferTemplates extends EGamePopup implements INotifyReceiver
   {
      
      private static const BODY_SKU:String = "body";
       
      
      private var mLayoutAreaFactory:ELayoutAreaFactory;
      
      private var mBody:ESprite;
      
      private var mScrollArea:EScrollArea;
      
      private var mScrollLayout:ELayoutArea;
      
      private var mTemplateViews:Vector.<EBufferTemplateView>;
      
      private var mTemplatesData:XML = null;
      
      public function EPopupBufferTemplates()
      {
         mTemplateViews = new Vector.<EBufferTemplateView>(0);
         super();
      }
      
      override public function setup(popupId:String, viewFactory:ViewFactory, skinId:String) : void
      {
         super.setup(popupId,viewFactory,skinId);
         this.setupBackground();
         var userDataMng:UserDataMng;
         if(!(userDataMng = InstanceMng.getUserDataMng()).isFileLoaded(UserDataMng.KEY_TEMPLATES))
         {
            return;
         }
         MessageCenter.getInstance().registerObject(this);
         var fileXML:XML = userDataMng.getFileXML(UserDataMng.KEY_TEMPLATES);
         this.mTemplatesData = fileXML;
         this.setupBody();
      }
      
      private function setupBackground() : void
      {
         this.mLayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopXL");
         setLayoutArea(this.mLayoutAreaFactory.getContainerLayoutArea());
         var bkg:EImage = mViewFactory.getEImage("pop_xl",mSkinSku,false,this.mLayoutAreaFactory.getArea("bg"));
         setBackground(bkg);
         eAddChild(bkg);
         this.mBody = mViewFactory.getESprite(mSkinSku,this.mLayoutAreaFactory.getArea("body"));
         setContent("body",this.mBody);
         bkg.eAddChild(this.mBody);
         var button:EButton = mViewFactory.getButtonClose(mSkinSku,this.mLayoutAreaFactory.getArea("btn_close"));
         setCloseButton(button);
         bkg.eAddChild(button);
         button.eAddEventListener("click",this.onCloseClick);
         var field:ETextField = mViewFactory.getETextField(mSkinSku,this.mLayoutAreaFactory.getTextArea("text_title"),"text_title_0");
         setTitle(field);
         field.setText(DCTextMng.getText(3979));
         bkg.eAddChild(field);
      }
      
      private function setupBody() : void
      {
         var numTemplates:int = InstanceMng.getUserInfoMng().getProfileLogin().getMaxHqLevelInAllPlanets() + 1;
         this.mScrollLayout = ELayoutAreaFactory.createLayoutTextAreaFromLayoutArea(this.mBody.getLayoutArea());
         this.mScrollLayout.y -= 40;
         this.mScrollLayout.width -= 60;
         this.mScrollLayout.height += 10;
         this.mScrollArea = new EScrollArea();
         this.mScrollArea.build(this.mScrollLayout,numTemplates,ESpriteContainer,this.fillTemplateData,5);
         setContent("scrollArea",this.mScrollArea);
         this.mBody.eAddChild(this.mScrollArea);
         mViewFactory.getEScrollBar(this.mScrollArea);
      }
      
      private function getTemplateXMLBySlotId(slotId:int) : XML
      {
         if(this.mTemplatesData == null)
         {
            return null;
         }
         for each(var templateXML in EUtils.xmlGetChildrenList(this.mTemplatesData))
         {
            if(EUtils.xmlReadInt(templateXML,"slotId") == slotId)
            {
               return templateXML;
            }
         }
         return null;
      }
      
      private function fillTemplateData(spriteReference:ESpriteContainer, rowOffset:int, rebuild:Boolean) : void
      {
         var templateView:EBufferTemplateView = null;
         var thumb:BitmapData = null;
         var templateCode:String = null;
         var itemsData:Object = null;
         var templateXML:XML = null;
         var itemsXML:XMLList = null;
         if(rebuild)
         {
            while(spriteReference.numChildren)
            {
               (templateView = spriteReference.getChildAt(0) as EBufferTemplateView).destroy();
            }
            (templateView = new EBufferTemplateView()).build();
            thumb = null;
            templateCode = null;
            itemsData = {};
            templateXML = this.getTemplateXMLBySlotId(rowOffset);
            if((itemsXML = EUtils.xmlGetChildrenList(templateXML)) != null)
            {
               itemsData = InstanceMng.getBuildingsBufferController().convertItemsXMLListToSkuBasedItemsData(itemsXML);
               templateCode = EUtils.xmlReadString(templateXML,"id");
            }
            templateView.setData(rowOffset,itemsData,templateCode,thumb);
            this.mTemplateViews.push(templateView);
            spriteReference.eAddChild(templateView);
            spriteReference.setContent("itemContainer" + rowOffset,templateView);
         }
      }
      
      public function updateExportCode(slotId:int, templateUUID:String) : void
      {
         for each(var templateView in this.mTemplateViews)
         {
            if(templateView.getSlotId() == slotId)
            {
               templateView.setData(slotId,null,templateUUID,null);
               templateView.updateTemplateView();
               return;
            }
         }
      }
      
      private function onCloseClick(e:EEvent) : void
      {
         MessageCenter.getInstance().unregisterObject(this);
         super.notifyPopupMngClose(e);
      }
      
      public function getName() : String
      {
         return "EPopupBufferTemplates";
      }
      
      public function getTaskList() : Vector.<String>
      {
         return new <String>["lockTemplatesPopup","unlockTemplatesPopup"];
      }
      
      public function onMessage(cmd:String, params:Dictionary) : void
      {
         var templateView:* = null;
         switch(cmd)
         {
            case "lockTemplatesPopup":
               if(getCloseButton())
               {
                  getCloseButton().setIsEnabled(false);
               }
               for each(templateView in this.mTemplateViews)
               {
                  templateView.setButtonsEnabled(false);
               }
               break;
            case "unlockTemplatesPopup":
               if(getCloseButton())
               {
                  getCloseButton().setIsEnabled(true);
               }
               for each(templateView in this.mTemplateViews)
               {
                  templateView.updateButtons();
               }
         }
      }
   }
}
