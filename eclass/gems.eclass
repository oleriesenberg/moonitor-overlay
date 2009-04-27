# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/gems.eclass,v 1.21 2008/02/17 08:49:19 rbrown Exp $
#
# Author: Rob Cakebread <pythonhead@gentoo.org>
# Current Maintainer: Ruby Herd <ruby@gentoo.org>
#
# The gems eclass is designed to allow easier installation of
# gems-based ruby packagess and their incorporation into
# the Gentoo Linux system.
#
# - Features:
# gems_location()	  - Set ${GEMSDIR} with gem install dir and ${GEM_SRC} with
# 						path to gem to install. Optionally takes a ruby version string, like 
#						"ruby18" as a parameter.
# gems_src_unpack()	  - Patches the gem, if needed [beta code!, --a3li Sep 26, 2008]
# gems_src_compile()  - Does nothing.
# gems_src_install()  - installs a gem into ${D} using each ruby version that is both 
# 						installed and specified in USE_RUBY.
#
# NOTE:
# See http://dev.gentoo.org/~pythonhead/ruby/gems.html for notes on using gems with portage


inherit eutils ruby

SRC_URI="mirror://rubyforge/gems/${P}.gem"

IUSE="doc"

DEPEND="
	|| ( >=dev-ruby/rubygems-0.9.4 =dev-lang/ruby-1.9* )
	!dev-ruby/rdoc
"
RDEPEND="${DEPEND}"

gems_location() {
	local ruby_version
	if [[ -z "$1" ]]; then
		ruby_version="gem"
	else
		ruby_version=${1/ruby/gem}
	fi
	export GEMSDIR=$(/usr/bin/${ruby_version} env gemdir)
}

gems_src_unpack() {
	[[ -z "${GEM_PATCHES}" ]] && return

	# Prepare environment
	if [[ -z "${MY_P}" ]]; then
		[[ -z "${GEM_SRC}" ]] && GEM_SRC="${DISTDIR}/${P}"
	else
		[[ -z "${GEM_SRC}" ]] && GEM_SRC="${DISTDIR}/${MY_P}"
	fi

	local GEMNAME=${GEM_SRC##${DISTDIR}/}

	# Unpack the gem
	mkdir "${T}/gempatch" "${T}/gembuild" || die "Failed to create dirs"
	cd "${T}/gempatch" || die

	/usr/bin/gem unpack "${GEM_SRC}.gem" >/dev/null 2>&1

	cd "${GEMNAME}" || die 

	# Patch
	for p in ${GEM_PATCHES} ; do
		epatch ${p}
	done

	# Repacking data (yes, ruby's tar format is a little weird...)
	find -type f -print0 | sed -e 's#\./##g' | xargs -0 \
	tar --format posix -czf ../../gembuild/data-new.tar.gz

	[[ $? -eq 0 ]] || die "Repacking failed"

	# Repack gem
	cd "${T}/gembuild" || die

	tar -xf "${GEM_SRC}.gem" >/dev/null 2>&1 || die "Couldn't unpack raw gem"
	mv data-new.tar.gz data.tar.gz
	
	rm "${GEM_SRC}.gem" || die "Couldn't remove distfile symlink"
	tar -cf "${T}/${GEMNAME}.gem" data.tar.gz metadata* \
		|| die "Couldn't repack gem"

	# Set patched gem path
	export GEM_SRC="${T}/${GEMNAME}.gem"

	einfo "Done with patching the gem."
}

gems_src_compile() {
	true
}

gems_src_install() {
	local myconf
	if use doc; then
		myconf="--rdoc --ri"
	else
		myconf="--no-rdoc --no-ri"
	fi

	# I'm not sure how many ebuilds have correctly set USE_RUBY - let's assume
	# ruby18 if they haven't, since even pure Ruby gems that have been written
	# against 1.8 can explode under 1.9.
	if [[ -z "${USE_RUBY}" ]]; then
		USE_RUBY="ruby18"
	elif [[ "${USE_RUBY}" == "any" ]]; then
		# Get the installed versions.
		USE_RUBY=`ls /usr/bin/ruby* | grep -E 'ruby1(8|9)' | sed -e 's@/usr/bin/@@g'`
	fi

	local num_ruby_slots=$(echo "${USE_RUBY}" | wc -w)

	for ruby_version in ${USE_RUBY} ; do
		# Check that we have the version installed
		[[ -e "/usr/bin/${ruby_version/ruby/gem}" ]] || continue

		einfo "Installing for ${ruby_version}..."
		gems_location ${ruby_version}
		dodir ${GEMSDIR}

		if [[ -z "${MY_P}" ]]; then
			[[ -z "${GEM_SRC}" ]] && GEM_SRC="${DISTDIR}/${P}"
			spec_path="${D}/${GEMSDIR}/specifications/${P}.gemspec"
		else
			[[ -z "${GEM_SRC}" ]] && GEM_SRC="${DISTDIR}/${MY_P}"
			spec_path="${D}/${GEMSDIR}/specifications/${MY_P}.gemspec"
		fi

		# >=1.3.0 needs a path fix
		local gte13=$(/usr/bin/${ruby_version} -rubygems -e 'puts Gem::RubyGemsVersion >= "1.3.0"')

		if [[ "${gte13}" == "true" ]] ; then
			/usr/bin/${ruby_version} /usr/bin/gem install ${GEM_SRC} \
			--version ${PV} ${myconf} --local --install-dir "${D}/${GEMSDIR}" \
			--sandbox-fix --no-user-install || die "gem (>=1.3.0) install failed"
		else
			/usr/bin/${ruby_version} /usr/bin/gem install ${GEM_SRC} \
			--version ${PV} ${myconf} --local --install-dir "${D}/${GEMSDIR}" \
			|| die "gem (<1.3.0) install failed"
		fi

		if [[ -d "${D}/${GEMSDIR}/bin" ]] ; then
			exeinto /usr/bin
			for exe in "${D}"/${GEMSDIR}/bin/* ; do
				if [ "$num_ruby_slots" -ge 2 ] ; then
					# Ensures that the exe file gets run using the currently
					# selected version of ruby.
					sed -i -e 's@^#!/usr/bin/ruby.*$@#!/usr/bin/ruby@' "${exe}"
				fi
				doexe "${exe}"
			done
		fi
	done
}

EXPORT_FUNCTIONS src_unpack src_compile src_install
