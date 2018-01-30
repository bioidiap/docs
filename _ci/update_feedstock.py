#!/usr/bin/env python

import hashlib
try:
  from urllib2 import urlopen
except ImportError:
  from urllib.request import urlopen
import requests
import json
try:
  from packaging.version import parse
except ImportError:
  from pip._vendor.packaging.version import parse
import re
import tempfile
import shutil
import os
import subprocess

URL_PATTERN = 'https://pypi.python.org/pypi/{package}/json'


def run_commands(*calls):
  """runs the given commands."""
  # get all calls
  for call in calls:
    print(' - ' + ' '.join(call))
    # execute call
    if subprocess.call(call):
      # call failed (has non-zero exit status)
      raise ValueError("Command '%s' failed; stopping" % ' '.join(call))


def get_version(package, url_pattern=URL_PATTERN):
  """Return version of package on pypi.python.org using json."""
  req = requests.get(url_pattern.format(package=package))
  version = parse('0')
  if req.status_code == requests.codes.ok:
    j = json.loads(req.text)
    if 'releases' in j:
      releases = j['releases']
      for release in releases:
        ver = parse(release)
        if not ver.is_prerelease:
          version = max(version, ver)
  return str(version)


def get_remote_md5_sum(url, max_file_size=100 * 1024 * 1024):
  remote = urlopen(url)
  hash = hashlib.md5()

  total_read = 0
  while True:
    data = remote.read(4096)
    total_read += 4096

    if not data or total_read > max_file_size:
      break
    hash.update(data)

  return hash.hexdigest()


class Gitlab(object):
  """A class that wraps Gitlab API using curl"""

  def __init__(self, token):
    super(Gitlab, self).__init__()
    self.token = token
    self.base_url = 'https://gitlab.idiap.ch/api/v3/'
    self.projects_url = self.base_url + 'projects/'

  def get_project(self, project_name, namespace='bob'):
    cmd = ["curl", "--header",
           "PRIVATE-TOKEN: {}".format(self.token),
           self.base_url + "projects/{}%2F{}".format(
               namespace, project_name)]
    pipeline = subprocess.check_output(cmd)
    return json.loads(pipeline.decode())

  def create_pipeline(self, project_id):
    cmd = ["curl", "--request", "POST", "--header",
           "PRIVATE-TOKEN: {}".format(self.token),
           self.base_url + "projects/{}/pipeline?ref=master".format(
               project_id)]
    pipeline = subprocess.check_output(cmd)
    return json.loads(pipeline.decode())

  def get_pipeline(self, project_id, pipeline_id):
    cmd = ["curl", "--header",
           "PRIVATE-TOKEN: {}".format(self.token),
           self.base_url + "projects/{}/pipelines/{}".format(
               project_id, pipeline_id)]
    pipeline = subprocess.check_output(cmd)
    return json.loads(pipeline.decode())

  def create_merge_request(self, project_id, source_branch, target_branch,
                           title, assignee_id='', description='',
                           target_project_id='', labels='', milestone_id='',
                           remove_source_branch=''):
    url = "projects/{}/merge_requests?"
    url += "&".join(['source_branch={}', 'target_branch={}', 'title={}',
                     'assignee_id={}', 'description={}',
                     'target_project_id={}', 'labels={}',
                     'milestone_id={}', 'remove_source_branch={}'])
    url = url.format(project_id, source_branch, target_branch, title,
                     assignee_id, description, target_project_id, labels,
                     milestone_id, remove_source_branch)
    cmd = ["curl", "--request", "POST", "--header",
           "PRIVATE-TOKEN: {}".format(self.token),
           self.base_url + url]
    pipeline = subprocess.check_output(cmd)
    return json.loads(pipeline.decode())

  def accept_merge_request(self, project_id, mergerequest_id,
                           merge_commit_message='',
                           should_remove_source_branch='',
                           merge_when_pipeline_succeeds='', sha=''):
    """
    Update an existing merge request.
    """

    url = "projects/{}/merge_request/{}/merge?"
    url += "&".join([
        'merge_commit_message={}',
        'should_remove_source_branch={}',
        'merge_when_pipeline_succeeds={}',
        'sha={}',
    ])
    url = url.format(project_id, mergerequest_id, merge_commit_message,
                     should_remove_source_branch,
                     merge_when_pipeline_succeeds,
                     sha)
    cmd = ["curl", "--request", "PUT", "--header",
           "PRIVATE-TOKEN: {}".format(self.token),
           self.base_url + url]
    pipeline = subprocess.check_output(cmd)
    try:
      return json.loads(pipeline.decode())
    except Exception:
      return False


