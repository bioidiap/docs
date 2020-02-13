.. vim: set fileencoding=utf-8 :

===================================
 Documentation of all Bob packages
===================================

Start here
----------

* :ref:`bob_main_page`

.. note::
   Bob paper packages can serve as good examples of how to use Bob. Search for
   ``bob.paper`` in our Gitlab: https://gitlab.idiap.ch/bob?filter=bob.paper **AND** in
   PyPI: https://pypi.org/search/?q=bob.paper&c=Framework+::+Bob for paper packages.
   Please note that the older a ``bob.paper`` package is, it is more likely that it uses
   some deprecated practices.

   For example, you can look at:

   * https://gitlab.idiap.ch/bob/bob.paper.icml2017 on how to evaluate a new CNN-based
     face recognition algorithm on face recognition databases. (Note that the
     ``evaluate.py`` command is replaced by ``bob bio evaluate`` in recent versions of
     Bob.)
   * https://gitlab.idiap.ch/bob/bob.paper.btas2018_siliconemask/tree/master/bob/paper/btas2018_siliconemask/database
     and https://gitlab.idiap.ch/bob/bob.db.oulunpu/ for good examples of how to create
     new database interfaces for the ``bob.bio`` and ``bob.pad`` frameworks.

.. note::
   Use :ref:`bob.devtools <bob.devtools>` if you want to develop Bob packages or create
   a new package. **DO NOT** modify (including adding extra files) the source code of
   Bob packages in your Conda environments. Typically, Bob packages can be extended
   without modifying the original package. So you may want to put your new code in a new
   package instead of modifying the original package. Also, Conda uses hard links to
   create new environments from a cache folder. Editing a file in one of the
   environments will edit that file in **ALL** of your environments. The only safe way
   to recover from this is to delete your Conda installation completely and installing
   everything again from scratch.

Please find the documentation of all Bob packages below.

Basic Functionality
-------------------

* :ref:`bob.core`
* :ref:`bob.math`

Data Input and Output
---------------------

* :ref:`bob.io.base`
* :ref:`bob.io.image`
* :ref:`bob.io.video`
* :ref:`bob.io.audio`
* :ref:`bob.io.matlab`

Signal, Audio, Image and Video Processing
-----------------------------------------

* :ref:`bob.sp`
* :ref:`bob.ap`
* :ref:`bob.ip.base`
* :ref:`bob.ip.color`
* :ref:`bob.ip.draw`
* :ref:`bob.ip.gabor`
* :ref:`bob.ip.facedetect`
* :ref:`bob.ip.facelandmarks`
* :ref:`bob.ip.optflow.liu`
* :ref:`bob.ip.optflow.hornschunck`
* :ref:`bob.ip.flandmark`
* :ref:`bob.ip.dlib`
* :ref:`bob.ip.qualitymeasure`
* :ref:`bob.ip.skincolorfilter`
* :ref:`bob.ip.tensorflow_extractor`
* :ref:`bob.ip.binseg`


Machine Learning
----------------

* :ref:`bob.measure`
* :ref:`bob.learn.linear`
* :ref:`bob.learn.mlp`
* :ref:`bob.learn.activation`
* :ref:`bob.learn.libsvm`
* :ref:`bob.learn.em`
* :ref:`bob.learn.boosting`
* :ref:`bob.learn.tensorflow`
* :ref:`bob.learn.pytorch`

Modules for Developers
----------------------

* :ref:`bob.devtools`
* :ref:`bob.extension`
* :ref:`bob.blitz`
* :ref:`bob.buildout`

Parallel Execution
------------------

* :ref:`gridtk`

Biometric Recognition
---------------------

* :ref:`bob.bio.base`
* :ref:`bob.bio.face`
* :ref:`bob.bio.spear`
* :ref:`bob.bio.vein`
* :ref:`bob.bio.video`
* :ref:`bob.bio.gmm`
* :ref:`bob.bio.face_ongoing`
* :ref:`bob.bio.htface`
* :ref:`bob.ip.tensorflow_extractor`
* :ref:`bob.fusion.base`


Presentation Attack Detection (anti-spoofing)
---------------------------------------------

