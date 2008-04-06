# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $


inherit eutils

DESCRIPTION="automated screenshot-taking with webserver support"

HOMEPAGE="http://patrick-nagel.net"

SRC_URI="http://distfiles.moonitor.org/${P}.tar.gz"

LICENSE="GPL"

SLOT="0"

KEYWORDS="~x86 ~amd64"

IUSE="kde"

DEPEND=""
RDEPEND="${DEPEND}
		|| ( net-misc/openssh net-misc/ssh )
		media-gfx/scrot
		net-misc/curl
		kde? ( kde-base/klipper )
		kde? ( kde-base/kdialog )"

src_compile() {
		econf --prefix=/usr $(use_enable kde) || die "configure failed"
}

src_install() {
		make DESTDIR=${D} install || die "make failed"
}

pkg_postinst() {
		ewarn
		ewarn "You need a running sshd, a httpd and ImageMagick on your server."
		ewarn "If you're using the script from a non-interactive environment,"
		ewarn "you also have to setup pubkey authorization on your server."
		ewarn "(see http://sial.org/howto/openssh/publickey-auth/)"
		ewarn
}

