package com.dchoc.game.eview.widgets
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import esparragon.display.EGraphics;
   import esparragon.display.EMovieClip;
   import esparragon.display.ESpriteContainer;
   import esparragon.layout.ELayoutAreaFactory;
   
   public class ELoadingScreen extends ESpriteContainer
   {
       
      
      private var mViewFactory:ViewFactory;
      
      public function ELoadingScreen()
      {
         super();
         this.mViewFactory = InstanceMng.getViewFactory();
      }
      
      public function setup() : void
      {
         var bkg:EGraphics = this.mViewFactory.getGraphics();
         eAddChild(bkg);
         setContent("bkg",bkg);
         var layoutFactory:ELayoutAreaFactory = this.mViewFactory.getLayoutAreaFactory("LayoutLoadingScreen");
         var spiral:EMovieClip = this.mViewFactory.getEMovieClip("spiral",null,false,layoutFactory.getArea("cbox_spiral_logo"));
         eAddChild(spiral);
         setContent("spiral",spiral);
      }
      
      public function drawBackground(w:Number, h:Number) : void
      {
         var bkg:EGraphics = getContent("bkg") as EGraphics;
         bkg.drawRect(w,h,0);
         bkg.logicLeft = -w / 2;
         bkg.logicTop = -h / 2;
      }
   }
}
