package com.dchoc.game.eview.widgets.contest
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.model.contest.ContestReward;
   import com.dchoc.game.model.contest.ContestUser;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EScrollArea;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.layout.ELayoutTextArea;
   
   public class BodyStripes extends ESpriteContainer
   {
      
      private static const STRIPE:String = "Stripe_";
      
      private static const NOSTRIPES:String = "noStripes";
      
      private static const HEADER:String = "header";
       
      
      private var mViewFactory:ViewFactory;
      
      private var mSkinSku:String;
      
      private var mStripes:Array;
      
      private var mStripesCount:int;
      
      private var mBodyArea:ELayoutArea;
      
      private var mFooterArea:ELayoutArea;
      
      private var mStripesArea:ELayoutArea;
      
      private var mNoStripesText:ETextField;
      
      private var mNoStripesString:String;
      
      private var mLayoutFactory:ELayoutAreaFactory;
      
      public function BodyStripes(viewFactory:ViewFactory, skinSku:String)
      {
         super();
         this.mViewFactory = viewFactory;
         this.mSkinSku = skinSku;
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         this.mViewFactory = null;
         this.mSkinSku = null;
         this.mBodyArea = null;
         this.mFooterArea = null;
         this.mNoStripesString = null;
         this.mLayoutFactory = null;
         this.mNoStripesText = null;
      }
      
      public function createStripesHeader(layout:String, instances:Array, texts:Array, textsProps:String) : void
      {
         var layoutFactory:ELayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory(layout);
         this.mStripesArea = layoutFactory.getArea("body");
         var headerStripes:ESpriteContainer = this.mViewFactory.getHeaderStripes(layoutFactory,instances,texts,textsProps,this.mSkinSku);
         eAddChild(headerStripes);
         setContent("header",headerStripes);
      }
      
      public function setStrips(stripesInfo:Array, layout:String, noStripes:String) : void
      {
         this.mNoStripesString = noStripes;
         if(this.mBodyArea == null)
         {
            this.mLayoutFactory = this.mViewFactory.getLayoutAreaFactory(layout);
            this.mBodyArea = this.mLayoutFactory.getArea("body");
            this.mFooterArea = this.mLayoutFactory.getArea("footer");
         }
         if(this.mStripes == null)
         {
            this.mStripes = stripesInfo;
            this.mStripesCount = this.mStripes.length;
         }
         this.paintStripes();
      }
      
      private function paintStripes() : void
      {
         var scrollArea:EScrollArea = null;
         var area:ELayoutTextArea = null;
         var noStripeArea:ELayoutTextArea = null;
         if(this.mStripes != null)
         {
            scrollArea = new EScrollArea();
            if(this.mStripes[0] is ContestUser)
            {
               scrollArea.build(this.mStripesArea,this.mStripesCount,ESpriteContainer,this.locateStripesLeaderBoard);
            }
            else
            {
               scrollArea.build(this.mStripesArea,this.mStripesCount,ESpriteContainer,this.locateStripesReward);
            }
            this.mViewFactory.getEScrollBar(scrollArea);
            setContent("scrollArea",scrollArea);
            eAddChild(scrollArea);
         }
         else
         {
            if(this.mNoStripesText == null)
            {
               area = this.mLayoutFactory.getTextArea("text_title");
               noStripeArea = new ELayoutTextArea(area);
               noStripeArea.height *= 2;
               this.mNoStripesText = this.mViewFactory.getETextField(this.mSkinSku,noStripeArea);
               this.mNoStripesText.setText(this.mNoStripesString);
               this.mBodyArea.centerContent(this.mNoStripesText);
               this.mNoStripesText.logicLeft -= this.mBodyArea.x;
               this.mNoStripesText.logicTop -= this.mBodyArea.y;
               setContent("noStripes",this.mNoStripesText);
               this.mNoStripesText.applySkinProp(this.mSkinSku,"text_title_0");
            }
            if(!eContains(this.mNoStripesText))
            {
               eAddChild(this.mNoStripesText);
            }
         }
      }
      
      private function locateStripesLeaderBoard(spriteReference:ESpriteContainer, rowOffset:int, rebuild:Boolean) : void
      {
         var stripe:ContestLeaderboardStripe = null;
         var PROPS:Array = new Array("stripe_1","stripe_2","stripe_3");
         if(rebuild)
         {
            stripe = new ContestLeaderboardStripe(this.mViewFactory,this.mSkinSku);
            spriteReference.eAddChild(stripe);
            spriteReference.setContent("stripe",stripe);
         }
         stripe = spriteReference.getChildAt(0) as ContestLeaderboardStripe;
         var stripeType:String = "stripe";
         var contestUser:ContestUser;
         if((contestUser = this.mStripes[rowOffset]).getIsMe())
         {
            stripeType = "stripe_player";
         }
         else if(rowOffset < 3)
         {
            stripeType = String(PROPS[rowOffset]);
         }
         stripe.setup(contestUser,stripeType);
      }
      
      private function locateStripesReward(spriteReference:ESpriteContainer, rowOffset:int, rebuild:Boolean) : void
      {
         var stripe:ContestRewardsStripes = null;
         var text:String = null;
         var fromPos:int = 0;
         var toPos:int = 0;
         var PROPS:Array = new Array("stripe_1","stripe_2","stripe_3");
         if(rebuild)
         {
            stripe = new ContestRewardsStripes(this.mViewFactory,this.mSkinSku);
            spriteReference.eAddChild(stripe);
            spriteReference.setContent("stripe",stripe);
         }
         var contestReward:ContestReward = this.mStripes[rowOffset];
         var userPos:int = InstanceMng.getContestMng().userGetRank();
         fromPos = contestReward.getFromPos();
         if((toPos = contestReward.getToPos()) == -1)
         {
            text = DCTextMng.replaceParameters(3338,[fromPos.toString()]);
         }
         else if(fromPos < toPos)
         {
            text = DCTextMng.replaceParameters(3337,[fromPos.toString(),toPos.toString()]);
         }
         else if(fromPos == toPos)
         {
            text = DCTextMng.replaceParameters(3340,[fromPos.toString()]);
         }
         var textureName:String = "stripe";
         var isUserPos:Boolean;
         if(isUserPos = contestReward.belongsToGroup(userPos))
         {
            textureName = "stripe_player";
         }
         else if(rowOffset < 3)
         {
            textureName = String(PROPS[rowOffset]);
         }
         stripe.setup(contestReward.getEntryString(),text,textureName);
         if(isUserPos)
         {
            stripe.setTextProps("text_title_2",false);
            stripe.setTextProps("text_positive");
         }
      }
   }
}
