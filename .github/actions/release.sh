#!/usr/bin/env bash

set -e

if [[ "${GITHUB_REF}" == refs/heads/master || "${GITHUB_REF}" == refs/tags/* ]]; then
    printf '%s' "${DOCKER_PASSWORD}" | docker login --username "${DOCKER_USERNAME}" --password-stdin

    if [[ "${GITHUB_REF}" == refs/tags/* ]]; then
      export IMAGE_REVISION="${GITHUB_REF##*/}"
    fi

    IFS=',' read -ra tags <<< "${TAGS}"

    for tag in "${tags[@]}"; do
        if [[ -n "${IMAGE_REVISION:-}" ]]; then
            revision_tag="${tag}-${IMAGE_REVISION}"
            if [[ "${tag}" == latest ]]; then
                revision_tag="${IMAGE_REVISION}"
            fi
            # Publish the image built by this job under its revision reference.
            docker tag "wodby/docker:${tag}" "wodby/docker:${revision_tag}"
            make push TAG="${revision_tag}"
        else
            make push TAG="${tag}"
        fi
    done
fi
