# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


inherit eutils

DESCRIPTION="dbus-c++"

HOMEPAGE="http://moonitor.org"

SRC_URI="http://distfiles.moonitor.org/${P}.tar.gz"

LICENSE="GPL"

SLOT="0"

KEYWORDS="~x86 ~amd64"

IUSE=""

DEPEND="sys-apps/dbus"

RDEPEND="${DEPEND}"

src_install() {
	make install DESTDIR=${D}
}
