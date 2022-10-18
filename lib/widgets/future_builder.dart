import 'package:flutter/material.dart';

FutureBuilder futureBuilder(
  Future future,
  Widget Function(dynamic data) widget,
  dynamic initialData,
) =>
    FutureBuilder(
      initialData: initialData,
      future: future,
      builder: (context, snapshot) => snapshot.hasError
          ? Text('An error occurred:\n${snapshot.error}')
          : snapshot.connectionState != ConnectionState.done
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : widget(snapshot.data),
    );
