package com.dchoc.game.eview.widgets.contest
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.eview.widgets.paginator.TabHeadersView;
   import com.dchoc.game.model.contest.ContestReward;
   import com.dchoc.game.model.contest.ContestUser;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import esparragon.widgets.paginator.EPaginatorComponent;
   import esparragon.widgets.paginator.EPaginatorController;
   
   public class PopupContest extends EGamePopup implements EPaginatorController
   {
      
      private static const BODY_SKU:String = "body";
      
      private static const TABS_AREA_SKU:String = "Tabs";
      
      private static const TAB_1:String = "tab_1";
      
      private static const TAB_2:String = "tab_2";
      
      private static const TAB_3:String = "tab_3";
      
      private static const BODY_AMBASSADOR:String = "bodyAmbassador";
      
      private static const BODY_LEADERBOARD:String = "bodyLeaderBoard";
      
      private static const BODY_REWARDS:String = "bodyRewards";
      
      private static const PAGE_AMBASSADOR:int = 0;
      
      private static const PAGE_LEADERBOARD:int = 1;
      
      private static const PAGE_REWARDS:int = 2;
       
      
      private var mTabHeaders:TabHeadersView;
      
      private var mCurrentPage:int;
      
      private var mIsBuilt:Boolean;
      
      private var mPaginatorComponent:EPaginatorComponent;
      
      private var mTabs:Vector.<EButton>;
      
      public function PopupContest()
      {
         super();
         this.mCurrentPage = 0;
      }
      
      override public function setup(popupId:String, viewFactory:ViewFactory, skinId:String) : void
      {
         var container:ESpriteContainer = null;
         super.setup(popupId,viewFactory,skinId);
         var layoutFactory:ELayoutAreaFactory;
         var area:ELayoutArea = (layoutFactory = mViewFactory.getLayoutAreaFactory("PopXLTabs")).getArea("bg");
         setLayoutArea(area);
         var bkg:ESprite = viewFactory.getEImage("pop_xl",mSkinSku,false,area);
         setBackground(bkg);
         eAddChild(bkg);
         var title:ETextField = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_title"));
         setTitle(title);
         setTitleText(DCTextMng.getText(TextIDs[InstanceMng.getContestMng().getTitle()]));
         bkg.eAddChild(title);
         title.applySkinProp(mSkinSku,"text_title_0");
         area = layoutFactory.getArea("body");
         var body:ESprite = mViewFactory.getEImage("tabBody",mSkinSku,false,area);
         bkg.eAddChild(body);
         setContent("body",body);
         var closeButton:EButton = mViewFactory.getButtonClose(mSkinSku,layoutFactory.getArea("btn_close"));
         bkg.eAddChild(closeButton);
         setCloseButton(closeButton);
         closeButton.eAddEventListener("click",this.onCloseButton);
         area = layoutFactory.getArea("tab");
         var tabsArea:ESprite = mViewFactory.getESprite(mSkinSku,area);
         bkg.eAddChild(tabsArea);
         setContent("Tabs",tabsArea);
         this.mTabs = new Vector.<EButton>(0);
         var tab:EButton = mViewFactory.getTextTabHeaderPopup(DCTextMng.getText(3309));
         this.mTabs.push(tab);
         bkg.eAddChild(tab);
         setContent("tab_1",tab);
         tab = mViewFactory.getTextTabHeaderPopup(DCTextMng.getText(3315));
         this.mTabs.push(tab);
         bkg.eAddChild(tab);
         setContent("tab_2",tab);
         tab = mViewFactory.getTextTabHeaderPopup(DCTextMng.getText(3317));
         this.mTabs.push(tab);
         bkg.eAddChild(tab);
         setContent("tab_3",tab);
         this.mTabHeaders = new TabHeadersView(area,mViewFactory,mSkinSku);
         this.mTabHeaders.setTabHeaders(this.mTabs);
         this.mPaginatorComponent = new EPaginatorComponent();
         this.mPaginatorComponent.init(this.mTabHeaders,this);
         this.mTabHeaders.setPaginatorComponent(this.mPaginatorComponent);
         container = new TabBodyContestAmbassador(mViewFactory,mSkinSku);
         TabBodyContestAmbassador(container).setup();
         setContent("bodyAmbassador",container);
         body.eAddChild(container);
         this.mIsBuilt = true;
      }
      
      private function requestLeaderBoard() : void
      {
         this.lockPopup();
         InstanceMng.getContestMng().leaderboardRequest(this.buildStripesLeaderboard,this.onFailRequest,true);
      }
      
      private function getLeaderboardBody() : void
      {
         var container:ESprite = new BodyStripes(mViewFactory,mSkinSku);
         setContent("bodyLeaderBoard",container);
      }
      
      private function buildStripesLeaderboard(e:Object) : void
      {
         var usersCount:int = 0;
         var stripesInfo:Array = null;
         var i:int = 0;
         var instances:Array = null;
         var texts:Array = null;
         if(!mIsBeingShown)
         {
            return;
         }
         var PROPS:Array = new Array("stripe_1","stripe_2","stripe_3");
         var usersContest:Vector.<ContestUser> = InstanceMng.getContestMng().leaderboardGetUsers();
         var body:BodyStripes;
         if((body = getContent("bodyLeaderBoard") as BodyStripes) == null)
         {
            this.getLeaderboardBody();
            body = getContent("bodyLeaderBoard") as BodyStripes;
         }
         var bkg:ESprite;
         (bkg = getContent("body")).eAddChild(body);
         if(usersContest != null)
         {
            if(usersContest.length > 0)
            {
               usersCount = int(usersContest.length);
               stripesInfo = [];
               for(i = 0; i < usersCount; )
               {
                  stripesInfo.push(usersContest[i]);
                  i++;
               }
               instances = ["text_position","text_player","text_progress"];
               texts = [DCTextMng.getText(3342),DCTextMng.getText(3343),DCTextMng.getText(3344)];
               body.createStripesHeader("ContestLeaderboardHeader",instances,texts,"text_header");
               body.setStrips(stripesInfo,"PopXLTabs",null);
            }
         }
         else
         {
            body.setStrips(null,"PopXLTabs",DCTextMng.getText(3316));
         }
         this.unlockPopup();
      }
      
      private function onFailRequest(e:Object) : void
      {
         var body:BodyStripes = null;
         var bkg:ESprite = null;
         if(mIsBeingShown)
         {
            body = getContent("bodyLeaderBoard") as BodyStripes;
            if(body == null)
            {
               this.getLeaderboardBody();
               body = getContent("bodyLeaderBoard") as BodyStripes;
            }
            bkg = getContent("body");
            bkg.eAddChild(body);
            body.setStrips(null,"PopXLTabs",DCTextMng.getText(3316));
            this.unlockPopup();
         }
      }
      
      private function buildStripesRewards() : void
      {
         var stripes:Array = null;
         var rewardsCount:int = 0;
         var i:int = 0;
         var body:BodyStripes = null;
         var instances:Array = null;
         var texts:Array = null;
         if(!mIsBeingShown)
         {
            return;
         }
         var container:ESprite = new BodyStripes(mViewFactory,mSkinSku);
         setContent("bodyRewards",container);
         var rewards:Vector.<ContestReward>;
         if((rewards = InstanceMng.getContestMng().rewardsGetRewardsForView()) != null)
         {
            stripes = [];
            rewardsCount = int(rewards.length);
            for(i = 0; i < rewardsCount; )
            {
               stripes.push(rewards[i]);
               i++;
            }
            body = getContent("bodyRewards") as BodyStripes;
            instances = ["text_position","text_reward"];
            texts = [DCTextMng.getText(3342),DCTextMng.getText(35)];
            body.createStripesHeader("ContestRewardsHeader",instances,texts,"text_header");
            body.setStrips(stripes,"PopXLTabs",null);
         }
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var container:ESpriteContainer = null;
         if(this.mIsBuilt)
         {
            if(this.mCurrentPage == 0)
            {
               container = getContent("bodyAmbassador") as ESpriteContainer;
               if(container != null)
               {
                  TabBodyContestAmbassador(container).logicUpdate(dt);
               }
            }
         }
         super.logicUpdate(dt);
      }
      
      private function onCloseButton(e:EEvent) : void
      {
         InstanceMng.getPopupMng().closePopup(this);
      }
      
      public function setPageId(pc:EPaginatorComponent, id:int) : void
      {
         var PAGES:Array = null;
         var TABS:Array = null;
         var body:ESprite = null;
         var bkg:ESprite = null;
         if(this.mCurrentPage != id)
         {
            PAGES = new Array("bodyAmbassador","bodyLeaderBoard","bodyRewards");
            TABS = new Array("tab_1","tab_2","tab_3");
            body = getContent(PAGES[this.mCurrentPage]);
            bkg = getContent("body");
            if(body != null)
            {
               bkg.eRemoveChild(body);
               if(body is BodyStripes)
               {
                  body.destroy();
                  body = null;
                  setContent(PAGES[this.mCurrentPage],null);
               }
            }
            this.mCurrentPage = id;
            if(this.mCurrentPage == 1)
            {
               this.requestLeaderBoard();
            }
            else if(this.mCurrentPage == 2)
            {
               this.buildStripesRewards();
            }
            if((body = getContent(PAGES[this.mCurrentPage])) != null)
            {
               bkg.eAddChild(body);
            }
            this.mTabHeaders.setPageId(id);
         }
      }
      
      override public function lockPopup(componentId:String = null) : void
      {
         var button:EButton = null;
         super.lockPopup(componentId);
         for each(button in this.mTabs)
         {
            button.mouseEnabled = false;
         }
      }
      
      override public function unlockPopup() : void
      {
         var button:EButton = null;
         super.unlockPopup();
         for each(button in this.mTabs)
         {
            button.mouseEnabled = true;
         }
      }
   }
}
