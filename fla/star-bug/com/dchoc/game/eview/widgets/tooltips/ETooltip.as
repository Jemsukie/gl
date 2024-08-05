package com.dchoc.game.eview.widgets.tooltips
{
   import com.dchoc.game.core.instance.InstanceMng;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.layout.ELayoutAreaFactory;
   
   public class ETooltip extends ESpriteContainer
   {
      
      public static const MAX_WIDTH:int = 200;
      
      public static const MARGIN:int = 12;
       
      
      protected var mType:int;
      
      protected var mLayoutAreaFactory:ELayoutAreaFactory;
      
      public function ETooltip()
      {
         super();
      }
      
      public function loadLayout(factoryName:String) : void
      {
         this.mLayoutAreaFactory = InstanceMng.getViewFactory().getLayoutAreaFactory(factoryName);
      }
      
      public function setArrowVisible(value:Boolean, esprite:ESprite) : void
      {
      }
   }
}
