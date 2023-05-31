import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:get/get.dart';
import 'package:http_web_scrap/Screens/content_screen.dart';

void main() {
  runApp(const MyApp());
}

class MaterialColorGenerator {
  static MaterialColor from(Color color) {
    return MaterialColor(color.value, <int, Color>{
      50: color.withOpacity(0.1),
      100: color.withOpacity(0.2),
      200: color.withOpacity(0.3),
      300: color.withOpacity(0.4),
      400: color.withOpacity(0.5),
      500: color.withOpacity(0.6),
      600: color.withOpacity(0.7),
      700: color.withOpacity(0.8),
      800: color.withOpacity(0.9),
      900: color.withOpacity(1.0),
    });
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch:
            MaterialColorGenerator.from(Color.fromRGBO(0, 36, 136, 1)),
        scaffoldBackgroundColor: Color.fromRGBO(11, 11, 20, 1),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
        ),
        scrollbarTheme:
            ScrollbarThemeData(thumbVisibility: MaterialStatePropertyAll(true)),
      ),
      home: const MyHomePage(title: 'Web Scrapping'),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => MyApp(),
        ),
        GetPage(
            name: '/content_screen',
            page: () => ContentScreen(),
            transition: Transition.rightToLeft)
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> titles = [];
  List<String> imageLinks = [];
  List<dynamic> titleUrls = [];
  List<dynamic> content = [];
  @override
  void initState() {
    getWebsiteData();
    super.initState();
  }

  Future getWebsiteData() async {
    final url = Uri.parse('https://www.freecodecamp.org/news/tag/blog');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    final titles = html
        .querySelectorAll('h2 > a')
        .map((element) => element.innerHtml.trim())
        .toList();

    final titleUrls = html
        .querySelectorAll('div > div > header > h2 > a')
        .map((element) => element.attributes)
        .toList();

    final imageLinks = html
        .querySelectorAll('a.post-card-image-link > img')
        .map((element) => element.attributes['src']!)
        .toList();
    // print(titles.length);
    setState(() {
      this.titles = titles;
      this.imageLinks = imageLinks;
      this.titleUrls = titleUrls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: ListView.separated(
          padding: const EdgeInsets.all(12),
          itemBuilder: (ctx, index) => Column(
                children: [
                  Text(
                    titles[index],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  InkWell(
                    onTap: () async {
                      final link = 'https://www.freecodecamp.org' +
                          titleUrls[index]['href'];
                      final url = Uri.parse(link);
                      final response = await http.get(url);
                      dom.Document html = dom.Document.html(response.body);
                      final content = html
                          .querySelectorAll(
                              '#site-main > div > article > section > div.post-and-sidebar > section > p')
                          .map((e) => e.innerHtml)
                          .toList();

                      // final pUrl = html
                      //     .querySelectorAll(
                      //         '#site-main > div > article > section > div.post-and-sidebar > section > p > a')
                      //     .map((e) => e.innerHtml)
                      //     .toList();

                      RegExp regExp = RegExp(
                          '<(?:"[^"]*"[\'"]*|\'[^\']*\'[\'"]*|[^\'">])+>');

                      for (int i = 0; i < content.length; i++) {
                        content[i] = content[i].replaceAll(regExp, "");
                      }

                      Get.toNamed('content_screen',
                          arguments: [content, titles[index]]);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(imageLinks[index],
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover),
                    ),
                  ),
                ],
              ),
          separatorBuilder: (ctx, index) => const SizedBox(
                height: 12,
              ),
          itemCount: titles.length),
    );
  }
}