* :ref:`bob.pad.base`
* :ref:`bob.pad.face`
* :ref:`bob.pad.vein`
* :ref:`bob.pad.voice`
* :ref:`bob.fusion.base`


Remote Heart Rate Measurement
-----------------------------

* :ref:`bob.rppg.base`


Database Interfaces
-------------------

Base Database Packages
^^^^^^^^^^^^^^^^^^^^^^

* :ref:`bob.db.base`
* :ref:`bob.bio.base`
* :ref:`bob.pad.base`

Interfaces
^^^^^^^^^^

* :ref:`bob.db.arface`
* :ref:`bob.db.asvspoof2017`
* :ref:`bob.db.asvspoof`
* :ref:`bob.db.atnt`
* :ref:`bob.db.atvskeystroke`
* :ref:`bob.db.avspoof`
* :ref:`bob.db.banca`
* :ref:`bob.db.biosecure`
* :ref:`bob.db.biosecurid.face`
* :ref:`bob.db.casia_fasd`
* :ref:`bob.db.casiasurf`
* :ref:`bob.db.casme2`
* :ref:`bob.db.caspeal`
* :ref:`bob.db.cbsr_nir_vis_2`
* :ref:`bob.db.chasedb1`
* :ref:`bob.db.cohface`
* :ref:`bob.db.cuhk_cufs`
* :ref:`bob.db.cuhk_cufsf`
* :ref:`bob.db.drionsdb`
* :ref:`bob.db.drishtigs1`
* :ref:`bob.db.drive`
* :ref:`bob.db.fargo`
* :ref:`bob.db.frgc`
* :ref:`bob.db.fv3d`
* :ref:`bob.db.gbu`
* :ref:`bob.db.hci_tagging`
* :ref:`bob.db.hrf`
* :ref:`bob.db.ijba`
* :ref:`bob.db.ijbc`
* :ref:`bob.db.iostar`
* :ref:`bob.db.iris`
* :ref:`bob.db.kboc16`
* :ref:`bob.db.ldhf`
* :ref:`bob.db.lfw`
* :ref:`bob.db.livdet2013`
* :ref:`bob.db.maskattack`
* :ref:`bob.db.mnist`
* :ref:`bob.db.mobio`
* :ref:`bob.db.msu_mfsd_mod`
* :ref:`bob.db.multipie`
* :ref:`bob.db.nist_sre12`
* :ref:`bob.db.nivl`
* :ref:`bob.db.oulunpu`
* :ref:`bob.db.pericrosseye`
* :ref:`bob.db.pola_thermal`
* :ref:`bob.db.putvein`
* :ref:`bob.db.refuge`
* :ref:`bob.db.replay`
* :ref:`bob.db.replaymobile`
* :ref:`bob.db.rimoner3`
* :ref:`bob.db.scface`
* :ref:`bob.db.siw`
* :ref:`bob.db.stare`
* :ref:`bob.db.swan`
* :ref:`bob.db.utfvp`
* :ref:`bob.db.uvad`
* :ref:`bob.db.verafinger`
* :ref:`bob.db.voicepa`
* :ref:`bob.db.voxforge`
* :ref:`bob.db.wine`
* :ref:`bob.db.xm2vts`
* :ref:`bob.db.youtube`



Index of all Packages
=====================

