package com.dchoc.toolkit.core.notify
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import flash.utils.getQualifiedClassName;
   
   public class DCNotifyMng extends DCComponent
   {
       
      
      private const EVENTS_QUEUE_COUNT:int = 2;
      
      private var mEventsQueueCurrentIndex:int;
      
      private var mEventsQueues:Vector.<Vector.<Object>>;
      
      public function DCNotifyMng()
      {
         super();
      }
      
      override protected function loadDoStep(step:int) : void
      {
         if(step == 0)
         {
            this.eventsLoad();
         }
      }
      
      override protected function unloadDo() : void
      {
         if(this.mEventsQueues != null)
         {
            while(this.mEventsQueues.length > 0)
            {
               this.mEventsQueues.shift();
            }
            this.mEventsQueues = null;
         }
      }
      
      override protected function buildDoAsyncStep(step:int) : void
      {
         if(step == 0)
         {
            this.mEventsQueueCurrentIndex = 0;
         }
      }
      
      override protected function unbuildDo() : void
      {
         var thisVector:Vector.<Object> = null;
         if(this.mEventsQueues != null)
         {
            while(this.mEventsQueues.length > 0)
            {
               thisVector = this.mEventsQueues.shift();
               while(thisVector.length > 0)
               {
                  thisVector.shift();
               }
            }
         }
         this.mEventsQueueCurrentIndex = -1;
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var e:Object = null;
         var componentTarget:DCComponent = null;
         var queue2:Vector.<Object> = this.mEventsQueues[this.mEventsQueueCurrentIndex];
         this.mEventsQueueCurrentIndex = (this.mEventsQueueCurrentIndex + 1) % 2;
         var queue:Vector.<Object> = this.mEventsQueues[this.mEventsQueueCurrentIndex];
         while(queue.length > 0)
         {
            e = queue.shift();
            componentTarget = e.componentTarget as DCComponent;
            if(e.time != null && e.time - InstanceMng.getApplication().getCurrentServerTimeMillis() <= 0 && componentTarget.isBuilt())
            {
               componentTarget.notify(e);
            }
            else
            {
               queue2.push(e);
               if(Config.DEBUG_ASSERTS)
               {
                  DCDebug.trace("WARNING in DCNotifyMng.logicUpdateDo(): event " + e + " is being sent to " + getQualifiedClassName(componentTarget) + " which is not built yet",1);
                  DCDebug.traceObject(e);
               }
            }
         }
      }
      
      private function eventsLoad() : void
      {
         var i:int = 0;
         this.mEventsQueues = new Vector.<Vector.<Object>>(2);
         for(i = 0; i < 2; )
         {
            this.mEventsQueues[i] = new Vector.<Object>(0);
            i++;
         }
      }
      
      public function addEvent(componentTarget:DCComponent, e:Object, notifyImmediately:Boolean = false, time:Number = 0) : void
      {
         e.time = InstanceMng.getApplication().getCurrentServerTimeMillis() + time;
         if(notifyImmediately)
         {
            componentTarget.notify(e);
         }
         else if(this.mEventsQueueCurrentIndex > -1)
         {
            if(this.mEventsQueues == null)
            {
               this.eventsLoad();
            }
            e.componentTarget = componentTarget;
            this.mEventsQueues[this.mEventsQueueCurrentIndex].push(e);
         }
      }
   }
}
