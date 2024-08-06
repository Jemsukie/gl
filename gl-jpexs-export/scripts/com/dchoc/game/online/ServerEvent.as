package com.dchoc.game.online
{
   import flash.events.Event;
   
   public class ServerEvent extends Event
   {
      
      public static const onServerResponse:String = "onServerResponse";
       
      
      public var params:Object;
      
      public function ServerEvent(type:String, params:Object)
      {
         super(type);
         this.params = params;
      }
   }
}
