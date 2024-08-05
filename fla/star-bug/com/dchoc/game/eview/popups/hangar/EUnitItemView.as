package com.dchoc.game.eview.popups.hangar
{
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.game.model.items.ItemsDef;
   import com.dchoc.game.model.world.ship.ShipDef;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import flash.utils.Dictionary;
   
   public class EUnitItemView extends ESpriteContainer
   {
      
      protected static const AREA_ITEMS:String = "container_box";
      
      protected static const IMAGE:String = "img";
      
      protected static const ICON_INFO:String = "icon";
      
      protected static const ICON_CLOSE:String = "btn_close";
      
      protected static const TEXT_NAME:String = "text";
       
      
      protected var mLayoutName:String;
      
      protected var mLayout:ELayoutAreaFactory;
      
      protected var mSkinSku:String;
      
      protected var mViewFactory:ViewFactory;
      
      protected var mBaseItemSku:String;
      
      protected var mItemsDef:ItemsDef;
      
      protected var mItemDef:ShipDef;
      
      protected var mTotalAmount:int;
      
      protected var mBoxProp:String;
      
      protected var mCloseBtnProp:String;
      
      public function EUnitItemView()
      {
         super();
         this.mLayoutName = "BoxUnits";
         this.mBoxProp = "units_box";
         this.mCloseBtnProp = null;
      }
      
      public function build(useButtons:Boolean = true, useMouseOver:Boolean = true) : void
      {
         this.mViewFactory = InstanceMng.getViewFactory();
         this.mSkinSku = InstanceMng.getSkinsMng().getCurrentSkinSku();
         this.mLayout = this.mViewFactory.getLayoutAreaFactory(this.mLayoutName);
         var image:EImage = this.mViewFactory.getEImage(this.mBoxProp,this.mSkinSku,true,this.mLayout.getArea("container_box"));
         this.eAddChild(image);
         this.setContent("container_box",image);
         image = this.mViewFactory.getEImage(null,this.mSkinSku,true,this.mLayout.getArea("img"));
         this.eAddChild(image);
         this.setContent("img",image);
         this.setupText();
         if(useMouseOver)
         {
            this.setupMouseEvents();
         }
         if(useButtons)
         {
            this.setupButtons();
         }
      }
      
      protected function setupText() : void
      {
         var name:ETextField = this.mViewFactory.getETextField(this.mSkinSku,this.mLayout.getTextArea("text"));
         name.setText("...");
         name.applySkinProp(this.mSkinSku,"text_title_3");
         this.eAddChild(name);
         this.setContent("text",name);
      }
      
      protected function setupMouseEvents() : void
      {
         getContent("img").eAddEventListener("rollOver",this.onMouseOver);
         getContent("img").eAddEventListener("rollOut",this.onMouseOut);
      }
      
      public function setupMouseEventsForUnitDescription() : void
      {
         getContent("img").eAddEventListener("rollOver",this.onMouseOverForUnitDescription);
         getContent("img").eAddEventListener("rollOut",this.onMouseOut);
      }
      
      protected function setupButtons() : void
      {
         var closeButton:EButton = this.mViewFactory.getButtonClose(this.mSkinSku,this.mLayout.getArea("btn_close"));
         closeButton.applySkinProp(this.mSkinSku,this.mCloseBtnProp);
         closeButton.eAddEventListener("click",this.onRemoveThis);
         this.eAddChild(closeButton);
         this.setContent("btn_close",closeButton);
      }
      
      public function changeSkinPropBkg(texture:String, prop:String) : void
      {
         var bkg:EImage = null;
         if(texture)
         {
            bkg = this.getContent("container_box") as EImage;
            this.mViewFactory.setTextureToImage(texture,this.mSkinSku,bkg);
         }
         if(prop)
         {
            this.getContent("container_box").unapplySkinProp(this.mSkinSku,this.mBoxProp);
            this.mBoxProp = prop;
            this.getContent("container_box").applySkinProp(this.mSkinSku,this.mBoxProp);
         }
      }
      
      public function changeSkinPropCloseBtn(texture:String, prop:String) : void
      {
         var btn:EImage = null;
         if(texture)
         {
            btn = (this.getContent("btn_close") as EButton).getBackground();
            this.mViewFactory.setTextureToImage(texture,this.mSkinSku,btn);
         }
         if(prop)
         {
            this.getContent("btn_close").unapplySkinProp(this.mSkinSku,this.mCloseBtnProp);
            this.mCloseBtnProp = prop;
            this.getContent("btn_close").applySkinProp(this.mSkinSku,this.mCloseBtnProp);
         }
      }
      
      public function setCloseButtonVisible(value:Boolean) : void
      {
         getContent("btn_close").visible = value;
      }
      
      public function fillData(object:Array) : void
      {
         this.fillDataFromParams(object[0],object[2],object[3]);
      }
      
      public function fillDataFromParams(sku:String, def:ShipDef, amount:int) : void
      {
         this.mBaseItemSku = sku;
         this.mItemDef = def;
         this.mTotalAmount = amount;
         this.setText("x" + this.mTotalAmount);
         this.mViewFactory.setTextureToImage(this.mItemDef.getIcon(),this.mSkinSku,getContent("img") as EImage);
      }
      
      public function fillDataFromItemParams(sku:String, def:ItemsDef, amount:int) : void
      {
         this.mBaseItemSku = sku;
         this.mItemsDef = def;
         this.mTotalAmount = amount;
         this.setText("x" + this.mTotalAmount);
         this.mViewFactory.setTextureToImage(this.mItemsDef.getIcon(true),this.mSkinSku,getContent("img") as EImage);
      }
      
      public function setText(value:String) : void
      {
         if(getContentAsETextField("text"))
         {
            getContentAsETextField("text").setText(value);
         }
      }
      
      public function getBaseItemSku() : String
      {
         return this.mBaseItemSku;
      }
      
      protected function onRemoveThis(evt:EEvent) : void
      {
         var unitSku:String = this.mItemDef.mSku;
         var params:Dictionary = new Dictionary();
         params["sku"] = unitSku;
         MessageCenter.getInstance().sendMessage("hangarKillUnit",params);
      }
      
      protected function onMouseOver(evt:EEvent) : void
      {
         this.onMouseOverForSizeDescription(evt);
      }
      
      private function onMouseOverForSizeDescription(evt:EEvent) : void
      {
         var tooltipText:String = null;
         if(this.mItemDef)
         {
            tooltipText = this.mItemDef.getNameToDisplay() + "\n" + DCTextMng.getText(553) + ": " + this.mItemDef.getSize();
            ETooltipMng.getInstance().createTooltipInfoFromText(tooltipText,getContent("img"));
         }
         if(this.mItemsDef)
         {
            tooltipText = this.mItemsDef.getNameToDisplay();
            ETooltipMng.getInstance().createTooltipInfoFromText(tooltipText,getContent("img"));
         }
      }
      
      private function onMouseOverForUnitDescription(evt:EEvent) : void
      {
         var tooltipText:String = null;
         if(this.mItemDef)
         {
            tooltipText = this.mItemDef.getNameToDisplay() + "\n" + DCTextMng.getText(553) + ": " + this.mItemDef.getSize();
            ETooltipMng.getInstance().createTooltipInfoFromTexts(this.mItemDef.getNameToDisplay(),this.mItemDef.getDescToDisplay() + "\n\n" + this.mItemDef.getInfoToDisplay(),getContent("img"));
         }
         if(this.mItemsDef)
         {
            tooltipText = this.mItemsDef.getNameToDisplay();
            ETooltipMng.getInstance().createTooltipInfoFromTexts(this.mItemsDef.getNameToDisplay(),this.mItemsDef.getDescToDisplay() + "\n\n" + this.mItemsDef.getInfoToDisplay(),getContent("img"));
         }
      }
      
      protected function onMouseOut(evt:EEvent) : void
      {
         ETooltipMng.getInstance().removeCurrentTooltip();
      }
   }
}
