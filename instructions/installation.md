# Installation instructions (bob >= 12.0.0)

To install a bob package in order to use its commands and/or python API, you can either
use `conda` or `pip`.

## Installing a bob package with pip

### Installing a stable version

To install a stable (released) package with pip, you can use the ones deployed on pypi.
For example to install the latest stable `bob.bio.face`:

``` sh
pip install bob.bio.face
pip list | grep bob.bio.face
```

should output (with any version number but a beta):

``` text
bob.bio.face      7.1.2
```

If you want to install a beta of a package via pip, you will need to specify our own
registry as an additional `index-url`:

``` sh
pip install --extra-index-url https://gitlab.idiap.ch/api/v4/groups/373/-/packages/pypi/simple bob.bio.face
pip list | grep bob.bio.face
```

should output (with any beta version number):

``` text
bob.bio.face      7.1.3b0
```
> **NOTE:**
>
> If you regularly need to give this extra `index-url`, you can add it to your
> `~/.config/pip/pip.conf`:
>
> ``` text
> [global]
> trusted-host = gitlab.idiap.ch
> extra-index-url = https://gitlab.idiap.ch/api/v4/groups/373/-/packages/pypi/simple
> ```

## Installing a bob package with conda


> **NOTE:**
>
> The following commands use `mamba` as it operates much faster than the regular conda's
> `create` and `install` commands.
>
> If you don't have mamba installed, you can replace all `mamba xxx` commands by
> `conda xxx`.

### Installing a stable version

To create an environment containing a stable (released) bob package with conda, you can
use the following command (assuming you have
[a working conda installation](https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html#regular-installation)):

``` sh
mamba create -n bob_face_stable --override-channels -c https://www.idiap.ch/software/bob/conda -c conda-forge -c defaults bob.bio.face
conda activate bob_face_stable
conda list bob.bio.face
```

should output (with any version number but a beta):

``` text
# packages in environment at /your/path/to/miniconda3/envs/bob_face_stable:
#
# Name            Version              Build  Channel
bob.bio.face      7.1.2       py39hb6b4a9b_0  https://www.idiap.ch/software/bob/conda
```

### Installing a beta version

To create a conda environment containing a beta version of a bob package, you can use
the same method but adding the correct channel:

``` sh
mamba create -n bob_face_beta --override-channels -c https://www.idiap.ch/software/bob/conda/label/beta -c conda-forge -c defaults bob.bio.face
conda activate bob_face_beta
conda list bob.bio.face
```

should output (with any beta version):

``` text
# packages in environment at /your/path/to/miniconda3/envs/bob_face_beta:
#
# Name            Version              Build  Channel
bob.bio.face      7.1.3b0      pyhe1939b0_36  https://www.idiap.ch/software/bob/conda/label/beta
```

> **NOTE:**
>
> You can also install a bob package in an existing conda environment:
>
> ``` sh
> conda activate bob_face_beta
> mamba install --override-channels -c https://www.idiap.ch/software/bob/conda/label/beta -c conda-forge -c defaults bob.pad.face
> ```

## Installing cuda packages with conda

If your machine has no GPU available, conda/mamba will try to install the non-cuda (cpu)
version of packages like pytorch or tensorflow.

There is a way to force conda to install the cuda version of package by setting the
`CONDA_OVERRIDE_CUDA` environment variable to the desired version of cuda that would be
available on a machine with a GPU:

```
export CONDA_OVERRIDE_CUDA="11.6"
mamba create -n bob_face --override-channels -c https://www.idiap.ch/software/bob/conda -c conda-forge -c defaults bob.bio.face
```
