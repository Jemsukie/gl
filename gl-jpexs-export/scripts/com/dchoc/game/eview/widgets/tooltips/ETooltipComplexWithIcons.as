package com.dchoc.game.eview.widgets.tooltips
{
   import com.dchoc.game.eview.ViewFactory;
   import com.dchoc.game.eview.popups.hangar.EUnitItemView;
   import com.dchoc.game.eview.widgets.smallStructures.IconBar;
   import com.dchoc.game.eview.widgets.smallStructures.IconBarTime;
   import com.dchoc.game.eview.widgets.smallStructures.ResourceFillBar;
   import esparragon.display.ESprite;
   import esparragon.display.ESpriteContainer;
   import esparragon.display.ETextField;
   import esparragon.layout.ELayoutArea;
   import esparragon.layout.ELayoutAreaFactory;
   import esparragon.widgets.EButton;
   
   public class ETooltipComplexWithIcons extends ETooltipComplex
   {
       
      
      public function ETooltipComplexWithIcons()
      {
         super();
         mType = 2;
      }
      
      override protected function buildContent(info:ETooltipInfo, viewFactory:ViewFactory, skin:String) : void
      {
         var result:ESprite = null;
         var element:Object = null;
         var index:int = 0;
         var block:ESpriteContainer = null;
         var distribution:String = null;
         var accumulatedHMargin:int = 0;
         var i:int = 0;
         var blockElement:Object = null;
         var child:ESprite = null;
         var elements:Array = info.getElements();
         var accumulatedVMargin:int = 0;
         for each(element in elements)
         {
            if(element is Array)
            {
               block = viewFactory.getESpriteContainer();
               distribution = String(element[0]);
               accumulatedHMargin = 0;
               for(i = 1; i < element.length; )
               {
                  blockElement = element[i];
                  result = this.buildSingleElement(blockElement,viewFactory,skin);
                  if(distribution == "row")
                  {
                     result.logicLeft = block.getLogicWidth() + accumulatedHMargin;
                     accumulatedHMargin += info.blockHorizontalPadding;
                  }
                  else if(distribution == "column")
                  {
                     result.logicTop = block.getLogicHeight();
                  }
                  else if(distribution == "ship_column")
                  {
                     result.logicTop = block.getLogicHeight() - 10;
                  }
                  block.eAddChild(result);
                  block.setContent(result.name,result);
                  i++;
               }
               result = block;
            }
            else
            {
               result = this.buildSingleElement(element,viewFactory,skin);
            }
            mMaxWidth = Math.max(mMaxWidth,result.getLogicWidth());
            accumulatedVMargin += info.blockVerticalPadding;
            result.logicTop = mContent.getLogicHeight() + accumulatedVMargin;
            mContent.eAddChild(result);
            mContent.setContent(result.name,result);
         }
         for(index = 0; index < mContent.numChildren; )
         {
            (child = mContent.eGetChildAt(index)).logicLeft = (mMaxWidth - child.getLogicWidth()) / 2 + 12;
            index++;
         }
      }
      
      private function buildSingleElement(element:Object, viewFactory:ViewFactory, skin:String) : ESprite
      {
         var unitView:EUnitItemView = null;
         var scale:Number = NaN;
         var layout:ELayoutArea = null;
         var result:ESprite = null;
         var textField:ETextField = null;
         var resourceFillBar:ResourceFillBar = null;
         var iconFillBar:IconBar = null;
         var textIcon:ESpriteContainer = null;
         var button:EButton = null;
         switch(element.type)
         {
            case "text":
               textField = createTextfield(element.text,viewFactory,skin,"left",element.propSku);
               mMaxWidth = Math.max(mMaxWidth,textField.width);
               result = textField;
               break;
            case "iconText":
               result = textIcon = viewFactory.getContentIconWithTextHorizontal("IconTextXS",element.resource,element.text,null,element.propSku,false);
               break;
            case "iconTwoTexts":
               result = textIcon = viewFactory.getContentIconWithTwoTextsHorizontal("IconTwoTextsXS",element.resource,element.topText,element.bottomText,null,element.topPropSku,element.bottomPropSku,false);
               break;
            case "fillbarResources":
               (resourceFillBar = new ResourceFillBar(viewFactory,skin)).setup(element.maxValue,element.value,element.resource,this.getColorFromResourceType(element.resource),null);
               result = resourceFillBar;
               break;
            case "fillbarIcon":
               (iconFillBar = new IconBar()).setup(element.layoutName,element.value,element.maxValue,this.getColorFromResourceType(element.resource),element.resource);
               iconFillBar.updateTopText(element.topText);
               iconFillBar.updateText(element.bottomText);
               iconFillBar.logicUpdate(0);
               result = iconFillBar;
               break;
            case "fillbarTime":
               (iconFillBar = new IconBarTime(element.updateFunction,element.updateParams)).setup("IconBarXS",0,100,this.getColorFromResourceType(element.resource),element.resource);
               iconFillBar.logicUpdate(0);
               result = iconFillBar;
               break;
            case "button":
               (button = viewFactory.getButtonSocial(null,null,element.text)).eAddEventListener("click",element.callback);
               result = button;
               break;
            case "iconUnit":
               (unitView = new EUnitItemView()).build(false,false);
               unitView.fillDataFromParams(element.sku,element.def,element.amount);
               scale = element.size / unitView.getLogicWidth();
               (layout = ELayoutAreaFactory.createLayoutArea(unitView.getLogicWidth() + element.customPadding,unitView.getLogicWidth())).isSetPositionEnabled = false;
               unitView.setLayoutArea(layout,true);
               unitView.scaleLogicX = scale;
               unitView.scaleLogicY = scale;
               result = unitView;
         }
         return result;
      }
      
      private function getColorFromResourceType(type:String) : String
      {
         var returnValue:String = null;
         switch(type)
         {
            case "icon_coin":
            case "icon_coins":
            case "icon_bag_coins":
               break;
            case "icon_mineral":
            case "icon_minerals":
            case "icon_bag_minerals":
               return "color_minerals";
            case "icon_score":
            case "icon_score_level":
               return "color_score";
            case "icon_hangar":
               return "color_capacity";
            case "icon_clock":
               return "color_time";
            default:
               returnValue = "color_time";
               if(type.indexOf("refinery") > -1)
               {
                  return "color_minerals";
               }
               return returnValue;
         }
         return "color_coins";
      }
   }
}
