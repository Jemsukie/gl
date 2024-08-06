package com.dchoc.game.eview.popups.inventory
{
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.eview.widgets.smallStructures.IconBar;
   import com.dchoc.game.model.items.ItemObject;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.layout.ELayoutTextArea;
   import esparragon.widgets.EButton;
   
   public class EPopupUseResources extends EGamePopup
   {
       
      
      private const BODY:String = "body";
      
      private var mBodyArea:ELayoutArea;
      
      private var mInputQuantityField:ETextField;
      
      private var mProducedAmountField:ETextField;
      
      private var mPreviewIconBar:IconBar;
      
      private var mItemObject:ItemObject;
      
      private var mQuantity:int = 0;
      
      public function EPopupUseResources()
      {
         super();
      }
      
      public function setItemObject(itemObject:ItemObject) : void
      {
         this.mItemObject = itemObject;
      }
      
      override public function setup(popupId:String, viewFactory:ViewFactory, skinId:String) : void
      {
         super.setup(popupId,viewFactory,skinId);
         this.setupBackground("PopS","pop_s");
         var titleText:String = "";
         switch(this.mItemObject.mDef.getActionType())
         {
            case "coins":
               titleText = DCTextMng.getText(4063);
               break;
            case "minerals":
               titleText = DCTextMng.getText(4064);
         }
         setTitleText(titleText);
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
         var body:ESprite = getContent("body");
         var layoutFactory:ELayoutAreaFactory;
         var area:ELayoutTextArea = (layoutFactory = mViewFactory.getLayoutAreaFactory("ContainerTextField")).getTextArea("text_info");
         var tArea1:ELayoutTextArea = ELayoutAreaFactory.createLayoutTextAreaFromLayoutTextArea(area);
         var tArea2:ELayoutTextArea = ELayoutAreaFactory.createLayoutTextAreaFromLayoutTextArea(area);
         var tArea3:ELayoutTextArea = ELayoutAreaFactory.createLayoutTextAreaFromLayoutTextArea(area);
         var tArea4:ELayoutTextArea = ELayoutAreaFactory.createLayoutTextAreaFromLayoutTextArea(area);
         var OFFSET:int = 10;
         var HEIGHT:int = 36;
         tArea1.width = this.mBodyArea.width - OFFSET;
         tArea1.height = HEIGHT;
         tArea2.width = this.mBodyArea.width - OFFSET;
         tArea2.height = HEIGHT;
         tArea3.width = this.mBodyArea.width - OFFSET;
         tArea3.height = HEIGHT;
         tArea4.width = this.mBodyArea.width - OFFSET;
         tArea4.height = HEIGHT;
         tArea1.x = OFFSET / 2;
         tArea1.y = 0;
         tArea2.x = OFFSET / 2;
         tArea2.y = HEIGHT;
         tArea3.x = OFFSET;
         tArea3.y = HEIGHT * 2;
         tArea4.x = this.mBodyArea.width / 2;
         tArea4.y = HEIGHT * 3;
         var field:ETextField;
         (field = mViewFactory.getETextField(null,tArea1,"text_subheader")).setText(DCTextMng.getText(4065));
         field.setHAlign("left");
         body.eAddChild(field);
         setContent("titleQuantity",field);
         var img:EImage = mViewFactory.getEImage("box_simple",null,false,tArea2,"color_blue_box");
         body.eAddChild(img);
         setContent("quantityBkg",img);
         this.mInputQuantityField = mViewFactory.getETextField(null,tArea2,"text_subheader");
         this.mInputQuantityField.setText("0");
         this.mInputQuantityField.setEditable(true);
         this.mInputQuantityField.setHAlign("left");
         this.mInputQuantityField.setMaxChars(10);
         this.mInputQuantityField.getTextField().restrict = "0-9";
         this.mInputQuantityField.eAddEventListener("keyUp",updateFields);
         body.eAddChild(this.mInputQuantityField);
         setContent("inputAmount",this.mInputQuantityField);
         var propSku:String = "text_coins";
         var barColor:String = "color_coins";
         var resourceIconSku:String = "icon_coins";
         switch(this.mItemObject.mDef.getActionType())
         {
            case "coins":
               propSku = "text_coins";
               barColor = "color_coins";
               resourceIconSku = "icon_coin";
               break;
            case "minerals":
               propSku = "text_minerals";
               barColor = "color_minerals";
               resourceIconSku = "icon_mineral";
         }
         this.mProducedAmountField = mViewFactory.getETextField(null,tArea3,propSku);
         body.eAddChild(this.mProducedAmountField);
         setContent("producedAmount",this.mProducedAmountField);
         this.mProducedAmountField.setText("");
         this.mProducedAmountField.setHAlign("center");
         this.mPreviewIconBar = new IconBar();
         this.mPreviewIconBar.setup("IconBarM",0,100,barColor,resourceIconSku);
         this.mPreviewIconBar.setLayoutArea(tArea4,true);
         this.mPreviewIconBar.updateText("xxx,xxx,xxx / xxx,xxx,xxx");
         this.mPreviewIconBar.logicUpdate(0);
         body.eAddChild(this.mPreviewIconBar);
         setContent("previewBar",this.mPreviewIconBar);
         var button:EButton = mViewFactory.getButtonByTextWidth(DCTextMng.getText(623),0,"btn_accept");
         addButton("button",button);
         button.eAddEventListener("click",this.onUse);
         this.updateFields(null);
      }
      
      private function updateFields(e:EEvent) : void
      {
         var rawInput:Number = NaN;
         var quantity:* = 0;
         try
         {
            if((rawInput = parseFloat(this.mInputQuantityField.getText())) >= 2147483647)
            {
               quantity = 2147483647;
            }
            else
            {
               quantity = rawInput;
            }
         }
         catch(error:Error)
         {
         }
         if(quantity > 0)
         {
            this.mInputQuantityField.setText(quantity + "");
            this.mInputQuantityField.getTextField().text = quantity + "";
         }
         var profile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         var itemObjectUseQuantity:int = parseInt(this.mItemObject.mDef.getActionParam());
         var currentResourceAmount:Number = 0;
         var newResourceAmount:Number = 0;
         var resourceCapacity:Number = 0;
         switch(this.mItemObject.mDef.getActionType())
         {
            case "coins":
               currentResourceAmount = profile.getCoins();
               resourceCapacity = profile.getCoinsCapacity();
               break;
            case "minerals":
               currentResourceAmount = profile.getMinerals();
               resourceCapacity = profile.getMineralsCapacity();
         }
         var maxQuantity:int = Math.floor((resourceCapacity - currentResourceAmount) / itemObjectUseQuantity);
         maxQuantity = Math.min(maxQuantity,this.mItemObject.quantity);
         if(quantity > maxQuantity)
         {
            quantity = maxQuantity;
            this.mInputQuantityField.setText(quantity + "");
            this.mInputQuantityField.getTextField().text = quantity + "";
         }
         this.mQuantity = quantity;
         var producedAmountText:String = "+" + DCTextMng.convertNumberToString(this.mQuantity * itemObjectUseQuantity,-1,-1);
         this.mProducedAmountField.setText(producedAmountText);
         this.mProducedAmountField.getTextField().text = producedAmountText;
         newResourceAmount = currentResourceAmount + this.mQuantity * itemObjectUseQuantity;
         this.mPreviewIconBar.setBarCurrentValue(newResourceAmount);
         this.mPreviewIconBar.setBarMaxValue(resourceCapacity);
         this.mPreviewIconBar.updateText(DCTextMng.convertNumberToString(newResourceAmount,-1,-1) + "/" + DCTextMng.convertNumberToString(resourceCapacity,-1,-1));
         this.mPreviewIconBar.logicUpdate(0);
         this.mPreviewIconBar.x = (this.mBodyArea.width - this.mPreviewIconBar.width) / 2;
      }
      
      private function onCloseClick(e:EEvent) : void
      {
         InstanceMng.getUIFacade().closePopup(this);
      }
      
      private function onUse(e:EEvent) : void
      {
         if(this.mQuantity > 0)
         {
            switch(this.mItemObject.mDef.getActionType())
            {
               case "coins":
                  InstanceMng.getItemsMng().useItemFromInventory(this.mItemObject,null,"inventory",this.mQuantity);
                  break;
               case "minerals":
                  InstanceMng.getItemsMng().useItemFromInventory(this.mItemObject,null,"inventory",this.mQuantity);
            }
            MessageCenter.getInstance().sendMessage("reloadInventory");
         }
         this.onCloseClick(null);
      }
   }
}
