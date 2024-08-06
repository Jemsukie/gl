package com.dchoc.game.eview.popups.buffer
{
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.DCUtils;
   import esparragon.core.Esparragon;
   import esparragon.display.EImage;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETexture;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import flash.display.BitmapData;
   
   public class EBufferTemplateView extends ESpriteContainer
   {
      
      private static const THUMBNAIL_SKU:String = "thumbnail";
      
      private static const SAVE_SKU:String = "save";
      
      private static const LOAD_SKU:String = "load";
      
      private static const DELETE_SKU:String = "delete";
      
      private static const EXPORT_SKU:String = "export";
      
      private static const IMPORT_SKU:String = "import";
      
      private static const PADDING:int = 10;
      
      private static const BKG_WIDTH:int = 600;
      
      private static const BKG_HEIGHT:int = 200;
      
      private static const THUMBNAIL_WIDTH:int = 400;
      
      private static const THUMBNAIL_HEIGHT:int = 190;
       
      
      protected var mViewFactory:ViewFactory;
      
      private var mTemplateSlotId:int;
      
      private var mThumbnailBmp:BitmapData = null;
      
      private var mPreviewEspc:ESpriteContainer = null;
      
      private var mItemsData:Object = null;
      
      private var mTemplateUUID:String = null;
      
      public function EBufferTemplateView()
      {
         super();
      }
      
      public function build() : void
      {
         var elementLayoutArea:ELayoutArea;
         var buttonsLayoutArea:ELayoutArea;
         var image:EImage;
         var btn:EButton;
         var buttons:Array;
         this.mViewFactory = InstanceMng.getViewFactory();
         buttons = [];
         elementLayoutArea = ELayoutAreaFactory.createLayoutArea(600,200);
         elementLayoutArea.x = 0;
         elementLayoutArea.y = 0;
         image = this.mViewFactory.getEImage("generic_box",null,false,elementLayoutArea);
         eAddChild(image);
         setContent("bkg",image);
         elementLayoutArea = ELayoutAreaFactory.createLayoutArea(400,190);
         elementLayoutArea.x = 10 / 2;
         elementLayoutArea.y = 10 / 2;
         image = this.mViewFactory.getEImage("illus_template_missing",null,false,elementLayoutArea);
         eAddChild(image);
         setContent("thumbnail",image);
         image.onSetTextureLoaded = function():void
         {
            rescaleThumbnail();
         };
         buttonsLayoutArea = ELayoutAreaFactory.createLayoutArea(195,190 - 10);
         buttonsLayoutArea.x = 400 + 10 / 2;
         buttonsLayoutArea.y = 10;
         btn = this.mViewFactory.getButtonSocial(null,null,DCTextMng.getText(3981));
         btn.name = "save";
         btn.eAddEventListener("click",this.onSaveClicked);
         eAddChild(btn);
         setContent(btn.name,btn);
         buttons.push(btn);
         btn = this.mViewFactory.getButtonSocial(null,null,DCTextMng.getText(3982));
         btn.name = "load";
         btn.eAddEventListener("click",this.onLoadClicked);
         eAddChild(btn);
         setContent(btn.name,btn);
         buttons.push(btn);
         btn = this.mViewFactory.getButtonSocial(null,null,DCTextMng.getText(3991));
         btn.name = "export";
         btn.eAddEventListener("click",this.onExportClicked);
         eAddChild(btn);
         setContent(btn.name,btn);
         buttons.push(btn);
         btn = this.mViewFactory.getButtonSocial(null,null,DCTextMng.getText(4068));
         btn.name = "import";
         btn.eAddEventListener("click",this.onImportClicked);
         eAddChild(btn);
         setContent(btn.name,btn);
         buttons.push(btn);
         this.mViewFactory.distributeSpritesInArea(buttonsLayoutArea,buttons,1,1,2,1,true);
      }
      
      public function setData(templateId:int, itemsData:Object = null, templateUUID:String = null, thumbnailBmp:BitmapData = null) : void
      {
         this.mTemplateSlotId = templateId;
         if(itemsData != null)
         {
            this.mItemsData = itemsData;
         }
         if(templateUUID != null)
         {
            this.mTemplateUUID = templateUUID;
         }
         if(thumbnailBmp != null)
         {
            this.mThumbnailBmp = thumbnailBmp;
         }
         this.updateTemplateView();
      }
      
      public function getSlotId() : int
      {
         return this.mTemplateSlotId;
      }
      
      private function rescaleThumbnail() : void
      {
      }
      
      private function onSaveClicked(evt:EEvent) : void
      {
         this.mItemsData = InstanceMng.getBuildingsBufferController().getItemsDataForTemplate();
         InstanceMng.getUserDataMng().updateTemplates_saveTemplate(this.mTemplateSlotId,this.mItemsData,"");
         this.updateTemplateView();
         MessageCenter.getInstance().sendMessage("lockTemplatesPopup");
      }
      
      private function onLoadClicked(evt:EEvent) : void
      {
         var templateResponse:int = InstanceMng.getBuildingsBufferController().tryToApplyTemplate(this.mItemsData);
         if(templateResponse == 0)
         {
            InstanceMng.getUIFacade().closePopupById("PopupBufferTemplates");
         }
         else
         {
            InstanceMng.getNotificationsMng().guiOpenTemplateError(templateResponse);
         }
      }
      
      private function onDeleteClicked(evt:EEvent) : void
      {
         InstanceMng.getNotificationsMng().guiOpenConfirmPopup("PopupConfirmTemplateDelete",DCTextMng.getText(3063),DCTextMng.getText(3985),"orange_normal",DCTextMng.getText(1),null,function():void
         {
            deleteDo();
         });
      }
      
      private function onExportClicked(evt:EEvent) : void
      {
         var popup:EPopupTemplateExport = new EPopupTemplateExport();
         popup.setUUID(this.mTemplateUUID);
         popup.setup("PopupBufferTemplatesImport",this.mViewFactory,null);
         popup.setIsStackable(true);
         InstanceMng.getUIFacade().enqueuePopup(popup);
      }
      
      private function onImportClicked(evt:EEvent) : void
      {
         var popup:EPopupTemplateImport = new EPopupTemplateImport();
         popup.setSlotId(this.mTemplateSlotId);
         popup.setup("PopupBufferTemplatesImport",this.mViewFactory,null);
         popup.setIsStackable(true);
         InstanceMng.getUIFacade().enqueuePopup(popup);
      }
      
      private function deleteDo() : void
      {
         InstanceMng.getUserDataMng().updateTemplates_deleteTemplate(this.mTemplateSlotId);
         this.mItemsData = null;
         this.mThumbnailBmp = null;
         this.mTemplateUUID = null;
         this.updateTemplateView();
      }
      
      public function updateTemplateView() : void
      {
         var texture:ETexture = null;
         var espcLayout:ELayoutArea = null;
         var HQDef:WorldItemDef = null;
         var imgLayout:ELayoutArea = null;
         var itemsEspc:ESpriteContainer = null;
         var itemsLayout:ELayoutArea = null;
         var img:EImage = getContentAsEImage("thumbnail");
         if(this.mThumbnailBmp != null)
         {
            texture = Esparragon.getDisplayFactory().createTextureFromBitmapData(this.mThumbnailBmp);
            img.setTexture(texture);
         }
         else if(DCUtils.isObjectEmpty(this.mItemsData))
         {
            this.mViewFactory.setTextureToImage("illus_template_missing",null,img);
         }
         else
         {
            espcLayout = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(img.getLayoutArea());
            this.eRemoveChild(img);
            if(this.mPreviewEspc != null)
            {
               this.eRemoveChild(this.mPreviewEspc);
               this.mPreviewEspc.destroy();
            }
            this.mPreviewEspc = this.mViewFactory.getESpriteContainer();
            this.mPreviewEspc.setLayoutArea(espcLayout,true);
            HQDef = InstanceMng.getWorldItemDefMng().getDefBySkuAndUpgradeId("wonders_headquarters",this.getHQUpgradeId());
            if(HQDef == null)
            {
               return;
            }
            (imgLayout = InstanceMng.getViewFactory().getLayoutAreaFactory("BoxUnits").getArea("img")).isSetPositionEnabled = false;
            img = this.mViewFactory.getEImage(HQDef.getAssetIdShop(),null,false,imgLayout);
            itemsEspc = this.mViewFactory.getESpriteContainer();
            (itemsLayout = ELayoutAreaFactory.createLayoutArea(400 * 0.8,190)).isSetPositionEnabled = false;
            itemsEspc.setLayoutArea(itemsLayout,true);
            this.buildItemsPreviewEspc(itemsEspc);
            this.mPreviewEspc.eAddChild(img);
            this.mPreviewEspc.eAddChild(itemsEspc);
            this.mViewFactory.distributeSpritesInArea(espcLayout,[img,itemsEspc],1,1,-1,1,true);
            this.mPreviewEspc.name = "preview";
            eAddChild(this.mPreviewEspc);
            setContent(this.mPreviewEspc.name,this.mPreviewEspc);
         }
         rescaleThumbnail();
         this.updateButtons();
      }
      
      private function buildItemsPreviewEspc(spriteReference:ESpriteContainer) : void
      {
         var numSkus:int;
         var assetPair:Array;
         var itemEspc:ESpriteContainer;
         var itemContainers:Array = [];
         var itemsSummary:Vector.<Array> = this.getItemsPreviewData();
         itemsSummary.sort(function(a:Array, b:Array):Number
         {
            return b[1] - a[1];
         });
         numSkus = 0;
         for each(assetPair in itemsSummary)
         {
            if(numSkus == 24)
            {
               break;
            }
            itemEspc = this.mViewFactory.getContainerItem(assetPair[0],assetPair[1]);
            spriteReference.eAddChild(itemEspc);
            itemContainers.push(itemEspc);
            numSkus++;
         }
         this.mViewFactory.distributeSpritesInArea(spriteReference.getLayoutArea(),itemContainers,1,1,6,-1);
      }
      
      private function getItemsPreviewData() : Vector.<Array>
      {
         var wioDef:WorldItemDef = null;
         var assetId:String = null;
         var itemsArray:Array = null;
         var amount:int = 0;
         var returnValue:Vector.<Array> = new Vector.<Array>(0);
         var HQUpgradeId:int = this.getHQUpgradeId();
         for(var sku in this.mItemsData)
         {
            if(sku != "wonders_headquarters")
            {
               wioDef = InstanceMng.getWorldItemDefMng().getMaxDefUnlockedAtHqUpgradeId(sku,HQUpgradeId);
               if(wioDef != null)
               {
                  assetId = wioDef.getAssetIdShop();
                  if(!((itemsArray = this.mItemsData[sku]) == null || itemsArray.length == 0))
                  {
                     amount = int(this.mItemsData[sku].length);
                     returnValue.push(["" + assetId,amount]);
                  }
               }
            }
         }
         return returnValue;
      }
      
      private function getHQUpgradeId() : int
      {
         for(var sku in this.mItemsData)
         {
            if(sku == "wonders_headquarters")
            {
               return parseInt(this.mItemsData[sku][0]["l"]);
            }
         }
         return 0;
      }
      
      public function setButtonsEnabled(value:Boolean) : void
      {
         var btn:EButton = null;
         for each(var btnSku in ["save","load","export","import"])
         {
            btn = getContentAsEButton(btnSku);
            if(btn)
            {
               btn.setIsEnabled(value);
            }
         }
      }
      
      public function updateButtons() : void
      {
         var btn:EButton = null;
         var hasData:* = !DCUtils.isObjectEmpty(this.mItemsData);
         btn = getContentAsEButton("save");
         btn.setIsEnabled(InstanceMng.getBuildingsBufferController().isAnythingPlaced());
         btn = getContentAsEButton("load");
         btn.setIsEnabled(hasData);
         btn = getContentAsEButton("export");
         btn.setIsEnabled(this.mTemplateUUID != null && this.mTemplateUUID != "");
         btn = getContentAsEButton("import");
         btn.setIsEnabled(true);
      }
   }
}
