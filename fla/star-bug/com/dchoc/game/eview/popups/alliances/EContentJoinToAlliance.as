package com.dchoc.game.eview.popups.alliances
{
   import com.dchoc.game.controller.alliances.AlliancesControllerStar;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.paginator.TabHeadersView;
   import com.dchoc.game.model.alliances.AlliancesAPIEvent;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.EScrollArea;
   import esparragon.display.EScrollBar;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import esparragon.widgets.paginator.EPaginatorComponent;
   import esparragon.widgets.paginator.EPaginatorController;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   
   public class EContentJoinToAlliance extends ESpriteContainer implements EPaginatorController
   {
       
      
      private const BUTTON_CREATE:String = "button_create";
      
      private const TAB_SUGGESTION:String = "tabSuggestion";
      
      private const TAB_LEADERBOARD:String = "tabLeaderBoard";
      
      private const TAB_BODY:String = "tabBody";
      
      private const BUTTON_REFRESH:String = "button_refresh";
      
      private const NUM_STRIPES:int = 4;
      
      private const INITIAL_REQUEST:int = 50;
      
      private const AMOUNT_TO_REQUEST:int = 25;
      
      private const SCROLL_DOWN_PERCENTAGE:int = 95;
      
      private const SCROLL_UP_PERCENTAGE:int = 5;
      
      private const PAGE_SUGGESTIONS:int = 0;
      
      private const PAGE_LEADERBOARD:int = 1;
      
      private const SCROLLING_UP:int = 0;
      
      private const SCROLLING_DOWN:int = 1;
      
      private var mSkinSku:String;
      
      private var mViewFactory:ViewFactory;
      
      private var mAllianceController:AlliancesControllerStar;
      
      private var mSearchInput:ETextField;
      
      private var mTabs:Vector.<EButton>;
      
      private var mTabView:TabHeadersView;
      
      private var mPaginator:EPaginatorComponent;
      
      private var mCurrentPage:int = -1;
      
      private var mStripesArea:ELayoutArea;
      
      private var mBodyWidth:Number;
      
      private var mWord:String;
      
      private var mAlliances:Array;
      
      private var mScrollArea:EScrollArea;
      
      private var mScrollBar:EScrollBar;
      
      private var mAlliancesRequested:int;
      
      private var mRequestInProgress:Boolean;
      
      private var mTotalAlliances:int;
      
      private var mScrollDir:int;
      
      private var mPage:int;
      
      private var mStripeHeight:Number = 0;
      
      public function EContentJoinToAlliance(viewFactory:ViewFactory, skinSku:String)
      {
         super();
         this.mSkinSku = skinSku;
         this.mViewFactory = viewFactory;
         this.mAllianceController = AlliancesControllerStar(InstanceMng.getAlliancesController());
         this.mWord = "";
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         this.mStripesArea = null;
         this.mTabs = null;
         this.mTabView = null;
         this.mPaginator = null;
         this.mScrollBar = null;
         this.mScrollArea = null;
      }
      
      public function build() : void
      {
         var img:EImage = null;
         var field:ETextField = null;
         var layoutFactory:ELayoutAreaFactory;
         var area:ELayoutArea = (layoutFactory = this.mViewFactory.getLayoutAreaFactory("LayoutBodyJoinAlliance")).getArea("btn_xxl");
         var button:EButton = this.mViewFactory.getButtonByTextWidth(DCTextMng.getText(2778),area.width,"btn_accept",null,this.mSkinSku,"XXL");
         setContent("button_create",button);
         eAddChild(button);
         button.layoutApplyTransformations(area);
         button.eAddEventListener("click",this.onCreateAlliance);
         (field = this.mViewFactory.getETextField(this.mSkinSku,layoutFactory.getTextArea("text_title_search"),"text_subheader")).setText(DCTextMng.getText(2900));
         eAddChild(field);
         setContent("searchTitle",field);
         img = this.mViewFactory.getEImage("box_simple",this.mSkinSku,false,layoutFactory.getArea("search_area"),"color_blue_box");
         eAddChild(img);
         setContent("searchBkg",img);
         button = this.mViewFactory.getButtonImage("btn_search",this.mSkinSku,layoutFactory.getArea("btn_search"));
         eAddChild(button);
         setContent("buttonSearch",button);
         button.eAddEventListener("click",this.onSearchClick);
         this.mSearchInput = this.mViewFactory.getETextField(this.mSkinSku,layoutFactory.getTextArea("text_search"),"text_body");
         this.mSearchInput.setEditable(true);
         eAddChild(this.mSearchInput);
         setContent("searchField",this.mSearchInput);
         this.mSearchInput.setText(DCTextMng.getText(2839));
         this.mSearchInput.getTextField().addEventListener("keyDown",this.onSearchKeyDown);
         this.mSearchInput.getTextField().addEventListener("click",this.onSearchIn);
         this.mSearchInput.getTextField().addEventListener("focusOut",this.onSearchOut);
         img = this.mViewFactory.getEImage("tabBody",this.mSkinSku,false,layoutFactory.getArea("area_tabs_content"));
         setContent("tabBody",img);
         eAddChild(img);
         this.mBodyWidth = layoutFactory.getArea("area_tabs_content").width;
         this.mTabs = new Vector.<EButton>(0);
         button = this.mViewFactory.getTextTabHeaderPopup(DCTextMng.getText(2901),this.mSkinSku);
         eAddChild(button);
         setContent("tabSuggestion",button);
         this.mTabs.push(button);
         button = this.mViewFactory.getTextTabHeaderPopup(DCTextMng.getText(2835),this.mSkinSku);
         eAddChild(button);
         setContent("tabLeaderBoard",button);
         this.mTabs.push(button);
         this.mTabView = new TabHeadersView(layoutFactory.getArea("tab"),this.mViewFactory,this.mSkinSku);
         this.mTabView.setTabHeaders(this.mTabs);
         this.mPaginator = new EPaginatorComponent();
         this.mPaginator.init(this.mTabView,this);
         this.mTabView.setPaginatorComponent(this.mPaginator);
         (field = this.mViewFactory.getETextField(this.mSkinSku,layoutFactory.getTextArea("text_title_rank"),"text_subheader")).setText(DCTextMng.getText(2840));
         eAddChild(field);
         setContent("rank",field);
         (field = this.mViewFactory.getETextField(this.mSkinSku,layoutFactory.getTextArea("text_title_name"),"text_subheader")).setText(DCTextMng.getText(2811));
         eAddChild(field);
         setContent("name",field);
         (field = this.mViewFactory.getETextField(this.mSkinSku,layoutFactory.getTextArea("text_title_members"),"text_subheader")).setText(DCTextMng.getText(2807));
         eAddChild(field);
         setContent("members",field);
         (field = this.mViewFactory.getETextField(this.mSkinSku,layoutFactory.getTextArea("text_title_victories"),"text_subheader")).setText(DCTextMng.getText(2841));
         eAddChild(field);
         setContent("victories",field);
         var buttonArea:ELayoutArea = layoutFactory.getArea("btn_refresh");
         button = this.mViewFactory.getButtonByTextWidth(DCTextMng.getText(2903),buttonArea.width,"btn_accept");
         eAddChild(button);
         setContent("button_refresh",button);
         button.layoutApplyTransformations(buttonArea);
         button.eAddEventListener("click",this.onRefresh);
         this.mStripesArea = layoutFactory.getArea("stripes");
         this.setPageId(null,0);
         layoutFactory = this.mViewFactory.getLayoutAreaFactory("StripeAlliancesLeaderBoard");
         this.mStripeHeight = layoutFactory.getContainerLayoutArea().height;
      }
      
      public function setPageId(pc:EPaginatorComponent, id:int) : void
      {
         if(this.mCurrentPage != id)
         {
            this.mCurrentPage = id;
            this.resetScroll();
            this.mTabView.setPageId(id);
         }
      }
      
      private function resetScroll() : void
      {
         if(this.mAlliances != null)
         {
            this.mAlliances.length = 0;
         }
         this.removeStripes();
         if(!this.isSuggestion())
         {
            this.mAlliancesRequested = 0;
         }
         getContentAsEButton("button_refresh").visible = this.isSuggestion();
         this.mScrollDir = 1;
         this.mPage = 0;
         this.requestAlliances(50);
         this.mAlliancesRequested += 50;
      }
      
      private function isSuggestion() : Boolean
      {
         return this.mCurrentPage == 0;
      }
      
      private function requestAlliances(requestFor:int) : void
      {
         this.mRequestInProgress = true;
         if(this.isSuggestion())
         {
            this.mAllianceController.requestAlliances(this.onSuccess,this.onFail,true,0,4);
         }
         else
         {
            this.mAllianceController.requestAlliances(this.onSuccess,this.onFail,true,this.mAlliancesRequested,requestFor,this.mWord);
         }
      }
      
      private function removeStripes() : void
      {
         if(this.mScrollArea != null)
         {
            eRemoveChild(this.mScrollArea);
            this.mScrollArea.destroy();
            this.mScrollArea = null;
         }
      }
      
      private function locateStripes(spriteReference:ESpriteContainer, rowOffset:int, rebuild:Boolean) : void
      {
         var stripe:EAllianceBoxJoin = null;
         if(rebuild)
         {
            (stripe = new EAllianceBoxJoin()).build();
            spriteReference.eAddChild(stripe);
            spriteReference.setContent("stripe",stripe);
         }
         (stripe = spriteReference.getChildAt(0) as EAllianceBoxJoin).setInfo(this.mAlliances[rowOffset]);
      }
      
      override public function logicUpdate(dt:int) : void
      {
         super.logicUpdate(dt);
         if(!this.mRequestInProgress && this.mScrollArea != null)
         {
            if(this.mScrollArea.getLogicYRelative() >= 95 / 100 && this.mAlliancesRequested < this.mTotalAlliances)
            {
               this.mPage++;
               if(this.mScrollDir == 0)
               {
                  this.mAlliancesRequested += 50;
               }
               this.mScrollDir = 1;
               this.requestAlliances(25);
               this.mAlliancesRequested += 25;
            }
            else if(this.mScrollArea.getLogicYRelative() <= 5 / 100 && this.mPage > 0)
            {
               this.mPage--;
               if(this.mScrollDir == 1)
               {
                  this.mAlliancesRequested -= 50;
               }
               this.mAlliancesRequested -= 25;
               this.mScrollDir = 0;
               this.requestAlliances(25);
            }
         }
      }
      
      public function setWordToSearch(value:String) : void
      {
         if(value == DCTextMng.getText(2900) || value == DCTextMng.getText(2839))
         {
            value = "";
         }
         this.mWord = value;
      }
      
      private function onSuccess(ae:AlliancesAPIEvent) : void
      {
         var pos:Number = NaN;
         this.mTotalAlliances += ae.count;
         this.removeStripes();
         if(this.mAlliances == null)
         {
            this.mAlliances = [];
         }
         if(this.mScrollDir == 1)
         {
            this.mAlliances.splice(0,25);
            this.mAlliances = this.mAlliances.concat(ae.alliance_array);
         }
         else
         {
            this.mAlliances.splice(25,25);
            this.mAlliances = ae.alliance_array.concat(this.mAlliances);
         }
         if(this.mAlliances.length > 0)
         {
            this.mScrollArea = new EScrollArea();
            this.mScrollArea.build(this.mStripesArea,this.mAlliances.length,ESpriteContainer,this.locateStripes);
            this.mViewFactory.getEScrollBar(this.mScrollArea);
            if(this.isSuggestion() || this.mTotalAlliances <= 4)
            {
               this.mScrollArea.logicLeft = (this.mBodyWidth - this.mScrollArea.width) * 0.5;
            }
            else
            {
               pos = 0;
               if(this.mScrollDir == 1 && this.mPage > 0)
               {
                  pos = (Math.ceil(47.5) - 25 - 4 / 2) * this.mStripeHeight;
               }
               else if(this.mScrollDir == 0)
               {
                  pos = (Math.ceil(2.5) + 25 - 4 / 2) * this.mStripeHeight;
               }
               this.mScrollArea.scroll(pos);
               this.logicUpdate(0);
            }
            eAddChild(this.mScrollArea);
            setContent("scrollArea",this.mScrollArea);
         }
         this.mRequestInProgress = false;
      }
      
      private function onFail(ae:AlliancesAPIEvent) : void
      {
         this.removeStripes();
         DCDebug.trace("Fail alliances request");
      }
      
      private function onCreateAlliance(e:EEvent) : void
      {
         this.mAllianceController.guiOpenCreateAlliancePopup();
      }
      
      private function onSearchClick(e:EEvent) : void
      {
         var alliance:String = this.mSearchInput.getText();
         if(alliance == DCTextMng.getText(2839))
         {
            alliance = "";
         }
         if(EPopupAlliances(this.mAllianceController.getPopupAlliance()).canDoSearch(alliance,this.mWord))
         {
            this.setWordToSearch(alliance);
            this.mCurrentPage = -1;
            this.setPageId(null,1);
         }
      }
      
      private function onSearchIn(e:MouseEvent) : void
      {
         InstanceMng.getApplication().setToWindowedMode();
         if(this.mSearchInput.getText() == DCTextMng.getText(2839))
         {
            this.mSearchInput.getTextField().text = "";
         }
      }
      
      private function onSearchOut(e:FocusEvent) : void
      {
         var formattedText:String = this.mSearchInput.getText().replace(/ /g,"");
         if(formattedText == "")
         {
            if(this.mWord == "")
            {
               this.mSearchInput.setText(DCTextMng.getText(2839));
            }
         }
      }
      
      private function onSearchKeyDown(e:KeyboardEvent) : void
      {
         if(e.charCode == 13)
         {
            this.onSearchOut(null);
            this.onSearchClick(null);
         }
      }
      
      private function onRefresh(e:EEvent) : void
      {
         this.removeStripes();
         this.requestAlliances(50);
      }
   }
}
