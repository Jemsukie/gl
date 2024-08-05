package esparragon.layout.behaviors
{
   import esparragon.display.ESprite;
   import esparragon.layout.ELayoutArea;
   
   public class ELayoutBehaviorCenterAndScale extends ELayoutBehavior
   {
       
      
      public function ELayoutBehaviorCenterAndScale()
      {
         super();
      }
      
      override public function perform(content:ESprite, layoutArea:ELayoutArea) : void
      {
         var coefOrig:Number = NaN;
         var contentWidth:* = 0;
         var contentHeight:* = 0;
         var scaleX:Number = NaN;
         var scaleY:Number = NaN;
         var coef:Number = NaN;
         var newHeight:Number = NaN;
         var newWidth:Number = NaN;
         var scaleLogicX:Number = content.scaleLogicX;
         var scaleLogicY:Number = content.scaleLogicY;
         content.scaleX = 1;
         content.scaleY = 1;
         var contentWidthOrig:int = content.width;
         var contentHeightOrig:int = content.height;
         if(contentWidthOrig != 0 && contentHeightOrig != 0)
         {
            coefOrig = contentWidthOrig / contentHeightOrig;
            contentWidth = contentWidthOrig;
            contentHeight = contentHeightOrig;
            if(contentWidthOrig > layoutArea.width)
            {
               contentWidth = layoutArea.width;
            }
            if(contentHeightOrig > layoutArea.height)
            {
               contentHeight = layoutArea.height;
            }
            scaleX = contentWidth / contentWidthOrig;
            scaleY = contentHeight / contentHeightOrig;
            if((coef = contentWidth / contentHeight) < coefOrig)
            {
               scaleY = (newHeight = contentWidth / coefOrig) / contentHeightOrig;
            }
            else if(coef > coefOrig)
            {
               scaleX = (newWidth = contentHeight * coefOrig) / contentWidthOrig;
            }
            content.setScaleAreaXY(scaleX,scaleY);
            if(layoutArea.isSetPositionEnabled)
            {
               content.logicX = layoutArea.x + layoutArea.width / 2;
               content.logicY = layoutArea.y + layoutArea.height / 2;
            }
            else if(content.pivotLogicX == 0 && content.pivotLogicY == 0)
            {
               content.logicX += layoutArea.width / 2;
               content.logicY += layoutArea.height / 2;
            }
            content.setPivotLogicXY(0.5,0.5);
            content.scaleLogicX = scaleLogicX;
            content.scaleLogicY = scaleLogicY;
         }
      }
   }
}
