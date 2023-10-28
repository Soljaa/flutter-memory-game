import 'dart:math';
import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  const Game(
      {super.key,
      required String nickName,
      required bool numbers,
      required bool images})
      : _nickName = nickName,
        _numbers = numbers,
        _images = images;

  final String _nickName;
  final bool _numbers;
  final bool _images;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  int plays = 0;
  int matches = 0;
  bool endGame = false;
  bool canTap = true;

  @override
  void initState() {
    cardImages = generateCards();
    super.initState();
  }

  List<String> defaultImages = [
    "assets/getou.png",
    "assets/gojo.png",
    "assets/maki.png",
    "assets/megumi.png",
    "assets/nanami.png",
    "assets/nobara.png",
    "assets/sukuna.png",
    "assets/todo.png",
    "assets/toji.png",
    "assets/yuji.png",
  ];

  List<String> generateCards() {
    List<String> shuffledCards = [];
    if (widget._images && !widget._numbers) {
      for (int i = 0; i < 10; i++) {
        shuffledCards.addAll([defaultImages[i], defaultImages[i]]);
      }
      shuffledCards.shuffle();
    } else if (!widget._images && widget._numbers) {
      for (int i = 0; i < 10; i++) {
        shuffledCards.addAll([i.toString(), i.toString()]);
      }
      shuffledCards.shuffle();
    } else {
      List<int> usedIndex = [];
      for (int i = 0; i < 5; i++) {
        int randIndex;
        do {
          randIndex = Random().nextInt(10);
        } while (usedIndex.contains(randIndex));
        usedIndex.add(randIndex);

        shuffledCards
            .addAll([defaultImages[randIndex], defaultImages[randIndex]]);
        shuffledCards.addAll([randIndex.toString(), randIndex.toString()]);
      }
      shuffledCards.shuffle();
    }
    return shuffledCards;
  }

  List<String> cardImages = [];

  void resetGame() {
    // reset cards list
    setState(() {
      plays = 0;
      matches = 0;
      for (int i = 0; i < 20; i++) {
        cardKeys[i].currentState?.setFlipState(false);
        cardKeys[i].currentState?.unlockCard();
      }
      cardImages = generateCards();
      endGame = false;
      // reroll the cardsImages
    });
  }

  void addCounter() {
    setState(() {
      plays = plays + 1;
    });
  }

  void addMatches() {
    setState(() {
      matches = matches + 1;
    });
  }

  void finshGame() {
    setState(() {
      endGame = true;
    });
  }

  List<Row> creatCardGrid() {
    List<Row> cardGrid = [];
    for (int i = 0; i < 5; i++) {
      // ignore: prefer_const_constructors
      Row row = Row(
          // ignore: prefer_const_literals_to_create_immutables
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: []);
      for (int j = 0; j < 4; j++) {
        Card card = Card(
            // i * 4 + j uses i and j to go from 0 to 19 index
            key: cardKeys[i * 4 + j],
            // uses i * 4 + j index to get the previusly randomized content
            frontImage: cardImages[i * 4 + j],
            onFlip: () {
              if (canTap) {
                // flips the card *** add animation
                cardKeys[i * 4 + j].currentState?.setFlipState(true);
                // checks if there is another card flipped
                if (currentCard != null) {
                  addCounter();
                  canTap = false;
                  // checks if its a match
                  Future.delayed(const Duration(milliseconds: 700), () {
                    cardKeys[i * 4 + j].currentState?.setFlipState(true);
                    if (currentCard?.currentState?.getImage() ==
                        cardKeys[i * 4 + j].currentState?.getImage()) {
                      // lock matching cards
                      currentCard?.currentState?.lockCard();
                      cardKeys[i * 4 + j].currentState?.lockCard();
                      // clear current card
                      currentCard = null;
                      addMatches();
                      if (matches == 10) {
                        finshGame();
                      }
                    } else {
                      // turn down unmatching cards
                      cardKeys[i * 4 + j].currentState?.setFlipState(false);
                      currentCard?.currentState?.setFlipState(false);
                      currentCard = null;
                    }
                    canTap = true;
                  });
                } else {
                  // sets current as the only card flipped
                  currentCard = cardKeys[i * 4 + j];
                }
              }
            });
        row.children.add(card);
      }
      cardGrid.add(row);
    }
    return cardGrid;
  }

  List<GlobalKey<_CardState>> cardKeys =
      List.generate(20, (_) => GlobalKey<_CardState>());

  GlobalKey<_CardState>? currentCard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !endGame
          ? AppBar(
              shape: const Border(
                bottom: BorderSide(color: Colors.white, width: 2.0),
              ),
              backgroundColor: const Color(0xff1a1b2d),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget._nickName != ""
                      ? widget._nickName
                      : "Uma Maldição?"),
                  Text("Jogadas: $plays")
                ],
              ))
          : null,
      body: DecoratedBox(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/background.jpg"),
                fit: BoxFit.none,
                repeat: ImageRepeat.repeat)),
        child: Center(
            child: SizedBox(
          width: 500,
          height: 600,
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
              child: !endGame
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: creatCardGrid())
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xff1a1b2d),
                                border: Border.all(
                                    color: Colors.white, width: 2.0)),
                            child: Center(
                              child: Text(
                                "Parabéns ${widget._nickName}",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 30.0),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.white, width: 2.0)),
                          child: const Image(
                            image: AssetImage("assets/gojo_approves.png"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xff1a1b2d),
                                border: Border.all(
                                    color: Colors.white, width: 2.0)),
                            child: Center(
                                child: Text("Total de Jogadas: $plays",
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20.0))),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                                style: ButtonStyle(
                                    fixedSize: const MaterialStatePropertyAll(
                                        Size(100.0, 20.0)),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    backgroundColor:
                                        const MaterialStatePropertyAll(
                                            Color.fromARGB(255, 236, 74, 95))),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Início",
                                    style: TextStyle(fontSize: 15))),
                            ElevatedButton(
                                style: ButtonStyle(
                                    fixedSize: const MaterialStatePropertyAll(
                                        Size(180.0, 20.0)),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    backgroundColor:
                                        const MaterialStatePropertyAll(
                                            Color.fromARGB(255, 236, 74, 95))),
                                onPressed: () {
                                  resetGame();
                                },
                                child: const Text("Jogar Novamente",
                                    style: TextStyle(fontSize: 15)))
                          ],
                        )
                      ],
                    )),
        )),
      ),
    );
  }
}

