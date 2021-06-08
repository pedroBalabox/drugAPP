import 'dart:convert';

import 'package:drugapp/src/utils/globals.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:drugapp/src/widget/card_widget.dart';
import 'package:drugapp/src/widget/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class HomeClient extends StatefulWidget {
  HomeClient({Key key}) : super(key: key);

  @override
  _HomeClientState createState() => _HomeClientState();
}

class _HomeClientState extends State<HomeClient> {
  var cat = [];
  @override
  void initState() {
    cat = jsonDecode(dummyCat);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveAppBar(
        screenWidht: MediaQuery.of(context).size.width,
        drawerMenu: true,
        body: BodyHome(cat: cat),
        title: null);
  }
}

final List<String> imgList = [
  'cover1.png',
  'cover2.png',
];


class BodyHome extends StatefulWidget {
  final dynamic cat;
  BodyHome({Key key, this.cat}) : super(key: key);

  @override
  _BodyHomeState createState() => _BodyHomeState();
}

class _BodyHomeState extends State<BodyHome> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
    return Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: ListView(children: [
        CarouselWithIndicatorDemo(),
        Container(
          margin: EdgeInsets.symmetric(
              vertical: smallPadding,
              horizontal: MediaQuery.of(context).size.width > 100
                  ? smallPadding
                  : medPadding),
          color: bgGrey,
          height: MediaQuery.of(context).size.width * 0.35,
          width: MediaQuery.of(context).size.width,
          child: Swiper(
            itemCount: imgList.length,
            itemBuilder: (BuildContext context, int index) =>
                Image.asset("images/${imgList[index]}", fit: BoxFit.cover),
            autoplay: true,
            autoplayDelay: 5000,
            scrollDirection: Axis.horizontal,
            pagination: new SwiperPagination(
                builder: new DotSwiperPaginationBuilder(
                    color: Colors.white.withOpacity(0.5),
                    activeColor: Theme.of(context).primaryColor),
                margin:
                    new EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                alignment: Alignment.bottomCenter),
          ),
        ),
        SizedBox(
          height: smallPadding / 1.5,
        ),
        constraints.maxWidth < 1000
            ? Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.15,
                child: ListView.builder(
                  itemCount: widget.cat.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return HomeCategory(cat: widget.cat[index]);
                  },
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  HomeCategory(cat: widget.cat[0]),
                  HomeCategory(cat: widget.cat[1]),
                  HomeCategory(cat: widget.cat[2]),
                  HomeCategory(cat: widget.cat[3]),
                  HomeCategory(cat: widget.cat[4]),
                ],
              ),
        SizedBox(height: smallPadding),
        Container(
          padding: EdgeInsets.all(0),
          width: MediaQuery.of(context).size.width,
          child: constraints.maxWidth > 1000
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                        child: InkWell(
                          onTap: () => Navigator.pushNamed(context, '/tiendas').then((value) => setState(() {})),
                                                  child: HomeInfoCard(
                              title: 'Tiendas',
                              image: 'drug1.jpg',
                              nav: '/tiendas'),
                        )),
                    Flexible(
                        child: HomeInfoCard(
                            title: 'Productos más vendidos',
                            image: 'drug2.jpg',
                            nav: '/productos')),
                    Flexible(
                        child: HomeInfoCard(
                            title: 'Ofertas del día',
                            image: 'drug3.jpg',
                            nav: '/productos')),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    HomeInfoCard(
                        title: 'Tiendas', image: 'drug1.jpg', nav: '/tiendas'),
                    HomeInfoCard(
                        title: 'Productos más vendidos',
                        image: 'drug2.jpg',
                        nav: '/productos'),
                    HomeInfoCard(
                        title: 'Ofertas del día',
                        image: 'drug3.jpg',
                        nav: '/productos'),
                  ],
                ),
        ),
        SizedBox(height: smallPadding),
        Container(
          padding: EdgeInsets.all(medPadding),
          width: MediaQuery.of(context).size.width,
          color: bgGrey,
          child: constraints.maxWidth > 1000
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(child: cardInfoDrug(context)),
                    Flexible(child: cardInfoDrug(context)),
                    Flexible(child: cardInfoDrug(context)),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    cardInfoDrug(context),
                    cardInfoDrug(context),
                    cardInfoDrug(context),
                  ],
                ),
        ),
        Container(
          padding: EdgeInsets.all(medPadding / 2),
          width: MediaQuery.of(context).size.width,
          color: Color(0xffefefef),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: 'Drug Farmacéutica. ',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey),
              children: <TextSpan>[
                TextSpan(
                    text: 'Todos los derechos reservados 2021.',
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w400))
              ],
            ),
          ),
        )
      ]),
    );
  });
  }
}

class CarouselWithIndicatorDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CarouselWithIndicatorState();
  }
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicatorDemo> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    // final List<Widget> imageSliders = imgList
    //     .map((item) => Container(
    //           height: MediaQuery.of(context).size.width > 1000
    //               ? MediaQuery.of(context).size.height * 0.6
    //               : MediaQuery.of(context).size.height * 0.4,
    //           child: Image.network(item, fit: BoxFit.cover),
    //         ))
    //     .toList();

    return Column(children: []);
  }
}
