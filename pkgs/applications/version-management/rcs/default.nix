{ lib, stdenv, fetchurl, fetchpatch, buildPackages, diffutils, ed, lzip }:

stdenv.mkDerivation rec {
  pname = "rcs";
  version = "5.10.1";

  src = fetchurl {
    url = "mirror://gnu/rcs/${pname}-${version}.tar.lz";
    sha256 = "sha256-Q93+EHJKi4XiRo9kA7YABzcYbwHmDgvWL95p2EIjTMU=";
  };

  patches = [
    # glibc 2.34 compat
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/rcs/raw/f8e07cd37f4abfb36e37d41852bb8f9e234d3fb1/f/rcs-5.10.0-SIGSTKSZ.patch";
      sha256 = "sha256-mc6Uye9mdEsLBcOnf1m1TUb1BV0ncNU//iKBpLGBjho=";
    })
  ];

  ac_cv_path_ED = "${ed}/bin/ed";
  DIFF = "${diffutils}/bin/diff";
  DIFF3 = "${diffutils}/bin/diff3";

  disallowedReferences =
    lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform)
      [ buildPackages.diffutils buildPackages.ed ];

  NIX_CFLAGS_COMPILE = "-std=c99";

  hardeningDisable = lib.optional stdenv.cc.isClang "format";

  nativeBuildInputs = [ lzip ];

  meta = {
    homepage = "https://www.gnu.org/software/rcs/";
    description = "Revision control system";
    longDescription =
      '' The GNU Revision Control System (RCS) manages multiple revisions of
         files. RCS automates the storing, retrieval, logging,
         identification, and merging of revisions.  RCS is useful for text
         that is revised frequently, including source code, programs,
         documentation, graphics, papers, and form letters.
      '';

    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ eelco ];
    platforms = lib.platforms.unix;
  };
}
