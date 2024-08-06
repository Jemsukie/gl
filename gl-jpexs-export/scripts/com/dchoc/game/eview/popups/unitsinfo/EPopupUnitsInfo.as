package com.dchoc.game.eview.popups.unitsinfo
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.eview.widgets.paginator.TabHeadersView;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.game.model.world.ship.ShipDef;
   import com.dchoc.game.model.world.ship.ShipDefMng;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.def.DCDef;
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
   
   public class EPopupUnitsInfo extends EGamePopup implements EPaginatorController
   {
       
      
      private const BODY:String = "Body";
      
      private const TEXT_DESCRIPTION:String = "textDescription";
      
      private const ARROW_PREVIOUS:String = "arrowPrevious";
      
      private const ARROW_NEXT:String = "arrowNext";
      
      private const FILLBAR_TEXT_VALUE:String = "text_value";
      
      private const UNIT_TYPES:Array = [2,3,0];
      
      private const TARGET_TYPE_BOTH:int = 0;
      
      private const TARGET_TYPE_GROUND:int = 1;
      
      private const TARGET_TYPE_AIR:int = 2;
      
      private const DAMAGE_TYPE_BLAST:int = 0;
      
      private const DAMAGE_TYPE_SHOT:int = 1;
      
      private const DAMAGE_TYPE_BURST:int = 2;
      
      private const PAGE_SOLDIERS:int = 0;
      
      private const PAGE_MECHAS:int = 1;
      
      private const PAGE_SHIPS:int = 2;
      
      private const PAGE_DEFENSES:int = 3;
      
      private const NUM_PAGES:int = 4;
      
      private var mTabsArea:ELayoutArea;
      
      private var mTabs:Vector.<EButton>;
      
      private var mTabView:TabHeadersView;
      
      private var mPaginator:EPaginatorComponent;
      
      private var mCurrentPage:int;
      
      private var mGameUnits:Vector.<DCDef>;
      
      private var mCurrentDefId:int;
      
      private var mTotalDefs:int;
      
      private var mDescriptionBox:ESpriteContainer;
      
      private var mTargetsBox:ESpriteContainer;
      
      private var mTargetsContainer:ESpriteContainer;
      
      private var mInfoBox:ESpriteContainer;
      
      private var mFillBars:Array;
      
      private var mBarsArea:ELayoutArea;
      
      private var mTargetsArea:ELayoutArea;
      
      public function EPopupUnitsInfo()
      {
         super();
      }
      
      public function setupPopup(sku:String) : void
      {
         var index:int = 0;
         this.setupBackground("PopXLTabsNoFooter","pop_xl_no_buttons");
         this.createTabs();
         this.setupBoxes();
         var def:DCDef = InstanceMng.getWorldItemDefMng().getDefBySku(sku);
         if(def == null)
         {
            def = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getGameUnitBySku(sku).mDef;
         }
         var found:Boolean = false;
         var i:int = 0;
         while(i < 4 && !found)
         {
            this.getGameUnits(i);
            if((index = this.mGameUnits.indexOf(def)) > -1)
            {
               this.mCurrentDefId = index;
               this.mCurrentPage = i;
               this.setCurrentDef();
               this.mTabView.setPageId(this.mCurrentPage);
               found = true;
            }
            i++;
         }
         if(!found)
         {
            this.mCurrentPage = -1;
            this.setPageId(null,0);
         }
         this.checkArrows();
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         this.mInfoBox.destroy();
         this.mInfoBox = null;
         this.mTargetsContainer.destroy();
         this.mTargetsContainer = null;
      }
      
      protected function setupBackground(layoutName:String, background:String) : void
      {
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory(layoutName);
         setLayoutArea(layoutFactory.getContainerLayoutArea());
         var bkg:EImage = mViewFactory.getEImage(background,null,false,layoutFactory.getArea("bg"));
         setBackground(bkg);
         eAddChild(bkg);
         var field:ETextField = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_title"),"text_header");
         setTitle(field);
         bkg.eAddChild(field);
         var button:EButton = mViewFactory.getButtonClose(null,layoutFactory.getArea("btn_close"));
         setCloseButton(button);
         bkg.eAddChild(button);
         button.eAddEventListener("click",this.onCloseClick);
         var body:ESprite = mViewFactory.getEImage("tabBody",null,false,layoutFactory.getArea("body"));
         bkg.eAddChild(body);
         setContent("Body",body);
         this.mTabsArea = layoutFactory.getArea("tab");
      }
      
      private function createTabs() : void
      {
         if(this.mTabs == null)
         {
            this.mTabs = new Vector.<EButton>(0);
         }
         else
         {
            this.mTabs.length = 0;
         }
         var tab:EButton = mViewFactory.getTextTabHeaderPopup(DCTextMng.getText(684));
         eAddChild(tab);
         setContent("tabSoldiers",tab);
         this.mTabs.push(tab);
         tab = mViewFactory.getTextTabHeaderPopup(DCTextMng.getText(685));
         eAddChild(tab);
         setContent("tabMechas",tab);
         this.mTabs.push(tab);
         tab = mViewFactory.getTextTabHeaderPopup(DCTextMng.getText(686));
         eAddChild(tab);
         setContent("tabShips",tab);
         this.mTabs.push(tab);
         tab = mViewFactory.getTextTabHeaderPopup(DCTextMng.getText(526));
         eAddChild(tab);
         setContent("tabDefenses",tab);
         this.mTabs.push(tab);
         this.mTabView = new TabHeadersView(this.mTabsArea,mViewFactory,null);
         this.mTabView.setTabHeaders(this.mTabs);
         this.mPaginator = new EPaginatorComponent();
         this.mPaginator.init(this.mTabView,this);
         this.mTabView.setPaginatorComponent(this.mPaginator);
      }
      
      private function setupBoxes() : void
      {
         var body:ESprite = getContent("Body");
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopupLayoutLabInfo");
         var boxes:Array = [];
         var bottomArea:ELayoutArea = layoutFactory.getArea("container_requeriments");
         this.mBarsArea = layoutFactory.getArea("container_info");
         var infoArea:ELayoutArea = layoutFactory.getArea("pannel");
         var button:EButton = mViewFactory.getButtonImage("btn_arrow",null);
         body.eAddChild(button);
         button.logicTop = infoArea.height / 2;
         button.scaleLogicX *= -1;
         button.name = "arrowPrevious";
         button.getBackground().onSetTextureLoaded = this.locateArrow;
         setContent("arrowPrevious",button);
         button.eAddEventListener("click",this.onPrevious);
         button = mViewFactory.getButtonImage("btn_arrow",null);
         body.eAddChild(button);
         button.logicTop = (infoArea.height - button.width) / 2;
         button.logicLeft = infoArea.width;
         button.name = "arrowNext";
         setContent("arrowNext",button);
         button.eAddEventListener("click",this.onNext);
         button.getBackground().onSetTextureLoaded = this.locateArrow;
         layoutFactory = mViewFactory.getLayoutAreaFactory("ContainerCost");
         this.mDescriptionBox = new ESpriteContainer();
         body.eAddChild(this.mDescriptionBox);
         setContent("description",this.mDescriptionBox);
         var descArea:ELayoutArea = layoutFactory.getArea("area_use_items");
         this.mTargetsArea = descArea;
         var img:EImage = mViewFactory.getEImage("generic_box",null,false,descArea);
         this.mDescriptionBox.eAddChild(img);
         this.mDescriptionBox.setContent("bkg",img);
         var field:ETextField = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_unit"),"text_body_2");
         this.mDescriptionBox.eAddChild(field);
         this.mDescriptionBox.setContent("textDescription",field);
         this.mDescriptionBox.setLayoutArea(descArea);
         boxes.push(this.mDescriptionBox);
         this.mTargetsBox = new ESpriteContainer();
         body.eAddChild(this.mTargetsBox);
         setContent("targetsBox",this.mTargetsBox);
         layoutFactory = mViewFactory.getLayoutAreaFactory("ContainerCost");
         img = mViewFactory.getEImage("generic_box",null,false,descArea);
         this.mTargetsBox.eAddChild(img);
         this.mTargetsBox.setContent("bkg",img);
         boxes.push(this.mTargetsBox);
         mViewFactory.distributeSpritesInArea(bottomArea,boxes,0,1,boxes.length,1,true);
      }
      
      private function checkArrows() : void
      {
         var button:EButton = null;
         button = getContentAsEButton("arrowPrevious");
         button.setIsEnabled(true);
         button = getContentAsEButton("arrowNext");
         button.setIsEnabled(true);
         if(this.mCurrentDefId == 0)
         {
            button = getContentAsEButton("arrowPrevious");
            button.setIsEnabled(false);
         }
         if(this.mCurrentDefId == this.mTotalDefs - 1)
         {
            button = getContentAsEButton("arrowNext");
            button.setIsEnabled(false);
         }
      }
      
      private function locateArrow(img:EImage) : void
      {
         if(img.name == "arrowPrevious")
         {
            img.logicLeft += img.width;
         }
         else
         {
            img.logicLeft -= img.width;
         }
      }
      
      private function setDescription(text:String) : void
      {
         var field:ETextField = this.mDescriptionBox.getContentAsETextField("textDescription");
         if(field != null)
         {
            field.setText(text);
         }
      }
      
      public function setPageId(pc:EPaginatorComponent, id:int) : void
      {
         if(this.mCurrentPage != id)
         {
            this.mCurrentPage = id;
            this.getGameUnits(this.mCurrentPage);
            this.mCurrentDefId = 0;
            this.setCurrentDef();
            this.checkArrows();
         }
      }
      
      private function getGameUnits(id:int) : void
      {
         if(id != 3)
         {
            this.mGameUnits = InstanceMng.getShipyardController().getShipsInfo(ShipDefMng.TYPE_SKUS[this.UNIT_TYPES[id]]);
         }
         else
         {
            this.mGameUnits = InstanceMng.getBuildingsShopController().getShopResourcesInfo("1");
         }
         this.mTotalDefs = this.mGameUnits.length;
      }
      
      private function setupInfoUnit(shipDef:ShipDef) : void
      {
         var dmg:ESpriteContainer = null;
         var field:ETextField = null;
         var specialLayoutFactory:ELayoutAreaFactory = null;
         var specialContainer:ESpriteContainer = null;
         var itemsContainer:ESpriteContainer = null;
         var item:ESprite = null;
         var offset:Number = NaN;
         var barsArea:ELayoutArea = null;
         var typeUnit:int = 0;
         var body:ESprite = getContent("Body");
         this.setDescription(shipDef.getDescToDisplay());
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopupLayoutLabInfo");
         if(this.mInfoBox != null)
         {
            this.mInfoBox.destroy();
            this.mInfoBox = null;
         }
         if(this.mFillBars == null)
         {
            this.mFillBars = [];
         }
         else
         {
            this.mFillBars.length = 0;
         }
         this.mInfoBox = new ESpriteContainer();
         body.eAddChild(this.mInfoBox);
         setContent("infoBox",this.mInfoBox);
         var img:EImage = mViewFactory.getEImage(shipDef.getIcon(),null,true,layoutFactory.getArea("cbox_img"));
         this.mInfoBox.setContent("img",img);
         this.mInfoBox.eAddChild(img);
         var maxDef:ShipDef = InstanceMng.getGameUnitMngController().getGameUnitMng().getGameUnitBySku(shipDef.mSku).getMaxDef();
         this.createFillBar(DCTextMng.getText(543),maxDef.getMaxEnergy(),shipDef.getMaxEnergy(),"icon_health");
         if(shipDef.getShotDamage() > 0)
         {
            dmg = this.createFillBar(DCTextMng.getText(539),maxDef.getShotDamage(),shipDef.getShotDamage(),"icon_damage");
            if(shipDef.getShotBurstLength() > 1)
            {
               field = null;
               (field = dmg.getContentAsETextField("text_value")).setText(String(shipDef.getShotDamage()) + " X" + String(shipDef.getShotBurstLength()));
            }
         }
         else
         {
            this.createFillBar(DCTextMng.getText(712),-maxDef.getShotDamage(),-shipDef.getShotDamage(),"icon_heal");
         }
         this.createFillBar(DCTextMng.getText(552),maxDef.getSpeed(),shipDef.getSpeed(),"icon_speed");
         this.createFillBar(DCTextMng.getText(550),maxDef.getShotDistance(),shipDef.getShotDistance(),"icon_range");
         this.createFillBar(DCTextMng.getText(545),maxDef.getShotSpeed(),shipDef.getShotSpeed(),"icon_rate");
         if(shipDef.getConstructionCoins() > 0)
         {
            this.createFillBar(DCTextMng.getText(627),maxDef.getConstructionCoins(),shipDef.getConstructionCoins(),"icon_bag_coins");
         }
         else
         {
            this.createFillBar(DCTextMng.getText(627),maxDef.getConstructionMineral(),shipDef.getConstructionMineral(),"icon_bag_minerals");
         }
         this.createFillBar(DCTextMng.getText(54),maxDef.getConstructionTime(),shipDef.getConstructionTime(),"icon_clock",1);
         var useNormalDistribution:Boolean = true;
         if(shipDef.shotEffectsNeedsToShowInfo())
         {
            useNormalDistribution = false;
            specialLayoutFactory = mViewFactory.getLayoutAreaFactory("SpecialInfoBox");
            specialContainer = mViewFactory.getESpriteContainer();
            itemsContainer = mViewFactory.getESpriteContainer();
            offset = 0;
            mInfoBox.eAddChild(specialContainer);
            mInfoBox.setContent("SpecialInfo",specialContainer);
            specialContainer.setLayoutArea(specialLayoutFactory.getContainerLayoutArea());
            img = mViewFactory.getEImage("generic_box",mSkinSku,false,specialLayoutFactory.getArea("area_info"));
            specialContainer.eAddChild(img);
            specialContainer.setContent("background",img);
            field = mViewFactory.getETextField(mSkinSku,specialLayoutFactory.getTextArea("text_title"),"text_body_2");
            specialContainer.eAddChild(field);
            specialContainer.setContent("text",field);
            field.setText(shipDef.getTextSpecial());
            specialContainer.eAddChild(itemsContainer);
            specialContainer.setContent("specialItemsContainer",itemsContainer);
            if(shipDef.shotEffectsBurnIsOn())
            {
               item = mViewFactory.getContentIconWithTextHorizontal("IconTextXS","icon_clock",DCTextMng.getText(4096) + " " + GameConstants.getTimeTextFromMs(shipDef.shotEffectsGetBurnMaxDuration()),mSkinSku,"text_body_2");
               itemsContainer.eAddChild(item);
               itemsContainer.setContent("specialItem1",item);
               item.logicLeft = 0;
               offset += item.width;
               item = mViewFactory.getContentIconWithTextHorizontal("IconTextXS","icon_flame",shipDef.shotEffectsGetBurnMinTemperature() + " - " + shipDef.shotEffectsGetBurnMaxTemperature(),mSkinSku,"text_body_2");
               itemsContainer.eAddChild(item);
               itemsContainer.setContent("specialItem2",item);
               item.logicLeft = offset;
               itemsContainer.layoutApplyTransformations(specialLayoutFactory.getArea("container_icon_text_xs"));
            }
            (barsArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(this.mBarsArea)).height = this.mBarsArea.height - specialContainer.getLogicHeight();
            mViewFactory.distributeSpritesInArea(barsArea,this.mFillBars,1,1,1,this.mFillBars.length,true);
            this.mFillBars.push(specialContainer);
            specialContainer.x = barsArea.x;
            specialContainer.y = barsArea.y + barsArea.height;
         }
         if(useNormalDistribution)
         {
            mViewFactory.distributeSpritesInArea(this.mBarsArea,this.mFillBars,1,1,1,this.mFillBars.length,true);
         }
         var ground:Boolean = shipDef.getAttackGroundUnits();
         var air:Boolean = shipDef.getAttackAirUnits();
         if(ground && air)
         {
            typeUnit = 0;
         }
         else if(ground)
         {
            typeUnit = 1;
         }
         else
         {
            typeUnit = 2;
         }
         var damageType:int = 1;
         if(shipDef.getBlastRadius() > 0)
         {
            damageType = 0;
         }
         if(shipDef.getShotBurstLength() > 1)
         {
            damageType = 2;
         }
         this.getTargetInfo(damageType,typeUnit,shipDef.getSize(),DCTextMng.getText(shipDef.getShotPriorityTargetTooltipTid()));
      }
      
      private function getTargetInfo(damageType:int, targetUnit:int = -1, size:int = -1, targetType:String = null) : void
      {
         var content:ESpriteContainer = null;
         if(this.mTargetsContainer != null)
         {
            this.mTargetsContainer.destroy();
            this.mTargetsContainer = null;
         }
         this.mTargetsContainer = new ESpriteContainer();
         this.mTargetsBox.eAddChild(this.mTargetsContainer);
         setContent("targetsCont",this.mTargetsContainer);
         var boxes:Array = [];
         var text:* = targetType;
         var icon:String = "icon_target";
         if(targetType != null)
         {
            content = mViewFactory.getContentIconWithTwoTextsHorizontal("HIconTwoTextsXS",icon,DCTextMng.getText(172),text,null,"text_header","text_body_2",true,false);
            this.mTargetsContainer.eAddChild(content);
            this.mTargetsContainer.setContent("target",content);
            boxes.push(content);
         }
         if(targetUnit > -1)
         {
            if(targetUnit == 0)
            {
               text = DCTextMng.getText(587);
               icon = "icon_target";
            }
            else if(targetUnit == 1)
            {
               text = DCTextMng.getText(589);
               icon = "icon_target_ground";
            }
            else if(targetUnit == 2)
            {
               text = DCTextMng.getText(588);
               icon = "icon_target_air";
            }
            content = mViewFactory.getContentIconWithTwoTextsHorizontal("HIconTwoTextsXS",icon,DCTextMng.getText(551),text,null,"text_header","text_body_2",true,false);
            this.mTargetsContainer.eAddChild(content);
            this.mTargetsContainer.setContent("targetUnit",content);
            boxes.push(content);
         }
         switch(damageType)
         {
            case 0:
               text = DCTextMng.getText(541);
               icon = "icon_damage_type_blast";
               break;
            case 1:
               text = DCTextMng.getText(542);
               icon = "icon_damage_type_shot";
               break;
            case 2:
               text = DCTextMng.getText(4094);
               icon = "icon_damage_type_shot";
               break;
            default:
               text = DCTextMng.getText(542);
               icon = "icon_damage_type_shot";
         }
         content = mViewFactory.getContentIconWithTwoTextsHorizontal("HIconTwoTextsXS",icon,DCTextMng.getText(540),text,null,"text_header","text_body_2",true,false);
         this.mTargetsContainer.eAddChild(content);
         this.mTargetsContainer.setContent("damage",content);
         boxes.push(content);
         if(size > -1)
         {
            icon = "icon_hangar";
            text = size.toString();
            content = mViewFactory.getContentIconWithTwoTextsHorizontal("HIconTwoTextsXS",icon,DCTextMng.getText(553),text,null,"text_header","text_body_2",true,false);
            this.mTargetsContainer.eAddChild(content);
            this.mTargetsContainer.setContent("size",content);
            boxes.push(content);
         }
         mViewFactory.distributeSpritesInArea(this.mTargetsArea,boxes,1,1,1,boxes.length,true);
      }
      
      private function setupInfoDefense(wioDef:WorldItemDef) : void
      {
         var typeUnit:int = 0;
         var specialContainer:ESpriteContainer = null;
         var field:ETextField = null;
         var itemsContainer:ESpriteContainer = null;
         var offset:Number = NaN;
         var item:ESprite = null;
         var maxDef:WorldItemDef = wioDef.getMaxDef();
         var body:ESprite = getContent("Body");
         this.setDescription(wioDef.getDescToDisplay());
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopupLayoutLabInfo");
         if(this.mInfoBox != null)
         {
            this.mInfoBox.destroy();
            this.mInfoBox = null;
         }
         this.mInfoBox = new ESpriteContainer();
         body.eAddChild(this.mInfoBox);
         setContent("infoBox",this.mInfoBox);
         if(this.mFillBars == null)
         {
            this.mFillBars = [];
         }
         else
         {
            this.mFillBars.length = 0;
         }
         var img:EImage = mViewFactory.getEImage(wioDef.getAssetId() + "_tooltip",null,true,layoutFactory.getArea("cbox_img"));
         this.mInfoBox.setContent("img",img);
         this.mInfoBox.eAddChild(img);
         var text1:String = DCTextMng.convertNumberToString(wioDef.getMaxEnergy(),-1,-1);
         this.createWIOFillBar(DCTextMng.getText(543),maxDef.getMaxEnergyProgressBar(),wioDef.getMaxEnergyProgressBar(),"icon_health",text1);
         var maxValue:Number = maxDef.getShotDistance();
         var currentValue:Number = wioDef.getShotDistance();
         text1 = wioDef.getShotDistance().toString();
         this.createWIOFillBar(DCTextMng.getText(550),maxValue,currentValue,"icon_range",text1);
         if(wioDef.getShotDamage() > 0)
         {
            maxValue = maxDef.getShotDamage();
            currentValue = wioDef.getShotDamage();
            text1 = DCTextMng.convertNumberToString(wioDef.getShotDamage(),1,7);
            this.createWIOFillBar(DCTextMng.getText(539),maxValue,currentValue,"icon_damage",text1);
         }
         maxValue = maxDef.getShotSpeed();
         currentValue = wioDef.getShotSpeed();
         this.createWIOFillBar(DCTextMng.getText(545),maxValue,currentValue,"icon_rate");
         if(wioDef.shotEffectsNeedsToShowInfo())
         {
            layoutFactory = mViewFactory.getLayoutAreaFactory("SpecialInfoBox");
            specialContainer = new ESpriteContainer();
            this.mInfoBox.eAddChild(specialContainer);
            this.mInfoBox.setContent("SpecialInfo",specialContainer);
            specialContainer.setLayoutArea(layoutFactory.getContainerLayoutArea());
            img = mViewFactory.getEImage("generic_box",mSkinSku,false,layoutFactory.getArea("area_info"));
            specialContainer.eAddChild(img);
            specialContainer.setContent("background",img);
            field = mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_title"),"text_body_2");
            specialContainer.eAddChild(field);
            specialContainer.setContent("text",field);
            field.setText(wioDef.getTextSpecial());
            itemsContainer = new ESpriteContainer();
            specialContainer.eAddChild(itemsContainer);
            specialContainer.setContent("specialItemsContainer",itemsContainer);
            offset = 0;
            if(wioDef.shotEffectsSlowDownIsOn())
            {
               item = mViewFactory.getContentIconWithTextHorizontal("IconTextXS","icon_clock",GameConstants.getTimeTextFromMs(wioDef.shotEffectsGetSlowDownTime()),mSkinSku,"text_body_2");
               itemsContainer.eAddChild(item);
               itemsContainer.setContent("specialItem1",item);
               item.logicLeft = 0;
               offset += item.width;
               if(wioDef.shotEffectsGetSlowDownSpeedPercent() != 0)
               {
                  item = mViewFactory.getContentIconWithTextHorizontal("IconTextXS","icon_speed",this.getStringFromAbility(wioDef.shotEffectsGetSlowDownSpeedPercent()),mSkinSku,"text_body_2");
                  itemsContainer.eAddChild(item);
                  itemsContainer.setContent("specialItem2",item);
                  item.logicLeft = offset;
                  offset += item.width;
               }
               if(wioDef.shotEffectsGetSlowDownRatePercent() != 0)
               {
                  item = mViewFactory.getContentIconWithTextHorizontal("IconTextXS","icon_rate",this.getStringFromAbility(wioDef.shotEffectsGetSlowDownRatePercent()),mSkinSku,"text_body_2");
                  itemsContainer.eAddChild(item);
                  itemsContainer.setContent("specialItem3",item);
                  item.logicLeft = offset;
               }
               itemsContainer.layoutApplyTransformations(layoutFactory.getArea("container_icon_text_xs"));
               this.mFillBars.push(specialContainer);
            }
         }
         mViewFactory.distributeSpritesInArea(this.mBarsArea,this.mFillBars,1,1,1,this.mFillBars.length,true);
         var ground:Boolean = wioDef.getAttackGroundUnits();
         var air:Boolean = wioDef.getAttackAirUnits();
         if(ground && air)
         {
            typeUnit = 0;
         }
         else if(ground)
         {
            typeUnit = 1;
         }
         else
         {
            typeUnit = 2;
         }
         var damageType:int = 1;
         if(wioDef.getBlastRadius() > 0)
         {
            damageType = 0;
         }
         if(wioDef.getShotBurstLength() > 1)
         {
            damageType = 2;
         }
         this.getTargetInfo(damageType,typeUnit);
      }
      
      private function getStringFromAbility(value:Number) : String
      {
         var str:String = (value > 0 ? "-" : "") + value.toFixed();
         var dotIndex:int = str.indexOf(".");
         if(dotIndex > -1)
         {
            str = str.replace(".","");
         }
         return str + "%";
      }
      
      private function createFillBar(title:String, maxValue:Number, currentValue:Number, icon:String, numFormat:int = 0) : ESpriteContainer
      {
         var OFFSET:Number = NaN;
         var text:String = null;
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
         }
         else
         {
            text = GameConstants.getTimeTextFromMs(currentValue,true);
         }
         field.setText(text);
         this.mInfoBox.setContent(title,container);
         this.mInfoBox.eAddChild(container);
         this.mFillBars.push(container);
         return container;
      }
      
      private function createWIOFillBar(text:String, maxValue:Number, currentValue:Number, icon:String, text1:String = null, format:int = 0) : void
      {
         var field:ETextField = null;
         var fillbar:ESpriteContainer = this.createFillBar(text,maxValue,currentValue,icon,format);
         if(text1 != null)
         {
            if((field = fillbar.getContentAsETextField("text_value")) != null)
            {
               field.setText(text1);
            }
         }
      }
      
      private function setCurrentDef() : void
      {
         if(this.mCurrentPage == 3)
         {
            this.setupInfoDefense(this.mGameUnits[this.mCurrentDefId] as WorldItemDef);
         }
         else
         {
            this.setupInfoUnit(this.mGameUnits[this.mCurrentDefId] as ShipDef);
         }
      }
      
      private function onCloseClick(e:EEvent) : void
      {
         InstanceMng.getUIFacade().closePopup(this);
      }
      
      private function onPrevious(e:EEvent) : void
      {
         if(this.mCurrentDefId > 0)
         {
            this.mCurrentDefId--;
            this.setCurrentDef();
            this.checkArrows();
         }
      }
      
      private function onNext(e:EEvent) : void
      {
         if(this.mCurrentDefId < this.mTotalDefs - 1)
         {
            this.mCurrentDefId++;
            this.setCurrentDef();
            this.checkArrows();
         }
      }
   }
}
