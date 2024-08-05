package com.dchoc.toolkit.utils.animations
{
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.core.component.DCComponent;
   import flash.utils.Dictionary;
   
   public class DCAnimMng extends DCComponent
   {
      
      public static const ANIM_DEFAULT_ID:int = -3;
      
      public static const ANIM_KEEP_ID:int = -2;
      
      public static const ANIM_EMPTY_ID:int = -1;
       
      
      protected var mTypesCatalog:Vector.<DCAnimType>;
      
      protected var mImpCatalog:Vector.<DCAnimImp>;
      
      protected var mTypeToImp:Dictionary;
      
      public function DCAnimMng()
      {
         super();
      }
      
      override protected function loadDoStep(step:int) : void
      {
         if(step == 0)
         {
            this.mTypesCatalog = new Vector.<DCAnimType>(this.typesCatalogGetCount());
            this.mImpCatalog = new Vector.<DCAnimImp>(this.impCatalogGetCount());
            this.mTypeToImp = new Dictionary(false);
         }
      }
      
      override protected function unloadDo() : void
      {
         var animType:DCAnimType = null;
         var animImp:DCAnimImp = null;
         for each(animType in this.mTypesCatalog)
         {
            if(animType != null)
            {
               animType.unload();
            }
         }
         for each(animImp in this.mImpCatalog)
         {
            if(animImp != null)
            {
               animImp.unload();
            }
         }
         this.mTypesCatalog = null;
         this.mImpCatalog = null;
         this.mTypeToImp = null;
      }
      
      override protected function buildDoAsyncStep(step:int) : void
      {
         if(step == 0)
         {
            this.typesCatalogPopulate();
            this.impCatalogPopulate();
            this.typeToImpPopulate();
         }
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
      }
      
      protected function typesCatalogGetCount() : int
      {
         return 1;
      }
      
      protected function typesCatalogPopulate() : void
      {
      }
      
      protected function impCatalogGetCount() : int
      {
         return 1;
      }
      
      protected function impCatalogPopulate() : void
      {
      }
      
      public function impCatalogGet(id:int) : DCAnimImp
      {
         return this.mImpCatalog[id];
      }
      
      protected function typeToImpPopulate() : void
      {
      }
      
      protected function typeToImpSet(typeId:int, impId:int) : void
      {
         this.mTypeToImp[typeId] = impId;
      }
      
      private function itemReleaseAnimFromImp(item:DCItemAnimatedInterface, i:int, impCurrent:DCAnimImp) : void
      {
         impCurrent.itemRemoveFromStage(i,item);
         impCurrent.animRelease(item.viewLayersAnimGet(i));
         item.viewLayersAnimSet(i,null);
         item.viewLayersImpCurrentSet(i,-1);
      }
      
      public function itemReleaseAnim(item:DCItemAnimatedInterface, i:int) : void
      {
         var impCurrent:DCAnimImp = null;
         var impCurrentId:int;
         if((impCurrentId = item.viewLayersImpCurrentGet(i)) > -1)
         {
            impCurrent = this.mImpCatalog[impCurrentId];
            this.itemReleaseAnimFromImp(item,i,impCurrent);
         }
      }
      
      public function itemCheckAnims(item:DCItemAnimatedInterface, i:int, dt:int, impNeededId:int = -3) : void
      {
         var wio:WorldItemObject = null;
         var cond:Boolean = false;
         var impCurrent:DCAnimImp = null;
         var impNeeded:DCAnimImp = null;
         var typeRequired:DCAnimType = null;
         var typeRequiredId:int = item.viewLayersTypeRequiredGet(i);
         var typeCurrentId:int = item.viewLayersTypeCurrentGet(i);
         var impCurrentId:int = item.viewLayersImpCurrentGet(i);
         if(impNeededId == -3)
         {
            impNeededId = -1;
            if(typeRequiredId > -1)
            {
               if((impNeededId = (typeRequired = this.mTypesCatalog[typeRequiredId]).getImpId(item,i)) == -2)
               {
                  impNeededId = impCurrentId;
               }
               else if(impNeededId == -1)
               {
                  impNeededId = int(this.mTypeToImp[typeRequiredId]);
               }
            }
         }
         if(typeRequiredId != typeCurrentId || impCurrentId != impNeededId)
         {
            if(impCurrentId > -1)
            {
               impCurrent = this.mImpCatalog[impCurrentId];
               this.itemReleaseAnimFromImp(item,i,impCurrent);
            }
            if(impNeededId == -1)
            {
               item.viewLayersTypeCurrentSet(i,-1);
            }
            else if((impNeeded = this.mImpCatalog[impNeededId]) != null && impNeeded.itemIsAnimReady(item))
            {
               wio = WorldItemObject(item);
               if(!(cond = i == 3 && wio.mState.mStateId == 11 && (wio.isBeingMoved() || wio.isFlatBed())))
               {
                  item.viewLayersAnimSet(i,impNeeded.itemGetAnim(item));
                  item.viewLayersTypeCurrentSet(i,typeRequiredId);
                  item.viewLayersImpCurrentSet(i,impNeededId);
                  if(item.viewLayersIsAllowedToBeDraw(i))
                  {
                     impNeeded.itemAddToStage(i,item);
                     item.setLayerDirty(i,false);
                     item.viewLayersCheckFilters(i);
                  }
               }
            }
         }
         else
         {
            item.setLayerDirty(i,false);
            if(impNeededId > -1)
            {
               this.mImpCatalog[impNeededId].logicUpdate(item,i,dt);
            }
         }
      }
      
      private function itemGetImp(item:DCItemAnimatedInterface, layerId:int) : DCAnimImp
      {
         var typeRequiredId:int = 0;
         var typeRequired:DCAnimType = null;
         var impNeededId:int;
         if((impNeededId = item.viewGetImpId(layerId)) == -3)
         {
            typeRequiredId = item.viewLayersTypeRequiredGet(layerId);
            if(typeRequiredId > -1)
            {
               if((impNeededId = (typeRequired = this.mTypesCatalog[typeRequiredId]).getImpId(item,layerId)) == -2)
               {
                  impNeededId = item.viewLayersImpCurrentGet(layerId);
               }
               else if(impNeededId == -1)
               {
                  impNeededId = int(this.mTypeToImp[typeRequiredId]);
               }
            }
         }
         var returnValue:DCAnimImp = null;
         if(impNeededId > -1)
         {
            returnValue = this.mImpCatalog[impNeededId];
         }
         return returnValue;
      }
      
      public function itemCalculatePosition(item:DCItemAnimatedInterface, layerId:int) : void
      {
         var imp:DCAnimImp = this.itemGetImp(item,layerId);
         if(imp != null)
         {
            imp.itemCalculatePosition(item,layerId);
         }
      }
      
      public function getImpFromId(id:int) : DCAnimImp
      {
         return this.mImpCatalog != null && id >= 0 && id < this.mImpCatalog.length ? this.mImpCatalog[id] : null;
      }
   }
}
