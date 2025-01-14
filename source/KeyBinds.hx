import flixel.FlxG;

class KeyBinds
{
	public static var gamepad:Bool = false;

	public static function keyCheck():Void
	{
		if(FlxG.save.data.upBind == null)
			FlxG.save.data.upBind = "d";
		if (StringTools.contains(FlxG.save.data.upBind,"NUMPAD"))
			FlxG.save.data.upBind = "f";
		if(FlxG.save.data.downBind == null)
			FlxG.save.data.downBind = "j";
		if (StringTools.contains(FlxG.save.data.downBind,"NUMPAD"))
			FlxG.save.data.downBind = "k";
		if(FlxG.save.data.leftBind == null)
			FlxG.save.data.leftBind = "A";
		if (StringTools.contains(FlxG.save.data.leftBind,"NUMPAD"))
			FlxG.save.data.leftBind = "A";
		if(FlxG.save.data.rightBind == null)
			FlxG.save.data.rightBind = "D";
		if (StringTools.contains(FlxG.save.data.rightBind,"NUMPAD"))
			FlxG.save.data.rightBind = "D";

		if(FlxG.save.data.gpupBind == null)
			FlxG.save.data.gpupBind = "DPAD_UP";
		if(FlxG.save.data.gpdownBind == null)
			FlxG.save.data.gpdownBind = "DPAD_DOWN";
		if(FlxG.save.data.gpleftBind == null)
			FlxG.save.data.gpleftBind = "DPAD_LEFT";
		if(FlxG.save.data.gprightBind == null)
			FlxG.save.data.gprightBind = "DPAD_RIGHT";
		if(FlxG.save.data.killBind == null)
			FlxG.save.data.killBind = "R";
	}
}
