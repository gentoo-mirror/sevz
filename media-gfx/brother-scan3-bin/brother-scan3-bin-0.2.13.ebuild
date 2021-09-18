# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm

DESCRIPTION="Brother scanner driver (brscan3)"

HOMEPAGE="http://support.brother.com"

SRC_URI="amd64? ( https://download.brother.com/welcome/dlf006644/brscan3-0.2.13-1.x86_64.rpm )
	x86? ( https://download.brother.com/welcome/dlf006643/brscan3-0.2.13-1.i386.rpm ) "
LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE=""

RESTRICT="mirror strip"

DEPEND="media-gfx/sane-backends[usb]"
RDEPEND="${DEPEND}
	virtual/libusb:0"

S=${WORKDIR}

src_install() {
	cp -r usr "${D}" || die

	unlink "${D}/usr/lib64/libbrscandec3.so.1"
	dosym "libbrscandec3.so.1.0.0" "/usr/lib64/libbrscandec3.so.1"
	unlink "${D}/usr/lib64/libbrscandec3.so"
	dosym "libbrscandec3.so.1" "/usr/lib64/libbrscandec3.so"

	unlink "${D}/usr/lib64/sane/libsane-brother3.so.1"
	dosym "libsane-brother3.so.1.0.7" "/usr/lib64/sane/libsane-brother3.so.1"
	unlink "${D}/usr/lib64/sane/libsane-brother3.so"
	dosym "libsane-brother3.so.1" "/usr/lib64/sane/libsane-brother3.so"

	dodir "/etc/sane.d/dll.d"
	echo "brother3" > "${D}/etc/sane.d/dll.d/brscan3.conf"
}

pkg_postinst() {
	"${ROOT}/usr/local/Brother/sane/setupSaneScan3" -i || die

	einfo "Example with MFC-7440N over network:"
	einfo "	/usr/local/Brother/sane/brsaneconfig3 -a name=MFC-7440N model=MFC-7440N ip=192.168.250.4"
	einfo "	/usr/local/Brother/sane/brsaneconfig3 -a name=MFC-7440N model=MFC-7440N nodename=mfc7440n"
	einfo "	chmod 644 /usr/local/Brother/sane/brsanenetdevice3.cfg"

	#only for usb access
	elog "You may need to be in the scanner or plugdev group in order to use the scanner"
}

pkg_prerm() {
	"${ROOT}/usr/local/Brother/sane/setupSaneScan3" -e || die
}
