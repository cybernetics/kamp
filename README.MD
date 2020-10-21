# KAMP
This project aims to provide an extensive catalog of kotlin multiplatform projects across various maven repositories
out there.

## Motivation
The project is heavily inspired by existing community catalogs such as [Awesome Kotlin](https://github.com/KotlinBy/awesome-kotlin)
& [multiplatform-libraries](https://github.com/icerockdev/multiplatform-libraries). While they all provide the same feature 
as this project (a catalog for kotlin libraries), they all require the library authors to be aware of them and register 
their creations. This project aims to automate that to ensure the community has an extensive self-updating catalog of 
all the marvelous kotlin creations out there!

## Structure
The project consists of two modules - a background processor providing the data feed and a webapp for exposing it as a catalog.

### Scanner
An internet crawler that's meant to scan and identify kotlin libraries across the web. 
It is only able to find the libraries published with gradle-metadata, so older Kotlin libraries might be missing.
Currently, supported maven repositories are:
* Maven Central
* JCenter (limited support due to lackluster bintray API limitations, no guarantees for your package to show up)

## App
The driving server and client to expose the data collected by the scanner as a nice web-based catalog.
It's still WIP. Star the repo for updates as to when it'll be published.

  