package com.dchoc.game.core.flow.messaging
{
   import flash.utils.Dictionary;
   
   public interface INotifyReceiver
   {
       
      
      function getName() : String;
      
      function getTaskList() : Vector.<String>;
      
      function onMessage(param1:String, param2:Dictionary) : void;
   }
}
