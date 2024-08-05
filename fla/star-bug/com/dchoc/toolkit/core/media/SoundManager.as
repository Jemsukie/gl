package com.dchoc.toolkit.core.media
{
   import com.dchoc.toolkit.core.debug.DCDebug;
   import com.dchoc.toolkit.core.resource.DCResourceMng;
   import com.gskinner.motion.GTween;
   import flash.events.Event;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundLoaderContext;
   import flash.media.SoundTransform;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   
   public class SoundManager
   {
      
      public static const SOUND_INITIAL_VOLUME:Number = 1;
      
      public static const TYPE_MUSIC:int = 0;
      
      public static const TYPE_SFX:int = 1;
      
      public static const TYPE_MUSIC_KEY:String = "music";
      
      public static const TYPE_SFX_KEY:String = "sfx";
      
      private static var mInstance:SoundManager;
      
      private static var mAllowInstance:Boolean;
      
      private static const MAX_SOUNDS_COUNT:int = 16;
       
      
      private var mMusicOn:Boolean;
      
      private var mSfxOn:Boolean;
      
      private var mSoundOn:Boolean;
      
      private var mSoundsDictionary:Dictionary;
      
      private var mSounds:Array;
      
      private var mLastMusic:String;
      
      private var mSoundsCount:int;
      
      private var mGeneralVolume:Number;
      
      private var mMusicVolume:Number;
      
      private var mSfxVolume:Number;
      
      private var mSoundLooping:Dictionary;
      
      private var mExceptionSounds:Array;
      
      private var mSFXSpecialVolume:Number = -1;
      
      public var mMusicDisabledByExtNotification:Boolean = false;
      
      public var mSfxDisabledByExtNotification:Boolean = false;
      
      private var mDelayedSoundsCatalog:Dictionary;
      
      public function SoundManager()
      {
         super();
         if(!SoundManager.mAllowInstance)
         {
            throw new Error("ERROR: SoundManager Error: Instantiation failed: Use SoundManager.getInstance() instead of new.");
         }
         this.mMusicOn = true;
         this.mSfxOn = true;
         this.mSoundOn = true;
         this.mSoundsDictionary = new Dictionary(true);
         this.mSounds = [];
         this.mSoundLooping = new Dictionary(true);
         this.mLastMusic = "";
         this.mSoundsCount = 0;
         this.mGeneralVolume = 1;
         this.mMusicVolume = 1;
         this.mSfxVolume = 1;
      }
      
      public static function getTypeIdFromKey(key:String) : int
      {
         var returnValue:int = -1;
         switch(key)
         {
            case "music":
               returnValue = 0;
               break;
            case "sfx":
               returnValue = 1;
         }
         return returnValue;
      }
      
      public static function getInstance() : SoundManager
      {
         if(SoundManager.mInstance == null)
         {
            SoundManager.mAllowInstance = true;
            SoundManager.mInstance = new SoundManager();
            SoundManager.mAllowInstance = false;
         }
         return SoundManager.mInstance;
      }
      
      public function addLibrarySound(linkageID:*, name:String, type:int) : Boolean
      {
         if(this.soundExists(name))
         {
            return false;
         }
         var snd:Sound = new linkageID();
         this.createSound(snd,name,type);
         return true;
      }
      
      public function addExternalSound(path:String, name:String, type:int, buffer:Number = 1000, checkPolicyFile:Boolean = false) : Boolean
      {
         var snd:Sound = null;
         if(this.soundExists(name))
         {
            return false;
         }
         try
         {
            snd = new Sound(new URLRequest(path),new SoundLoaderContext(buffer,checkPolicyFile));
            this.createSound(snd,name,type);
         }
         catch(e:Error)
         {
            DCDebug.trace("IOStream error, probably the path doesn\'t exist: " + path);
         }
         return true;
      }
      
      private function createSound(snd:Sound, name:String, type:int) : void
      {
         var soundObject:Object;
         (soundObject = {}).name = name;
         soundObject.sound = snd;
         soundObject.channel = new SoundChannel();
         soundObject.position = 0;
         soundObject.paused = false;
         soundObject.stopped = true;
         soundObject.volume = 1;
         soundObject.startTime = 0;
         soundObject.loops = 0;
         soundObject.type = type;
         soundObject.length = 0;
         this.mSoundsDictionary[name] = soundObject;
         this.mSounds.push(soundObject);
      }
      
      private function soundCompleteHandler(event:Event) : void
      {
         var object:Object = null;
         var channel:SoundChannel = null;
         var targetChannel:SoundChannel = null;
         for each(object in this.mSoundsDictionary)
         {
            channel = object.channel as SoundChannel;
            targetChannel = event.target as SoundChannel;
            if(targetChannel == channel)
            {
               targetChannel.removeEventListener("soundComplete",this.soundCompleteHandler);
               object.channel = object.sound.play(0,object.loops,new SoundTransform(this.calcOutputVolume(object.volume,object.type)));
               object.length = object.sound.length;
               object.channel.addEventListener("soundComplete",this.soundCompleteHandler);
            }
         }
      }
      
      public function soundExists(name:String) : Boolean
      {
         var i:int = 0;
         for(i = 0; i < this.mSounds.length; )
         {
            if(this.mSounds[i].name == name)
            {
               return true;
            }
            i++;
         }
         return false;
      }
      
      public function removeSound(name:String) : void
      {
         var i:int = 0;
         for(i = 0; i < this.mSounds.length; )
         {
            if(this.mSounds[i].name == name)
            {
               this.mSounds[i] = null;
               this.mSounds.splice(i,1);
            }
            i++;
         }
         delete this.mSoundsDictionary[name];
      }
      
      public function removeAll() : void
      {
         var i:int = 0;
         for(i = 0; i < this.mSounds.length; )
         {
            this.mSounds[i] = null;
            i++;
         }
         this.mSounds = [];
         this.mSoundsDictionary = new Dictionary(true);
      }
      
      public function playSound(name:String, volume:Number = 1, startTime:Number = 0, loops:int = 0, type:int = 1) : void
      {
         var soundObject:Object = null;
         var applySpecialVolume:* = false;
         try
         {
            if(name == null || this.mSoundsDictionary == null)
            {
               return;
            }
            if(!this.soundExists(name))
            {
               this.addExternalSound(DCResourceMng.getFileName("sounds/" + name),name,type);
            }
            if((soundObject = this.mSoundsDictionary[name]) == null)
            {
               return;
            }
            if(this.mExceptionSounds != null)
            {
               if((applySpecialVolume = this.mExceptionSounds.indexOf(name) == -1) && this.mSFXSpecialVolume != -1)
               {
                  volume = this.mSFXSpecialVolume;
               }
            }
            soundObject.volume = volume;
            soundObject.startTime = startTime;
            soundObject.loops = loops;
            if(soundObject.type == 0)
            {
               if(!this.isMusicOn() || !this.isSoundOn())
               {
                  soundObject.stopped = false;
                  soundObject.paused = true;
               }
               if(this.mLastMusic == name && !soundObject.stopped)
               {
                  return;
               }
               this.mLastMusic = name;
               this.mSoundLooping[name] = loops;
               if(soundObject.stopped)
               {
                  soundObject.channel = soundObject.sound.play(startTime,soundObject.loops,new SoundTransform(this.calcOutputVolume(soundObject.volume,soundObject.type)));
                  soundObject.stopped = false;
               }
            }
            else if(soundObject.type == 1)
            {
               if(!this.isSfxOn() || !this.isSoundOn())
               {
                  return;
               }
               if(!soundObject.stopped)
               {
                  if(this.mSoundsCount > 16)
                  {
                     return;
                  }
                  this.mSoundsCount++;
               }
               soundObject.channel = soundObject.sound.play(startTime,soundObject.loops,new SoundTransform(this.calcOutputVolume(soundObject.volume,soundObject.type)));
               soundObject.stopped = false;
            }
            if(loops < 0)
            {
               soundObject.channel.addEventListener("soundComplete",this.soundCompleteHandler);
            }
            else if(soundObject.type == 1)
            {
               soundObject.channel.addEventListener("soundComplete",this.checkSoundEnd);
            }
         }
         catch(error:Error)
         {
            DCDebug.traceCh("TOOLKIT","SoundManager.playSound(): Error trying to play file " + name);
         }
      }
      
      public function resumeSound(name:String, volume:Number = 1, startTime:Number = 0, loops:int = 0) : void
      {
         var soundObject:Object = null;
         try
         {
            if(name == null || this.mSoundsDictionary == null)
            {
               return;
            }
            if((soundObject = this.mSoundsDictionary[name]) == null)
            {
               return;
            }
            if(soundObject.type == 0)
            {
               if(!this.isMusicOn() || !this.isSoundOn() || (this.mLastMusic == name && !soundObject.paused || soundObject.stopped))
               {
                  return;
               }
               this.mLastMusic = name;
            }
            if(soundObject.paused)
            {
               soundObject.volume = volume;
               soundObject.startTime = startTime;
               soundObject.loops = loops;
               soundObject.channel = soundObject.sound.play(soundObject.position,soundObject.loops,new SoundTransform(this.calcOutputVolume(soundObject.volume,soundObject.type)));
               soundObject.paused = false;
               if(loops < 0)
               {
                  soundObject.channel.addEventListener("soundComplete",this.soundCompleteHandler);
               }
            }
         }
         catch(error:Error)
         {
            DCDebug.traceCh("TOOLKIT","SoundManager.playSound(): Error trying to play file " + name);
         }
      }
      
      public function stopSound(name:String) : void
      {
         var soundObject:Object = null;
         try
         {
            if(name == null || this.mSoundsDictionary == null || this.mSoundsDictionary[name] == null)
            {
               return;
            }
            soundObject = this.mSoundsDictionary[name];
            if(soundObject == null)
            {
               return;
            }
            soundObject.stopped = true;
            soundObject.channel.stop();
            if(soundObject.type == 1)
            {
               soundObject.channel.removeEventListener("soundComplete",this.checkSoundEnd);
               this.mSoundsCount--;
               if(this.mSoundsCount < 0)
               {
                  this.mSoundsCount = 0;
               }
            }
            else
            {
               soundObject.channel.removeEventListener("soundComplete",this.soundCompleteHandler);
            }
            soundObject.position = soundObject.channel.position;
         }
         catch(e:Error)
         {
            DCDebug.traceCh("TOOLKIT","SoundManager.stopSound(): Error trying to stop file " + name);
         }
      }
      
      public function pauseSound(name:String) : void
      {
         var soundObject:Object = this.mSoundsDictionary[name];
         if(soundObject != null && soundObject.channel != null && !soundObject.stopped)
         {
            soundObject.paused = true;
            soundObject.position = soundObject.channel.position;
            soundObject.channel.stop();
         }
      }
      
      public function stopAll(onlyMusic:Boolean = false, onlySfx:Boolean = false) : void
      {
         var i:int = 0;
         if(this.mSounds != null)
         {
            for(i = 0; i < this.mSounds.length; )
            {
               if(!(onlyMusic && this.mSounds[i].type == 1))
               {
                  if(!(onlySfx && this.mSounds[i].type == 0))
                  {
                     this.stopSound(this.mSounds[i].name);
                  }
               }
               i++;
            }
         }
      }
      
      public function playAll(onlyMusic:Boolean = false, onlySfx:Boolean = false) : void
      {
         var i:int = 0;
         if(this.mSounds != null)
         {
            for(i = 0; i < this.mSounds.length; )
            {
               if(!(onlyMusic && this.mSounds[i].type == 1))
               {
                  if(!(onlySfx && this.mSounds[i].type == 0))
                  {
                     this.playSound(this.mSounds[i].name);
                  }
               }
               i++;
            }
         }
      }
      
      public function resumeAll() : void
      {
         var name:String = null;
         var i:int = 0;
         if(this.mSounds != null)
         {
            for(i = 0; i < this.mSounds.length; )
            {
               if(this.mSounds[i].type == 0)
               {
                  name = String(this.mSounds[i].name);
                  this.resumeSound(name,1,0,this.mSoundLooping[name]);
               }
               i++;
            }
         }
      }
      
      public function pauseAll() : void
      {
         var i:int = 0;
         if(this.mSounds != null)
         {
            for(i = 0; i < this.mSounds.length; )
            {
               if(this.mSounds[i].type == 0)
               {
                  this.pauseSound(this.mSounds[i].name);
               }
               i++;
            }
         }
      }
      
      public function isMusicOn() : Boolean
      {
         return this.mMusicOn;
      }
      
      public function isSfxOn() : Boolean
      {
         return this.mSfxOn;
      }
      
      public function isSoundOn() : Boolean
      {
         return this.mSoundOn;
      }
      
      public function muteOff() : void
      {
         this.mSoundOn = true;
         if(this.isMusicOn())
         {
            this.resumeAll();
         }
      }
      
      public function muteOn() : void
      {
         this.mSoundOn = false;
         this.pauseAll();
      }
      
      public function setMusicOn(on:Boolean, externalCommandRequested:Boolean = false) : void
      {
         if(externalCommandRequested || !this.mMusicDisabledByExtNotification)
         {
            this.mMusicOn = on;
         }
         if(externalCommandRequested)
         {
            if(this.mMusicOn && this.mSoundOn)
            {
               this.mMusicDisabledByExtNotification = false;
               this.resumeAll();
            }
            else
            {
               this.mMusicDisabledByExtNotification = true;
               this.pauseAll();
            }
            return;
         }
         if(this.mMusicOn && this.mSoundOn)
         {
            this.resumeAll();
         }
         else
         {
            this.pauseAll();
         }
      }
      
      public function isMusicDisabledByExtNotification() : Boolean
      {
         return this.mMusicDisabledByExtNotification;
      }
      
      public function isSfxDisabledByExtNotification() : Boolean
      {
         return this.mSfxDisabledByExtNotification;
      }
      
      public function setSfxOn(on:Boolean, externalCommandRequested:Boolean = false) : void
      {
         this.mSfxOn = on;
      }
      
      public function setSoundVolume(name:String, volume:Number) : void
      {
         var curTransform:SoundTransform = null;
         var soundObject:Object;
         if((soundObject = this.mSoundsDictionary[name]) != null)
         {
            curTransform = soundObject.channel.soundTransform;
            curTransform.volume = this.calcOutputVolume(volume,soundObject.type);
            soundObject.channel.soundTransform = curTransform;
            soundObject.volume = volume;
         }
      }
      
      public function getSoundVolume(name:String) : Number
      {
         return this.mSoundsDictionary[name].volume;
      }
      
      public function getSoundOutputVolume(name:String) : Number
      {
         return this.mSoundsDictionary[name].channel.soundTransform.volume;
      }
      
      public function getSoundPosition(name:String) : Number
      {
         return this.mSoundsDictionary[name].channel.position;
      }
      
      public function getSoundDuration(name:String) : Number
      {
         return this.mSoundsDictionary[name].sound.length;
      }
      
      public function getSoundObject(name:String) : Sound
      {
         return this.mSoundsDictionary[name].sound;
      }
      
      public function isSoundPaused(name:String) : Boolean
      {
         if(this.mSoundsDictionary[name] == null)
         {
            return false;
         }
         return this.mSoundsDictionary[name].paused;
      }
      
      public function getSounds() : Array
      {
         return this.mSounds;
      }
      
      public function getLastMusic() : String
      {
         return this.mLastMusic;
      }
      
      public function playLastSound() : void
      {
         this.playSound(this.mLastMusic);
      }
      
      public function checkSoundEnd(event:Event) : void
      {
         var soundObject:Object = event.target;
         soundObject.removeEventListener("soundComplete",this.checkSoundEnd);
         this.mSoundsCount--;
         if(this.mSoundsCount < 0)
         {
            this.mSoundsCount = 0;
         }
      }
      
      public function isSoundPlaying(soundName:String) : Boolean
      {
         if(this.mSoundsDictionary[soundName] == null)
         {
            return false;
         }
         return !this.mSoundsDictionary[soundName].paused && !this.mSoundsDictionary[soundName].stopped;
      }
      
      private function calcOutputVolume(soundVolume:Number, soundType:int) : Number
      {
         var outputVolume:Number = soundVolume * this.mGeneralVolume;
         switch(soundType)
         {
            case 0:
               outputVolume = outputVolume * this.mMusicVolume * this.mGeneralVolume;
               break;
            case 1:
               outputVolume = outputVolume * this.mSfxVolume * this.mGeneralVolume;
         }
         return outputVolume;
      }
      
      public function setGeneralVolume(volume:Number) : void
      {
         var soundObject:Object = null;
         var curTransform:SoundTransform = null;
         this.mGeneralVolume = volume;
         for each(soundObject in this.mSoundsDictionary)
         {
            if(soundObject != null)
            {
               curTransform = soundObject.channel.soundTransform;
               curTransform.volume = this.calcOutputVolume(soundObject.volume,soundObject.type);
               soundObject.channel.soundTransform = curTransform;
            }
         }
      }
      
      public function getGeneralVolume() : Number
      {
         return this.mGeneralVolume;
      }
      
      public function setMusicVolume(volume:Number) : void
      {
         this.mMusicVolume = volume;
         this.updateSoundVolumesByType(0);
      }
      
      public function getMusicVolume() : Number
      {
         return this.mMusicVolume;
      }
      
      public function setSfxVolume(volume:Number) : void
      {
         this.mSfxVolume = volume;
         this.updateSoundVolumesByType(1);
      }
      
      public function getSfxVolume() : Number
      {
         return this.mSfxVolume;
      }
      
      private function updateSoundVolumesByType(soundType:int) : void
      {
         var soundObject:Object = null;
         var curTransform:SoundTransform = null;
         for each(soundObject in this.mSoundsDictionary)
         {
            if(soundObject != null && soundObject.type == soundType)
            {
               curTransform = soundObject.channel.soundTransform;
               curTransform.volume = this.calcOutputVolume(soundObject.volume,soundObject.type);
               soundObject.channel.soundTransform = curTransform;
            }
         }
      }
      
      public function fadeSound(name:String, initVolume:Number = 0, targVolume:Number = 1, fadeLength:Number = 1, playSoundAuto:Boolean = false, stopSoundOnComplete:Boolean = true, playLoops:int = 0) : void
      {
         if(this.mSoundsDictionary[name] == null || this.mSoundsDictionary[name].channel == null)
         {
            return;
         }
         var tween:GTween;
         var soundObject:Object;
         if((tween = (soundObject = this.mSoundsDictionary[name]).tween) != null)
         {
            tween.resetValues();
            tween.end();
            soundObject.tween = null;
         }
         (tween = new GTween(soundObject,fadeLength,{"volume":targVolume})).target.name = name;
         tween.target.stopSoundOnComplete = stopSoundOnComplete;
         soundObject.tween = tween;
         soundObject.tween.onChange = this.onChangeFadeSound;
         soundObject.tween.onComplete = this.onCompleteFadeSound;
         if(playSoundAuto)
         {
            this.playSound(name,initVolume,0,playLoops);
         }
      }
      
      private function onChangeFadeSound(tween:Object) : void
      {
         var name:String = String(tween.target.name);
         if(this.mSoundsDictionary[name] == null || this.mSoundsDictionary[name].channel == null)
         {
            return;
         }
         var soundObject:Object = this.mSoundsDictionary[name];
         this.setSoundVolume(name,soundObject.tween.target.volume);
      }
      
      private function onCompleteFadeSound(tween:Object) : void
      {
         var name:String = String(tween.target.name);
         var stopSoundOnComplete:Boolean = Boolean(tween.target.stopSoundOnComplete);
         if(this.mSoundsDictionary[name] == null || this.mSoundsDictionary[name].channel == null)
         {
            return;
         }
         var soundObject:Object = this.mSoundsDictionary[name];
         if(stopSoundOnComplete)
         {
            this.stopSound(name);
         }
         soundObject.tween = null;
      }
      
      public function fadeMusic(initVolume:Number = 0, targVolume:Number = 1, fadeLength:Number = 1) : void
      {
         var name:String = null;
         var i:int = 0;
         if(this.mSounds != null)
         {
            for(i = 0; i < this.mSounds.length; )
            {
               if(this.mSounds[i].type == 0)
               {
                  name = String(this.mSounds[i].name);
                  if(this.isSoundPlaying(name))
                  {
                     this.fadeSound(name,initVolume,targVolume,fadeLength,false,false);
                  }
               }
               i++;
            }
         }
      }
      
      public function setAllSFXVolume(volume:Number = 1) : void
      {
         var name:String = null;
         var i:int = 0;
         if(this.mSounds != null)
         {
            for(i = 0; i < this.mSounds.length; )
            {
               if(this.mSounds[i].type == 1)
               {
                  name = String(this.mSounds[i].name);
                  this.mSounds[i].volume = volume;
               }
               i++;
            }
         }
      }
      
      public function fadeAllSFX(initVolume:Number = 0, targVolume:Number = 1, fadeLength:Number = 1) : void
      {
         this.setAllSFXVolume(initVolume);
         var object:Object;
         (object = {}).volume = initVolume;
         var tween:GTween = new GTween(object,fadeLength,{"volume":targVolume});
         object.tween = tween;
         object.tween.onChange = this.onChange;
         tween.onComplete = this.onTweenComplete;
      }
      
      private function onChange(obj:Object) : void
      {
         this.mSFXSpecialVolume = obj.target.volume;
      }
      
      private function onTweenComplete(obj:Object) : void
      {
         this.mSFXSpecialVolume = -1;
      }
      
      public function setExceptionSounds(exceptions:Array) : void
      {
         if(this.mExceptionSounds == null)
         {
            this.mExceptionSounds = [];
         }
         this.mExceptionSounds = exceptions;
      }
      
      public function playDelayedSound(name:String, volume:Number = 1, startTime:Number = 0, loops:int = 0, delay:Number = 0) : void
      {
         if(this.mDelayedSoundsCatalog == null)
         {
            this.mDelayedSoundsCatalog = new Dictionary();
         }
         var obj:Object;
         (obj = {}).name = name;
         obj.volume = volume;
         obj.startTime = startTime;
         obj.loops = loops;
         obj.delay = delay;
         this.mDelayedSoundsCatalog[name] = obj;
      }
      
      public function logicUpdate(dt:int) : void
      {
         var soundObj:Object = null;
         for each(soundObj in this.mDelayedSoundsCatalog)
         {
            if(soundObj != null)
            {
               if(!isNaN(soundObj.delay))
               {
                  if(soundObj.delay > 0)
                  {
                     soundObj.delay -= dt;
                  }
                  else
                  {
                     this.playSound(soundObj.name,soundObj.volume,soundObj.startTime,soundObj.loops);
                     this.mDelayedSoundsCatalog[soundObj.name] = null;
                  }
               }
            }
         }
      }
   }
}
