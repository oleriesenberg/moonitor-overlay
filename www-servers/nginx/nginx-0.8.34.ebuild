# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils ssl-cert toolchain-funcs

DESCRIPTION="Robust, small and high performance http and reverse proxy server"

UPLOADPROGRESS="nginx_uploadprogress_module"
FAIR="nginx-upstream-fair"
REDIS="ngx_http_redis"

HOMEPAGE="http://nginx.net/"
SRC_URI="http://sysoev.ru/nginx/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="addition debug fair fastcgi flv imap ipv6 passenger pcre perl random-index redis securelink ssl status sub uploadprogress webdav zlib"

DEPEND="dev-lang/perl
	pcre? ( >=dev-libs/libpcre-4.2 )
	ssl? ( dev-libs/openssl )
	zlib? ( sys-libs/zlib )
	perl? ( >=dev-lang/perl-5.8 )"

pkg_setup() {
	if use passenger ; then
		PASSENGER_ROOT=`passenger-config --root` ||	die "Please install passenger via rubygems and remerge nginx"
		PASSENGER_VERSION=`passenger-config --version`
	fi

	ebegin "Creating nginx user and group"
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
	eend ${?}

	if use ipv6; then
		ewarn "Note that ipv6 support in nginx is still experimental."
		ewarn "Be sure to read comments on gentoo bug #274614"
		ewarn "http://bugs.gentoo.org/show_bug.cgi?id=274614"
	fi
}

src_unpack() {
	unpack ${A}
	sed -i 's/ make/ \\$(MAKE)/' "${S}"/auto/lib/perl/make || die

	if use uploadprogress ; then
		# I'd put this in SRC_URI, but curl has to be run specifically like this
		cd ${DISTDIR}
		curl -A "Mozilla/4.0" \
						"http://wiki.nginx.org/images/8/83/Nginx_uploadprogress_module-0.5.tar.gz" \
						-o ${UPLOADPROGRESS}-0.5.tar.gz || die "Could not download the upload progress module"

		unpack ${UPLOADPROGRESS}-0.5.tar.gz
		mv ${UPLOADPROGRESS} ${WORKDIR}
	fi

	if use fair ; then
		# dirty
		cd ${DISTDIR}
		git clone git://github.com/gnosek/nginx-upstream-fair.git ${FAIR} || die "Could not \`git clone\' the upstream-fair module"
		mv ${FAIR} ${WORKDIR}
	fi

	if use redis ; then
		cd ${DISTDIR}
		curl -A "Mozilla/4.0" \
						"http://people.freebsd.org/~osa/ngx_http_redis-0.3.1.tar.gz" \
						-o ngx_http_redis-0.3.1.tar.gz || die "Could not download the redis module"

		unpack ${REDIS}-0.3.1.tar.gz
		mv ${REDIS}-0.3.1 ${WORKDIR}/${REDIS}
	fi

	if use passenger ; then
		cp -R ${PASSENGER_ROOT} ${WORKDIR}
	fi
}

src_compile() {
	local myconf

	# threads support is broken atm.
	#
	# if use threads; then
	# 	einfo
	# 	ewarn "threads support is experimental at the moment"
	# 	ewarn "do not use it on production systems - you've been warned"
	# 	einfo
	# 	myconf="${myconf} --with-threads"
	# fi

	use addition && myconf="${myconf} --with-http_addition_module"
	use ipv6	&& myconf="${myconf} --with-ipv6"
	use fastcgi	|| myconf="${myconf} --without-http_fastcgi_module"
	use fastcgi	&& myconf="${myconf} --with-http_realip_module"
	use flv		&& myconf="${myconf} --with-http_flv_module"
	use zlib	|| myconf="${myconf} --without-http_gzip_module"
	use pcre	|| {
		myconf="${myconf} --without-pcre --without-http_rewrite_module"
	}
	use debug	&& myconf="${myconf} --with-debug"
	use ssl		&& myconf="${myconf} --with-http_ssl_module"
	use imap	&& myconf="${myconf} --with-imap" # pop3/imap4 proxy support
	use perl	&& myconf="${myconf} --with-http_perl_module"
	use status	&& myconf="${myconf} --with-http_stub_status_module"
	use webdav	&& myconf="${myconf} --with-http_dav_module"
	use sub		&& myconf="${myconf} --with-http_sub_module"
	use random-index	&& myconf="${myconf} --with-http_random_index_module"

	use uploadprogress && myconf="${myconf} --add-module=../${UPLOADPROGRESS}"
	use fair && myconf="${myconf} --add-module=../${FAIR}"
	use redis && myconf="${myconf} --add-module=../${REDIS}"
	use passenger && myconf="${myconf} --add-module=../passenger-${PASSENGER_VERSION}/ext/nginx"

	tc-export CC
	./configure \
		--prefix=/usr \
		--conf-path=/etc/${PN}/${PN}.conf \
		--http-log-path=/var/log/${PN}/access_log \
		--error-log-path=/var/log/${PN}/error_log \
		--pid-path=/var/run/${PN}.pid \
		--http-client-body-temp-path=/var/tmp/${PN}/client \
		--http-proxy-temp-path=/var/tmp/${PN}/proxy \
		--http-fastcgi-temp-path=/var/tmp/${PN}/fastcgi \
		--with-md5-asm --with-md5=/usr/include \
		--with-sha1-asm --with-sha1=/usr/include \
		${myconf} || die "configure failed"

	emake LINK="${CC} ${LDFLAGS}" OTHERLDFLAGS="${LDFLAGS}" || die "failed to compile"
}

src_install() {
	keepdir /var/log/${PN} /var/tmp/${PN}/{client,proxy,fastcgi}

	dosbin objs/nginx
	cp "${FILESDIR}"/nginx-r1 "${T}"/nginx
	doinitd "${T}"/nginx

	cp "${FILESDIR}"/nginx.conf-r4 conf/nginx.conf

	dodir /etc/${PN}
	insinto /etc/${PN}
	doins conf/*

	dodoc CHANGES{,.ru} README

	use perl && {
		cd "${S}"/objs/src/http/modules/perl/
		einstall DESTDIR="${D}"|| die "failed to install perl stuff"
	}

	if use passenger ; then
		exeinto "${PASSENGER_ROOT}"/ext/nginx
		doexe ${WORKDIR}/passenger-"${PASSENGER_VERSION}"/ext/nginx/HelperServer
	fi
}

pkg_postinst() {
	use ssl && {
		if [ ! -f "${ROOT}"/etc/ssl/${PN}/${PN}.key ]; then
			install_cert /etc/ssl/${PN}/${PN}
			chown ${PN}:${PN} "${ROOT}"/etc/ssl/${PN}/${PN}.{crt,csr,key,pem}
		fi
	}
}
