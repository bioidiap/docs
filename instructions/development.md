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

Any modification of the project will be reflected in the environment (thanks to
`--editable`). If this is not a desirable behavior, you can install the package using:

``` sh
pip install --no-deps ./bob.bio.face
```

In that case to account for any changes in the code, you must execute that command again
for the installed files to reflect the new changes.

# Development guidelines

Commit your changes to a branch (not main or master), and create merge requests (MR) in
GitLab for your changes to be included into a package.

Prefer the use of [Conventional Commit](https://www.conventionalcommits.org/en/v1.0.0/)
to write your commit messages.

Try to make commits atomic.

Use `pre-commit` to ensure the code quality respects our standards. You will need to
install the `pre-commit` package once in your environment, and run `pre-commit install`
on a freshly cloned repository. If you already committed changes before installing,
please run `pre-commit run --all-files` to verify that previous changes are up to
standards.

``` sh
conda activate your_dev_env
mamba install pre-commit
cd your/path/to/bob.bio.face
pre-commit install
pre-commit run --all-files
```

Then the `pre-commit` hooks will be called every time you do a `git commit`, with a nice
summary of what was modified automatically or what needs to be fixed. When everything is
fixed, just run `git commit` again and (if everything is correct), the commit will not
fail.

You can then `git push` your changes to GitLab and create a merge request with a
description of the changes you made.

A CI pipeline will then be run to ensure tests pass and the package can be built.
