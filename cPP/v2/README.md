Protection Profile for Application Software
===========
![Build](https://github.com/commoncriteria/application/workflows/Build/badge.svg)
![Validate](https://github.com/commoncriteria/application/workflows/Validate/badge.svg)
[![SanityChecks](https://raw.githubusercontent.com/commoncriteria/application/gh-pages/warnings.svg)](https://github.com/commoncriteria/application/blob/gh-pages/SanityChecksOutput.md)
[![SpellCheck](https://raw.githubusercontent.com/commoncriteria/application/gh-pages/spell-badge.svg)](https://github.com/commoncriteria/application/blob/gh-pages/SpellCheckReport.txt)
[![QuickBuild](https://github.com/commoncriteria/application/actions/workflows/quick_build.yml/badge.svg)](https://commoncriteria.github.io/application)
[![GitHub issues Open](https://img.shields.io/github/issues/commoncriteria/application.svg?maxAge=2592000)](https://github.com/commoncriteria/application/issues) 

This repository hosts the draft version of the Protection Profile for Application Software based on the 
[Essential Security Requirements (ESR)](https://commoncriteria.github.io/pp/application/application-esr.html) for this technology class of 
products. This repository is used to facilitate collaboration and development on the draft document. 
See the [release](#Release-Version) section if you are looking for the officially released version for evaluations. A list of products that have passed evaluation against this Protection Profile can be found [here](https://www.niap-ccevs.org/Product/PCL.cfm?ID624=74).

## Draft Version

* [Protection Profile for Application Software](https://commoncriteria.github.io/pp/application/application-release.html) (html)
* [Protection Profile for Application Software](https://commoncriteria.github.io/pp/application/application-release.pdf) (pdf)

## Release Version
* [Protection Profile for Application Software v1.3](https://www.niap-ccevs.org/Profile/Info.cfm?PPID=429&id=429)
* [Protection Profile for Application Software v1.4](https://www.niap-ccevs.org/Profile/Info.cfm?PPID=429&id=462)

## Contributing

If you are interested in contributing directly to future versions the this Protection Profile, please consider joining the NIAP technical community.
* [How to join the NIAP Technical Community (Mailing list and updates)](https://www.niap-ccevs.org/NIAP_Evolution/tech_communities.cfm)

## Feedback

Questions, comments, and fixes can be submitted to the [repository issue tracker](https://github.com/commoncriteria/application/issues)

## Quickstart
To clone this project along with its _transforms_ submodule run:

````
  git clone --recursive git@github.com:commoncriteria/application.git
````
To pull updates from the upstream _transforms_ submodule and commit them run:
````
 git submodule update --remote transforms
 git add transforms
 git commit
````

### Development Info
* [Help working with Transforms Submodule](https://github.com/commoncriteria/transforms/wiki/Working-with-Transforms-as-a-Submodule)

## Repository Content
* input - Contains the 'meat' of the project. It's the input content (in XML form) that gets transformed to readable html.
* output - The output directory where the html is placed after transformation.
* output/images - The directory where images are stored
* transforms - Points to the transform subproject which is really a repository for resources shared amongst many Common Criteria projects.

## Links 
* [National Information Assurance Partnership (NIAP)](https://www.niap-ccevs.org/)
* [Common Criteria Portal](https://www.commoncriteriaportal.org/)

## License

See [License](./LICENSE)
