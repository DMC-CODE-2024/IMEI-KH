import 'package:flutter/material.dart';

import 'menu_model.dart';

Widget expendableList(
    List<MenuModel> menuItem, int selected, Function childCallback) {
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return ListView.builder(
      key: Key('builder ${selected.toString()}'),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: menuItem.length,
      itemBuilder: (context, i) {
        bool isValidUrl = Uri.parse(menuItem[i].icon ?? "").isAbsolute;
        return Theme(
            data: Theme.of(context)
                .copyWith(dividerColor: Colors.grey.withAlpha(50)),
            child: ListTileTheme(
              child: ExpansionTile(
                key: Key(i.toString()),
                initiallyExpanded: i == selected,
                //attention
                tilePadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                childrenPadding: const EdgeInsets.only(
                    top: 0, bottom: 0, left: 40, right: 0),
                iconColor: Colors.black,
                title: Row(
                  children: [
                    isValidUrl
                        ? Image.network(menuItem[i].icon ?? "",
                            width: 24, height: 24,
                            errorBuilder: (context, error, stackTrace) {
                            return const SizedBox(width: 24, height: 24,);
                          })
                        : Container(),
                    Container(
                      width: 10,
                    ),
                    Expanded(
                        child: Text(
                      menuItem[i].title ?? "",
                      style: const TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w600),
                    ))
                  ],
                ),
                onExpansionChanged: ((newState) {
                  if (newState) {
                    setState(() {
                      const Duration(seconds: 20000);
                      selected = i;
                    });
                  } else {
                    setState(() {
                      selected = -1;
                    });
                  }
                }),
                children: (menuItem[i].childList != null)
                    ? <Widget>[
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: menuItem[i].childList?.length,
                            itemBuilder: (context, index) {
                              var item = menuItem[i].childList?[index];
                              return ExpansionTile(
                                onExpansionChanged: ((newState) {
                                  childCallback.call(
                                      item?.title ?? "", item?.url ?? "");
                                }),
                                title: Text(item?.title ?? "",
                                    style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w600)),
                                trailing:
                                    const Icon(Icons.keyboard_arrow_right),
                                iconColor: Colors.black,
                              );
                            })
                      ]
                    : [Container()],
              ),
            ));
      },
    );
  });
}
