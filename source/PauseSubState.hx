package;

import flixel.input.gamepad.FlxGamepad;
import openfl.Lib;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.addons.display.FlxBackdrop;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = ['Resume', 'Restart Song', 'Exit to menu'];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;
	var perSongOffset:FlxText;
	var songPath:String;

	var offsetChanged:Bool = false;
	var startOffset:Float = PlayState.songOffset;

	var stripes:FlxBackdrop;
	var fgstuff:FlxBackdrop;


	public override function create()
	{
		super.create();

		pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);


		FlxG.cameras.bgColor = 0x11000000;
		FlxG.camera.useBgAlphaBlending = true;

		var bg:FlxSprite = new FlxSpriteExtra().makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();

		add(bg);

		stripes = new FlxBackdrop(Paths.image('test'), 0.2, 0, true, false);
		stripes.velocity.set(-50, 0);
		stripes.setGraphicSize(Std.int((stripes.width * 1.2)));
		//stripes.updateHitbox();
		stripes.screenCenter(XY);
		stripes.alpha = 0;
		stripes.blend = SCREEN;
		stripes.antialiasing = FlxG.save.data.antialiasing;
		add(stripes);

		fgstuff = new FlxBackdrop(Paths.image('test2'), 0.2, 0, true, true);
		fgstuff.velocity.set(200, 150);
		//fgstuff.setGraphicSize(Std.int((fgstuff.width * 1.2) / defaultCamZoom));
		//fgstuff.updateHitbox();
		fgstuff.screenCenter(XY);
		fgstuff.alpha = 0;
		fgstuff.antialiasing = FlxG.save.data.antialiasing;

		add(fgstuff);


		var levelInfo:FlxFixedText = new FlxFixedText(20, 15, 0, "", 32);
		levelInfo.text += Song.unformatSongName(PlayState.SONG.song);
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 32);
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDifficulty:FlxFixedText = new FlxFixedText(20, 15 + 32, 0, "", 32);
		levelDifficulty.text += CoolUtil.difficultyFromInt(PlayState.storyDifficulty).toUpperCase();
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);

		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(stripes, {alpha: 0.1}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(fgstuff, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);
		perSongOffset = new FlxFixedText(5, FlxG.height - 18, 0, "Additive Offset (Left, Right): " + PlayState.songOffset + " - Description - " + 'Adds value to global offset, per song.', 12);
		perSongOffset.scrollFactor.set();
		perSongOffset.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);

		add(perSongOffset);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		// pre lowercasing the song name (update)
		var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
		songPath = 'assets/data/' + songLowercase + '/';

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
		cameras[0].zoom = 1;
		
		#if android
                addVirtualPad(LEFT_FULL, A);
                #end
	}

	override function update(elapsed:Float)
	{
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		var upPcontroller:Bool = false;
		var downPcontroller:Bool = false;
		var leftPcontroller:Bool = false;
		var rightPcontroller:Bool = false;

		if (gamepad != null && KeyBinds.gamepad)
		{
			upPcontroller = gamepad.justPressed.DPAD_UP;
			downPcontroller = gamepad.justPressed.DPAD_DOWN;
			leftPcontroller = gamepad.justPressed.DPAD_LEFT;
			rightPcontroller = gamepad.justPressed.DPAD_RIGHT;
		}

		if (controls.UP_P || upPcontroller)
			changeSelection(-1);
		else if (controls.DOWN_P || downPcontroller)
			changeSelection(1);
		else if (controls.LEFT_P || leftPcontroller)
		{
			changeOffset(-1);
		}
		else if (controls.RIGHT_P || rightPcontroller)
		{
			changeOffset(1);
		}

		if (controls.ACCEPT)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "Resume":
					close();
				case "Restart Song":
					PlayState.startTime = 0;
					FlxG.resetState();
				case "Exit to menu":
					PlayState.startTime = 0;
					PlayState.deaths = 0;

					#if windows
					if (PlayState.luaModchart != null)
					{
						PlayState.luaModchart.die();
						PlayState.luaModchart = null;
					}
					#end
					if (FlxG.save.data.framerate > 290)
						Main.setFPSCap(290);

					if (PlayState.isStoryMode)
						FlxG.switchState(new StoryMenuState());
					else
						FlxG.switchState(new FreeplayState());
			}
		}
	}

	override function destroy()
	{
		pauseMusic.destroy();
		FlxG.cameras.bgColor = 0x00000000;
        FlxG.camera.useBgAlphaBlending = false;

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
				item.alpha = 1;
		}
	}

	function changeOffset(amount:Int)
	{
		var oldOffset = PlayState.songOffset;
		PlayState.songOffset += amount;
		sys.FileSystem.rename(songPath + oldOffset + '.offset', songPath + PlayState.songOffset + '.offset');
		perSongOffset.text = "Additive Offset (Left, Right): " + PlayState.songOffset + " - Description - " + 'Adds value to global offset, per song.';
		if(!offsetChanged)
		{
			grpMenuShit.clear();

			menuItems = ['Restart Song', 'Exit to menu'];

			for (i in 0...menuItems.length)
			{
				var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
				songText.isMenuItem = true;
				songText.targetY = i;
				grpMenuShit.add(songText);
			}

			changeSelection();

			offsetChanged = true;
		}

		if (PlayState.songOffset == startOffset)
		{
			grpMenuShit.clear();

			menuItems = ['Resume', 'Restart Song', 'Exit to menu'];

			for (i in 0...menuItems.length)
			{
				var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
				songText.isMenuItem = true;
				songText.targetY = i;
				grpMenuShit.add(songText);
			}

			changeSelection();

			offsetChanged = false;
		}
	}
}
