import UIKit

class PDFView: UIView {

  var document: CGPDFDocumentRef!
  var numberOfPages: NSInteger = 0
  var scrollView :UIScrollView!


  convenience init (frame: CGRect, pdfUrl: NSURL) {
    self.init(frame: frame)

    scrollView = UIScrollView(frame: self.bounds)
    scrollView.pagingEnabled = true
    scrollView.backgroundColor = UIColor.blackColor()
    self.addSubview(scrollView)

    document = CGPDFDocumentCreateWithURL(pdfUrl as CFURLRef)
    numberOfPages = CGPDFDocumentGetNumberOfPages(document)

    for i in 0...numberOfPages {
      let pageView = PDFPageView(frame: CGRect(x: self.bounds.size.width * CGFloat(i),
                                               y: 0,
                                               width: self.bounds.size.width,
                                               height: self.bounds.size.height),
                                 document: document,
                                 pageNumber: i + 1)
      scrollView.addSubview(pageView)
    }

    scrollView.contentSize = CGSize(width: self.bounds.size.width * CGFloat(numberOfPages),
                                    height: self.bounds.size.height)
  }

  func prev() {
    let prevPage = self.currentPage() - 1
    if 0 <= prevPage {
      scrollView.setContentOffset(CGPoint(x: scrollView.frame.size.width * CGFloat(prevPage), y: 0), animated: true)
    }
  }

  func next() {
    let nextPage = self.currentPage() + 1
    if nextPage < numberOfPages {
      scrollView.setContentOffset(CGPoint(x: scrollView.frame.size.width * CGFloat(nextPage), y: 0), animated: true)
    }
  }

  func reload() {
    scrollView.setContentOffset(CGPointZero,  animated: true)
  }

  func currentPage() -> NSInteger {
    return NSInteger(scrollView.contentOffset.x / scrollView.bounds.size.width);
  }
}
