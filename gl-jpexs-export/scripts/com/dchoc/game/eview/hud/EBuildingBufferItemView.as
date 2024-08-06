package com.dchoc.game.eview.hud
{
   import com.dchoc.game.controller.shop.BuildingsBufferController;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.popups.hangar.EUnitItemView;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   
   public class EBuildingBufferItemView extends EUnitItemView
   {
      
      protected static const AREA_BUTTON:String = "btn";
       
      
      protected var mWorldItemDef:WorldItemDef;
      
      private var mItem:WorldItemObject;
      
      private var amount:int;
      
      public function EBuildingBufferItemView()
      {
         super();
         mLayoutName = "BoxUnitsButtons";
         mBoxProp = "units_box";
         mCloseBtnProp = null;
      }
      
      override protected function setupButtons() : void
      {
      }
      
      override public function fillData(object:Array) : void
      {
         this.mWorldItemDef = object[0] as WorldItemDef;
         var sku:String = this.mWorldItemDef.getSku();
         var currentAmount:int = InstanceMng.getWorld().itemsAmountGet(sku);
         var maxAmount:int = InstanceMng.getRuleMng().wioMaxNumPerCurrentHQUpgradeId(sku);
         var tf:ETextField = getContentAsETextField("text");
         var level:int = this.mWorldItemDef.getUpgradeId() + 1;
         var text:String = this.amount.toString() + "x\n ";
         if(InstanceMng.getWorldItemDefMng().getMaxUpgradeLevel(this.mWorldItemDef.mSku) > 1)
         {
            text = text + DCTextMng.getText(444) + " " + level.toString();
         }
         tf.setText(text);
         tf.logicY += 25;
         tf.setFontSize(25);
         this.eAddEventListener("click",this.onButtonClicked);
         mViewFactory.setTextureToImage(this.mWorldItemDef.getAssetIdShop(),null,getContentAsEImage("img"));
      }
      
      override protected function onMouseOver(evt:EEvent) : void
      {
         ETooltipMng.getInstance().createTooltipInfoFromWorldItemDef(this.mWorldItemDef,getContent("img"),null,false,true);
      }
      
      private function onButtonClicked(evt:EEvent) : void
      {
         var bbController:BuildingsBufferController = InstanceMng.getBuildingsBufferController();
         if(bbController.getBuildingAmount(this.mItem.mDef.getSku()) == 0)
         {
            this.destroy();
            InstanceMng.getUIFacade().getBuildingsBufferBar().destroyView(this.mItem.mDef.getSku());
         }
         if(InstanceMng.getToolsMng().getCurrentTool().isItemAttached())
         {
            bbController.tryToAddItem();
         }
         bbController.setItem(this.mItem);
      }
      
      override public function set mouseEnabled(enabled:Boolean) : void
      {
         super.mouseEnabled = enabled;
         super.mouseChildren = enabled;
      }
      
      public function setMItem(item:WorldItemObject) : void
      {
         this.mItem = item;
      }
      
      public function setAmount(i:int) : void
      {
         this.amount = i;
      }
   }
}
