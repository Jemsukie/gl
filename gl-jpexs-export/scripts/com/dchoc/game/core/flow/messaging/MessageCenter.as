package com.dchoc.game.core.flow.messaging
{
   import com.dchoc.toolkit.core.debug.DCDebug;
   import flash.utils.Dictionary;
   
   public class MessageCenter
   {
      
      public static const CONSOLE_CHANNEL_NAME:String = "Messaging";
      
      private static var smInstance:MessageCenter;
      
      private static var smAllowInstance:Boolean = false;
       
      
      private var mRegisteredReceiverTasks:Dictionary;
      
      private var mRegisteredReceiverNames:Vector.<String>;
      
      public function MessageCenter()
      {
         super();
         if(!smAllowInstance)
         {
            throw new Error("Use MessageCenter.getInstance() instead");
         }
         this.mRegisteredReceiverTasks = new Dictionary();
         this.mRegisteredReceiverNames = new Vector.<String>(0);
      }
      
      public static function getInstance() : MessageCenter
      {
         if(!smInstance)
         {
            smAllowInstance = true;
            smInstance = new MessageCenter();
            smAllowInstance = false;
         }
         return smInstance;
      }
      
      public function registerObject(notifyReceiver:INotifyReceiver) : void
      {
         var task:String = null;
         var receiverName:String = notifyReceiver.getName();
         if(this.mRegisteredReceiverNames.lastIndexOf(receiverName) >= 0)
         {
            DCDebug.traceCh("Messaging","Notify receiver with name " + receiverName + " already registered");
         }
         else
         {
            this.mRegisteredReceiverNames.push(receiverName);
         }
         var taskList:Vector.<String> = notifyReceiver.getTaskList();
         for each(task in taskList)
         {
            if(this.mRegisteredReceiverTasks[task] == null)
            {
               this.mRegisteredReceiverTasks[task] = new Vector.<INotifyReceiver>(0);
            }
            if(this.mRegisteredReceiverTasks[task].lastIndexOf(notifyReceiver) < 0)
            {
               this.mRegisteredReceiverTasks[task].push(notifyReceiver);
            }
         }
      }
      
      public function unregisterObject(notifyReceiver:INotifyReceiver) : void
      {
         var task:String = null;
         var lastIndex:int = 0;
         var receiverName:String = notifyReceiver.getName();
         var receiverNameIndex:int;
         if((receiverNameIndex = this.mRegisteredReceiverNames.lastIndexOf(receiverName)) < 0)
         {
            DCDebug.traceCh("Messaging","Trying to unregister a non-registered receiver: " + receiverName);
         }
         else
         {
            this.mRegisteredReceiverNames.splice(receiverNameIndex,1);
         }
         var taskList:Vector.<String> = notifyReceiver.getTaskList();
         for each(task in taskList)
         {
            if(this.mRegisteredReceiverTasks[task] != null)
            {
               lastIndex = int(this.mRegisteredReceiverTasks[task].lastIndexOf(notifyReceiver));
               while(lastIndex >= 0)
               {
                  this.mRegisteredReceiverTasks[task].splice(lastIndex,1);
                  lastIndex = int(this.mRegisteredReceiverTasks[task].lastIndexOf(notifyReceiver));
               }
            }
         }
      }
      
      public function sendMessage(task:String, params:Dictionary = null) : void
      {
         var receiver:INotifyReceiver = null;
         var registeredReceivers:Vector.<INotifyReceiver> = this.mRegisteredReceiverTasks[task];
         for each(receiver in registeredReceivers)
         {
            receiver.onMessage(task,params);
         }
      }
   }
}
