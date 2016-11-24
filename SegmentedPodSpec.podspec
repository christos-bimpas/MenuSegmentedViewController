Pod::Spec.new do |s|

  s.name         = 'MenuSegmentedViewController'

  s.version      = '0.1'

  s.summary      = 'MenuSegmentedViewController'

  s.homepage     = 'https://github.com/christos-bimpas/MenuSegmentedViewController'
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { 'Christos Bimpas' => 'christosbimpas@gmail.com' }

  s.platform     = :ios, '9.0'

  s.source       = { :git => 'https://github.com/christos-bimpas/MenuSegmentedViewController', :tag => s.version }

  s.source_files  = 'MenuSegmentedViewController/MenuSegmentedViewController/*.swift'

  s.dependency 'SnapKit', '~> 3.0'

end
