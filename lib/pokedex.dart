import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'momon.dart';

class MyHomePage extends StatefulWidget {
  static const String url =  'https://pokeapi.co/api/v2/pokemon?limit=151&offset=0';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Pokemons pokemons;

  
  Future<List<Pokemons>> _fetchData() async{
   final response = await http.get(MyHomePage.url);
   final decode = json.decode(response.body);
   final data = Pokemons.fromJson(decode['results']);
   print(data.pokemons);

   setState(() {
     pokemons = data;
   });
  return _fetchData();
  }

  void initState(){
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: Text("Pokedex"),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft, 
            end: Alignment.centerRight, 
            colors: [Colors.blue, Colors.pink]
            )
            ),
            child:
            pokemons == null ?
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            )
                : GridView.count(
              crossAxisCount: 1,
              children: List.generate(pokemons.pokemons.length,
                      (index) =>
                          PokeCard(
                    pokeURL: pokemons.pokemons[index].url,
                  )),
            ),
          ),


      );

  }
}

class PokeCard extends StatefulWidget {

  const PokeCard({Key key , this.pokeURL}) : super(key: key);
  final String pokeURL;

  @override
  _PokeCardState createState() => _PokeCardState();
}

class _PokeCardState extends State<PokeCard> {
  Pokemon pokemon;

  _fetchData() async{
    final response = await http.get(widget.pokeURL);
    final decode = json.decode(response.body);
    final data = Pokemon.fromJson(decode);

    setState(() {
      pokemon = data;
    });
  }

  void initState(){
    _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child:  Card(
        
            shape: StadiumBorder(            
            side: BorderSide(
            color: Colors.yellow,
            width: 70,
  ),
),

            color: Colors.green,
            child: InkWell(
              onTap: (){
                Navigator.push(context, new MaterialPageRoute(builder: (context) => Detail(pokemon)));
              },
              child: pokemon == null ? Center(
                child: CircularProgressIndicator(),
              ) : Column(
                mainAxisAlignment: MainAxisAlignment.center ,
                children: [
                  Image.network(pokemon.sprites.frontDefault,
                    width: 300,
                    fit: BoxFit.fill,

                  ),
                ],
              ),

            )
          ),
      );
  }
}

class Detail extends StatelessWidget {
  Pokemon pokemon;

  Color bgColor = Color(0xFF171515);
  Detail(this.pokemon);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text("Pokedex"),
        backgroundColor: Colors.green,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          tooltip: "Return to list",
          onPressed: (){
            Navigator.pop(context,true);
          },
        ),
       
      ),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 250,
                decoration: BoxDecoration(
            gradient: LinearGradient(
            begin: Alignment.centerLeft, 
            end: Alignment.centerRight, 
            colors: [Colors.blue, Colors.pink]
            )
            ),
                   
                ),
                
              

              Positioned(
                child: CircleAvatar(radius: 100,
                  backgroundColor: Colors.white54,
                  backgroundImage:NetworkImage(pokemon.sprites.frontDefault),
                ),
              )
            ],
          ),
          SizedBox(height: 12),
          Text(pokemon.name,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 40,
                color: Colors.black,
                letterSpacing: 3
            ),
          ),
          Text('type', style: TextStyle(color: Colors.black, fontSize: 30)),
          SizedBox(height: 10,),
          Expanded(
            flex: -1,
            child: Container(
              height: 120,
              child: ListView.builder(
                  itemCount: pokemon.types.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return Container(
                      alignment: Alignment.center,

                      padding: EdgeInsets.all(8),
                      margin: EdgeInsets.symmetric(horizontal: 120,vertical: 8),
                      child: Text(pokemon.types[index].type.name,style: TextStyle(color: Colors.black,fontSize: 15,     letterSpacing: 2),),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                    );
                  }),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('${pokemon.weight/10} KG',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Colors.black,)
                  ),
                  Text('Weight',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                        color: Colors.black,)
                  ),
                ],
              ),
              Column(
                children: [
                  Text('${pokemon.height/10} M',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Colors.black,)
                  ),
                  Text('Height',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                        color: Colors.black,)
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12,),
          Text("Base Stats",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 24,
                color: Colors.black,
                decoration: TextDecoration.underline,
                letterSpacing: 2
                
            ),
          ),
          SizedBox(height: 12,),
          Expanded(
            child: ListView.builder(
                itemCount: pokemon.stats.length,
                itemBuilder: (context,index){
                  final poke = pokemon.stats[index];
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(115,0,0,0),
                    child: Row(
                    children: [
                      Text('${poke.stat.name} = ${poke.baseStat}',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                            letterSpacing: 1

                        ),
                      ),
                      SizedBox(height: 3,)
                    ],
                  ));
                }
            ),
          )
        ],
      ),

    );
  }
}