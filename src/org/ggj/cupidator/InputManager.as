package org.ggj.cupidator 
{
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Jerome
	 */
	public class InputManager
	{
		//keycodes
		public const KEYBOARD_LEFT:uint = 37;
		public const KEYBOARD_UP:uint = 38;
		public const KEYBOARD_RIGHT:uint = 39;
		public const KEYBOARD_DOWN:uint = 40;
		public const KEYBOARD_Z:uint = 90;
		public const KEYBOARD_Q:uint = 81;
		public const KEYBOARD_S:uint = 83;
		public const KEYBOARD_D:uint = 68;	
		public const KEYBOARD_SPACE:uint = 32;
		public const KEYBOARD_ENTER:uint = 13;
		public const KEYBOARD_CONTROL:uint = 17;
		
		public var keyDown:Boolean = false;
		public var keyUp:Boolean = false;
		public var keyLeft:Boolean = false;
		public var keyRight:Boolean = false;
		
		public var mouse:Boolean = false;
		public var actionBtn:Boolean = false;
		
		public function InputManager(main:Sprite)
		{
			main.stage.addEventListener(KeyboardEvent.KEY_DOWN, _keyDownListener);
			main.stage.addEventListener(KeyboardEvent.KEY_UP, _keyUpListener);
			main.stage.addEventListener(MouseEvent.MOUSE_DOWN, _mouseDownListener);
			main.stage.addEventListener(MouseEvent.MOUSE_UP, _mouseUpListener);
		}
		
		private function _keyDownListener(event:KeyboardEvent):void
		{
			_updateKeys(event, true);
		}
		
		private function _keyUpListener(event:KeyboardEvent):void
		{
			_updateKeys(event, false);
		}  
		
		private function _updateKeys(event:KeyboardEvent, value:Boolean):void
		{
			if (event.keyCode == KEYBOARD_LEFT || event.keyCode == KEYBOARD_Q)
			{
				keyLeft = value;
			}
			if (event.keyCode == KEYBOARD_UP || event.keyCode == KEYBOARD_Z)
			{
				keyUp = value;
			}
			if (event.keyCode == KEYBOARD_RIGHT || event.keyCode == KEYBOARD_D)
			{
				keyRight = value;
			}
			if (event.keyCode == KEYBOARD_DOWN || event.keyCode == KEYBOARD_S)
			{
				keyDown = value;
			}
			if (event.keyCode == KEYBOARD_SPACE || event.keyCode == KEYBOARD_ENTER || event.keyCode == KEYBOARD_CONTROL)
			{
				actionBtn = value;
			}
		}
		
		private function _mouseDownListener(event:MouseEvent):void
		{
			mouse = true;
		}
		
		private function _mouseUpListener(event:MouseEvent):void
		{
			mouse = false;
		}
	}

}