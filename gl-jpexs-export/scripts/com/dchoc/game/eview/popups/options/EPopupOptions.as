package com.dchoc.game.eview.popups.options
{
   import com.dchoc.game.core.flow.messaging.INotifyReceiver;
   import com.dchoc.game.core.flow.messaging.MessageCenter;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.skins.SkinsMng;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.eview.widgets.paginator.TabHeadersView;
   import com.dchoc.game.model.userdata.Profile;
   import com.dchoc.game.model.userdata.Transaction;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.EScrollArea;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.resources.EResourcesMng;
   import esparragon.widgets.EButton;
   import esparragon.widgets.paginator.EPaginatorComponent;
   import esparragon.widgets.paginator.EPaginatorController;
   import flash.display.Stage;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class EPopupOptions extends EGamePopup implements EPaginatorController, INotifyReceiver
   {
      
      private static const BODY_SKU:String = "body";
      
      private static const CONTAINER_SKU:String = "tabContainer";
      
      private static const TAB_BUTTON_SKU:String = "tab_button_";
      
      private static const TAB_GRAPHICS:String = "graphics";
      
      private static const TAB_SOUND:String = "sound";
      
      private static const TAB_CUSTOMIZE:String = "customize";
      
      private static const TAB_LANGUAGE:String = "language";
      
      private static const TAB_ORDER:Vector.<String> = new <String>["graphics","sound","customize","language"];
      
      private static const TAB_TITLE_TIDS:Vector.<int> = new <int>[3848,3849,3850,3851];
      
      private static const BAR_SKU_ZOOM:String = "zoom";
      
      private static const BAR_SKU_FRAMERATE_LIMIT:String = "framerateLimit";
      
      private static const BAR_SKU_SOUND:String = "sound";
      
      private static const BAR_SKU_MUSIC:String = "music";
      
      private static const BAR_SKU_SFX:String = "sfx";
       
      
      private var mTabHeader:TabHeadersView;
      
      private var mPaginatorComponent:EPaginatorComponent;
      
      private var mSkinPaginator:ESkinPaginator;
      
      private var mFullscreenBoolean:EBooleanOption;
      
      private var mSoundSlider:EOptionSlider;
      
      private var mCurrentPage:int = -1;
      
      private var mLayoutAreaFactory:ELayoutAreaFactory;
      
      private var mBody:ESprite;
      
      private var mTabs:Dictionary;
      
      private var mTabContent:ESpriteContainer;
      
      private var mProfile:Profile;
      
      private var mStage:Stage;
      
      public function EPopupOptions()
      {
         super();
         this.mProfile = InstanceMng.getUserInfoMng().getProfileLogin();
         this.mStage = InstanceMng.getApplication().stageGetStage().getImplementation();
         MessageCenter.getInstance().registerObject(this);
      }
      
      public function getName() : String
      {
         return "EPopupOptions";
      }
      
      public function getTaskList() : Vector.<String>
      {
         return new <String>["fullscreenSetting","soundSetting"];
      }
      
      public function onMessage(task:String, params:Dictionary) : void
      {
         switch(task)
         {
            case "fullscreenSetting":
               if(TAB_ORDER[this.mCurrentPage] == "graphics")
               {
                  this.mFullscreenBoolean.setCheckboxValue(params["value"]);
               }
               break;
            case "soundSetting":
               if(TAB_ORDER[this.mCurrentPage] == "sound")
               {
                  this.mSoundSlider.setToggled(params["value"]);
               }
         }
      }
      
      override public function setup(popupId:String, viewFactory:ViewFactory, skinId:String) : void
      {
         super.setup(popupId,viewFactory,skinId);
         this.mTabs = new Dictionary();
         this.setupBackground();
         this.setupBody();
      }
      
      private function setupBackground() : void
      {
         this.mLayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopXLTabsNoFooter");
         setLayoutArea(this.mLayoutAreaFactory.getContainerLayoutArea());
         var img:EImage = mViewFactory.getEImage("pop_xl_no_buttons",mSkinSku,false,this.mLayoutAreaFactory.getArea("bg"));
         setBackground(img);
         eAddChild(img);
         this.mBody = mViewFactory.getESprite(mSkinSku,this.mLayoutAreaFactory.getArea("body"));
         setContent("body",this.mBody);
         img.eAddChild(this.mBody);
         var button:EButton = mViewFactory.getButtonClose(mSkinSku,this.mLayoutAreaFactory.getArea("btn_close"));
         setCloseButton(button);
         img.eAddChild(button);
         button.eAddEventListener("click",notifyPopupMngClose);
         var field:ETextField = mViewFactory.getETextField(mSkinSku,this.mLayoutAreaFactory.getTextArea("text_title"),"text_title_0");
         setTitle(field);
         field.setText(DCTextMng.getText(3847));
         img.eAddChild(field);
         this.mTabContent = mViewFactory.getESpriteContainer();
         this.mBody.eAddChild(this.mTabContent);
         this.mTabContent.setLayoutArea(this.mBody.getLayoutArea(),false);
      }
      
      private function setupBody() : void
      {
         this.createTabsHeaders(this.mViewFactory.getLayoutAreaFactory("PopXLTabsNoFooter").getArea("tab"));
         this.setPageId(null,0);
      }
      
      private function createTabsHeaders(tabArea:ELayoutArea) : void
      {
         var i:int = 0;
         var tabButton:EButton = null;
         var bkg:ESprite = getBackground();
         var tabs:Vector.<EButton> = new Vector.<EButton>(0);
         for(i = 0; i < TAB_TITLE_TIDS.length; )
         {
            tabButton = this.mViewFactory.getTextTabHeaderPopup(DCTextMng.getText(TAB_TITLE_TIDS[i]),mSkinSku);
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
      
      private function createTabGraphics(spriteReference:ESpriteContainer) : void
      {
         var layoutArea:ELayoutArea = null;
         var graphicsOptionsContainer:ESpriteContainer = mViewFactory.getESpriteContainer();
         var scrollArea:EScrollArea = new EScrollArea();
         layoutArea = ELayoutAreaFactory.createLayoutArea(630,300);
         layoutArea.x = 15;
         layoutArea.y = 40;
         scrollArea.build(layoutArea,4,ESpriteContainer,this.fillGraphicsOptions,20);
         this.mViewFactory.getEScrollBar(scrollArea);
         graphicsOptionsContainer.setContent("scrollArea",scrollArea);
         graphicsOptionsContainer.eAddChild(scrollArea);
         this.createResetButton(graphicsOptionsContainer);
         spriteReference.setContent("tabContainer",graphicsOptionsContainer);
         spriteReference.eAddChild(graphicsOptionsContainer);
      }
      
      private function fillGraphicsOptions(spriteReference:ESpriteContainer, rowOffset:int, rebuild:Boolean) : void
      {
         var layout:ELayoutArea = null;
         var option:EBooleanOption = null;
         var optionBar:EOptionSlider = null;
         var optionPag:EOptionPaginator = null;
         var btn:EButton = null;
         var initialPage:int = 0;
         var options:* = undefined;
         var i:int = 0;
         var sprite:ESprite = null;
         var layoutAreaBoolean:ELayoutArea = ELayoutAreaFactory.createLayoutArea(170,40);
         var layoutAreaBar:ELayoutArea = ELayoutAreaFactory.createLayoutArea(170,60);
         var layoutAreaPaginator:ELayoutArea = ELayoutAreaFactory.createLayoutArea(170,125);
         var rowContainer:ESpriteContainer = this.mViewFactory.getESpriteContainer();
         var rowContents:Array = [];
         switch(rowOffset)
         {
            case 0:
               layout = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layoutAreaBar);
               (optionBar = new EOptionSlider("zoom",3968,this.onZoomChanged)).init(layout);
               optionBar.setValue(this.mProfile.getZoom(false),false);
               rowContainer.setContent("zoom",optionBar);
               rowContainer.eAddChild(optionBar);
               rowContents.push(optionBar);
               layout = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layoutAreaBoolean);
               this.mFullscreenBoolean = new EBooleanOption(3855,this.onFullscreenToggled);
               this.mFullscreenBoolean.init(layout);
               this.mFullscreenBoolean.setCheckboxValue(InstanceMng.getApplication().isFullScreen());
               rowContainer.setContent("fullscreen",this.mFullscreenBoolean);
               rowContainer.eAddChild(this.mFullscreenBoolean);
               rowContents.push(this.mFullscreenBoolean);
               layout = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layoutAreaPaginator);
               options = new <String>["low","high"];
               (optionPag = new EOptionPaginator(3852,options,new <int>[3853,3854],this.onQualitySelected,this.isQualitySelected)).init(rowContainer,layout);
               initialPage = int((initialPage = options.indexOf(this.mProfile.getQuality())) > -1 ? initialPage : 0);
               optionPag.setPageId(null,initialPage);
               rowContainer.setContent("qualityPaginator",optionPag);
               rowContainer.eAddChild(optionPag);
               rowContents.push(optionPag);
               break;
            case 1:
               layout = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layoutAreaPaginator);
               (optionPag = new EOptionPaginator(3977,new <String>["1","2"],new <int>[3865,3866],this.onParticlesSelected,this.isParticlesSelected)).init(rowContainer,layout);
               initialPage = int((initialPage = this.mProfile.getParticles() - 1) > -1 ? initialPage : 0);
               optionPag.setPageId(null,initialPage);
               rowContainer.setContent("particlesPaginator",optionPag);
               rowContainer.eAddChild(optionPag);
               rowContents.push(optionPag);
               layout = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layoutAreaBoolean);
               (option = new EBooleanOption(3966,this.onInvisibleWallsToggled)).init(layout);
               option.setCheckboxValue(this.mProfile.getInvisibleWalls());
               rowContainer.setContent("invisibleWalls",option);
               rowContainer.eAddChild(option);
               rowContents.push(option);
               layout = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layoutAreaBoolean);
               (option = new EBooleanOption(3967,this.onInvisibleHangarUnitsToggled)).init(layout);
               option.setCheckboxValue(this.mProfile.getInvisibleHangarUnits());
               rowContainer.setContent("invisibleHangarUnits",option);
               rowContainer.eAddChild(option);
               rowContents.push(option);
               break;
            case 2:
               layout = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layoutAreaBoolean);
               (option = new EBooleanOption(3856,this.onAnimatedBackgroundToggled)).init(layout);
               option.setCheckboxValue(this.mProfile.getAnimatedBackground());
               rowContainer.setContent("animatedBackground",option);
               rowContainer.eAddChild(option);
               rowContents.push(option);
               layout = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layoutAreaBoolean);
               (option = new EBooleanOption(4066,this.onZoomScrollToggled)).init(layout);
               option.setCheckboxValue(this.mProfile.getScrollZoomEnabled());
               rowContainer.setContent("zoomScrollEnabled",option);
               rowContainer.eAddChild(option);
               rowContents.push(option);
               layout = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layoutAreaBoolean);
               (option = new EBooleanOption(4067,this.onZoomScrollInverted)).init(layout);
               option.setCheckboxValue(this.mProfile.getScrollZoomInverted());
               rowContainer.setContent("zoomScrollInverted",option);
               rowContainer.eAddChild(option);
               rowContents.push(option);
               break;
            case 3:
               layout = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layoutAreaBoolean);
               (btn = this.mViewFactory.getButtonSocial(null,null,DCTextMng.getText(4328))).eAddEventListener("click",this.onFullscreenResolutionClicked);
               layout.centerContent(btn);
               rowContainer.setContent("fullscreenResolutionBtn",btn);
               rowContainer.eAddChild(btn);
               rowContents.push(btn);
               layout = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layoutAreaBoolean);
               (btn = this.mViewFactory.getButtonSocial(null,null,DCTextMng.getText(4312))).eAddEventListener("click",this.onTextOptionsClicked);
               layout.centerContent(btn);
               btn.name = "textOptionsBtn";
               rowContainer.setContent("textOptionsBtn",btn);
               rowContainer.eAddChild(btn);
               rowContents.push(btn);
               layout = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layoutAreaBar);
               (optionBar = new EOptionSlider("framerateLimit",4332,this.onFramerateLimitChanged)).setBounds(5,120);
               optionBar.init(layout);
               optionBar.setValue(this.mProfile.getFramerateLimit(),false);
               rowContainer.setContent("framerateLimit",optionBar);
               rowContainer.eAddChild(optionBar);
               rowContents.push(optionBar);
         }
         var rowHeight:int = int([110,90,40,110][rowOffset]);
         for(i = 0; i < rowContents.length; )
         {
            (sprite = rowContents[i]).logicLeft = 200 * i;
            if(sprite.name == "textOptionsBtn")
            {
               sprite.logicLeft += 50;
            }
            sprite.logicTop = (rowHeight - sprite.getLogicHeight()) / 2;
            i++;
         }
         spriteReference.setContent("row-" + rowOffset,rowContainer);
         spriteReference.eAddChild(rowContainer);
      }
      
      private function createTabSound(spriteReference:ESpriteContainer) : void
      {
         var layoutArea:ELayoutArea = null;
         var optionBar:EOptionSlider = null;
         var i:int = 0;
         var soundBarsContainer:ESpriteContainer = mViewFactory.getESpriteContainer();
         var bars:Array = [];
         for(i = 0; i < 3; )
         {
            layoutArea = ELayoutAreaFactory.createLayoutArea(400,60);
            optionBar = new EOptionSlider(["sound","music","sfx"][i],[3857,3858,3859][i],this.onVolumeChanged,this.onVolumeToggled);
            optionBar.init(layoutArea);
            optionBar.setValue([this.mProfile.getSoundVolume(),this.mProfile.getMusicVolume(),this.mProfile.getSfxVolume()][i],false);
            optionBar.setToggled([this.mProfile.getSound(),this.mProfile.getMusic(),this.mProfile.getSfx()][i]);
            soundBarsContainer.setContent("soundBar" + i,optionBar);
            soundBarsContainer.eAddChild(optionBar);
            bars.push(optionBar);
            if(i == 0)
            {
               this.mSoundSlider = optionBar;
            }
            i++;
         }
         this.mViewFactory.distributeSpritesInArea(this.mBody.getLayoutArea(),bars,1,1,1);
         this.createResetButton(soundBarsContainer);
         spriteReference.setContent("tabContainer",soundBarsContainer);
         spriteReference.eAddChild(soundBarsContainer);
      }
      
      private function createTabCustomize(spriteReference:ESpriteContainer) : void
      {
         var layoutArea:ELayoutArea = null;
         var initialPage:int = 0;
         var skinPaginatorContainer:ESpriteContainer = mViewFactory.getESpriteContainer();
         var customizeOptionsContainer:ESpriteContainer = mViewFactory.getESpriteContainer();
         (layoutArea = ELayoutAreaFactory.createLayoutArea(315,300)).x = 50;
         layoutArea.y = 30;
         this.mSkinPaginator = new ESkinPaginator();
         this.mSkinPaginator.init(skinPaginatorContainer,layoutArea);
         spriteReference.eAddChild(skinPaginatorContainer);
         initialPage = int((initialPage = InstanceMng.getSkinsMng().getSkinsVector().indexOf(InstanceMng.getSkinsMng().getCurrentSkinSku())) > -1 ? initialPage : 0);
         this.mSkinPaginator.setPageId(null,initialPage);
         var scrollArea:EScrollArea = new EScrollArea();
         (layoutArea = ELayoutAreaFactory.createLayoutArea(240,310)).x = 415;
         layoutArea.y = 40;
         scrollArea.build(layoutArea,5,ESpriteContainer,this.fillCustomizeOptions,20);
         this.mViewFactory.getEScrollBar(scrollArea);
         customizeOptionsContainer.setContent("scrollArea",scrollArea);
         customizeOptionsContainer.eAddChild(scrollArea);
         this.createResetButton(customizeOptionsContainer);
         spriteReference.setContent("tabContainer",customizeOptionsContainer);
         spriteReference.eAddChild(customizeOptionsContainer);
      }
      
      private function fillCustomizeOptions(spriteReference:ESpriteContainer, rowOffset:int, rebuild:Boolean) : void
      {
         var layout:ELayoutArea = null;
         var btn:EButton = null;
         var initialPage:int = 0;
         var options:* = undefined;
         var basesPaginator:EOptionPaginator = null;
         var civilsPaginator:EOptionPaginator = null;
         var spylingMode:EBooleanOption = null;
         var confirmEndBattle:EBooleanOption = null;
         var layoutAreaBoolean:ELayoutArea = ELayoutAreaFactory.createLayoutArea(220,35);
         var layoutAreaPaginator:ELayoutArea = ELayoutAreaFactory.createLayoutArea(220,125);
         switch(rowOffset)
         {
            case 0:
               layout = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layoutAreaPaginator);
               options = InstanceMng.getSkinsMng().getFoundationSkusVector();
               (basesPaginator = new EOptionPaginator(3860,options,InstanceMng.getSkinsMng().getFoundationTitlesVector(),onFoundationsSelect,isFoundationSelected)).init(spriteReference,layout);
               initialPage = int((initialPage = options.indexOf(this.mProfile.getFoundations())) > -1 ? initialPage : 0);
               basesPaginator.setPageId(null,initialPage);
               spriteReference.setContent("foundationsPaginator",basesPaginator);
               spriteReference.eAddChild(basesPaginator);
               break;
            case 1:
               layout = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layoutAreaPaginator);
               (civilsPaginator = new EOptionPaginator(3863,new <String>["0","1","2","3","4"],new <int>[3864,3865,3866,3867,3868],onCivilsPopulationSelected,isCivilsPopulationSelected)).init(spriteReference,layout);
               initialPage = int((initialPage = this.mProfile.getCivilsPopulation()) > -1 ? initialPage : 0);
               civilsPaginator.setPageId(null,initialPage);
               spriteReference.setContent("civilsPaginator",civilsPaginator);
               spriteReference.eAddChild(civilsPaginator);
               break;
            case 2:
               layout = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layoutAreaBoolean);
               (spylingMode = new EBooleanOption(3869,onSpylingModeToggled,3870)).init(layout);
               spylingMode.setCheckboxValue(this.mProfile.getStreamerMode());
               spriteReference.setContent("spylingMode",spylingMode);
               spriteReference.eAddChild(spylingMode);
               break;
            case 3:
               layout = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layoutAreaBoolean);
               (confirmEndBattle = new EBooleanOption(3980,onConfirmEndBattleToggled)).init(layout);
               confirmEndBattle.setCheckboxValue(this.mProfile.getConfirmEndBattle());
               spriteReference.setContent("confirmEndBattle",confirmEndBattle);
               spriteReference.eAddChild(confirmEndBattle);
               break;
            case 4:
               layout = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(layoutAreaBoolean);
               (btn = this.mViewFactory.getButtonSocial(null,null,DCTextMng.getText(4303))).eAddEventListener("click",this.onHotkeysClicked);
               layout.centerContent(btn);
               spriteReference.setContent("hotkeysBtn",btn);
               spriteReference.eAddChild(btn);
         }
      }
      
      private function createTabLanguage(spriteReference:ESpriteContainer) : void
      {
         var languageContainer:ESpriteContainer = mViewFactory.getESpriteContainer();
         var btn:EButton = null;
         var languageButtons:Array = [];
         for each(var lang in DCTextMng.langListGetIds())
         {
            (btn = mViewFactory.getButton("btn_hud",null,"M",DCTextMng.langListGetNativeText()[lang])).name = lang;
            btn.eAddEventListener("click",this.onLanguageSelected);
            btn.setIsEnabled(InstanceMng.getUserInfoMng().getProfileLogin().getLocale() != lang);
            languageButtons.push(btn);
            languageContainer.eAddChild(btn);
            languageContainer.setContent(lang,btn);
         }
         languageContainer.setLayoutArea(spriteReference.getLayoutArea(),false);
         this.mViewFactory.distributeSpritesInArea(languageContainer.getLayoutArea(),languageButtons,1,1,5);
         spriteReference.setContent("tabContainer",languageContainer);
         spriteReference.eAddChild(languageContainer);
      }
      
      public function setPageId(pc:EPaginatorComponent, id:int) : void
      {
         this.destroyTabs();
         this.mCurrentPage = id;
         var tabSku:String = TAB_ORDER[this.mCurrentPage];
         switch(tabSku)
         {
            case "graphics":
               this.createTabGraphics(this.mTabContent);
               break;
            case "sound":
               this.createTabSound(this.mTabContent);
               break;
            case "customize":
               this.createTabCustomize(this.mTabContent);
               break;
            case "language":
               this.createTabLanguage(this.mTabContent);
         }
         this.mTabs[tabSku] = this.mTabContent;
         setContent(tabSku,this.mTabs[tabSku]);
      }
      
      private function destroyTabs() : void
      {
         var esp:ESprite = null;
         var tab:* = null;
         for(tab in this.mTabs)
         {
            while(this.mTabs[tab].numChildren)
            {
               esp = this.mTabs[tab].getChildAt(0) as ESprite;
               esp.destroy();
            }
            delete this.mTabs[tab];
         }
      }
      
      private function createResetButton(where:ESpriteContainer) : void
      {
         var bodyLayout:ELayoutArea = this.mLayoutAreaFactory.getArea("body");
         var btnLayout:ELayoutArea;
         (btnLayout = this.mViewFactory.getLayoutAreaFactory(this.mViewFactory.getButtonLayout("M",false)).getContainerLayoutArea()).x = bodyLayout.width - 150;
         btnLayout.y = bodyLayout.height - 40;
         var btn:EButton = InstanceMng.getViewFactory().getButton("btn_hud",null,"M",DCTextMng.getText(3969),null,btnLayout);
         btn.eAddEventListener("click",this.onResetToDefaults);
         where.setContent("resetBtn",btn);
         where.eAddChild(btn);
      }
      
      private function isFoundationSelected(sku:String) : Boolean
      {
         return sku == this.mProfile.getFoundations();
      }
      
      private function onFoundationsSelect(sku:String, reload:Boolean = true) : void
      {
         sku = SkinsMng.getValidFoundationSku(sku);
         this.mProfile.setFoundations(sku);
         InstanceMng.getSkinsMng().setCurrentFoundationSku(sku);
         if(reload)
         {
            InstanceMng.getApplication().reloadLatestOwnerPlanet();
         }
      }
      
      private function onCivilsColorClicked(e:EEvent) : void
      {
         var popup:EPopupChooseColor = new EPopupChooseColor();
         popup.setup("PopupChooseColor",this.mViewFactory,null);
         popup.setIsStackable(true);
         popup.setApplyCallback(this.onCivilsColorApplied);
         InstanceMng.getUIFacade().enqueuePopup(popup);
      }
      
      private function onCivilsColorApplied(value:String, reload:Boolean = true) : void
      {
         var price:int = InstanceMng.getSettingsDefMng().mSettingsDef.getStarlingColorPrice();
         var trans:Transaction;
         (trans = new Transaction()).setTransCash(-price);
         this.mProfile.setCivilsColor(value,trans);
         if(reload)
         {
            InstanceMng.getApplication().reloadLatestOwnerPlanet();
         }
      }
      
      private function onHotkeysClicked(e:EEvent) : void
      {
         var popup:EPopupChooseHotkeys = new EPopupChooseHotkeys();
         popup.setup("PopupChooseHotkeys",this.mViewFactory,null);
         popup.setIsStackable(true);
         popup.setApplyCallback(this.onHotkeysApplied);
         InstanceMng.getUIFacade().enqueuePopup(popup);
      }
      
      private function onHotkeysApplied(value:String) : void
      {
         this.mProfile.setHotkeys(value);
      }
      
      private function onFullscreenResolutionApplied(value:String) : void
      {
         var width:int = 0;
         var height:int = 0;
         this.mProfile.setFullscreenResolution(value);
         if(value != "" && value.indexOf(",") > -1)
         {
            width = int(value.split(",")[0]);
            height = int(value.split(",")[1]);
            this.mStage.fullScreenSourceRect = new Rectangle(0,0,width,height);
         }
         else
         {
            this.mStage.fullScreenSourceRect = null;
         }
      }
      
      private function onTextOptionsApplied(value:Object, reload:Boolean = true) : void
      {
         var oldAA:String;
         if((oldAA = this.mProfile.getTextAntiAliasingMode()) != value["AA"])
         {
            this.mProfile.setTextAntiAliasingMode(value["AA"]);
         }
         var oldSharpness:int = this.mProfile.getTextSharpness();
         if(oldSharpness != value["sharpness"])
         {
            this.mProfile.setTextSharpness(value["sharpness"]);
         }
         var oldThickness:int;
         if((oldThickness = this.mProfile.getTextThickness()) != value["thickness"])
         {
            this.mProfile.setTextThickness(value["thickness"]);
         }
         if(reload)
         {
            InstanceMng.getApplication().reloadLatestOwnerPlanet();
         }
      }
      
      private function isCivilsPopulationSelected(sku:String) : Boolean
      {
         var value:int = int(sku);
         return value == this.mProfile.getCivilsPopulation();
      }
      
      private function onCivilsPopulationSelected(sku:String) : void
      {
         var value:int = int(sku);
         this.mProfile.setCivilsPopulation(value);
         InstanceMng.getTrafficMng().applyPopulationSetting(value);
      }
      
      private function onSpylingModeToggled(value:Boolean, reload:Boolean = true) : void
      {
         this.mProfile.setStreamerMode(value ? 1 : 0);
         if(reload)
         {
            InstanceMng.getApplication().reloadLatestOwnerPlanet();
         }
      }
      
      private function onConfirmEndBattleToggled(value:Boolean) : void
      {
         this.mProfile.setConfirmEndBattle(value ? 1 : 0);
      }
      
      private function isQualitySelected(sku:String) : Boolean
      {
         return sku == this.mProfile.getQuality();
      }
      
      private function onQualitySelected(sku:String) : void
      {
         this.mProfile.setQuality(sku);
         this.mStage.quality = sku;
      }
      
      private function onFullscreenToggled(value:Boolean) : void
      {
         this.mProfile.setFullscreen(value ? 1 : 0);
         InstanceMng.getApplication().toggleFullScreen();
      }
      
      private function onAnimatedBackgroundToggled(value:Boolean) : void
      {
         this.mProfile.setAnimatedBackground(value ? 1 : 0);
         InstanceMng.getMapView().onAnimatedBackgroundToggled(value);
      }
      
      private function onInvisibleWallsToggled(value:Boolean, reload:Boolean = true) : void
      {
         this.mProfile.setInvisibleWalls(value ? 1 : 0);
         if(reload)
         {
            InstanceMng.getApplication().reloadLatestOwnerPlanet();
         }
      }
      
      private function onInvisibleHangarUnitsToggled(value:Boolean, reload:Boolean = true) : void
      {
         this.mProfile.setInvisibleHangarUnits(value ? 1 : 0);
         if(reload)
         {
            InstanceMng.getApplication().reloadLatestOwnerPlanet();
         }
      }
      
      private function isParticlesSelected(sku:String) : Boolean
      {
         var value:int = int(sku);
         return value == this.mProfile.getParticles();
      }
      
      private function onParticlesSelected(sku:String, reload:Boolean = true) : void
      {
         var value:int = int(sku);
         this.mProfile.setParticles(value);
         if(reload)
         {
            InstanceMng.getApplication().reloadLatestOwnerPlanet();
         }
      }
      
      private function onZoomScrollToggled(value:Boolean) : void
      {
         this.mProfile.setScrollZoomEnabled(value ? 1 : 0);
      }
      
      private function onZoomScrollInverted(value:Boolean) : void
      {
         this.mProfile.setScrollZoomInverted(value ? 1 : 0);
      }
      
      private function onZoomChanged(sku:String, value:int) : void
      {
         var _loc3_:* = sku;
         if("zoom" === _loc3_)
         {
            this.mProfile.setZoom(value,true);
         }
      }
      
      private function onFramerateLimitChanged(sku:String, value:int) : void
      {
         var _loc3_:* = sku;
         if("framerateLimit" === _loc3_)
         {
            this.mStage.frameRate = value;
            this.mProfile.setFramerateLimit(value);
         }
      }
      
      private function onFullscreenResolutionClicked(e:EEvent) : void
      {
         var popup:EPopupChooseResolution = new EPopupChooseResolution();
         popup.setup("PopupChooseResolution",this.mViewFactory,null);
         popup.setIsStackable(true);
         popup.setApplyCallback(this.onFullscreenResolutionApplied);
         InstanceMng.getUIFacade().enqueuePopup(popup);
      }
      
      private function onTextOptionsClicked(e:EEvent) : void
      {
         var popup:EPopupTextOptions = new EPopupTextOptions();
         popup.setup("PopupTextOptions",this.mViewFactory,null);
         popup.setIsStackable(true);
         popup.setApplyCallback(this.onTextOptionsApplied);
         InstanceMng.getUIFacade().enqueuePopup(popup);
      }
      
      private function onVolumeChanged(sku:String, value:int) : void
      {
         switch(sku)
         {
            case "sound":
               this.mProfile.setSoundVolume(value);
               break;
            case "music":
               this.mProfile.setMusicVolume(value);
               break;
            case "sfx":
               this.mProfile.setSfxVolume(value);
         }
      }
      
      private function onVolumeToggled(sku:String, value:Boolean) : void
      {
         switch(sku)
         {
            case "sound":
               this.mProfile.setSound(value);
               break;
            case "music":
               this.mProfile.setMusic(value);
               break;
            case "sfx":
               this.mProfile.setSfx(value);
         }
      }
      
      private function onLanguageSelected(evt:EEvent) : void
      {
         var resourcesMng:EResourcesMng = null;
         var lang:String = String(evt.getTarget().name);
         if(DCTextMng.langListGetIds().indexOf(lang) > -1)
         {
            InstanceMng.getGUIController().lockGUI();
            resourcesMng = InstanceMng.getEResourcesMng();
            if(resourcesMng.isAssetLoaded(lang,"locale"))
            {
               InstanceMng.getUserInfoMng().getProfileLogin().setLocale(lang);
               DCTextMng.langSetLang(lang);
               DCTextMng.langBuild(resourcesMng.getAssetString(lang,"locale"));
               InstanceMng.getApplication().reloadLatestOwnerPlanet();
            }
            InstanceMng.getGUIController().unlockGUI();
         }
      }
      
      private function onResetToDefaults(evt:EEvent) : void
      {
         var tabSku:String = TAB_ORDER[this.mCurrentPage];
         switch(tabSku)
         {
            case "graphics":
               this.onQualitySelected("high");
               this.onAnimatedBackgroundToggled(true);
               this.onZoomChanged("zoom",50);
               this.onInvisibleWallsToggled(false,false);
               this.onInvisibleHangarUnitsToggled(false,false);
               this.onParticlesSelected("2",false);
               this.onFullscreenResolutionApplied("");
               this.onFramerateLimitChanged("framerateLimit",60);
               this.onTextOptionsApplied({
                  "AA":"advanced",
                  "sharpness":0,
                  "thickness":0
               },false);
               InstanceMng.getApplication().reloadLatestOwnerPlanet();
               break;
            case "sound":
               this.onVolumeToggled("sound",true);
               this.onVolumeToggled("music",true);
               this.onVolumeToggled("sfx",true);
               this.onVolumeChanged("sound",100);
               this.onVolumeChanged("music",100);
               this.onVolumeChanged("sfx",100);
               break;
            case "customize":
               this.onFoundationsSelect("wio_bases",false);
               this.onCivilsPopulationSelected("2");
               this.onSpylingModeToggled(false,false);
               this.onConfirmEndBattleToggled(false);
               this.onHotkeysApplied("");
               this.mSkinPaginator.setSkinToDefault();
               InstanceMng.getApplication().reloadLatestOwnerPlanet();
         }
         this.setPageId(null,this.mCurrentPage);
      }
      
      override public function notifyPopupMngClose(e:Object) : void
      {
         MessageCenter.getInstance().unregisterObject(this);
         super.notifyPopupMngClose(e);
      }
   }
}
