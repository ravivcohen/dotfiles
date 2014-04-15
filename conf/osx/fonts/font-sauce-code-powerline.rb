class FontSauceCodePowerline < Cask
  url 'https://github.com/Lokaltog/powerline-fonts/trunk/SourceCodePro',
      :using      => :svn,
      :revision   => '50',
      :trust_cert => true
  homepage 'https://github.com/Lokaltog/powerline-fonts/tree/master/SourceCodePro'
  version '1.020'
  sha256 '084a40279c77d73d4c5a71791c7743d0e310e51821def95e0439ace7419c9e91'
  font 'Sauce Code Powerline Black.otf'
  font 'Sauce Code Powerline Bold.otf'
  font 'Sauce Code Powerline ExtraLight.otf'
  font 'Sauce Code Powerline Light.otf'
  font 'Sauce Code Powerline Medium.otf'
  font 'Sauce Code Powerline Regular.otf'
  font 'Sauce Code Powerline Semibold.otf'
end
