# MenuSegmentedViewController

#Example

      import SegmentedViewController

      class ViewController: MenuSegmentedViewController {

      override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
      let firstViewController = FirstViewController()
      firstViewController.title = "FIRST"

      let secondViewController = SecondViewController()
      secondViewController.title = "SECOND"

      let thirdViewController = ThirdViewController()
      thirdViewController.title = "THIRD"

      self.titleFont = NDFontHelper.fontLight(withSize: 14)
      self.titleColor = UIColor.init(red: 155.0/255.0, green: 155.0/255.0, blue: 155.0/255.0, alpha: 1.0)
      self.underlineColor = UIColor.init(red: 69.0/255.0, green: 69.0/255.0, blue: 69.0/255.0, alpha: 1.0)

      self.set(viewControllers: [firstViewController, secondViewController, thirdViewController])
      }

      override func contentDidScroll(withOffset offset: CGFloat) {

      }

      }
