class FontMesloPowerline < Cask
  url 'https://github.com/Lokaltog/powerline-fonts/trunk/Meslo',
      :using      => :svn,
      :revision   => '50',
      :trust_cert => true
  homepage 'https://github.com/Lokaltog/powerline-fonts/tree/master/Meslo'
  version '1.020'
  sha256 '5ea872b959b05899c7953fb148a14b372a5629eb28359060292763f93cdc0b4a'
  font 'Meslo LG L DZ Regular for Powerline.otf'
  font 'Meslo LG L Regular for Powerline.otf'
  font 'Meslo LG M DZ Regular for Powerline.otf'
  font 'Meslo LG M Regular for Powerline.otf'
  font 'Meslo LG S DZ Regular for Powerline.otf'
  font 'Meslo LG S Regular for Powerline.otf'
end
