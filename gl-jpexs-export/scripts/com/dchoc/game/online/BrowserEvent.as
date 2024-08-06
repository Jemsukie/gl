package com.dchoc.game.online
{
   import flash.events.Event;
   
   public class BrowserEvent extends Event
   {
      
      public static const onBrowserResponse:String = "onBrowserResponse";
       
      
      public var params:Object;
      
      public function BrowserEvent(type:String, params:Object)
      {
         super(type);
         this.params = params;
      }
   }
}
