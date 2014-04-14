class FontInconsolataDzPowerline < Cask
  url 'https://github.com/Lokaltog/powerline-fonts/trunk/InconsolataDz',
      :using      => :svn,
      :revision   => '50',
      :trust_cert => true
  homepage 'https://github.com/Lokaltog/powerline-fonts/tree/master/InconsolataDz'
  version '1.010'
  sha256 'faf945e8131d92b16bfdd9227b908e4f818d4d77549740a0f2a98067f12548af'
  font 'Inconsolata-dz for Powerline.otf'
end
