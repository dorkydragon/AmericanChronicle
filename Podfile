# Uncomment this line to define a global platform for your project
# platform :ios, '8.0'
# Uncomment this line if you're using Swift


target 'AmericanChronicle' do
	use_frameworks!

	# Pods for 'AmericanChronicle'
	pod 'SnapKit'
	pod 'AlamofireObjectMapper'
	pod 'SDWebImage'
	pod 'DynamicColor'
	pod 'SwiftyBeaver'

	target 'AmericanChronicleTests' do
		inherit! :search_paths
	end

	target 'AmericanChronicleUITests' do
		inherit! :search_paths
	end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
      config.build_settings['CODE_SIGN_IDENTITY'] = "Don't Code Sign"
      config.build_settings['CODE_SIGN_IDENTITY[sdk=iphoneos*]'] = "Don't Code Sign"
    end
  end
end
