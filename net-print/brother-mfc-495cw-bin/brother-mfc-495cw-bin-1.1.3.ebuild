# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm multilib-minimal

DESCRIPTION="Brother printer driver for MFC-495CW"

HOMEPAGE="http://support.brother.com"

SRC_URI="https://download.brother.com/welcome/dlf006143/mfc495cwlpr-1.1.3-1.i386.rpm
	https://download.brother.com/welcome/dlf006145/mfc495cwcupswrapper-1.1.3-1.i386.rpm"

LICENSE="Brother-EULA GPL-2"

SLOT="0"

KEYWORDS="~amd64 ~x86"

RESTRICT="mirror strip"

DEPEND="net-print/cups"
RDEPEND="${DEPEND}"

S=${WORKDIR}

#pkg_setup() {
#	CONFIG_CHECK=""
#	if use amd64; then
#		CONFIG_CHECK="${CONFIG_CHECK} ~IA32_EMULATION"
#	fi

#	linux-info_pkg_setup
#}

src_prepare() {
	eapply_user

	perl -i -pe 'BEGIN{$stop=0} $stop = !$stop if /ENDOFWFILTER/; if(!$stop) {s/\$1/\$2/g;s!/usr!\$1/usr!;s!/etc!\$1/etc!;s!/opt!\$1/opt!}' \
	"opt/brother/Printers/mfc495cw/cupswrapper/cupswrappermfc495cw"
}

src_install() {
	cp -r usr "${D}"
	cp -r opt "${D}"

	fperms 755 "/opt/brother/Printers/mfc495cw/lpd"
	fperms 755 "/opt/brother/Printers/mfc495cw/inf"
	fperms 755 "/opt/brother/Printers/mfc495cw"

	# needed for the follow script
	local lib="lib"

	if use amd64; then
		lib="lib64"
	fi

	dodir "/usr/${lib}/cups/filter"

	"${D}/opt/brother/Printers/mfc495cw/cupswrapper/cupswrappermfc495cw" "${D}"
	fperms 755 "/opt/brother/Printers/mfc495cw/cupswrapper"

	keepdir "/var/spool/lpd/mfc495cw"
	dodir "/usr/libexec/cups/filter"
	dosym "../../../usr/${lib}/cups/filter/brlpdwrappermfc495cw" "/usr/libexec/cups/filter/brlpdwrappermfc495cw"
}
