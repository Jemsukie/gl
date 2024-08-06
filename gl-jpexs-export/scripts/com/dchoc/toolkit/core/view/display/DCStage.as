package com.dchoc.toolkit.core.view.display
{
   import com.dchoc.toolkit.core.debug.DCDebug;
   import flash.display.DisplayObject;
   import flash.display.Stage;
   
   public class DCStage extends DCDisplayObject
   {
      
      public static const SCALE_MODE_NO_SCALE:String = "noScale";
      
      public static const SCALE_MODE_EXACT_FIT:String = "exactFit";
      
      public static const SCALE_MODE_NO_BORDER:String = "noBorder";
      
      public static const SCALE_MODE_SHOW_ALL:String = "showAll";
      
      public static const ALIGN_TOP:String = "T";
      
      public static const ALIGN_TOP_RIGHT:String = "TR";
      
      public static const ALIGN_RIGHT:String = "R";
      
      public static const ALIGN_BOTTOM_RIGHT:String = "BR";
      
      public static const ALIGN_BOTTOM:String = "B";
      
      public static const ALIGN_BOTTOM_LEFT:String = "BL";
      
      public static const ALIGN_LEFT:String = "L";
      
      public static const ALIGN_TOP_LEFT:String = "TL";
       
      
      private var mStage:Stage;
      
      public function DCStage(stage:Stage)
      {
         super();
         this.mStage = stage;
      }
      
      override public function getDisplayObjectContent() : DisplayObject
      {
         return this.mStage;
      }
      
      override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         if(this.mStage != null)
         {
            this.mStage.addEventListener(type,listener,useCapture,priority,useWeakReference);
         }
      }
      
      override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         if(this.mStage != null)
         {
            this.mStage.removeEventListener(type,listener,useCapture);
         }
      }
      
      public function getImplementation() : Stage
      {
         return this.mStage;
      }
      
      public function setScaleMode(mode:String) : void
      {
         this.mStage.scaleMode = mode;
      }
      
      public function setAlign(mode:String) : void
      {
         this.mStage.align = mode;
      }
      
      override public function addChild(o:DisplayObject) : DisplayObject
      {
         var returnValue:DisplayObject = null;
         if(o != null)
         {
            returnValue = this.mStage.addChild(o);
         }
         return returnValue;
      }
      
      override public function removeChild(o:DisplayObject) : DisplayObject
      {
         var returnValue:DisplayObject = null;
         if(o != null)
         {
            if(o.parent == this.mStage)
            {
               returnValue = this.mStage.removeChild(o);
            }
         }
         return returnValue;
      }
      
      public function getStageWidth() : int
      {
         return this.mStage.stageWidth;
      }
      
      public function getStageHeight() : int
      {
         return this.mStage.stageHeight;
      }
      
      public function getDisplayState() : String
      {
         return this.mStage.displayState;
      }
      
      public function setDisplayState(newState:String) : void
      {
         try
         {
            this.mStage.displayState = newState;
         }
         catch(e:SecurityError)
         {
            DCDebug.traceCh("TOOLKIT","Fullscreen mode not allowed: " + e.message);
         }
      }
      
      public function getMouseX() : Number
      {
         return this.mStage.mouseX;
      }
      
      public function getMouseY() : Number
      {
         return this.mStage.mouseY;
      }
      
      override public function setChildIndex(o:DisplayObject, index:int) : void
      {
         this.mStage.setChildIndex(o,index);
      }
   }
}
