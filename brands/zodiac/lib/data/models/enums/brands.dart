enum Brands{
  zodiac, psiquiqos, psiquiqosPt;

  int get id{
    switch(this){
      case Brands.zodiac:
        return 1;
        case Brands.psiquiqos:
        return 4;
        case Brands.psiquiqosPt:
        return 8;
    }
  }
}