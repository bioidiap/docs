# Checks if a package is private or not

visibility() {
  local code=$(curl --output /dev/null --silent --fail --write-out "%{http_code}" ${CI_PROJECT_URL})
  [[ ${code} == *200 ]] && true || echo "$pkg: private"
}

for pkg in bob.ip.qualitymeasure bob.ip.skincolorfilter bob.ip.facelandmarks \
bob.ip.dlib bob.db.arface bob.db.asvspoof bob.db.asvspoof2017 \
bob.db.atvskeystroke bob.db.avspoof bob.db.banca bob.db.biosecure \
bob.db.biosecurid.face bob.db.casme2 bob.db.caspeal bob.db.cohface bob.db.frgc \
bob.db.gbu bob.db.hci_tagging bob.db.ijba bob.db.kboc16 bob.db.lfw \
bob.db.livdet2013 bob.db.mobio bob.db.msu_mfsd_mod bob.db.multipie \
bob.db.nist_sre12 bob.db.putvein bob.db.replay bob.db.replaymobile \
bob.db.scface bob.db.utfvp bob.db.verafinger bob.db.fv3d bob.db.hkpu \
bob.db.thufvdt bob.db.mmcbnu6k bob.db.hmtvein bob.db.voicepa bob.db.xm2vts \
bob.db.youtube bob.db.pericrosseye bob.db.cuhk_cufs bob.bio.base bob.bio.gmm \
bob.bio.face bob.bio.spear bob.bio.video bob.bio.vein bob.db.voxforge \
bob.pad.base bob.pad.face bob.db.oulunpu bob.db.uvad \
; do
    CI_PROJECT_URL=https://gitlab.idiap.ch/bob/$pkg
    visibility
done
