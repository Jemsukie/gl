package com.dchoc.game.eview.behaviors
{
   import com.dchoc.game.eview.behaviors.bet.BehaviorSelectBet;
   import esparragon.behaviors.EBehavior;
   import esparragon.behaviors.EBehaviorApplySkinProp;
   import esparragon.behaviors.EBehaviorMoveY;
   import esparragon.behaviors.EBehaviorResetCursor;
   import esparragon.behaviors.EBehaviorRollbackColor;
   import esparragon.behaviors.EBehaviorSetColor;
   import esparragon.behaviors.EBehaviorSetCursorFinguer;
   import esparragon.behaviors.EBehaviorUnapplySkinProp;
   import esparragon.behaviors.EBehaviorsMng;
   
   public class BehaviorsMng extends EBehaviorsMng
   {
      
      public static const MOUSE_OVER_GRAY:String = "MouseOverGray";
      
      public static const MOUSE_OVER_SET_CURSOR_FINGER:String = "MouseOverSetCursorFinger";
      
      public static const MOUSE_OUT_RESET_COLOR:String = "MouseOutResetColor";
      
      public static const MOUSE_OUT_RESET_CURSOR:String = "MouseOutResetCursor";
      
      public static const MOUSE_OUT_SIMULATED:String = "MouseOutSimulated";
      
      public static const MOUSE_DOWN:String = "MouseDown";
      
      public static const MOUSE_UP:String = "MouseUp";
      
      public static const MOUSE_UP_MOVE_Y:String = "MouseUpMoveY";
      
      public static const MOUSE_DOWN_MOVE_Y:String = "MouseDownMoveY";
      
      public static const MOUSE_OVER_RED:String = "MouseOverRed";
      
      public static const MOUSE_OVER_BUTTON:String = "MouseOverButton";
      
      public static const MOUSE_OUT_BUTTON:String = "MouseOutButton";
      
      public static const MOUSE_OVER_SKIN_BUTTON:String = "MouseOverSkinButton";
      
      public static const MOUSE_OUT_SKIN_BUTTON:String = "MouseOutSkinButton";
      
      public static const SELECT_BET:String = "SelectBet";
      
      public static const START_NOW_UNLOCK:String = "StartNowUnlock";
      
      public static const CLOSE_WELCOME_POPUP:String = "CloseWelcomePopup";
      
      public static const FADE_OUT:String = "FadeOut";
      
      public static const CHECK:String = "CHECK";
      
      public static const MOUSE_OVER_UNDERLINE:String = "MouseOverUnderline";
      
      public static const MOUSE_OUT_UNDERLINE:String = "MouseOutUnderline";
       
      
      public function BehaviorsMng()
      {
         super();
      }
      
      protected function createBehavior(sku:String) : EBehavior
      {
         var returnValue:EBehavior = null;
         switch(sku)
         {
            case "MouseOverGray":
               returnValue = new EBehaviorSetColor(16777215,0.3);
               break;
            case "MouseOutResetColor":
               returnValue = new EBehaviorRollbackColor();
               break;
            case "MouseOverSetCursorFinger":
               returnValue = new EBehaviorSetCursorFinguer();
               break;
            case "MouseOutResetCursor":
               returnValue = new EBehaviorResetCursor();
               break;
            case "Disable":
               returnValue = new BehaviorDisableButton(this.getMouseBehavior("Disable_basic"),this.getMouseBehavior("MouseOutSkinButton"));
               break;
            case "Enable":
               returnValue = new EBehaviorUnapplySkinProp("disabled");
               break;
            case "Disable_basic":
               returnValue = new EBehaviorApplySkinProp("disabled");
               break;
            case "MouseDown":
               returnValue = new BehaviorMouseDown(this.getMouseBehavior("MouseDownMoveY"),this.getMouseBehavior("MouseUp"));
               break;
            case "MouseUp":
               returnValue = new BehaviorMouseUp(this.getMouseBehavior("MouseUpMoveY"));
               break;
            case "MouseUpMoveY":
               returnValue = new EBehaviorMoveY(-2);
               break;
            case "MouseDownMoveY":
               returnValue = new EBehaviorMoveY(2);
               break;
            case "MouseOverRed":
               returnValue = new EBehaviorSetColor(10694171,0.5);
               break;
            case "CHECK":
               returnValue = new BehaviorCheck();
               break;
            case "MouseOverButton":
               returnValue = new BehaviorMouseOverButton(this.getMouseBehavior("MouseDown"),this.getMouseBehavior("MouseOverSkinButton"));
               break;
            case "MouseOutButton":
               returnValue = new BehaviorMouseOutButton(this.getMouseBehavior("MouseUp"),this.getMouseBehavior("MouseOutSkinButton"));
               break;
            case "MouseOverSkinButton":
               returnValue = new EBehaviorApplySkinProp("mouse_over_button");
               break;
            case "MouseOutSkinButton":
               returnValue = new EBehaviorUnapplySkinProp("mouse_over_button");
               break;
            case "MouseOverUnderline":
               returnValue = new BehaviorUnderline(true);
               break;
            case "MouseOutUnderline":
               returnValue = new BehaviorUnderline(false);
               break;
            case "MouseOutSimulated":
               returnValue = new BehaviorDisableSimulateMouseOut();
         }
         return returnValue;
      }
      
      public function getMouseBehavior(sku:String) : EBehavior
      {
         var returnValue:EBehavior = null;
         if(!sharedIsBehaviorBySku(sku))
         {
            returnValue = this.createBehavior(sku);
            sharedAddBehavior(sku,returnValue);
         }
         else
         {
            returnValue = sharedGetBehavior(sku);
         }
         return returnValue;
      }
      
      public function getBehaviorSelectBet(sku:String) : EBehavior
      {
         return new BehaviorSelectBet(sku);
      }
      
      public function getBehaviorFadeTo(fadeTo:Number, timeInMilliseconds:int) : BehaviorFadeTo
      {
         return new BehaviorFadeTo(fadeTo,timeInMilliseconds);
      }
      
      public function getBehaviorPropertyBlink(propSku:String) : BehaviorPropertyBlink
      {
         return new BehaviorPropertyBlink(propSku);
      }
   }
}
