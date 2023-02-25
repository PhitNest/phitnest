part of message;

class _MessageCard extends StatelessWidget {
  final bool sentByMe;
  final String message;

  const _MessageCard({
    Key? key,
    required this.message,
    required this.sentByMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.only(
        top: 12.w,
        bottom: 12.w,
        right: sentByMe ? 32.w : 0.0,
        left: sentByMe ? 0.0 : 32.w,
      ),
      child: Container(
        constraints: BoxConstraints(maxWidth: 225.w),
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: sentByMe ? Color(0xFFF8F7F7) : Color(0xFFFFE3E3),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          message,
        ),
      ),
    );
  }
}
