package com.dchoc.toolkit.view.gui.popups
{
   import com.dchoc.toolkit.core.component.DCComponentUI;
   import com.dchoc.toolkit.core.instance.DCInstanceMng;
   import com.dchoc.toolkit.core.view.mng.DCViewMng;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.utils.Dictionary;
   
   public class DCPopupMng extends DCComponentUI
   {
      
      private static const BACKGROUND_COLOR:uint = 0;
      
      private static const BACKGROUND_ALPHA:Number = 0.3;
      
      public static var smIsPopupActive:Boolean = false;
       
      
      protected var mPopups:Dictionary;
      
      protected var mPopupNames:Vector.<String>;
      
      protected var mBackground:Sprite;
      
      protected var mNumPopups:int;
      
      protected var mNumOpenPopups:int;
      
      private var mBackWidth:Number;
      
      private var mBackHeight:Number;
      
      protected var mPopupBeingShown:DCIPopup;
      
      protected var mLastPopup:DCIPopup;
      
      public function DCPopupMng()
      {
         super();
      }
      
      override protected function loadDoStep(step:int) : void
      {
         if(step == 0)
         {
            this.mPopups = new Dictionary();
            this.mPopupNames = new Vector.<String>(0);
         }
      }
      
      override protected function unloadDo() : void
      {
         var popup:DCIPopup = null;
         var i:int = 0;
         if(this.mPopups != null)
         {
            for each(popup in this.mPopups)
            {
               popup.destroy();
            }
            for(i = 0; i < this.mPopupNames.length; )
            {
               delete this.mPopups[this.mPopupNames[i]];
               this.mPopupNames[i] = null;
               i++;
            }
            this.mPopups = null;
            this.mPopupNames = null;
            this.mBackground = null;
            this.mPopupBeingShown = null;
         }
         smIsPopupActive = false;
      }
      
      private function setBackSize(w:Number, h:Number) : void
      {
         this.mBackWidth = w;
         this.mBackHeight = h;
      }
      
      public function addPopup(popup:DCIPopup, popupName:String, replaceIfExists:Boolean = false) : void
      {
         if(this.mPopupNames.indexOf(popupName) == -1)
         {
            this.mPopupNames.push(popupName);
            this.mPopups[popupName] = popup;
         }
         else
         {
            if(!replaceIfExists)
            {
               throw new Error(popupName + " already exist");
            }
            this.mPopups[popupName] = popup;
         }
         this.mNumPopups++;
      }
      
      public function openPopup(popupId:Object, viewMng:DCViewMng = null, showAnim:Boolean = true, showDarkBackground:Boolean = true, closeOpenedPopup:Boolean = true) : Boolean
      {
         var popup:DCIPopup = popupId is String ? this.mPopups[popupId] : DCIPopup(popupId);
         if(viewMng == null)
         {
            viewMng = DCInstanceMng.getInstance().getViewMng();
         }
         var box:DisplayObject = popup.getForm();
         if(!viewMng.contains(box))
         {
            if(showDarkBackground)
            {
               if(this.mBackground == null)
               {
                  this.mBackground = new Sprite();
                  this.drawBackground(DCInstanceMng.getInstance().getApplication().stageGetWidth(),DCInstanceMng.getInstance().getApplication().stageGetHeight());
               }
               this.mBackground.alpha = 1;
               viewMng.addPopup(this.mBackground,this.mNumOpenPopups);
            }
            viewMng.addPopup(box);
            popup.show(showAnim);
            this.mNumOpenPopups++;
            smIsPopupActive = true;
            return true;
         }
         return false;
      }
      
      public function closePopup(popupId:Object, viewMng:DCViewMng = null, instant:Boolean = false) : Boolean
      {
         var box:DisplayObject = null;
         var popup:DCIPopup;
         if((popup = popupId is String ? this.mPopups[popupId] : DCIPopup(popupId)) != null)
         {
            if(viewMng == null)
            {
               viewMng = DCInstanceMng.getInstance().getViewMng();
            }
            box = popup.getForm();
            if(viewMng.contains(box))
            {
               viewMng.removePopup(box);
               popup.close();
               this.mLastPopup = popup;
               this.mPopupBeingShown = null;
               this.mNumOpenPopups--;
               smIsPopupActive = this.mNumOpenPopups > 0;
               if(this.mNumOpenPopups == 0)
               {
                  viewMng.removePopup(this.mBackground);
               }
               else if(this.mBackground != null)
               {
                  viewMng.addPopup(this.mBackground,this.mNumOpenPopups - 1);
               }
               return true;
            }
         }
         return false;
      }
      
      public function destroyPopup(_popup:DCIPopup) : void
      {
         var nameIdx:int = 0;
         var popupName:* = "";
         var found:Boolean = false;
         for(popupName in this.mPopups)
         {
            if(this.mPopups[popupName] == _popup)
            {
               found = true;
               break;
            }
         }
         if(found)
         {
            this.mNumPopups--;
            _popup.destroy();
            delete this.mPopups[popupName];
            nameIdx = this.mPopupNames.indexOf(popupName);
            if(nameIdx != -1)
            {
               this.mPopupNames.splice(nameIdx,1);
            }
         }
      }
      
      override public function onResize(stageWidth:int, stageHeight:int) : void
      {
         var popup:DCComponentUI = null;
         var popupName:String = null;
         this.setBackSize(stageWidth,stageHeight);
         var i:int = 0;
         for each(popupName in this.mPopupNames)
         {
            popup = this.mPopups[popupName];
            if(popup is DCIPopup)
            {
               (popup as DCIPopup).resize();
            }
            i++;
         }
         if(this.mPopupBeingShown != null)
         {
            this.mPopupBeingShown.onResize(stageWidth,stageHeight);
         }
         this.drawBackground(stageWidth,stageHeight);
      }
      
      public function getPopup(popup:*) : DCIPopup
      {
         var auxPopup:DCIPopup = null;
         var returnPopup:* = null;
         if(popup is String)
         {
            returnPopup = this.mPopups[popup];
         }
         else if(popup is DCIPopup)
         {
            if(this.mPopups != null)
            {
               for each(auxPopup in this.mPopups)
               {
                  if(auxPopup == popup)
                  {
                     returnPopup = auxPopup;
                  }
               }
            }
         }
         return returnPopup;
      }
      
      public function getPopupBeingShown() : DCIPopup
      {
         var returnPopup:* = null;
         var auxPopup:DCIPopup = null;
         for each(auxPopup in this.mPopups)
         {
            if(auxPopup.isPopupBeingShown())
            {
               returnPopup = auxPopup;
            }
         }
         return returnPopup;
      }
      
      public function getLastPopup() : DCIPopup
      {
         return this.mLastPopup;
      }
      
      public function deletePopupPointer(popup:String) : void
      {
         var index:int = 0;
         var returnPopup:DCIPopup = null;
         if(popup is String)
         {
            returnPopup = this.mPopups[popup];
            if(returnPopup != null)
            {
               delete this.mPopups[popup];
               index = this.mPopupNames.indexOf(popup);
               if(index != -1)
               {
                  this.mPopupNames.splice(index,1);
               }
            }
         }
      }
      
      protected function drawBackground(w:Number, h:Number) : void
      {
         var colors:Array = null;
         var alphas:Array = null;
         var ratios:Array = null;
         var matrix:Matrix = null;
         if(this.mBackground != null)
         {
            this.mBackground.graphics.clear();
            colors = [0,0];
            alphas = [0.1,0.9];
            ratios = [0,255];
            (matrix = new Matrix()).createGradientBox(w,h);
            this.mBackground.graphics.beginGradientFill("radial",colors,alphas,ratios,matrix);
            this.mBackground.graphics.drawRect(0,0,w,h);
            this.mBackground.graphics.endFill();
         }
      }
   }
}
