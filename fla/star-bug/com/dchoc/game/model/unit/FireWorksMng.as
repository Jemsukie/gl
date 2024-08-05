package com.dchoc.game.model.unit
{
   import com.dchoc.game.core.instance.InstanceMng;
   import com.dchoc.game.view.dc.mng.ViewMngPlanet;
   import com.dchoc.game.view.dc.mng.ViewMngrGame;
   import com.dchoc.toolkit.core.media.SoundManager;
   import com.dchoc.toolkit.core.view.display.DCDisplayObjectSWF;
   import flash.display.Shape;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class FireWorksMng
   {
      
      private static const colors:Array = new Array(16513824,16555578,14631167,15769376,909567,15688720,7335984,1376191,16717591,12250124,16719284);
      
      private static const FRIENDS_HUD_HEIGHT:int = 135;
      
      private static const NUM_FIRES:int = 13;
      
      private static var smInstance:FireWorksMng;
       
      
      private var mFireWorks:Vector.<FireWork>;
      
      private var mTimer:Vector.<int>;
      
      private var mCanvas:Shape;
      
      private var mDCCanvas:DCDisplayObjectSWF;
      
      private var mArePlaying:Boolean;
      
      private var mCreateMore:Boolean;
      
      private var mCurrentTimer:int;
      
      public function FireWorksMng()
      {
         super();
      }
      
      public static function getInstance() : FireWorksMng
      {
         if(smInstance == null)
         {
            smInstance = new FireWorksMng();
         }
         return smInstance;
      }
      
      public function init(timeToFinish:Number = -1, showInWorldLayer:Boolean = true) : void
      {
         var i:int = 0;
         var fire:FireWork = null;
         var viewMngPlanet:ViewMngPlanet = null;
         var viewPosX:int = 0;
         var viewPosY:int = 0;
         this.mFireWorks = new Vector.<FireWork>(13,true);
         this.mTimer = new Vector.<int>(13,true);
         this.mCanvas = new Shape();
         this.mDCCanvas = new DCDisplayObjectSWF(this.mCanvas);
         var width:int = InstanceMng.getViewMngGame().getStage().getImplementation().stageWidth;
         var height:int = InstanceMng.getViewMngGame().getStage().getImplementation().stageHeight - 135;
         for(i = 0; i < 13; )
         {
            fire = new FireWork(Math.random() * width,Math.random() * height,colors[int(Math.random() * colors.length)],colors[int(Math.random() * colors.length)]);
            this.mFireWorks[i] = fire;
            this.mTimer[i] = this.getTime();
            i++;
         }
         if(showInWorldLayer)
         {
            viewMngPlanet = InstanceMng.getViewMngPlanet();
            viewPosX = viewMngPlanet.screenToWorldX(0);
            viewPosY = viewMngPlanet.screenToWorldY(0);
            this.mDCCanvas.setXY(viewPosX,viewPosY);
         }
         InstanceMng.getViewMngGame().addFireworksToStage(this.mDCCanvas,showInWorldLayer);
         this.mArePlaying = true;
         this.mCreateMore = true;
         if(timeToFinish != -1)
         {
            this.mCurrentTimer = setTimeout(this.stop,timeToFinish);
         }
         if(Config.USE_SOUNDS)
         {
            SoundManager.getInstance().playSound("firework.mp3");
         }
      }
      
      public function reset(timeToFinish:int) : void
      {
         clearTimeout(this.mCurrentTimer);
         this.mCurrentTimer = setTimeout(this.stop,timeToFinish);
      }
      
      public function showFireworks(timeToFinish:int) : void
      {
         if(this.areFireworksRunning())
         {
            this.reset(timeToFinish);
         }
         else
         {
            this.init(timeToFinish);
         }
      }
      
      private function getTime() : int
      {
         return 500 + Math.random() * 10 * 200;
      }
      
      public function logicUpdate(dt:int) : void
      {
         var width:int = 0;
         var height:int = 0;
         var firesOver:int = 0;
         var i:int = 0;
         var time:int = 0;
         var fire:FireWork = null;
         if(this.mArePlaying)
         {
            this.mCanvas.graphics.clear();
            width = InstanceMng.getViewMngGame().getStage().getImplementation().stageWidth;
            height = InstanceMng.getViewMngGame().getStage().getImplementation().stageHeight - 135;
            firesOver = 0;
            for(i = 0; i < 13; )
            {
               if((time = this.mTimer[i]) == 0)
               {
                  (fire = this.mFireWorks[i]).logicUpdate(dt,this.mCanvas);
                  if(this.mCreateMore)
                  {
                     if(!fire.isAlive)
                     {
                        fire.resetFireWork(Math.random() * width,Math.random() * height,colors[int(Math.random() * colors.length)],colors[int(Math.random() * colors.length)]);
                        this.mTimer[i] = this.getTime();
                     }
                  }
                  else if(!fire.isAlive)
                  {
                     firesOver += 1;
                  }
               }
               else
               {
                  if((time -= dt) <= 0)
                  {
                     time = 0;
                  }
                  this.mTimer[i] = time;
               }
               i++;
            }
            if(firesOver == 13)
            {
               this.destroy();
            }
         }
      }
      
      public function stop() : void
      {
         if(this.mArePlaying == true)
         {
            this.mCreateMore = false;
         }
      }
      
      private function destroy() : void
      {
         var i:int = 0;
         this.mArePlaying = false;
         for(i = 0; i < 13; )
         {
            this.mFireWorks[i] = null;
            i++;
         }
         this.mFireWorks = null;
         this.mTimer = null;
         var viewMng:ViewMngrGame = InstanceMng.getViewMngGame();
         viewMng.removeFireworksFromStage(this.mDCCanvas);
         this.mCanvas = null;
         this.mDCCanvas = null;
         smInstance = null;
      }
      
      public function areFireworksRunning() : Boolean
      {
         return this.mArePlaying;
      }
   }
}
