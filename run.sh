#!/bin/bash

if [ -z "${NPM_LATEST}" ]; then
  NPM_LATEST=true
fi

if [ -z "${NPM_EMAIL}" ]; then
  error 'Please specify email'
  exit 1
fi

if [ -z "${NPM_AUTH_TOKEN}" ]; then
  error 'Please specify auth token'
  exit 1
fi

if [ ! -f ./package.json ]; then
  error 'Project must contain a package.json'
  exit 1
fi

echo _auth = ${NPM_AUTH_TOKEN} > ~/.npmrc
echo email = ${NPM_EMAIL} >> ~/.npmrc

NPM_VERSION=`cat package.json | grep 'version' | awk '{print substr($2, 2, length($2)-3)}'`
NPM_VERSION_PRERELEASE=$(echo ${NPM_VERSION} | cut -d '-' -f 2 -s)

echo "NPM_LATEST=${NPM_LATEST}"
echo "NPM_VERSION=${NPM_VERSION}"
echo "NPM_VERSION_PRERELEASE=${NPM_VERSION_PRERELEASE}"

if [[ -n "${NPM_VERSION_PRERELEASE}" ]] || [[ "${NPM_LATEST}" != "true" ]]; then
  echo npm publish --tag ${NPM_VERSION}
  npm publish --tag ${NPM_VERSION}
else
  echo npm publish
  npm publish
fi