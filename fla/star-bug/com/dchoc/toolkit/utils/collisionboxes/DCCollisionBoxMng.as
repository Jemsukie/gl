package com.dchoc.toolkit.utils.collisionboxes
{
   import flash.utils.Dictionary;
   
   public class DCCollisionBoxMng
   {
      
      protected static var smCollisionTypeMappings:Dictionary;
       
      
      private var mCollisionTemplates:Dictionary;
      
      private var mFilesReady:Vector.<Boolean>;
      
      private var mFilesCount:int;
      
      private var mFilesCurrentReady:int;
      
      public function DCCollisionBoxMng()
      {
         super();
      }
      
      public function build() : void
      {
         this.mCollisionTemplates = new Dictionary();
         this.filesBuild();
      }
      
      public function unbuild() : void
      {
         this.filesUnbuild();
      }
      
      public function addCollisionBoxTemplate(sku:String, collisionBoxes:Vector.<Object>) : void
      {
         var boxes:Dictionary = null;
         var types:Dictionary = null;
         var collisionBoxData:Object = null;
         if(this.mCollisionTemplates[sku] == undefined)
         {
            this.mCollisionTemplates[sku] = {
               "boxes":new Dictionary(),
               "types":new Dictionary()
            };
            boxes = this.mCollisionTemplates[sku]["boxes"];
            types = this.mCollisionTemplates[sku]["types"];
            for each(collisionBoxData in collisionBoxes)
            {
               if(boxes[collisionBoxData.name] == undefined)
               {
                  boxes[collisionBoxData.name] = collisionBoxData;
               }
               if(types[collisionBoxData.type] == undefined)
               {
                  types[collisionBoxData.type] = new Vector.<Object>(0);
               }
               types[collisionBoxData.type].push(collisionBoxData);
            }
         }
      }
      
      public function getCollisionBoxByName(template:String, name:String) : Object
      {
         if(this.mCollisionTemplates[template] != undefined)
         {
            return this.mCollisionTemplates[template]["boxes"][name];
         }
         return null;
      }
      
      public function getCollisionBoxesByType(template:String, type:uint) : Vector.<Object>
      {
         if(this.mCollisionTemplates[template] != undefined)
         {
            return this.mCollisionTemplates[template]["types"][type];
         }
         return null;
      }
      
      public function getTypeByName(type:String) : uint
      {
         if(smCollisionTypeMappings == null)
         {
            smCollisionTypeMappings = new Dictionary();
            this.populateMappings();
         }
         return smCollisionTypeMappings[type];
      }
      
      protected function populateMappings() : void
      {
      }
      
      public function logicUpdate(dt:int) : void
      {
         var i:int = 0;
         if(this.mFilesCurrentReady < this.mFilesCount)
         {
            for(i = 0; i < this.mFilesCount; )
            {
               if(!this.mFilesReady[i])
               {
                  if(this.filesIsAvailable(i))
                  {
                     this.filesReadCollisionBoxes(i);
                     this.mFilesReady[i] = true;
                     this.mFilesCurrentReady++;
                  }
               }
               i++;
            }
         }
      }
      
      private function filesBuild() : void
      {
         this.mFilesCount = this.filesGetCount();
         if(this.mFilesCount > 0)
         {
            this.mFilesReady = new Vector.<Boolean>(this.mFilesCount);
         }
      }
      
      private function filesUnbuild() : void
      {
         this.mFilesReady = null;
         this.mFilesCount = 0;
         this.mFilesCurrentReady = 0;
      }
      
      protected function filesGetCount() : int
      {
         return 0;
      }
      
      protected function filesIsAvailable(i:int) : Boolean
      {
         return false;
      }
      
      protected function filesReadCollisionBoxes(i:int) : void
      {
      }
   }
}
