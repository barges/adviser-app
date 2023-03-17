#!/usr/bin/env bash

ARGUMENT="$1"

PubGet() {
  if [ -z $ARGUMENT ]; then
    flutter pub get
    flutter pub run build_runner build --delete-conflicting-outputs
  elif [ $ARGUMENT = 'full' ]; then
    flutter pub get
    dart analyze
  elif [ $ARGUMENT = '-u' ]; then
    flutter pub upgrade
  elif [ $ARGUMENT = '-c' ]; then
    flutter clean
  else
    flutter pub get
    flutter pub run build_runner build --delete-conflicting-outputs
  fi
}

  echo "Start pub get script"
  echo "To analyze pubs please run 'pubs full'"
  echo "To upgrade pubs run 'pubs -u'"
  echo "To clean modules run 'pubs -c'"
  PubGet
  cd brands/fortunica || exit
  PubGet
  cd ..
  cd zodiac || exit
  PubGet
  cd ../..

