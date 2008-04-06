# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header$

inherit eutils

MY_PN=${PN/portage-}
MY_PN=${MY_PN/-ng}
MY_PV=${PV/.1_beta}
MY_P=${MY_PN}-v$MY_PV
MY_SF=${PN/-ng}

DESCRIPTION="A pluggable Portage add-on. Included: tmpfs, autopatch, localepurge, perpackage, resumemerge, distclean"
HOMEPAGE="http://portage-bashrc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${MY_SF}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc-macos ~ppc64 ~s390 ~sparc ~x86"
IUSE="tmpfs perpackage localepurge autopatch resumemerge distclean"
RESTRICT="mirror"

DEPEND=">=sys-apps/portage-2.1
	>=sys-apps/coreutils-5.94-r1
	autopatch?	( >=sys-devel/patch-2.5.9 )
	localepurge?	( >=app-admin/localepurge-0.5-r1 )"

S="${WORKDIR}/${PN}-${MY_PV}_beta"

src_unpack() {
	unpack ${A}
	cd ${S}
}

src_install() {
	insinto /etc/portage
	doins bashrc
	dodir /etc/portage/bashrc-ng
	insinto /etc/portage/bashrc-ng
	doins bashrc-ng/bashrc-ng.conf.example
	dodir /usr/share/portage-bashrc-ng
	insinto /usr/share/portage-bashrc-ng
	doins bashrc-ng/*.module
	insinto /usr/share/eselect/modules
	doins bashrc-ng.eselect
	docinto modules
	dodoc docs/*
}

pkg_postinst() {
	echo ""
	echo ""
	einfo "To create a default configuration, please do:"
	einfo "emerge --config =${PF}"
	einfo ""
	einfo "If you want to configure ${PF} manually, please do:"
	einfo "cp ${ROOT}etc/portage/bashrc-ng/bashrc-ng.conf.example ${ROOT}etc/portage/bashrc-ng/bashrc-ng.conf"
	einfo "${EDITOR} ${ROOT}etc/portage/bashrc-ng/bashrc-ng.conf"
	echo ""
	echo ""
}

pkg_config() {
	cp ${ROOT}etc/portage/bashrc-ng/bashrc-ng.conf.example ${ROOT}etc/portage/bashrc-ng/bashrc-ng.conf

	if use autopatch; then
		ebegin "Activating AutoPatch module"
			sed -i -e "s:#autopatch=on:autopatch=on:" \
			       -e "s:#PATCH_OVERLAY=\/usr\/portage\/local\/patches\/$:PATCH_OVERLAY=\/usr\/portage\/local\/patches\/:" \
				   ${ROOT}etc/portage/bashrc-ng/bashrc-ng.conf || die
			mkdir -p ${ROOT}usr/portage/local/patches
		eend $?
	fi;

	if use localepurge; then
		ebegin "Activating LocalePurge module"
			sed -i -e "s:#localepurge=on:localepurge=on:" \
				${ROOT}etc/portage/bashrc-ng/bashrc-ng.conf || die
		eend $?
	fi;

	if use resumemerge; then
		ebegin "Activating ResumeMerge module"
			sed -i -e "s:#resumemerge=on:resumemerge=on:" \
				${ROOT}etc/portage/bashrc-ng/bashrc-ng.conf || die
		eend $?
	fi;

	if use perpackage; then
		ebegin "Activating PerPackage module"
			sed -i -e "s:#perpackage=on:perpackage=on:" \
				${ROOT}etc/portage/bashrc-ng/bashrc-ng.conf || die
			touch ${ROOT}etc/portage/package.cflags
			touch ${ROOT}etc/portage/package.cxxflags
			touch ${ROOT}etc/portage/package.features
			touch ${ROOT}etc/portage/package.ldflags
			touch ${ROOT}etc/portage/package.nocflags
			touch ${ROOT}etc/portage/package.nocxxflags
			touch ${ROOT}etc/portage/package.nofeatures
			touch ${ROOT}etc/portage/package.noldflags
		eend $?
	fi;

	if use tmpfs; then
		ebegin "Activating tmpFS module"
			sed -i -e "s:#tmpfs=on:tmpfs=on:" \
			       -e "s:#PORTAGE_MEMSIZE=500M:PORTAGE_MEMSIZE=500M:" \
					${ROOT}etc/portage/bashrc-ng/bashrc-ng.conf || die
			touch ${ROOT}etc/portage/package.mem
		eend $?
	fi;
	
	if use distclean; then
		ebegin "Activating DistClean module"
			sed -i -e "s:#distclean=on:distclean=on:" \
				${ROOT}etc/portage/bashrc-ng/bashrc-ng.conf || die
		eend $?
	fi;
}

pkg_postrm() {
	echo ""
	ewarn "Please rememeber to remove /etc/portage/bashrc if you unmerge"
	ewarn "portage-bashrc-ng."
	echo ""
}
