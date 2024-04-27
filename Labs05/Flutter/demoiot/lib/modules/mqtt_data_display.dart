import 'package:flutter/material.dart';

class DataWidget extends StatefulWidget {
  const DataWidget(
      {super.key,
      required this.dataStream,
      required this.dataUnit,
      required this.dataName,
      required this.dataColor});
  final Stream dataStream;
  final String dataUnit;
  final String dataName;
  final Color dataColor;
  @override
  State<DataWidget> createState() => _DataWidgetState();
}

class _DataWidgetState extends State<DataWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      color: widget.dataColor,
      child: StreamBuilder(
        stream: widget.dataStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.dataName,
                    style: const TextStyle(fontSize: 15, color: Colors.white)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${snapshot.data}',
                      style: const TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    Text(widget.dataUnit,
                        style:
                            const TextStyle(fontSize: 20, color: Colors.white))
                  ],
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
