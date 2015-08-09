name              "larvel"
maintainer        "Izzia Raffaele"
maintainer_email  "izziaraffaele@gmail.com"
license           "MIT"
description       "Set of recipes to help setup and deploy Laravel applications."
version           "1.0.0"

depends "composer"
depends "npm"

recipe "composer::install", "Installs composer packages."
recipe "composer::update", "Update composer packages."
recipe "npm::install", "Install npm packages."
