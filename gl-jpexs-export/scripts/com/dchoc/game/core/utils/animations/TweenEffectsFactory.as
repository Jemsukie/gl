package com.dchoc.game.core.utils.animations
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import com.greensock.easing.Back;
   import com.gskinner.motion.GTween;
   import com.gskinner.motion.GTweenTimeline;
   import com.gskinner.motion.easing.Bounce;
   import com.gskinner.motion.easing.Exponential;
   import com.gskinner.motion.easing.Sine;
   import com.gskinner.motion.plugins.ColorAdjustPlugin;
   import com.gskinner.motion.plugins.MotionBlurPlugin;
   import flash.display.DisplayObjectContainer;
   import flash.geom.Point;
   
   public class TweenEffectsFactory
   {
      
      public static const EFFECT_ZOOM:int = 0;
      
      public static const EFFECT_ACCORDION_VERTICAL:int = 1;
      
      public static const EFFECT_ACCORDION_HORIZONTAL:int = 2;
      
      public static const EFFECT_TRANSLATION_LEFT:int = 3;
      
      public static const EFFECT_TRANSLATION_RIGHT:int = 4;
      
      public static const EFFECT_BLURRED_TRANSITION:int = 5;
      
      public static const EFFECT_FADE:int = 6;
      
      public static const EFFECT_MODE_IN:int = 0;
      
      public static const EFFECT_MODE_OUT:int = 1;
      
      private static var mTransitionScaleAlpha:Object = {
         "scale":0,
         "alpha":0
      };
      
      private static var mTransitionPosition:Point;
      
      private static var mTransitionOrigin:Point;
      
      private static var mTransitionDoc:DisplayObjectContainer;
      
      private static var mTransitionFunction:Function;
       
      
      public function TweenEffectsFactory()
      {
         super();
      }
      
      public static function createTransition(doc:DisplayObjectContainer, duration:Number, oPoint:Point, tPoint:Point, oScale:Number, tScale:Number, oAlpha:Number, tAlpha:Number, easeScale:Function, easeTransition:Function, onComplete:Function = null) : void
      {
         mTransitionScaleAlpha.scale = oScale;
         mTransitionScaleAlpha.alpha = oAlpha;
         mTransitionDoc = doc;
         mTransitionPosition = oPoint;
         mTransitionOrigin = new Point(doc.x,doc.y);
         mTransitionFunction = onComplete;
         var timeline:GTweenTimeline;
         (timeline = new GTweenTimeline(null,0,null,{
            "repeatCount":1,
            "reflect":false
         })).addTween(0,new GTween(mTransitionScaleAlpha,duration,{
            "scale":tScale,
            "alpha":tScale
         },{
            "ease":easeScale,
            "onChange":onTweenChangeScaleAlpha
         }));
         if(tPoint != null)
         {
            timeline.addTween(0,new GTween(mTransitionPosition,duration,{
               "x":tPoint.x,
               "y":tPoint.y
            },{
               "ease":easeTransition,
               "onChange":onTweenChangePosition
            }));
         }
         timeline.onComplete = onTransitionComplete;
         timeline.calculateDuration();
      }
      
      public static function createTransitionAlpha(doc:DisplayObjectContainer, duration:Number, oAlpha:Number, tAlpha:Number, easeScale:Function, easeTransition:Function, onComplete:Function = null) : void
      {
         mTransitionScaleAlpha.alpha = oAlpha;
         mTransitionDoc = doc;
         mTransitionOrigin = new Point(doc.x,doc.y);
         mTransitionFunction = onComplete;
         var timeline:GTweenTimeline;
         (timeline = new GTweenTimeline(null,0,null,{
            "repeatCount":1,
            "reflect":false
         })).addTween(0,new GTween(mTransitionScaleAlpha,duration,{"alpha":tAlpha},{"onChange":onTweenChangeAlpha}));
         timeline.onComplete = onTransitionComplete;
         timeline.calculateDuration();
      }
      
      public static function createZoom(mode:int, doc:DisplayObjectContainer, onComplete:Function = null) : GTween
      {
         var values:Object = null;
         var ease:Object = null;
         var speed:Number = 0;
         if(mode == 0)
         {
            doc.scaleX = 0;
            doc.scaleY = 0;
            doc.alpha = 0.2;
            speed = 0.35;
            values = {
               "scaleX":1,
               "scaleY":1,
               "alpha":1
            };
            ease = {
               "ease":Back.easeOut,
               "onComplete":onComplete
            };
         }
         else
         {
            speed = 0.2;
            values = {
               "scaleX":0,
               "scaleY":0,
               "alpha":0.2
            };
            ease = {"onComplete":onComplete};
         }
         return new GTween(doc,speed,values,ease);
      }
      
      public static function createJump(doc:DisplayObjectContainer, duration:Number, oPoint:DCCoordinate, tPoint:DCCoordinate, delayTime:Number = 0.5) : GTween
      {
         var tweenBounce:GTween = null;
         var tween:GTween = null;
         var values:Object = null;
         var ease:Object = null;
         var valuesBounce:Object = null;
         var easeBounce:Object = null;
         valuesBounce = {
            "x":oPoint.x,
            "y":oPoint.y
         };
         easeBounce = {
            "autoPlay":false,
            "ease":Bounce.easeOut,
            "nextTween":tween
         };
         tweenBounce = new GTween(doc,duration,valuesBounce,easeBounce);
         values = {
            "x":tPoint.x,
            "y":tPoint.y
         };
         ease = {
            "delay":delayTime,
            "autoPlay":true,
            "nextTween":tweenBounce,
            "ease":Sine.easeOut
         };
         tween = new GTween(doc,duration / 1.5,values,ease);
         tweenBounce.nextTween = tween;
         return tween;
      }
      
      public static function createTranslation(doc:DisplayObjectContainer, centerByCoord:DCCoordinate, alphaValue:Number = 0.1, duration:Number = 0.45, nextTweenAnim:GTween = null, applyBlur:Boolean = true, onComplete:Function = null) : GTween
      {
         var values:Object = null;
         var ease:Object = null;
         var pluginData:Object = null;
         if(centerByCoord == null)
         {
            centerByCoord = MyUnit.smCoor;
            centerByCoord.x = InstanceMng.getApplication().stageGetWidth() / 2;
            centerByCoord.y = InstanceMng.getApplication().stageGetHeight() / 2;
         }
         values = {
            "alpha":alphaValue,
            "x":centerByCoord.x,
            "y":centerByCoord.y
         };
         ease = {
            "nextTween":nextTweenAnim,
            "ease":Sine.easeInOut,
            "onComplete":onComplete
         };
         if(applyBlur)
         {
            MotionBlurPlugin.install();
            MotionBlurPlugin.strength = 0.8;
            pluginData = {"MotionBlurEnabled":true};
         }
         return new GTween(doc,duration,values,ease,pluginData);
      }
      
      public static function createBlurredZoom(zoomMode:int, doc:DisplayObjectContainer, alphaValue:Number = 0.1, scale:Number = 0, duration:Number = 0.45, target:Point = null, autoStart:Boolean = true, onComplete:Function = null) : GTween
      {
         var signX:int = 0;
         var signY:int = 0;
         var pT:Point = null;
         var values:Object = null;
         var ease:Object = null;
         var pluginData:Object = null;
         values = {
            "scaleX":scale,
            "scaleY":scale,
            "alpha":alphaValue
         };
         if(target != null)
         {
            signX = scale >= doc.scaleX ? 1 : 0;
            signY = scale >= doc.scaleY ? 1 : 0;
            pT = new Point((target.x - doc.x) * (scale * signX),(target.y - doc.y) * (scale * signY));
            values.x = InstanceMng.getViewMng().getStageWidth() / 2 - pT.x;
            values.y = InstanceMng.getViewMng().getStageHeight() / 2 - pT.y;
         }
         ease = {
            "ease":Exponential.easeIn,
            "onComplete":onComplete,
            "autoPlay":autoStart,
            "pluginData":pluginData
         };
         return new GTween(doc,duration,values,ease);
      }
      
      public static function createSimpleTranslation(doc:DisplayObjectContainer, coord:DCCoordinate, duration:Number, nextTweenAnim:GTween, autoPlayTween:Boolean = true, onComplete:Function = null) : GTween
      {
         var values:Object = null;
         var ease:Object = null;
         values = {
            "x":coord.x,
            "y":coord.y
         };
         ease = {
            "autoPlay":autoPlayTween,
            "nextTween":nextTweenAnim,
            "ease":Sine.easeInOut,
            "onComplete":onComplete
         };
         return new GTween(doc,duration,values,ease);
      }
      
      public static function createColorAdjustFX(doc:DisplayObjectContainer, duration:Number, nextTweenAnim:GTween, autoPlayTween:Boolean = true, brightnessValue:Number = 100, onComplete:Function = null) : GTween
      {
         var values:Object = null;
         var ease:Object = null;
         values = {"brightness":brightnessValue};
         ease = {
            "autoPlay":autoPlayTween,
            "nextTween":nextTweenAnim,
            "onComplete":onComplete
         };
         ColorAdjustPlugin.install();
         return new GTween(doc,duration,values,ease);
      }
      
      public static function createAccordionVertical(mode:int, doc:DisplayObjectContainer, onComplete:Function = null) : GTween
      {
         var values:Object = null;
         var ease:Object = null;
         var speed:Number = 0.35;
         if(mode == 0)
         {
            doc.scaleX = 1.25;
            doc.scaleY = 0;
            values = {
               "scaleX":1,
               "scaleY":1
            };
            ease = {
               "ease":Exponential.easeOut,
               "onComplete":onComplete
            };
         }
         else
         {
            speed = 0.2;
            values = {
               "scaleX":1.05,
               "scaleY":0
            };
            ease = {
               "ease":Exponential.easeIn,
               "onComplete":onComplete
            };
         }
         return new GTween(doc,speed,values,ease);
      }
      
      public static function createAccordionHorizontal(mode:int, doc:DisplayObjectContainer, onComplete:Function = null) : GTween
      {
         var values:Object = null;
         var ease:Object = null;
         var speed:Number = 0.35;
         if(mode == 0)
         {
            doc.scaleX = 0;
            doc.scaleY = 1.25;
            values = {
               "scaleX":1,
               "scaleY":1
            };
            ease = {
               "ease":Exponential.easeOut,
               "onComplete":onComplete
            };
         }
         else
         {
            speed = 0.2;
            values = {
               "scaleX":0,
               "scaleY":1.05
            };
            ease = {
               "ease":Exponential.easeIn,
               "onComplete":onComplete
            };
         }
         return new GTween(doc,speed,values,ease);
      }
      
      public static function createTranslationLeft(mode:int, doc:DisplayObjectContainer, onComplete:Function = null) : GTween
      {
         var pointA:Point = new Point();
         var pointB:Point = new Point();
         if(mode == 0)
         {
            pointA.x = 0;
            pointA.y = doc.y;
            pointB.x = InstanceMng.getApplication().stageGetWidth() >> 1;
            pointB.y = doc.y;
         }
         else
         {
            pointA.x = doc.x;
            pointA.y = doc.y;
            pointB.x = 0;
            pointB.y = doc.y;
         }
         return createTranslationFromPointToPoint(mode,doc,pointA,pointB,true,onComplete);
      }
      
      public static function createTranslationRight(mode:int, doc:DisplayObjectContainer, onComplete:Function = null) : GTween
      {
         var pointA:Point = new Point();
         var pointB:Point = new Point();
         if(mode == 0)
         {
            pointA.x = InstanceMng.getApplication().stageGetWidth();
            pointA.y = doc.y;
            pointB.x = InstanceMng.getApplication().stageGetWidth() >> 1;
            pointB.y = doc.y;
         }
         else
         {
            pointA.x = doc.x;
            pointA.y = doc.y;
            pointB.x = InstanceMng.getApplication().stageGetWidth();
            pointB.y = doc.y;
         }
         return createTranslationFromPointToPoint(mode,doc,pointA,pointB,true,onComplete);
      }
      
      public static function createTranslationFromPointToPoint(mode:int, doc:DisplayObjectContainer, pointA:Point, pointB:Point, fade:Boolean = true, onComplete:Function = null) : GTween
      {
         var values:Object = null;
         var ease:Object = null;
         var speed:Number = 0.35;
         if(mode == 0)
         {
            doc.x = pointA.x;
            doc.y = pointA.y;
            if(fade)
            {
               doc.alpha = 0;
            }
            else
            {
               doc.alpha = 1;
            }
            values = {
               "x":pointB.x,
               "y":pointB.y,
               "alpha":1
            };
            ease = {
               "ease":Exponential.easeOut,
               "onComplete":onComplete
            };
         }
         else
         {
            speed = 0.2;
            doc.x = pointA.x;
            doc.y = pointA.y;
            values = {
               "x":pointB.x,
               "y":pointB.y
            };
            if(fade)
            {
               values.alpha = 0;
            }
            ease = {
               "ease":Exponential.easeIn,
               "onComplete":onComplete
            };
         }
         return new GTween(doc,speed,values,ease);
      }
      
      public static function createFade(mode:int, doc:DisplayObjectContainer, onComplete:Function = null) : GTween
      {
         var values:Object = null;
         var ease:Object = null;
         var speed:Number = 0.2;
         if(mode == 0)
         {
            doc.alpha = 0;
            values = {"alpha":1};
            ease = {"onComplete":onComplete};
         }
         else
         {
            values = {"alpha":0};
            ease = {"onComplete":onComplete};
         }
         return new GTween(doc,speed,values,ease);
      }
      
      private static function onTransitionComplete(tween:GTween) : void
      {
         mTransitionScaleAlpha.scale = 1;
         mTransitionScaleAlpha.alpha = 1;
         mTransitionPosition = null;
         mTransitionOrigin = null;
         mTransitionDoc = null;
         if(mTransitionFunction is Function)
         {
            mTransitionFunction();
         }
         mTransitionFunction = null;
      }
      
      private static function onTweenChangePosition(tween:GTween) : void
      {
         var pT:Point = null;
         var coord:Point = null;
         if(mTransitionDoc != null)
         {
            pT = new Point((mTransitionPosition.x - mTransitionOrigin.x) * mTransitionScaleAlpha.scale,(mTransitionPosition.y - mTransitionOrigin.y) * mTransitionScaleAlpha.scale);
            coord = new Point(InstanceMng.getViewMng().getStageWidth() / 2 - pT.x,InstanceMng.getViewMng().getStageHeight() / 2 - pT.y);
            mTransitionDoc.x = coord.x;
            mTransitionDoc.y = coord.y;
            mTransitionDoc.scaleX = mTransitionScaleAlpha.scale;
            mTransitionDoc.scaleY = mTransitionScaleAlpha.scale;
         }
      }
      
      private static function onTweenChangeScaleAlpha(tween:GTween) : void
      {
         if(mTransitionDoc != null)
         {
            mTransitionDoc.scaleX = mTransitionScaleAlpha.scale;
            mTransitionDoc.scaleY = mTransitionScaleAlpha.scale;
            mTransitionDoc.alpha = mTransitionScaleAlpha.alpha;
         }
      }
      
      private static function onTweenChangeAlpha(tween:GTween) : void
      {
         if(mTransitionDoc != null)
         {
            mTransitionDoc.alpha = mTransitionScaleAlpha.alpha;
         }
      }
   }
}
