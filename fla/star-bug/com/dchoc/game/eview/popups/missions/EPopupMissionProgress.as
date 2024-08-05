package com.dchoc.game.eview.popups.missions
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.widgets.EGamePopup;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.DCTargetDef;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.easing.Exponential;
   import esparragon.display.ESprite;
   import esparragon.display.ETextField;
   import esparragon.events.EEvent;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   
   public class EPopupMissionProgress extends EGamePopup
   {
      
      public static const NUM_ITEMS:int = 3;
      
      private static const BODY:String = "Body";
      
      private static const LAYOUT_POPUP_NAME:String = "PopL";
      
      private static const LAYOUT_CONTENT_NAME:String = "PopMission";
      
      private static const LAYOUT_MINITARGET_NAME:String = "PopMissionBox";
      
      private static const LAYOUT_BACKGROUND_RESOURCE_NAME:String = "pop_l";
       
      
      private var mTarget:DCTarget;
      
      private var mBriefingTF:ETextField;
      
      private var mHintTF:ETextField;
      
      private var mBoxesSprite:ESprite;
      
      private var mBoxesContent:Vector.<EPopupMissionTargetBox>;
      
      public function EPopupMissionProgress()
      {
         super();
      }
      
      override public function setup(popupId:String, viewFactory:ViewFactory, skinSku:String) : void
      {
         var i:int = 0;
         var button:EButton = null;
         super.setup(popupId,viewFactory,skinSku);
         var popupLayoutFactory:ELayoutAreaFactory = viewFactory.getLayoutAreaFactory("PopL");
         var contentLayoutFactory:ELayoutAreaFactory = viewFactory.getLayoutAreaFactory("PopMission");
         var minitargetLayoutFactory:ELayoutAreaFactory = viewFactory.getLayoutAreaFactory("PopMissionBox");
         setFooterArea(popupLayoutFactory.getArea("footer"));
         var area:ELayoutArea = popupLayoutFactory.getArea("bg");
         var bkg:ESprite = viewFactory.getEImage("pop_l",mSkinSku,false,area);
         setLayoutArea(area,true);
         setBackground(bkg);
         eAddChild(bkg);
         var body:ESprite;
         (body = mViewFactory.getESprite(skinSku)).layoutApplyTransformations(popupLayoutFactory.getArea("body"));
         bkg.eAddChild(body);
         setContent("Body",body);
         var title:ETextField = mViewFactory.getETextField(skinSku,popupLayoutFactory.getTextArea("text_title"),"text_title_0");
         setTitle(title);
         bkg.eAddChild(getTitle());
         this.mBriefingTF = mViewFactory.getETextField(skinSku,contentLayoutFactory.getTextArea("text_info"));
         this.mBriefingTF.applySkinProp(mSkinSku,"text_body");
         body.eAddChild(this.mBriefingTF);
         this.mHintTF = mViewFactory.getETextField(skinSku,contentLayoutFactory.getTextArea("text_hint"));
         this.mHintTF.applySkinProp(mSkinSku,"text_body");
         body.eAddChild(this.mHintTF);
         var contentLayoutArea:ELayoutArea = contentLayoutFactory.getArea("container_missions");
         this.mBoxesContent = new Vector.<EPopupMissionTargetBox>(3);
         this.mBoxesSprite = mViewFactory.getESprite(skinSku,contentLayoutArea);
         var hDiff:int = contentLayoutArea.height / 3;
         for(i = 0; i < 3; )
         {
            this.mBoxesContent[i] = new EPopupMissionTargetBox();
            this.mBoxesContent[i].build(minitargetLayoutFactory,skinSku,this);
            this.mBoxesSprite.eAddChild(this.mBoxesContent[i]);
            this.mBoxesContent[i].logicTop = hDiff * i;
            i++;
         }
         this.mBoxesSprite.layoutApplyTransformations(contentLayoutArea);
         body.eAddChild(this.mBoxesSprite);
         button = mViewFactory.getButton("btn_accept",mSkinSku,"M",DCTextMng.getText(390));
         addButton("btn_accept",button);
         button.eAddEventListener("click",this.onAcceptButton);
      }
      
      override protected function extendedDestroy() : void
      {
         var box:EPopupMissionTargetBox = null;
         super.extendedDestroy();
         this.mTarget = null;
         if(this.mBriefingTF != null)
         {
            this.mBriefingTF.destroy();
            this.mBriefingTF = null;
         }
         if(this.mHintTF != null)
         {
            this.mHintTF.destroy();
            this.mHintTF = null;
         }
         if(this.mBoxesSprite != null)
         {
            this.mBoxesSprite.destroy();
            this.mBoxesSprite = null;
         }
         if(this.mBoxesContent != null)
         {
            while(this.mBoxesContent.length > 0)
            {
               box = this.mBoxesContent.shift();
               box.destroy();
            }
            this.mBoxesContent = null;
         }
      }
      
      public function setTarget(target:DCTarget, mustUpdateContent:Boolean = true) : void
      {
         this.mTarget = target;
         if(mustUpdateContent)
         {
            this.updateContent();
         }
      }
      
      private function updateContent() : void
      {
         var i:* = 0;
         var miniTargetProgStr:String = null;
         var totalProgStr:String = null;
         var mainText:String = null;
         var miniTargetProgress:int = 0;
         var progress:String = null;
         var isTargetCompleted:* = false;
         var targetDef:DCTargetDef = this.mTarget.getDef();
         getTitle().setText(DCTextMng.getText(TextIDs[targetDef.getTargetTitle()]));
         this.mBriefingTF.setText(DCTextMng.getText(TextIDs[targetDef.getTargetSummary()]));
         this.mHintTF.setText(DCTextMng.getText(TextIDs[targetDef.getTargetHelp()]));
         var numElems:int = targetDef.getNumMinitargetsFound();
         for(i = 0; i < numElems; )
         {
            mainText = targetDef.getMiniTargetBody(i);
            this.mBoxesContent[i].setText(DCTextMng.getText(TextIDs[mainText]));
            this.mBoxesContent[i].setSecondaryRequirement(targetDef,i);
            miniTargetProgress = InstanceMng.getTargetMng().getProgress(targetDef.mSku,i);
            miniTargetProgStr = DCTextMng.convertNumberToString(miniTargetProgress,1,4,true);
            totalProgStr = DCTextMng.convertNumberToString(targetDef.getMiniTargetAmount(i),1,4);
            progress = miniTargetProgStr + "/" + totalProgStr;
            isTargetCompleted = miniTargetProgress >= targetDef.getMiniTargetAmount(i);
            this.mBoxesContent[i].setCompleted(isTargetCompleted);
            if(isTargetCompleted == false)
            {
               this.mBoxesContent[i].setProgressText(progress);
            }
            this.mBoxesContent[i].visible = true;
            this.mBoxesContent[i].setIconInfo(targetDef.getMiniTargetIcon(i));
            this.mBoxesContent[i].setupButtons(targetDef,i);
            this.mBoxesContent[i].setMiniTargetIndexInTarget(i);
            i++;
         }
         for(i = numElems; i < 3; )
         {
            this.mBoxesContent[i].visible = false;
            i++;
         }
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var obj:EPopupMissionTargetBox = null;
         var box:ESprite = null;
         super.logicUpdate(dt);
         if(this.mBriefingTF != null)
         {
            this.mBriefingTF.logicUpdate(dt);
         }
         if(this.mHintTF != null)
         {
            this.mHintTF.logicUpdate(dt);
         }
         if(this.mBoxesSprite != null)
         {
            for each(box in this.mBoxesSprite)
            {
               box.logicUpdate(dt);
            }
         }
         if(this.mTarget != null && this.mTarget.State >= 3)
         {
            InstanceMng.getPopupMng().closePopup(this,null,true);
            return;
         }
         for each(obj in this.mBoxesContent)
         {
            obj.logicUpdate(dt);
         }
      }
      
      override protected function showEffect() : void
      {
         var i:int = 0;
         var obj:EPopupMissionTargetBox = null;
         var tween:GTween = null;
         super.showEffect();
         for(i = 0; i < 3; )
         {
            obj = this.mBoxesContent[i];
            tween = new GTween(obj,0.2);
            tween.setValue("x",obj.x);
            tween.setValue("alpha",1);
            tween.delay = 0.2 * i;
            tween.autoPlay = true;
            tween.ease = Exponential.easeOut;
            obj.x += 400;
            obj.alpha = 0;
            i++;
         }
      }
      
      private function onAcceptButton(evt:EEvent) : void
      {
         super.notifyPopupMngClose(this);
      }
   }
}
