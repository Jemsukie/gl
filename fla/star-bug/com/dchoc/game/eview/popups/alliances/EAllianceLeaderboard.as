package com.dchoc.game.eview.popups.alliances
{
   import com.dchoc.game.controller.alliances.AlliancesControllerStar;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.model.alliances.Alliance;
   import com.dchoc.game.model.alliances.AlliancesAPIEvent;
   import com.dchoc.game.model.alliances.AlliancesConstants;
   import com.dchoc.game.model.alliances.AlliancesUser;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.EScrollArea;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   
   public class EAllianceLeaderboard extends ESpriteContainer
   {
       
      
      private const CHECK_BOX:String = "check";
      
      private const INITIAL_REQUEST:int = 50;
      
      private const AMOUNT_TO_REQUEST:int = 25;
      
      private const SCROLL_DOWN_PERCENTAGE:int = 95;
      
      private const SCROLL_UP_PERCENTAGE:int = 5;
      
      private const SCROLLING_UP:int = 0;
      
      private const SCROLLING_DOWN:int = 1;
      
      private var mAllianceController:AlliancesControllerStar;
      
      private var mUserAlliance:Alliance;
      
      private var mUserMember:AlliancesUser;
      
      private var mIsLeader:Boolean;
      
      private var mSearchInput:ETextField;
      
      private var mWord:String = "";
      
      private var mAlliancesRequested:int;
      
      private var mStripesArea:ELayoutArea;
      
      private var mStripesContainer:ESpriteContainer;
      
      private var mAlliances:Array;
      
      private var mScrollArea:EScrollArea;
      
      private var mRequestInProgress:Boolean;
      
      private var mScrollDir:int;
      
      private var mTotalAlliances:int;
      
      private var mPage:int;
      
      private var mStripeHeight:Number;
      
      private var mVisibleStripes:int;
      
      private var mBodyWidth:Number;
      
      public function EAllianceLeaderboard()
      {
         super();
         this.mAllianceController = InstanceMng.getAlliancesController() as AlliancesControllerStar;
         this.mUserAlliance = this.mAllianceController.getMyAlliance();
         this.mUserMember = this.mAllianceController.getMyUser();
         this.mIsLeader = AlliancesConstants.canRoleInvitePeople(this.mUserMember.getRole());
      }
      
      override protected function extendedDestroy() : void
      {
         if(this.mSearchInput != null)
         {
            this.mSearchInput.getTextField().removeEventListener("keyDown",this.onSearchKeyDown);
            this.mSearchInput.getTextField().removeEventListener("click",this.onSearchIn);
            this.mSearchInput.getTextField().removeEventListener("focusOut",this.onSearchOut);
            this.mSearchInput = null;
         }
         super.extendedDestroy();
         this.removeStripes();
      }
      
      public function build() : void
      {
         var content:ESprite = null;
         var field:ETextField = null;
         var viewFactory:ViewFactory;
         var layoutFactory:ELayoutAreaFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("LayoutBodyAllianceLeaderboard");
         if(!Config.useAlliancesSuggested() && this.mIsLeader)
         {
            content = viewFactory.getCheckBox(layoutFactory.getArea("tick"));
            eAddChild(content);
            setContent("check",content);
            content.eAddEventListener("click",this.onCheckBoxClick);
            field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_recruitment"),"text_body_2");
            field.setText(DCTextMng.getText(455));
            eAddChild(field);
            setContent("text_inwar",field);
         }
         var img:EImage = viewFactory.getEImage("box_simple",null,false,layoutFactory.getArea("search_area"),"color_blue_box");
         eAddChild(img);
         setContent("searchBkg",img);
         this.mSearchInput = viewFactory.getETextField(null,layoutFactory.getTextArea("text_search"),"text_body");
         eAddChild(this.mSearchInput);
         this.mSearchInput.setEditable(true);
         this.mSearchInput.setMultiline(false);
         this.mSearchInput.setText(DCTextMng.getText(2839));
         this.mSearchInput.getTextField().addEventListener("keyDown",this.onSearchKeyDown);
         this.mSearchInput.getTextField().addEventListener("click",this.onSearchIn);
         this.mSearchInput.getTextField().addEventListener("focusOut",this.onSearchOut);
         setContent("searchInput",this.mSearchInput);
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_title_search"),"text_subheader");
         field.setText(DCTextMng.getText(2900));
         eAddChild(field);
         setContent("searchTitle",field);
         var button:EButton = viewFactory.getButtonImage("btn_search",null,layoutFactory.getArea("btn_search"));
         eAddChild(button);
         setContent("buttonSearch",button);
         button.eAddEventListener("click",this.onSearchClick);
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_title_position"),"text_subheader");
         field.setText(DCTextMng.getText(2840));
         setContent("rank",field);
         eAddChild(field);
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_title_name"),"text_subheader");
         field.setText(DCTextMng.getText(2811));
         setContent("name",field);
         eAddChild(field);
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_title_victories"),"text_subheader");
         field.setText(DCTextMng.getText(2841));
         setContent("Warswon",field);
         eAddChild(field);
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_title_level"),"text_subheader");
         field.setText(DCTextMng.getText(2842));
         setContent("level",field);
         eAddChild(field);
         field = viewFactory.getETextField(null,layoutFactory.getTextArea("text_title_warpoints"),"text_subheader");
         field.setText(DCTextMng.getText(2813));
         setContent("warpoints",field);
         eAddChild(field);
         this.mStripesArea = layoutFactory.getArea("stripes");
         layoutFactory = viewFactory.getLayoutAreaFactory("StripeAlliancesLeaderBoard");
         this.mStripeHeight = layoutFactory.getContainerLayoutArea().height;
         this.mVisibleStripes = Math.ceil(this.mStripesArea.height / this.mStripeHeight);
         layoutFactory = viewFactory.getLayoutAreaFactory("PopXLNoTabsNoFooter");
         this.mBodyWidth = layoutFactory.getArea("body").width;
         this.resetAlliances(true);
      }
      
      private function resetAlliances(searchMYAlli:Boolean) : void
      {
         this.mAlliancesRequested = 0;
         this.mScrollDir = 1;
         this.mPage = 0;
         if(this.mAlliances != null)
         {
            this.mAlliances.length = 0;
         }
         this.requestAlliances(50,searchMYAlli);
         this.mAlliancesRequested += 50;
      }
      
      private function requestAlliances(requestFor:int, searchMyAlliance:Boolean) : void
      {
         this.mRequestInProgress = true;
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         var checkBox:ESpriteContainer = getContentAsESpriteContainer("check");
         this.mAllianceController.requestAlliances(this.onRequestSuccess,this.onRequestFailed,true,this.mAlliancesRequested,requestFor,this.mWord,searchMyAlliance);
      }
      
      private function locateStripes(spriteReference:ESpriteContainer, rowOffset:int, rebuild:Boolean) : void
      {
         var stripe:EAllianceBoxLeaderboard = null;
         if(rebuild)
         {
            (stripe = new EAllianceBoxLeaderboard()).build();
            spriteReference.eAddChild(stripe);
            spriteReference.setContent("stripe",stripe);
         }
         (stripe = spriteReference.getChildAt(0) as EAllianceBoxLeaderboard).setInfo(this.mAlliances[rowOffset]);
      }
      
      private function removeStripes() : void
      {
         if(this.mStripesContainer != null)
         {
            this.mStripesContainer.destroy();
            this.mStripesContainer = null;
         }
         if(this.mScrollArea != null)
         {
            this.mScrollArea.destroy();
            this.mScrollArea = null;
         }
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
               this.requestAlliances(25,false);
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
               this.requestAlliances(25,false);
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
      
      private function onRequestSuccess(ae:AlliancesAPIEvent) : void
      {
         var requestParams:Object = null;
         var searchMyAlli:Boolean = false;
         var searchMyAlliKey:String = null;
         var pos:Number = NaN;
         var index:int = 0;
         var alli:Alliance = null;
         var total:int = 0;
         var viewFactory:ViewFactory = InstanceMng.getViewFactory();
         this.removeStripes();
         this.mTotalAlliances += ae.count;
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
            viewFactory.getEScrollBar(this.mScrollArea);
            requestParams = ae.getRequestParams();
            searchMyAlli = false;
            if(requestParams != null)
            {
               searchMyAlliKey = AlliancesConstants.objGetKey(requestParams,"userPage");
               if(requestParams[searchMyAlliKey] != null)
               {
                  searchMyAlli = Boolean(requestParams[searchMyAlliKey]);
               }
            }
            if(this.mTotalAlliances <= this.mVisibleStripes)
            {
               this.mScrollArea.logicLeft = (this.mBodyWidth - this.mScrollArea.width) / 2;
            }
            else
            {
               pos = 0;
               if(searchMyAlli)
               {
                  index = 0;
                  for each(alli in this.mAlliances)
                  {
                     if(alli.getId() == this.mUserAlliance.getId())
                     {
                        break;
                     }
                     index++;
                  }
                  pos = index * this.mStripeHeight;
                  this.mAlliancesRequested = Math.ceil(this.mUserAlliance.getRank() / 50) * 50;
                  total = this.mAlliancesRequested - 50;
               }
               else if(this.mScrollDir == 1 && this.mPage > 0)
               {
                  pos = (Math.ceil(47.5) - 25 - this.mVisibleStripes / 2) * this.mStripeHeight;
               }
               else if(this.mScrollDir == 0)
               {
                  pos = (Math.ceil(2.5) + 25 - this.mVisibleStripes / 2) * this.mStripeHeight;
               }
               this.mScrollArea.scroll(pos);
               this.logicUpdate(0);
            }
            eAddChild(this.mScrollArea);
            setContent("scrollArea",this.mScrollArea);
         }
         this.mRequestInProgress = false;
      }
      
      private function onRequestFailed(ae:AlliancesAPIEvent) : void
      {
         this.removeStripes();
         this.mRequestInProgress = false;
         DCDebug.trace("Alliance Leaderboard. Fail request alliances");
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
            this.resetAlliances(false);
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
      
      private function onCheckBoxClick(e:EEvent) : void
      {
         this.resetAlliances(this.mUserAlliance.isInAWar());
      }
   }
}