.. toctree::
   :maxdepth: 1
   :titlesonly:

   bob <bob/bob/doc/index.rst>
   bob.ap <bob/bob.ap/doc/index.rst>
   bob.bio.base <bob/bob.bio.base/doc/index.rst>
   bob.bio.face <bob/bob.bio.face/doc/index.rst>
   bob.bio.face_ongoing <bob/bob.bio.face_ongoing/doc/index.rst>
   bob.bio.gmm <bob/bob.bio.gmm/doc/index.rst>
   bob.bio.htface <bob/bob.bio.htface/doc/index.rst>
   bob.bio.spear <bob/bob.bio.spear/doc/index.rst>
   bob.bio.vein <bob/bob.bio.vein/doc/index.rst>
   bob.bio.video <bob/bob.bio.video/doc/index.rst>
   bob.blitz <bob/bob.blitz/doc/index.rst>
   bob.buildout <bob/bob.buildout/doc/index.rst>
   bob.core <bob/bob.core/doc/index.rst>
   bob.db.arface <bob/bob.db.arface/doc/index.rst>
   bob.db.asvspoof <bob/bob.db.asvspoof/doc/index.rst>
   bob.db.asvspoof2017 <bob/bob.db.asvspoof2017/doc/index.rst>
   bob.db.atnt <bob/bob.db.atnt/doc/index.rst>
   bob.db.atvskeystroke <bob/bob.db.atvskeystroke/doc/index.rst>
   bob.db.avspoof <bob/bob.db.avspoof/doc/index.rst>
   bob.db.banca <bob/bob.db.banca/doc/index.rst>
   bob.db.base <bob/bob.db.base/doc/index.rst>
   bob.db.biosecure <bob/bob.db.biosecure/doc/index.rst>
   bob.db.biosecurid.face <bob/bob.db.biosecurid.face/doc/index.rst>
   bob.db.casia_fasd <bob/bob.db.casia_fasd/doc/index.rst>
   bob.db.casiasurf <bob/bob.db.casiasurf/doc/index.rst>
   bob.db.casme2 <bob/bob.db.casme2/doc/index.rst>
   bob.db.caspeal <bob/bob.db.caspeal/doc/index.rst>
   bob.db.cbsr_nir_vis_2 <bob/bob.db.cbsr_nir_vis_2/doc/index.rst>
   bob.db.chasedb1 <bob/bob.db.chasedb1/doc/index.rst>
   bob.db.cohface <bob/bob.db.cohface/doc/index.rst>
   bob.db.cuhk_cufs <bob/bob.db.cuhk_cufs/doc/index.rst>
   bob.db.cuhk_cufsf <bob/bob.db.cuhk_cufsf/doc/index.rst>
   bob.db.drionsdb <bob/bob.db.drionsdb/doc/index.rst>
   bob.db.drishtigs1 <bob/bob.db.drishtigs1/doc/index.rst>
   bob.db.drive <bob/bob.db.drive/doc/index.rst>
   bob.db.fargo <bob/bob.db.fargo/doc/index.rst>
   bob.db.frgc <bob/bob.db.frgc/doc/index.rst>
   bob.db.fv3d <bob/bob.db.fv3d/doc/index.rst>
   bob.db.gbu <bob/bob.db.gbu/doc/index.rst>
   bob.db.hci_tagging <bob/bob.db.hci_tagging/doc/index.rst>
   bob.db.hrf <bob/bob.db.hrf/doc/index.rst>
   bob.db.ijba <bob/bob.db.ijba/doc/index.rst>
   bob.db.ijbc <bob/bob.db.ijbc/doc/index.rst>
   bob.db.iostar <bob/bob.db.iostar/doc/index.rst>
   bob.db.iris <bob/bob.db.iris/doc/index.rst>
   bob.db.kboc16 <bob/bob.db.kboc16/doc/index.rst>
   bob.db.ldhf <bob/bob.db.ldhf/doc/index.rst>
   bob.db.lfw <bob/bob.db.lfw/doc/index.rst>
   bob.db.livdet2013 <bob/bob.db.livdet2013/doc/index.rst>
   bob.db.maskattack <bob/bob.db.maskattack/doc/index.rst>
   bob.db.mnist <bob/bob.db.mnist/doc/index.rst>
   bob.db.mobio <bob/bob.db.mobio/doc/index.rst>
   bob.db.msu_mfsd_mod <bob/bob.db.msu_mfsd_mod/doc/index.rst>
   bob.db.multipie <bob/bob.db.multipie/doc/index.rst>
   bob.db.nist_sre12 <bob/bob.db.nist_sre12/doc/index.rst>
   bob.db.nivl <bob/bob.db.nivl/doc/index.rst>
   bob.db.oulunpu <bob/bob.db.oulunpu/doc/index.rst>
   bob.db.pericrosseye <bob/bob.db.pericrosseye/doc/index.rst>
   bob.db.pola_thermal<bob/bob.db.pola_thermal/doc/index.rst>
   bob.db.putvein <bob/bob.db.putvein/doc/index.rst>
   bob.db.refuge <bob/bob.db.refuge/doc/index.rst>
   bob.db.replay <bob/bob.db.replay/doc/index.rst>
   bob.db.replaymobile <bob/bob.db.replaymobile/doc/index.rst>
   bob.db.rimoner3 <bob/bob.db.rimoner3/doc/index.rst>
   bob.db.scface <bob/bob.db.scface/doc/index.rst>
   bob.db.siw <bob/bob.db.siw/doc/index.rst>
   bob.db.stare <bob/bob.db.stare/doc/index.rst>
   bob.db.swan <bob/bob.db.swan/doc/index.rst>
   bob.db.utfvp <bob/bob.db.utfvp/doc/index.rst>
   bob.db.uvad <bob/bob.db.uvad/doc/index.rst>
   bob.db.verafinger <bob/bob.db.verafinger/doc/index.rst>
   bob.db.voicepa <bob/bob.db.voicepa/doc/index.rst>
   bob.db.voxforge <bob/bob.db.voxforge/doc/index.rst>
   bob.db.wine <bob/bob.db.wine/doc/index.rst>
   bob.db.xm2vts <bob/bob.db.xm2vts/doc/index.rst>
   bob.db.youtube <bob/bob.db.youtube/doc/index.rst>
   bob.devtools <bob/bob.devtools/doc/index.rst>
   bob.extension <bob/bob.extension/doc/index.rst>
   bob.fusion.base <bob/bob.fusion.base/doc/index.rst>
   bob.io.audio <bob/bob.io.audio/doc/index.rst>
   bob.io.base <bob/bob.io.base/doc/index.rst>
   bob.io.image <bob/bob.io.image/doc/index.rst>
   bob.io.matlab <bob/bob.io.matlab/doc/index.rst>
   bob.io.video <bob/bob.io.video/doc/index.rst>
   bob.ip.base <bob/bob.ip.base/doc/index.rst>
   bob.ip.binseg <bob/bob.ip.binseg/doc/index.rst>
   bob.ip.color <bob/bob.ip.color/doc/index.rst>
   bob.ip.dlib <bob/bob.ip.dlib/doc/index.rst>
   bob.ip.draw <bob/bob.ip.draw/doc/index.rst>
   bob.ip.facedetect <bob/bob.ip.facedetect/doc/index.rst>
   bob.ip.facelandmarks <bob/bob.ip.facelandmarks/doc/index.rst>
   bob.ip.flandmark <bob/bob.ip.flandmark/doc/index.rst>
   bob.ip.gabor <bob/bob.ip.gabor/doc/index.rst>
   bob.ip.optflow.hornschunck <bob/bob.ip.optflow.hornschunck/doc/index.rst>
   bob.ip.optflow.liu <bob/bob.ip.optflow.liu/doc/index.rst>
   bob.ip.qualitymeasure <bob/bob.ip.qualitymeasure/doc/index.rst>
   bob.ip.skincolorfilter <bob/bob.ip.skincolorfilter/doc/index.rst>
   bob.ip.tensorflow_extractor <bob/bob.ip.tensorflow_extractor/doc/index.rst>
   bob.learn.activation <bob/bob.learn.activation/doc/index.rst>
   bob.learn.boosting <bob/bob.learn.boosting/doc/index.rst>
   bob.learn.em <bob/bob.learn.em/doc/index.rst>
   bob.learn.libsvm <bob/bob.learn.libsvm/doc/index.rst>
   bob.learn.linear <bob/bob.learn.linear/doc/index.rst>
   bob.learn.mlp <bob/bob.learn.mlp/doc/index.rst>
   bob.learn.pytorch <bob/bob.learn.pytorch/doc/index.rst>
   bob.learn.tensorflow <bob/bob.learn.tensorflow/doc/index.rst>
   bob.math <bob/bob.math/doc/index.rst>
   bob.measure <bob/bob.measure/doc/index.rst>
   bob.pad.base <bob/bob.pad.base/doc/index.rst>
   bob.pad.face <bob/bob.pad.face/doc/index.rst>
   bob.pad.vein <bob/bob.pad.vein/doc/index.rst>
   bob.pad.voice <bob/bob.pad.voice/doc/index.rst>
   bob.rppg.base <bob/bob.rppg.base/doc/index.rst>
   bob.sp <bob/bob.sp/doc/index.rst>
   gridtk <bob/gridtk/doc/index.rst>
   readme_index.rst
