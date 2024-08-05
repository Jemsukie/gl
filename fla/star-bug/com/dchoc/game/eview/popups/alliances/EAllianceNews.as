package com.dchoc.game.eview.popups.alliances
{
   import com.dchoc.game.controller.alliances.AlliancesControllerStar;
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.model.alliances.AlliancesAPINewsEvent;
   import com.dchoc.game.model.alliances.AlliancesNew;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EScrollArea;
   import esparragon.display.ESpriteContainer;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   
   public class EAllianceNews extends ESpriteContainer
   {
       
      
      private const CHECK_BOX_ALL:String = "all";
      
      private const CHECK_BOX_ALLIANCE:String = "alliance";
      
      private const CHECK_BOX_WAR:String = "war";
      
      private const INITIAL_REQUEST:int = 50;
      
      private const AMOUNT_TO_REQUEST:int = 25;
      
      private const SCROLL_DOWN_PERCENTAGE:int = 80;
      
      private const SCROLL_UP_PERCENTAGE:int = 10;
      
      private const SCROLLING_UP:int = 0;
      
      private const SCROLLING_DOWN:int = 1;
      
      private var mAllianceController:AlliancesControllerStar;
      
      private var mViewFactory:ViewFactory;
      
      private var mStripeHeight:int;
      
      private var mVisibleStripes:Number;
      
      private var mBodyWidth:Number;
      
      private var mBodyHeight:Number;
      
      private var mStripesArea:ELayoutArea;
      
      private var mScrollArea:EScrollArea;
      
      private var mTotalNews:int;
      
      private var mNewsTypes:Array;
      
      private var mNews:Vector.<AlliancesNew>;
      
      private var mRequestRetry:int;
      
      private var mIsRetry:Boolean;
      
      private var mScrollDir:int;
      
      private var mRequestInProgress:Boolean;
      
      private var mNewsRequested:int;
      
      private var mPage:int;
      
      public function EAllianceNews()
      {
         this.mNewsTypes = [0,1,2];
         super();
         this.mAllianceController = InstanceMng.getAlliancesController() as AlliancesControllerStar;
      }
      
      public function build() : void
      {
         this.mViewFactory = InstanceMng.getViewFactory();
         var layoutFactory:ELayoutAreaFactory;
         var bkgArea:ELayoutArea = (layoutFactory = this.mViewFactory.getLayoutAreaFactory("LayoutAlliancePageNews")).getArea("search");
         var checkBoxes:Array = [];
         var checkbox:ESpriteContainer = this.mViewFactory.getCheckBoxWithText("IconTextXSLarge",DCTextMng.getText(2826),"text_subheader");
         eAddChild(checkbox);
         setContent("all",checkbox);
         checkbox.eAddEventListener("click",this.onAllClick);
         checkBoxes.push(checkbox);
         checkbox = this.mViewFactory.getCheckBoxWithText("IconTextXSLarge",DCTextMng.getText(2827),"text_subheader");
         eAddChild(checkbox);
         checkbox.eAddEventListener("click",this.onAllianceClick);
         setContent("alliance",checkbox);
         checkBoxes.push(checkbox);
         checkbox = this.mViewFactory.getCheckBoxWithText("IconTextXSLarge",DCTextMng.getText(2829),"text_subheader");
         eAddChild(checkbox);
         checkbox.eAddEventListener("click",this.onAllianceClick);
         setContent("war",checkbox);
         checkBoxes.push(checkbox);
         this.mViewFactory.distributeSpritesInArea(bkgArea,checkBoxes,1,1,-1,1,true);
         this.mStripesArea = layoutFactory.getArea("stripes");
         layoutFactory = this.mViewFactory.getLayoutAreaFactory("StripeAlliancesLeaderBoard");
         this.mStripeHeight = layoutFactory.getContainerLayoutArea().height;
         this.mVisibleStripes = Math.ceil(this.mStripesArea.height / this.mStripeHeight);
         var bodyArea:ELayoutArea = (layoutFactory = this.mViewFactory.getLayoutAreaFactory("PopXLNoTabsNoFooter")).getArea("body");
         this.mBodyWidth = bodyArea.width;
         this.mBodyHeight = bodyArea.height;
         this.resetNews();
      }
      
      private function getCheckBox(checkboxName:String) : ESpriteContainer
      {
         return getContentAsESpriteContainer(checkboxName).getContentAsESpriteContainer("check");
      }
      
      private function resetNews() : void
      {
         this.mNewsRequested = 0;
         this.mScrollDir = 1;
         this.mPage = 0;
         if(this.mNews != null)
         {
            this.mNews.length = 0;
         }
         this.mRequestRetry = 0;
         this.requestNews(50);
         this.mNewsRequested += 50;
      }
      
      private function requestNews(requestFor:int) : void
      {
         this.mRequestInProgress = true;
         this.mAllianceController.requestNews(this.onRequestNewsSuccess,this.onRequestFail,this.mNewsTypes,this.mNewsRequested,requestFor,true);
      }
      
      private function filterNews(news:Vector.<AlliancesNew>) : Vector.<AlliancesNew>
      {
         var i:int = 0;
         var allianceNew:AlliancesNew = null;
         var index:int = 0;
         var filteredNews:Vector.<AlliancesNew> = new Vector.<AlliancesNew>(0);
         var count:int = int(news.length);
         for(i = 0; i < count; )
         {
            allianceNew = news[i];
            if((index = this.mNewsTypes.indexOf(allianceNew.getType())) > -1)
            {
               filteredNews.push(allianceNew);
            }
            i++;
         }
         return filteredNews;
      }
      
      private function locateStripes(spriteReference:ESpriteContainer, rowOffset:int, rebuild:Boolean) : void
      {
         var stripe:EAllianceNewBox = null;
         if(rebuild)
         {
            stripe = new EAllianceNewBox();
            spriteReference.eAddChild(stripe);
            spriteReference.setContent("stripe",stripe);
         }
         (stripe = spriteReference.getChildAt(0) as EAllianceNewBox).setInfo(this.mNews[rowOffset]);
      }
      
      override public function logicUpdate(dt:int) : void
      {
         super.logicUpdate(dt);
         if(!this.mRequestInProgress && this.mScrollArea != null)
         {
            if(this.mScrollArea.getLogicYRelative() >= 80 / 100 && this.mNewsRequested < this.mTotalNews)
            {
               this.mPage++;
               this.mRequestRetry = 0;
               if(this.mScrollDir == 0)
               {
                  this.mNewsRequested += 50;
               }
               this.mScrollDir = 1;
               this.requestNews(25);
               this.mNewsRequested += 25;
            }
            else if(this.mScrollArea.getLogicYRelative() <= 10 / 100 && this.mPage > 0)
            {
               this.mPage--;
               this.mRequestRetry = 0;
               if(this.mScrollDir == 1)
               {
                  this.mNewsRequested -= 50;
               }
               this.mNewsRequested -= 25;
               this.mScrollDir = 0;
               this.requestNews(25);
            }
         }
      }
      
      private function addNewType(type:int) : void
      {
         if(this.mNewsTypes.indexOf(type) == -1)
         {
            this.mNewsTypes.push(type);
         }
      }
      
      private function removeNewType(type:int) : void
      {
         var pos:int = this.mNewsTypes.indexOf(type);
         if(pos > -1)
         {
            this.mNewsTypes.splice(pos,1);
         }
      }
      
      private function onRequestNewsSuccess(ae:AlliancesAPINewsEvent) : void
      {
         var box:EAllianceNewBox = null;
         var pos:Number = NaN;
         var news:Vector.<AlliancesNew> = this.filterNews(ae.getAlliancesNews());
         var boxes:Array = [];
         this.mTotalNews = ae.count;
         if(this.mScrollArea != null)
         {
            this.mScrollArea.destroy();
            this.mScrollArea = null;
         }
         if(this.mNews == null)
         {
            this.mNews = new Vector.<AlliancesNew>(0);
         }
         if(this.mScrollDir == 1)
         {
            if(!this.mIsRetry)
            {
               this.mNews.splice(0,25);
            }
            this.mNews = this.mNews.concat(news);
         }
         else
         {
            if(!this.mIsRetry)
            {
               this.mNews.splice(25,25);
            }
            this.mNews = news.concat(this.mNews);
         }
         if(this.mNews.length < 50 && this.mNewsRequested < this.mTotalNews && this.mNewsRequested > 0 && this.mRequestRetry < 2)
         {
            this.mRequestRetry++;
            if(this.mScrollDir == 1)
            {
               this.requestNews(25);
               this.mNewsRequested += 25;
            }
            else
            {
               this.mNewsRequested -= 25;
               this.requestNews(25);
            }
            this.mIsRetry = true;
            return;
         }
         var newsCount:int;
         if((newsCount = int(this.mNews.length)) > 0)
         {
            this.mScrollArea = new EScrollArea();
            this.mScrollArea.build(this.mStripesArea,newsCount,ESpriteContainer,this.locateStripes);
            this.mViewFactory.getEScrollBar(this.mScrollArea);
            eAddChild(this.mScrollArea);
            setContent("scrollArea",this.mScrollArea);
            if(this.mTotalNews <= this.mVisibleStripes || newsCount <= this.mVisibleStripes)
            {
               this.mScrollArea.logicLeft = (this.mBodyWidth - this.mScrollArea.width) / 2;
            }
            else
            {
               pos = 0;
               if(this.mScrollDir == 1 && this.mPage > 0)
               {
                  pos = (Math.ceil(40) - 25 - this.mVisibleStripes / 2) * this.mStripeHeight;
               }
               else if(this.mScrollDir == 0)
               {
                  pos = (Math.ceil(5) + 25 - this.mVisibleStripes / 2) * this.mStripeHeight;
               }
               this.mScrollArea.scroll(pos);
               this.logicUpdate(0);
            }
         }
         this.mRequestInProgress = false;
      }
      
      private function onRequestFail(ae:AlliancesAPINewsEvent) : void
      {
         this.mAllianceController.throwErrorMessage(ae.getErrorTitle(),ae.getErrorMsg());
         this.mRequestInProgress = false;
      }
      
      private function onAllClick(e:EEvent) : void
      {
         var isChecked:Boolean = this.mViewFactory.isCheckBoxChecked(this.getCheckBox("all"));
         if(isChecked)
         {
            this.mViewFactory.setChecked(this.getCheckBox("alliance"),true);
            this.mViewFactory.setChecked(this.getCheckBox("war"),true);
            this.mNewsTypes.push(0,1,2);
         }
         else
         {
            this.mViewFactory.setChecked(this.getCheckBox("alliance"),false);
            this.mViewFactory.setChecked(this.getCheckBox("war"),false);
            this.mNewsTypes.length = 0;
         }
         this.resetNews();
      }
      
      private function onAllianceClick(e:EEvent) : void
      {
         var isCheckedAlliance:Boolean = this.mViewFactory.isCheckBoxChecked(this.getCheckBox("alliance"));
         var isCheckedWar:Boolean = this.mViewFactory.isCheckBoxChecked(this.getCheckBox("war"));
         if(isCheckedAlliance && isCheckedWar)
         {
            this.mViewFactory.setChecked(this.getCheckBox("all"),true);
         }
         else
         {
            this.mViewFactory.setChecked(this.getCheckBox("all"),false);
         }
         if(isCheckedAlliance)
         {
            this.addNewType(0);
            this.addNewType(1);
         }
         else
         {
            this.removeNewType(0);
            this.removeNewType(1);
         }
         if(isCheckedWar)
         {
            this.addNewType(2);
         }
         else
         {
            this.removeNewType(2);
         }
         this.resetNews();
      }
   }
}
