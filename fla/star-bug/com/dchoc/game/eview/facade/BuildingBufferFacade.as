package com.dchoc.game.eview.facade
{
   import com.dchoc.game.controller.shop.BuildingsBufferController;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.hud.EBuildingBufferItemView;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipInfo;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.game.model.userdata.UserDataMng;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.game.view.dc.gui.components.GUIBar;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.view.conf.DCGUIDef;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   import com.gskinner.motion.GTween;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import flash.utils.Dictionary;
   
   public class BuildingBufferFacade extends GUIBar
   {
      
      private static const NUM_ITEMS:int = 6;
      
      private static const BUTTON_DESELECT:String = "deselect";
      
      private static const BUTTON_CONFIRM_PLACEMENT:String = "confirm_placement";
      
      private static const BUTTON_CANCEL_MOVES:String = "cancel_moves";
      
      private static const BUTTON_CLEAR:String = "clear";
      
      private static const BUTTON_TEMPLATES:String = "templates";
      
      private static const BUTTON_RANGE:String = "btn_range";
      
      private static const BUTTON_GRID:String = "btn_grid";
      
      private static const BUTTON_FLATBED:String = "btn_flatbed";
      
      private static const AREA_BKG:String = "container_hud_bottom";
      
      private static const AREA_BUTTON_BOXES:String = "area_button_boxes";
      
      private static const BUTTON_CLOSE:String = "btn_close";
      
      private static const ARROW_LEFT:String = "btn_arrow_left";
      
      private static const ARROW_RIGHT:String = "btn_arrow_right";
       
      
      protected var mBuildingBufferControllerRef:BuildingsBufferController;
      
      private var mViewFactory:ViewFactory;
      
      private var mLayoutAreaFactory:ELayoutAreaFactory;
      
      private var mCanvasBottom:ESpriteContainer;
      
      private var mContentHolders:Dictionary;
      
      private var mItemViews:Vector.<String>;
      
      private var mPage:int = 0;
      
      private var mResourcesInfo:Vector.<WorldItemObject>;
      
      private var mHasAnythingBeenDone:Boolean = false;
      
      public function BuildingBufferFacade()
      {
         super("shop_menu");
         this.mContentHolders = new Dictionary();
         this.mItemViews = new Vector.<String>(0);
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildSyncTotalSteps = 3;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         var layoutArea:ELayoutArea = null;
         var buttonBoxesArea:ELayoutArea = null;
         var i:int = 0;
         var s:ESprite = null;
         var btn:EButton = null;
         var buttonBoxes:Vector.<EButton> = null;
         switch(step)
         {
            case 0:
               this.mViewFactory = InstanceMng.getViewFactory();
               this.mCanvasBottom = this.mViewFactory.getESpriteContainer();
               this.mLayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory("LayoutHudBottomShop");
               this.mBuildingBufferControllerRef = InstanceMng.getBuildingsBufferController();
               buildAdvanceSyncStep();
               break;
            case 1:
               (buttonBoxesArea = ELayoutAreaFactory.createLayoutArea(700,62)).x = -352;
               buttonBoxesArea.y = -171;
               (s = this.mViewFactory.getEImage("tab_bkg_hud",null,false,buttonBoxesArea)).name = "area_button_boxes";
               this.addHudElement("area_button_boxes",s,this.mCanvasBottom,false);
               (s = this.mViewFactory.getEImage("skin_ui_hud_area_bottom",null,false,this.mLayoutAreaFactory.getArea("container_hud_bottom"))).name = "container_hud_bottom";
               this.addHudElement("container_hud_bottom",s,this.mCanvasBottom,false);
               s.eAddEventListener("click",this.addItem);
               (btn = this.mViewFactory.getButtonClose(null,this.mLayoutAreaFactory.getArea("btn_close"))).name = "btn_close";
               btn.eAddEventListener("click",this.onCancelClick);
               this.addHudElement("btn_close",btn,this.mCanvasBottom,true);
               buttonBoxes = new Vector.<EButton>(0);
               buttonBoxes.length = 0;
               (btn = this.mViewFactory.getButton("btn_cancel",null,"S",DCTextMng.getText(3688))).name = "clear";
               btn.mouseChildren = false;
               btn.eAddEventListener("click",this.onClearClick);
               buttonBoxes.push(btn);
               this.addHudElement("clear",btn,this.mCanvasBottom,true);
               (btn = this.mViewFactory.getButton("btn_hud",null,"S",DCTextMng.getText(4070))).name = "deselect";
               btn.mouseChildren = false;
               btn.eAddEventListener("click",this.addItem);
               buttonBoxes.push(btn);
               this.addHudElement("deselect",btn,this.mCanvasBottom,true);
               (btn = this.mViewFactory.getButton("btn_hud",null,"S",DCTextMng.getText(3686))).name = "confirm_placement";
               btn.mouseChildren = false;
               btn.eAddEventListener("click",this.confirmSelection);
               buttonBoxes.push(btn);
               this.addHudElement("confirm_placement",btn,this.mCanvasBottom,true);
               (btn = this.mViewFactory.getButton("btn_hud",null,"S",DCTextMng.getText(3979))).name = "templates";
               btn.mouseChildren = false;
               btn.eAddEventListener("click",this.onTemplatesClick);
               buttonBoxes.push(btn);
               this.addHudElement("templates",btn,this.mCanvasBottom,true);
               (btn = this.mViewFactory.getButton("btn_cancel",null,"S",DCTextMng.getText(4072))).name = "cancel_moves";
               btn.mouseChildren = false;
               btn.eAddEventListener("click",this.onCancelClick);
               buttonBoxes.push(btn);
               this.addHudElement("cancel_moves",btn,this.mCanvasBottom,true);
               this.mViewFactory.distributeButtons(buttonBoxes,buttonBoxesArea,true);
               for(i = 0; i < buttonBoxes.length; )
               {
                  btn = buttonBoxes[i];
                  btn.logicY += buttonBoxesArea.height / 4;
                  i++;
               }
               buildAdvanceSyncStep();
               break;
            case 2:
               layoutArea = ELayoutAreaFactory.createLayoutArea(28,28);
               layoutArea.x = -369;
               layoutArea.y = -107;
               (btn = this.mViewFactory.getButtonIcon("btn_hud","icon_range",null,layoutArea,null,true)).getIcon().scaleX = 0.3;
               btn.getIcon().scaleY = 0.3;
               btn.getIcon().logicLeft = btn.getIcon().logicLeft + 1;
               btn.name = "btn_range";
               btn.eAddEventListener("click",this.onRangeClick);
               this.addHudElement("btn_range",btn,this.mCanvasBottom,true);
               (btn = this.mViewFactory.getButtonImage("btn_arrow",null,this.mLayoutAreaFactory.getArea("btn_arrow_left"))).name = "btn_arrow_left";
               btn.eAddEventListener("click",this.onLeftClick);
               this.addHudElement("btn_arrow_left",btn,this.mCanvasBottom,true);
               (btn = this.mViewFactory.getButtonImage("btn_arrow",null,this.mLayoutAreaFactory.getArea("btn_arrow_right"))).name = "btn_arrow_right";
               btn.eAddEventListener("click",this.onRightClick);
               this.addHudElement("btn_arrow_right",btn,this.mCanvasBottom,true);
               layoutArea = ELayoutAreaFactory.createLayoutArea(28,28);
               layoutArea.x = -369;
               layoutArea.y = -45;
               (btn = this.mViewFactory.getButtonIcon("btn_hud","skin_icon_grid",null,layoutArea,null,true)).getIcon().scaleX = 0.8;
               btn.getIcon().scaleY = 0.8;
               btn.getIcon().logicLeft = btn.getIcon().logicLeft + 3;
               btn.getIcon().logicTop = btn.getIcon().logicTop + 3;
               btn.name = "btn_grid";
               btn.eAddEventListener("click",this.onGridClick);
               this.addHudElement("btn_grid",btn,this.mCanvasBottom,true);
               layoutArea = ELayoutAreaFactory.createLayoutArea(28,28);
               layoutArea.x = 341;
               layoutArea.y = -45;
               (btn = this.mViewFactory.getButtonIcon("btn_hud","skin_icon_flatbed",null,layoutArea,null,true)).getIcon().scaleX = 0.55;
               btn.getIcon().scaleY = 0.55;
               btn.getIcon().logicTop = btn.getIcon().logicTop + 6;
               btn.name = "btn_flatbed";
               btn.eAddEventListener("click",this.onFlatbedClick);
               this.addHudElement("btn_flatbed",btn,this.mCanvasBottom,true);
               buildAdvanceSyncStep();
         }
      }
      
      private function addHudElement(id:String, s:ESprite, where:ESpriteContainer, addMouseOverBehaviours:Boolean) : void
      {
         s.name = id;
         if(addMouseOverBehaviours)
         {
            s.eAddEventBehavior("rollOver",InstanceMng.getBehaviorsMng().getMouseBehavior("MouseOverButton"));
            s.eAddEventBehavior("rollOut",InstanceMng.getBehaviorsMng().getMouseBehavior("MouseOutButton"));
            s.eAddEventListener("rollOver",this.onMouseOverBtn);
            s.eAddEventListener("rollOut",this.onMouseOutBtn);
         }
         s.eAddEventListener("rollOver",uiEnable);
         s.eAddEventListener("rollOut",uiDisable);
         where.eAddChild(s);
         this.mContentHolders[id] = s;
      }
      
      override protected function beginDo() : void
      {
         InstanceMng.getViewMngGame().addESpriteToLayer(this.mCanvasBottom,InstanceMng.getViewMngGame().getHudLayerSku(),8);
         this.mCanvasBottom.logicY = this.mCanvasBottom.logicY;
         setVisible(true);
         this.moveDisappearUpToDown(0.01);
      }
      
      override protected function unbuildDo() : void
      {
         var id:* = null;
         for(id in this.mContentHolders)
         {
            this.mContentHolders[id].destroy();
            delete this.mContentHolders[id];
         }
         this.mCanvasBottom.destroy();
      }
      
      override protected function endDo() : void
      {
         ETooltipMng.getInstance().removeCurrentTooltip();
         InstanceMng.getViewMngGame().removeESpriteFromLayer(this.mCanvasBottom,InstanceMng.getViewMngGame().getHudLayerSku());
      }
      
      public function updateButtons() : void
      {
         if(this.mBuildingBufferControllerRef.isBufferOpen())
         {
            this.getHudElement("cancel_moves").setIsEnabled(this.mBuildingBufferControllerRef.getCancelButtonAvailability());
            this.getHudElement("confirm_placement").setIsEnabled(this.getConfirmButtonAvailability());
            this.getHudElement("deselect").setIsEnabled(InstanceMng.getToolsMng().getCurrentTool().isItemAttached());
            this.getHudElement("clear").setIsEnabled(this.mBuildingBufferControllerRef.isAnythingPlaced());
            this.getHudElement("templates").setIsEnabled(InstanceMng.getUserDataMng().isFileLoaded(UserDataMng.KEY_TEMPLATES));
         }
      }
      
      private function getConfirmButtonAvailability() : Boolean
      {
         if(!this.mHasAnythingBeenDone || !this.mResourcesInfo || this.mResourcesInfo.length > 0 || InstanceMng.getToolsMng().getCurrentTool().isItemAttached())
         {
            return false;
         }
         return true;
      }
      
      private function getHudElement(id:String) : ESprite
      {
         return this.mContentHolders[id];
      }
      
      override public function unlock(exception:Object = null) : void
      {
         var s:ESprite = null;
         super.unlock();
         addMouseEvents();
         if(exception)
         {
            s = this.getHudElement(exception.toString());
            if(s)
            {
               s.mouseEnabled = false;
            }
         }
      }
      
      override public function lock() : void
      {
         super.lock();
         removeMouseEvents();
      }
      
      override public function moveDisappearUpToDown(numSeconds:Number = 0.5) : void
      {
         var values:Object = null;
         var tween:GTween = null;
         if(isVisible())
         {
            values = {"pivotLogicY":-1};
            tween = new GTween(this.mCanvasBottom,numSeconds,values);
            tween.autoPlay = true;
            tween.onComplete = function(t:GTween):void
            {
               setVisible(false);
            };
         }
      }
      
      override public function moveAppearDownToUp(numSeconds:Number = 0.5) : void
      {
         var values:Object;
         var tween:GTween;
         this.mHasAnythingBeenDone = false;
         values = null;
         tween = null;
         if(!isVisible())
         {
            values = {"pivotLogicY":0};
            tween = new GTween(this.mCanvasBottom,numSeconds,values);
            tween.autoPlay = true;
            tween.onComplete = function(t:GTween):void
            {
               setVisible(true);
            };
         }
      }
      
      public function loadShop() : void
      {
         this.mResourcesInfo = this.mBuildingBufferControllerRef.getShopResourcesInfo();
         this.loadResources(this.mPage);
      }
      
      private function loadResources(page:int) : void
      {
         this.mPage = page;
         this.reloadView();
      }
      
      public function reloadView() : void
      {
         var skus:Vector.<Array> = new Vector.<Array>(0);
         var skuIndex:int = 0;
         var i:int = 0;
         var alreadyAddedAsSku:Boolean = false;
         var j:int = 0;
         var buildingView:EBuildingBufferItemView = null;
         this.destroyViews();
         this.mResourcesInfo = this.mBuildingBufferControllerRef.getShopResourcesInfo();
         DCDebug.traceCh("BB","RESOURCES INFO HAS: " + this.mResourcesInfo.length.toString() + " ITEMS");
         ETooltipMng.getInstance().removeCurrentTooltip();
         if(this.mResourcesInfo.length != 0)
         {
            skuIndex = 0;
            for(i = 0; i < this.mResourcesInfo.length; )
            {
               alreadyAddedAsSku = false;
               for(j = 0; j < skuIndex; )
               {
                  if(skus[j][0] == this.mResourcesInfo[i].mDef.getSku())
                  {
                     alreadyAddedAsSku = true;
                     break;
                  }
                  j++;
               }
               if(!alreadyAddedAsSku)
               {
                  skus[skuIndex++] = [this.mResourcesInfo[i].mDef.getSku(),i];
               }
               i++;
            }
            skus.sort(0);
            i = this.mPage * 6;
            while(i < skus.length && i < (this.mPage + 1) * 6)
            {
               (buildingView = new EBuildingBufferItemView()).build();
               buildingView.setLayoutArea(this.mLayoutAreaFactory.getArea("area_" + (i - this.mPage * 6)),true);
               this.addHudElement(this.mResourcesInfo[skus[i][1]].mDef.getSku(),buildingView,this.mCanvasBottom,true);
               buildingView.setAmount(this.mBuildingBufferControllerRef.getBuildingAmount(this.mResourcesInfo[skus[i][1]].mDef.getSku()));
               buildingView.fillData([this.mResourcesInfo[skus[i][1]].mDef]);
               this.mItemViews.push(this.mResourcesInfo[skus[i][1]].mDef.getSku());
               buildingView.setMItem(this.mResourcesInfo[skus[i][1]]);
               i++;
            }
         }
         this.checkArrows(skus.length);
         this.updateButtons();
      }
      
      private function isViewCreated(s:String) : Boolean
      {
         var view:String = null;
         for each(view in this.mItemViews)
         {
            if(view == s)
            {
               return true;
            }
         }
         return false;
      }
      
      private function checkArrows(itemCount:int) : void
      {
         (this.getHudElement("btn_arrow_left") as EButton).setIsEnabled(this.mPage > 0);
         (this.getHudElement("btn_arrow_right") as EButton).setIsEnabled((this.mPage + 1) * 6 < itemCount);
      }
      
      private function destroyViews() : void
      {
         var itemView:String = null;
         for each(itemView in this.mItemViews)
         {
            this.getHudElement(itemView).destroy();
         }
         this.mItemViews = new Vector.<String>(0);
      }
      
      public function destroyView(i:String) : void
      {
         var index:int = this.mItemViews.indexOf(i);
         i = null;
         this.mItemViews.splice(index,1);
      }
      
      public function closeBufferBar() : void
      {
         MessageCenter.getInstance().sendMessage("hideBufferbar");
         this.destroyViews();
         this.mBuildingBufferControllerRef.cancelSelection();
         this.mResourcesInfo = null;
      }
      
      private function onMouseOverBtn(evt:EEvent) : void
      {
         var buttonName:String = null;
         var guiDef:DCGUIDef = null;
         var tooltipInfo:ETooltipInfo = null;
         if(evt.getTarget())
         {
            buttonName = String(evt.getTarget().name);
            if(guiDef = InstanceMng.getGUIDefMng().getDefBySku(buttonName) as DCGUIDef)
            {
               tooltipInfo = ETooltipMng.getInstance().createTooltipInfoFromText(DCTextMng.getText(TextIDs[guiDef.getTidTitleTooltip()]),evt.getTarget());
            }
         }
      }
      
      private function onMouseOutBtn(evt:EEvent) : void
      {
         if(evt.getTarget())
         {
            ETooltipMng.getInstance().removeCurrentTooltip();
         }
      }
      
      private function confirmSelection(evt:EEvent) : void
      {
         this.getHudElement("confirm_placement").setIsEnabled(false);
         this.mBuildingBufferControllerRef.sendConfirmationToServer();
         MessageCenter.getInstance().sendMessage("hideBufferbar");
         this.destroyViews();
         this.mResourcesInfo = null;
      }
      
      private function doCancel(evt:EEvent) : void
      {
         MessageCenter.getInstance().sendMessage("hideBufferbar");
         this.destroyViews();
         var wio:WorldItemObject = null;
         var allItems:Vector.<WorldItemObject> = InstanceMng.getWorld().itemsGetAllItems();
         for each(wio in allItems)
         {
            if(!wio.mDef.isAnObstacle() && !this.mBuildingBufferControllerRef.checkItemInBuffer(wio) && this.mBuildingBufferControllerRef.isItemAllowedInBuffer(wio))
            {
               this.mBuildingBufferControllerRef.getShopResourcesInfo().push(wio);
               this.mBuildingBufferControllerRef.moveBegin(wio);
               wio.setTileXY(wio.mTileRelativeX + 1000,wio.mTileRelativeY);
               this.mBuildingBufferControllerRef.moveEnd(wio);
               this.mBuildingBufferControllerRef.calculateQuantity(wio);
            }
         }
         this.mBuildingBufferControllerRef.cancelSelection();
         this.mResourcesInfo = null;
      }
      
      private function doClear(evt:EEvent) : void
      {
         InstanceMng.getWorld().toggleAllRangePreviews(true);
         this.mBuildingBufferControllerRef.addAllItems();
      }
      
      private function onCancelClick(evt:EEvent) : void
      {
         InstanceMng.getNotificationsMng().guiOpenConfirmPopup("PopupCancelBuffer",DCTextMng.getText(4),DCTextMng.getText(113),"orange_normal",DCTextMng.getText(1),DCTextMng.getText(2),doCancel,null);
      }
      
      private function onClearClick(evt:EEvent) : void
      {
         InstanceMng.getNotificationsMng().guiOpenConfirmPopup("PopupCancelBuffer",DCTextMng.getText(4),DCTextMng.getText(4071),"orange_normal",DCTextMng.getText(1),DCTextMng.getText(2),doClear,null);
      }
      
      private function onRangeClick(evt:EEvent) : void
      {
         InstanceMng.getWorld().toggleAllRangePreviews();
      }
      
      private function onGridClick(evt:EEvent) : void
      {
         InstanceMng.getMapViewPlanet().onIncrementBorderResolution();
      }
      
      private function onLeftClick(evt:EEvent) : void
      {
         this.loadResources(this.mPage - 1);
      }
      
      private function onRightClick(evt:EEvent) : void
      {
         this.loadResources(this.mPage + 1);
      }
      
      private function onFlatbedClick(evt:EEvent) : void
      {
         InstanceMng.getUserInfoMng().getProfileLogin().toggleFlatbed();
      }
      
      private function onTemplatesClick(evt:EEvent) : void
      {
         var userDataMng:UserDataMng = InstanceMng.getUserDataMng();
         if(!userDataMng.isFileLoaded(UserDataMng.KEY_TEMPLATES))
         {
            return;
         }
         var popup:DCIPopup = InstanceMng.getUIFacade().getPopupFactory().getBufferTemplatesPopup();
         InstanceMng.getUIFacade().enqueuePopup(popup);
      }
      
      private function addItem(evt:EEvent) : void
      {
         if(InstanceMng.getToolsMng().getCurrentTool().isItemAttached())
         {
            this.mBuildingBufferControllerRef.tryToAddItem();
            this.loadShop();
         }
      }
      
      public function noLongerInitialState() : void
      {
         this.mHasAnythingBeenDone = true;
      }
   }
}
