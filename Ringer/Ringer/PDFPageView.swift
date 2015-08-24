import UIKit

class PDFPageView: UIView {

  var page: CGPDFPageRef!

  convenience init(frame: CGRect, document: CGPDFDocumentRef, pageNumber: NSInteger) {
    self.init(frame: frame)
    page = CGPDFDocumentGetPage(document, pageNumber)
  }

  override func drawRect(rect: CGRect) {
    let context: CGContextRef  = UIGraphicsGetCurrentContext()
    let pdfRect: CGRect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox)
    let scale: CGFloat = self.frame.size.width / pdfRect.size.width;
    CGContextScaleCTM(context, scale, -1.0 * scale);
    CGContextTranslateCTM(context, 0.0, -1.5 * pdfRect.size.height);
    CGContextDrawPDFPage(context, page);
  }
}
