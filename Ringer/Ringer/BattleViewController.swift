import UIKit

class BattleViewController: UIViewController, CRApplicationDelegate {

  var ringApp: CRApplication?

  let gestures = [ "circle" : CR_POINTS_CIRCLE,
                   "left" : CR_POINTS_LEFT,
                   "right" : CR_POINTS_RIGHT ]

  var pdfView: PDFView!


  override func viewDidLoad() {
    super.viewDidLoad()

    if let pdfUrl = NSBundle.mainBundle().URLForResource("ring", withExtension: "pdf") {
      pdfView = PDFView(frame: self.view.bounds, pdfUrl: pdfUrl)
      self.view.addSubview(pdfView)
    }

    //
    // Draw Gesture Image
    //

    let buttonWidth  = self.view.bounds.size.width / CGFloat(count(gestures.keys))

    for (index, key) in enumerate(["left", "circle", "right"]) {

      //
      // Create Image
      //

      let points = self.gestures[key];

      let image = CRCommon.imageWithPoints(points,
                                       width: buttonWidth * 0.5,
                                       lineColor: UIColor.lightGrayColor(),
                                       pointColor: UIColor.whiteColor())

      let button = UIButton.buttonWithType(.Custom) as! UIButton
      button.tag = index
      button.frame = CGRect(x: buttonWidth * CGFloat(index),
                            y: self.view.bounds.size.height - buttonWidth,
                            width: buttonWidth,
                            height: buttonWidth)
      button.setImage(image, forState: .Normal)
      button.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
      self.view.addSubview(button)
    }
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    if let r = ringApp {
      return
    }
    self.startRing()
  }

  func startRing() {

    //
    // Create an instance
    //

    ringApp = CRApplication(delegate:self, background: false)

    //
    // Install gestures if not installed.
    //

    if ringApp!.installedGestureIdentifiers().count == 0 {

      let g = gestures as [NSObject : AnyObject]

      var error: NSError?
      if !ringApp!.installGestures(g, error: &error) {
        println(error!.localizedDescription)
        return
      }
    }

    //
    // Set active gestures.
    //

    ringApp!.setActiveGestureIdentifiers(gestures.keys.array)

    //
    // Start a ring session.
    //

    ringApp!.start()
  }

  func endRing() {
    ringApp = nil
  }

  // MARK: CRApplicationDelegate

  func deviceDidDisconnect() {
    println(__FUNCTION__)
  }

  func deviceDidInitialize() {
    println(__FUNCTION__)
  }

  func didReceiveEvent(event: CRRingEvent) {
    println(__FUNCTION__)
  }

  func didReceiveGesture(identifier: String!) {

    if let g = identifier {
      println(__FUNCTION__ + " " + identifier)
    } else {
      println(__FUNCTION__ + " " + "not match")
      return
    }

    dispatch_async(dispatch_get_main_queue(), {
        if "left" == identifier {
          self.pdfView.prev()
          return
        }
        if "circle" == identifier {
          self.pdfView.reload()
          return
        }
        if "right" == identifier {
          self.pdfView.next()
          return
        }
      });
  }

  func didReceiveQuaternion(quaternion: CRQuaternion) {
    println(__FUNCTION__)
  }

  func didReceivePoint(point: CGPoint) {
    println(__FUNCTION__)
  }

  // MARK: UI events

  func buttonPressed(button: UIButton) {
    if 0 == button.tag {
      self.pdfView.prev()
      return
    }
    if 1 == button.tag {
      self.pdfView.reload()
      return
    }
    if 2 == button.tag {
      self.pdfView.next()
      return
    }
  }
}
