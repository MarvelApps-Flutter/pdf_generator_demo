import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter_pdf_apps/model/invoice.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pdf;

class InvoiceBuilder {
  final Invoice invoice;

  InvoiceBuilder(this.invoice);

  Widget buildInvoice() {
    return PdfPreview(
        pdfFileName: "invoice.pdf",

        allowPrinting: true,

        canChangePageFormat: false,
        canChangeOrientation: false,
        maxPageWidth: 800,
        build: (pageformat) {
          return generateInvoicePdf(pageformat, invoice);
        });
  }

  Future<Uint8List> generateInvoicePdf(
      PdfPageFormat format, Invoice invoice) async {
    var doc = pdf.Document();
    doc.addPage(
        pdf.MultiPage(
        pageFormat: format,
        header: buildHeader,
        build: (context) {
          return [buildContent(invoice)];
        }));

    return doc.save();
  }

  pdf.Widget buildContent(Invoice invoice) {
    return
      pdf.Padding(
          padding: pdf.EdgeInsets.all(8.0),
          child: pdf.Column(
            children: [
              pdf.Container(
                  alignment: pdf.Alignment.center,
                  child: pdf.Text("INVOICE",
                      style: pdf.TextStyle(
                          fontWeight: pdf.FontWeight.bold, fontSize: 24))),
              pdf.Row(
                  mainAxisAlignment: pdf.MainAxisAlignment.spaceAround,
                  children: [
                    pdf.Column(
                        crossAxisAlignment: pdf.CrossAxisAlignment.start,
                        children: [
                          pdf.SizedBox(height: 30),
                          pdf.Text("Bill To",
                              style: pdf.TextStyle(
                                  fontSize: 20,
                                  fontWeight: pdf.FontWeight.bold)),
                          pdf.Text(invoice.clientName!,
                              ),
                          pdf.Text(invoice.clientCompanyName!,
                              ),
                          pdf.Text(invoice.clientAddress!,
                             ),
                          pdf.Text(invoice.clientContactNo!,
                             ),
                          _UrlText(invoice.clientEmail!,'mailto:${invoice.clientEmail}'),
                          // pdf.Text(invoice.clientEmail!,
                          //     style: pdf.TextStyle(fontSize: 16)),
                        ]),
                    pdf.Spacer(),
                    pdf.Column(
                        crossAxisAlignment: pdf.CrossAxisAlignment.start,
                        children: [
                          pdf.Text("${invoice.invoiceNumber}",
                              style: pdf.TextStyle(
                                  fontSize: 20,
                                  fontWeight: pdf.FontWeight.bold)),
                          pdf.Text("${invoice.invoiceDate}",
                              style: pdf.TextStyle(fontSize: 16))
                        ])
                  ]),
              pdf.SizedBox(height: 20),
              buildTableContent(),
              pdf.SizedBox(height: 20),
              buildTermsAndCon()
            ],
          ));
  }

