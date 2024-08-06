package com.dchoc.game.eview.popups.upgrade
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.paginator.TabHeadersView;
   import com.dchoc.game.eview.widgets.tooltips.ETooltip;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipInfo;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.game.model.items.ItemObject;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import esparragon.widgets.EFillBar;
   import esparragon.widgets.paginator.EPaginatorComponent;
   import esparragon.widgets.paginator.EPaginatorController;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class UpgradeBodyInfo extends UpgradeBody implements EPaginatorController
   {
      
      protected static const BODY:String = "body";
      
      protected static const CONTAINER_INFO:String = "pannel";
      
      protected static const CONTAINER_IMAGE:String = "cbox_img";
      
      protected static const BKG_REQUIREMENTS:String = "area";
      
      protected static const REQUIREMENTS_TITLE:String = "requirements_title";
      
      protected static const REQUIREMENTS_BOX:String = "requirements_box";
      
      protected static const REQUIREMENTS_ITEM:String = "requirements_item";
      
      protected static const REQUIREMENTS_DESC:String = "requirementes_desc";
      
      protected static const REQUIREMENTS_LEVEL:String = "requirements_level";
      
      protected static const CHIPS_BOX:String = "ChipsBox";
      
      protected static const CHIPS_BKG:String = "ChipsBkg";
      
      protected static const CHIPS_TITLE:String = "ChipsTitle";
      
      protected static const CHIPS_TEXT:String = "ChipsText";
      
      protected static const BUTTON_CHIPS:String = "ButtonChips";
      
      protected static const TAB:String = "tab";
      
      protected static const COST_BOX:String = "CostBox";
      
      protected static const COST_BACKGROUND:String = "CostBackground";
      
      protected static const COST_TITLE:String = "CostTitle";
      
      protected static const COST_TIME:String = "CostTime";
      
      protected static const COST_COINS:String = "CostCoins";
      
      protected static const COST_MINERALS:String = "CostMinerals";
      
      protected static const COST_ITEMS:String = "CostItems";
      
      protected static const BUTTON_START:String = "ButtonStart";
      
      protected static const WARNING_BOX:String = "WarningBox";
      
      protected static const WARNING_BKG:String = "WarningBkg";
      
      protected static const WARNING_IMAGE:String = "WarningImage";
      
      protected static const WARNING_TEXT:String = "WarningText";
      
      protected static const TEXT_TITLE:String = "text_title";
      
      protected static const TEXT_INFO:String = "text_info";
      
      protected static const FILLBAR_TEXT_VALUE:String = "text_value";
      
      protected static const FILLBAR_TEXT_REVALUE:String = "text_revalue";
       
      
      protected var mBottomBoxes:Array;
      
      protected var mInfoBox:ESpriteContainer;
      
      protected var mRequirementsBox:ESpriteContainer;
      
      protected var mTabsHeaderView:TabHeadersView;
      
      private var mPaginator:EPaginatorComponent;
      
      protected var mBottomArea:ELayoutArea;
      
      protected var mInfoArea:ELayoutArea;
      
      protected var mFillBars:Array;
      
      private var mTabsCount:int;
      
      private var mItemTooltips:Dictionary;
      
      private var mCurrentItemTooltip:ETooltip;
      
      public function UpgradeBodyInfo(popupUpgrade:EPopupUpgrade, viewFactory:ViewFactory, skinSku:String)
      {
         mItemTooltips = new Dictionary();
         super(popupUpgrade,viewFactory,skinSku);
         mPopupUpgrade = popupUpgrade;
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         this.destroyComponents();
         this.mTabsHeaderView = null;
         this.mPaginator = null;
         this.mBottomBoxes = null;
         this.mFillBars = null;
         this.mRequirementsBox = null;
      }
      
      public function setup(info:*) : void
      {
         this.setupCommon();
         this.setupBottom();
      }
      
      private function setupCommon() : void
      {
         if(this.mInfoBox == null)
         {
            this.mInfoBox = new ESpriteContainer();
            eAddChild(this.mInfoBox);
         }
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopupLayoutLabInfo");
         var img:EImage = mViewFactory.getEImage("tabBody",mSkinSku,false,layoutFactory.getArea("pannel"));
         this.mInfoBox.setContent("pannel",img);
         this.mInfoBox.eAddChild(img);
         img = mViewFactory.getEImage(this.getUnitImageName(),mSkinSku,true,layoutFactory.getArea("cbox_img"));
         this.mInfoBox.setContent("cbox_img",img);
         this.mInfoBox.eAddChild(img);
         var field:ETextField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_item"),"text_title_0");
         this.mInfoBox.setContent("unitName",field);
         this.mInfoBox.eAddChild(field);
         if(mPopupUpgrade.getEvent()["items"])
         {
            field.setText(this.getName() + " x " + mPopupUpgrade.getEvent()["items"].length);
         }
         else
         {
            field.setText(this.getName());
         }
         this.mBottomArea = layoutFactory.getArea("container_requeriments");
         this.mInfoArea = layoutFactory.getArea("container_info");
         this.getFillBars();
      }
      
      protected function createTabs(numTabs:int) : void
      {
         var bkg:ESprite = null;
         var tab:EButton = null;
         var tabs:Vector.<EButton> = null;
         var i:int = 0;
         if(!mIsTutorial)
         {
            bkg = mPopupUpgrade.getBackground();
            tabs = new Vector.<EButton>(numTabs,true);
            this.mTabsCount = numTabs;
            for(i = 0; i < numTabs; )
            {
               tab = this.getTextTabHeader(DCTextMng.replaceParameters(136,["" + (i + 1)]),mSkinSku);
               setContent("tab" + i,tab);
               bkg.eAddChild(tab);
               tabs[i] = tab;
               i++;
            }
            this.mTabsHeaderView = new TabHeadersView(mPopupUpgrade.getTabArea(),mViewFactory,mSkinSku);
            this.mTabsHeaderView.setTabHeaders(tabs);
            this.mPaginator = new EPaginatorComponent();
            this.mPaginator.init(this.mTabsHeaderView,this);
            this.mTabsHeaderView.setPaginatorComponent(this.mPaginator);
         }
      }
      
      protected function setTabProperties() : void
      {
         var i:int = 0;
         var tab:EButton = null;
         var currentUnselectedProp:String = null;
         var unselected:* = false;
         for(i = 0; i < this.mTabsCount; )
         {
            unselected = i != this.mTabsHeaderView.getTabHeaderSelected();
            tab = getContentAsEButton("tab" + i);
            if(tab != null)
            {
               currentUnselectedProp = tab.getUnselectedProp();
               tab.setUnselectedProp(this.getTabProp(i));
               if(unselected)
               {
                  tab.getBackground().unapplySkinProp(mSkinSku,currentUnselectedProp);
                  tab.getBackground().applySkinProp(mSkinSku,tab.getUnselectedProp());
               }
            }
            i++;
         }
      }
      
      protected function setupRequirements() : void
      {
         if(this.mRequirementsBox == null)
         {
            this.mRequirementsBox = new ESpriteContainer();
         }
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("ContainerRequirements");
         var img:EImage = mViewFactory.getEImage("generic_box",mSkinSku,false,layoutFactory.getArea("area"));
         this.mRequirementsBox.setContent("area",img);
         this.mRequirementsBox.eAddChild(img);
         var field:ETextField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_title"),"text_subheader");
         this.mRequirementsBox.setContent("requirements_title",field);
         this.mRequirementsBox.eAddChild(field);
         field.setText(DCTextMng.getText(598));
         eAddChild(this.mRequirementsBox);
         this.mBottomBoxes.push(this.mRequirementsBox);
      }
      
      protected function setupCostWithChipsBox() : void
      {
         var container:ESpriteContainer = new ESpriteContainer();
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("ContainerChips");
         var img:EImage = mViewFactory.getEImage("generic_box",mSkinSku,false,layoutFactory.getArea("area"));
         container.eAddChild(img);
         container.setContent("ChipsBkg",img);
         var field:ETextField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_title"),"text_subheader");
         container.eAddChild(field);
         container.setContent("ChipsTitle",field);
         field.setText(DCTextMng.getText(662));
         field = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_info"),"text_body_2");
         container.eAddChild(field);
         container.setContent("ChipsText",field);
         field.setText(DCTextMng.getText(663));
         var button:EButton = this.getChipsButton(layoutFactory.getArea("ibtn_l"));
         if(button != null)
         {
            container.eAddChild(button);
            container.setContent("ButtonChips",button);
            button.eAddEventListener("click",onInstantUpgradeActivate);
         }
         eAddChild(container);
         this.mBottomBoxes.push(container);
      }
      
      protected function setupCostBox() : void
      {
         var info:ETooltipInfo = null;
         var prop:String = null;
         var itemContainer:ESpriteContainer = null;
         var cost:String = null;
         var tid:int = 0;
         var itemsCount:int = 0;
         var itemData:Array = null;
         var itemAmount:int = 0;
         var itemObject:ItemObject = null;
         var i:int = 0;
         var SEPARATION:int = 20;
         var container:ESpriteContainer = new ESpriteContainer();
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("ContainerCost");
         var img:EImage = mViewFactory.getEImage("generic_box",mSkinSku,false,layoutFactory.getArea("area_use_items"));
         container.eAddChild(img);
         container.setContent("CostBackground",img);
         var field:ETextField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_title"),"text_subheader");
         container.eAddChild(field);
         container.setContent("CostTitle",field);
         field.setText(DCTextMng.getText(659));
         field = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_info"),"text_body_2");
         container.eAddChild(field);
         container.setContent("CostTime",field);
         var text:String = DCTextMng.replaceParameters(660,[GameConstants.getTimeTextFromMs(getCostTime())]);
         field.setText(text);
         var coins:Number = this.getCostCoins();
         var minerals:Number = this.getCostMinerals();
         var items:Array = this.getCostItems();
         var containers:Array = [];
         var profile:Profile = InstanceMng.getUserInfoMng().getProfileLogin();
         if(coins > 0)
         {
            prop = "text_coins";
            if(coins > profile.getCoins())
            {
               prop = "text_negative";
            }
            cost = DCTextMng.convertNumberToString(coins,2,8);
            itemContainer = mViewFactory.getContentIconWithTextVertical("ContainerItemVerticalL","icon_coins",cost,mSkinSku,prop,true);
            mViewFactory.readjustContentIconWithTextVertical(itemContainer);
            containers.push(itemContainer);
            container.eAddChild(itemContainer);
            container.setContent("CostCoins",itemContainer);
         }
         if(minerals > 0)
         {
            prop = "text_minerals";
            if(minerals > profile.getMinerals())
            {
               prop = "text_negative";
            }
            cost = DCTextMng.convertNumberToString(minerals,2,8);
            itemContainer = mViewFactory.getContentIconWithTextVertical("ContainerItemVerticalL","icon_mineral",cost,mSkinSku,prop,true);
            mViewFactory.readjustContentIconWithTextVertical(itemContainer);
            containers.push(itemContainer);
            container.eAddChild(itemContainer);
            container.setContent("CostMinerals",itemContainer);
         }
         if(items != null)
         {
            if((itemsCount = int(items.length)) > 0)
            {
               for(i = 0; i < itemsCount; )
               {
                  itemData = items[i].split(":");
                  itemObject = InstanceMng.getItemsMng().getItemObjectBySku(itemData[0]);
                  itemAmount = int(itemData[1]);
                  cost = itemObject.quantity + "/" + itemAmount;
                  prop = "text_title_3";
                  if(itemAmount > itemObject.quantity)
                  {
                     prop = "text_negative";
                  }
                  itemContainer = mViewFactory.getContentIconWithTextVertical("ContainerItemVerticalL",itemObject.mDef.getAssetId(),cost,mSkinSku,prop,true);
                  mViewFactory.readjustContentIconWithTextVertical(itemContainer);
                  containers.push(itemContainer);
                  container.eAddChild(itemContainer);
                  container.setContent("CostItems" + i,itemContainer);
                  itemContainer.name = "itemBox-" + i;
                  info = ETooltipMng.getInstance().createTooltipInfoFromDef(itemObject.mDef,itemContainer,null,false,false);
                  this.mItemTooltips[itemContainer.name] = info;
                  itemContainer.eAddEventListener("rollOver",showItemTooltip);
                  itemContainer.eAddEventListener("rollOut",hideItemTooltip);
                  i++;
               }
            }
         }
         mViewFactory.distributeSpritesInArea(layoutFactory.getArea("v_icon_text_s"),containers,1,1,containers.length,1,true);
         if(this.getIsUnlocked())
         {
            tid = 601;
         }
         else
         {
            tid = 614;
         }
         cost = DCTextMng.getText(tid);
         var buttonArea:ELayoutArea = layoutFactory.getArea("btn_xxl");
         var button:EButton;
         (button = mViewFactory.getButtonByTextWidth(cost,buttonArea.width,"btn_accept")).layoutApplyTransformations(buttonArea);
         container.eAddChild(button);
         button.eAddEventListener("click",this.onStartUpgradeActivate);
         container.setContent("ButtonStart",button);
         eAddChild(container);
         this.mBottomBoxes.push(container);
      }
      
      protected function createFillBar(title:String, maxValue:Number, currentValue:Number, nextValue:Number, icon:String, numFormat:int = 0) : ESpriteContainer
      {
         var OFFSET:Number = NaN;
         var text:String = null;
         var updateText:String = null;
         var img:EImage = null;
         var SEMIOFFSET:Number = (OFFSET = 4) / 2;
         var container:ESpriteContainer = new ESpriteContainer();
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("ContainerUnitInfo");
         var iconContainer:ESprite;
         (iconContainer = mViewFactory.getContentIconWithTextHorizontal("IconTextXS",icon,title,mSkinSku,"text_body_2")).layoutApplyTransformations(layoutFactory.getArea("icon_text_xs"));
         container.eAddChild(iconContainer);
         container.setContent("icon",iconContainer);
         var fillbarArea:ELayoutArea = layoutFactory.getArea("bar_xs");
         var fillbar:EFillBar = mViewFactory.createFillBar(0,fillbarArea.width,fillbarArea.height,0,"color_fill_bkg");
         container.setContent("fillbarBase",fillbar);
         container.eAddChild(fillbar);
         fillbar.layoutApplyTransformations(fillbarArea);
         (fillbar = mViewFactory.createFillBar(1,fillbarArea.width - OFFSET,fillbarArea.height - OFFSET,maxValue,"color_upgrade")).setValue(nextValue);
         container.setContent("fillbarUpdate",fillbar);
         container.eAddChild(fillbar);
         fillbar.layoutApplyTransformations(fillbarArea);
         fillbar.logicLeft += SEMIOFFSET;
         fillbar.logicTop += SEMIOFFSET;
         (fillbar = mViewFactory.createFillBar(1,fillbarArea.width - OFFSET,fillbarArea.height - OFFSET,maxValue,"color_capacity")).setValue(currentValue);
         container.setContent("fillbarcurrent",fillbar);
         container.eAddChild(fillbar);
         fillbar.layoutApplyTransformations(fillbarArea);
         fillbar.logicLeft += SEMIOFFSET;
         fillbar.logicTop += SEMIOFFSET;
         var field:ETextField = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_value"),"text_capacity");
         container.setContent("text_value",field);
         container.eAddChild(field);
         if(numFormat == 0)
         {
            text = currentValue.toString();
            updateText = nextValue.toString();
         }
         else
         {
            text = GameConstants.getTimeTextFromMs(currentValue,true);
            updateText = GameConstants.getTimeTextFromMs(nextValue,true);
         }
         field.setText(text);
         if(nextValue > currentValue)
         {
            field = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_revalue"),"text_upgrade");
            container.setContent("text_revalue",field);
            container.eAddChild(field);
            field.setText(updateText);
            img = mViewFactory.getEImage("icon_arrow_capacity",mSkinSku,false,layoutFactory.getArea("icon_arrow"));
            container.setContent("arrow",img);
            container.eAddChild(img);
         }
         this.mInfoBox.setContent(title,container);
         this.mInfoBox.eAddChild(container);
         container.setLayoutArea(layoutFactory.getContainerLayoutArea());
         if(this.mFillBars == null)
         {
            this.mFillBars = [];
         }
         this.mFillBars.push(container);
         return container;
      }
      
      protected function setupMessageBox(icon:String, msg:String) : void
      {
         var textProp:String = null;
         var bkgProp:String = null;
         var container:ESpriteContainer = new ESpriteContainer();
         if(icon == "icon_warning")
         {
            textProp = "text_light_negative";
            bkgProp = "box_negative";
         }
         else
         {
            textProp = "text_positive";
            bkgProp = "stripe_player";
         }
         eAddChild(container);
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("WarningStripe");
         container.setLayoutArea(layoutFactory.getContainerLayoutArea());
         var img:EImage = mViewFactory.getEImage(bkgProp,mSkinSku,false,layoutFactory.getArea("stripe"));
         container.eAddChild(img);
         container.setContent("WarningBkg",img);
         img = mViewFactory.getEImage(icon,mSkinSku,true,layoutFactory.getArea("icon"));
         container.eAddChild(img);
         container.setContent("WarningImage",img);
         var field:ETextField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_info"),textProp);
         container.eAddChild(field);
         container.setContent("WarningText",field);
         field.setText(msg);
         this.mBottomBoxes.push(container);
      }
      
      protected function setupDescriptionBox() : void
      {
         var container:ESpriteContainer = new ESpriteContainer();
         eAddChild(container);
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("ContainerCost");
         var img:EImage = mViewFactory.getEImage("generic_box",mSkinSku,false,layoutFactory.getArea("area_use_items"));
         container.eAddChild(img);
         container.setContent("CostBackground",img);
         var field:ETextField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_title"),"text_subheader");
         container.eAddChild(field);
         container.setContent("title",field);
         field.setText(this.getName());
         field = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_unit"),"text_body_2");
         container.eAddChild(field);
         container.setContent("desc",field);
         field.setText(this.getDescription());
         this.mBottomBoxes.push(container);
      }
      
      protected function setupDiscountBox() : void
      {
         var container:ESpriteContainer = new ESpriteContainer();
         this.mBottomBoxes.push(container);
         eAddChild(container);
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("DiscountBox");
         var img:EImage = mViewFactory.getEImage("generic_box",mSkinSku,false,layoutFactory.getArea("area"));
         container.eAddChild(img);
         container.setContent("bkg",img);
         var field:ETextField = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_title"),"text_subheader");
         container.eAddChild(field);
         container.setContent("title",field);
         field.setText(DCTextMng.getText(662));
         field = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_offer"),"text_subheader");
         container.eAddChild(field);
         container.setContent("offer",field);
         field.setText(this.getDiscountText());
         field = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_chips"),"text_body_2");
         container.eAddChild(field);
         container.setContent("chips",field);
         var chips:String = this.getRealPriceText();
         var chipsText:String = DCTextMng.replaceParameters(493,[chips]);
         field.setText(chipsText);
         var scratchArea:ELayoutArea = layoutFactory.getArea("scratch");
         var chipsBound:Rectangle;
         if((chipsBound = field.getStrBoundaries(chips)) != null)
         {
            scratchArea.x = field.logicLeft + chipsBound.x;
         }
         img = mViewFactory.getEImage("scratch",mSkinSku,false,scratchArea);
         container.eAddChild(img);
         container.setContent("scratch",img);
         var button:EButton = this.getChipsButton(layoutFactory.getArea("ibtn_l"));
         container.eAddChild(button);
         container.setContent("button",button);
         button.eAddEventListener("click",onInstantUpgradeActivate);
      }
      
      protected function destroyComponents() : void
      {
         var boxesCount:int = 0;
         var content:ESprite = null;
         var i:int = 0;
         if(this.mInfoBox != null)
         {
            this.mInfoBox.destroy();
            this.mInfoBox = null;
         }
         if(this.mBottomBoxes != null)
         {
            boxesCount = int(this.mBottomBoxes.length);
            for(i = 0; i < boxesCount; )
            {
               content = this.mBottomBoxes[i];
               content.destroy();
               content = null;
               i++;
            }
         }
         if(mUpgradingBox != null)
         {
            mUpgradingBox.destroy();
            mUpgradingBox = null;
         }
         this.mFillBars = null;
      }
      
      override protected function setupUpgradingBox() : void
      {
         super.setupUpgradingBox();
         this.mBottomBoxes.push(mUpgradingBox);
      }
      
      private function getTextTabHeader(text:String, skinSku:String = null, tabProp:String = null) : EButton
      {
         var button:EButton;
         (button = mViewFactory.getTextTabHeaderPopup(text,skinSku)).setUnselectedProp(tabProp);
         if(tabProp == "old_tab")
         {
            button.setTextProp("text_old_tab");
         }
         return button;
      }
      
      protected function getChipsButton(buttonArea:ELayoutArea) : EButton
      {
         var button:EButton = mViewFactory.getButtonChips(getPayButtonText(),buttonArea,mSkinSku);
         button.layoutApplyTransformations(buttonArea);
         return button;
      }
      
      protected function getBuildingIcon(sku:String, neededLevel:int) : String
      {
         var def:WorldItemDef = InstanceMng.getWorldItemDefMng().getDefBySkuAndUpgradeId(sku,neededLevel);
         return def.getAssetId() + "_ready";
      }
      
      protected function getCostCoins() : Number
      {
         return 0;
      }
      
      protected function getCostMinerals() : Number
      {
         return 0;
      }
      
      protected function getCostItems() : Array
      {
         return null;
      }
      
      protected function getIsUnlocking() : Boolean
      {
         return false;
      }
      
      protected function getIsUnlocked() : Boolean
      {
         return true;
      }
      
      protected function getIsUpgrading() : Boolean
      {
         return false;
      }
      
      protected function getUpgradeId() : int
      {
         return 0;
      }
      
      protected function getFillBars() : void
      {
      }
      
      protected function getName() : String
      {
         return null;
      }
      
      protected function getDescription() : String
      {
         return null;
      }
      
      protected function getUnitImageName() : String
      {
         return null;
      }
      
      public function setPageId(pc:EPaginatorComponent, id:int) : void
      {
      }
      
      protected function setupBottom() : void
      {
      }
      
      protected function getDiscountText() : String
      {
         return null;
      }
      
      protected function getRealPriceText() : String
      {
         return null;
      }
      
      public function startUpgradeActivate(transaction:Transaction) : void
      {
      }
      
      protected function getTabProp(id:int) : String
      {
         return null;
      }
      
      protected function onStartUpgradeActivate(e:EEvent) : void
      {
      }
      
      protected function showItemTooltip(e:EEvent) : void
      {
         var itemContainer:ESpriteContainer = e.getTarget() as ESpriteContainer;
         this.mCurrentItemTooltip = ETooltipMng.getInstance().showTooltip(this.mItemTooltips[itemContainer.name]);
      }
      
      protected function hideItemTooltip(e:EEvent) : void
      {
         ETooltipMng.getInstance().removeTooltip(this.mCurrentItemTooltip);
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var boxesCount:int = 0;
         var content:ESprite = null;
         var i:int = 0;
         super.logicUpdate(dt);
         if(this.mInfoBox != null)
         {
            this.mInfoBox.logicUpdate(dt);
         }
         if(this.mBottomBoxes != null)
         {
            boxesCount = int(this.mBottomBoxes.length);
            for(i = 0; i < boxesCount; )
            {
               (content = this.mBottomBoxes[i]).logicUpdate(dt);
               i++;
            }
         }
      }
   }
}
