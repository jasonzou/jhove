#!/usr/bin/env bash

testRoot="test-root"
paramCandidateVersion=""
paramBaselineVersion=""
baselineRoot="${testRoot}/baselines"
candidateRoot="${testRoot}/candidates"
targetRoot="${testRoot}/targets"
# Check the passed params to avoid disapointment
checkParams () {
	OPTIND=1	# Reset in case getopts previously used

	while getopts "h?b:c:" opt; do	# Grab the options
		case "$opt" in
		h|\?)
			showHelp
			exit 0
			;;
		b)	paramBaselineVersion=$OPTARG
			;;
		c)	paramCandidateVersion=$OPTARG
			;;
		esac
	done

	if [ -z "$paramBaselineVersion" ] || [ -z "$paramCandidateVersion" ]
	then
		showHelp
		exit 0
	fi

	baselineRoot="${baselineRoot}/${paramBaselineVersion}"
	candidateRoot="${candidateRoot}/${paramCandidateVersion}"
	targetRoot="${targetRoot}/${paramCandidateVersion}"
}

# Show usage message
showHelp() {
	echo "usage: create-target [-b <baselineVersion>] [-c <candidateVersion>] [-h|?]"
	echo ""
	echo "  baselineVersion  : The version number id for the baseline data."
	echo "  candidateVersion : The version number id for the candidate data."
	echo ""
	echo "  -h|? : This message."
}

# Execution starts here
checkParams "$@";
if [[ -d "${targetRoot}" ]]; then
	rm -rf "${targetRoot}"
fi

# Simply copy 1.16 for now we're not making any changes
cp -R "${baselineRoot}" "${targetRoot}"

# Use the new audit for gzip and warc modules since external signatures have been added
if [[ -f "${candidateRoot}/examples/modules/audit-GZIP-kb.jhove.xml" ]]; then
	cp "${candidateRoot}/examples/modules/audit-GZIP-kb.jhove.xml" "${targetRoot}/examples/modules/"
fi
if [[ -f "${candidateRoot}/examples/modules/audit-WARC-kb.jhove.xml" ]]; then
	cp "${candidateRoot}/examples/modules/audit-WARC-kb.jhove.xml" "${targetRoot}/examples/modules/"
fi

# Issue 62 add ICCProfileName
if [[ -f "${candidateRoot}/examples/modules/JPEG-hul/AA_Banner-progressive.jpg.jhove.xml" ]]; then
	cp "${candidateRoot}/examples/modules/JPEG-hul/AA_Banner-progressive.jpg.jhove.xml" "${targetRoot}/examples/modules/JPEG-hul/"
fi
if [[ -f "${candidateRoot}/examples/modules/JPEG-hul/AA_Banner.jpg.jhove.xml" ]]; then
	cp "${candidateRoot}/examples/modules/JPEG-hul/AA_Banner.jpg.jhove.xml" "${targetRoot}/examples/modules/JPEG-hul/"
fi
if [[ -f "${candidateRoot}/examples/modules/TIFF-hul/6mp_soft.tif.jhove.xml" ]]; then
	cp "${candidateRoot}/examples/modules/TIFF-hul/6mp_soft.tif.jhove.xml" "${targetRoot}/examples/modules/TIFF-hul/"
fi
if [[ -f "${candidateRoot}/examples/modules/TIFF-hul/AA_Banner.tif.jhove.xml" ]]; then
	cp "${candidateRoot}/examples/modules/TIFF-hul/AA_Banner.tif.jhove.xml" "${targetRoot}/examples/modules/TIFF-hul/"
fi;

# Copy over the fixed version for an encrypted file testRoot
if [[ -f "${candidateRoot}/examples/modules/TIFF-hul/AA_Banner.tif.jhove.xml" ]]; then
	cp "${candidateRoot}/errors/modules/PDF-hul/pdf-hul-22-govdocs-000187.pdf.jhove.xml" "${targetRoot}/errors/modules/PDF-hul/"
fi;

