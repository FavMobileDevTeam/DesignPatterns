/// «Реализация» моста — умеет экспортировать в конкретный формат.
abstract class DocumentExporter {
  Future<void> export(String content, String fileName);
}

class PdfExporter implements DocumentExporter {
  @override
  Future<void> export(String content, String fileName) async {
    // здесь вы собираете PDF из content и сохраняете под fileName.pdf
    print('Экспорт в PDF: $fileName.pdf');
  }
}

class ExcelExporter implements DocumentExporter {
  @override
  Future<void> export(String content, String fileName) async {
    // собираете XLSX и сохраняете fileName.xlsx
    print('Экспорт в Excel: $fileName.xlsx');
  }
}

class HtmlExporter implements DocumentExporter {
  @override
  Future<void> export(String content, String fileName) async {
    // генерируете HTML-файл
    print('Экспорт в HTML: $fileName.html');
  }
}

/// «Абстракция» моста — документ, которому можно задать экспортер.
abstract class Document {
  final DocumentExporter exporter;

  Document(this.exporter);

  /// Собрать содержимое документа
  String generateContent();

  /// Общий метод: собрать + экспортировать
  Future<void> export(String fileName) {
    final content = generateContent();
    return exporter.export(content, fileName);
  }
}

class Invoice extends Document {
  final String customer;
  final double amount;

  Invoice(DocumentExporter exporter, this.customer, this.amount) : super(exporter);

  @override
  String generateContent() {
    return 'Счёт для $customer на сумму $amount';
  }
}

class SalesReport extends Document {
  final DateTime periodStart;
  final DateTime periodEnd;
  final Map<String, double> data;

  SalesReport(super.exporter, this.periodStart, this.periodEnd, this.data);

  @override
  String generateContent() {
    final buffer = StringBuffer();
    buffer.writeln('Отчёт продаж с $periodStart по $periodEnd');
    data.forEach((item, value) {
      buffer.writeln('$item: $value');
    });
    return buffer.toString();
  }
}

void main() async {
  // Можно легко «подключить» любой экспортёр:
  final pdfExporter = PdfExporter();
  final excelExporter = ExcelExporter();

  // Создаём документ‑счёт и экспортируем его в PDF:
  final invoice = Invoice(pdfExporter, 'ООО Ромашка', 12500);
  await invoice.export('invoice_001');

  // Тот же счёт, но сразу в Excel:
  final invoiceXls = Invoice(excelExporter, 'ООО Ромашка', 12500);
  await invoiceXls.export('invoice_001');

  // Отчёт продаж только в HTML:
  final report = SalesReport(
    HtmlExporter(),
    DateTime(2025, 1, 1),
    DateTime(2025, 1, 31),
    {'Товар A': 10000, 'Товар B': 7500},
  );
  await report.export('jan_sales');
}
