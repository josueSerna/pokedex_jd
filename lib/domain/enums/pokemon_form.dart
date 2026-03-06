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

  String get label {
    switch (this) {
      case PokemonForm.mega:
        return 'Megas';
      case PokemonForm.alola:
        return 'Regionales de Alola';
      case PokemonForm.galar:
        return 'Regionales de Galar';
      case PokemonForm.hisui:
        return 'Regionales de Hisui';
      case PokemonForm.paldea:
        return 'Regionales de Paldea';
      case PokemonForm.gigantamax:
        return 'Gigamax';
    }
  }

  static PokemonForm? fromRoute(String route) {
    switch (route) {
      case 'mega':
        return PokemonForm.mega;
      case 'alola':
        return PokemonForm.alola;
      case 'galar':
        return PokemonForm.galar;
      case 'hisui':
        return PokemonForm.hisui;
      case 'paldea':
        return PokemonForm.paldea;
      case 'gmax':
        return PokemonForm.gigantamax;
      default:
        return null;
    }
  }
}
