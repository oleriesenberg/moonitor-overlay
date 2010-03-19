# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

#WANT_AUTOMAKE="latest"
inherit autotools eutils python

DESCRIPTION="Persistent distributed key-value data caching system."
HOMEPAGE="http://code.google.com/p/redis/"
SRC_URI="http://redis.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

pkg_setup() {
	enewgroup redis 75
	enewuser redis 75 /bin/bash /var/lib/redis redis
}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}/${PV}-makefile.patch"
}

src_compile() {
	emake CFLAGS="-std=c99 ${CFLAGS}" || die "make failed"
}

src_install() {
	insinto /etc/
	doins "${FILESDIR}/redis.conf"
	chown redis:redis "${D}/etc/redis.conf"

	newconfd "${FILESDIR}/redis.confd" redis
	newinitd "${FILESDIR}/redis.initd" redis

	dodoc 00-RELEASENOTES BETATESTING.txt BUGS COPYING Changelog README \
		TODO
	docinto html ; dodoc doc/*

	dobin redis-benchmark redis-cli redis-server

	einfo "Run emerge --config =${PN}-${PV} to initialize Redis' data"
	einfo "directory and log file, if this is a first-time install."
}

pkg_config() {
	# Set up a location to store data dumps.
	einfo "Installing /var/lib/redis directory..."
	mkdir -p "/var/lib/redis/"
	chown redis:redis "/var/lib/redis/"

	# Set up a logging location.
	einfo "Setting up log file /var/log/redis.log..."
	mkdir -p "/var/log/"
	touch "/var/log/redis.log"
	chown redis:redis "/var/log/redis.log"

	einfo "Done!"
}
