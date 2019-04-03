import 'package:flutter/material.dart';


class BlogPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
        child: ListView(
          
          padding: const EdgeInsets.symmetric(
            horizontal:7.0,
          ),
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.bookmark),
              title:Text('Several studies have concluded that Hong Kong is located in Asia', overflow: TextOverflow.ellipsis, maxLines: 1,), 
              subtitle: Text('Jacky Angara'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BlogDetailPage()),
                );
              },
            ),
            
            Divider(),
            ListTile(
              leading: Icon(Icons.bookmark),
              title:Text('Is global warming a hoax made by environmentalists to get funding going their way?', overflow: TextOverflow.ellipsis, maxLines: 1,), 
              subtitle: Text('Leonardo Vinsen'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BlogDetailPage()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.bookmark),
              title:Text('Indonesia changed their currency to Indonesian Rupeeah', overflow: TextOverflow.ellipsis, maxLines: 1,), 
              subtitle: Text('Dan Brown'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BlogDetailPage()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.bookmark),
              title:Text('Flat earthers banned the phrase "around the world"', overflow: TextOverflow.ellipsis, maxLines: 1,), 
              subtitle: Text('J. K. Rowling'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BlogDetailPage()),
                );
              },
            ),
            Divider(),
          ],
        ),
    );
  }
}

class BlogDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        
      )
    );
  }
}