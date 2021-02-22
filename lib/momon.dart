import 'dart:convert';
import 'package:flutter/cupertino.dart';

class Pokemons {
  List<BaseP> pokemons = [];


  Pokemons.fromJson(List<dynamic> json) {
    if (json == null) return;

    json.forEach((item) {
      final pokemon = BaseP.fromJson(item);
      pokemons.add(pokemon);
    });
  }
}

class BaseP {
  String name;
  String url;

  BaseP({
    this.name,
    this.url,
  });

  factory BaseP.fromJson(Map<String, dynamic> json) {
    return BaseP(
      name: json["name"],
      url: json["url"],
    );
  }

  Map<String, dynamic> toJson() => {"name": name, "url": url};
}

Pokemon pokemonFromJson(String str) => Pokemon.fromJson(json.decode(str));

class Pokemon {
  int id;
  String name;
  Species species;
  Sprites sprites;
  List<Stat> stats;
  List<Type> types;
  List<Species> forms;
  int weight;
  
  int height;


  Pokemon({
    this.id,
    this.name,
    @required this.weight, 
   
    @required this.height,
    
    this.sprites,
    this.stats,
    this.types,
    this.forms,
    

  });

  factory Pokemon.fromJson(Map<String, dynamic> json) => Pokemon(
    id: json["id"],
    name: json["name"],
    weight: json["weight"],
    height: json["height"],
    
    
    stats: List<Stat>.from(json["stats"].map((x) => Stat.fromJson(x))),
    types: List<Type>.from(json["types"].map((x) => Type.fromJson(x))),
    
    sprites: Sprites.fromJson(json["sprites"]),
  );
}


class Species {
  String name;
  String url;

  Species({
    this.name,
    this.url,
  });

  factory Species.fromJson(Map<String, dynamic> json) => Species(
    name: json["name"],
    url: json["url"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "url": url,
  };
}



class Sprites {
  String frontDefault;

  Sprites({
    this.frontDefault,
  });

  factory Sprites.fromJson(Map<String, dynamic> json) => Sprites(
    frontDefault: json["front_default"],
  );

  Map<String, dynamic> toJson() => {
    "front_default": frontDefault,
  };
}

class Stat {
  int baseStat;
  Species stat;

  Stat({
    this.baseStat,
    this.stat,
  });

  factory Stat.fromJson(Map<String, dynamic> json) => Stat(
    baseStat: json["base_stat"],
    stat: Species.fromJson(json["stat"]),
  );
}

class Type {
  int slot;
  Species type;

  Type({
    this.slot,
    this.type,
  });

  factory Type.fromJson(Map<String, dynamic> json) => Type(
    slot: json["slot"],
    type: Species.fromJson(json["type"]),
  );
}