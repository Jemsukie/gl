package com.dchoc.game.eview.widgets.smallStructures
{
   import com.dchoc.game.core.instance.InstanceMng;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   
   public class IconBarHud extends IconBar
   {
      
      protected static const BUTTON:String = "btn";
       
      
      protected var mCallback:Function;
      
      public function IconBarHud()
      {
         super();
      }
      
      public function setupButton(buttonResourceID:String, callbackFunction:Function) : void
      {
         var layoutAreaFactory:ELayoutAreaFactory = getLayoutAreaFactory();
         var button:EButton = InstanceMng.getViewFactory().getButtonImage(buttonResourceID,null,layoutAreaFactory.getArea("btn"));
         setContent("btn",button);
         eAddChild(button);
         this.setCallback(callbackFunction);
      }
      
      private function setCallback(callbackFunction:Function) : void
      {
         this.mCallback = callbackFunction;
         if(this.mCallback != null)
         {
            this.eAddEventListener("click",this.mCallback);
         }
      }
      
      override protected function extendedDestroy() : void
      {
         super.extendedDestroy();
         if(this.mCallback != null)
         {
            this.mCallback = null;
         }
      }
   }
}
