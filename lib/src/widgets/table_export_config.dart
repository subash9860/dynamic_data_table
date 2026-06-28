/// App-level configuration for the shared dynamic table.
///
/// The Excel-export button is permission-gated, but the permission key is
/// app-specific (restaurant vs admin). Each app sets [exportPermission] once at
/// startup; `null` means the button is always shown.
class TableExportConfig {
  TableExportConfig._();

  /// Permission key required to show the table's Excel-export button.
  /// `null` = always show.
  static String? exportPermission;
}
