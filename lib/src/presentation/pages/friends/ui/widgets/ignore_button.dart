part of friends_page;

class _LightButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;

  const _LightButton({
    Key? key,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          width: 64.w,
          height: 26.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            border: Border.fromBorderSide(
              BorderSide(
                color: Color(0xFFFFE3E3),
              ),
            ),
          ),
          child: Center(
            child: Text(text),
          ),
        ),
      );
}
