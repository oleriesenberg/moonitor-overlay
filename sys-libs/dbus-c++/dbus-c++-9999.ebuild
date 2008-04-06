# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git

EGIT_REPO_URI="git://anongit.freedesktop.org/git/dbus/dbus-c++/"

DESCRIPTION="C++ bindings for dbus"
HOMEPAGE="http://dev.openwengo.com/"
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="sys-apps/dbus"

RDEPEND="${DEPEND}"

src_compile() {
	./autogen.sh || die "foo"
	econf || die "moo"
}

src_install() {
	make install DESTDIR=${D}
}
