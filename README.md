# custom-card-devcontainer

A devcontainer for developing and testing Home Assistant custom cards.

## Features

- Latest Home Assistant installed from PyPI
- [HACS](https://hacs.xyz) installed automatically (skipped if already up to date)
- Node.js LTS via nvm for building and bundling cards
- Fast Python dependency installation via [uv](https://github.com/astral-sh/uv)
- go2rtc for full Home Assistant media support
- Compatible with GitHub Codespaces and VS Code Dev Containers

## Usage

### Developing Custom Cards Locally in this Repo

To get started quickly with your own custom cards in this repository:

1. Place your custom card files (like `.js` files) inside the `workspace/` directory.
2. We've included a sample `workspace/my-custom-card.js`.
3. The `.devcontainer/devcontainer.json` and `docker-compose.yml` are already configured to map the `workspace/` folder into the container and register `my-custom-card.js` via the `LOVELACE_LOCAL_FILES` environment variable.
4. If you add more files, just update `LOVELACE_LOCAL_FILES` in `.devcontainer/devcontainer.json` or `docker-compose.yml`.

### GitHub Codespaces / VS Code Dev Containers

This repository includes a `.devcontainer/devcontainer.json` you can use directly or adapt for your own project.

The image is published to the [GitHub Container Registry](https://ghcr.io/custom-cards/custom-card-devcontainer) on every tagged release. Images are tagged with the full version (`1.2.3`), minor version (`1.2`), and `latest`.

For reproducible environments, pin to a specific version tag:

```bash
docker pull ghcr.io/custom-cards/custom-card-devcontainer:1.2.3
```

### Beta / pre-release images

Pre-release tags (e.g. `v1.2.3-beta.1`) are published with the exact version and a floating `beta` tag. The `latest` tag is **not** updated for pre-releases.

To test a beta image, use the `beta` tag or pin to the exact pre-release version:

```bash
docker pull ghcr.io/custom-cards/custom-card-devcontainer:beta
docker pull ghcr.io/custom-cards/custom-card-devcontainer:1.2.3-beta.1
```

For your own custom card project, add a `.devcontainer/devcontainer.json`:

```json
{
  "image": "ghcr.io/custom-cards/custom-card-devcontainer:1.2.3",
  "forwardPorts": [8123],
  "postCreateCommand": "container setup",
  "remoteUser": "vscode",
  "mounts": [
    "source=${localWorkspaceFolder},target=/config/www/workspace,type=bind,consistency=cached"
  ],
  "runArgs": ["--env-file", "${localWorkspaceFolder}/.env"]
}
```

### Docker

```bash
docker run --rm -it \
    -p 8123:8123 \
    -v $(pwd):/config/www/workspace \
    -e LOVELACE_LOCAL_FILES="my-card.js" \
    ghcr.io/custom-cards/custom-card-devcontainer
```

### Docker Compose

```bash
mkdir -p config
docker compose up --build
```

## Environment Variables

| Name | Description | Default |
|------|-------------|---------|
| `HASS_USERNAME` | Username of the default Home Assistant user | `dev` |
| `HASS_PASSWORD` | Password of the default Home Assistant user | `dev` |
| `LOVELACE_LOCAL_FILES` | Space-separated list of filenames in `/config/www/workspace` to register as Lovelace resources | Empty |
| `LOVELACE_REMOTE_FILES` | Space-separated list of full URLs for remotely served Lovelace resources (e.g. a local dev server) | Empty |

### LOVELACE_LOCAL_FILES

Use this for the card file(s) you are actively developing. The files must be present in your workspace, which is mounted at `/config/www/workspace`.

```
LOVELACE_LOCAL_FILES="my-card.js other-card.js"
```

### LOVELACE_REMOTE_FILES

Use this for resources served by a separate process (e.g. a Webpack or Rollup dev server). Provide full URLs including host and port.

```
LOVELACE_REMOTE_FILES="http://localhost:5000/my-card.js http://localhost:5001/other-card.js"
```

## Container Script

| Command | Description |
|---------|-------------|
| `container` | Set up Home Assistant and launch it |
| `container setup` | Perform setup (config, user, HACS, Lovelace resources) without launching |
| `container launch` | Launch Home Assistant with `hass -c /config -v` |

## hassfest

If you are also developing a custom integration, you can validate it with:

```bash
hassfest
```

This will clone the Home Assistant source on first run (into `/usr/src/homeassistant`) and run `hassfest` validation against any integrations found in `/config/custom_components`.
