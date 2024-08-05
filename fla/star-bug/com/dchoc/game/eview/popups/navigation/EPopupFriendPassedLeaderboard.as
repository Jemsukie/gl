package com.dchoc.game.eview.popups.navigation
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.model.userdata.UserDataMng;
   import com.dchoc.game.model.userdata.UserInfo;
   import com.dchoc.game.model.userdata.UserScoreInfo;
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
   
   public class EPopupFriendPassedLeaderboard extends EGamePopup
   {
      
      private static const BOX_SPEED:Number = 0.2;
      
      private static const BOX_INC_SCALE:Number = 0.001;
      
      private static const BOX_MAX_SCALE:Number = 1.2;
      
      private static const TIME_TO_START_ANIM:int = 2000;
      
      private static const TIME_BETWEEN_SWAPS:int = 1000;
       
      
      private const BODY:String = "body";
      
      private const MAX_FRIENDS_PASSED:uint = 2;
      
      private var mFriendsPassed:Vector.<UserInfo>;
      
      private var mWeeklyScoreList:Vector.<UserScoreInfo>;
      
      private var mOldWeeklyScoreList:Vector.<UserScoreInfo>;
      
      private var mUserOldPosWeekly:int;
      
      private var mUserPosWeekly:int;
      
      private var mStripeHeight:Number;
      
      private var mPosWeeklyInRankingFirst:int;
      
      private var mSwapEnd:Boolean = true;
      
      private var mFirst:Boolean = false;
      
      private var mMaxScale:Boolean = false;
      
      private var mMinimizeScale:Boolean = false;
      
      private var mTopY:int;
      
      private var mBottomY:int;
      
      private var mDistY:Number;
      
      private var mEngageAnim:Boolean = false;
      
      private var mTime:int;
      
      private var mUserIdx:int;
      
      private var mPlayerBoxes:Array;
      
      private var mStripesArea:ELayoutArea;
      
      private var mHasToReloadStripes:Boolean;
      
      public function EPopupFriendPassedLeaderboard()
      {
         super();
      }
      
      override public function setup(popupId:String, viewFactory:ViewFactory, skinId:String) : void
      {
         super.setup(popupId,viewFactory,skinId);
         this.setupBackground("PopXL","pop_xl");
         setTitleText(DCTextMng.getText(648));
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         this.mStripesArea = null;
      }
      
      private function initializeContent() : void
      {
         if(this.mWeeklyScoreList == null)
         {
            this.mWeeklyScoreList = InstanceMng.getUserInfoMng().getWeeklyScoreList();
            if(this.mWeeklyScoreList != null)
            {
               this.getData();
               this.setupContent();
               this.mEngageAnim = true;
            }
         }
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
         var body:ESprite = mViewFactory.getESprite(null,layoutFactory.getArea("body"));
         bkg.eAddChild(body);
         setContent("body",body);
         mFooterArea = layoutFactory.getArea("footer");
      }
      
      private function setupContent() : void
      {
         var i:int = 0;
         var text1:String = null;
         var text2:String = null;
         var maxRows:int = 0;
         var stripe:ESpriteContainer = null;
         var body:ESprite = getContent("body");
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("PopPassFriendScore");
         if(this.mFriendsPassed.length == 1)
         {
            text1 = DCTextMng.getText(649);
            text2 = DCTextMng.getText(650);
         }
         else
         {
            text1 = DCTextMng.getText(651);
            text2 = DCTextMng.getText(652);
         }
         var img:EImage = mViewFactory.getEImage("box_simple",null,false,layoutFactory.getArea("speech"),"speech_color");
         body.eAddChild(img);
         setContent("speechBkg",img);
         img = mViewFactory.getEImage("speech_arrow",null,false,layoutFactory.getArea("arrow"),"speech_color");
         body.eAddChild(img);
         setContent("speechArrow",img);
         var field:ETextField = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_speech"),"text_body");
         body.eAddChild(field);
         setContent("text_speech",field);
         field.setText(text1 + "\n\n" + text2);
         img = mViewFactory.getEImage("orange_happy",null,true,layoutFactory.getArea("img"));
         body.eAddChild(img);
         setContent("advisor",img);
         if(this.mOldWeeklyScoreList.length <= maxRows)
         {
            maxRows = int(this.mOldWeeklyScoreList.length);
            this.mPosWeeklyInRankingFirst = 0;
         }
         else if(this.mFriendsPassed.length > 2)
         {
            this.mUserPosWeekly = this.mUserOldPosWeekly - this.mFriendsPassed.length + 2;
            this.mPosWeeklyInRankingFirst = this.mUserOldPosWeekly - this.mFriendsPassed.length;
         }
         else
         {
            this.mPosWeeklyInRankingFirst = this.mUserOldPosWeekly - 2;
            if(this.mPosWeeklyInRankingFirst < 0)
            {
               this.mPosWeeklyInRankingFirst = 0;
            }
         }
         this.mStripesArea = layoutFactory.getArea("area_stripes");
         maxRows = Math.floor(this.mStripesArea.height / this.mStripeHeight);
         var idxRanking:int = this.mPosWeeklyInRankingFirst;
         var idxList:int = this.mPosWeeklyInRankingFirst;
         this.mPlayerBoxes = [];
         for(i = 0; i < maxRows; )
         {
            if(idxRanking == this.mUserPosWeekly)
            {
               stripe = this.getUserStripe(this.mOldWeeklyScoreList[this.mUserOldPosWeekly],idxRanking,true);
               if(this.mUserOldPosWeekly == idxRanking)
               {
                  idxList++;
               }
               this.mUserIdx = i;
            }
            else
            {
               stripe = this.getUserStripe(this.mOldWeeklyScoreList[idxList],idxRanking,false);
               idxList++;
            }
            body.eAddChild(stripe);
            setContent("stripe" + i,stripe);
            this.mPlayerBoxes.push(stripe);
            idxRanking++;
            i++;
         }
         mViewFactory.distributeSpritesInArea(this.mStripesArea,this.mPlayerBoxes,0,4,1,maxRows,true);
      }
      
      private function getData() : void
      {
         this.mFriendsPassed = InstanceMng.getUserInfoMng().getWeeklyScoreListPassedFriends();
         this.mOldWeeklyScoreList = InstanceMng.getUserInfoMng().getOldWeeklyScoreList();
         this.mUserOldPosWeekly = InstanceMng.getUserInfoMng().getUserOldPosWeeklyScoreList();
         this.mUserPosWeekly = this.mUserOldPosWeekly;
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("StripeFriendPassed");
         this.mStripeHeight = layoutFactory.getArea("box_base").height;
      }
      
      private function getUserStripe(userScoreInfo:UserScoreInfo, idx:int, itsMe:Boolean) : ESpriteContainer
      {
         var resource:String = null;
         var textProp:String = null;
         var layoutFactory:ELayoutAreaFactory = mViewFactory.getLayoutAreaFactory("StripeFriendPassed");
         var userInfo:UserInfo = InstanceMng.getUserInfoMng().getUserInfoObj(userScoreInfo.getAccountId(),0);
         var container:ESpriteContainer;
         (container = new ESpriteContainer()).setLayoutArea(layoutFactory.getContainerLayoutArea());
         if(itsMe)
         {
            resource = "stripe_player";
            textProp = "text_positive";
         }
         else
         {
            resource = "stripe";
            textProp = "text_subheader";
         }
         var img:EImage = mViewFactory.getEImage(resource,null,false,layoutFactory.getArea("box_base"));
         container.eAddChild(img);
         container.setContent("bkg",img);
         var pic:String = String(userInfo != null ? userInfo.getThumbnailURL() : null);
         (img = mViewFactory.getEImageProfileFromURL(pic,null,null)).layoutApplyTransformations(layoutFactory.getArea("img_profile"));
         container.eAddChild(img);
         container.setContent("profileImg",img);
         var playerName:String = userInfo != null ? userInfo.getPlayerName() : "";
         var field:ETextField;
         (field = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_name"),textProp)).setText(playerName);
         container.eAddChild(field);
         container.setContent("userName",field);
         (field = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_value"),textProp)).setText(DCTextMng.convertNumberToString(userScoreInfo.getScore(),-1,-1));
         container.eAddChild(field);
         container.setContent("userScore",field);
         if(itsMe)
         {
            img = mViewFactory.getEImage("passFriendMedal",null,true,layoutFactory.getArea("icon"));
            container.eAddChild(img);
            container.setContent("medal",img);
         }
         (field = mViewFactory.getETextField(null,layoutFactory.getTextArea("text_number"),textProp)).setText("" + (idx + 1));
         container.eAddChild(field);
         container.setContent("textRank",field);
         return container;
      }
      
      private function changeNumRank(stripe:ESpriteContainer, idx:int) : void
      {
         var field:ETextField = stripe.getContentAsETextField("textRank");
         if(field != null)
         {
            field.setText(idx.toString());
         }
      }
      
      private function swapBox(contentTop:ESprite, contentBottom:ESprite, dt:int) : void
      {
         var content:ESprite = null;
         if(!this.mFirst)
         {
            this.mFirst = true;
            this.mTopY = contentTop.logicTop;
            this.mBottomY = contentBottom.logicTop;
         }
         contentTop.logicTop += 0.2 * dt;
         contentBottom.logicTop -= 0.2 * dt;
         if(!this.mMaxScale && contentBottom.scaleLogicX < 1.2)
         {
            contentBottom.scaleLogicX += 0.001 * dt;
            contentBottom.scaleLogicY += 0.001 * dt;
         }
         if(!this.mMaxScale && contentBottom.scaleLogicX >= 1.2 - 0.01)
         {
            contentBottom.scaleLogicX = 1.2;
            contentBottom.scaleLogicY = 1.2;
            this.mMaxScale = true;
            this.mDistY = contentTop.logicTop - this.mTopY;
         }
         var dist:Number = this.mBottomY - this.mDistY;
         if(!this.mMinimizeScale && Math.abs(dist - contentTop.logicTop) < 4 && this.mMaxScale && contentBottom.scaleLogicX > 1)
         {
            this.mMinimizeScale = true;
         }
         if(this.mMinimizeScale && contentBottom.scaleLogicX > 1)
         {
            contentBottom.scaleLogicX -= 0.001 * dt;
            contentBottom.scaleLogicY -= 0.001 * dt;
         }
         if(contentTop.logicTop >= this.mBottomY)
         {
            contentBottom.scaleLogicX = 1;
            contentBottom.scaleLogicY = 1;
            contentBottom.logicTop = this.mTopY;
            contentTop.logicTop = this.mBottomY;
            this.changeNumRank(contentBottom as ESpriteContainer,this.mUserPosWeekly);
            this.changeNumRank(contentTop as ESpriteContainer,this.mUserPosWeekly + 1);
            content = this.mPlayerBoxes[this.mUserIdx];
            this.mPlayerBoxes[this.mUserIdx] = this.mPlayerBoxes[this.mUserIdx - 1];
            this.mPlayerBoxes[this.mUserIdx - 1] = content;
            this.mFirst = false;
            this.mSwapEnd = true;
            this.mMaxScale = false;
            this.mMinimizeScale = false;
            this.mUserIdx--;
            this.mUserPosWeekly--;
            if(this.mUserPosWeekly > this.mUserOldPosWeekly - this.mFriendsPassed.length)
            {
               this.mEngageAnim = true;
               this.mTime = 1000;
            }
            else
            {
               this.mHasToReloadStripes = true;
            }
         }
      }
      
      private function reloadStripes() : void
      {
         var i:int = 0;
         var stripe:ESpriteContainer = null;
         var pos:Number = NaN;
         var maxPos:int = 0;
         var numStripes:int = int(this.mPlayerBoxes.length);
         for(i = 0; i < numStripes; )
         {
            (stripe = this.mPlayerBoxes[i]).destroy();
            stripe = null;
            i++;
         }
         this.mPlayerBoxes = null;
         var scrollArea:EScrollArea = new EScrollArea();
         scrollArea.build(this.mStripesArea,this.mWeeklyScoreList.length,ESpriteContainer,this.locateStripes);
         mViewFactory.getEScrollBar(scrollArea);
         setContent("scrollArea",scrollArea);
         var body:ESprite = getContent("body");
         var numRows:int = Math.floor(this.mStripesArea.height / this.mStripeHeight);
         if(this.mUserPosWeekly > numRows)
         {
            maxPos = this.mWeeklyScoreList.length - numRows;
            if(this.mUserPosWeekly > maxPos)
            {
               pos = maxPos;
            }
            else
            {
               pos = this.mUserPosWeekly - this.mUserIdx;
            }
            scrollArea.scroll(pos * this.mStripeHeight);
            scrollArea.logicUpdate(0);
         }
         body.eAddChild(scrollArea);
         var button:EButton = mViewFactory.getButtonByTextWidth(DCTextMng.getText(654),0,"btn_social");
         addButton("buttonLeaderboard",button);
         button.eAddEventListener("click",this.onSeeLeaderboards);
      }
      
      private function locateStripes(spriteReference:ESpriteContainer, rowOffset:int, rebuild:Boolean) : void
      {
         var stripe:ESpriteContainer = null;
         var userScore:UserScoreInfo;
         if((userScore = this.mWeeklyScoreList[rowOffset]) != null)
         {
            if((stripe = this.getUserStripe(userScore,rowOffset,this.mUserPosWeekly == rowOffset)) != null)
            {
               spriteReference.eAddChild(stripe);
               spriteReference.setContent("stripe",stripe);
            }
            else if((stripe = spriteReference.getContentAsESpriteContainer("stripe")) != null)
            {
               spriteReference.eRemoveChild(stripe);
               stripe.destroy();
               stripe = null;
            }
         }
      }
      
      override public function logicUpdate(dt:int) : void
      {
         super.logicUpdate(dt);
         if(this.mHasToReloadStripes)
         {
            this.mHasToReloadStripes = false;
            this.reloadStripes();
         }
         this.initializeContent();
         if(this.mEngageAnim)
         {
            this.mTime -= dt;
            if(this.mTime <= 0)
            {
               this.mEngageAnim = false;
               this.mSwapEnd = false;
            }
         }
         if(!this.mSwapEnd && this.mUserPosWeekly > this.mUserOldPosWeekly - this.mFriendsPassed.length)
         {
            this.swapBox(this.mPlayerBoxes[this.mUserIdx - 1],this.mPlayerBoxes[this.mUserIdx],dt);
         }
      }
      
      private function onCloseClick(e:EEvent) : void
      {
         InstanceMng.getUIFacade().closePopup(this);
         InstanceMng.getUnitScene().battleResultClose();
      }
      
      public function onSeeLeaderboards(e:EEvent) : void
      {
         InstanceMng.getUserDataMng().requestTask(UserDataMng.KEY_OPEN_LEADERBOARD_TAB);
         this.onCloseClick(null);
      }
   }
}
