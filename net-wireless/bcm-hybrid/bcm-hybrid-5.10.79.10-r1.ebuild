# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils linux-mod 

DESCRIPTION="Driver for Broadcom 4311, 4312, 4321 and 4322"
HOMEPAGE="http://www.broadcom.com/support/802.11/linux_sta.php"
SRC_URI="x86? ( http://www.broadcom.com/docs/linux_sta/hybrid-portsrc-x86_32-v${PV//./_}.tar.gz )
	 amd64? ( http://www.broadcom.com/docs/linux_sta/hybrid-portsrc-x86_64-v${PV//./_}.tar.gz )"

LICENSE="GPL2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="strip mirror"

DEPEND=""
RDEPEND=""
PDEPEND=""

src_unpack() {
	unpack ${A}
	cd $S
	EPATCH_OPTS="-p1" 
	epatch "${FILESDIR}/broadcom-wl-5.10.27.14-linux-2.6.29.patch"
}

pkg_setup() {
	linux-mod_pkg_setup
	S=${S%/*}
	BUILD_PARAMS="-C ${KERNEL_DIR} M=${S}"
	MODULE_NAMES="wl(net:${S})"
}

src_compile() {
	debug-print-function ${FUNCNAME} $*

	local modulename libdir srcdir objdir i n myABI="${ABI}"
	set_arch_to_kernel
	ABI="${KERNEL_ABI}"

	BUILD_TARGETS=${BUILD_TARGETS:-clean module}
	strip_modulenames;
	cd "${S}"
	touch Module.symvers
	for i in ${MODULE_NAMES}
	do
		unset libdir srcdir objdir
		for n in $(find_module_params ${i})
		do
			eval ${n/:*}=${n/*:/}
		done
		libdir=${libdir:-misc}
		srcdir=${srcdir:-${S}}
		objdir=${objdir:-${srcdir}}

		if [ ! -f "${srcdir}/.built" ];
		then
			cd ${srcdir}
			ln -s "${S}"/Module.symvers Module.symvers
			einfo "Preparing ${modulename} module"
			if [[ -n ${ECONF_PARAMS} ]]
			then
				econf ${ECONF_PARAMS} || \
				die "Unable to run econf ${ECONF_PARAMS}"
			fi

			# This looks messy, but it is needed to handle multiple variables
			# being passed in the BUILD_* stuff where the variables also have
			# spaces that must be preserved. If don't do this, then the stuff
			# inside the variables gets used as targets for Make, which then
			# fails.
			eval "emake HOSTCC=\"$(tc-getBUILD_CC)\" \
						CROSS_COMPILE=${CHOST}- \
						LDFLAGS=\"$(get_abi_LDFLAGS)\" \
						${BUILD_FIXES} \
						${BUILD_PARAMS}" \
				|| die "Unable to emake HOSTCC="$(tc-getBUILD_CC)" CROSS_COMPILE=${CHOST}- LDFLAGS="$(get_abi_LDFLAGS)" ${BUILD_FIXES} ${BUILD_PARAMS} ${BUILD_TARGETS}"
			cd ${OLDPWD}
			touch ${srcdir}/.built
		fi
	done

	set_arch_to_portage
	ABI="${myABI}"
}

src_install() {
	linux-mod_src_install
	insinto ${ROOT}/usr/share/${PF}
	doins lib/LICENSE.txt || die "doins lib/LICENSE.txt failed"
}
pkg_postinst() {
	linux-mod_pkg_postinst
	ewarn "You must read /usr/share/doc/${PF}/LICENSE.txt before using this software."
}
