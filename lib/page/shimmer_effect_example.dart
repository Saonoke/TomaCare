import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Shimmer Example'),
      //   backgroundColor: const Color(0xff0097f7),
      //   foregroundColor: const Color(0xffffffff),
      // ),
      body: Shimmer.fromColors(
        baseColor: Colors.grey[350]!,
        highlightColor: Colors.white,
        child: ListView.separated(
          itemCount: 18,
          padding: const EdgeInsets.all(16),
          separatorBuilder: (context, index) => const SizedBox(
            height: 16,
          ),
          itemBuilder: (context, index) {
            return SizedBox(
              height: 96,
              child: Row(
                children: [
                  Container(
                    height: 96,
                    width: 96,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 20,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      Container(
                        height: 20,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      Row(
                        children: [
                          Container(
                            height: 20,
                            width: 120,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ],
                      ),
                    ],
                  ))
                ],
              ),
            );
          },
        ),
      ),
    );
    // );
    // }
  }
}
