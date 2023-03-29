# Quick development setup

## First time setup

### Install idiap-devtools in base

``` sh
conda activate
mamba install idiap-devtools
```

### Clone and set up bob/dev-profile

_You can use any other directory instead of `~/idiap-dev-profiles`._

``` sh
git clone git@gitlab.idiap.ch/bob/dev-profile ~/idiap-dev-profiles/bob
echo '[profiles]
default = "bob"
bob = "~/idiap-dev-profiles/bob"
' > ~/.config/idiap-devtools.toml
```

## Create a dev environment (here for bob/bob.bio.face)

``` sh
git clone git@gitlab.idiap.ch:bob/bob.bio.face.git
cd ./bob.bio.face
devtool env --python=3.10 -o bob_bio_face_env.yaml .
mamba env create -f bob_bio_face_env.yaml -n bob_face_devel
pip install --no-deps -e .
pre-commit install
```
