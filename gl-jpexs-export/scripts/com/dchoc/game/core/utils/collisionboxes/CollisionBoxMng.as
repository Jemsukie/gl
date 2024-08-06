package com.dchoc.game.core.utils.collisionboxes
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.world.item.WorldItemDef;
   import com.dchoc.toolkit.utils.collisionboxes.DCCollisionBoxMng;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class CollisionBoxMng extends DCCollisionBoxMng
   {
      
      public static const COLLISION_BOX_TYPE_COLLECT:uint = 16763904;
      
      public static const COLLISION_BOX_TYPE_CONSTRUCTION:uint = 65535;
      
      public static const COLLISION_BOX_TYPE_BAR:uint = 16777215;
      
      public static const COLLISION_BOX_TYPE_SUFFIX_CONSTRUCTION:String = "const";
      
      public static const COLLISION_BOX_TYPE_SUFFIX_COLLECT:String = "collect";
      
      public static const COLLISION_BOX_TYPE_SUFFIX_BAR:String = "bar";
      
      private static const FILES_COLLISION_BOXES:Vector.<String> = new <String>["assets/flash/world_items/buildings/bases/bases.swf"];
      
      private static const FILES_COUNT:int = FILES_COLLISION_BOXES.length;
       
      
      public function CollisionBoxMng()
      {
         super();
      }
      
      override protected function populateMappings() : void
      {
         smCollisionTypeMappings["collect"] = 16763904;
         smCollisionTypeMappings["const"] = 65535;
         smCollisionTypeMappings["bar"] = 16777215;
      }
      
      override protected function filesGetCount() : int
      {
         return FILES_COUNT;
      }
      
      override protected function filesIsAvailable(id:int) : Boolean
      {
         var returnValue:Boolean = false;
         if(id < FILES_COUNT)
         {
            returnValue = InstanceMng.getWorldItemDefMng().isBuilt() && InstanceMng.getResourceMng().isResourceLoaded(FILES_COLLISION_BOXES[id]);
         }
         return returnValue;
      }
      
      override protected function filesReadCollisionBoxes(id:int) : void
      {
         var baseSizes:Vector.<String> = null;
         var size:String = null;
         var animName:* = null;
         if(id < FILES_COUNT)
         {
            baseSizes = InstanceMng.getWorldItemDefMng().basesGetSizes();
            for each(size in baseSizes)
            {
               animName = "construction_" + size + "_particles";
               this.registerCollisionBoxesInAnim(FILES_COLLISION_BOXES[id],this.getCollisionBoxSku(size));
            }
         }
      }
      
      private function registerCollisionBoxesInAnim(resourceSku:String, animName:String) : void
      {
         var collisionBoxes:Vector.<Object> = null;
         var symbol:Sprite = null;
         var numChildren:int = 0;
         var child:DisplayObject = null;
         var tokens:Array = null;
         var currentCollision:Object = null;
         var i:int = 0;
         var defClass:Class;
         if((defClass = InstanceMng.getResourceMng().getSWFClass(resourceSku,animName)) != null)
         {
            collisionBoxes = new Vector.<Object>(0);
            symbol = new defClass();
            numChildren = symbol.numChildren;
            for(i = 0; i < numChildren; )
            {
               tokens = (child = symbol.getChildAt(i)).name.split("_");
               currentCollision = {
                  "name":child.name,
                  "type":getTypeByName(tokens[0]),
                  "x":child.x,
                  "y":child.y
               };
               if(tokens.length > 1)
               {
                  currentCollision.id = int(tokens[1]) - 1;
               }
               collisionBoxes.push(currentCollision);
               i++;
            }
            addCollisionBoxTemplate(animName,collisionBoxes);
         }
      }
      
      public function getCollisionBoxSku(fileSku:String) : String
      {
         return "construction_" + fileSku + "_particles";
      }
      
      public function getCollisionBoxSkuForDef(def:WorldItemDef) : String
      {
         var key:String = def.getBaseCols() + "x" + def.getBaseRows();
         return this.getCollisionBoxSku(key);
      }
   }
}
