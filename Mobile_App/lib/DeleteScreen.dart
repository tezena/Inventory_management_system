import 'package:flutter/material.dart';

class DeleteScreen extends StatelessWidget {
  const DeleteScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        height: 470,
        width: 320,
        decoration: BoxDecoration(
          color: Color(0xffb6B3BE1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(35.0),
              child: Container(
                height: 120.0,
                width: 120.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  color: Color(0xffbFFFFFF),
                ),
                child: Center(
                  child: Image.asset(
                    "lib/icons/garbage.png",
                    height: 85,
                    width: 85,
                  ),
                ),
              ),
            ),
            Container(
                child: Text.new("   You are about to delete a product  ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                      color: Color(0xffbD9D9D9),
                    ))),
            SizedBox(
              height: 30,
            ),
            Container(
                child: Text.new(
              "     This will  delete your product from  ",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                  color: Color(0xffbD9D9D9)),
            )),
            Container(
              child: Text.new(
                " the Catalog Are you sure?            ",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0,
                    color: Color(0xffbD9D9D9)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 80.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: Color(0xffbFFFFFF),
                    textColor: Colors.black,
                    height: 50.0,
                    onPressed: () {},
                    child: Text(
                      ' Cancel ',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: Color(0xffbFFFFFF),
                    textColor: Colors.black,
                    height: 50.0,
                    onPressed: () {},
                    child: Text(
                      '   Delete   ',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
