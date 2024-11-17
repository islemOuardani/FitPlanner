import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fit_planner/controllers/user_controller.dart';
import 'package:fit_planner/models/recipe_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class RecipePage extends StatefulWidget{

  const RecipePage({super.key,});
  @override
  RecipeState createState() => RecipeState();
}

class RecipeState extends State<RecipePage> {

  List<Model> list = <Model>[];
  bool isLoading = false;

  Future<void> fetchRecipes(String q) async {

    int cal = await UserController.requiredKcal(UserController.user);

    const String apiUrl = 'https://api.edamam.com/api/recipes/v2';
    const String appId = 'f52cddcc';
    const String appKey = '51dfb2ab317ff550576228b3b0403885';
    const String userId = 'islemOuardani';

    final Uri uri = Uri.parse('$apiUrl?type=public&q=$q&app_id=$appId&app_key=$appKey&calories=$cal');

    try {
      setState(() {
        isLoading = true;
        list.clear();
      });
      final response = await http.get(
        uri,
        headers: {
          'Edamam-Account-User': userId,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        data['hits'].forEach((e){
          Model model = Model(
              url: e['recipe']['url'],
              image: e['recipe']['image'],
              source: e['recipe']['source'],
              label: e['recipe']['label']
          );
          setState(() {
            list.add(model);
          });
        });
      } else {
        print('Error: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Request failed: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchRecipes("chicken");
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    String q;
    return Scaffold(
      appBar: AppBar(
        title: Text('Find a receipt that match your goal'),
      ) ,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search...',
                  hintText: 'Type an ingredient...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.arrow_forward), // Submit button inside the TextField
                    onPressed: () {
                      q = searchController.text;
                      fetchRecipes(q);
                    },
                  ),
                ),
                onSubmitted: (value) {
                  fetchRecipes(value);
                },
              ),
              const SizedBox(height: 20,),
              isLoading
                  ? const Center (
                child: CircularProgressIndicator(),
              )
                  : GridView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                primary: true,
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 50,
                ),
                itemCount: list.length,
                itemBuilder: (context,index) {
                  final x = list[index];
                  return InkWell(
                      onTap: (){
                        print(x.url!);
                        if(x.url != null){
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context)=> WebPage(
                                url: x.url,
                                label: x.label,
                              )));
                        }},
                      child: Column(
                        children: [
                          Card(
                            child: SizedBox(
                              height: 110.0, // Set fixed height
                              child: Image.network(
                                x.image.toString(),
                                fit: BoxFit.cover, // Ensure image fits nicely
                              ),
                            ),
                          ),
                          SizedBox(height: 0.0,),
                          Text(x.label.toString()),
                          SizedBox(height: 5.0,),
                          Text("Source: ${x.source}",
                            style: TextStyle(color: Colors.grey, fontSize: 12, ),),
                        ],
                      )
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class WebPage extends StatelessWidget {
  final String? url;
  final String? label;
  WebPage({required this.url, required this.label});
  @override
  Widget build(BuildContext context) {
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url!));
    return Scaffold(
      appBar: AppBar(
        title: Text(label!),
      ),
      body: SafeArea(
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}