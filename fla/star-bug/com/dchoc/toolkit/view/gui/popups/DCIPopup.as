package com.dchoc.toolkit.view.gui.popups
{
   import flash.display.DisplayObjectContainer;
   
   public interface DCIPopup extends DCIContent
   {
       
      
      function destroy() : void;
      
      function lockPopup(param1:String = null) : void;
      
      function unlockPopup() : void;
      
      function getSkinSku() : String;
      
      function getPopupType() : String;
      
      function setPopupType(param1:String) : void;
      
      function isPopupBeingShown() : Boolean;
      
      function setIsBeingShown(param1:Boolean) : void;
      
      function show(param1:Boolean = true) : void;
      
      function notifyPopupMngClose(param1:Object) : void;
      
      function close() : void;
      
      function notify(param1:Object) : Boolean;
      
      function onResize(param1:int, param2:int) : void;
      
      function resize() : void;
      
      function getForm() : DisplayObjectContainer;
      
      function setX(param1:Number) : void;
      
      function setY(param1:Number) : void;
      
      function startCloseEffect() : void;
      
      function configureEffects(param1:int, param2:int) : void;
      
      function isStackable() : Boolean;
      
      function setIsStackable(param1:Boolean) : void;
      
      function setShowAnim(param1:Boolean) : void;
      
      function getShowAnim() : Boolean;
      
      function setShowDarkBackground(param1:Boolean) : void;
      
      function getShowDarkBackground() : Boolean;
      
      function getEvent() : Object;
      
      function setEvent(param1:Object) : void;
      
      function refresh() : void;
      
      function logicUpdate(param1:int) : void;
   }
}
