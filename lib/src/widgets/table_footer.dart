// import 'package:flutter/material.dart';

// class TablePaginationFooter extends StatelessWidget {
//   final int currentPage;
//   final int totalPages;
//   final int totalItems;
//   final int rowsPerPage;

//   final List<int> rowsPerPageOptions;
//   final Function(int) onRowsPerPageChanged;
//   final VoidCallback onPrevious;
//   final VoidCallback onNext;

//   const TablePaginationFooter({
//     super.key,
//     required this.currentPage,
//     required this.totalPages,
//     required this.totalItems,
//     required this.rowsPerPage,
//     required this.onRowsPerPageChanged,
//     required this.onPrevious,
//     required this.onNext,
//     this.rowsPerPageOptions = const [25, 50, 100],
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
//       decoration: BoxDecoration(
//         color: theme.cardColor,
//         border: const Border(top: BorderSide(color: Colors.black12)),
//       ),
//       child: Row(
//         children: [
//           /// LEFT SIDE - Info
//           Text(
//             "Page $currentPage of $totalPages • $totalItems items",
//             style: theme.textTheme.bodyMedium,
//           ),

//           const Spacer(),

//           /// CENTER - Pagination buttons
//           Row(
//             children: [
//               IconButton(
//                 onPressed: currentPage > 1 ? onPrevious : null,
//                 icon: const Icon(Icons.chevron_left),
//                 tooltip: "Previous",
//               ),

//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 6,
//                 ),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   color: theme.colorScheme.primary.withValues(alpha:0.1),
//                 ),
//                 child: Text(
//                   "$currentPage",
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: theme.colorScheme.primary,
//                   ),
//                 ),
//               ),

//               IconButton(
//                 onPressed: currentPage < totalPages ? onNext : null,
//                 icon: const Icon(Icons.chevron_right),
//                 tooltip: "Next",
//               ),
//             ],
//           ),

//           const SizedBox(width: 20),

//           /// RIGHT SIDE - Rows per page
//           Row(
//             children: [
//               Text("Rows:", style: theme.textTheme.bodyMedium),
//               const SizedBox(width: 8),

//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Colors.black26),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: DropdownButton<int>(
//                   value: rowsPerPage,
//                   underline: const SizedBox(),
//                   padding: EdgeInsets.zero,
//                   items: rowsPerPageOptions
//                       .map((e) => DropdownMenuItem(value: e, child: Text("$e")))
//                       .toList(),
//                   onChanged: (value) {
//                     if (value != null) {
//                       onRowsPerPageChanged(value);
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class TablePaginationFooter extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int rowsPerPage;

  final List<int> rowsPerPageOptions;
  final Function(int) onRowsPerPageChanged;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const TablePaginationFooter({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.rowsPerPage,
    required this.onRowsPerPageChanged,
    required this.onPrevious,
    required this.onNext,
    this.rowsPerPageOptions = const [25, 50, 100],
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSmall = MediaQuery.of(context).size.width < 600;

    final info = Text(
      "Page $currentPage of $totalPages • $totalItems items",
      style: theme.textTheme.bodyMedium,
    );

    final paginationControls = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: currentPage > 1 ? onPrevious : null,
          icon: const Icon(Icons.chevron_left),
          tooltip: "Previous",
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
          ),
          child: Text(
            "$currentPage",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        IconButton(
          onPressed: currentPage < totalPages ? onNext : null,
          icon: const Icon(Icons.chevron_right),
          tooltip: "Next",
        ),
      ],
    );

    final rowsDropdown = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Rows:", style: theme.textTheme.bodyMedium),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<int>(
            value: rowsPerPage,
            underline: const SizedBox(),
            padding: EdgeInsets.zero,
            items: rowsPerPageOptions
                .map((e) => DropdownMenuItem(value: e, child: Text("$e")))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                onRowsPerPageChanged(value);
              }
            },
          ),
        ),
      ],
    );

    final borderSide = BorderSide(
      color: theme.colorScheme.outline.withValues(alpha: 0.15),
      width: 0.5,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(
          top: borderSide,
          left: borderSide,
          right: borderSide,
          bottom: borderSide,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),

      /// 🔥 RESPONSIVE SWITCH
      child: isSmall
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                info,
                const SizedBox(height: 8),

                /// second row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [paginationControls, rowsDropdown],
                ),
              ],
            )
          : Row(
              children: [
                info,
                const Spacer(),
                paginationControls,
                const SizedBox(width: 20),
                rowsDropdown,
              ],
            ),
    );
  }
}
