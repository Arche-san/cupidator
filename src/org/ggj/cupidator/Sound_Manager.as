package org.ggj.cupidator //model Jérome
{	
	public const Sound_Manager:Sound_Manager_Singleton = new Sound_Manager_Singleton();
}

import flash.display.MovieClip;
import flash.events.Event;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.media.SoundMixer;
import flash.net.URLRequest;

internal class Sound_Manager_Singleton
{
	private var _isMute:Boolean = false; //always false when launching the game
	
	//************** mp3 files MUST be 11025, 22050 or 44100 (preferred) Hz ************************************************
	//************** DONT CHANGE THE VAR NAMES *****************************************************************************
	

	//**************Sound list from embedded files "../lib/_Sounds/filename.mp3" : ******************************************
	//***********************************************************************************************************************
	
	//Main theme
	//[Embed(source="../../../../lib/_Sounds/SplashTheme.mp3")]
	//private var SplashTheme:Class;
	//private var splashTheme:Sound = new SplashTheme();
	private var splashTheme:lib_Son_SplashTheme = new lib_Son_SplashTheme();
	private var runTheme:lib_Son_RunTheme = new lib_Son_RunTheme();
	private var contact:lib_Son_contact = new lib_Son_contact();
	private var gameover:lib_Son_gameover = new lib_Son_gameover();
	private var heartbeat1:lib_Son_heartbeat1 = new lib_Son_heartbeat1();
	private var heartbeat2:lib_Son_heartbeat2 = new lib_Son_heartbeat2();
	private var gun:lib_Son_gun = new lib_Son_gun();
	private var pop:lib_Son_pop = new lib_Son_pop();
	private var magneto:lib_Son_magneto = new lib_Son_magneto();
	private var outro:lib_Son_outro = new lib_Son_outro();
	
	//Theme Battle
	//[Embed(source="../../../../lib/_Sounds/RunTheme.mp3")]
	//private var RunTheme:Class;
	//private var runTheme:Sound = new RunTheme();
	
	//Contact player/enemy
	//[Embed(source="../../../../lib/_Sounds/contact.wav")]
	//private var Contact:Class;
	//private var contact:Sound = new Contact();
	
	//hp = 0
	//[Embed(source="../../../../lib/_Sounds/gameover.wav")]
	//private var Gameover:Class;
	//private var gameover:Sound = new Gameover();
	
	// heartbeat1 est joué en meme temps que runtheme
	//[Embed(source="../../../../lib/_Sounds/heartbeat-01.wav")]
	//private var Heartbeat1:Class;
	//private var heartbeat1:Sound = new Heartbeat1();
	
	// remplace heartbeat1 quand le player touche le coeur
	//[Embed(source="../../../../lib/_Sounds/heartbeat-02.wav")]
	//private var Heartbeat2:Class;
	//private var heartbeat2:Sound = new Heartbeat2();
	
	// player shoots
	//[Embed(source="../../../../lib/_Sounds/gun.wav")]
	//private var Gun:Class;
	//private var gun:Sound = new Gun();
	
	// en meme temps que la scene magneto
	//[Embed(source="../../../../lib/_Sounds/magneto.wav")]
	//private var Magneto:Class;
	//private var magneto:Sound = new Magneto();
	
	// enemy qui meurt
	//[Embed(source="../../../../lib/_Sounds/pop.wav")]
	//private var Pop:Class;
	//private var pop:Sound = new Pop();
	
	// pendant l'outro
	//[Embed(source="../../../../lib/_Sounds/outro.mp3")]
	//private var Outro:Class;
	//private var outro:Sound = new Outro();
	
	//************************************************************************************************************************
	//************************************************************************************************************************
		
	// !!! Don't change this :
	private var channel:SoundChannel; // classic sfx channel
	private var music_channel:SoundChannel; // channel for music
	private var spacial_channel:SoundChannel; // channel for spacial sound effects
	private var muteSoundTransform:SoundTransform = new SoundTransform(); //SoundTransform for volume
	
		public function Sound_Manager ():void
		{
			//test play music
			//sound.playMusic("zic_main",1,0,2);
			
			//test play sound
			//sound.playSound("zic_main");
		}
		
		public function get isMute():Boolean{
			return _isMute;
		}
		public function set isMute(setSound:Boolean):void{
			_isMute=setSound;
		}
		
		public function playMusic (musicObject:String,vol:Number=1,delay:Number=0,repeat:uint=99999):void
		{
			var transformSound:SoundTransform = new SoundTransform(vol);
			//music_channel.soundTransform = transformSound;
			
			switch(musicObject)
			{
				case "splashTheme":
					music_channel = splashTheme.play(delay, repeat);
					//music_channel.soundTransform = transformSound;
					break;
				
				case "runTheme":
					music_channel = runTheme.play(delay, repeat);
					music_channel = heartbeat1.play(delay, repeat);
					break;
				
				case "heartbeat1":
					music_channel = heartbeat1.play(delay, repeat);
					break;
					
				case "heartbeat2":
					music_channel = heartbeat2.play(delay, repeat);
					break;

				default: // for safety
					music_channel = splashTheme.play(delay,repeat);
					break;
			}
			music_channel.soundTransform = transformSound;
		}
		
		public function playSound(soundObject:String):void
		{
			if (!_isMute)
			{
				switch (soundObject)
				{
					case "gun":
					channel=gun.play();
					break;
					
					case "pop":
					channel=pop.play();
					break;
					
					case "contact":
					channel=contact.play();
					break;
					
					case "magneto":
					channel=magneto.play();
					break;
					
					case "gameover":
					channel=gameover.play();
					break;
					
					case "outro":
					channel=outro.play();
					break;
					
				default: //for safety
					channel=pop.play();
					break;
				}
			}
		}
		
		public function update ():void
		{
		if (!_isMute)
			{
				muteSoundTransform.volume = 1;
				SoundMixer.soundTransform = muteSoundTransform;
			}
		else if (_isMute)
			{
				muteSoundTransform.volume = 0;
				SoundMixer.soundTransform = muteSoundTransform;
			}
		}
		public function stopAll():void
		{
			SoundMixer.stopAll();
		}
}
