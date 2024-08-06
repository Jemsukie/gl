package com.dchoc.game.model.unit.components.view
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.model.unit.MyUnit;
   import com.dchoc.game.model.unit.UnitScene;
   import com.dchoc.game.model.unit.components.goal.GoalShip;
   import com.dchoc.game.model.unit.components.goal.GoalShipOnHangar;
   import com.dchoc.game.model.unit.components.movement.UnitComponentMovement;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.utils.DCUtils;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import com.dchoc.toolkit.view.map.DCMapViewDef;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   import flash.text.TextField;
   
   public class UnitViewDebug extends UnitComponentView
   {
      
      public static const SHAPE_BASE:int = 0;
      
      public static const SHAPE_AVOID_OBSTACLES_BOX:int = 1;
      
      public static const SHAPE_BOUNDING_AREA:int = 2;
      
      public static const SHAPE_TARGET:int = 3;
      
      public static const SHAPE_SHOT_AREA:int = 4;
      
      public static const SHAPE_PURSUIT_AREA:int = 5;
      
      public static const SHAPE_PANIC_AREA:int = 6;
      
      public static const SHAPE_HANGAR_AREA:int = 7;
      
      public static const SHAPE_COUNT:int = 8;
      
      private static const CONTAINER_AREAS:int = 0;
      
      private static const CONTAINER_BODY:int = 1;
      
      private static const CONTAINER_TEXT:int = 2;
      
      private static const CONTAINER_TARGET:int = 3;
      
      private static const CONTAINER_COUNT:int = 4;
      
      private static const CONTAINER_VISIBLE:Array = [true,true,true,false];
      
      private static var smMapViewDef:DCMapViewDef;
      
      private static var smCoor:DCCoordinate;
       
      
      private var mContainers:Array;
      
      private var mRenderMatrix:Matrix3D;
      
      private var mShapes:Array;
      
      public function UnitViewDebug(unit:MyUnit, headingComponentKey:int = -1)
      {
         super(unit,headingComponentKey);
      }
      
      public static function unloadStatic() : void
      {
         smMapViewDef = null;
         smCoor = null;
      }
      
      override protected function load() : void
      {
         var i:int = 0;
         var t:TextField = null;
         super.load();
         this.mContainers = new Array(4);
         for(i = 0; i < 4; )
         {
            if(i == 2)
            {
               t = new TextField();
               DCTextMng.setText(t,mUnit.mId + "");
               t.textColor = 16773120;
               this.mContainers[i] = t;
            }
            else
            {
               this.mContainers[i] = new Sprite();
            }
            i++;
         }
         this.mShapes = new Array(8);
      }
      
      override public function unload() : void
      {
         this.mContainers = null;
         this.mShapes = null;
         super.unload();
      }
      
      override public function unbuild(u:MyUnit) : void
      {
         this.removeFromScene();
         if(this.mShapes != null)
         {
            this.mShapes.length = 0;
         }
      }
      
      override public function reset(u:MyUnit) : void
      {
         super.reset(u);
         if(smMapViewDef == null)
         {
            smMapViewDef = InstanceMng.getMapControllerPlanet().mMapViewDef;
            smCoor = new DCCoordinate();
         }
         this.setVisible(true);
      }
      
      override public function setVisible(value:Boolean) : void
      {
         var i:int = 0;
         super.setVisible(value);
         for(i = 0; i < 8; )
         {
            if(i <= 0 || i == 4)
            {
               this.shapeSetVisible(i,value);
            }
            i++;
         }
      }
      
      private function shapeToContainerId(shapeId:int) : int
      {
         var returnValue:int = 0;
         switch(shapeId - 1)
         {
            case 0:
            case 3:
               returnValue = 0;
               break;
            case 2:
               returnValue = 3;
               break;
            default:
               returnValue = 1;
         }
         return returnValue;
      }
      
      public function shapeSetVisible(id:int, value:Boolean) : void
      {
         var container:DisplayObjectContainer = this.mContainers[this.shapeToContainerId(id)];
         if(value)
         {
            this.renderShape(id);
            container.addChild(this.mShapes[id]);
         }
         else if(this.mShapes[id] != null)
         {
            if(container.contains(this.mShapes[id]))
            {
               container.removeChild(this.mShapes[id]);
            }
         }
      }
      
      private function renderShape(id:int) : void
      {
         var value:Number = NaN;
         var mov:UnitComponentMovement = null;
         if(this.mShapes[id] == null)
         {
            this.mShapes[id] = new Shape();
         }
         var g:Graphics = Shape(this.mShapes[id]).graphics;
         switch(id)
         {
            case 0:
               DCUtils.fillTriangle(g,16711935);
               break;
            case 1:
               mov = mUnit.getMovementComponent();
               if(mov != null)
               {
               }
               break;
            case 2:
               DCUtils.drawEllipse(g,mUnit.getBoundingRadius(),16711680);
               break;
            case 3:
               break;
            case 4:
               value = mUnit.mDef.getShotDistance();
               DCUtils.drawCircle(g,65280,value);
               DCUtils.drawEllipse(g,value,16777215);
               break;
            case 5:
               DCUtils.drawCircle(g,4095,mUnit.mDef.getPursuitDistance(),0,0,true);
               break;
            case 6:
               DCUtils.drawCircle(g,16711680,mUnit.mDef.getPanicDistance());
               break;
            case 7:
               DCUtils.drawCircle(g,16711935,80);
         }
      }
      
      override protected function render(dt:int, heading:Vector3D) : void
      {
         var text:* = null;
         var target:Vector3D = null;
         if(mUnit.mData == null)
         {
            return;
         }
         if(mUnit.mData[31] != null)
         {
            this.renderShape(5);
         }
         smCoor.x = mUnit.mPositionDrawX;
         smCoor.y = mUnit.mPositionDrawY;
         var renderData:DisplayObject = this.mContainers[0];
         if(renderData != null)
         {
            renderData.x = smCoor.x;
            renderData.y = smCoor.y + mUnit.mPosition.z;
         }
         renderData = this.mContainers[1];
         if(renderData != null)
         {
            if(heading != null)
            {
               if(this.mRenderMatrix == null)
               {
                  this.mRenderMatrix = new Matrix3D();
               }
               this.mRenderMatrix.identity();
               heading.z = 0;
               this.mRenderMatrix.pointAt(heading,Vector3D.X_AXIS,Vector3D.Y_AXIS);
               this.mRenderMatrix.appendTranslation(smCoor.x,smCoor.y + mUnit.mPosition.z,0);
               renderData.transform.matrix3D = this.mRenderMatrix;
            }
            else
            {
               renderData.x = smCoor.x;
               renderData.y = smCoor.y;
            }
         }
         renderData = this.mContainers[2];
         if(renderData != null)
         {
            text = mUnit.mId + "/";
            if(mUnit.getGoalComponent() != null)
            {
               if(mUnit.getGoalComponent() is GoalShipOnHangar)
               {
                  text += "H:";
               }
               else if(mUnit.getGoalComponent() is GoalShip)
               {
                  text += "G:";
               }
               text += mUnit.getGoalComponent().mCurrentState;
            }
            DCTextMng.setText(renderData as TextField,text);
            renderData.x = smCoor.x;
            renderData.y = smCoor.y;
         }
         var mov:UnitComponentMovement;
         if((mov = mUnit.getMovementComponent()) != null)
         {
            target = mov.getTarget();
            if(this.mContainers[3] != null && target != null)
            {
               smCoor.x = target.x;
               smCoor.y = target.y;
               InstanceMng.getViewMngPlanet().logicPosToViewPos(smCoor);
               this.mContainers[3].x = smCoor.x;
               this.mContainers[3].y = smCoor.y;
            }
            this.shapeSetVisible(1,mov.mBehaviourWeights[7] > 0);
         }
      }
      
      override public function addToScene() : void
      {
         var s:DisplayObject = null;
         var i:int = 0;
         this.reset(mUnit);
         if(UnitScene.DEBUG_ENABLED)
         {
            for(i = 0; i < 4; )
            {
               s = this.mContainers[i];
               if(CONTAINER_VISIBLE[i])
               {
                  InstanceMng.getUnitScene().mDebugRenderData.addChild(s);
               }
               i++;
            }
         }
      }
      
      override public function removeFromScene() : void
      {
         var s:DisplayObject = null;
         var stage:DisplayObjectContainer = null;
         if(UnitScene.DEBUG_ENABLED)
         {
            stage = InstanceMng.getUnitScene().mDebugRenderData;
            for each(s in this.mContainers)
            {
               if(stage.contains(s))
               {
                  stage.removeChild(s);
               }
            }
         }
      }
      
      override public function getDisplayObject() : DisplayObject
      {
         return this.mContainers[1];
      }
   }
}
