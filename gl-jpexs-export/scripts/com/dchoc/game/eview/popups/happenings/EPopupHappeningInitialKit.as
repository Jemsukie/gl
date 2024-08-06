package com.dchoc.game.eview.popups.happenings
{
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.popups.inventory.EInventoryItemView;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.model.happening.HappeningDef;
   import com.dchoc.game.model.happening.HappeningTypeWaveDef;
   import com.dchoc.game.model.items.RewardObject;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import flash.utils.Dictionary;
   
   public class EPopupHappeningInitialKit extends EGamePopup
   {
      
      public static const ADVISOR:String = "img";
      
      public static const TEXT_INFO:String = "text_info";
      
      public static const BOXES_CONTAINER:String = "area_items";
      
      public static const BOX_PREFIX:String = "box_";
      
      public static const AREA_SPEECH:String = "speech";
      
      public static const AREA_SPEECH_ARROW:String = "arrow";
      
      public static const AREA_SPEECH_TEXT:String = "text";
       
      
      public function EPopupHappeningInitialKit()
      {
         super();
      }
      
      public function setupHappening(happeningDef:HappeningDef) : void
      {
         var itemKitSku:String = null;
         var arrow:EImage = null;
         var text:String = null;
         var textContent:ESpriteContainer = null;
         var speechBubble:ESprite = null;
         var shopButton:EButton = null;
         var itemSku:String = null;
         var itemAmount:String = null;
         var itemContainer:EInventoryItemView = null;
         var rewardObject:RewardObject = null;
         var currentItemAmount:int = 0;
         var body:ESpriteContainer = mViewFactory.getESpriteContainer();
         var happeningTypeWaveDef:HappeningTypeWaveDef = InstanceMng.getHappeningTypeDefMng().getDefBySku(happeningDef.getTypeSku()) as HappeningTypeWaveDef;
         var layoutAreaFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("LayoutHappeningsInitialKit");
         setupStructure("PopL","pop_l",happeningDef.getInitialKitTitle(),body);
         var advisor:EImage = mViewFactory.getEImage(happeningTypeWaveDef.getShopAdvisorPath(),null,false,layoutAreaFactory.getArea("img"));
         setContent("img",advisor);
         body.eAddChild(advisor);
         var text_info:ETextField;
         (text_info = mViewFactory.getETextField(null,layoutAreaFactory.getTextArea("text_info"),"text_body_3")).setText(DCTextMng.getText(3191));
         setContent("text_info",text_info);
         body.eAddChild(text_info);
         var itemSkus:Array = happeningDef.getInitialKitItems();
         var boxes:Array = [];
         for each(itemKitSku in itemSkus)
         {
            itemSku = String(itemKitSku.split(":")[0]);
            itemAmount = String(itemKitSku.split(":")[1]);
            itemContainer = new EInventoryItemView();
            currentItemAmount = (rewardObject = InstanceMng.getRuleMng().createRewardObjectFromParams("item",parseInt(itemAmount),itemSku)).getItem().quantity;
            rewardObject.getItem().quantity = parseInt(itemAmount);
            itemContainer.build("BoxUnits");
            itemContainer.fillData(rewardObject.getItem());
            rewardObject.getItem().quantity = currentItemAmount;
            itemContainer.setActionButtonVisible(false);
            itemContainer.setCloseButtonVisible(false);
            body.setContent("box_" + boxes.length,itemContainer);
            body.eAddChild(itemContainer);
            boxes.push(itemContainer);
         }
         mViewFactory.distributeSpritesInArea(layoutAreaFactory.getArea("area_items"),boxes,1,1,-1,1,true);
         arrow = mViewFactory.getEImage("speech_arrow",null,false,layoutAreaFactory.getArea("arrow"),"speech_color");
         body.setContent("arrow",arrow);
         text = DCTextMng.checkTags(happeningDef.getInitialKitBody());
         (textContent = mViewFactory.getContentOneText("ContainerTextField",text,"text_body",null)).layoutApplyTransformations(layoutAreaFactory.getTextArea("text"));
         body.setContent("text",textContent);
         speechBubble = mViewFactory.getSpeechBubble(layoutAreaFactory.getArea("speech"),layoutAreaFactory.getArea("arrow"),textContent,null,"speech_color");
         body.setContent("speech",speechBubble);
         body.eAddChild(speechBubble);
         body.eAddChild(arrow);
         body.eAddChild(textContent);
         (shopButton = mViewFactory.getButtonByTextWidth(DCTextMng.getText(508),0,"btn_common")).eAddEventListener("click",this.onShopButton);
         addButton("SHOP",shopButton);
         getCloseButton().eAddEventListener("click",notifyPopupMngClose);
         setCloseButtonVisible(true);
      }
      
      private function onShopButton(evt:EEvent) : void
      {
         notifyPopupMngClose(evt);
         var params:Dictionary = new Dictionary();
         params["tab"] = "specials";
         MessageCenter.getInstance().sendMessage("openPremiumShop",params);
      }
   }
}
