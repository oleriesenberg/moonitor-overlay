# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit subversion
inherit qt3

ESVN_REPO_URI="svn://moonitor.org/moonitor/branches/automake"

ESVN_PROJECT="moonitor-svn"

DESCRIPTION="A dbus monitoring suite for emerge with KDE panel support"

RESTRICT="mirror"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~x86 ~amd64"


IUSE="kde qt3 ncurses"

DEPEND="dev-libs/boost
		sys-libs/dbus-c++
		kde? ( || ( kde-base/kicker kde-base/kdebase ) )
		qt3? ( >=x11-libs/qt-3.3 )
		ncurses? ( =sys-libs/ndk++-9999 )"

RDEPEND="${DEPEND}
		dev-python/dbus-python
	 	app-portage/portage-bashrc-ng
	 	app-portage/portage-utils"

enable_use() {
	if use $1; then
		echo "--enable-$1"
	fi
}

src_compile() {
	einfo "Running autoreconf..."
	autoreconf -fvi > build.log 2>&1 \
	|| die "Error: autoreconf failed!"

	einfo "Running econf..."
	econf $(enable_use kde) \
	$(enable_use qt3) \
	$(enable_use ncurses) \
	--prefix=/ \
	--exec-prefix=/usr \
	--includedir=/usr/include \
	--datarootdir=/usr/share \
	>> build.log 2>&1 \
	|| die "Error: econf failed!"

	einfo "Running emake..."
	emake >> build.log 2>&1 || die "Error: emake failed!"
}

src_install() {
	einfo "Installing moonitor..."
	make install DESTDIR=${D} >> build.log 2>&1 || die "Error: make install failed!"
}

pkg_postinst() {
	ewarn
	ewarn "In order to use moonitor, you have to append \"moonitor=on\" to"
	ewarn "/etc/portage/bashrc-ng/bashrc-ng.conf to activate the bashrc module."
	ewarn
	ewarn "You can enter your favourite emerge command in /etc/moonitor/moonitor.conf."
	ewarn "If you are using <app-portage/cfg-update-1.8.2, you have to set it to"
	ewarn "\"/usr/bin/emerge_with_indexing_for_cfg-update\""
	ewarn
	ewarn "To own the moonitor dbus service, your user must be a member of the portage group."
	ewarn
	ewarn "DO NOT report bugs to Gentoo's bugzilla"
	ewarn "Please report all bugs to http://trac.moonitor.org"
}
