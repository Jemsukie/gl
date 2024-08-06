package com.dchoc.game.eview.widgets
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import esparragon.display.ESpriteContainer;
   import esparragon.layout.ELayoutArea;
   import esparragon.widgets.EFillBar;
   
   public class EFillBarSegmented extends ESpriteContainer
   {
      
      private static const MARGIN:int = 4;
       
      
      private var mFillBar:EFillBar;
      
      public function EFillBarSegmented()
      {
         super();
      }
      
      public function build(area:ELayoutArea, maxValue:Number = 0, fillColor:String = null, segments:int = 0) : void
      {
         var segmentsSP:ESpriteContainer = null;
         var viewFactory:ViewFactory;
         var fillbar:EFillBar = (viewFactory = InstanceMng.getViewFactory()).createFillBar(0,area.width,area.height,0);
         setContent("background",fillbar);
         eAddChild(fillbar);
         fillbar = viewFactory.createFillBar(1,area.width - 4,area.height - 4,maxValue,fillColor);
         setContent("fill",fillbar);
         eAddChild(fillbar);
         fillbar.logicLeft += 4 / 2;
         fillbar.logicTop += 4 / 2;
         this.mFillBar = fillbar;
         if(segments > 1)
         {
            segmentsSP = viewFactory.createFillbarSegments(getContent("background") as EFillBar,segments);
            setContent("segments",segmentsSP);
            eAddChild(segmentsSP);
         }
         logicLeft = area.x;
         logicTop = area.y;
      }
      
      public function setValue(value:Number) : void
      {
         this.mFillBar.setValue(value);
      }
      
      public function setMinValue(value:Number) : void
      {
         this.mFillBar.setMinValue(value);
      }
      
      public function setMaxValue(value:Number) : void
      {
         this.mFillBar.setMaxValue(value);
      }
      
      public function getCurrentValue() : Number
      {
         return this.mFillBar.getCurrentValue();
      }
      
      public function setValueAnimated(value:Number, time:Number = 1000) : void
      {
         this.mFillBar.setValueAnimated(this.mFillBar.getCurrentValue(),value,time);
      }
   }
}
