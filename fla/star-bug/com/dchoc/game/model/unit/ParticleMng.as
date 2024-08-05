package com.dchoc.game.model.unit
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.core.resource.ResourceMng;
   import com.dchoc.game.model.items.ItemObject;
   import com.dchoc.game.model.world.item.WorldItemObject;
   import com.dchoc.toolkit.core.component.DCComponent;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.core.view.display.DCDisplayObjectSWF;
   import com.dchoc.toolkit.utils.DCUtils;
   import com.dchoc.toolkit.utils.math.DCMath;
   import esparragon.display.ESpriteContainer;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   
   public class ParticleMng extends DCComponent
   {
      
      private static var smParticlesActive:Vector.<Particle> = new Vector.<Particle>(0);
      
      public static const TTL_DEFAULT:Number = 1000;
      
      public static const TYPE_BIG_EXPLOSION_GROUND_AIR:uint = 0;
      
      public static const TYPE_SMOKE:uint = 1;
      
      public static const TYPE_TEXTFIELD_UP:uint = 2;
      
      public static const TYPE_PARTICLE_COIN_ICON_UP:uint = 3;
      
      public static const TYPE_PARTICLE_MINERAL_ICON_UP:uint = 4;
      
      public static const TYPE_PARTICLE_XP_ICON_UP:uint = 5;
      
      public static const TYPE_BIG_EXPLOSION_AIR_GROUND:uint = 6;
      
      public static const TYPE_BIG_EXPLOSION_GROUND_GROUND:uint = 7;
      
      public static const TYPE_SHOT_1:int = 8;
      
      public static const TYPE_SHOT_2:int = 9;
      
      public static const TYPE_SHOT_3:int = 10;
      
      public static const TYPE_GIFT:uint = 11;
      
      public static const TYPE_CRATER:uint = 12;
      
      public static const TYPE_MODULAR_EXPLOSION1:int = 13;
      
      public static const TYPE_MODULAR_EXPLOSION2:int = 14;
      
      public static const TYPE_MODULAR_EXPLOSION3:int = 15;
      
      public static const TYPE_MODULAR_EXPLOSION4:int = 16;
      
      public static const TYPE_LOOTER_EFFECT:uint = 17;
      
      public static const TYPE_BIG_EXPLOSION_GROUND_AIR2:uint = 18;
      
      public static const TYPE_BOMB_TAIL:int = 19;
      
      public static const TYPE_IMPACT_GLUE:int = 20;
      
      public static const TYPE_BOMB_EXPLOSION:int = 21;
      
      public static const TYPE_DUST:int = 23;
      
      public static const TYPE_IMPACT_LASER_BIG:int = 24;
      
      public static const TYPE_IMPACT_LASER_SMALL:int = 25;
      
      private static const NUM_TYPE_PARTICLES:int = 26;
      
      public static var smParticlesGiftActives:int = 0;
      
      public static var smGlowsDictionary:Dictionary = new Dictionary();
      
      protected static var smParticles:Vector.<Vector.<Particle>> = new Vector.<Vector.<Particle>>(26,true);
      
      public static var smCheckBounds:Vector.<Boolean> = new Vector.<Boolean>(26,true);
      
      private static const MAX_PARTICLES_PER_ITEM:int = 8;
      
      private static const TILES_BIGGER_BUILDING:int = 10;
      
      private static const PARTICLE_TIMER:int = 100;
      
      private static var smAttackedItems:Vector.<WorldItemObject>;
      
      private static var smParticlesPerItemCount:Vector.<int>;
      
      private static var smMaxParticlesCount:Vector.<int>;
      
      private static var smParticlesTimer:Vector.<int>;
      
      private static var smParticlesCount:int;
      
      private static var smLaunchParticles:Boolean;
       
      
      public function ParticleMng()
      {
         super();
      }
      
      private static function getCurrentParticle(type:int) : Particle
      {
         var count:int = 0;
         var i:int = 0;
         var particles:Vector.<Particle>;
         if((particles = smParticles[type]) != null)
         {
            if(!particles.fixed)
            {
               addParticleType(type,0);
            }
            count = int(particles.length);
            for(i = 0; i < count; )
            {
               if(particles[i].mState == 0)
               {
                  return particles[i];
               }
               i++;
            }
         }
         return null;
      }
      
      private static function addParticleType(type:int, index:int) : void
      {
         var cParticle:Particle = null;
         var sprite:Sprite = null;
         var bitmapContainer:DCDisplayObjectSWF = null;
         if(type >= 26)
         {
            return;
         }
         if(type == 19)
         {
            cParticle = new BombTail(type);
         }
         else
         {
            cParticle = new Particle(type);
         }
         var particleList:Vector.<Particle>;
         if((particleList = smParticles[type]).fixed)
         {
            particleList[index] = cParticle;
         }
         else
         {
            particleList.push(cParticle);
         }
         switch(type)
         {
            case 0:
               cParticle.mCustomRenderData = getDCDisplayObject("explosion_air_1");
               cParticle.mFrameCount = 35;
               break;
            case 18:
               cParticle.mCustomRenderData = getDCDisplayObject("explosion_air_2");
               cParticle.mFrameCount = 40;
               break;
            case 6:
               cParticle.mCustomRenderData = getDCDisplayObject("explosion_ground_1");
               cParticle.mFrameCount = 12;
               break;
            case 7:
               cParticle.mCustomRenderData = getDCDisplayObject("explosion_ground_2");
               cParticle.mFrameCount = 30;
               break;
            case 8:
               cParticle.mCustomRenderData = getDCDisplayObject("impact_bullet_1");
               cParticle.mFrameCount = 4;
               break;
            case 9:
               cParticle.mCustomRenderData = getDCDisplayObject("impact_bullet_2");
               cParticle.mFrameCount = 4;
               break;
            case 10:
               cParticle.mCustomRenderData = getDCDisplayObject("impact_bullet_3");
               cParticle.mFrameCount = 4;
               break;
            case 1:
               cParticle.mCustomRenderData = getDCDisplayObject("smoke_rocket");
               cParticle.mFrameCount = 9;
               break;
            case 2:
               cParticle.createTextField();
               break;
            case 3:
               cParticle.mCustomRenderData = InstanceMng.getResourceMng().getDCDisplayObject("assets/flash/world_items/pngs_common/particle_coin.png","");
               cParticle.mCustomRenderData.visible = false;
               cParticle.createTextField();
               cParticle.mFrameCount = 18;
               cParticle.mCustomRenderHeight = 23;
               cParticle.mCustomRenderWidth = 23;
               break;
            case 4:
               cParticle.mCustomRenderData = InstanceMng.getResourceMng().getDCDisplayObject("assets/flash/world_items/pngs_common/particle_resource.png","");
               cParticle.mCustomRenderData.visible = false;
               cParticle.createTextField();
               cParticle.mFrameCount = 18;
               cParticle.mCustomRenderHeight = 32;
               cParticle.mCustomRenderWidth = 32;
               break;
            case 5:
               cParticle.mCustomRenderData = InstanceMng.getResourceMng().getDCDisplayObject("assets/flash/world_items/pngs_common/particle_experience.png","");
               cParticle.mCustomRenderData.visible = false;
               cParticle.createTextField();
               cParticle.mFrameCount = 18;
               cParticle.mCustomRenderHeight = 32;
               cParticle.mCustomRenderWidth = 32;
               break;
            case 11:
               (sprite = new Sprite()).mouseChildren = false;
               sprite.filters = [DCUtils.STROKE_WHITE];
               bitmapContainer = new DCDisplayObjectSWF(sprite);
               cParticle.mCustomRenderData = bitmapContainer;
               break;
            case 12:
               cParticle.mCustomRenderData = InstanceMng.getResourceMng().getPngResource("assets/flash/battle_effects/crater.png","assets/flash/battle_effects/crater.png");
               cParticle.mFrameCount = 1;
               break;
            case 13:
               cParticle.mCustomRenderData = getDCDisplayObject("explosion_1");
               cParticle.mFrameCount = 31;
               break;
            case 14:
               cParticle.mCustomRenderData = getDCDisplayObject("explosion_2");
               cParticle.mFrameCount = 25;
               break;
            case 15:
               cParticle.mCustomRenderData = getDCDisplayObject("explosion_3");
               cParticle.mFrameCount = 28;
               break;
            case 16:
               cParticle.mCustomRenderData = getDCDisplayObject("explosion_4");
               cParticle.mFrameCount = 27;
               break;
            case 17:
               cParticle.mCustomRenderData = getDCDisplayObject("looters_effect");
               cParticle.mFrameCount = 20;
               break;
            case 20:
               cParticle.mCustomRenderData = getDCDisplayObject("impact_freeze");
               cParticle.mFrameCount = 13;
               break;
            case 21:
               cParticle.mCustomRenderData = getDCDisplayObject("explosion_mortar");
               cParticle.mCustomRenderData.getDisplayObject().blendMode = "lighten";
               cParticle.mCustomRenderData.scaleX = 0.5;
               cParticle.mCustomRenderData.scaleY = 0.5;
               cParticle.mFrameCount = 15;
               cParticle.setFrameRate(1);
               break;
            case 23:
               cParticle.mCustomRenderData = getDCDisplayObject("dust");
               cParticle.mFrameCount = 10;
               break;
            case 24:
               cParticle.mCustomRenderData = getDCDisplayObject("impact_photon_1");
               cParticle.mFrameCount = cParticle.mCustomRenderData.totalFrames;
               break;
            case 25:
               cParticle.mCustomRenderData = getDCDisplayObject("impact_photon_2");
               cParticle.mFrameCount = cParticle.mCustomRenderData.totalFrames;
         }
      }
      
      private static function getDCDisplayObject(clipName:String) : DCDisplayObject
      {
         return InstanceMng.getEResourcesMng().getDCDisplayObject("units_effects","legacy",clipName,3);
      }
      
      private static function isParticleAllowed(type:uint) : Boolean
      {
         return true;
      }
      
      public static function addParticle(type:uint, x:int, y:int, frameTicks:int = 2) : Particle
      {
         var cParticle:Particle = null;
         if(isParticleAllowed(type))
         {
            if((cParticle = getCurrentParticle(type)) != null)
            {
               if(cParticle.activate(x,y,1,frameTicks))
               {
                  return cParticle;
               }
               cParticle.deactivate();
               removeParticle(cParticle);
            }
         }
         return null;
      }
      
      public static function addParticleAndScale(type:uint, x:int, y:int, scaleX:Number = 1, scaleY:Number = 1, frameTicks:int = 2) : Particle
      {
         var cParticle:Particle;
         if((cParticle = getCurrentParticle(type)) != null)
         {
            if(cParticle.activate(x,y,1,frameTicks))
            {
               cParticle.mCustomRenderData.scaleX = scaleX;
               cParticle.mCustomRenderData.scaleY = scaleY;
               return cParticle;
            }
            cParticle.deactivate();
            removeParticle(cParticle);
         }
         return null;
      }
      
      public static function addParticleGift(item:ItemObject, x:int, y:int, maxPart:int = 1, index:int = 0) : Particle
      {
         var sprite:Sprite = null;
         var amount:String = null;
         var arr:Array = null;
         var cont:ESpriteContainer = null;
         var cParticle:Particle;
         if((cParticle = getCurrentParticle(11)) != null)
         {
            sprite = cParticle.mCustomRenderData.getDisplayObject() as Sprite;
            amount = null;
            if((arr = item.mDef.getActionParam().split(":")).length > 1 && int(arr[1]) > 1)
            {
               amount = String(arr[1]);
            }
            cont = InstanceMng.getViewFactory().getContainerItem(item.mDef.getAssetId(),amount,null,false);
            sprite.addChild(cont);
            cParticle.setCurrentGift(item);
            cParticle.setMaxItemsPerTimeAndIndex(maxPart,index);
            smParticlesGiftActives++;
            cParticle.activate(x,y,1,0);
            return cParticle;
         }
         return null;
      }
      
      public static function addParticleTextField(type:uint, x:int, y:int, text:String, color:uint = 0, outlineColor:uint = 0, ttl:Number = 0, xVelocity:int = 0, yVelocity:int = -1, size:int = 20, bold:Boolean = true, italic:Boolean = false, underline:Boolean = false) : Particle
      {
         var cParticle:Particle;
         if((cParticle = getCurrentParticle(type)) != null)
         {
            cParticle.activate(x,y);
            cParticle.setTextFieldInfo(text,xVelocity,yVelocity,ttl,color,outlineColor,size,bold,italic,underline);
            return cParticle;
         }
         return null;
      }
      
      public static function addParticleIconTextField(type:uint, positionInQueue:int, x:int, y:int, text:String, color:uint = 0, outlineColor:uint = 0, ttl:Number = 1000, xVelocity:int = 0, yVelocity:int = -1, size:int = 18, bold:Boolean = true, italic:Boolean = false, underline:Boolean = false) : Particle
      {
         var cParticle:Particle;
         if((cParticle = getCurrentParticle(type)) != null)
         {
            y -= 60;
            cParticle.mPosition.y = y;
            cParticle.mPosition.x = x;
            if(positionInQueue > 0)
            {
               while(!checkBoundaries(cParticle,2) || !checkBoundaries(cParticle,3) || !checkBoundaries(cParticle,4) || !checkBoundaries(cParticle,5))
               {
                  y += 30;
                  cParticle.mPosition.y = y;
               }
            }
            cParticle.activate(x,y,positionInQueue);
            cParticle.setTextFieldInfo(text,xVelocity,yVelocity,ttl,color,outlineColor,size,bold,italic,underline);
            return cParticle;
         }
         return null;
      }
      
      public static function addParticleBombTail(x:int, y:int, color:uint = 16711680) : BombTail
      {
         var cParticle:BombTail;
         if((cParticle = getCurrentParticle(19) as BombTail) != null)
         {
            cParticle.setColor(color);
            cParticle.activate(x,y);
            return cParticle;
         }
         return null;
      }
      
      public static function checkBoundaries(particle:Particle, type:int = -1) : Boolean
      {
         var i:int = 0;
         var particlesList:Vector.<Particle> = null;
         var p2:Particle = null;
         if(type == -1)
         {
            type = int(particle.mType);
         }
         particlesList = smParticles[type];
         var count:int = int(particlesList.length);
         for(i = 0; i < count; )
         {
            p2 = particlesList[i];
            if(particle != p2 && p2.mState != 0 && checkBoundariesBetweenParticles(particle,p2))
            {
               return false;
            }
            i++;
         }
         return true;
      }
      
      private static function checkBoundariesBetweenParticles(p1:Particle, p2:Particle) : Boolean
      {
         var renderer1:DCDisplayObject = p1.mCustomRenderData;
         var renderer2:DCDisplayObject = p2.mCustomRenderData;
         var x1:Number = p1.mPosition.x;
         var x2:Number = p2.mPosition.x;
         var y1:Number = p1.mPosition.y;
         var y2:Number = p2.mPosition.y;
         var w1:Number = p1.mCustomRenderWidth / 2;
         var h1:Number = p1.mCustomRenderHeight / 2;
         if(renderer1 != null)
         {
            w1 = renderer1.getMaxWidth() / 2;
            h1 = renderer1.getMaxHeight() / 2;
         }
         return Math.abs(x1 - x2) <= w1 && Math.abs(y1 - y2) <= h1;
      }
      
      public static function removeParticle(particle:Particle) : void
      {
         var particlesList:Vector.<Particle> = null;
         particlesList = smParticles[particle.mType];
         if(!particlesList.fixed)
         {
            particlesList.splice(particlesList.indexOf(particle),1);
            particle = null;
         }
      }
      
      public static function addParticleToVector(particle:Particle) : void
      {
         if(smParticlesActive.indexOf(particle) == -1)
         {
            smParticlesActive.push(particle);
         }
      }
      
      public static function isParticleAlive(particle:Particle) : Boolean
      {
         return Boolean(particle.mState);
      }
      
      public static function removeAllActiveParticles() : void
      {
         var i:int = 0;
         var particle:Particle = null;
         resetModularParticles();
         var particlesCount:int = int(smParticlesActive.length);
         smLaunchParticles = false;
         for(i = 0; i < particlesCount; )
         {
            particle = smParticlesActive[i];
            particle.deactivate();
            smParticlesActive.splice(i,1);
            particlesCount--;
         }
         smParticlesGiftActives = 0;
      }
      
      public static function launchParticle(currency:int, amount:int, item:WorldItemObject, posInQueue:int = 1, x:Number = 0, y:Number = 0, useScoreFormat:Boolean = false, randomizePlacement:Boolean = false, customColor:uint = 0) : void
      {
         var size:int = 0;
         var symbol:String = null;
         var color:* = 0;
         var outlineColor:* = 0;
         var particleText:String = null;
         var particleType:uint = 0;
         var particle:Particle = null;
         if(InstanceMng.getUnitScene().battleIsRunning())
         {
            if(amount == 0)
            {
               return;
            }
            switch(currency - 1)
            {
               case 0:
               case 1:
               case 9:
                  color = 16763955;
                  particleType = 2;
                  outlineColor = 0;
                  if(currency == 2)
                  {
                     color = 6546729;
                  }
                  if(currency == 10)
                  {
                     color = customColor;
                  }
                  break;
               case 5:
                  color = 14745599;
                  outlineColor = 18534;
                  particleType = 5;
            }
            if(useScoreFormat)
            {
               particleText = GameConstants.formatScoreValue(Math.abs(amount));
            }
            else
            {
               particleText = DCTextMng.convertNumberToString(Math.abs(amount),-1,-1);
            }
            symbol = amount < 0 ? "-" : "+";
         }
         else
         {
            if(amount < 0)
            {
               symbol = "-";
               color = 14822701;
               outlineColor = 4128768;
            }
            particleText = DCTextMng.convertNumberToString(Math.abs(amount),-1,-1);
            switch(currency - 1)
            {
               case 0:
                  if(amount > 0)
                  {
                     symbol = "+";
                     color = 16777165;
                     outlineColor = 5452288;
                  }
                  particleType = 3;
                  break;
               case 1:
                  if(amount > 0)
                  {
                     symbol = "+";
                     color = 6546729;
                     outlineColor = 20992;
                  }
                  particleType = 4;
                  break;
               case 5:
                  symbol = "+";
                  color = 14745599;
                  outlineColor = 18534;
                  particleType = 5;
            }
         }
         if(amount != 0)
         {
            if(item != null)
            {
               x = item.mViewCenterWorldX;
               y = item.mViewCenterWorldY;
               if(randomizePlacement)
               {
                  size = (item.mDef.getBaseRows() + item.mDef.getBaseCols()) / 2;
                  x += DCMath.randBetween(-size * 4,size * 4);
                  y += DCMath.randBetween(-size * 3,size * 2);
               }
            }
            if(isParticleAllowed(particleType))
            {
               particle = addParticleIconTextField(particleType,posInQueue,x,y,symbol + particleText,color,outlineColor);
            }
         }
      }
      
      public static function launchParticleTextFromItem(text:String, item:WorldItemObject) : void
      {
         addParticleTextField(2,item.mViewCenterWorldX,item.mViewCenterWorldY,text,16777165,0,1000);
      }
      
      private static function initModularParticles() : void
      {
         smAttackedItems = new Vector.<WorldItemObject>(0);
         smParticlesPerItemCount = new Vector.<int>(0);
         smParticlesTimer = new Vector.<int>(0);
         smMaxParticlesCount = new Vector.<int>(0);
      }
      
      private static function resetModularParticles() : void
      {
         if(smAttackedItems != null)
         {
            smAttackedItems.length = 0;
            smParticlesPerItemCount.length = 0;
            smParticlesTimer.length = 0;
            smMaxParticlesCount.length = 0;
         }
      }
      
      public static function startModularParticles(item:WorldItemObject) : void
      {
         if(smAttackedItems == null)
         {
            initModularParticles();
         }
         smLaunchParticles = true;
         smAttackedItems.push(item);
         smParticlesPerItemCount.push(0);
         smParticlesTimer.push(100);
         var particlesCount:int = item.mDef.getBaseCols() / 2 + 2;
         if(particlesCount == 0)
         {
            particlesCount = 1;
         }
         else if(particlesCount > 8)
         {
            particlesCount = 8;
         }
         smMaxParticlesCount.push(particlesCount);
      }
      
      override protected function setup() : void
      {
         super.setup();
         mBuildSyncTotalSteps = 1;
      }
      
      override protected function buildDoSyncStep(step:int) : void
      {
         var particlesOption:int = 0;
         var resourceMng:ResourceMng = null;
         if(step == 0 && InstanceMng.getEResourcesMng().isAssetLoaded("units_effects","legacy"))
         {
            resourceMng = InstanceMng.getResourceMng();
            if(resourceMng.isResourceLoaded("assets/flash/world_items/pngs_common/particle_coin.png") && resourceMng.isResourceLoaded("assets/flash/world_items/pngs_common/particle_resource.png") && resourceMng.isResourceLoaded("assets/flash/world_items/pngs_common/particle_experience.png") && resourceMng.isResourceLoaded("assets/flash/battle_effects/crater.png"))
            {
               particlesOption = InstanceMng.getUserInfoMng().getProfileLogin().getParticles();
               this.addParticlesToPool(0,[0,3,10][particlesOption]);
               this.addParticlesToPool(18,[0,3,10][particlesOption]);
               this.addParticlesToPool(1,0,true);
               this.addParticlesToPool(2,[0,3,25][particlesOption]);
               this.addParticlesToPool(3,[0,3,10][particlesOption]);
               this.addParticlesToPool(4,[0,3,10][particlesOption]);
               this.addParticlesToPool(5,[0,3,10][particlesOption]);
               this.addParticlesToPool(6,[0,5,15][particlesOption]);
               this.addParticlesToPool(7,[0,5,15][particlesOption]);
               this.addParticlesToPool(8,[0,7,20][particlesOption]);
               this.addParticlesToPool(9,[0,7,20][particlesOption]);
               this.addParticlesToPool(10,[0,7,20][particlesOption]);
               this.addParticlesToPool(11,[0,5,15][particlesOption]);
               this.addParticlesToPool(12,0,true);
               this.addParticlesToPool(13,[0,7,20][particlesOption]);
               this.addParticlesToPool(14,[0,7,20][particlesOption]);
               this.addParticlesToPool(15,[0,7,20][particlesOption]);
               this.addParticlesToPool(16,[0,7,20][particlesOption]);
               this.addParticlesToPool(17,[0,17,50][particlesOption]);
               this.addParticlesToPool(19,[0,17,50][particlesOption]);
               this.addParticlesToPool(20,[0,3,10][particlesOption]);
               this.addParticlesToPool(21,[0,3,10][particlesOption]);
               this.addParticlesToPool(23,[0,7,20][particlesOption]);
               this.addParticlesToPool(24,[0,7,20][particlesOption]);
               this.addParticlesToPool(25,[0,7,20][particlesOption]);
               buildAdvanceSyncStep();
            }
         }
      }
      
      override protected function unbuildDo() : void
      {
         var i:int = 0;
         var length:int = 0;
         var v:Vector.<Particle> = null;
         if(smParticles != null)
         {
            length = int(smParticles.length);
            for(i = 0; i < length; )
            {
               v = smParticles[i];
               if(v != null)
               {
                  smParticles[i] = null;
               }
               i++;
            }
         }
      }
      
      private function addParticlesToPool(type:int, num:int, checkBounds:Boolean = false) : void
      {
         var i:int = 0;
         smCheckBounds[type] = checkBounds;
         if(num == 0)
         {
            smParticles[type] = new Vector.<Particle>(0);
         }
         else
         {
            smParticles[type] = new Vector.<Particle>(num,true);
         }
         for(i = 0; i < num; )
         {
            addParticleType(type,i);
            i++;
         }
      }
      
      override protected function endDo() : void
      {
         removeAllActiveParticles();
      }
      
      override protected function logicUpdateDo(dt:int) : void
      {
         var i:int = 0;
         var cParticle:Particle = null;
         var particlesCount:int = int(smParticlesActive.length);
         for(i = 0; i < particlesCount; )
         {
            cParticle = smParticlesActive[i];
            cParticle.logicUpdate(dt);
            if(cParticle.mState == 0)
            {
               if(cParticle.mType == 11)
               {
                  smParticlesGiftActives--;
               }
               smParticlesActive.splice(i,1);
               i--;
               particlesCount--;
               removeParticle(cParticle);
            }
            i++;
         }
         this.modularParticlesUpdate(dt);
      }
      
      private function modularParticlesUpdate(dt:int) : void
      {
         var length:int = 0;
         var particleType:int = 0;
         var x:Number = NaN;
         var y:Number = NaN;
         var item:WorldItemObject = null;
         var i:int = 0;
         if(smAttackedItems != null)
         {
            length = int(smAttackedItems.length);
            for(i = 0; i < length; )
            {
               smParticlesTimer[i] -= dt;
               if(smParticlesTimer[i] <= 0)
               {
                  smParticlesTimer[i] = 100;
                  particleType = Math.random() * 4;
                  item = smAttackedItems[i];
                  x = item.mViewCenterWorldX - item.mBoundingBox.mWidth / 4 + Math.random() * (item.mBoundingBox.mWidth / 2);
                  y = item.mViewCenterWorldY - item.mBoundingBox.mHeight / 2 + Math.random() * (item.mBoundingBox.mHeight - 40);
                  addParticle(13 + particleType,x,y,1);
                  smParticlesPerItemCount[i]++;
                  if(smParticlesPerItemCount[i] == smMaxParticlesCount[i] && smLaunchParticles)
                  {
                     smParticlesPerItemCount.splice(i,1);
                     smAttackedItems.splice(i,1);
                     smParticlesTimer.splice(i,1);
                     smMaxParticlesCount.splice(i,1);
                     i--;
                     length = int(smAttackedItems.length);
                  }
               }
               i++;
            }
         }
      }
   }
}
