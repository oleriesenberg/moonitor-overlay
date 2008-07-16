# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion

EGIT_REPO_URI="git://moonitor.org/ndkpp.git"

DESCRIPTION="A C++ ncurses toolkit"

RESTRICT="mirror"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~x86 ~amd64"


IUSE=""

DEPEND=">=sys-libs/ncursesxx-0.0.1_beta5"

RDEPEND="${DEPEND}"

src_compile() {
	emake
}

src_install() {
	make install DESTDIR=${D}
}
