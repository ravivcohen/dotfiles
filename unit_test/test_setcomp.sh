#!/usr/bin/env bash
source $DOTFILES/bin/dotfiles "source"

e_header "$(basename "$0" .sh)"

function my_test() {
  setcomp "${undesired[*]}" "${installed[*]}"
}

undesired=(a b c); installed=(); assert "" my_test
undesired=(a b c); installed=(a); assert "a" my_test
undesired=(a b c); installed=(a b); assert "a b" my_test
undesired=(b c); installed=(a b c); assert "b c" my_test
undesired=(a b c); installed=(a b); assert "a b" my_test
undesired=(a b c); installed=(c a); assert "a c" my_test
undesired=(a a-b); installed=(a-b); assert "a-b" my_test
undesired=(a a-b); installed=(a); assert "a" my_test
undesired=(a a-b c); installed=(a c); assert "a c" my_test
undesired=(a-b a); installed=(a-b); assert "a-b" my_test
undesired=(a-b a); installed=(a); assert "a" my_test
undesired=(a a-b); installed=(a-b a); assert "a a-b" my_test
undesired=(a-b a); installed=(a-b a); assert "a-b a" my_test
undesired=(a a-b); installed=(a a-b); assert "a a-b" my_test
undesired=(a-b a); installed=(a a-b); assert "a-b a" my_test
undesired=(); installed=(a a-b); assert "" my_test

unset setdiffA setdiffB setdiffC
setcomp "a b c" "" >/dev/null
assert "0" echo "${#setdiffC[@]}"

unset setdiffA setdiffB setdiffC; setdiffA=(a b c); setdiffB=(a b c); setcomp
assert "3" echo "${#setdiffC[@]}"
assert "a b c" echo "${setdiffC[*]}"

unset setdiffA setdiffB setdiffC; setdiffA=(a b c); setdiffB=(b c); setcomp
assert "2" echo "${#setdiffC[@]}"
assert "b c" echo "${setdiffC[*]}"

unset setdiffA setdiffB setdiffC; setdiffA=(a b c); setdiffB=(c a); setcomp
assert "2" echo "${#setdiffC[@]}"
assert "a c" echo "${setdiffC[*]}"

unset setdiffA setdiffB setdiffC; setdiffA=("a b" c); setdiffB=(a b c); setcomp
assert "2" echo "${#setdiffC[@]}"
assert "a b c" echo "${setdiffC[*]}"

unset setdiffA setdiffB setdiffC; setdiffA=(b "a b" "c d" b "d c"); setdiffB=(a c); setcomp
assert "2" echo "${#setdiffC[@]}"
assert "a b c d" echo "${setdiffC[*]}"

unset setdiffA setdiffB setdiffC;
setdiffA=("apple-gcc42" "readline --universal" "s-lang" "wget --with-iri" "grep" \
"git" "wireshark --with --w-m='3' --x=3"); setdiffB=(apple sauce); setcomp
assert "0" echo "${#setdiffC[@]}"
assert "" echo "${setdiffC[*]}"

unset setdiffA setdiffB setdiffC;
setdiffA=("apple-gcc42" "readline --universal" "s-lang" "wget --with-iri" "grep" \
"git" "wireshark --with --w-m='3' --x=3"); 
setdiffB=(s-lang apple-gcc42  wget wireshark grep random); 
setcomp
assert "5" echo "${#setdiffC[@]}"
assert "apple-gcc42 s-lang wget --with-iri grep wireshark --with --w-m='3' --x=3" echo "${setdiffC[*]}"

unset setdiffA setdiffB setdiffC;
setdiffA=("apple-gcc42" "readline --universal" "s-lang" "wget --with-iri" "grep" \
"git" "wireshark --with --w-m='3' --x=3"); 
setdiffB=(readline s-lang apple-gcc42  wget git wireshark grep random); 
setcomp
assert "7" echo "${#setdiffC[@]}"
assert "apple-gcc42 readline --universal s-lang wget --with-iri grep \
git wireshark --with --w-m='3' --x=3" echo "${setdiffC[*]}"

# loaded="$(launchctl list | awk 'NR>1 && $3 !~ /0x[0-9a-fA-F]+\.(anonymous|mach_init)/ {print $3}')"
# is_loaded=($(setdiff 1 "homebrew.mxcl.offline-imap" "$loaded"))
# is_installed=($(setcomp 1 "offline-imap" "$(brew list)"))
# echo "${#is_loaded[@]}"
# echo "${#is_installed[@]}"
# if [[  "$is_loaded" -eq 0 ]] && [[ "$is_installed" --eq 1 ]]; then
#     e_header "Loading offline-imap launchctl"
# fi