class Report {
  Report(
      {required this.reason,
      required this.postId,
      required this.postUserId,
      required this.reportUserId});
  final String postId;
  final String postUserId;
  final String reportUserId;
  final String reason;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'postId': postId,
        'postUserId': postUserId,
        'reportUserId': reportUserId,
        'reason': reason,
      };

  factory Report.fromSnap(dynamic snap) {
    return Report(
      postId: snap['postId'] as String,
      postUserId: snap['postUserId'] as String,
      reportUserId: snap['reportUserId'] as String,
      reason: snap['reason'] as String,
    );
  }
}
