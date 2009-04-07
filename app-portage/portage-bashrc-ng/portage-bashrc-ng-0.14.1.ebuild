# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /cvsroot/portage-bashrc//portage-bashrc-ng/portage-bashrc-ng-9999.ebuild,v 1.11 2007/02/15 14:33:41 toffanin_mauro Exp $

inherit eutils

DESCRIPTION="A pluggable Portage add-on. Included: tmpfs, autopatch, localepurge, perpackage, resumemerge, distclean"
HOMEPAGE="http://portage-bashrc.sourceforge.net/"
SRC_URI="mirror://sourceforge/gechi-overlay/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE=""
DEPEND=""
RDEPEND="!app-portage/bashrcng
	>=sys-apps/portage-2.1.2-r9
	app-admin/eselect"

RESTRICT="primaryuri"

src_install() {
	# Install bashrc script
	insinto /etc/portage
	doins bashrc

	# Install sample configuration file
	insinto /etc/portage/bashrc-ng
	doins bashrc-ng/bashrc-ng.conf.example
	if [ ! -e /etc/portage/bashrc-ng/bashrc-ng.conf ] ; then
		ebegin "First configuration file installation"
			cp bashrc-ng/bashrc-ng.conf.example bashrc-ng/bashrc-ng.conf
			doins bashrc-ng/bashrc-ng.conf
		eend $?
	fi

	# Install modules
	insinto /usr/share/portage-bashrc-ng
	doins bashrc-ng/*.module

	# Install common functions repository
	doins bashrc-ng/common.funcs

	# Install eselect module
	insinto /usr/share/eselect/modules
	doins bashrc-ng.eselect

	# Install same little utils
	dosbin bin/*

	# Install docs
	docinto modules
	dodoc docs/*
}

pkg_postinst() {
	echo

	ewarn "bashrc-ng modules handling is changed!"
	ewarn "the configuration file: /etc/portage/bashrc-ng/bashrc-ng.conf"
	ewarn "do not store anymore the modules activation status (see below),"
	ewarn "but only the modules options."
	ebeep 5

	echo
	einfo "To manage bashrc-ng modules please use 'eselect' tool."
	einfo
	einfo "For example, to enable module name 'perpackage':"
	einfo "  eselect bashrc-ng enable perpackage"
	einfo
	einfo "If you want to know which bashrc-ng modules are available:"
	einfo "  eselect bashrc-ng list"
	echo
}

# DEPRECATED, will be removed soon!
#pkg_postrm() {
#	ewarn
#	ewarn "Please remember to remove /etc/portage/bashrc if you unmerge"
#	ewarn "portage-bashrc-ng."
#	ewarn
#}
