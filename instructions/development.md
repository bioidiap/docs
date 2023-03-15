### Developing a bob package

We follow the development procedure defined in
[idiap-devtools](https://www.idiap.ch/software/biosignal/docs/software/idiap-devtools/main/sphinx/).
You will need a working conda installation with `devtool` in it (preferably in `base`),
installed with:

``` sh
mamba install -n base -c https://www.idiap.ch/software/bob/conda/label/beta -c conda-forge idiap-devtools
```

You will also need a local copy of bob's `dev-profile`:

``` sh
git clone git@gitlab.idiap.ch:bob/dev-profile.git /your/path/to/idiap-profiles/bob
```

To create a development environment for a particular package execute:

``` sh
# git clone git@gitlab.idiap.ch:bob/bob.bio.face.git
# conda activate
devtool env -P /your/path/to/idiap-profiles/bob ./bob.bio.face
mamba env create -f environment.yaml -n bob_face_devel
mamba activate bob_face_devel
pip install --no-deps -e ./bob.bio.face
```

> **NOTE:**
>
> You can also define the profiles' paths in a configuration file (see here) so you can
> use the simpler `devtool env` command:
>
> ``` sh
> devtool env -P bob ./bob.bio.face
> ```
