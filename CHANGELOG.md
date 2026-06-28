## 1.0.1

- Updates and improvements.

## 1.0.0

Initial production-grade release with complete feature set:

### Core Features
- **Row Selection** - Checkboxes with select-all functionality for bulk operations
- **Sorting** - Clickable column headers with visual sort indicators (ascending/descending arrows)
- **Filtering** - Per-column filtering with custom filter value builders
- **Pagination** - Page navigation with customizable rows-per-page selection
- **Search** - Local and remote search support with debounce
- **Export System** - Pluggable export formats (Excel via Syncfusion, CSV, custom formats)
- **Date Filtering** - Calendar picker UI for date range filtering
- **Date Filter Model** - Built-in date range filtering with start/end date pickers
- **Loading States** - Spinner overlay for async data loading
- **Error States** - Error message display and error state handling
- **Responsive Design** - Adaptive layout for desktop, tablet, and mobile screens
- **Custom Cell Builders** - Full control over cell rendering per column
- **Custom Export Builders** - Per-column export value customization
- **Custom Filter Builders** - Per-column filter value extraction

### Configuration & Customization
- **Centralized TableConfig** - All strings and settings in one config object
- **i18n Ready** - All UI strings customizable via TableConfig for internationalization
- **Keyboard Navigation** - Full keyboard support for navigation and selection
- **Accessibility** - Semantic widgets and ARIA labels for screen reader support
- **Custom Empty State** - Replaceable empty data widget
- **Custom Total Cell Builder** - Footer rows with totals per column
- **Resizable Columns** - Column width adjustment capability
- **Flexible Column Sizing** - flex factor and fixed width support
- **Column Visibility Toggle** - Show/hide columns with column picker dialog

### Data Processing
- **Table Data Processor** - Utility for sorting, filtering, and paginating data
- **Row Selection State** - Managed state for selected rows
- **Pagination Response** - Type-safe pagination metadata

### Developer Experience
- **Zero App-Level Dependencies** - Uses only Flutter, data_table_2, intl, and optional export libraries
- **Generic Type Safety** - Full TypeScript-like generics for type-safe data handling
- **Callback-Based** - Simple callback patterns for all interactions
- **Composable Widgets** - Export individual UI components for custom implementations
- **Example App** - Comprehensive example with all features demonstrated

### Testing
- **Unit Tests** - Test suite for core models and utilities
- **Widget Tests** - Tests for UI components
- **CI/CD Ready** - GitHub Actions workflows for testing and publishing

### Quality & Publishing
- **pub.dev Ready** - Fully compliant with pub.dev packaging standards
- **GitHub Repository** - Official repository with issue tracking
- **MIT License** - Open source license
- **Semantic Versioning** - Professional version management with Makefile helpers
