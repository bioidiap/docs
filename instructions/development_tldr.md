# Quick development setup

Here is an example of how to create a working development environment for
`bob.bio.face`:

``` sh
git clone git@gitlab.idiap.ch:bob/bob.bio.face.git
devtool env ./bob.bio.face -o bob_bio_face_env.yaml
mamba env create -f bob_bio_face_env.yaml -n bob_face_devel
pip install --no-deps -e ./bob.bio.face
```
