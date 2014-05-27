class FontDejavuSansMonoForPowerline < Cask
  url 'https://github.com/Lokaltog/powerline-fonts/trunk/DejaVuSansMono',
      :using => :svn,
      :revision   => '50',
      :trust_cert => true
  homepage 'https://github.com/Lokaltog/powerline-fonts/tree/master/DejaVuSansMono'
  version '1.010'
  sha256 '08de7bf556c3bbdf92cd0758a1d7e87a0b6e9adbddd824dd893c33bcbefcca20'
  font 'DejaVu Sans Mono for Powerline.ttf'
  font 'DejaVu Sans Mono Bold for Powerline.ttf'
  font 'DejaVu Sans Mono Oblique for Powerline.ttf'
  font 'DejaVu Sans Mono Bold Oblique for Powerline.ttf'
end