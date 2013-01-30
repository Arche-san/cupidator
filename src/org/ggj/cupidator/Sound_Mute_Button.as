package  org.ggj.cupidator
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import singletons.Sound_Manager;
	
	/**
	 * ...
	 * @author Shinta
	 */
	public class Sound_Mute_Button extends MovieClip 
	{
		private var _mc:MovieClip;
		
		//************** HOW TO USE : put this line where a mute button is already in the .fla******************
		//var muteBTN:Sound_Mute_Button = new Sound_Mute_Button(btn_mute); //btn_mute = tag name in the .fla
		
		public function Sound_Mute_Button(mc:MovieClip) 
		{
			_mc = mc;
			_mc.addEventListener(MouseEvent.CLICK, onClick_Handler);
			updateButton();
		}

		private function onClick_Handler(e:MouseEvent):void 
		{
			Sound_Manager.isMute = ! Sound_Manager.isMute;
			updateButton();
			Sound_Manager.update();
		}
		
		private function updateButton():void
		{
			if (Sound_Manager.isMute)
			{
				_mc.gotoAndStop("red");
			}
			else if (!Sound_Manager.isMute)
			{
				_mc.gotoAndStop("green");
			}			
		}
		
		public function forceMute():void
		{
			Sound_Manager.isMute = true;
			updateButton();
		}
	}

}