# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils linux-mod 

X86_HYB_PACKAGE="32"
AMD64_HYB_PACKAGE="64"

DESCRIPTION="Driver for Broadcom 4311, 4312, 4321 and 4322"
HOMEPAGE="http://www.broadcom.com/support/802.11/linux_sta.php"
SRC_URI="x86? ( http://www.broadcom.com/docs/linux_sta/hybrid-portsrc-x86_32-v${PV//./_}.tar.gz )
	 amd64? ( http://www.broadcom.com/docs/linux_sta/hybrid-portsrc-x86_64-v${PV//./_}.tar.gz )"

LICENSE="proprietary"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="strip mirror"

DEPEND=""
RDEPEND=""
PDEPEND=""

pkg_setup() {
	linux-mod_pkg_setup
}
