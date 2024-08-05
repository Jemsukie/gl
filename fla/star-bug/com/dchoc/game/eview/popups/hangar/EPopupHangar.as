package com.dchoc.game.eview.popups.hangar
{
   import com.dchoc.game.controller.hangar.Hangar;
   import com.dchoc.game.core.flow.messaging.INotifyReceiver;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.eview.widgets.smallStructures.IconBar;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.EScrollArea;
   import esparragon.display.EScrollBar;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.layout.ELayoutTextArea;
   import esparragon.widgets.EButton;
   import flash.utils.Dictionary;
   
   public class EPopupHangar extends EGamePopup implements INotifyReceiver
   {
      
      protected static const TEXT_POWERUP:String = "tezt_title";
      
      protected static const BUTTON_SHOP:String = "button_shop";
      
      protected static const AREA_POWERUP:String = "icon_text";
      
      protected static const AREA_CONTENT:String = "area_units";
      
      protected static const AREA_BAR:String = "area_bar";
      
      private static const INVENTORY_ITEMS_PER_ROW:int = 5;
       
      
      private var mHangarRef:Hangar;
      
      private var mTotalCapacityBar:IconBar;
      
      private var mScrollArea:EScrollArea;
      
      private var mPowerupCountdownTF:ETextField;
      
      private var mInventoryRowWidth:int;
      
      private var mInventoryRowHeight:int;
      
      private var mTopArrow:EImage;
      
      private var mBottomArrow:EImage;
      
      private var mBarBg:EImage;
      
      private var mBar:EImage;
      
      public function EPopupHangar(hangar:Hangar)
      {
         super();
         this.mHangarRef = hangar;
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         MessageCenter.getInstance().unregisterObject(this);
         this.mHangarRef = null;
         if(this.mTotalCapacityBar != null)
         {
            this.mTotalCapacityBar.destroy();
            this.mTotalCapacityBar = null;
         }
         if(this.mScrollArea != null)
         {
            this.mScrollArea.destroy();
            this.mScrollArea = null;
         }
         if(this.mPowerupCountdownTF != null)
         {
            this.mPowerupCountdownTF.destroy();
            this.mPowerupCountdownTF = null;
         }
      }
      
      private function getUnits() : Vector.<Array>
      {
         return InstanceMng.getHangarControllerMng().getHangarController().getUnitsInAllHangars();
      }
      
      public function build(popupId:String, viewFactory:ViewFactory, skinId:String) : void
      {
         var imageArea:ELayoutArea = null;
         var textArea:ELayoutTextArea = null;
         var textField:ETextField = null;
         super.setup(popupId,viewFactory,skinId);
         var popupLayoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopupLayoutHangarUnits");
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopXL");
         var content:ESprite = mViewFactory.getESprite(skinId);
         var area:ELayoutArea = layoutFactory.getArea("bg");
         var bkg:ESprite = mViewFactory.getEImage("pop_xl_no_buttons",mSkinSku,false,area);
         setLayoutArea(area,true);
         setBackground(bkg);
         eAddChild(bkg);
         var title:ETextField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_title"),"text_title_0");
         setTitle(title);
         setTitleText(DCTextMng.getText(163));
         bkg.eAddChild(getTitle());
         this.mTotalCapacityBar = new IconBar();
         this.mTotalCapacityBar.setup("IconBarM",0,10,"color_capacity","icon_three_hangars");
         this.mTotalCapacityBar.updateText("...");
         this.mTotalCapacityBar.updateTopText(DCTextMng.getText(702));
         this.mTotalCapacityBar.logicUpdate(0);
         this.mTotalCapacityBar.layoutApplyTransformations(popupLayoutFactory.getArea("area_bar"));
         content.eAddChild(this.mTotalCapacityBar);
         setContent("area_bar",this.mTotalCapacityBar);
         (textField = mViewFactory.getETextField(mSkinSku,popupLayoutFactory.getTextArea("tezt_title"))).setText(DCTextMng.getText(672));
         textField.applySkinProp(mSkinSku,"text_title_1");
         content.eAddChild(textField);
         setContent("tezt_title",textField);
         var textWithIcon:ESpriteContainer;
         (textWithIcon = mViewFactory.getContentIconWithTextHorizontal("IconTextS","icon_defense_damage",DCTextMng.convertTimeToStringColon(0),mSkinSku)).layoutApplyTransformations(popupLayoutFactory.getArea("icon_text"));
         content.eAddChild(textWithIcon);
         setContent("icon_text",textWithIcon);
         this.mPowerupCountdownTF = textWithIcon.getContent("text") as ETextField;
         this.mPowerupCountdownTF.applySkinProp(mSkinSku,"text_title_1");
         var powerupButton:EButton;
         (powerupButton = mViewFactory.getButton("btn_accept",mSkinSku,"M",DCTextMng.getText(671))).layoutApplyTransformations(popupLayoutFactory.getArea("icon_text"));
         powerupButton.eAddEventListener("click",this.onGoToShop);
         content.eAddChild(powerupButton);
         setContent("button_shop",powerupButton);
         area = popupLayoutFactory.getArea("area_units");
         this.mInventoryRowWidth = area.width;
         this.mInventoryRowHeight = area.height / 3;
         this.mScrollArea = new EScrollArea();
         this.mScrollArea.build(area,Math.ceil(this.getUnits().length / 5),ESpriteContainer,this.fillData);
         content.eAddChild(this.mScrollArea);
         setContent("area_units",this.mScrollArea);
         bkg.eAddChild(content);
         content.layoutApplyTransformations(layoutFactory.getArea("body"));
         setContent("CONTENT",content);
         var closeButton:EButton = mViewFactory.getButtonClose(mSkinSku,layoutFactory.getArea("btn_close"));
         bkg.eAddChild(closeButton);
         setCloseButton(closeButton);
         setCloseButtonVisible(true);
         closeButton.eAddEventListener("click",notifyPopupMngClose);
         MessageCenter.getInstance().registerObject(this);
         this.buildScrollBar();
         this.reloadView();
      }
      
      private function reloadView() : void
      {
         this.updateCapacityLabels();
         this.mScrollArea.reloadView();
      }
      
      private function fillData(spriteReference:ESpriteContainer, rowOffset:int, rebuild:Boolean) : void
      {
         var itemContainer:EUnitItemView = null;
         var i:int = 0;
         var xOffset:int = 0;
         if(rebuild)
         {
            while(spriteReference.numChildren)
            {
               (itemContainer = spriteReference.getChildAt(0) as EUnitItemView).destroy();
            }
            for(i = 0; i < 5; )
            {
               (itemContainer = new EUnitItemView()).build();
               itemContainer.changeSkinPropBkg("box_with_border",null);
               itemContainer.changeSkinPropCloseBtn(null,"btn_close_blue");
               spriteReference.eAddChild(itemContainer);
               spriteReference.setContent("itemContainer_" + i,itemContainer);
               i++;
            }
         }
         var items:Vector.<Array> = this.getUnits();
         i = rowOffset * 5;
         while(i < (rowOffset + 1) * 5 && i < items.length)
         {
            (itemContainer = spriteReference.getChildAt(i % 5) as EUnitItemView).visible = true;
            itemContainer.fillData(items[i]);
            xOffset = (this.mInventoryRowWidth - 5 * itemContainer.width) / (5 + 1);
            itemContainer.logicLeft = i % 5 * (itemContainer.width + xOffset) + xOffset;
            itemContainer.logicTop = (this.mInventoryRowHeight - itemContainer.height) / 2;
            i++;
         }
         while(i < (rowOffset + 1) * 5)
         {
            (itemContainer = spriteReference.getChildAt(i % 5) as EUnitItemView).visible = false;
            i++;
         }
      }
      
      private function buildScrollBar() : void
      {
         this.mTopArrow = mViewFactory.getEImage("scrollbar_arrow",mSkinSku,false);
         this.mBottomArrow = mViewFactory.getEImage("scrollbar_arrow",mSkinSku,false);
         this.mBarBg = mViewFactory.getEImage("scrollbar",mSkinSku,false);
         this.mBar = mViewFactory.getEImage("btn_scrollbar",mSkinSku,false);
         this.mBottomArrow.scaleY *= -1;
         var scrollBar:EScrollBar = new EScrollBar(0,this.mTopArrow,this.mBottomArrow,this.mBarBg,this.mBar,this.mScrollArea);
      }
      
      public function updateCapacityLabels() : void
      {
         this.updateCapacityLabel(this.mTotalCapacityBar,InstanceMng.getHangarControllerMng().getHangarController().getTotalCapacityOccupied(),InstanceMng.getHangarControllerMng().getHangarController().getTotalMaxCapacity());
      }
      
      private function updateCapacityLabelChunks(bar:IconBar, available:Vector.<int>) : void
      {
         bar.updateText(available.join(", "));
         bar.logicUpdate(0);
      }
      
      private function updateCapacityLabel(bar:IconBar, current:int, max:int) : void
      {
         bar.setBarMaxValue(max);
         bar.setBarCurrentValue(current);
         var currentCapacityStr:String = "" + current;
         var maxCapacityStr:String = "" + max;
         bar.updateText(currentCapacityStr + "/" + maxCapacityStr);
         bar.logicUpdate(0);
      }
      
      override public function logicUpdate(dt:int) : void
      {
         super.logicUpdate(dt);
         if(this.getPowerupRemainingTime() > 0)
         {
            getContent("button_shop").visible = false;
            getContent("icon_text").visible = true;
            getContent("tezt_title").visible = true;
            this.mPowerupCountdownTF.setText(DCTextMng.convertTimeToStringColon(this.getPowerupRemainingTime()));
         }
         else
         {
            getContent("button_shop").visible = true;
            getContent("icon_text").visible = false;
            getContent("tezt_title").visible = false;
         }
      }
      
      private function getPowerupRemainingTime() : Number
      {
         return 0;
      }
      
      public function onGoToShop(evt:EEvent) : void
      {
         super.notifyPopupMngClose(evt);
         InstanceMng.getApplication().shopControllerOpenPopup("premium","units");
      }
      
      public function getName() : String
      {
         return "PopupHangar";
      }
      
      public function getTaskList() : Vector.<String>
      {
         return new <String>["reloadHangar","hangarKillUnit"];
      }
      
      public function onMessage(task:String, params:Dictionary) : void
      {
         var hangar:Hangar = null;
         switch(task)
         {
            case "hangarKillUnit":
               hangar = InstanceMng.getHangarControllerMng().getHangarController().getHangarContainingSku(params["sku"]);
               if(hangar != null)
               {
                  hangar.removeUnit(params["sku"]);
                  InstanceMng.getUserDataMng().updateShips_killUnitFromHangar(params["sku"],parseInt(hangar.getSid()),null);
                  this.reloadView();
               }
               break;
            case "reloadHangar":
               this.reloadView();
         }
      }
   }
}
