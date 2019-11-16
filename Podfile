# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

def universal_pods
end

def testing_pods
  pod 'Quick'
  pod 'Nimble'
end

target 'TypeStyle' do
  use_frameworks!

  universal_pods
end

target 'TypeStyleTests' do
  universal_pods
  testing_pods
end
