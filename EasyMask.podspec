#
# Be sure to run `pod lib lint EasyMask.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EasyMask'
  s.version          = '0.1.0'
  s.summary          = 'An Swift mask of easy use.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
#
  s.description      = <<-DESC
  TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/MarcioFPaludo/EasyMask'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Marcio F. Paludo' => 'marciof.paludo@gmail.com' }
  s.source           = { :git => 'https://github.com/MarcioFPaludo/EasyMask.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '9.0'
  s.source_files = 'EasyMask/Classes/**/*'
end
