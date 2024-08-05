package com.dchoc.game.online
{
   import com.dchoc.toolkit.core.debug.DCDebug;
   import flash.events.EventDispatcher;
   import flash.external.ExternalInterface;
   
   public class Browser extends EventDispatcher
   {
       
      
      public function Browser()
      {
         super();
         try
         {
            if(ExternalInterface.available)
            {
               ExternalInterface.addCallback("taskResponse",this.taskResponse);
               DCDebug.trace("ExternalInterface Callback correct");
            }
            else
            {
               DCDebug.trace("ExternalInterface is not available");
            }
         }
         catch(e:Error)
         {
            traceError(e);
         }
      }
      
      public function taskRequest(task:String, data:Object = null) : void
      {
         var paramsJSon:String = null;
         DCDebug.traceCh("JavaScript","--=> Browser.externalTaskRequest(" + task + ")");
         DCDebug.traceChObject("JavaScript",data);
         try
         {
            if(ExternalInterface.available)
            {
               paramsJSon = data == null ? "{}" : JSON.stringify(data);
               ExternalInterface.call("externalTask",task,paramsJSon);
            }
         }
         catch(e:Error)
         {
            traceError(e);
         }
      }
      
      public function taskResponse(task:String, paramsJSon:String = null) : void
      {
         var data:Object = null;
         DCDebug.traceCh("JavaScript","--> Browser.taskResponse: " + task);
         if(task != null)
         {
            data = paramsJSon == null ? {} : JSON.parse(paramsJSon);
            DCDebug.traceChObject("JavaScript",data);
            dispatchEvent(new BrowserEvent("onBrowserResponse",{
               "task":task,
               "data":data
            }));
         }
      }
      
      private function traceError(e:Error) : void
      {
         DCDebug.traceCh("JavaScript","*******************");
         DCDebug.traceCh("JavaScript","***  E R R O R  ***");
         DCDebug.traceCh("JavaScript",e.toString());
         DCDebug.traceCh("JavaScript",e.message);
         DCDebug.traceCh("JavaScript","*******************");
      }
   }
}
