import 'dart:convert';
import 'dart:io';

import 'package:file_picker_cross/file_picker_cross.dart';

typedef NewDataCallback = void Function(OutputLine);

class OutputLine {
  final String data;
  final bool isError;

  OutputLine(this.data, this.isError);
}

class DetectRunner {
  Future<Process> runScan(void newDataCallback(OutputLine outputLine)) async {
    print("Asking for source");
    var filePickerCross = await FilePickerCross.importFromStorage(type: FileTypeCross.any);

    var directory = filePickerCross.directory;
    if (directory.startsWith("//")) {
      directory = directory.substring(1);
    }
    print("Source directory: $directory");

    var detectArgs = ['--detect.source.path=$directory'];
    var properties = File(filePickerCross.path).readAsLinesSync().map((property) => '--$property');
    detectArgs.addAll(properties);

    print("Downloading Detect");
    var detectShFile = await _downloadDetect();

    print("Starting Detect");
    var process = await _runDetect(detectShFile, detectArgs, newDataCallback);

    print("Exit Code: ${await process.exitCode}");

    return process;
  }

  Future<File> _downloadDetect() async {
    var detectShFile = File('detect.sh');
    var request = await HttpClient().getUrl(Uri.parse('https://detect.synopsys.com/detect.sh'));
    var response = await request.close();
    response.pipe(detectShFile.openWrite());

    await Process.run("chmod", ["+x", "--", detectShFile.absolute.path]);

    return detectShFile;
  }

  Future<Process> _runDetect(File detectShFile, List<String> detectArgs, NewDataCallback newDataCallback) async {
    var process = await Process.start(detectShFile.absolute.path, detectArgs);

    process.stdout.transform(utf8.decoder).listen((data) {
      print(data);
      var containsWarning = data.contains("WARN");
      newDataCallback.call(OutputLine(data, containsWarning));
    });
    process.stderr.transform(utf8.decoder).listen((data) {
      print(data);
      newDataCallback.call(OutputLine(data, true));
    });

    return process;
  }
}
