# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils ssl-cert

DESCRIPTION="Robust, small and high performance http and reverse proxy server"

UPLOADPROGRESS="nginx_uploadprogress_module"
FAIR="nginx-upstream-fair"

HOMEPAGE="http://nginx.net/"
SRC_URI="http://sysoev.ru/nginx/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="addition debug fastcgi flv imap pcre perl ssl status sub webdav zlib uploadprogress fair passenger random-index ipv6"

DEPEND="dev-lang/perl
	pcre? ( >=dev-libs/libpcre-4.2 )
	ssl? ( dev-libs/openssl )
	zlib? ( sys-libs/zlib )
	perl? ( >=dev-lang/perl-5.8 )"

pkg_setup() {
	if use passenger ; then
		PASSENGER_ROOT=`passenger-config --root` ||	die "Please install passenger via rubygems to use it with nginx"
		PASSENGER_VERSION=`passenger-config --version`
	fi

	ebegin "Creating nginx user and group"
	enewgroup nginx
	enewuser nginx -1 -1 /dev/null nginx
	eend ${?}
}

src_unpack() {
	unpack ${A}
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
	use random-index  && myconf="${myconf} --with-http_random_index_module"
	use ipv6	&& myconf="${myconf} --with-ipv6"

	use uploadprogress && myconf="${myconf} --add-module=../${UPLOADPROGRESS}"
	use fair && myconf="${myconf} --add-module=../${FAIR}"
	use passenger && myconf="${myconf} --add-module=../passenger-${PASSENGER_VERSION}/ext/nginx"

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

	emake || die "failed to compile"
}

src_install() {
	keepdir /var/log/${PN} /var/tmp/${PN}/{client,proxy,fastcgi}

	dosbin objs/nginx
	cp "${FILESDIR}"/nginx-r1 "${T}"/nginx
	doinitd "${T}"/nginx

	cp "${FILESDIR}"/nginx.conf-r4 conf/nginx.conf

	dodir "${ROOT}"/etc/${PN}
	insinto "${ROOT}"/etc/${PN}
	doins conf/*

	dodoc CHANGES{,.ru} LICENSE README

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
			dodir "${ROOT}"/etc/ssl/${PN}
			insinto "${ROOT}"etc/ssl/${PN}/

			insopts -m0644 -o nginx -g nginx
			install_cert /etc/ssl/nginx/nginx
		fi
	}
}
