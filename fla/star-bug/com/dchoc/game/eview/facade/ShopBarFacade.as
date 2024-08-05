package com.dchoc.game.eview.facade
{
   import com.dchoc.game.controller.shop.BuildingsShopController;
   import com.dchoc.game.core.flow.messaging.INotifyReceiver;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.hud.EUnitItemShopBarView;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipInfo;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.game.view.dc.gui.components.GUIBar;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.def.DCDef;
   import com.dchoc.toolkit.view.conf.DCGUIDef;
   import com.gskinner.motion.GTween;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import flash.utils.Dictionary;
   
   public class ShopBarFacade extends GUIBar implements INotifyReceiver
   {
      
      public static var NUM_ITEMS:int;
      
      public static const BUTTON_SHOP_DEFENSES:String = "defenses_button";
      
      public static const BUTTON_SHOP_SHIPYARD:String = "shipyard_button";
      
      public static const BUTTON_SHOP_LABS:String = "laboratories_button";
      
      public static const BUTTON_SHOP_HOUSES:String = "houses_button";
      
      public static const BUTTON_SHOP_DECORATIONS:String = "decorations_button";
      
      public static const BUTTON_SHOP_DROIDS:String = "droids_button";
      
      public static const SHOP_BOX_COMING_SOON_ID:String = "COMINGSOON";
      
      private static const SKU_HOUSE:String = "houses";
      
      private static const SKU_DEFENSES:String = "defenses";
      
      private static const SKU_TURRETS:String = "turrets";
      
      private static const SKU_SHIPYARD:String = "shipyard";
      
      private static const SKU_DECORATIONS:String = "decorations";
      
      private static const AREA_BKG:String = "container_hud_bottom";
      
      private static const AREA_NAVIGATION:String = "area_navegation";
      
      private static const BUTTON_CLOSE:String = "btn_close";
      
      private static const ARROW_LEFT:String = "btn_arrow_left";
      
      private static const ARROW_RIGHT:String = "btn_arrow_right";
      
      private static const AREA_UNIT_SHIP_PREFIX:String = "area_";
      
      public static const HUD_PRIMARY_BUTTONS_GROUP:Array = ["houses_button","decorations_button","defenses_button","droids_button","laboratories_button","shipyard_button","btn_close","btn_arrow_left","btn_arrow_right","area_0","area_1","area_2","area_3","area_4","area_5"];
       
      
      private var mButtonSkusDic:Dictionary;
      
      protected var mShopControllerRef:BuildingsShopController;
      
      private var mViewFactory:ViewFactory;
      
      private var mLayoutAreaFactory:ELayoutAreaFactory;
      
      private var mCanvasBottom:ESpriteContainer;
      
      private var mContentHolders:Dictionary;
      
      private var mPage:int = 0;
      
      private var mResourcesInfo:Vector.<DCDef>;
      
      public function ShopBarFacade()
      {
         super("shop_menu");
         this.mContentHolders = new Dictionary();
         NUM_ITEMS = 6;
         this.mButtonSkusDic = new Dictionary();
         this.mButtonSkusDic["houses"] = "houses_button";
         this.mButtonSkusDic["defenses"] = "laboratories_button";
         this.mButtonSkusDic["turrets"] = "defenses_button";
         this.mButtonSkusDic["shipyard"] = "shipyard_button";
         this.mButtonSkusDic["decorations"] = "decorations_button";
      }
      
      public static function getTabIdFromNameId(nameId:String) : String
      {
         if(nameId == null || nameId == "")
         {
            return null;
         }
         return nameId + "_button";
      }
      
      public function getName() : String
      {
         return "EShopBar";
      }
      
      public function getTaskList() : Vector.<String>
      {
         return new <String>["uiUnlockElement","uiLockElement","putTutorialCircle"];
      }
      
      public function onMessage(task:String, params:Dictionary) : void
      {
         var name:String = null;
         var component:ESprite = null;
         switch(task)
         {
            case "putTutorialCircle":
               name = String(params["elementName"]);
               component = this.getHudElement(name);
               if(component)
               {
                  InstanceMng.getViewMngPlanet().addHighlightFromContainer(component);
               }
               break;
            case "uiUnlockElement":
               name = String(params["elementName"]);
               component = this.getHudElement(name);
               if(component)
               {
                  component.mouseEnabled = true;
               }
               break;
            case "uiLockElement":
               name = String(params["elementName"]);
               component = this.getHudElement(name);
               if(component)
               {
                  component.mouseEnabled = false;
               }
         }
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildSyncTotalSteps = 3;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         var s:ESprite = null;
         var btn:EButton = null;
         var buttonBoxes:Vector.<EButton> = null;
         var i:int = 0;
         var unitView:EUnitItemShopBarView = null;
         switch(step)
         {
            case 0:
               this.mViewFactory = InstanceMng.getViewFactory();
               this.mCanvasBottom = this.mViewFactory.getESpriteContainer();
               this.mLayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory("LayoutHudBottomShop");
               this.mShopControllerRef = InstanceMng.getBuildingsShopController();
               buildAdvanceSyncStep();
               break;
            case 1:
               s = this.mViewFactory.getEImage("skin_ui_hud_area_bottom",null,false,this.mLayoutAreaFactory.getArea("container_hud_bottom"));
               s.name = "container_hud_bottom";
               this.addHudElement("container_hud_bottom",s,this.mCanvasBottom,false);
               (btn = this.mViewFactory.getButtonClose(null,this.mLayoutAreaFactory.getArea("btn_close"))).name = "btn_close";
               btn.eAddEventListener("click",this.onCloseClick);
               this.addHudElement("btn_close",btn,this.mCanvasBottom,true);
               s = this.mViewFactory.getEImage("tab_bkg_hud",null,false,this.mLayoutAreaFactory.getArea("area_navegation"));
               s.name = "area_navegation";
               this.addHudElement("area_navegation",s,this.mCanvasBottom,false);
               buttonBoxes = new Vector.<EButton>(0);
               buttonBoxes.length = 0;
               (btn = this.mViewFactory.getTextTabHeaderHud(this.mShopControllerRef.getShopTabTitle("houses_button"),null)).name = "houses_button";
               btn.mouseChildren = false;
               btn.eAddEventListener("click",this.onTabClick);
               buttonBoxes.push(btn);
               this.addHudElement("houses_button",btn,this.mCanvasBottom,true);
               (btn = this.mViewFactory.getTextTabHeaderHud(this.mShopControllerRef.getShopTabTitle("shipyard_button"),null)).name = "shipyard_button";
               btn.mouseChildren = false;
               btn.eAddEventListener("click",this.onTabClick);
               buttonBoxes.push(btn);
               this.addHudElement("shipyard_button",btn,this.mCanvasBottom,true);
               (btn = this.mViewFactory.getTextTabHeaderHud(this.mShopControllerRef.getShopTabTitle("defenses_button"),null)).name = "defenses_button";
               btn.mouseChildren = false;
               btn.eAddEventListener("click",this.onTabClick);
               buttonBoxes.push(btn);
               this.addHudElement("defenses_button",btn,this.mCanvasBottom,true);
               (btn = this.mViewFactory.getTextTabHeaderHud(this.mShopControllerRef.getShopTabTitle("laboratories_button"),null)).name = "laboratories_button";
               btn.mouseChildren = false;
               btn.eAddEventListener("click",this.onTabClick);
               buttonBoxes.push(btn);
               this.addHudElement("laboratories_button",btn,this.mCanvasBottom,true);
               (btn = this.mViewFactory.getTextTabHeaderHud(this.mShopControllerRef.getShopTabTitle("decorations_button"),null)).name = "decorations_button";
               btn.mouseChildren = false;
               btn.eAddEventListener("click",this.onTabClick);
               buttonBoxes.push(btn);
               this.addHudElement("decorations_button",btn,this.mCanvasBottom,true);
               this.mViewFactory.distributeButtons(buttonBoxes,this.mLayoutAreaFactory.getArea("area_navegation"),true);
               buildAdvanceSyncStep();
               break;
            case 2:
               (btn = this.mViewFactory.getButtonImage("btn_arrow",null,this.mLayoutAreaFactory.getArea("btn_arrow_left"))).name = "btn_arrow_left";
               btn.eAddEventListener("click",this.onLeftClick);
               this.addHudElement("btn_arrow_left",btn,this.mCanvasBottom,true);
               (btn = this.mViewFactory.getButtonImage("btn_arrow",null,this.mLayoutAreaFactory.getArea("btn_arrow_right"))).name = "btn_arrow_right";
               btn.eAddEventListener("click",this.onRightClick);
               this.addHudElement("btn_arrow_right",btn,this.mCanvasBottom,true);
               for(i = 0; i < NUM_ITEMS; )
               {
                  (unitView = new EUnitItemShopBarView()).build();
                  unitView.setLayoutArea(this.mLayoutAreaFactory.getArea("area_" + i),true);
                  this.addHudElement("area_" + i,unitView,this.mCanvasBottom,true);
                  i++;
               }
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
         this.changeShop("houses_button");
         MessageCenter.getInstance().registerObject(this);
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
         MessageCenter.getInstance().unregisterObject(this);
         InstanceMng.getViewMngGame().removeESpriteFromLayer(this.mCanvasBottom,InstanceMng.getViewMngGame().getHudLayerSku());
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var s:ESprite = null;
         super.logicUpdateDo(dt);
         for each(s in this.mContentHolders)
         {
            s.logicUpdate(dt);
         }
      }
      
      private function getHudElement(id:String) : ESprite
      {
         return this.mContentHolders[id];
      }
      
      override public function addMouseEvents() : void
      {
         var s:String = null;
         var esprite:ESprite = null;
         for each(s in HUD_PRIMARY_BUTTONS_GROUP)
         {
            esprite = this.getHudElement(s);
            if(esprite)
            {
               esprite.mouseEnabled = true;
            }
         }
      }
      
      override public function removeMouseEvents() : void
      {
         var s:String = null;
         var esprite:ESprite = null;
         for each(s in HUD_PRIMARY_BUTTONS_GROUP)
         {
            esprite = this.getHudElement(s);
            if(esprite)
            {
               esprite.mouseEnabled = false;
            }
         }
      }
      
      override public function unlock(exception:Object = null) : void
      {
         var s:ESprite = null;
         super.unlock();
         this.addMouseEvents();
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
         this.removeMouseEvents();
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
         var values:Object = null;
         var tween:GTween = null;
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
      
      public function reloadResources() : void
      {
         this.changeShop(this.mShopControllerRef.getShopTab(),true);
      }
      
      public function changeShopBySku(sku:String) : void
      {
         var name:String = String(this.mButtonSkusDic[sku]);
         if(name != null)
         {
            this.changeShop(name,true);
         }
      }
      
      public function changeShop(shop:String, forceChange:Boolean = false) : Boolean
      {
         if(this.mShopControllerRef.getShopTab() == shop && !forceChange)
         {
            return false;
         }
         this.mPage = 0;
         this.mShopControllerRef.setShopTab(shop);
         this.loadShop(shop);
         this.mShopControllerRef.notifyChangeShop();
         return true;
      }
      
      public function searchItem(sku:String) : void
      {
         var count:int = 0;
         var i:int = 0;
         var page:int = 0;
         if(this.mResourcesInfo != null)
         {
            count = int(this.mResourcesInfo.length);
            for(i = 0; i < count; )
            {
               if(this.mResourcesInfo[i].mSku == sku)
               {
                  page = i / NUM_ITEMS;
                  this.loadResources(page);
                  break;
               }
               i++;
            }
         }
      }
      
      public function loadShop(shop:String = null) : void
      {
         this.mResourcesInfo = this.mShopControllerRef.getShopResourcesInfo();
         this.loadResources(this.mPage);
      }
      
      private function loadResources(page:int) : void
      {
         this.mPage = page;
         this.reloadView();
      }
      
      private function reloadView() : void
      {
         var i:int = 0;
         this.checkArrows();
         if(this.mResourcesInfo != null)
         {
            i = 0;
            while(i < NUM_ITEMS && i + this.mPage * NUM_ITEMS < this.mResourcesInfo.length)
            {
               (this.getHudElement("area_" + i) as EUnitItemShopBarView).fillData([this.mResourcesInfo[this.mPage * NUM_ITEMS + i]]);
               this.getHudElement("area_" + i).visible = true;
               i++;
            }
            while(i < NUM_ITEMS)
            {
               this.getHudElement("area_" + i).visible = false;
               i++;
            }
         }
      }
      
      private function checkArrows() : void
      {
         (this.getHudElement("btn_arrow_left") as EButton).setIsEnabled(this.mPage > 0);
         (this.getHudElement("btn_arrow_right") as EButton).setIsEnabled((this.mPage + 1) * NUM_ITEMS < this.mResourcesInfo.length - 1);
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
      
      private function onCloseClick(evt:EEvent) : void
      {
         MessageCenter.getInstance().sendMessage("hideShopbar");
      }
      
      private function onTabClick(evt:EEvent) : void
      {
         this.changeShop(evt.getTarget().name,true);
      }
      
      private function onLeftClick(evt:EEvent) : void
      {
         this.loadResources(this.mPage - 1);
      }
      
      private function onRightClick(evt:EEvent) : void
      {
         this.loadResources(this.mPage + 1);
      }
   }
}
