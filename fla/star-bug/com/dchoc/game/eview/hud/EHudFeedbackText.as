package com.dchoc.game.eview.hud
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.utils.animations.TweenEffectsFactory;
   import com.dchoc.game.eview.ViewFactory;
   import com.gskinner.motion.GTween;
   import esparragon.display.ESprite;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.layout.ELayoutTextArea;
   
   public class EHudFeedbackText extends ESprite
   {
      
      private static const LAYER_TEXT:int = 0;
      
      private static const LAYER_FADE_IN:int = 1;
      
      private static const LAYER_FADE_OUT:int = 2;
      
      private static const LAYER_COUNT:int = 3;
       
      
      private var mGlobalAreaFeedbackTextFieldVector:Vector.<ETextField>;
      
      private var mTTL:int;
      
      private var mAnimationData:Vector.<Object>;
      
      public function EHudFeedbackText()
      {
         var i:int = 0;
         var tf:ETextField = null;
         super();
         this.mGlobalAreaFeedbackTextFieldVector = new Vector.<ETextField>(0);
         this.mAnimationData = new Vector.<Object>(0);
         var viewFactory:ViewFactory;
         var layoutFactory:ELayoutAreaFactory = (viewFactory = InstanceMng.getViewFactory()).getLayoutAreaFactory("TextFieldAnimation");
         var textArea:ELayoutTextArea = layoutFactory.getTextArea("text_1");
         for(i = 0; i < 3; )
         {
            tf = viewFactory.getETextField(InstanceMng.getSkinsMng().getCurrentSkinSku(),textArea);
            tf.setText(" ");
            tf.applySkinProp(null,"text_header");
            tf.mouseEnabled = false;
            eAddChild(tf);
            this.mGlobalAreaFeedbackTextFieldVector.push(tf);
            i++;
         }
         this.mouseEnabled = false;
         this.mouseChildren = false;
         this.hideIfEmpty(null);
      }
      
      override protected function extendedDestroy() : void
      {
         var tf:ETextField = null;
         for each(tf in this.mGlobalAreaFeedbackTextFieldVector)
         {
            eRemoveChild(tf);
         }
         this.mGlobalAreaFeedbackTextFieldVector.length = 0;
         this.mAnimationData.length = 0;
         this.mTTL = 0;
      }
      
      public function addData(text:String, ttl:int, delay:int, animation:String = null) : void
      {
         this.mAnimationData.push({
            "text":text,
            "ttl":ttl,
            "delay":delay,
            "animation":animation
         });
      }
      
      private function startAnimation(o:Object) : void
      {
         this.scaleLogicX = this.scaleLogicY = 1;
         this.mGlobalAreaFeedbackTextFieldVector[0].visible = false;
         this.mGlobalAreaFeedbackTextFieldVector[0].setText(o["text"]);
         this.mGlobalAreaFeedbackTextFieldVector[1].setText(o["text"]);
         this.mGlobalAreaFeedbackTextFieldVector[1].visible = true;
         var tween:GTween = TweenEffectsFactory.createFade(0,this.mGlobalAreaFeedbackTextFieldVector[1]);
         tween.autoPlay = true;
         tween.duration = Math.min(0.8,(o["ttl"] - 100) / 1000);
         tween.onComplete = this.showText;
         this.mTTL = o["ttl"];
      }
      
      private function showText(tween:GTween) : void
      {
         if(this.mGlobalAreaFeedbackTextFieldVector.length == 3)
         {
            this.mGlobalAreaFeedbackTextFieldVector[0].visible = true;
            this.mGlobalAreaFeedbackTextFieldVector[1].visible = false;
         }
      }
      
      private function stopAnimation() : void
      {
         var tween:GTween = null;
         if(this.mGlobalAreaFeedbackTextFieldVector.length == 3)
         {
            this.mGlobalAreaFeedbackTextFieldVector[0].visible = false;
            this.mGlobalAreaFeedbackTextFieldVector[2].visible = true;
            this.mGlobalAreaFeedbackTextFieldVector[2].alpha = 1;
            this.mGlobalAreaFeedbackTextFieldVector[2].setText(this.mGlobalAreaFeedbackTextFieldVector[0].getText());
            tween = TweenEffectsFactory.createFade(1,this.mGlobalAreaFeedbackTextFieldVector[2]);
            tween.autoPlay = true;
            tween.onComplete = this.hideIfEmpty;
         }
      }
      
      private function hideIfEmpty(tween:GTween) : void
      {
         if(this.mTTL <= 0)
         {
            this.scaleLogicX = this.scaleLogicY = 0;
         }
      }
      
      override public function logicUpdate(dt:int) : void
      {
         var i:int = 0;
         var data:Object = null;
         if(this.mTTL > 0)
         {
            this.mTTL -= dt;
            if(this.mTTL <= 0)
            {
               this.stopAnimation();
            }
         }
         for(i = this.mAnimationData.length - 1; i >= 0; )
         {
            data = this.mAnimationData[i];
            data["delay"] -= dt;
            if(data["delay"] <= 0)
            {
               this.startAnimation(data);
               this.mAnimationData.splice(i,1);
            }
            i--;
         }
      }
   }
}
