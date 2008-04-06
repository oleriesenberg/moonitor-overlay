# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

IUSE=""
DESCRIPTION="The Ventrilo Voice Communication Server"
HOMEPAGE="http://www.ventrilo.com/"
SRC_URI="http://distfiles.moonitor.org/ventrilo_2_1_2_server_linux.tar.gz"

LICENSE="ventrilo"
SLOT="0"
KEYWORDS="-* x86 amd64"
RESTRICT="mirror"

S=${WORKDIR}

DEPEND="amd64? ( app-emulation/emul-linux-x86-baselibs )"

src_install() {
        exeinto /opt/ventrilo-server
        doexe ventrilo_{srv,status}

        newinitd "${FILESDIR}"/init.d.ventrilo ventrilo
        newconfd "${FILESDIR}"/conf.d.ventrilo ventrilo

        insinto /opt/ventrilo-server
        doins ventrilo_srv.ini

        dohtml ventrilo_srv.htm
}