  pdf.Widget buildTableContent() {
    const tableHeaders = ["No.", "Products", "Amount"];
    var sum = invoice.itemList!
        .map<int>((m) => int.parse(m.rate!))
        .reduce((a, b) => a + b);
    return pdf.Column(children: [
      pdf.Table.fromTextArray(
          border: const pdf.TableBorder(
            right: pdf.BorderSide(color: PdfColors.grey),
            left: pdf.BorderSide(color: PdfColors.grey),
            top: pdf.BorderSide(color: PdfColors.grey),
            bottom: pdf.BorderSide(color: PdfColors.grey),
          ),
          cellAlignment: pdf.Alignment.centerLeft,
          headerHeight: 25,
          cellHeight: 40,
          headerStyle: pdf.TextStyle(
              color: PdfColors.white, fontWeight: pdf.FontWeight.bold),
          cellAlignments: {
            0: pdf.Alignment.center,
            1: pdf.Alignment.center,
            2: pdf.Alignment.center,
          },
          rowDecoration: pdf.BoxDecoration(
              border: pdf.Border(
            bottom: pdf.BorderSide(
              width: .5,
            ),
          )),
          headerDecoration:
              const pdf.BoxDecoration(color: PdfColors.indigoAccent700),
          headers: List.generate(tableHeaders.length, (index) {
            return tableHeaders[index];
          }),
          data: List<List<dynamic>>.generate(
              invoice.itemList!.length,
              (row) => List<dynamic>.generate(tableHeaders.length,
                  (col) => invoice.itemList![row].getIndex(col)))),
      pdf.SizedBox(height: 20),
      pdf.Row(children: [
        pdf.Expanded(flex: 1, child: pdf.SizedBox()),
        pdf.Expanded(
            flex: 1,
            child: pdf.Row(children: [
              pdf.Text("Grand Total:",
                  style: pdf.TextStyle(
                      fontSize: 20, fontWeight: pdf.FontWeight.bold)),
              pdf.SizedBox(width: 10),
              pdf.Container(
                  padding: pdf.EdgeInsets.all(5.0),
                  color: PdfColors.indigoAccent700,
                  alignment: pdf.Alignment.centerRight,
                  child: pdf.Text(invoice.itemList == null ? "Amount" : "$sum",
                      style: pdf.TextStyle(
                          color: PdfColors.white,
                          fontSize: 18,
                          fontWeight: pdf.FontWeight.bold))),
            ]))
      ])
    ]);
  }

  pdf.Widget buildHeader(pdf.Context context) {
    return pdf.Column(children: [
      pdf.Row(
          mainAxisAlignment: pdf.MainAxisAlignment.spaceBetween,
          children: [
        pdf.Column(
            crossAxisAlignment: pdf.CrossAxisAlignment.start,
            children: [
          pdf.Text(invoice.companyName!),
          pdf.Text(invoice.companyAddress!),
              _UrlText(invoice.companyEmail!,'mailto:${invoice.companyEmail}'),
          pdf.Text(invoice.companyGstin!),
              _UrlText(invoice.companyWebsite!,'www.google.com'),
          //pdf.Text(invoice.companyWebsite!),
        ]),
            pdf.Container(
              width: 140,
              height: 110,
                decoration: pdf.BoxDecoration(
                  shape: pdf.BoxShape.circle,
                  color: PdfColors.white,
                  image: pdf.DecorationImage(
                    fit: pdf.BoxFit.fill,
                    image:
                        pdf.MemoryImage(
                            File(invoice.imagePath!).readAsBytesSync()),
                  ),
                ),

            )

      ]),
      pdf.Divider(color: PdfColors.grey),
    ]);
  }

  pdf.Widget buildTermsAndCon() {
    return pdf.Column(children: [
      pdf.Row(
        crossAxisAlignment: pdf.CrossAxisAlignment.end,
        children: [
          pdf.Expanded(
            child: pdf.Column(
              crossAxisAlignment: pdf.CrossAxisAlignment.start,
              children: [
                pdf.Container(
                  decoration: pdf.BoxDecoration(
                    border: pdf.Border(
                      bottom: pdf.BorderSide(color: PdfColors.indigoAccent700),
                    ),
                  ),
                  padding: const pdf.EdgeInsets.only(top: 10, bottom: 4),
                  child: pdf.Text(
                    'Terms & Conditions',
                    style: pdf.TextStyle(
                      fontSize: 14,
                      color: PdfColors.indigoAccent700,
                      fontWeight: pdf.FontWeight.bold,
                    ),
                  ),
                ),
                pdf.SizedBox(height: 10),
                pdf.Text(invoice.termsAndCon!),
              ],
            ),
          ),
        ],
      ),
    ]);
  }
}

class _UrlText extends pdf.StatelessWidget {
  _UrlText(this.text, this.url);

  final String text;
  final String url;

  @override
  pdf.Widget build(pdf.Context context) {
    return pdf.UrlLink(
      destination: url,
      child: pdf.Text(text,
          style: const pdf.TextStyle(
            decoration: pdf.TextDecoration.underline,
            color: PdfColors.blue,
          )),
    );
  }
}
