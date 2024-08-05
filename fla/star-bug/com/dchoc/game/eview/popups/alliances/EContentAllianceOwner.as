package com.dchoc.game.eview.popups.alliances
{
   import com.dchoc.game.controller.alliances.AlliancesControllerStar;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.paginator.TabHeadersView;
   import com.dchoc.game.model.alliances.Alliance;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   import esparragon.widgets.paginator.EPaginatorComponent;
   import esparragon.widgets.paginator.EPaginatorController;
   
   public class EContentAllianceOwner extends ESpriteContainer implements EPaginatorController
   {
      
      public static const PAGE_HQ:int = 0;
      
      public static const PAGE_WAR:int = 1;
      
      public static const PAGE_LEADERBOARD:int = 2;
      
      public static const PAGE_HISTORY:int = 3;
      
      public static const PAGE_REWARDS:int = 4;
       
      
      private const BODY:String = "body";
      
      private const TAB:String = "tab";
      
      private const CONTENT:String = "content";
      
      private var mTabsView:TabHeadersView;
      
      private var mPaginator:EPaginatorComponent;
      
      private var mCurrentPage:int = -1;
      
      private var mAllianceController:AlliancesControllerStar;
      
      private var mUserAlliance:Alliance;
      
      public function EContentAllianceOwner()
      {
         super();
         this.mAllianceController = InstanceMng.getAlliancesController() as AlliancesControllerStar;
         this.mUserAlliance = this.mAllianceController.getMyAlliance();
      }
      
      public function build() : void
      {
         var tab:EButton = null;
         var viewFactory:ViewFactory;
         var layoutFactory:ELayoutAreaFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("PopXLTabsNoFooter");
         var bkg:EImage = viewFactory.getEImage("tabBody",null,false,layoutFactory.getArea("body"));
         setContent("body",bkg);
         eAddChild(bkg);
         var tabs:Vector.<EButton> = new Vector.<EButton>(0);
         var tabIndex:int = 0;
         tab = viewFactory.getTextTabHeaderPopup(DCTextMng.getText(2793));
         setContent("tab" + tabIndex,tab);
         eAddChild(tab);
         tabs.push(tab);
         tabIndex++;
         tab = viewFactory.getTextTabHeaderPopup(DCTextMng.getText(2836));
         setContent("tab" + tabIndex,tab);
         eAddChild(tab);
         tabs.push(tab);
         tabIndex++;
         tab = viewFactory.getTextTabHeaderPopup(DCTextMng.getText(2835));
         setContent("tab" + tabIndex,tab);
         eAddChild(tab);
         tabs.push(tab);
         tabIndex++;
         tab = viewFactory.getTextTabHeaderPopup(DCTextMng.getText(2837));
         setContent("tab" + tabIndex,tab);
         eAddChild(tab);
         tabs.push(tab);
         tabIndex++;
         tab = viewFactory.getTextTabHeaderPopup(DCTextMng.getText(2830));
         setContent("tab" + tabIndex,tab);
         eAddChild(tab);
         tabs.push(tab);
         tabIndex++;
         this.mTabsView = new TabHeadersView(layoutFactory.getArea("tab"),viewFactory,null);
         this.mTabsView.setTabHeaders(tabs);
         this.mPaginator = new EPaginatorComponent();
         this.mPaginator.init(this.mTabsView,this);
         this.mTabsView.setPaginatorComponent(this.mPaginator);
         if(this.mAllianceController.getMyAlliance().isInAWar())
         {
            this.setPageId(null,1);
         }
         else
         {
            this.setPageId(null,0);
         }
         viewFactory.createButtonNotification(getContentAsEButton("tab" + 3));
         viewFactory.createButtonNotification(getContentAsEButton("tab" + 4));
      }
      
      private function setTabAmount(tab:EButton, amount:int) : void
      {
         var notification:ESpriteContainer = tab.getContentAsESpriteContainer("notification");
         if(notification != null)
         {
            if(amount > 0)
            {
               notification.visible = true;
               notification.getContentAsETextField("text").setText(amount.toString());
            }
            else
            {
               notification.visible = false;
            }
         }
      }
      
      public function setPageIdForced(id:int) : void
      {
         this.mCurrentPage = -1;
         this.setPageId(null,id);
      }
      
      public function setPageId(pc:EPaginatorComponent, id:int) : void
      {
         var currentBody:ESpriteContainer = null;
         var body:ESprite = null;
         var popup:EPopupAlliances = null;
         if(this.mCurrentPage != id)
         {
            currentBody = getContentAsESpriteContainer("content");
            body = getContent("body");
            popup = EPopupAlliances(this.mAllianceController.getPopupAlliance());
            if(popup != null)
            {
               popup.destroyActionsTooltip();
            }
            if(currentBody != null)
            {
               currentBody.destroy();
               currentBody = null;
            }
            this.mCurrentPage = id;
            switch(this.mCurrentPage)
            {
               case 0:
                  currentBody = new EAllianceHeadQuarter();
                  EAllianceHeadQuarter(currentBody).build();
                  break;
               case 1:
                  currentBody = new EAllianceWarPage();
                  EAllianceWarPage(currentBody).build();
                  break;
               case 2:
                  currentBody = new EAllianceLeaderboard();
                  EAllianceLeaderboard(currentBody).build();
                  break;
               case 3:
                  currentBody = new EAllianceNews();
                  EAllianceNews(currentBody).build();
                  this.mUserAlliance.setNewsUnreadCount(0);
                  break;
               case 4:
                  currentBody = new EAllianceRewards();
                  EAllianceRewards(currentBody).build();
            }
            if(currentBody != null)
            {
               setContent("content",currentBody);
               body.eAddChild(currentBody);
            }
            this.mTabsView.setPageId(this.mCurrentPage);
         }
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var tab:EButton = null;
         super.logicUpdate(dt);
         if(this.mUserAlliance != null)
         {
            tab = getContentAsEButton("tab" + 3);
            this.setTabAmount(tab,this.mUserAlliance.getNewsUnreadCount());
            tab = getContentAsEButton("tab" + 4);
            this.setTabAmount(tab,InstanceMng.getAlliancesRewardsMng().getRewardsAvailable());
         }
      }
   }
}
