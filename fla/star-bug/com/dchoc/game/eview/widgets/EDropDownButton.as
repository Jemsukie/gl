package com.dchoc.game.eview.widgets
{
   import esparragon.display.ESpriteContainer;
   import esparragon.events.EEvent;
   import esparragon.widgets.EButton;
   
   public class EDropDownButton extends ESpriteContainer
   {
      
      protected static const BUTTON:String = "button";
      
      protected static const DROPDOWN:String = "dropdown";
       
      
      protected var mOnClickFnc:Function;
      
      public function EDropDownButton(button:EButton, dropdown:EDropDownSprite, onClickFnc:Function = null)
      {
         super();
         this.eAddChild(dropdown);
         this.eAddChild(button);
         this.setContent("button",button);
         this.setContent("dropdown",dropdown);
         dropdown.close(false);
         this.mOnClickFnc = onClickFnc;
         button.eAddEventListener("click",this.onButtonClick);
      }
      
      public function getDropDown() : EDropDownSprite
      {
         return getContent("dropdown") as EDropDownSprite;
      }
      
      public function getButton() : EButton
      {
         return getContentAsEButton("button");
      }
      
      private function onButtonClick(evt:EEvent) : void
      {
         var dropdown:EDropDownSprite = null;
         if(this.mOnClickFnc != null)
         {
            this.mOnClickFnc(evt);
         }
         else
         {
            dropdown = this.getDropDown();
            if(this.isOpen())
            {
               dropdown.close();
            }
            else
            {
               dropdown.open();
            }
         }
      }
      
      public function close(animation:Boolean = false) : void
      {
         this.getDropDown().close(animation);
      }
      
      public function open(animation:Boolean = false) : void
      {
         this.getDropDown().open(animation);
      }
      
      public function isOpen() : Boolean
      {
         return this.getDropDown().isOpen();
      }
      
      override public function set mouseEnabled(enabled:Boolean) : void
      {
         super.mouseEnabled = enabled;
         this.getButton().mouseEnabled = enabled;
      }
      
      override public function setIsEnabled(value:Boolean) : void
      {
         super.setIsEnabled(value);
         this.getButton().setIsEnabled(value);
      }
   }
}
