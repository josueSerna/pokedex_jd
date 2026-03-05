enum PokemonForm { mega, alola, galar, hisui, paldea, gigantamax }

extension PokemonFormX on PokemonForm {
  String get value {
    switch (this) {
      case PokemonForm.mega:
        return 'mega';
      case PokemonForm.alola:
        return 'alola';
      case PokemonForm.galar:
        return 'galar';
      case PokemonForm.hisui:
        return 'hisui';
      case PokemonForm.paldea:
        return 'paldea';
      case PokemonForm.gigantamax:
        return 'gmax';
    }
  }
}
