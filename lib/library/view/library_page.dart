import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_test/details/detials.dart';
import 'package:go_router_test/widgets/app_image.dart';
import 'package:go_router_test/widgets/image_fade.dart';

const imageUrls = [
  'https://www.themoviedb.org/t/p/original/uKvVjHNqB5VmOrdxqAt2F7J78ED.jpg',
  'https://www.themoviedb.org/t/p/original/sv1xJUazXeYqALzczSZ3O6nkH75.jpg',
  'https://www.themoviedb.org/t/p/original/2g9ZBjUfF1X53EinykJqiBieUaO.jpg',
  'https://www.themoviedb.org/t/p/original/wjOHjWCUE0YzDiEzKv8AfqHj3ir.jpg',
  'https://image.tmdb.org/t/p/original/oodPJ3Op1pWBhnEFyw5fampRCWf.jpg',
  'https://www.themoviedb.org/t/p/original/8Ji1h0nZB1fmimAalfi97fnKfXg.jpg',
  'https://www.themoviedb.org/t/p/original/9CxWs95VQWlOAdgE0iadrz3RPwH.jpg',
  'https://www.themoviedb.org/t/p/original/B7m21gukMeVK3NAuk1PLCo9C8p.jpg',
  'https://www.themoviedb.org/t/p/original/SIY6lVRZ9W1C4GU3Dvi3l4MSFs.jpg',
  'https://image.tmdb.org/t/p/original/t6HIqrRAclMCA60NsSmeqe9RmNV.jpg',
  'https://www.themoviedb.org/t/p/original/ngl2FKBlU4fhbdsrtdom9LVLBXw.jpg',
  'https://www.themoviedb.org/t/p/original/vvKuYw2vmaBbWNgNxEQkuYYpX2l.jpg',
  'https://www.themoviedb.org/t/p/original/dmO2U0ckWkE6T5hyYY3rUtSH9X4.jpg',
  'https://www.themoviedb.org/t/p/original/kuf6dutpsT0vSVehic3EZIqkOBt.jpg',
  'https://www.themoviedb.org/t/p/original/3whQLi8RI7h2h2Si2KTDFJxfEcR.jpg',
];

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  /// Method for pushing to this route within the app.
  static void go(BuildContext context) => context.goNamed(LibraryPage.name);

  static const path = '/library';
  static const name = 'library';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: const [
          Expanded(child: ImageTester()),

          // Expanded(child: const ImageTester()),
          // Expanded(child: const ImageTester()),
          // Expanded(child: const ImageTester()),
        ],
      ),
    );
  }
}
//   return Center(
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         const Text('Library Page'),
//         const SizedBox(height: 20),
//         OutlinedButton(
//           onPressed: () => DetailsPage.go(
//             context,
//             const MovieDetailsRequest(movieId: '1234'),
//           ),
//           child: const Text('Get movie details for id: 1234'),
//         ),
//       ],
//     ),
//   );
// }
// }

class ImageTester extends StatelessWidget {
  const ImageTester({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: imageUrls.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            width: 100,
            // child: ImageFade(
            //   image:
            //       CachedNetworkImageProvider(imageUrls[index], maxWidth: 100),
            //   duration: Duration(milliseconds: 300),
            //   syncDuration: Duration.zero,
            // ),
            child: AppImage(
              src: imageUrls[index],
              aspectRatio: 2 / 3,
              shouldOptimize: true,
              // maxWidth: 100,
            ),
          ),
        );
      },
    );
  }
}
