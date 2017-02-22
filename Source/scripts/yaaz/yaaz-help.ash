void main()
{


print("This script (yaaz) was built as an experiment to build a new automated ascension script, but built with a few different goals than prior scripts.");
print("Accordingly, if these goals don't fit what you're interested in, this will be a poor choice of a script on your part.");
print("");
print("Goals:");
print("* More clear output (quickly see what's being done and progress towards goals)");
print("* Slower (short pauses at quest breakpoints, etc.)");
print("* Ability to run automation on individual quests or goals.");
print("* Automatically send gifts and nice things to people");
print("* Do it myself");
print("");

print("Obviously the last one was just for me, but I want to note anyway. If you're into scripting, you should go script your own, too!");
print("");

print("Beyond just 'yaaz' there are some other tools you may be interested in that part of the yaaz set of tools:");
print_html("* <i>yaaz-begin</i>: Do daily startup things without adventuring");
print_html("* <i>yaaz-end</i>: Run end-of-day things (like prepping for rollover)");
print_html("* <i>yaaz-options</i>: List some options that can configure yaaz");
print_html("* <i>yaaz-progress</i>: Progress towards various goals");
print_html("* <i>yaaz-trophy</i>: Progress towards trophies (and other similar goals)");
print("");
print("If you browse the script directory from the 'Scripts' menu, the majority of scripts there can each be run individually as well. Run 'prep' and it'll do it's bit of cleanup for you, for instance.");
print("");
print("This is most useful in the 'quests' directory where you can, instead of using yaaz to attempt the whole ascension, have yaaz automate individual quests. Run L06_Q_friar.ash and the Friar's quest will be done but nothing else.");
print("");
print("Note that these scripts are meant to break out regularly when sub-goals are met, so running a quest script may have to be done multiple times (the friar script will end each time one of the required items are found. Rerun it to find all of them). Also, some scripts will wait based on internal logic. If it thinks it should wait and not do a quest now, running it may not work. This should be (generally) rare (imagine a case where you've digitized a lobsterfrogman - rerunning the lighthouse sidequest will cause it to skip since it's waiting for the monsters to show up in other ways).");
}
