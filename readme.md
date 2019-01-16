# Yaaz (Yet Another Ascension Zcript)

This ascension script for Kingdom of Loathing is intended to be a bit friendlier
than other scripts, translating to being a bit more verbose about what it's
doing. It also isn't intended to be specifically for speed ascensions (though
it tries to be efficient) and has the option in several places to complete
side quests along the way.

Please, please, please reach out to me if you find bugs/problems/improvements!
I'm `Degrassi` in KoL.

## Installation

First, install it by running this command in KoLmafia's graphical CLI:

```
svn checkout https://github.com/mapledyne/yaaz/branches/Release/
```

To update the script itself, run this command in the graphical CLI:

```
svn update
```

## Purpose

This script (yaaz) was built as an experiment to build a new automated ascension script, but built with a few different goals than prior scripts.

Accordingly, if these goals don't fit what you're interested in, this will be a poor choice of a script on your part.

#### Goals:


* More clear output (quickly see what's being done and progress towards goals)

* Ability to run automation on individual quests or goals

* Work at any level of skill and IotM ownership

* Automatically send gifts and nice things to people


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

### yaaz-begin

This command runs any "start of day" tasks that should be done early in a day
but has little cost (once a day things with a greater cost are attempted later
as appropriate resources are available). It's analogous to KolMafia's breakfast
system in many respects. This never needs to be run directly (the main yaaz
script runs this itself) but if you want to kick a day off, then do some manual
tasks first, this is an easy option.


### Other scripts

If you browse the script directory from the 'Scripts' menu, the majority of
scripts there can each be run individually as well. Run 'yz_prep' and it'll
do it's bit of cleanup for you, for instance.

This is most useful in the 'quests' directory where you can, instead of using
yaaz to attempt the whole ascension, have yaaz automate individual quests. Run
L06_Q_friar.ash and the Friar's quest will be done but nothing else. Quest
files have breakpoints in them, so manually running a quest file may have
to be done multiple times to get it to complete a quest.

Note that files that begin with 'yaaz-' are primarily meant to be run this way. Scripts starting with 'yz_' can be run, but are designed to primarily be run from the 'yaaz-' scripts, so you may get sub-optimal performance.


## Options

Lots of options available for Yaaz:
