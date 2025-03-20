import 'package:flutter/material.dart';

import 'index.dart';

class SeeMoreList<T> extends StatelessWidget {
  const SeeMoreList({
    super.key,
    required this.items,
    required this.itemBuilder,
    required this.onSeeMore,
    this.defaultItemCount = 3,
  });

  final List<T> items;
  final Widget Function(T item, int? index) itemBuilder;
  final VoidCallback onSeeMore;
  final int defaultItemCount;

  @override
  Widget build(BuildContext context) {
    final maxItemCount = items.length > defaultItemCount ? defaultItemCount : items.length;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < maxItemCount; i++) itemBuilder(items[i], i),
        if (items.length > defaultItemCount)
          Align(
            alignment: Alignment.centerRight,
            child: SeeMoreWidget(
              onTap: onSeeMore,
            ),
          ),
      ],
    );
  }
}

class ExpandMoreList<T> extends StatefulWidget {
  const ExpandMoreList({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.defaultItemCount = 3,
  });

  final List<T> items;
  final Widget Function(T item, int? index) itemBuilder;
  final int defaultItemCount;

  @override
  State<ExpandMoreList<T>> createState() => _ExpandMoreListState<T>();
}

class _ExpandMoreListState<T> extends State<ExpandMoreList<T>> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();

    // Tạo AnimationController
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(covariant ExpandMoreList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items.length <= widget.defaultItemCount) {
      _isExpanded = false;
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward(); // Mở rộng
      } else {
        _controller.reverse(); // Thu gọn
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final visibleItems = widget.items.take(widget.defaultItemCount).toList();
    final expandItems = widget.items.skip(visibleItems.length).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Danh sách hiển thị mặc định
        ...List.generate(
          visibleItems.length,
          (index) => widget.itemBuilder(visibleItems[index], index),
        ),

        // Danh sách mở rộng có animation
        SizeTransition(
          sizeFactor: _animation,
          axisAlignment: -1.0, // Hiển thị từ trên xuống dưới
          child: Column(
            children: List.generate(
              expandItems.length,
              (index) => widget.itemBuilder(expandItems[index], index + widget.defaultItemCount),
            ),
          ),
        ),

        // Nút "Xem tất cả" hoặc "Thu gọn"
        if (widget.items.length > widget.defaultItemCount)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: OutlinedButton(
              onPressed: _toggleExpand,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  ),
                  const SizedBox(width: 4),
                  Text(_isExpanded ? 'Thu gọn' : 'Xem tất cả'),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