def update_meta(meta_path, package):
  stable_version = get_version(package)
  print('latest stable version for {} is {}'.format(package, stable_version))
  url = 'https://pypi.io/packages/source/{0}/{1}/{1}-{2}.zip'.format(
      package[0], package, stable_version)
  md5 = get_remote_md5_sum(url)
  with open(meta_path) as f:
    doc = f.read()
  build_number = '0'
  doc = re.sub(r'\{\s?%\s?set\s?version\s?=\s?".*"\s?%\s?\}',
               '{% set version = "' + str(stable_version) + '" %}',
               doc, count=1)
  doc = re.sub(r'\s+number\:\s?[0-9]+', '\n  number: ' + build_number, doc,
               count=1)
  doc = re.sub(r'\{\s?%\s?set\s?build_number\s?=\s?"[0-9]+"\s?%\s?\}',
               '{% set build_number = "' + build_number + '" %}',
               doc, count=1)
  doc = re.sub(r'\s+md5\:.*', '\n  md5: {}'.format(md5), doc, count=1)
  doc = re.sub(r'\s+url\:.*',
               '\n  url: {}'.format(
                   url.replace(stable_version, '{{ version }}')),
               doc, count=1)
  doc = re.sub(r'\s+home\:.*',
               '\n  home: https://www.idiap.ch/software/bob/',
               doc, count=1)
  doc = doc.replace('Modified BSD License (3-clause)', 'BSD 3-Clause')

  if package == 'bob':
    requrl = 'https://gitlab.idiap.ch/bob/bob/blob/v{}/requirements.txt'
    requrl = requrl.format(stable_version)
    remote = requests.get(requrl)
    req = remote.content.decode()
    req = '\n    - '.join(req.replace('== ', '==').strip().split('\n'))
    be_id = doc.find('bob.extension')
    te_id = doc.find('test:\n', be_id)
    template = '''{req}

  run:
    - python
    - numpy x.x
    - {req}

'''.format(req=req)
    doc = doc[:be_id] + template + doc[te_id:]

  with open(meta_path, 'w') as f:
    f.write(doc)

  return stable_version


def main(package, subfolder='recipes', direct_push=False):
  temp_dir = tempfile.mkdtemp()
  try:
    print("\nClonning bob.conda")
    root = os.path.join(temp_dir, 'bob.conda')
    feedstock = os.path.join(root, subfolder, package)
    try:
      run_commands(
          ['git', 'clone',
           'git@gitlab.idiap.ch:bob/bob.conda.git',
           root])
    except ValueError:
      print("\nFailed to clone `bob.conda`, Exiting ...")
      raise
    os.chdir(feedstock)
    # update meta.yaml
    meta_path = 'meta.yaml'
    stable_version = update_meta(meta_path, package)

    branch_name = '{}-{}'.format(package, stable_version)
    if not direct_push:
      run_commands(
          ['git', 'checkout', '-b', branch_name])

    run_commands(['git', '--no-pager', 'diff'],
                 ['git', 'config', 'user.email',
                  os.environ.get('GITLAB_USER_EMAIL')],
                 ['git', 'config', 'user.name',
                  os.environ.get('GITLAB_USER_ID')],
                 ['git', 'add', '-A'])
    try:
      run_commands(['git', 'commit', '-am',
                    '[{}] Update to version {}'.format(package,
                                                       stable_version)])
    except ValueError:
      print('Feedstock is already uptodate, skipping.')
      return
    if direct_push:
      print(feedstock)
      try:
        answer = raw_input(
            'Would you like to push directly to master?').lower()
      except Exception:
        answer = input('Would you like to push directly to master?').lower()
      if answer.startswith('y') or answer == '':
        run_commands(['git', 'push'])
        print('See the changes at:\n'
              'https://github.com/conda-forge/'
              '{}-feedstock/commits/master\n\n'.format(package))
    else:
      origin_url = 'https://idiapbbb:{}@gitlab.idiap.ch/bob/bob.conda.git'
      origin_url = origin_url.format(os.environ.get('IDIAPBBB_PASS'))
      subprocess.call(['git', 'remote', 'set-url', 'origin', origin_url])
      run_commands(['git', 'push', '--quiet', '--force', '--set-upstream',
                    'origin', branch_name])
      gitlab = Gitlab(os.environ.get('GITLAB_API_TOKEN'))
      project_id = gitlab.get_project('bob.conda')['id']
      title = 'Update-to-{}'.format(branch_name)
      mr = gitlab.create_merge_request(project_id, branch_name, 'master',
                                       title, remove_source_branch='true')
    #   gitlab.accept_merge_request(
        #   project_id, mr['id'], merge_when_pipeline_succeeds='true')
  finally:
    shutil.rmtree(temp_dir)


if __name__ == '__main__':
  import sys
  main(*sys.argv[1:])
