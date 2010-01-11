# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Yaws is a HTTP high perfomance 1.1 webserver particularly well suited for dynamic-content webapplications"
HOMEPAGE="http://yaws.hyber.org/"
SRC_URI="http://yaws.hyber.org/download/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ssl"

DEPEND="dev-lang/erlang
		ssl?	( >=dev-libs/openssl-0.9.6d )"

src_compile() {
	./configure --prefix=/usr || die
	make || die
}

src_install() {
	make DESTDIR=${D} install || die
}
