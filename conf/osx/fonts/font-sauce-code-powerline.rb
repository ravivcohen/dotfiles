class FontSauceCodePowerline < Cask
  url 'https://github.com/Lokaltog/powerline-fonts/trunk/SourceCodePro',
      :using      => :svn,
      :revision   => '50',
      :trust_cert => true
  homepage 'https://github.com/Lokaltog/powerline-fonts/tree/master/SourceCodePro'
  version '1.020'
  sha256 '72fac1ab274067d5fa98ce0b7f5c78e33c5a685c003ab5d555ec8143cdf850e5'
  font 'Sauce Code Powerline Black.otf'
  font 'Sauce Code Powerline Bold.otf'
  font 'Sauce Code Powerline ExtraLight.otf'
  font 'Sauce Code Powerline Light.otf'
  font 'Sauce Code Powerline Medium.otf'
  font 'Sauce Code Powerline Regular.otf'
  font 'Sauce Code Powerline Semibold.otf'
end
