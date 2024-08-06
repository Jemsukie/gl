package com.dchoc.game.view.facade
{
   public interface CursorFacade
   {
       
      
      function getCursorX() : Number;
      
      function getCursorY() : Number;
      
      function setCursorId(param1:int) : void;
      
      function getCursorId() : int;
      
      function setTextInCursor(param1:int, param2:String) : void;
      
      function nameToId(param1:String, param2:int = -1) : int;
   }
}
