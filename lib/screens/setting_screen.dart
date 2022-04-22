import 'package:flutter/material.dart';
import 'package:posttest3_2009106072_gilang/util/theme_notifier.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final int _navigationIndex = 2;
  bool _editCity = false;
  final List<bool> _isOpen = [false, false, false];
  final Map<String, String> _languageMap = const {
    "English": "en",
    "Indonesia": "id",
    "Deutsch": "de",
    "Español": "sp",
    "Português": "pt",
    "日本": "ja",
  };
  String _city = "Samarinda";
  bool _isMetric = false;
  String _language = "English";

  String getThemeModeString(ThemeMode mode) {
    if (mode == ThemeMode.system) {
      return "Pengaturan Sistem";
    } else if (mode == ThemeMode.dark) {
      return "Gelap";
    } else {
      return "Terang";
    }
  }

  @override
  Widget build(BuildContext context) {
    final cityWidget = _editCity
        ? ListTile(
            key: const ValueKey(1),
            tileColor: Theme.of(context).bottomAppBarColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            title: TextField(
              decoration: InputDecoration(
                hintText: "Kota",
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onSubmitted: (value) {
                setState(() {
                  _city = value;
                  _editCity = false;
                });
              },
            ),
            trailing: SizedBox(
              width: 52,
              height: 52,
              child: ElevatedButton(
                child: const Icon(
                  Icons.location_pin,
                ),
                onPressed: () {
                  setState(() {
                    _city = "Samarinda";
                    _editCity = false;
                  });
                },
              ),
            ),
          )
        : ListTile(
            key: const ValueKey(2),
            tileColor: Theme.of(context).bottomAppBarColor,
            contentPadding: const EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Kota"),
                Text(_city),
              ],
            ),
            trailing: SizedBox(
              width: 40,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _editCity = true;
                  });
                },
                child: const Icon(
                  Icons.edit,
                  color: Colors.grey,
                ),
              ),
            ),
          );

    return Scaffold(
      body: ListView(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) {
              final offsetAnimation = Tween<Offset>(
                begin: const Offset(-0.5, 0),
                end: const Offset(0, 0),
              ).animate(animation);

              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: offsetAnimation,
                  child: child,
                ),
              );
            },
            child: cityWidget,
          ),
          ExpansionPanelList(
            animationDuration: const Duration(milliseconds: 500),
            expandedHeaderPadding: const EdgeInsets.all(10),
            expansionCallback: (index, isOpen) {
              setState(() {
                _isOpen[index] = !isOpen;
              });
            },
            children: [
              ExpansionPanel(
                canTapOnHeader: true,
                headerBuilder: (_, __) => ExpansionPanelHeader(
                  leadingString: "Tema",
                  trailingString: getThemeModeString(
                    context.watch<ThemeNotifier>().themeMode,
                  ),
                ),
                isExpanded: _isOpen[0],
                body: Column(
                  children: [
                    ListTileRadio(
                      titleString: "Menggunakan Pengaturan Sistem",
                      onTap: () => context
                          .read<ThemeNotifier>()
                          .changeTheme(ThemeMode.system),
                      groupValue: context.watch<ThemeNotifier>().themeMode,
                      value: ThemeMode.system,
                    ),
                    ListTileRadio(
                      titleString: "Terang",
                      onTap: () => context
                          .read<ThemeNotifier>()
                          .changeTheme(ThemeMode.light),
                      groupValue: context.watch<ThemeNotifier>().themeMode,
                      value: ThemeMode.light,
                    ),
                    ListTileRadio(
                      titleString: "Gelap",
                      onTap: () => context
                          .read<ThemeNotifier>()
                          .changeTheme(ThemeMode.dark),
                      groupValue: context.watch<ThemeNotifier>().themeMode,
                      value: ThemeMode.dark,
                    ),
                  ],
                ),
              ),
              ExpansionPanel(
                canTapOnHeader: true,
                headerBuilder: (_, __) => ExpansionPanelHeader(
                  leadingString: "Sistem Pengukuran",
                  trailingString: _isMetric ? "Metrik" : "Imperial",
                ),
                isExpanded: _isOpen[1],
                body: ListTile(
                  leading: Checkbox(
                    value: _isMetric,
                    onChanged: (bool? value) {
                      setState(() {
                        _isMetric = value ?? false;
                      });
                    },
                  ),
                  title: const Text("Menggunakan Metrik?"),
                ),
              ),
              ExpansionPanel(
                canTapOnHeader: true,
                headerBuilder: (_, __) => ExpansionPanelHeader(
                  leadingString: "Bahasa",
                  trailingString: _language,
                ),
                isExpanded: _isOpen[2],
                body: Column(
                  children: _languageMap.keys.map((String e) {
                    return ListTileRadio(
                      titleString: e,
                      groupValue: _language,
                      value: e,
                      onTap: () => setState(() {
                        _language = e;
                      }),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _navigationIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.cloud_outlined,
            ),
            activeIcon: Icon(
              Icons.cloud,
            ),
            label: "Cuaca",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart_outlined),
            label: "Ramalan Cuaca",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
            label: "Pengaturan",
          )
        ],
      ),
    );
  }
}

class ListTileRadio extends StatelessWidget {
  final String titleString;
  final VoidCallback onTap;
  final Object groupValue;
  final Object value;

  const ListTileRadio({
    Key? key,
    required this.titleString,
    required this.onTap,
    required this.groupValue,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(titleString),
      onTap: onTap,
      leading: Radio(
        value: value,
        groupValue: groupValue,
        onChanged: (value) {
          onTap();
        },
      ),
    );
  }
}

class ExpansionPanelHeader extends StatelessWidget {
  final String leadingString;
  final String trailingString;

  const ExpansionPanelHeader({
    Key? key,
    required this.leadingString,
    required this.trailingString,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            leadingString,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Text(
            trailingString,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );
  }
}