/// A production-grade Flutter data table widget with sorting, filtering,
/// pagination, row selection, and pluggable export formats.
library dynamic_data_table;

// Models
export 'src/models/column_def.dart';
export 'src/models/table_config.dart';
export 'src/models/row_selection_state.dart';
export 'src/models/date_filter_model.dart';
export 'src/models/export_provider.dart';
export 'src/models/pagination_response.dart';

// Widgets
export 'src/widgets/dynamic_data_table.dart';
export 'src/widgets/data_table_widget.dart';
export 'src/widgets/dynamic_table_header.dart';
export 'src/widgets/sort_indicator.dart';
export 'src/widgets/filter_dialog.dart';
export 'src/widgets/column_picker_dialog.dart';
export 'src/widgets/table_footer.dart';
export 'src/widgets/table_date_filter.dart';
export 'src/widgets/table_search_field.dart';

// Utils
export 'src/utils/table_data_processor.dart';
