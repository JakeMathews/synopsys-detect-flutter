import 'dart:convert';
import 'dart:io';

typedef NewDataCallback = void Function(OutputLine);

class OutputLine {
  final String data;
  final bool isError;

  OutputLine(this.data, this.isError);
}

class DetectRunner {
  Future<File> downloadDetect() async {
    var detectShFile = File('detect.sh');
    var request = await HttpClient().getUrl(Uri.parse('https://detect.synopsys.com/detect.sh'));
    var response = await request.close();
    response.pipe(detectShFile.openWrite());

    await Process.run("chmod", ["+x", "--", detectShFile.absolute.path]);

    return detectShFile;
  }

  Future<Process> runDetect(File detectShFile, List<String> detectArgs, NewDataCallback newDataCallback) async {
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
