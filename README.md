# MenuSegmentedViewController

#Example

      import MenuSegmentedViewController

      class ViewController: MenuSegmentedViewController {
    
            override init() {
            super.init()
            super.viewDidLoad()
            let firstViewController = FirstViewController()
            firstViewController.title = "FIRST"

            let secondViewController = SecondViewController()
            secondViewController.title = "SECOND"

            let thirdViewController = ThirdViewController()
            thirdViewController.title = "THIRD"

            //self.titleFont = ...
            self.titleColor = UIColor.init(red: 155.0/255.0, green: 155.0/255.0, blue: 155.0/255.0, alpha: 1.0)
            self.underlineColor = UIColor.init(red: 69.0/255.0, green: 69.0/255.0, blue: 69.0/255.0, alpha: 1.0)

            self.set(viewControllers: [firstViewController, secondViewController, thirdViewController])
            }

            required init?(coder aDecoder: NSCoder) {
              fatalError("init(coder:) has not been implemented")
            }

            override func contentDidScroll(withOffset offset: CGFloat) {
                  
            }

      }
      
#Install
Podfile

      use_frameworks!
      target 'SegmentedExample' do
           pod 'MenuSegmentedViewController', :git => ‘https://github.com/christos-bimpas/MenuSegmentedViewController.git'
      end
