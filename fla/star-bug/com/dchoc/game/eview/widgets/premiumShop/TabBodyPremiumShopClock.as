package com.dchoc.game.eview.widgets.premiumShop
{
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   
   public class TabBodyPremiumShopClock extends TabBodyPremiumShop
   {
      
      private static const TEXT_PAGE:String = "text_info";
      
      private static const CLOCK_CONTENT:String = "clock_conent";
       
      
      private var mClockText:ETextField;
      
      private var mSubBody:ESprite;
      
      private var mSubArea:ELayoutArea;
      
      public function TabBodyPremiumShopClock(viewFactory:ViewFactory, skinSku:String)
      {
         super(viewFactory,skinSku,false);
         MAX_BOXES = 3;
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         this.mClockText = null;
      }
      
      override public function setup() : void
      {
         var layoutFactory:ELayoutAreaFactory = null;
         super.setup();
         layoutFactory = mViewFactory.getLayoutAreaFactory("PremiumShopPageClock");
         this.mSubArea = layoutFactory.getArea("container_boxes");
         this.mSubBody = mViewFactory.getESprite(mSkinSku,this.mSubArea);
         mBody.eAddChild(this.mSubBody);
         var content:ESpriteContainer = mViewFactory.getContentIconWithTextHorizontal("IconTextS","icon_clock","00:00:00",mSkinSku,"text_body");
         setContent("clock_conent",content);
         mBody.eAddChild(content);
         this.mClockText = content.getContent("text") as ETextField;
         this.setTextTime(0);
         this.mClockText.applySkinProp(mSkinSku,"text_title_3");
         layoutFactory.getArea("icon_text_m").centerContent(content);
      }
      
      private function setTextTime(time:Number) : void
      {
         if(this.mClockText != null)
         {
            this.mClockText.setText(DCTextMng.getCountdownTime(time));
         }
      }
      
      override public function setTimerVisible(value:Boolean) : void
      {
         var content:ESprite = getContent("clock_conent");
         if(content != null)
         {
            content.visible = value;
         }
      }
      
      override protected function getBodyArea() : ELayoutArea
      {
         return this.mSubArea;
      }
      
      override protected function getBodyContainer() : ESprite
      {
         return this.mSubBody;
      }
      
      override public function logicUpdate(dt:int) : void
      {
         super.logicUpdate(dt);
         if(mShopDef != null)
         {
            this.setTextTime(mShopDef.getTimeLeft());
         }
      }
   }
}
