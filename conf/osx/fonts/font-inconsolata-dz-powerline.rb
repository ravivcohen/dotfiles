class FontInconsolataDzPowerline < Cask
  url 'https://github.com/Lokaltog/powerline-fonts/trunk/InconsolataDz',
      :using      => :svn,
      :revision   => '50',
      :trust_cert => true
  homepage 'https://github.com/Lokaltog/powerline-fonts/tree/master/InconsolataDz'
  version '1.010'
  sha256 '78f8cf4f8a7da763d7b8734dfd6c6bab713be8a24d3a9c2c04f95737ac230b90'
  font 'Inconsolata-dz for Powerline.otf'
end
