# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit versionator eutils autotools

EAPI="2"

MY_PV=$(replace_version_separator 3 '-')
S="${WORKDIR}/${PN}-${MY_PV}/source"
MY_SUFFIX="ee"

DESCRIPTION="Ruby Enterprise Edition is a branch of Ruby including various enhancements"
HOMEPAGE="http://www.rubyenterpriseedition.com/"
SRC_URI="mirror://rubyforge/emm-ruby/${PN}-${MY_PV}.tar.gz"

LICENSE="|| ( Ruby GPL-2 )"
SLOT=ee
KEYWORDS="~amd64 ~x86"
IUSE="berkdb debug doc gdbm ipv6 ssl tcmalloc threads tk"

DEPEND="
	dev-libs/openssl
	tcmalloc? ( dev-util/google-perftools )
	>=app-admin/eselect-ruby-20081211"
RDEPEND="${DEPEND}"
PDEPEND="dev-ruby/rubygems-ee"

PROVIDE="virtual/ruby"

src_prepare() {
	epatch "${FILESDIR}/libdir.patch"
	epatch "${FILESDIR}/mkconfig.patch"

	if use tcmalloc ; then
		sed -i 's:^EXTLIBS.*:EXTLIBS = -ltcmalloc_minimal:' Makefile.in
	fi

	# Fix a hardcoded lib path in configure script
	sed -i -e "s:\(RUBY_LIB_PREFIX=\"\${prefix}/\)lib:\1$(get_libdir):" \
	configure.in || die "sed failed"

	eautoreconf
}

src_configure() {
	econf \
		--program-suffix="${MY_SUFFIX}" \
		--enable-shared \
		$(use_enable doc install-doc) \
		$(use_enable threads pthread) \
		$(use_enable ipv6) \
		$(use_enable debug) \
		$(use_with berkdb dbm) \
		$(use_with gdbm) \
		$(use_with ssl openssl) \
		$(use_with tk) \
		--with-sitedir=/usr/$(get_libdir)/ruby${MY_SUFFIX}/site_ruby \
		--enable-option-checking=no \
		|| die "econf failed"
}

src_install() {
	LD_LIBRARY_PATH="${D}/usr/$(get_libdir)"
	RUBYLIB="${S}:${D}/usr/$(get_libdir)/ruby/${SLOT}"
	for d in $(find "${S}/ext" -type d) ; do
		RUBYLIB="${RUBYLIB}:$d"
	done
	export LD_LIBRARY_PATH RUBYLIB

	unset RUBYOPT

	emake DESTDIR="${D}" install || die "make install failed" 

	MINIRUBY=$(echo -e 'include Makefile\ngetminiruby:\n\t@echo	$(MINIRUBY)' | make -f - getminiruby)
	keepdir $(${MINIRUBY} -rrbconfig -e "print Config::CONFIG['sitelibdir']")
	keepdir $(${MINIRUBY} -rrbconfig -e "print Config::CONFIG['sitearchdir']")

	dodoc ChangeLog NEWS README* ToDo
}

pkg_postinst() {
	if [[ ! -n $(readlink "${ROOT}"usr/bin/ruby) ]] ; then
		eselect ruby set ruby${MY_SUFFIX}
	fi

	elog
	elog "This ebuild is compatible to eselect-ruby"
	elog "To switch between available Ruby profiles, execute as root:"
	elog "\teselect ruby set ruby(18|19|...)"
	elog
}

pkg_postrm() {
	if [[ ! -n $(readlink "${ROOT}"usr/bin/ruby) ]] ; then
	eselect ruby set ruby${MY_SUFFIX}
	fi
}
