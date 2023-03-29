# Developing a bob package

## Creating a development environment

We follow the development procedure defined in
[idiap-devtools](https://www.idiap.ch/software/biosignal/docs/software/idiap-devtools/main/sphinx/).
You will need a working conda installation with `devtool` in it (preferably in the
`base` environment), installed with:

``` sh
mamba install -n base --override-channels -c https://www.idiap.ch/software/bob/conda/label/beta -c conda-forge -c defaults idiap-devtools
```

You will also need a local copy of bob's `dev-profile`:

``` sh
git clone git@gitlab.idiap.ch:bob/dev-profile.git /your/path/to/idiap-profiles/bob
```

To create a development environment for a particular package execute (e.g. with
`bob.bio.face`):

``` sh
# git clone git@gitlab.idiap.ch:bob/bob.bio.face.git
# conda activate
devtool env --python=3.10 -P /your/path/to/idiap-profiles/bob ./bob.bio.face
mamba env create -f environment.yaml -n bob_face_devel
mamba activate bob_face_devel
pip install --no-deps --editable ./bob.bio.face
```

> **NOTE:**
>
> You can also define the profiles' paths in a configuration file (read
> [here](https://www.idiap.ch/software/biosignal/docs/software/idiap-devtools/main/sphinx/install.html#setting-up-development-profiles)
> for more info) so you can use the simpler `devtool env` command:
>
> ``` sh
> devtool env --python=3.10 -P bob ./bob.bio.face
> ```
>
> or, if the default is set correctly:
>
> ``` sh
> devtool env --python=3.10 ./bob.bio.face
> ```

Any modification of the project's code will be reflected in the environment (thanks to
`--editable`). If this is not a desirable behavior, you can install the package using:

``` sh
pip install --no-deps ./bob.bio.face
```

In that case to account for any changes in the code, you must execute that command again
for the installed files to reflect the new changes.

# Development guidelines

Use English (prefer American English) when writing comments, identifiers (variables,
functions, classes, etc.), and commit messages.

Limit your lines length to 88 characters (enforced for the code by `black`, but try to
respect it also in the docstring and text files).

Do document your functions, classes and methods with some docstring.

Try to use python typing for your functions and methods arguments.

``` python
def append_suffix(string: str, suffix: str) -> str:
    """Short description of the function.

    Long description and details about the function.

    Parameters
    ----------
    string
        Description of the ``string`` parameter.
    suffix
        Description of the ``suffix`` parameter.

    Returns
    -------
    Description of the return value.
    """

    return "".join((string, suffix))
```

Commit your changes to a branch (not main or master), and create merge requests (MR) in
GitLab for your changes to be included into a package.

``` sh
git checkout -b awesome-branch
```

Prefer the use of [Conventional Commit](https://www.conventionalcommits.org/en/v1.0.0/)
to write your commit messages.

Use `pre-commit` to ensure the code quality respects our standards. You will need to
install the `pre-commit` package once in your environment, and run `pre-commit install`
on a freshly cloned repository. If you already committed changes before installing,
please run `pre-commit run --all-files` to verify that previous changes are up to
standards. The CI will fail if `pre-commit` does not pass.

``` sh
conda activate your_dev_env
mamba install pre-commit
cd your/path/to/bob.bio.face
pre-commit install
pre-commit run --all-files
```

Then the `pre-commit` hooks will be called every time you do a `git commit`, with a
summary of what was modified automatically or what needs to be fixed. When everything is
fixed, just run `git commit` again and (if everything is correct), the commit will not
fail.

You can then `git push` your changes to GitLab and create a merge request with a
description of the changes you made.

A CI pipeline will be run to ensure `pre-commit` is valid, tests pass, and the package
can be built.

## Installing cuda packages with conda

If your machine has no GPU available, conda/mamba will try to install the non-cuda (cpu)
version of packages like pytorch or tensorflow.

There is a way to force conda to install the cuda version of package by setting the
`CONDA_OVERRIDE_CUDA` environment variable to the desired version of cuda that would be
available on a machine with a GPU:

```
devtool env --python=3.10 -P bob ./bob.bio.face
export CONDA_OVERRIDE_CUDA="11.6"
mamba env create -f environment.yaml -n bob_face_devel
```

# Releasing a bob package

Once a package is passing the CI pipelines on the master branch the package is released
as a beta both on the conda channel and its GitLab package registry.

Before releasing the package, a few details must be taken care of:

- Pin the conda dependencies versions in `conda/meta.yaml`;
- Pin the dependencies versions in `pyproject.toml`;
- Change the version number in `pyproject.toml`;
- Generate/write a changelog;
- Set a tag on the main GitLab branch with the changelog as description;
- Run the CI pipeline for that tag.

Most of these steps are automated in `idiap-devtools` and can be run with the commands:

``` sh
devtool gitlab changelog -o face_changelog.md bob/bob.bio.face
# Check and eventually edit face_changelog.md
devtool gitlab release face_changelog.md
```

Or you can give a list in a file to release multiple packages:

``` sh
echo bob/bob.bio.base > packages.txt
echo bob/bob.bio.face >> packages.txt
echo bob/bob.bio.video >> packages.txt
devtool gitlab changelog -o mult_changelog.md ./packages.txt
devtool gitlab release mult_changelog.md
```

## Versioning

Follow [semantic versioning](https://semver.org/) when releasing bob packages.

The version change type is defined in the changelog file output by
`devtool gitlab changelog`. The default is `patch` and this can be changed for each
package in the changelog:

``` md
# bob/bob.bio.face: patch

  - bob/bob.bio.face!100: Fixed foo

    Description of foo.

  - bob/bob.bio.face!101: Solved bar
```

If the changes are more important, you can change `patch` to `minor` or `major` before
calling `devtool gitlab release` on that changelog package entry.

``` md
# bob/bob.bio.face: minor

  - bob/bob.bio.face!103: Added baz

# bob/bob.bio.video: major

  - bob/bob.bio.video!100: Removed ham

    BREAKING CHANGE: ham removed.

  - bob.bob.bio.video!101: Modified spam

    Description of changes to spam.
```

Once `devtool gitlab release` is called, each package in the changelog file will be
edited to pin the version of its dependencies then tagged on GitLab with the appropriate
version and a CI pipeline will be run that publishes the new package on the main conda
channel and on Pypi. The command will wait for the previous package's pipeline to end
before trying to release the next one.

## Release of bob/bob

To guarantee that all the packages of bob work between each others the `bob/bob` package
can be released, that pins all the `bob/*` packages.

To do so, follow the same procedure but specify `bob/bob` as target package, with the
version update type (patch, minor, major) corresponding to the maximum of the released
packages for that version:

``` sh
devtool gitlab changelog -o bob_changelog.md bob/bob
# Pleas, edit bob_changelog.md to set the release type
devtool gitlab release bob_changelog.md
```

This will release the `bob` package, useful to install all bob packages at once.
