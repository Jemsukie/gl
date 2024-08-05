package com.dchoc.game.model.friends
{
   public interface IFriendHelpBox
   {
       
      
      function hasEnded() : Boolean;
      
      function hasStarted() : Boolean;
      
      function addToDisplay() : void;
      
      function removeFromDisplay() : void;
      
      function startMoving() : void;
      
      function logicUpdate(param1:int) : void;
      
      function setVisible(param1:Boolean) : void;
      
      function setItemSid(param1:String) : void;
      
      function setX(param1:Number) : void;
      
      function setY(param1:Number) : void;
      
      function uiSetIsEnabled(param1:Boolean) : void;
      
      function onAcceptThis() : void;
   }
}
