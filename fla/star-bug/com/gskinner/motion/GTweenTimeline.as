package com.gskinner.motion
{
   public class GTweenTimeline extends GTween
   {
       
      
      public var suppressCallbacks:Boolean;
      
      protected var callbacks:Array;
      
      protected var labels:Object;
      
      protected var tweens:Array;
      
      protected var tweenStartPositions:Array;
      
      public function GTweenTimeline(target:Object = null, duration:Number = 1, values:Object = null, props:Object = null, pluginData:Object = null, tweens:Array = null)
      {
         this.tweens = [];
         this.tweenStartPositions = [];
         this.callbacks = [];
         this.labels = {};
         this.addTweens(tweens);
         super(target,duration,values,props,pluginData);
         if(autoPlay)
         {
            paused = false;
         }
      }
      
      public static function setPropertyValue(target:Object, propertyName:String, value:*) : void
      {
         target[propertyName] = value;
      }
      
      override public function set position(value:Number) : void
      {
         var i:int = 0;
         var tmpSuppressEvents:Boolean = suppressEvents;
         suppressEvents = true;
         super.position = value;
         var repeatIndex:Number = _position / duration >> 0;
         var rev:Boolean = reflect && repeatIndex % 2 >= 1;
         var l:int = int(this.tweens.length);
         if(rev)
         {
            for(i = 0; i < l; )
            {
               this.tweens[i].position = calculatedPosition - this.tweenStartPositions[i];
               i++;
            }
         }
         else
         {
            for(i = l - 1; i >= 0; )
            {
               this.tweens[i].position = calculatedPosition - this.tweenStartPositions[i];
               i--;
            }
         }
         if(!this.suppressCallbacks)
         {
            this.checkCallbacks();
         }
         suppressEvents = tmpSuppressEvents;
         if(onChange != null && !suppressEvents)
         {
            onChange(this);
         }
         if(onComplete != null && !suppressEvents && value >= repeatCount * duration && repeatCount > 0)
         {
            onComplete(this);
         }
      }
      
      public function addTween(position:Number, tween:GTween) : void
      {
         if(tween == null || isNaN(position))
         {
            return;
         }
         tween.autoPlay = false;
         tween.paused = true;
         var index:int = -1;
         do
         {
            index++;
         }
         while(index < this.tweens.length && this.tweenStartPositions[index] < position);
         
         this.tweens.splice(index,0,tween);
         this.tweenStartPositions.splice(index,0,position);
         tween.position = calculatedPosition - position;
      }
      
      public function addTweens(tweens:Array) : void
      {
         var i:* = 0;
         if(tweens == null)
         {
            return;
         }
         i = 0;
         while(i < tweens.length)
         {
            this.addTween(tweens[i],tweens[i + 1] as GTween);
            i += 2;
         }
      }
      
      public function removeTween(tween:GTween) : void
      {
         var i:int = 0;
         for(i = int(this.tweens.length); i >= 0; )
         {
            if(this.tweens[i] == tween)
            {
               this.tweens.splice(i,1);
               this.tweenStartPositions.splice(i,1);
            }
            i--;
         }
      }
      
      public function addLabel(position:Number, label:String) : void
      {
         this.labels[label] = position;
      }
      
      public function removeLabel(label:String) : void
      {
         delete this.labels[label];
      }
      
      public function addCallback(labelOrPosition:*, forwardCallback:Function, forwardParameters:Array = null, reverseCallback:Function = null, reverseParameters:Array = null) : void
      {
         var i:int = 0;
         var position:Number = this.resolveLabelOrPosition(labelOrPosition);
         if(isNaN(position))
         {
            return;
         }
         var callback:Callback = new Callback(position,forwardCallback,forwardParameters,reverseCallback,reverseParameters);
         for(var l:int,i = (l = int(this.callbacks.length)) - 1; i >= 0; )
         {
            if(position > this.callbacks[i].position)
            {
               break;
            }
            i--;
         }
         this.callbacks.splice(i + 1,0,callback);
      }
      
      public function removeCallback(labelOrPosition:*) : void
      {
         var i:int = 0;
         var position:Number = this.resolveLabelOrPosition(labelOrPosition);
         if(isNaN(position))
         {
            return;
         }
         var l:int = int(this.callbacks.length);
         for(i = 0; i < l; )
         {
            if(position == this.callbacks[i].position)
            {
               this.callbacks.splice(i,1);
            }
            i++;
         }
      }
      
      public function gotoAndPlay(labelOrPosition:*) : void
      {
         this.goto_(labelOrPosition);
         paused = false;
      }
      
      public function gotoAndStop(labelOrPosition:*) : void
      {
         this.goto_(labelOrPosition);
         paused = true;
      }
      
      public function goto_(labelOrPosition:*) : void
      {
         var pos:Number = this.resolveLabelOrPosition(labelOrPosition);
         if(!isNaN(pos))
         {
            this.position = pos;
         }
      }
      
      public function resolveLabelOrPosition(labelOrPosition:*) : Number
      {
         return isNaN(labelOrPosition) ? Number(this.labels[labelOrPosition]) : labelOrPosition;
      }
      
      public function calculateDuration() : void
      {
         var i:int = 0;
         var d:Number = 0;
         if(this.callbacks.length > 0)
         {
            d = Number(this.callbacks[this.callbacks.length - 1].position);
         }
         i = 0;
         while(i < this.tweens.length)
         {
            if(this.tweens[i].duration + this.tweenStartPositions[i] > d)
            {
               d = this.tweens[i].duration + this.tweenStartPositions[i];
            }
            i++;
         }
         duration = d;
      }
      
      protected function checkCallbacks() : void
      {
         var rev:Boolean = false;
         if(this.callbacks.length == 0)
         {
            return;
         }
         var repeatIndex:uint = uint(_position / duration >> 0);
         var previousRepeatIndex:uint = uint(positionOld / duration >> 0);
         if(repeatIndex == previousRepeatIndex || repeatCount > 0 && _position >= duration * repeatCount)
         {
            this.checkCallbackRange(calculatedPositionOld,calculatedPosition);
         }
         else
         {
            rev = reflect && previousRepeatIndex % 2 >= 1;
            this.checkCallbackRange(calculatedPositionOld,rev ? 0 : duration);
            rev = reflect && repeatIndex % 2 >= 1;
            this.checkCallbackRange(rev ? duration : 0,calculatedPosition,!reflect);
         }
      }
      
      protected function checkCallbackRange(startPos:Number, endPos:Number, includeStart:Boolean = false) : void
      {
         var callback:Callback = null;
         var pos:Number = NaN;
         var sPos:* = startPos;
         var ePos:* = endPos;
         var i:* = -1;
         var j:int = int(this.callbacks.length);
         var k:int = 1;
         if(startPos > endPos)
         {
            sPos = endPos;
            ePos = startPos;
            i = j;
            j = k = -1;
         }
         while((i += k) != j)
         {
            if((pos = (callback = this.callbacks[i]).position) > sPos && pos < ePos || pos == endPos || includeStart && pos == startPos)
            {
               if(k == 1)
               {
                  if(callback.forward != null)
                  {
                     callback.forward.apply(this,callback.forwardParams);
                  }
               }
               else if(callback.reverse != null)
               {
                  callback.reverse.apply(this,callback.reverseParams);
               }
            }
         }
      }
   }
}

class Callback
{
    
   
   public var position:Number;
   
   public var forward:Function;
   
   public var reverse:Function;
   
   public var forwardParams:Array;
   
   public var reverseParams:Array;
   
   public function Callback(position:Number, forward:Function, forwardParams:Array, reverse:Function, reverseParams:Array)
   {
      super();
      this.position = position;
      this.forward = forward;
      this.reverse = reverse;
      this.forwardParams = forwardParams;
      this.reverseParams = reverseParams;
   }
}
