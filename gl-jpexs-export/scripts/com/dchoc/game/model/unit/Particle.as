package com.dchoc.game.model.unit
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.eview.facade.TopHudFacade;
   import com.dchoc.game.model.items.ItemObject;
   import com.dchoc.game.view.facade.UIFacade;
   import com.dchoc.toolkit.core.media.SoundManager;
   import com.dchoc.toolkit.core.text.DCTextMng;
   import com.dchoc.toolkit.core.view.display.DCBitmapMovieClip;
   import com.dchoc.toolkit.core.view.display.DCDisplayObject;
   import com.dchoc.toolkit.utils.math.geom.DCCoordinate;
   import esparragon.display.ESpriteContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   import flash.text.TextField;
   import flash.text.TextFormat;
   
   public class Particle
   {
      
      public static const STATE_DISABLED:uint = 0;
      
      public static const STATE_ENABLED:uint = 1;
      
      public static const STATE_FALLING:uint = 2;
      
      public static const STATE_WAITING:uint = 3;
      
      public static const STATE_CLICKED:uint = 4;
      
      public static const STATE_COLLECTING:uint = 5;
      
      public static const STATE_COLLECTING_FADING:uint = 6;
      
      public static const TTL_DEFAULT:Number = 1000;
      
      public static const TTL_GIFT:Number = 10000;
      
      public static const TTL_CRATER:Number = 3000;
      
      public static const TTL_INFINITE:Number = 1.7976931348623157e+308;
      
      public static const COLOR_BLACK:uint = 0;
      
      public static const COLOR_GREEN:uint = 6546729;
      
      public static const COLOR_GOLD:uint = 16777165;
      
      public static const COLOR_BLUE:uint = 14745599;
      
      public static const COLOR_RED:uint = 14822701;
      
      public static const COLOR_STEALING:uint = 16763955;
      
      public static const COLOR_OUTLINE_GREEN:uint = 20992;
      
      public static const COLOR_OUTLINE_GOLD:uint = 5452288;
      
      public static const COLOR_OUTLINE_BLUE:uint = 18534;
      
      public static const COLOR_OUTLINE_RED:uint = 4128768;
      
      public static const COLOR_OUTLINE_BLACK:uint = 0;
      
      public static const GIFT_TIME_CLICK:int = 300;
      
      public static var smGiftCashOffset:int = 0;
      
      private static const GIFT_TIME_TO_DEST:int = 600;
      
      private static const GIFT_FADE_SPEED:Number = 0.0016666666666666668;
       
      
      public var mType:uint;
      
      public var mState:uint;
      
      private var mFilters:Array;
      
      private var mOutlineFilter:GlowFilter;
      
      public var mPosition:Vector3D;
      
      public var mVelocity:Vector3D;
      
      public var mAcceleration:Vector3D;
      
      private var mFriction:Number;
      
      public var mTextField:TextField;
      
      public var mCustomRenderData:DCDisplayObject;
      
      public var mCustomRenderWidth:int = 35;
      
      public var mCustomRenderHeight:int = 45;
      
      public var mFrameCount:int = 18;
      
      protected var mFrame:uint;
      
      private var mFrameSustain:int;
      
      private var mFrameDelay:int;
      
      public var mTTL:Number;
      
      public var mAngle:Number;
      
      public var mPositionInQueue:int = 1;
      
      private var mCoord:DCCoordinate;
      
      private var mSpecialCoords:DCCoordinate;
      
      private var mGiftSprite:Sprite;
      
      private var mGiftWaitTimer:Number;
      
      private var mGiftBound:int;
      
      private var mGiftBoundEnabled:Boolean;
      
      private var mGiftBoundStep:int;
      
      private var mGiftOriginX:Number;
      
      private var mGiftOriginY:Number;
      
      private var mGiftDestX:Number;
      
      private var mGiftDestY:Number;
      
      private var mGiftCurrentTime:int;
      
      private var mItemGift:ItemObject;
      
      private var mMaxItems:int;
      
      private var mItemIndex:int;
      
      private var mVelocityYInit:int;
      
      public function Particle(type:uint)
      {
         super();
         this.mPosition = new Vector3D();
         this.mVelocity = new Vector3D();
         this.mAcceleration = new Vector3D();
         this.mFriction = 0.96;
         this.mType = type;
         this.mCoord = new DCCoordinate();
         this.mSpecialCoords = new DCCoordinate();
         this.mPosition.x = 0;
         this.mPosition.y = 0;
         this.mAngle = 0;
      }
      
      public static function getColorFromCurrencyId(incomeCurrencyId:int) : uint
      {
         switch(incomeCurrencyId)
         {
            case 0:
               return 16777165;
            case 1:
               return 16777165;
            case 2:
               return 6546729;
            case 4:
               return 14822701;
            default:
               return 0;
         }
      }
      
      public static function getOutlineColorFromCurrencyId(incomeCurrencyId:int) : uint
      {
         switch(incomeCurrencyId)
         {
            case 0:
               return 5452288;
            case 1:
               return 5452288;
            case 2:
               return 20992;
            case 4:
               return 4128768;
            default:
               return 0;
         }
      }
      
      private function setupFilters(outlineColor:uint) : void
      {
         this.mTextField.filters = null;
         this.mFilters = this.mTextField.filters;
         var glow:GlowFilter = ParticleMng.smGlowsDictionary[outlineColor];
         if(glow == null)
         {
            glow = new GlowFilter(outlineColor,255,3,3,5,3);
            ParticleMng.smGlowsDictionary[outlineColor] = glow;
         }
         this.mOutlineFilter = glow;
         this.mFilters.push(this.mOutlineFilter);
      }
      
      public function createTextField() : void
      {
         this.mTextField = new TextField();
         this.mTextField.selectable = false;
         this.mTextField.autoSize = "left";
         this.mTextField.defaultTextFormat = new TextFormat("font_esparragon");
         this.mTextField.embedFonts = true;
      }
      
      public function activate(x:int, y:int, positionInQueue:int = 1, frameTicks:int = 50) : Boolean
      {
         var angleOffset:Number = NaN;
         var currentAngle:Number = NaN;
         var velocity:Number = NaN;
         this.mPositionInQueue = positionInQueue;
         var verticalOffsetForQueuedParticles:int = this.mPositionInQueue * 35;
         this.mPosition.x = x;
         this.mPosition.y = y;
         this.mPosition.z = 0;
         this.mVelocity.x = 0;
         this.mVelocity.y = 0;
         this.mVelocity.z = 0;
         this.mAcceleration.x = 0;
         this.mAcceleration.y = 0;
         this.mAcceleration.z = 0;
         if(this.mCustomRenderData != null)
         {
            this.mCustomRenderData.x = this.mPosition.x;
            this.mCustomRenderData.y = this.mPosition.y;
         }
         this.mFrameSustain = 1000 / (25 / (frameTicks + 1));
         this.mFrame = 0;
         this.mState = 1;
         switch(int(this.mType) - 1)
         {
            case 0:
               this.mCustomRenderData.visible = true;
               break;
            case 1:
               this.mTextField.x = x;
               this.mTextField.y = y;
               DCTextMng.setText(this.mTextField,"");
               this.mTextField.visible = true;
               break;
            case 2:
            case 3:
            case 4:
               this.mTextField.x = x;
               this.mTextField.y = y - verticalOffsetForQueuedParticles;
               DCTextMng.setText(this.mTextField,"");
               this.mTextField.visible = true;
               this.mCustomRenderData.visible = true;
               break;
            case 10:
               if(this.mItemGift.isAChipCollectable())
               {
                  smGiftCashOffset++;
               }
               this.mTTL = 1.7976931348623157e+308;
               this.mCustomRenderData.visible = true;
               currentAngle = (angleOffset = 360 / this.mMaxItems) * this.mItemIndex * 3.141592653589793 / 180;
               velocity = 2 + Math.random() * 3;
               this.mVelocity.x = Math.cos(currentAngle) * velocity;
               this.mVelocity.y = -10;
               this.mVelocity.z = Math.sin(currentAngle) * velocity;
               this.mVelocityYInit = -10;
               this.mAcceleration.x = 0;
               this.mAcceleration.y = 1;
               this.mAcceleration.z = 0;
               this.mState = 2;
               if(this.mGiftSprite == null)
               {
                  this.mGiftSprite = this.mCustomRenderData.getDisplayObject() as Sprite;
               }
               this.mGiftSprite.scaleX = 0.5;
               this.mGiftSprite.scaleY = 0.5;
               this.mGiftSprite.addEventListener("mouseOver",this.onMouseOver);
               this.mGiftSprite.addEventListener("mouseMove",this.onMouseOver);
               break;
            case 11:
               this.mTTL = 3000;
               this.mCustomRenderData.alpha = 1;
               this.mCustomRenderData.visible = true;
               this.mCustomRenderData.x = this.mPosition.x - this.mCustomRenderData.getCurrentFrameWidth() / 2;
               this.mCustomRenderData.y = this.mPosition.y - this.mCustomRenderData.getCurrentFrameHeight() / 2;
               break;
            case 16:
               this.mTTL = 1.7976931348623157e+308;
               this.mCustomRenderData.visible = true;
               this.mCustomRenderData.x = this.mPosition.x;
               this.mCustomRenderData.y = this.mPosition.y;
               break;
            default:
               this.mTTL = 1.7976931348623157e+308;
         }
         if(!ParticleMng.smCheckBounds[this.mType] || ParticleMng.checkBoundaries(this))
         {
            InstanceMng.getViewMngPlanet().particlesAddToStage(this);
            ParticleMng.addParticleToVector(this);
            return true;
         }
         return false;
      }
      
      public function logicUpdate(dt:int) : void
      {
         var verticalOffsetForQueuedParticles:int = 0;
         if(this.mState == 0)
         {
            return;
         }
         switch(int(this.mType) - 11)
         {
            case 0:
               this.giftUpdate(dt);
               return;
            case 1:
               if(this.mTTL > 0)
               {
                  this.mTTL -= dt;
                  if(this.mTTL <= 0)
                  {
                     this.mTTL = 0;
                  }
               }
               else
               {
                  this.mCustomRenderData.alpha -= 0.05;
                  if(this.mCustomRenderData.alpha <= 0)
                  {
                     this.deactivate();
                  }
               }
               return;
            default:
               this.physicsUpdate(dt / 10);
               verticalOffsetForQueuedParticles = this.mPositionInQueue * 35;
               this.mCoord.x = this.mPosition.x;
               this.mCoord.y = this.mPosition.y;
               if(this.mTTL != 1.7976931348623157e+308)
               {
                  this.mTTL -= dt;
                  if(this.mTTL <= 0)
                  {
                     this.mTTL = 0;
                     this.deactivate();
                     return;
                  }
               }
               switch(int(this.mType) - 2)
               {
                  case 0:
                     this.mTextField.x = this.mCoord.x;
                     this.mTextField.y = this.mCoord.y;
                     break;
                  case 1:
                  case 2:
                  case 3:
                     this.mTextField.x = this.mCoord.x;
                     this.mTextField.y = this.mCoord.y - verticalOffsetForQueuedParticles;
                     this.mSpecialCoords.x = this.mPosition.x;
                     this.mSpecialCoords.y = this.mPosition.y - verticalOffsetForQueuedParticles;
                     this.mCustomRenderData.x = this.mSpecialCoords.x - (this.mCustomRenderWidth + 5);
                     this.mCustomRenderData.y = this.mSpecialCoords.y;
                     this.mCustomRenderData.getLayerParent().mMustDraw = true;
                     break;
                  default:
                     if(this.mFrame < this.mFrameCount)
                     {
                        if(this.mCustomRenderData is DCBitmapMovieClip)
                        {
                           this.mCustomRenderData.gotoAndStop(this.mFrame + 1);
                           this.mCustomRenderData.x = this.mCoord.x;
                           this.mCustomRenderData.y = this.mCoord.y;
                           if(this.mFrameDelay <= 0)
                           {
                              this.mFrame++;
                              this.mFrameDelay = this.mFrameSustain;
                           }
                           else
                           {
                              this.mFrameDelay -= dt;
                           }
                        }
                        else
                        {
                           this.mCustomRenderData.currentFrame = this.mFrame++;
                           this.mCustomRenderData.x = this.mCoord.x - this.mCustomRenderWidth / 2;
                           this.mCustomRenderData.y = this.mCoord.y - this.mCustomRenderHeight / 2;
                        }
                        this.mCustomRenderData.getLayerParent().mMustDraw = true;
                        break;
                     }
                     this.deactivate();
                     return;
               }
               return;
         }
      }
      
      private function giftUpdate(dt:Number) : void
      {
         switch(int(this.mState) - 2)
         {
            case 0:
               if(this.mGiftSprite.scaleX < 1)
               {
                  this.mGiftSprite.scaleX += 0.025;
                  this.mGiftSprite.scaleY += 0.025;
                  if(this.mGiftSprite.scaleX > 1)
                  {
                     this.mGiftSprite.scaleX = 1;
                     this.mGiftSprite.scaleY = 1;
                  }
               }
               this.mPosition.x += this.mVelocity.x;
               this.mPosition.y += this.mVelocity.y;
               this.mPosition.z += this.mVelocity.z;
               this.mVelocity.x += this.mAcceleration.x;
               this.mVelocity.y += this.mAcceleration.y;
               this.mVelocity.z += this.mAcceleration.z;
               if(this.mVelocity.y >= -this.mVelocityYInit)
               {
                  this.mVelocityYInit /= 2;
                  if(this.mVelocityYInit > -2)
                  {
                     this.mVelocity.y = 0;
                     this.mState = 3;
                     this.mGiftWaitTimer = 10000;
                     this.mGiftBound = 0;
                     this.mGiftBoundEnabled = false;
                  }
                  else
                  {
                     this.mVelocity.y = this.mVelocityYInit;
                  }
               }
               this.mCustomRenderData.x = this.mPosition.x - this.mCustomRenderData.getCurrentFrameWidth() / 2;
               this.mCustomRenderData.y = this.mPosition.y - this.mCustomRenderData.getCurrentFrameHeight() / 2 - this.mPosition.z;
               break;
            case 1:
               this.mGiftWaitTimer -= dt;
               if(this.mGiftBound == 0 && this.mGiftWaitTimer <= 7000 || this.mGiftBound == 1 && this.mGiftWaitTimer <= 3000)
               {
                  this.mGiftBound++;
                  this.mGiftBoundEnabled = true;
                  this.mVelocity.y = -4;
                  this.mAcceleration.y = 0.6;
                  this.mGiftBoundStep = 0;
               }
               if(this.mGiftBoundEnabled)
               {
                  this.mCustomRenderData.y += this.mVelocity.y;
                  this.mVelocity.y += this.mAcceleration.y;
                  if(this.mVelocity.y > 4)
                  {
                     this.mGiftBoundStep++;
                     if(this.mGiftBoundStep == 2)
                     {
                        this.mGiftBoundEnabled = false;
                     }
                     else
                     {
                        this.mVelocity.y = -4;
                        this.mAcceleration.y = 0.5;
                     }
                  }
               }
               if(this.mGiftWaitTimer <= 0)
               {
                  if(InstanceMng.getPopupMng().getPopupBeingShown() != null)
                  {
                     this.removeGiftListeners();
                     this.deactivate();
                     InstanceMng.getViewMngPlanet().particlesRemoveFromStage(this);
                  }
                  else
                  {
                     this.onGiftClick();
                  }
               }
               break;
            case 3:
               this.giftMoving(dt);
         }
      }
      
      private function removeGiftListeners() : void
      {
         this.mGiftSprite.removeEventListener("mouseOver",this.onMouseOver);
         this.mGiftSprite.removeEventListener("mouseMove",this.onMouseOver);
      }
      
      private function onGiftClick(mEvent:MouseEvent = null) : void
      {
         this.removeGiftListeners();
         this.giftStartMoving();
      }
      
      private function giftStartMoving() : void
      {
         var coll:Point = null;
         var BOX_OFFSET:int = 70;
         var hud:TopHudFacade = InstanceMng.getTopHudFacade();
         var uiFacade:UIFacade = InstanceMng.getUIFacade();
         if(this.mGiftSprite.scaleX < 1)
         {
            this.mGiftSprite.scaleX = 1;
            this.mGiftSprite.scaleY = 1;
         }
         if(this.mCustomRenderData.getDisplayObject().parent == null)
         {
            this.deactivate();
            InstanceMng.getViewMngPlanet().particlesRemoveFromStage(this);
            return;
         }
         var crDataPos:Point = new Point(this.mCustomRenderData.x,this.mCustomRenderData.y);
         crDataPos = this.mCustomRenderData.getDisplayObject().parent.localToGlobal(crDataPos);
         var offsetX:Number = 0;
         var offsetY:Number = 0;
         coll = new Point(0,0);
         if(this.mItemGift.mDef.getMenusList().indexOf("collectable") > -1)
         {
            hud.collectiblesSetCollection(this.mItemGift.mDef.mSku,true);
            hud.collectiblesResetTimer();
            offsetX = uiFacade.collectiblesGetCollectablePosition(this.mItemGift.mDef.mSku) * BOX_OFFSET + this.mCustomRenderData.getCurrentFrameWidth() / 2;
            offsetY = this.mCustomRenderData.getCurrentFrameHeight() / 2;
            if(!hud.isCollectiblesShown())
            {
               hud.collectiblesShow();
            }
            if(this.mItemGift.mDef.getShowInInventory())
            {
               this.mItemGift.mVisualStarIconAmount.value++;
               InstanceMng.getApplication().showInventoryStar(this.mItemGift);
            }
            coll = uiFacade.getCollectionPanelPositionAbsolute();
         }
         else if(this.mItemGift.mDef.getMenusList().indexOf("contest") > -1)
         {
            coll = uiFacade.getContestToolContainerPositionCentered();
         }
         else if(this.mItemGift.mDef.isDroidPart())
         {
            hud.workersResetTimer();
            offsetX = uiFacade.workerCollectiblesGetCollectablePosition(this.mItemGift.mDef.mSku) * BOX_OFFSET + this.mCustomRenderData.getCurrentFrameWidth() / 2;
            if(!hud.isWorkerCollectiblesShown())
            {
               hud.workerCollectiblesSetCollection(this.mItemGift.mDef.mSku,true);
               hud.workerCollectiblesShow();
            }
            if(InstanceMng.getItemsMng().incrementItemAmount(this.mItemGift))
            {
               if(this.mItemGift.mDef.getShowInInventory())
               {
                  InstanceMng.getApplication().showInventoryStar(this.mItemGift);
               }
               this.mItemGift.quantity--;
            }
            coll = uiFacade.getWorkerCollectionPanelPositionAbsolute();
         }
         else if(this.mItemGift.isAChipCollectable())
         {
            coll = InstanceMng.getUIFacade().getCashContainerPosition();
         }
         else if(this.mItemGift.mDef.getMenusList().indexOf("crafting") > -1)
         {
            hud.craftingSetCollection(this.mItemGift.mDef.mSku,true);
            hud.craftingResetTimer();
            offsetX = uiFacade.craftingGetCollectablePosition(this.mItemGift.mDef.mSku) * BOX_OFFSET + this.mCustomRenderData.getCurrentFrameWidth() / 2;
            offsetY = this.mCustomRenderData.getCurrentFrameHeight() / 2;
            if(!hud.isCraftingShown())
            {
               hud.craftingShow();
            }
            if(this.mItemGift.mDef.getShowInInventory())
            {
               this.mItemGift.mVisualStarIconAmount.value++;
               InstanceMng.getApplication().showInventoryStar(this.mItemGift);
            }
            coll = uiFacade.getCraftingPanelPositionAbsolute();
         }
         else
         {
            if(InstanceMng.getItemsMng().incrementItemAmount(this.mItemGift))
            {
               if(this.mItemGift.mDef.getShowInInventory())
               {
                  InstanceMng.getApplication().showInventoryStar(this.mItemGift);
               }
               this.mItemGift.quantity--;
            }
            if(InstanceMng.getRole().mId != 0)
            {
               coll = new Point(InstanceMng.getApplication().stageGetWidth() / 2,InstanceMng.getApplication().stageGetHeight());
            }
            else
            {
               coll = InstanceMng.getUIFacade().getInventoryContainerPositionCentered();
            }
         }
         coll.x += offsetX;
         coll.y += offsetY;
         this.mGiftOriginX = crDataPos.x;
         this.mGiftOriginY = crDataPos.y;
         this.mGiftDestX = coll.x;
         this.mGiftDestY = coll.y;
         var distanceX:Number = coll.x - this.mGiftOriginX;
         var distanceY:Number = coll.y - this.mGiftOriginY;
         var MAX_DIST:int = 760;
         var GRAVITY:Number = -0.0009;
         this.mVelocity.x = distanceX / 600;
         this.mVelocity.y = distanceY / 600;
         this.mVelocity.z = -GRAVITY * 600 * 0.5;
         this.mAcceleration.x = 0;
         this.mAcceleration.y = 0;
         this.mAcceleration.z = GRAVITY;
         InstanceMng.getViewMngPlanet().particlesRemoveFromStage(this);
         InstanceMng.getViewMngPlanet().addHud(this.mCustomRenderData);
         this.mCustomRenderData.x = crDataPos.x;
         this.mCustomRenderData.y = crDataPos.y;
         this.mPosition.x = crDataPos.x;
         this.mPosition.y = crDataPos.y;
         this.mPosition.z = 0;
         this.mGiftCurrentTime = 0;
         this.mState = 5;
         if(Config.USE_SOUNDS)
         {
            SoundManager.getInstance().playSound("collect_item.mp3");
         }
      }
      
      private function giftMoving(dt:int) : void
      {
         this.mGiftCurrentTime += dt;
         this.mPosition.x = this.mGiftOriginX + this.mVelocity.x * this.mGiftCurrentTime;
         this.mPosition.y = this.mGiftOriginY + this.mVelocity.y * this.mGiftCurrentTime;
         this.mPosition.z = this.mVelocity.z * this.mGiftCurrentTime + 0.5 * this.mAcceleration.z * this.mGiftCurrentTime * this.mGiftCurrentTime;
         this.mCustomRenderData.y = this.mPosition.y + this.mPosition.z;
         this.mCustomRenderData.x = this.mPosition.x;
         if(this.mPosition.z <= 0)
         {
            this.deactivateGift();
         }
      }
      
      private function deactivateGift() : void
      {
         if(this.mItemGift.mDef.getMenusList().indexOf("collectable") > -1)
         {
            InstanceMng.getTopHudFacade().collectiblesSetCollection(this.mItemGift.mDef.mSku,false);
         }
         else if(this.mItemGift.mDef.isDroidPart())
         {
            InstanceMng.getTopHudFacade().workerCollectiblesSetCollection(this.mItemGift.mDef.mSku,false);
         }
         else if(this.mItemGift.isAChipCollectable())
         {
            smGiftCashOffset--;
            if(smGiftCashOffset < 0)
            {
               smGiftCashOffset = 0;
            }
            InstanceMng.getTopHudFacade().setHudCash(InstanceMng.getUserInfoMng().getProfileLogin().getCash());
         }
         this.deactivate();
      }
      
      public function setCurrentGift(item:ItemObject) : void
      {
         this.mItemGift = item;
      }
      
      public function setMaxItemsPerTimeAndIndex(maxItems:int = 1, index:int = 0) : void
      {
         this.mMaxItems = maxItems;
         this.mItemIndex = index;
      }
      
      private function onMouseOver(mEvent:MouseEvent) : void
      {
         var mouseCoord:Point = new Point(mEvent.localX - 10 / 2,mEvent.localY - 10 / 2);
         var spriteCoord:Point = new Point(this.mGiftSprite.x - this.mGiftSprite.width / 2,this.mGiftSprite.y - this.mGiftSprite.height / 2);
         spriteCoord = this.mGiftSprite.parent.localToGlobal(spriteCoord);
         mouseCoord = this.mGiftSprite.localToGlobal(mouseCoord);
         this.onGiftClick(mEvent);
      }
      
      public function physicsUpdate(dt:Number) : void
      {
         this.mVelocity.y *= this.mFriction;
         this.mPosition.x += this.mVelocity.x * dt;
         this.mPosition.y += this.mVelocity.y * dt;
         this.mPosition.z += this.mVelocity.z * dt;
         this.mVelocity.x += this.mAcceleration.x * dt;
         this.mVelocity.y += this.mAcceleration.y * dt;
         this.mVelocity.z += this.mAcceleration.z * dt;
         if(this.mTTL < 1000 / 4)
         {
            switch(int(this.mType) - 2)
            {
               case 0:
                  this.mTextField.alpha = this.mTTL / (1000 / 4);
                  break;
               case 1:
               case 2:
               case 3:
                  this.mTextField.alpha = this.mTTL / (1000 / 4);
                  this.mCustomRenderData.alpha = this.mTTL / (1000 / 4);
            }
         }
      }
      
      public function deactivate() : void
      {
         var cont:ESpriteContainer = null;
         this.mState = 0;
         this.mAcceleration.x = 0;
         this.mAcceleration.y = 0;
         this.mAcceleration.z = 0;
         this.mVelocity.x = 0;
         this.mVelocity.y = 0;
         this.mVelocity.z = 0;
         switch(int(this.mType) - 2)
         {
            case 0:
               this.mTextField.visible = false;
               this.mTextField.alpha = 1;
               break;
            case 1:
            case 2:
            case 3:
               this.mTextField.visible = false;
               this.mTextField.alpha = 1;
               this.mCustomRenderData.visible = false;
               this.mCustomRenderData.alpha = 1;
               break;
            default:
               this.mCustomRenderData.alpha = 1;
         }
         InstanceMng.getViewMngPlanet().particlesRemoveFromStage(this);
         if(this.mType == 11)
         {
            InstanceMng.getViewMngPlanet().removeHud(this.mGiftSprite);
            cont = this.mGiftSprite.getChildAt(0) as ESpriteContainer;
            this.mGiftSprite.removeChild(cont);
            cont.destroy();
            cont = null;
         }
      }
      
      public function setTextFieldInfo(text:String, xVelocity:Number = 0, yVelocity:Number = -1, ttl:Number = 1000, color:uint = 0, outlineColor:uint = 0, size:int = 12, bold:Boolean = false, italic:Boolean = false, underline:Boolean = false) : void
      {
         this.mVelocity = new Vector3D(xVelocity,yVelocity);
         this.mTTL = ttl;
         this.concatenateText(text,color,outlineColor,size,bold,italic,underline);
      }
      
      public function concatenateText(text:String, color:uint = 0, outlineColor:uint = 0, size:int = 10, bold:Boolean = false, italic:Boolean = false, underline:Boolean = false) : void
      {
         var format:TextFormat = null;
         DCTextMng.setText(this.mTextField,text);
         var nTextLength:int;
         if((nTextLength = this.mTextField.text.length) > 0)
         {
            (format = this.mTextField.defaultTextFormat).color = color;
            format.size = size;
            format.bold = bold;
            format.italic = italic;
            format.underline = underline;
            this.mTextField.setTextFormat(format,0,nTextLength);
            this.setupFilters(outlineColor);
            this.mTextField.filters = this.mFilters;
         }
      }
      
      public function setFrameRate(time:int) : void
      {
         this.mFrameSustain = 1000 / (25 / (time + 1));
      }
   }
}
