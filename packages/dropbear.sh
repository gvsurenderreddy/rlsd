PACKAGE_VERSION="2013.62"
PACKAGE_SOURCES="https://matt.ucc.asn.au/dropbear/releases/dropbear-$PACKAGE_VERSION.tar.bz2"

PROGRAMS="dropbear dbclient dropbearkey scp"

dropbear_build() {
	[ -d dropbear-$PACKAGE_VERSION ] && rm -rf dropbear-$PACKAGE_VERSION
	tar -xjvf dropbear-$PACKAGE_VERSION.tar.bz2
	cd dropbear-$PACKAGE_VERSION

	sed s~'^#define LOCAL_IDENT .*'~'#define LOCAL_IDENT "SSH-2.0-None"'~ \
	    -i sysoptions.h

	touch scp.1
	./configure --host=$HOST \
	            --prefix= \
	            --sbindir=/bin \
	            --datarootdir=/usr/share \
	            --enable-zlib \
	            --disable-pam
	make PROGRAMS="$PROGRAMS" MULTI=1
}

dropbear_package() {
	make DESTDIR="$1" PROGRAMS="$PROGRAMS" MULTI=1 install
	ln -s dropbearmulti "$1/bin/ssh"
	install -D -m 644 README "$1/usr/share/doc/dropbear/README"
	install -m 644 LICENSE "$1/usr/share/doc/dropbear/LICENSE"
}
