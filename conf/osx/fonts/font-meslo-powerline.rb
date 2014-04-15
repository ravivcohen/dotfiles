class FontMesloPowerline < Cask
  url 'https://github.com/Lokaltog/powerline-fonts/trunk/Meslo',
      :using      => :svn,
      :revision   => '50',
      :trust_cert => true
  homepage 'https://github.com/Lokaltog/powerline-fonts/tree/master/Meslo'
  version '1.020'
  sha256 '8495cbffa20615ce1ccce0e772182a1eaca0239f19f30e342ae390338fb4c207'
  font 'Meslo LG L DZ Regular for Powerline.otf'
  font 'Meslo LG L Regular for Powerline.otf'
  font 'Meslo LG M DZ Regular for Powerline.otf'
  font 'Meslo LG M Regular for Powerline.otf'
  font 'Meslo LG S DZ Regular for Powerline.otf'
  font 'Meslo LG S Regular for Powerline.otf'
end
