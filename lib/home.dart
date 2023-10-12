import 'package:flutter/material.dart';
import 'package:jogo_da_memoria/game.dart';

// fazer responsivo
// fazer imagens e deixar layout bonitinho

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String nickName = "";
  bool numbers = false;
  bool images = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            shape: const Border(
              bottom: BorderSide(color: Colors.white, width: 2.0),
            ),
            backgroundColor: const Color(0xff1a1b2d),
            title: const Center(child: Text("Memoria dos Feiticeiros")),
            automaticallyImplyLeading: false),
        body: DecoratedBox(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/background.jpg"),
                  fit: BoxFit.none,
                  repeat: ImageRepeat.repeat)),
          child: Center(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 30),
                child: Center(
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.white,
                      decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color(0xff1a1b2d),
                          labelText: "Apelido de Feiticeiro...",
                          labelStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white))),
                      maxLength: 15,
                      onChanged: (String nick) {
                        nickName = nick;
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 60),
                  child: Container(
                      width: 300,
                      decoration: BoxDecoration(
                          color: const Color(0xff1a1b2d),
                          border: Border.all(color: Colors.white, width: 2.0)),
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor: Colors.white,
                        ),
                        child: Column(
                          children: [
                            Center(
                              child: SizedBox(
                                  width: 300,
                                  child: CheckboxListTile(
                                    title: const Text(
                                      'Modo Números',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    activeColor: Colors.white,
                                    checkColor: const Color(0xff1a1b2d),
                                    value: numbers,
                                    onChanged: (bool? value) {
                                      if (value != null) {
                                        setState(() {
                                          numbers = value;
                                        });
                                      }
                                    },
                                  )),
                            ),
                            Center(
                              child: SizedBox(
                                  width: 300,
                                  child: CheckboxListTile(
                                    title: const Text(
                                      'Modo Imagens',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    activeColor: Colors.white,
                                    checkColor: const Color(0xff1a1b2d),
                                    value: images,
                                    onChanged: (bool? value) {
                                      if (value != null) {
                                        setState(() {
                                          images = value;
                                        });
                                      }
                                    },
                                  )),
                            ),
                          ],
                        ),
                      ))),
              ElevatedButton(
                  style: ButtonStyle(
                      fixedSize:
                          const MaterialStatePropertyAll(Size(160.0, 40.0)),
                      foregroundColor: images || numbers
                          ? MaterialStateProperty.all(Colors.white)
                          : null,
                      backgroundColor: images || numbers
                          ? const MaterialStatePropertyAll(
                              Color.fromARGB(255, 236, 74, 95))
                          : null),
                  onPressed: !images && !numbers
                      ? null
                      : () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Game(
                                      nickName: nickName,
                                      numbers: numbers,
                                      images: images)));
                        },
                  child: const Text("Jogar", style: TextStyle(fontSize: 23.0)))
            ]),
          ),
        ));
  }
}
