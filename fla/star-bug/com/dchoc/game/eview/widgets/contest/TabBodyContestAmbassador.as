package com.dchoc.game.eview.widgets.contest
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.model.contest.ContestMng;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import esparragon.core.Esparragon;
   import esparragon.display.EGraphics;
   import esparragon.display.EImage;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.layout.behaviors.ELayoutBehaviorCenterAndScale;
   
   public class TabBodyContestAmbassador extends ESpriteContainer
   {
      
      private static const ADVISOR_SKU:String = "Advisor";
      
      private static const WINUP_BKG:String = "winupBkg";
      
      private static const SHINE:String = "shine";
      
      private static const WINUP_TEXT:String = "winupText";
      
      private static const REWARD:String = "reward";
      
      private static const CLOCK_BKG:String = "clockBkg";
      
      private static const TIME_LEFT_SKU:String = "timeLeftSku";
      
      private static const TIME_COUNTER:String = "timeCounter";
      
      private static const ARROW_SKU:String = "arrow";
      
      private static const SPEECH_CONTAINER:String = "speechContainer";
      
      private static const SPEECH_BKG:String = "speechBkg";
      
      private static const TEXT_SPEECH:String = "textSpeech";
      
      private static const ICON_TEXT:String = "iconText1";
      
      private static const ITEMS_BKG:String = "itemsBkg";
      
      private static const ITEMS_TITLE:String = "itemsTitle";
      
      private static const ITEM_CONTENT:String = "itemsContent";
       
      
      private var mViewFactory:ViewFactory;
      
      private var mSkinSku:String;
      
      private var mTimerField:ETextField;
      
      private var mContestMng:ContestMng;
      
      private var mTimerChangedToDone:Boolean;
      
      private var mTimerArea:ELayoutArea;
      
      private var mDoneField:ETextField;
      
      private var mShineArea:ELayoutArea;
      
      public function TabBodyContestAmbassador(viewFactory:ViewFactory, skinSku:String)
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
         if(this.mTimerField != null)
         {
            this.mTimerField.destroy();
            this.mTimerField = null;
         }
         this.mContestMng = null;
         this.mTimerArea = null;
         if(this.mShineArea != null)
         {
            this.mShineArea.destroy();
            this.mShineArea = null;
         }
         if(this.mDoneField != null)
         {
            this.mDoneField.destroy();
            this.mDoneField = null;
         }
      }
      
      public function setup() : void
      {
         var i:int = 0;
         var cols:int = 0;
         var rows:int = 0;
         this.mContestMng = InstanceMng.getContestMng();
         var layoutFactory:ELayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory("BodyAmbassador");
         var img:EImage = this.mViewFactory.getEImage(this.mContestMng.getAdvisor(),this.mSkinSku,true,layoutFactory.getArea("cbox_img"));
         eAddChild(img);
         setContent("Advisor",img);
         var area:ELayoutArea = layoutFactory.getArea("container_box");
         img = this.mViewFactory.getEImage("box_with_border",this.mSkinSku,false,area);
         eAddChild(img);
         setContent("winupBkg",img);
         this.mShineArea = ELayoutAreaFactory.createLayoutAreaFromLayoutArea(area);
         this.mShineArea.addBehavior(new ELayoutBehaviorCenterAndScale());
         img = this.mViewFactory.getEImage("shine_base",this.mSkinSku,false,this.mShineArea);
         img.setPivotLogicXY(0.5,0.5);
         eAddChild(img);
         setContent("shine",img);
         this.mViewFactory.distributeSpritesInArea(area,[img],1,1,1,1,true);
         var field:ETextField;
         (field = this.mViewFactory.getETextField(this.mSkinSku,layoutFactory.getTextArea("text_win"))).setText(DCTextMng.getText(3323));
         eAddChild(field);
         setContent("winupText",field);
         field.applySkinProp(this.mSkinSku,"text_title_1");
         var content:ESpriteContainer;
         if((content = this.mViewFactory.getSingleEntryContainer(this.mContestMng.rewardsGetEntryStringByPos(1),"IconTextXL",this.mSkinSku)) != null)
         {
            field = content.getContent("text") as ETextField;
            eAddChild(content);
            setContent("reward",content);
            area = layoutFactory.getArea("container_text_icon_xl");
            area.centerContent(content);
         }
         this.mTimerArea = layoutFactory.getArea("area_time");
         img = this.mViewFactory.getEImage("generic_box",this.mSkinSku,false,this.mTimerArea);
         eAddChild(img);
         setContent("clockBkg",img);
         field = this.mViewFactory.getETextField(this.mSkinSku,layoutFactory.getTextArea("text_time"));
         eAddChild(field);
         field.setText(DCTextMng.getText(3322));
         setContent("timeLeftSku",field);
         field.applySkinProp(this.mSkinSku,"text_body_2");
         content = this.mViewFactory.getContentIconWithTextHorizontal("IconTextS","icon_clock",DCTextMng.convertTimeToStringColon(0),this.mSkinSku);
         eAddChild(content);
         setContent("timeCounter",content);
         field = content.getContent("text") as ETextField;
         field.width = field.textWithMarginWidth;
         this.mTimerField = field;
         this.mTimerField.applySkinProp(this.mSkinSku,"text_body_2");
         this.mViewFactory.distributeSpritesInArea(this.mTimerArea,[content],1,1);
         content.logicLeft += this.mTimerArea.x;
         content.logicTop += this.mTimerArea.y;
         var clockFactory:ELayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory("IconTextS");
         this.mDoneField = this.mViewFactory.getETextField(this.mSkinSku,clockFactory.getTextArea("text"));
         this.mDoneField.logicLeft = 0;
         this.mDoneField.setText(DCTextMng.getText(3324));
         this.mDoneField.visible = false;
         this.mDoneField.applySkinProp(this.mSkinSku,"text_body_2");
         eAddChild(this.mDoneField);
         this.mViewFactory.distributeSpritesInArea(this.mTimerArea,[this.mDoneField],1,1);
         this.mDoneField.logicLeft += this.mTimerArea.x;
         this.mDoneField.logicTop += this.mTimerArea.y;
         if(this.mContestMng.getRunningTimeLeft() <= 0)
         {
            this.changeTimerToDone();
         }
         area = layoutFactory.getArea("area_items");
         img = this.mViewFactory.getEImage("generic_box",this.mSkinSku,false,area);
         eAddChild(img);
         setContent("itemsBkg",img);
         field = this.mViewFactory.getETextField(this.mSkinSku,layoutFactory.getTextArea("text_items"));
         eAddChild(field);
         field.applySkinProp(this.mSkinSku,"text_body_2");
         setContent("itemsTitle",field);
         field.setText(DCTextMng.getText(TextIDs[this.mContestMng.getProgressText()]));
         content = this.mViewFactory.getContentIconWithTextHorizontal("IconTextS",this.mContestMng.getProgressIcon(),this.mContestMng.userGetScore().toString(),this.mSkinSku);
         eAddChild(content);
         (field = content.getContent("text") as ETextField).applySkinProp(this.mSkinSku,"text_body_2");
         setContent("itemsContent",content);
         area.centerContent(content);
         img = this.mViewFactory.getEImage("speech_arrow",this.mSkinSku,false,layoutFactory.getArea("arrow"),"speech_color");
         eAddChild(img);
         setContent("arrow",img);
         var areaSpeech:ELayoutArea = layoutFactory.getArea("area_speech");
         var speechContent:ESprite = this.mViewFactory.getESprite(this.mSkinSku,areaSpeech);
         area = layoutFactory.getArea("container_text_icon_s_large");
         var gr:EGraphics;
         (gr = Esparragon.getDisplayFactory().createGraphics()).drawRect(area.width,area.height);
         gr.x = area.x;
         gr.y = area.y;
         gr.alpha = 0;
         speechContent.eAddChild(gr);
         setContent("egraphicsrect",gr);
         (field = this.mViewFactory.getETextField(this.mSkinSku,layoutFactory.getTextArea("text_info"))).setText(DCTextMng.getText(TextIDs[this.mContestMng.getMissionText()]));
         speechContent.eAddChild(field);
         setContent("textSpeech",speechContent);
         field.applySkinProp(this.mSkinSku,"text_body");
         var speechBkg:ESprite = this.mViewFactory.getSpeechBubble(areaSpeech,layoutFactory.getArea("arrow"),null,this.mSkinSku,"speech_color");
         eAddChild(speechBkg);
         setContent("speechBkg",speechBkg);
         eAddChild(speechContent);
         var contents:Array = [];
         var contestMng:ContestMng;
         var conditionsCount:int = (contestMng = InstanceMng.getContestMng()).getNumConditions();
         var layout:String = this.mViewFactory.getLayoutByConditions(conditionsCount);
         for(i = 0; i < conditionsCount; )
         {
            content = this.mViewFactory.getContentIconWithTextHorizontal(layout,contestMng.getConditionIcon(i),DCTextMng.getText(TextIDs[contestMng.getConditionTid(i)]),this.mSkinSku,"text_body");
            speechContent.eAddChild(content);
            contents.push(content);
            setContent("iconText1" + i,content);
            i++;
         }
         switch(conditionsCount - 1)
         {
            case 0:
               cols = 1;
               rows = 1;
               break;
            case 1:
               cols = 2;
               rows = 1;
               break;
            case 2:
            case 3:
               cols = 2;
               rows = 2;
         }
         area = layoutFactory.getArea("container_text_icon_s_large");
         this.mViewFactory.distributeSpritesInArea(area,contents,1,1,cols,rows);
         for(i = 0; i < conditionsCount; )
         {
            content = contents[i];
            content.logicLeft += area.x;
            content.logicTop += area.y;
            i++;
         }
         this.mViewFactory.relocateChildInContainer(speechContent);
      }
      
      private function setTime(time:Number) : void
      {
         if(this.mTimerField != null)
         {
            this.mTimerField.setText(DCTextMng.getCountdownTime(time));
         }
      }
      
      private function changeTimerToDone() : void
      {
         var content:ESpriteContainer = getContent("timeCounter") as ESpriteContainer;
         if(content != null)
         {
            content.visible = false;
            this.mDoneField.visible = true;
            this.mTimerChangedToDone = true;
         }
      }
      
      override public function logicUpdate(dt:int) : void
      {
         super.logicUpdate(dt);
         var time:Number = InstanceMng.getContestMng().getRunningTimeLeft();
         if(time > 0)
         {
            this.setTime(time);
         }
         else if(!this.mTimerChangedToDone)
         {
            this.changeTimerToDone();
         }
      }
   }
}
