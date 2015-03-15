#!/usr/bin/env bash
source $DOTFILES/bin/dotfiles "source"

e_header "$(basename "$0" .sh)"

function my_test() {
  setdiff "${desired[*]}" "${installed[*]}"
}

desired=(a b c); installed=(); assert "a b c" my_test
desired=(a b c); installed=(a); assert "b c" my_test
desired=(a b c); installed=(b); assert "a c" my_test
desired=(a b c); installed=(c); assert "a b" my_test
desired=(a b c); installed=(a b); assert "c" my_test
desired=(a b c); installed=(c a); assert "b" my_test
desired=(a a-b); installed=(a); assert "a-b" my_test
desired=(a a-b); installed=(a-b); assert "a" my_test
desired=(a a-b c); installed=(a-b); assert "a c" my_test
desired=(a-b a); installed=(a); assert "a-b" my_test
desired=(a-b a); installed=(a-b); assert "a" my_test
desired=(a a-b); installed=(a-b a); assert "" my_test
desired=(a-b a); installed=(a-b a); assert "" my_test
desired=(a a-b); installed=(a a-b); assert "" my_test
desired=(a-b a); installed=(a a-b); assert "" my_test

unset setdiffA setdiffB setdiffC
setdiff "a b c" "" >/dev/null
assert "0" echo "${#setdiffC[@]}"

unset setdiffA setdiffB setdiffC; setdiffA=(a b c); setdiffB=(); setdiff
assert "3" echo "${#setdiffC[@]}"
assert "a b c" echo "${setdiffC[*]}"

unset setdiffA setdiffB setdiffC; setdiffA=(a b c); setdiffB=(a); setdiff
assert "2" echo "${#setdiffC[@]}"
assert "b c" echo "${setdiffC[*]}"

unset setdiffA setdiffB setdiffC; setdiffA=(a b c); setdiffB=(c a); setdiff
assert "1" echo "${#setdiffC[@]}"
assert "b" echo "${setdiffC[*]}"

unset setdiffA setdiffB setdiffC; setdiffA=("a b" c); setdiffB=(a b c); setdiff
assert "0" echo "${#setdiffC[@]}"
assert "" echo "${setdiffC[*]}"

unset setdiffA setdiffB setdiffC; setdiffA=(a b "a b" c "c d" b "d c"); setdiffB=(a c); setdiff
assert "3" echo "${#setdiffC[@]}"
assert "b b d c" echo "${setdiffC[*]}"

unset setdiffA setdiffB setdiffC;
setdiffA=("apple-gcc42" "readline --universal" "s-lang" "wget --with-iri" "grep" \
"git" "wireshark --with --w-m='3' --x=3"); setdiffB=(apple sauce); setdiff
assert "7" echo "${#setdiffC[@]}"
assert "apple-gcc42 readline --universal s-lang wget --with-iri grep \
git wireshark --with --w-m='3' --x=3" echo "${setdiffC[*]}"

unset setdiffA setdiffB setdiffC;
setdiffA=("apple-gcc42" "readline --universal" "s-lang" "wget --with-iri" "grep" \
"git" "wireshark --with --w-m='3' --x=3"); 
setdiffB=(s-lang apple-gcc42  wget wireshark grep random); 
setdiff
assert "2" echo "${#setdiffC[@]}"
assert "readline --universal git" echo "${setdiffC[*]}"

unset setdiffA setdiffB setdiffC;
setdiffA=("apple-gcc42" "readline --universal" "s-lang" "wget --with-iri" "grep" \
"git" "wireshark --with --w-m='3' --x=3"); 
setdiffB=(readline s-lang apple-gcc42  wget git wireshark grep random); 
setdiff
assert "0" echo "${#setdiffC[@]}"
assert "" echo "${setdiffC[*]}"


# # Test for osx brew
unset setdiffA setdiffB setdiffC;
recipes=("apple-gcc42" "readline --universal" "sqlite --universal" "gdbm --universal" "openssl --universal" "s-lang" "zsh" "wget --with-iri" "grep" "git" "ssh-copy-id" "nmap" "dvtm" "git-extras" "htop-osx" "youtube-dl" "coreutils" "findutils" "ack" "lynx" "rename" "pkg-config" "p7zip" "lesspipe --syntax-highlighting" "python --universal" "brew-cask" "profanity --with-terminal-notifier" "wireshark --with-headers --with-libpcap --with-libsmi --with-lua --with-qt --devel" "vim --with-python --with-ruby --with-perl --enable-cscope 
--enable-pythoninterp --override-system-vi" "core")
setdiffA=("${recipes[@]}")
setdiffB=( $(brew list) )
setdiff 1