import 'package:flutter/material.dart';

class ProductSize extends StatefulWidget {
  final List pros;

  final Function(String) onselected;
  const ProductSize({super.key, required this.pros, required this.onselected});

  @override
  State<ProductSize> createState() => _ProductSizeState();
}

class _ProductSizeState extends State<ProductSize> {
  int _selectedindex = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (var i = 0; i < widget.pros.length; i++)
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.onselected("${widget.pros[i]}");
                  _selectedindex = i;
                });
              },
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: _selectedindex == i
                        ? Colors.orange
                        : Color.fromARGB(255, 181, 177, 177)),
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                ),
                child: Text(
                  "${widget.pros[i]}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _selectedindex == i ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
