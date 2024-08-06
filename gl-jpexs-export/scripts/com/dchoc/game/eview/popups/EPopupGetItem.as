package com.dchoc.game.eview.popups
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.model.items.ItemObject;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.layout.ELayoutTextArea;
   import esparragon.widgets.EButton;
   import flash.text.TextField;
   
   public class EPopupGetItem extends EGamePopup
   {
       
      
      private const BODY:String = "body";
      
      private var mBodyArea:ELayoutArea;
      
      private var mInputSku:TextField;
      
      private var mInputAmount:TextField;
      
      public function EPopupGetItem()
      {
         super();
      }
      
      override public function setup(popupId:String, viewFactory:ViewFactory, skinId:String) : void
      {
         super.setup(popupId,viewFactory,skinId);
         this.setupBackground("PopS","pop_s");
         setTitleText("Create and add item");
         this.setupBody();
      }
      
      protected function setupBackground(layoutName:String, background:String) : void
      {
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory(layoutName);
         setLayoutArea(layoutFactory.getContainerLayoutArea());
         var bkg:EImage = mViewFactory.getEImage(background,null,false,layoutFactory.getArea("bg"));
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
         var tArea1:ELayoutTextArea = null;
         var tArea2:ELayoutTextArea = null;
         var tArea3:ELayoutTextArea = null;
         var tArea4:ELayoutTextArea = null;
         var body:ESprite = getContent("body");
         var layoutFactory:ELayoutAreaFactory;
         var area:ELayoutTextArea = (layoutFactory = mViewFactory.getLayoutAreaFactory("ContainerTextField")).getTextArea("text_info");
         tArea1 = ELayoutAreaFactory.createLayoutTextAreaFromLayoutTextArea(area);
         tArea2 = ELayoutAreaFactory.createLayoutTextAreaFromLayoutTextArea(area);
         tArea3 = ELayoutAreaFactory.createLayoutTextAreaFromLayoutTextArea(area);
         tArea4 = ELayoutAreaFactory.createLayoutTextAreaFromLayoutTextArea(area);
         var OFFSET:int = 10;
         var HEIGHT:int = 36;
         tArea1.width = this.mBodyArea.width / 2 - OFFSET;
         tArea1.height = HEIGHT;
         tArea2.width = this.mBodyArea.width / 2 - OFFSET;
         tArea2.height = HEIGHT;
         tArea3.width = this.mBodyArea.width / 2 - OFFSET;
         tArea3.height = HEIGHT;
         tArea4.width = this.mBodyArea.width / 2 - OFFSET;
         tArea4.height = HEIGHT;
         tArea1.x = OFFSET / 2;
         tArea1.y = this.mBodyArea.height / 2 - HEIGHT;
         tArea2.x = OFFSET / 2 + this.mBodyArea.width / 2;
         tArea2.y = this.mBodyArea.height / 2 - HEIGHT;
         tArea3.x = OFFSET / 2;
         tArea3.y = this.mBodyArea.height / 2;
         tArea4.x = OFFSET / 2 + this.mBodyArea.width / 2;
         tArea4.y = this.mBodyArea.height / 2;
         var field:ETextField = mViewFactory.getETextField(null,tArea1,"text_subheader");
         body.eAddChild(field);
         setContent("titleItem",field);
         field.setText("Item:");
         field.setHAlign("left");
         field = mViewFactory.getETextField(null,tArea2,"text_subheader");
         body.eAddChild(field);
         setContent("titleAmount",field);
         field.setText("Amount:");
         field.setHAlign("left");
         var img:EImage = mViewFactory.getEImage("box_simple",null,false,tArea3,"color_blue_box");
         body.eAddChild(img);
         setContent("itemBkg",img);
         img = mViewFactory.getEImage("box_simple",null,false,tArea4,"color_blue_box");
         body.eAddChild(img);
         setContent("AmountBkg",img);
         field = mViewFactory.getETextField(null,tArea3,"text_subheader");
         body.eAddChild(field);
         setContent("inputItem",field);
         field.setText("");
         field.setEditable(true);
         field.setHAlign("left");
         this.mInputSku = field.getTextField();
         field = mViewFactory.getETextField(null,tArea4,"text_subheader");
         body.eAddChild(field);
         setContent("inputAmount",field);
         field.setText("");
         field.setEditable(true);
         field.setHAlign("left");
         this.mInputAmount = field.getTextField();
         var button:EButton = mViewFactory.getButtonByTextWidth("Create Items",0,"btn_accept");
         addButton("button",button);
         button.eAddEventListener("click",this.onCreate);
      }
      
      private function onCloseClick(e:EEvent) : void
      {
         InstanceMng.getUIFacade().closePopup(this);
      }
      
      private function onCreate(e:EEvent) : void
      {
         var i:int = 0;
         var count:int = 0;
         var itemObject:ItemObject = null;
         var x:int = InstanceMng.getWorld().itemsGetHeadquarters().mViewCenterWorldX;
         var y:int = InstanceMng.getWorld().itemsGetHeadquarters().mViewCenterWorldY;
         var sku:String = this.mInputSku.text;
         var amount:int = int(this.mInputAmount.text);
         for(i = 0; i < amount; )
         {
            if(count < 10)
            {
               itemObject = InstanceMng.getItemsMng().getItemObjectBySku(sku);
               if(itemObject != null)
               {
                  InstanceMng.getItemsMng().getCollectibleItemsParticle(sku,x,y);
                  InstanceMng.getUserDataMng().updateSocialItem_addItem(sku,1);
                  count++;
               }
            }
            i++;
         }
         this.onCloseClick(null);
      }
   }
}
