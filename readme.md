# Yaaz (Yet Another Ascension Zcript)

This ascension script for Kingdom of Loathing is intended to be a bit friendlier
than other scripts, translating to being a bit more verbose about what it's
doing. It also isn't intended to be specifically for speed ascensions (though
it tries to be efficient) and has the option in several places to complete
side quests along the way.

## Installation

First, install it by running this command in KoLmafia's graphical CLI:

```
svn checkout https://github.com/mapledyne/yaaz/branches/Release/
```

To update the script itself, run this command in the graphical CLI:

```
svn update
```

## Usage

The primary commands can be run right from the graphical CLI.

**Note:** As a first time user, try out `yaaz-progres` and `yaaz-trophy` to get
a feel for things before running `yaaz`. Those don't consume any turns or
resources so they have less risk to try out.

### yaaz-progress

Print out a detailed progress sheet of things you can do and how far you're
along with various quests.

### yaaz-trophy

Print out a list of trophies you don't have along with your progress towards
them. In addition to trophies will track trophy-like progress for other
completionist sorts of goals. This includes royalty, recipes you may not have
made yet, food/booze you haven't consumed, monsters with missing factoids in
Manuel, etc.

### yaaz

This command is the core of yaaz and will attempt to run you through a full
ascension. See options, below, to customize how the script works.

### yaaz-end

Run this command once yaaz completes and it'll use up everything it thinks it
can before rollover. This command won't make you overdrink, but will otherwise
try to prep you for end-of-day, including pvp, any one-a-day things you haven't
done, and get the best outfit for rollover.

Generally speaking, if you want to do other things during the day, you'd want
to do them before running this script.

## Options

Lots of options available for Yaaz:
