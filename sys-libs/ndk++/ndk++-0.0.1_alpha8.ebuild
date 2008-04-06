# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


inherit eutils

DESCRIPTION="ndk++"

HOMEPAGE="http://ndk-xx.sourceforge.net/"

SRC_URI="http://distfiles.moonitor.org/${P}.tar.bz2"

RESTRICT="mirror"

LICENSE="GPL"

SLOT="0"

KEYWORDS="~x86 ~amd64"

IUSE=""

DEPEND="sys-libs/ncursesxx"

RDEPEND="${DEPEND}"

src_compile() {
	emake
}

src_install() {
	make install DESTDIR=${D}
}
