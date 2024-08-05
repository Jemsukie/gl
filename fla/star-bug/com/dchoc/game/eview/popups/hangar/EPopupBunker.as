package com.dchoc.game.eview.popups.hangar
{
   import com.dchoc.game.controller.gui.GUIControllerPlanet;
   import com.dchoc.game.controller.hangar.Bunker;
   import com.dchoc.game.core.flow.messaging.INotifyReceiver;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.eview.widgets.paginator.PaginatorViewSimple;
   import com.dchoc.game.eview.widgets.smallStructures.IconBarWithFillPreview;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.world.ship.ShipDef;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import esparragon.widgets.paginator.EPaginatorComponent;
   import esparragon.widgets.paginator.EPaginatorController;
   import flash.utils.Dictionary;
   
   public class EPopupBunker extends EGamePopup implements EPaginatorController, INotifyReceiver
   {
      
      private static const CONTAINER_UNITS_HANGAR:String = "container_units_hangar";
      
      private static const CONTAINER_UNITS_BUNKER:String = "container_units_bunker";
      
      private static const CONTAINER_WARNING_DISPLAY:String = "stripe_l";
      
      private static const AREA_PRICE:String = "area_price";
      
      private static const AREA_PRICE_BKG:String = "container_btn_minerals";
      
      private static const AREA_TRANSFER_BUTTON:String = "base";
      
      private static const AREA_HELP_AMOUNT:String = "container_item";
      
      private static const UNITS_PER_PAGE:int = 5;
       
      
      protected var mCapacityBar:IconBarWithFillPreview;
      
      protected var mBunkerRef:Bunker;
      
      protected var mCostIconTF:ESpriteContainer;
      
      protected var mWarningIconLabel:ESpriteContainer;
      
      protected var mBunkerBoxes:Vector.<EUnitItemView>;
      
      protected var mHangarBoxes:Vector.<EUnitItemTransferView>;
      
      protected var mBunkerPaginatorComponent:EPaginatorComponent;
      
      protected var mHangarPaginatorComponent:EPaginatorComponent;
      
      protected var mBunkerPaginatorView:PaginatorViewSimple;
      
      protected var mHangarPaginatorView:PaginatorViewSimple;
      
      protected var mHangarAddedUnits:Dictionary;
      
      protected var mTransferMineralsAmount:int;
      
      protected var mTransferDefs:Vector.<ShipDef>;
      
      private var mHelpAmountSprite:ESpriteContainer;
      
      private var mTransferButton:EButton;
      
      private var mIsVisitor:Boolean;
      
      public function EPopupBunker(bunker:Bunker, isVisitor:Boolean)
      {
         super();
         this.mBunkerRef = bunker;
         this.mIsVisitor = isVisitor;
         this.mHangarAddedUnits = new Dictionary();
         this.mTransferDefs = new Vector.<ShipDef>(0);
         this.mBunkerBoxes = new Vector.<EUnitItemView>(5);
         this.mHangarBoxes = new Vector.<EUnitItemTransferView>(5);
      }
      
      public function build(popupId:String, viewFactory:ViewFactory, skinId:String) : void
      {
         var image:EImage = null;
         var tf:ETextField = null;
         super.setup(popupId,viewFactory,skinId);
         var popupLayoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopupLayoutBunker");
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopXL");
         var content:ESprite = mViewFactory.getESprite(skinId);
         var title:ETextField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_title"),"text_title_0");
         var area:ELayoutArea = layoutFactory.getArea("bg");
         var bkg:ESprite = mViewFactory.getEImage("pop_xl_no_buttons",mSkinSku,false,area);
         var titleText:String = DCTextMng.getText(1023);
         var bunkerIcon:String = "bunker";
         var warningText:String = DCTextMng.getText(266);
         setLayoutArea(area,true);
         setBackground(bkg);
         eAddChild(bkg);
         setTitle(title);
         if(this.mIsVisitor)
         {
            titleText = DCTextMng.getText(1026);
            bunkerIcon = "bunker_002_ready";
            if(InstanceMng.getVisitorMng().getAmountActionsLeft() < 1)
            {
               warningText = DCTextMng.getText(244);
            }
         }
         setTitleText(titleText);
         bkg.eAddChild(getTitle());
         content.eAddChild(image = mViewFactory.getEImage("bunker_box",mSkinSku,false,popupLayoutFactory.getArea("area_units_transfered")));
         setContent("area_units_transfered",image);
         content.eAddChild(image = mViewFactory.getEImage("bunker_box",mSkinSku,false,popupLayoutFactory.getArea("area_units")));
         setContent("area_units",image);
         content.eAddChild(image = mViewFactory.getEImage(bunkerIcon,mSkinSku,false,popupLayoutFactory.getArea("container_bunker")));
         setContent("container_bunker",image);
         content.eAddChild(image = mViewFactory.getEImage("hangar",mSkinSku,false,popupLayoutFactory.getArea("container_hangar")));
         setContent("container_hangar",image);
         content.eAddChild(image = mViewFactory.getEImage("icon_arrow",mSkinSku,false,popupLayoutFactory.getArea("icon_arrow_down")));
         setContent("icon_arrow_down",image);
         content.eAddChild(image = mViewFactory.getEImage("icon_arrow",mSkinSku,false,popupLayoutFactory.getArea("icon_arrow_up")));
         setContent("icon_arrow_up",image);
         this.mCapacityBar = new IconBarWithFillPreview();
         this.mCapacityBar.setup("IconBarL",this.mBunkerRef.getCapacityOccupied(),this.mBunkerRef.getMaxCapacity(),"color_capacity","icon_hangar");
         this.mCapacityBar.updateText(this.mBunkerRef.getCapacityOccupied() + "/" + this.mBunkerRef.getMaxCapacity());
         this.mCapacityBar.updateTopText(DCTextMng.getText(610));
         this.mCapacityBar.logicUpdate(0);
         this.mCapacityBar.layoutApplyTransformations(popupLayoutFactory.getArea("container_bar_l"));
         content.eAddChild(this.mCapacityBar);
         setContent("container_bar_l",this.mCapacityBar);
         var areaSprite:ESprite = mViewFactory.getEImage("generic_box",mSkinSku,false,popupLayoutFactory.getArea("container_btn_minerals"));
         content.eAddChild(areaSprite);
         setContent("container_btn_minerals",areaSprite);
         this.mCostIconTF = mViewFactory.getContentIconWithTextHorizontal("IconTextSLarge","icon_minerals",DCTextMng.convertTimeToStringColon(0),mSkinSku,"text_title_3");
         this.mCostIconTF.layoutApplyTransformations(popupLayoutFactory.getArea("area_price"));
         content.eAddChild(this.mCostIconTF);
         setContent("area_price",this.mCostIconTF);
         this.mTransferButton = mViewFactory.getButton("btn_accept",mSkinSku,"M",DCTextMng.getText(608));
         this.mTransferButton.layoutApplyTransformations(popupLayoutFactory.getArea("base"));
         this.mTransferButton.eAddEventListener("click",this.onTransfer);
         content.eAddChild(this.mTransferButton);
         setContent("base",this.mTransferButton);
         if(this.mIsVisitor)
         {
            this.mHelpAmountSprite = mViewFactory.getContainerItem("icon_help","3",mSkinSku,true);
            this.mHelpAmountSprite.layoutApplyTransformations(popupLayoutFactory.getArea("container_item"));
            content.eAddChild(this.mHelpAmountSprite);
            setContent("container_item",this.mHelpAmountSprite);
         }
         content.eAddChild(tf = mViewFactory.getETextField(mSkinSku,popupLayoutFactory.getTextArea("text_title_hangar")));
         tf.setText(DCTextMng.getText(1019));
         tf.applySkinProp(mSkinSku,"text_title_0");
         var paginatorBunker:ESpriteContainer = mViewFactory.getPaginatorAssetSimple(popupLayoutFactory.getArea("container_units_bunker"),"BtnImgM",mSkinSku);
         this.mBunkerPaginatorView = new PaginatorViewSimple(paginatorBunker,1);
         this.mBunkerPaginatorComponent = new EPaginatorComponent();
         this.mBunkerPaginatorComponent.init(this.mBunkerPaginatorView,this);
         this.mBunkerPaginatorView.setPaginatorComponent(this.mBunkerPaginatorComponent);
         content.eAddChild(paginatorBunker);
         setContent("container_units_bunker",paginatorBunker);
         var paginatorHangar:ESpriteContainer = mViewFactory.getPaginatorAssetSimple(popupLayoutFactory.getArea("container_units_hangar"),"BtnImgM",mSkinSku);
         this.mHangarPaginatorView = new PaginatorViewSimple(paginatorHangar,1);
         this.mHangarPaginatorComponent = new EPaginatorComponent();
         this.mHangarPaginatorComponent.init(this.mHangarPaginatorView,this);
         this.mHangarPaginatorView.setPaginatorComponent(this.mHangarPaginatorComponent);
         content.eAddChild(paginatorHangar);
         setContent("container_units_hangar",paginatorHangar);
         this.mWarningIconLabel = mViewFactory.getESpriteContainer();
         var warningIconLabel:EImage = mViewFactory.getEImage("box_negative",mSkinSku,false,popupLayoutFactory.getArea("stripe_l"));
         var warningIconTF:ESpriteContainer;
         (warningIconTF = mViewFactory.getContentIconWithTextHorizontal("ContainerStripeL","icon_warning",warningText,mSkinSku,"text_light_negative")).layoutApplyTransformations(popupLayoutFactory.getArea("stripe_l"));
         this.mWarningIconLabel.eAddChild(warningIconLabel);
         this.mWarningIconLabel.eAddChild(warningIconTF);
         content.eAddChild(this.mWarningIconLabel);
         this.mWarningIconLabel.setContent("label",warningIconLabel);
         this.mWarningIconLabel.setContent("tf",warningIconTF);
         setContent("stripe_l",this.mWarningIconLabel);
         var closeButton:EButton = mViewFactory.getButtonClose(mSkinSku,layoutFactory.getArea("btn_close"));
         bkg.eAddChild(closeButton);
         setCloseButton(closeButton);
         setCloseButtonVisible(true);
         closeButton.eAddEventListener("click",notifyPopupMngClose);
         bkg.eAddChild(content);
         setContent("CONTENT",content);
         content.layoutApplyTransformations(layoutFactory.getArea("body"));
         this.loadBoxes(popupLayoutFactory.getArea("container_units_bunker"),popupLayoutFactory.getArea("container_units_hangar"));
         this.reloadView();
         MessageCenter.getInstance().registerObject(this);
      }
      
      override protected function extendedDestroy() : void
      {
         var unitItemView:EUnitItemView = null;
         super.extendedDestroy();
         if(this.mBunkerBoxes != null)
         {
            while(this.mBunkerBoxes.length > 0)
            {
               unitItemView = this.mBunkerBoxes.shift();
               unitItemView.destroy();
            }
            this.mBunkerBoxes = null;
         }
         if(this.mHangarBoxes != null)
         {
            while(this.mHangarBoxes.length > 0)
            {
               unitItemView = this.mHangarBoxes.shift();
               unitItemView.destroy();
            }
            this.mHangarBoxes = null;
         }
         this.mCapacityBar = null;
         this.mCostIconTF = null;
         this.mWarningIconLabel = null;
         this.mBunkerRef = null;
         this.mBunkerPaginatorComponent = null;
         this.mHangarPaginatorComponent = null;
         this.mBunkerPaginatorView = null;
         this.mHangarPaginatorView = null;
         this.mHangarAddedUnits = null;
         this.mTransferDefs = null;
         MessageCenter.getInstance().unregisterObject(this);
      }
      
      private function loadBoxes(bunkerArea:ELayoutArea, hangarArea:ELayoutArea) : void
      {
         var i:int = 0;
         var esprite:ESpriteContainer = null;
         var offsetX:int = 0;
         esprite = getContent("container_units_bunker") as ESpriteContainer;
         offsetX = 0;
         for(i = 0; i < this.mBunkerBoxes.length; )
         {
            this.mBunkerBoxes[i] = new EUnitItemView();
            this.mBunkerBoxes[i].build();
            if(this.mIsVisitor)
            {
               this.mBunkerBoxes[i].setCloseButtonVisible(false);
            }
            esprite.eAddChild(this.mBunkerBoxes[i]);
            esprite.setContent("bunker" + i,this.mHangarBoxes[i]);
            offsetX += this.mBunkerBoxes[i].getLogicWidth();
            i++;
         }
         offsetX = (bunkerArea.width - offsetX) / (5 + 1);
         for(i = 0; i < this.mBunkerBoxes.length; )
         {
            this.mBunkerBoxes[i].logicLeft += offsetX * (i + 1) + this.mBunkerBoxes[i].getLogicWidth() * i;
            i++;
         }
         esprite = getContent("container_units_hangar") as ESpriteContainer;
         offsetX = 0;
         for(i = 0; i < this.mHangarBoxes.length; )
         {
            this.mHangarBoxes[i] = new EUnitItemTransferView();
            this.mHangarBoxes[i].build();
            esprite.eAddChild(this.mHangarBoxes[i]);
            esprite.setContent("hangar" + i,this.mHangarBoxes[i]);
            offsetX += this.mHangarBoxes[i].getLogicWidth();
            i++;
         }
         offsetX = (hangarArea.width - offsetX) / (5 + 1);
         for(i = 0; i < this.mHangarBoxes.length; )
         {
            this.mHangarBoxes[i].logicLeft += offsetX * (i + 1) + this.mHangarBoxes[i].getLogicWidth() * i;
            i++;
         }
      }
      
      public function reloadView() : void
      {
         var unit:Array = null;
         var i:int = 0;
         var sku:* = null;
         var transaction:Transaction = null;
         var couldFitAnotherOne:Boolean = false;
         var unitDef:ShipDef = null;
         var currentAmount:int = 0;
         var bunkerRemainingSpace:int = this.mBunkerRef.getCapacityLeft();
         this.mTransferMineralsAmount = 0;
         this.mTransferDefs.length = 0;
         for(sku in this.mHangarAddedUnits)
         {
            unitDef = InstanceMng.getShipDefMng().getDefBySkuAndUpgradeId(sku,InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getGameUnitBySku(sku).mDef.getUpgradeId());
            bunkerRemainingSpace -= this.mHangarAddedUnits[sku] * unitDef.getSize();
            for(i = 0; i < this.mHangarAddedUnits[sku]; )
            {
               this.mTransferDefs.push(unitDef);
               i++;
            }
         }
         transaction = InstanceMng.getRuleMng().getTransactionTransfer({"defs":this.mTransferDefs});
         this.mTransferMineralsAmount = -transaction.getTransMinerals();
         (this.mCostIconTF.getContent("text") as ETextField).setText("" + this.mTransferMineralsAmount);
         if(InstanceMng.getUserInfoMng().getProfileLogin().getMinerals() - this.mTransferMineralsAmount > 0)
         {
            this.mCostIconTF.getContent("text").unapplySkinProp(mSkinSku,"text_light_negative");
            this.mCostIconTF.getContent("text").applySkinProp(mSkinSku,"text_title_3");
         }
         else
         {
            this.mCostIconTF.getContent("text").unapplySkinProp(mSkinSku,"text_title_3");
            this.mCostIconTF.getContent("text").applySkinProp(mSkinSku,"text_light_negative");
         }
         this.mCostIconTF.visible = !this.mIsVisitor;
         var vector:Vector.<Array> = this.mBunkerRef.getWarUnitsInfoAsVector();
         this.mBunkerPaginatorView.setTotalPages(Math.ceil(vector.length / 5));
         var currentPage:int = this.mBunkerPaginatorView.getCurrentPage();
         i = 0;
         while(i < 5 && i + 5 * currentPage < vector.length)
         {
            unit = vector[i + 5 * currentPage];
            this.mBunkerBoxes[i].fillData(unit);
            this.mBunkerBoxes[i].visible = true;
            i++;
         }
         while(i < 5)
         {
            this.mBunkerBoxes[i].visible = false;
            i++;
         }
         vector = InstanceMng.getHangarControllerMng().getProfileLoginHangarController().getStoredUnitsInfo();
         this.mHangarPaginatorView.setTotalPages(Math.ceil(vector.length / 5));
         currentPage = this.mHangarPaginatorView.getCurrentPage();
         var canTransferMore:Boolean = !this.mIsVisitor || InstanceMng.getVisitorMng().getAmountActionsLeft();
         i = 0;
         while(i < 5 && i + 5 * currentPage < vector.length)
         {
            unit = vector[i + 5 * currentPage];
            this.mHangarBoxes[i].fillData(unit);
            currentAmount = int(this.mHangarAddedUnits[unit[0]]);
            this.mHangarBoxes[i].setCurrentAmount(currentAmount);
            this.mHangarBoxes[i].setEnabledMinusButton(currentAmount != 0);
            this.mHangarBoxes[i].setEnabledPlusButton(canTransferMore && currentAmount != unit[3] && unit[2].getSize() <= bunkerRemainingSpace);
            this.mHangarBoxes[i].visible = true;
            i++;
         }
         while(i < 5)
         {
            this.mHangarBoxes[i].visible = false;
            i++;
         }
         this.updateCapacityLabel(this.mBunkerRef.getMaxCapacity() - bunkerRemainingSpace);
         this.mTransferButton.setIsEnabled(this.mTransferDefs.length > 0);
         if(this.mIsVisitor)
         {
            (this.mHelpAmountSprite.getContent("text") as ETextField).setText("X" + InstanceMng.getVisitorMng().getAmountActionsLeft());
            if(InstanceMng.getVisitorMng().getAmountActionsLeft() < 1 && this.mWarningIconLabel != null)
            {
               this.mWarningIconLabel.visible = true;
               ((this.mWarningIconLabel.getContent("tf") as ESpriteContainer).getContent("text") as ETextField).setText(DCTextMng.getText(244));
            }
         }
      }
      
      private function updateCapacityLabel(previewAmount:int) : void
      {
         var currentCapacity:int = this.mBunkerRef.getCapacityOccupied();
         var maxCapacity:int = this.mBunkerRef.getMaxCapacity();
         this.mCapacityBar.setBarMaxValue(maxCapacity);
         this.mCapacityBar.setBarCurrentValue(currentCapacity);
         this.mCapacityBar.setPreviewBarValue(previewAmount);
         var currentCapacityStr:String = "" + currentCapacity;
         var maxCapacityStr:String = "" + maxCapacity;
         this.mWarningIconLabel.visible = currentCapacity >= maxCapacity;
         this.mCapacityBar.updateText(currentCapacityStr + "/" + maxCapacityStr);
      }
      
      private function transferUnits() : void
      {
         var sku:* = null;
         var arr:Array = null;
         var def:ShipDef = null;
         var bunkerUnits:Vector.<Array> = new Vector.<Array>(0);
         var i:int = 0;
         for(sku in this.mHangarAddedUnits)
         {
            def = InstanceMng.getShipDefMng().getDefBySkuAndUpgradeId(sku,InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getGameUnitBySku(sku).mDef.getUpgradeId());
            arr = [];
            arr[0] = sku;
            arr[1] = this.getHangarIdsForUnitSku(sku,this.mHangarAddedUnits[sku]);
            arr[2] = def;
            arr[3] = this.mHangarAddedUnits[sku];
            bunkerUnits.push(arr);
            if(this.mIsVisitor)
            {
               for(i = 0; i < this.mHangarAddedUnits[sku]; )
               {
                  this.mBunkerRef.store(sku,def.getSize(),true);
                  i++;
               }
            }
            delete this.mHangarAddedUnits[sku];
         }
         if(this.mIsVisitor)
         {
            InstanceMng.getApplication().lockUIWaitForWarpBunkerTransfer(bunkerUnits,this.mBunkerRef.getSid());
         }
         else
         {
            InstanceMng.getHangarControllerMng().getProfileLoginHangarController().moveUnitsToItem(bunkerUnits,this.mBunkerRef);
         }
      }
      
      private function getHangarIdsForUnitSku(sku:String, amount:int) : String
      {
         var sid:* = undefined;
         var i:int = 0;
         var returnValue:String = "";
         var unitsInfo:Object = InstanceMng.getHangarControllerMng().getProfileLoginHangarController().getUnitsInfo();
         for(sid in unitsInfo)
         {
            i = 0;
            while(i < unitsInfo[sid][sku] && amount)
            {
               returnValue += sid + ",";
               amount--;
               i++;
            }
            if(!amount)
            {
               break;
            }
         }
         return returnValue;
      }
      
      public function setPageId(pc:EPaginatorComponent, id:int) : void
      {
         this.reloadView();
      }
      
      private function onTransfer(evt:EEvent) : void
      {
         var guiControllerPlanet:GUIControllerPlanet = null;
         var o:Object = null;
         if(this.mTransferMineralsAmount == 0)
         {
            return;
         }
         if(this.mIsVisitor)
         {
            this.transferUnits();
         }
         else
         {
            guiControllerPlanet = InstanceMng.getGUIControllerPlanet();
            o = guiControllerPlanet.createNotifyEvent("EventPopup","NotifyTransferUnitsToBunker",guiControllerPlanet);
            o.transferAmount = this.mTransferMineralsAmount;
            o.defs = this.mTransferDefs.concat();
            InstanceMng.getNotifyMng().addEvent(guiControllerPlanet,o);
         }
      }
      
      public function onTransferUnitsOK(e:Object) : void
      {
         var unitSku:String = null;
         var hangarIds:String = null;
         var amount:int = 0;
         var i:int = 0;
         var hangarIdArr:Array = null;
         var unitsArr:Array = null;
         var bunkerUnits:Vector.<Array>;
         if((bunkerUnits = e.units) == null)
         {
            return;
         }
         InstanceMng.getVisitorMng().onActionPerformed();
         for each(unitsArr in bunkerUnits)
         {
            unitSku = String(unitsArr[0]);
            hangarIds = String(unitsArr[1]);
            amount = int(unitsArr[3]);
            hangarIdArr = hangarIds.split(",");
            for(i = 0; i < amount; )
            {
               hangarIds = String(hangarIdArr[i]);
               InstanceMng.getTargetMng().updateProgress("addUnitsToFriendsBunker",1,unitSku);
               i++;
            }
         }
         InstanceMng.getHangarControllerMng().getProfileLoginHangarController().removeUnitsFromHangars(bunkerUnits);
         this.reloadView();
      }
      
      public function getName() : String
      {
         return "PopupBunker";
      }
      
      public function getTaskList() : Vector.<String>
      {
         return new <String>["hangarKillUnit","bunkerTransactionUnitsUpdate","bunkerTransactionOK"];
      }
      
      public function onMessage(task:String, params:Dictionary) : void
      {
         switch(task)
         {
            case "hangarKillUnit":
               this.mBunkerRef.removeUnit(params["sku"]);
               InstanceMng.getUserDataMng().updateShips_killUnitFromBunker(params["sku"],parseInt(this.mBunkerRef.getSid()),null);
               this.reloadView();
               break;
            case "bunkerTransactionUnitsUpdate":
               if(params["amount"] == 0)
               {
                  delete this.mHangarAddedUnits[params["sku"]];
               }
               else
               {
                  this.mHangarAddedUnits[params["sku"]] = params["amount"];
               }
               this.reloadView();
               break;
            case "bunkerTransactionOK":
               this.transferUnits();
               this.reloadView();
         }
      }
   }
}
