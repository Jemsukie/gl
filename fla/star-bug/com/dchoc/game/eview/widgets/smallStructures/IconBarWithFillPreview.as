package com.dchoc.game.eview.widgets.smallStructures
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.ViewFactory;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EFillBar;
   
   public class IconBarWithFillPreview extends IconBar
   {
      
      protected static const BAR_FILL_PREVIEW_ID:String = "fillPreview";
       
      
      protected var mPreviewBarCurrent:Number;
      
      public function IconBarWithFillPreview()
      {
         super();
         this.mPreviewBarCurrent = 0;
      }
      
      override protected function updateBar() : void
      {
         var viewFactory:ViewFactory = null;
         var layoutAreaFactory:ELayoutAreaFactory = null;
         var area:ELayoutArea = null;
         var fillBar:EFillBar = null;
         var mustCreate:* = getContent("barFill") == null;
         super.updateBar();
         if(mustCreate)
         {
            viewFactory = InstanceMng.getViewFactory();
            layoutAreaFactory = getLayoutAreaFactory();
            area = layoutAreaFactory.getArea("bar");
            (fillBar = viewFactory.createFillBar(1,area.width - 8,area.height - 8,mBarMax,getBarFillColor())).applySkinProp(InstanceMng.getSkinsMng().getCurrentSkinSku(),"color_preview");
            setContent("fillPreview",fillBar);
            eAddChildAt(fillBar,1);
            fillBar.logicLeft = area.x + 4;
            fillBar.logicTop = area.y + 4;
            fillBar.setValue(this.mPreviewBarCurrent);
         }
         else
         {
            (getContent("fillPreview") as EFillBar).setValue(this.mPreviewBarCurrent);
         }
      }
      
      public function setPreviewBarValue(value:Number) : void
      {
         if(this.mPreviewBarCurrent != value)
         {
            this.mPreviewBarCurrent = value;
            mBarNeedsToBeUpdated = true;
         }
      }
   }
}
