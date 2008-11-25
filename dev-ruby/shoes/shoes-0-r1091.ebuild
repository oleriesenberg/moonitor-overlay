# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

MY_PV="0.r1091"
MY_S=${PN}-${MY_PV}
MY_P=$PN-${MY_PV}
DESCRIPTION="Shoes is a very informal graphics and windowing toolkit for Ruby."
HOMEPAGE="http://shoooes.net/"
SRC_URI="http://shoooes.net/dist/${MY_P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="vlc curl sqlite3 examples"

DEPEND="
	x11-libs/cairo
	media-libs/libpixman
	x11-libs/pango
	dev-lang/ruby
	x11-libs/gtk+
	media-libs/jpeg
	vlc? ( media-video/vlc )
	curl? ( net-misc/curl )
	sqlite3? ( >=dev-db/sqlite-3 )
	"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${MY_S}"
	epatch "${FILESDIR}/${MY_P}-makefile.patch"
}

src_compile() {
	cd "${MY_S}"

	if use vlc; then
		emake VIDEO=1 || die "Make VIDEO=1 failed"
	fi

}

src_install() {
	cd "${MY_S}"

	emake DESTDIR="${D}" install || die "make install failed"
	dodoc CHANGELOG COPYING README static/manual.txt || die

	if use examples; then
		docinto /usr/share/shoes/samples/
		dodoc "${MY_S}"/samples/* || die
	fi
}
