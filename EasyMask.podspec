#
# Be sure to run `pod lib lint EasyMask.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.summary          = 'An Swift mask of easy use.'
  s.name             = 'EasyMask'
  s.version          = '1.2.2'
  s.swift_version    = '5.0'

  s.description      = <<-DESC
    EasyMask is an easy and quick way to put a mask on a TextField without having to do complex treatments.
                       DESC

  s.authors          = { 'Marcio F. Paludo' => 'marciof.paludo@gmail.com', 'Vinícius D. Brandão' => "viniciusbrando059@gmail.com" }
  s.source           = { :git => 'https://github.com/MarcioFPaludo/EasyMask.git', :tag => s.version.to_s }
  s.homepage         = 'https://github.com/MarcioFPaludo/EasyMask'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  
  
  s.ios.deployment_target = '9.0'
  s.source_files = 'EasyMask/Classes/**/*'
end
