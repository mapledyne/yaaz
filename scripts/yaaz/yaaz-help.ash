void main()
{


print("This script (yaaz) was built as an experiment to build a new automated ascension script, but built with a few different goals than prior scripts.");
print("Accordingly, if these goals don't fit what you're interested in, this will be a poor choice of a script on your part.");
print("");
print("Goals:");
print("* More clear output (quickly see what's being done and progress towards goals)");
print("* Ability to run automation on individual quests or goals");
print("* Work at any level of skill and IotM ownership");
print("* Automatically send gifts and nice things to people");
print("");
print_html("You can customize how the script operates by changing some of its flags. Info here: <a href='https://github.com/mapledyne/yaaz/wiki/yaaz-options'>yaaz-options</a>");
print("");
print("Beyond just 'yaaz' there are some other tools you may be interested in that part of the yaaz set of tools:");
print_html("* <i>yaaz-begin</i>: Do daily startup things without adventuring");
print_html("* <i>yaaz-end</i>: Run end-of-day things (like prepping for rollover)");
print_html("* <i>yaaz-progress</i>: Progress towards various goals");
print_html("* <i>yaaz-trophy</i>: Progress towards trophies (and other similar goals)");
print("");
print("If you browse the script directory from the 'Scripts' menu, the majority of scripts there can each be run individually as well. Run 'yz_prep' and it'll do it's bit of cleanup for you, for instance.");
print("");
print("This is most useful in the 'quests' directory where you can, instead of using yaaz to attempt the whole ascension, have yaaz automate individual quests. Run L06_Q_friar.ash and the Friar's quest will be done but nothing else. Quest files have some breakpoints in them, so manually running a quest file may have to be done multiple times to get it to complete a quest.");
print("Note that files that begin with 'yaaz-' are primarily meant to be run this way. Scripts starting with 'yz_' can be run, but are designed to primarily be run from the 'yaaz-' scripts.");
print("");
print_html("See issues being worked, known bugs, and features being considered at: <a href='https://github.com/mapledyne/yaaz'>https://github.com/mapledyne/yaaz</a>");
print("Please add any bugs or feature requests there as well.");
}
