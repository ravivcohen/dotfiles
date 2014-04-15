class FontMesloPowerline < Cask
  url 'https://github.com/Lokaltog/powerline-fonts/trunk/Meslo',
      :using      => :svn,
      :revision   => '50',
      :trust_cert => true
  homepage 'https://github.com/Lokaltog/powerline-fonts/tree/master/Meslo'
  version '1.020'
  sha256 '968fce517ee235c582927bb009eedadadcd9817a45591a194e59c997a37453ff'
  font 'Meslo LG L DZ Regular for Powerline.otf'
  font 'Meslo LG L Regular for Powerline.otf'
  font 'Meslo LG M DZ Regular for Powerline.otf'
  font 'Meslo LG M Regular for Powerline.otf'
  font 'Meslo LG S DZ Regular for Powerline.otf'
  font 'Meslo LG S Regular for Powerline.otf'
end
