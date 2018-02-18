export PREFIX=/usr/local
export SRC_PREFIX=/src
export sudo='sudo '
#export CWEB_VERSION=cweb-3.64c
export CWEB_VERSION=cweb-3.43

for bin in cweave ctangle
do
  rm $PREFIX/bin/$bin || true
  ln -s $PREFIX/bin/$bin-$CWEB_VERSION $PREFIX/bin/$bin
done
