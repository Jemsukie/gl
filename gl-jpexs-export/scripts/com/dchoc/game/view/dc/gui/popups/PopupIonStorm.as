package com.dchoc.game.view.dc.gui.popups
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.game.eview.widgets.ELoadingScreen;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   
   public class PopupIonStorm extends EGamePopup
   {
       
      
      private var mLoadingScreen:ELoadingScreen;
      
      private var mBodyContent:ESpriteContainer;
      
      public function PopupIonStorm()
      {
         super();
      }
      
      public function setupPopup() : void
      {
         this.mLoadingScreen = new ELoadingScreen();
         this.mLoadingScreen.setup();
         eAddChild(this.mLoadingScreen);
         setContent("loadingScreen",this.mLoadingScreen);
      }
      
      override public function resize() : void
      {
         var stageW:int = InstanceMng.getApplication().stageGetWidth();
         var stageH:int = InstanceMng.getApplication().stageGetHeight();
         x = stageW / 2;
         y = stageH / 2;
         this.mLoadingScreen.drawBackground(stageW,stageH);
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var layoutFactory:ELayoutAreaFactory = null;
         var mArrowArea:ELayoutArea = null;
         var mAdvisorArea:ELayoutArea = null;
         var advisorImg:EImage = null;
         var mSpeechArea:ELayoutArea = null;
         var content:ESpriteContainer = null;
         var speechBox:ESprite = null;
         var speechArrow:EImage = null;
         super.logicUpdate(dt);
         if(this.mBodyContent == null)
         {
            mViewFactory = InstanceMng.getViewFactory();
            this.mBodyContent = mViewFactory.getESpriteContainer();
            this.eAddChild(this.mBodyContent);
            mArrowArea = (layoutFactory = mViewFactory.getLayoutAreaFactory("PopSpeech")).getArea("arrow");
            mAdvisorArea = layoutFactory.getArea("img");
            advisorImg = mViewFactory.getEImage("builder_worried",mSkinSku,true,mAdvisorArea);
            this.mBodyContent.setContent("img",advisorImg);
            this.mBodyContent.eAddChild(advisorImg);
            mSpeechArea = layoutFactory.getArea("area_speech");
            content = mViewFactory.getContentOneText("ContainerTextField",DCTextMng.getText(411),"text_body",null);
            speechBox = mViewFactory.getSpeechBubble(mSpeechArea,mArrowArea,content,mSkinSku,null,false,"box_with_border");
            this.mBodyContent.setContent("area_speech",speechBox);
            this.mBodyContent.eAddChild(speechBox);
            speechArrow = mViewFactory.getEImage("speech_arrow_1",null,false,mArrowArea);
            this.mBodyContent.setContent("arrow",speechArrow);
            this.mBodyContent.eAddChild(speechArrow);
            this.mBodyContent.setContent("text",content);
            this.mBodyContent.eAddChild(content);
            this.mBodyContent.logicLeft = -this.mBodyContent.getLogicWidth() / 2 - this.mBodyContent.mostLeft;
            this.mBodyContent.logicTop = -this.mBodyContent.getLogicHeight() / 2 - this.mBodyContent.mostTop;
         }
      }
   }
}
