class FontInconsolataPowerline < Cask
  url 'https://github.com/Lokaltog/powerline-fonts/trunk/Inconsolata',
      :using      => :svn,
      :revision   => '50',
      :trust_cert => true
  homepage 'https://github.com/Lokaltog/powerline-fonts/tree/master/Inconsolata'
  version '1.010'
  sha256 'e09141545654a2f3086a845b237a4880b28a5a8190ef2750ff0bfaa2ec740df3'
  font 'Inconsolata for Powerline.otf'
end
