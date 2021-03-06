# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

WANT_AUTOCONF=latest
WANT_AUTOMAKE=latest
inherit eutils autotools depend.php

DESCRIPTION="Lightweight high-performance web server"
HOMEPAGE="http://www.lighttpd.net/"
SRC_URI="http://www.lighttpd.net/download/lighttpd-1.5.0-r1992.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test fam php minimal maintainer-mode ipv6 mysql postgresql ldap xattr valgrind ssl kerberos pcre bzip2 webdav gdbm memcache lua linux-aio"

RDEPEND=">=sys-libs/zlib-1.1
	bzip2?    ( app-arch/bzip2 )
	fam?      ( virtual/fam )
	gdbm?     ( sys-libs/gdbm )
	ldap?     ( >=net-nds/openldap-2.1.26 )
	linux-aio?	( dev-libs/libaio )
	lua?      ( >=dev-lang/lua-5.1 )
	memcache? ( dev-libs/libmemcache )
	mysql?    ( >=virtual/mysql-4.0 )
	pcre?     ( >=dev-libs/libpcre-3.1 )
	php?      ( virtual/httpd-php )
	rrdtool? ( net-analyzer/rrdtool )
	ssl?    ( >=dev-libs/openssl-0.9.7 )
	webdav? (
		dev-libs/libxml2
		>=dev-db/sqlite-3
		sys-fs/e2fsprogs
	)
	xattr? ( kernel_linux? ( sys-apps/attr ) )"

DEPEND="${RDEPEND}
	doc?  ( dev-python/docutils )
	test? (
		virtual/perl-Test-Harness
		dev-libs/fcgi
	)"

# update certain parts of lighttpd.conf based on conditionals
update_config() {
	local config="/etc/lighttpd/lighttpd.conf"

	# enable stat() caching
	use fam && \
		dosed 's|#\(.*stat-cache.*$\)|\1|' ${config}
}

# remove non-essential stuff (for USE=minimal)
remove_non_essential() {
	local libdir="${D}/usr/$(get_libdir)/${PN}"

	# text docs
	use doc || rm -fr ${D}/usr/share/doc/${PF}/txt

	# non-essential modules
	rm -f \
		${libdir}/mod_{compress,evhost,expire,proxy,scgi,secdownload,simple_vhost,status,setenv,trigger*,usertrack}.*

	# allow users to keep some based on USE flags
	use pcre    || rm -f ${libdir}/mod_{ssi,re{direct,write}}.*
	use webdav  || rm -f ${libdir}/mod_webdav.*
	use mysql   || rm -f ${libdir}/mod_mysql_vhost.*
	use lua     || rm -f ${libdir}/mod_{cml,magnet}.*
	use rrdtool || rm -f ${libdir}/mod_rrdtool.*
}

pkg_setup() {
	if ! use pcre ; then
		ewarn "It is highly recommended that you build ${PN}"
		ewarn "with perl regular expressions support via USE=pcre."
		ewarn "Otherwise you lose support for some core options such"
		ewarn "as conditionals and modules such as mod_re{write,direct}"
		ewarn "and mod_ssi."
		ebeep 5
	fi

	enewgroup lighttpd
	enewuser lighttpd -1 -1 /var/www/localhost/htdocs lighttpd
}

src_unpack() {
	unpack ${A}
	cd ${S}

	eautoreconf || die

	# dev-python/docutils installs rst2html.py not rst2html
	sed -i -e 's|\(rst2html\)|\1.py|g' doc/Makefile.in || \
		die "sed doc/Makefile.in failed"

	# fix typo
	sed -i -e 's|\(output_content\)_\(type\)|\1\2|' doc/cml.txt || \
		die "sed doc/cml.txt failed"
}

src_compile() {
	econf --libdir=/usr/$(get_libdir)/${PN} \
		--enable-lfs \
		$(use_enable maintainer-mode) \
		$(use_enable ipv6) \
		$(use_with bzip2) \
		$(use_with fam) \
		$(use_with gdbm) \
		$(use_with kerberos) \
		$(use_with lua) \
		$(use_with ldap) \
		$(use_with linux-aio) \
		$(use_with memcache) \
		$(use_with mysql) \
		$(use_with pcre) \
		$(use_with postgresql) \
		$(use_with ssl openssl) \
		$(use_with valgrind) \
		$(use_with webdav webdav-props) \
		$(use_with webdav webdav-locks) \
		$(use_with xattr attr) \
		|| die "econf failed"

	emake || die "emake failed"

	if use doc ; then
		einfo "Building HTML documentation"
		cd doc
		emake html || die "failed to build HTML documentation"
	fi
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"

	# init script stuff
	newinitd ${FILESDIR}/lighttpd.initd-1.5 lighttpd || die
	newconfd ${FILESDIR}/lighttpd.confd lighttpd || die
	use fam && has_version app-admin/fam && \
		sed -i 's/after famd/need famd/g' "${D}"/etc/init.d/lighttpd

	# configs
	insinto /etc/lighttpd
	doins ${FILESDIR}/conf/lighttpd.conf
	doins ${FILESDIR}/conf/mime-types.conf
	# Secure directory for fastcgi sockets
	keepdir /var/run/lighttpd/
	fperms 0750 /var/run/lighttpd/
	fowners lighttpd:lighttpd /var/run/lighttpd/

	# update lighttpd.conf directives based on conditionals
	update_config

	# docs
	dodoc AUTHORS README NEWS ChangeLog doc/*.sh
	newdoc doc/lighttpd.conf lighttpd.conf.distrib

	use doc && dohtml -r doc/*

	docinto txt
	dodoc doc/*.txt

	# logrotate
	insinto /etc/logrotate.d
	newins ${FILESDIR}/lighttpd.logrotate lighttpd || die

	keepdir /var/l{ib,og}/lighttpd /var/www/localhost/htdocs
	fowners lighttpd:lighttpd /var/l{ib,og}/lighttpd
	fperms 0750 /var/l{ib,og}/lighttpd

	use minimal && remove_non_essential
}

pkg_postinst () {
	echo
	if [[ -f ${ROOT}etc/conf.d/spawn-fcgi.conf ]] ; then
		einfo "spawn-fcgi is now included with lighttpd"
		einfo "spawn-fcgi's init script configuration is now located"
		einfo "at /etc/conf.d/spawn-fcgi."
		echo
	fi

	if use fam ; then
		einfo "Remember to re-emerge lighttpd should you switch from"
		einfo "app-admin/famd to app-admin/gamin or vice versa."
	fi
	echo
}
