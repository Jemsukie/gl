package com.dchoc.game.controller.hangar
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.popups.hangar.EPopupBunker;
   import com.dchoc.game.model.userdata.UserDataMng;
   import com.dchoc.game.model.world.World;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.core.component.DCComponent;
   import esparragon.utils.EUtils;
   
   public class HangarControllerMng extends DCComponent
   {
      
      private static const PROFILES_OWNER:int = 0;
      
      private static const PROFILES_VISITING:int = 1;
      
      private static const PROFILES_COUNT:int = 2;
       
      
      private var mHangarControllers:Vector.<HangarController>;
      
      private var mCurrentProfile:int;
      
      private var mHelpListHangars:Vector.<Object>;
      
      public function HangarControllerMng()
      {
         super();
         this.mCurrentProfile = 0;
      }
      
      override protected function loadDoStep(step:int) : void
      {
         var i:int = 0;
         if(step != 0)
         {
            return;
         }
         this.mHangarControllers = new Vector.<HangarController>(2,true);
         for(i = 0; i < 2; )
         {
            this.mHangarControllers[i] = new HangarController();
            this.mHangarControllers[i].load();
            i++;
         }
         this.helpListLoad();
      }
      
      override protected function unloadDo() : void
      {
         var i:int = 0;
         for(i = 0; i < 2; )
         {
            this.mHangarControllers[i].unload();
            i++;
         }
         this.mHangarControllers = null;
         this.helpListUnload();
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildSyncTotalSteps = 2;
         mBuildAsyncTotalSteps = 0;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         if(step == 0)
         {
            if(mPersistenceData != null && InstanceMng.getWorld().isBuilt())
            {
               if(this.mHangarControllers[this.mCurrentProfile].isBuilt() == false)
               {
                  this.mHangarControllers[this.mCurrentProfile].build();
               }
               else
               {
                  this.mHangarControllers[this.mCurrentProfile].summonShipsInHangars();
               }
               if(!this.mHangarControllers[0].isBuilt())
               {
                  this.mHangarControllers[0].build();
               }
               if(this.mHangarControllers[this.mCurrentProfile].isBuilt() && this.mHangarControllers[0])
               {
                  buildAdvanceSyncStep();
               }
            }
         }
         else if(step == 1)
         {
            this.helpListBuild();
            buildAdvanceSyncStep();
         }
      }
      
      override protected function unbuildDo() : void
      {
         this.unbuildMode(InstanceMng.getApplication().mFlowStateUnbuildMode);
         this.mHangarControllers[1].unbuild();
         this.helpListUnbuild();
      }
      
      override public function unbuildMode(mode:int) : void
      {
         if(mode == 1)
         {
            this.mHangarControllers[0].unbuild();
         }
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         this.helpListLogicUpdate(dt);
      }
      
      override public function persistenceSetData(value:XML) : void
      {
         super.persistenceSetData(value);
         if(this.mHangarControllers[0].isBuilt() == false)
         {
            this.mHangarControllers[0].persistenceSetData(value);
         }
         this.mHangarControllers[1].persistenceSetData(value);
      }
      
      override public function persistenceGetData() : XML
      {
         return this.mHangarControllers[this.mCurrentProfile].persistenceGetData();
      }
      
      public function persistenceSetDataOwner(value:XML, unbuild:Boolean) : void
      {
         super.persistenceSetData(value);
         var hangarController:HangarController = this.mHangarControllers[0] as HangarController;
         if(unbuild)
         {
            hangarController.setKeepHangars(true);
            hangarController.unbuild();
            hangarController.setKeepHangars(false);
         }
         hangarController.persistenceSetData(value);
      }
      
      public function persistenceSetDataVisitor(value:XML) : void
      {
         super.persistenceSetData(value);
         this.mHangarControllers[1].persistenceSetData(value);
      }
      
      public function getHangarController() : HangarController
      {
         return this.mHangarControllers[this.mCurrentProfile];
      }
      
      public function getProfileLoginHangarController() : HangarController
      {
         return this.mHangarControllers[0];
      }
      
      public function changeProfileDependingOnRole(newRoleId:int) : void
      {
         switch(newRoleId - 1)
         {
            case 0:
            case 1:
            case 2:
               this.mCurrentProfile = 1;
               break;
            default:
               this.mCurrentProfile = 0;
         }
      }
      
      private function helpListLoad() : void
      {
         this.mHelpListHangars = new Vector.<Object>(0);
      }
      
      private function helpListUnload() : void
      {
         this.mHelpListHangars = null;
      }
      
      private function helpListBuild() : void
      {
         var hangarXml:XML = null;
         var userXml:XML = null;
         var helpXml:XML = null;
         var pHelpsVector:Vector.<Object> = null;
         var helpUser:Object = null;
         var pHelpsUnits:Vector.<Object> = null;
         var pSid:String = null;
         var pUserId:String = null;
         var pSku:String = null;
         var helpList:XML;
         if((helpList = InstanceMng.getUserDataMng().getFileXML(UserDataMng.KEY_HANGARS_HELP_LIST)) != null)
         {
            for each(hangarXml in EUtils.xmlGetChildrenList(helpList,"Hangar"))
            {
               pSid = EUtils.xmlReadString(hangarXml,"sid");
               pHelpsVector = new Vector.<Object>(0);
               for each(userXml in EUtils.xmlGetChildrenList(hangarXml,"User"))
               {
                  pUserId = EUtils.xmlReadString(userXml,"accountId");
                  pHelpsUnits = new Vector.<Object>(0);
                  for each(helpXml in EUtils.xmlGetChildrenList(userXml,"Help"))
                  {
                     pSku = EUtils.xmlReadString(helpXml,"sku");
                     pHelpsUnits.push({
                        "sku":pSku,
                        "amount":EUtils.xmlReadInt(helpXml,"amount")
                     });
                  }
                  helpUser = {
                     "userId":pUserId,
                     "helpsUnits":pHelpsUnits
                  };
                  pHelpsVector.push(helpUser);
               }
               this.mHelpListHangars.push({
                  "sid":pSid as String,
                  "helpsVector":pHelpsVector,
                  "reset":false
               });
            }
         }
      }
      
      public function helpListUpdateHangar(hangarUpdatedXml:XML) : void
      {
         var result:int = 0;
         var pSid:String = null;
         var pUserId:String = null;
         var pSku:String = null;
         var pHelpsUnits:Vector.<Object> = null;
         var pHelpsVector:Vector.<Object> = null;
         var unitXml:XML = null;
         if(hangarUpdatedXml != null)
         {
            result = EUtils.xmlReadInt(hangarUpdatedXml,"result");
            if(result != -1)
            {
               pSid = EUtils.xmlReadString(hangarUpdatedXml,"sid");
               pHelpsUnits = new Vector.<Object>(0);
               pHelpsVector = new Vector.<Object>(0);
               for each(unitXml in EUtils.xmlGetChildrenList(hangarUpdatedXml,"Unit"))
               {
                  pSku = EUtils.xmlReadString(unitXml,"sku");
                  pHelpsUnits.push({
                     "sku":pSku,
                     "amount":EUtils.xmlReadInt(unitXml,"amount")
                  });
               }
               pHelpsVector.push({
                  "userId":"",
                  "helpsUnits":pHelpsUnits
               });
               this.mHelpListHangars.push({
                  "sid":pSid,
                  "helpsVector":pHelpsVector,
                  "reset":true
               });
            }
         }
      }
      
      private function helpListUnbuild() : void
      {
         this.mHelpListHangars.length = 0;
      }
      
      private function helpListLogicUpdate(dt:int) : void
      {
         var doNotification:* = false;
         var userDataMng:UserDataMng = null;
         var world:World = null;
         var help:Object = null;
         var helpUser:Object = null;
         var helpUnit:Object = null;
         var i:int = 0;
         var j:int = 0;
         var sid:String = null;
         var item:WorldItemObject = null;
         var removeHelp:* = false;
         var hangar:Hangar = null;
         var hangarController:HangarController = null;
         var bunkerController:BunkerController = null;
         var thisHangarController:HangarController = null;
         var unitsHelpedAmount:int = 0;
         var epopupBunker:EPopupBunker = null;
         var length:int;
         if((length = int(this.mHelpListHangars.length)) > 0)
         {
            doNotification = InstanceMng.getRole().mId == 0;
            userDataMng = InstanceMng.getUserDataMng();
            world = InstanceMng.getWorld();
            hangarController = InstanceMng.getHangarControllerMng().getProfileLoginHangarController();
            bunkerController = InstanceMng.getBunkerController();
            unitsHelpedAmount = 0;
            for(i = 0; i < length; )
            {
               sid = String((help = this.mHelpListHangars[i]).sid);
               if(!(removeHelp = (item = world.itemsGetItemBySid(sid)) == null))
               {
                  if(removeHelp = !item.needsRepairs())
                  {
                     hangar = (thisHangarController = item.mDef.isABunker() ? bunkerController : hangarController).getFromSid(sid);
                     if(hangar != null)
                     {
                        if(help.reset)
                        {
                           hangar.removeUnits();
                        }
                        for each(helpUser in help.helpsVector)
                        {
                           hangar.helpReceiveHelpFromUser(helpUser.userId,helpUser.helpsUnits);
                           unitsHelpedAmount += helpUser.helpsUnits.length;
                        }
                        if(doNotification && unitsHelpedAmount != 0)
                        {
                           hangar.getWIO().highlightAdd();
                        }
                     }
                  }
               }
               if(removeHelp)
               {
                  this.mHelpListHangars.splice(i,1);
                  length--;
                  if(doNotification)
                  {
                     userDataMng.updateMisc_hangarHelpDone(int(sid));
                  }
               }
               i++;
            }
            if(epopupBunker = InstanceMng.getPopupMng().getPopupBeingShown() as EPopupBunker)
            {
               epopupBunker.reloadView();
            }
         }
      }
   }
}
