package com.dchoc.game.eview.popups.embassy
{
   import com.dchoc.game.controller.alliances.AlliancesControllerStar;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.eview.widgets.paginator.TabHeadersView;
   import com.dchoc.game.eview.widgets.premiumShop.TabBodyPremiumShop;
   import com.dchoc.game.eview.widgets.smallStructures.IconBar;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.game.model.alliances.Alliance;
   import com.dchoc.game.model.alliances.AlliancesUser;
   import com.dchoc.game.model.items.ItemsDef;
   import com.dchoc.game.model.rule.AlliancesLevelDef;
   import com.dchoc.game.model.shop.ShopDef;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.view.gui.popups.DCIPopup;
   import esparragon.display.EImage;
   import esparragon.display.EScrollArea;
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
   
   public class EPopupEmbassy extends EGamePopup implements EPaginatorController
   {
      
      private static const BODY_SKU:String = "body";
      
      private static const CONTENT_SKU:String = "content";
      
      private static const BODY_CONTENT_SKU:String = "container_prizes";
      
      private static const SCROLL_CONTAINER_SKU:String = "scrollArea";
      
      private static const BOX_CONTENT:String = "box_";
      
      private static const BADGES_BAR:String = "bar";
      
      private static const TAB_CONTENT:String = "tab_content";
      
      private static const TAB_BUTTON:String = "tab_button_";
      
      private static const NUM_VISIBLE_BOXES:int = 3;
      
      private static const MAX_BOXES:int = 6;
      
      private static const INFO_AREA_PADDING:int = 10;
      
      private static const INFO_AREA_OFFSET_Y:int = 45;
      
      private static const TAB_TITLE_IDS:Vector.<int> = new <int>[3707,3709,4045,4047];
      
      private static const TAB_DESC_IDS:Vector.<int> = new <int>[3708,3710,4046,4048];
       
      
      private var mTabHeader:TabHeadersView;
      
      private var mPaginatorComponent:EPaginatorComponent;
      
      private var mCurrentPage:int = -1;
      
      private var mCurrentPageName:String = "";
      
      private var mAreaToScroll:ELayoutArea;
      
      private var mBoxContainer:ESpriteContainer;
      
      private var mAllianceController:AlliancesControllerStar;
      
      private var mUserAlliance:Alliance;
      
      private var mUser:AlliancesUser;
      
      private var mEmbassyDefs:Vector.<ItemsDef>;
      
      private var mScrollArea:EScrollArea;
      
      public function EPopupEmbassy(wio:WorldItemObject)
      {
         mBoxContainer = new ESpriteContainer();
         mEmbassyDefs = new Vector.<ItemsDef>(0);
         super();
         this.buildEmbassyDefs();
         this.mAllianceController = InstanceMng.getAlliancesController() as AlliancesControllerStar;
         this.mUserAlliance = this.mAllianceController.getMyAlliance();
         this.mUser = this.mAllianceController.getMyUser();
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
      }
      
      public function setupBackground(popupId:String, viewFactory:ViewFactory, skinId:String) : void
      {
         super.setup(popupId,viewFactory,skinId);
         var layoutFactory:ELayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory("PopXLTabsNoFooter");
         setLayoutArea(layoutFactory.getArea("bg"),true);
         var bkg:EImage = this.mViewFactory.getEImage("pop_xl_no_buttons",mSkinSku,false,layoutFactory.getArea("bg"));
         eAddChild(bkg);
         setBackground(bkg);
         var field:ETextField = this.mViewFactory.getETextField(mSkinSku,layoutFactory.getTextArea("text_title"),"text_header");
         bkg.eAddChild(field);
         setTitle(field);
         setTitleText(DCTextMng.getText(1033));
         var button:EButton = this.mViewFactory.getButtonImage("btn_info",null,layoutFactory.getArea("btn_info"));
         bkg.eAddChild(button);
         setContent("infoButton",button);
         button.eAddEventListener("click",this.onHelpButton);
      }
      
      public function build() : void
      {
         var espc:ESpriteContainer = null;
         var logo:Array = null;
         var flag:ESprite = null;
         var button:EButton = null;
         var bkg:ESprite = getBackground();
         var layoutFactory:ELayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory("PopXLTabsNoFooter");
         var layoutFactoryContent:ELayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory("LayoutBodyAllianceRewards");
         var containerContent:ESpriteContainer = new ESpriteContainer();
         var areaBody:ELayoutArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layoutFactory.getArea("body"));
         var body:ESprite = this.mViewFactory.getEImage("tabBody",mSkinSku,false,areaBody);
         bkg.eAddChild(body);
         setContent("body",body);
         button = this.mViewFactory.getButtonClose(mSkinSku,layoutFactory.getArea("btn_close"));
         bkg.eAddChild(button);
         setCloseButton(button);
         button.eAddEventListener("click",notifyPopupMngClose);
         var page:TabBodyPremiumShop;
         (page = new TabBodyPremiumShop(this.mViewFactory,mSkinSku,false)).setup();
         setContent("tab_content",page);
         this.mAreaToScroll = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layoutFactoryContent.getArea("container_prizes"));
         var items:Vector.<ItemsDef>;
         var itemsCount:int = int((items = this.getEmbassyDefs()).length);
         this.mScrollArea = new EScrollArea();
         this.mScrollArea.build(this.mAreaToScroll,Math.ceil(itemsCount / 3),ESpriteContainer,this.buildBoxes);
         this.mViewFactory.getEScrollBar(this.mScrollArea);
         this.mBoxContainer.eAddChild(this.mScrollArea);
         containerContent.setContent("scrollArea_1",this.mBoxContainer);
         containerContent.eAddChild(this.mBoxContainer);
         var infoArea:ELayoutArea;
         (infoArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layoutFactoryContent.getArea("container_info"))).y = 45;
         var img:EImage = this.mViewFactory.getEImage("generic_box",null,false,infoArea);
         containerContent.setContent("infoBackground",img);
         containerContent.eAddChild(img);
         infoArea.centerContent(img);
         containerContent.layoutApplyTransformations(ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layoutFactory.getArea("tab")));
         var infoItems:Array = [];
         img = this.mViewFactory.getEImageProfileFromURL(InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj().getThumbnailURL(),null,null);
         containerContent.eAddChild(img);
         containerContent.setContent("userPicture",img);
         infoItems.push(img);
         var bar:IconBar;
         (bar = this.mViewFactory.getIconBar(null,"IconBarHudL","color_score","icon_user_badges")).scaleLogicX = 1.4;
         bar.scaleLogicY = 1.4;
         ETooltipMng.getInstance().createTooltipInfoFromText(DCTextMng.getText(3845),bar,null,true,false);
         containerContent.eAddChild(bar);
         containerContent.setContent("bar",bar);
         infoItems.push(bar);
         if(this.mUserAlliance != null)
         {
            (espc = this.getAllianceLevelBar()).scaleLogicX = 0.85;
            espc.scaleLogicY = 0.85;
            containerContent.eAddChild(espc);
            containerContent.setContent("allianceBar",espc);
            infoItems.push(espc);
            logo = this.mUserAlliance.getLogo();
            (flag = this.mAllianceController.getAllianceFlag(logo[0],logo[1],logo[2])).scaleLogicX = 0.6;
            flag.scaleLogicY = 0.6;
            containerContent.eAddChild(flag);
            containerContent.setContent("allianceFlag",flag);
            infoItems.push(flag);
         }
         for each(var s in infoItems)
         {
            infoArea.centerContent(s);
         }
         bar.x = infoArea.x + 10;
         img.x = bar.width + bar.x + 10 * 3;
         if(this.mUserAlliance != null)
         {
            espc.x = infoArea.width - espc.width - 10;
            flag.x = espc.x - flag.width - 10 * 6;
            flag.y = img.y - 6;
         }
         this.createTabs(layoutFactory.getArea("tab"));
         this.setPageId(null,0);
         containerContent.layoutApplyTransformations(layoutFactory.getArea("body"));
         eAddChild(containerContent);
         setContent("content",containerContent);
         this.updateBadgesBar();
      }
      
      private function buildEmbassyDefs() : void
      {
         this.mEmbassyDefs.length = 0;
         for each(var itemDef in InstanceMng.getItemsDefMng().getDefs())
         {
            if(itemDef.getPriceBadges() > 0)
            {
               this.mEmbassyDefs.push(itemDef);
            }
         }
      }
      
      private function getEmbassyDefs() : Vector.<ItemsDef>
      {
         return this.mEmbassyDefs;
      }
      
      private function getEmbassyDefsForPage(pageId:int) : Vector.<ItemsDef>
      {
         var defs:Vector.<ItemsDef> = this.getEmbassyDefs();
         var defsForThisPage:Vector.<ItemsDef> = new Vector.<ItemsDef>(0);
         for each(var itemDef in defs)
         {
            if(itemDef.getEmbassyTab() == pageId)
            {
               defsForThisPage.push(itemDef);
            }
         }
         return defsForThisPage;
      }
      
      private function createTabs(tabArea:ELayoutArea) : void
      {
         var i:int = 0;
         var tabButton:EButton = null;
         var bkg:ESprite = getBackground();
         var tabs:Vector.<EButton> = new Vector.<EButton>(0);
         var numberOfTabs:int = 0;
         for each(var itemDef in this.getEmbassyDefs())
         {
            numberOfTabs = Math.max(numberOfTabs,itemDef.getEmbassyTab());
         }
         numberOfTabs += 1;
         for(i = 0; i < numberOfTabs; )
         {
            tabButton = this.mViewFactory.getTextTabHeaderPopup(DCTextMng.getText(TAB_TITLE_IDS[i]),mSkinSku);
            setContent("tab_button_" + i,tabButton);
            bkg.eAddChild(tabButton);
            tabs[i] = tabButton;
            i++;
         }
         this.mTabHeader = new TabHeadersView(tabArea,this.mViewFactory,mSkinSku);
         this.mTabHeader.setTabHeaders(tabs);
         this.mPaginatorComponent = new EPaginatorComponent();
         this.mPaginatorComponent.init(this.mTabHeader,this);
         this.mTabHeader.setPaginatorComponent(this.mPaginatorComponent);
      }
      
      private function buildBoxes(spriteReference:ESpriteContainer, rowOffset:int, rebuild:Boolean) : void
      {
         var itemContainer:EEmbassyBox = null;
         var i:int = 0;
         var xOffset:int = 0;
         if(rebuild)
         {
            while(spriteReference.numChildren)
            {
               (itemContainer = spriteReference.getChildAt(0) as EEmbassyBox).destroy();
            }
            for(i = 0; i < 3; )
            {
               itemContainer = new EEmbassyBox();
               spriteReference.eAddChild(itemContainer);
               spriteReference.setContent("itemContainer" + i,itemContainer);
               i++;
            }
         }
         var defsForThisPage:Vector.<ItemsDef> = getEmbassyDefsForPage(this.mCurrentPage);
         i = rowOffset * 3;
         while(i < (rowOffset + 1) * 3 && i < defsForThisPage.length)
         {
            (itemContainer = spriteReference.getChildAt(i % 3) as EEmbassyBox).visible = true;
            itemContainer.build();
            itemContainer.setInfo(defsForThisPage[i]);
            xOffset = (this.mAreaToScroll.width - 3 * itemContainer.width) / (3 + 1);
            itemContainer.logicLeft = i % 3 * (itemContainer.width + xOffset) + xOffset;
            itemContainer.logicTop = 0;
            this.mBoxContainer.setContent("box_" + i,itemContainer);
            i++;
         }
         while(i < (rowOffset + 1) * 3)
         {
            (itemContainer = spriteReference.getChildAt(i % 3) as EEmbassyBox).visible = false;
            i++;
         }
      }
      
      public function reloadView() : void
      {
         var items:Vector.<ItemsDef> = getEmbassyDefsForPage(this.mCurrentPage);
         var itemsCount:int = int(items.length);
         this.mScrollArea.reloadView(itemsCount);
      }
      
      private function updateBadgesBar() : void
      {
         var profile:Profile = null;
         var badges:int = 0;
         var badgesCapacity:int = 0;
         var bar:IconBar = (getContent("content") as ESpriteContainer).getContent("bar") as IconBar;
         if(bar != null)
         {
            badges = (profile = InstanceMng.getUserInfoMng().getProfileLogin()).getBadges();
            badgesCapacity = profile.getBadgesCapacity();
            bar.setBarCurrentValue(badges);
            bar.setBarMaxValue(badgesCapacity);
            bar.updateText(DCTextMng.convertNumberToString(badges,-1,-1) + "/" + DCTextMng.convertNumberToString(badgesCapacity,-1,-1));
         }
      }
      
      private function getAllianceLevelBar() : ESpriteContainer
      {
         var OFFSET:int = 6;
         var container:ESpriteContainer = this.mViewFactory.getESpriteContainer();
         var layoutFactory:ELayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory("ProductionBar");
         var allianceLevel:String = InstanceMng.getAlliancesLevelDefMng().getLevelFromScore(this.mUserAlliance.getScore());
         var fillbarArea:ELayoutArea = layoutFactory.getArea("bar");
         var fillbar:EFillBar = this.mViewFactory.createFillBar(0,fillbarArea.width,fillbarArea.height,0,"color_fill_bkg");
         container.setContent("fillbarBkg",fillbar);
         container.eAddChild(fillbar);
         fillbar.layoutApplyTransformations(fillbarArea);
         var levelDef:AlliancesLevelDef = InstanceMng.getAlliancesLevelDefMng().getDefBySku(allianceLevel) as AlliancesLevelDef;
         fillbar = this.mViewFactory.createFillBar(1,fillbarArea.width - OFFSET,fillbarArea.height - OFFSET,levelDef.getMaxScore() - levelDef.getMinScore(),"color_yellow");
         container.setContent("fillbar",fillbar);
         container.eAddChild(fillbar);
         fillbarArea.centerContent(fillbar);
         fillbar.setValue(this.mUserAlliance.getScore() - levelDef.getMinScore());
         var icon:EImage = this.mViewFactory.getEImage("icon_alliance_level",null,true,layoutFactory.getArea("icon"));
         container.setContent("icon",icon);
         container.eAddChild(icon);
         var field:ETextField;
         (field = this.mViewFactory.getETextField(null,layoutFactory.getTextArea("text"),"text_title_3")).setText(allianceLevel);
         container.setContent("allianceLevel",field);
         container.eAddChild(field);
         container.mouseChildren = false;
         var score:Number = this.mUserAlliance.getScore();
         var nextScore:Number = InstanceMng.getAlliancesLevelDefMng().getMaxScoreByScore(score);
         var text:String = DCTextMng.replaceParameters(3021,[DCTextMng.convertNumberToString(score,-1,-1),DCTextMng.convertNumberToString(nextScore,-1,-1)]);
         ETooltipMng.getInstance().createTooltipInfoFromText(text,container,null,true,false);
         return container;
      }
      
      public function refreshCurrentPage() : void
      {
         this.reloadView();
         this.updateBadgesBar();
      }
      
      private function removeBoxes() : void
      {
         var container:ESprite = null;
         var i:int = 0;
         for(i = 0; i < 6; )
         {
            container = getContent("box_" + i);
            if(container != null)
            {
               container.destroy();
               container = null;
            }
            i++;
         }
      }
      
      public function setPageId(pc:EPaginatorComponent, id:int) : void
      {
         var items:* = undefined;
         var itemsCount:int = 0;
         var page:TabBodyPremiumShop = null;
         var body:ESprite = null;
         var info:ShopDef = null;
         if(this.mCurrentPage != id)
         {
            body = getContent("body");
            if(this.mCurrentPage > -1)
            {
               page = getContent(this.mCurrentPageName) as TabBodyPremiumShop;
               body.eRemoveChild(page);
            }
            this.mCurrentPage = id;
            this.removeBoxes();
            itemsCount = int((items = getEmbassyDefsForPage(id)).length);
            this.mScrollArea = new EScrollArea();
            this.mScrollArea.build(this.mAreaToScroll,Math.ceil(itemsCount / 3),ESpriteContainer,this.buildBoxes);
            this.mViewFactory.getEScrollBar(this.mScrollArea);
            this.mBoxContainer.setContent("scrollArea",this.mScrollArea);
            this.mBoxContainer.eAddChild(this.mScrollArea);
            this.mCurrentPageName = "tab_content";
            page = getContent(this.mCurrentPageName) as TabBodyPremiumShop;
            body.eAddChild(page);
            if(info)
            {
               page.setShopDef(info);
            }
            page.setupHeader(DCTextMng.getText(TAB_DESC_IDS[id]),"text_body_2");
            this.mTabHeader.setPageId(this.mCurrentPage);
         }
      }
      
      private function onHelpButton(e:EEvent) : void
      {
         var popup:DCIPopup = InstanceMng.getUIFacade().getPopupFactory().getHelpEmbassyPopup();
         InstanceMng.getUIFacade().enqueuePopup(popup);
      }
   }
}
