import 'package:drugapp/src/pages/client/categoriaProductos_page.dart';
import 'package:drugapp/src/utils/route.dart';
import 'package:drugapp/src/utils/theme.dart';
import 'package:flutter/material.dart';

class HomeCategory extends StatefulWidget {
  final dynamic cat;
  HomeCategory({Key key, this.cat}) : super(key: key);

  @override
  _HomeCategoryState createState() => _HomeCategoryState();
}

class _HomeCategoryState extends State<HomeCategory> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => widget.cat['name'] == 'Más categorías'
          ? Navigator.pushNamed(context, '/categorias').then((value) => setState(() {}))
          : Navigator.pushNamed(
              context,
              '/productos',
            ).then((value) => setState(() {})),
      child: Container(
        width: MediaQuery.of(context).size.width > 1000
            ? MediaQuery.of(context).size.width * 0.18
            : MediaQuery.of(context).size.width * 0.5,
        padding: EdgeInsets.symmetric(
            horizontal: smallPadding / 2, vertical: smallPadding / 2),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(smallPadding * 0.7),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                blurRadius: 3.0, // soften the shadow
                spreadRadius: 0.5, //extend the shadow
                offset: Offset(
                  0.4, // Move to right 10  horizontally
                  2.5, // Move to bottom 10 Vertically
                ),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(smallPadding),
                decoration: BoxDecoration(
                  gradient: gradientBluePurple,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Icon(
                  IconData(int.parse(widget.cat['icon']),
                      fontFamily: 'MaterialIcons'),
                  // child: Icon(
                  //   cat['icon'],
                  color: Colors.white,
                  size: MediaQuery.of(context).size.width > 700 ? 50 : 30,
                ),
              ),
              SizedBox(width: 10),
              Flexible(
                  child: Text(
                widget.cat['name'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 17),
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class HomeInfoCard extends StatefulWidget {
  final String title;
  final String image;
  final String nav;
  HomeInfoCard({Key key, this.title, this.image, this.nav}) : super(key: key);

  @override
  _HomeInfoCardState createState() => _HomeInfoCardState();
}

class _HomeInfoCardState extends State<HomeInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: smallPadding, vertical: smallPadding),
      child: InkWell(
        onTap: () =>
            Navigator.pushNamed(context, widget.nav).then((value) => setState(() {})),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.width < 1000
                  ? MediaQuery.of(context).size.width / 2.5
                  : MediaQuery.of(context).size.width / 7,
              // width: MediaQuery.of(context).size.width < 1000
              //     ? MediaQuery.of(context).size.width
              //     : MediaQuery.of(context).size.width / 3.5,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      colorFilter: new ColorFilter.mode(
                          Colors.black.withOpacity(0.3), BlendMode.colorBurn),
                      fit: BoxFit.cover,
                      image: AssetImage('images/${widget.image}'))),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: smallPadding,
                      bottom: smallPadding,
                      left: smallPadding,
                      right: medPadding * 4),
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 27),
                  ),
                ),
              ),
            ),
            Container(
                height: 6,
                // width: MediaQuery.of(context).size.width < 1000
                //     ? MediaQuery.of(context).size.width
                //     : MediaQuery.of(context).size.width / 3.5,
                decoration: BoxDecoration(gradient: gradientDrug),
                child: Container())
          ],
        ),
      ),
    );
  }
}

cardInfoDrug(context) {
  return Container(
    padding: EdgeInsets.all(smallPadding),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            padding: EdgeInsets.all(smallPadding),
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(100)),
            child: Icon(
              Icons.favorite_border_outlined,
              color: Colors.blue,
              size: 55,
            )),
        SizedBox(height: smallPadding),
        Text(
          'Paga con tarjeta de crédito o débito.',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w700, color: Colors.grey, fontSize: 17),
        ),
        SizedBox(height: smallPadding),
        Text(
          'No te preocupes por tu información, tus transacciones están seguras con nosotros.',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w400, color: Colors.grey, fontSize: 17),
        )
      ],
    ),
  );
}
