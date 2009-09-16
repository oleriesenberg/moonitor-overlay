# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion
inherit qt4

ESVN_REPO_URI="svn://moonitor.org/moonitor/tags/0.2.0/"

ESVN_PROJECT="moonitor-svn"

DESCRIPTION="A dbus monitoring suite for emerge with KDE panel support"

HOMEPAGE="http://moonitor.org"

RESTRICT="mirror"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~x86 ~amd64"


IUSE="kde qt3 cfg-update"

DEPEND="dev-libs/boost
		=sys-libs/dbus-c++-0.3
		kde? ( || ( kde-base/kicker kde-base/kdebase ) )
		qt3? ( >=x11-libs/qt-3.3 ) "

RDEPEND="${DEPEND}
		dev-python/dbus-python
	 	app-portage/portage-bashrc-ng
	 	app-portage/portage-utils"

enable_use() {
	if use $1; then
		echo "--enable-$1"
	fi
}

pkg_setup() {
	if ! use kde; then
		eerror
		eerror "Not using KDE is not yet supported."
		eerror "Rerun emerge with USE=\"kde\""
		eerror
		die
	fi
}

src_compile() {
	einfo "Running autoreconf..."
	autoreconf -fvi >/dev/null 2>&1 \
	|| die "Error: autoreconf failed!"
	einfo "Running econf..."
	econf $(enable_use kde) \
	$(enable_use boost) \
	$(enable_use cfg-update) \
	$(enable_use qt3) >/dev/null 2>&1 \
	|| die "Error: econf failed!"
	emake || die "Error: emake failed!"
}

src_install() {
	make install DESTDIR=${D} \
	|| die "Error: make install failed!"
}

pkg_postinst() {
	einfo
	einfo "USE=\"cfg-update\" is not used yet."
	einfo "If you are using <app-portage/cfg-update-1.8.2 you have to change"
	einfo "EMERGE_EXEC to \"/usr/bin/emerge_with_indexing_for_cfg-update\"" 
	einfo "in /etc/moonitor/moonitor.conf"
	ewarn
	ewarn "In order to use moonitor, you have to append \"moonitor=on\" to"
	ewarn "/etc/portage/bashrc-ng/bashrc-ng.conf to activate the bashrc module."
	ewarn "You can enter your favourite emerge command in /etc/moonitor/moonitor.conf."
	ewarn "To own the moonitor dbus service, your user must be a member of the portage group."
	ewarn
	ewarn "DO NOT report bugs to Gentoo's bugzilla"
	ewarn "Please report all bugs to http://trac.moonitor.org"
}
