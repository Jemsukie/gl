package com.dchoc.game.utils
{
   import com.dchoc.toolkit.core.media.SoundManager;
   import flash.events.Event;
   import flash.utils.Timer;
   
   public class SoundUtil
   {
       
      
      private var elapsedTime:int;
      
      private var name:String;
      
      private var totalTime:int;
      
      private var intervalLow:int;
      
      private var intervalHigh:int;
      
      public function SoundUtil()
      {
         super();
      }
      
      public function startRandomLoop(name:String, totalTime:int, intervalLow:int, intervalHigh:int) : void
      {
         this.name = name;
         this.totalTime = totalTime;
         this.intervalLow = intervalLow;
         this.intervalHigh = intervalHigh;
         SoundManager.getInstance().playSound("explode.mp3");
         this.soundRepetition();
      }
      
      private function soundRepetition() : void
      {
         var repetitionTime:int = this.intervalLow + Math.random() * (this.intervalHigh - this.intervalLow);
         this.elapsedTime += repetitionTime;
         var timer:Timer = new Timer(repetitionTime);
         timer.addEventListener("timer",this.onTimer);
         timer.start();
      }
      
      private function onTimer(e:Event) : void
      {
         (e.target as Timer).removeEventListener("timer",this.onTimer);
         SoundManager.getInstance().playSound("explode.mp3");
         if(this.elapsedTime < this.totalTime)
         {
            this.soundRepetition();
         }
      }
   }
}
