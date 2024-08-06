package com.dchoc.toolkit.utils.def
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.instance.DCInstanceMng;
   import com.dchoc.toolkit.core.resource.DCResourceMng;
   import com.dchoc.toolkit.core.rule.DCRuleMng;
   import esparragon.utils.EUtils;
   import flash.utils.Dictionary;
   
   public class DCDefMng extends DCComponent
   {
       
      
      private var mDefsBySku:Dictionary;
      
      private var mDefsByGroup:Dictionary;
      
      private var mDirectoryPath:String;
      
      private var mResourceDefs:Vector.<String>;
      
      private var mResourceDefsBuilt:Vector.<Boolean>;
      
      private var mTypeSkus:Vector.<String>;
      
      private var mSigFiles:Vector.<String>;
      
      private var mSigDefs:Vector.<DCDef>;
      
      public function DCDefMng(resourceDefs:Vector.<String>, typeSkus:Vector.<String> = null, directoryPath:String = null, sigFiles:Vector.<String> = null)
      {
         var i:int = 0;
         super();
         this.mResourceDefs = resourceDefs;
         this.mResourceDefsBuilt = new Vector.<Boolean>(this.mResourceDefs.length,true);
         if(typeSkus == null)
         {
            typeSkus = new Vector.<String>(0);
            for(i = resourceDefs.length - 1; i > -1; )
            {
               typeSkus.push("default");
               i--;
            }
         }
         this.mTypeSkus = typeSkus;
         this.mDirectoryPath = directoryPath;
         this.mSigFiles = sigFiles;
      }
      
      public function getResourceDefs() : Vector.<String>
      {
         return this.mResourceDefs;
      }
      
      override protected function loadDoStep(step:int) : void
      {
         if(step == 0)
         {
            this.mDefsBySku = new Dictionary(true);
            this.mDefsByGroup = new Dictionary(true);
         }
      }
      
      override protected function unloadDo() : void
      {
         this.mDefsBySku = null;
         this.mDefsByGroup = null;
         this.mResourceDefs = null;
         this.mResourceDefsBuilt = null;
         this.mTypeSkus = null;
         this.mSigFiles = null;
         this.mSigDefs = null;
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildAsyncTotalSteps = 0;
         mBuildSyncTotalSteps = 1;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         var ruleMng:DCRuleMng = null;
         var advanceStep:Boolean = false;
         var currentTime:Number = NaN;
         var defXml:XML = null;
         var info:XML = null;
         var def:DCDef = null;
         var defToWriteXml:* = null;
         var defPlatform:String = null;
         var writePreviousDef:* = false;
         var currentPlatform:String = null;
         var i:int = 0;
         var fileName:String = null;
         var type:String = null;
         if(step == 0)
         {
            ruleMng = DCInstanceMng.getInstance().getRuleMng();
            advanceStep = this.buildCheckSyncStepCanBeAdvanced();
            currentTime = InstanceMng.getUserDataMng().getServerCurrentTimemillis();
            if(advanceStep)
            {
               currentPlatform = InstanceMng.getPlatformSettingsDefMng().getCurrentPlatformSku();
               for(i = this.mResourceDefs.length - 1; i > -1; )
               {
                  fileName = this.mResourceDefs[i];
                  if(!this.mResourceDefsBuilt[i])
                  {
                     if(ruleMng.filesIsFileLoaded(fileName))
                     {
                        info = ruleMng.filesGetFileAsXML(fileName);
                     }
                     else
                     {
                        info = null;
                     }
                     if(info == null)
                     {
                        advanceStep = false;
                     }
                     else
                     {
                        type = this.mTypeSkus[i];
                        defToWriteXml = null;
                        for each(defXml in EUtils.xmlGetChildrenList(info,"Definition"))
                        {
                           if(writePreviousDef = defToWriteXml != null)
                           {
                              if(EUtils.xmlReadString(defToWriteXml,"sku") == EUtils.xmlReadString(defXml,"sku") && EUtils.xmlIsAttribute(defXml,"platforms"))
                              {
                                 if((defPlatform = EUtils.xmlReadString(defXml,"platforms")) != "")
                                 {
                                    writePreviousDef = false;
                                    if(defPlatform.indexOf(currentPlatform) > -1)
                                    {
                                       defToWriteXml = defXml;
                                    }
                                 }
                              }
                           }
                           else
                           {
                              defToWriteXml = defXml;
                           }
                           if(writePreviousDef)
                           {
                              this.addDefFromXml(defToWriteXml,type,fileName,currentTime);
                              defToWriteXml = defXml;
                           }
                        }
                        if(defToWriteXml != null)
                        {
                           this.addDefFromXml(defToWriteXml,type,fileName,currentTime);
                        }
                        this.mResourceDefsBuilt[i] = true;
                     }
                  }
                  i--;
               }
            }
            if(advanceStep)
            {
               buildAdvanceSyncStep();
            }
         }
         if(mBuildSyncCurrentStep == mBuildSyncTotalSteps)
         {
            this.buildDefs();
         }
      }
      
      private function addDefFromXml(xml:XML, type:String, fileName:String, currentTime:Number) : void
      {
         var currentPlatform:String = null;
         var defPlatform:String = null;
         var def:DCDef = null;
         var doAdd:*;
         if(doAdd = xml != null)
         {
            currentPlatform = InstanceMng.getPlatformSettingsDefMng().getCurrentPlatformSku();
            if(EUtils.xmlIsAttribute(xml,"platforms"))
            {
               doAdd = (defPlatform = EUtils.xmlReadString(xml,"platforms")) != "" && defPlatform.indexOf(currentPlatform) > -1;
            }
            if(doAdd)
            {
               (def = this.createDef(type)).fromXml(xml,type);
               def.addGroup(fileName);
               if(def.isAvailable(currentTime))
               {
                  this.addDef(def);
               }
            }
         }
      }
      
      protected function buildCheckSyncStepCanBeAdvanced() : Boolean
      {
         return true;
      }
      
      public function notifyChangeOnRules() : void
      {
         this.buildDefs();
      }
      
      protected function buildDefs() : void
      {
         var k:* = null;
         var def:DCDef = null;
         var i:int = 0;
         if(this.mSigFiles != null)
         {
            this.mSigDefs = this.getDefs(this.mSigFiles);
            this.mSigFiles = null;
         }
         this.sort();
         for(k in this.mDefsBySku)
         {
            def = DCDef(this.mDefsBySku[k]);
            if(this.mTypeSkus != null)
            {
               i = this.mTypeSkus.length - 1;
               while(i > -1 && !def.belongsToGroup(this.mTypeSkus[i]))
               {
                  i--;
               }
               if(i > -1)
               {
                  def.setTypeId(i);
               }
               else if(Config.DEBUG_ASSERTS)
               {
                  DCDebug.traceCh("TOOLKIT","ERROR in DCDefMng.doDoBuild(): <" + i + "> is not a valid type in <" + this.mTypeSkus + "> for definition <" + def.getSku() + ">",1);
               }
            }
            def.build();
            def.setSig(def.getSig(true));
         }
      }
      
      public function addDef(def:DCDef) : void
      {
         var key:String = null;
         if(this.mDefsBySku[def.getSku()] == null)
         {
            this.mDefsBySku[def.getSku()] = def;
            for each(key in def.getGroups())
            {
               if(this.mDefsByGroup[key] == null)
               {
                  this.mDefsByGroup[key] = new Vector.<DCDef>(0);
               }
               this.mDefsByGroup[key].push(def);
            }
         }
         else if(Config.DEBUG_ASSERTS)
         {
            DCDebug.traceCh("TOOLKIT","ERROR in DCDefMng.addDef(): definition <" + def.getSku() + "> already registered: " + this.mDefsBySku[def.getSku()],1);
         }
      }
      
      public function removeDef(def:DCDef) : void
      {
         var key:String = null;
         var index:int = 0;
         if(this.mDefsBySku[def.getSku()] != null)
         {
            this.mDefsBySku[def.getSku()] = null;
            for each(key in def.getGroups())
            {
               index = int(this.mDefsByGroup[key].indexOf(def));
               if(index > -1)
               {
                  this.mDefsByGroup[key].splice(index,1);
               }
               else if(Config.DEBUG_ASSERTS)
               {
                  DCDebug.traceCh("TOOLKIT","ERROR in DCDefMng.removeDef(): definition <" + def.getSku() + "> not found in group " + key,1);
               }
            }
         }
         else if(Config.DEBUG_ASSERTS)
         {
            DCDebug.traceCh("TOOLKIT","ERROR in DCDefMng.removeDef(): definition <" + def.getSku() + "> not found",1);
         }
      }
      
      public function getDefBySku(sku:String) : DCDef
      {
         return this.mDefsBySku[sku];
      }
      
      public function getDefs(groups:Vector.<String> = null) : Vector.<DCDef>
      {
         var key:String = null;
         var def:DCDef = null;
         if(groups == null)
         {
            groups = this.getDefaultGroups();
         }
         var returnValue:Vector.<DCDef> = new Vector.<DCDef>(0);
         for each(key in groups)
         {
            for each(def in this.mDefsByGroup[key])
            {
               returnValue.push(def);
            }
         }
         return returnValue;
      }
      
      protected function getDefaultGroups() : Vector.<String>
      {
         var returnValue:Vector.<String> = new Vector.<String>(0);
         returnValue.push("default");
         return returnValue;
      }
      
      public function getDefsCount(groups:Vector.<String> = null) : int
      {
         var key:String = null;
         var returnValue:int = 0;
         if(groups == null)
         {
            groups = this.getDefaultGroups();
         }
         for each(key in groups)
         {
            returnValue += this.mDefsByGroup[key].length;
         }
         return returnValue;
      }
      
      public function getGroupsFromDef(def:DCDef) : String
      {
         var key:* = null;
         var ret:String = "";
         for(key in this.mDefsByGroup)
         {
            if(this.mDefsByGroup[key].indexOf(def) != -1)
            {
               ret += key + ",";
            }
         }
         return ret;
      }
      
      public function getDefsWithCondition(thisFunction:Function, params:Object, groups:Vector.<String> = null, isValid:Function = null) : Vector.<DCDef>
      {
         var key:String = null;
         var def:DCDef = null;
         var addItem:Boolean = false;
         if(groups == null)
         {
            groups = this.getDefaultGroups();
         }
         var returnValue:Vector.<DCDef> = new Vector.<DCDef>(0);
         for each(key in groups)
         {
            for each(def in this.mDefsByGroup[key])
            {
               addItem = true;
               if(isValid != null)
               {
                  addItem = isValid(def);
               }
               if(addItem && thisFunction(def,params))
               {
                  returnValue.push(def);
               }
            }
         }
         return returnValue;
      }
      
      public function getNewDefs() : Vector.<DCDef>
      {
         return this.mDefsByGroup["new"];
      }
      
      public function getDefsInGroup(key:String) : Vector.<DCDef>
      {
         return this.mDefsByGroup[key];
      }
      
      public function isAnyDefInGroup(group:String) : int
      {
         var returnValue:int = 0;
         if(this.mDefsByGroup[group] != null)
         {
            returnValue = int(this.mDefsByGroup[group].length);
         }
         return returnValue;
      }
      
      public function isAnyDefInGroupBelongingToThisGroup(groupKey:String, groupIn:String) : int
      {
         var def:DCDef = null;
         var returnValue:int = this.isAnyDefInGroup(groupKey);
         var count:int = 0;
         if(returnValue > 0)
         {
            for each(def in this.mDefsByGroup[groupKey])
            {
               if(def.belongsToGroup(groupIn))
               {
                  count++;
               }
            }
         }
         return count;
      }
      
      public function isAnyDefInGroupBelongingToThisType(groupKey:String, typeId:int) : int
      {
         var def:DCDef = null;
         var returnValue:int = this.isAnyDefInGroup(groupKey);
         var count:int = 0;
         if(returnValue > 0)
         {
            for each(def in this.mDefsByGroup[groupKey])
            {
               if(def.mTypeId == typeId)
               {
                  count++;
               }
            }
         }
         return count;
      }
      
      protected function checkLevel(def:DCDef, level:int) : Boolean
      {
         return def.getLevel() == level;
      }
      
      public function getItemsByLevel(level:int, groups:Vector.<String> = null, isValid:Function = null) : Vector.<DCDef>
      {
         return this.getDefsWithCondition(this.checkLevel,level,groups,isValid);
      }
      
      override protected function requestResourcesDo() : void
      {
         var resourcesMng:DCResourceMng = null;
         var def:DCDef = null;
         var k:* = null;
         if(this.mDirectoryPath != null && this.mDirectoryPath != "")
         {
            resourcesMng = DCInstanceMng.getInstance().getResourceMng();
            for(k in this.mDefsBySku)
            {
               def = this.mDefsBySku[k];
               def.requestResources(resourcesMng,this.mDirectoryPath);
            }
         }
      }
      
      protected function createDef(type:String) : DCDef
      {
         return new DCDef();
      }
      
      public function sort() : void
      {
         var groupDefs:Vector.<DCDef> = null;
         var k:* = null;
         if(this.sortIsNeeded())
         {
            for(k in this.mDefsByGroup)
            {
               groupDefs = this.mDefsByGroup[k];
               groupDefs.sort(this.sortCompareFunction);
            }
         }
      }
      
      protected function sortIsNeeded() : Boolean
      {
         return true;
      }
      
      protected function sortCompareFunction(a:DCDef, b:DCDef) : Number
      {
         var aValue:Number = a.getOrder();
         var bValue:Number = b.getOrder();
         var returnValue:Number = 0;
         if(aValue > bValue)
         {
            returnValue = 1;
         }
         else if(aValue < bValue)
         {
            returnValue = -1;
         }
         else
         {
            returnValue = this.sortCompareSameOrderFunction(a,b);
         }
         return returnValue;
      }
      
      protected function sortCompareSameOrderFunction(a:DCDef, b:DCDef) : Number
      {
         return 0;
      }
      
      public function sigCalculate(calculate:Boolean) : String
      {
         var def:DCDef = null;
         var sig:String = "";
         if(this.mSigDefs != null)
         {
            for each(def in this.mSigDefs)
            {
               sig += def.getSig(calculate);
            }
         }
         return sig;
      }
   }
}
