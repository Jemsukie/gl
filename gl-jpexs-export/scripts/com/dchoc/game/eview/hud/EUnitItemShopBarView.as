package com.dchoc.game.eview.hud
{
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.popups.hangar.EUnitItemView;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipInfo;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.widgets.EButton;
   import flash.utils.Dictionary;
   
   public class EUnitItemShopBarView extends EUnitItemView
   {
      
      protected static const AREA_BUTTON:String = "btn";
       
      
      protected var mWorldItemDef:WorldItemDef;
      
      public function EUnitItemShopBarView()
      {
         super();
         mLayoutName = "BoxUnitsButtons";
         mBoxProp = "units_box";
         mCloseBtnProp = null;
      }
      
      override protected function setupButtons() : void
      {
         var btn:EButton = mViewFactory.getButtonByTextWidth("......",mLayout.getArea("btn").width,"btn_hud","icon_coin",null,null);
         btn.name = "btn";
         btn.setLayoutArea(mLayout.getArea("btn"),true);
         btn.eAddEventListener("click",this.onButtonClicked);
         setContent("btn",btn);
         eAddChild(btn);
         btn = mViewFactory.getButtonImage("btn_info",null,mLayout.getArea("icon"));
         btn.name = "icon";
         btn.eAddEventListener("click",this.onInfoClicked);
         setContent("icon",btn);
         eAddChild(btn);
      }
      
      override public function fillData(object:Array) : void
      {
         this.mWorldItemDef = object[0] as WorldItemDef;
         var sku:String = this.mWorldItemDef.getSku();
         var currentAmount:int = InstanceMng.getWorld().itemsAmountGet(sku);
         var maxAmount:int = InstanceMng.getRuleMng().wioMaxNumPerCurrentHQUpgradeId(sku);
         var tf:ETextField = getContentAsETextField("text");
         tf.setText(currentAmount + "/" + maxAmount);
         tf.setLayoutArea(tf.getLayoutArea(),true);
         tf.unapplySkinProp(null,"text_light_negative");
         tf.unapplySkinProp(null,"text_title_3");
         if(currentAmount >= maxAmount)
         {
            tf.applySkinProp(null,"text_light_negative");
         }
         else
         {
            tf.applySkinProp(null,"text_title_3");
         }
         getContent("icon").visible = this.mWorldItemDef.isATurret();
         var image:EImage = getContentAsESpriteContainer("btn").getContentAsEImage("icon");
         if(InstanceMng.getWorldItemDefMng().checkIsLocked(this.mWorldItemDef))
         {
            getContentAsEButton("btn").setText(DCTextMng.getText(164));
            image.visible = false;
         }
         else if(this.mWorldItemDef.getConstructionCoins() > 0)
         {
            mViewFactory.setTextureToImage("icon_coin",null,image);
            getContentAsEButton("btn").setText(this.mWorldItemDef.getConstructionCoins().toString());
            image.visible = true;
         }
         else
         {
            mViewFactory.setTextureToImage("icon_chip",null,image);
            getContentAsEButton("btn").setText(this.mWorldItemDef.getConstructionCash().toString());
            image.visible = true;
         }
         image = getContentAsEImage("img");
         mViewFactory.setTextureToImage(this.mWorldItemDef.getAssetIdShop(),null,image);
         if(maxAmount == 0)
         {
            image.applySkinProp(null,"disabled");
         }
         else
         {
            image.unapplySkinProp(null,"disabled");
         }
      }
      
      override protected function onMouseOver(evt:EEvent) : void
      {
         var tooltipInfo:ETooltipInfo = null;
         var container:ESprite = getContent("img");
         tooltipInfo = ETooltipMng.getInstance().createTooltipInfoFromWorldItemDef(this.mWorldItemDef,container,null,false,true);
      }
      
      private function onButtonClicked(evt:EEvent) : void
      {
         var params:Dictionary = new Dictionary();
         params["sku"] = this.mWorldItemDef.getSku();
         MessageCenter.getInstance().sendMessage("hudShopBarButtonClicked",params);
      }
      
      private function onInfoClicked(evt:EEvent) : void
      {
         var params:Dictionary = new Dictionary();
         params["sku"] = this.mWorldItemDef.getSku();
         MessageCenter.getInstance().sendMessage("hudShopBarInfoClicked",params);
      }
      
      override public function set mouseEnabled(enabled:Boolean) : void
      {
         super.mouseEnabled = enabled;
         super.mouseChildren = enabled;
      }
   }
}
