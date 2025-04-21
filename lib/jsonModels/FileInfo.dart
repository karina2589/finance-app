class FileInfo {
  /*
  "file": {
        "fieldname": "bankstatement",
        "originalname": "kaspi_gold_statement.pdf",
        "encoding": "7bit",
        "mimetype": "application/pdf",
        "destination": "uploads/documents",
        "filename": "1744699881239-967885668-kaspi_gold_statement.pdf",
        "path": "uploads/documents/1744699881239-967885668-kaspi_gold_statement.pdf",
        "size": 58829
    }
   */

  final String fieldname;
  final String originalname;
  final String encoding;
  final String mimetype;
  final String destination;
  final String path;
  final int size;

  FileInfo({
    required this.fieldname,
    required this.originalname,
    required this.encoding,
    required this.mimetype,
    required this.destination,
    required this.path,
    required this.size
  });

  factory FileInfo.fromJson(Map<String, dynamic> json){
    return FileInfo(
        fieldname: json['fieldname'],
        originalname: json['originalname'],
        encoding: json['encoding'],
        mimetype: json['mimetype'],
        destination: json['destination'],
        path: json['path'],
        size: (json['size'] as num).toInt()
    );
  }
}