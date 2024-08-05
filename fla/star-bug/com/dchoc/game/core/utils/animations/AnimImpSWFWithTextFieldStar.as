package com.dchoc.game.core.utils.animations
{
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.utils.animations.DCItemAnimatedInterface;
   import flash.display.DisplayObjectContainer;
   import flash.text.TextField;
   
   public class AnimImpSWFWithTextFieldStar extends AnimImpSWFStar
   {
       
      
      private var mAttributeSku:String;
      
      public function AnimImpSWFWithTextFieldStar(id:int, layerId:int, fileSku:String, animSku:String, attributeSku:String, calculatePosition:Boolean = true, needsZSorting:Boolean = false)
      {
         super(id,layerId,fileSku,animSku,null,calculatePosition,needsZSorting);
         this.mAttributeSku = attributeSku;
      }
      
      override protected function itemProcessAnim(layerId:int, item:DCItemAnimatedInterface, anim:DCDisplayObject) : void
      {
         var d:DisplayObjectContainer = DisplayObjectContainer(anim.getDisplayObject());
         var textField:TextField = TextField(d.getChildByName("text_info_01"));
         DCTextMng.setText(textField,item.viewLayersGetAttribute(layerId,this.mAttributeSku));
      }
   }
}
