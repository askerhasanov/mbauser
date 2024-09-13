import 'package:flutter/material.dart';
import 'package:mbauser/elements/colors.dart';
import '../../models/moto.dart';

class MotoThumbnail extends StatefulWidget {
  final Moto moto;
  final VoidCallback onTap;

  const MotoThumbnail({super.key, required this.moto, required this.onTap});

  @override
  State<MotoThumbnail> createState() => _MotoThumbnailState();
}

class _MotoThumbnailState extends State<MotoThumbnail> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Add border radius to the entire card
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image slider using PageView (no onTap here)
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ), // Apply the border radius to the image container
                  child: PageView.builder(
                    itemCount: widget.moto.images.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                        ),
                         // Placeholder background color
                        child: FittedBox(
                          fit: BoxFit.contain, // Ensures the image fits within the box
                          child: Image.network(
                            widget.moto.images[index],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Indicators (dots)
                Positioned(
                  bottom: 8,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(widget.moto.images.length, (index) {
                      return Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentImageIndex == index
                              ? Colors.red
                              : Colors.grey,
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          // Other details that can be tapped
          GestureDetector(
            onTap: widget.onTap, // onTap outside the image part
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.moto.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: MbaColors.red
                    ),
                  ),
                  const SizedBox(height: 5,),
                  Text(widget.moto.about, overflow: TextOverflow.ellipsis, maxLines: 3, textAlign: TextAlign.justify, style: const TextStyle(fontSize: 12),),
                  const SizedBox(height: 5,),
                  Text('Qiymət: ${widget.moto.price} azn'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
