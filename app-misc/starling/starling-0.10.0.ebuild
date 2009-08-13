# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

inherit gems

DESCRIPTION="Starling is a lightweight, transactional, distributed queue server"
HOMEPAGE="http://github.com/starling/starling/"

SRC_URI="http://gems.github.com/gems/${PN}-${P}.gem"

LICENSE="GPL"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE=""

USE_RUBY="ruby18 ruby19"
DEPEND=""

pkg_setup() {
		enewgroup starling
		enewuser starling -1 -1 /var/spool/starling starling
}

src_install() {
		newconfd "${FILESDIR}/conf" starling
		newinitd "${FILESDIR}/init" starling

		keepdir /var/spool/starling
		fowners starling:starling /var/spool/starling
}

