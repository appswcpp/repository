# collaborative Protection Profile for Application Software

[![Build](https://github.com/appswcpp/repository/actions/workflows/quick_build.yml/badge.svg)](https://github.com/appswcpp/repository/actions/workflows/quick_build.yml)
[![GitHub issues](https://img.shields.io/github/issues/appswcpp/repository.svg?maxAge=2592000)](https://github.com/appswcpp/repository/issues)

This repository hosts the collaborative Protection Profile (cPP) for Application Software, maintained by the Application Software international Technical Community (AppSW-iTC).

The v2 base cPP and its Supporting Document are both generated from `input/application.xml`. Evaluation Activities embedded in that XML are projected into `output/application-sd.html`; `Archive/cPP/SD_APP_SW.adoc` is the historical v1.0e SD and is not a v2 production source.

## Draft Version

- [collaborative Protection Profile for Application Software](https://appswcpp.github.io/repository/Version-2/application-release.html) (HTML)

## Archived Versions

The previous version (v1.0e) of the cPP, Supporting Document, and PP-Modules (Agent and Server) are available in the [Archive](Archive/) directory.

## PP-Modules

The following PP-Modules extend the base cPP:

- **Agent** — PP-Module for Application Software Agent (`Modules/Agent/`)
  - [PP-Module for Agent](https://appswcpp.github.io/repository/Version-2/Modules/Agent/Agent-release.html) (HTML)
  - [SD for Agent](https://appswcpp.github.io/repository/Version-2/Modules/Agent/Agent-sd.html) (HTML)
- **Server** — PP-Module for Application Software Server (`Modules/Server/`)
  - [PP-Module for Server](https://appswcpp.github.io/repository/Version-2/Modules/Server/Server-release.html) (HTML)
  - [SD for Server](https://appswcpp.github.io/repository/Version-2/Modules/Server/Server-sd.html) (HTML)

## Quickstart

Clone with the transforms submodule:

```
git clone --recursive git@github.com:appswcpp/repository.git
```

Update the transforms submodule:

```
git submodule update --remote transforms
git add transforms
git commit
```

## Repository Content

| Directory | Description |
|-----------|-------------|
| `input/` | Authoritative v2 XML source for both the base cPP and generated base SD |
| `output/` | Generated HTML output |
| `transforms/` | Shared Common Criteria build transforms (submodule) |
| `Modules/` | PP-Module directories (Agent, Server) |
| `Archive/` | Previous version (v1.0e) of the cPP, SD, and PP-Modules |
| `.templates/` | Document authoring templates |

## Links

- [AppSW-iTC Website](https://appswcpp.github.io/)
- [National Information Assurance Partnership (NIAP)](https://www.niap-ccevs.org/)
- [Common Criteria Portal](https://www.commoncriteriaportal.org/)

## License

See [LICENSE](LICENSE)
