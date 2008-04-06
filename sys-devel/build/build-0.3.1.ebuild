# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Build is a massively-parallel software build system implemented on top of GNU make."
HOMEPAGE="http://kolpackov.net/projects/build/"
SRC_URI="ftp://kolpackov.net/pub/projects/build/0.3/${P}.tar.bz2"

RESTRICT="mirror"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=sys-devel/make-3.81
		>=app-shells/bash-2.05a"
RDEPEND="${DEPEND}"


src_install() {
	einfo "Installing Build..."
	make install_prefix=${D}/usr install || die "Error: make install failed!"
}

pkg_postinst() {
	ewarn
	ewarn "DO NOT report bugs to Gentoo's bugzilla"
	ewarn "Please report all bugs to http://trac.moonitor.org"
	ewarn
}
