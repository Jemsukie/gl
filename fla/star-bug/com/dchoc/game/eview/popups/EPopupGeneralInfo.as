package com.dchoc.game.eview.popups
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.eview.widgets.paginator.TabHeadersView;
   import com.dchoc.game.eview.widgets.tooltips.ETooltipMng;
   import com.dchoc.game.model.poll.PollDef;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.DCUtils;
   import esparragon.display.EImage;
   import esparragon.display.EScrollArea;
   import esparragon.display.EScrollBar;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.layout.ELayoutTextArea;
   import esparragon.widgets.EButton;
   import esparragon.widgets.EFillBar;
   import esparragon.widgets.paginator.EPaginatorComponent;
   import esparragon.widgets.paginator.EPaginatorController;
   import flash.utils.Dictionary;
   
   public class EPopupGeneralInfo extends EGamePopup implements EPaginatorController
   {
      
      private static const BODY_SKU:String = "body";
      
      private static const CONTAINER_SKU:String = "tab_container";
      
      private static const TAB_BUTTON_SKU:String = "tab_button_";
      
      private static const TAB_POLL:String = "poll";
      
      private static const TAB_MEDIA:String = "media";
      
      private static const TAB_UPDATES:String = "updates";
      
      private static const TAB_GUIDELINES:String = "guidelines";
      
      private static const PADDING:int = 10;
      
      private static const POLL_OPTION_BUTTON_SKU:String = "option_button_";
      
      private static var TAB_ORDER:Array = ["media","updates","guidelines"];
      
      private static var TAB_TITLE_TIDS:Vector.<int> = new <int>[4074,4075,4076];
       
      
      private var mLayoutAreaFactory:ELayoutAreaFactory;
      
      private var mTabHeader:TabHeadersView;
      
      private var mPaginatorComponent:EPaginatorComponent;
      
      private var mCurrentPage:int = -1;
      
      private var mBody:ESprite;
      
      private var mTabs:Dictionary;
      
      private var mTabContent:ESpriteContainer;
      
      private var mScrollArea:ELayoutArea;
      
      private var mUpdatesVector:Vector.<Object>;
      
      private var mGuidelinesVector:Vector.<String>;
      
      public function EPopupGeneralInfo()
      {
         mUpdatesVector = new Vector.<Object>(0);
         mGuidelinesVector = new Vector.<String>(0);
         super();
      }
      
      override public function setup(popupId:String, viewFactory:ViewFactory, skinId:String) : void
      {
         super.setup(popupId,viewFactory,skinId);
         this.mTabs = new Dictionary();
         if(InstanceMng.getPollMng().pollIsActive() && TAB_ORDER.indexOf("poll") == -1)
         {
            TAB_ORDER.unshift("poll");
            TAB_TITLE_TIDS.unshift(4102);
         }
         this.buildStringContent();
         this.setupBackground();
         this.setupBody();
      }
      
      private function setupBackground() : void
      {
         this.mLayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory("PopLTabs");
         setLayoutArea(this.mLayoutAreaFactory.getContainerLayoutArea());
         var img:EImage = this.mViewFactory.getEImage("pop_l",mSkinSku,false,this.mLayoutAreaFactory.getArea("bg"));
         setBackground(img);
         eAddChild(img);
         this.mBody = this.mViewFactory.getESprite(mSkinSku,this.mLayoutAreaFactory.getArea("body"));
         setContent("body",this.mBody);
         img.eAddChild(this.mBody);
         var button:EButton = this.mViewFactory.getButtonClose(mSkinSku,this.mLayoutAreaFactory.getArea("btn_close"));
         setCloseButton(button);
         img.eAddChild(button);
         button.eAddEventListener("click",notifyPopupMngClose);
         var field:ETextField = this.mViewFactory.getETextField(mSkinSku,this.mLayoutAreaFactory.getTextArea("text_title"),"text_title_0");
         setTitle(field);
         field.setText(DCTextMng.getText(4073));
         img.eAddChild(field);
         this.mTabContent = this.mViewFactory.getESpriteContainer();
         this.mBody.eAddChild(this.mTabContent);
         this.mTabContent.setLayoutArea(this.mBody.getLayoutArea(),false);
      }
      
      private function setupBody() : void
      {
         this.mScrollArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(this.mBody.getLayoutArea());
         this.mScrollArea.x = 10;
         this.mScrollArea.y = 10 * 2;
         this.mScrollArea.width -= 10 * 3;
         this.mScrollArea.height += 10;
         this.createTabsHeaders(this.mLayoutAreaFactory.getArea("tab"));
         this.setPageId(null,0);
      }
      
      private function buildStringContent() : void
      {
         var rawText:String = null;
         var entry:* = null;
         var entryObject:Object = null;
         rawText = DCTextMng.getText(4082);
         for each(entry in rawText.split("||"))
         {
            entryObject = {};
            entryObject["date"] = entry.split("//")[0];
            entryObject["content"] = entry.split("//")[1];
            this.mUpdatesVector.push(entryObject);
         }
         rawText = DCTextMng.getText(4081);
         for each(entry in rawText.split("||"))
         {
            this.mGuidelinesVector.push(entry);
         }
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
      
      private function destroyTabs() : void
      {
         for(var tabSku in this.mTabs)
         {
            if(this.getTabNumScrollableItems(tabSku) == 0)
            {
               while(this.mTabs[tabSku].numChildren)
               {
                  (this.mTabs[tabSku].getChildAt(0) as ESprite).destroy();
               }
            }
            else
            {
               this.mTabs[tabSku].destroy();
            }
            delete this.mTabs[tabSku];
         }
      }
      
      public function setPageId(pc:EPaginatorComponent, id:int) : void
      {
         var scrollBar:EScrollBar = null;
         var oldPage:int = this.mCurrentPage;
         this.mCurrentPage = id;
         if(oldPage == this.mCurrentPage || this.mCurrentPage < 0 || this.mCurrentPage >= TAB_ORDER.length)
         {
            return;
         }
         this.destroyTabs();
         var tabSku:String = String(TAB_ORDER[this.mCurrentPage]);
         var numScrollableItems:int = this.getTabNumScrollableItems(tabSku);
         switch(tabSku)
         {
            case "poll":
               this.createPagePoll(this.mTabContent);
               this.mTabs[tabSku] = this.mTabContent;
               break;
            case "media":
               this.createPageMedia(this.mTabContent);
               this.mTabs[tabSku] = this.mTabContent;
               break;
            case "updates":
               this.mTabs["updates"] = new EScrollArea();
               this.mTabs["updates"].build(this.mScrollArea,numScrollableItems,ESpriteContainer,this.fillUpdateData,40);
               break;
            case "guidelines":
               this.mTabs["guidelines"] = new EScrollArea();
               this.mTabs["guidelines"].build(this.mScrollArea,numScrollableItems,ESpriteContainer,this.fillGuidelineData,20);
         }
         setContent(tabSku,this.mTabs[tabSku]);
         this.mBody.eAddChild(this.mTabs[tabSku]);
         if(numScrollableItems > 0)
         {
            scrollBar = this.mViewFactory.getEScrollBar(this.mTabs[tabSku]);
            if(tabSku == "updates")
            {
               scrollBar.setScrollAmount(60);
               scrollBar.setDraggerUpdateInterval(300);
            }
         }
      }
      
      private function getTabNumScrollableItems(tabSku:String) : int
      {
         var returnValue:int = 0;
         switch(tabSku)
         {
            case "poll":
            case "media":
               break;
            case "updates":
               return this.mUpdatesVector.length;
            case "guidelines":
               return this.mGuidelinesVector.length;
            default:
               return returnValue;
         }
         return 0;
      }
      
      private function getPollBar(pollDef:PollDef, width:int) : ESpriteContainer
      {
         var i:int = 0;
         var fillbar:EFillBar = null;
         var currentBarWidth:int = 0;
         var textArea:ELayoutArea = null;
         var field:ETextField = null;
         var voteAmounts:Array;
         if((voteAmounts = InstanceMng.getPollMng().getVotes()) == null)
         {
            return null;
         }
         var barSizes:Vector.<int> = new Vector.<int>(0);
         for(i = 0; i < pollDef.getNumOptions(); )
         {
            barSizes[i] = voteAmounts[i];
            if(i > 0)
            {
               var _loc17_:* = i;
               var _loc18_:* = barSizes[_loc17_] + barSizes[i - 1];
               barSizes[_loc17_] = _loc18_;
            }
            i++;
         }
         var barMax:int;
         if((barMax = barSizes[barSizes.length - 1]) == 0)
         {
            return null;
         }
         var OFFSET:int;
         var SEMIOFFSET:Number = (OFFSET = 8) / 2;
         var barArea:ELayoutArea;
         (barArea = ELayoutAreaFactory.createLayoutArea(width,50)).isSetPositionEnabled = false;
         var barContainer:ESpriteContainer = this.mViewFactory.getESpriteContainer();
         var barBkg:EFillBar = this.mViewFactory.createFillBar(0,barArea.width,barArea.height,0,"color_fill_bkg");
         barContainer.setContent("barBkg",barBkg);
         barContainer.eAddChild(barBkg);
         barBkg.layoutApplyTransformations(barArea);
         var previousBarWidth:* = 0;
         for(i = 0; i < pollDef.getNumOptions(); )
         {
            (fillbar = this.mViewFactory.createFillBar(1,barArea.width - OFFSET,barArea.height - OFFSET,barMax,"color_score")).setValue(barSizes[i]);
            currentBarWidth = (barArea.width - OFFSET) * (barSizes[i] / barMax);
            fillbar.transform.colorTransform = DCUtils.setInk(DCUtils.smColorTransformInit,pollDef.getBarColor(i),1);
            barContainer.setContent("fillbar_" + i,fillbar);
            barContainer.eAddChildAt(fillbar,1);
            fillbar.layoutApplyTransformations(barArea);
            fillbar.logicLeft += SEMIOFFSET;
            fillbar.logicTop += SEMIOFFSET;
            (textArea = ELayoutAreaFactory.createLayoutArea(currentBarWidth - previousBarWidth,fillbar.height)).x = fillbar.x + previousBarWidth;
            textArea.y = fillbar.y;
            (field = this.mViewFactory.getETextField(null,ELayoutAreaFactory.createLayoutTextAreaFromLayoutArea(textArea),"text_title_0")).setText(DCTextMng.convertNumberToString(voteAmounts[i],-1,-1));
            field.setHAlign("center");
            field.setVAlign("center");
            field.setFontSize(24);
            if(i == InstanceMng.getPollMng().getMyVote())
            {
               field.applySkinProp(null,"mouse_over_button");
            }
            barContainer.setContent("field_" + i,field);
            barContainer.eAddChildAt(field,barContainer.numChildren);
            previousBarWidth = currentBarWidth;
            i++;
         }
         return barContainer;
      }
      
      private function createPagePoll(spriteReference:ESpriteContainer) : void
      {
         var i:int = 0;
         var btn:EButton = null;
         var barContainer:ESpriteContainer = null;
         var tabContentContainer:ESpriteContainer;
         (tabContentContainer = this.mViewFactory.getESpriteContainer()).setLayoutArea(spriteReference.getLayoutArea(),false);
         var BAR_WIDTH:int = 500;
         var pollDef:PollDef = InstanceMng.getPollMng().getPollDef();
         var bodyFieldArea:ELayoutTextArea = ELayoutAreaFactory.createLayoutTextAreaFromLayoutArea(ELayoutAreaFactory.createLayoutArea(BAR_WIDTH,100));
         var bodyField:ETextField;
         (bodyField = this.mViewFactory.getETextField(null,bodyFieldArea,"text_body")).setText(pollDef.getTextBody());
         bodyField.setMultiline(true);
         bodyField.autoSize(true);
         bodyField.setFontSize(18);
         tabContentContainer.setContent("bodyField",bodyField);
         tabContentContainer.eAddChild(bodyField);
         var optionBtns:Array = [];
         var btnContainer:ESpriteContainer = this.mViewFactory.getESpriteContainer();
         var buttonsArea:ELayoutArea;
         (buttonsArea = ELayoutAreaFactory.createLayoutArea(BAR_WIDTH,100)).isSetPositionEnabled = false;
         for(i = 0; i < pollDef.getNumOptions(); )
         {
            (btn = this.mViewFactory.getButtonSocial(null,null,pollDef.getOptionText(i))).name = "option_button_" + i;
            btn.eAddEventListener("click",this.onPollOptionClicked);
            btn.setIsEnabled(InstanceMng.getPollMng().isVoteAvailable());
            optionBtns.push(btn);
            btnContainer.setContent(btn.name,btn);
            btnContainer.eAddChild(btn);
            i++;
         }
         tabContentContainer.setContent("btns",btnContainer);
         tabContentContainer.eAddChild(btnContainer);
         this.mViewFactory.distributeSpritesInArea(buttonsArea,optionBtns,0,1,-1,1);
         var containersToDistribute:Array = [bodyField,btnContainer];
         var showResults:*;
         if(showResults = pollDef.getVisibleResult())
         {
            showResults = (barContainer = this.getPollBar(pollDef,BAR_WIDTH)) != null;
         }
         if(showResults)
         {
            tabContentContainer.setContent("bar",barContainer);
            tabContentContainer.eAddChild(barContainer);
            containersToDistribute = [bodyField,barContainer,btnContainer];
         }
         this.mViewFactory.distributeSpritesInArea(tabContentContainer.getLayoutArea(),containersToDistribute,1,1,1,-1);
         spriteReference.setContent("tab_container",tabContentContainer);
         spriteReference.eAddChild(tabContentContainer);
      }
      
      private function createPageMedia(spriteReference:ESpriteContainer) : void
      {
         var icon:EButton = null;
         var i:int = 0;
         var text:String = null;
         var tabContentContainer:ESpriteContainer = this.mViewFactory.getESpriteContainer();
         var tArea:ELayoutTextArea = ELayoutAreaFactory.createLayoutTextAreaFromLayoutTextArea(this.mViewFactory.getLayoutAreaFactory("ContainerTextField").getTextArea("text_info"));
         tArea.x = 0;
         tArea.y = 20;
         tArea.width = spriteReference.getLogicWidth();
         tArea.height = 20;
         var field:ETextField;
         (field = this.mViewFactory.getETextField(null,tArea,"text_title_0")).setText(DCTextMng.getText(3703));
         field.setHAlign("center");
         field.setMultiline(true);
         field.name = "subtitle";
         tabContentContainer.setContent(field.name,field);
         tabContentContainer.eAddChild(field);
         var icons:Array = [];
         var iconImageSkus:Vector.<String> = new <String>["icon_yt","icon_discord","icon_instagram","icon_polls","icon_tiktok"];
         var iconTooltipsTids:Vector.<int> = new <int>[4077,4078,4079,4080,4099];
         var urls:Vector.<String> = new <String>["https://www.youtube.com/@PhoenixNetwork","https://discord.com/invite/galaxylife","https://www.instagram.com/phoenixnetwork","https://polls.galaxylifegame.net","https://www.tiktok.com/@galaxylifeofficial"];
         var area:ELayoutArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(this.mViewFactory.getLayoutAreaFactory("IconTextXL").getArea("icon"),1);
         for(i = 0; i < urls.length; )
         {
            area = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(area);
            area.isSetPositionEnabled = false;
            text = DCTextMng.getText(iconTooltipsTids[i]);
            (icon = this.mViewFactory.getButtonIconLink(iconImageSkus[i],urls[i],area)).name = text;
            ETooltipMng.getInstance().createTooltipInfoFromText(text,icon,null,true,false);
            icon.getBackground().visible = false;
            icons.push(icon);
            tabContentContainer.eAddChild(icon);
            tabContentContainer.setContent("icon_" + i,icon);
            i++;
         }
         tabContentContainer.setLayoutArea(spriteReference.getLayoutArea(),false);
         this.mViewFactory.distributeSpritesInArea(tabContentContainer.getLayoutArea(),icons,1,1,-1,2);
         spriteReference.setContent("tab_container",tabContentContainer);
         spriteReference.eAddChild(tabContentContainer);
      }
      
      private function fillUpdateData(spriteReference:ESpriteContainer, rowOffset:int, rebuild:Boolean) : void
      {
         var layoutArea:ELayoutArea = null;
         var img:EImage = null;
         var field:ETextField = null;
         var date:String = String(this.mUpdatesVector[rowOffset]["date"]);
         var content:String = String(this.mUpdatesVector[rowOffset]["content"]);
         var contentWidth:int = this.mScrollArea.width - 10;
         (layoutArea = ELayoutAreaFactory.createLayoutArea(contentWidth,20)).x = 0;
         layoutArea.y = 0;
         (field = this.mViewFactory.getETextField(null,ELayoutAreaFactory.createLayoutTextAreaFromLayoutArea(layoutArea),"text_title_0")).setMultiline(true);
         field.autoSize(true);
         field.setFontSize(18);
         field.setHAlign("center");
         field.setVAlign("top");
         field.setText(date);
         layoutArea.height = field.height;
         img = this.mViewFactory.getEImage("box_simple",null,false,layoutArea,"color_blue_box");
         spriteReference.eAddChild(img);
         spriteReference.setContent("dateBkg",img);
         spriteReference.eAddChild(field);
         spriteReference.setContent("dateField",field);
         (layoutArea = ELayoutAreaFactory.createLayoutArea(contentWidth,100)).x = 0;
         layoutArea.y = field.logicY + field.height + 10;
         (field = this.mViewFactory.getETextField(null,ELayoutAreaFactory.createLayoutTextAreaFromLayoutArea(layoutArea),"text_body")).setMultiline(true);
         field.autoSize(true);
         field.setHAlign("left");
         field.setText(content);
         layoutArea.height = field.height;
         img = this.mViewFactory.getEImage("box_simple",null,false,layoutArea,"color_blue_box");
         spriteReference.eAddChild(img);
         spriteReference.setContent("contentBkg",img);
         spriteReference.eAddChild(field);
         spriteReference.setContent("contentField",field);
         if(rowOffset < this.mUpdatesVector.length - 1)
         {
            (layoutArea = ELayoutAreaFactory.createLayoutArea(contentWidth)).x = 0;
            layoutArea.y = field.logicY + field.height + 10 * 3;
            layoutArea.height = 10;
            img = this.mViewFactory.getEImage("box_simple",null,false,layoutArea,"disabled");
            spriteReference.eAddChild(img);
            spriteReference.setContent("divider",img);
         }
      }
      
      private function fillGuidelineData(spriteReference:ESpriteContainer, rowOffset:int, rebuild:Boolean) : void
      {
         var layoutArea:ELayoutArea = null;
         var img:EImage = null;
         var field:ETextField = null;
         (layoutArea = ELayoutAreaFactory.createLayoutArea(this.mScrollArea.width - 10,40)).x = 0;
         layoutArea.y = 0;
         (field = this.mViewFactory.getETextField(null,ELayoutAreaFactory.createLayoutTextAreaFromLayoutArea(layoutArea),"text_body")).setMultiline(true);
         field.autoSize(true);
         field.setHAlign("left");
         field.setVAlign("center");
         field.setText(this.mGuidelinesVector[rowOffset]);
         layoutArea.height = field.height;
         img = this.mViewFactory.getEImage("box_simple",null,false,layoutArea,"color_blue_box");
         spriteReference.eAddChild(img);
         spriteReference.setContent("ruleBkg",img);
         spriteReference.eAddChild(field);
         spriteReference.setContent("ruleField",field);
      }
      
      private function reloadPollData() : void
      {
         this.setPageId(null,-1);
         this.setPageId(null,TAB_ORDER.indexOf("poll"));
      }
      
      private function onPollOptionClicked(evt:EEvent) : void
      {
         var optionId:int = parseInt(evt.getTarget().name.slice("option_button_".length));
         InstanceMng.getPollMng().applyMyVote(optionId);
         this.reloadPollData();
      }
   }
}
