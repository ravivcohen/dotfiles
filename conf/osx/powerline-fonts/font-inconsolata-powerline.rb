class FontInconsolataPowerline < Cask
  url 'https://github.com/Lokaltog/powerline-fonts/trunk/Inconsolata',
      :using      => :svn,
      :revision   => '50',
      :trust_cert => true
  homepage 'https://github.com/Lokaltog/powerline-fonts/tree/master/Inconsolata'
  version '1.010'
  sha256 'e30fc7651f23318947d00c2e21df5da4773274c78dde9a83fbc1e29905d52f27'
  font 'Inconsolata for Powerline.otf'
end
