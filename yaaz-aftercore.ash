
int plushie_sets()
{
  int total = item_amount($item[microplushie: bropane]);

  foreach it in $items[microplushie: bropane,
                       microplushie: dorkonide,
                       microplushie: ermahgerdic acid,
                       microplushie: fauxnerditide,
                       microplushie: gothochondria,
                       microplushie: hippylase,
                       microplushie: hipsterine,
                       microplushie: hobomosome,
                       microplushie: otakulone,
                       microplushie: raverdrine,
                       microplushie: sororitrate]
  {
    total = min(total, item_amount(it));
  }
  return total;
}

void yaaz_aftercore()
{

  // Get the key/chest combos to open chests:
  int stuffy = min(stash_amount($item[stuffed key]), stash_amount($item[stuffed treasure chest]));
  if (stuffy > 0)
  {
    take_stash(stuffy, $item[stuffed treasure chest]);
    take_stash(stuffy, $item[stuffed key]);
  }
  stuffy = min(item_amount($item[stuffed key]), item_amount($item[stuffed treasure chest]));
  use(stuffy, $item[stuffed treasure chest]);


  // Get the harder to find microplushies to try to make complete sets:
  foreach it in $items[Microplushie: Hobomosome,
                      Microplushie: Ermahgerdic Acid,
                      Microplushie: Dorkonide,
                      Microplushie: Fauxnerditide,
                      Microplushie: Hipsterine]
  {
    take_stash(stash_amount(it), it);
  }


}

void main()
{
  yaaz_aftercore();
}
