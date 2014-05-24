class FontDejavuSansMonoForPowerline < Cask
  url 'https://github.com/Lokaltog/powerline-fonts/trunk/DejaVuSansMono',
      :using => :svn,
      :revision   => '50',
      :trust_cert => true
  homepage 'https://github.com/Lokaltog/powerline-fonts/tree/master/DejaVuSansMono'
  version '1.010'
  sha256 'be11b7ac056ecaac75fd5787d4f173fc9b8c85608adef4146aae388941bed9f5'
  font 'DejaVu Sans Mono for Powerline.ttf'
  font 'DejaVu Sans Mono Bold for Powerline.ttf'
  font 'DejaVu Sans Mono Oblique for Powerline.ttf'
  font 'DejaVu Sans Mono Bold Oblique for Powerline.ttf'
end