class Card extends StatefulWidget {
  const Card({super.key, required String frontImage, required this.onFlip})
      : _frontImage = frontImage;

  final String _frontImage;
  final String backImage = "assets/jjk_Cards.png"; // back card image
  final VoidCallback onFlip;

  @override
  State<Card> createState() => _CardState();
}

class _CardState extends State<Card> {
  bool isFlipped = false;
  bool found = false;

  bool getFlipState() {
    return isFlipped;
  }

  void setFlipState(bool state) {
    setState(() {
      isFlipped = state;
    });
  }

  void lockCard() {
    setState(() {
      found = true;
      isFlipped = true;
    });
  }

  void unlockCard() {
    setState(() {
      found = false;
    });
  }

  String getImage() {
    return widget._frontImage;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!found && !isFlipped) {
          widget.onFlip();
        }
      },
      child: AnimatedContainer(
        decoration: BoxDecoration(
            color: const Color(0xff1a1b2d),
            border: Border.all(color: Colors.white, width: 2.0)),
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 500),
        width: 70.0,
        height: 80.0,
        alignment: Alignment.center,
        child: isFlipped
            ? widget._frontImage.length > 1
                ? Image(image: AssetImage(widget._frontImage), fit: BoxFit.fill)
                : Text(
                    widget._frontImage,
                    style: const TextStyle(fontSize: 20.0, color: Colors.white),
                  )
            : Image(image: AssetImage(widget.backImage), fit: BoxFit.fill),
      ),
    );
  }
}