# Sed fix for changed key encryption message
find "${targetRoot}" -type f -name "pdf-hul-43-govdocs-486355.pdf.jhove.xml" -exec sed -i 's/Key greater than 40/40-bit or greater RC4 or AES/' {} \;

# Copy over the fixed version for an encrypted file testRoot
if [[ -f "${candidateRoot}/examples/modules/audit-WAVE-hul.jhove.xml" ]]; then
	cp "${candidateRoot}/examples/modules/audit-WAVE-hul.jhove.xml" "${targetRoot}/examples/modules/"
fi;

# Sed fix for change to WAV MIME type
find "${targetRoot}" -type f -name "*.wav.jhove.xml" -exec sed -i 's/audio\/x-wave<\/mimeType>/audio\/vnd.wave<\/mimeType>/' {} \;

# Issue 60 add new file 20150213_140637.jpg with exif profile
if [[ -f "${candidateRoot}/examples/modules/JPEG-hul/20150213_140637.jpg.jhove.xml" ]]; then
	cp "${candidateRoot}/examples/modules/JPEG-hul/20150213_140637.jpg.jhove.xml" "${targetRoot}/examples/modules/JPEG-hul/"
fi;

# Issue 60 add new audit for JPEG and TIFF since new documentation added
if [[ -f "${candidateRoot}/examples/modules/audit-JPEG-hul.jhove.xml" ]]; then
	cp "${candidateRoot}/examples/modules/audit-JPEG-hul.jhove.xml" "${targetRoot}/examples/modules/"
fi;

if [[ -f "${candidateRoot}/examples/modules/audit-TIFF-hul.jhove.xml" ]]; then
	cp "${candidateRoot}/examples/modules/audit-TIFF-hul.jhove.xml" "${targetRoot}/examples/modules/"
fi;

find "${targetRoot}" -type f -name "audit.jhove.xml" -exec sed -i 's/^   <module release="1.2">JPEG-hul<\/module>$/   <module release="1.3">JPEG-hul<\/module>/' {} \;
find "${targetRoot}" -type f -name "audit.jhove.xml" -exec sed -i 's/^   <module release="1.7">TIFF-hul<\/module>$/   <module release="1.8">TIFF-hul<\/module>/' {} \;
find "${targetRoot}" -type f -name "*.tif.jhove.xml" -exec sed -i 's%<reportingModule release="1.7" date="2012-08-12">TIFF%<reportingModule release="1.8" date="2017-05-11">TIFF%' {} \;
find "${targetRoot}" -type f -name "*.g3.jhove.xml" -exec sed -i 's%<reportingModule release="1.7" date="2012-08-12">TIFF%<reportingModule release="1.8" date="2017-05-11">TIFF%' {} \;
find "${targetRoot}" -type f -name "bathy1.*.jhove.xml" -exec sed -i 's%<reportingModule release="1.7" date="2012-08-12">TIFF%<reportingModule release="1.8" date="2017-05-11">TIFF%' {} \;
find "${targetRoot}" -type f -name "compos.*.jhove.xml" -exec sed -i 's%<reportingModule release="1.7" date="2012-08-12">TIFF%<reportingModule release="1.8" date="2017-05-11">TIFF%' {} \;
find "${targetRoot}" -type f -name "*.jpg.jhove.xml" -exec sed -i 's%<reportingModule release="1.2" date="2007-02-13">JPEG%<reportingModule release="1.3" date="2017-05-11">JPEG%' {} \;
find "${targetRoot}" -type f -name "README.jhove.xml" -exec sed -i 's%<reportingModule release="1.7" date="2012-08-12">TIFF%<reportingModule release="1.8" date="2017-05-11">TIFF%' {} \;
find "${targetRoot}" -type f -name "README.jhove.xml" -exec sed -i 's%<reportingModule release="1.2" date="2007-02-13">JPEG%<reportingModule release="1.3" date="2017-05-11">JPEG%' {} \;
find "${targetRoot}" -type f -name "*.wav.jhove.xml" -exec sed -i 's%44100.0</aes:sampleRate>%44100</aes:sampleRate>%' {} \;
