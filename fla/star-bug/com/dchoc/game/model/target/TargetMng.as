package com.dchoc.game.model.target
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.target.DCTarget;
   import com.dchoc.toolkit.core.target.DCTargetDef;
   import com.dchoc.toolkit.core.target.DCTargetMng;
   import flash.display.DisplayObjectContainer;
   
   public class TargetMng extends DCTargetMng
   {
       
      
      private var mHighlightShown:Boolean;
      
      private var mLastHighlightedContainer:DisplayObjectContainer;
      
      public function TargetMng(needsPersistence:Boolean = false)
      {
         super(needsPersistence);
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         if(!this.mHighlightShown)
         {
            this.highlightHide();
         }
         this.setHighlightShown(false);
         super.logicUpdateDo(dt);
      }
      
      public function getHighlightShown() : Boolean
      {
         return this.mHighlightShown;
      }
      
      public function setHighlightShown(value:Boolean) : void
      {
         this.mHighlightShown = value;
      }
      
      public function highlightContainer(container:DisplayObjectContainer) : void
      {
         if(!this.mHighlightShown)
         {
            if(container && container != this.mLastHighlightedContainer)
            {
               this.highlightHide();
               InstanceMng.getViewMngPlanet().addHighlightFromContainer(container);
               this.mLastHighlightedContainer = container;
            }
            this.setHighlightShown(true);
         }
      }
      
      public function highlightHide() : void
      {
         if(!this.mHighlightShown && this.mLastHighlightedContainer)
         {
            InstanceMng.getViewMngPlanet().removeHighlightContainer(this.mLastHighlightedContainer);
            this.mLastHighlightedContainer = null;
            this.setHighlightShown(false);
         }
      }
      
      override public function getProgress(id:String, index:int = 0) : Number
      {
         var returnValue:Number = NaN;
         var target:DCTarget = null;
         var targetSku:String = null;
         var upgradeLevel:int = 0;
         var targetType:String = null;
         var reqAmount:int = 0;
         var currAmount:int = 0;
         var serverStoredValue:int = 0;
         var unitIsUnlocked:Boolean = false;
         var unitUpgradeValue:int = 0;
         var updateServer:Boolean = true;
         var def:DCTargetDef = (target = getTargetById(id)).getDef();
         if(target != null)
         {
            switch(targetType = def.getMiniTargetTypes(index))
            {
               case "buildingsCreated":
                  reqAmount = def.getMiniTargetAmount(index);
                  upgradeLevel = int((upgradeLevel = def.getMiniTargetLevel(index) as int) == 0 ? -1 : upgradeLevel);
                  targetSku = def.getMiniTargetSku(index);
                  serverStoredValue = this.getServerProgress(id,index);
                  currAmount = InstanceMng.getWorld().itemsAmountGetAlreadyBuilt(targetSku,upgradeLevel,true);
                  updateServer = false;
                  break;
               case "droidsCreated":
                  reqAmount = def.getMiniTargetAmount(index);
                  currAmount = InstanceMng.getUserInfoMng().getProfileLogin().getMaxDroidsAmount();
                  serverStoredValue = this.getServerProgress(id,index);
                  break;
               case "haveColonies":
                  currAmount = InstanceMng.getUserInfoMng().getProfileLogin().getUserInfoObj().getPlanetsAmount() - 1;
                  reqAmount = def.getMiniTargetAmount(index);
                  serverStoredValue = this.getServerProgress(id,index);
                  break;
               case "possess":
                  targetSku = def.getMiniTargetSku(index);
                  reqAmount = def.getMiniTargetAmount(index);
                  currAmount = InstanceMng.getItemsMng().getItemObjectBySku(targetSku).quantity;
                  serverStoredValue = this.getServerProgress(id,index);
                  break;
               case "unitUpgraded":
                  reqAmount = def.getMiniTargetAmount(index);
                  serverStoredValue = this.getServerProgress(id,index);
                  unitIsUnlocked = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().isGameUnitUnlocked(def.getMiniTargetSku(index));
                  unitUpgradeValue = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().getCurrentUpgradeIdBySku(def.getMiniTargetSku(index));
                  currAmount = unitIsUnlocked == true && unitUpgradeValue >= def.getMiniTargetLevel(index) ? 1 : 0;
                  updateServer = false;
                  break;
               case "unitUnlocked":
                  reqAmount = def.getMiniTargetAmount(index);
                  serverStoredValue = this.getServerProgress(id,index);
                  currAmount = (unitIsUnlocked = InstanceMng.getGameUnitMngController().getGameUnitMngOwner().isGameUnitUnlocked(def.getMiniTargetSku(index))) == true ? 1 : 0;
                  updateServer = false;
                  break;
               default:
                  returnValue = super.getProgress(id,index);
            }
         }
         if(updateServer)
         {
            this.updateServerProgress(target,currAmount,reqAmount,serverStoredValue,targetType,upgradeLevel);
            returnValue = this.getServerProgress(id,index);
         }
         else
         {
            returnValue = serverStoredValue > currAmount ? serverStoredValue : currAmount;
         }
         return returnValue;
      }
      
      private function getServerProgress(id:String, index:int) : Number
      {
         return super.getProgress(id,index);
      }
      
      private function updateServerProgress(target:DCTarget, currAmount:int, reqAmount:int, serverStoredAmount:int, targetType:String, targetLevel:int = 0) : void
      {
         var amountToUpdate:int = 0;
         if(serverStoredAmount < reqAmount)
         {
            if((amountToUpdate = currAmount - serverStoredAmount) > 0)
            {
               target.updateProgress(targetType,amountToUpdate,"","",targetLevel);
            }
         }
      }
      
      override public function updateProgress(type:String, amount:int, resourceType:String = "", accId:String = "", level:int = 0) : void
      {
         var target:DCTarget = null;
         if(amount != 0)
         {
            for each(target in mTargets)
            {
               if(target.State < 3)
               {
                  target.updateProgress(type,amount,resourceType,accId,level,InstanceMng.getFlowStatePlanet().isTutorialRunning() == false);
               }
            }
         }
      }
      
      override protected function deleteTarget(target:DCTarget) : void
      {
         if(mTargets != null && InstanceMng.getFlowStatePlanet().isTutorialRunning())
         {
            delete mTargets[target.Id];
         }
      }
   }
}
